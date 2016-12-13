---
layout: single
authors: ['Leah Wasser', 'Data Carpentry', 'Software Carpentry']
category: [course-materials]
title: 'Install & Setup R and R Studio on Your Computer'
attribution: 'These materials were adapted from Software Carpentry materials by Earth Lab.'
excerpt: 'This tutorial walks you through downloading and installing R and R studio on your computer.'
dateCreated: 2016-12-12
dateModified: 2016-12-12
nav-title: 'Install Packages'
sidebar:
  nav:
course: 'earth-analytics'
class-lesson: ['setup-r-rstudio']
permalink: /course-materials/earth-analytics/install-r-packages
author_profile: false
comments: false
order: 2
---


##  Install a Package

In this tutorial, we will walk you through installing the `rmarkdown` and `knitr`
 packages for `R`.


<div class='notice--success' markdown="1">

# Learning Objectives
At the end of this activity, you will:

* Know how to install a pacakge for `R` using `Rstudio`.
* Be able to explain what a package is in `R`.

</div>

## What is a Package?

A package, in `R` is a bundle of pre-build functionality. Think of it like a
tool box. Except for the tools, may do things like calculate a mathamatical function
e.g. `sum` or create a plot.

## Install a Package

In `R` we install packages using the `install.packages()` function. Let's get
rmarkdown and knitr installed so we can use them in our exercises. In the R
console within Rstudio, use the code below to install both packages individually.


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

In our case, the knitr and rmarkdown packages load buttons and options within
the Rstudio enviornment that we can use. Thus we won't have to call these two
packages in our code in this lesson.
