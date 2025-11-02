# <center>Lab4</center>

<center>程娜 张丝童</center>

## 练习1：完善中断处理 （需要编程）

### 实现过程
1. 在 `interrupt_handler` 中定位 `IRQ_S_TIMER` 分支，新增静态变量 `ticks`、`num` 用于跨中断统计。
2. 每次中断先调用 `clock_set_next_event()` 预约下一次触发，累加 `ticks`。
3. 当 `ticks` 达到 100 时调用 `print_ticks()` 打印一次，重置 `ticks` 并将 `num` 加 1。
4. 当 `num` 等于 10 时调用 `sbi_shutdown()` 结束系统运行。

### 定时器中断处理流程
1. 硬件触发 S 模式时钟中断后进入 `trap()`，由 `trap_dispatch()` 分发到 `interrupt_handler()`。
2. 在 `IRQ_S_TIMER` 分支调用 `clock_set_next_event()`，确保定时器继续周期工作。
3. 维护 `ticks` 计数器，累计到 100 次打印一次 “100 ticks”，累计 10 次后执行关机。
4. 中断处理结束返回 `__trapret`，恢复寄存器状态并继续后续执行。

### 代码分析
插入于 `interrupt_handler` 的 `IRQ_S_TIMER` 分支：
```c
/*(1)设置下次时钟中断- clock_set_next_event()
 *(2)计数器（ticks）加一
 *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
 *(4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
 */
{
    static int ticks = 0;       // 累计当前组内的时钟中断次数
    static int num = 0;         // 已打印“100 ticks”行数
    clock_set_next_event();     // (1) 预约下一次时钟中断
    ticks++;                    // (2) 累加本轮中断次数
    if (ticks == 100) {         // (3) 满 100 次
        print_ticks();          // 打印“100 ticks”
        ticks = 0;              // 组内计数归零
        num++;                  // 已打印组数加一
        if (num == 10) {        // (4) 达到 10 组后关机
            sbi_shutdown();
        }
    }
}
```
要点说明:
- 静态变量保证跨多次中断持续保存状态，不需全局暴露。
- `clock_set_next_event()` 必须在最前执行，避免遗漏下一次中断预约。
- 先判断 `ticks==100` 再清零，逻辑清晰避免 `off-by-one`。
- 使用 `num` 控制关机条件，避免立即退出导致后续资源未清理，调用 `sbi_shutdown()` 即可。


### 实验结果
系统启动后进入时钟中断循环，每累计 100 次中断打印一行：
```
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
```
第 10 行打印完成后触发 `sbi_shutdown()`，QEMU 模拟器正常退出，符合题目要求，练习完成。

## 扩展练习 Challenge1：描述与理解中断流程

### 1. 中断/异常处理整体流程
1. 触发源产生：CPU 执行过程中出现 异常(如非法指令/断点) 或 时钟/外设中断，硬件写入 `scause(sepc/stval/sstatus)`。
2. 入口分派：在 idt_init 中
   ```c
   extern void __alltraps(void);
   write_csr(sscratch, 0);
   write_csr(stvec, &__alltraps);
   ```
   将 `stvec` 指向内核统一入口 `__alltraps`。
3. 进入汇编入口：硬件跳到 `__alltraps`（`trapentry.S`）。首先执行宏 `SAVE_ALL`：
   ```asm
   addi sp, sp, -36*REGBYTES   # 为 trapframe 腾空间
   STORE x0..x31                # 依序保存通用寄存器
   csrr s1,sstatus ; csrr s2,sepc ; csrr s3,stval ; csrr s4,scause
   STORE s1->32槽, s2->33槽, s3->34槽, s4->35槽
   ```
   同时通过 `csrrw s0, sscratch, x0` & 保存原 `sp` 到槽2，形成完整 `trapframe`。
4. 形成参数：立即
   ```asm
   move a0, sp
   jal  trap
   ```
   把 `trapframe` 首地址传给 C 函数 `trap(struct trapframe *tf)`。
5. C 级分发：`trap() → trap_dispatch()`：
   ```c
   if ((intptr_t)tf->cause < 0) interrupt_handler(tf);
   else exception_handler(tf);
   ```
   RISC-V 规定 `scause` 最高位 = 1 表示中断，因而 <0 判断成立即进入中断处理。
7. 返回路径：`trap()` 结束后回到 `__trapret`：
   ```asm
   RESTORE_ALL
   sret
   ```
   `RESTORE_ALL` 读取槽32/33 还原 `sstatus/sepc`，再恢复除 `x0` 外所有通用寄存器，最后恢复原 `sp(x2)` 并 `sret` 返回到 `sepc` 指向的位置继续执行（或修改后的位置）。
8. 状态继续：若异常处理修改了 `tf->epc`（如跳过非法指令），`sret` 后执行流按更新地址前进；若关机则不会返回（`sbi_shutdown`）。

### 2. 指令 mov a0, sp 的目的
`SAVE_ALL` 完成后，`sp` 指向当前陷入上下文的 `trapframe`。`move a0, sp` 把这一指针放进第一个参数寄存器 `a0`，以便随后 `jal trap` 调用的 C 函数 `trap(struct trapframe *tf)` 能直接访问保存的寄存器现场进行分发处理。

### 3. SAVE_ALL 中寄存器在栈中的位置如何确定
`SAVE_ALL` 在汇编里按固定顺序用 `STORE` 把 `x0→x31`（其中槽2存原始 `sp`）再加 `sstatus/sepc/stval/scause` 依次写入栈；C 侧的 `struct trapframe` 采用同样的字段排列并按 `REGBYTES` 对齐，因此两边偏移一一对应，栈槽位置由这对顺序共同决定。

### 4. 是否必须保存所有寄存器？分析
理论上只需保证返回前不会破坏调用约定的寄存器，但中断可能在任意点发生，处理函数也可能使用任意寄存器；因此最安全、最简洁的实现是把全部通用寄存器和关键 CSR 一并保存，避免遗漏带来的不确定性，只有在对调用链、编译器用寄存器情况完全确定且对性能极度敏感时才考虑缩减集合。


## 扩展练习 Challenge2：理解上下文切换机制

### 1. 两条关键指令的作用与目的  
```asm
csrw sscratch, sp
csrrw s0, sscratch, x0
```
这两条指令的作用如下：
- `csrw sscratch, sp`：把当前陷入前的栈指针 `sp` 保存到 `sscratch` 寄存器中。这样可以在后续处理中临时保存原始 `sp`，防止被覆盖。
- `csrrw s0, sscratch, x0`：把 `sscratch` 的值（即原始 `sp`）读到 `s0` 寄存器，并同时把 `sscratch` 置为 `0`。这样既恢复了原始 `sp`，又用 `0` 标记当前已在内核栈上。

目的：
1. 记录陷入前的栈指针，便于后续恢复或保存到 `trapframe`。
2. 通过将 `sscratch` 置 0，标记当前已在内核栈，方便后续嵌套异常时判断是否需要切换栈，防止栈混乱。
这是 RISC-V 下区分用户态/内核态陷入、支持嵌套异常处理的常用技巧。

### 2. 为什么 SAVE_ALL 里保存了 `stval` / `scause` 却不在 RESTORE_ALL 里还原？  
- 保存目的：  
  * `stval`：提供与本次异常/页故障/访问错误相关的“问题地址”或指令取值辅助信息；  
  * `scause`：记录这次陷入的类型（中断/异常 + 具体编号）；  
  * 它们被复制进 `trapframe`，是为了让 C 语言层 `trap()` / `exception_handler()` 能读取、打印、决策。  
- 不恢复的原因：  
  * 它们属于“陷入原因的只读语义快照”，供上层逻辑调用，返回时没有必要伪造或写回；  
  * 恢复继续执行所必需的只有执行点与处理态控制：`sepc`（返回地址）与 `sstatus`（特权级/中断使能位等）；  
  * 写回 `scause` / `stval` 不改变硬件回到原指令的语义，也可能不被硬件需要（很多实现对这些 CSR 写入并无意义或是 WARL/只读情形）；  
  * 统一 `trapframe` 设计里“保存多于恢复”是常见模式：所有寄存器/CSR 打包一次性传给上层，方便调试/扩展，而恢复最小必要集保证返回正确。  


## 扩展练习Challenge3：完善异常中断

### 主要思想
- 在 `exception_handler` 的非法指令与断点分支中输出异常类型与触发地址，并根据指令长度（支持 16/32 位）调整 `tf->epc` 以跳过产生异常的指令。
- 通过 `instr_len` 辅助函数读取异常地址处的半字节码判断指令是否为压缩格式。
- 启动阶段借助 `trigger_exceptions`（受 `ENABLE_TRAP_TEST` 宏控制）主动触发一次 `ebreak` 和一条非法压缩指令，用于验证处理流程。

### 代码分析
```c
// filepath: kern/trap/trap.c
static inline int instr_len(uintptr_t epc) {
    uint16_t inst16 = *(uint16_t *)epc;
    return ((inst16 & 0x3) == 0x3) ? 4 : 2;
}

case CAUSE_ILLEGAL_INSTRUCTION:
    cprintf("Exception type:Illegal instruction\n");
    cprintf("Illegal instruction caught at 0x%08lx\n", (unsigned long)tf->epc);
    tf->epc += instr_len(tf->epc);
    break;
case CAUSE_BREAKPOINT:
    cprintf("Exception type: breakpoint\n");
    cprintf("ebreak caught at 0x%08lx\n", (unsigned long)tf->epc);
    tf->epc += instr_len(tf->epc);
    break;
```

### 测试方法
在任意内核初始化阶段插入触发代码，例如放入某测试函数：
```c
#if ENABLE_TRAP_TEST
    trigger_exceptions();
#endif

static void trigger_exceptions(void) {
    static int done = 0;
    if (done) return;
    done = 1;
    asm volatile("ebreak");
    asm volatile(".2byte 0x0000");
}
```

### 实验结果
启动内核时若 `ENABLE_TRAP_TEST` 置 1，可见一次断点与非法指令的处理日志并继续运行至时钟中断：
```
Exception type: breakpoint
ebreak caught at 0xffffffffc02007ac
Exception type:Illegal instruction
Illegal instruction caught at 0xffffffffc02007ae
...
++ setup timer interrupts
100 ticks
100 ticks
...
```
关闭该宏后，系统不再自动触发测试，正常进入后续流程。

## 实验知识点与OS原理知识点对应关系
### 1. 时钟中断处理（练习1）
- **实验知识点**：周期性时钟中断监听、中断计数累加、条件触发打印与关机（ticks累计100打印、num累计10关机）、`clock_set_next_event()`预约下一次中断。
- **对应OS原理知识点**：中断驱动机制、时钟中断的核心作用、中断服务程序（ISR）设计。
- **理解**：
  - 关系：实验是OS原理中“时钟中断驱动系统运行”的简化实现。原理中时钟中断是进程调度的时间片划分依据、系统计时、延迟任务触发的核心，实验通过“计数-打印-关机”的流程，直观体现了“中断周期性触发+中断处理逻辑执行”的核心逻辑。
  - 差异：原理中时钟中断处理需结合进程调度（如时间片耗尽切换进程）、系统负载统计等复杂逻辑；实验仅保留基础的计数与条件动作，未涉及进程调度等延伸功能，且中断类型仅聚焦时钟中断，未覆盖其他外设中断。

### 2. 中断/异常处理整体流程（Challenge1）
- **实验知识点**：中断/异常触发（硬件写入CSR寄存器）、统一入口`__alltraps`、`SAVE_ALL`保存上下文、C层`traps()`分发（中断/异常分支）、`RESTORE_ALL`恢复上下文、`sret`返回执行。
- **对应OS原理知识点**：中断响应与处理流程、中断向量表、上下文保存与恢复、特权级切换。
- **理解**：
  - 关系：实验完整复现了OS原理中“中断触发-入口跳转-上下文管理-逻辑分发-恢复返回”的通用流程框架，严格遵循RISC-V架构的中断/异常处理规范，是原理的架构特定实现。
  - 差异：原理中中断向量表需支持多中断源（时钟、键盘、磁盘等）的入口映射，且异常处理需区分致命异常（如内存访问错误）和非致命异常（如断点），并提供不同处理策略（终止进程/跳过指令）；实验仅实现时钟中断、非法指令、断点三种场景，且异常处理仅做日志打印和指令跳过，未涉及致命异常的终止逻辑。

### 3. 中断上下文管理（Challenge1、Challenge2）
- **实验知识点**：`SAVE_ALL`/`RESTORE_ALL`保存/恢复所有通用寄存器与CSR（sstatus/sepc/stval/scause）、`sscratch`寄存器的使用（标记内核栈状态）、`mov a0, sp`传递`trapframe`指针。
- **对应OS原理知识点**：中断上下文切换、栈帧设计、特权级切换时的状态传递。
- **理解**：
  - 关系：实验的上下文管理是原理中“中断上下文保护”的直接实现。原理中上下文保存的核心目标是保证被中断程序能恢复执行，实验通过固定栈帧布局（36个寄存器槽位）和严格的保存/恢复顺序，实现了这一核心目标。
  - 差异：原理中可能存在“最小化上下文保存”优化（仅保存被使用的寄存器以提升性能），而实验为简化逻辑、避免遗漏，选择保存所有通用寄存器；原理中`sscratch`还需用于用户态/内核态栈切换，实验仅用其标记内核栈状态，未涉及用户态场景。

### 4. 异常处理（Challenge3）
- **实验知识点**：非法指令、断点异常的识别与处理、`instr_len`判断指令长度、调整`tf->epc`跳过异常指令。
- **对应OS原理知识点**：异常分类与处理策略、断点调试机制、指令地址修正。
- **理解**：
  - 关系：实验是原理中“非致命异常恢复”的简化实现。原理中断点异常是调试工具（如GDB）的基础，通过暂停程序并保留上下文供调试；非法指令异常需判断是否可恢复（如跳过无效指令）或终止进程，实验的“打印日志+跳过指令”符合非致命异常的恢复逻辑。
  - 差异：原理中异常类型更丰富（如内存访问错误、系统调用异常等），且需结合进程控制块（PCB）记录异常状态；实验仅覆盖2种异常，且未涉及进程层面的状态管理，仅聚焦指令流的继续执行。

### 5. `sscratch`寄存器的作用（Challenge2）
- **实验知识点**：`csrw sscratch, sp`保存原始栈指针、`csrrw s0, sscratch, x0`恢复并标记内核栈状态（置0）。
- **对应OS原理知识点**：特权级切换中的栈管理、中断嵌套支持。
- **理解**：
  - 关系：实验体现了原理中“用专用寄存器标记/保存栈状态”的设计思想。原理中`sscratch`的核心作用是在中断嵌套或用户态/内核态切换时，区分栈的来源（用户栈/内核栈），避免栈混乱。
  - 差异：原理中`sscratch`需处理用户态触发中断时的栈切换（从用户栈切换到内核栈），实验仅涉及内核态中断，未涉及用户态场景，因此`sscratch`的功能被简化为“标记内核栈状态”。

## OS原理中重要但实验未对应的知识点
1. **中断优先级与嵌套**：原理中不同中断源（如磁盘中断优先级高于键盘中断）有不同优先级，高优先级中断可打断低优先级中断的处理；实验未涉及中断优先级配置，仅支持单一中断的串行处理，无嵌套逻辑。
2. **中断屏蔽**：原理中可通过关闭特定中断源或全局中断屏蔽（如`cli`指令），避免关键操作被中断打断；实验未实现中断屏蔽功能，时钟中断始终可触发。
3. **设备中断处理**：原理中需支持键盘、磁盘、网络等多种外设中断，每种中断有对应的ISR；实验仅处理时钟中断，未涉及其他外设的中断检测与处理。
4. **系统调用机制**：原理中系统调用是用户态进程请求内核服务的核心方式，通过特殊异常（如`ecall`指令）触发；实验未实现系统调用相关逻辑，未区分“异常”与“系统调用”的差异。
5. **中断控制器（如PIC/APIC）**：原理中中断控制器负责管理多个中断源的请求、优先级仲裁、向CPU发送中断信号；实验未涉及中断控制器的模拟或配置，直接通过QEMU模拟时钟中断触发。
6. **致命异常的处理**：原理中致命异常（如内存访问越界、权限错误）需终止异常进程并回收资源；实验仅处理非致命异常（非法指令、断点），未实现致命异常的进程终止逻辑。
7. **用户态与内核态切换的中断处理差异**：原理中用户态触发的中断需切换栈（用户栈→内核栈）、验证权限；实验仅运行在内核态，未涉及用户态进程，因此未体现该差异。
