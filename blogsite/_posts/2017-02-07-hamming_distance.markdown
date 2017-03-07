---
layout: post
title:  "Hamming Distance (汉明距离)"
date:   2017-02-07 09:21:21 +0800
categories: algorithm 
---

---
## 1. 汉明距离的定义
　　在信息理论中，[Hamming Distance](https://en.wikipedia.org/wiki/Hamming_distance "Hamming Distance") 表示两个等长字符串在对应位置上不同字符的数目，我们以d(x, y)表示字符串x和y之间的汉明距离。从另外一个方面看，汉明距离度量了通过替换字符的方式将字符串x变成y所需要的最小的替换次数。
```
# 举例说明以下字符串间的汉明距离为：
"karolin" and "kathrin" is 3.
"karolin" and "kerstin" is 3.
1011101 and 1001001 is 2.
2173896 and 2233796 is 3.
```

---
## 2. 汉明距离的意义

　　对于二进制串ａ和ｂ来说，汉明距离等于ａ**XOR**ｂ中１的数目，我们又称其为[汉明权重](https://en.wikipedia.org/wiki/Hamming_weight)，也叫做population count或popcount。长度为ｎ的二进制字符串通过汉明距离构成了一个度量空间([metric space](https://en.wikipedia.org/wiki/Metric_space))，我们称其为汉明立方(Hamming Cube)。

* 下图表示在hypercube中 0100→1001 (红色)的汉明距离是 3; 0110→1110 (蓝色)的汉明距离是 1
![在hypercube中 0100→1001 has distance 3; 0110→1110 has distance 1](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Hamming_distance_4_bit_binary_example.svg/420px-Hamming_distance_4_bit_binary_example.svg.png "在hypercube中 0100→1001 has distance 3; 0110→1110 has distance 1")

---
## 3. 汉明距离的计算

* python3　简单计算汉明距离的代码如下：
```python
def hammingDistance(s1, s2):
    """Return the Hamming distance between equal-length sequences"""
    if len(s1) != len(s2):
        raise ValueError("Undefined for sequences of unequal length")
    return sum(el1 != el2 for el1, el2 in zip(s1, s2))
```
　　Wegner (1960)　提出了一种计算汉明权重（即计算给定整数的二进制表示中１的个数）的算法，通过反复查找并消除最低的非零bit位来实现。基于此使用Ｃ语言实现的计算汉明距离的算法如下：
```c
int hamming_distance(unsigned x, unsigned y)
{
    int dist = 0;
    unsigned  val = x ^ y;

    // Count the number of bits set
    while (val != 0)
    {
        // A bit is set, so increment the count and clear the bit
        dist++;
        val &= val - 1;
    }

    // Return the number of differing bits
    return dist;
}
```
　　还可以借助编译器内置计算popcount的调用来更高效地实现。
```c
int hamming_distance(unsigned x, unsigned y)
{
    return __builtin_popcount(x ^ y);
}
//if your compiler supports 64-bit integers
int hamming_distance(unsigned long long x, unsigned long long y)
{
    return __builtin_popcountll(x ^ y);
}
```

---
## 4. 汉明距离的应用
　　汉明距离主要应用在通信编码领域上，用于制定可纠错的编码体系。在机器学习领域中，汉明距离也常常被用于作为一种距离的度量方式。在LSH算法汉明距离也有重要的应用。【有待完善】

---
## 5. leetcode 刷题

* [191. Number of 1 Bits](https://leetcode.com/problems/number-of-1-bits/)
* [461. Hamming Distance](https://leetcode.com/problems/hamming-distance/)
* [477. Total Hamming Distance](https://leetcode.com/problems/total-hamming-distance/)




