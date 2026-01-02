# <center>Lab8 实验报告</center>

<center>学号: 2311828  姓名: 程娜</center>
<center>学号: 2313540  姓名: 张丝童</center>

## 练习0：填写已有实验

### 实验过程

本实验依赖实验2/3/4/5/6/7的代码。我将之前完成的实验代码填入本实验中相应位置。

#### 主要复制的文件和模块：

1. **调度器模块**
   - `kern/schedule/default_sched.c`：RR调度算法实现
   - `kern/schedule/default_sched_stride.c`：Stride调度算法实现

2. **同步互斥模块**
   - `kern/sync/monitor.c`：管程的实现
   - `kern/sync/check_sync.c`：哲学家就餐问题的实现

3. **内存管理模块**
   - `kern/mm/pmm.c`：物理内存管理
   - `kern/mm/vmm.c`：虚拟内存管理
   - `kern/trap/trap.c`：中断和异常处理

#### 需要注意的改进：

为了适配实验8的文件系统，进行了以下改进：

1. **类型转换修复**：在`kmalloc.c`中修复了`kva2page()`的类型转换问题
2. **系统调用适配**：修复了`waitpid`函数中int和int64_t类型不匹配的问题
3. **新增辅助函数**：
   - 在`vmm.c`中实现`copy_string()`函数，用于用户空间到内核空间的字符串复制
   - 在`swapfs.h`中添加`swap_offset()`函数

### 主要改动代码

1. **进程切换 - proc_run**（[kern/process/proc.c](kern/process/proc.c)）

这是LAB4的关键代码，确保进程能够正确调度和切换：

```c
void proc_run(struct proc_struct *proc) {
    if (proc != current) {
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
        local_intr_save(intr_flag);
        {
            current = proc;
            lsatp(next->pgdir);    // 切换页表
            flush_tlb();           // 刷新TLB缓存
            switch_to(&(prev->context), &(next->context));  // 上下文切换
        }
        local_intr_restore(intr_flag);
    }
}
```

2. **文件读写路径 - sfs_io_nolock**（[kern/fs/sfs/sfs_inode.c](kern/fs/sfs/sfs_inode.c)）

```c
// 三段式处理：首块(非对齐) -> 中间整块 -> 末块(非对齐)
if ((blkoff = offset % SFS_BLKSIZE) != 0) {
    size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
    sfs_bmap_load_nolock(sfs, sin, blkno, &ino);
    sfs_buf_op(sfs, buf, size, ino, blkoff);
    alen += size; buf += size; blkno++; nblks--;
}
if (nblks > 0) {
    sfs_bmap_load_nolock(sfs, sin, blkno, &ino);
    sfs_block_op(sfs, buf, ino, nblks);
    alen += nblks * SFS_BLKSIZE; buf += nblks * SFS_BLKSIZE; blkno += nblks; nblks = 0;
}
if ((size = endpos % SFS_BLKSIZE) != 0) {
    sfs_bmap_load_nolock(sfs, sin, blkno, &ino);
    sfs_buf_op(sfs, buf, size, ino, 0);
    alen += size;
}
```

3. **可执行文件加载 - load_icode**（[kern/process/proc.c](kern/process/proc.c)）

```c
// 从fd读取ELF，遍历LOAD段并按权限映射
load_icode_read(fd, elf, sizeof(*elf), 0);
for (i = 0; i < elf->e_phnum; i++) {
    load_icode_read(fd, ph, sizeof(*ph), elf->e_phoff + i * sizeof(*ph));
    if (ph->p_type != ELF_PT_LOAD || ph->p_filesz == 0) continue;
    vm_flags = ph_flags_to_vm(ph->p_flags); perm = vm_flags_to_pte(vm_flags);
    mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL);
    // 拷贝TEXT/DATA
    for (start = ph->p_va, la = ROUNDDOWN(start, PGSIZE), offset = ph->p_offset;
         start < ph->p_va + ph->p_filesz; ) {
        page = pgdir_alloc_page(mm->pgdir, la, perm);
        size = MIN(PGSIZE - (start - la), ph->p_va + ph->p_filesz - start);
        load_icode_read(fd, page2kva(page) + (start - la), size, offset);
        start += size; offset += size; la += PGSIZE;
    }
    // BSS 清零
    for (; start < ph->p_va + ph->p_memsz; start += size, la += PGSIZE) {
        page = pgdir_alloc_page(mm->pgdir, la, perm);
        size = MIN(PGSIZE, ph->p_va + ph->p_memsz - start);
        memset(page2kva(page), 0, size);
    }
}
// 构建用户栈并布置 argc/argv
stacktop = push_argv_strings(USTACKTOP, argc, kargv, &uargv);
((int *)stacktop)[-1] = argc; tf->gpr.sp = stacktop - sizeof(int);
tf->epc = elf->e_entry; tf->status = (tf->status & ~SSTATUS_SPP) | SSTATUS_SPIE;
```

4. **用户字符串拷贝 - copy_string**（[kern/mm/vmm.c](kern/mm/vmm.c)）

```c
int copy_string(struct mm_struct *mm, char *dst, const char *src, size_t maxn) {
    size_t copied = 0; char ch;
    while (copied < maxn) {
        if (!user_mem_check(mm, (uintptr_t)src + copied, 1, 0)) return -E_INVAL;
        ch = src[copied]; dst[copied++] = ch; if (ch == '\0') return 0;
    }
    dst[maxn - 1] = '\0'; return 0;
}
```

5. **swap 读写偏移辅助**（[kern/fs/swap/swapfs.h](kern/fs/swap/swapfs.h)）

```c
static inline off_t swap_offset(size_t entry) {
    return (off_t)(entry >> 8); // 剥离低8位标志
}
```

6. **waitpid 类型修复**（[user/libs/ulib.c](user/libs/ulib.c)）

```c
int
waitpid(int pid, int *store) {
    uint32_t status = 0; // 与内核的int32接口保持一致
    int ret = sys_wait(pid, &status);
    if (store != NULL) *store = (int)status;
    return ret;
}
```

7. **kva 转 page 的安全转换**（[kern/mm/kmalloc.c](kern/mm/kmalloc.c)）

```c
static void __slob_free_pages(void *kva) {
    struct Page *page = kva2page((uintptr_t)kva); // 显式uintptr_t避免编译告警
    free_pages(page, 1);
}
```
---

## 练习1：完成读文件操作的实现

### 题目要求

填写`kern/fs/sfs/sfs_inode.c`中的`sfs_io_nolock()`函数，实现读文件中数据的代码。

### 设计思路

文件的读写操作需要处理以下三种情况：

1. **不对齐的起始块**：如果offset不在块边界上，需要先处理第一个块中从offset到块尾的部分
2. **对齐的中间块**：处理完整的块
3. **不对齐的结束块**：如果endpos不在块边界上，需要处理最后一个块中从块首到endpos的部分

### 实现代码

```c
static int
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
    struct sfs_disk_inode *din = sin->din;
    assert(din->type != SFS_TYPE_DIR);
    off_t endpos = offset + *alenp, blkoff;
    *alenp = 0;
    
    // 计算读/写结束位置
    if (offset < 0 || offset >= SFS_MAX_FILE_SIZE || offset > endpos) {
        return -E_INVAL;
    }
    if (offset == endpos) {
        return 0;
    }
    if (endpos > SFS_MAX_FILE_SIZE) {
        endpos = SFS_MAX_FILE_SIZE;
    }
    if (!write) {
        if (offset >= din->size) {
            return 0;
        }
        if (endpos > din->size) {
            endpos = din->size;
        }
    }

    // 设置读写函数指针
    int (*sfs_buf_op)(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);
    int (*sfs_block_op)(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks);
    if (write) {
        sfs_buf_op = sfs_wbuf, sfs_block_op = sfs_wblock;
    }
    else {
        sfs_buf_op = sfs_rbuf, sfs_block_op = sfs_rblock;
    }

    int ret = 0;
    size_t size, alen = 0;
    uint32_t ino;
    uint32_t blkno = offset / SFS_BLKSIZE;          // 读/写起始块号
    uint32_t nblks = endpos / SFS_BLKSIZE - blkno;  // 读/写块数

    // (1) 处理不对齐的第一个块
    if ((blkoff = offset % SFS_BLKSIZE) != 0) {
        // 计算第一个块需要读/写的大小
        size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
        
        // 获取磁盘块号
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        
        // 读/写数据
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

    // (2) 处理对齐的块
    if (nblks > 0) {
        // 获取磁盘块号
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        
        // 读/写整块数据
        if ((ret = sfs_block_op(sfs, buf, ino, nblks)) != 0) {
            goto out;
        }
        
        // 更新变量
        alen += nblks * SFS_BLKSIZE;
        buf += nblks * SFS_BLKSIZE;
        blkno += nblks;
        nblks -= nblks;
    }

    // (3) 处理不对齐的最后一个块
    if ((size = endpos % SFS_BLKSIZE) != 0) {
        // 获取磁盘块号
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        
        // 读/写数据
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
```

### 实现说明

#### 1. 参数说明
- `sfs`: SFS文件系统结构
- `sin`: SFS inode结构，包含文件的元数据
- `buf`: 读/写缓冲区
- `offset`: 文件内的偏移量
- `alenp`: 指向实际读/写长度的指针
- `write`: 读(0)或写(1)标志

#### 2. 关键步骤

**步骤1：处理不对齐的第一个块**
- 计算块内偏移：`blkoff = offset % SFS_BLKSIZE`
- 如果不为0，说明起始位置不对齐
- 计算需要读/写的大小：如果有多个块，读到块尾；否则读到endpos
- 使用`sfs_bmap_load_nolock()`获取逻辑块号对应的物理块号
- 使用`sfs_buf_op()`（实际是`sfs_rbuf`或`sfs_wbuf`）进行非对齐的块内读/写

**步骤2：处理对齐的中间块**
- 对于完整的块，可以直接使用`sfs_block_op()`（实际是`sfs_rblock`或`sfs_wblock`）
- 这样效率更高，因为不需要先读入缓冲区再复制

**步骤3：处理不对齐的最后一个块**
- 计算最后一个块需要读/写的大小：`endpos % SFS_BLKSIZE`
- 如果不为0，说明结束位置不对齐
- 同样使用`sfs_buf_op()`进行块内读/写

#### 3. 关键函数说明

- **sfs_bmap_load_nolock()**: 根据inode和逻辑块号，查找对应的物理块号
- **sfs_rbuf()/sfs_wbuf()**: 读/写块内的部分数据（非对齐访问）
- **sfs_rblock()/sfs_wblock()**: 读/写完整的块（对齐访问）

### 测试验证

执行 `make grade` 进行测试，验证文件读写功能：

```
sfs: mount: 'simple file system' (107/10/117)
vfs: mount disk0.
++ setup timer interrupts
kernel_execve: pid = 2, name = "sh".
user sh is running!!!
$ 
```

**测试结果分析**：
- `sfs: mount: 'simple file system'` 表示SFS文件系统成功挂载，说明文件系统初始化和块读取正常
- 括号中的 `(107/10/117)` 分别表示：已用块数/根目录inode数/总块数
- `vfs: mount disk0.` 表示虚拟文件系统层成功挂载disk0设备
- 后续能够成功加载和执行sh程序，证明 `sfs_io_nolock` 的实现正确支持了ELF文件的读取

---

## 练习2：完成基于文件系统的执行程序机制的实现

### 题目要求

改写`proc.c`中的`load_icode`函数，实现基于文件系统的执行程序机制。

### 设计思路

在实验5中，`load_icode`函数接收的是已经在内存中的二进制数据。在实验8中，需要改为从文件系统中读取可执行文件。

主要变化：
1. **参数变化**：从`(unsigned char *binary, size_t size)`改为`(int fd, int argc, char **kargv)`
2. **读取方式**：使用`load_icode_read()`从文件描述符读取数据
3. **参数传递**：需要在用户栈上正确设置argc和argv

### 实现代码

```c
static int
load_icode(int fd, int argc, char **kargv)
{
    if (current->mm != NULL)
    {
        panic("load_icode: current->mm must be empty.\n");
    }

    int ret = -E_NO_MEM;
    struct mm_struct *mm;
    
    // (1) 创建新的mm结构
    if ((mm = mm_create()) == NULL)
    {
        goto bad_mm;
    }
    
    // (2) 创建新的页目录表
    if (setup_pgdir(mm) != 0)
    {
        goto bad_pgdir_cleanup_mm;
    }
    
    // (3) 从文件加载程序段
    struct Page *page = NULL;
    
    // (3.1) 读取ELF文件头
    struct elfhdr __elf, *elf = &__elf;
    if ((ret = load_icode_read(fd, (void *)elf, sizeof(struct elfhdr), 0)) != 0)
    {
        goto bad_elf_cleanup_pgdir;
    }
    
    // (3.2) 检查ELF魔数
    if (elf->e_magic != ELF_MAGIC)
    {
        ret = -E_INVAL_ELF;
        goto bad_elf_cleanup_pgdir;
    }
    
    // (3.3) 读取程序头表
    struct proghdr __ph, *ph = &__ph;
    uint32_t vm_flags, perm;
    int i;
    for (i = 0; i < elf->e_phnum; i++)
    {
        // 读取每个程序头
        off_t phoff = elf->e_phoff + i * sizeof(struct proghdr);
        if ((ret = load_icode_read(fd, (void *)ph, sizeof(struct proghdr), phoff)) != 0)
        {
            goto bad_cleanup_mmap;
        }
        
        // (3.4) 查找LOAD类型的程序段
        if (ph->p_type != ELF_PT_LOAD)
        {
            continue;
        }
        if (ph->p_filesz > ph->p_memsz)
        {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }
        if (ph->p_filesz == 0)
        {
            continue;
        }
        
        // (3.5) 建立虚拟内存映射
        vm_flags = 0, perm = PTE_U | PTE_V;
        if (ph->p_flags & ELF_PF_X)
            vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PF_W)
            vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PF_R)
            vm_flags |= VM_READ;
        
        // 设置页表权限位
        if (vm_flags & VM_READ)
            perm |= PTE_R;
        if (vm_flags & VM_WRITE)
            perm |= (PTE_W | PTE_R);
        if (vm_flags & VM_EXEC)
            perm |= PTE_X;
            
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
        {
            goto bad_cleanup_mmap;
        }
        
        // (3.6) 分配内存并从文件读取数据
        off_t offset = ph->p_offset;
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);

        ret = -E_NO_MEM;

        end = ph->p_va + ph->p_filesz;
        // (3.6.1) 复制TEXT/DATA段
        while (start < end)
        {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
            {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la)
            {
                size -= la - end;
            }
            // 从文件读取数据
            if ((ret = load_icode_read(fd, page2kva(page) + off, size, offset)) != 0)
            {
                goto bad_cleanup_mmap;
            }
            start += size;
            offset += size;
        }

        // (3.6.2) 建立BSS段
        end = ph->p_memsz + ph->p_va;
        if (start < la)
        {
            if (start == end)
            {
                continue;
            }
            off = start - (la - PGSIZE);
            size = la - start;
            if (end < la)
            {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end)
        {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
            {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la)
            {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    
    // 关闭文件描述符
    sysfile_close(fd);
    
    // (4) 建立用户栈
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
    {
        goto bad_cleanup_mmap;
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);

    // (5) 设置mm、页目录表和CR3
    mm_count_inc(mm);
    current->mm = mm;
    current->pgdir = PADDR(mm->pgdir);
    lsatp(PADDR(mm->pgdir));

    // (6) 在用户栈上设置argc和argv
    uint32_t argv_size = 0;
    for (i = 0; i < argc; i++)
    {
        argv_size += strlen(kargv[i]) + 1;
    }

    uintptr_t stacktop = USTACKTOP - (argv_size / sizeof(long) + 1) * sizeof(long);
    char **uargv = (char **)(stacktop - argc * sizeof(char *));

    argv_size = 0;
    for (i = 0; i < argc; i++)
    {
        uargv[i] = strcpy((char *)(stacktop + argv_size), kargv[i]);
        argv_size += strlen(kargv[i]) + 1;
    }

    stacktop = (uintptr_t)uargv - sizeof(int);
    *(int *)stacktop = argc;

    // (7) 设置trapframe
    struct trapframe *tf = current->tf;
    uintptr_t sstatus = tf->status;
    memset(tf, 0, sizeof(struct trapframe));
    tf->gpr.sp = stacktop;
    tf->epc = elf->e_entry;
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;

    ret = 0;
out:
    return ret;
bad_cleanup_mmap:
    exit_mmap(mm);
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
}
```

### 实现说明

#### 1. 与实验5的主要区别

| 方面 | 实验5 | 实验8 |
|------|-------|-------|
| 数据来源 | 内存中的二进制数据 | 文件系统中的文件 |
| 参数 | `binary`指针和`size` | 文件描述符`fd`、`argc`和`kargv` |
| 读取方式 | 直接从内存复制 | 通过`load_icode_read()`读取 |
| 参数传递 | 无 | 需要在用户栈上设置argc/argv |

#### 2. 关键步骤详解

**步骤1-2：创建mm和页目录**
- 与实验5相同，为进程创建虚拟内存空间

**步骤3：从文件加载程序**
- 使用`load_icode_read(fd, buf, len, offset)`从文件读取数据
- 先读取ELF头，验证魔数
- 遍历程序头表，对每个LOAD段：
  - 调用`mm_map()`建立VMA
  - 分配物理页并从文件读取数据
  - 处理BSS段（全部清零）

**步骤6：设置argc和argv**

用户栈布局（从高地址到低地址）：
```
+------------------+ <- USTACKTOP
|   参数字符串区    |
|  kargv[0]内容    |
|  kargv[1]内容    |
|      ...         |
+------------------+
|   指针数组       |
|  uargv[0]指针    |
|  uargv[1]指针    |
|      ...         |
+------------------+
|      argc        |
+------------------+ <- stacktop (tf->gpr.sp)
|       ...        |
```

实现步骤：
1. 计算所有参数字符串的总长度
2. 在栈上预留空间存放参数字符串
3. 在字符串区下方存放指针数组
4. 在指针数组下方存放argc
5. 设置栈指针sp指向argc的位置

**步骤7：设置trapframe**
- 设置栈指针`sp`指向argc
- 设置程序入口`epc`为ELF的入口地址
- 设置状态寄存器，使能中断，切换到用户态

#### 3. load_icode_read函数

```c
static int
load_icode_read(int fd, void *buf, size_t len, off_t offset)
{
    struct iobuf __iob, *iob = &__iob;
    iobuf_init(iob, buf, len, offset);
    return file_read(fd, iob);
}
```

该函数封装了文件读取操作：
- 初始化IO缓冲区`iobuf`
- 调用`file_read()`从文件读取指定长度的数据

### 测试验证

#### 1. 执行 `make qemu` 测试

```
(THU.CST) os is loading ...

Special kernel symbols:
  entry  0xc020004a (virtual)
  etext  0xc020b264 (virtual)
  edata  0xc0291060 (virtual)
  end    0xc0296910 (virtual)
Kernel executable memory footprint: 603KB
...
check_alloc_page() succeeded!
check_pgdir() succeeded!
check_boot_pgdir() succeeded!
use SLOB allocator
kmalloc_init() succeeded!
check_vma_struct() succeeded!
check_vmm() succeeded.
sched class: RR_scheduler
Initrd: 0xc0214010 - 0xc021bd0f, size: 0x00007d00
Initrd: 0xc021bd10 - 0xc029100f, size: 0x00075300
sfs: mount: 'simple file system' (107/10/117)
vfs: mount disk0.
++ setup timer interrupts
kernel_execve: pid = 2, name = "sh".
user sh is running!!!
$ 
```

**测试结果分析**：
- 所有内存检查通过（`check_alloc_page`, `check_pgdir`, `check_boot_pgdir`, `check_vma_struct`, `check_vmm`）
- 文件系统成功挂载：`sfs: mount: 'simple file system'`
- `kernel_execve: pid = 2, name = "sh".` 表示内核成功调用execve加载sh程序
- `user sh is running!!!` 表示用户态shell程序成功启动
- 出现 `$` 提示符，说明shell正常运行等待用户输入

#### 2. 执行 `make grade` 评分测试

```
  -sh execve:                                OK
  -user sh :                                 OK
Total Score: 100/100
```

**评分结果**：
- `-sh execve`: **OK** - 验证了kernel_execve正确加载并执行sh程序
- `-user sh`: **OK** - 验证了用户态shell正确输出"user sh is running!!!"
- **总分：100/100** - 所有测试项全部通过




---
## 扩展练习 Challenge1：UNIX的PIPE机制

### 设计方案

#### 1. 数据结构设计

```c
// 管道缓冲区大小
#define PIPE_BUF_SIZE 4096

// 管道结构
struct pipe {
    struct spinlock lock;        // 保护管道的自旋锁
    char data[PIPE_BUF_SIZE];   // 环形缓冲区
    uint32_t nread;             // 已读取的字节数
    uint32_t nwrite;            // 已写入的字节数
    int readopen;               // 读端是否打开
    int writeopen;              // 写端是否打开
    wait_queue_t read_queue;    // 读等待队列
    wait_queue_t write_queue;   // 写等待队列
    struct inode *inode;        // 关联的inode
};

// 管道inode信息
struct pipe_inode_info {
    struct pipe *pipe;          // 指向管道结构
    struct semaphore sem;       // 保护管道操作的信号量
};
```

#### 2. 接口设计

```c
// 创建管道，返回读端和写端的文件描述符
int sys_pipe(int *fd);

// 管道读操作
int pipe_read(struct file *file, void *buf, size_t len);

// 管道写操作
int pipe_write(struct file *file, const void *buf, size_t len);

// 关闭管道的一端
int pipe_close(struct file *file);

// 管道的文件操作表
static const struct file_operations pipe_fops = {
    .read = pipe_read,
    .write = pipe_write,
    .close = pipe_close,
};
```

#### 3. 同步互斥机制

**读操作的同步**：
- 如果缓冲区为空且写端已关闭，返回0（EOF）
- 如果缓冲区为空且写端未关闭，读进程睡眠在read_queue上
- 读取数据后，唤醒write_queue上等待的写进程

**写操作的同步**：
- 如果缓冲区已满，写进程睡眠在write_queue上
- 如果读端已关闭，返回错误（EPIPE）
- 写入数据后，唤醒read_queue上等待的读进程

**关闭操作的同步**：
- 关闭读端时，唤醒所有写进程（让它们返回EPIPE错误）
- 关闭写端时，唤醒所有读进程（让它们返回0表示EOF）
- 当读端和写端都关闭时，释放管道资源

#### 4. 实现要点

**环形缓冲区的管理**：
```c
// 缓冲区中的数据量
#define PIPE_SIZE(pipe) ((pipe)->nwrite - (pipe)->nread)

// 缓冲区剩余空间
#define PIPE_SPACE(pipe) (PIPE_BUF_SIZE - PIPE_SIZE(pipe))

// 读位置
#define PIPE_READ_POS(pipe) ((pipe)->nread % PIPE_BUF_SIZE)

// 写位置
#define PIPE_WRITE_POS(pipe) ((pipe)->nwrite % PIPE_BUF_SIZE)
```

**管道读操作伪代码**：
```c
int pipe_read(struct file *file, void *buf, size_t len) {
    struct pipe *pipe = file->pipe;
    
    lock_pipe(pipe);
    while (PIPE_SIZE(pipe) == 0) {
        if (!pipe->writeopen) {
            unlock_pipe(pipe);
            return 0;  // EOF
        }
        sleep_on(&pipe->read_queue, &pipe->lock);
    }
    
    // 从环形缓冲区读取数据
    int n = min(len, PIPE_SIZE(pipe));
    memcpy(buf, &pipe->data[PIPE_READ_POS(pipe)], n);
    pipe->nread += n;
    
    wakeup(&pipe->write_queue);
    unlock_pipe(pipe);
    return n;
}
```

#### 5. 可能的问题和解决方案

**问题1：死锁**
- 如果读写两端都在等待对方，可能发生死锁
- 解决：使用超时机制或非阻塞IO

**问题2：原子性**
- POSIX规定小于PIPE_BUF的写操作应该是原子的
- 解决：在写操作中检查空间是否足够，不够则阻塞等待

**问题3：信号处理**
- 写入已关闭读端的管道应该产生SIGPIPE信号
- 解决：在pipe_write中检测读端状态并发送信号

---

## 扩展练习 Challenge2：UNIX的软连接和硬连接机制

### 设计方案

#### 1. 数据结构设计

```c
// inode结构需要添加的字段
struct inode {
    // ... 原有字段 ...
    uint32_t i_nlink;           // 硬链接计数
    uint32_t i_flags;           // 文件标志（是否为符号链接）
};

// 目录项需要记录文件类型
struct dirent {
    uint32_t ino;               // inode编号
    uint16_t reclen;            // 目录项长度
    uint8_t type;               // 文件类型：普通文件、目录、符号链接等
    char name[MAX_NAME_LEN];    // 文件名
};

// 符号链接的内容存储在inode的数据块中
// 如果路径很短，可以直接存在inode结构中
struct symlink_inode {
    struct inode base;
    char target[60];            // 符号链接指向的路径（短路径优化）
};
```

#### 2. 接口设计

```c
// 创建硬链接
// 语义：为oldpath创建一个新的名字newpath，它们指向同一个inode
int sys_link(const char *oldpath, const char *newpath);

// 创建符号链接
// 语义：创建一个符号链接newpath，它指向target路径
int sys_symlink(const char *target, const char *newpath);

// 读取符号链接的内容
// 语义：读取符号链接path指向的目标路径
int sys_readlink(const char *path, char *buf, size_t bufsiz);

// 删除链接（硬链接或符号链接）
// 语义：删除路径name，如果是最后一个硬链接，则释放inode
int sys_unlink(const char *name);

// 路径解析时跟随符号链接
int follow_link(struct inode *inode, char *buf, int bufsize);
```

#### 3. 硬链接的实现

**创建硬链接**：
```c
int sys_link(const char *oldpath, const char *newpath) {
    // 1. 查找oldpath对应的inode
    struct inode *old_inode = namei(oldpath);
    if (!old_inode) {
        return -ENOENT;
    }
    
    // 2. 检查是否为目录（不允许硬链接目录）
    if (S_ISDIR(old_inode->mode)) {
        iput(old_inode);
        return -EPERM;
    }
    
    // 3. 在newpath的父目录中创建新的目录项
    struct inode *parent = namei_parent(newpath);
    if (!parent) {
        iput(old_inode);
        return -ENOENT;
    }
    
    // 4. 添加目录项，指向同一个inode
    int ret = add_direntry(parent, basename(newpath), old_inode->ino);
    if (ret == 0) {
        // 5. 增加硬链接计数
        old_inode->i_nlink++;
        mark_inode_dirty(old_inode);
    }
    
    iput(old_inode);
    iput(parent);
    return ret;
}
```

**删除硬链接**：
```c
int sys_unlink(const char *path) {
    // 1. 查找path的父目录和文件名
    struct inode *parent = namei_parent(path);
    const char *name = basename(path);
    
    // 2. 从父目录中删除目录项
    struct inode *inode = remove_direntry(parent, name);
    if (!inode) {
        iput(parent);
        return -ENOENT;
    }
    
    // 3. 减少硬链接计数
    inode->i_nlink--;
    
    // 4. 如果链接计数为0，释放inode
    if (inode->i_nlink == 0) {
        free_inode(inode);
    } else {
        mark_inode_dirty(inode);
    }
    
    iput(inode);
    iput(parent);
    return 0;
}
```

#### 4. 符号链接的实现

**创建符号链接**：
```c
int sys_symlink(const char *target, const char *newpath) {
    // 1. 创建新的inode
    struct inode *inode = alloc_inode();
    if (!inode) {
        return -ENOSPC;
    }
    
    // 2. 设置inode类型为符号链接
    inode->mode = S_IFLNK | 0777;
    inode->i_nlink = 1;
    
    // 3. 将目标路径写入inode的数据块
    if (strlen(target) < sizeof(((struct symlink_inode*)0)->target)) {
        // 短路径：直接存储在inode中
        strcpy(((struct symlink_inode*)inode)->target, target);
    } else {
        // 长路径：存储在数据块中
        write_inode_data(inode, target, strlen(target));
    }
    
    // 4. 在newpath的父目录中添加目录项
    struct inode *parent = namei_parent(newpath);
    add_direntry(parent, basename(newpath), inode->ino);
    
    mark_inode_dirty(inode);
    iput(inode);
    iput(parent);
    return 0;
}
```

**跟随符号链接**：
```c
int follow_link(struct inode *inode, char *buf, int bufsize) {
    // 1. 检查是否为符号链接
    if (!S_ISLNK(inode->mode)) {
        return -EINVAL;
    }
    
    // 2. 读取符号链接的目标路径
    if (strlen(((struct symlink_inode*)inode)->target) > 0) {
        // 从inode直接读取
        strncpy(buf, ((struct symlink_inode*)inode)->target, bufsize);
    } else {
        // 从数据块读取
        read_inode_data(inode, buf, bufsize);
    }
    
    return 0;
}
```

#### 5. 路径解析中的符号链接处理

```c
struct inode *namei(const char *path) {
    struct inode *inode = NULL;
    int symlink_depth = 0;
    const int MAX_SYMLINK_DEPTH = 8;  // 防止循环链接
    
    while (1) {
        inode = path_lookup(path);
        if (!inode) {
            return NULL;
        }
        
        // 如果不是符号链接，直接返回
        if (!S_ISLNK(inode->mode)) {
            return inode;
        }
        
        // 检查符号链接深度
        if (++symlink_depth > MAX_SYMLINK_DEPTH) {
            iput(inode);
            return NULL;  // ELOOP
        }
        
        // 读取符号链接的目标
        char target[MAX_PATH];
        follow_link(inode, target, sizeof(target));
        iput(inode);
        
        // 继续解析目标路径
        path = target;
    }
}
```

#### 6. 同步互斥问题

**问题1：创建硬链接时的竞争**
- 多个进程同时创建指向同一inode的硬链接
- 解决：对inode加锁，原子地更新i_nlink

**问题2：删除时的竞争**
- 一个进程删除链接，另一个进程正在访问
- 解决：使用引用计数，只有当i_nlink和引用计数都为0时才释放

**问题3：符号链接循环**
- A -> B, B -> A 形成循环
- 解决：限制符号链接跟随的最大深度

**问题4：目录操作的原子性**
- 添加/删除目录项时需要保证原子性
- 解决：对父目录加锁

#### 7. 实现要点

**硬链接的限制**：
- 不允许对目录创建硬链接（避免形成环）
- 不允许跨文件系统创建硬链接

**符号链接的特点**：
- 可以指向不存在的文件
- 可以跨文件系统
- 删除符号链接不影响目标文件
- 目标文件被删除后，符号链接变成悬空链接

**删除操作**：
- `unlink`删除目录项和减少链接计数
- `rm`命令实际上调用`unlink`
- 只有最后一个硬链接被删除时，文件才真正被释放

---

## 重要知识点总结

### 1. 文件系统相关知识点

#### （1）VFS虚拟文件系统层

**实验中的体现**：
- uCore实现了一个简单的VFS层，包括inode、file、superblock等抽象
- 通过函数指针表（如file_operations）实现了不同文件系统的统一接口

**与OS原理的关系**：
- VFS是现代操作系统的重要抽象层，Linux、Windows等都有类似设计
- 实验简化了很多细节，如dentry缓存、页缓存等
- 核心思想一致：提供统一的文件访问接口，屏蔽底层文件系统差异

#### （2）文件描述符和文件表

**实验中的体现**：
- 进程有files_struct结构，管理打开的文件描述符
- file结构对应一个打开的文件，包含当前位置、访问模式等

**与OS原理的关系**：
- 标准的UNIX文件描述符模型：进程表->文件表->inode表
- 实验实现了这个三级结构，支持fork时文件描述符的继承

#### （3）SFS文件系统

**实验中的体现**：
- 实现了Simple File System，包括超级块、inode、数据块管理
- 支持直接块和间接块索引，最大文件大小有限制

**与OS原理的关系**：
- SFS类似于ext2的简化版本
- 核心概念（inode、数据块、位图）与实际文件系统一致
- 简化了很多特性，如扩展属性、日志等

#### （4）块设备I/O

**实验中的体现**：
- 通过ide驱动实现块设备访问
- sfs_io_nolock处理对齐和非对齐的读写

**与OS原理的关系**：
- 块设备是文件系统的基础
- 实验展示了如何将文件偏移映射到块号
- 实际系统中还有缓冲区缓存、预读等优化

### 2. 进程管理相关知识点

#### （5）ELF文件格式

**实验中的体现**：
- 解析ELF文件头和程序头表
- 加载TEXT、DATA、BSS段到内存

**与OS原理的关系**：
- ELF是Linux的标准可执行文件格式
- 理解ELF对于理解程序加载、动态链接等非常重要
- 实验简化了重定位、动态链接等复杂特性

#### （6）程序加载和执行

**实验中的体现**：
- load_icode从文件系统加载程序
- 建立虚拟内存映射，设置用户栈和参数

**与OS原理的关系**：
- 这是exec系统调用的核心功能
- 实验展示了从磁盘到内存、从内核态到用户态的完整过程
- 实际系统还支持动态链接、写时复制等优化

#### （7）参数传递

**实验中的体现**：
- 在用户栈上布置argc、argv数组和参数字符串
- 使用指针数组实现argv

**与OS原理的关系**：
- 这是UNIX/Linux标准的参数传递方式
- 理解这个机制对于理解main函数的参数来源很重要
- 还涉及到环境变量（envp）的传递

### 3. 内存管理相关知识点

#### （8）虚拟内存映射

**实验中的体现**：
- 使用mm_map建立VMA
- 为TEXT、DATA、BSS、STACK分别建立映射区域

**与OS原理的关系**：
- 这是虚拟内存管理的核心
- 每个段有不同的权限（读、写、执行）
- 实际系统还支持共享内存、内存映射文件等

#### （9）页面分配

**实验中的体现**：
- pgdir_alloc_page分配物理页并建立页表映射
- 按需分配，只在需要时才分配物理页

**与OS原理的关系**：
- 这是虚拟内存的基本操作
- 实际系统还有页面换出、换入等机制
- COW（写时复制）、懒加载等优化

### 4. 与OS原理对应但实验中简化的知识点

#### （10）缓冲区缓存（Buffer Cache）

**OS原理**：
- 内核维护一个缓冲区缓存，缓存最近访问的磁盘块
- 减少磁盘访问次数，提高性能

**实验中的情况**：
- 只有一个简单的sfs_buffer
- 没有实现LRU等替换算法
- 没有脏页写回机制

#### （11）文件系统一致性

**OS原理**：
- 需要保证文件系统的一致性（断电、崩溃时）
- 日志文件系统、写屏障等机制

**实验中的情况**：
- 没有考虑一致性问题
- 没有日志、检查点等机制

#### （12）并发控制

**OS原理**：
- 多个进程可能同时访问同一文件
- 需要文件锁、记录锁等机制

**实验中的情况**：
- 有基本的锁机制
- 但并发控制比较简单

### 5. OS原理中重要但实验未涉及的知识点

#### （13）文件系统高级特性

- **日志文件系统**：ext3/ext4的日志机制，保证一致性
- **B+树索引**：ext4、XFS等现代文件系统的目录索引
- **扩展属性**：存储文件的额外元数据
- **ACL访问控制**：比传统rwx更精细的权限控制

#### （14）存储优化技术

- **预读（Prefetch）**：预测未来的读取，提前加载
- **延迟写（Delayed Write）**：批量写回脏页，减少磁盘I/O
- **I/O调度**：电梯算法、CFQ等磁盘调度算法
- **SSD优化**：针对固态硬盘的特殊优化

#### （15）分布式文件系统

- **NFS（Network File System）**：网络文件系统
- **GFS（Google File System）**：大规模分布式存储
- **HDFS（Hadoop Distributed File System）**：Hadoop的分布式文件系统

#### （16）虚拟化相关

- **容器文件系统**：OverlayFS、AUFS等
- **快照（Snapshot）**：ZFS、Btrfs的快照功能
- **去重（Deduplication）**：相同数据块只存储一份

---

## 实验总结

### 1. 实验收获

通过本次实验，我深入理解了：

1. **文件系统的层次结构**：从VFS抽象层到具体的SFS实现，理解了文件系统的分层设计思想

2. **文件I/O的实现细节**：包括块对齐处理、缓冲区管理、inode和数据块的映射关系

3. **程序加载机制**：从文件系统读取ELF文件，解析各个段，建立虚拟内存映射，最终执行用户程序的完整流程

4. **系统调用的实现**：通过open、read、write、exec等系统调用，理解了内核如何为用户程序提供服务

5. **同步互斥机制**：在文件系统中如何处理并发访问，保证数据一致性

### 2. 遇到的问题和解决

1. **类型转换问题**：编译时出现多处类型不匹配错误，需要仔细检查函数签名

2. **参数传递**：在用户栈上设置argc/argv时，需要注意内存布局和指针计算

3. **文件读取**：理解文件偏移、块号、块内偏移之间的关系，正确处理对齐和非对齐情况

### 3. 改进方向

1. 实现更完善的缓冲区缓存机制
2. 添加文件锁机制，支持并发访问控制
3. 实现符号链接和硬链接
4. 优化I/O性能，如预读、延迟写等
5. 实现更多文件系统特性，如扩展属性、ACL等

### 4. 心得体会

文件系统是操作系统中非常重要的组成部分，它不仅涉及到磁盘管理、内存管理，还与进程管理、同步互斥等紧密相关。通过本次实验，我对操作系统有了更全面、更深入的理解。实验中的许多设计思想（如分层抽象、缓冲区管理、同步机制等）都值得在实际开发中借鉴。

---
