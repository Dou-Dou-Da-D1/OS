#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <default_sched.h>
#include <stdio.h>
#include "../kern/schedule/sched.h"

/*
 * RR_init initializes the run-queue rq with correct assignment for
 * member variables, including:
 *
 *   - run_list: should be an empty list after initialization.
 *   - proc_num: set to 0
 *   - max_time_slice: no need here, the variable would be assigned by the caller.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
RR_init(struct run_queue *rq)
{
    list_init(&rq->run_list);
    rq->proc_num = 0;
    /* ensure lab6 run pool cleared if present */
    rq->lab6_run_pool = NULL;
}

/*
 * RR算法直接把需要入队的进程放在调度队列的尾端
 */
static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
    assert(proc);
    /* 添加到队尾 */
    list_add_before(&rq->run_list, &proc->run_link);
// DEBUG:     if (proc->pid >= 2 && proc->pid <= 7) cprintf("RR_enqueue: pid=%d\n", proc->pid); /* if list_add_before behaves as add_tail */
    proc->rq = rq;
    rq->proc_num++;
    /* 若当前进程剩余时间片为0，重置时间片为最大时间片 */
    if (proc != idleproc) {
        proc->time_slice = rq->max_time_slice;
    }
}

/*
    直接将进程从调度队列中移除
 */
static void
RR_dequeue(struct run_queue *rq, struct proc_struct *proc)
{
    assert(proc && proc->rq == rq);
// DEBUG:     if (proc->pid >= 2 && proc->pid <= 7) cprintf("RR_dequeue: pid=%d\n", proc->pid);
    list_del_init(&proc->run_link);     // 从队列中移除该进程
    proc->rq = NULL;
    rq->proc_num--;     // 更新rq中进程数目
}

/*
    pick_next选取队列头的表项，用le2proc函数获得对应的进程控制块
 */
static struct proc_struct *
RR_pick_next(struct run_queue *rq)
{
    if (list_empty(&rq->run_list)){
        return idleproc;
    }
    list_entry_t *le = list_next(&rq->run_list);
    struct proc_struct *p = le2proc(le, run_link);
// DEBUG:     if (p->pid >= 2 && p->pid <= 7) cprintf("RR_pick_next: picked pid=%d\n", p->pid);
    return p;
}

/*
    proc_tick函数在每一次时钟中断调用，减小当前进程时间片。
 */
static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
    if (proc == idleproc || !proc) {
        return;
    }
    /* decrease time slice, trigger reschedule when exhausted */
    if (proc->time_slice > 0) {
        proc->time_slice--;
    }
    // 当时间片减少为0时，便把当前进程设置为可调度。
    if (proc->time_slice == 0) {
        proc->need_resched = 1;
    }
}

struct sched_class default_sched_class = {
    .name = "RR_scheduler",
    .init = RR_init,
    .enqueue = RR_enqueue,
    .dequeue = RR_dequeue,
    .pick_next = RR_pick_next,
    .proc_tick = RR_proc_tick,
};