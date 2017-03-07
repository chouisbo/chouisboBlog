---
layout: post
title:  "Scikit-Learn 实战 iris数据集分类"
date:   2017-02-09 09:21:21 +0800
categories: python algorithm ml
---


### 1. Iris数据集简介
[Iris数据集](http://archive.ics.uci.edu/ml/datasets/Iris) 是常用的分类实验数据集，由Fisher, 1936收集整理。Iris也称鸢尾花卉数据集，是一类多重变量分析的数据集。数据集包含150个数据集，分为3类，每类50个数据，每个数据包含4个属性。可通过花萼长度，花萼宽度，花瓣长度，花瓣宽度4个属性预测鸢尾花卉属于（Setosa，Versicolour，Virginica）三个种类中的哪一类。

### 2.  使用 Scikit-Learn 加载 iris 数据并划分训练集和测试机集

由于iris数据集很常用，sklearn中自带iris数据集，使用 load_iris 方法即可加载iris数据集，使用train_test_split方法可以很方便地将原始数据集划分为两部分，分别用于训练与测试使用。默认情况下train_test_split会将25%的数据划分到测试集，75%的数据划分到训练集，random_state保证了随机采样的可重入性。

```python
import matplotlib.pyplot as plt
import numpy as np
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split

iris = load_iris()
X_train, X_test, y_train, y_test = train_test_split(iris['data'], iris['target'], random_state=0)
```

### 3. 接下来我们采用pair plot对数据属性相关情况进行可视化展示

```python
fig, ax = plt.subplots(3, 3, figsize=(15, 15))
plt.suptitle("iris_pairplot")
for i in range(3):
    for j in range(3):
        ax[i, j].scatter(X_train[:, j], X_train[:, i + 1], c=y_train, s=60)
        ax[i, j].set_xticks(())
        ax[i, j].set_yticks(())
        if i == 2:
            ax[i, j].set_xlabel(iris['feature_names'][j])
        if j == 0:
            ax[i, j].set_ylabel(iris['feature_names'][i + 1])
        if j > i:
            ax[i, j].set_visible(False)
plt.show()
```

![iris-pari-plot](http://7xqhkl.com1.z0.glb.clouddn.com/iris-pair-plot.png "iris-pari-plot")

### 4. 使用KNN训练模型并进行预测与评估

```python
from sklearn.neighbors import KNeighborsClassifier
knn = KNeighborsClassifier(n_neighbors=1)
knn.fit(X_train, y_train)
```
```python
X_new = np.array([[5, 2.9, 1, 0.2]])
prediction = knn.predict(X_new)
print (iris['target_names'][prediction])
```
```python
y_pred = knn.predict(X_test)
print (np.mean(y_pred == y_test))
print (knn.score(X_test, y_test))
```

```zsh
$ 0.973684210526
$ 0.973684210526
```

