# <center>Lab5 实验报告</center>

<center>学号: 2311828  姓名: 程娜</center>
<center>学号: 2313540  姓名: 张丝童</center>

## 练习0：填写已有实验

在已有的基础上,完成了 Lab2/3/4 代码的整合和修正。

### 修改的关键函数

#### 1. alloc_proc 函数

```c
static struct proc_struct *
alloc_proc(void)
{
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL)
    {
        proc->state = PROC_UNINIT;
        proc->pid = -1;
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
        proc->flags = 0;
        memset(proc->name, 0, PROC_NAME_LEN + 1);
        
        // LAB5 新增字段初始化
        proc->wait_state = 0;
        proc->cptr = proc->yptr = proc->optr = NULL;
        proc->exit_code = 0;
    }
    return proc;
}
```

新增了 `wait_state`、`cptr`、`yptr`、`optr` 等进程关系字段的初始化。

#### 2. do_fork 函数

```c
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
    // ...existing code...
    
    // LAB5: 设置父子进程关系
    proc->parent = current;
    assert(current->wait_state == 0);
    
    // ...existing code...
    
    // LAB5: 设置进程间链接关系
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
        hash_proc(proc);
        set_links(proc);  // 关键:设置进程树关系
    }
    local_intr_restore(intr_flag);
    
    wakeup_proc(proc);
    ret = proc->pid;
    
    // ...existing code...
}
```

增加了父子进程关系的建立和进程树链接的设置。

---

## 练习1: 加载应用程序并执行（需要编码）

### 1.1 trapframe 初始化代码实现

在 `load_icode` 函数的第6步中,我们需要正确设置 trapframe 的三个关键字段:

```c
//(6) setup trapframe for user environment
struct trapframe *tf = current->tf;
uintptr_t sstatus = tf->status;
memset(tf, 0, sizeof(struct trapframe));

// 设置用户栈指针
tf->gpr.sp = USTACKTOP;

// 设置程序入口点
tf->epc = elf->e_entry;

// 设置状态寄存器
tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;
```

### 1.2 设计实现说明

本练习的核心是正确初始化用户进程的 trapframe,使其能够从内核态正确返回到用户态并开始执行。具体设计考虑如下:

1. **用户栈指针 (sp) 的设置**: 
   - 将 `tf->gpr.sp` 设置为 `USTACKTOP`,即用户栈的顶部地址
   - 这确保了用户程序开始执行时拥有一个有效的栈空间,可以进行函数调用和局部变量分配

2. **程序计数器 (epc) 的设置**:
   - 将 `tf->epc` 设置为 `elf->e_entry`,即 ELF 文件中指定的程序入口地址
   - 当通过 `sret` 指令从内核态返回时,CPU 会从这个地址开始执行用户程序的第一条指令

3. **状态寄存器 (status) 的设置**:
   - 清除 `SSTATUS_SPP` 位:表示异常来自用户态,这样 `sret` 指令会返回到用户态而不是内核态
   - 设置 `SSTATUS_SPIE` 位:表示在返回用户态后允许中断,确保系统的响应性

这三个字段的正确设置是用户程序能够正常执行的关键,它们共同构成了从内核态到用户态的状态转换所需的全部信息。

### 1.3 用户进程执行流程详解

从 RUNNING 态到执行应用程序第一条指令的完整过程可以分为以下几个阶段:

#### 阶段1: 进程创建与调度
1. **进程创建**: 在 `init_main()` 函数中,通过 `kernel_thread(user_main, NULL, 0)` 创建用户进程
2. **状态转换**: `do_fork()` 分配进程控制块并初始化,`wakeup_proc()` 将进程状态设置为 `PROC_RUNNABLE`
3. **调度执行**: 调度器选中该进程,通过 `proc_run()` 切换到该进程,进程状态变为 RUNNING

#### 阶段2: 触发系统调用
1. **执行入口**: 进程开始执行 `user_main()` 函数
2. **宏展开**: `KERNEL_EXECVE(exit)` 宏展开为 `kernel_execve()` 函数调用
3. **内联汇编**: 在 `kernel_execve()` 中执行 `ebreak` 指令,触发断点异常

#### 阶段3: 异常处理与系统调用
1. **异常入口**: CPU 跳转到 `__alltraps`,保存当前进程的 trapframe
2. **异常分发**: `trap()` → `trap_dispatch()` → `exception_handler()`
3. **识别断点**: 在 `CAUSE_BREAKPOINT` 分支中,检测到 `a7` 寄存器值为 10(SYS_exec)
4. **调用syscall**: `syscall()` 函数根据 `a0` 寄存器的值分发到 `sys_exec()`

#### 阶段4: 程序加载
1. **内核处理**: `sys_exec()` 调用 `do_execve()`,开始加载新程序
2. **内存清理**: 释放当前进程的旧内存空间
3. **ELF解析**: `load_icode()` 解析 ELF 文件格式的二进制程序
4. **内存映射**: 建立代码段、数据段、BSS段和用户栈的虚拟内存映射
5. **trapframe设置**: 按照练习要求设置 `tf->gpr.sp`、`tf->epc`、`tf->status`

#### 阶段5: 返回用户态
1. **特殊返回**: 通过 `kernel_execve_ret()` 函数,将新的 trapframe 复制到内核栈顶
2. **恢复现场**: `__trapret` 从 trapframe 恢复所有寄存器状态
3. **特权切换**: 执行 `sret` 指令:
   - CPU 从 `sepc`(即 `tf->epc`)读取返回地址
   - 根据 `sstatus` 的 SPP 位判断返回到用户态
   - PC 跳转到用户程序入口地址
4. **开始执行**: 用户程序从 `elf->e_entry` 指定的地址开始执行第一条指令

这个过程完整展示了 ucore 如何通过系统调用机制实现用户程序的加载和执行,体现了用户态与内核态之间的精密协作。

---

## 练习2: 父进程复制自己的内存空间给子进程（需要编码）

### 2.1 copy_range 实现

```c
int copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end,
               bool share)
{
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));
    
    do {
        pte_t *ptep = get_pte(from, start, 0), *nptep;
        if (ptep == NULL) {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
            continue;
        }
        
        if (*ptep & PTE_V) {
            if ((nptep = get_pte(to, start, 1)) == NULL) {
                return -E_NO_MEM;
            }
            
            uint32_t perm = (*ptep & PTE_USER);
            struct Page *page = pte2page(*ptep);
            struct Page *npage = alloc_page();
            assert(page != NULL);
            assert(npage != NULL);
            
            // (1) 获取源页面的内核虚拟地址
            void *src_kvaddr = page2kva(page);
            
            // (2) 获取目标页面的内核虚拟地址
            void *dst_kvaddr = page2kva(npage);
            
            // (3) 复制页面内容
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
            
            // (4) 建立物理地址映射
            int ret = page_insert(to, npage, start, perm);
            assert(ret == 0);
        }
        start += PGSIZE;
    } while (start != 0 && start < end);
    
    return 0;
}
```

#### 实现步骤

1. 获取父进程页面的内核虚拟地址 `src_kvaddr`
2. 为子进程分配新页面并获取其内核虚拟地址 `dst_kvaddr`
3. 使用 `memcpy` 将父进程页面的 `PGSIZE` 字节内容复制到子进程页面
4. 在子进程页表中建立虚拟地址到新物理页面的映射,保持原有的权限设置

### 2.2 Copy on Write (COW) 机制设计

#### 概要设计

COW (Copy on Write) 机制是一种内存优化技术,其核心思想是延迟复制:
- **fork 时**: 父子进程不立即复制物理页面,而是共享同一物理页面,并将该页面设置为只读
- **写时**: 当任一进程尝试写入共享页面时,触发页面错误异常(page fault)
- **真正复制**: 在异常处理中检测到写保护异常后,分配新的物理页面,复制内容,然后将该页面设置为可写

这种机制的优势在于:
1. 减少 fork 时的内存开销,许多页面可能永远不会被写入
2. 加快 fork 操作的速度
3. 节省物理内存,只有真正需要独立副本时才分配

#### 详细设计与实现

**状态转换图**:

```
         [父进程可写页面]
              |
              | fork() 
              v
      [父子共享只读页面]
       ref_count = 2
       PTE_W 清零
              |
              | 任一进程写操作
              v
      [触发 Page Fault]
       CAUSE_STORE_PAGE_FAULT
       error_code = 2
              |
              v
      [do_pgfault 检查]
              |
              v
      [检查页面引用计数]
              |
      +-------+-------+
      |               |
   ref = 1         ref > 1
      |               |
      v               v
 [直接设置可写]   [执行COW复制]
  *ptep |= PTE_W    1. alloc_page()
  tlb_invalidate    2. memcpy()
                    3. page_remove()
                    4. page_insert()
              |
              v
         [独立页面]
      各进程 ref = 1
      各自可写
```

#### 实现代码分析

**1. fork 时的共享设置** (在 `copy_range` 中):

```c
// COW 版本的 copy_range 
if (share || (perm & PTE_W)) {
    // 增加引用计数
    page_ref_inc(page);
    
    // 子进程共享页面,设置为只读
    ret = page_insert(to, page, start, perm & ~PTE_W);
    
    // 修改父进程页面权限为只读
    *ptep = pte_create(page2ppn(page), PTE_V | PTE_U | PTE_R);
    tlb_invalidate(from, start);
}
```

**2. 写时的异常处理** (在 `do_pgfault` 中,已实现):

```c
int do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
    // ...existing code...
    
    // COW 处理逻辑
    if (*ptep & PTE_V) {
        // 页面存在但触发了写保护异常
        if ((error_code & 0x2) && !(*ptep & PTE_W)) {
            struct Page *page = pte2page(*ptep);
            
            if (page_ref(page) == 1) {
                // 情况1: 只有一个进程引用
                // 直接修改权限为可写,无需复制
                *ptep |= PTE_W;
                tlb_invalidate(mm->pgdir, addr);
            } else {
                // 情况2: 多个进程共享
                // 需要执行真正的复制操作
                struct Page *npage = alloc_page();
                if (npage == NULL) {
                    return -E_NO_MEM;
                }
                
                // 复制页面内容
                memcpy(page2kva(npage), page2kva(page), PGSIZE);
                
                // 移除旧映射(减少引用计数)
                page_remove(mm->pgdir, addr);
                
                // 插入新页面(可写)
                if (page_insert(mm->pgdir, npage, addr, perm) != 0) {
                    free_page(npage);
                    return -E_NO_MEM;
                }
            }
            return 0;
        }
    }
    
    // ...existing code...
}
```

**3. 异常处理集成** (在 `trap.c` 中):

```c
case CAUSE_LOAD_PAGE_FAULT:
case CAUSE_STORE_PAGE_FAULT:
    if (current != NULL && current->mm != NULL) {
        // 尝试 COW 处理
        ret = do_pgfault(current->mm, 
                        tf->cause == CAUSE_STORE_PAGE_FAULT ? 2 : 0, 
                        tf->tval);
        if (ret == 0) {
            return;  // 成功处理,返回用户态继续执行
        }
    }
    // COW 处理失败,终止进程
    cprintf("Page fault\n");
    if (current != NULL) {
        do_exit(-E_KILLED);
    }
    break;
```

#### Dirty COW 漏洞分析与防护

**Dirty COW (CVE-2016-5195)** 是 Linux 内核中的一个严重安全漏洞,其原理如下:

**漏洞原理**:
1. 利用 `mmap` 将一个只读文件映射到内存
2. 使用 `madvise(MADV_DONTNEED)` 标记内存区域可以被丢弃
3. 在 COW 机制处理期间,利用竞态条件在时间窗口内写入数据
4. 由于时序问题,写入操作绕过了写保护检查,修改了只读内存

**在 ucore 中的防护措施**:

1. **严格的权限检查**:
```c
// 在 do_pgfault 中验证 VMA 权限
if (!(vma->vm_flags & VM_WRITE)) {
    cprintf("COW: write to read-only VMA denied\n");
    return -E_INVAL;
}
```

2. **原子性保证**:
```c
// 使用中断禁用保护关键区域
local_intr_save(intr_flag);
{
    // 引用计数检查和页面操作
    page_remove(mm->pgdir, addr);
    page_insert(mm->pgdir, npage, addr, perm);
}
local_intr_restore(intr_flag);
```

3. **简化的设计**:
   - ucore 没有 `madvise` 等复杂的内存管理系统调用
   - 没有文件映射机制,避免了文件系统与内存管理的交互
   - 同步机制相对简单,减少了竞态条件的可能性

**ucore 的实现虽然简化,但正确展示了 COW 的核心原理,同时通过简单的设计避免了复杂系统中容易出现的安全漏洞。**

---

## 练习3: 阅读分析源代码,理解进程执行 fork/exec/wait/exit 的实现

### 3.1 fork/exec/wait/exit 函数分析

#### 3.1.1 fork 函数

**系统调用入口**:
```c
static int sys_fork(uint64_t arg[]) {
    struct trapframe *tf = current->tf;
    uintptr_t stack = tf->gpr.sp;
    return do_fork(0, stack, tf);
}
```

**do_fork 核心流程**:

1. **分配进程控制块**:
   - 调用 `alloc_proc()` 分配并初始化 `proc_struct`
   - 设置父子关系: `proc->parent = current`
   - 确保父进程等待状态为 0: `assert(current->wait_state == 0)`

2. **分配内核资源**:
   - `setup_kstack(proc)`: 为子进程分配内核栈
   - `copy_mm(clone_flags, proc)`: 根据标志复制或共享内存空间
   - `copy_thread(proc, stack, tf)`: 复制 trapframe 和设置上下文

3. **分配 PID 并建立进程关系**:
   - `get_pid()`: 分配唯一的进程标识符
   - `hash_proc(proc)`: 将进程加入哈希表
   - `set_links(proc)`: 建立进程树关系(父子、兄弟)

4. **唤醒子进程**:
   - `wakeup_proc(proc)`: 设置状态为 `PROC_RUNNABLE`
   - 返回子进程的 PID

**用户态/内核态分析**:
- **用户态**: 调用 `fork()` 库函数,触发 `ecall` 进入内核
- **内核态**: 执行上述所有操作
- **返回**: 父进程返回子进程 PID,子进程返回 0

#### 3.1.2 exec 函数

**系统调用入口**:
```c
static int sys_exec(uint64_t arg[]) {
    const char *name = (const char *)arg[0];
    size_t len = (size_t)arg[1];
    unsigned char *binary = (unsigned char *)arg[2];
    size_t size = (size_t)arg[3];
    return do_execve(name, len, binary, size);
}
```

**do_execve 核心流程**:

1. **参数验证**:
   - `user_mem_check()`: 检查用户提供的参数地址是否合法
   - 限制程序名称长度不超过 `PROC_NAME_LEN`

2. **清理旧内存空间**:
   - 切换到内核页表: `lsatp(boot_pgdir_pa)`
   - 如果引用计数为 0,释放虚拟内存:
     - `exit_mmap(mm)`: 解除所有虚拟内存映射
     - `put_pgdir(mm)`: 释放页目录
     - `mm_destroy(mm)`: 销毁内存管理结构

3. **加载新程序**:
   - `load_icode(binary, size)`: 解析 ELF 文件并加载
     - 创建新的 `mm_struct`
     - 建立代码段、数据段、BSS 段的内存映射
     - 分配用户栈
     - **设置 trapframe**(练习1的内容)

4. **更新进程信息**:
   - `set_proc_name()`: 设置新的进程名称

**用户态/内核态分析**:
- **用户态**: 调用 `exec()`,准备程序路径和参数
- **内核态**: 完成内存清理和新程序加载
- **返回**: 成功返回 0,失败返回错误码;成功后从新程序入口开始执行

#### 3.1.3 wait 函数

**系统调用入口**:
```c
static int sys_wait(uint64_t arg[]) {
    int pid = (int)arg[0];
    int *store = (int *)arg[1];
    return do_wait(pid, store);
}
```

**do_wait 核心流程**:

1. **验证参数**:
   - 检查 `code_store` 地址是否在用户空间且可写

2. **查找可回收的子进程**:
   - 如果 `pid != 0`: 查找指定 PID 的子进程
   - 如果 `pid == 0`: 遍历所有子进程(通过 `cptr` 指针)
   - 寻找状态为 `PROC_ZOMBIE` 的子进程

3. **等待或休眠**:
   - 如果有子进程但都未结束:
     - 设置当前进程状态为 `PROC_SLEEPING`
     - 设置等待状态为 `WT_CHILD`
     - 调用 `schedule()` 让出 CPU
     - 被唤醒后检查是否被 killed,否则重新查找

4. **回收子进程资源**:
   - 保存子进程的退出码到 `code_store`
   - 从进程哈希表和进程链表中移除: `unhash_proc()`, `remove_links()`
   - 释放子进程的内核栈和进程控制块

**用户态/内核态分析**:
- **用户态**: 调用 `wait()` 或 `waitpid()`
- **内核态**: 查找子进程、休眠等待、回收资源
- **阻塞机制**: 如果没有僵尸子进程,父进程会休眠,直到某个子进程退出时被唤醒

#### 3.1.4 exit 函数

**系统调用入口**:
```c
static int sys_exit(uint64_t arg[]) {
    int error_code = (int)arg[0];
    return do_exit(error_code);
}
```

**do_exit 核心流程**:

1. **安全检查**:
   - 禁止 `idleproc` 和 `initproc` 退出

2. **释放内存资源**:
   - 切换到内核页表
   - 如果内存引用计数为 0:
     - `exit_mmap(mm)`: 解除所有虚拟内存映射
     - `put_pgdir(mm)`: 释放页目录
     - `mm_destroy(mm)`: 销毁 mm_struct

3. **设置进程状态**:
   - 状态设置为 `PROC_ZOMBIE`
   - 保存退出码: `current->exit_code = error_code`

4. **处理父子关系**:
   - 唤醒父进程(如果父进程在等待子进程)
   - 将所有子进程过继给 `initproc`:
     - 遍历子进程链表
     - 修改每个子进程的 `parent` 指针
     - 如果子进程已是僵尸态,唤醒 `initproc`

5. **让出 CPU**:
   - 调用 `schedule()` 切换到其他进程
   - **此函数永不返回**

**用户态/内核态分析**:
- **用户态**: 调用 `exit(error_code)`
- **内核态**: 完成所有清理工作
- **特殊性**: 进程不会返回用户态,直接进入僵尸状态等待父进程回收

### 3.2 问题1: fork/exec/wait/exit 执行流程分析

#### 一、用户态与内核态的操作划分

**用户态完成的操作**:
- 调用系统调用库函数（如 `fork()`, `exec()`, `wait()`, `exit()`）
- 准备系统调用参数（存入寄存器 `a0-a7`）
- 执行 `ecall` 指令触发异常，陷入内核态
- 从系统调用返回后，在 `a0` 寄存器中获取返回值
- 根据返回值继续执行用户程序逻辑

**内核态完成的操作**:

1. **fork 系统调用**:
   - 分配新的进程控制块 (`alloc_proc`)
   - 分配内核栈 (`setup_kstack`)
   - 复制父进程的内存空间 (`copy_mm`)
   - 复制父进程的 trapframe 和上下文 (`copy_thread`)
   - 分配唯一的 PID (`get_pid`)
   - 建立父子进程关系 (`set_links`)
   - 将子进程加入就绪队列 (`wakeup_proc`)

2. **exec 系统调用**:
   - 验证用户参数的合法性 (`user_mem_check`)
   - 释放当前进程的虚拟内存空间 (`exit_mmap`, `put_pgdir`, `mm_destroy`)
   - 解析 ELF 文件头，创建新的内存管理结构 (`mm_create`)
   - 建立代码段、数据段、BSS段的虚拟内存映射
   - 分配用户栈空间
   - 设置 trapframe 的关键字段（`sp`, `epc`, `status`）

3. **wait 系统调用**:
   - 遍历当前进程的子进程链表，查找状态为 `PROC_ZOMBIE` 的子进程
   - 如果没有僵尸子进程，将当前进程状态设置为 `PROC_SLEEPING`，调用 `schedule()` 让出 CPU
   - 被唤醒后重新查找僵尸子进程
   - 找到僵尸子进程后，从进程哈希表和进程树中移除 (`unhash_proc`, `remove_links`)
   - 释放子进程的内核栈和进程控制块

4. **exit 系统调用**:
   - 释放进程的虚拟内存空间（如果引用计数为0）
   - 将进程状态设置为 `PROC_ZOMBIE`
   - 保存退出码到进程控制块
   - 唤醒等待该进程的父进程 (`wakeup_proc`)
   - 将所有子进程过继给 `initproc`
   - 调用 `schedule()` 切换到其他进程（**此函数永不返回**）

---

#### 二、用户态与内核态的交错执行流程

以一个完整的 **父进程 fork 子进程 → 子进程 exec 新程序 → 父进程 wait 子进程 → 子进程 exit** 流程为例：

**阶段1: 父进程调用 fork()**

1. **用户态**: 父进程执行到 `fork()` 库函数，设置系统调用号（`a0=SYS_fork`），执行 `ecall` 指令
2. **切换到内核态**: CPU 自动保存 PC 到 `sepc`，跳转到 `stvec` 指向的 `__alltraps` 入口
3. **内核态**: 
   - `__alltraps` 保存完整的 trapframe（所有寄存器）
   - `trap()` → `trap_dispatch()` → `exception_handler()` → `syscall()`
   - `syscall()` 调用 `sys_fork()` → `do_fork()`
   - `do_fork()` 完成子进程创建，设置 **子进程** trapframe 的 `a0=0`，设置 **父进程** trapframe 的 `a0=child_pid`
4. **返回用户态**: `__trapret` 恢复 trapframe，执行 `sret` 指令，CPU 从 `sepc` 读取返回地址，切换到用户态
5. **用户态**: 父进程从 `fork()` 返回，获得子进程 PID；子进程从 `fork()` 返回，获得 0

**阶段2: 父进程调用 wait()**

1. **用户态**: 父进程执行 `wait()`，通过 `ecall` 陷入内核
2. **内核态**:
   - `do_wait()` 遍历子进程链表，未找到 `PROC_ZOMBIE` 状态的子进程
   - 将父进程状态设置为 `PROC_SLEEPING`，等待状态设置为 `WT_CHILD`
   - 调用 `schedule()` 让出 CPU，**父进程被阻塞**

**阶段3: 子进程调用 exec()**

1. **用户态**: 调度器选中子进程执行，子进程调用 `exec()`，通过 `ecall` 陷入内核
2. **内核态**:
   - `do_execve()` 释放子进程的旧内存空间（清空原有的代码、数据、栈）
   - `load_icode()` 解析新的 ELF 文件，建立新的虚拟内存映射
   - 设置 trapframe 的 `epc` 为新程序入口，`sp` 为用户栈顶，`status` 为用户态标志
3. **返回用户态**: 通过 `sret` 返回，但 **PC 跳转到新程序的入口地址**，子进程开始执行新程序

**阶段4: 子进程执行完毕后调用 exit()**

1. **用户态**: 子进程执行完任务，调用 `exit(error_code)`，通过 `ecall` 陷入内核
2. **内核态**:
   - `do_exit()` 释放子进程的虚拟内存空间
   - 将子进程状态设置为 `PROC_ZOMBIE`，保存退出码
   - 检查父进程是否在等待（`parent->wait_state == WT_CHILD`），如果是，调用 `wakeup_proc(parent)` **唤醒父进程**
   - 调用 `schedule()` 切换到其他进程，**子进程不再被调度**

**阶段5: 父进程被唤醒，继续执行 wait()**

1. **内核态**: 调度器选中父进程（状态从 `PROC_SLEEPING` → `PROC_RUNNABLE` → `RUNNING`）
2. **内核态**: 父进程从 `schedule()` 返回后，继续执行 `do_wait()`
   - 重新遍历子进程链表，找到状态为 `PROC_ZOMBIE` 的子进程
   - 读取子进程的退出码，写入用户提供的 `code_store` 地址
   - 调用 `unhash_proc()` 和 `remove_links()` 将子进程从系统中移除
   - 释放子进程的内核栈和进程控制块
   - 将子进程 PID 写入 `tf->gpr.a0` 作为返回值
3. **返回用户态**: 通过 `sret` 返回用户态
4. **用户态**: 父进程从 `wait()` 返回，获得子进程的 PID 和退出码，继续执行后续逻辑

---

#### 三、内核态与用户态的切换机制

**用户态 → 内核态（系统调用入口）**:

1. **触发方式**: 用户程序执行 `ecall` 指令
2. **硬件自动完成**:
   - 保存当前 PC 到 `sepc`（返回地址）
   - 设置 `sstatus.SPP=0`（标记来自用户态）
   - PC 跳转到 `stvec`（内核异常入口地址）
   - CPU 特权级切换到 S 态（内核态）
3. **软件处理**:
   - `__alltraps` 将所有通用寄存器、`sepc`、`sstatus` 等保存到 trapframe
   - 调用 `trap()` → `syscall()`，根据 `a0` 寄存器的值分发到具体的系统调用处理函数

**内核态 → 用户态（系统调用返回）**:

1. **返回值设置**: 内核在处理完系统调用后，将返回值写入 `tf->gpr.a0`
2. **恢复现场**: `__trapret` 从 trapframe 恢复所有寄存器的值（包括 `a0`）
3. **执行返回指令**: `sret` 指令
   - 从 `sepc` 读取返回地址，设置 PC（跳转到 `ecall` 的下一条指令）
   - 根据 `sstatus.SPP` 的值切换特权级（0 表示返回用户态）
   - 清除 `sstatus.SPP` 位
4. **继续执行**: 用户程序从系统调用处继续执行，从 `a0` 寄存器中获取返回值

---

#### 四、内核态执行结果的返回机制

**核心原理**: 内核通过修改 **trapframe** 中的 `a0` 寄存器值来传递返回值，当 `sret` 指令恢复寄存器状态时，用户程序自然获得返回值。

**具体流程**:

1. **系统调用分发**:
```c
void syscall(void) {
    struct trapframe *tf = current->tf;
    uint64_t arg[5];
    int num = tf->gpr.a0;  // 系统调用号
    
    // 提取参数（a1-a5）
    arg[0] = tf->gpr.a1;
    arg[1] = tf->gpr.a2;
    // ...
    
    // 执行系统调用，将返回值写入 trapframe
    tf->gpr.a0 = syscalls[num](arg);  // 关键步骤
}
```

2. **特殊情况 - fork 的两个返回值**:
```c
// 在 do_fork() 中
proc->tf->gpr.a0 = 0;                    // 子进程返回 0
current->tf->gpr.a0 = proc->pid;         // 父进程返回子进程 PID
```
通过分别设置父子进程 trapframe 的 `a0` 值，实现了 `fork()` 的"一次调用，两次返回"。

3. **错误码传递**:
   - 成功: 返回非负值（如 PID、0）
   - 失败: 返回负的错误码（如 `-E_NO_MEM`、`-E_INVAL`）
   - 用户程序检查返回值是否为负数来判断系统调用是否成功

**总结**: trapframe 是内核与用户态之间的"通信桥梁"，既保存了用户态的完整上下文，又提供了参数传递和返回值传递的通道。

---

## 测试结果
运行 `make grade` 测试

![make grade](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS5/images/1.png)

测试结果130/130分,全部通过。

## 扩展练习 Challenge: Copy on Write 机制实现

## COW 机制设计概述
Copy on Write（写时复制）是一种内存优化技术，其核心思想是：

1. fork 时不立即复制物理页面，父子进程共享同一物理页面

2. 将共享页面设置为只读，任何写操作都会触发页面错误

3. 写入时才真正复制，分配新的物理页面并复制内容

4. 实现内存的延迟分配，节省不必要的复制开销

## COW 状态转换机制（有限状态自动机）

### 状态定义

状态名称	    描述	                关键标志
WRITABLE	    可写独占页面	    PTE_W=1, ref_count=1
COW_SHARED	    COW共享只读页面	    PTE_W=0, ref_count≥2
FAULT_DETECTED	 检测到写保护异常	临时状态，在 do_pgfault 中
COPYING	        正在执行页面复制	临时状态，分配新页面并复制
ISOLATED	    复制完成，独立可写	PTE_W=1, ref_count=1

### 状态转换图

```
                  [初始状态: 父进程可写页面]
                         (WRITABLE)
                    ref_count = 1, PTE_W = 1
                             |
                             | fork() 系统调用
                             |
                             v
                 +-----------+-----------+
                 |                       |
            父进程页面                子进程页面
         (COW_SHARED)              (COW_SHARED)
      ref_count = 2              共享同一物理页
      PTE_W = 0 (只读)            PTE_W = 0 (只读)
                 |                       |
                 |                       |
         父进程写操作                子进程写操作
                 |                       |
                 v                       v
         [触发 Page Fault]       [触发 Page Fault]
         (FAULT_DETECTED)        (FAULT_DETECTED)
      CAUSE_STORE_PAGE_FAULT  CAUSE_STORE_PAGE_FAULT
      error_code = 2          error_code = 2
                 |                       |
                 v                       v
         [do_pgfault 处理]       [do_pgfault 处理]
                 |                       |
         检查 page_ref(page)     检查 page_ref(page)
                 |                       |
      +----------+----------+  +---------+---------+
      |                     |  |                   |
   ref = 1               ref > 1              ref > 1
      |                     |  |                   |
      v                     v  v                   v
 [直接设置可写]        [执行 COW 复制]      [执行 COW 复制]
  (ISOLATED)            (COPYING)            (COPYING)
  *ptep |= PTE_W         |                    |
  tlb_invalidate         |                    |
      |                  v                    v
      |          1. alloc_page()      1. alloc_page()
      |          2. memcpy(...)       2. memcpy(...)
      |          3. page_remove(...)  3. page_remove(...)
      |          4. page_insert(...)  4. page_insert(...)
      |                  |                    |
      |                  v                    v
      |          [独立可写页面]        [独立可写页面]
      |           (ISOLATED)           (ISOLATED)
      |          ref = 1, PTE_W = 1   ref = 1, PTE_W = 1
      |                  |                    |
      +------------------+--------------------+
                         |
                         v
                 [各自独立执行]
              父进程页面 ≠ 子进程页面

```

### COW 测试用例

我们创建了专门的 COW 测试程序 `cow_test.c`:

```c
#include <stdio.h>
#include <ulib.h>
#include <unistd.h>

int global_data = 100;

int main(void) {
    cprintf("COW Test Start\n");
    cprintf("Before fork: global_data = %d at %x\n", global_data, &global_data);
    
    int pid = fork();
    
    if (pid == 0) {
        // 子进程
        cprintf("Child: global_data = %d at %x\n", global_data, &global_data);
        global_data = 200;  // 触发 COW
        cprintf("Child: after write, global_data = %d at %x\n", global_data, &global_data);
        exit(0);
    } else if (pid > 0) {
        // 父进程
        cprintf("Parent: global_data = %d at %x\n", global_data, &global_data);
        wait();
        cprintf("Parent: after child exit, global_data = %d at %x\n", global_data, &global_data);
        
        if (global_data == 100) {
            cprintf("COW Test PASS!\n");
        } else {
            cprintf("COW Test FAIL!\n");
        }
    } else {
        cprintf("Fork failed!\n");
    }
    
    return 0;
}
```

### COW 测试结果

运行 `make test-cow` 后的输出:

```
COW Test Start
Before fork: global_data = 100 at 801000
Parent: global_data = 100 at 801000
Child: global_data = 100 at 801000
Child: after write, global_data = 200 at 801000
Parent: after child exit, global_data = 100 at 801000
COW Test PASS!
```

**结果分析**:
1. ✅ 子进程写入后,值从 100 变为 200
2. ✅ 父进程的值保持 100 不变
3. ✅ COW 机制成功隔离了父子进程的内存修改

![make test-cow](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS5/images/2.png)

## 说明该用户程序是何时被预先加载到内存中的？与我们常用操作系统的加载有何区别，原因是什么？

在 COW 机制下，程序在父进程首次 exec 时加载到物理内存，fork 时父子进程共享这些页面（设为只读），只有在写入时才真正复制。这与传统操作系统在 fork 时立即复制所有内存的实现方式不同，后者会消耗更多内存资源，尤其是在多进程共享大量只读数据（如程序代码）的情况下。

---

## 分支任务：Lab5 gdb调试系统调用以及返回

### 一、实验目标

本实验在系统调用分支下进行，旨在通过 GDB 双重调试技术，深入理解 RISC-V 架构下用户态（U 态）触发系统调用、切换到内核态（S 态）执行服务、最终返回用户态的完整流程，重点观察 QEMU 对 `ecall`（系统调用触发）和 `sret`（特权级返回）指令的模拟实现，以及特权级切换、上下文保存与恢复的核心机制。

### 二、实验核心步骤与执行记录

#### 步骤1: 启动 QEMU 并建立第一层 GDB 连接

1. **启动 QEMU 模拟器**(终端1):

```bash
cd ~/OS/OS5
make debug
```

2. **查找 QEMU 进程并 attach**(终端2):

```bash
pgrep -f qemu-system-riscv64  # 输出PID
sudo gdb
(gdb) attach <PID>
(gdb) handle SIGPIPE nostop noprint  # 忽略管道信号，避免调试中断
(gdb) continue
```

成功 `attach` 后，QEMU 进程被暂停，等待 GDB 控制。

#### 步骤2: 建立第二层 GDB 连接到 ucore 内核

1. **启动 ucore GDB 并加载用户程序符号表**:

在另一终端连接到 QEMU 的 GDB stub，控制 `ucore` 内核执行：

```bash
cd ~/OS/OS5
make gdb
```

2. **加载用户程序符号表并设置断点**:

```gdb
# 加载用户程序 exit 的符号表（基地址 0x800020）
(gdb) add-symbol-file obj/__user_exit.out 0x800020
(y or n) y
Reading symbols from obj/__user_exit.out...
(gdb) set remotetimeout unlimited

# 断点1：用户态 syscall 函数（包含 ecall 指令）
(gdb) break user/libs/syscall.c:18
Breakpoint 1 at 0x8000f0: file user/libs/syscall.c, line 19.

(gdb) c  # 运行 ucore，触发用户态 syscall 断点
Continuing.
```

3. **定位 ecall 指令并暂停**:

```gdb
# 单步执行到 ecall 指令前
(gdb) si  # 多次执行，直到 PC 指向 ecall
=> 0x800104 <syscall+44>:       ecall  

# 查看从当前PC开始的10条汇编指令，找到ecall
(gdb) x/10i $pc

# 查看当前PC寄存器
(gdb) i r $pc
# 输出：pc             0x800104 0x800104 <syscall+44>
```

#### 步骤3: 在 QEMU 源码中设置断点

在终端 2 执行 Ctrl+C 触发 `ecall` 指令，接着对 QEMU 中处理 `ecall` 的核心函数设置断点：

```gdb
# 断点1：RISC-V指令翻译函数（捕获ecall指令）
(gdb) b riscv_tr_translate_insn

# 断点2：陷阱处理函数
(gdb) b riscv_cpu_do_interrupt

(gdb) c
Continuing.

# 断点触发后，单步执行（查看QEMU如何模拟ecall）
(gdb) si  # 逐行执行QEMU源码
# 关键观察点：
# 1. QEMU解析ecall指令，判断特权级切换（U态→S态）
# 2. 查找中断向量表，跳转到内核态中断入口
# 3. 保存用户态上下文（寄存器、PC等）
```

#### 步骤4: 观察内核处理系统调用并定位 sret

在终端 3 的 GDB 中继续执行 `ucore`（完成 `ecall` 内核处理）：

```gdb
# 继续执行ucore，直到系统调用处理完成，接近sret指令
(gdb) c

# 断点2：内核态中断返回函数（包含 sret 指令）
# 方法：打断点在sret前
(gdb) b kern/trap/tranpentry.S:133

(gdb) c  # 运行 ucore，触发 sret 断点
Continuing.

# 单步到sret指令前
(gdb) si  # 直到PC指向sret
(gdb) i r $pc  # 确认PC指向sret
```

#### 步骤5: 在 QEMU 源码中设置断点

重复终端 2 的暂停操作（Ctrl + C），设置 `sret` 相关断点：

```gdb
(gdb) c
Continuing.

# QEMU处理sret的核心函数
(gdb) b helper_sret
(gdb) c
(gdb) si  # 跟踪sret处理逻辑：恢复用户态特权级、上下文，PC跳回用户态
```

### 三、实验结果分析与总结

#### 核心知识点总结

1.  系统调用完整流程验证：
成功观测到从用户态 `ecall` 触发 → 内核态处理 → `sret` 返回用户态的全链路；
QEMU 通过 `helper_ecall` 和 `helper_sret` 函数模拟硬件对两条指令的处理，核心是特权级切换和上下文保存 / 恢复。

2.  特权级切换关键机制：
U→S 态（`ecall`）：QEMU 修改 `env->priv` 为 `PRIV_S`，PC 跳转到 `stvec` 指向的内核中断入口，保存用户态 PC 到 sepc；
S→U 态（`sret`）：QEMU 从 `sepc` 恢复用户态 PC，修改 `env->priv` 为 `PRIV_U`，清除 `status` 寄存器的 SPP 标志。

3.  上下文保存核心寄存器：
`sepc`：保存用户态返回地址（`ecall` 下一条指令）；
`stvec`：内核中断向量表基址，指导 `ecall` 后跳转到内核处理函数；
`status`：通过 SPP 位标记当前特权级（1=S 态，0=U 态）。

4.  QEMU 指令翻译（TCG）关联：
实验中 `ecall/sret` 的处理依赖 QEMU 的 TCG（Tiny Code Generator）技术，QEMU 先将 RISC-V 指令翻译为宿主架构（x86）中间码，再通过 `helper_ecall/helper_sret` 执行核心逻辑；
与 Lab2 地址翻译调试类似，双重 GDB 本质是观察 TCG 翻译后的指令执行与硬件模拟过程。

#### 实验过程中的问题与解决

##### 问题1：ecall指令地址不在syscall函数里

- 原因：环境开了优化，编译器做了内联；

- 解决：在编译用户程序时添加 -O0 编译选项关闭编译器优化。

##### 问题2：QEMU启动报错“Address already in use”

- 原因：1234调试端口被残留QEMU进程占用；

- 解决：杀死占用端口的进程：`kill -9 $(lsof -t -i:1234)`。

##### 问题3：sudo命令未找到

- 原因：当前已是root用户，无需sudo权限；

- 解决：直接执行命令，去掉sudo前缀。

#### 实验延伸思考

1.  TCG 翻译的作用：QEMU 作为软件模拟器，通过 TCG 将 RISC-V 指令翻译为宿主架构指令，`ecall/sret` 的翻译结果直接对应 `helper_ecall/helper_sret` 函数调用，这与 Lab2 中地址翻译的 TCG 翻译逻辑一致；

2.  真实硬件与 QEMU 模拟的差异：真实 CPU 对 `ecall/sret` 的处理是硬件电路实现，而 QEMU 是通过 C 函数模拟，但其核心逻辑（特权级切换、寄存器操作）完全一致；

3.  系统调用安全性：特权级隔离（U 态无法直接访问内核资源）通过硬件（或 QEMU 模拟）强制实现，ecall 是唯一合法的 “特权级提升入口”，这是系统安全性的核心保障。

---

## 分支任务：Lab2 虚拟内存地址翻译机制调试

### 一、实验目标

本实验在 Lab2 分支下进行，旨在通过 GDB 双重调试技术，深入理解 RISC-V Sv39 分页机制下的虚拟地址翻译过程。

### 二、实验核心步骤与调试记录

#### 步骤1: 启动 QEMU 并建立第一层 GDB 连接

1. **启动 QEMU 模拟器**(终端1):

```bash
cd ~/OS/OS2
make qemu-gdb
# QEMU 在 localhost:1234 端口等待 GDB 连接
```

2. **查找 QEMU 进程并 attach**(终端2):

```bash
pgrep -f qemu-system-riscv64  # 输出PID
sudo gdb
(gdb) attach <PID>
(gdb) handle SIGPIPE nostop noprint  # 忽略管道信号，避免调试中断
```

成功 attach 后，QEMU 进程被暂停，等待 GDB 控制。

#### 步骤2: 在 QEMU 源码中设置断点

在 QEMU 的虚拟地址翻译关键函数处设置断点：

```gdb
(gdb) b get_physical_address
Breakpoint 1 at 0x55867acad4e3: file target/riscv/cpu_helper.c, line 158.

(gdb) b riscv_cpu_tlb_fill
Breakpoint 2 at 0x55867acae0f8: file target/riscv/cpu_helper.c, line 438.

(gdb) c
Continuing.
```

#### 步骤3: 建立第二层 GDB 连接到 ucore 内核

在另一终端连接到 QEMU 的 GDB stub，控制 ucore 内核执行：

```bash
cd ~/OS/OS2
make gdb
# 自动执行: riscv64-unknown-elf-gdb -ex 'file bin/kernel' ...
```

```gdb
(gdb) set remotetimeout unlimited
(gdb) b kern_init
Breakpoint 1 at 0xffffffffc02000d6: file kern/init/init.c, line 30.
(gdb) c
Continuing.

Breakpoint 1, kern_init () at kern/init/init.c:30
30          memset(edata, 0, end - edata);
```

成功触发内核初始化断点，此时 ucore 尝试访问虚拟地址 `edata`。

#### 步骤3.5: 观察 QEMU TCG 指令地址获取

在终端2 (QEMU GDB) 中，可以观察到 QEMU 的 TCG 引擎在翻译执行指令前，需要先获取指令的物理地址：

```gdb
(gdb) c
Continuing.
[Switching to Thread 0x78fb81ce36c0 (LWP 10276)]

Thread 2 "qemu-system-ris" hit Breakpoint 3, get_page_addr_code (
    env=0x56d71bc38230, 
    addr=18446744072637907180)    # 虚拟地址 0xffffffffc02000ec
    at /home/doudoudadii/qemu/qemu-4.1.1/accel/tcg/cputlb.c:1025
1025        uintptr_t mmu_idx = cpu_mmu_index(env, true);
(gdb) c
Continuing.
```

**TCG 指令获取分析**:

1. **断点触发函数**: `get_page_addr_code`
   - 这是 QEMU TCG 引擎在翻译 RISC-V 指令前调用的函数
   - 作用：将指令的虚拟地址翻译为宿主机物理地址，以便 QEMU 读取指令内容

2. **虚拟地址**: `0xffffffffc02000ec`
   - 这是 `kern_init` 函数中某条指令的地址
   - 位于内核代码段，属于直接映射区域

3. **MMU 索引**: `cpu_mmu_index(env, true)`
   - 参数 `true` 表示这是指令获取 (instruction fetch)
   - 用于确定当前的特权级和访问模式，以便进行正确的地址翻译

4. **TCG 翻译流程**:
   ```
   用户态指令 (RISC-V) → get_page_addr_code (地址翻译)
       ↓
   读取指令字节 → TCG 中间表示 (IR)
       ↓
   宿主机代码 (x86) → 执行
   ```

**与数据访问地址翻译的区别**:

| 特性 | 指令获取 (`get_page_addr_code`) | 数据访问 (`get_physical_address`) |
|------|----------------------------------|-----------------------------------|
| 调用时机 | TCG 翻译指令前 | 执行 load/store 指令时 |
| 权限检查 | 需要可执行权限 (X 位) | 需要读/写权限 (R/W 位) |
| TLB 类型 | 指令 TLB | 数据 TLB |
| 触发异常 | Instruction Page Fault | Load/Store Page Fault |

**实验意义**:
- 展示了 QEMU 作为软件模拟器，不仅要模拟数据的虚拟地址翻译，也要模拟指令获取的地址翻译
- 理解 CPU 的"取指-译码-执行"流程中，"取指"阶段就涉及 MMU 地址翻译
- 真实 CPU 的指令 TLB 和数据 TLB 是分离的，QEMU 也模拟了这种分离机制

#### 步骤4: 观察第一次虚拟地址翻译

在终端2 (QEMU GDB) 自动触发断点：

```gdb
Thread 2 "qemu-system-ris" hit Breakpoint 1, get_physical_address (
    env=0x55867bda8230, 
    physical=0x7ffcf638ae18, 
    prot=0x7ffcf638ae10, 
    addr=18446744072637907158,    # 虚拟地址
    access_type=0,                # 读操作
    mmu_idx=1)                    # 内核态
    at target/riscv/cpu_helper.c:158
```

**分析虚拟地址结构**:

```gdb
(gdb) p/x addr
$1 = 0xffffffffc02000d6  # 虚拟地址

(gdb) p/x env->satp
$2 = 0x8000000000080204  # satp 寄存器值

# 提取 satp 字段
(gdb) set $satp = env->satp
(gdb) set $mode = ($satp >> 60) & 0xF
(gdb) set $ppn = $satp & 0xFFFFFFFFFFF

(gdb) print $mode
$5 = 8  # Sv39 模式

(gdb) print /x $ppn << 12
$6 = 0x80204000  # 页表基址 (物理地址)

# 提取虚拟地址各级页号
(gdb) set $va = addr
(gdb) set $vpn2 = ($va >> 30) & 0x1FF
(gdb) set $vpn1 = ($va >> 21) & 0x1FF
(gdb) set $vpn0 = ($va >> 12) & 0x1FF
(gdb) set $offset = $va & 0xFFF

(gdb) printf "VA=0x%lx: VPN[2]=%d VPN[1]=%d VPN[0]=%d Offset=0x%x\n", \
      $va, $vpn2, $vpn1, $vpn0, $offset
VA=0xffffffffc02000d6: VPN[2]=511 VPN[1]=1 VPN[0]=0 Offset=0xd6
```

**Sv39 地址翻译结构**:
```
虚拟地址: 0xffffffffc02000d6
├─ VPN[2]=511 (9 bits, [38:30]) → 页目录表索引
├─ VPN[1]=1   (9 bits, [29:21]) → 中间页表索引
├─ VPN[0]=0   (9 bits, [20:12]) → 页表索引
└─ Offset=0xd6 (12 bits, [11:0]) → 页内偏移
```

#### 步骤5: 观察第二次地址翻译 (写操作触发 TLB 填充)

继续执行后，ucore 尝试写入虚拟地址 `0xffffffffc0203ff8`:

```gdb
(gdb) c
Continuing.

Thread 2 "qemu-system-ris" hit Breakpoint 2, riscv_cpu_tlb_fill (
    cs=0x55867bd9f820, 
    address=18446744072637923320,  # 0xffffffffc0203ff8
    size=8, 
    access_type=MMU_DATA_STORE,   # 写操作
    mmu_idx=1, 
    probe=false, 
    retaddr=123597515391301)
    at target/riscv/cpu_helper.c:438
```

**分析虚拟地址结构**:

```gdb
(gdb) print /x address
$7 = 0xffffffffc0203ff8

# 提取虚拟地址各级页号
(gdb) set $va = address
(gdb) set $vpn2 = ($va >> 30) & 0x1FF
(gdb) set $vpn1 = ($va >> 21) & 0x1FF
(gdb) set $vpn0 = ($va >> 12) & 0x1FF
(gdb) set $offset = $va & 0xFFF

(gdb) printf "VPN[2]=%d, VPN[1]=%d, VPN[0]=%d, Offset=0x%x\n", \
      $vpn2, $vpn1, $vpn0, $offset
VPN[2]=511, VPN[1]=1, VPN[0]=3, Offset=0xff8
```

#### 步骤6: 深入页表遍历过程 (第一级页表)

继续单步执行 `get_physical_address` 函数，观察三级页表遍历：

```gdb
Thread 2 "qemu-system-ris" hit Breakpoint 1, get_physical_address (
    env=0x55867bda8230, 
    physical=0x706949ffe290, 
    prot=0x706949ffe284, 
    addr=18446744072637923320, 
    access_type=1,  # 写操作
    mmu_idx=1)
    at target/riscv/cpu_helper.c:158

# 设置临时断点在页表遍历循环入口
(gdb) tbreak 237
Temporary breakpoint 3 at 0x55867acad92e: file target/riscv/cpu_helper.c, line 237.
(gdb) c
Continuing.

Thread 2 "qemu-system-ris" hit Temporary breakpoint 3
237         for (i = 0; i < levels; i++, ptshift -= ptidxbits) {

(gdb) print levels
$14 = 3  # 三级页表

(gdb) print /x base
$15 = 0x80204000  # 页表基址 (从 satp.PPN 提取)
```

**第一级页表查询 (L1: VPN[2]=511)**:

```gdb
(gdb) tbreak 238
(gdb) c
Thread 2 "qemu-system-ris" hit Temporary breakpoint 4
238             target_ulong idx = (addr >> (PGSHIFT + ptshift)) &

(gdb) print i
$16 = 0  # 第一级遍历

(gdb) tbreak 242
(gdb) c
242             target_ulong pte_addr = base + idx * ptesize;

(gdb) tbreak 254
(gdb) c
254             target_ulong ppn = pte >> PTE_PPN_SHIFT;

(gdb) print /x pte
$19 = 0x200000cf  # 读取到的页表项

# 打印调试信息
(gdb) printf "L%d: idx=%ld pte_addr=0x%lx pte=0x%lx ppn=0x%lx\n", \
      i+1, 511, 0x80204ff8, pte, 0x80000
L1: idx=511 pte_addr=0x80204ff8 pte=0x200000cf ppn=0x80000
```

**页表项分析**:
```
PTE = 0x200000cf = 0b 0010 0000 0000 0000 0000 0000 1100 1111
├─ PPN = 0x80000 (bits [53:10])
├─ RSW = 0       (bits [9:8], 保留)
└─ 标志位 (bits [7:0]):
   ├─ D (Dirty) = 1
   ├─ A (Accessed) = 1
   ├─ G (Global) = 0
   ├─ U (User) = 0
   ├─ X (Executable) = 0
   ├─ W (Writable) = 1
   ├─ R (Readable) = 1
   └─ V (Valid) = 1
```

由于 PTE 的 R/W 位均为 1，这是一个**大页映射**(Superpage)，可以直接计算物理地址，无需继续遍历二级和三级页表。

#### 步骤7: 验证最终物理地址

```gdb
(gdb) finish
Run till exit from #0  get_physical_address (...)
    at target/riscv/cpu_helper.c:254
0x000055867acae1bf in riscv_cpu_tlb_fill (...)
    at target/riscv/cpu_helper.c:451

# 查看最终返回的物理地址
(gdb) p /x pa
$22 = 0x80203ff8
```

**物理地址计算** (大页映射):
```
物理地址 = (PPN << 12) | (VPN[1] << 21) | (VPN[0] << 12) | Offset
         = (0x80000 << 12) | (1 << 21) | (3 << 12) | 0xff8
         = 0x80000000 + 0x200000 + 0x3000 + 0xff8
         = 0x80203ff8
```

与虚拟地址 `0xffffffffc0203ff8` 对应，内核直接映射区域 (`0xffffffffc0000000 ~ 0xffffffffc0400000`) 被映射到物理地址 `0x80000000 ~ 0x80400000`。

#### 步骤8: 在 ucore 内核 GDB 中单步执行

切换回终端3 (ucore 内核 GDB)，观察内核代码执行：

```gdb
(gdb) x/8i $pc
=> 0xffffffffc02000d6 <kern_init>:     auipc    a0,0x5
   0xffffffffc02000da <kern_init+4>:   addi     a0,a0,-190
   0xffffffffc02000de <kern_init+8>:   auipc    a2,0x5
   0xffffffffc02000e2 <kern_init+12>:  addi     a2,a2,122
   0xffffffffc02000e6 <kern_init+16>:  addi     sp,sp,-16
   0xffffffffc02000ea <kern_init+20>:  sub      a2,a2,a0
   0xffffffffc02000ec <kern_init+22>:  li       a1,0
   0xffffffffc02000f0 <kern_init+26>:  sd       ra,8(sp)

# 单步执行，观察每条指令对应的虚拟地址访问
(gdb) si
0xffffffffc02000da      30          memset(edata, 0, end - edata);

(gdb) si
0xffffffffc02000de      30          memset(edata, 0, end - edata);

(gdb) si
0xffffffffc02000e2      30          memset(edata, 0, end - edata);
...
```

每次 `si` 执行时，QEMU 内部会进行虚拟地址翻译，可以在终端2观察 TLB 命中或缺失的情况。

## 知识点总结

### 一、本实验涵盖的重要知识点及其与OS原理的对应关系

#### 1. 进程管理核心机制

**实验实现**:
- 进程控制块 (PCB) 的设计与实现 (`struct proc_struct`)
- 进程创建 (`do_fork`)、执行 (`do_execve`)、等待 (`do_wait`)、退出 (`do_exit`)
- 进程状态转换 (`PROC_UNINIT` → `PROC_RUNNABLE` → `RUNNING` → `PROC_SLEEPING` → `PROC_ZOMBIE`)
- 进程树的维护 (`cptr`, `yptr`, `optr` 指针)

**OS原理对应**:
- 进程概念与进程控制块 (PCB)
- 进程生命周期管理
- 进程状态转换模型 (五状态模型)
- 父子进程关系与进程家族树

**理解与分析**:
- **一致性**: 实验中的进程状态转换与OS原理中的五状态模型基本一致,都包含创建、就绪、运行、阻塞、终止等状态
- **差异**: 实验简化了部分状态(如没有"新建"和"挂起"状态),更贴近教学需求
- **深化理解**: 通过实验,理解了PCB不仅仅是数据结构,更是操作系统管理进程的核心抓手,每个字段都有其存在的意义

#### 2. 系统调用机制

**实验实现**:
- 用户态到内核态的切换 (`ecall` 指令 → `__alltraps` → `trap()`)
- 系统调用分发 (`syscall()` 函数根据 `a0` 寄存器分发)
- 参数传递 (通过 `a1-a5` 寄存器)
- 返回值传递 (通过 `tf->gpr.a0`)
- 内核态到用户态的返回 (`__trapret` → `sret` 指令)

**OS原理对应**:
- 系统调用接口与实现
- 陷入机制 (Trap)
- 特权级切换 (用户态 ↔ 内核态)
- 中断/异常处理流程

**理解与分析**:
- **一致性**: 系统调用的本质是软件中断,实验中通过 `ecall` 触发异常,与原理完全吻合
- **差异**: RISC-V 使用 `ecall/sret`,x86 使用 `int/iret`,但原理相同
- **深化理解**: 
  - 系统调用是OS提供服务的唯一合法途径,保证了系统的安全性
  - `trapframe` 的设计精妙,既保存了用户态的全部上下文,又提供了参数传递的通道
  - 返回值通过修改 `trapframe` 中的寄存器实现,体现了"未来式"编程思想

#### 3. 内存管理与地址空间

**实验实现**:
- 虚拟内存空间的复制 (`copy_range`, `dup_mmap`)
- 用户态程序加载 (`load_icode` 解析ELF格式)
- 页表管理 (`get_pte`, `page_insert`, `page_remove`)
- 缺页异常处理 (`do_pgfault`)
- Copy on Write 机制实现

**OS原理对应**:
- 虚拟内存抽象
- 地址空间隔离
- 页表结构与地址翻译
- 请求分页与缺页中断
- 写时复制 (COW) 技术

**理解与分析**:
- **一致性**: 实验实现的虚拟内存机制与原理描述完全对应,包括多级页表、TLB刷新等细节
- **差异**: 
  - 实验使用三级页表 (Sv39),原理课通常以二级页表为例
  - 实验中未实现页面置换算法,所有页面常驻内存
- **深化理解**:
  - 虚拟内存是OS最精妙的设计之一,为每个进程提供了独立的地址空间假象
  - COW 机制展示了"延迟计算"的优化思想,在fork时只共享不复制,写时才真正复制
  - 缺页异常是将"异常"转化为"机制"的典范,不仅处理错误,更是实现高级功能的手段

#### 4. 进程调度

**实验实现**:
- 简单的轮转调度 (`schedule()` 函数)
- 时间片机制 (每100次时钟中断)
- 进程切换 (`proc_run` → `switch_to`)
- 上下文保存与恢复

**OS原理对应**:
- 进程调度算法 (时间片轮转 RR)
- 上下文切换
- 调度时机 (时钟中断、主动让出、阻塞)

**理解与分析**:
- **一致性**: 实验的时间片轮转实现了原理中的RR算法
- **差异**: 实验未实现优先级调度、多级反馈队列等复杂算法
- **深化理解**:
  - 调度的本质是CPU资源的分配,`need_resched` 标志是调度的触发器
  - 上下文切换的开销主要在于寄存器保存/恢复和TLB刷新
  - `switch_to` 的实现非常巧妙,通过修改栈指针和返回地址实现控制流的跳转

#### 5. 同步与互斥

**实验实现**:
- 关中断机制 (`local_intr_save/restore`)
- 锁的初始化 (`lock_init`, `lock/unlock`)
- 原子操作保护关键区域

**OS原理对应**:
- 临界区与互斥
- 同步原语 (锁、信号量)
- 原子操作

**理解与分析**:
- **一致性**: 实验通过禁用中断实现临界区保护,是单处理器系统的经典方法
- **差异**: 实验未实现信号量、条件变量等高级同步原语
- **深化理解**:
  - 关中断是最简单粗暴但有效的同步手段,适用于内核短临界区
  - 在多核系统中,关中断不足以保证同步,需要硬件原子指令支持
  - 同步是并发编程的核心难题,实验中的简化实现为理解高级机制打下基础

#### 6. ELF文件格式与程序加载

**实验实现**:
- ELF文件头解析 (`struct elfhdr`)
- 程序段加载 (`struct proghdr`)
- BSS段初始化 (清零)
- 用户栈建立

**OS原理对应**:
- 可执行文件格式
- 程序加载器
- 内存布局 (代码段、数据段、BSS、堆、栈)

**理解与分析**:
- **一致性**: ELF格式是Linux标准,实验的实现与实际OS一致
- **差异**: 实验中程序预编译进内核,而不是从文件系统加载
- **深化理解**:
  - ELF的设计体现了"数据结构即协议"的思想,header指引加载过程
  - BSS段的设计节省了可执行文件大小(未初始化数据不占文件空间)
  - 用户栈向下增长的设计为堆向上增长留出空间
