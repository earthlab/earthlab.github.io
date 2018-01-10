---
layout: single
title: "Add Variables to an RMD Report R."
excerpt: " "
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['how-to-hints-week8']
permalink: /courses/earth-analytics/multispectral-remote-sensing-modis/add-variables-to-rmarkdown-report/
nav-title: 'Variables in Rmarkdown Report'
module-title: 'Refine Plots & Add Variables to Rmarkdown Reports'
module-description: 'This tutorial set covers some basic things you can do to refine your plots in Rmarkdown document. It covers plotting in grids, adding titles to plotRGB() plots
and refining the width and height of plots to optimize space.'
module-nav-title: 'Refine Rmarkdown Reports'
module-type: 'class'
class-order: 2
course: "earth-analytics"
week: 8
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['rmarkdown']
lang-lib:
  r: []
redirect_from:
  - "/courses/earth-analytics/week-7/add-variables-to-rmarkdown-report/"
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Add a variable to the markdown chunk in your rmd report.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>




## Automating Report Content

Let's pretend that you've calculated a value in your code and you want to include
it in your R Markdown report but you don't want to include the code. Maybe it's a
number that you want to appear in the TEXT of your report - not as a code chunk
output. How do you do that?



```r

total_area <- (800 * 7) / 2
```

You can add any variable that you want to a report using the syntax

`"r total_area"`

However replace the double quotes "" with ticks <kbd>`</kbd>


There are **2800 km** of burned area according to modis.

Where the markdown text is surrounded by ticks. Followed by the language "r"
and then the variable that you want to print in your report! This is very useful
when you are trying to create a fully automated report. As you update the data,
the output numbers if your report also update!
