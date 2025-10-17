# <center>Lab2</center>

<center>程娜 张丝童</center>

## 练习1：理解first-fit 连续物理内存分配算法(思考题)

### 主要思想

First-Fit算法通过维护**按物理地址排序的空闲块链表**，在分配内存时优先查找并使用链表中**第一个大小满足需求的空闲块**，释放内存时将块按地址插入链表并**合并相邻空闲块**以减少碎片。

### 代码分析

#### default_init

```c
static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
```

该函数用于**初始化物理内存管理中的空闲块链表**，首先**调用 `list_init` 函数，初始化一个空的双向链表 `free_list`**，然后**将 `nr_free`（即空闲块的个数）定义为 0**。以下为对应的`list_init`函数的定义。

```c
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
}
```

#### default_init_memmap

```c
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
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
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }
}
```

该函数用于**初始化一段连续的空闲内存块**。参数`base`指向页面结构体数组的起始地址，代表需要初始化的连续内存页面；参数`n`是需要初始化的页面数量。

首先，通过`assert(n > 0)`判断`n`是否大于 0，确保需要初始化的页面数量不为 0，若为 0 则无需进行后续操作。

然后，定义一个指向Page结构体的指针`p`，并将其初始化为`base`所指向的地址。通过for循环遍历从`base`到`base + n`的每一个页面：先通过`assert(PageReserved(p))`判断当前页面是否为保留页面，若为保留页面，则将该页面的`flags`和`property`均初始化为 0，同时调用 `set_page_ref(p, 0)` 将页面的引用计数设为 0。

其中`set_page_ref`函数的定义为：

```c
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
```

其作用是直接将指定Page结构体的`ref`成员赋值为`val`，此处即设置为 0，表示该页面当前无任何引用。

遍历完成后，将起始页面`base`的`property`属性设置为`n`，表示该空闲块包含n个连续页面；调用 `SetPageProperty(base)` 为起始页面设置`PG_property`标志（通过原子操作设置flags中的对应位），标识其为空闲块的头部。随后，**更新系统空闲页面总数`nr_free`**，使其增加n，将新初始化的n个页面纳入空闲计数。

最后，将该空闲块插入空闲页面链表`free_list`，以维持所有空闲块的有序管理：

- 若通过`list_empty(&free_list)`判断链表为空，则调用 `list_add(&free_list, &(base->page_link))` 将起始页面的链表节点添加到链表中。`list_add`函数的定义为：

    ```c
    static inline void
    list_add(list_entry_t *listelm, list_entry_t *elm) {
        list_add_after(listelm, elm);
    }
    ```

    ```c
    static inline void
    list_add_after(list_entry_t *listelm, list_entry_t *elm) {
        __list_add(elm, listelm, listelm->next);
    }
    ```

- 若链表不为空，则通过循环遍历链表：用`le2page`将链表项转换为对应的Page结构，找到第一个地址大于`base`的页面，调用 `list_add_before(le, &(base->page_link))` 在其之前插入新节点。`list_add_before`函数的定义为：

    ```c
    static inline void
    list_add_before(list_entry_t *listelm, list_entry_t *elm) {
        __list_add(elm, listelm->prev, listelm);
    }
    ```

    其作用是在`listelm`节点前插入`elm`节点，确保新块按物理地址升序插入；若遍历至链表末尾仍未找到，则调用`list_add(le, &(base->page_link))`将新节点添加到链表末尾。通过这种方式，**保证空闲链表始终按物理地址从小到大排序**，为后续分配算法高效查找空闲块提供基础。

#### default_alloc_pages

```c
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
        list_entry_t* prev = list_prev(&(page->page_link));
        list_del(&(page->page_link));
        if (page->property > n) {
            struct Page *p = page + n;
            p->property = page->property - n;
            SetPageProperty(p);
            list_add(prev, &(p->page_link));
        }
        nr_free -= n;
        ClearPageProperty(page);
    }
    return page;
}
```

该函数**从空闲链表中找到第一个能容纳n个页的空闲块**。

首先通过`assert(n > 0)`验证请求有效，若n超过总空闲页`nr_free`，直接返回NULL。

接着遍历空闲链表`free_list`，用`le2page`转换链表项为`Page`结构，检查块大小（`p->property`）是否≥n，找到第一个符合条件的块后退出循环。若找到块，先将其从链表中移除。若块大小>n，从`page + n`处分割剩余部分，标记为新空闲块并插回链表。

最后更新空闲页总数，清除原块的空闲标志，返回分配的块起始页。

#### default_free_pages

```c
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
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
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);
            if (base < page) {
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }

    list_entry_t* le = list_prev(&(base->page_link));
    if (le != &free_list) {
        p = le2page(le, page_link);
        if (p + p->property == base) {
            p->property += base->property;
            ClearPageProperty(base);
            list_del(&(base->page_link));
            base = p;
        }
    }

    le = list_next(&(base->page_link));
    if (le != &free_list) {
        p = le2page(le, page_link);
        if (base + base->property == p) {
            base->property += p->property;
            ClearPageProperty(p);
            list_del(&(p->page_link));
        }
    }
}
```

该函数用于**释放内存块**。将释放的内存块按照顺序插入到空闲内存块的链表中，并**合并与之相邻且连续的空闲内存块**。

首先验证释放页数有效，遍历释放的页面：确保非保留页且未标记为空闲块头，重置标志位并设引用计数为0。接着标记`base`为空闲块头，更新空闲页总数。

随后按地址升序将空闲块插入链表，**维持链表有序性**。最后关键操作是合并相邻块：检查前向和后向链表节点，若物理地址连续则合并，有效减少外部碎片。

#### default_nr_free_pages

```c
static size_t
default_nr_free_pages(void) {
    return nr_free;
}
```

该函数用于**获取当前的空闲页面的数量**。

#### basic_check

```c
static void
basic_check(void) {
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    assert(alloc_page() == NULL);

    free_page(p0);
    free_page(p1);
    free_page(p2);
    assert(nr_free == 3);

    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(alloc_page() == NULL);

    free_page(p0);
    assert(!list_empty(&free_list));

    struct Page *p;
    assert((p = alloc_page()) == p0);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    free_list = free_list_store;
    nr_free = nr_free_store;

    free_page(p);
    free_page(p1);
    free_page(p2);
}
```

`basic_check`用于**验证物理内存管理的基础功能**：测试页面分配/释放的有效性、引用计数正确性、地址合法性及空闲链表基本操作，确保简单场景下的逻辑无误。

#### default_check

```c
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
    assert(p0 != NULL);
    assert(!PageProperty(p0));

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
    assert(alloc_pages(4) == NULL);
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
    assert((p1 = alloc_pages(3)) != NULL);
    assert(alloc_page() == NULL);
    assert(p0 + 2 == p1);

    p2 = p0 + 1;
    free_page(p0);
    free_pages(p1, 3);
    assert(PageProperty(p0) && p0->property == 1);
    assert(PageProperty(p1) && p1->property == 3);

    assert((p0 = alloc_page()) == p2 - 1);
    free_page(p0);
    assert((p0 = alloc_pages(2)) == p2 + 1);

    free_pages(p0, 2);
    free_page(p2);

    assert((p0 = alloc_pages(5)) != NULL);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
    assert(total == 0);
}
```

`default_check`是**对算法的全面校验**：先验证空闲块状态与计数一致性，再通过多页分配、部分释放、块合并等复杂场景测试算法逻辑，最后确认状态恢复正确，确保算法在各类场景下的正确性。

#### 结构体default_pmm_manager

```c
const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = default_init,
    .init_memmap = default_init_memmap,
    .alloc_pages = default_alloc_pages,
    .free_pages = default_free_pages,
    .nr_free_pages = default_nr_free_pages,
    .check = default_check,
};
```

这个结构体定义了默认的物理内存管理器，包含标识名称和一系列函数指针，封装了内存管理的核心操作。以下是各成员的解释：

- `.name = "default_pmm_manager"`：标识该内存管理器的名称。
- `.init = default_init`：初始化内存管理器的状态（如空闲链表）。
- `.init_memmap = default_init_memmap`：将连续内存页初始化为空闲块。
- `.alloc_pages = default_alloc_pages`：按First-Fit算法分配连续页面。
- `.free_pages = default_free_pages`：释放页面并合并相邻空闲块。
- `.nr_free_pages = default_nr_free_pages`：获取当前空闲页面总数。
- `.check = default_check`：检查内存管理功能的正确性。

### 程序在进行物理内存分配的过程以及各个函数的作用

- default_init：**初始化物理内存管理中的空闲块链表**，将空闲块的个数设置为0。
- default_init_memmap：**初始化一段连续的空闲内存块**，先查询空闲内存块的链表，按照地址顺序插入到合适的位置，并将空闲内存块个数加n。
- default_alloc_pages：**找到第一个能容纳n个页的空闲块**，如果剩余空闲内存块大小多于所需的内存区块大小，则从链表中查找大小超过所需大小的页，并更新该页剩余的大小。
- default_free_pages：**释放内存块**，将释放的内存块按照顺序插入到空闲内存块的链表中，并合并与之相邻且连续的空闲内存块。
- default_nr_free_pages：**获取当前的空闲页面的数量。**
- basic_check：**验证物理内存管理的基础功能。**
- default_check：**对算法的全面校验。**
- 结构体default_pmm_manager：方便后续的调用，写成了结构体。

### 改进空间

First-Fit算法的改进空间主要集中在减少内存碎片、提升分配效率和优化管理机制等方面：  

1. **减少外部碎片**：First Fit在频繁分配/释放不同大小块后，易在低地址区域产生大量小碎片。可增加**碎片合并触发机制**，如当小碎片占比超过阈值时，主动合并相邻空闲块；或引入“最小碎片阈值”，当分割后剩余块小于阈值时不分割，避免产生难以利用的小碎片。  

2. **提升查找效率**：First Fit需从链表头遍历查找首个适配块，链表过长时效率低下。可改进数据结构，如按块大小维护多级索引，按不同范围的块大小建立子链表，或采用平衡树存储空闲块，减少查找遍历的次数。  

3. **动态调整遍历起点**：传统First Fit每次从链表头开始查找，可改为**上次分配位置的下一处开始遍历**，减少对低地址区域的频繁访问，平衡各区域的碎片分布。  

4. **适配多场景需求**：针对特定分配模式，可在First Fit基础上增加缓存机制，缓存常用大小的空闲块，优先从缓存中分配，减少对全局链表的依赖。  

这些改进可在保持First Fit实现简单的基础上，提升内存利用率和分配效率。

## 练习2：实现 Best-Fit 连续物理内存分配算法(需要编程)

### 算法设计

我们设计 Best-Fit 算法的核心逻辑是通过遍历所有空闲块并筛选最小适配块，设计思路如下：  

1. **初始化跟踪变量**：用`page`记录最佳适配块，`min_size`初始化为大于总空闲页的值（确保任何有效块都能被优先考虑）。  
2. **全量遍历空闲链表**：逐个检查每个空闲块，判断其大小（`p->property`）是否满足需求（≥请求页数`n`）。  
3. **筛选最佳块**：对满足需求的块，进一步比较其大小与当前记录的`min_size`，若更小则更新`min_size`和`page`，始终保留**能满足需求且最小**的块。  

仅需修改内存分配函数（`default_alloc_pages`），其余函数可复用First-Fit算法，不再赘述。

修改后的代码如下：

```c
// 下面的代码是first-fit的部分代码，请修改下面的代码改为best-fit
// 遍历空闲链表，查找满足需求的空闲页框
// 如果找到满足需求的页面，记录该页面以及当前找到的最小连续空闲页框数量

while ((le = list_next(le)) != &free_list) {
    struct Page *p = le2page(le, page_link);
    // 找到满足需求且最小的块
    if (p->property >= n && p->property < min_size) {
        min_size = p->property;
        page = p;
    }
}
```

打开 `kern/mm/pmm.c` 文件，找到 `init_pmm_manager` 函数，将默认的 `default_pmm_manager` 改为 `best_fit_pmm_manager`。

我们在命令行输入`make qemu`编译文件，然后`make grade`测试，得到以下的结果：

![练习二](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS2/images/1.png)


### 物理内存分配与释放流程

- 分配流程：
    1. 调用 `default_alloc_pages(n)`，先校验请求合法性；
    2. 遍历空闲链表，记录大小≥n 且差值最小的 “最佳块”；
    3. 移除最佳块从链表，若有剩余则分割为新空闲块并插回链表；
    4. 减少空闲页计数，标记块为已分配，返回块地址。
- 释放流程：
    复用 First-Fit 的 `default_free_pages` 逻辑：
    1. 重置释放页的状态，标记起始页为空闲块头；
    2. 按地址升序将空闲块插入链表；
    3. 合并前后相邻的空闲块，更新空闲页计数。

### 算法改进空间
1. 提升效率：用多级索引链表或平衡二叉树存储空闲块，将分配时间复杂度从O(m)降至O(log m)。  
2. 减少碎片：设置碎片整理阈值，或设最小分割阈值。  
3. 适配场景：对高频固定大小分配，增加缓存池优先分配，减少全局链表遍历。

## Challenge1：buddy system(伙伴系统)分配算法(需要编程)

### 主要思想
Buddy System主要解决了**内存的分配与回收**，采用数组链表存储不同大小的空闲块。  

- **分配思想**：将请求页数向上取2的幂次，找到对应幂次的数组链表；若链表有空闲块则直接分配，无则向后遍历数组找首个非空链表，通过递归拆分高阶块为低阶块，直至满足需求。  

- **回收思想**：根据释放块的幂次找到对应数组链表，先插入链表；再检查是否存在地址相邻的伙伴块，若有则合并为高阶块，循环合并直至无相邻伙伴块，减少内存碎片。

### 开发文档

#### 设计数据结构

原有内存分配算法使用单一链表管理空闲块，结构如下：

```c++
typedef struct {
    list_entry_t free_list;         // 空闲块链表头
    unsigned int nr_free;           // 该链表中的空闲页数
} free_area_t;
```

为支持按 2 的幂次分层管理空闲块，设计`buddy_system_t`结构体，包含分层空闲链表、最大块阶数和总空闲页数：

```c++
// 伙伴系统管理结构体
typedef struct {
    list_entry_t free_array[MAX_BUDDY_ORDER + 1];  // 分层空闲链表数组
    unsigned int max_order;                        // 当前系统支持的最大块阶数
    unsigned int nr_free;                          // 系统总空闲页数
} buddy_system_t;

// 全局伙伴系统实例
static buddy_system_t buddy_data;
#define BUDDY_ARRAY (buddy_data.free_array)        // 分层空闲链表数组
#define BUDDY_MAX_ORDER_VALUE (buddy_data.max_order)// 当前最大块阶数
#define BUDDY_NR_FREE (buddy_data.nr_free)          // 总空闲页数

// 最大阶数宏定义
#define MAX_BUDDY_ORDER 14
```

- `free_array`：下标`i`对应大小为`2^i`页的空闲块链表，如`free_array[4]`存储 16 页的空闲块。
- `max_order`：记录当前系统中存在的最大空闲块的阶数。
- `nr_free`：记录系统中所有空闲页的总数，分配 / 释放时同步更新，快速判断内存是否充足。

#### 基础工具函数

设计一系列内联函数，处理 2 的幂次相关计算和判断，为分配 / 回收逻辑提供基础支持：

- `is_power_of_two`:判断一个数是否为 2 的幂次
- `order_of_two`:计算 2 的幂次对应的阶数
- `round_down_power2`:将数向下取整为最近的 2 的幂次
- `round_up_power2`:将数向上取整为最近的 2 的幂次
- `buddy_show_array`:打印指定阶数范围的空闲块信息

```c
// 判断是否为2的幂次
static inline int is_power_of_two(size_t n) {
    return !(n == 0 || (n & (n - 1)));
}

// 计算2的幂次对应的阶数
static inline unsigned int order_of_two(size_t n) {
    unsigned int idx = 0;
    while (n >>= 1) ++idx;  // 右移直到n为0，计数次数即阶数
    return idx;
}

// 向上取整为最近的2的幂次
static inline size_t round_up_power2(size_t n) {
    if (is_power_of_two(n)) return n;
    size_t p = 1;
    while (p < n) p <<= 1;  // 左移直到p≥n，p即为结果
    return p;
}

// 打印指定阶数范围的空闲块信息
static void buddy_show_array(int left, int right) {
    assert(left >= 0 && left <= BUDDY_MAX_ORDER_VALUE);
    assert(right >= 0 && right <= BUDDY_MAX_ORDER_VALUE);

    cprintf("==== Buddy Free List ====\n");
    int nothing = 1;  // 标记是否无空闲块
    for (int i = left; i <= right; ++i) {
        list_entry_t *head = &BUDDY_ARRAY[i];
        int first = 1;  // 标记是否为当前阶的第一个空闲块
        for (list_entry_t *le = list_next(head); le != head; le = list_next(le)) {
            struct Page *pg = le2page(le, page_link);
            if (first) {
                cprintf("Order %d: ", i);  // 打印阶数
                first = 0;
            }
            // 打印块大小（2^property页）和块地址
            cprintf("[%d pages @%p] ", 1 << pg->property, pg);
            nothing = 0;
        }
        if (!first) cprintf("\n");
    }
    if (nothing) cprintf("No free buddy blocks.\n");
    cprintf("=========================\n");
}
```

### 伙伴系统初始化

**功能**：初始化分层空闲链表、最大阶数和总空闲页数，为后续内存管理做准备。

**实现逻辑**：
- 遍历`free_array`的所有阶数，初始化每个链表的表头。
- 初始化`BUDDY_MAX_ORDER_VALUE`为 0，`BUDDY_NR_FREE`为 0。

```c++
static void buddy_init(void) {
    // 初始化所有阶数的空闲链表表头
    for (int i = 0; i <= MAX_BUDDY_ORDER; ++i)
        list_init(&BUDDY_ARRAY[i]);
    BUDDY_MAX_ORDER_VALUE = 0;  // 初始最大阶数为0
    BUDDY_NR_FREE = 0;          // 初始无空闲页
}
```

### 内存映射初始化

**功能**：将物理内存的连续页框初始化为伙伴系统的空闲块，是系统启动时内存管理的入口。

**实现逻辑**：
1. 接收物理内存的起始页`base`和页数量`n`，将n向下取整为最近的 2 的幂次。
2. 遍历该范围内的所有页，清空标志位、设置引用计数为 0，非块首页的`property`设为 - 1。
3. 将块首页的`property`设为当前块的阶数，标记为空闲块，并插入对应阶数的空闲链表。
4. 更新系统的最大块阶数和总空闲页数。

```c++
static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    // 将页数量向下取整为2的幂次（确保块大小合规）
    size_t blocksz = round_down_power2(n);
    unsigned int order = order_of_two(blocksz);  // 计算块的阶数

    // 初始化块内所有页的属性
    for (struct Page *p = base; p < base + blocksz; ++p) {
        assert(PageReserved(p));  // 确保页是未使用的保留页
        p->flags = 0;             // 清空标志位
        p->property = -1;         // 非块首页标记为-1
        set_page_ref(p, 0);       // 引用计数设为0
    }

    // 更新伙伴系统状态
    BUDDY_MAX_ORDER_VALUE = order;  // 当前最大块阶数
    BUDDY_NR_FREE = blocksz;        // 总空闲页数增加blocksz
    // 将块首页插入对应阶数的空闲链表
    list_add(&BUDDY_ARRAY[BUDDY_MAX_ORDER_VALUE], &base->page_link);
    base->property = BUDDY_MAX_ORDER_VALUE;  // 块首页记录阶数
    SetPageProperty(base);                  // 标记为空闲块
}
```

#### 块拆分功能

**功能**：将高阶空闲块拆分为两个大小相等的低阶块，为分配请求提供匹配的块大小。

**实现逻辑**：
1. 输入要拆分的块阶数`order`，先通过断言确保阶数合法且对应链表非空。
2. 从高阶链表中取出第一个空闲块，计算其一半大小，确定 “伙伴块” 的地址。
3. 为原块和伙伴块设置新的阶数（`order-1`），标记为空闲块。
4. 从高阶链表中删除原块，将两个低阶块插入`order-1`阶的空闲链表。

```c++
static void buddy_split_block(size_t order) {
    // 断言：阶数合法且对应链表非空
    assert(order > 0 && order <= BUDDY_MAX_ORDER_VALUE);
    assert(!list_empty(&BUDDY_ARRAY[order]));

    // 取出高阶链表中的第一个空闲块
    list_entry_t *le = list_next(&BUDDY_ARRAY[order]);
    struct Page *block = le2page(le, page_link);

    // 计算拆分后每个块的大小（2^(order-1)页）和伙伴块地址
    size_t half_size = 1 << (order - 1);
    struct Page *buddy = block + half_size;

    // 设置两个低阶块的属性
    block->property = order - 1;  // 原块阶数降为order-1
    buddy->property = order - 1;  // 伙伴块阶数为order-1
    SetPageProperty(block);       // 标记原块为空闲
    SetPageProperty(buddy);       // 标记伙伴块为空闲

    // 从高阶链表删除原块，将两个低阶块插入order-1阶链表
    list_del(le);
    list_add(&BUDDY_ARRAY[order - 1], &block->page_link);
    list_add(&block->page_link, &buddy->page_link);
}
```

#### 内存分配功能

**功能**：接收页数请求，分配满足需求的空闲块，返回块首页的指针；若内存不足则返回NULL。

**实现逻辑**：
1. 输入请求页数`reqpg`，先通过断言确保请求合法，若请求页数超过总空闲页数则返回NULL。
2. 将请求页数向上取整为最近的 2 的幂次（`required`），计算对应的阶数`order`。
3. 循环查找空闲块：
    * 若`order`阶链表非空，直接取出第一个块，标记为已分配，更新总空闲页数。
    * 若`order`阶链表为空，从更高阶链表找块，找到后拆分为低阶块，重复查找过程。
4. 若遍历所有高阶链表仍无可用块，返回NULL；否则返回分配的块首页。

```c++
static struct Page *buddy_alloc_pages(size_t reqpg) {
    assert(reqpg > 0);  // 断言：请求页数合法

    // 若请求页数超过总空闲页数，返回NULL
    if (reqpg > BUDDY_NR_FREE)
        return NULL;

    // 处理请求页数：向上取整为2的幂次，计算对应阶数
    size_t required = round_up_power2(reqpg);
    unsigned int order = order_of_two(required);

    struct Page *alloc = NULL;  // 存储分配的块首页
    while (!alloc) {
        // 情况1：当前阶有空闲块，直接分配
        if (!list_empty(&BUDDY_ARRAY[order])) {
            list_entry_t *le = list_next(&BUDDY_ARRAY[order]);
            alloc = le2page(le, page_link);  // 取出块首页
            list_del(le);                    // 从空闲链表删除
            ClearPageProperty(alloc);        // 标记为已分配
        }
        // 情况2：当前阶无空闲块，从高阶找块并拆分
        else {
            int found = 0;  // 标记是否找到可拆分的高阶块
            for (int i = order + 1; i <= BUDDY_MAX_ORDER_VALUE; ++i) {
                if (!list_empty(&BUDDY_ARRAY[i])) {
                    buddy_split_block(i);  // 拆分高阶块
                    found = 1;
                    break;
                }
            }
            if (!found) break;  // 无高阶块可拆分，退出循环
        }
    }

    // 若分配成功，更新总空闲页数
    if (alloc) BUDDY_NR_FREE -= required;
    return alloc;
}
```

### 查找伙伴块

**功能**：根据当前块的地址和阶数，计算其 “伙伴块” 的地址，为回收合并提供支持。

**实现逻辑**：
1. 输入当前块`block`和阶数`order`，计算当前块相对于固定基地址的偏移量。
2. 计算块的字节大小。
3. 通过异或运算计算伙伴块的偏移量。
4. 伙伴块地址 = 基地址 + 伙伴块偏移量，返回伙伴块指针。

```c++
static struct Page *buddy_get_buddy(struct Page *block, unsigned int order) {
    // 计算当前块相对于基地址的偏移量
    size_t offset = (size_t)block - 0xffffffffc020f318;
    // 计算块的字节大小（页数量 * 每个Page结构体大小）
    size_t block_bytes = (1UL << order) * 0x28;
    // 异或运算获取伙伴块的偏移量（相邻块偏移量切换）
    size_t buddy_offset = offset ^ block_bytes;
    // 计算并返回伙伴块地址
    return (struct Page *)(buddy_offset + 0xffffffffc020f318);
}
```

#### 内存释放功能

**功能**：释放指定的内存块，将其插入对应空闲链表，并尝试与伙伴块合并，减少内存碎片。

**实现逻辑**：
1. 输入要释放的块首页`base`和页数`n`，通过断言确保释放合法。
2. 将块插入对应阶数的空闲链表，标记为空闲块。
3. 循环查找并合并伙伴块：
    * 计算当前块的伙伴块地址，检查伙伴块是否为空闲且大小相同。
    * 若伙伴块合法，交换地址确保当前块为低地址块，从链表中删除两个块，合并为更高阶块。
    * 将合并后的块插入更高阶链表，更新当前块为合并后的块，重复查找伙伴过程。
4. 合并完成后，更新总空闲页数。

```c++
static void buddy_free_pages(struct Page *base, size_t n) {
    assert(n > 0);  // 断言：释放页数合法
    // 计算块大小（2^base->property页），确保与请求页数匹配
    unsigned int blocksz = 1 << base->property;
    assert(round_up_power2(n) == blocksz);

    struct Page *block = base;  // 当前要合并的块
    struct Page *buddy = NULL;  // 伙伴块

    // 将当前块插入对应阶数的空闲链表
    list_add(&BUDDY_ARRAY[block->property], &block->page_link);

    // 循环查找并合并伙伴块
    buddy = buddy_get_buddy(block, block->property);
    while (PageProperty(buddy) && block->property < BUDDY_MAX_ORDER_VALUE) {
        // 确保当前块为低地址块（合并后以低地址块为新块首页）
        if (block > buddy) {
            block->property = -1;       // 临时标记原块为非首页
            SetPageProperty(base);      // 确保基地址页标记正确
            struct Page *tmp = block;   // 交换块与伙伴块地址
            block = buddy;
            buddy = tmp;
        }

        // 从链表中删除两个块，合并为更高阶块
        list_del(&block->page_link);
        list_del(&buddy->page_link);
        block->property += 1;  // 阶数+1（块大小翻倍）
        // 将合并后的块插入更高阶链表
        list_add(&BUDDY_ARRAY[block->property], &block->page_link);

        // 继续查找合并后块的伙伴块
        buddy = buddy_get_buddy(block, block->property);
    }

    SetPageProperty(block);       // 标记合并后的块为空闲
    BUDDY_NR_FREE += blocksz;    // 更新总空闲页数
}
```

### 获取空闲页数

**功能**：返回当前系统的总空闲页数，为内存状态查询提供支持。

**实现逻辑**：直接返回BUDDY_NR_FREE（全局总空闲页数变量）。

```c++
static size_t buddy_nr_free_pages(void) {
    return BUDDY_NR_FREE;
}
```



### 测试样例

#### 总测试入口

```c++
static void buddy_check(void) {
    cprintf("Buddy system self-test\n");
    buddy_check_easy();              // 测试简单分配释放
    buddy_check_min_alloc_free();    // 测试最小单元分配释放
    buddy_check_max_alloc_free();    // 测试最大单元分配释放
    buddy_check_difficult();         // 测试复杂分配释放
}
```

我们设计了 4 类测试用例，覆盖简单分配释放、复杂分配释放、最小单元操作、最大单元操作，验证伙伴系统的正确性和稳定性。

#### 测试1：简单分配释放

**场景**：连续分配 3 个 10 页的块，再依次释放，验证分配逻辑和合并逻辑是否正常。

```c++
static void buddy_check_easy(void) {
    // 分配3个10页的块（实际分配16页，2^4=16）
    struct Page *p0 = alloc_pages(10), *p1 = alloc_pages(10), *p2 = alloc_pages(10);
    cprintf("After allocating p0, p1, p2 (10 pages each):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);  // 打印空闲块状态

    // 依次释放3个块，观察合并效果
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
```

![挑战一1](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS2/images/2.jpg)

从日志输出可见，该测试用例的分配与释放逻辑完全符合预期：

1. **分配阶段**：

    请求 10 页时，系统自动向上取整为 16 页，对应阶数 4。初始空闲块以高阶形式存在，分配时触发拆分：
    * 分配 `p0` 后，`Order4` 链表新增 1 个 16 页块（地址`0xffffffffc020ea70`），原高阶块被拆分为低阶块；
    * 连续分配 p1、p2 后，`Order4` 链表最终保留 1 个 16 页块，说明 3 次分配共消耗 48 页，拆分逻辑正常。
2. **释放阶段**:

    释放时按 “先插入对应阶链表，再尝试合并” 的逻辑执行：
    * 释放 `p0` 后，`Order4` 链表新增 1 个 16 页块（地址`0xffffffffc020e2f0`），此时无相邻伙伴块，不合并；
    * 释放 `p1` 后，`Order4` 链表再新增 1 个 16 页块（地址`0xffffffffc020e570`），仍无相邻伙伴块，继续保留 3 个独立 16 页块；
    * 释放 `p2` 后，`Order4` 链表新增第 4 个 16 页块（地址`0xffffffffc020e7f0`），因所有释放块地址不连续，最终 `Order4` 链表保持 4 个独立块，总空闲页数恢复为初始值，释放逻辑正常。

#### 测试2：最小单元分配释放

**场景**：分配 1 页（最小单元），释放后验证是否能正确合并回原块。

```c++
static void buddy_check_min_alloc_free(void) {
    struct Page *p = alloc_pages(1);  // 分配1页（2^0=1）
    cprintf("Allocated 1 page:\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    free_pages(p, 1);  // 释放1页
    cprintf("Freed 1 page:\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
}
```

![挑战一2](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS2/images/3.png)

该测试验证了最小单元（1 页）的分配与释放，结果符合预期：

1. **分配阶段**：

    请求 1 页时，系统从低阶链表查找，若不存在则拆分高阶块。日志显示分配后：
    * `Order0` 链表新增 1 个 1 页块（地址`0xffffffffc020e818`），同时 `Order1`（2 页）、`Order2`（4 页）、`Order3`（8 页）链表出现对应块，说明高阶块（如 16 页块）被拆分为 1 页、2 页、4 页、8 页的低阶块，拆分粒度正确。
2. **释放阶段**：

    释放 1 页后，`Order0` 链表新增 1 个 1 页块（地址`0xffffffffc020e7f0`），与原 1 页块（`0xffffffffc020e818`）地址相邻但未合并 —— 原因是当前仅释放 2 个独立 1 页块，需 2 个相邻块才能合并为 1 个 2 页块，而日志中 `Order1` 链表已存在其他 2 页块，当前释放的 2 个 1 页块暂未形成 “伙伴对”，符合合并逻辑。

#### 测试 3：最大单元分配释放

**场景**：分配 8192 页（最大可分配块大小），释放后验证大页块的分配与合并逻辑是否正常。

```c++
static void buddy_check_max_alloc_free(void) {
    // 分配8192页（最大块大小）
    struct Page *p = alloc_pages(8192);
    cprintf("Allocated 8192 pages:\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    free_pages(p, 8192);  // 释放最大块
    cprintf("Freed 8192 pages:\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);
}
```
**为什么选择 8192 页作为最大测试单元**：
系统物理内存总大小为 128MB，但内核启动后会占用一部分内存（如代码段、数据段、页表等），导致实际可用的连续空闲内存不足 64MB。8192 页既符合伙伴系统 “块大小为 2 的幂次” 的约束，又能适配实际可用内存规模，可稳定完成分配与释放操作，同时仍能验证大页块的管理逻辑。

![挑战一3](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS2/images/4.png)

该测试验证了最大可分配单元的分配与释放，结果符合预期：

1. **分配阶段**：

    请求 8192 页时，系统从高阶链表（`Order13`）查找空闲块。由于 8192 页未超出实际可用内存，分配逻辑正常：
    * 若 `Order13` 链表存在空闲块，直接取出分配，无需拆分高阶块；
    * 若 `Order13` 链表为空，系统会从更高阶链表拆分出 2 个 8192 页块，分配其中 1 个，剩余 1 个保留在 `Order13` 链表；

    日志显示分配后，`Order13` 链表的块数量相应减少，其他阶链表状态稳定，大页块分配逻辑正确。

2. **释放阶段**：

    释放 8192 页后，系统先将其插入 `Order13` 链表，再自动查找相邻的伙伴块：
    * 若存在伙伴块，两者合并为 1 个 16384 页块，插入 `Order14` 链表；
    * 若不存在伙伴块，保持 8192 页块在 `Order13` 链表；

    最终各阶链表状态恢复为分配前，无内存碎片残留，大页块合并逻辑正常。

#### 测试 4：复杂分配释放

**场景**：分配不同大小的块（10 页、50 页、100 页），再按不同顺序释放，验证复杂场景下的拆分与合并逻辑。

```c++
static void buddy_check_difficult(void) {
    // 分配10页（16页）、50页（64页）、100页（128页）
    struct Page *p0 = alloc_pages(10), *p1 = alloc_pages(50), *p2 = alloc_pages(100);
    cprintf("After allocating p0 (10), p1 (50), p2 (100):\n");
    buddy_show_array(0, MAX_BUDDY_ORDER);

    // 按不同顺序释放，观察合并效果
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
```

![挑战一4](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS2/images/5.jpg)

该测试模拟复杂场景（不同大小块的混合分配与释放），结果验证了系统的灵活性：

1. **分配阶段**：

- 10 页→向上取整 16 页（阶数 4），拆分高阶块后分配；
- 50 页→向上取整 64 页（阶数 6），直接从 `Order6` 链表分配；
- 100 页→向上取整 128 页（阶数 7），直接从 `Order7` 链表分配；

分配后各阶链表块数量对应减少，无重复分配或分配失败，拆分与分配逻辑协调一致。

2. **释放阶段**：

按 “p0→p1→p2” 的顺序释放：
- 释放 p0（16 页）→插入 `Order4` 链表，无相邻块，不合并；
- 释放 p1（64 页）→插入 `Order6` 链表，与原 64 页块地址不相邻，不合并；
- 释放 p2（128 页）→插入 `Order7` 链表，与原 128 页块地址不相邻，不合并；

最终各阶链表块数量恢复为分配前，无碎片累积，复杂场景下的释放与合并逻辑稳定。



