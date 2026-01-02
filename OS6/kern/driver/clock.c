#include <clock.h>
#include <defs.h>
#include <sbi.h>
#include <stdio.h>
#include <riscv.h>
#include <proc.h>

// 强制启用RISC-V架构宏，确保riscv.h中所有定义生效
#ifndef __riscv
#define __riscv 1
#endif
#ifndef __riscv_xlen
#define __riscv_xlen 32  // 32位系统，64位则改为64
#endif

// 直接定义sie寄存器别名（跳过DECLARE_CSR，避免条件编译问题）
#ifndef sie
#define sie CSR_SIE  // CSR_SIE在riscv.h中已定义为0x104（标准地址）
#endif

// 确认MIP_STIP定义（riscv.h中已包含，此处冗余定义防止遗漏）
#ifndef MIP_STIP
#define IRQ_S_TIMER 5
#define MIP_STIP (1 << IRQ_S_TIMER)
#endif

volatile size_t ticks;

static inline uint64_t get_cycles(void)
{
#if __riscv_xlen == 64
    uint64_t n;
    __asm__ __volatile__("rdtime %0" : "=r"(n));
    return n;
#else
    uint32_t lo, hi, tmp;
    __asm__ __volatile__(
        "1:\n"
        "rdtimeh %0\n"
        "rdtime %1\n"
        "rdtimeh %2\n"
        "bne %0, %2, 1b"
        : "=&r"(hi), "=&r"(lo), "=&r"(tmp));
    return ((uint64_t)hi << 32) | lo;
#endif
}

static uint64_t timebase = 100000;
#define TIME_SLICE 5  // 定义时间片大小（时钟中断次数）

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void)
{
    set_csr(sie, MIP_STIP);

    clock_set_next_event();
    // initialize time counter 'ticks' to zero
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }

/* 时钟中断处理函数 */
void clock_intr(void) {
    ticks++;  // 全局时钟计数递增

    // 设置下一次时钟中断
    clock_set_next_event();

    // 如果当前有运行的进程，更新其时间片
    if (current != NULL) {
        if (current->pid >= 2 && current->pid <= 7 && ticks % 10 == 0) {
// DEBUG:             cprintf("clock_intr: pid=%d, time_slice=%d\n", current->pid, current->time_slice);
        }
        current->time_slice--;  // 减少当前进程时间片
        
        // 时间片用完，需要重新调度
        if (current->time_slice <= 0) {
            if (current->pid >= 2 && current->pid <= 7) {
// DEBUG:                 cprintf("clock_intr: pid=%d time_slice expired, set need_resched\n", current->pid);
            }
            current->need_resched = 1;  // 设置调度标志
        }
    }
}
