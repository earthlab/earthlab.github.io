---
layout: single
title: 'Introduction to List Comprehensions in Python: Write More Efficient Loops'
excerpt: "A list comprehensions in Python is a type of loop that is often faster than traditional loops. Learn how to create list comprehensions to automate data tasks in Python."
authors: ['Nathan Korinek', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-loops-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/loops/list-comprehensions
nav-title: "List Comprehensions"
dateCreated: 2020-07-07
modified: 2021-01-28
module-type: 'class'
chapter: 18
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Modify values in a list using a list comprehension
* Apply a function to values in a list using a list comprehension
* Use conditional statements within a list comprehension to control list outputs
 
</div>

## List Comprehension Basics
Loops, as you've seen, can be a very powerful tool to manipulate and create data. 
However, they're not the only option when it comes to these types of operations. 
Another popular method is list comprehension. It's a concise and quick way to modify 
values in a list and create a new list from the output. It works in a similar way to 
a `for` loop, but has slightly different syntax. One can be translated to the other fairly 
easily! 

To perform list comprehension, you have to put the for loop and the desired outcome inside 
of a list. So this:

```
new_list = []
for i in list:
    new_list.append(i*i)
```
becomes this:
```
new_list = [i*i for i in list]
```

You can see that the code takes up less space, and uses similar words to the for loop. 
However, the execution is different.

### Benefits and Downsides of List Comprehension
There are many pros and cons to consider when using list comprehension. 

Pros: 
* Generally faster than for loops, especially for large datasets.
* Takes less code to write and fits in a smaller space than a for loop.

Cons:
* Can be less legible in certain situations.
* Can be harder to implement for complicated operations in for loops. 

In this lesson, you will go over things you learned how to do with traditional `for` 
loops and see how to do them with list comprehension. 

## Time Saved with List Comprehension

Because of differences in how **Python** implements for loops and list comprehension, 
list comprehensions are almost always faster than for loops when performing operations. 
Below, the same operation is performed by list comprehension and by for loop. It's a simple 
operation, it's just creating a list of the squares of numbers from 1 to 50000. From the 
timed cells below, you can see that the list comprehension runs almost twice as fast as the 
for loop for this calculation. This is one of the primary benefits of using list 
comprehension.  

{:.input}
```python
%%time
# Time a cell using a for loop
for_list = []
for i in range(50000):
    for_list.append(i*i)
```

{:.output}
    CPU times: user 0 ns, sys: 7.63 ms, total: 7.63 ms
    Wall time: 7.6 ms



{:.input}
```python
%%time
# Time a cell using list comprehension
comp_list = [i*i for i in range(50000)]
```

{:.output}
    CPU times: user 3.61 ms, sys: 0 ns, total: 3.61 ms
    Wall time: 3.62 ms



## Modify Values with List Comprehension

Operations previously done by for loops can use list comprehension. You have 
converted inches to millimeters many times in these lessons. A cleaner way to 
do this is using list comprehension. Below is a list of Boulder precipitation 
values in inches being modified to millimeters with list comprehension.

{:.input}
```python
# Create list of average monthly precip (inches) in Boulder, CO
avg_monthly_precip_in = [0.70,  0.75, 1.85, 2.93, 3.05, 2.02, 
                         1.93, 1.62, 1.84, 1.31, 1.39, 0.84]

# Convert each item in list from in to mm
[month * 25.4 for month in avg_monthly_precip_in]
```

{:.output}
{:.execute_result}



    [17.779999999999998,
     19.049999999999997,
     46.99,
     74.422,
     77.46999999999998,
     51.308,
     49.022,
     41.148,
     46.736,
     33.274,
     35.306,
     21.336]





## Apply a Function to a List

Similar to modifying a value in a list, it's possible to use list comprehension 
to apply a function to every value in a list. This can be useful for more complicated 
operations that need to be performed. This can also be done with the `map` function. 
More info on mapping can be found in the Data Tip below.

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** `map` in **Python**

While a list comprehension is one way to apply a function to every variable in a list, **Python** has functions more suited for this type of operation, namely the `map()` function. Although it can be more complicated, it is very useful for the type of situation where you would be applying a complicated function to every variable in a list, **pandas** `DataFrame`, or other data storage object. [For further reading on `map()`, see this website explaining the fundamentals.](https://www.geeksforgeeks.org/python-map-function/)

</div>

{:.input}
```python
# Function written to convert from inches to mm
def convert_in_to_mm(num):
    return num * 25.4

# Using list comprehension to convert all the variables in the list
[convert_in_to_mm(month) for month in avg_monthly_precip_in]
```

{:.output}
{:.execute_result}



    [17.779999999999998,
     19.049999999999997,
     46.99,
     74.422,
     77.46999999999998,
     51.308,
     49.022,
     41.148,
     46.736,
     33.274,
     35.306,
     21.336]





## Conditionals

### If Condition Only

Conditionals can be implemented in list comprehension. This is can be an easy way 
to filter out unwanted variables from a list. If the conditional doesn't have an 
`else` statement, the `if` condition is put after the for loop.

{:.input}
```python
# Filtering out values in a month that are less than 1.5
[month for month in avg_monthly_precip_in if month > 1.5]
```

{:.output}
{:.execute_result}



    [1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84]





### If Else Conditionals

If your conditional has an else statement, it is formatted differently. In this 
case, it would go before the for loop, with the operation for the `if` condition 
going before `if`, and the operation for the `else` condition going after `else`. 

{:.input}
```python
# Performing two different operations on the variables depending on if they are more or less than 1.5. 
# If they are more then 1.5, they are multiplied by negative 2. Otherwise, they are multiplied by positive 2. 
[month * -2 if month > 1.5 else month * 2 for month in avg_monthly_precip_in]
```

{:.output}
{:.execute_result}



    [1.4, 1.5, -3.7, -5.86, -6.1, -4.04, -3.86, -3.24, -3.68, 2.62, 2.78, 1.68]




