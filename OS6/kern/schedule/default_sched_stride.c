#include <defs.h>
#include <list.h>
#include <proc.h>
#include <assert.h>
#include <default_sched.h>
#include <stdio.h>
#include <skew_heap.h>
#include "../kern/schedule/sched.h"

#define USE_SKEW_HEAP 1

/* You should define the BigStride constant here*/
/* LAB6 CHALLENGE 1: 2311828 2313540 */
#define BIG_STRIDE (0x7FFFFFFF) /* you should give a value, and is ??? */

/* Overflow protection constants for stride scheduling 
 * 
 * Key insight: stride values use int32_t for comparison (signed arithmetic).
 * To prevent overflow while maintaining correct comparison:
 * - PASS_MAX is the maximum pass increment (when priority = 1)
 * - When any process's stride could overflow, we normalize all strides
 * - This ensures STRIDE_MAX - STRIDE_MIN <= PASS_MAX always holds
 */
#define PASS_MAX BIG_STRIDE          /* Maximum stride increment per scheduling */
#define STRIDE_OVERFLOW_THRESHOLD (0xFFFFFFFFU - BIG_STRIDE)  /* Trigger normalization before overflow */

/* Forward declaration for stride comparison function */
static int proc_stride_comp_f(void *a, void *b);

/* Normalize all stride values to prevent overflow 
 * This function subtracts the minimum stride from all processes,
 * effectively resetting the baseline while preserving relative ordering.
 */
static void stride_normalize(struct run_queue *rq) {
     // 检查是否有就绪进程
    if (rq->lab6_run_pool == NULL || rq->proc_num == 0) {
        return;
    }
    
    // 寻找最小stride值
    struct proc_struct *min_proc = le2proc(rq->lab6_run_pool, lab6_run_pool);
    uint32_t min_stride = min_proc->lab6_stride;
    
    if (min_stride == 0) {
        return;  // Already normalized
    }
    
    // 临时链表保存所有进程节点
    list_entry_t temp_list;
    list_init(&temp_list);
    
    // 归一化
    while (rq->lab6_run_pool != NULL) {
        // 取出堆顶进程
        struct proc_struct *proc = le2proc(rq->lab6_run_pool, lab6_run_pool);
        // 从堆中移除该进程
        rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
        // 归一化stride
        proc->lab6_stride -= min_stride;  // Normalize: subtract minimum
        // 加入临时链表
        list_add(&temp_list, &proc->run_link);
    }
    
    // 重建堆，重新插回
    while (!list_empty(&temp_list)) {
        list_entry_t *le = list_next(&temp_list);
        list_del(le);
        struct proc_struct *proc = le2proc(le, run_link);
        rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
    }
}

/* The compare function for two skew_heap_node_t's and the
 * corresponding procs*/
static int
proc_stride_comp_f(void *a, void *b)
{
     struct proc_struct *p = le2proc(a, lab6_run_pool);
     struct proc_struct *q = le2proc(b, lab6_run_pool);
     int32_t c = p->lab6_stride - q->lab6_stride;
     if (c > 0)
          return 1;
     else if (c == 0)
          return 0;
     else
          return -1;
}

/*
 * stride_init initializes the run-queue rq with correct assignment for
 * member variables, including:
 *
 *   - run_list: should be a empty list after initialization.
 *   - lab6_run_pool: NULL
 *   - proc_num: 0
 *   - max_time_slice: no need here, the variable would be assigned by the caller.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
stride_init(struct run_queue *rq)
{
     /* LAB6 CHALLENGE 1: 2311828 2313540
      * (1) init the ready process list: rq->run_list
      * (2) init the run pool: rq->lab6_run_pool
      * (3) set number of process: rq->proc_num to 0
      */
     list_init(&rq->run_list);    // 初始化链表（兼容旧逻辑）
     rq->lab6_run_pool = NULL;    // 初始化斜堆（stride核心）
     rq->proc_num = 0;            // 就绪进程数置0
}

/*
 * stride_enqueue inserts the process ``proc'' into the run-queue
 * ``rq''. The procedure should verify/initialize the relevant members
 * of ``proc'', and then put the ``lab6_run_pool'' node into the
 * queue(since we use priority queue here). The procedure should also
 * update the meta date in ``rq'' structure.
 *
 * proc->time_slice denotes the time slices allocation for the
 * process, which should set to rq->max_time_slice.
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc)
{
     /* LAB6 CHALLENGE 1: 2311828 2313540
      * (1) insert the proc into rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_insert: insert a entry into skew_heap
      *         list_add_before: insert  a entry into the last of list
      * (2) recalculate proc->time_slice
      * (3) set proc->rq pointer to rq
      * (4) increase rq->proc_num
      */
     assert(proc && rq);
     // 1. 斜堆插入：将proc的lab6_run_pool节点加入rq的斜堆
     rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
     // 2. 重置时间片（同RR调度）
     if (proc != idleproc) {
         proc->time_slice = rq->max_time_slice;
     }
     // 3. 关联进程与就绪队列，更新进程数
     // 4. 初始化优先级（如果未设置）
     if (proc->lab6_priority == 0) {
         proc->lab6_priority = 1;  // 默认优先级
     }
     // 5. 初始化stride值：仅在进程第一次加入队列时设置（stride为0时）
     //    设置为队列中的最小stride，避免新进程饥饿其他进程
     if (proc->lab6_stride == 0 && rq->lab6_run_pool != NULL) {
         struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
         proc->lab6_stride = p->lab6_stride;
     }
     proc->rq = rq;
     rq->proc_num++;
}

/*
 * stride_dequeue removes the process ``proc'' from the run-queue
 * ``rq'', the operation would be finished by the skew_heap_remove
 * operations. Remember to update the ``rq'' structure.
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc)
{
     /* LAB6 CHALLENGE 1: 2311828 2313540
      * (1) remove the proc from rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_remove: remove a entry from skew_heap
      *         list_del_init: remove a entry from the  list
      */
     assert(proc && rq);
     if (proc->rq != rq) proc->rq = rq;  // 兼容调度器切换
     // 1. 斜堆删除：移除proc的lab6_run_pool节点
     rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &proc->lab6_run_pool, proc_stride_comp_f);
     // 2. 清除进程与队列的关联，更新进程数
     proc->rq = NULL;
     rq->proc_num--;
}
/*
 * stride_pick_next pick the element from the ``run-queue'', with the
 * minimum value of stride, and returns the corresponding process
 * pointer. The process pointer would be calculated by macro le2proc,
 * see kern/process/proc.h for definition. Return NULL if
 * there is no process in the queue.
 *
 * When one proc structure is selected, remember to update the stride
 * property of the proc. (stride += BIG_STRIDE / priority)
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static struct proc_struct *
stride_pick_next(struct run_queue *rq)
{
     /* LAB6 CHALLENGE 1: 2311828 2313540
      * (1) get a  proc_struct pointer p  with the minimum value of stride
             (1.1) If using skew_heap, we can use le2proc get the p from rq->lab6_run_pol
             (1.2) If using list, we have to search list to find the p with minimum stride value
      * (2) update p;s stride value: p->lab6_stride
      * (3) return p
      */
     if (rq->lab6_run_pool == NULL) {
         return idleproc;  // 无就绪进程，返回空闲进程
     }
     // 1. 从斜堆顶获取stride最小的进程
     struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
     // 2. 更新进程stride：stride += BIG_STRIDE / 优先级（优先级默认为1，避免除0）
     uint32_t priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
     uint32_t stride_inc = BIG_STRIDE / priority;
     
     // 溢出保护：如果当前stride加上增量会导致溢出，则先进行归一化
     // 确保满足不变量：STRIDE_MAX - STRIDE_MIN <= PASS_MAX
     if (p->lab6_stride > STRIDE_OVERFLOW_THRESHOLD) {
         stride_normalize(rq);
         // 归一化后重新获取堆顶进程（可能已变化）
         p = le2proc(rq->lab6_run_pool, lab6_run_pool);
         priority = (p->lab6_priority == 0) ? 1 : p->lab6_priority;
         stride_inc = BIG_STRIDE / priority;
     }
     
     p->lab6_stride += stride_inc;

     // 3. 返回选中的进程
     return p;
}

/*
 * stride_proc_tick works with the tick event of current process. You
 * should check whether the time slices for current process is
 * exhausted and update the proc struct ``proc''. proc->time_slice
 * denotes the time slices left for current
 * process. proc->need_resched is the flag variable for process
 * switching.
 */
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc)
{
     /* LAB6 CHALLENGE 1: 2311828 2313540 */
     if (proc == idleproc || !proc) {
         return;
     }
     // 1. 时间片递减（同RR调度）
     if (proc->time_slice > 0) {
         proc->time_slice--;
     }
     // 2. 时间片耗尽，标记需要重新调度
     if (proc->time_slice == 0) {
         proc->need_resched = 1;
     }
}

struct sched_class stride_sched_class = {
    .name = "stride_scheduler",
    .init = stride_init,
    .enqueue = stride_enqueue,
    .dequeue = stride_dequeue,
    .pick_next = stride_pick_next,
    .proc_tick = stride_proc_tick,
};
