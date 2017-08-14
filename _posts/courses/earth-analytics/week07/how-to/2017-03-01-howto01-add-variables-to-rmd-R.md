---
layout: single
title: "Add variables to an RMD report R."
excerpt: " "
authors: ['Leah Wasser']
modified: '2017-08-14'
category: [course-materials]
class-lesson: ['how-to-hints-week7']
permalink: /courses/earth-analytics/week-7/add-variables-to-rmarkdown-report/
nav-title: 'Variables in rmarkdown report'
module-title: 'Refine plots & add variables to Rmarkdown reports'
module-description: 'This tutorial set covers some basic things you can do to refine your plots in Rmarkdown document. It covers plotting in grids, adding titles to plotRGB() plots
and refining the width and height of plots to optimize space.'
module-nav-title: 'Refine Rmarkdown reports'
module-type: 'homework'
course: "earth-analytics"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['rmarkdown']
lang-lib:
  r: []
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Add a variable to the markdown chunk in your rmd report.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>




## Automating report content

Let's pretend that we've calculated a value in our code and we want to include
it in our R markdown report but we don't want to include the code. Maybe it's a
number that we want to appear in the TEXT of our report - not as a code chunk
output. How do we do that?



```r

total_area <- (800 * 7) / 2
```

We can add any variable that we want to a report using the syntax

`"r total_area"`

However replace the double quotes "" with ticks <kbd>`</kbd>


There are **2800 km** of burned area according to modis.

Where the markdown text is surrounded by ticks. Followed by the language "r"
and then the variable that we want to print in our report! This is very useful
when we are trying to create a fully automated report. As we update the data,
the output numbers if our report also update!
