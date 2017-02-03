---
layout: single
authors: ['Leah Wasser', 'Data Carpentry', 'Software Carpentry']
category: [course-materials]
title: 'Install & Use Packages in R'
attribution: 'These materials were adapted from Software Carpentry materials by Earth Lab.'
excerpt: 'Packages are sets of functions that perform tasks that help us work with various data structures in R. This tutorial walks you through installing and loading R packages R in RStudio.'
dateCreated: 2016-12-12
modified: '2017-02-01'
nav-title: 'Install Packages'
week: 1
sidebar:
  nav:
course: 'earth-analytics'
class-lesson: ['setup-r-rstudio']
permalink: /course-materials/earth-analytics/week-1/install-r-packages/
author_profile: false
comments: true
order: 3
---
{% include toc title="In This Lesson" icon="file-text" %}


##  Install a Package

In this tutorial, we will walk you through installing the `rmarkdown`, `knitr`
and `ggplot2` packages for `R`.


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will:

* Know how to install an `R` package using `Rstudio`.
* Be able to explain what a package is in `R`.

</div>

## What is a Package?

A package, in `R` is a bundle of pre-built functionality. Think of it like a
toolbox. Except for the tools, may do things like calculate a mathematical function
e.g. `sum` or create a plot.

## Install a Package

In `R` we install packages using the `install.packages("packageNameHere")` function. Let's get
`rmarkdown` and `knitr` installed so we can use them in our exercises. In the `R`
console within `Rstudio`, use the code below to install packages individually.


```r
# install knitr
install.packages("knitr")

# install the rmarkdown package
install.packages("rmarkdown")

# install ggplot for plotting
install.packages("ggplot2")
```

<i class="fa fa-star"></i> **Data Tip** You can install as many packages as you one in one string of code as follows
`install.packages(c("name-one", "name-two"))`
{: .notice }

## Call Package in R

Once the package is installed, to use it, you call the package at the top of
your script like this:

```r
library(knitr)
library(rmarkdown)
library(ggplot2)

```
Note that you don't need to use quotes around the package name when you call it
using the `library()` function. But you do need the quotes when you install a


In our case, the `knitr` and `rmarkdown` packages load buttons and options within
the `Rstudio` environment that we can use. Thus we won't have to call these two
packages in our code in this lesson. However, when we use `ggplot2` to plot,
we will have to call it. We will see how calling a package works in a later set
of lessons.
