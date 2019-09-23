---
layout: single
title: 'Intro to Numpy Arrays'
excerpt: "Numpy arrays are . Learn ."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['numpy-arrays']
permalink: /courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/
nav-title: "Intro to Numpy Arrays"
dateCreated: 2019-09-06
modified: 2019-09-23
module-title: 'Numpy Arrays'
module-nav-title: 'Numpy Arrays'
module-description: 'Numpy arrays are . Learn .'
module-type: 'class'
chapter: 14
class-order: 1
course: "intro-to-earth-data-science-textbook"
week: 6
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

In this chapter, you will learn about a commonly used data structure in Python for scientific data: numpy arrays. You will write `Python` code to import text data (.txt and .csv) as `numpy arrays` and to manipulate, summarize, and plot data in `numpy arrays`.

After completing this chapter, you will be able to:

* Describe the key characteristics of **numpy** arrays.
* Import data from text files (.txt, .csv) into **numpy** arrays. 
* Run calculations and summarize data in **numpy** arrays.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>


## What are Numpy Arrays

`Numpy arrays` are a commonly used data structure for scientific data. Data structures are **Python** objects that provide the ability to organize and manipulate data by defining the relationships between data values stored within the data structure and by providing a set of functionality that can be executed on the data structure. 

Recall that in the previous lessons, you also used `Python` lists (another data structure in **Python**) to store values of monthly precipitation for Boulder, CO. 

Like `Python` lists, `numpy arrays` are also composed of ordered values, which are called elements, and also use indexing to organize and manipulate the elements in the `numpy array`. 

`array([0.7 , 0.75, 1.85])`

Unlike lists, which do not require a specific package to be defined, `Numpy arrays` are defined using the `numpy.array()` function with a list of values (i.e. the elements) as the input parameter. 

All elements in an `numpy array` must be the same type of data (i.e. all integers, floats, text strings, etc).

`Numpy arrays` can store data along multiple dimensions (e.g. rows, columns) that are relative to each other, resulting in dimensionality contained within this data structure. This dimensionality makes `numpy arrays` very efficient for storing large amounts of data of the same type and characteristic.



## Key Differences Between Python Lists and Numpy Arrays

While `Python` lists and `numpy arrays` have similarities in that they are both collections of values that use indexing to help you store and access data, there are a few key differences between these two data structures:

1. Unlike a `Python` list, all elements in a `numpy array` must be the same data type (i.e. all integers, decimals, text strings, etc).

2. Because of this requirement, `numpy arrays` support arithmetic and other mathematical operations that run on each element of the array (e.g. element-by-element multiplication). `Lists` do not support these calculations.

3. Unlike a `Python` list, a `numpy array` is not edited by adding/removing/replacing elements in the array. Instead, the `numpy array` is deleted and recreated each time that it is manipulated.

4. `Numpy arrays` can store data along multiple dimensions (e.g. rows, columns) that are relative to each other.


## Dimensionality of Numpy Arrays 

`Numpy arrays` can be one-dimensional, meaning that they contain values along one dimension similar to a `Python` list, or they can be multi-dimensional with multiple rows and columns. 

In `numpy arrays`, brackets `[]` are used to assign the dimensions of the `numpy array`. 

```python
# example of one-dimensional numpy array of monthly average precipitation for January through March in Boulder, CO
precip = numpy.array([0.70, 0.75, 1.85])
```

```python
# example of two-dimensional numpy array of January through March precipitation in Boulder, CO for two years: 2002 and 2013
# dimensions are 2 rows, 3 columns
precip = np.array([ [1.07, 0.44, 1.50], 
                 [0.27, 1.13, 1.72] ])
```

This means that indexing for two-dimensional `numpy arrays` requires two values identifying the location of an element within the `numpy array`: the row number and the column number. 

In this course, you will work with one and two dimensional `numpy arrays`, and in the lessons that follow, you will learn how you can use indexing to access data in one- and two-dimensional `numpy arrays`.

{:.input}
```python
# Add to this page: Manual definition of numpy arrays
```
