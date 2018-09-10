---
layout: single
title: 'Write Custom Functions'
excerpt: "This lesson teaches you how to write custom functions in Python."
authors: ['Jenny Palomino', 'Leah Wasser', 'Software Carpentry']
category: [courses]
class-lesson: ['functions']
permalink: /courses/earth-analytics-bootcamp/functions/write-functions/
nav-title: "Write Custom Functions"
dateCreated: 2019-08-11
modified: 2018-09-10
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 10
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to write custom functions in Python.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain the structure of a function in Python
* Define an input parameter to a function
* Write custom functions in Python

</div>

## Write a Function in Python

{:.input}
```python
# this is an example function that adds the value of five to any input parameter
# x is the placeholder for the input parameter and will be assigned when the function is called

def add_five(x):
    
    # add the value of 5 to an input parameter
    # function can take a single value, single value variable, or numpy array as input
    # function can not take list or pandas dataframe as input
    
    return (x + 5)
```

There are several parts of a function in `Python`:

### Def Keyword

Functions begins with the keyword **`def`**: this keyword initiates the function definition. It is followed by the function name and input parameter in parenthesis `()`. 

Just like with loops and conditional statements, the colon `:` is used to indicate that the definition (i.e. code) of the function is below. Also, note that the code lines below are indented once, just like with loops and conditional statements. 

### Function Name

This is the name that you will use when you call the function (e.g. `add_five`). 

For example, `add_five(x)` is a function with the name `add_five`. You pass this function the parameter value for `x` within parenthesis `()`, and it adds the value `5` to `x` (i.e. the value that has been passed to the function). 

### Input Parameters

An input parameter is what you pass the function as the required information for the function to run. The function will take the value or variable provided as the input parameter and use it to perform some task. 

In the example above, `x` is actually a placeholder for the variable that will be acted upon in the function (i.e. the variable that will have the value of 5 added to it). 
    
Notice that `x` has not been explicitly defined outside of the function. It does not need to be because it will actually be defined by the user of the function when the function is called (e.g. `add_five(5)`). 

### Return Statement

This statement returns the value of the code executed in the function, using the syntax `return (output)`. 

If the function is as simple as the example above, the return statement also contains the code that is being executed in the function to determine the output value. However, you can write more lines of code before the return statement, and then return the final output.

### Documentation With Python Comments

Documentation is not required for the function to work. However, good documentation will save you time in the future when you need to use this code again, and it also helps others understand how they can use your function.

In the example above, the documentation has noted that the input parameter can be a single value variable or a `numpy array`, but it cannot be a list or `pandas dataframe`.


## Call a Function in Python

Below is an example call to this function. Again, notice that you do not have to create a variable `x` in order to give the function a parameter value. 

You can simply give the function a value `3` as the input parameter, and the function will add the value `5` and return the value `8`.

{:.input}
```python
# this is an example call to the add_five function using a single value
add_five(3)
```

{:.output}
{:.execute_result}



    8





Notice that you will get an error if you try to print the value of `x`.

Is `x` an explicit variable? What role does `x` play in the function?

{:.input}
```python
# uncomment line to run, as it will result in an error
#print(x)
```

Because the function is well documented, you know that you can also provide an existing `numpy array` as the input.

{:.input}
```python
# import necessary package
import numpy as np

# create numpy array that will be used as input parameter
arrayname = np.array([1.8, 0.68])

# this is an example call to the add_five function
add_five(arrayname)
```

{:.output}
{:.execute_result}



    array([6.8 , 5.68])





Notice the output that you receive when you call the original variable `arrayname`. 

Why have the original values not changed? Does the function actually assign new values to the input parameter?

{:.input}
```python
# print data in `arrayname`
arrayname
```

{:.output}
{:.execute_result}



    array([1.8 , 0.68])





**Why would the function `add_five` not be able to take lists or `pandas dataframes` as an input?** Look carefully at the code that the function executes. 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Write a function to convert an input parameter value from inches to millimeters. Recall that one inch is equal to 25.4 millimeters. 

    * See the example function `add_five()` that adds the value of 5 to the input parameter. 
    * Begin with the `def` keyword and a clear function name that tells the user what the function does.
    * Use a placeholder name for the input parameter that is also clear and tells the user what the function is expecting. 
    * Because your code is simple, your return statement can contain the code that calculates the output within parenthesis `()`, just like `add_five()`. 
    * Be sure to add documentation about the input and output parameters of the function.

2. Run your function on the value `1.8` (i.e. your input parameter).

</div>


{:.output}
{:.execute_result}



    45.72




