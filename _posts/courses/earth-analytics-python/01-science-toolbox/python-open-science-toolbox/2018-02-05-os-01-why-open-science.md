---
layout: single
title: 'Jupyter Notebooks - An Important Part of the Open Science Toolbox'
excerpt: "Jupyter Notebooks are a tool you can use to combine code, documentation and outputs in the same file. Learn how how to use Jupyter Notebooks for reproducible open science work."
authors: ['Leah Wasser', 'Martha Morrissey']
category: [courses]
class-lesson: ['open-science-python']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/jupyter-notebooks-for-open-science/
nav-title: "Why Open Science"
dateCreated: 2018-02-08
modified: 2018-02-09
module-title: 'Open Science Python'
module-nav-title: 'Open Science Python'
module-description: 'This module reviews why open science and best practices in python.'
module-type: 'class'
class-order: 2
course: "earth-analytics-python"
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python', 'jupyter-notebook']
---


{% include toc title="In This Lesson" icon="file-text" %}

In this lesson you will learn how the importance of open science and how to use Jupyter Notebooks for reproducible work.
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

 * List benefits of using Jupyter Notebooks to create reports. 
 * Explain how Jupyter Notebooks are a useful tool in Open Science approaches. 
 * Explain one way that Jupyter Notebooks can benefit your research. 
 
## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need
 be sure that you have Python and  the earth analytics python environment installed on your computer.  You should also have an `earth-analytics` directory setup on your computer with a `/data` directory with it
 
</div>
 

## Why Open Science 
Open science is about making scientific methods, data and outcomes
available to everyone. It can be broken down into several parts <a href= "http://www.openscience.org/blog/?p=269" target = "_blank">Gezelter 2009</a>):

* Transparency in experimental methodology, observation, and collection of data.
* Public availability and reusability of scientific data.
* Public accessibility and transparency of scientific communication.
* Using web-based tools to facilitate scientific collaboration.

In this tutorial, you are not going to focus on all aspects of open science as listed above. However, you will learn about Jupyter Notebooks as one tool that can be used to connect data, methods and outputs to make your work:

1. More transparent and
2. More available and accessible to the public and your colleagues.

Jupyter notebooks allow you to connect data, code (methods used to process the data) and outputs. Jupyter Notebooks can be saved and shared in different formats such as html or pdf.


### Open Science Slide Show 

Click through the slideshow below to learn more about open science.
<a class="btn btn--success" href="{{ site.baseurl}}/slide-shows/share-publish-archive/" target= "_blank">
View Slideshow: Share, Publish & Archive Code & Data </a>


## About Jupyter Notebooks

The `.ipynb` file format allows you to combine descriptive text, code blocks and code output. You can run the code in python and you can export the .ipynb file to a nicely rendered, shareable format like `.pdf` or html. When render your file to `.html` or pdf the code is run and so your code outputs including plots, and other figures appear in the rendered document. You will use Jupyter Notebooks (`.ipynb` files) to document workflows and to share code for data processing, analysis and visualization.


### Why Combine Markdown and Code in Jupyter Notebooks

Mixing markdown with code in Jupyter Notebooks provides many advantages:

* **Human readable:** it's much easier to read a web page or a report containing text and figures.By adding markdown or text around your code, your project becomes more user friendly and easier to understand.
* **Simple syntax:** markdown is a simple language to learn and can be learned quickly. This makes the learning curve for well-documented Jupyter Notebooks smaller. 
* **Helpful Reminder for Your Future Self:** When you code, consider your future self. If you leave your future self a well documented set of jupyter notebooks that both run your code and describe the steps, then all components of your work are clearly documented. You and your future self then don't have to remember what steps, assumptions, tests were used to complete the workflow.
* **Easy to Modify:** You can easily extend or refine analyses contained within a Jupyter notebook by modifying existing or adding new code blocks.
* **Flexible export formats:** Analysis results stored in Notebooks can be disseminated in various formats including HTML, PDF and slideshows.
* **Easy to share:** If all of your analysis is contained and described in a one or more notebooks, it makes it easy to share with a colleague. Your colleague can also easily replicate your workflow.

<i class="fa fa-star"></i> **Data Tip:**
You can easily create fully reproducible jupyter notebooks that can be run online using <a href="https://mybinder.org/" target = "_blank">my binder</a>. 
{: .notice--success }

### Jupyter Notebooks Are Beneficial to Your Colleagues

The link between data, code and results makes Jupyter Notebooks powerful. You can share your entire workflow with your colleagues and they can quickly see your process. You can also write reports using .ipynb files which contain code and data analysis results. To enrich the document, you can add text, just like you would in a word document that describes your workflow, discusses your results and presents your conclusions - along side your analysis results.

### Jupyter Notebooks Are Beneficial to You & Your Future Self

Jupyter notebooks (`.ipynb`) are efficient. If you need to make changes to your workflow, you can simply modify the code and run the report again. Your future self will appreciate it too. Jupyter Notebooks allows you to add documentation to remind yourself of your process. Further, all of the code that you used is in the notebook ready to be rerun or modified at any time.

<i class="fa fa-star"></i> **Data Tip:**
Many of the Earth Lab lessons, including this one, were created using Jupyter Notebooks!
{: .notice--success }


### Convert Notebooks to Shareable html Files
You can save Jupyter Notebooks containing code and markdown as `.html` files. When you save a notebook as `.html`, it creates a nicely rendered web page with the code and outputs visible along with the markdown rendered as nicely formatted text. This means that you can share the file with a colleague and they can see your entire workflow - without having to rerun your analysis. You will learn how how to save to `.html` and other formats later in this course.
