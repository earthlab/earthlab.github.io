---
layout: single
title: "Introduction to Documenting Python Software"
excerpt: "Lack of documentation will limit peoples’ use of your code. In this lesson you will learn about 2 ways to document python code using docstrings and online documentation. YOu will also learn how to improve documentation in other software packages."
authors: ['Leah Wasser', 'Max Joseph', 'Lauren Herwehe']
modified: 2020-04-01
category: [courses]
class-lesson: ['open-source-software-python']
permalink: /courses/earth-analytics-python/contribute-to-open-source/software-documentation-python/
nav-title: 'Document Python Code'
week: 13
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Be able to define what a `Python` function docstring is and the elements that should be included in a docstring.
* Be able to describe the elements of a well documented python function.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.
</div>

## Software Documentation is Important

Documentation is the core of good software development. You can write the best code and tools, but if the code is not documented, it will limit peoples’ use. In this lesson we will explore documentation as it relates to individual functions in Python. 

There are two core components of a well documented function when writing software.

### 1. The Function Docstring 

The docstring is the text that you write that describes the function inputs, outputs and application. It’s also the text that you or someone else will see when you use the `help(function-name-here)` function in python. Imagine what someone needs to know to use this function. This information should be included in the function docstring. This text goes within the function right below where it is defined. Like this:

```python
def some-function(val):
“””
This is the docstring where you can document a function. This is what appears to describe the function when you type help(function-name) into the Python console.
parameters
--------------
   Val: int
        An integer that you wish to add 1 to.
“””
    newval = val+1
    return(newval)
```

Pay close attention to the syntax applied to the function above. You will see many different conventions surrounding how to format functions. We will be using `PEP8` and the rasterio package as a guideline for syntax.

### 2. Online Package Documentation

Docstrings are the first step towards documenting code and proper online documentation is the second. However, good documentation can make or break good software. Proper software documentation is often on a separate website. For many `python` packages, <a href="https://www.readthedocs.org" target="_blank">readthedocs.org </a> is used to host documentation. ReadTheDocs is free,  easy to use and integrates easily with GitHub.

Good documentation will describe the functionality of the package. It will also provide easy to understand vignettes that demonstrate how parts of the package - e.g. functions are used. The more applied the vignettes are, the better. Some developers will even provide example workflows that show you how a set of functions in the package can be used together to produce an entire workflow. 

As you begin to study the `earthpy` documentation, consider exploring other tools’ documentation for other examples of what documentation can look like. Some examples are below:

* <a href="https://earthpy.readthedocs.io" target="_blank">earthpy documentation</a>
* <a href="https://rasterio.readthedocs.io" target="_blank">rasterio documentation</a>
* <a href="https://geopandas.readthedocs.io" target="_blank">geopandas documentation</a>
* <a href="http://scikit-learn.org/stable/documentation.html" target="_blank">scikit learn docs - note this is not readthedocs documentation but still excellent!</a>
