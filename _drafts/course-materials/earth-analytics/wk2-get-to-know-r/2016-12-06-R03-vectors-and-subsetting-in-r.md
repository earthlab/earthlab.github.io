---
layout: single
title: "Working with vectors and data types in R"
excerpt: "This tutorial introduces vectors in R. It also introduces subsetting,
and working with NA values."
authors: ['Data Carpentry', 'Leah Wasser']
category: [course-materials]
class-lesson: ['get-to-know-r']
permalink: /course-materials/earth-analytics/work-with-data-types-r
nav-title: 'Vectors in R'
dateCreated: 2016-12-13
lastModified: 2016-12-14
sidebar:
  nav:
author_profile: false
comments: false
order: 3
---

.

<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will be able to:

* Be able to work with the 4 panes in the RStudio interface
* Understand the basic concept of a function and be able to use a function in your code.
* Know how to use key operator commands in R (<-)

## What You Need

You need R and RStudio to complete this tutorial. Also we recommend have you
have an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / R Studio](/course-materials/setup-r-rstudio)
* [Setup your working directory](/course-materials/setup-working-directory)


</div>

------------

> ## Learning Objectives
>
> * Familiarize participants with R syntax
> * Understand the concepts of objects and assignment
> * Understand the concepts of vector and data types
> * Get exposed to a few functions

------------



```

## Vectors and data types



A vector is the most common and basic data structure in R, and is pretty much
the workhorse of R. It's a group of values, mainly either numbers or
characters. You can assign this list of values to a variable, just like you
would for one item. For example we can create a vector of animal weights:


```r
weight_g <- c(50, 60, 65, 82)
weight_g
## [1] 50 60 65 82
```

A vector can also contain characters:


```r
animals <- c("mouse", "rat", "dog")
animals
## [1] "mouse" "rat"   "dog"
```

There are many functions that allow you to inspect the content of a
vector. `length()` tells you how many elements are in a particular vector:


```r
length(weight_g)
## [1] 4
length(animals)
## [1] 3
```

An important feature of a vector, is that all of the elements are the same type of data.
The function `class()` indicates the class (the type of element) of an object:


```r
class(weight_g)
## [1] "numeric"
class(animals)
## [1] "character"
```

The function `str()` provides an overview of the object and the elements it
contains. It is a really useful function when working with large and complex
objects:


```r
str(weight_g)
##  num [1:4] 50 60 65 82
str(animals)
##  chr [1:3] "mouse" "rat" "dog"
```

You can add elements to your vector by using the `c()` function:


```r
weight_g <- c(weight_g, 90) # adding at the end of the vector
weight_g <- c(30, weight_g) # adding at the beginning of the vector
weight_g
## [1] 30 50 60 65 82 90
```

What happens here is that we take the original vector `weight_g`, and we are
adding another item first to the end of the other ones, and then another item at
the beginning. We can do this over and over again to grow a vector, or assemble
a dataset. As we program, this may be useful to add results that we are
collecting or calculating.

We just saw 2 of the 6 **atomic vector** types that R uses: `"character"` and
`"numeric"`. These are the basic building blocks that all R objects are built
from. The other 4 are:

* `"logical"` for `TRUE` and `FALSE` (the boolean data type)
* `"integer"` for integer numbers (e.g., `2L`, the `L` indicates to R that it's an integer)
* `"complex"` to represent complex numbers with real and imaginary parts (e.g.,
  `1+4i`) and that's all we're going to say about them
* `"raw"` that we won't discuss further

Vectors are one of the many **data structures** that R uses. Other important
ones are lists (`list`), matrices (`matrix`), data frames (`data.frame`) and
factors (`factor`).


### Challenge


* **Question**: We’ve seen that atomic vectors can be of type character,
  numeric, integer, and logical. But what happens if we try to mix these types in
  a single vector?
<!-- * _Answer_: R implicitly converts them to all be the same type -->

* **Question**: What will happen in each of these examples? (hint: use `class()`
  to check the data type of your objects):

```r
num_char <- c(1, 2, 3, 'a')
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c('a', 'b', 'c', TRUE)
tricky <- c(1, 2, 3, '4')
```

* **Question**: Why do you think it happens?
<!-- * _Answer_: Vectors can be of only one data type. R tries to convert (=coerce)
  the content of this vector to find a "common denominator". -->

* **Question**: Can you draw a diagram that represents the hierarchy of the data
  types?
<!-- * _Answer_: `logical -> numeric -> character <-- logical` -->




## Subsetting vectors

If we want to extract one or several values from a vector, we must provide one
or several indices in square brackets. For instance:


```r
animals <- c("mouse", "rat", "dog", "cat")
animals[2]
## [1] "rat"
animals[c(3, 2)]
## [1] "dog" "rat"
```

We can also repeat the indices to create an object with more elements than the
original one:


```r
more_animals <- animals[c(1, 2, 3, 2, 1, 4)]
more_animals
## [1] "mouse" "rat"   "dog"   "rat"   "mouse" "cat"
```

R indexes start at 1. Programming languages like Fortran, MATLAB, and R start
counting at 1, because that's what human beings typically do. Languages in the C
family (including C++, Java, Perl, and Python) count from 0 because that's
simpler for computers to do.

### Conditional subsetting

Another common way of subsetting is by using a logical vector: `TRUE` will
select the element with the same index, while `FALSE` will not:


```r
weight_g <- c(21, 34, 39, 54, 55)
weight_g[c(TRUE, FALSE, TRUE, TRUE, FALSE)]
## [1] 21 39 54
```

Typically, these logical vectors are not typed by hand, but are the output of
other functions or logical tests. For instance, if you wanted to select only the
values above 50:


```r
weight_g > 50    # will return logicals with TRUE for the indices that meet the condition
## [1] FALSE FALSE FALSE  TRUE  TRUE
## so we can use this to select only the values above 50
weight_g[weight_g > 50]
## [1] 54 55
```

You can combine multiple tests using `&` (both conditions are true, AND) or `|`
(at least one of the conditions is true, OR):


```r
weight_g[weight_g < 30 | weight_g > 50]
## [1] 21 54 55
weight_g[weight_g >= 30 & weight_g == 21]
## numeric(0)
```

When working with vectors of characters, if you are trying to combine many
conditions it can become tedious to type. The function `%in%` allows you to test
if a value is found in a vector:


```r
animals <- c("mouse", "rat", "dog", "cat")
animals[animals == "cat" | animals == "rat"] # returns both rat and cat
## [1] "rat" "cat"
animals %in% c("rat", "cat", "dog", "duck")
## [1] FALSE  TRUE  TRUE  TRUE
animals[animals %in% c("rat", "cat", "dog", "duck")]
## [1] "rat" "dog" "cat"
```

> ### Challenge {.challenge}
>
> * Can you figure out why `"four" > "five"` returns `TRUE`?



<!--

```r
## Answers
## * When using ">" or "<" on strings, R compares their alphabetical order. Here
##   "four" comes after "five", and therefore is "greater than" it.
```
-->



## Missing data

As R was designed to analyze datasets, it includes the concept of missing data
(which is uncommon in other programming languages). Missing data are represented
in vectors as `NA`.


```r
planets <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus",
             "Neptune", NA)
```

The default setting for most base functions that read data into R is to
interpret `NA` as a missing value. If there are multiple types of missing values
in your dataset, you can extend what R considers a missing value when it reads
the file in.  To do this you supply additional values to the "`na.strings`"
argument of the command to read in the data. For instance, if you wanted to read
in a CSV file named `planets.csv` that had missing values represented as empty
cell, a single blank space, and the value -999, you would use:


```r
planets_df <- read.csv(file = "planets.csv", na.strings = c("", " ", "-999"))
```

When doing operations on numbers, most functions will return `NA` if the data
you are working with include missing values. It is a safer behavior as otherwise
you may overlook that you are dealing with missing data. You can add the
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
## Extract those elements which are not missing values.
heights[!is.na(heights)]
## [1] 2 4 4 6

## Returns the object with incomplete cases removed. The returned object is atomic.
na.omit(heights)
## [1] 2 4 4 6
## attr(,"na.action")
## [1] 4
## attr(,"class")
## [1] "omit"

## Extract those elements which are complete cases.
heights[complete.cases(heights)]
## [1] 2 4 4 6
```


### Challenge

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

Next, we will use the "surveys" dataset to explore the `data.frame` data
structure, which is one of the most common types of R objects.
