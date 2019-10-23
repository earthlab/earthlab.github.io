---
layout: single
title: 'Intro to Conditional Statements'
excerpt: "Conditional statements support efficient code by executing code only when certain conditions are met. Learn about the structure of conditional statements in Python and how they can be used to write DRY (Don't Repeat Yourself) code in Python."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['conditional-statements-tb']
permalink: /courses/intro-to-earth-data-science/dry-code-python/conditional-statements/
nav-title: "Intro to Conditional Statements"
dateCreated: 2019-10-22
modified: 2019-10-23
module-title: 'Conditional Statements in Python'
module-nav-title: 'Conditional Statements'
module-description: 'Conditional statements support efficient code by executing code only when certain conditions are met. Learn how to use conditional statements to write DRY (Don't Repeat Yourself) code in Python.'
module-type: 'class'
chapter: 17
class-order: 1
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/conditional-statements/intro-conditional-statements/"
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Seventeen - Conditional Statements

In this chapter, you will learn about the structure of conditional statements in **Python** and how you can use them to write DRY (Don't Repeat Yourself) code in **Python**.  

After completing this chapter, you will be able to:

* Describe the syntax for conditional statements in **Python**.
* Explain how conditional statements can be used to write DRY code in **Python**.
* Write conditional statements in **Python** to control the flow of code. 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have Conda setup on your computer and the Earth Analytics Python Conda environment. Follow the <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Set up Git, Bash, and Conda on your computer</a> to install these tools.

Be sure that you have completed the chapters on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>, <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">Numpy Arrays</a>, and <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/">Pandas Dataframes</a>.

</div>


## Don't Repeat Yourself: Remove Repetition in Your Code

### Why Write Efficient, DRY (Don’t Repeat Yourself) Code

In the first chapter of this textbook, you learned that one component of reproducibility is writing code that is easy to read. 

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

This chapter introduces conditional statements in **Python**, which can be used to improve code efficiency by executing code only when certain conditions are met.

## Why Use Conditional Statements

A conditional statement is used to determine whether a certain condition exists before code is executed. 

Conditional statements can help improve the efficiency of your code by providing you with the ability to control the flow of your code, such as when or how code is executed.  

This can be very useful for checking whether a certain condition exists before the code begins to execute, as you may want to only execute certain code lines when certain conditions are met.   

For example, conditional statements can be used to check that a certain variable or file exists before code is executed, or to execute more code if some criteria is met, such as a calculation resulting in a specific value. 


## Structure of Conditional Statements

A conditional statement uses a syntax structure based on `if` and `else` statements that define the potential actions that can be completed: 

```python
if condition:
    some code here
else:
    some other code here
```

When the condition following the `if` is met, then a certain code will execute. When that condition is not met, then the code following the `else` will execute. For example:

```python
if condition:
    print("Condition is true.")
else:
    print("Condition is not true.")
```

In conditional statements, it can be useful to include <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/get-started-using-python/python-operators/">operators</a> to compare values, such as comparison operators (e.g. equal to `==`, less than `<`), membership operators (e.g. `in` or `not in`) and identity operators (e.g. `is`, `is not`). 


## Compare Numeric Values Using Conditional Statements

For example, you can use comparison operators to check the value of variable against some other value or variable. 

{:.input}
```python
# Set x to 0
x = 0

# Print statement based on comparison of x to 10
if x == 10:
    print("x is equal to 10.")    
else:
    print("x has a value of", x, "which is not equal to 10.")    
```

{:.output}
    x has a value of 0 which is not equal to 10.



{:.input}
```python
# Set x to 0
x = 0

# Print statement based on comparison of x to 10
if x == 10:
    print("x is equal to 10.")    
else:
    print("x has a value of", x, "which is not equal to 10.")   
```

{:.output}
    x has a value of 0 which is not equal to 10.



{:.input}
```python
# Set x to 0
x = 0

# Print statement based on comparison of x to 10
if x < 10:
    print("x has a value of", x, "which is less than 10.")    
else:
    print("x has a value of", x, "which is not less than 10.")    
```

{:.output}
    x has a value of 0 which is less than 10.



{:.input}
```python
# Now make x equal to 100
x = 100

# Print statement based on comparison of x to 10
if x < 10:
    print("x has a value of", x, "which is less than 10.")
else:
    print("x has a value of", x, "which is not less than 10.") 
```

{:.output}
    x has a value of 100 which is not less than 10.



## Check Text Strings Using Conditional Statements

You can use membership operators to also write conditional statements to identify keywords within a text string, such as the name of a variable. 

{:.input}
```python
# check if the text string "precip" in contained within the text string "avg_monthly_precip"
if "precip" in "avg_monthly_precip":
    print("This textstring contains the keyword: precip.")
    
else:
    print("This textstring does NOT contain the keyword: precip")
```

{:.output}
    This textstring contains the keyword: precip.



{:.input}
```python
# check if the text string "precip" in contained within the text string "avg_monthly_temp"
if "precip" not in "avg_monthly_temp":
    print("This textstring does NOT contain the keyword: precip.")
    
else:
    print("This textstring contains the keyword: precip.")
```

{:.output}
    This textstring does NOT contain the keyword: precip.



## Compare Object Type and Attributes Using Conditional Statements  

Identify Operators in Conditional Statements

Is
Is not

{:.input}
```python
avg_monthly_precip = [0.7,  0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84]

if type(avg_monthly_precip) is list:
    print("")
```

{:.output}
    



{:.input}
```python
months = ["Jan", "Feb", "Mar"]

if type(avg_monthly_precip) is type(months):
    print("")
```

{:.output}
    



{:.input}
```python
import numpy as np
avg_monthly_precip = np.array([0.7,  0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84])

type(avg_monthly_precip)

if avg_monthly_precip.ndim is 1:
    print("")
```

{:.output}
    



