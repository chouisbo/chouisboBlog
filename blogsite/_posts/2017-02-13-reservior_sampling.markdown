---
layout: post
title:  "Reservior Sampling (蓄水池抽样算法)"
date:   2017-02-13 09:21:21 +0800
categories: algorithm 
---

---
## 1. 蓄水池抽样问题描述
　　[Reservoir sampling](https://en.wikipedia.org/wiki/Reservoir_sampling) is a family of randomized algorithms for randomly choosing a sample of k items from a list S containing n items, where n is either a very large or unknown number. Typically n is large enough that the list doesn't fit into main memory.
　　蓄水池抽样问题是，从一个长度为n的流中随机选取k个元素，使得n个元素中的每个元素都以相同的概率被采样到，通常情况下n是一个未知的很大的数目，而且无法将其载入主存中。

---
## 2. 蓄水池抽样的解法

　　在[Dictionary of Algorithms and Data Structures](https://xlinux.nist.gov/dads/)中该问题的定义与解法如下:

* Definition: Randomly select k items from a stream of items of unknown length.
* Solution: Save the first k items in an array of size k. For each item j, j > k, choose a random integer M from 1 to j (inclusive). If M ≤ k, replace item M of the array with item j.

该问题的解法一般被称为 **Algorithm R** 由 Jeffrey Vitter 在其论文["Random sampling with a reservoir"](http://www.cs.umd.edu/~samir/498/vitter.pdf) 中提出，其伪代码如下所示：

```
(*
  S has items to sample, R will contain the result
 *)
ReservoirSample(S[1..n], R[1..k])
  // fill the reservoir array
  for i = 1 to k
      R[i] := S[i]

  // replace elements with gradually decreasing probability
  for i = k+1 to n
    j := random(1, i)   // important: inclusive range
    if j <= k
        R[j] := S[i]
```

---
## 3. Algorithm R 算法的数学证明

证明请参见我的[CSDN Blog](http://blog.csdn.net/chouisbo/article/details/55046128)

---
## 4. leetcode 刷题

* [382. Linked List Random Node](https://leetcode.com/problems/linked-list-random-node/)

