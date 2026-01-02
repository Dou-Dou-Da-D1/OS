#include <list.h>
#include <sync.h>
#include <proc.h>
#include <stdio.h>
#include <assert.h>
#include <default_sched.h>
#include "../kern/schedule/sched.h"

// the list of timer
static list_entry_t timer_list;

static struct sched_class *sched_class;

static struct run_queue *rq;

static inline void
sched_class_enqueue(struct proc_struct *proc)
{
    if (proc != idleproc) {
        proc->rq = rq;
        sched_class->enqueue(rq, proc);
    }
}

static inline void
sched_class_dequeue(struct proc_struct *proc)
{
    sched_class->dequeue(rq, proc);
}

static inline struct proc_struct *
sched_class_pick_next(void)
{
    return sched_class->pick_next(rq);
}

void sched_class_proc_tick(struct proc_struct *proc)
{
    if (proc != idleproc) {
        sched_class->proc_tick(rq, proc);
    } else {
        /* idleproc: normally do nothing, but could reset accounting */
    }
}

static struct run_queue __rq;

void sched_init(void)
{
    list_init(&timer_list);

    sched_class = &default_sched_class;

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    /* ensure run_queue fields initialized by class */
    sched_class->init(rq);

    
    cprintf("sched class: %s\n", sched_class->name);
}

/* wakeup_proc: make proc runnable and enqueue if needed */
void wakeup_proc(struct proc_struct *proc)
{
    bool intr_flag;
    local_intr_save(intr_flag);

    if (proc->state != PROC_RUNNABLE) {
// DEBUG:         cprintf("wakeup_proc: pid=%d state=%d\n", proc->pid, proc->state);
        proc->state = PROC_RUNNABLE;
        proc->wait_state = 0;
        /* only enqueue if it's not the current running thread */
        if (proc != current) {
            sched_class_enqueue(proc);
        }
    }

    local_intr_restore(intr_flag);
}

/* schedule: high level scheduling flow (enqueue current if runnable,
 * pick next, dequeue it and run) */
void schedule(void)
{
    bool intr_flag;
    local_intr_save(intr_flag);

    struct proc_struct *cur = current;
    struct proc_struct *next;

    /* clear resched flag for current; it will be set again if needed */
    cur->need_resched = 0;

    /* if current is still runnable, enqueue it */
    if (cur->state == PROC_RUNNABLE) {
        sched_class_enqueue(cur);
    }

    /* pick next from scheduling class */
    next = sched_class_pick_next();
    if (!next) {
        next = idleproc;
    } else {
        /* remove next from run-queue */
        sched_class_dequeue(next);
    }

    /* if next is the same as current, nothing to do */
    if (next == cur) {
        local_intr_restore(intr_flag);
        return;
    }

    // DEBUG: if (next->pid >= 3 && next->pid <= 7) cprintf("schedule: switching to pid=%d\n", next->pid);
    /* accounting */
    next->runs++;

    /* context switch */
    proc_run(next);

    /* proc_run should not return here in normal flow, but restore just in case */
    local_intr_restore(intr_flag);
}