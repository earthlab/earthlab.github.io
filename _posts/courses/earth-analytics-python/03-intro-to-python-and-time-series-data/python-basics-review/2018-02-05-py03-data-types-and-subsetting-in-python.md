---
layout: single
title: "About data types in Python - Data Science for scientists 101"
excerpt: "This tutorial introduces numpy arrays in Python. It also introduces the differences between strings, numbers and boolean values (True / False) in Python."
authors: ['Chris Holdgraf', 'Martha Morrissey', 'Data Carpentry', 'Leah Wasser']
category: [courses]
class-lesson: ['get-to-know-python']
course: "earth-analytics-python"
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/work-with-data-types-python/
nav-title: 'Data Types'
dateCreated: 2017-05-23
modified: 2018-10-08
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Understand the structure of and be able to create a vector object in Python.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

To begin working with arrays in `python` you will first load the `numpy` library. 

{:.input}
```python
import numpy as np
```

## Numpy arrays and data types

An array is a common data structure used in `python`. An array is defined as a
group of values, which most often are either numbers or characters. You can assign this list of values to an object or variable, just like you can for a single value. For example you can create a vector of animal weights:

{:.input}
```python
weight_g = np.array([50, 60, 65, 82])
weight_g
```

{:.output}
{:.execute_result}



    array([50, 60, 65, 82])





An array can also contain characters:

{:.input}
```python
animals = np.array(['mouse', 'rat', 'dog'])
animals
```

{:.output}
{:.execute_result}



    array(['mouse', 'rat', 'dog'], 
          dtype='<U5')





There are many functions that allow you to inspect the content and structure of an
array. For instance, `len()` (short for **len**gth) tells you how many elements are in a particular vector:

{:.input}
```python
len(weight_g)
```

{:.output}
{:.execute_result}



    4





{:.input}
```python
len(animals)
```

{:.output}
{:.execute_result}



    3





## Array data types

An important feature of an array, is that all of the elements are the same data
type. The attribute `.dtype` shows us the the data type stored within an array:

{:.input}
```python
weight_g.dtype
```

{:.output}
{:.execute_result}



    dtype('int64')





{:.input}
```python
animals.dtype
```

{:.output}
{:.execute_result}



    dtype('<U5')





The function `type()` shows us the **structure** of the object. 

{:.input}
```python
# View the python object type
type(weight_g)
```

{:.output}
{:.execute_result}



    numpy.ndarray





You can add elements to an array using the `.hstack()` function. 
Below, you add the value 90 to the end of the `weight_g` object.

{:.input}
```python
# add the number 90 to the end of the vector
weight_g = np.hstack([weight_g, 90])
```

{:.input}
```python
# add the number 30 to the beginning of the vector
weight_g = np.hstack([30, weight_g])
```

{:.input}
```python
weight_g
```

{:.output}
{:.execute_result}



    array([30, 50, 60, 65, 82, 90])





In the examples above, you saw 2 standard **data** types that `Python` uses:

1. `"String"` and
2. `"Integer"`.

These are four primative data types that all `python` objects are built
from. They are 

* `"Boolean"` for `TRUE` and `FALSE` 
* `"Integer"` : whole numbers from negative infinity to infinity 
* `"Float"` : Rational Numbers ending with decinmal points 
* `"String"` : Collections of words or characters in single or double quotes



## Data type vs. data structure

Data structures in python include arrays, lists, tuples, sets, and dictonaries. 

* `"Arrays"`: In this class you will work with arrays through the numpy modeule, it is important to know that arrays and lists are similar but arrays must be made up of elments that are the same data type. 
* `"lists"`: denoted by [] and contain a series of values, seperated by , they are mutable in python which means they can be changed 
* `"Tuple"`: defined by () and contain a series of values, but tuples are immutable 
* `"Sets"`: a collect of unique objects. Sets are mutable 
* `"Dictonaries"` list of key value pairs that are denoted by {} a key and its value(s) are seperated by a : and key value pairs are sepearted by commas. 


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge activity

* **Question**: What happens when you create a list that contains both numbers
and character values? Give it a try and write down the answer.

<!-- * _Answer_: Python lets you create a list with elements as different data types or as the same data type. -->


* **Question**: What will happen in each of these examples? (hint: use `type()`
  to check the data type of your objects):


```python
num_char = np.array([1, 2, 3, 'a'])

num_logical = np.array([1, 2, 3, True])

char_logical = np.array(['a', 'b', 'c', True])

tricky = np.array([1, 2, 3, '4'])
```

* **Question**: Why do you think it happens?

<!-- * _Answer_: arrays can be of only one data type. Python tries to convert (=coerce)
  the content of this array to find a "common denominator". -->

* **Question**: Can you draw a diagram that represents the hierarchy of the data
  types?

<!-- * _Answer_: `logical -> numeric -> character <-- logical` -->

</div>

{:.input}
```python
animals = np.array(["mouse", "rat", "dog", "cat"])
animals[2]

```

{:.output}
{:.execute_result}



    'dog'





# Subset arrays

If you want to extract one or several values from a vector, you must provide one
or several indices in square brackets. For instance:

{:.input}
```python
animals[[2, 3]]
```

{:.output}
{:.execute_result}



    array(['dog', 'cat'], 
          dtype='<U5')






<div class="notice--success" markdown="1">

### <i class="fa fa-star"></i> 0 vs 1-based Indexing

Python and other languages such as C++, Java, and Perl count from 0. The first element of a list in python will be accessed with listname[0]. Programming languages like `Fortran`, `MATLAB`, and `R` start counting at 1. So, in comparison, in `R`, you would use listname[1].

Subsetting using a series of sequential numbers in Python, is also different from a language like `R`. In python, you the end n umber in the subset is 1 index BEYOND the last index value. So, if you want the first three elements of a list you would run `listname[0:3]` and that would return the elements at positions 0, 1, and 2. 

</div>


You can subset arrays too. For instance, if you want to select only the values that are greater than 50:

{:.input}
```python
weight_g > 50
```

{:.output}
{:.execute_result}



    array([False, False,  True,  True,  True,  True], dtype=bool)





Notice that the command above returns a `BOOLEAN` (`TRUE` / `FALSE`) array. You can then use 
that array to select all objects in your weight_g array that are greater than 50 as follows:


{:.input}
```python
# select only the values greater than 50
weight_g[weight_g > 50]
```

{:.output}
{:.execute_result}



    array([60, 65, 82])





You can combine multiple tests using `&` (both conditions are `TRUE`, AND) or `|`
(at least one of the conditions is `TRUE`, OR):


{:.input}
```python
# select objects that are EITHER less than 30 OR greater than 50
weight_g[(weight_g < 30) | (weight_g > 50)]
```

{:.output}
{:.execute_result}



    array([60, 65, 82])





{:.input}
```python
# select objects that are greater than or equal to 30 OR equal to 21
weight_g[(weight_g >= 30) & (weight_g == 21)]
```

{:.output}
{:.execute_result}



    array([], dtype=int64)








Notice that you use two `==` signs to designate `equal to` so as not to confuse equals to with the assignment operator which is also `=` in Python.

{:.input}
```python
animals = np.array(['mouse', 'rat', 'dog', 'cat'])
animals[(animals == 'cat') | (animals == 'rat')]
```

{:.output}
{:.execute_result}



    array(['rat', 'cat'],
          dtype='<U5')





The function `intersection()` allows you to test
if a value is found in an array of values:


{:.input}
```python
# select objects in the animals array that are within the array [`rat`, `cat`, `dog`, `duck`]
set(animals).intersection(set(['rat', 'cat', 'dog', 'duck']))
```

{:.output}
{:.execute_result}



    {'cat', 'dog', 'rat'}






<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

* Can you figure out why `"four" > "five"` returns `TRUE`?

</div>

## Answers

<!-- When using ">" or "<" on strings, python compares their alphabetical order. Here "four" comes after "five", and therefore is "greater than" it. -->
