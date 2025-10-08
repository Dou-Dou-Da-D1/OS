# Lab1

## 练习一

1. 借助`la sp,bootstacktop`指令，把`bootstacktop`对应的地址赋予`sp`寄存器，指令的目的是完成栈的初始化，并为栈分配相应的内存空间。
2. `tail kern_init`采用尾调用的方式，在函数`kern_init`所在位置继续执行，指令的目的是进入操作系统的入口，同时避免此次函数调用对`sp`寄存器造成影响。

## 练习二

首先我们打开终端，进入`OS1`实验根目录，并拆分成两个窗口。

在第一个终端输入以下命令启动 QEMU。这个命令会让 QEMU 暂停在 CPU 加电的那一刻，等待 GDB 连接。

```
make debug
```

切换到第二个终端，输入以下命令启动 GDB 并自动连接到 QEMU。

```
make gdb
```

GDB 成功启动并连接后，显示以下信息，表明它停在了 RISC-V 的复位地址 `0x1000`。

![GDB连接成功](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/1.png)

接着，在第二个终端的 `gdb` 提示符下，执行以下命令：

1. 在 OpenSBI 入口处设置断点：

```
b *0x80000000
```

2. 继续执行，直到遇到断点：

```
c
```

GDB 会输出 `Continuing` 并暂停，等待 QEMU 运行到 `0x80000000`。最终显示：

![显示1](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/2.png)

这表示我们已经进入了 OpenSBI 的代码。

3. 在内核入口 `kern_entry` 处设置断点：

```
b *kern_entry
```

4. 继续执行，进入内核：

```
c
```

GDB 会再次暂停，这次是在内核的汇编入口点 `kern_entry`。

![显示2](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/3.png)

5. 单步执行汇编指令：

使用 `si` 命令来逐条执行汇编代码。

```
si
```

每执行一次 `si` ，都会前进一条指令。观察 `pc` 的变化。

6. 查看寄存器状态：

在执行 `la sp, bootstacktop` 后，可以检查栈指针 `sp` 是否被正确初始化。

```
info registers sp
```

我们会看到 `sp` 的值已经变成了 `bootstacktop` 的地址。

![显示3](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS1/images/4.png)

7. 跟踪进入 C 函数 `kern_init`：

继续使用 `si` 单步执行，直到指令指向 `tail kern_init`。再执行一次 `si`，我们就会进入 C 函数 `kern_init`。

8. 在 C 函数中设置断点并调试：

```
b kern_init

c

ni
```