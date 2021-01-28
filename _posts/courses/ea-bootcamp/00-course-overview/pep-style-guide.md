---
layout: single
title: 'GEOG 4463 & 5463 - Earth Analytics Bootcamp: Reference on PEP 8 Style Guide'
authors: ['Jenny Palomino']
category: courses
excerpt:
nav-title: Reference on PEP 8 Style Guide
modified: 2021-01-28
comments: no
permalink: /courses/earth-analytics-bootcamp/pep-8-style-guide/
author_profile: no
overview-order: 8
module-type: 'overview'
course: "earth-analytics-bootcamp"
sidebar:
  nav:
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> About PEP 8 

PEP 8 is the style guide that is most promoted within the `Python` community for standardization of naming conventions, use of whitespace (i.e. tabs, spaces), and layout of code. 

`Python` is developed and maintained by an open source community, and thus, it is not really possible to enforce the standard in mandatory way. Rather, community members choose to adhere to PEP 8 recommendations whenever possible, so that they can contribute code that can easily be read and used by the greater community of users. 

</div>


## Resources For Implementation

"Conforming your Python code to PEP 8 is generally a good idea and helps make code more consistent when working on projects with other developers. The PEP 8 guidelines are explicit enough that they can be programmatically checked" (from the <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>). 

There are a few packages developed by the `Python` community that can help you check that your code is adhering to PEP 8 standards:

* the `pep8` package, which can check your code for adherence to the PEP 8 style guide

* the `autopep8` package, which can be used to modify script files (.py) to the PEP 8 style guide

`Python` community members expect that your code will adhere to the PEP 8 standard, and if it does not, they generally will not be shy to tell you that your code is not "Pythonic"! 

While PEP 8 covers more than naming conventions, this page currently focuses on naming conventions and will continue to be developed by Earth Lab to include more information on other portions of the PEP 8 style guide. 


## PEP 8 Naming Conventions

The text in this section is quoted directly from the <a href="https://www.python.org/dev/peps/pep-0008/#naming-conventions" target="_blank">PEP8 Style Guide published by the Python Software Foundation</a>.


### Descriptive: Naming Styles

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


## Earth Lab Recommendations for Naming Conventions

### Directory and File Names

For courses in the Earth Analytics program, we use the naming conventions of lower-case-with-dashes for directory and file names, in order to easily distinguish them from variable names. 

### Variables

For variables, we use the naming conventions of lowercase for short variable names and lower_case_with_underscores for longer and more descriptive variable names, as needed.

Variable names should be kept as short and concise as possible, while also clearly indicating the kind of data contained in the variable. 

Examples include:
* precip: to indicate a simple variable (either single value or data structure without temporal or spatial variation in coverage)
* boulder_precip: to indicate the location of the data collection
* max_precip: to indicate the result of a summary statistic
* precip_2002: to indicate a particular year of data included
* precip_2002_2013: to indicate the particular years of data included
* precip_2000_to_2010: to indicate a range of years of data included
* precip_in or precip_mm: to indicate the measurement units

The variable names should be driven by the overall goals and purpose of the code in which they are being used. For example, in some cases, it may be more important to distinguish the units of measurement, the location, or the year or range of years covered by the data. Use your best judgment and modify variable names as needed.  

### Functions

For functions, we recommend the use of the naming conventions of mixedCase to differentiate function names from variable names, or lower_case_with_underscores when longer and more descriptive function names are needed. 


<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank">The PEP 8 Style Guide</a>

* <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>
    
</div>

