// ------------------------------------------------Buddy System设计文档------------------------------------------------
/*
一些基础函数：
- is_power_of_two：判断一个数是否为2的幂次
- order_of_two：计算2的幂次对应的阶数
- round_down_power2：将数向下取整为最近的2的幂次
- round_up_power2：将数向上取整为最近的2的幂次
- buddy_show_array：显示指定阶数范围的空闲块链表，打印各阶块的页数和起始地址
- buddy_init：初始化伙伴系统核心资源，包括各阶空闲链表初始化、最大阶数设为0、总空闲页数设为0
- buddy_init_memmap：初始化物理内存映射，将连续页框转为2的幂次大小的空闲块，设置页属性并加入对应阶空闲链表
- buddy_get_buddy：计算指定块的伙伴块地址
- buddy_nr_free_pages：返回系统当前总空闲页数

分块设计：通过buddy_split_block函数实现高阶块拆分为两个等大低阶块
1. 合法性校验：确保拆分阶数在有效范围，且对应阶链表非空；
2. 块信息获取：从高阶链表取出第一个块，计算拆分后单个块的大小及伙伴块地址；
3. 属性更新：将两个块的阶数设为order-1，标记为空闲状态；
4. 链表操作：从原高阶链表删除该块，将两个低阶块加入order-1阶空闲链表，完成拆分。

分配设计：通过buddy_alloc_pages函数实现内存块分配
1. 合法性校验：确保请求页数>0，且不超过总空闲页数；
2. 请求处理：将请求页数向上取整为最近的2的幂次，计算对应分配阶数；
3. 块查找与拆分：
   - 若目标阶链表非空，直接取出第一个块，标记为已分配并从链表删除；
   - 若目标阶链表为空，从更高阶链表查找非空链表，调用buddy_split_block拆分后重新尝试分配；
4. 状态更新：分配成功则减少总空闲页数，返回分配块的起始页指针。

释放设计：通过buddy_free_pages函数实现内存块释放与合并
1. 合法性校验：确保释放页数>0，且释放页数向上取整后与块实际大小一致；
2. 初始操作：将释放块加入对应阶空闲链表，计算其伙伴块地址；
3. 循环合并：
   - 若伙伴块为空闲且当前块阶数<最大阶数，交换地址确保当前块为低地址块；
   - 从链表删除两个块，合并为更高阶块，加入对应高阶链表；
   - 重新计算合并后块的伙伴块地址，重复合并逻辑直到无法合并；
4. 状态更新：合并完成后标记块为空闲，增加总空闲页数。
*/
// --------------------------------------------------------------------------------------------------------------------

#include "buddy_pmm.h"
#include <pmm.h>
#include <list.h>
#include <string.h>
#include <stdio.h>

#define BUDDY_MAX_ORDER MAX_BUDDY_ORDER

static buddy_system_t buddy_data;

#define BUDDY_ARRAY (buddy_data.free_array)
#define BUDDY_MAX_ORDER_VALUE (buddy_data.max_order)
#define BUDDY_NR_FREE (buddy_data.nr_free)

static inline int is_power_of_two(size_t n) {
    return !(n == 0 || (n & (n - 1)));
}

static inline unsigned int order_of_two(size_t n) {
    unsigned int idx = 0;
    while (n >>= 1) ++idx;
    return idx;
}

static inline size_t round_down_power2(size_t n) {
    if (is_power_of_two(n)) return n;
    size_t p = 1;
    while (p < n) p <<= 1;
    return p >> 1;
}

static inline size_t round_up_power2(size_t n) {
    if (is_power_of_two(n)) return n;
    size_t p = 1;
    while (p < n) p <<= 1;
    return p;
}

static void buddy_split_block(size_t order) {
    assert(order > 0 && order <= BUDDY_MAX_ORDER_VALUE);
    assert(!list_empty(&BUDDY_ARRAY[order]));

    list_entry_t *le = list_next(&BUDDY_ARRAY[order]);
    struct Page *block = le2page(le, page_link);

    size_t half_size = 1 << (order - 1);
    struct Page *buddy = block + half_size;

    block->property = order - 1;
    buddy->property = order - 1;
    SetPageProperty(block);
    SetPageProperty(buddy);

    list_del(le);
    list_add(&BUDDY_ARRAY[order - 1], &block->page_link);
    list_add(&block->page_link, &buddy->page_link);
}

static void buddy_show_array(int left, int right) {
    assert(left >= 0 && left <= BUDDY_MAX_ORDER_VALUE);
    assert(right >= 0 && right <= BUDDY_MAX_ORDER_VALUE);

    cprintf("==== Buddy Free List ====\n");
    int nothing = 1;
    for (int i = left; i <= right; ++i) {
        list_entry_t *head = &BUDDY_ARRAY[i];
        int first = 1;
        for (list_entry_t *le = list_next(head); le != head; le = list_next(le)) {
            struct Page *pg = le2page(le, page_link);
            if (first) {
                cprintf("Order %d: ", i);
                first = 0;
            }
            cprintf("[%d pages @%p] ", 1 << pg->property, pg);
            nothing = 0;
        }
        if (!first) cprintf("\n");
    }
    if (nothing) cprintf("No free buddy blocks.\n");
    cprintf("=========================\n");
}

static void buddy_init(void) {
    for (int i = 0; i <= MAX_BUDDY_ORDER; ++i)
        list_init(&BUDDY_ARRAY[i]);
    BUDDY_MAX_ORDER_VALUE = 0;
    BUDDY_NR_FREE = 0;
}

static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    size_t blocksz = round_down_power2(n);
    unsigned int order = order_of_two(blocksz);

    for (struct Page *p = base; p < base + blocksz; ++p) {
        assert(PageReserved(p));
        p->flags = 0;
        p->property = -1;
        set_page_ref(p, 0);
    }
    BUDDY_MAX_ORDER_VALUE = order;
    BUDDY_NR_FREE = blocksz;

    list_add(&BUDDY_ARRAY[BUDDY_MAX_ORDER_VALUE], &base->page_link);
    base->property = BUDDY_MAX_ORDER_VALUE;
    SetPageProperty(base);
}

static struct Page *buddy_alloc_pages(size_t reqpg) {
    assert(reqpg > 0);

    if (reqpg > BUDDY_NR_FREE)
        return NULL;

    size_t required = round_up_power2(reqpg);
    unsigned int order = order_of_two(required);

    struct Page *alloc = NULL;
    while (!alloc) {
        if (!list_empty(&BUDDY_ARRAY[order])) {
            list_entry_t *le = list_next(&BUDDY_ARRAY[order]);
            alloc = le2page(le, page_link);
            list_del(le);
            ClearPageProperty(alloc);
        } else {
            int found = 0;
            for (int i = order + 1; i <= BUDDY_MAX_ORDER_VALUE; ++i) {
                if (!list_empty(&BUDDY_ARRAY[i])) {
                    buddy_split_block(i);
                    found = 1;
                    break;
                }
            }
            if (!found) break;
        }
    }
    if (alloc) BUDDY_NR_FREE -= required;
    return alloc;
}

static struct Page *buddy_get_buddy(struct Page *block, unsigned int order) {
    size_t offset = (size_t)block - 0xffffffffc020f318;
    size_t block_bytes = (1UL << order) * 0x28;
    size_t buddy_offset = offset ^ block_bytes;
    return (struct Page *)(buddy_offset + 0xffffffffc020f318);
}

static void buddy_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    unsigned int blocksz = 1 << base->property;
    assert(round_up_power2(n) == blocksz);

    struct Page *block = base;
    struct Page *buddy = NULL;
    list_add(&BUDDY_ARRAY[block->property], &block->page_link);

    buddy = buddy_get_buddy(block, block->property);
    while (PageProperty(buddy) && block->property < BUDDY_MAX_ORDER_VALUE) {
        if (block > buddy) {
            block->property = -1;
            SetPageProperty(base);
            struct Page *tmp = block;
            block = buddy;
            buddy = tmp;
        }
        list_del(&block->page_link);
        list_del(&buddy->page_link);
        block->property += 1;
        list_add(&BUDDY_ARRAY[block->property], &block->page_link);
        buddy = buddy_get_buddy(block, block->property);
    }
    SetPageProperty(block);
    BUDDY_NR_FREE += blocksz;
}

static size_t buddy_nr_free_pages(void) {
    return BUDDY_NR_FREE;
}

static void buddy_check_min_alloc_free(void) {
    struct Page *p = alloc_pages(1);
    cprintf("Allocated 1 page:\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
    free_pages(p, 1);
    cprintf("Freed 1 page:\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
}

static void buddy_check_max_alloc_free(void) {
    struct Page *p = alloc_pages(8192);
    cprintf("Allocated 8192 pages:\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
    free_pages(p, 8192);
    cprintf("Freed 8192 pages:\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
}

static void buddy_check_easy(void) {
    struct Page *p0 = alloc_pages(10), *p1 = alloc_pages(10), *p2 = alloc_pages(10);
    cprintf("After allocating p0, p1, p2 (10 pages each):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    free_pages(p0, 10);
    cprintf("Freed p0 (10 pages):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    free_pages(p1, 10);
    cprintf("Freed p1 (10 pages):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    free_pages(p2, 10);
    cprintf("Freed p2 (10 pages):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
}

static void buddy_check_difficult(void) {
    struct Page *p0 = alloc_pages(10), *p1 = alloc_pages(50), *p2 = alloc_pages(100);
    cprintf("After allocating p0 (10), p1 (50), p2 (100):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    free_pages(p0, 10);
    cprintf("Freed p0 (10 pages):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    free_pages(p1, 50);
    cprintf("Freed p1 (50 pages):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    free_pages(p2, 100);
    cprintf("Freed p2 (100 pages):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
}

static void buddy_check(void) {
    cprintf("Buddy system self-test\n");
    buddy_check_easy();
    buddy_check_min_alloc_free();
    buddy_check_max_alloc_free();
    buddy_check_difficult();
}

// Exported manager for PMM
const struct pmm_manager buddy_system_pmm_manager = {
    .name = "buddy_system_pmm_manager_alt",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};