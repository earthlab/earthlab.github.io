---
layout: single
title: "Write Clean Code - Expressive or Literate Programming in R - Data Science for Scientists 101"
excerpt: "This lesson covers the basics of clean coding meaning that you ensure that the code that you write is easy for someone else to understand. The lesson will briefly cover style guides, consistent spacing, literate object naming best practices. "
authors: ['Leah Wasser', 'Data Carpentry']
category: [courses]
class-lesson: ['write-clean-code']
permalink: /courses/earth-analytics/time-series-data/write-clean-code-with-r/
nav-title: 'Write Clean Code'
dateCreated: 2016-12-13
modified: '2018-01-10'
module-title: 'Clean Code & Getting Help'
module-nav-title: 'Clean Code & Getting Help with R'
module-description: 'This module covers how to write easier to read, clean code.
Further is covers some basic approaches to getting help when working in R. Finally
it reviews how to install QGIS - a free and open source GIS tool - on your computer.'
module-type: 'homework'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 1
course: "earth-analytics"
topics:
  reproducible-science-and-programming: ['RStudio', 'literate-expressive-programming']
---


{% include toc title="In This Lesson" icon="file-text" %}

This lesson reviews best practices associated with clean coding.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Write code using Hadley Wickham's style guide.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also we recommend that you
have an `earth-analytics` directory set up on your computer with a `/data`
directory within it.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)

***

### Resources
* <a href="http://adv-r.had.co.nz/Style.html" target="_blank" data-proofer-ignore=''>Hadley Wickham's style guide</a>

</div>


Clean code means that your code is organized in a way that is easy for you and
for someone else to follow and read. Certain conventions are suggested to make code
easier to read. For example, many guides suggest the use of a space after a comment.
Like so:

```r
#poorly formatted  comments are missing the space after the pound sign.
# good comments have a space after the pound sign
```

While these types of guidelines may seem unimportant when you first begin to code,
after a while you'll realize that consistently formatted code is much easier
for your eye to scan and quickly understand.

## Consistent, Clean Code

Take some time to review <a href="http://adv-r.had.co.nz/Style.html" target="_blank">Hadley Wickham's style guide</a>.
From here on in, you will follow this guide for all of the assignments in this class.

## Object Naming Best Practices

1. **Keep object names short:** This makes them easier to read when scanning through code
2. **Use meaningful names:** For example, `precip` is a more useful name that tells us something about the object compared to `x`
3. **Don't start names with numbers!** Objects that start with a number are NOT VALID in `R`
4. **Avoid names that are existing functions in R:** e.g.`if`, `else`, `for`, see
[here](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Reserved.html)

A few other notes about object names in `R`:

* `R` is case sensitive (e.g. `weight_kg` is different from `Weight_kg`).
* Avoid other function names (e.g. `c`, `T`, `mean`, `data`, `df`, `weights`).
* Use nouns for variable names and verbs for function names.
* Avoid using dots in object names - e.g. `my.dataset` - dots have a special meaning
in `R` (for methods) and other programming languages. Instead use underscores `my_dataset`.


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge

Take a look at the code below.

* Create a list of all of the things that could be improved to make the code
easier to read and work with.
* Add to that list things that don't fit the Hadley Wickham style guide standards.
* Try to run the code in `R`. Any issues?

<!--
FORMAT Issues:
missing spaces in between comments
comments aren't useful to help me understand what is happening

OBJECT NAMING
- didn't use useful object names that describe the object
- used a number to name a variable
- one very long object name
- used a mixture of underscore and case that will be easy to confuse
- used a . in an object name

-->
</div>


```r

#my code

#load stuff
library(ggplot2)

#turn off factors
options(stringsAsFactors = FALSE)

1variable <- 3 * 6
meanVariable <- 1variable

#calculate something important
mean-variable <- meanvariable * 5

thefinalthingthatineedtocalculate <- mean-variable + 5

#get things that are important
download.file(url = "https://ndownloader.figshare.com/files/7010681",
              destfile = "data/boulder-precip.csv")

my.data <- read.csv(file="data/boulder-precip.csv")
head(my_data)

str(my.data)

qplot(x=my.data$DATE,
      y=my.data$PRECIP)

```
