---
layout: single
title: 'Variables in Python'
excerpt: "Variables store data (i.e. information) that you want to re-use in your code (e.g. single value, path to a directory, filename). Learn how to write Python code to create and work with variables."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['python-fundamentals']
permalink: /courses/intro-to-earth-data-science/python-fundamentals/get-started-python/variables/
nav-title: "Python Variables"
dateCreated: 2019-07-01
modified: 2019-09-04
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/python-variables-lists/variables/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Explain how `Python` uses variables to store data.
* Write `Python` code to:
    * create variables that store single data values (e.g. numeric values, text strings). 
    * check the type of a variable (e.g. integer, string).  

</div>
 

## What are Variables in Python?

Within a programming workflow, variables store data (i.e. information) that you want to re-use in your code (e.g. single value, filename, path to a directory). 

In `Python`, variables can be created without explicitly defining the type of data that it will hold (e.g. integer, text string). 

You can easily create a variable in `Python` using the following syntax:

`variable_name = value`

This basic syntax is the same whether you are assigning a numeric value (e.g. `a = 3`) or a text value (e.g. `a = "word"` which uses `""` to indicate a text string value). This differs from many other programming languages that require the variable to be explicitly assigned a data type when it is created.

### Importance of Clear and Distinct Variable Names

Just like you want to use good naming conventions for directories on your computer, you also want to assign clear and short names to variables, avoiding spaces or complicated wording, but still specific enough that you know what it is. Underscores (e.g. `boulder_precip_in`) can be helpful to add more detail to the name (e.g. location, measurement, units) and still preserve code readibility. 

A key characteristic of variables is that once a variable is created within your code (e.g. `Jupyter Notebook` file), the value of that variable will remain the same throughout the code.

However, you can overwrite an existing variable if you create a new variable with the same name. 

While there are occassions in which you might want to overwrite an existing variable to assign a new value to it, you want to make sure that you give variables both clear and distinct names to avoid *accidentally* overwriting variable values.  


## Variables For Numeric Values

In `Python`, you can create variables to store integers (i.e. whole numbers such as 10) and floats (i.e. decimal values such as 10.5).  

For more advanced math applications, you can also use variables to work with <a href="https://docs.python.org/3/library/stdtypes.html#numeric-types-int-float-complex" target="_blank">complex numbers</a>. 

As described previously, you do not need to define which numeric type you want to use to create a variable. 

For example, you can create a variable containing an integer called `boulder_precip_in`, which contains the rounded up value for the average annual precipitation in inches (in) in Boulder, Colorado. 

{:.input}
```python
boulder_precip_in = 21

boulder_precip_in
```

{:.output}
{:.execute_result}



    21





You could also create a variable containing a float value to capture the data using decimal units. 

{:.input}
```python
boulder_precip_in = 20.68

boulder_precip_in
```

{:.output}
{:.execute_result}



    20.68





Notice that in these examples, `boulder_precip_in` was overwritten by the second variable definition because both definitions assigned the same name to the variable. 

## Variables for Text Strings

To create a variable containing a text string, you need to use quotations (`""`) around the value, so that `Python` knows it is a text string (e.g. `variable_name = "text"`). 

While in `Python` the single quote (`''`) and the double quote (`""`) are used interchangeably (see the official <a href=" https://docs.python.org/3/library/stdtypes.html#text-sequence-type-str" target="_blank">Python docs</a> for more examples), it is good to choose one option and use it consistently. This textbook uses the double quote (`""`) for identifying text strings. 

Using quotes, you can create variables that contain a single word or many words, including punctuation.

{:.input}
```python
city = "Boulder"

city
```

{:.output}
{:.execute_result}



    'Boulder'





{:.input}
```python
city = "Boulder, CO"

city
```

{:.output}
{:.execute_result}



    'Boulder, CO'





{:.input}
```python
city = "Boulder, CO is the home of the University of Colorado, Boulder campus."

city
```

{:.output}
{:.execute_result}



    'Boulder, CO is the home of the University of Colorado, Boulder campus.'





## Check Variable Type

After you create a variable, you can check the type using the following syntax:

`type(variable_name)`

For example, you can check the type of `boulder_precip_in` after each time that a variable is created with that name to see that the type changes from `int` to `float`. 

{:.input}
```python
boulder_precip_in = 21

type(boulder_precip_in)
```

{:.output}
{:.execute_result}



    int





{:.input}
```python
boulder_precip_in = 20.68

type(boulder_precip_in)
```

{:.output}
{:.execute_result}



    float





You can also check the type of the variable named `city`, which is always a string, regardless of how many words (or punctuation) it contains. 

{:.input}
```python
city = "Boulder"

type(city)
```

{:.output}
{:.execute_result}



    str





{:.input}
```python
city = "Boulder, CO is the home of the University of Colorado, Boulder campus."

type(city)
```

{:.output}
{:.execute_result}



    str





Checking the type for a variable can help you make sure that you understand what a variable contains and how it can be used. 

For example, you can actually create a string that contain numbers if you use the syntax for creating a string (e.g. `variable_name = "value"`).

Notice below that `city_precip` is still a string, even though it contains a number.

{:.input}
```python
city_precip = "20.68"

type(city_precip)
```

{:.output}
{:.execute_result}



    str





Thus, the value itself is not important for determining whether the variable is a string - the syntax does this. 

A good reminder that it is important to make sure that you are defining variables with the appropriate syntax to distinguish between numeric and string types. 
