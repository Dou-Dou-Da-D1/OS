#include <stdio.h>
#include <ulib.h>

int zero;

int
main(void) {
    int result;
    cprintf("zero value is %d.\n", zero);
    // 使用内联汇编强制执行除零,确保得到 RISC-V 标准结果 -1
    asm volatile(
        "div %0, %1, %2"
        : "=r"(result)
        : "r"(1), "r"(zero)
    );
    cprintf("value is %d.\n", result);
    panic("FAIL: T.T\n");
}

