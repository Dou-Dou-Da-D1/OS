#ifndef __KERN_SCHEDULE_SCHED_H__
#define __KERN_SCHEDULE_SCHED_H__

#include <defs.h>
#include <list.h>
#include <skew_heap.h>

#define MAX_TIME_SLICE 5

struct proc_struct;

struct run_queue
{
    list_entry_t run_list;  // 保存着链表头指针
    unsigned int proc_num;  // 运行队列中的线程数
    int max_time_slice;     // 最大的时间片大小
    // For LAB6 ONLY
    skew_heap_entry_t *lab6_run_pool;   // Stride调度算法中的优先队列
};

// The introduction of scheduling classes is borrrowed from Linux, and makes the
// core scheduler quite extensible. These classes (the scheduler modules) encapsulate
// the scheduling policies.
struct sched_class
{
    // 调度类的名字
    const char *name;
    // 初始化 run queue
    void (*init)(struct run_queue *rq);
    // 把进程放进 run queue, 函数必须在持有rq_lock的情况下调用
    void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
    // 把进程取出 runqueue, 函数必须在持有rq_lock的情况下调用
    void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
    // 选择下一个要执行的进程
    struct proc_struct *(*pick_next)(struct run_queue *rq);
    // 每次时钟中断调用, 减少当前进程时间片
    void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
    /* for SMP support in the future
     *  load_balance
     *     void (*load_balance)(struct rq* rq);
     *  get some proc from this rq, used in load_balance,
     *  return value is the num of gotten proc
     *  int (*get_proc)(struct rq* rq, struct proc* procs_moved[]);
     */
};

void sched_init(void);
void wakeup_proc(struct proc_struct *proc);
void schedule(void);
void sched_class_proc_tick(struct proc_struct *proc);
#endif /* !__KERN_SCHEDULE_SCHED_H__ */
