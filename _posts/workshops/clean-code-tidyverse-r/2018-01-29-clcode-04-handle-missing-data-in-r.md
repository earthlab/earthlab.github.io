---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Handle Missing Data in R'
attribution: ''
excerpt: 'Learn how to handle missing data in the R programming language.'
dateCreated: 2018-01-29
modified: '2019-08-24'
nav-title: 'Missing Data'
sidebar:
  nav:
module: "clean-coding-tidyverse-intro"
permalink: /workshops/clean-coding-tidyverse-intro/handle-missing-data-readr-r/
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['literate-expressive-programming']
---

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Understand why it is important to make note of missing data values.
* Be able to define what a NA value is in `R` and how it is used in a vector.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

Follow the setup instructions here:

* [Setup instructions]({{ site.url }}/workshops/clean-coding-tidyverse-intro/)

</div>


[<i class="fa fa-download" aria-hidden="true"></i> Overview of clean code ]({{ site.url }}/courses/earth-analytics/automate-science-workflows/write-efficient-code-for-science-r/){:data-proofer-ignore='' .btn }

In the previous lesson you attempted to plot the first file's worth of data
by time. However, the plot did you turn out as planned. There were
at least two values that likely represent missing data values:

* `missing` and
* `999.99`

In this lesson, you will learn how to handle missing data values in `R` using
`readr` and some basic data exploration approaches.

## Missing Data Values

Sometimes, your data are missing values. Imagine a spreadsheet in Microsoft
Excel with cells that are blank. If the cells are blank, you don’t know for
sure whether those data weren’t collected, or someone forgot to fill them in.
To indicate that data are missing (not by mistake) you can put a value in
those cells that represents no data.

The `R` programming language uses `NA` to represent missing data values.

Lucky for us, `readr` makes it easy to deal with missing data values too.
To account for these, we use the argument:

`na = "value_to_change_to_na_here"`

You can also send na a vector of missing data values, like this:
`na = c("value1", "value2")`


```r
# load libraries
library(readr)
library(ggplot2)
library(dplyr)
```

Let's go through our workflow again but this time account for missing values.
First, let's have a look at the unique values contained in our `HPCP` column









