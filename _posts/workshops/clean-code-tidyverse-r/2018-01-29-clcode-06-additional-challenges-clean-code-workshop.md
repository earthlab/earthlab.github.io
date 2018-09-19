---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Challenge Yourself'
attribution: ''
excerpt: 'This lesson contains a series of challenges that require using tidyverse functions in R to process data.'
dateCreated: 2018-01-29
modified: '2018-02-02'
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





<img src="{{ site.url }}/images/rfigs/workshops/clean-code-tidyverse-r/2018-01-29-clcode-06-additional-challenges-clean-code-workshop/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="90%" />

## Challenge 2

Create a plot that shows total precipitation by MONTH for each station. Color each
station using a different color. Remove all rows with a Quality Flag.

HINTS:

The `filter()` function, allows you to remove certain rows from your data based
upon criteria that you specify. For example you may choose to filter all precipitation
values that are less than or equal to .1 as follows:

`filter(HPCP <= .1)`

Use `filter()` and `ggplot(aes(..., color = ...)) + ...`
to create a scatterplot of `HPCP` over time. Use a different color for each
station. Exclude any observations that are NA OR that have any quality flag
associated with them.


the zoo package has the function: as.yearmon that can be used to create a date field
with only the year and month in it.

Once the zoo package is loaded, you can then use + scale_x_yearmon() to scale the
x axis of your ggplot() plot.

<img src="{{ site.url }}/images/rfigs/workshops/clean-code-tidyverse-r/2018-01-29-clcode-06-additional-challenges-clean-code-workshop/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="90%" />


## Challenge 3

Use `count()` to calculate the number of observations (rows) that exist for each
station.

Does one station have more observations than another?
Calculate it for yourself in R. The correct answer is below.



```
## # A tibble: 3 x 2
## # Groups:   toupper(STATION_NAME) [3]
##   `toupper(STATION_NAME)`     n
##                     <chr> <int>
## 1         BOULDER 2 CO US  1840
## 2          DENVER 1 CO US  1840
## 3           LYONS 1 CO US  1840
```

## Challenge 4

Explore ggplot! Make a plot that shows monthly mean precipitation at each station 
that is publication ready. Consider the following when creating this plot:

* Customize axis labels (e.g. display pretty axis labels like Jan
instead of 1.0 for month)
* Change the look of the plot using a theme
* Customize the fonts used in the plot and colors. 

Customize any aspects of the plot that you wish. Then use `ggsave()` to save
the plot as a pdf file.



