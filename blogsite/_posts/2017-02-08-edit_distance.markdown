---
layout: post
title:  "Edit Distance(编辑距离)"
date:   2017-02-08 09:21:21 +0800
categories: algorithm 
---

## 1. 编辑距离的定义
　　在计算机科学中，编辑距离用于度量任意两个字符串间**不相似**的程度，即二者之间的编辑距离越大表示两个字符串之间的差异就越大。
#### 问题描述：
　　给定两个字符串ｘ和ｙ，只允许使用三种操作（插入一个字符、删除一个字符、修改一个字符）将ｘ变换为ｙ，求最少需要的操作次数。（更进一步，还需给出变换的具体步骤）【此编辑距离被称作[Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)】
　　 **P.S.** 在[Longest common subsequence (LCS)](https://en.wikipedia.org/wiki/Longest_common_subsequence_problem) distance中只允许进行插入和删除两种操作。在[Hamming Distance](https://en.wikipedia.org/wiki/Hamming_distance) 中只允许进行替换操作。这就是这距离的关系，从广义上说它们都可以称作编辑距离，本文所说的编辑距离主要指：**Levenshtein distance**。

#### 举例：
　　以"kitten"和"sitting"两个字符串为例，它们之间的编辑距离是3。因为可以通过如下3步将"kitten"变为"sitting"，且至少需要3步才能完成变化，具体步骤如下所示：
```
1. kitten → sitten (将"k"替换为"s")
2. sitten → sittin (将"e"替换为"i")
3. sittin → sitting (在末尾添加"g").
```

---
## 2. 编辑距离的性质
　　编辑距离满足度量公理，具备如下性质：

* d(a, b) = 0 if and only if a=b
* d(a, b) > 0 when a ≠ b
* d(a, b) = d(b, a) # by equality of the cost of each operation and its inverse.
* Triangle inequality: d(a, c) ≤ d(a, b) + d(b, c).
* LCS distance 的上限是两个字符串长度之和。
* LCS distance 是 Levenshtein distance 的上限。
* 对于等长串, Hamming distance 是 Levenshtein distance 的上限。

---
## 3. 编辑距离的应用
　　编辑距离在很多领域中都有这广泛的应用。在自然语言处理方面，常见的**拼写自动纠错**就是通过编辑距离来实现的，即计算用户输入的字符串与候选字符串集合中字符串的编辑距离，来为用户自动推荐最可能的单词或语言片段。在生物信息学中编辑距离经常用于**度量两个基因DNA片段序列的相似程度**，因为DNA片段可以看成是A、C、G和T碱基组成的序列串。

---
## 4. 编辑距离的计算

具体证明请参见我的[CSDN Blog](http://blog.csdn.net/chouisbo/article/details/54923274)

* python 实现
```python
import random

class Solution:
    def minDistance(self, word1, word2):
        m, n = len(word2), len(word1)
        d = [[0] * (n+1) for k in range(m+1)]
        for i in range(m+1): d[i][0] = i
        for j in range(n+1): d[0][j] = j
        for i in range(1, m+1):
            for j in range(1, n+1):
                if word1[j-1] == word2[i-1]: d[i][j] = d[i-1][j-1]
                else:
                    d[i][j] = min(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+1)
        self.backtrace(word1, word2, d)
        return d[m][n]

    def backtrace(self, word1, word2, d):
        m, n, steps = len(word2), len(word1), []
        # generate a random solution
        while m > 0 and n > 0:
            if word2[m-1] == word1[n-1] and d[m][n] == d[m-1][n-1]:
                m -= 1
                n -= 1
            else:
                choices = []
                #0 - delete word2[m]
                if d[m][n] == d[m-1][n] + 1: choices.append(0)
                #1 - insert word1[n]
                if d[m][n] == d[m][n-1] + 1: choices.append(1)
                #2 - substitute word2[m] => word1[n]
                if d[m][n] == d[m-1][n-1] + 1: choices.append(2)
                #randomly choose one possible choices
                rc = random.choice(choices)
                if 0 == rc: 
                    steps.append("delete word2[%d]='%s'" % (m-1, word2[m-1]))
                    m -= 1
                elif 1 == rc:
                    steps.append("insert word1[%d]='%s' at %d " % (n-1, word1[n-1], m-1))
                    n -= 1
                elif 2 == rc: 
                    steps.append("substitute word2[%d]='%s' to word1[%d]='%s'" % (m-1, word2[m-1], n-1, word1[n-1]))
                    m -= 1
                    n -= 1
                else:
                    print ('Error!')
                    return
        while m > 0:
            steps.append("delete word2[%d]='%s'" % (m-1, word2[m-1]))
            m -= 1
        while n > 0:
            steps.append("insert word1[%d]='%s' at 0" % (n-1, word1[n-1]))
            n -= 1
        steps.reverse()
        for i in range(len(steps)):
            print ("Step %d: %s" % (i+1, steps[i]))
  
```

* c++ implementation
```cpp
int minDistance(string word1, string word2) {
    size_t m = word2.length(), n = word1.length();
    vector<size_t> prev(n+1), current(n+1, 0);
    iota(prev.begin(), prev.end(), 0);
    for (size_t i=1; i<m+1; i++) {
        current[0] = i;
        for (size_t j=1; j<n+1; j++) {
            if (word2[i-1] == word1[j-1]) {
                current[j] = prev[j-1]; 
            } else {
                current[j] = min(min(prev[j-1]+1, prev[j]+1), current[j-1]+1);
            }
        }
        swap_ranges(prev.begin(), prev.end(), current.begin());
    }
    return (int) prev[n];
}
```

---
## 5. leetcode 刷题

* [72. Edit Distance](https://leetcode.com/problems/edit-distance/)


