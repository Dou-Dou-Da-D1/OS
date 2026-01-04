#include <defs.h>
#include <string.h>
#include <stdlib.h>
#include <list.h>
#include <stat.h>
#include <kmalloc.h>
#include <vfs.h>
#include <dev.h>
#include <sfs.h>
#include <inode.h>
#include <iobuf.h>
#include <bitmap.h>
#include <error.h>
#include <assert.h>

static const struct inode_ops sfs_node_dirops;  // dir operations
static const struct inode_ops sfs_node_fileops; // file operations

/*
 * lock_sin - lock the process of inode Rd/Wr
 */
static void
lock_sin(struct sfs_inode *sin) {
    down(&(sin->sem));
}

/*
 * unlock_sin - unlock the process of inode Rd/Wr
 */
static void
unlock_sin(struct sfs_inode *sin) {
    up(&(sin->sem));
}

/*
 * sfs_get_ops - return function addr of fs_node_dirops/sfs_node_fileops
 */
static const struct inode_ops *
sfs_get_ops(uint16_t type) {
    switch (type) {
    case SFS_TYPE_DIR:
        return &sfs_node_dirops;
    case SFS_TYPE_FILE:
        return &sfs_node_fileops;
    }
    panic("invalid file type %d.\n", type);
}

/*
 * sfs_hash_list - return inode entry in sfs->hash_list
 */
static list_entry_t *
sfs_hash_list(struct sfs_fs *sfs, uint32_t ino) {
    return sfs->hash_list + sin_hashfn(ino);
}

/*
 * sfs_set_links - link inode sin in sfs->linked-list AND sfs->hash_link
 */
static void
sfs_set_links(struct sfs_fs *sfs, struct sfs_inode *sin) {
    list_add(&(sfs->inode_list), &(sin->inode_link));
    list_add(sfs_hash_list(sfs, sin->ino), &(sin->hash_link));
}

/*
 * sfs_remove_links - unlink inode sin in sfs->linked-list AND sfs->hash_link
 */
static void
sfs_remove_links(struct sfs_inode *sin) {
    list_del(&(sin->inode_link));
    list_del(&(sin->hash_link));
}

/*
 * sfs_block_inuse - check the inode with NO. ino inuse info in bitmap
 */
static bool
sfs_block_inuse(struct sfs_fs *sfs, uint32_t ino) {
    if (ino != 0 && ino < sfs->super.blocks) {
        return !bitmap_test(sfs->freemap, ino);
    }
    panic("sfs_block_inuse: called out of range (0, %u) %u.\n", sfs->super.blocks, ino);
}

/*
 * sfs_block_alloc -  check and get a free disk block
 */
static int
sfs_block_alloc(struct sfs_fs *sfs, uint32_t *ino_store) {
    int ret;
    if ((ret = bitmap_alloc(sfs->freemap, ino_store)) != 0) {
        return ret;
    }
    assert(sfs->super.unused_blocks > 0);
    sfs->super.unused_blocks --, sfs->super_dirty = 1;
    assert(sfs_block_inuse(sfs, *ino_store));
    return sfs_clear_block(sfs, *ino_store, 1);
}

/*
 * sfs_block_free - set related bits for ino block to 1(means free) in bitmap, add sfs->super.unused_blocks, set superblock dirty *
 */
static void
sfs_block_free(struct sfs_fs *sfs, uint32_t ino) {
    assert(sfs_block_inuse(sfs, ino));
    bitmap_free(sfs->freemap, ino);
    sfs->super.unused_blocks ++, sfs->super_dirty = 1;
}

/*
 * sfs_create_inode - alloc a inode in memroy, and init din/ino/dirty/reclian_count/sem fields in sfs_inode in inode
 */
static int
sfs_create_inode(struct sfs_fs *sfs, struct sfs_disk_inode *din, uint32_t ino, struct inode **node_store) {
    struct inode *node;
    if ((node = alloc_inode(sfs_inode)) != NULL) {
        vop_init(node, sfs_get_ops(din->type), info2fs(sfs, sfs));
        struct sfs_inode *sin = vop_info(node, sfs_inode);
        sin->din = din, sin->ino = ino, sin->dirty = 0, sin->reclaim_count = 1;
        sem_init(&(sin->sem), 1);
        *node_store = node;
        return 0;
    }
    return -E_NO_MEM;
}

/*
 * lookup_sfs_nolock - according ino, find related inode
 *
 * NOTICE: le2sin, info2node MACRO
 */
static struct inode *
lookup_sfs_nolock(struct sfs_fs *sfs, uint32_t ino) {
    struct inode *node;
    list_entry_t *list = sfs_hash_list(sfs, ino), *le = list;
    while ((le = list_next(le)) != list) {
        struct sfs_inode *sin = le2sin(le, hash_link);
        if (sin->ino == ino) {
            node = info2node(sin, sfs_inode);
            if (vop_ref_inc(node) == 1) {
                sin->reclaim_count ++;
            }
            return node;
        }
    }
    return NULL;
}

/*
 * sfs_load_inode - If the inode isn't existed, load inode related ino disk block data into a new created inode.
 *                  If the inode is in memory alreadily, then do nothing
 */
int
sfs_load_inode(struct sfs_fs *sfs, struct inode **node_store, uint32_t ino) {
    lock_sfs_fs(sfs);
    struct inode *node;
    if ((node = lookup_sfs_nolock(sfs, ino)) != NULL) {
        goto out_unlock;
    }

    int ret = -E_NO_MEM;
    struct sfs_disk_inode *din;
    if ((din = kmalloc(sizeof(struct sfs_disk_inode))) == NULL) {
        goto failed_unlock;
    }

    assert(sfs_block_inuse(sfs, ino));
    if ((ret = sfs_rbuf(sfs, din, sizeof(struct sfs_disk_inode), ino, 0)) != 0) {
        goto failed_cleanup_din;
    }

    assert(din->nlinks != 0);
    if ((ret = sfs_create_inode(sfs, din, ino, &node)) != 0) {
        goto failed_cleanup_din;
    }
    sfs_set_links(sfs, vop_info(node, sfs_inode));

out_unlock:
    unlock_sfs_fs(sfs);
    *node_store = node;
    return 0;

failed_cleanup_din:
    kfree(din);
failed_unlock:
    unlock_sfs_fs(sfs);
    return ret;
}

/*
 * sfs_bmap_get_sub_nolock - according entry pointer entp and index, find the index of indrect disk block
 *                           return the index of indrect disk block to ino_store. no lock protect
 * @sfs:      sfs file system
 * @entp:     the pointer of index of entry disk block
 * @index:    the index of block in indrect block
 * @create:   BOOL, if the block isn't allocated, if create = 1 the alloc a block,  otherwise just do nothing
 * @ino_store: 0 OR the index of already inused block or new allocated block.
 */
static int
sfs_bmap_get_sub_nolock(struct sfs_fs *sfs, uint32_t *entp, uint32_t index, bool create, uint32_t *ino_store) {
    assert(index < SFS_BLK_NENTRY);
    int ret;
    uint32_t ent, ino = 0;
    off_t offset = index * sizeof(uint32_t);  // the offset of entry in entry block
	// if entry block is existd, read the content of entry block into  sfs->sfs_buffer
    if ((ent = *entp) != 0) {
        if ((ret = sfs_rbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
            return ret;
        }
        if (ino != 0 || !create) {
            goto out;
        }
    }
    else {
        if (!create) {
            goto out;
        }
		//if entry block isn't existd, allocated a entry block (for indrect block)
        if ((ret = sfs_block_alloc(sfs, &ent)) != 0) {
            return ret;
        }
    }
    
    if ((ret = sfs_block_alloc(sfs, &ino)) != 0) {
        goto failed_cleanup;
    }
    if ((ret = sfs_wbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
        sfs_block_free(sfs, ino);
        goto failed_cleanup;
    }

out:
    if (ent != *entp) {
        *entp = ent;
    }
    *ino_store = ino;
    return 0;

failed_cleanup:
    if (ent != *entp) {
        sfs_block_free(sfs, ent);
    }
    return ret;
}

/*
 * sfs_bmap_get_nolock - according sfs_inode and index of block, find the NO. of disk block
 *                       no lock protect
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @index:    the index of block in inode
 * @create:   BOOL, if the block isn't allocated, if create = 1 the alloc a block,  otherwise just do nothing
 * @ino_store: 0 OR the index of already inused block or new allocated block.
 */
static int
sfs_bmap_get_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index, bool create, uint32_t *ino_store) {
    struct sfs_disk_inode *din = sin->din;      // 取得磁盘inode
    int ret;
    uint32_t ent, ino;
	// the index of disk block is in the fist SFS_NDIRECT  处理直接块数组情况
    if (index < SFS_NDIRECT) {
        // 未分配时，创建新块写入direct数组，标记内存inode为dirty
        if ((ino = din->direct[index]) == 0 && create) {
            if ((ret = sfs_block_alloc(sfs, &ino)) != 0) { 
                return ret;
            }
            din->direct[index] = ino;
            sin->dirty = 1;
        }
        goto out;
    }
    // the index of disk block is in the indirect blocks.  处理间接索引情况
    index -= SFS_NDIRECT;
    // 处理一级间接块
    if (index < SFS_BLK_NENTRY) {
        ent = din->indirect;
        // 确保间接块存在、在需要时为间接表或数据块分配新块，并返回对应数据块号 ino
        if ((ret = sfs_bmap_get_sub_nolock(sfs, &ent, index, create, &ino)) != 0) {
            return ret;
        }
        // 间接块号被创建/改变，更新磁盘 inode 的 indirect 字段并标脏。
        if (ent != din->indirect) {
            assert(din->indirect == 0);
            din->indirect = ent;
            sin->dirty = 1;
        }
        goto out;
    } else {
		panic ("sfs_bmap_get_nolock - index out of range");     // 索引超出范围
	}
out:
    assert(ino == 0 || sfs_block_inuse(sfs, ino));          // 检验ino=0或freemap中已用
    *ino_store = ino;               
    return 0;
}

/*
 * sfs_bmap_free_sub_nolock - set the entry item to 0 (free) in the indirect block
 */
static int
sfs_bmap_free_sub_nolock(struct sfs_fs *sfs, uint32_t ent, uint32_t index) {
    assert(sfs_block_inuse(sfs, ent) && index < SFS_BLK_NENTRY);
    int ret;
    uint32_t ino, zero = 0;
    off_t offset = index * sizeof(uint32_t);
    if ((ret = sfs_rbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
        return ret;
    }
    if (ino != 0) {
        if ((ret = sfs_wbuf(sfs, &zero, sizeof(uint32_t), ent, offset)) != 0) {
            return ret;
        }
        sfs_block_free(sfs, ino);
    }
    return 0;
}

/*
 * sfs_bmap_free_nolock - free a block with logical index in inode and reset the inode's fields
 */
static int
sfs_bmap_free_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index) {
    struct sfs_disk_inode *din = sin->din;
    int ret;
    uint32_t ent, ino;
    // direct 则释放对应数据块并把 direct[i]=0；
    if (index < SFS_NDIRECT) {
        if ((ino = din->direct[index]) != 0) {
			// free the block
            sfs_block_free(sfs, ino);
            din->direct[index] = 0;
            sin->dirty = 1;
        }
        return 0;
    }
    // 若是间接则在间接表中清除对应 entry 并释放数据块；
    index -= SFS_NDIRECT;
    if (index < SFS_BLK_NENTRY) {
        // 间接块的块号
        if ((ent = din->indirect) != 0) {
			// set the entry item to 0 in the indirect block
            if ((ret = sfs_bmap_free_sub_nolock(sfs, ent, index)) != 0) {
                return ret;
            }
        }
        return 0;
    }
    return 0;
}

/*
 * sfs_bmap_load_nolock - according to the DIR's inode and the logical index of block in inode, find the NO. of disk block.
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @index:    the logical index of disk block in inode
 * @ino_store:the NO. of disk block
 */
// 得到该逻辑块对应的物理块号
static int
sfs_bmap_load_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index, uint32_t *ino_store) {
    struct sfs_disk_inode *din = sin->din;      // 取出内存inode指向的磁盘inode
    assert(index <= din->blocks);               // index 不超过当前记录的块数
    int ret;
    uint32_t ino;
    bool create = (index == din->blocks);       // true 表示需要为 inode 增加新块
    if ((ret = sfs_bmap_get_nolock(sfs, sin, index, create, &ino)) != 0) {
        return ret;                             // 委托实际查找/分配工作给 sfs_bmap_get_nolock，返回磁盘块号
    }
    assert(sfs_block_inuse(sfs, ino));          // 检查freemap为已占用状态
    if (create) {
        din->blocks ++;
    }
    if (ino_store != NULL) {
        *ino_store = ino;   // 返回磁盘块号
    }
    return 0;
}

/*
 * sfs_bmap_truncate_nolock - free the disk block at the end of file
 */
// 将多级数据索引表的最后一个 entry 释放掉
static int
sfs_bmap_truncate_nolock(struct sfs_fs *sfs, struct sfs_inode *sin) {
    struct sfs_disk_inode *din = sin->din;
    assert(din->blocks != 0);       // 至少有一个数据块
    int ret;
    if ((ret = sfs_bmap_free_nolock(sfs, sin, din->blocks - 1)) != 0) {
        return ret;
    }
    din->blocks --;         // 将磁盘 inode 的块计数减 1，表示文件逻辑块数减少
    sin->dirty = 1;
    return 0;
}

/*
 * sfs_dirent_read_nolock - read the file entry from disk block which contains this entry
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @slot:     the index of file entry
 * @entry:    file entry
 */
 // 将目录的第 slot 个 entry 读取到指定的内存空间。
static int
sfs_dirent_read_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, int slot, struct sfs_disk_entry *entry) {
    assert(sin->din->type == SFS_TYPE_DIR && (slot >= 0 && slot < sin->din->blocks));
    int ret;
    uint32_t ino;
	// 调用映射函数把目录的第 slot 个逻辑块映射到物理块号 ino。
    if ((ret = sfs_bmap_load_nolock(sfs, sin, slot, &ino)) != 0) {
        return ret;
    }
    // 校验该物理块在 freemap 中确实被标为“已用”
    assert(sfs_block_inuse(sfs, ino));
	// 从物理块 ino 的偏移 0 处读取一个 sfs_disk_entry 到 entry
    if ((ret = sfs_rbuf(sfs, entry, sizeof(struct sfs_disk_entry), ino, 0)) != 0) {
        return ret;
    }
    entry->name[SFS_MAX_FNAME_LEN] = '\0';
    return 0;
}

#define sfs_dirent_link_nolock_check(sfs, sin, slot, lnksin, name)                  \
    do {                                                                            \
        int err;                                                                    \
        if ((err = sfs_dirent_link_nolock(sfs, sin, slot, lnksin, name)) != 0) {    \
            warn("sfs_dirent_link error: %e.\n", err);                              \
        }                                                                           \
    } while (0)

#define sfs_dirent_unlink_nolock_check(sfs, sin, slot, lnksin)                      \
    do {                                                                            \
        int err;                                                                    \
        if ((err = sfs_dirent_unlink_nolock(sfs, sin, slot, lnksin)) != 0) {        \
            warn("sfs_dirent_unlink error: %e.\n", err);                            \
        }                                                                           \
    } while (0)

/*
 * sfs_dirent_search_nolock - read every file entry in the DIR, compare file name with each entry->name
 *                            If equal, then return slot and NO. of disk of this file's inode
 * @sfs:        sfs file system
 * @sin:        sfs inode in memory
 * @name:       the filename
 * @ino_store:  NO. of disk of this file (with the filename)'s inode
 * @slot:       logical index of file entry (NOTICE: each file entry ocupied one  disk block)
 * @empty_slot: the empty logical index of file entry.
 */
// 常用的查找函数
static int
sfs_dirent_search_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, const char *name, uint32_t *ino_store, int *slot, int *empty_slot) {
    assert(strlen(name) <= SFS_MAX_FNAME_LEN);
    struct sfs_disk_entry *entry;               // 分配一个临时缓冲区
    if ((entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        return -E_NO_MEM;
    }

#define set_pvalue(x, v)            do { if ((x) != NULL) { *(x) = (v); } } while (0)   // 仅在指针非 NULL 时写回输出值
    int ret, i, nslots = sin->din->blocks;
    set_pvalue(empty_slot, nslots);
    // 逐槽遍历，
    for (i = 0; i < nslots; i ++) {
        // 调用读取读取第 i 个目录条目
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
            goto out;
        }
        // 把 empty_slot 记录为该 i ，继续搜索查找匹配项
        if (entry->ino == 0) {
            set_pvalue(empty_slot, i);
            continue ;
        }
        // 查找成功，写回 slot 和 ino_store
        if (strcmp(name, entry->name) == 0) {
            set_pvalue(slot, i);
            set_pvalue(ino_store, entry->ino);
            goto out;
        }
    }
#undef set_pvalue
    ret = -E_NOENT;
out:
    kfree(entry);
    return ret;
}

/*
 * sfs_dirent_findino_nolock - read all file entries in DIR's inode and find a entry->ino == ino
 */

static int
sfs_dirent_findino_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t ino, struct sfs_disk_entry *entry) {
    int ret, i, nslots = sin->din->blocks;
    for (i = 0; i < nslots; i ++) {
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
            return ret;
        }
        if (entry->ino == ino) {
            return 0;
        }
    }
    return -E_NOENT;
}

/*
 * sfs_lookup_once - find inode corresponding the file name in DIR's sin inode 
 * @sfs:        sfs file system
 * @sin:        DIR sfs inode in memory
 * @name:       the file name in DIR
 * @node_store: the inode corresponding the file name in DIR
 * @slot:       the logical index of file entry
 */
static int
sfs_lookup_once(struct sfs_fs *sfs, struct sfs_inode *sin, const char *name, struct inode **node_store, int *slot) {
    int ret;
    uint32_t ino;
    lock_sin(sin);      // 对该目录的内存 inode 加锁
    {   // 查找名字 name 对应的磁盘 inode 编号
        ret = sfs_dirent_search_nolock(sfs, sin, name, &ino, slot, NULL);
    }
    unlock_sin(sin);
    if (ret == 0) {
		// 根据磁盘 inode 编号加载对应的内存 inode
        ret = sfs_load_inode(sfs, node_store, ino);
    }
    return ret;
}

// sfs_opendir - just check the opne_flags, now support readonly
static int
sfs_opendir(struct inode *node, uint32_t open_flags) {
    switch (open_flags & O_ACCMODE) {
    case O_RDONLY:
        break;
    case O_WRONLY:
    case O_RDWR:
    default:
        return -E_ISDIR;
    }
    if (open_flags & O_APPEND) {
        return -E_ISDIR;
    }
    return 0;
}

// sfs_openfile - open file (no use)
static int
sfs_openfile(struct inode *node, uint32_t open_flags) {
    return 0;
}

// sfs_close - close file
static int
sfs_close(struct inode *node) {
    return vop_fsync(node);
}

/*  
 * sfs_io_nolock - Rd/Wr a file contentfrom offset position to offset+ length  disk blocks<-->buffer (in memroy)
 * @sfs:      sfs file system
 * @sin:      sfs inode in memory
 * @buf:      the buffer Rd/Wr
 * @offset:   the offset of file
 * @alenp:    the length need to read (is a pointer). and will RETURN the really Rd/Wr lenght
 * @write:    BOOL, 0 read, 1 write
 */
static int
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
    struct sfs_disk_inode *din = sin->din;
    assert(din->type != SFS_TYPE_DIR);      // 确保不是目录
    off_t endpos = offset + *alenp, blkoff; // 计算结束位置
    *alenp = 0;                             // 调用者请求的长度
	// calculate the Rd/Wr end position
    // 偏移合法
    if (offset < 0 || offset >= SFS_MAX_FILE_SIZE || offset > endpos) {
        return -E_INVAL;
    }
    // 请求长度为0
    if (offset == endpos) {
        return 0;
    }
    // 不允许超过最大文件大小
    if (endpos > SFS_MAX_FILE_SIZE) {
        endpos = SFS_MAX_FILE_SIZE;
    }
    if (!write) {
        // 读取位置不可超出文件大小
        if (offset >= din->size) {
            return 0;
        }
        // 限制到当前文件大小
        if (endpos > din->size) {
            endpos = din->size;
        }
    }

    
    int (*sfs_buf_op)(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);
    int (*sfs_block_op)(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks);
    if (write) {
        sfs_buf_op = sfs_wbuf, sfs_block_op = sfs_wblock;
    }
    else {
        sfs_buf_op = sfs_rbuf, sfs_block_op = sfs_rblock;
    }

    // blkno：起始逻辑块号，nblks：需要读写的块数，alen：累计处理的字节数
    int ret = 0;
    size_t size, alen = 0;
    uint32_t ino;
    uint32_t blkno = offset / SFS_BLKSIZE;          // The NO. of Rd/Wr begin block
    uint32_t nblks = endpos / SFS_BLKSIZE - blkno;  // The size of Rd/Wr blocks

  //LAB8:EXERCISE1 2311828 2313540 HINT: call sfs_bmap_load_nolock, sfs_rbuf, sfs_rblock,etc. read different kind of blocks in file
	/*
	 * (1) If offset isn't aligned with the first block, Rd/Wr some content from offset to the end of the first block
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_buf_op
	 *               Rd/Wr size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset)
	 * (2) Rd/Wr aligned blocks 
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_block_op
     * (3) If end position isn't aligned with the last block, Rd/Wr some content from begin to the (endpos % SFS_BLKSIZE) of the last block
	 *       NOTICE: useful function: sfs_bmap_load_nolock, sfs_buf_op	
	*/

    // blkoff：在起始块的字节偏移
    if ((blkoff = offset % SFS_BLKSIZE) != 0) {
        // (1) 如果offset不与第一个块对齐，从offset读/写到第一个块的结尾
        size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
        // 获取逻辑块对应的物理块号
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        // 从物理块ino的blkoff偏移处读/写size字节到buf
        if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
            goto out;
        }
        // 更新变量
        alen += size;
        if (nblks == 0) {
            goto out;
        }
        buf += size;
        blkno++;
        nblks--;
    }

    // (2) 读/写对齐的块
    if (nblks > 0) {
        // 得到第一个整块的物理块号 ino
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        // 从该起始物理块顺序处理 nblks 个块
        if ((ret = sfs_block_op(sfs, buf, ino, nblks)) != 0) {
            goto out;
        }
        alen += nblks * SFS_BLKSIZE;
        buf += nblks * SFS_BLKSIZE;
        blkno += nblks;
        nblks -= nblks;
    }

    // (3) 如果结束位置不与最后一个块对齐，从开始读/写到最后一个块的(endpos % SFS_BLKSIZE)
    if ((size = endpos % SFS_BLKSIZE) != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
            goto out;
        }
        alen += size;
    }

out:
    *alenp = alen;
    if (offset + alen > sin->din->size) {
        sin->din->size = offset + alen;
        sin->dirty = 1;
    }
    return ret;
}

/*
 * sfs_io - Rd/Wr file. the wrapper of sfs_io_nolock
            with lock protect
 */
static inline int
sfs_io(struct inode *node, struct iobuf *iob, bool write) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    int ret;
    lock_sin(sin);
    {
        size_t alen = iob->io_resid;
        ret = sfs_io_nolock(sfs, sin, iob->io_base, iob->io_offset, &alen, write);
        if (alen != 0) {
            iobuf_skip(iob, alen);
        }
    }
    unlock_sin(sin);
    return ret;
}

// sfs_read - read file
// node是对应文件的inode，iob是缓存，write表示是读还是写的布尔值
static int
sfs_read(struct inode *node, struct iobuf *iob) {
    return sfs_io(node, iob, 0);
}

// sfs_write - write file
static int
sfs_write(struct inode *node, struct iobuf *iob) {
    return sfs_io(node, iob, 1);
}

/*
 * sfs_fstat - Return nlinks/block/size, etc. info about a file. The pointer is a pointer to struct stat;
 */
static int
sfs_fstat(struct inode *node, struct stat *stat) {
    int ret;
    memset(stat, 0, sizeof(struct stat));
    if ((ret = vop_gettype(node, &(stat->st_mode))) != 0) {
        return ret;
    }
    struct sfs_disk_inode *din = vop_info(node, sfs_inode)->din;
    stat->st_nlinks = din->nlinks;
    stat->st_blocks = din->blocks;
    stat->st_size = din->size;
    return 0;
}

/*
 * sfs_fsync - Force any dirty inode info associated with this file to stable storage.
 */
static int
sfs_fsync(struct inode *node) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    int ret = 0;
    if (sin->dirty) {
        lock_sin(sin);
        {
            if (sin->dirty) {
                sin->dirty = 0;
                if ((ret = sfs_wbuf(sfs, sin->din, sizeof(struct sfs_disk_inode), sin->ino, 0)) != 0) {
                    sin->dirty = 1;
                }
            }
        }
        unlock_sin(sin);
    }
    return ret;
}

/*
 *sfs_namefile -Compute pathname relative to filesystem root of the file and copy to the specified io buffer.
 *  
 */
static int
sfs_namefile(struct inode *node, struct iobuf *iob) {
    struct sfs_disk_entry *entry;
    if (iob->io_resid <= 2 || (entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        return -E_NO_MEM;
    }

    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int ret;
    char *ptr = iob->io_base + iob->io_resid;
    size_t alen, resid = iob->io_resid - 2;
    vop_ref_inc(node);
    while (1) {
        struct inode *parent;
        if ((ret = sfs_lookup_once(sfs, sin, "..", &parent, NULL)) != 0) {
            goto failed;
        }

        uint32_t ino = sin->ino;
        vop_ref_dec(node);
        if (node == parent) {
            vop_ref_dec(node);
            break;
        }

        node = parent, sin = vop_info(node, sfs_inode);
        assert(ino != sin->ino && sin->din->type == SFS_TYPE_DIR);

        lock_sin(sin);
        {
            ret = sfs_dirent_findino_nolock(sfs, sin, ino, entry);
        }
        unlock_sin(sin);

        if (ret != 0) {
            goto failed;
        }

        if ((alen = strlen(entry->name) + 1) > resid) {
            goto failed_nomem;
        }
        resid -= alen, ptr -= alen;
        memcpy(ptr, entry->name, alen - 1);
        ptr[alen - 1] = '/';
    }
    alen = iob->io_resid - resid - 2;
    ptr = memmove(iob->io_base + 1, ptr, alen);
    ptr[-1] = '/', ptr[alen] = '\0';
    iobuf_skip(iob, alen);
    kfree(entry);
    return 0;

failed_nomem:
    ret = -E_NO_MEM;
failed:
    vop_ref_dec(node);
    kfree(entry);
    return ret;
}

/*
 * sfs_getdirentry_sub_noblock - get the content of file entry in DIR
 */
static int
sfs_getdirentry_sub_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, int slot, struct sfs_disk_entry *entry) {
    int ret, i, nslots = sin->din->blocks;
    for (i = 0; i < nslots; i ++) {
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
            return ret;
        }
        if (entry->ino != 0) {
            if (slot == 0) {
                return 0;
            }
            slot --;
        }
    }
    return -E_NOENT;
}

/*
 * sfs_getdirentry - according to the iob->io_offset, calculate the dir entry's slot in disk block,
                     get dir entry content from the disk 
 */
static int
sfs_getdirentry(struct inode *node, struct iobuf *iob) {
    struct sfs_disk_entry *entry;
    if ((entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        return -E_NO_MEM;
    }

    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int ret, slot;
    off_t offset = iob->io_offset;
    if (offset < 0 || offset % sfs_dentry_size != 0) {
        kfree(entry);
        return -E_INVAL;
    }
    if ((slot = offset / sfs_dentry_size) > sin->din->blocks) {
        kfree(entry);
        return -E_NOENT;
    }
    lock_sin(sin);
    if ((ret = sfs_getdirentry_sub_nolock(sfs, sin, slot, entry)) != 0) {
        unlock_sin(sin);
        goto out;
    }
    unlock_sin(sin);
    ret = iobuf_move(iob, entry->name, sfs_dentry_size, 1, NULL);
out:
    kfree(entry);
    return ret;
}

/*
 * sfs_reclaim - Free all resources inode occupied . Called when inode is no longer in use. 
 */
static int
sfs_reclaim(struct inode *node) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int  ret = -E_BUSY;
    uint32_t ent;
    lock_sfs_fs(sfs);
    assert(sin->reclaim_count > 0);
    if ((-- sin->reclaim_count) != 0 || inode_ref_count(node) != 0) {
        goto failed_unlock;
    }
    if (sin->din->nlinks == 0) {
        if ((ret = vop_truncate(node, 0)) != 0) {
            goto failed_unlock;
        }
    }
    if (sin->dirty) {
        if ((ret = vop_fsync(node)) != 0) {
            goto failed_unlock;
        }
    }
    sfs_remove_links(sin);
    unlock_sfs_fs(sfs);

    if (sin->din->nlinks == 0) {
        sfs_block_free(sfs, sin->ino);
        if ((ent = sin->din->indirect) != 0) {
            sfs_block_free(sfs, ent);
        }
    }
    kfree(sin->din);
    vop_kill(node);
    return 0;

failed_unlock:
    unlock_sfs_fs(sfs);
    return ret;
}

/*
 * sfs_gettype - Return type of file. The values for file types are in sfs.h.
 */
static int
sfs_gettype(struct inode *node, uint32_t *type_store) {
    struct sfs_disk_inode *din = vop_info(node, sfs_inode)->din;
    switch (din->type) {
    case SFS_TYPE_DIR:
        *type_store = S_IFDIR;
        return 0;
    case SFS_TYPE_FILE:
        *type_store = S_IFREG;
        return 0;
    case SFS_TYPE_LINK:
        *type_store = S_IFLNK;
        return 0;
    }
    panic("invalid file type %d.\n", din->type);
}

/* 
 * sfs_tryseek - Check if seeking to the specified position within the file is legal.
 */
static int
sfs_tryseek(struct inode *node, off_t pos) {
    if (pos < 0 || pos >= SFS_MAX_FILE_SIZE) {
        return -E_INVAL;
    }
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    if (pos > sin->din->size) {
        return vop_truncate(node, pos);
    }
    return 0;
}

/*
 * sfs_truncfile : reszie the file with new length
 */
static int
sfs_truncfile(struct inode *node, off_t len) {
    if (len < 0 || len > SFS_MAX_FILE_SIZE) {
        return -E_INVAL;
    }
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    struct sfs_disk_inode *din = sin->din;

    int ret = 0;
	//new number of disk blocks of file
    uint32_t nblks, tblks = ROUNDUP_DIV(len, SFS_BLKSIZE);
    if (din->size == len) {
        assert(tblks == din->blocks);
        return 0;
    }

    lock_sin(sin);
	// old number of disk blocks of file
    nblks = din->blocks;
    if (nblks < tblks) {
		// try to enlarge the file size by add new disk block at the end of file
        while (nblks != tblks) {
            if ((ret = sfs_bmap_load_nolock(sfs, sin, nblks, NULL)) != 0) {
                goto out_unlock;
            }
            nblks ++;
        }
    }
    else if (tblks < nblks) {
		// try to reduce the file size 
        while (tblks != nblks) {
            if ((ret = sfs_bmap_truncate_nolock(sfs, sin)) != 0) {
                goto out_unlock;
            }
            nblks --;
        }
    }
    assert(din->blocks == tblks);
    din->size = len;
    sin->dirty = 1;

out_unlock:
    unlock_sin(sin);
    return ret;
}

/*
 * sfs_lookup - Parse path relative to the passed directory
 *              DIR, and hand back the inode for the file it
 *              refers to.
 */
static int
sfs_lookup(struct inode *node, char *path, struct inode **node_store) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    // path 非空且不是以 / 开头
    assert(*path != '\0' && *path != '/');
    // 把传入的起点目录引用计数加 1，防止inode被回收
    vop_ref_inc(node);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    // 确保起点 inode 是目录类型
    if (sin->din->type != SFS_TYPE_DIR) {
        vop_ref_dec(node);
        return -E_NOTDIR;
    }
    struct inode *subnode;
    // 查找目录项对应的子 inode
    int ret = sfs_lookup_once(sfs, sin, path, &subnode, NULL);

    vop_ref_dec(node);
    if (ret != 0) {
        return ret;
    }
    *node_store = subnode;
    return 0;
}

// The sfs specific DIR operations correspond to the abstract operations on a inode.
static const struct inode_ops sfs_node_dirops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = sfs_opendir,      // 只是完成一些 open 函数传递的参数判断
    .vop_close                      = sfs_close,
    .vop_fstat                      = sfs_fstat,
    .vop_fsync                      = sfs_fsync,
    .vop_namefile                   = sfs_namefile,
    .vop_getdirentry                = sfs_getdirentry,  // 主要工作是获取目录下的文件 inode 信息
    .vop_reclaim                    = sfs_reclaim,
    .vop_gettype                    = sfs_gettype,
    .vop_lookup                     = sfs_lookup,
};
/// The sfs specific FILE operations correspond to the abstract operations on a inode.
static const struct inode_ops sfs_node_fileops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = sfs_openfile,
    .vop_close                      = sfs_close,        // 把对文件的修改内容写回到硬盘
    .vop_read                       = sfs_read,         // 通过访问硬盘驱动来完成对文件内容数据的读写
    .vop_write                      = sfs_write,
    .vop_fstat                      = sfs_fstat,
    .vop_fsync                      = sfs_fsync,
    .vop_reclaim                    = sfs_reclaim,
    .vop_gettype                    = sfs_gettype,
    .vop_tryseek                    = sfs_tryseek,
    .vop_truncate                   = sfs_truncfile,
};

