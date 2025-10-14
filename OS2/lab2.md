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

