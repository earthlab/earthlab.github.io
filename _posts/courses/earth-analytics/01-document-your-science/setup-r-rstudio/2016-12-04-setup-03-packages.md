---
layout: single
authors: ['Leah Wasser', 'Data Carpentry', 'Software Carpentry']
category: [courses]
title: 'Install & Use Packages in R'
attribution: 'These materials were adapted from Software Carpentry materials by Earth Lab.'
excerpt: 'Learn what a package is in R and how to install packages to work with your data.'
dateCreated: 2016-12-12
modified: '2018-07-30'
nav-title: 'Install packages'
week: 1
sidebar:
  nav:
course: 'earth-analytics'
class-lesson: ['setup-r-rstudio']
permalink: /courses/earth-analytics/document-your-science/install-r-packages/
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['RStudio']
---

{% include toc title="In This Lesson" icon="file-text" %}



##  Install a Package

In this tutorial, we will walk you through installing the `rmarkdown`, `knitr`
and `ggplot2` packages for `R`.


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will:

* Know how to install an `R` package using `R Studio`.
* Be able to explain what a package is in `R`.

</div>

## What is a Package?

A package, in `R` is a bundle of pre-built functionality. Think of it like a
toolbox. Except for the tools may do things like calculate a mathematical function
e.g. `sum` or create a plot.

## Install a Package

In `R` we install packages using the `install.packages("packageNameHere")` function. Let's get
`R Markdown` and `knitr` installed so we can use them in our exercises. In the `R`
console within `R Studio`, use the code below to install packages individually.



```r
# install knitr
install.packages("knitr")

# install the rmarkdown package
install.packages("rmarkdown")

# install ggplot for plotting
install.packages("ggplot2")

# install dplyr for data manipulation
install.packages("dplyr")
```

<i class="fa fa-star"></i> **Data tip** You can install as many packages as you want in one string of code as follows
`install.packages(c("name-one", "name-two"))`
{: .notice--success}

## Call Package in R

Once the package is installed, to use it, you call the package at the top of
your script like this:

```r
# load libraries
library(knitr)
library(rmarkdown)
library(ggplot2)
```

Note that you don't need to use quotes around the package name when you call it
using the `library()` function. But you do need the quotes when you install a package.


In our case, the `knitr` and `R Markdown` packages load buttons and options within
the `R Studio` environment that we can use. Thus we won't have to call these two
packages in our code in this lesson. However, when we use `ggplot2` to plot,
we will have to call it. We will see how calling a package works in a later set
of lessons.

### What Does Loading a Library Do?

When you load a library in `R`, you are telling `R` to make all of the FUNCTIONS
available in the package (think of functions like tools that perform tasks - for
example `plot()`) available to you in your code.


### Where Do R Packages Live?

`R` packages are most often found on the <a href="https://cran.r-project.org/" target="_blank">CRAN repository. </a> When you call `install.packages("package-name-here")` you are actually downloading
the packages from CRAN. However there are other places where you may install packages
from including:

* Bioconductor
* github
* and more


<i class="fa fa-star" aria-hidden="true"></i>**Data tip** While some `R` packages are just fine to use. Keep in mind that not all `R` packages are secure. <a href="https://ropensci.org/blog/2017/07/25/notary" target="_blank">Learn more. </a>
{: .notice--success }

### Advanced - Install Multiple Packages at Once
You can also install multiple `R` packages at the same time. To do that, you
send the `install.packages()` function a vector or list of package names.

A vector is a list of objects. the syntax for a vector is:

`c("object1", "object2")`

you can also store numbers in a vector.

`c(1, 5, 74)`

So if we want to install `rmarkdown`, `ggplot2` and `dplyr` all at once,
we do this:



```r
# install several packages at once
install.packages(c("rmarkdown", "ggplot2", "dplyr"))

```
