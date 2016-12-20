---
layout: single
title: "Missing data in R"
excerpt: "This tutorial introduces the concept of missing of no data values in R."
authors: ['Data Carpentry', 'Leah Wasser']
category: [course-materials]
class-lesson: ['get-to-know-r']
permalink: /course-materials/earth-analytics/week-2/missing-data-in-r-na/
nav-title: 'Missing data'
dateCreated: 2016-12-13
lastModified: 2016-12-20
sidebar:
  nav:
author_profile: false
comments: false
order: 4
---

.

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will be able to:

* Understand why it is important to make note of missing data values.
* Be able to define what a `NA` value is in `R` and how it is used in a vector.

## What You Need

You need R and RStudio to complete this tutorial. Also we recommend have you
have an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / R Studio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)


</div>

## Missing data - No Data Values

Sometimes, our data are missing values. Imagine a spreadsheet in Microsoft excel
with cells that are blank. If the cells are blank, we don't know for sure whether
those data weren't collected, or something someone forgot to fill in. To account
for data that are missing (not by mistake) we can put a value in those cells
that represents `no data`.

The `R` programming language uses the value `NA` to represent missing data values.


```r

planets <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus",
             "Neptune", NA)
```

The default setting for most base functions that read data into `R` is to
interpret `NA` as a missing value.

## Customizing no data values

Sometimes, you'll find a dataset that uses another value for missing data. In some
disciplines, for example -9999 is sometimes used. If there are multiple types of
missing values in your dataset, you can extend what `R` considers a missing value when it reads
the file in using  "`na.strings`" argument. For instance, if you wanted to read
in a `.CSV` file named `planets.csv` that had missing values represented as an empty
cell, a single blank space, and the value -999, you would use:


```r

# import data with multiple no data values
planets_df <- read.csv(file = "planets.csv", na.strings = c("", " ", "-999"))
## Warning in file(file, "rt"): cannot open file 'planets.csv': No such file
## or directory
## Error in file(file, "rt"): cannot open the connection
```

When performing mathematical operations on numbers in `R`, most functions will
return the value `NA` if the data you are working with include missing values.
This allows you to see that you have missing data in your dataset. You can add the
argument `na.rm=TRUE` to calculate the result while ignoring the missing values.


```r
heights <- c(2, 4, 4, NA, 6)
mean(heights)
## [1] NA
max(heights)
## [1] NA
mean(heights, na.rm = TRUE)
## [1] 4
max(heights, na.rm = TRUE)
## [1] 6
```

If your data include missing values, you may want to become familiar with the
functions `is.na()`, `na.omit()`, and `complete.cases()`. See below for
examples.



```r
# Extract those elements which are not missing values.
heights[!is.na(heights)]
## [1] 2 4 4 6

# Returns the object with incomplete cases removed. The returned object is atomic.
na.omit(heights)
## [1] 2 4 4 6
## attr(,"na.action")
## [1] 4
## attr(,"class")
## [1] "omit"

# Extract those elements which are complete cases.
heights[complete.cases(heights)]
## [1] 2 4 4 6
```

<div class="notice--warning" markdown="1">

# Challenge

* **Question**: Why does the following piece of code give a warning?

```r
sample <- c(2, 4, 4, "NA", 6)
mean(sample, na.rm = TRUE)
## Warning in mean.default(sample, na.rm = TRUE): argument is not numeric or
## logical: returning NA
## [1] NA
```
<!-- * _Answer_: Because R recognizes the NA in quotes as a character. -->

* **Question**: Why does the warning message say the argument is not numeric?
<!-- * _Answer_: R converts the entire vector to character because of the "NA", and doesn't recognize it as numeric. -->

</div>
