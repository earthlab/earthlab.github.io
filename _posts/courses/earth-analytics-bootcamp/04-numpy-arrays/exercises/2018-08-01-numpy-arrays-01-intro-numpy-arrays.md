---
layout: single
title: 'Intro to Numpy Arrays'
excerpt: "This lesson describes the key characteristics of a commonly used data structure in Python for scientific data: numpy arrays."
authors: ['Jenny Palomino']
category: [courses]
class-lesson: ['numpy-arrays']
permalink: /courses/earth-analytics-bootcamp/numpy-arrays/intro-numpy-arrays/
nav-title: "Intro to Numpy Arrays"
dateCreated: 2018-07-23
modified: 2018-09-10
module-title: 'Intro to Working With Numpy Arrays in Python'
module-nav-title: 'Numpy Arrays'
module-description: 'This tutorial teaches you to work with a commonly used data structure in Python for scientific data: numpy arrays.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn about data structures in `Python` and write code to create and manipulate a commonly used data structures for scientific data: `numpy arrays`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Define a data structure in `Python` (e.g. lists, `numpy arrays`)
* Explain the structure (i.e. dimensionality) of `numpy arrays`
* Explain the differences between `Python` lists and `numpy arrays`


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/variables/">Python Variables.</a> 

 </div>


## Data Structures in Python

Data structures are variables that provide the ability to store and organize data in `Python` by defining the relationships between data values stored within the data structure and by providing a set of functionality that can be executed on the data structure. 

In fact, you have already worked with simple data structures when you created variables of single values for integers, decimal values (or floats), and text strings. 

There are also complex data structures that can store collections of values, instead of just single values. `Python` lists are one type of these complex data structures used to store multiple values. Recall that in the previous lessons, you also created `Python` lists to store values of monthly precipitation for Boulder, CO. 

In this course, you will also work with two additional complex data structures for scientific data: `numpy arrays`, which you will learn about in today's lessons, as well as `pandas dataframes`, which you will learn about in future lessons.


## Numpy Arrays

`Numpy arrays` are a commonly used data structure for scientific data. Like `Python` lists, `numpy arrays` are also composed of ordered values, which are called elements, and also use indexing to organize and manipulate the elements in the `numpy array`. 

`Numpy arrays` are defined using the `numpy.array()` function with a list of values (i.e. the elements) as the input parameter. All elements in an `numpy array` must be the same type of data (i.e. all integers, floats, text strings, etc).

`Numpy arrays` can store data using both rows and columns that are relative to each other, resulting in dimensionality contained within this data structure. This dimensionality makes `numpy arrays` very efficient for storing large amounts of data of the same type and characteristic.

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


## Key Differences Between Python Lists and Numpy Arrays

While `Python` lists and `numpy arrays` have similarities in that they are both collections of values that use indexing to help you store and access data, there are a few key differences between these two data structures:

1. Unlike a `Python` list, all elements in a `numpy array` must be the same data type (i.e. all integers, decimals, text strings, etc).

2. Because of this requirement, `numpy arrays` support arithmetic and other mathematical operations that run on each element of the array (e.g. element-by-element multiplication). `Lists` do not support these calculations.

3. Unlike a `Python` list, a `numpy array` is not edited by adding/removing/replacing elements in the array. Instead, the `numpy array` is deleted and recreated each time that it is manipulated.

4. `Numpy arrays` have dimensionality resulting from the ability to store data using both rows and columns that are relative to each other.

In the lessons that follow, you will review these features of `numpy arrays` and learn why `numpy arrays` are a useful data structure for scientific data. 
