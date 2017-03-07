---
layout: post
title:  "Binary Heap (二叉堆)"
date:   2017-02-10 09:21:21 +0800
categories: algorithm ds 
---

# Binary Heap (二叉堆)
---
## 1. 二叉堆的定义
　　在计算机科学中，[二叉堆](https://en.wikipedia.org/wiki/Binary_heap)是[二叉树](https://en.wikipedia.org/wiki/Binary_tree)形状的[堆结构](https://en.wikipedia.org/wiki/Heap_%28data_structure%29)。二叉堆是最常见的实现[优先级队列](https://en.wikipedia.org/wiki/Priority_queue)的方法，它与优先级队列紧密相连，一起应用到诸多地方，在很多主流语言的标准算法库中都能看到它们的身影。同时它也是很多算法中需要用到的底层数据结构，能够快速地掌握这些已有的标准库和类，能够很高效地实现诸多算法。

* 其空间复杂度和相关操作的时间复杂度如下表所示：

| Algorithm | Average | Worst Case |
| --------- |:-------:| -----:|
| Space | O(n) | O(n) |
| Search | O(n) | O(n) |
| Insert | O(1) | O(log n) |
| Delete | O(log n) | O(log n) |
| Peek | O(1) | O(1) |

---
## 2. 二叉堆的性质

　　二叉堆的是一个具有堆性质的完全二叉树，因此二叉堆具备了完全二叉树和堆的全部特性，实现起来非常容易，也是程序员必须要掌握的基本数据结构。

* 最大堆示例
![最大堆示例](http://images.cnitblog.com/i/605165/201408/030922489463608.jpg "最大堆示例")

* [完全二叉树](https://en.wikipedia.org/wiki/Complete_Binary_Tree):　完全二叉树是由满二叉树而引出来的。对于深度为K的，有n个结点的二叉树，当且仅当其每一个结点都与深度为K的满二叉树中编号从1至n的结点一一对应时称之为完全二叉树。只有最下面的两层结点度能够小于2，并且最下面一层的结点都集中在该层最左边的若干位置。完全二叉树是一种效率很高的数据结构，通常采用数组形式存储，可以快速计算出一个节点的父子节点，同时不需要额外存储索引信息。

* [堆性质](https://en.wikipedia.org/wiki/Heap_%28data_structure%29):　堆性质是指树中的任意节点的取值，均比其字节点的取值大，称为最大堆。（或小，称为最小堆）这个是基于二叉堆获得节点取值对应关系的重要依据，是体现优先级的地方。

---
## 3. Ｃ语言实现二叉堆的基本操作(指针操作)

```c
#include <stdio.h>
#include <stdlib.h>

#define ARRAY_LENGTH(x) (sizeof(x) / sizeof(x[0]))

int int_less(const void *key1, const void *key2) {
    if (*((int *) key1) < *((int *) key2)) return 1;
    else return 0;
}

void int_swap(void *a, void *b) {
    int temp;
    temp = *(int*)a;
    *(int*)a = *(int*)b;
    *(int*)b = temp;
}

void **array_to_data(int *array, int n) {
    void **data = (void **) malloc(sizeof(void *) * n);
    for (int i = 0; i < n; i++) {
        data[i] = (array+i);
    }
    return data;
}

void output_int_array(int *data, int n) {
    int *p = data;
    for (int i=0; i<n; i++) {
        printf("%d, ", *(p++));
    }
    printf("\n");
}

void output_int_data(void **data, int n) {
    void **p = data;
    for (int i=0; i<n; i++) {
        printf("%d, ", *((int *) *(p++)));
    }
    printf("\n");
}


// adds an element to a heap
void push_heap(void **data, int *len, const int capacity, void *x,
               int (*compare)(const void *key1,
                              const void *key2),
               void (*swap)(void *a, void *b)) {
    if (*len >= capacity) return;
    // from bottom shift to top
    int n = *len; *len = *len + 1;
    data[n] = x;
    while (n != 0) {
        int p = (n-1) / 2;
        if (! compare(data[p], data[n])) {
            swap(data[p], data[n]);
            n = p;
        } else {
            break;
        }
    }
}

// creates a heap out of a range of elements
void make_heap(void **data, const int n,
               int (*compare)(const void *key1,
                              const void *key2),
               void (*swap)(void *a, void *b)) {

    int len = 0;
    while (len < n) {
        push_heap(data, &len, n, data[len], compare, swap);
    }        

}

// removes the largest element from a max heap
void *pop_heap(void **data, int *len,
               int (*compare)(const void *key1,
                              const void *key2),
               void (*swap)(void *key1, void *key2)) {
    if (*len <= 0) return NULL;

    // from top to bottom
    int n = 0;
    void *x = data[n]; *len = *len - 1;
    data[n] = data[*len];
    int c, c1, c2;
    while ((c1 = 2*n + 1) < *len) {
        c = c1;
        if (((c2 = 2 * (n+1)) < *len) &&
            ! compare(data[c1], data[c2])) {
            c = c2;
        }
        if (! compare(data[n], data[c])) {
            swap(data[n], data[c]);
            n = c;
        } else {
            break;
        }
    }
    return x;
}

void test_make_heap() {
    int array[] = {3, 5, 8, 2, 7, 4, 1, 6, 9};
    int n = ARRAY_LENGTH(array);
    output_int_array(array, n);

    void **data = array_to_data(array, n);
    output_int_data(data, n);

    make_heap(data, n, int_less, int_swap);
    output_int_data(data, n);

    int len = n;
    void *x = NULL;
    while (len > 0) {
        x = pop_heap(data, &len, int_less, int_swap);
        printf("%d, ", *(int *)x);
    }
    printf("\n");    

    free(data);
}

int main(void) {

    test_make_heap();

    return 0;
}
```

---

## ４. 标准算法库与工具类

* [Python - heap queue algorithm](https://docs.python.org/2/library/heapq.html)

* [C++ - STL heap algorithm](http://en.cppreference.com/w/cpp/algorithm)

* [Java - PriorityQueue](http://docs.oracle.com/javase/8/docs/api/index.html)

## 5. 二叉堆的应用

　　二叉堆非常适合解决在连续的插入和删除操作中，快读定位最大值或最小值的问题。在很多[贪心算法](https://en.wikipedia.org/wiki/Greedy_algorithm)中，都需要取得当前时刻的最大值或最小值，二叉堆与贪心算法的结合尤其紧密。

1). **堆排序**
2). **优先级队列**
3). **Top K Problem**

---
## 6. leetcode 刷题

* [451. Sort Characters By Frequency](https://leetcode.com/problems/sort-characters-by-frequency/)
* [373. Find K Pairs with Smallest Sums](https://leetcode.com/problems/find-k-pairs-with-smallest-sums/)
* [502. IPO](https://leetcode.com/problems/ipo/)


