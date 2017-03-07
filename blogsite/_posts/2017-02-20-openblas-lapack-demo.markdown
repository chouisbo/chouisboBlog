---
layout: post
title:  "OpenBLAS 与 LAPACK快速上手"
date:   2017-02-20 10:21:21 +0800
categories: ml
---


## 1. OpenBLAS


### 1.1 Build

```zsh
make -j4
make install PREFIX=xxx
```


### 1.2 References


* [Apple BLAS API Reference](https://developer.apple.com/reference/accelerate/1668466-blas)
* [MKL-BLAS and Sparse BLAS Routines](https://software.intel.com/zh-cn/node/520724)
* [Numpy-Documentation](https://docs.scipy.org/doc/)
* [BoostBLAS-ublas](http://www.boost.org/doc/libs/1_61_0/libs/numeric/ublas/doc/)


### 1.3 Examples

* example.py

```python

import numpy as np

M, N, K, alpha, beta = 3, 3, 2, 1.0, 0.0
A = np.array([1.0,2.0,1.0,-3.0,4.0,-1.0]).reshape(M, K)
B = np.array([1.0,2.0,1.0,-3.0,4.0,-1.0]).reshape(K, N)
C = np.array([.5,.5,.5,.5,.5,.5,.5,.5,.5]).reshape(M, N)

print alpha * np.dot(A, B) + beta * C

```

* example.c

```c
#include <cblas.h>
#include <stdio.h>

void main() {

    int i = 0;
    double A[6] = {1.0,2.0,1.0,-3.0,4.0,-1.0};         
    double B[6] = {1.0,2.0,1.0,-3.0,4.0,-1.0};  
    double C[9] = {.5,.5,.5,.5,.5,.5,.5,.5,.5}; 

    int M = 3; // row of A and C
    int N = 3; // col of B and C
    int K = 2; // col of A and row of B

    double alpha = 1.0;
    double beta = 0.0;

    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, M, N, K, alpha, A, K, B, N, beta, C, N);

    for (i = 0; i < 9; i++) {
        printf("%lf ", C[i]);
    }
    printf("\n");
}
```

```zsh

$ gcc -o example example.c -I ./include -L ./lib -lopenblas -lpthread -lgfortran

$ python example.py 
[[ -5.  10.  -1.]
 [ 10. -10.   4.]
 [  7.   4.   5.]]
 
$ ./example 
-5.000000 10.000000 -1.000000 10.000000 -10.000000 4.000000 7.000000 4.000000 5.000000
```

---


## 2. LAPACK

### 2.1 Build

```zsh

mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=/home/zhubolong/openblas/lapack-3.7.0-release ..
make -j4
make test
make install


cp LAPACK/make.inc.example LAPACK/make.inc
cd LAPACKE
make lapacke


```

### 2.2 Reference

* [LAPACK - Linear Algebra PACKage](http://www.netlib.org/lapack/)
* [LAPACK Users' Guide 3rd](http://www.netlib.org/lapack/lug/)
* [LAPACKE C Interface to LAPACK](http://www.netlib.org/lapack/lapacke.html)


### 2.3 Examples

* example.py
```python

import numpy as np

M, N, K = 3, 2, 5
A = np.array([1,1,1,2,3,4,3,5,2,4,2,5,5,4,3]).reshape(K, M)
B = np.array([-10,-3,12,14,14,12,16,16,18,16]).reshape(K, N)

print np.linalg.lstsq(A, B)

```

* example.c

```c

#include <stdio.h>
#include <lapacke.h>

int main (int argc, const char * argv[]) {
    double a[5][3] = {1,1,1,2,3,4,3,5,2,4,2,5,5,4,3};
    double b[5][2] = {-10,-3,12,14,14,12,16,16,18,16};
    lapack_int info,m,n,lda,ldb,nrhs;
    int i,j;

    m = 5;
    n = 3;
    nrhs = 2;
    lda = 3;
    ldb = 2;

    info = LAPACKE_dgels(LAPACK_ROW_MAJOR,'N',m,n,nrhs,*a,lda,*b,ldb);

    for(i=0;i<n;i++) {
        for(j=0;j<nrhs;j++) {
            printf("%lf ",b[i][j]);
        }
        printf("\n");
    }
    return(info);
}

```

```zsh
$ gcc -o example example.c -I ./include -L ./lib -llapacke -llapack -lblas -ltmglib -lpthread -lgfortran -lm

$ python example.py 
(array([[ 2.,  1.],
       [ 1.,  1.],
       [ 1.,  2.]]), array([ 200.,   51.]), 3, array([ 12.31682225,   3.16227766,   1.81545851]))

$ ./example 
2.000000 1.000000 
1.000000 1.000000 
1.000000 2.000000
```
