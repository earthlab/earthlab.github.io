---
layout: single
title: "Write Efficient Scientific Code - the DRY (Don't Repeat Yourself) Principle "
excerpt: "This lesson will cover the basic principles of using functions and why they are important."
authors: ['Max Joseph', 'Leah Wasser', 'Software Carpentry', 'Reproducible Science Curriculum Community']
modified: '2018-01-10'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/write-efficient-code-for-science-r/
nav-title: "Modular Code"
module-title: "Don't Repeat Yourself: Remove Repetition in Your Code Using Functions in R."
module-description: "This module will overview the basic principles of DRY - don't repeat yourself. It will then walk you through incorporating functions into your scientific programming to increase efficiency, clarity, and readability. "
module-nav-title: 'Efficient Programming Using Functions'
module-type: 'class'
course: "earth-analytics"
week: 6
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 1
redirect_from:
  - "/courses/earth-analytics/week-8/automate-your-science-r/"
---


{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Be able to define the DRY principle.
* Describe how functions can make your code easier to read.
* Identify repeated lines of code that could be replaced by functions.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>


## Efficient Coding 101

In the first week of class, you learned about reproducibility. One component of
reproducibility is writing easier to read code. If your code is easier to read,
it will be easier for your future self to understand. It will also be easier for
your colleagues to work with. This is important,
but there is an even more selfish reasons to consider writing efficient code.

Efficient coding will make your life easier too.

> Reproducibility is actually all about being as lazy as possible!
> – Hadley Wickham (via Twitter, 2015-05-03)


## Don't Repeat Yourself - DRY

DRY (Don't Repeat Yourself) is a principle of software development. The focus of
DRY is to avoid repetition of information.

Why?

When you write code that performs the same tasks over and over again, any
modification of one task requires the same change to be made to every single
instance of that task! Editing every instance of a task is a lot of work.


<figure>
 <a href="{{ site.url}}/images/courses/earth-analytics/week-8/funct-all-things.png">
 <img src="{{ site.url}}/images/courses/earth-analytics/week-8/funct-all-things.png" alt="Functionalize all the things."></a>
    <figcaption>You can use functions in our code to replace tasks that you are performing over and over. Source: Francois Michonneau
    </figcaption>
</figure>

Instead, you can create **functions** that perform those tasks, using sets of
**arguments** or inputs to specify how the task is performed.

## The Benefits of Functions

* **Modularity:** If you write function for specific individual tasks, you can use them over and over. A function that you write for one script can even be reused in other scripts!
* **Fewer global variables:** When you run a function, the intermediate variables that it creates are not stored in your global environment. This saves memory and keeps your global environment cleaner.
* **Better documentation:** Well documented functions help the user understand the steps of your processing.
* **Easier to maintain / edit:** When you create a function for a repeated task, it is easy to edit that one function. Then every location in your code where that same task is performed is automatically updated.
* **Testing:** You won't learn this in class this week, but writing functions allows you to more easily test your code to identify bugs.

> input --> function does something --> output

### Write Modular Functions and Code

Good functions only do one thing, but they do it well and often in a variety of contexts.
Often the operations contained in a good function are generally useful for many tasks.
Take for instance the `R` function `mean()`, which computes sample mean values.
This function only does one thing (computes a mean). However you may use the `mean()`
function in different places in your code. You may use it to calculate a new column
value in a data.frame. Or you could use it to calculate that mean of a matrix.

The `mean()` function is **modular**. It can be easily combined with other
functions to accomplish a variety of tasks.

> numeric input --> function calculates mean --> mean is returns as an output


When you write **modular** functions, you can even re-use them for other projects.
Some people even write their own `R` packages for personal use that contain custom
functions for their work.

## Functions Create Fewer Global Variables

Global variables are objects in `R` that exist within the **global environment**.
You learned about the global environment in the first few weeks of class. You can think
of it as a bucket filled with all of the objects (and package functions) in your
`R` session. When you code line by line, you create numerous intermediate variables
that you don't need to use again.

Creating intermediate variables that you don't need to use is problematic because:

1. **Global variables accumulate in your environment**, but you may never need to access intermediate results.
2. **Global variables consume memory**, which can lead to reduced performance. In the extreme, you may run out of RAM if you have too many objects in your global environment.
3. Lots of global variables increases the odds that you will define another global variable with the same name. This will overwrite the existing object and will lead to problems with your code.

### Functions Run in Their Own Environment

Similar to pipes, functions run in their own environment. This function environment
is created when the function is called, and deleted (by default) once the function
returns a result. Objects defined inside of functions are thus created inside of
that function's environment. Once the function is done running, those objects
are gone! This means less memory is used.

For instance, if you define an object in your global environment:


```r
# first define x -x is a global variable
x <- 10
```

Then define and call a function which defines an object called `x`:


```r
modify_x <- function(x) {
  x <- 2 * x
  x
}

modify_x(x)
## [1] 20

x
## [1] 10
```

Notice that the `x` in our global environment is unchanged, even though it was
changed in the body of your function. The `x` in the function environment was
removed once the function returned its result.

Functions allow you to focus on the inputs and the outputs of your workflow rather
than the intermediate steps.

## Reasons Why Functions Improve Code Readability

### 1. Better Documentation

Ideally, your code is easy to understand.
However, what might seem clear to you now might be clear as mud 6 months from now
or even 3 weeks from now (remember we discussed your future self in week 1 of this class).

Well written functions help you document your workflow because:

1. Well written functions are documented with inputs and outputs clearly defined.
2. Well written functions use names that help you better understand the task that the
function performs.

### 2. Expressive Function Names Make Code Self-Describing

Name functions using verbs the indicate what the function *does*. This makes
your code more expressive or self describing and in turn makes it easier to read
for both you, your future self and your colleagues.

### 3. Easier to Maintain and Edit

If all your code is written line by line, with repeated code in
multiple parts of your document, it can be challenging to maintain.

Imagine having to fix one element of a line of code that is repeated many times.
You will have to find and replace that code to implement the fix in EVERY INSTANCE
it occurs in your code. This makes your code difficult to maintain.

Do you also duplicate your comments where you duplicate parts of your scripts?
How do you keep the duplicated comments in sync?
**A comment that is misleading because the code changed is worse than no comment at all.**

Re-organizing your code using functions (or organizing your code using functions
from the beginning) allows you to explicitly document the tasks that your code performs.

### 4. You Can Incorporate Testing To Ensure Code Runs Properly

While you won't learn this in class this week, functions are also useful for testing.
As your code gets longer and more complex, it is more prone to mistakes. For example, if your
analysis relies on data that gets updated often, you may want to make sure that
all the columns in your spreadsheet are present before performing an analysis.
Or that the new data are not formatted in a different way.

Changes in data structure and format could cause your code to not run. Or in the
worse case scenario, your code may run but return the wrong values!

If all your code is made up of functions, that have built in tests to ensure
that they run as expected, then you can control the input and test for the output.
It is something that would be difficult to do if all of your code is written,
line by line with repeated steps.

## Summary

It is a good idea to learn how to:

1. **Modularize** your code and identify generalizable tasks.
2. Write functions for parts of your code which include repeated steps.
3. Document your functions clearly, specifying the structure of the inputs and outputs.
