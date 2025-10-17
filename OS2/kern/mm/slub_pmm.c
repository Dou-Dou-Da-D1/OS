#include <pmm.h>
#include <list.h>
#include <string.h>
#include <slub_pmm.h>
#include <stdio.h>

#ifndef KADDR
#define KADDR(pa) ((void *)((uintptr_t)(pa) + KERNBASE))
#endif

#define le2slub_block(le, member) to_struct((le), struct SlubBlock, member)

static free_area_t area;
#define free_list (area.free_list)
#define nr_free (area.nr_free)

static slub_cache_t slub_caches[3];
static size_t slub_cache_count = 0;

static size_t slub_calc_obj_num(size_t obj_size) {
    size_t block_head_sz = sizeof(slub_block_t);
    size_t total_usable_sz = PGSIZE - block_head_sz;
    size_t obj_total_sz = obj_size + (1 / 8);
    size_t obj_num = total_usable_sz / obj_total_sz;
    return obj_num > 0 ? obj_num : 1;
}

static void slub_cache_init(void) {
    slub_cache_count = 3;
    size_t obj_sizes[3] = {32, 64, 128};
    for (int i = 0; i < slub_cache_count; i++) {
        slub_caches[i].obj_size = obj_sizes[i];
        slub_caches[i].obj_num = slub_calc_obj_num(obj_sizes[i]);
        list_init(&slub_caches[i].blocks);
    }
}

static void area_init(void) {
    list_init(&free_list);
    nr_free = 0;
}

void slub_init(void) {
    area_init();
    slub_cache_init();
}

static void area_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t *le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page *page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }
}

void slub_init_memmap(struct Page *base, size_t n) {
    area_init_memmap(base, n);
}

struct Page *area_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) return NULL;
    struct Page *result = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            result = p;
            break;
        }
    }
    if (result) {
        list_entry_t *prev_le = list_prev(&(result->page_link));
        list_del(&(result->page_link));
        if (result->property > n) {
            struct Page *remain_page = result + n;
            remain_page->property = result->property - n;
            SetPageProperty(remain_page);
            list_add(prev_le, &(remain_page->page_link));
        }
        nr_free -= n;
        ClearPageProperty(result);
    }
    return result;
}

static slub_block_t *slub_block_create(size_t obj_size, size_t obj_num) {
    struct Page *page = area_alloc_pages(1);
    if (!page) return NULL;
    void *page_vaddr = KADDR(page2pa(page));
    slub_block_t *blk = (slub_block_t *)page_vaddr;
    blk->free_cnt = obj_num;
    blk->objs = (void *)blk + sizeof(slub_block_t);
    blk->bitmap = (unsigned char *)(blk->objs + obj_size * obj_num);
    memset(blk->bitmap, 0, (obj_num + 7) / 8);
    list_init(&blk->node);
    return blk;
}

void *slub_alloc_obj(size_t size) {
    if (size == 0 || size > 128) return NULL;
    slub_cache_t *target_cache = NULL;
    for (int i = 0; i < slub_cache_count; i++) {
        if (slub_caches[i].obj_size >= size) {
            target_cache = &slub_caches[i];
            break;
        }
    }
    if (!target_cache) return NULL;
    list_entry_t *le = &target_cache->blocks;
    while ((le = list_next(le)) != &target_cache->blocks) {
        slub_block_t *blk = le2slub_block(le, node);
        if (blk->free_cnt > 0) {
            for (size_t obj_idx = 0; obj_idx < target_cache->obj_num; obj_idx++) {
                size_t byte_idx = obj_idx / 8;
                size_t bit_idx = obj_idx % 8;
                if (!(blk->bitmap[byte_idx] & (1 << bit_idx))) {
                    blk->bitmap[byte_idx] |= (1 << bit_idx);
                    blk->free_cnt--;
                    return blk->objs + obj_idx * target_cache->obj_size;
                }
            }
        }
    }
    slub_block_t *new_blk = slub_block_create(target_cache->obj_size, target_cache->obj_num);
    if (!new_blk) return NULL;
    list_add(&target_cache->blocks, &new_blk->node);
    new_blk->bitmap[0] |= 1 << 0;
    new_blk->free_cnt--;
    return new_blk->objs;
}

void area_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    nr_free += n;
    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t *le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page *page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }
    list_entry_t *prev_le = list_prev(&(base->page_link));
    if (prev_le != &free_list) {
        p = le2page(prev_le, page_link);
        if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            list_del(&(base->page_link));
            base = p;
        }
    }
    list_entry_t *next_le = list_next(&(base->page_link));
    if (next_le != &free_list) {
        p = le2page(next_le, page_link);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
    }
}

void slub_free_obj(void *obj) {
    if (!obj) return;
    for (size_t cache_idx = 0; cache_idx < slub_cache_count; cache_idx++) {
        slub_cache_t *cache = &slub_caches[cache_idx];
        list_entry_t *le = &cache->blocks;
        while ((le = list_next(le)) != &cache->blocks) {
            slub_block_t *blk = le2slub_block(le, node);
            void *obj_start = blk->objs;
            void *obj_end = obj_start + cache->obj_size * cache->obj_num;
            if (obj >= obj_start && obj < obj_end) {
                size_t obj_offset = (char *)obj - (char *)obj_start;
                size_t obj_idx = obj_offset / cache->obj_size;
                size_t byte_idx = obj_idx / 8;
                size_t bit_idx = obj_idx % 8;
                if (blk->bitmap[byte_idx] & (1 << bit_idx)) {
                    blk->bitmap[byte_idx] &= ~(1 << bit_idx);
                    blk->free_cnt++;
                    memset(obj, 0, cache->obj_size);
                    if (blk->free_cnt == cache->obj_num) {
                        list_del(&blk->node);
                        struct Page *blk_page = pa2page(PADDR(blk));
                        area_free_pages(blk_page, 1);
                    }
                }
                return;
            }
        }
    }
}

size_t slub_nr_free_pages(void) {
    return nr_free;
}

void slub_check(void) {
    // 替换%zu为%lu，size_t转换为unsigned long
    cprintf("SLUB allocator check: slub_block struct size = %lu bytes\n", (unsigned long)sizeof(slub_block_t));
    size_t expect_obj_num[3] = {126, 63, 31};
    for (int i = 0; i < slub_cache_count; i++) {
        assert(slub_caches[i].obj_num == expect_obj_num[i]);
        // 替换%zu为%lu，变量转换为unsigned long
        cprintf("Cache %d: obj_size=%luB, obj_num=%lu\n", 
                i, (unsigned long)slub_caches[i].obj_size, (unsigned long)slub_caches[i].obj_num);
    }
    size_t base_free_pages = nr_free;
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("Initial free pages: %lu\n", (unsigned long)base_free_pages);
    
    assert(slub_alloc_obj(0) == NULL);
    assert(slub_alloc_obj(256) == NULL);
    cprintf("Boundary test passed: alloc 0B/256B → NULL\n");
    
    // 新增：标记进入单个对象测试
    cprintf("Start single object test...\n");
    void *obj1 = slub_alloc_obj(32);
    // 新增：打印 obj1 是否为 NULL
    cprintf("obj1 address: %p\n", obj1);
    assert(obj1 != NULL);  // 若 obj1 是 NULL，这里会 panic
    
    memset(obj1, 0x66, 32);
    // 新增：标记 memset 完成
    cprintf("memset obj1 done...\n");
    for (int i = 0; i < 32; i++) {
        assert(((unsigned char *)obj1)[i] == 0x66);
    }
    slub_free_obj(obj1);
    cprintf("Single object (32B) alloc/free test passed\n");
    
    void *objs[10];
    for (int i = 0; i < 10; i++) {
        objs[i] = slub_alloc_obj(64);
        assert(objs[i] != NULL);
        memset(objs[i], i, 64);
        for (int j = 0; j < 64; j++) {
            assert(((unsigned char *)objs[i])[j] == (unsigned char)i);
        }
    }
    for (int i = 0; i < 10; i++) {
        slub_free_obj(objs[i]);
        for (int j = 0; j < 64; j++) {
            assert(((unsigned char *)objs[i])[j] == 0x00);
        }
    }
    cprintf("Multiple objects (64B) alloc/free test passed\n");
    
    void *bulk_objs[30000];
    size_t free_pages_mid1, free_pages_mid2;
    
    for (int i = 0; i < 10000; i++) {
        bulk_objs[i] = slub_alloc_obj(25);
        assert(bulk_objs[i] != NULL);
    }
    free_pages_mid1 = nr_free;
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("After alloc 10000×25B: free pages = %lu\n", (unsigned long)free_pages_mid1);
    
    for (int i = 0; i < 10000; i++) {
        bulk_objs[10000 + i] = slub_alloc_obj(62);
        assert(bulk_objs[10000 + i] != NULL);
    }
    free_pages_mid2 = nr_free;
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("After alloc 10000×62B: free pages = %lu\n", (unsigned long)free_pages_mid2);
    
    for (int i = 0; i < 10000; i++) {
        bulk_objs[20000 + i] = slub_alloc_obj(124);
        assert(bulk_objs[20000 + i] != NULL);
    }
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("After alloc 10000×124B: free pages = %lu\n", (unsigned long)nr_free);
    
    for (int i = 0; i < 30000; i++) {
        slub_free_obj(bulk_objs[i]);
    }
    assert(nr_free == base_free_pages);
    // 替换%zu为%lu，变量转换为unsigned long
    cprintf("Bulk objects alloc/free test passed: free pages restored to %lu\n", (unsigned long)nr_free);
    
    void *o1 = slub_alloc_obj(32), *o2 = slub_alloc_obj(64), *o3 = slub_alloc_obj(128);
    void *o4 = slub_alloc_obj(32), *o5 = slub_alloc_obj(128), *o6 = slub_alloc_obj(128);
    void *objs2[30];
    for (int i = 0; i < 29; i++) {
        objs2[i] = slub_alloc_obj(128);
    }
    assert(o5 != NULL && o6 != NULL);
    
    for (int i = 0; i < 29; i++) slub_free_obj(objs2[i]);
    slub_free_obj(o1); slub_free_obj(o2); slub_free_obj(o3);
    slub_free_obj(o4); slub_free_obj(o5); slub_free_obj(o6);
    assert(nr_free == base_free_pages);
    cprintf("Complex mixed alloc/free test passed\n");
    
    cprintf("All SLUB allocator checks passed!\n");
}

const struct pmm_manager slub_pmm_manager = {
    .name = "slub_pmm_manager_alt",
    .init = slub_init,
    .init_memmap = slub_init_memmap,
    .alloc_pages = area_alloc_pages,
    .free_pages = area_free_pages,
    .nr_free_pages = slub_nr_free_pages,
    .check = slub_check
};