---
layout: single
title: 'Variables in Python'
excerpt: "Variables store data (i.e. information) that you want to re-use in your code (e.g. single numeric value, path to a directory or file). Learn how to to create and work with variables in Python."
authors: ['Jenny Palomino', 'Leah Wasser', 'Nathan Korinek']
category: [courses]
class-lesson: ['get-started-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/get-started-using-python/variables/
nav-title: "Python Variables"
dateCreated: 2019-07-01
modified: 2020-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
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
  - "/courses/earth-analytics-python/use-time-series-data-in-python/objects-and-variables-in-python/"
  - "/courses/earth-analytics-python/use-time-series-data-in-python/work-with-data-types-python/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Explain how variables are used in **Python** to store information.
* Use **Python** code to create variables that store single data values including numbers and text strings. 
* Check the data type of a variable using **Python**

</div>

## What are Variables in Python?

A variable in programming is used to store information that you want to re-use in your code. Examples of things that you may wish to save in your code include:

* numeric values 
* filenames
* paths 
* or even larger datasets such as a remote sensing image or a terrain model

In **Python**, variables can be created without explicitly defining the type of data that it will hold (e.g. integer, text string). You can create a variable in **Python** using the following syntax:

`variable_name = value`

{:.input}
```python
# Try it out
my_variable = 5

my_variable
```

{:.output}
{:.execute_result}



    5





This syntax for creating variables is the same whether you are assigning a numeric 
or text value to a variable. For example, below you assign the variable name `a` 
the value of 3 which is a number:  

`a = 3`

Here is an example of assigning a text string value to the same variable named `a`. 

`a = "a word"`

Notice that strings (character values) use double quotes `""` to indicate a text 
string value. 


<i class="fa fa-star"></i> **Data Tip:** Some programming languages require a 
variable to be explicitly assigned a data type when it is created. You do not 
need to worry about this when using `Python`, however! 
{: .notice--success }


### Expressive Programming: Easy to Understand Variable Names Make Your Code Easier to Read

Just like you want to use 
<a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/best-practices-for-organizing-open-reproducible-science/"> 
expressive naming conventions (names that represent what is stored within 
the directory)</a> for directories on your computer, you also want to use 
short, clear names for your variables to make your code easier to read. To 
follow best practices for variable names, avoid the following:

* spaces in your variable names
* complicated wording
* long variable names
* words that do not represent what the variable contains (example: `my_variable` vs `precip_data`)

When naming a variable, you want to keep the name short but specific enough 
that someone reading your code can understand what it contains. It is good 
practice to use underscores (e.g. `boulder_precip_in`) to create multi-word 
variable names that provide specifics regarding the variable's content. The 
underscore makes the variable name easier to read and follows **Python** 
<a href="https://www.python.org/dev/peps/pep-0008/#naming-conventions" target="_blank">PEP 8 best practices for code readability</a>. 


<i class="fa fa-star"></i> **Data Tip:** Read more about expressive variable 
names and clean code <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/write-efficient-python-code/intro-to-clean-code/expressive-variable-names-make-code-easier-to-read/">
in this earth data science lesson.</a> 
{: .notice-success } 


### Variables Are Available In Your Coding Environment Once Defined 

A key characteristic of variables is that once you create a variable in your 
coding environment (that is to say you run the actual line of code that defines 
the variable), it is available throughout your code. So for example, if you 
create a variable at the top of a Jupyter Notebook, the value associated with 
that variable will remain the same and can be reused in cells lower down in the 
notebook.

<i class="fa fa-star"></i> **Data Tip:** You can overwrite an existing variable 
if you create a new variable with the same name. For example, if you assign 
`a = 5` in one cell and then assign `a = "dog"` in the next cell, the final value 
of `a` will be `"dog"`.
{: .notice--success }

While there are occasions in which you might want to overwrite an existing variable 
to assign a new value to it, you want to make sure that you give variables both 
clear and distinct names to avoid *accidentally* overwriting variable values.   

{:.input}
```python
# Here you assign the variable name temperature the value 55 (a number)
temperature = 55

temperature
```

{:.output}
{:.execute_result}



    55





{:.input}
```python
# Note that you can easily reassign a variable name 
# to contain a new value (a string / word in this case)
temperature = "doctor"

temperature
```

{:.output}
{:.execute_result}



    'doctor'





## About Data Types in Python

**Python** data types are important to understand when coding. Below you will learn 
more about the different types of variables that you can store including:

* Numbers (integers and floats)
* Strings (letters / characters and words)

## Numeric Variables in Python

In **Python**, you can create variables to store numeric values such as integers 
(`int`) which represent whole numbers and floating point numbers which represent 
decimal values (`float`).  

<i class="fa fa-star"></i> **Data Tip:** For more advanced math applications, you can also 
use variables to work with <a href="https://docs.python.org/3/library/stdtypes.html#numeric-types-int-float-complex" target="_blank">complex numbers (see Python documentation for more details)</a>.
{: .notice--success}

As described previously, you do not need to define which numeric type you want to 
use to create a variable. For example, you can create a `int` variable called 
`boulder_precip_in`, which contains the value for the 
[average annual precipitation in inches (in) in Boulder, Colorado](https://psl.noaa.gov/boulder/Boulder.mm.precip.html), rounded to the nearest integer.

{:.input}
```python
# This is a comment line in Python
boulder_precip_integer = 20

# You can see the value of any variable by calling the variable name
boulder_precip_integer
```

{:.output}
{:.execute_result}



    20





You can use the `type()` function to figure out the type of data stored in a 
variable.

{:.input}
```python
# What is the type of data stored in boulder_precip_in
type(boulder_precip_integer)
```

{:.output}
{:.execute_result}



    int





If your data has decimal places associated with it, it will be stored in Python 
as a type: `float`. 

{:.input}
```python
boulder_precip_float = 20.23

boulder_precip_float
```

{:.output}
{:.execute_result}



    20.23





{:.input}
```python
type(boulder_precip_float)
```

{:.output}
{:.execute_result}



    float





## How to Store Text Variables: Strings in Python

To create a variable containing a text string (`str`), you use quotation marks 
(`""`) around the value. For example: 

`variable_name = "text"`

While in **Python** the single quote (`''`) and the double quote (`""`) are 
used interchangeably (see the official <a href="https://docs.python.org/3/library/stdtypes.html#text-sequence-type-str" target="_blank">Python Docs</a> for more examples), we suggest 
that you use double quotes `""` to define strings (type == `str`) following 
`PEP8` code style for Python best practices. Using quotes, you can create `str` 
variables that contain a single word or many words, including punctuation. 
Below are some examples of creating a string. 

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
city_state = "Boulder, CO"

city_state
```

{:.output}
{:.execute_result}



    'Boulder, CO'





{:.input}
```python
city_description = "Boulder, CO is the home of the University of Colorado, Boulder campus."

city_description
```

{:.output}
{:.execute_result}



    'Boulder, CO is the home of the University of Colorado, Boulder campus.'





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Interactive Activity - What Does Float() Do?

Run the code in the cell below. What does the `float()` function do to the 
value stored in the variable named `a`?

</div>

{:.input}
```python
# Run the code below - what does the float() function do? 
a = 75
b = float(a)
print(a, b)

# What data type is variable b? (hint: use the type() function to find out)
```

{:.output}
    75 75.0




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Interactive Activity  - Create Some Variables

It's time for you to create some variables of your own! Create the following: 

1. a variable called `precip_float` that stores a float value. 
2. a variable called `precip_int` that stores an integer value.
3. a variable called `location` that stores the string for the location: `New York City`.

For these variables, use the [average annual precipitation in New York City](https://www.usclimatedata.com/climate/new-york/new-york/united-states/usny0996), which is 46.23 inches. 

HINT: you can coerce a floating point value to an integer using the `int()` function. Use int() to convert your floating point value to an integer. The variable name should be precip_int. 

Try the code below to see how this works:

```
a = 75.643
b = int(a)
print(a, b)
```

</div>


## Check Variable Type

In the activities above, you used the `type()` function to determine what 
type of data are stored in a variable. 

`type(variable_name)`

For example, you can check the type of `boulder_precip_in` after each time 
that a variable is created with that same name to see that the type changes 
from `int` to `float`. 

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





You can also check the type of the variable named `city`, which is a string (`str`) regardless of how many words (or punctuation) it contains. 

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





Checking the type for a variable can help you make sure that you understand what a variable contains and how it can be used. For example, you can actually create a `str` variable that contain numbers if you use the syntax for creating a `str` variable (e.g. `variable_name = "value"`). Notice below that `city_precip` is still a `str`, even though it contains a number.

{:.input}
```python
city_precip = "20.68"

type(city_precip)
```

{:.output}
{:.execute_result}



    str





If you wanted to perform math on that variable, it would not work the way you think it should. 

{:.input}
```python
# Multiply city_precip by 2
city_precip * 2
```

{:.output}
{:.execute_result}



    '20.6820.68'





Thus, the value itself is not important for determining whether the variable is a numeric or string type - the syntax does this. 

A good reminder that it is important to make sure that you are defining variables with the appropriate syntax to distinguish between numeric and string types. 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge - Data Types & Math

Run the following code which divides variable `a` by variable `b` (`a/b`). 

```
a = 5
b = 3
c = a/b
```

Use the `type()` function to determine what type of value is stored in each variable defined (`a`, `b`, and `c`).

</div>

