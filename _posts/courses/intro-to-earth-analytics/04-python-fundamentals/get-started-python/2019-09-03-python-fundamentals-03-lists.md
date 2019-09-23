---
layout: single
title: 'Lists in Python'
excerpt: "A Python list is a data structure that stores a collection of values in a specified order (or sequence) and is mutable (or changeable). Learn how to create and work with lists in Python."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['get-started-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/get-started-using-python/lists/
nav-title: "Python Lists"
dateCreated: 2019-07-01
modified: 2019-09-23
module-type: 'class'
course: "intro-to-earth-data-science"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/python-variables-lists/lists/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Explain how **Python** uses lists to store multiple data values.
* Create new **Python** lists that contain `int`, `float` and `str` values.
* Use the list index to update, add, and remove items in a **Python** list.
 
</div>
 
 
## What are Python Lists?

A **Python** list is a data structure that stores a collection of values in a specified order (or sequence). **Python** lists are mutable, which means that they can be changed or updated.

Another interesting feature of **Python** lists is that they can store data of different types, including a mix of `int`, `float`, `str`, etc, values, all in the same list.  You can even create a list that is composed of other lists!

Each value in a list is called an item.  Since lists are sequences of items in a specified order, there is a label for the location (i.e. order number) of each item in the list.  

This order label is referred to as an index. Indexing allows lists to be iterable, meaning that you can access the each item in list, in the order in which they appear in the sequence. 


### List Index in Python

In **Python**, indexing is used by many data structures, such as lists, to organize data and manage the order of the items within the data structure. 

By default, **Python** indexing will always begin at `[0]`, rather `[1]`. 

Thus, the first item in a **Python** list has an index `[0]`, the second item in a list has an index `[1]`, and so on. 

You can use the index of an item to query its value. For example, you can use the index `[1]` to get the value for the 2nd item (`0.75`) in the following list of values (`0.70, 0.75, 1.85`). 


## Create Python Lists

Previously in this chapter, you learned how to create variables to store single data values such as `boulder_precip_in = 20.68`, which contained the the average annual precipitation in inches (in) in Boulder, Colorado. 

To create a **Python** list, you use the following syntax:

`list_name = [item_1, item_2, item_3]`

Notice that the values (soon to be items in a list) are enclosed within brackets `[]` and are separated from each other using commas `,`. 

Similar to defining variables, you do not have to define what types of values will be stored in the list.

For example, you can create lists of numeric values such as `floats`. 

{:.input}
```python
boulder_precip_in = [0.70, 0.75, 1.85]

boulder_precip_in
```

{:.output}
{:.execute_result}



    [0.7, 0.75, 1.85]





You can also create lists of `str` values. Just like defining `str` variables, you need to enclose the individual text strings using quotes `""`. 

{:.input}
```python
months = ["January", "February", "March"]

months
```

{:.output}
{:.execute_result}



    ['January', 'February', 'March']





You can also create a list that contains different types of data (e.g. `int`, `float`, `str`), including other defined variables.

{:.input}
```python
jan = 0.70

boulder_avg_precip = [1, jan, "January"]

boulder_avg_precip
```

{:.output}
{:.execute_result}



    [1, 0.7, 'January']





### Check Type

Just like you are able to check the type of data stored in a variable, you can also check the object type for lists to confirm that it is indeed a list: 

`type(list_name)`


{:.input}
```python
type(boulder_avg_precip)
```

{:.output}
{:.execute_result}



    list





## Print the Length of a List
 
To work efficiently with the list index, it is very helpful to know how long the list is, meaning how many items are stored in the list. 

You can use the **Python** function `len()` to query this information by including the name of the list as a parameter, or input, to the function as follows: 

`len(list_name)` 

Using `len()`, you can see that `months` contains 3 items, as it only contained `str` values for January through March. 

{:.input}
```python
months
```

{:.output}
{:.execute_result}



    ['January', 'February', 'March']





{:.input}
```python
len(months)
```

{:.output}
{:.execute_result}



    3





## Query List Items Using Index

As **Python** indexing begins at `[0]`, you can use the list index to query the value of the nth item in the list with `month[index]`, where index is equal to:

`number of items - 1` or `n-1`

For example, if you want to query the second item in the `months` list, you will need to use the index value that results from `2-1`, or `1`.

{:.input}
```python
months[1]
```

{:.output}
{:.execute_result}



    'February'





Note that calling an index value that is larger than `n-1` will result in an error that the index does not exist. 

In this example, `months[3]` results in the following error:

`IndexError: list index out of range`

because there are only three items in the list. 

## Update Items in Lists

In addition to querying values, you can also use the list index to update items in a list by assigning a new value to that index location. 

For example, if you want to update the value stored at `months[index]`, you can assign a new value with:

`months[index] = value`

{:.input}
```python
boulder_precip_in[1] = 0

boulder_precip_in
```

{:.output}
{:.execute_result}



    [0.7, 0, 1.85]





{:.input}
```python
months[1] = "Feb"

months
```

{:.output}
{:.execute_result}



    ['January', 'Feb', 'March']





## Delete Items From List

You can delete unwanted items from an existing list using the `del` statement: 

`del list_name[index]` 

Once again, checking the length of a list is helpful before using the list index to modify the list.

{:.input}
```python
len(boulder_precip_in)
```

{:.output}
{:.execute_result}



    3





{:.input}
```python
del months[2]

months
```

{:.output}
{:.execute_result}



    ['January', 'Feb']





## Append Items to List

To add items to the end of a list, you can use the `.append()` function that is associated with lists (referred to as a method of the list object). 

You can call this method to add values to a list using the syntax: 

`listname.append(value)` 

{:.input}
```python
months.append("March")

months
```

{:.output}
{:.execute_result}



    ['January', 'Feb', 'March']





{:.input}
```python
boulder_precip_in.append(2.93)

boulder_precip_in
```

{:.output}
{:.execute_result}



    [0.7, 0, 1.85, 2.93]





## Add Items to List

You can also add items to a list using the addition operation `+`.

For example, you can add items to the beginning of a list using the following syntax: 

`listname = [value] + listname`

{:.input}
```python
boulder_precip_in = [-9999] + boulder_precip_in

boulder_precip_in
```

{:.output}
{:.execute_result}



    [-9999, 0.7, 0, 1.85, 2.93]





You can also add items to the end of a list by combining the addition `+` with an `=`:

`listname += [value]`

which combines the steps to add and set the list equal to itself plus the new value. 

{:.input}
```python
months += ["April"]

months
```

{:.output}
{:.execute_result}



    ['January', 'Feb', 'March', 'April']





You can even use this same assignment operator to add multiple values to the end of a list. 

{:.input}
```python
months += ["May", "June"]

months
```

{:.output}
{:.execute_result}



    ['January', 'Feb', 'March', 'April', 'May', 'June']





By using the `+` and `+=` syntax to add new values to a list, you have actually just used **Python** operators, which are symbols used in **Python** to execute specific operations on variables and data structures such as lists. 

You will learn more about different operators in **Python** on the next page of this chapter. 
