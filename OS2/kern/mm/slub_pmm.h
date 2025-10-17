#ifndef __SLUB_PMM_H__
#define __SLUB_PMM_H__

#include <list.h>
#include <memlayout.h>
#include <pmm.h>

typedef struct SlubBlock {
    list_entry_t node;      // 链表节点
    size_t free_cnt;        // 当前空闲对象数
    void *objs;             // 对象起始指针
    unsigned char *bitmap;  // 位图
} slub_block_t;

typedef struct SlubCache {
    list_entry_t blocks;    // 该cache下的所有slub_block链表
    size_t obj_size;        // 每个对象大小
    size_t obj_num;         // 每个slub_block包含对象数
} slub_cache_t;

// 导出SLUB分配器管理器
extern const struct pmm_manager slub_pmm_manager;

// SLUB分配和释放接口
void *slub_alloc_obj(size_t size);
void slub_free_obj(void *obj);
size_t slub_nr_free_pages(void);
void slub_check(void);

#endif // __SLUB_PMM_H__