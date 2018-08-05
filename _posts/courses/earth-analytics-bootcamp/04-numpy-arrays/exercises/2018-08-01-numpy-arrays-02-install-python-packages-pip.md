---
layout: single
title: 'Install Python Packages With Pip'
excerpt: "This lesson teaches you how to install Python packages using the pip package manager."
authors: ['Jenny Palomino']
category: [courses]
class-lesson: ['numpy-arrays']
permalink: /courses/earth-analytics-bootcamp/numpy-arrays/install-python-packages-pip/
nav-title: "Install Python Packages With Pip"
dateCreated: 2018-07-23
modified: 2018-08-04
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn about `pip`, a package management system used to install and manage software packages written in `Python`. You will run `pip` in the `Terminal` to install a `Python` package created specifically for working with earth systems data called `earthpy`. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Define a package management system
* Run `pip` in the `Terminal` to install `Python` packages that are hosted on `Github.com`


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/intro-shell/">Intro to Shell</a> and <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/import-python-packages/">Import Python Packages</a>.
 
</div>
 
## Package Managers

Package management systems, or package managers, provide a set of commands that are used to download and install packages that are published online. When used to install packages, package managers check for prerequisite packages that need to be present in order for the new package to install and run successfully. 

`Pip` is a package manager used to install and manage software packages written in `Python`. `Pip` can install `Python` packages from many online sources including `Github.com` and the centralized repository managed by `pip`. 

The `Pip` package manager (and its commands) are installed on your computer when you install `Python`. In this course, both `Python` and `pip` were installed using the Anaconda `Python` distribution. 

The Anaconda `Python` distribution also provides a package manager that can be used to install packages that are published in the centralized repository managed by Anaconda. 

In this lesson, you will use `pip` in the `Terminal` to install a `Python` package for working with earth systems data called `earthpy`. The `earthpy` package is published on `Github.com` at <a href="https://github.com/earthlab/earthpy" target= "_blank">https://github.com/earthlab/earthpy</a>.


## Install Python Packages Using Pip

Installing `Python` packages using `pip` is easily accomplished using the `Terminal`. 

1. Begin by opening the `Terminal` that you used in the `Shell` lessons.

2. Type:

`pip install --upgrade git+https://github.com/earthlab/earthpy.git`

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Import the `earthpy` package as `et` in a `Jupyter Notebook` file.

Be sure to add a `Python` comment describing what the code is doing, and add `Python` code to print a message after the import is successful. 

</div>

<div class="notice--info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Additional Resources

* <a href="https://packaging.python.org/tutorials/installing-packages/#use-pip-for-installing" target="_blank">More Information on Installing Packages With Pip</a>

</div>
