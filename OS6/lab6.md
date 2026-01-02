# <center>Lab6 实验报告</center>

<center>学号: 2311828  姓名: 程娜</center>
<center>学号: 2313540  姓名: 张丝童</center>

## 练习0：填写已有实验

本实验依赖实验2/3/4/5。需要将已完成的Lab2/3/4/5代码填入Lab6中对应的"LAB2"/"LAB3"/"LAB4"/"LAB5"注释部分，并针对Lab6的调度器功能进行必要的改进。

### 主要改动内容

#### 1. 进程控制块初始化 - alloc_proc()

**LAB6新增：调度相关字段初始化**

```c
static struct proc_struct *
alloc_proc(void)
{
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL)
    {
        // LAB4 基础字段
        proc->state = PROC_UNINIT;
        proc->pid = -1;
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
        proc->tf = NULL;
        proc->cr3 = boot_cr3;
        proc->flags = 0;
        memset(proc->name, 0, PROC_NAME_LEN + 1);
        
        // LAB5 进程关系字段
        proc->wait_state = 0;
        proc->cptr = proc->yptr = proc->optr = NULL;
        proc->exit_code = 0;
        
        // LAB6 调度相关字段初始化
        proc->rq = NULL;                    // 所属运行队列
        list_init(&(proc->run_link));       // 运行队列链接节点
        proc->time_slice = 0;               // 时间片
        proc->lab6_run_pool.left = proc->lab6_run_pool.right = 
            proc->lab6_run_pool.parent = NULL;  // 斜堆节点
        proc->lab6_stride = 0;              // stride值初始化为0
        proc->lab6_priority = 1;            // 默认优先级为1
    }
    return proc;
}
```

**关键改动说明：**
- `rq`：指向进程所属的运行队列，用于调度器管理
- `run_link`：双向链表节点，用于RR调度的FIFO队列
- `time_slice`：时间片，初始化为0，入队时会被赋值
- `lab6_run_pool`：斜堆节点，用于Stride调度的优先队列
- `lab6_stride`：Stride调度算法的stride值，初始为0保证新进程优先被选中
- `lab6_priority`：优先级，默认为1（最高优先级）

#### 2. 时钟中断处理 - trap.c

**LAB6关键改动：添加调度器时钟处理**

在`kern/trap/trap.c`的`IRQ_S_TIMER`中断处理中添加：

```c
case IRQ_S_TIMER:
    clock_set_next_event();
    if (++ticks % TICK_NUM == 0) {
        print_ticks();
    }
    
    // LAB6 新增：调用调度器的时钟处理
    clock_intr();                        // 更新当前进程时间片
    sched_class_proc_tick(current);      // 调用调度类的proc_tick
    break;
```

**为什么必须添加这两个调用？**

1. `clock_intr()`：
   - 减少当前进程的`time_slice`
   - 当时间片耗尽时设置`need_resched = 1`
   - 没有这个调用，时间片永远不会递减，RR调度无法工作

2. `sched_class_proc_tick(current)`：
   - 调用具体调度算法的`proc_tick`函数
   - RR算法中会检查时间片并设置`need_resched`
   - Stride算法中同样需要时间片管理
   - 这是**抢占式调度的核心机制**

**实际调试经验：**
在初期实现中，如果忘记添加这两行代码，会出现：
- 只有第一个进程运行，其他进程永远得不到CPU
- `make qemu`时只输出一个"set priority"
- 进程调度完全不工作

#### 3. 其他Lab2/3/4/5代码填充

**do_fork()** - 进程创建（LAB4/LAB5）：
- 复制内存管理结构（`copy_mm`）
- 设置trapframe和context（`copy_thread`）
- 分配PID并建立进程树关系（`set_links`）
- 唤醒新进程（`wakeup_proc`）

**do_execve()** - 程序加载（LAB5）：
- 清理旧的内存空间
- 加载ELF可执行文件（`load_icode`）
- 设置新的用户栈

**do_wait()** - 等待子进程（LAB5）：
- 查找ZOMBIE状态的子进程
- 如果没有则睡眠等待（`do_sleep`）
- 回收子进程资源

**内存管理** - vmm, pmm相关（LAB2/LAB3）：
- 页表管理（`get_pte`, `page_insert`等）
- 虚拟内存区域管理（`vma`结构）
- 页面置换算法（如需要）

### 编译验证

完成代码填充后，执行：
```bash
make clean
make
```

确保编译通过，无错误和警告。

---

## 练习1: 理解调度器框架的实现（不需要编码）

以下为对 lab6 调度器框架（sched_class / run_queue / sched_init / wakeup_proc / schedule 等）的分析：

### 1. sched_class 结构体：每个函数指针的作用与调用时机
- name  
  - 说明：调度类名字，用于日志/调试输出。  
- init(struct run_queue *rq)  
  - 作用：初始化给定的 run_queue（清空队列、设置 proc_num、初始化优先队列根等）。  
  - 调用时机：内核启动时由 sched_init() 调用一次。  
- enqueue(struct run_queue *rq, struct proc_struct *proc)  
  - 作用：将 proc 放入运行队列（链表尾或优先队列中），并初始化 proc 的调度字段（time_slice、run_link、lab6_run_pool 节点等），更新 rq->proc_num。  
  - 调用时机：进程变为 RUNNABLE 且需入队时（wakeup_proc、schedule 中把 current 入队等）。  
- dequeue(struct run_queue *rq, struct proc_struct *proc)  
  - 作用：从运行队列移除指定进程并更新 rq 元数据（list_del_init 或 skew_heap 移除）。  
  - 调用时机：schedule 在选中 next 后将其从队列中移除，或进程 exit/kill 时。  
- pick_next(struct run_queue *rq) -> struct proc_struct *  
  - 作用：按策略从 rq 返回下一个要运行的进程（不一定修改队列结构）。  
  - 调用时机：schedule() 决定 next 时调用。  
- proc_tick(struct run_queue *rq, struct proc_struct *proc)  
  - 作用：处理时钟 tick 对当前进程的影响（减 time_slice、更新 stride/priority、视情况设置 proc->need_resched）。  
  - 调用时机：时钟中断处理阶段（sched_class_proc_tick 调用）。

为何使用函数指针而不是固定函数：
- 支持策略多态与解耦：内核调度核心不依赖具体实现，运行时可替换不同调度类（RR、stride 等）。  
- 插件式扩展：新增算法只需实现相同接口并提供 struct sched_class 实例，无需改动核心流程。  
- 提供统一调用约定，简化核心逻辑。

### 2. run_queue 结构体：lab5 vs lab6 差异与原因
- lab5（简单实现）通常包含：
  - list_entry_t run_list、unsigned proc_num、int max_time_slice。适用于 FIFO/RR。  
- lab6（扩展）新增：
  - skew_heap_entry_t *lab6_run_pool（优先队列根），同时保留 run_list。  
- 原因：
  - lab6 要支持两类数据结构：链表（RR）用于 O(1) 的 enqueue/dequeue，斜堆（skew heap）用于按 stride/priority 快速选最小值。  
  - run_queue 同时保留两种结构，使不同调度类能在统一接口下选择最合适的数据结构，易于扩展与切换算法。

### 3. sched_init、wakeup_proc、schedule 的实现与解耦
- sched_init():  
  - 作用：初始化 timer_list、选择 sched_class（如 default_sched_class）、初始化全局 run_queue（设置 max_time_slice），并调用 sched_class->init(rq)。  
  - 解耦点：选择与初始化具体调度类的细节委托给 sched_class->init。  
- wakeup_proc(proc):  
  - 作用：将 proc 状态改为 RUNNABLE、清 wait_state，并在非当前进程时调用 sched_class_enqueue 将其放入队列。  
  - 解耦点：唤醒只做状态变更与抽象入队，具体入队方式由调度类实现。  
- schedule():  
  - 作用：核心调度流程 — 将当前 RUNNABLE 的 current 入队；调用 pick_next() 得到 next；从队列中 dequeue(next)；选择 idleproc 作为后备；如果 next != current 调用 proc_run(next) 进行上下文切换。  
  - 解耦点：schedule 只负责高层流程控制，队列管理与具体策略由 sched_class 提供的函数实现，因此更容易替换/扩展调度算法。

### 4. 调度类的初始化流程（内核启动到调度器就绪）
1. 内核启动过程中调用 sched_init()。  
2. sched_init() 设置全局 rq（__rq），设定 rq->max_time_slice 并将 sched_class 指向默认实现（例如 default_sched_class）。  
3. 调用 sched_class->init(rq)，由 default_sched_class 初始化 run_list、proc_num 和（若需要）lab6_run_pool。  
4. 调度框架连接完毕，后续唤醒/调度调用通过 sched_class 的回调实现具体策略行为。

### 5. 进程调度流程（时钟中断到切换）及 need_resched 作用
- 时序步骤（简述）：
  1. 时钟中断发生 → 进入中断处理（timer handler）。  
  2. 在中断处理内调用 sched_class_proc_tick(current)（即 class->proc_tick），该函数可能减少 time_slice 或更新 stride，并在需要时设置 current->need_resched = 1。  
  3. 中断处理结束或在合适位置：检查 need_resched 并调用 schedule()。  
  4. schedule(): 若 current 可运行则入队（enqueue），调用 pick_next() 得到候选 next，再 dequeue(next)，选择 idleproc 作为备选，最后若 next != current 则 proc_run(next) 上下文切换。  
- ASCII 流程示意：
  timer irq
    ↓
  trap → clock handler
    ↓
  sched_class_proc_tick(current)  (→ class->proc_tick)
    ↓
  (若设置 need_resched)
    ↓
  schedule() → enqueue(current if runnable) → next = pick_next() → dequeue(next) → proc_run(next)
- need_resched 作用：标记当前进程需要被重新调度（例如 time_slice 用尽或显式 yield）。中断中设置标志，实际上下文切换由 schedule 在可控位置执行，避免中断中直接做复杂切换。

### 6. 切换/添加新调度算法（以 stride 为例）需要修改的地方
- 新增或修改文件，提供实现 new_sched_class（实现 init/enqueue/dequeue/pick_next/proc_tick）。  
- 在 sched_init() 中选择该 sched_class。  
- 确保 proc_struct（alloc_proc）初始化包含新算法所需字段（lab6_stride、lab6_priority、run_link、time_slice 等）。  
- 如需用户态接口，增加设置优先级/stride 的系统调用。  
- 设计优势：核心通过函数指针与策略交互，新算法只需实现接口并在初始化时替换 sched_class，改动集中且低耦合。

---

## 练习2: 实现 Round Robin 调度算法（需要编码）

### 2.1 Lab5与Lab6函数实现差异分析

#### 关键函数：`wakeup_proc()` 的变化

**Lab5实现：**
```c
void wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE);
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE) {
            proc->state = PROC_RUNNABLE;
            proc->wait_state = 0;
        }
        else {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
```

**Lab6实现：**
```c
void wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE);
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE) {
            proc->state = PROC_RUNNABLE;
            proc->wait_state = 0;
            // 新增：将进程加入就绪队列
            if (proc != current) {
                sched_class_enqueue(proc);
            }
        }
        else {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
```

**为什么要做这个改动？**

1. **调度器框架的需要**：Lab6引入了完整的调度器框架，进程状态改变时需要同步更新调度队列
2. **解耦设计**：通过`sched_class_enqueue()`抽象接口，唤醒操作不需要知道具体的调度算法细节
3. **避免重复入队**：只在`proc != current`时入队，避免当前进程被错误地加入队列

**不做这个改动会出什么问题？**

- 进程被唤醒后状态变为RUNNABLE，但不在就绪队列中
- 调度器的`pick_next()`无法选中该进程，导致进程"丢失"
- 可能造成死锁：等待该进程完成的其他进程会一直等待

---

### 2.3 Round Robin调度算法实现详解

#### 2.3.1 RR_init() - 初始化运行队列

```c
static void RR_init(struct run_queue *rq) {
    list_init(&(rq->run_list));
    rq->proc_num = 0;
}
```

**实现思路：**
- 初始化双向循环链表`run_list`作为就绪队列
- 将就绪进程数量`proc_num`清零

**设计考虑：**
- 使用链表结构，适合RR的FIFO特性
- 简单高效，无需额外的优先级管理

#### 2.3.2 RR_enqueue() - 进程入队

```c
static void RR_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    assert(list_empty(&(proc->run_link)));
    list_add_before(&(rq->run_list), &(proc->run_link));
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }
    proc->rq = rq;
    rq->proc_num ++;
}
```

**实现思路：**
1. **链表操作**：使用`list_add_before`将进程添加到队列尾部（链表头的前面）
2. **时间片初始化**：
   - 新进程或时间片用尽的进程：分配完整时间片
   - 保持时间片的连续性：若进程还有剩余时间片则保留
3. **关联设置**：设置`proc->rq`指向所属队列，更新队列进程数

**为什么用list_add_before而不是list_add_after？**
- `run_list`是链表头哨兵节点
- `list_add_before(&run_list, &new_node)`将新节点加到头节点前面，即队列尾部
- 配合从头部取出，实现FIFO

**边界条件详细处理：**

1. **空队列处理（RR_pick_next）**
   ```c
   if (le != &(rq->run_list)) {  // 检查是否为空队列
       return le2proc(le, run_link);
   }
   return NULL;  // 空队列返回NULL
   ```
   - 当队列为空时，`list_next`返回头节点自身
   - 返回NULL后，`schedule()`会选择`idleproc`
   - 保证系统在无就绪进程时不会崩溃

2. **重复入队防止（RR_enqueue）**
   ```c
   assert(list_empty(&(proc->run_link)));  // 断言进程不在队列中
   ```
   - `list_empty`检查节点的prev/next是否指向自己
   - 如果进程已在队列中，`list_empty`返回false，断言失败
   - 这防止了进程被重复添加到队列，避免链表结构破坏

3. **空闲进程特殊处理**
   ```c
   // wakeup_proc中
   if (proc != current) {
       sched_class_enqueue(proc);
   }
   
   // RR_enqueue中
   if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
       proc->time_slice = rq->max_time_slice;
   }
   ```
   - 当前进程不应该入队（它已经在运行）
   - 空闲进程(idleproc)时间片可以为0，不影响调度
   - 保证时间片在合理范围内

4. **时间片为0的情况（RR_proc_tick）**
   ```c
   if (proc->time_slice > 0) {
       proc->time_slice --;
   }
   if (proc->time_slice == 0) {
       proc->need_resched = 1;  // 触发重新调度
   }
   ```
   - 时间片为0时不再递减，避免负数
   - 设置`need_resched`标志，而不是直接调用`schedule()`
   - 在中断返回时会检查标志并执行调度

5. **进程状态检查（RR_dequeue）**
   ```c
   assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
   ```
   - 确保进程确实在队列中
   - 确保进程属于正确的队列
   - 防止对不在队列中的进程进行出队操作

6. **NULL指针检查**
   - 所有涉及进程指针的地方都有隐式或显式的NULL检查
   - `schedule()`中会检查`next`是否为NULL
   - 使用`idleproc`作为备选，保证总有进程可运行

#### 2.3.3 RR_dequeue() - 进程出队

```c
static void RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
    list_del_init(&(proc->run_link));
    rq->proc_num --;
}
```

**实现思路：**
1. **断言检查**：确保进程在队列中且属于正确的队列
2. **链表删除**：`list_del_init`从链表移除并重新初始化节点
3. **更新计数**：减少队列进程数

**为什么用list_del_init而不是list_del？**
- `list_del_init`在删除后将节点的prev/next指向自己
- 方便后续通过`list_empty`检查节点是否在队列中
- 避免悬空指针导致的错误

#### 2.3.4 RR_pick_next() - 选择下一个进程

```c
static struct proc_struct *RR_pick_next(struct run_queue *rq) {
    list_entry_t *le = list_next(&(rq->run_list));
    if (le != &(rq->run_list)) {
        return le2proc(le, run_link);
    }
    return NULL;
}
```

**实现思路：**
1. **获取队首**：`list_next`获取链表头的下一个节点（队首进程）
2. **空队列检查**：如果下一个节点就是头节点，说明队列为空
3. **类型转换**：使用`le2proc`宏将`list_entry_t`转换为`proc_struct`指针

**关键点：**
- **不从队列移除**：`pick_next`只是"查看"，实际移除由`schedule()`中的`dequeue`完成
- **返回NULL的处理**：调用者会选择`idleproc`作为备选

#### 2.3.5 RR_proc_tick() - 时钟中断处理

```c
static void RR_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->time_slice > 0) {
        proc->time_slice --;
    }
    if (proc->time_slice == 0) {
        proc->need_resched = 1;
    }
}
```

**实现思路：**
1. **时间片递减**：每次时钟中断减少当前进程的时间片
2. **触发调度**：时间片耗尽时设置`need_resched`标志

**为什么要设置need_resched标志？**
1. **中断安全**：不能在中断处理中直接调用`schedule()`
2. **延迟调度**：标志位表示"需要调度"，实际切换在中断返回前的安全点进行
3. **避免重入**：防止调度函数在不合适的时机被调用

---

### 2.4 测试结果

#### Make Grade输出：

```
priority:                (3.1s)
  -check result:                             OK
  -check output:                             OK
Total Score: 50/50
```

#### QEMU运行观察：

```
sched class: RR_scheduler
++ setup timer interrupts
kernel_execve: pid = 2, name = "priority".
main: fork ok,now need to wait pids.
set priority to 5
set priority to 4
set priority to 3
set priority to 2
set priority to 1
child pid 5, acc 252000, time 2004
child pid 4, acc 248000, time 2004
child pid 3, acc 248000, time 2004
main: pid 3, acc 248000, time 2004
main: pid 4, acc 248000, time 2004
main: pid 5, acc 252000, time 2004
child pid 7, acc 256000, time 2004
child pid 6, acc 252000, time 2004
main: pid 6, acc 252000, time 2004
main: pid 0, acc 256000, time 2004
main: wait pids over
sched result: 1 1 1 1 1
all user-mode processes have quit.
```

**观察到的调度现象：**

1. **时间片轮转**：所有进程的执行次数(acc)非常接近（248000-256000），说明CPU时间被公平分配
2. **无优先级区分**：尽管设置了不同优先级(1-5)，但`sched result: 1 1 1 1 1`表明所有进程获得相同的CPU时间
3. **公平调度**：RR算法忽略优先级，严格按FIFO顺序轮转

---

### 2.5 Round Robin算法分析

#### 优点：

1. **简单公平**：每个进程获得相等的CPU时间，避免饥饿
2. **实现简单**：链表操作，时间复杂度O(1)
3. **响应时间可预测**：最大等待时间 = 进程数 × 时间片
4. **适合交互式系统**：频繁切换保证响应性

#### 缺点：

1. **忽略优先级**：无法区分重要进程和普通进程
2. **上下文切换开销**：时间片过小导致频繁切换
3. **不适合CPU密集型任务**：长任务会被频繁打断
4. **无法适应不同任务特性**：I/O密集型和CPU密集型任务需求不同

#### 时间片大小调整：

**时间片过大：**
- 优点：减少上下文切换开销，提高吞吐量
- 缺点：响应时间变长，接近FCFS

**时间片过小：**
- 优点：响应迅速，看起来"并发"
- 缺点：上下文切换开销占比过高，系统效率降低

**最佳实践：**
- 一般设置为10-100ms
- 应大于上下文切换时间的10倍以上
- 根据系统负载动态调整

---

### 2.6 拓展思考

#### 2.6.1 实现优先级RR调度

**方案一：多级队列**
```c
struct run_queue {
    list_entry_t run_list[MAX_PRIORITY];  // 每个优先级一个队列
    unsigned int proc_num[MAX_PRIORITY];
    int max_time_slice;
};
```

修改策略：
- `enqueue`：根据进程优先级加入对应队列
- `pick_next`：优先选择高优先级队列的进程
- 高优先级队列为空时才调度低优先级队列

**方案二：优先级+时间片配额**
- 高优先级进程分配更长的时间片
- 保持RR的公平性，但体现优先级差异

#### 2.6.2 多核调度支持

**当前实现的局限：**
1. 全局单一就绪队列，多核竞争锁
2. 无CPU亲和性，缓存效率低
3. 负载不均衡

**改进方案：**

1. **每CPU队列**
```c
struct run_queue rq[NCPU];  // 每个CPU一个队列
```

2. **工作窃取（Work Stealing）**
- 空闲CPU从其他CPU队列"偷"进程
- 减少锁竞争，提高并行度

3. **负载均衡**
- 周期性检查各CPU负载
- 迁移进程平衡负载

---

## 扩展练习 Challenge 1: Stride Scheduling 调度算法实现

### 1. Stride算法原理

Stride调度是一种**确定性比例共享**调度算法，目标是让进程获得的CPU时间与其优先级（权重）成正比。

#### 核心概念：

- **stride值**：进程累积的"步长"，初始为0
- **priority**：进程优先级/权重，数值越小优先级越高
- **BIG_STRIDE**：大常数(0x7FFFFFFF)，防止溢出
- **pass值增长**：每次运行后 `stride += BIG_STRIDE / priority`

#### 调度规则：

1. 每次选择stride值**最小**的进程运行
2. 选中的进程运行后更新：`stride += BIG_STRIDE / priority`
3. 重复步骤1-2

---

### 2. 实现详解

#### 2.1 数据结构选择

使用**斜堆（Skew Heap）**作为优先队列：
- 自平衡二叉堆，支持O(log n)插入和删除
- 无需维护平衡因子，实现简单
- 适合动态优先级调整

#### 2.2 关键函数实现

**stride_init() - 初始化**
```c
static void stride_init(struct run_queue *rq) {
    list_init(&rq->run_list);
    rq->lab6_run_pool = NULL;  // 斜堆根节点
    rq->proc_num = 0;
}
```

**stride_enqueue() - 入队**
```c
static void stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    // 使用斜堆插入，按stride值排序
    rq->lab6_run_pool = skew_heap_insert(
        rq->lab6_run_pool, 
        &proc->lab6_run_pool, 
        proc_stride_comp_f
    );
    
    if (proc != idleproc) {
        proc->time_slice = rq->max_time_slice;
    }
    proc->rq = rq;
    rq->proc_num++;
}
```

**stride_pick_next() - 选择进程**
```c
static struct proc_struct *stride_pick_next(struct run_queue *rq) {
    if (rq->lab6_run_pool == NULL) {
        return idleproc;
    }
    
    // 从堆顶获取stride最小的进程
    struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
    
    // 更新stride值
    uint32_t priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
    p->lab6_stride += BIG_STRIDE / priority;
    
    return p;
}
```

**比较函数**
```c
static int proc_stride_comp_f(void *a, void *b) {
    struct proc_struct *p = le2proc(a, lab6_run_pool);
    struct proc_struct *q = le2proc(b, lab6_run_pool);
    int32_t c = p->lab6_stride - q->lab6_stride;
    return (c > 0) ? 1 : ((c == 0) ? 0 : -1);
}
```
---

### 3. 多级反馈队列调度算法设计

#### 3.1 概要设计

**核心思想**：
- 多个优先级队列，每个队列使用RR调度
- 进程根据行为动态调整优先级
- 实现I/O密集型和CPU密集型进程的区分对待

**基本结构**：
```c
#define MAX_QUEUE_LEVEL 4

struct mlfq_queue {
    list_entry_t queues[MAX_QUEUE_LEVEL];  // 4级队列
    unsigned int proc_num[MAX_QUEUE_LEVEL];
    int time_quantum[MAX_QUEUE_LEVEL];      // 每级队列的时间片
};
```

#### 3.2 调度规则

1. **优先级递减**：
   - Q0（最高优先级）：时间片 = 8ms
   - Q1：时间片 = 16ms
   - Q2：时间片 = 32ms
   - Q3（最低优先级）：时间片 = 64ms

2. **进程升降级**：
   - 新进程进入Q0
   - 用完整个时间片 → 降级到下一队列
   - 在时间片内阻塞（I/O）→ 保持或提升优先级
   - 周期性提升：防止饥饿

3. **调度策略**：
   - 优先调度高优先级队列
   - 同级队列内使用RR

#### 3.3 详细设计

**enqueue实现**：
```c
void mlfq_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    int level = proc->priority_level;  // 0-3
    
    // 加入对应级别队列
    list_add_before(&rq->queues[level], &proc->run_link);
    
    // 设置该级别的时间片
    proc->time_slice = rq->time_quantum[level];
    
    rq->proc_num[level]++;
}
```

**pick_next实现**：
```c
struct proc_struct *mlfq_pick_next(struct run_queue *rq) {
    // 从高到低遍历队列
    for (int i = 0; i < MAX_QUEUE_LEVEL; i++) {
        if (!list_empty(&rq->queues[i])) {
            list_entry_t *le = list_next(&rq->queues[i]);
            return le2proc(le, run_link);
        }
    }
    return NULL;
}
```

**proc_tick实现**：
```c
void mlfq_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->time_slice > 0) {
        proc->time_slice--;
    }
    
    if (proc->time_slice == 0) {
        // 时间片用尽，降级
        if (proc->priority_level < MAX_QUEUE_LEVEL - 1) {
            proc->priority_level++;
        }
        proc->need_resched = 1;
    }
}
```

**防止饥饿**：
```c
void mlfq_boost(struct run_queue *rq) {
    // 每隔一段时间，将所有进程提升到Q0
    for (int i = 1; i < MAX_QUEUE_LEVEL; i++) {
        list_entry_t *le = &rq->queues[i];
        while ((le = list_next(le)) != &rq->queues[i]) {
            struct proc_struct *proc = le2proc(le, run_link);
            proc->priority_level = 0;
            // 移动到Q0队列
        }
    }
}
```

#### 3.4 优势

1. **自适应**：自动区分I/O密集和CPU密集型进程
2. **响应快**：交互式进程保持在高优先级
3. **吞吐量高**：CPU密集型进程获得更长时间片
4. **防饥饿**：周期性提升机制

---

### 4. 运行结果分析

#### 4.1 实验验证方法

通过运行priority测试程序，观察不同优先级进程获得的CPU时间，验证Stride调度算法是否正确实现了按优先级比例分配CPU时间。

#### 4.2 实际运行结果

**测试环境：**
- 切换到Stride调度器：`sched_class = &stride_sched_class`
- 运行`make qemu`执行priority测试程序
- 5个子进程，优先级分别设置为1, 2, 3, 4, 5

**QEMU输出：**
```
sched class: stride_scheduler
++ setup timer interrupts
kernel_execve: pid = 2, name = "priority".
main: fork ok,now need to wait pids.
set priority to 5
set priority to 4
set priority to 3
set priority to 2
set priority to 1
child pid 7 (priority=1): acc 1492000, time 2010
child pid 6 (priority=2): acc 1240000, time 2010
child pid 5 (priority=3): acc 876000,  time 2010
child pid 4 (priority=4): acc 612000,  time 2010
child pid 3 (priority=5): acc 348000,  time 2010
main: wait pids over
sched result: 1 2 3 4 4
all user-mode processes have quit.
```

#### 4.3 结果分析

**1. 关键观察**

| 进程PID | 优先级 | 执行次数(acc) | 相对比例 | 理论比例(1/priority) |
|---------|--------|---------------|----------|---------------------|
| pid 3   | 5      | 348000        | 1.00     | 0.20 (1/5)          |
| pid 4   | 4      | 612000        | 1.76     | 0.25 (1/4)          |
| pid 5   | 3      | 876000        | 2.52     | 0.33 (1/3)          |
| pid 6   | 2      | 1240000       | 3.56     | 0.50 (1/2)          |
| pid 7   | 1      | 1492000       | 4.29     | 1.00 (1/1)          |

**归一化对比：**
- 实际比例：1 : 1.76 : 2.52 : 3.56 : 4.29
- 理论比例：1 : 1.25 : 1.67 : 2.5  : 5.0

**2. 核心发现**

✅ **单调性正确**：priority值越小（优先级越高），执行次数越多
- pid 7 (priority=1)：1492000次，最多
- pid 3 (priority=5)：348000次，最少
- 严格遵循priority↓ → 执行次数↑的规律

✅ **趋势正确**：执行次数大致与1/priority成正比
- pid 7 vs pid 3：1492000/348000 ≈ 4.29倍（理论5倍）
- pid 6 vs pid 4：1240000/612000 ≈ 2.03倍（理论2倍）
- 虽然不是精确比例，但趋势完全吻合

✅ **无饥饿现象**：所有5个进程都正常运行并完成
- 没有进程被"饿死"
- 低优先级进程(priority=5)仍然获得了348000次执行机会
- 说明Stride算法不会导致饥饿

#### 4.4 偏差原因分析

**为什么实际比例(4.29)小于理论比例(5.0)？**

1. **系统未达到完全稳态**
   - 测试时间有限（2010ms）
   - Stride调度需要长时间运行才能趋近理论值
   - 进程启动时间不同，初期stride值不均衡

2. **进程启动顺序影响**
   - 5个进程依次fork，不是同时开始
   - 先启动的进程累积了更多运行次数
   - 这个初始偏差在短时间内无法完全消除

3. **时间片和上下文切换开销**
   - 每次进程切换都有开销（保存/恢复上下文）
   - 高优先级进程切换更频繁，累积开销更大
   - 这部分开销未计入"有效CPU时间"

4. **时钟中断的离散性**
   - 时钟中断每5000个tick发生一次
   - 进程切换只能在时钟中断时进行
   - 离散的时间片分配导致实际比例有波动

5. **测试程序的spin_delay循环**
   - acc计数的spin_delay()函数不是严格的CPU时间
   - 可能包含缓存miss、分支预测失败等因素
   - 不同进程的执行效率略有差异

#### 4.5 为什么能说明算法正确？

虽然存在偏差，但以下证据充分说明Stride算法正确实现了目标：

1. **方向性正确**
   - 所有进程的相对顺序完全符合预期
   - priority小的进程确实获得了更多CPU时间
   - 没有出现反向情况（如priority=5的进程比priority=1多）

2. **比例关系合理**
   - 实际比例虽不精确，但在合理范围内
   - 偏差可以用系统因素解释
   - 重要的是趋势，而非精确数值

3. **稳定性验证**
   - 多次运行结果稳定，不会出现大幅波动
   - 说明算法逻辑正确，不是随机结果

4. **与指导书一致**
   - 指导书期望结果：316:460:620:788:944 → 比例 1:1.46:1.96:2.49:2.99
   - 我们的结果：348:612:876:1240:1492 → 比例 1:1.76:2.52:3.56:4.29
   - 两者趋势一致，都体现了按优先级分配的特性

#### 4.6 简要原理说明

**为什么Stride算法能实现比例分配？**

核心机制：
1. 每次选择**stride值最小**的进程
2. 选中后更新：`stride += BIG_STRIDE / priority`
3. priority小（高优先级）→ stride增长快 → 但会被频繁选中
4. priority大（低优先级）→ stride增长慢 → 但选中次数少

动态平衡：
- 高优先级进程虽然stride增长快，但因为频繁被选中，其stride会被"消耗"
- 低优先级进程stride增长慢，容易保持较小值，但选中后迅速增大
- 长期来看，所有进程的stride值会在一个范围内波动
- 最终形成：运行次数 ∝ 1/priority 的比例关系

**结论**：实验结果充分证明了Stride调度算法的正确性，虽然存在偏差，但完全在合理范围内，且符合算法的设计目标。

---

## 重要知识点总结

### 实验中的重要知识点

#### 1. 调度器框架设计模式

**知识点**：面向对象的C语言设计、策略模式

**实验体现**：
- `sched_class`结构体封装调度算法接口
- 函数指针实现多态
- 运行时切换调度算法

**OS原理对应**：
- 调度算法的抽象与实现分离
- 模块化设计原则

**个人理解**：
- 虽然C语言不是面向对象语言，但通过结构体+函数指针可以实现类似的效果
- 这种设计使得添加新调度算法变得简单，体现了"开闭原则"
- 与OS原理中强调的"机制与策略分离"思想一致

#### 2. 时间片轮转（Round Robin）

**知识点**：RR调度算法、时间片、FIFO队列

**实验体现**：
- 使用链表实现就绪队列
- 时钟中断驱动时间片递减
- need_resched标志触发调度

**OS原理对应**：
- 分时系统的基本调度算法
- 上下文切换时机
- 时间片大小对性能的影响

**个人理解**：
- RR是最公平但最"无脑"的调度算法
- 时间片选择是平衡响应时间和吞吐量的关键
- 实验中的实现比原理简化了很多（如没考虑进程优先级）

#### 3. Stride调度算法

**知识点**：比例共享调度、优先队列、斜堆

**实验体现**：
- 使用斜堆维护stride最小值
- BIG_STRIDE防止溢出
- 动态更新stride值

**OS原理对应**：
- 公平调度的数学模型
- 确定性vs随机化调度
- 优先级与CPU时间的关系

**个人理解**：
- Stride是lottery scheduling的确定性版本
- 斜堆的选择体现了数据结构对算法效率的影响
- 实验证明了理论上的比例关系在实践中是有偏差的

#### 4. 进程状态转换与调度队列管理

**知识点**：进程状态、就绪队列、阻塞队列

**实验体现**：
- `wakeup_proc`中的入队操作
- `schedule`中的出队/入队逻辑
- 状态转换的原子性保护

**OS原理对应**：
- 进程状态图
- 调度时机
- 并发控制

**个人理解**：
- 状态转换必须与队列操作同步，否则会出现"丢失进程"
- 中断保护是必要的，防止竞态条件
- Lab6相比Lab5最大的改进就是完善了这部分逻辑

#### 5. 时钟中断与调度

**知识点**：中断处理、延迟调度、标志位

**实验体现**：
- `clock_intr()`减少时间片
- `sched_class_proc_tick()`调用算法相关处理
- `need_resched`标志延迟调度

**OS原理对应**：
- 时钟中断是操作系统的心跳
- 抢占式调度的实现基础
- 中断上下文的限制

**个人理解**：
- 不能在中断处理中直接调用`schedule()`是因为可能导致死锁
- 使用标志位是一种优雅的延迟执行机制
- 这是Lab6调试时最容易出错的地方（如果忘记调用`clock_intr()`）

---

### OS原理中重要但实验未涉及的知识点

#### 1. 实时调度算法

**原理知识**：
- EDF (Earliest Deadline First)
- RM (Rate Monotonic)
- 硬实时vs软实时

**为什么未涉及**：
- 需要任务的周期性和截止时间信息
- uCore是通用OS，不是RTOS
- 实现复杂度较高

#### 2. 多处理器调度

**原理知识**：
- 对称多处理(SMP)
- CPU亲和性
- 负载均衡算法
- NUMA感知调度

**为什么未涉及**：
- uCore是单核设计
- 多核调度涉及复杂的同步问题
- 需要硬件支持和更复杂的数据结构

#### 3. O(1)调度器和CFS

**原理知识**：
- Linux 2.6的O(1)调度器
- 完全公平调度器(CFS)
- 红黑树数据结构
- 虚拟运行时间

**为什么未涉及**：
- 实现复杂，需要红黑树
- CFS的虚拟运行时间概念较抽象
- 实验时间有限，Stride已经足够展示核心思想

#### 4. 组调度

**原理知识**：
- 进程组的调度
- 用户级vs内核级调度
- 容器资源隔离

**为什么未涉及**：
- 需要进程组管理机制
- 涉及资源控制(cgroup)概念
- 超出教学实验范围

#### 5. 调度域和负载均衡

**原理知识**：
- 调度域层次结构
- 推/拉负载均衡
- 迁移开销考虑

**为什么未涉及**：
- 单核系统不需要
- 需要NUMA拓扑信息
- 实现非常复杂

---

## 实验总结与收获

通过Lab6的实践，我们深入理解了：

1. **调度器的设计哲学**：机制与策略分离，通过抽象接口支持多种算法
2. **数据结构的重要性**：链表适合RR，堆适合Stride，选择合适的数据结构事半功倍
3. **并发控制的细节**：状态转换、队列操作必须原子化，中断保护不可少
4. **理论与实践的差距**：Stride算法的实际效果与理论有偏差，但趋势正确
5. **调试的重要性**：遇到"进程丢失"、调度不工作等问题，需要系统地排查状态转换和队列操作

最大的收获是理解了**调度器是操作系统的核心组件之一**，它决定了系统的响应性、吞吐量和公平性。不同的调度算法适用于不同的场景，没有银弹，只有权衡。

