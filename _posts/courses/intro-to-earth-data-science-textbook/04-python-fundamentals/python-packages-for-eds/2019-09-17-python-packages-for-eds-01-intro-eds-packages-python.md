---
layout: single
title: 'Python Packages for Earth Data Science'
excerpt: "The Python programming language provides many packages and libraries for working with scientific data. Learn about key Python packages for earth data science."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey']
category: [courses]
class-lesson: ['python-packages-for-eds']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/python-packages/
nav-title: "Python Packages for EDS"
dateCreated: 2019-09-17
modified: 2019-09-23
module-title: 'Import and Install Python Packages for Earth Data Science'
module-nav-title: 'Import and Install Packages for EDS'
module-description: 'The Python programming language provides many packages and libraries for working with scientific data. Learn how to import and install key Python packages for earth data science.'
module-type: 'class'
class-order: 2
chapter: 11
course: "intro-to-earth-data-science-textbook"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Chapter" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Eleven - Import and Install Python Packages for Earth Data Science

In this chapter, you will learn what makes **Python** a useful programming language for scientific workflows by explorting 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Explain what a package is in `Python`.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setting up Git, Bash, and Conda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>




## What is a Python Package

In `Python`, a package is a bundle of pre-built functionality. You can think of a package like a toolbox filled with tools. The tools in the toolbox can be compared to functions in `Python`. 

When working with Python, the "tools" (i.e. functions) do things like calculate a mathematical operation like a sum or create a plot. There are many different packages available for `Python`. Some of these are optimized for scientific tasks including:

* Statistics
* Machine learning
* Using geospatial data 
* Visualizing data

<a href="https://www.python.org/doc/essays/blurb/" target="_blank">**Python**</a> is a free, open source scientific programming language.





You can think of a package in Python as a tool box of organized code (i.e. functions) that can be used to perform different operations - like produce a plot. In `Python`, packages are organized directories of code that can be imported and used in your work.

Throughout this Bootcamp course, you will use the following packages:
1. `os` - to access files and directories on the computer
2. `numpy` - to store and access data in arrays (i.e. ordered series)
3. `pandas` - to store and access data as dataframes (i.e. tabular data with rows and columns)
4. `matplotlib` - to plot data

Packages can contain many modules (i.e. units of code) that each provide different functions and can build on each other. For example, the `matplotlib` package provides functionality to plot data using modules, one of which is the commonly used module called `pyplot`. 

Every `Python` package should have a unique name. This allows you to import the package using the name with the `import` command. For example, the command below imports the `matplotlib` package. 

```python
import matplotlib
```

Modules in different packages may have the same name. Thus, you call a specific module by first calling the package name and then the module name - using `.` to separate the names like this:

```python
import matplotlib.pyplot

```

## Key Python Packages for Earth Data Science

* os
* glob
* matplotlib
* numpy
* pandas
* rasterio
* geopandas
* earthpy
