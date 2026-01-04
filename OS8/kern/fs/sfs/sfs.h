#ifndef __KERN_FS_SFS_SFS_H__
#define __KERN_FS_SFS_SFS_H__

#include <defs.h>
#include <mmu.h>
#include <list.h>
#include <sem.h>
#include <unistd.h>

/*
 * Simple FS (SFS) definitions visible to ucore. This covers the on-disk format
 * and is used by tools that work on SFS volumes, such as mksfs.
 */

#define SFS_MAGIC                                   0x2f8dbe2a              /* magic number for sfs */
#define SFS_BLKSIZE                                 PGSIZE                  /* size of block */
#define SFS_NDIRECT                                 12                      /* # of direct blocks in inode */
#define SFS_MAX_INFO_LEN                            31                      /* max length of infomation */
#define SFS_MAX_FNAME_LEN                           FS_MAX_FNAME_LEN        /* max length of filename */
#define SFS_MAX_FILE_SIZE                           (1024UL * 1024 * 128)   /* max file size (128M) */
#define SFS_BLKN_SUPER                              0                       /* block the superblock lives in */
#define SFS_BLKN_ROOT                               1                       /* location of the root dir inode */
#define SFS_BLKN_FREEMAP                            2                       /* 1st block of the freemap */

/* # of bits in a block */
#define SFS_BLKBITS                                 (SFS_BLKSIZE * CHAR_BIT)

/* # of entries in a block */
#define SFS_BLK_NENTRY                              (SFS_BLKSIZE / sizeof(uint32_t))

/* file types */
#define SFS_TYPE_INVAL                              0       /* Should not appear on disk */
#define SFS_TYPE_FILE                               1
#define SFS_TYPE_DIR                                2
#define SFS_TYPE_LINK                               3

/*
 * On-disk superblock
 */
 // 文件系统控制块 包含了关于文件系统的所有关键参数
struct sfs_super {
    uint32_t magic;                                 // 成员变量魔数，检查磁盘镜像是否是合法的SFS img
    uint32_t blocks;                                // SFS 中所有 block 的数量，即 img 的大小
    uint32_t unused_blocks;                         // SFS 中未使用的 block 数量
    char info[SFS_MAX_INFO_LEN + 1];                // 文本描述信息
};

/* inode (on disk) */
// 磁盘索引节点
struct sfs_disk_inode {
    uint32_t size;                                  // 文件大小
    uint16_t type;                                  // 文件类型
    uint16_t nlinks;                                // 多少个目录项引用此inode
    uint32_t blocks;                                // 该文件占用的数据块数量
    uint32_t direct[SFS_NDIRECT];                   // 此inode的直接数据块索引值
    uint32_t indirect;                              // 此inode的一级间接数据块索引值
//    uint32_t db_indirect;                           /* double indirect blocks */
//   unused
};

/* file entry (on disk) */
// 目录项
struct sfs_disk_entry {
    uint32_t ino;                                   // 索引节点所占数据块索引值
    char name[SFS_MAX_FNAME_LEN + 1];               // 文件名
};

#define sfs_dentry_size                             \
    sizeof(((struct sfs_disk_entry *)0)->name)

/* inode for sfs */
// 内存索引节点
struct sfs_inode {
    struct sfs_disk_inode *din;                     // 硬盘inode指针
    uint32_t ino;                                   // inode编号（磁盘块号）
    bool dirty;                                     // 被修改但未写回磁盘设为true
    int reclaim_count;                              // 回收计数，生命周期控制：0且不被引用则可释放
    semaphore_t sem;                                // 保护din和内存inode的并发访问
    list_entry_t inode_link;                        // 把当前inode插入到sfs_fs的inode链表中
    list_entry_t hash_link;                         // 把当前inode插入到sfs_fs的hash链表中，快速查找
};

#define le2sin(le, member)                          \
    to_struct((le), struct sfs_inode, member)

/* filesystem for sfs */
struct sfs_fs {
    struct sfs_super super;                         /* on-disk superblock */
    struct device *dev;                             /* device mounted on */
    struct bitmap *freemap;                         /* blocks in use are mared 0 */
    bool super_dirty;                               /* true if super/freemap modified */
    void *sfs_buffer;                               /* buffer for non-block aligned io */
    semaphore_t fs_sem;                             /* semaphore for fs */
    semaphore_t io_sem;                             /* semaphore for io */
    semaphore_t mutex_sem;                          /* semaphore for link/unlink and rename */
    list_entry_t inode_list;                        /* inode linked-list */
    list_entry_t *hash_list;                        /* inode hash linked-list */
};

/* hash for sfs */
#define SFS_HLIST_SHIFT                             10
#define SFS_HLIST_SIZE                              (1 << SFS_HLIST_SHIFT)
#define sin_hashfn(x)                               (hash32(x, SFS_HLIST_SHIFT))

/* size of freemap (in bits) */
#define sfs_freemap_bits(super)                     ROUNDUP((super)->blocks, SFS_BLKBITS)

/* size of freemap (in blocks) */
#define sfs_freemap_blocks(super)                   ROUNDUP_DIV((super)->blocks, SFS_BLKBITS)

struct fs;
struct inode;

void sfs_init(void);
int sfs_mount(const char *devname);

void lock_sfs_fs(struct sfs_fs *sfs);
void lock_sfs_io(struct sfs_fs *sfs);
void unlock_sfs_fs(struct sfs_fs *sfs);
void unlock_sfs_io(struct sfs_fs *sfs);

int sfs_rblock(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks);
int sfs_wblock(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks);
int sfs_rbuf(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);
int sfs_wbuf(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);
int sfs_sync_super(struct sfs_fs *sfs);
int sfs_sync_freemap(struct sfs_fs *sfs);
int sfs_clear_block(struct sfs_fs *sfs, uint32_t blkno, uint32_t nblks);

int sfs_load_inode(struct sfs_fs *sfs, struct inode **node_store, uint32_t ino);

#endif /* !__KERN_FS_SFS_SFS_H__ */

