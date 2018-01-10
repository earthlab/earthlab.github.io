---
layout: single
title: "Working with Function Arguments"
excerpt: "Learn how to work with function arguments in the R programming language.."
authors: ['Max Joseph', 'Software Carpentry',  'Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/function-arguments-r/
nav-title: 'Function Arguments'
week: 6
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 5
redirect_from:
  - "/courses/earth-analytics/week-8/function-arguments-r/"
---


{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Define the purpose of a function argument.
* Use default vs. required function arguments in a function.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In the previous lessons, you have used many different functions and function
arguments to customize your code.



For example, you used numerous arguments to plot your data including:

1. `main` to add a title.
2. `axes = FALSE` to remove the axes of your plot.
3. `box = FALSE` to remove the box surrounding the plot.

In the example below, you call each argument by name and then assign it a value
based on the type of argument it is. For example the value for the `main = ` argument
is a text string which is the title that you want `R` to add to your plot.


```r

# import and plot landsat
boulder_precip <- raster("data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")
plot(boulder_precip,
     main = "Digital Surface Model for Boulder, Colorado")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/06-automate-science-workflows/class-lessons/2017-03-08-automation05-funct-arguments/plot-ndvi-1.png" title="ndvi plot" alt="ndvi plot" width="90%" />

Function arguments allow you to customize how a function runs. For example, you
use the `plot()` function to plot many different types of data. You can use the:

* `main = ` argument to customize the title of the plot.
* `axes = ` and `box = ` to customize whether R draws the axes and border around the plot.

Plot() is a powerful function as it can be used to do many different
things and is customizable in many ways that you may need / want.

## Argument Order Matters

You learned this in the first few weeks of class but let's review it again.
The order or arguments supplied to a function matters. `R` has three ways
that arguments supplied by you are matched to the *formal arguments* of the
function definition:

1. **By complete name:** i.e. you type `main = ""` and `R` matches main to the argument called `main`.
2. **By order or position when you call an argument:** i.e. you call `plot(raster, "title here")`, `R` will read these two variables in the order that you provide them. This can cause the function to fail if they are not in the right order!
3. **By partial name:** (matching on initial *n* characters of the argument name) - you are not going to review this in this class. Beware using this "feature".

Arguments are matched in the manner outlined above.

* `R` first tries to find arguments according to the complete name,
* then by partial matching of names,
* and finally by position.

With that in mind, let's look at the help for `read.csv()`:


```r
# view help for the csv function
?read.csv
```

There's a lot of information available in the help. The the most important part
is the first couple of lines:


```r
read.csv(file, header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "", ...)
```

This tells us that `read.csv()` has one argument, `file`, that doesn't have a
default value, and six other arguments that do have a default value.

Now you understand why the following code returns an error:


```r
precip_data <- read.csv(FALSE, "data/week-02/precipitation/precip-boulder-aug-oct-2013.csv")
## Error in read.table(file = file, header = header, sep = sep, quote = quote, : 'file' must be a character string or connection
```

The code above fails because `FALSE` is assigned to `file` and the filename is assigned to
the argument `header`.

## Default Function Arguments

You have passed arguments to functions in two ways:

1. Directly: `plot(landsat_ndvi)`
2. By name: `read.csv(file = "data/week-02/precipitation/precip-boulder-aug-oct-2013.csv", header = FALSE)`.

You can pass the arguments to `read.csv` without naming them if they are in the
order that `R` expects.


```r
precip_data <- read.csv("data/week-02/precipitation/precip-boulder-aug-oct-2013.csv",
                FALSE)
```

However, the position of the arguments matter if they are not named.
Does the code below return an error?


```r
# import csv
precip_data <- read.csv(header = FALSE,
                file = "data/week-02/precipitation/precip-boulder-aug-oct-2013.csv")

```

But this code below doesn't work. Make sense?


```r
dat <- read.csv(FALSE,
                "data/week-02/precipitation/precip-boulder-aug-oct-2013.csv")
## Error in read.table(file = file, header = header, sep = sep, quote = quote, : 'file' must be a character string or connection
```
