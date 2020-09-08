---
layout: single
title: "Intro to Conditional Statements in Python"
excerpt: "Conditional statements help you to control the flow of code by executing code only when certain conditions are met. Learn about the structure of conditional statements in Python and how they can be used to write Do Not Repeat Yourself, or DRY, code in Python."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-conditional-statements-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/conditional-statements/
nav-title: "Intro to Conditional Statements"
dateCreated: 2019-10-22
modified: 2020-09-03
module-title: 'Introduction to Conditional Statements in Python'
module-nav-title: 'Conditional Statements in Python'
module-description: 'Conditional statements help you to control the flow of code by executing code only when certain conditions are met. Learn how to use conditional statements to write Do Not Repeat Yourself, or DRY, code in Python.'
module-type: 'class'
class-order: 2
chapter: 17
course: "intro-to-earth-data-science-textbook"
week: 7
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
  - "/courses/earth-analytics-bootcamp/conditional-statements/intro-conditional-statements/"
  - "/courses/intro-to-earth-data-science/dry-code-python/conditional-statements/"
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Seventeen - Conditional Statements

In this chapter, you will learn about the structure of conditional statements in **Python** and how you can use them to write DRY (Don't Repeat Yourself) code in **Python**.  

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Explain how conditional statements can be used to write DRY code in **Python**.
* Describe the syntax for conditional statements in **Python**.
* Write conditional statements in **Python** to control the flow of code. 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have Conda setup on your computer and the Earth Analytics Python Conda environment. Follow the <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Set up Git, Bash, and Conda on your computer</a> to install these tools.

Be sure that you have completed the chapters on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>, <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">Numpy Arrays</a>, and <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/">Pandas Dataframes</a>.

</div>


## Review of Don't Repeat Yourself (DRY) to Remove Repetition in Your Code

### Why Write Efficient, DRY (Don’t Repeat Yourself) Code

In previous chapters of this textbook, you learned that one component of reproducibility is writing code that is easy to read. 

If your code is easier to read, it will be easier for your future self to understand, and it will also be easier for your colleagues to work with and contribute to your code. 

This is important, but there is an even more selfish reason to consider writing efficient code. 

Efficient coding will make your work easier, too.

> Reproducibility is actually all about being as lazy as possible! – Hadley Wickham, Chief Scientist at RStudio (via Twitter, 2015-05-03)

For example, imagine that you have copied and pasted the same code block to repeat a specific task throughout your workflow. Any modification of that task requires the same change to be made to every single instance of that task! 

Editing every instance of a task is not only a lot of work but also introduces the potential for errors. 

So what is the alternative?

DRY (Don’t Repeat Yourself) is a principle of software development. The focus of DRY is to avoid repetition of information. 

By implementing DRY strategies for writing code, you can make your code: 

1. easier to follow and read (for yourself as well as others), thereby, supporting reproducibility.
2. easier to update because you only have to update the code for a specified task once, rather than every instance of a repeated code block.

While there are many strategies for improving efficiency and removing repetition in code, three commonly used DRY strategies are conditional statements, loops, and functions.

This chapter introduces conditional statements in **Python**, which can be used to control the flow of code by executing code only when certain conditions are met.

## Why Use Conditional Statements

A conditional statement is used to determine whether a certain condition exists before code is executed. 

Conditional statements can help improve the efficiency of your code by providing you with the ability to control the flow of your code, such as when or how code is executed.  

This can be very useful for checking whether a certain condition exists before the code begins to execute, as you may want to only execute certain code lines when certain conditions are met.   

For example, conditional statements can be used to check that a certain variable or file exists before code is executed, or to execute more code if some criteria is met, such as a calculation resulting in a specific value. 


## Structure of Conditional Statements

A conditional statement uses a syntax structure based on `if` and `else` statements (each ending with a colon `:`) that define the potential actions that can be completed based on whether the condition is true or not: 

```python
if condition:
    some code here
else:
    some other code here
```

If the condition provided with the `if` statement is satisfied (i.e. results in a value of `True`), then a certain code will execute. If that condition is not met (i.e. results in a value of `False`), then the code provided with the `else` statement will execute. 

For example:

```python
if condition:
    print("Condition is true, and this statement is printed.")
else:
    print("Condition is false (i.e. not true), so a different statement is printed.")
```

### Indentation and Execution of Code Lines 

Note that the indentations for the code lines after `if` and `else` are an important part of the syntax of conditional statements. These indentations indicate which code should be executed with which statement, and they make the code easier to read. 

In the examples above, the `print()` code can actually be replaced by any code that will execute in **Python**. For example, you could choose to add values, select data, plot data, etc. depending on whether the condition is satisfied. 

To help you get familiar with conditional statements first, the examples on this page simply execute different `print` statements depending on whether the condition is satisfied. 

## Compare Numeric Values Using Conditional Statements

You can write conditional statements that use comparison operators (e.g.  equal to `==`, less than `<`)  to check the value of a variable against some other value or variable. 

For example, you can check whether the value of a variable is equal (`==`) to a certain value. 

{:.input}
```python
# Set x to 10
x = 10

# Compare x to 10
if x == 10:
    print("x is equal to 10.")    
else:
    print("x has a value of", x, "which is not equal to 10.")   
```

{:.output}
    x is equal to 10.



{:.input}
```python
# Set x to 0
x = 0

# Compare x to 10
if x == 10:
    print("x is equal to 10.")    
else:
    print("x has a value of", x, "which is not equal to 10.")    
```

{:.output}
    x has a value of 0 which is not equal to 10.



You can also use other comparison operators to check whether the value of variable is less than (`<`) or greater (`>`) than a certain value or another variable. 

{:.input}
```python
# Set x to 0
x = 0

# Check whether x is less than 10
if x < 10:
    print("x has a value of", x, "which is less than 10.")    
else:
    print("x has a value of", x, "which is greater than 10.")    
```

{:.output}
    x has a value of 0 which is less than 10.



{:.input}
```python
# Create y equal to -10
y = -10

# Check whether x is greater than y
if x > y:
    print("x has a value of", x, "which is greater than", y)
else:
    print("x has a value of", x, "which is less than", y) 
```

{:.output}
    x has a value of 0 which is greater than -10



{:.input}
```python
# Set y equal to 100 
y = 100

# Check whether x is greater than y
if x > y:
    print("x has a value of", x, "which is greater than", y)
else:
    print("x has a value of", x, "which is less than", y) 
```

{:.output}
    x has a value of 0 which is less than 100



## Check For Values Using Conditional Statements

You can use membership operators (e.g. `in` or `not in`) to write conditional statements to check whether certain values are contained within a data structure, such as a list, or even a text string. 

{:.input}
```python
# Create list of average monthly precip (inches) in Boulder, CO
avg_monthly_precip = [0.70,  0.75, 1.85, 2.93, 3.05, 2.02, 
                      1.93, 1.62, 1.84, 1.31, 1.39, 0.84]

# Check for value 0.70 in list
if 0.70 in avg_monthly_precip:
    print("Value is in list.")
else:     
    print("Value is not in list.")
```

{:.output}
    Value is in list.



{:.input}
```python
# Check for value 0.71 in list
if 0.71 in avg_monthly_precip:
    print("Value is in list.")
else:     
    print("Value is not in list.")
```

{:.output}
    Value is not in list.



The condition above could also be checked in the opposite manner using `not in` to check that the value is not in the list:

{:.input}
```python
# Check that value 0.71 not in list
if 0.71 not in avg_monthly_precip:
    print("Value is not in list.")
else:     
    print("Value is in list.")
```

{:.output}
    Value is not in list.



You can also use membership operators to check for specific words within a text string.

{:.input}
```python
# Check for string "precip" within text string "avg_monthly_temp"
if "precip" in "avg_monthly_temp":
    print("This textstring contains the word precip.")
    
else:
    print("This textstring does not contain the word precip.")
```

{:.output}
    This textstring does not contain the word precip.



Note that with this syntax, you are simply checking whether one text string is contained within another text string.

Thus, if you check for a specific text string within the name of an object, such as a list (e.g. `avg_monthly_precip`), you are not actually checking the values contained with the object.

Instead, specifying the object name using quotations `""` (e.g. `"list_name"`) identifies that you are referring to the name as text string.  

{:.input}
```python
# Check for string "precip" within text string "avg_monthly_precip"
if "precip" in "avg_monthly_precip":
    print("This textstring contains the word precip.")
    
else:
    print("This textstring does not contain the word precip.")
```

{:.output}
    This textstring contains the word precip.



Checking for specific text strings within the names of objects, such as lists or data structures, can be helpful when you have a long, automated workflow for which you want to execute code on only those objects that have a particular word in the name.

## Check Object Type Using Conditional Statements  

You can also use identity operators (e.g. `is` or `is not`) to write conditional statements to check whether an object is of a certain type (e.g. `int`, `str`, `list`). 

{:.input}
```python
# Set x to 0
x = 0

# Check if x is type integer
if type(x) is int:
    print(x, "is an integer.")
else:
    print(x, "is not an integer.")
```

{:.output}
    0 is an integer.



{:.input}
```python
# Check if x is type float
if type(x) is float:
    print(x, "is a float.")
else:
    print(x, "is not a float.")
```

{:.output}
    0 is not a float.



{:.input}
```python
# Check if x is not type string
if type(x) is not str:
    print(x, "is not a string.")
else:
    print(x, "is a string.")
```

{:.output}
    0 is not a string.



With identity operators, you can also check that an object is a certain data structure, such as a list, and even compare its type to the type of another object. 

{:.input}
```python
# Create list of abbreviated month names
months = ["Jan", "Feb", "Mar", "Apr", "May", "June",
         "July", "Aug", "Sept", "Oct", "Nov", "Dec"]

if type(months) is list:
    print("Object is a list.")
else:
    print("Object is not a list.")
```

{:.output}
    Object is a list.



{:.input}
```python
# Check that type of months matches type of avg_monthly_precip
if type(avg_monthly_precip) is type(months):
    print("These objects are of the same type.")
else: 
    print("These objects are not of the same type.")
```

{:.output}
    These objects are of the same type.



Note in the example above that you are not checking whether the objects are lists, but rather whether they are both of the same type. Because both of the objects are indeed lists, the condition is satisfied.

## Check Paths Using Conditional Statements

You can also use conditional statements to check paths using a familiar function: `os.path.exists()`.

In the example below, you will download a .txt file that contains the average monthly precipitation values for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Boulder, Colorado, provided by the U.S. National Oceanic and Atmospheric Administration (NOAA)</a>. 

Begin by importing the necessary packages and writing the code needed to download the data (**earthpy**) and set the working directory (**os**). You will also use **numpy** package to import the data into a **numpy** array. 

{:.input}
```python
# Import necessary packages
import os
import numpy as np
import earthpy as et
```

{:.input}
```python
# Avg monthly precip (inches) of Boulder, CO for 1-d array
avg_month_precip_url = 'https://ndownloader.figshare.com/files/12565616'
et.data.get_data(url=avg_month_precip_url)
```

{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/avg-monthly-precip.txt'





{:.input}
```python
# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

Next, define a relative path to the downloaded file, which you will use in the conditional statement. 

{:.input}
```python
# Path relative to working directory
avg_month_precip_path = os.path.join("data", "earthpy-downloads", 
                                     "avg-monthly-precip.txt")
```

Last, add the defined path to the conditional statement to check whether the path exists. 

{:.input}
```python
# Check path
if os.path.exists(avg_month_precip_path):
    print("This is a valid path.")
else:
    print("This path does not exist.")
```

{:.output}
    This is a valid path.



You can expand on the conditional statement to execute additional code if the path is valid, such as code to import the file into a **numpy** array. 

{:.input}
```python
# Import data into array if path exists
if os.path.exists(avg_month_precip_path):
    avg_month_precip = np.loadtxt(avg_month_precip_path)
    print(avg_month_precip)
else:
    print("This path does not exist.")
```

{:.output}
    [0.7  0.75 1.85 2.93 3.05 2.02 1.93 1.62 1.84 1.31 1.39 0.84]



Using this syntax, you can check whether any defined path exists and then execute additional code as needed.

On the next pages of this chapter, you will learn how to write conditional statements that check for multiple conditions and how to apply conditional statements to **numpy** arrays and **pandas** dataframes. 
