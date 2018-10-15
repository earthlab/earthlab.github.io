---
layout: single
title: "Get Help with Python"
excerpt: "This tutorial covers ways to get help when you are stuck in Python. "
authors: ['Chris Holdgraf', 'Data Carpentry', 'Leah Wasser', 'Martha Morrissey']
category: [courses]
class-lesson: ['get-to-know-python']
course: 'earth-analytics-python'
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/about-and-get-help-with-python/
nav-title: 'About Python & Get Help'
dateCreated: 2017-05-05
modified: 2018-10-08
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 7
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* List 2 ways that you can get help when you are stuck using Python.
* List several features of Python that makes it a versatile tool for scientific programming.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

A computer with internet access.

</div>


## Basics of Python

`Python` is a versatile, open source programming/scripting language that's useful both
for statistics but also data science.

* Free/Libre/Open Source Software. [Here is Python's license](https://docs.python.org/3/license.html). 
* It's widely used both in academia and industry.
* Available on all platforms.
* Not just for statistics, but also general purpose programming.
* For people who have experience in programmming: `Python` is both an object-oriented and a so-called [functional language](https://docs.python.org/3/library/functional.html).
* Large and growing community of developers 
* There are over 100,000 open source packages available to download that use `Python`! 

## Seeking help

Below you will learn a few ways that you can get help when you are stuck in `Python`.

### Within Jupyter 

* If you need help with a specific function, let's say creating a barplot `.bar()`, you can type:


`import matplotlib.pyplot as plt
plt.bar?`

Here's part of the output from when you type `plt.bar?`: 


`Signature: plt.bar(left, height, width=0.8, bottom=None, hold=None, data=None, **kwargs)
Docstring:
Make a bar plot.`

`Parameters
left : sequence of scalars
    the x coordinates of the left sides of the bars`

`height : sequence of scalars
    the heights of the bars`

`width : scalar or array-like, optional
    the width(s) of the bars
    default: 0.8`

`bottom : scalar or array-like, optional
    the y coordinate(s) of the bars
    default: None`

`color : scalar or array-like, optional
    the colors of the bar faces`

`edgecolor : scalar or array-like, optional
    the colors of the bar edges` 

When you type `plt.bar?` in the Python console, you are asking Python to look for the documentation
for the `.bar()` function.

* If you just need to remind yourself of the names of the arguments that can be used with the function, you can use the tab button as you type in the function name for help:

`plt.bar(<TAB>)`

## Help from the Internet 

If you're stuck with something programming related and google it (which you should) you will be directed commonly to 2 places: 
* a package's offical documentation 
* stack overflow 


### Official Documentation and source code

One of the many great things about working with open source software is that the source code will be available on github and the documnetation will be online for you to read if you need information about how a specific function works, detailed examples or detailed explinations of the argument. 

Here's the [github page for pandas](https://github.com/pandas-dev/pandas) and the link to its [offical documentation](https://pandas.pydata.org/pandas-docs/stable/). 


### Stackoverflow 

Most likely someone has encountered the same problem you’re stuck on right now, and asked about it on the website: Stack Overflow. [Stack Overflow](https://stackoverflow.com/) is a forum where programmings just like yourself ask and answer questions. The questions and answers get preserved and are searchable for other people to refer back to. When you google a question such as “How to subset dataframe based on a certain column value?” you will likely see a post from Stack Overflow that may contain one or more answers to your question!

One neat feature of Stack Overflow is people will upvote good questions and good answers. Thus often the best answer to your question, is towards the top of the post.
