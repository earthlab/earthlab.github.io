---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Challenge Yourself'
attribution: ''
excerpt: 'This lesson contains a series of challenges that require using tidyverse functions in R to process data.'
dateCreated: 2018-01-29
modified: '2018-01-31'
nav-title: 'Challenge Yourself'
sidebar:
  nav:
module: "clean-coding-tidyverse-intro"
permalink: /courses/clean-coding-tidyverse-intro/tidyverse-clean-code-challenges-r/
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['literate expressive programming']
---


{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
This activity will test all of the skills that you learned in the previous
lessons.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Follow the setup instructions here:

* [Setup instructions]({{ site.url }}/courses/clean-code-tidyverse-r/)

</div>


[<i class="fa fa-download" aria-hidden="true"></i> Overview of clean code ]({{ site.url }}/courses/earth-analytics/automate-science-workflows/write-efficient-code-for-science-r/){:data-proofer-ignore='' .btn }


In the previous lessons, you have learned a set of skills that will allow you
to work with tabular data using the `tidyverse` in `R` including

* Writing for loops
* Using pipes and `tidyverse` functions to create expressive code that minimizes intermediate outputs
* Handling missing data values

Below, find a set of challenges that will test (and add to) your skills.

## Challenge 1 -

Using the functions: `lubridate::year()`, `mutate()`, `group_by()`, and `summarize()`,
evaluate whether the annual variability in precipitation has increased or decreased at each of the three stations and make a figure that supports your conclusion.





Use `filter()` and `ggplot(aes(..., color = ...)) + ...`
to create a scatterplot of `HPCP` over time. Use a different color for each
station. Exclude any observations that are NA OR that have any quality flag
associated with them.





## Challenge 3

Use count() to calculate the number of observations (rows) that exist for each
station.

Does one station have more observations than another?




## Challenge 4

Make the plot of monthly means at each station publication ready. You can
add axis labels, change the theme, display pretty axis labels (e.g., Jan
instead of 1.0 for month), and anything else you might think of, then save
the plot as a pdf file.




SOME FILLER HERE TO ALLOW US TO ADD THE CODE AT THE BOTTOM OF THE PAGE??
It is very possible that we have covered SOME of these already in the on your own
section... Have we?
