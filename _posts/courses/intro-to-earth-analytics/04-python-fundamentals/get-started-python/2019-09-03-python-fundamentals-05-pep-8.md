---
layout: single
title: 'Introduction to PEP 8 Style Guide'
excerpt: "PEP 8 is the style guide that is widely used within the Python community to promote code readibility, including standardization of naming conventions, use of white space, and layout of code. Learn more about the PEP 8 conventions and recommendations for writing readable Python code."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['python-fundamentals']
permalink: /courses/intro-to-earth-data-science/python-fundamentals/get-started-python/pep-8-style-guide/
nav-title: "PEP 8 Style Guide"
dateCreated: 2019-09-03
modified: 2019-09-03
module-type: 'class'
class-order: 1
course: "intro-to-earth-data-science"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/pep-8-style-guide/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Explain what the PEP 8 style guide is and how it helps promote code readibility.
* Describe key components of the PEP 8 style guide including naming conventions and white space.
* List tools that can help you apply the PEP 8 style guide to your code.  

</div>
 

## About PEP 8 

PEP 8 is the style guide that is widely used within the Python community to promote code readibility, including standardization of naming conventions, use of white space (e.g. tabs, extra lines), and layout of code

`Python` is developed and maintained by an open source community, and thus, it is not really possible to enforce the standard in mandatory way. Rather, community members choose to adhere to PEP 8 recommendations whenever possible, so that they can contribute code that can easily be read and used by the greater community of users. 

PEP 8 covers many aspects of code readibility including:
* naming conventions
* use of comments
* line lengths
* use of white space


## PEP 8 Naming Conventions

The text in this section is summarized from the <a href="https://www.python.org/dev/peps/pep-0008/#naming-conventions" target="_blank">PEP8 Style Guide published by the Python Software Foundation</a>.


### Descriptive Naming Styles

There are a lot of different naming styles. It helps to be able to recognize what naming style is being used, independently from what they are used for.

The following naming styles are commonly distinguished:

* b (single lowercase letter)

* B (single uppercase letter)

* lowercase

* lower_case_with_underscores

* UPPERCASE

* UPPER_CASE_WITH_UNDERSCORES

* CapitalizedWords (or CapWords, or CamelCase -- so named because of the bumpy look of its letters. This is also sometimes known as StudlyCaps.

    * Note: When using acronyms in CapWords, capitalize all the letters of the acronym. Thus HTTPServerError is better than HttpServerError.

* mixedCase (differs from CapitalizedWords by initial lowercase character!)

* Capitalized_Words_With_Underscores (ugly!)


### Names to Avoid

Never use the characters 'l' (lowercase letter el), 'O' (uppercase letter oh), or 'I' (uppercase letter eye) as single character variable names.

In some fonts, these characters are indistinguishable from the numerals one and zero. When tempted to use 'l', use 'L' instead.


## Comments

###  Single line comments (`#`)

* Some ideas to add:
    * No space after comment and first line of code
    * Capitalization of First Word


###  Multi-line comments (docstrings)

* Some ideas to add:
    * Format
    * Example


## Line Length

* Some ideas to add:
    * Code line recommended length 
    * Comment line recommended length 


## White Space

* Some ideas to add:
    * add blank line before a single line comment (unless it is the first line of a cell in Jupyter Notebook)
    * add blank line after a set of related code



## Earth Lab Recommendations for Naming Conventions

### Directory and File Names

This textbook uses the naming conventions of `lower-case-with-dashes`for directory and file names, in order to easily distinguish them from variable names. 

Both directory and file names should be kept as short and concise as possible, while also clearly indicating what is contained within the directory or file.

Examples include:
* 
* 


### Variables

For variables, this textbook uses the naming conventions of `lowercase` for short variable names and `lower_case_with_underscores` for longer and more descriptive variable names, as needed.

Variable names should be kept as short and concise as possible, while also clearly indicating the kind of data contained in the variable. 

Examples include:
* precip: to indicate a simple variable (either single value or data structure without temporal or spatial variation in coverage)
* boulder_precip: to indicate the location of the data collection
* max_precip: to indicate the result of a summary statistic
* precip_2002: to indicate a particular year of data included
* precip_2002_2013: to indicate the particular years of data included
* precip_2000_to_2010: to indicate a range of years of data included
* precip_in or precip_mm: to indicate the measurement units

The variable names should be driven by the overall goals and purpose of the code in which they are being used. 

For example, in some cases, it may be more important to distinguish the units of measurement, the location, or the year or range of years covered by the data. Use your best judgment and modify variable names as needed.  

### Functions

For functions, this textbook uses of the naming conventions of `mixedCase` to differentiate function names from variable names, or `lower_case_with_underscores` when longer and more descriptive function names are needed. 

Again, function names should be kept as short and concise as possible, while also clearly indicating the kind of data contained in the variable.

Examples include:
* 
* 



## Tools For Applying PEP 8 To Your Code

> *Conforming your Python code to PEP 8 is generally a good idea and helps make code more consistent when working on projects with other developers. The PEP 8 guidelines are explicit enough that they can be programmatically checked* (from the <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>). 

There are a few packages developed by the `Python` community that can help you check that your code is adhering to PEP 8 standards:

* <a href="https://pep8.readthedocs.io/en/release-1.7.x/" target="_blank">pep8</a>, a `Python` package that can help you check your code for adherence to the PEP 8 style guide. 
* <a href="https://github.com/hhatto/autopep8" target="_blank">autopep8</a>, another `Python` package that can be used to modify files to the PEP 8 style guide.

`Python` community members expect that your code will adhere to the PEP 8 standard, and if it does not, they generally will not be shy to tell you that your code is not "Pythonic"! 

<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank">The PEP 8 Style Guide</a>

* <a href="https://realpython.com/python-pep8/" target="_blank">How To Write Beautiful Python Code with PEP 8</a>

* <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>
    
</div>
