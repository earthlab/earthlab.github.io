---
layout: single
title: 'Use Expressive Names in Your Python Code'
excerpt: "Expressive naming conventions help you to write code that is clean and readable, so that others can easily follow and understand your code. Learn how to create expressive names for objects in your Python code."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['clean-expressive-code']
permalink: /courses/intro-to-earth-data-science/write-clean-expressive-code/intro-to-clean-code/expressive-programming/
nav-title: "Expressive Naming Conventions"
dateCreated: 2019-09-03
modified: 2019-09-23
module-type: 'class'
course: "intro-to-earth-data-science"
week: 5
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

* Learn how using expressive naming conventions help you to write code that is clean and readable.
* Create expressive names for objects in your `Python` code, following PEP 8 recommendations for naming conventions. 

</div>


## Why Use Expressive Names? 

In chapter one on open reproducible science, you learned about <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/best-practices-for-organizing-open-reproducible-science/" target="_blank">best practices for organizing open reproducible science projects</a>, including how to create directories and files with names that are both expressive and machine readable.

Expressive naming applies to more than just directories and files. It is also important for naming objects in your `Python` code such as variables and functions.  Expressive naming helps you to write code that is clean and easily readable. 

Clean code means that your code is organized in a way that is easy for you and for someone else to follow / read. Certain conventions are suggested to make code easier to read, such as following a clear and expressive naming convention. 

While these types of guidelines may seem unimportant when you first begin to code, after a while you realize that consistently formatted code is much easier for your eye to scan and quickly understand.

As you have already learned in this chapter, <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank">the PEP 8 Style Guide</a> provides recommendations on many aspects of code readibility, including naming conventions.  On this page, you will learn how to apply PEP 8 recommendations for naming conventions to your `Python` code. 


## Best Practices For Naming Objects

1. **Keep object names short:** this makes them easier to read when scanning through code.

2. **Use meaningful names:** For example: `precip` is a more useful name that tells us something about the object compared to `x` or `a`.

3. **Don't start names with numbers!** Objects that start with a number are NOT VALID in `Python`.

4. **Avoid names that are existing functions in Python:** e.g., `if`, `else`, `for`, see [here](https://www.programiz.com/python-programming/keywords-identifier) for more reserved names.

A few other notes about object names in `Python`:

* `Python` is case sensitive (e.g., `weight_kg` is different from `Weight_kg`).
* Avoid existing function names (e.g. `mean`), though you can combine these with other words to create a more descriptive name (e.g. `precip_mean`).
* Use nouns for variable names (e.g. `weight_kg`), and verbs for function names (e.g. `convert_kg_lb`).
* Avoid using dots in object names - e.g. `precip.boulder` - dots have a special meaning in `Python` (for methods - the dot indicates a function that is connected to a particular `Python` object) and other programming languages. 
    * Instead, use underscores `precip_boulder`.


## Recommendations For Naming Conventions 

### Directory and File Names

This textbook uses the naming conventions of `lower-case-with-dashes`for directory and file names, in order to easily distinguish them from variable names. Directory and files names should be kept as short and concise as possible, while also clearly indicating what is contained within the directory or file. 

For a review of how to create directories and files with names that are both expressive and machine readable, revisit <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/get-started-open-reproducible-science/best-practices-for-organizing-open-reproducible-science/" target="_blank">best practices for organizing open reproducible science projects</a>.


### Variable Names

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


### Function Names

For functions, this textbook uses of the naming conventions of `mixedCase` to differentiate function names from variable names, or `lower_case_with_underscores` when longer and more descriptive function names are needed. 

Again, function names should be kept as short and concise as possible, while also clearly indicating the kind of data contained in the variable.

Examples include:
* 
* 



<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="https://www.python.org/dev/peps/pep-0008/" target="_blank">The PEP 8 Style Guide</a>.

* <a href="https://realpython.com/python-pep8/" target="_blank">How To Write Beautiful Python Code with PEP 8</a>.

* <a href="https://www.safaribooksonline.com/library/view/the-hitchhikers-guide/9781491933213/ch04.html" target="_blank">The Hitchhiker's Guide to Python by Tanya Schlusser and Kenneth Reitz</a>.
    
</div>

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Applying PEP 8 To Your Code

Take a look at the code below.

* Create a list of all of the things that could be improved to make the code easier to read / work with.
* Identify changes to specific items that would help the code adhere to the PEP 8 style guide.

<!--

Format Issues:
* missing spaces in between comments
* comments aren't useful to help me understand what is happening
* white space

Object Naming Issues
* didn't use useful object names that describe the object
* one very long object name
* used a mixture of underscore and case that will be easy to confused 

-->

</div>


{:.input}
```python
# Create variable
variable=3*6
meanvariable = variable

#calculate something important
mean_variable = meanvariable * 5

# last step of the workflow
finalthingthatineedtocalculate = mean_variable + 5
```
