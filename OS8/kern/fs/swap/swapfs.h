#ifndef __KERN_FS_SWAP_SWAPFS_H__
#define __KERN_FS_SWAP_SWAPFS_H__

#include <memlayout.h>

void swapfs_init(void);
int swapfs_read(swap_entry_t entry, struct Page *page);
int swapfs_write(swap_entry_t entry, struct Page *page);

// Extract offset from swap entry
static inline size_t swap_offset(swap_entry_t entry) {
    return (entry >> 8);
}

#endif /* !__KERN_FS_SWAP_SWAPFS_H__ */
