---
author: Matt Oakley
category: python
layout: single
tags:
- rpy2.robjects
title: Using R and Python in the Same Notebook
---



R and Python are both useful to retrieve, analyze, and manipulate data. While these two languages are both individually viable and powerful, sometimes it may be necessary to use the two in conjunction.

Unfortunately, it is currently not possible to simultaneously use both of these languages at the same time within a Jupyter notebook due to the fact that Jupyter notebooks can only run one kernel (or language) per notebook. However, we're able to accomplish this via library-level support. The Python package *rpy2* allows us to interact with an R interpreter in-memory as opposed to running an entirely separate kernel. This tutorial will go over how to use rpy2 which in turn will allow us to use these two languages simultaneously.

## Objectives

- Use Python
- Use R within the Python kernel

## Dependencies

- Install of Python and R
- rpy2


```python
!pip install rpy2
```

    Requirement already satisfied (use --upgrade to upgrade): rpy2 in /home/user/anaconda2/lib/python2.7/site-packages
    Requirement already satisfied (use --upgrade to upgrade): singledispatch in /home/user/anaconda2/lib/python2.7/site-packages (from rpy2)
    Requirement already satisfied (use --upgrade to upgrade): six in /home/user/anaconda2/lib/python2.7/site-packages (from rpy2)



```python
from rpy2.robjects import r
```

## Using Python

As this is natively a Python kernel, we should be able to do all of the Python programming we want.


```python
print "Hello World!"
```

    Hello World!



```python
str_list = ['This', 'is', 'python!']
for i in range(0, len(str_list)):
    print str_list[i],
```

    This is python!



```python
def my_function(i):
    print "I've been called", i + 1, "times!"

for i in range(0, 5):
    my_function(i)
```

    I've been called 1 times!
    I've been called 2 times!
    I've been called 3 times!
    I've been called 4 times!
    I've been called 5 times!


## Using R within Python

As we've just shown, we can do all of our normal python programming without any hiccups. Now, let's try and do some R programming within this Python kernel.


```python
r('print("Hello World!")')
```

    [1] "Hello World!"





    R object with classes: ('character',) mapped to:
    <StrVector - Python:0x7f3552edc128 / R:0x3a8e8e8>
    [str]




```python
r('str_list <- c("This", "is", "R!")')
r('for (i in 1:length(str_list)){print(str_list[i])}')
```

    [1] "This"
    [1] "is"
    [1] "R!"





    rpy2.rinterface.NULL




```python
r('''
    my_function <- function(i){
        cat("I've been called", i, "times!\n")
    }''')
r('for (i in 1:5) {my_function(i)}')
```

    I've been called 1 times!
    I've been called 2 times!
    I've been called 3 times!
    I've been called 4 times!
    I've been called 5 times!





    rpy2.rinterface.NULL




```python

```