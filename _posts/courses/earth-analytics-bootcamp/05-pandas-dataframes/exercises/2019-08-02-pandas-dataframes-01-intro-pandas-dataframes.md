---
layout: single
title: 'Intro to Pandas Dataframes'
excerpt: "This lesson describes key characteristics of pandas dataframes, a data structure commonly used for scientific data."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['pandas-dataframes']
permalink: /courses/earth-analytics-bootcamp/pandas-dataframes/intro-pandas-dataframes/
nav-title: "Intro to Pandas Dataframes"
dateCreated: 2019-07-24
modified: 2018-09-10
module-title: 'Intro to Working With Pandas Dataframes in Python'
module-nav-title: 'Pandas Dataframes'
module-description: 'This tutorial walks you through importing tabular data (.csv) to pandas dataframes as well as summarizing, plotting, and running calculations on pandas dataframes.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn about another data structure commonly used for tabular scientific data - `pandas dataframes` - and the key characteristics that distinguish this data structure from `numpy arrays`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Describe the data structure of `pandas dataframes`
* Explain how `pandas dataframes` differ from `numpy arrays` 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/numpy-arrays/">Numpy Arrays.</a> 

 </div>


## Pandas Dataframes

In the lessons introducing `Python` lists and `numpy arrays`, you learn that both of these data structures are complex, meaning that they can store collections of values, instead of just single values. 

You also learned that while `Python` lists are flexible and can store data items of various types (e.g. integers, floats, text strings), `numpy arrays` require all data elements to be of the same type. 

However, because of this requirement, `numpy arrays` can provide more functionality for running calculations such as element-by-element arithmetic operations (e.g. multiplication of each element in the `numpy array` by the same value) that `Python` lists do not support.  

In today's lessons, you will learn about another commonly used data structure for scientific data - `pandas dataframes` - which provide even more functionality for working with tabular data (i.e. data organized using rows and columns). 

`Pandas dataframes` are data structures that are composed of rows and columns that can have header names, and the columns in `pandas dataframes` can be different types (e.g. the first column containing integers and the second column containing text strings). 


| months          |  precip |
|:---------------|:--------|
| January        | 0.70 |
| February       |  0.75 |
| March          | 1.85 |  

Each value in `pandas dataframe` is referred to as a cell that has a specific row index and column index within the tabular structure. 


## Distinguishing Characteristics of Pandas Dataframes

These characteristics (i.e. tabular format with header names for columns or rows) make `pandas dataframes` very versatile for not only storing different types, but for maintaining the relationships between cells across the same row and/or column. 

Recall that in the lessons on `numpy arrays`, you could not easily connect the values across `precip` and `months` using `numpy arrays`. Within `pandas dataframes`, the relationship between the value `January` in the `months` column and the value `0.70` in the `precip` column is maintained. 

These two values (`January` and `0.70`) are considered the same record, representing the same observation in the `pandas dataframe`.

In addition, `pandas dataframes` differ from `numpy arrays` in other key ways:

1. Unlike `numpy arrays`, each column in a `pandas dataframe` can have a labeled name (i.e. header name such as `months`) and can contain a different type of data from its neighboring columns. 

2. Cells within the `pandas dataframe` can be identified by its combined row and column index (e.g. `[row index, column index]`). All cells have both a row index and a column index, even if there is only one row and/or one column in the `pandas dataframe`.

3. In addition to indexing by location, you can also query for data within `pandas dataframes` based on specific values or attributes. 

3. Because of this tabular indexing, you can query and run calculations on `pandas dataframes` across an entire row, an entire column, or a specific cell or series of cells based on either location and attribute values. 

4. Due to its inherent tabular structure, `pandas dataframes` also allow for cells to have `null` or blank values. 

In the lessons that follow, you will review these benefits of working with `pandas dataframes`. 
