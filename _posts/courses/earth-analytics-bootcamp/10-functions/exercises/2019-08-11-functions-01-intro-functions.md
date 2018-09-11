---
layout: single
title: 'Intro to Functions'
excerpt: "This lesson describes how functions are used in Python to write DRY and modular code."
authors: ['Jenny Palomino', 'Leah Wasser', 'Software Carpentry']
category: [courses]
class-lesson: ['functions']
permalink: /courses/earth-analytics-bootcamp/functions/intro-functions/
nav-title: "Intro to Functions"
dateCreated: 2019-08-11
modified: 2018-09-10
module-title: 'Intro to Writing Custom Functions in Python'
module-nav-title: 'Functions'
module-description: 'This tutorial walks you through defining custom functions and applying them to data structures in Python.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 10
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how functions are used in Python to write DRY and modular code that eliminates repetition and improves the efficiency of your code.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Define modular code
* Explain how functions help you to write DRY and modular code

</div>


## Modular Code With Functions

In the introduction to DRY code, you learned about the DRY (i.e. Do Not Repeat) yourself principle and were introduced to three strategies for eliminating repetition and improving the efficiency of your code: loops, conditional statements, and functions. 

In previous lessons, you learned about using loops to eliminate repetitive lines of code and using conditional structures to control the flow of your code. 

In this lesson, you will learn how functions in Python help you to execute a specific, outlined task on command, using sets of input parameters to specify how the task is performed.

`input parameter –> function does something –> output results`

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/week-8/funct-all-things.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/week-8/funct-all-things.png" alt="You can implement strategies such as loops and functions in your code to replace tasks that you are performing over and over. Source: Francois Michonneau."></a>
 <figcaption> You can implement strategies such as loops and functions in your code to replace tasks that you are performing over and over. Source: Francois Michonneau.
 </figcaption>
</figure>


## The Benefits of Functions

* Modularity: If you write function for specific individual tasks, you can use them over and over. A function that you write for one `Python` workflow can even be reused in other workflows!

* Fewer variables: When you run a function, the intermediate variables that it creates are not stored as explicit variables unless you specify otherwise. This saves memory and keeps your `Python` environment cleaner. 

* Better documentation: Well documented functions help other users understand the steps of your processing and helps your future self to understand previously written code.

* Easier to maintain and edit your code: When you create a function for a repeated task, it is easy to edit that one function. Then, every location in your code in which you call that function (i.e. when same task is performed) is automatically updated.

* Testing: You won’t learn about this in this class, but writing functions allows you to more easily test your code to identify issues (i.e. bugs).


### Write Modular Functions and Code

Good functions only do one thing, but they do it well and often in a variety of contexts. Often, the operations contained in a good function are generally useful for many tasks. 

Take, for instance, the `numpy` function called `mean()`, which computes mean values from a `numpy array`. This function only does one thing (i.e. computes a mean); however, you may use the `np.mean()` function many times in your code on multiple `numpy arrays`. 

The `np.mean()` function is modular, and it can be easily combined with other functions to accomplish a variety of tasks.

`numeric input –> function calculates mean –> mean is returns as an output`

When you write modular functions, you can re-use them for other workflows and projects. Some people even write their own `Python` packages for personal and professional use that contain custom functions for their work.


### Functions Create Fewer Variables

When you code line by line, you create numerous intermediate variables that you do not need to use again. This is inefficient and can cause your code to be repetitive if you are constantly creating variables that you will not use again. 

Functions allow you to focus on the inputs and the outputs of your workflow rather than the intermediate steps, such as creating extra variables that are not needed.


## Reasons Why Functions Improve Code Readability

### Better Documentation

Ideally, your code is easy to understand and is well-documented with `Python` comments (and `Markdown` in `Jupyter Notebook`). However, what might seem clear to you now might not be clear 6 months from now, or even 3 weeks from now.

Well-written functions help you document your workflow because:

    1. Well-written functions are documented by clearly outlining the inputs and outputs.
    2. Well-written functions use names that help you better understand the task that the function performs.

### Expressive Function Names Make Code Self-Describing

When writing your own functions, you should name functions using verbs and/or clear labels to indicate what the function does (i.e. `in_to_mm`). This makes your code more expressive or self-describing, and in turn makes it easier to read for both you, your future self and your colleagues.


### Easier to Maintain and Edit

If all your code is written line by line, with repeated code in multiple parts of your document, it can be challenging to maintain.

Imagine having to fix one element of a line of code that is repeated many times. You will have to find and replace that code to implement the fix in EVERY INSTANCE it occurs in your code. This makes your code difficult to maintain.

Do you also duplicate your comments where you duplicate parts of your scripts? 

How do you keep the duplicated comments in sync? A comment that is misleading because the code changed is worse than no comment at all.

Re-organizing your code using functions (or organizing your code using functions from the beginning) allows you to explicitly document the tasks that your code performs.

**You Can Incorporate Testing To Ensure Code Runs Properly**

While you won’t learn this in class this week, functions are also useful for testing. As your code gets longer and more complex, it is more prone to mistakes. 

For example, if your analysis relies on data that gets updated often, you may want to make sure that all the columns in your spreadsheet are present before performing an analysis. Or, that the new data are not formatted in a different way.

Changes in data structure and format could cause your code to not run. Or, in the worse case scenario, your code may run but return the wrong values!

If all your code is made up of functions (with built-in tests to ensure that they run as expected), then you can control the input to the function and test for the output. It is something that would be difficult to do if all of your code is written, line by line with repeated steps.

## Summary of Writing Modular Code with Functions

It is a good idea to learn how to:

1. Modularize your code into generalizable tasks.
2. Write functions for parts of your code which include repeated steps.
3. Document your functions clearly, specifying the structure of the inputs and outputs.
