---
layout: single
category: courses
title: "Intro to Conditional Statements in Python"
permalink: /courses/earth-analytics-bootcamp/conditionals-loops-in-python/
modified: 2021-01-28
week-landing: 1
week: 8
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-bootcamp"
module-type: 'session'
redirect_from:
  - "/courses/earth-analytics-bootcamp/conditional-statements/"
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to Week {{ page.week }} of the Earth Analytics Bootcamp course! This week, you 
will write efficient `Python` code using `Jupyter Notebooks`. You will will implement 
another strategy for DRY (i.e. Do Not Repeat Yourself) code: conditional statements 
combined with for loops. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing the lessons for Week {{ page.week }}, you will be able to:

* Explain how conditional statements help you to write DRY code
* Write `Python` code for conditional statements to run tasks only when certain conditions are met
* Create for loops to automate tasks

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework & Readings

<a href="https://github.com/earthlab-education/bootcamp-2020-08-loops-template" target="_blank"> <i class="fa fa-link" aria-hidden="true"></i> Click here to view the GitHub Repo with the assignment template. </a>{: .btn .btn--info .btn--x-large}


## <i class="fa fa-book"></i> Earth Data Science Textbook Readings

Please read the following chapters of the Intro to Earth Data Science online textbook to support completing this week's assignment:

Please read the following chapters to support completing this week's assignment:
* <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/write-efficient-python-code/conditional-statements/">Chapter 17 - intro to conditional statements in Python</a>.
* <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/write-efficient-python-code/loops/">Chapter 18 in Section 7 Introduction to for loops in Python</a>.

OPTIONAL: you may also want to read the chapter below on manipulating file paths and directories:

* <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/os-glob-manipulate-file-paths/">Lesson on manipulating file paths</a>.

</div>

## Example Homework Plots

The plots below are examples of what your plot could look like. Feel free to
customize or modify plot settings as you see fit! 





{:.output}
    ✅ The path /root/earth-analytics/data exists. Nothing to do here
    Downloading from https://ndownloader.figshare.com/files/25033508
    Extracted output to /root/earth-analytics/data/earthpy-downloads/ca-fires-yearly








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/08-conditionals-loops/2019-08-11-conditional-loops-landing-page/2019-08-11-conditional-loops-landing-page_9_0.png" alt = "Two bar plots. The top plot shows the monthly mean number of fires in California between 1992 and 2015. The bottom plot shows the monthly mean size of fires in California between 1992 and 2015.">
<figcaption>Two bar plots. The top plot shows the monthly mean number of fires in California between 1992 and 2015. The bottom plot shows the monthly mean size of fires in California between 1992 and 2015.</figcaption>

</figure>







{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/08-conditionals-loops/2019-08-11-conditional-loops-landing-page/2019-08-11-conditional-loops-landing-page_12_0.png" alt = "Two scatter plots. The top plot shows fires in California from 2010-2015 by size and cause. The bottom plot shows fires in California from 1995-2000 by size and cause. ">
<figcaption>Two scatter plots. The top plot shows fires in California from 2010-2015 by size and cause. The bottom plot shows fires in California from 1995-2000 by size and cause. </figcaption>

</figure>




