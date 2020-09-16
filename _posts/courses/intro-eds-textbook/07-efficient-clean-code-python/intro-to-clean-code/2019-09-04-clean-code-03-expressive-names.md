---
layout: single
title: 'Make Your Code Easier to Read By Using Expressive Variable Names in Python'
excerpt: "Expressive variable names refer to function and variable names that describe what the variable contains or what the function does. Using expressive names makes your code easier to understand. Learn how to create expressive names for objects in your Python code."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['clean-expressive-code-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/intro-to-clean-code/expressive-variable-names-make-code-easier-to-read/
nav-title: "Expressive Code"
dateCreated: 2019-09-03
modified: 2020-09-16
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Learn how using expressive names can help you to write code that is clean and readable.
* Create expressive names for objects in your **Python** code.
* Describe the PEP 8 recommendations for Python object names. 

</div>


## Why Use Expressive Names? 

In chapter one on open reproducible science, you learned about <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/best-practices-for-organizing-open-reproducible-science/">best practices for organizing open reproducible science projects</a>, including how to create directories and files with names that are both expressive and machine readable. As a refresher, expressive names are ones that describe the contents of the object itself. So for example you probably expect a directory called `data` to contain data within it. 

<figure>
 <a href="{{ site.url }}/images/earth-analytics/clean-code/expressive-file-names-make-science-projects-easier-to-work-with.png">
 <img src="{{ site.url }}/images/earth-analytics/clean-code/expressive-file-names-make-science-projects-easier-to-work-with.png" alt= "File and directory names that clearly indicate the type of information stored within that file or directory are the most useful or expressive to your colleagues or your future self as they allow you to quickly understand the structure and contents of a project directory. Source: Jenny Bryan, Reproducible Science Curriculum." ></a>
 <figcaption> Compare the list of file names on the LEFT to those on the right - which ones are easier to quickly understand? File and directory names that clearly indicate the type of information stored within that file or directory are the most useful or expressive to your colleagues or your future self as they allow you to quickly understand the structure and contents of a project directory. Source: Jenny Bryan, Reproducible Science Curriculum.
 </figcaption>
</figure>

Expressive code is also important for naming variables and functions in your **Python** code because it will make your code easier to understand for someone who is skimming it in the same way that it makes it easier for someone to understand a file directory structure. 

Expressive code is another part of clean coding - that is writing code that is easier for you, your future self and for someone else to look at and understand. After you've been programming for a while, you will begin to see that consistently formatted code is much easier for your eye to scan and quickly understand.


<figure>
 <a href="{{ site.url }}/images/earth-analytics/clean-code/clean-code-expressive-variable-names-basmati-rice.png">
 <img src="{{ site.url }}/images/earth-analytics/clean-code/clean-code-expressive-variable-names-basmati-rice.png" alt= "This container clearly contains cookies and yet it's labeled as rice. You can imagine that this might be confusing to someone who is looking for rice in your kitchen! Consider this when writing code. It's easier for someone to understand your code without running it when your code variables describe the objects that they contain.  Source: Jenny Bryan, Reproducible Science Curriculum." ></a>
 <figcaption> This container clearly contains cookies and yet it's labeled as rice. You can imagine that this might be confusing to someone who is looking for rice in your kitchen! Consider this when writing code. It's easier for someone to understand your code without running it when your code variables describe the objects that they contain. Source: Jenny Bryan, Reproducible Science Curriculum.
 </figcaption>
</figure>


<i class="fa fa-star"></i> **Data Tip:** The <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank">the PEP 8 Style Guide</a> suggests that all objects (variables, functions and methods) in your code are named using meaningful words. 
{: .notice--success}


## Best Practices For Naming Objects

PEP 8 style guide has a suite of recommendations that focus on making Python code more readable. Below are some of the PEP 8 guidelines related to expressive object names.  

1. **Keep object names short:** this makes them easier to read when scanning through code.

2. **Use meaningful names:** A meaningful or expressive variable name will be  eaiser for someone to understand. For example: `precip` is a more useful name that tells us something about the object compared to `x` or `a`.

3. **Do not start names with numbers** Objects that start with a number are NOT VALID in **Python**.

4. **Avoid names that are existing functions in Python:** e.g., `if`, `else`, `for`, see <a href="https://www.programiz.com/python-programming/keywords-identifier" target="_blank">here</a> for more reserved names.

A few other notes about object names in **Python**:

* **Python** is case sensitive (e.g., `weight_kg` is different from `Weight_kg`).
* Avoid existing function names (e.g. `mean`), though you can combine these with other words to create a more descriptive name (e.g. `precip_mean`).
* Use nouns for variable names (e.g. `weight_kg`), and verbs for function names (e.g. `convert_kg_lb`).
* Avoid using dots in object names - e.g. `precip.boulder` - dots have a special meaning in **Python** (for methods - the dot indicates a function that is connected to a particular **Python** object) and other programming languages. 
    * Instead, use underscores `precip_boulder`.


## Recommendations For Naming Conventions 

### Best Practices for Directory and File Names

We suggest that you use directory and file names that contain words that describe the contents of the file or directory, separated using dashes - like this:

`lower-case-with-dashes`

Directory and files names should be kept as short and concise as possible, while also clearly indicating what is contained within the directory or file. 

For a review of how to create directories and files with names that are both expressive and machine readable, revisit <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/best-practices-for-organizing-open-reproducible-science/">best practices for organizing open reproducible science projects</a>.

### Best Practices Variable Names In Python

For variables, we suggest that you use `lowercase` for short variable names and `lower_case_with_underscores` for longer and more descriptive variable names. Variable names should be kept as short and concise as possible, while also clearly indicating the kind of data or information contained in the variable. 

Examples include:
* **precip**: to indicate a simple variable (either single value or data structure without temporal or spatial variation in coverage)
* **boulder_precip**: to indicate the location of the data collection
* **max_precip**: to indicate the result of a summary statistic
* **precip_2002**: to indicate a particular year of data included
* **precip_2002_2013**: to indicate the particular years of data included
* **precip_2000_to_2010**: to indicate a range of years of data included
* **precip_in** or **precip_mm**: to indicate the measurement units

The variable names should be driven by the overall goals and purpose of the code in which they are being used. 

For example, in some cases, it may be more important to distinguish the units of measurement, the location, or the year or range of years covered by the data. Use your best judgment and modify variable names as needed.  


### Best Practices for Naming Functions and Methods in Python

Following PEP 8 guidelines, function names should be formatted using  
`words_separated_by_underscores`. The words that you use to name your function should clearly describe the function's intent (what the function does). Ideally this name is a very specific name that describes what the function does. For example, if you write a function that removes hyphens from some text a name like `remove_hyphens` might be appropriate.  

```python
## This function name is less expressive 
text_edit()

# This function name is more expressive
remove_hyphens()
```

## Example Function 

The function below is designed to convert a temperature provided 
in a numeric format in degrees fahrenheit to kelvin. 

```python

def fahr_to_kelvin(fahr):
    """Convert temperature in Fahrenheit to kelvin.
    
    Parameters:
    -----------
    fahr: int or float
        The tempature in Fahrenheit.
    
    Returns:
    -----------
    kelvin : int or float
        The temperature in kelvin.
    """
    kelvin = ((fahr - 32) * (5 / 9)) + 273.15
    return kelvin

```

Consider the list of function names below for the above function, which of these names are the most expressive and why?

```python
f()
my_func()
t_funk()
f2k()
convert_temperature()
fahr_to_kelvin()
```

<i class="fa fa-star"></i> **Data Tip:** While this book does not go into great depth on creating classes, PEP 8 suggests that class names should use `mixedCase`.
{: .notice--success}


