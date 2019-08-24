---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Challenge Yourself'
attribution: ''
excerpt: 'This lesson contains a series of challenges that require using tidyverse functions in R to process data.'
dateCreated: 2018-01-29
modified: '2019-08-24'
nav-title: 'Challenge Yourself'
sidebar:
  nav:
module: "clean-coding-tidyverse-intro"
permalink: /workshops/clean-coding-tidyverse-intro/tidyverse-clean-code-challenges-r/
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['literate-expressive-programming']
---

{% include toc title="In this lesson" icon="file-text" %}




<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
This activity will test all of the skills that you learned in the previous
lessons.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Follow the setup instructions here:

* [Setup instructions]({{ site.url }}/workshops/clean-coding-tidyverse-intro/)

</div>


[<i class="fa fa-download" aria-hidden="true"></i> Overview of clean code ]({{ site.url }}/courses/earth-analytics/automate-science-workflows/write-efficient-code-for-science-r/){:data-proofer-ignore='' .btn }



In the previous lessons, you have learned a set of skills that will allow you
to work with tabular data using the `tidyverse` in `R` including

* Writing for loops
* Using pipes and `tidyverse` functions to create expressive code that
minimizes intermediate outputs
* Handling missing data values

Below, find a set of challenges that will test (and add to) your skills.

## Challenge 1

Using the functions: `lubridate::year()`, `mutate()`, `group_by()`, and
`summarise()`, evaluate whether the annual variability in precipitation has
increased or decreased at each of the three stations and make a figure that
supports your conclusion.


HINTS:

* You can use the scales library and `scale_x_continuous(breaks = pretty_breaks())` when you created your plot to create a nicely scaled x axis.
* `year()` is a lubridate function, consider column names CAREFULLY if you add a column to your data.

The plot below is one example of how you might exploration this challenge. Feel
free to produce other plots that also help explore variability per site!










