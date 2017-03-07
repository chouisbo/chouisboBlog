---
layout: post
title:  "Armadillo_OpenBLAS_IntelMKL安装"
date:   2017-02-24 10:31:21 +0800
categories: ml
---


## 1. Intel-MKL

* [Intel Math Kernel Library](https://software.intel.com/en-us/intel-mkl)
* chouisbo@163.com
* Serial Number: 33RM-TL8JN77F

### 1-1 Installation

```zsh

# 执行 ./install.sh 命令按步骤运行即可，要输入序列号

./install.sh

```

---

## 2. OpenBLAS

* [Basic Linear Algebra Subprograms](http://www.netlib.org/blas/)
* [BLAS QuickReference Guide](http://www.netlib.org/blas/blasqr.pdf)
* [An optimized BLAS library](http://www.openblas.net/)


```zsh

make -j4
make install PREFIX=xxx

```

---

## 3. Armadillo

* [Armadillo](http://arma.sourceforge.net/)
* [Armadillo Documentation](http://arma.sourceforge.net/docs.html)
* [Armadillo Download](http://arma.sourceforge.net/download.html)

Armadillo is a high quality linear algebra library (matrix maths) for the C++ language, aiming towards a good balance between speed and ease of use.

### 3-1 Linux Compiling & Linking

```txt
The "examples" directory contains several quick example programs
that use the Armadillo library.
 
In general, programs which use Armadillo are compiled along these lines:
  
  g++ example1.cpp -o example1 -O2 -larmadillo
  
If you want to use Armadillo without installation (not recommended),
compile along these lines:
  
  g++ example1.cpp -o example1 -O2 -I /home/blah/armadillo-7.200.3/include -DARMA_DONT_USE_WRAPPER -lblas -llapack
  
The above command line assumes that you have unpacked the armadillo archive into /home/blah/
You will need to adjust this for later versions of Armadillo (ie. change the 7.200.3 part)
and/or if you have unpacked the armadillo archive into a different directory.
 
Replace -lblas with -lopenblas if you have OpenBLAS.
On Mac OS X, replace -lblas -llapack with -framework Accelerate
```

### 3-2 不编译库使用Armadillo+OpenBLAS

```zsh
# 直接将 Armadillo 的 include 目录下的文件放到OpenBLAS的include下即可
# 使用如下命令即可编译 Armadillo 提供的 example1.cpp 文件
# 由此可见 Armadillo 是在BLAS库的基础上做了更友好的API封装的元模板编程库

g++ example1.cpp -o example1 -O2 -I ./include -DARMA_DONT_USE_WRAPPER -L./lib -lopenblas

# 但是每次编译代码都要重新编译Armadillo的元模板，编译比较耗费时间！！！
```

### 3-3 编译Armadillo + OpenBLAS


```zsh

# 源码项目采用 CMake 构建，首先阅读 README.txt 
# 并使用 cmake . -LH 查看所有编译选项

cmake . -LH

# 打开 config.hpp 文件, 进行交叉编译链接的选择

vim include/armadillo_bits/config.hpp

// #define ARMA_USE_LAPACK
// #define ARMA_USE_BLAS


# 将编译好的 OpenBLAS 的lib目录拷贝到 Armadillo 源码项目目录中

cmake -Dopenblas_LIBRARY:FILEPATH=./lib/libopenblas.a \
      -Dopenblaso_LIBRARY:FILEPATH=./lib/libopenblas.so \
      -Dopenblasp_LIBRARY:FILEPATH=./lib/libopenblas_penrynp-r0.2.19.so \
      -DMKL_ROOT:STRING=. .


make install DESTDIR=my_usr_dir

```

### 3-4 Armadillo Build with MKL

```zsh

cmake -DMKL_ROOT:STRING=/home/chouisbo/intel/mkl .
mkdir install; make install DESTDIR=./install

cmake -DMKL_ROOT:STRING=/home/zhubolong/intel/mkl .
make install DESTDIR=/home/zhubolong/Armadillo-7.500.2_with_IntelMKL-2017.0.098

```





