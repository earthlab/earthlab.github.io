---
layout: single
title: 'Intro to DRY code'
excerpt: "This lesson describes the DRY (i.e. Do Not Repeat Yourself) principle and lists key strategies for writing DRY code in Python."
authors: ['Jenny Palomino', 'Leah Wasser', 'Software Carpentry']
category: [courses]
class-lesson: ['loops']
permalink: /courses/earth-analytics-bootcamp/loops/intro-dry-code/
nav-title: "Intro to DRY code"
dateCreated: 2019-08-11
modified: 2018-09-10
module-title: 'Intro to Writing Loops in Python'
module-nav-title: 'Loops'
module-description: 'This tutorial walks you through implementing a key strategy for writing DRY (i.e. Do Not Repeat Yourself) code in Python: loops.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn about the DRY (i.e. Do Not Repeat Yourself) principle as well as strategies to write DRY code in order to eliminate repetition and improve the efficiency of your code.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Be able to define the DRY principle
* List key strategies for writing DRY code in Python
* Explain how these strategies help you write DRY code

</div>


## Don't Repeat Yourself: Remove Repetition in Your Code

### Why Write Efficient Code

In the first week of class, you learned about reproducibility. One component of reproducibility is writing code that is easy to read. 

If your code is easier to read, it will be easier for your future self to understand. It will also be easier for your colleagues to work with and contribute to your code. This is important, but there is an even more selfish reason to consider writing efficient code.

Efficient coding will make your life easier, too.

`Reproducibility is actually all about being as lazy as possible! – Hadley Wickham (via Twitter, 2015-05-03)`


### Don’t Repeat Yourself - DRY

DRY (Don’t Repeat Yourself) is a principle of software development. The focus of DRY is to avoid repetition of information.

Why?

One main reason is that when you write code that performs the same tasks over and over again, any modification of one task requires the same change to be made to every single instance of that task! Editing every instance of a task is a lot of work.

By implementing DRY code strategies, you can make your code: 

1. easier to follow and read (for yourself as well as others), thereby supporting reproducibility
2. easier to update because you only have to update your code once, rather than every that code block is used


## Strategies For Writing DRY Code

While there are many strategies for trying to improve efficiency and remove repetition in code, three commonly used strategies are loops, conditional statements, and functions, all of which you will learn about in this course.


### Loops 

A loop is a sequence of operations that are performed over and over in some specified order. 

Loops can help you to eliminate repetition in code by replacing duplicate lines of code with an iteration, meaning that you can iteratively execute the same code line or block until it reaches an end point specified by you.

For example, the following lines could be replaced by a loop that iterates over a list of variable names and executes the `print()` function until it reaches the end of the list:

```python
print(avg_monthly_precip)
print(months)
print(precip_2002_2013)
```

You can create lists of variables, filenames, or other objects like data structures upon which you want to execute the same code. These lists can then be used as variables in loops. 

In today's lessons, you will write learn how to iterate code using loops in `Python`.

### Conditional Statements

A conditional statement is used to determine whether a certain condition exists before code is executed. Conditional Statements can help improve the efficiency of your code by providing you with the ability to control the flow of your code, such as when or how code is executed.  

For example, conditional statements can be used to check that a certain variable or file exists before code is executed, or to continue code if some criteria is met such as a calculation resulting in a specific value. 

In the example below, the following lines could be replaced with a conditional statement that the variable name must contain the word `precip`, in which case the code would only execute on `avg_monthly_precip` and `precip_2002_2013`.

```python
print(avg_monthly_precip)
print(months)
print(precip_2002_2013)
```

In upcoming lessons, you learn how to write and use conditional statements in `Python`. 


### Functions

A function is organized block of code that is reusable and performs a specific task. Functions can help you to both eliminate repetition and improve efficiency in your code through modularity.

Writing modular code allows you to subdivide tasks of a workflows into organized units of code that can be reused by yourself and others, often without them needing to know the specific details of the code.

In this course, you have used many functions already, such as the previous example `print()`, to produce output. You have also used functions that require input parameters, such as the `read.csv()` function to import data into a `pandas dataframe`. 

In both of these examples, you have generally sense of what the function is doing because you know what input parameters are required and what output you will receive. 

However, you do not need to know the specific lines of code that `read.csv()` is executing in the background for you to use it to import your CSV files into a `pandas dataframe`. 

In upcoming lessons, you learn how to write your own functions in `Python`. 
