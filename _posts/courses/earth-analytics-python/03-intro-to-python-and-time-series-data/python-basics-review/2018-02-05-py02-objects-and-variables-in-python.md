---
layout: single
title: "Objects and variables in Python"
excerpt: "This tutorial introduces the Python programming language. It is
designed for someone who has not used Python before. You will work with precipitation and
stream discharge data for Boulder County."
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey', 'Data Carpentry']
category: [courses]
class-lesson: ['get-to-know-python']
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/objects-and-variables-in-python/
nav-title: 'Objects in Python'
dateCreated: 2017-05-23
modified: 2018-10-08
course: "earth-analytics-python"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Be able to create, modify and use objects or variables in `Python`.
* Be able to define the key differences between the str (string) and num (number) classes in `Python` in terms of how `python` can or can not perform calculations with each.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>


## Creating objects

You can get output from `Python` by typing a mathematical equation into the console -
For example, if you type in `3 + 5`, `Python` will calculate the output value.

{:.input}
```python
# add 3 + 5
3 + 5
```

{:.output}
{:.execute_result}



    8





{:.input}
```python
# divide 12 by 7
12 / 7
```

{:.output}
{:.execute_result}



    1.7142857142857142





However, is it more useful to assign _values_ to _objects_. To create an object, you need to give it a name followed by the assignment operator `=`, and the value you want to give it:

{:.input}
```python
# assign weight_kg to the value of 55
weight_kg = 55

# view object value
weight_kg
```

{:.output}
{:.execute_result}



    55





## Expressive readable object names

You can name our objects in python anything that you  want. For example: `x`, `current_temperature`, or
`subject_id`. However, it is best to use clear, descriptive words when naming
objects to ensure your code is easy to follow. Using a naming convention that explains to someone reading the code what the object is or in the case of a function, what it does, is often referenced as as element of Expressive Programming.  

You wil learn best practicing for coding a bit later - in the [clean coding
lesson](/courses/earth-analytics-python/use-time-series-data-in-python/write-clean-code-with-python/). For now, here are some tips to improve your code:

1. **Keep object names short:** this makes them easier to read when scanning through code.
2. **Use meaningful / expressive names that describe the contents of the object that you are creating:** For example: `precip` is a more useful name that tells us something about the object compared to `x`
3. **Don't start names with numbers!** Objects that start with a number are NOT VALID in `Python`.
4. **Avoid names that are existing functions in `Python`:** e.g.,
`if`, `else`, `for`, see
[here](https://www.programiz.com/python-programming/keyword-list)

A few other notes about object names in `Python`:

* `Python` is case sensitive (e.g., `weight_kg` is different from `Weight_kg`).
* Avoid other function names (e.g., `c`, `T`, `mean`, `data`, `df`, `weights`).
* Use nouns for variable names, and verbs for function names.
* Avoid using dots in object names - e.g. `my.dataset` - dots have a special meaning in `Python` (for methods) and other programming languages. Instead use underscores `my_dataset`.

## View object value
When assigning a value to an object, `Python` does not print anything. You can force
it to print the value by using parentheses or by typing the name:

{:.input}
```python
# here weight_kg is assigned to the value 55 however nothing is printed
weight_kg=55  
# a variable name at the end of a cell will be printed by Jupyter notebook
weight_kg 
```

{:.output}
{:.execute_result}



    55





{:.input}
```python
# python is case sensitive
Weight_kg
```

{:.output}

    ---------------------------------------------------------------------------

    NameError                                 Traceback (most recent call last)

    <ipython-input-2-b8c9261fc186> in <module>()
    ----> 1 Weight_kg
    

    NameError: name 'Weight_kg' is not defined



Now that `Python` has stored `weight_kg` in memory, you can do arithmetic with it. For
instance, you may want to convert this weight in pounds (weight in pounds is 2.2
times the weight in kg):

{:.input}
```python
2.2 * weight_kg
```

{:.output}
{:.execute_result}



    121.00000000000001





You can also change a variable's value by assigning it a new value:

{:.input}
```python
weight_kg=57.6
2.2 * weight_kg
```

{:.output}
{:.execute_result}



    126.72000000000001





Assigning a value to one variable does not change the values of
other variables. For example, let's store the animal's weight in pounds in a new
variable, `weight_lb`:

{:.input}
```python
weight_lb = 2.2 * weight_kg
```



and then change `weight_kg` to 100.




{:.input}
```python
weight_kg=100
```

What do you think is the current content of the object `weight_lb`? 126.5 or 200?

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge activity

What are the values of each object defined in EACH LINE OF code below?

```python
mass = 47.5            # mass?
age  = 122             # age?
mass = mass * 2.0      # mass?
age  = age - 20        # age?
mass_index = mass / age  # mass_index?
```

Check your answers by running the code in python!
</div>

<!-- Answers to go here... -->

