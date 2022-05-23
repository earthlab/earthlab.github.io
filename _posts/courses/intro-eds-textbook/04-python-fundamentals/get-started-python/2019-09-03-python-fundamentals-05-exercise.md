---
layout: single
title: 'Python Fundamentals Exercise'
excerpt: "Complete these exercises to practice the skills you learned in the Python fundamentals chapters."
authors: ['Leah Wasser', 'Nathan Korinek']
category: [courses]
class-lesson: ['get-started-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/get-started-using-python/python-fundamentals-exercises/
nav-title: "Python Fundamentals Exercises"
dateCreated: 2019-07-01
modified: 2020-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

This page of exercises will test the skills that you learned in the previous lessons in this chapter.

</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Create Lists from Data 

The data below represent average monthly precipitation for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Boulder, Colorado provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).</a> 

Month  | Precipitation (inches) |
--- | --- |
jan | 0.70 |
feb | 0.75 |
mar | 1.85 |
apr | 2.93 |
may | 3.05 |
june | 2.02 |
july | 1.93 |
aug | 1.62 |
sept | 1.84 |
oct | 1.31 |
nov | 1.39 |
dec | 0.84 |

Create two **Python** lists as follows:
1. the first list should contain the month abbreviations and should be called `boulder_precip_months`.
2. the second list should be a list of precipitation values and should be called `boulder_precip_inches`.

Both lists should contain the data in the table above, in the order they appear in the 
table above! Here are all of the data formatted to make it easier for you to create your 
list! 

`0.70, 0.75,  1.85 , 2.93, 3.05 , 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84`

And here are the months:

`jan, feb, mar, apr, may, june, july, aug, sept, oct, nov, dec`

**HINT: the month values should be strings and the precipitation values should be floating point numbers!**

</div>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Modify Values in Existing List

Next, convert each floating point value in the `boulder_precip_inches` to 
millimeters by creating a new list variable called `boulder_precip_mm`. 
One way to do this is to create a copy of the old list and assign it to a 
new variable name - like this:

`new_list = old_list.copy()`

HINT: There are several efficient ways of converting your data to mm including list comprehensions. 

For this exercise, you can begin by making a copy of the `boulder_precip_inches` object using:

`boulder_precip_inches.copy()` 

Reassign that copy to the new variable called `boulder_precip_mm`. Then, 
you can replace each value in your new list using indexing. Refer back 
to the lesson on lists if you do not remember how to replace a value in 
a list. To convert inches to millimeters, you need to multiply the inches 
by `25.4` (1 inch = 25.4 mm). To make your code more legible, you can create 
a variable at the top of your notebook that stores the conversion value of 
`25.4`. A well named conversion variable will make your code easier to manage 
and easier to read.

</div>


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 3: Create a List of Lists

You can make a list of lists (a list which contains multiple sublists) using the following syntax:

`list_of_lists = [list_one, list_two]`

In the cell below, create a list called `all_boulder_data` that contains the 
`boulder_precip_months` and `boulder_precip_mm` objects as sublists.

</div>

{:.input}
```python
# Creating the list of lists

all_boulder_data = [boulder_precip_months, boulder_precip_mm]
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 4: Plot the Data in the List of Lists

Modify the following code to create a plot of your data. Be sure to use the 
`all_boulder_data` object for your plot:

HINT: you will need to properly index the all_boulder_data object to access each 
sublist within it. 

```python
# Import necessary plot package
import matplotlib.pyplot as plt

# Plot monthly precipitation values
fig, ax = plt.subplots(figsize=(6, 6))
ax.bar(listname_x_axis, 
       listname_y_axis, 
       color="red")
ax.set(title="Add plot title here",
       xlabel="Add x axis label here", 
       ylabel="Add y axis label here")
plt.show()
```

Customize this plot by completing the following tasks:
1. Replace `listname_x_axis` and `listname_y_axis` with the appropriate sublist within the `all_boulder_data` list.
2. Change the <a href="https://matplotlib.org/mpl_examples/color/named_colors.hires.png" target="_blank">color of the plot</a> to a blue color such as aqua.
3. Update the text for the titles and axes labels. 
4. Modify the values in `figsize=(6, 6)` to change the size of your plot. 

For your titles and labels, be sure to think about the following pieces of information that could help someone easily interpret the plot:

* geographic coverage or extent of data.
* duration or temporal extent of the data.
* what was actually measured and/or represented by the data.
* units of measurement.

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/04-python-fundamentals/get-started-python/2019-09-03-python-fundamentals-05-exercise/2019-09-03-python-fundamentals-05-exercise_9_0.png" alt = "Bar graph showing the average precipitation per month in Boulder, CO in millimeters.">
<figcaption>Bar graph showing the average precipitation per month in Boulder, CO in millimeters.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> BONUS Challenge: List Comprehensions in Python

Above you performed many tasks manually. Included in those manual steps was one 
where you converted each individual value in your list from inches to mm.
In **Python**, list comprehensions are a great way to perform operations on a sequence 
of values stored within a list. 

The syntax for a list comprehension is below. Essentially what is happening is that 
Python is iterating through each value in the old list (`for i in my_old_list`) and 
multiplying it by 2 (`i*2`). In each iteration of the loop, the value `i` represents 
the next value in the list. In the example below, `i` will first be the value 1, 
and then 2, and finally 3.


```python
my_old_list = [1, 2, 3]
my_new_list = [i *2 for i in my_old_list] 
```

`my_new_list` will equal each value in `my_old_list` multiplied by 2, so `my_new_list` 
will be equivalent to `[2, 4, 6]`. You can run this code and see the output for yourself!
Try to experiment with writing more efficient code. Convert your `boulder_precip_inches` 
list of values to a new list called `boulder_precip_mm` using a list comprehension. Use 
the syntax above to help you create this list comprehension.

For more information on loops and changing values within a list, you can check out <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/write-efficient-python-code/loops/" target="_blank">Earth Lab's lesson introducing loops in Python,</a> and you can go to <a href="https://www.pythonforbeginners.com/basics/list-comprehensions-in-python" target="_blank">this more in depth explanation on list comprehensions in Python.</a>

</div>

