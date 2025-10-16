#ifndef __KERN_MM_BUDDY_SYSTEM_PMM_H__
#define __KERN_MM_BUDDY_SYSTEM_PMM_H__

#include <pmm.h>
#include <list.h>  

// 1. 定义最大阶数
#define MAX_BUDDY_ORDER 14

// 2. 声明伙伴系统管理结构体
typedef struct {
    // 各阶空闲块链表：free_array[k]对应大小为2^k页的块
    list_entry_t free_array[MAX_BUDDY_ORDER + 1];
    unsigned int max_order;  // 当前系统支持的最大块阶数
    unsigned int nr_free;    // 总空闲页数
} buddy_system_t;

// 3. 声明伙伴系统管理器实例
extern const struct pmm_manager buddy_system_pmm_manager;

// 4. 声明辅助函数
extern struct Page *get_buddy(struct Page *block_addr, unsigned int block_size);

#endif /* ! __KERN_MM_BUDDY_SYSTEM_PMM_H__ */
