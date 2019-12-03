---
layout: single
title: 'Variables in Python'
excerpt: "Variables store data (i.e. information) that you want to re-use in your code (e.g. a single value, list of values, path to a directory, filename). Learn how to write Python code to work with variables."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['python-variables-lists']
permalink: /courses/earth-analytics-bootcamp/python-variables-lists/variables/
nav-title: "Variables in Python"
dateCreated: 2018-06-27
modified: 2018-09-10
module-title: 'Intro to Working With Variables and Lists in Python'
module-nav-title: 'Python Variables and Lists'
module-description: 'This tutorial teaches you how to create and manipulate variables and lists in Python. You will also learn how to plot data using the matplotlib package.'
module-type: 'class'
course: "earth-analytics-bootcamp"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will write `Python` code to create variables (to store data values) and to run arithmetic calculations on variables. 

<div class='notice--success' markdown="1">

# <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain how `Python` uses variables to store data
* Write `Python` code to:
    * create variables to store single data values (e.g. integers, decimals, text string) 
    * run simple arithmetic calculations on these variables (e.g. with the addition operator `+`)
   
 
# <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/">Setting up Git, Bash, and Anaconda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the previous lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/jupyter-notebook-interface/">The Jupyter Notebook Interface</a>.

The code below is available in the **ea-bootcamp-day-2** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 

 </div>

## Python Variables

Within a programming workflow, variables store data (i.e. information) that you want to re-use in your code (e.g. a single value, list of values, a filename, or path to a directory). 

In `Python`, variables can be created without defining the type of data that it will hold (e.g. whole numbers, text string). This differs from many other programming languages that require the variable to be explicitly assigned a data type. 

A variable can contain a single value - such as a whole number (i.e. integer), decimal, or text string - or it can contain a list of values. In this lesson, you will work with variables that store single data values. 

You can create a variable to store a single numeric value by defining a name and assigning a value to that name using the equal (`=`) operator (e.g. `variablename = 1.5`). 

If the value is a text string, you need to add quotations (`""`) around the value, so that `Python` knows it is a text string (e.g. `variablename = "text"`). 

Just like you want to use good naming conventions for directories on your computer, you also want to assign clear and short names to variables, avoiding spaces or complicated wording, but still specific enough that you know what it is. 

For example, a variable containing the average annual precipitation in millimeters (mm) for Boulder, Colorado could simply be called `precip`. 

{:.input}
```python
precip = 525

precip
```

{:.output}
{:.execute_result}



    525





{:.input}
```python
city = "Boulder"

city
```

{:.output}
{:.execute_result}



    'Boulder'





In this lesson, you will:

1. create new variables for average monthly precipitation values for Boulder, CO, U.S.A.
2. apply arithmetic calculations to these variables to convert the values from inches to millimeters. 

You will use data on average monthly precipitation for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Boulder, Colorado provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).</a> 

Month  | Precipitation (inches) |
--- | --- |
Jan | 0.70 |
Feb | 0.75 |
Mar | 1.85 |
Apr | 2.93 |
May | 3.05 |
June | 2.02 |
July | 1.93 |
Aug | 1.62 |
Sept | 1.84 |
Oct | 1.31 |
Nov | 1.39 |
Dec | 0.84 |


## Begin Writing Your Code

### Add Comments to Your Python Code 

You have previously learned that documentation is critical for open reproducible science. `Python` provides a great way to easily document your code with comments. 

Adding `Python` comments before each code block can help you to document and explain what is being accomplished with that code. 

`Python` comments are lines in the your code that will not execute a task and can be designated using `#`. Typically, the comment is written before the lines of codes, or code bloack (e.g. `# the code below does this`).

## Create Variables

Begin by creating a variable for each month to store the single value of average precipitation in that month (e.g. `jan = 0.70`). 

{:.input}
```python
# create new variables for monthly average precipitation values (inches) for January through June
jan = 0.70
feb = 0.75
mar = 1.85
apr = 2.93
may = 3.05
june = 2.02
```

## Running Arithmetic Calculations

In `Python`, there are many arithmetic operators including operators for addition (`+`) , subtraction (`-`), multiplication (`*`), and division (`\`). 

Run the Cells below and notice that the output is automatically generated, without the need to call the `print` function. 

{:.input}
```python
a = 4
b = 10

a + b
```

{:.output}
{:.execute_result}



    14





{:.input}
```python
b - a
```

{:.output}
{:.execute_result}



    6





{:.input}
```python
a * b
```

{:.output}
{:.execute_result}



    40





{:.input}
```python
b / a
```

{:.output}
{:.execute_result}



    2.5





## Assign Calculation Results to Variable

You can also assign new values to an existing variables as part of an arithmetic operation, though now you will need to use the `print` function, in order to see the results.

{:.input}
```python
a = a + b

print(a)
```

{:.output}
    14



Notice that the word `print` does not show up the output. Instead, you simply see the result `14`, without the quotations or parentheses. 

**You have now used your first `Python` function!** Functions in `Python` are commands that can take inputs that are used to produce output. 

We will learn more about functions as the course continues, and we will use the `print` function a lot, as it can be very handy for viewing results and for communicating the status of your code. 

Now that you have created individual variables to store the average precipitation (in inches) for each month, you can run arithmetic calculations on these variables to convert the values from inches to millimeters (mm). One inch is equal to 25.4 mm.

Use the multiplication (`*`) operator to multiply each monthly variable by 25.4 to convert the value from inches to millimeters. Use the original variable name (e.g. `jan`) to recreate it with the new value. 

{:.input}
```python
# convert the monthly variables for `jan` to `june` from inches to millimeters (1 inch = 25.4 mm)  
jan = jan * 25.4
feb = feb * 25.4
mar = mar * 25.4
apr = apr * 25.4
may = may * 25.4
june = june * 25.4

# print the value of `jan` to check that its value has changed
print(jan)
```

{:.output}
    17.779999999999998



Congratulations - you have created your first `Python` variables of this course!

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Create new variables for monthly average precipitation values (inches) for July through December (hint: `jan = 0.70`).

2. Use the appropriate arithmetic operator to convert the monthly variables for `july` to `dec` from inches to millimeters (1 inch = 25.4 mm) (hint: `jan = jan * 25.4`).

3. Print the values of `july` and `dec` to check that the values have changed (hint: `print(jan)`).

</div>



{:.output}
    49.022
    21.336


