---
layout: single
title: 'Intro to Conditional Statements'
excerpt: "This lesson describes the structure of conditional statements in Python and demonstrates how they are used for writing DRY code."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['conditional-statements']
permalink: /courses/earth-analytics-bootcamp/conditional-statements/intro-conditional-statements/
nav-title: "Intro to Conditional Statements"
dateCreated: 2019-08-11
modified: 2018-09-10
module-title: 'Intro to Writing Conditional Statements in Python'
module-nav-title: 'Conditional Statements'
module-description: 'This tutorial walks you through implementing another key strategy for writing DRY (i.e. Do Not Repeat Yourself) code in Python: conditional statements.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 8
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn about the structure of conditional statements in `Python` and how you can use them to write DRY code by only executing code when certain conditions have been met.  

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Describe the syntax for conditional statements in `Python`
* Explain how conditional statements can be used to write DRY code


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/loops/intro-dry-code/">Intro to DRY Code</a>. 

 </div>

## Conditional Statements

In the lesson introducing DRY code, you learned that conditional statements provide you with the ability to control when or how code is executed.  

This can be very useful for checking whether a certain condition exists before the code begins to execute, as you may want to only execute certain code lines when certain conditions are met.   

For example, conditional statements can be used to check that a certain variable or file exists before code is executed, or to execute more code if some criteria is met, such as a calculation resulting in a specific value. 

### Structure of Conditional Statements

The structure of a conditional statement is defined through the use of `if` and `else`. 

```python
if condition:
    print("condition is true")
else:
    print("condition not true")
```

When the condition following the `if` is met, then a certain code will execute. When that condition is not met, then the code following the `else` will execute.

Review these simple examples to see how the `if` and `else` are used to control which code lines are executed.

{:.input}
```python
# create a variable x with the value of 0
x = 0

# compare the value of x to 10 and print a message depending on the outcome of the comparison
if x < 10:
    print("x has a value of", x, "which is less than 10.")
    
else:
    print("x has a value of", x, "which is NOT less than 10.")    
```

{:.output}
    x has a value of 0 which is less than 10.



{:.input}
```python
# create a variable x with the value of 100
x = 100

# compare the value of x to 10 and print a message depending on the outcome of the comparison
if x < 10:
    print("x has a value of", x, "which is less than 10.")
    
else:
    print("x has a value of", x, "which is NOT less than 10.") 
```

{:.output}
    x has a value of 100 which is NOT less than 10.



You can also write conditional statements to identify keywords within a text string, such as the name of a variable. 

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
if "precip" in "avg_monthly_temp":
    print("This textstring contains the keyword: precip.")
    
else:
    print("This textstring does NOT contain the keyword: precip.")
```

{:.output}
    This textstring does NOT contain the keyword: precip.



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Test your `Python` skills to:

1. Write a conditional statement that will print a message depending on whether following condition is met: the value of `x` is equal to `35`. 
    * Set `x` equal to `25`, and print a message stating whether `x` is equal to `35`. 
    * Note that the comparison operator for `equal to` is `==`. 

2. How does the the comparison operator for `equal to` differ from using the `=` to assign values to variable names?


</div>


{:.output}
    x has a value of 25 which is NOT equal to 35.



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

Test your `Python` skills to:

1. Write a conditional statement that will add a value of `15` to a variable `x` if the following condition is met: the value of `x` is NOT equal to `35`. 
    * Set `x` equal to `25` and use the assignment operator (`+=`) to add `15` when `x` is not equal to `35`. 
    * Note that the comparison operator for `not equal to` is `!=`.
    * For both the `if` and `else`, print the final value of `x`.

</div>


{:.output}
    40


