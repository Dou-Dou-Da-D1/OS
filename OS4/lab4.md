# <center>Lab4</center>

<center>程娜 张丝童</center>

## 练习1：分配并初始化一个进程控制块（需要编码）

### 问题

alloc_proc函数（位于kern/process/proc.c中）负责分配并返回一个新的struct proc_struct结构，用于存储新建立的内核线程的管理信息。ucore需要对这个结构进行最基本的初始化，你需要完成这个初始化过程。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 请说明proc_struct中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）

### 解答

#### 设计实现

查看 `proc.h` 中的进程结构：

```c
struct proc_struct {
    enum proc_state state;      // 进程状态
    int pid;                    // 进程ID
    int runs;                   // 运行/被调度次数
    uintptr_t kstack;           // 内核栈基址
    volatile bool need_resched; // 是否需要重新调度
    struct proc_struct *parent; // 父进程
    struct mm_struct *mm;       // 内存管理结构（本实验为空）
    struct context context;     // 进程切换保存现场
    struct trapframe *tf;       // 中断/陷阱帧指针
    uintptr_t pgdir;            // 页表物理基地址
    uint32_t flags;             // 进程标志
    char name[PROC_NAME_LEN + 1];
    list_entry_t list_link;
    list_entry_t hash_link;
};
```

在 `alloc_proc` 中完成一次性初始化。结合 `proc.c` 中的实现：

```c
static struct proc_struct *alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
        proc->state = PROC_UNINIT;              // 初始未就绪
        proc->pid = -1;                         // 未分配PID
        proc->runs = 0;                         // 初始运行次数为0
        proc->kstack = 0;                       // 尚未分配内核栈
        proc->need_resched = 0;                 // 不请求调度
        proc->parent = NULL;                    // 尚无父进程
        proc->mm = NULL;                        // 不使用用户态地址空间
        memset(&(proc->context), 0, sizeof(struct context)); // 清空上下文
        proc->tf = NULL;                        // 还没有陷阱帧
        proc->pgdir = boot_pgdir_pa;            // 使用内核初始页表
        proc->flags = 0;                        // 清标志
        memset(proc->name, 0, PROC_NAME_LEN + 1); // 置空名字
    }
    return proc;
}
```

各字段初始化简述：
- state：设为 PROC_UNINIT，标识刚分配尚未进入就绪队列。
- pid：设为 -1，后续在 do_fork 中通过 get_pid 分配唯一合法 PID。
- runs：设为 0，用于统计调度次数。
- kstack：设为 0，后续由 setup_kstack 分配真正的内核栈页。
- need_resched：初始化为 0，表示不主动请求调度。
- parent/mm：均为空，内核线程不使用用户地址空间。
- context：清零，后续 copy_thread / switch_to 会写入有效寄存器现场。
- tf：为空，尚未建立陷阱帧，fork 时 copy_thread 分配并复制。
- pgdir：置为 boot_pgdir_pa，使用内核页表（本实验不创建独立页表）。
- flags/name：清零，后续可由 set_proc_name 赋实际名字。

通过 proc_init 中的自检逻辑（memcmp 等）可以验证初始化结果是否完全符合预期：
```
if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && ... ) {
    cprintf("alloc_proc() correct!\n");
}
```

#### 问题：context 与 trapframe 的含义与作用

1. struct context context  
   保存进程在“协作式上下文切换”时需要保留的寄存器集合（RISC-V 中保存 ra、sp、s0~s11 等被调用者保存寄存器）。在 switch_to(from, to) 调用时：
   - 当前进程的这些寄存器写入其 context
   - 目标进程的 context 恢复到真实寄存器
   这样可以使内核在不同内核线程之间切换执行流而不破坏各自独立的调用栈与返回路径。context 不包含所有整数寄存器（如 a0~a7、t 系列），这些在函数调用约定下由调用者保存，不必冗余存入 context，从而减少切换开销。

2. struct trapframe *tf  
   trapframe 是“异常/中断/陷阱进入”时的现场快照，包含：
   - 通用寄存器组（pushregs：zero、ra、sp、gp、tp、t0~t6、s0~s11、a0~a7）
   - 关键控制寄存器：status（处理器状态）、epc（异常返回地址）、badvaddr（故障地址）、cause（异常原因）
   在内核创建新线程（kernel_thread）或 fork 时：
   - copy_thread 会在新内核栈顶布置一份 trapframe
   - 通过设置 tf->gpr.s0 = 函数指针，tf->gpr.s1 = 参数，以及将 a0 置 0 区分子进程
   - 调度到该线程后，第一条实际执行的指令基于 tf->epc 指向的入口（kernel_thread_entry / forkret）
   trapframe 主要用于“陷阱路径”与“系统调用/异常返回”流程，保证内核能按规范恢复用户/内核态现场。

二者区别与协同：
- context 面向“显式的进程切换”（调度器层面的 switch_to），粒度小，仅保存必要的调用约定中被调用者保存的寄存器。
- trapframe 面向“硬件异常入口与返回”，是一次异常/系统调用的完整寄存器镜像，粒度大。
- 创建内核线程时：先分配 proc，再设置内核栈与 trapframe，再通过 context.ra 指向 forkret，使得调度第一次落入正确执行流。



## 练习2：为新创建的内核线程分配资源（需要编码）

### 问题

创建一个内核线程需要分配和设置好很多资源。kernel_thread函数通过调用**do_fork**函数完成具体内核线程的创建工作。do_kernel函数会调用alloc_proc函数来分配并初始化一个进程控制块，但alloc_proc只是找到了一小块内存用以记录进程的必要信息，并没有实际分配这些资源。ucore一般通过do_fork实际创建新的内核线程。do_fork的作用是，创建当前内核线程的一个副本，它们的执行上下文、代码、数据都一样，但是存储位置不同。因此，我们**实际需要"fork"的东西就是stack和trapframe**。在这个过程中，需要给新内核线程分配资源，并且复制原进程的状态。你需要完成在kern/process/proc.c中的do_fork函数中的处理过程。它的大致执行步骤包括：

- 调用alloc_proc，首先获得一块用户信息块。
- 为进程分配一个内核栈。
- 复制原进程的内存管理信息到新进程（但内核线程不必做此事）
- 复制原进程上下文到新进程
- 将新进程添加到进程列表
- 唤醒新进程
- 返回新进程号

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

- 请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。



### 解答

#### 设计实现

我们按照提示的步骤，在 `do_fork` 函数中完成新内核线程的创建：

- **调用`alloc_proc`，获得一块进程控制块**
  ```c
  if ((proc = alloc_proc()) == NULL) {
      goto fork_out;
  }
  proc->parent = current; // 设置父进程为当前进程
  ```
  首先分配 `proc_struct` 结构。如果失败，则直接退出。成功后，立即将新进程的 `parent` 指针指向当前进程 `current`。

- **为进程分配一个内核栈**
  ```c
  if (setup_kstack(proc) != 0) {
      goto bad_fork_cleanup_proc;
  }
  ```
  调用 `setup_kstack` 为新进程分配内核栈。如果失败，需要跳转到清理标签释放已分配的 `proc_struct`。

- **复制原进程的内存管理信息**
  ```c
  if (copy_mm(clone_flags, proc) != 0) {
      goto bad_fork_cleanup_kstack;
  }
  ```
  调用 `copy_mm`。对于内核线程，此函数基本不做操作，但保留了框架。失败则需清理内核栈和 `proc_struct`。

- **复制原进程上下文到新进程**
  ```c
  copy_thread(proc, stack, tf);
  ```
  调用 `copy_thread` 函数，它负责在新进程的内核栈顶设置 `trapframe`，并初始化 `context`，使得新进程在被调度后能从 `forkret` 开始执行。
  ```c
  static void
  copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
      proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
      *(proc->tf) = *tf;
      proc->tf->gpr.a0 = 0; // 子进程返回值为0
      proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
      proc->context.ra = (uintptr_t)forkret; // 设置返回地址为 forkret
      proc->context.sp = (uintptr_t)(proc->tf); // 设置栈顶为陷阱帧地址
  }
  ```

- **将新进程添加到进程列表**
  ```c
  proc->pid = get_pid();
  hash_proc(proc);
  list_add(&proc_list, &(proc->list_link));
  nr_process++;
  ```
  调用 `get_pid()` 获取一个唯一的PID，然后通过 `hash_proc` 和 `list_add` 将新进程加入到哈希表和全局进程链表中，并递增进程总数 `nr_process`。

- **唤醒新进程**
  ```c
  wakeup_proc(proc);
  ```
  调用 `wakeup_proc` 将新进程的状态从 `PROC_UNINIT` 设置为 `PROC_RUNNABLE`，使其可以被调度器调度。

- **返回新进程号**
  ```c
  ret = proc->pid;
  ```
  最后，将新进程的PID作为返回值赋给 `ret`。

通过以上步骤，我们完整地实现了 `do_fork` 函数，为新创建的内核线程正确分配了所需资源。

#### 问题

我们分析对应的函数get_pid：

```c++
static int
get_pid(void) {
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
        last_pid = 1;
        goto inside;
    }
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
            proc = le2proc(le, list_link);
            if (proc->pid == last_pid) {
                if (++ last_pid >= next_safe) {
                    if (last_pid >= MAX_PID) {
                        last_pid = 1;
                    }
                    next_safe = MAX_PID;
                    goto repeat;
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
}
```

**ucore能够确保为每个新fork的线程分配一个唯一的ID。**

`get_pid` 函数的设计保证了PID的唯一性。其核心逻辑如下：

1.  **PID的生成**：函数内部维护一个静态变量 `last_pid`，用于记录上一次分配的PID。每次调用时，它首先尝试将 `last_pid` 加一作为新的候选PID。如果 `last_pid` 超出 `MAX_PID` 的范围，则会回绕到1。

2.  **唯一性检查**：最关键的步骤是唯一性检查。在确定一个候选PID后，函数会遍历全局进程链表 `proc_list`，检查这个PID是否已经被其他正在运行的进程所占用。

3.  **冲突处理**：如果在遍历过程中发现候选PID `last_pid` 已经被某个进程 `proc` 使用（即 `proc->pid == last_pid`），函数会立即递增 `last_pid` 以产生一个新的候选PID，然后通过 `goto repeat` 语句，从头开始重新遍历整个进程链表，对这个新的候选PID进行唯一性检查。

4.  **循环直到成功**：这个“生成-测试-冲突则重试”的循环会一直持续，直到找到一个在当前所有进程中都未被使用的PID为止。

`next_safe` 变量是一个优化，它记录了遍历中遇到的、比 `last_pid` 大的最小PID。这可以帮助在某些情况下减少不必要的遍历。

综上所述，`get_pid` 通过一个严密的循环检查机制，确保了在分配PID时不会出现重复，因此ucore能够为每个新线程提供一个唯一的ID。

## 练习3：编写proc_run 函数（需要编码）

### 问题

proc_run用于将指定的进程切换到CPU上运行。它的大致执行步骤包括：

- 检查要切换的进程是否与当前正在运行的进程相同，如果相同则不需要切换。
- 禁用中断。你可以使用`/kern/sync/sync.h`中定义好的宏`local_intr_save(x)`和`local_intr_restore(x)`来实现关、开中断。
- 切换当前进程为要运行的进程。
- 切换页表，以便使用新进程的地址空间。`/libs/riscv.h`中提供了`lcr3(unsigned int cr3)`函数，可实现修改CR3寄存器值的功能。
- 实现上下文切换。`/kern/process`中已经预先编写好了`switch.S`，其中定义了`switch_to()`函数。可实现两个进程的context切换。
- 允许中断。

请回答如下问题：

- 在本实验的执行过程中，创建且运行了几个内核线程？

完成代码编写后，编译并运行代码：make qemu

### 解答

#### 设计实现

根据题目要求，我们完成了 `proc_run` 函数的编码，其核心是实现进程上下文的切换。

```c
void
proc_run(struct proc_struct *proc) {
    if (proc != current) {
        bool intr_flag;
        struct proc_struct *prev = current;
        local_intr_save(intr_flag);
        {
            current = proc;
            switch_to(&(prev->context), &(proc->context));
        }
        local_intr_restore(intr_flag);
    }
}
```

代码实现步骤如下：

1.  **检查是否需要切换**：首先判断要运行的进程 `proc` 是否就是当前正在运行的进程 `current`。如果是，则无需任何操作，直接返回。

2.  **保护临界区**：使用 `local_intr_save(intr_flag)` 宏来禁用中断并保存当前的中断状态。这是为了防止在上下文切换的过程中被其他中断打断，从而保证切换的原子性。

3.  **更新当前进程**：将全局变量 `current` 指向新的进程 `proc`。这标志着系统的当前活动进程已经改变。

4.  **执行上下文切换**：调用核心的 `switch_to` 函数，将CPU的执行上下文从上一个进程 (`prev`) 切换到新进程 (`proc`)。`switch_to` 会保存 `prev` 进程的被调用者保存寄存器到 `prev->context` 中，并从 `proc->context` 中恢复新进程的寄存器状态。执行流从此跳转。

5.  **恢复中断状态**：当将来某个时刻，执行流通过 `switch_to` 再次切换回 `prev` 进程时，`switch_to` 返回后的第一条指令就是 `local_intr_restore(intr_flag)`。它会根据之前保存的 `intr_flag` 恢复中断状态。

在这个实现中，我们没有切换页表（如调用 `lsatp`），因为本实验中的所有内核线程共享同一个内核地址空间，所以不需要更换页表。

#### 问题

在本实验的执行过程中，创建且运行了**2个内核线程**：

- **idleproc (PID 0)**：这是系统创建的第一个内核线程。它的主要任务是在系统启动初期完成一系列初始化工作，之后进入一个无限循环。当没有其他可运行的进程时，调度器就会选择 `idleproc` 运行，它会不断检查是否需要调度（`schedule()`），从而让出CPU。

- **initproc (PID 1)**：这是由 `idleproc` 在 `proc_init` 函数中创建的第二个内核线程。它的任务是执行 `init_main` 函数，打印 "Hello world!!" 等信息。当 `init_main` 执行完毕后，`initproc` 线程的生命周期就结束了，并触发 `do_exit`。

因此，总共创建并运行了 `idleproc` 和 `initproc` 这两个内核线程。

## 扩展练习 Challenge

### 问题

1. 说明语句`local_intr_save(intr_flag);....local_intr_restore(intr_flag);`是如何实现开关中断的？

2. 深入理解不同分页模式的工作原理（思考题）
    get_pte()函数（位于`kern/mm/pmm.c`）用于在页表中查找或创建页表项，从而实现对指定线性地址对应的物理页的访问和映射操作。这在操作系统中的分页机制下，是实现虚拟内存与物理内存之间映射关系非常重要的内容。
    - get_pte()函数中有两段形式类似的代码， 结合sv32，sv39，sv48的异同，解释这两段代码为什么如此相像。
    - 目前get_pte()函数将页表项的查找和页表项的分配合并在一个函数里，你认为这种写法好吗？有没有必要把两个功能拆开？



### 解答

1. **`local_intr_save` 和 `local_intr_restore` 的实现原理**

这两个宏配合使用，提供了一种安全地进入和退出临界区（critical section）的方法，其核心是**保存并恢复**而非简单地开关中断。它们的实现依赖于 `sstatus` 寄存器中的 `SIE` (Supervisor Interrupt Enable) 位。

相关定义如下：
```c
static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
        intr_disable();
        return 1;
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    }
}

#define local_intr_save(x) do { x = __intr_save(); } while (0)
#define local_intr_restore(x) __intr_restore(x);
```

**工作流程分析：**

- **`local_intr_save(intr_flag);`**
  1.  该宏调用 `__intr_save()` 函数，并将返回值存入 `intr_flag` 变量。
  2.  `__intr_save()` 首先读取 `sstatus` 寄存器，检查 `SIE` 位。
  3.  **如果 `SIE` 位为1（中断当前是开启的）**：它会调用 `intr_disable()`（该函数会清除 `SIE` 位）来关闭中断，然后返回 `true`。`intr_flag` 因此被赋值为 `true`。
  4.  **如果 `SIE` 位为0（中断当前已是关闭的）**：它不做任何操作，直接返回 `false`。`intr_flag` 因此被赋值为 `false`。
  
  执行完毕后，无论之前中断是开是关，**当前的中断状态都一定是关闭的**，并且 `intr_flag` 中保存了**进入临界区之前的中断状态**。

- **`local_intr_restore(intr_flag);`**
  1.  该宏调用 `__intr_restore()` 函数，并传入之前保存的 `intr_flag`。
  2.  `__intr_restore()` 检查 `intr_flag` 的值。
  3.  **如果 `intr_flag` 为 `true`**：说明在进入临界区前中断是开启的，因此函数调用 `intr_enable()`（该函数会设置 `SIE` 位）来重新开启中断。
  4.  **如果 `intr_flag` 为 `false`**：说明在进入临界区前中断就是关闭的，因此函数什么也不做，保持中断关闭的状态。

**总结：**
这一对宏并非简单地“开”和“关”，而是实现了“**保存并关闭**”和“**根据保存的状态恢复**”的逻辑。这种设计非常重要，因为它能正确处理嵌套的临界区。例如，如果一个已经关闭中断的函数调用了另一个使用这对宏的函数，内层函数退出时不会错误地开启中断，从而保证了程序的正确性。

2. **关于 `get_pte` 函数的思考**

   - **两段代码为何如此相像？**
     
     RISC-V架构的Sv32、Sv39、Sv48分页模式虽然支持的虚拟地址和物理地址宽度不同，但它们都采用了**多级页表**的共同设计思想。无论是哪种模式，地址翻译的过程都是一个**迭代的、树状的遍历过程**。
     
     `get_pte` 函数中的两段相似代码，正是这种迭代思想的体现。在我们的实验（基于Sv39）中：
     1.  第一段代码通过顶级页目录（`pgdir`）和虚拟地址的最高位索引（`PDX1(la)`）来查找**一级页表（L1 Page Table）**的页目录项（PDE）。如果该页表不存在（`PTE_V`位为0），则分配一个新的物理页作为下一级页表。
     2.  第二段代码通过上一步找到的一级页表基址和虚拟地址的次高位索引（`PDX0(la)`）来查找**零级页表（L0 Page Table）**的页目录项。同样，如果该页表不存在，则分配一个新的物理页。
     
     这两段代码的逻辑是完全相同的：**“根据当前页表基址和地址索引，查找下一级页表的页表项；如果不存在且需要创建，则分配一页内存作为下一级页表，并填充当前页表项”**。
     
     这种相似性源于多级页表结构的**递归/迭代**特性。对于更深层级的页表（如Sv48），我们只需重复这个逻辑即可。因此，这两段代码高度相似是多级页表机制内在结构一致性的直接反映。

   - **合并查找与分配功能是否是好的设计？**

     将查找和分配功能合并在 `get_pte` 一个函数中，并通过 `create` 标志来控制行为，是一种在操作系统内核中常见且实用的设计模式。它有利有弊：

     **优点：**
     1.  **代码紧凑，调用方便**：对于最常见的“查找，如果不存在则创建”的场景（例如 `page_insert` 函数），调用者只需一次函数调用即可完成，非常简洁。
     2.  **性能**：避免了两次函数调用（一次查找，一次创建）的开销，并且地址翻译的中间结果（如上一级页表的地址）可以被复用，减少了重复的地址计算。

     **缺点：**
     1.  **函数职责不单一**：该函数混合了“只读”的查找操作和“有副作用”的分配操作，违反了单一职责原则。这可能使代码的意图不那么清晰。
     2.  **潜在风险**：调用者必须非常小心地传递 `create` 参数。如果在一个只期望查找的场景中错误地将 `create` 置为 `true`，可能会意外地分配内存，导致难以发现的bug。

     **是否有必要拆分？**

     拆分成两个独立的函数，如 `find_pte`（只查找）和 `alloc_pte`（查找并创建），在设计上会更清晰，接口更安全。
     - `find_pte`：保证只读，绝不分配内存。
     - `alloc_pte`：内部可以调用 `find_pte`，如果找不到再执行分配逻辑。

     然而，在当前的内核实现中，`get_pte` 的使用场景非常明确，调用者（如 `page_insert` 和 `page_remove`）都清楚地知道何时应该创建页表。因此，当前的设计虽然在理论上不够“纯粹”，但在实践中是**高效且可接受的**。是否拆分更多地取决于项目的编码规范和对接口安全性的要求。对于一个精简的教学内核，当前的设计是完全合理的。

## 实验结果

![实验结果](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS4/images/1.png)
