---
layout: single
authors: ['Leah Wasser', 'Data Carpentry', 'Software Carpentry']
category: [courses]
title: 'Install & Use Packages in R'
attribution: 'These materials were adapted from Software Carpentry materials by Earth Lab.'
excerpt: 'Learn what a package is in R and how to install packages to work with your data.'
dateCreated: 2016-12-12
modified: '2017-08-30'
nav-title: 'Install R packages'
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


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will:

* Know how to install an `R` package using `Rstudio`.
* Be able to explain what a package is in `R`.

</div>

## What is a Package?

A package, in `R` is a bundle of pre-built functionality. Think of it like a
toolbox. Except for the tools may do things like calculate a mathematical function
e.g. `sum` or create a plot.

## Install a Package

In `R` we install packages using the `install.packages("packageNameHere")` function. Let's get
`rmarkdown`, `knitr` and several data manipulation packages installed that we will
use in the upcoming weeks. In the `R`
console within `Rstudio`, use the code below to install packages individually.



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

<i class="fa fa-star"></i> **Data Tip** You can install as many packages as you want in one string of code as follows
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

In our case, the `knitr` and `rmarkdown` packages load buttons and options within
the `Rstudio` environment that we can use. Thus we won't have to call these two
packages in our code in this lesson. However, when we use `ggplot2` to plot,
we will have to call it. We will see how calling a package works in a later set
of lessons.

### What does loading a library do?

When you load a library in `R`, you are telling `R` to make all of the FUNCTIONS
available in the package (think of functions like tools that perform tasks - for
example `plot()`) available to you in your code.


### Where do R packages live?

`R` packages are most often found on the <a href="https://cran.r-project.org/" target="_blank">CRAN repository. </a> When you call `install.packages("package-name-here")` you are actually downloading
the packages from CRAN. However there are other places where you may install packages
from including:

* Bioconductor
* github
* and more


Important. Note all `R` packages are secure. <a href="https://ropensci.org/blog/blog/2017/07/25/notary" target="_blank">Learn more. </a>

### Advanced - install multiple packages at once
You can also install multiple R packages at the same time. To do that,


```r
# install several packages at once
install.packages(c("rmarkdown", "ggplot2", "dplyr"))

```
