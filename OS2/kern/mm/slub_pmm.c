// ------------------------SLUB 设计文档

// ------------SLUB 原理概述
// SLUB（Slab Utilization By-pass）是 Linux 内核中用于高效管理小内存对象的分配器，是 SLAB 分配器的优化版本。
// 其设计目标是通过简化内部结构、减少元数据开销，提升内存分配效率并降低内存碎片，尤其适用于频繁创建和销毁的内核对象（如进程控制块、文件描述符等）。
// 作为现代 Linux 内核的默认内存分配器，SLUB 在兼顾性能与实现复杂度方面表现优异，广泛应用于各类内核场景。

// ------------SLUB 核心思想
// 基于“预分配+固定大小”的内存管理模式：为不同大小的对象预先分配连续内存块（称为 slab），每个 slab 仅存储同一大小的对象，通过这种方式实现快速分配与释放，同时最小化内存碎片。

// ------------SLUB 主要机制
// 缓存（Caches）
// - 缓存是 SLUB 的核心管理单元，每种固定大小的对象对应一个独立缓存。缓存负责管理该大小对象的所有 slab，协调分配与释放操作。
// - 缓存通过维护对象大小、单个 slab 可容纳的对象数量等元信息，确保内存分配的高效性和一致性。
// Slab 的管理
// - Slab 是实际存储对象的内存块，以物理页为基本单位（本实现中每个 slab 对应 1 页内存），与特定缓存绑定。
// - Slab 存在三种状态：
//   - 完全空闲：slab 中所有对象均未被分配，可回收至页分配器重用。
//   - 部分分配：slab 中部分对象已分配，部分空闲，是分配操作的主要目标。
//   - 完全分配：slab 中所有对象均被占用，暂不参与新的分配。
// 对象的分配和释放
// - 分配流程：
//   1. 根据待分配对象大小，匹配到最合适的缓存（对象大小不小于需求的最小缓存）。
//   2. 在缓存的 slab 链表中查找部分分配的 slab，从中选取一个空闲对象。
//   3. 若未找到可用 slab，则通过页分配器新分配一页内存创建 slab，再从新 slab 中分配对象。
//   4. 更新 slab 的空闲对象计数和位图（标记对象为已分配）。
// - 释放流程：
//   1. 确定待释放对象所属的 slab（通过内存地址范围判断）。
//   2. 更新 slab 的位图（标记对象为空闲）和空闲对象计数。
//   3. 若释放后 slab 变为完全空闲，则将其从缓存中移除并回收至页分配器。

// ------------设计实现
// 基于 ucore 操作系统，参考 SLUB 核心思想实现简易版本，具体步骤如下：
// 1、设计思路
// 采用两层内存分配架构：
//   - 第一层（页级）：复用现有页分配器（如 First-Fit 算法），负责管理物理页的分配与回收，为大内存需求（≥ 页大小）提供支持。
//   - 第二层（对象级）：基于页级分配器实现 SLUB 机制，管理小于页大小的小对象分配，每个 slab 对应 1 页内存，内部划分为“slab 元数据 + 对象存储区 + 位图”三部分：
//     
//     slab 元数据（slab_t 结构体） || 多个固定大小对象 || 位图（标记对象分配状态）
//     
//     其中，位图用 1 位表示一个对象的分配状态（1 为已分配，0 为空闲），节省元数据开销。
// 2、核心数据结构
// typedef struct Slab {        // 管理单个 slab 的元数据
//     list_entry_t list;       // 用于链接到所属缓存的 slab 链表
//     size_t free_cnt;         // 当前 slab 中的空闲对象数量
//     void *objs;              // 指向对象存储区的起始地址
//     unsigned char *bitmap;   // 指向位图的起始地址，标记对象分配状态
// } slab_t;
// 
// typedef struct Cache {       // 管理同一大小对象的缓存
//     list_entry_t slabs;      // 链接该缓存下的所有 slab
//     size_t obj_size;         // 该缓存管理的对象大小
//     size_t objs_num;         // 单个 slab 可容纳的对象数量
// } cache_t;
// 3、初始化流程
// 初始化分为两层，确保页级和对象级分配器均就绪：
//   - 页级初始化：调用默认页分配器的初始化函数（default_init），初始化空闲页链表和计数器。
//   - 缓存初始化：创建 3 个缓存（分别对应 32B、64B、128B 对象），计算每个缓存中单个 slab 可容纳的对象数量（公式：(页大小 - slab 元数据大小) / (对象大小 + 1/8)，确保总占用不超过 1 页），并初始化缓存的 slab 链表。
//   示例代码：
//   static cache_t caches[3];  // 3 个固定大小的缓存
//   static size_t cache_n = 3; // 缓存数量
//   static void cache_init(void) {
//       size_t sizes[3] = {32, 64, 128};
//       for (int i = 0; i < cache_n; i++) {
//           caches[i].obj_size = sizes[i];
//           caches[i].objs_num = calculate_objs_num(sizes[i]); // 计算对象数量
//           list_init(&caches[i].slabs);
//       }
//   }
// 4、分配与释放实现
// 分配操作（slub_alloc_obj）：
//   1. 根据待分配大小，查找最小适配的缓存（对象大小 ≥ 需求），无适配缓存则返回 NULL。
//   2. 遍历缓存的 slab 链表，查找有空闲对象的 slab：
//      - 找到后通过位图定位第一个空闲对象，更新位图（标记为已分配）和空闲计数，返回对象地址。
//   3. 若无可用 slab，则调用页分配器分配 1 页内存，创建新 slab 并添加到缓存链表，从新 slab 分配第一个对象。
// 释放操作（slub_free_obj）：
//   1. 遍历所有缓存和 slab，通过地址范围判断对象所属的 slab。
//   2. 找到后更新位图（标记为空闲）和空闲计数，将对象内存清零。
//   3. 若 slab 变为完全空闲（空闲计数 = 总对象数），则将其从缓存链表移除，调用页分配器回收该页。

// ------------测试代码
// 为验证 SLUB 实现的正确性，设计以下测试用例，覆盖核心功能与边界场景：
// - 边界测试：验证分配 0 字节或超过最大缓存大小（256B）的对象时，返回 NULL。
// - 基本功能测试：单次分配/释放 32B 对象，验证内存读写和释放后清零的正确性。
// - 多对象测试：分配 10 个 64B 对象，验证每个对象的独立存储和释放后状态。
// - 批量操作测试：分配/释放大量（10000 个）25B、62B、124B 对象，验证内存计数和回收的准确性。
// - 混合场景测试：交替分配/释放不同大小对象（32B、64B、128B），验证 slab 状态转换和内存管理的一致性。
// 所有测试通过断言确保逻辑正确，输出日志记录关键步骤和结果。

#include <pmm.h>
#include <list.h>
#include <string.h>
#include <slub_pmm.h>
#include <stdio.h>

static free_area_t mem_pool;

#define free_links (mem_pool.free_list)
#define free_total (mem_pool.nr_free)

#define le2slab(le, member) to_struct((le), struct Slab, member)

typedef struct Slab {
    list_entry_t link;
    size_t free_objs;
    void *obj_base;
    unsigned char *map;
} slab_t;

typedef struct Cache {
    list_entry_t slabs;
    size_t obj_sz;
    size_t obj_cnt;
} cache_t;

static cache_t cache_set[3];
static size_t cache_num = 0;

static size_t get_obj_count(size_t sz) {
    size_t slab_sz = sizeof(slab_t);
    size_t max = ((PGSIZE - slab_sz) / (sz + 0.125));
    return max == 0 ? 1 : max;
}

static void init_cache_set(void) {
    cache_num = 3;
    size_t sizes[3] = {32, 64, 128};
    for (int i = 0; i < cache_num; i++) {
        cache_set[i].obj_sz = sizes[i];
        cache_set[i].obj_cnt = get_obj_count(sizes[i]);
        list_init(&cache_set[i].slabs);
    }
}

static void init_base(void) {
    list_init(&free_links);
    free_total = 0;
}

static void slub_init(void) {
    init_base();
    init_cache_set();
}

static void init_mem_map(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    free_total += n;
    if (list_empty(&free_links)) {
        list_add(&free_links, &(base->page_link));
    } else {
        list_entry_t *le = &free_links;
        while ((le = list_next(le)) != &free_links) {
            struct Page *page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_links) {
                list_add(le, &(base->page_link));
            }
        }
    }
}

static void slub_init_memmap(struct Page *base, size_t n) {
    init_mem_map(base, n);
}

static struct Page *alloc_base_pages(size_t n) {
    assert(n > 0);
    if (n > free_total) return NULL;
    struct Page *page = NULL;
    list_entry_t *le = &free_links;
    while ((le = list_next(le)) != &free_links) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
        list_entry_t *prev = list_prev(&(page->page_link));
        list_del(&(page->page_link));
        if (page->property > n) {
            struct Page *p = page + n;
            p->property = page->property - n;
            SetPageProperty(p);
            list_add(prev, &(p->page_link));
        }
        free_total -= n;
        ClearPageProperty(page);
    }
    return page;
}

static slab_t *create_new_slab(size_t sz, size_t cnt) {
    struct Page *page = alloc_base_pages(1);
    if (!page) return NULL;
    void *kva = KADDR(page2pa(page));
    slab_t *slab = (slab_t *)kva;
    slab->free_objs = cnt;
    slab->obj_base = (void *)slab + sizeof(slab_t);
    slab->map = (unsigned char *)((void *)slab->obj_base + sz * cnt);
    memset(slab->map, 0, (cnt + 7) / 8);
    list_init(&slab->link);
    return slab;
}

static void *slub_alloc_object(size_t sz) {
    if (sz <= 0) return NULL;
    cache_t *cache = NULL;
    for (int i = 0; i < cache_num; i++) {
        if (cache_set[i].obj_sz >= sz) {
            cache = &cache_set[i];
            break;
        }
    }
    if (!cache) return NULL;
    list_entry_t *le = &cache->slabs;
    while ((le = list_next(le)) != &cache->slabs) {
        slab_t *slab = le2slab(le, link);
        if (slab->free_objs > 0) {
            for (size_t i = 0; i < cache->obj_cnt; i++) {
                size_t b = i / 8;
                size_t bit = i % 8;
                if (!(slab->map[b] & (1 << bit))) {
                    slab->map[b] |= (1 << bit);
                    slab->free_objs--;
                    return (void *)slab->obj_base + i * cache->obj_sz;
                }
            }
        }
    }
    slab_t *new_slab = create_new_slab(cache->obj_sz, cache->obj_cnt);
    if (!new_slab) return NULL;
    list_add(&cache->slabs, &new_slab->link);
    new_slab->map[0] |= 1;
    new_slab->free_objs--;
    return new_slab->obj_base;
}

static void free_base_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    free_total += n;
    if (list_empty(&free_links)) {
        list_add(&free_links, &(base->page_link));
    } else {
        list_entry_t *le = &free_links;
        while ((le = list_next(le)) != &free_links) {
            struct Page *page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_links) {
                list_add(le, &(base->page_link));
            }
        }
    }
    list_entry_t *le = list_prev(&(base->page_link));
    if (le != &free_links) {
        p = le2page(le, page_link);
        if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            list_del(&(base->page_link));
            base = p;
        }
    }
    le = list_next(&(base->page_link));
    if (le != &free_links) {
        p = le2page(le, page_link);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
    }
}

static void slub_free_object(void *obj) {
    for (size_t i = 0; i < cache_num; i++) {
        cache_t *cache = &cache_set[i];
        list_entry_t *le = &cache->slabs;
        while ((le = list_next(le)) != &cache->slabs) {
            slab_t *slab = le2slab(le, link);
            if (obj >= slab->obj_base && obj < (slab->obj_base + cache->obj_sz * cache->obj_cnt)) {
                size_t off = (char *)obj - (char *)slab->obj_base;
                size_t idx = off / cache->obj_sz;
                size_t b = idx / 8;
                size_t bit = idx % 8;
                if (slab->map[b] & (1 << bit)) {
                    slab->map[b] &= ~(1 << bit);
                    slab->free_objs++;
                    memset(obj, 0, cache->obj_sz);
                    if (slab->free_objs == cache->obj_cnt) {
                        list_del(&slab->link);
                        free_base_pages(pa2page(PADDR(slab)), 1);
                    }
                }
                return;
            }
        }
    }
}

static size_t slub_get_free_pages(void) {
    return free_total;
}

static void slub_run_tests(void) {
    cprintf("Starting SLUB allocator tests...\n\n");
    cprintf("The slab struct size is %d\n", sizeof(slab_t));
    cprintf("----------------------START-------------------------\n");
    size_t exp[3] = {126, 63, 31};
    for (int i = 0; i < cache_num; i++) {
        assert(cache_set[i].obj_cnt == exp[i]);
    }
    size_t init_free = free_total;
    {
        void *obj = slub_alloc_object(0);
        assert(obj == NULL);
        obj = slub_alloc_object(256);
        assert(obj == NULL);
        cprintf("Boundary check passed. \n");
    }
    {
        void *obj1 = slub_alloc_object(32);
        assert(obj1 != NULL);
        cprintf("Allocated 32-byte object at %p\n", obj1);
        memset(obj1, 0x66, 32);
        for (int i = 0; i < 32; i++) {
            assert(((unsigned char *)obj1)[i] == 0x66);
        }
        cprintf("Memory alloc verification passed. \n");
        slub_free_object(obj1);
        void *obj2 = slub_alloc_object(32);
        cprintf("Allocated 32-byte object at %p\n", obj2);
        for (int i = 0; i < 32; i++) {
            assert(((unsigned char *)obj2)[i] == 0x00);
        }
        slub_free_object(obj2);
        cprintf("Memory free verification passed. \n");
    }
    {
        const int cnt = 10;
        void *objs[cnt];
        cprintf("Allocating %d objects of size 64 bytes.\n", cnt);
        for (int i = 0; i < cnt; i++) {
            objs[i] = slub_alloc_object(64);
            assert(objs[i] != NULL);
            memset(objs[i], i, 64);
        }
        for (int i = 0; i < cnt; i++) {
            for (int j = 0; j < 64; j++) {
                assert(((unsigned char *)objs[i])[j] == (unsigned char)i);
            }
        }
        cprintf("Memory verification for 64-byte objects passed.\n");
        for (int i = 0; i < cnt; i++) {
            slub_free_object(objs[i]);
            cprintf("Freed 64-byte object at %p\n", objs[i]);
            for (int j = 0; j < 64; j++) {
                assert(((unsigned char *)objs[i])[j] == 0x00);
            }
        }
        cprintf("Memory free verification for 64-byte objects passed.\n");
    }
    {
        size_t f2, f3, f4;
        cprintf("Bulk allocation release check start.\n");
        assert(init_free == free_total);
        void *bulk[50000];
        for (int i = 1; i <= 10000; i++) {
            bulk[i - 1] = slub_alloc_object(25);
            assert(free_total == init_free - (i + 125) / 126);
        }
        f2 = free_total;
        for (int i = 1; i <= 10000; i++) {
            bulk[i + 9999] = slub_alloc_object(62);
            assert(free_total == f2 - (i + 62) / 63);
        }
        f3 = free_total;
        for (int i = 1; i <= 10000; i++) {
            bulk[i + 19999] = slub_alloc_object(124);
            assert(free_total == f3 - (i + 30) / 31);
        }
        f4 = free_total;
        for (int i = 1; i <= 10000; i++) {
            bulk[i + 29999] = slub_alloc_object(129 + i % 666);
            assert(free_total == f4);
        }
        for (int i = 0; i < 40000; i++) {
            if (i < 30000) {
                assert(bulk[i] != NULL);
                slub_free_object(bulk[i]);
            } else {
                assert(bulk[i] == NULL);
            }
        }
        assert(free_total == init_free);
        cprintf("Bulk allocation release check passed.\n");
    }
    {
        cprintf("Mixed check start.\n");
        void *o1 = slub_alloc_object(32);
        assert(o1 != NULL);
        cprintf("Allocated 32-byte object at %p\n", o1);
        assert(free_total == init_free - 1);
        void *o2 = slub_alloc_object(64);
        assert(o2 != NULL);
        cprintf("Allocated 64-byte object at %p\n", o2);
        assert(free_total == init_free - 2);
        void *o3 = slub_alloc_object(128);
        assert(o3 != NULL);
        cprintf("Allocated 128-byte object at %p\n", o3);
        assert(free_total == init_free - 3);
        void *o4 = slub_alloc_object(32);
        assert(o4 != NULL);
        cprintf("Allocated second 32-byte object at %p\n", o4);
        assert(free_total == init_free - 3);
        void *obs[100];
        for (int i = 1; i <= 29; i++) {
            obs[i] = slub_alloc_object(128);
        }
        void *o5 = slub_alloc_object(128);
        assert(o5 != NULL);
        cprintf("Allocated 31th 128-byte object at %p\n", o5);
        assert(free_total == init_free - 3);
        void *o6 = slub_alloc_object(128);
        assert(o6 != NULL);
        cprintf("Allocated 32th(new slam) 128-byte object at %p\n", o6);
        assert(free_total == init_free - 4);
        for (int i = 1; i <= 29; i++) {
            slub_free_object(obs[i]);
        }
        assert(free_total == init_free - 4);
        slub_free_object(o1);
        assert(free_total == init_free - 4);
        slub_free_object(o2);
        assert(free_total == init_free - 3);
        slub_free_object(o3);
        assert(free_total == init_free - 3);
        slub_free_object(o4);
        assert(free_total == init_free - 2);
        slub_free_object(o5);
        assert(free_total == init_free - 1);
        slub_free_object(o6);
        assert(free_total == init_free);
        cprintf("Mixed check passed.\n");
    }
    cprintf("----------------------END-------------------------\n");
}

const struct pmm_manager slub_pmm_manager = {
    .name = "slub_pmm_manager",
    .init = slub_init,
    .init_memmap = slub_init_memmap,
    .alloc_pages = alloc_base_pages,
    .free_pages = free_base_pages,
    .nr_free_pages = slub_get_free_pages,
    .check = slub_run_tests,
};