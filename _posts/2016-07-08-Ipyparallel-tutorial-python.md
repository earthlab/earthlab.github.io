---
author: Zach Schira
category: python
layout: single
tags:
- ipyparallel
- numpy
title: Running Parallel Jobs on JupyterHub with ipyparallel
---



[JupyterHub](https://jupyterhub.readthedocs.io/en/latest/) offers a multi user environment for running Jupyter Notebooks. Research Computing provides access to a JupyterHub environment with parallel processing support. This tutorial will demonstrate how to use the [ipyparallel](https://ipyparallel.readthedocs.io/en/latest/multiengine.html#) python package to run simple parallel jobs on JupyterHub.

## Objectives
- Connect to a remote cluster for parallel processing
- Use ipyparallel to run parallel jobs 

## Dependencies
- ipyparallel

## Using ipyparallel
Begin by installing the ipyparallel package


```python
!pip install ipyparallel
```

You will need to specify the cluster you will be running on, and connect to that cluster. For this example, we will be starting a client with 4 engines using the `$ ipcluster` command. Information on the clusters available through JupyterHub can be found [here](https://www.rc.colorado.edu/support/user-guide/jupyterhub.html). The 


```python
!ipcluster start -n 4
```

    2016-07-08 11:46:24.158 [IPClusterStart] CRITICAL | Cluster is already running with [pid=7580]. use "ipcluster stop" to stop the cluster.



```python
from ipyparallel import Client
cluster = Client()
c = cluster[:]
```

Now that you have created a connection to a cluster, you can start to run simple parallel jobs. The following code will calculate the square of each number from 1-28 and print the results.


```python
squares = c.map_sync(lambda x: x**2, range(1,28))
print('squares:',squares)
```

    squares: [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361, 400, 441, 484, 529, 576, 625, 676, 729]


There are several methods for running functions in parallel using ipyparallel. The easiest way to do this is using the `apply_sync()` method within the ipyparallel class. The following function will take two matricies and return the result of their multiplaction. By using the `apply_sync()` function with the name of the function to be executed as the first argument, and the functions arguments as the remaining arguments, the matrix multiplication will be performed in parallel on the connected cluster. This can be done with any python functions, including built in functions.


```python
import numpy as np
y = np.random.randn(50,50)
x = np.matrix(y)
def matmul(x, y):
    return x*y
res = c.apply_sync(matmul, x, x)
```

If you are creating a function with element-wise operations (perorm one opperation on every element of an array), you can use the `@parallel` tag to break the function up and process it in parallel.


```python
@c.parallel(block=True)
def arrmul(x,y):
    return x*y
res = arrmul(y, y)
```

When you have finished using the clusters, it is important to free the resources you have been using. For this example, this can be done using the `$ ipcluster` command again. If you are running your job in JupyterHub you can find more information on the rescources available, and how to use them [here](https://www.rc.colorado.edu/support/examples-and-tutorials/parallel-processing-with-jupyterhub.html).


```python
!ipcluster stop
```

    2016-07-08 11:46:32.410 [IPClusterStop] Removing pid file: C:\Users\Zach\.ipython\profile_default\pid\ipcluster.pid