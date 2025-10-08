# Lab1

## 练习一

1. 借助`la sp,bootstacktop`指令，把`bootstacktop`对应的地址赋予`sp`寄存器，指令的目的是完成栈的初始化，并为栈分配相应的内存空间。
2. `tail kern_init`采用尾调用的方式，在函数`kern_init`所在位置继续执行，指令的目的是进入操作系统的入口，同时避免此次函数调用对`sp`寄存器造成影响。

## 练习二

首先我们打开终端，进入`OS1`实验根目录，并拆分成两个窗口。

在第一个终端输入以下命令启动 QEMU：该命令会让 QEMU 暂停在 CPU 加电的那一刻，同时开启 1234 端口等待 GDB 连接，为后续跟踪启动流程做准备。

```
make debug
```

切换到第二个终端，输入以下命令启动 GDB 并自动连接到 QEMU。

```
make gdb
```

GDB 成功启动并连接后，显示以下信息，表明它停在了 RISC-V 的复位地址 `0x1000`。

![GDB连接成功](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/1.png)

这里需要注意：`0x1000` 并非随机地址，而是 QEMU 模拟的 RISC-V 处理器硬件加电后的复位地址——CPU 加电或复位时，硬件会强制将程序计数器（PC）设置为这个固定值，因此从 `0x1000` 开始执行的，就是系统启动的第一条指令。

为了进一步确认这些初始指令的功能，我们在 GDB 提示符下输入 `x/10i $pc`，查看当前 PC 指向的 10 条汇编指令，观察到如下的指令序列：

![指令序列](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/5.png)

这些指令的核心作用是**完成最基础的硬件识别和快速跳转到完整的 OpenSBI 固件**。具体分析如下：

1. `auipc t0, 0x0` 和 `addi a1, t0, 32`：

    * 这两条指令组合起来，是 `la a1, some_label`（Load Address）伪指令的具体实现。
    * `auipc` (Add Upper Immediate to PC) 将当前 PC 值（`0x1000`）的高 20 位加载到 `t0`。
    * `addi` (Add Immediate) 将 t0 的值加上一个 12 位的立即数（这里是 32），并将结果存入 `a1`。
    * 其最终效果是计算出 MROM 代码中某个数据结构（很可能是设备树地址或其他配置信息）的物理地址，并将其存入 `a1` 寄存器，作为后续调用的参数。

2. `csrr a0`, `mhartid`：
    * 这条指令读取 `mhartid` 寄存器，获取当前正在执行的 CPU 核心的 ID。
    * 这个 ID 被存入 `a0` 寄存器。在 RISC-V 的调用约定中，`a0` 和 `a1` 通常用于传递函数参数。

3. `ld t0`, `24(t0)` 和 `jr t0`：
    * 这是整个 MROM 代码的核心跳转逻辑。
    * `ld` (Load Doubleword) 从内存中加载一个 64 位的值。它的源地址是 `t0` 寄存器的值加上 24。`t0` 在 `auipc` 指令后，其值是 `0x1000` 的高 20 位扩展，加上 24 后，指向 MROM 代码段中一个特定的位置。这个位置存储的就是完整 OpenSBI 固件的入口地址。
    * `jr t0` (Jump Register) 指令将 `t0` 寄存器中的值（即刚刚加载的 OpenSBI 入口地址）赋给程序计数器 PC，从而实现跳转。


MROM 代码执行完成后，会自动跳转到`0x80000000`（OpenSBI 固件的加载地址）。为避免手动单步跟踪大量 SBI 代码，按 tips 建议通过观察点捕捉内核加载瞬间：

1. 在 GDB 中输入`b *0x80000000`，给 OpenSBI 入口设断点，再输入`c`让程序执行，触发断点后表明已进入 SBI 固件。
    ![显示1](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/2.png)
2. 为了观察内核被加载到 `0x80200000` 的瞬间，我在进入 OpenSBI 后，输入`watch *0x80200000`设置内存观察点。
    然而，程序并没有因为观察点被触发而中断，而是一直运行。在等待一段时间后，我手动按下 Ctrl+C 中断了程序。
    ![内存观察点](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/6.png)

    GDB 的输出显示，程序当时已经在执行内核 `kern_init` 函数中的无限循环。这表明，**内核早已开始运行，OpenSBI 已经完成了控制权的移交**。

    为了验证这一点，我们检查 `0x80200000` 的内存内容，GDB 将该地址直接解析为 `kern_entry`，并且内存中存放的是内核的指令代码，而非零值。
    
这一现象说明，我的内核镜像并非由 OpenSBI 在运行时加载。相反，它是由 QEMU 通过 `-device loader` 参数在启动时预加载到 `0x80200000` 的。因此，当我在 OpenSBI 启动后设置观察点时，`0x80200000` 的内容早已是内核代码，观察点自然不会被触发。

虽然 `watch` 命令因预加载机制未达预期，但我们可以直接验证启动流程的最终阶段 —— 控制权移交。

为验证这一过程，输入`b *0x80200000`给内核入口地址设断点，再输入`c`让程序执行。

GDB 很快在`0x80200000`处中断，输入`x/1i $pc`查看指令，显示为`kern_entry`的第一条汇编指令（`auipc sp, 0x3`），证明 OpenSBI 已完成初始化，并将控制权移交内核。

![控制权](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/7.png)
