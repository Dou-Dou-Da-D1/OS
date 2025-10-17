#ifndef __KERN_MM_BUDDY_SYSTEM_PMM_H__
#define __KERN_MM_BUDDY_SYSTEM_PMM_H__

#include <pmm.h>
#include <list.h>  

#define MAX_BUDDY_ORDER 14

typedef struct {
    list_entry_t free_array[MAX_BUDDY_ORDER + 1];
    unsigned int max_order;  
    unsigned int nr_free;    
} buddy_system_t;

extern const struct pmm_manager buddy_system_pmm_manager;

extern struct Page *get_buddy(struct Page *block_addr, unsigned int block_size);

#endif /* ! __KERN_MM_BUDDY_SYSTEM_PMM_H__ */
