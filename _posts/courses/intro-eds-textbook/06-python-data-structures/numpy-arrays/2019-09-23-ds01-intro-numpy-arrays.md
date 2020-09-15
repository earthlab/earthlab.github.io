---
layout: single
title: 'Intro to Numpy Arrays'
excerpt: "Numpy arrays are a commonly used scientific data structure in Python that store data as a grid, or a matrix. Learn about the key characteristics of numpy arrays that make them an efficient data structure for storing and working with large scientific datasets."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-numpy-arrays']
permalink: /courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/
nav-title: "Intro to Numpy Arrays"
dateCreated: 2019-09-06
modified: 2020-09-15
module-title: 'Work with Scientific Data Using Numpy Arrays'
module-nav-title: 'Numpy Arrays'
module-description: 'Numpy arrays are a commonly used scientific data structure in Python that store data as a grid, or a matrix. Learn how to import data into numpy arrays and how to run calculations, summarize, and select data from numpy arrays.'
module-type: 'class'
chapter: 14
class-order: 1
course: "intro-to-earth-data-science-textbook"
week: 6
estimated-time: "2-3 hours"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/numpy-arrays/intro-numpy-arrays/"
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Fourteen - Numpy Arrays

In this chapter, you will learn about a commonly used data structure in Python for scientific data: **numpy** arrays. You will write **Python** code to import text data (.txt and .csv) as **numpy** arrays and to run calculations and summarize data in **numpy** arrays.

After completing this chapter, you will be able to:

* Describe the key characteristics of **numpy** arrays.
* Import data from text files (.txt, .csv) into **numpy** arrays. 
* Run calculations and summarize data in **numpy** arrays.
* Use indexing to slice (i.e. select) data from **numpy arrays**.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have Conda setup on your computer and the Earth Analytics Python Conda environment. Follow the <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Set up Git, Bash, and Conda on your computer</a> to install these tools.

Be sure that you have completed the chapters on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>, <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/use-python-packages/">working with packages in Python</a>, and <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/">working with paths and directories in Python</a>.

</div>


## What are Numpy Arrays

**Numpy** arrays are a commonly used scientific data structure in **Python** that store data as a grid, or a matrix.

In **Python**, data structures are objects that provide the ability to organize and manipulate data by defining the relationships between data values stored within the data structure and by providing a set of functionality that can be executed on the data structure. 

Recall that in the previous chapters, you used lists (another data structure in **Python**) to store values of monthly precipitation for Boulder, CO. 

Like **Python** lists, **numpy** arrays are also composed of ordered values (called elements) and also use indexing to organize and manipulate the elements in the **numpy** arrays. 

A key characteristic of **numpy** arrays is that all elements in the array must be the same type of data (i.e. all integers, floats, text strings, etc).

Unlike lists which do not require a specific **Python** package to be defined (or worked with), **numpy** arrays are defined using the `array()` function from the **numpy** package.  

To this function, you can provide a list of values (i.e. the elements) as the input parameter:

`array = numpy.array([0.7 , 0.75, 1.85])`

The example above creates a **numpy** array with a simple grid structure along one dimension. However, the grid structure of **numpy** arrays allow them to store data along multiple dimensions (e.g. rows, columns) that are relative to each other. This dimensionality makes **numpy** arrays very efficient for storing large amounts of data of the same type and characteristic.


## Key Differences Between Python Lists and Numpy Arrays

While **Python** lists and **numpy** arrays have similarities in that they are both collections of values that use indexing to help you store and access data, there are a few key differences between these two data structures:

1. Unlike a **Python** list, all elements in a **numpy** arrays must be the same data type (i.e. all integers, decimals, text strings, etc).

2. Because of this requirement, **numpy** arrays support arithmetic and other mathematical operations that run on each element of the array (e.g. element-by-element multiplication). Recall that lists cannot have these numeric calculations applied directly to them.

3. Unlike a **Python** list, a **numpy** array is not edited by adding/removing/replacing elements in the array. Instead, each time that the **numpy** array is manipulated in some way, it is actually deleted and recreated each time.

4. **Numpy** arrays can store data along multiple dimensions (e.g. rows, columns) that are relative to each other. This makes **numpy** arrays a very efficient data structure for large datasets. 


## Dimensionality of Numpy Arrays 

**Numpy** arrays can be:
* one-dimensional composed of values along one dimension (resembling a **Python** list).
* two-dimensional composed of rows of individual arrays with one or more columns.
* multi-dimensional composed of nested arrays with one or more dimensions. 

In this chapter, you will work with one-dimensional and two-dimensional **numpy** arrays.

For **numpy** arrays, brackets `[]` are used to assign and identify the dimensions of the **numpy** arrays. 

This first example below shows how a single set of brackets `[]` are used to define a one-dimensional array. 

{:.input}
```python
# Import numpy with alias np
import numpy as np
```

{:.input}
```python
# Monthly avg precip for Jan through Mar in Boulder, CO
avg_monthly_precip = np.array([0.70, 0.75, 1.85])

print(avg_monthly_precip)
```

{:.output}
    [0.7  0.75 1.85]



Notice that the output of the one-dimensional **numpy** array is also contained within a single set of brackets `[]`.

To create a two-dimensional array, you need to specify two sets of brackets `[]`, the outer set that defines the entire array structure and inner sets that define the rows of the individual arrays.

{:.input}
```python
# Monthly precip for Jan through Mar in 2002 and 2013
precip_2002_2013 = np.array([
    [1.07, 0.44, 1.50],
    [0.27, 1.13, 1.72]
])

print(precip_2002_2013)
```

{:.output}
    [[1.07 0.44 1.5 ]
     [0.27 1.13 1.72]]



Notice again that the output of the two-dimensional **numpy** array is contained with two sets of brackets `[]`, which is an easy, visual way to identify whether the **numpy** array is two-dimensional. 

Dimensionality will remain a key concept for working with **numpy** arrays, as you learn more throughout this chapter including how to use attributes of the **numpy** arrays to identify the number of dimensions and how to use indexing to slice (i.e. select) data from **numpy** arrays.
