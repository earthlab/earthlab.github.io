---
layout: single
title: 'Intro to Loops in Python'
excerpt: "Loops .  Learn ."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-numpy-arrays']
permalink: /courses/intro-to-earth-data-science/dry-code-python/loops/
nav-title: "Intro to Loops"
dateCreated: 2019-10-23
modified: 2019-10-23
module-title: 'Introduction to Loops in Python'
module-nav-title: 'Loops'
module-description: 'Loops .  Learn .'
module-type: 'class'
chapter: 18
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
  - "/courses/earth-analytics-bootcamp/loops/intro-loops/"
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Eighteen - Loops

In this chapter, you will learn about the structure of `Python` loops and how you can use them to iteratively execute code. 

After completing this chapter, you will be able to:

* Describe the syntax for two looping structures used in `Python`: `while` and `for`
* Explain how repeated lines of code that could be replaced with loops (i.e. iteratively execute code)
 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have Conda setup on your computer and the Earth Analytics Python Conda environment. Follow the <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Set up Git, Bash, and Conda on your computer</a> to install these tools.

Be sure that you have completed the chapters on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>, <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">Numpy Arrays</a>, and <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/">Pandas Dataframes</a>.

</div>


## Looping Structures

A loop is a sequence of operations that are performed over and over in some specified order. 

Loops can help you to eliminate repetition in code by replacing duplicate lines of code with an iteration, meaning that you can iteratively execute the same code line or block until it reaches a specified end point.

For example, the following lines could be replaced by a loop that iterates over a list of variable names and executes the `print()` function until it reaches the end of the list:

```python
print(avg_monthly_precip)
print(months)
print(precip_2002_2013)
```

You can create lists of variables, filenames, or other objects like data structures upon which you want to execute the same code. These lists can then be used as variables in loops. 

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






