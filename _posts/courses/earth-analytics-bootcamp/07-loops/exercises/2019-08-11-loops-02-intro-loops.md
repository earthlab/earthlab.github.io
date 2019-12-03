---
layout: single
title: 'Intro to Loops'
excerpt: "This lesson describes the structure of loops in Python and how they are used to iteratively execute code."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['loops']
permalink: /courses/earth-analytics-bootcamp/loops/intro-loops/
nav-title: "Intro to Loops"
dateCreated: 2019-08-11
modified: 2018-08-13
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn about the structure of `Python` loops and how you can use them to iteratively execute code. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Describe the syntax for two looping structures used in `Python`: `while` and `for`
* Explain how repeated lines of code that could be replaced with loops (i.e. iteratively execute code)
 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/">Python Variables and Lists</a> and the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/loops/intro-dry-code/">Intro to DRY Code</a>. 

 </div>


## Comparison and Assignment Operators

In previous lessons, you used arithmetic operators such as `+` to add values, but there are many other operators in `Python` that allow you to work with values.   

In this lesson, you will work with comparison operators, which allow you to compare values such as checking whether one value is greater than another (e.g. `>`). 

With comparison operators, you can compare whether a value or variable is:

* `>` greater than 
* `>=` greater than or equal to
* `<` less than
* `<=` less than or equal to
* `==` equal to
* `=!` not equal to 

another value or variable that follows the operator. 

You will also work with assignment operators (e.g. `+=`), which allow you to set a variable to a new value based on an arithmetic operation or some other calculation. 

At this point in the course, you have already used assignment operators to add items to `Python` lists, such as when you added a new item for December to a list containing month names (e.g. `months += ["Dec"]`).


## Looping Structures

In `Python`, there are two primary structures for loops: `while` and `for`. You will learn about both in this lesson.

### While Loop

A `while` loop is used to iteratively execute code until a certain condition is met. That condition could be that the results of the code reach a certain value (e.g. code will iteratively execute as long as the current value of the results is less than 5). 

For `while` loops, comparison and assignment operators are both very useful. 

For example, you can write a loop to iteratively add a value of `1` to a variable `x` using `x += 1`, as long as the current value of `x` does not exceed a specified value.

{:.input}
```python
# create a variable `x` with the value `0`
x = 0

# as long as the value of `x` is less than `10`
# iteratively print the value of x and then add `1` to the current value of `x`
while x < 10:
    print(x)
    x += 1
```

{:.output}
    0
    1
    2
    3
    4
    5
    6
    7
    8
    9



Note the structure of the `while` loop:

1. First, you indicate the condition after the word `while` 
2. Then, you finish the condition with a colon `:`
3. Last, you indent the code lines that are included in the `while` loop. **This indentation is important** in `Python` as it indicates that the indented code is to be executed as part of the loop, not after the loop.

In this example, a comparison operator is used to compare the value of variable `x` (which begins with value of `0`) to the value `10`, the designated end point.

Within the loop, the value of `x` is printed first, before the assignment operator is used to add a value of `1` to `x`. This process repeats each time that the code iterates, until the current value of `x` is no longer less than `10`.

At that point, the condition is no longer true (as `x` is now equal to `10`), so the loop ends. 

Note that to access the value of the variable `x`, you must use the correct variable name in the loop (e.g. `x`).

Also, note that the code in the loop is executed in order, meaning that the `print()` function executes first before the value of `1` is added to `x`. You can change that order if you want to see the value of `x`, after the value of `1` has been added. 

{:.input}
```python
# create a variable `x` with the value `0`
x = 0

# as long as the value of `x` is less than `10`
# iteratively print the value of x and then add `1` to the current value of `x`
while x < 10:
    x += 1
    print(x)
```

{:.output}
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10



Compare the previous `while` loop to the code that you would have to write to accomplish the same task without a loop. Which would you rather do?

{:.input}
```python
x = 0

x += 1
print(x)

x += 1
print(x)

x += 1
print(x)

x += 1
print(x)

x += 1
print(x)

x += 1
print(x)

x += 1
print(x)

x += 1
print(x)

x += 1
print(x)

x += 1
print(x)
```

{:.output}
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10



In addition to using comparison operators to compare values, you can also specify a range of values to limit the duration of the `while` loop. The range is inclusive of the starting value, but not of the ending value. 

{:.input}
```python
# create a variable `x` with the value `1`
x = 1

# as long as the value of `x` within a range of `1` to `4`, as the range is not inclusive of `5`
# iteratively print the value of x and then add `1` to the current value of `x`
while x in range(1,5):
    print(x)
    x += 1
```

{:.output}
    1
    2
    3
    4



Note that the structure of the `while` loop remains the same, regarding the use of a condition, colon, and indentations of the code that will be iterated. 

In this example, rather than using an explicit comparison operator, you are stating that the code below can continue to execute as long as the value of `x` remains in a certain range.

Specifically, you state that the code can execute as long as the value of `x` exists within a numeric range that begins at `1` to and ends with `5`, but is not inclusive of `5`. This explains why the code does not print the value of `x` when it reaches `5`.  

### For Loop

Another useful looping structure is a `for` loop, which will iteratively execute code for each value in a group that is provided as an input parameter. This group can be a list of values or filenames, individual characters in a text string, etc.

The syntax of a `for` loop is quite similar to `while` loop, regarding the use of a condition, colon, and indentations of the code that will be iterated. 

The main differences are that the loop begins with `for` rather than `while`, and that the `for` loop is expecting to execute for each item in a list. Therefore, the list should be defined before (or as part of) the `for` loop. 

{:.input}
```python
# create a list of integers `numlist`
numlist = [5, 10, 15, 20]

# for each item in `numlist`, print the item's value
for x in numlist:
    print(x)    
```

Note that in this example, `x` is not a variable but rather a placeholder for the current value that the loop is working with in each iteration of the code.  

This means that you could use any word or character to indicate the placeholder, with the exception of numeric values. 

You simply need to reuse that same word or character in the code lines that are being executed, in order to access the value at that placeholder. 

For example, the placeholder could be called `i`, or even something completely unrelated like `banana`. 

{:.input}
```python
# create a list of integers `numlist`
numlist = [5, 10, 15, 20]

# for each item in `numlist`, print the item's value
for i in numlist:
    print(i)    
```

{:.input}
```python
# create a list of integers `numlist`
numlist = [5, 10, 15, 20]

# for each item in `numlist`, print the item's value
for banana in numlist:
    print(banana)   
```

`numlist` is a variable (in this case, a `Python` list), and you must use its variable name to access the items in the list. 

However, the list does not have to be numeric, as you may often want to use lists that contain text strings to iterate on directory and file names. For example, you may want to iterate code on a list of specific filenames. 

{:.input}
```python
# create a list of text strings of filenames
filelist = ["months.txt", "avg-monthly-precip.txt"]

# for each item in `filelist`, print the item's value
for filename in filelist:
    print(filename)   
```

Note that `print()` returns the name of the file, but not the values in the file. The function that you use in the loop will determine what output you will receive. 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Review the code blocks below carefully and determine why you do not receive an output when you execute it. 

2. Fix the code block so that it runs. 

```python
x = 3

while x < 15:
    print(i)
    x += 1
```


```python
fruit = ["apples", "oranges", "cherries"]

for i in fruit:
    print(oranges) 
```

</div>
