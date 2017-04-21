---
layout: single
authors: ['Leah Wasser', 'Data Carpentry', 'Software Carpentry']
category: [course-materials]
title: 'Install & setup R and RStudio on your laptop'
attribution: 'These materials were adapted from Software Carpentry materials by Earth Lab.'
excerpt: 'This tutorial walks you through downloading and installing R and RStudio on your computer.'
dateCreated: 2016-12-12
modified: '2017-02-01'
module-title: 'Setup R, RStudio and Your Working Directory'
module-description: 'This module walks you through getting R and RStudio setup on your
laptop. It also introduces file organization strategies.'
course: "Earth Analytics"
nav-title: 'Setup RStudio'
module-nav-title: 'Setup R'
module-type: 'homework'
course: "Earth Analytics"
week: 1
sidebar:
  nav:
course: 'earth-analytics'
class-lesson: ['setup-r-rstudio']
permalink: /course-materials/earth-analytics/week-1/setup-r-rstudio/
author_profile: false
comments: true
order: 1
---

{% include toc title="In This Lesson" icon="file-text" %}


##  R & RStudio Setup

In this tutorial, we will download and install `R` & `RStudio`
on your computer.

>The `R` & `RStudio` installation instructions below were adapted from
<a href="http://software-carpentry.org/" target="_blank"> Software Carpentry</a>.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will:

* Be able to download and install `R` and `Rstudio` on your laptop.

</div>

## Windows

*  <a href="http://cran.r-project.org/bin/windows/base/release.htm" target="_blank">Download R for Windows here</a>
*   Run the `.exe` file that was downloaded in the step above.
*  <a href="http://www.rstudio.com/ide/download/desktop" target="_blank">Go to the RStudio Download page</a>
*  Under *Installers* select **RStudio *current version ##* - Windows XP/Vista/7/8/10**
*  Double click the file to install it


Once `R` and `RStudio` are installed, open `RStudio` to make sure that you don't get
any error messages.

## Mac OS X


* Go to <a href="http://cran.r-project.org" target="_blank">CRAN</a> and click
on *Download R for (Mac) OS X*
* Select the .pkg file for the version of OS X that you have and the file
will download.
* Double click on the file that was downloaded and R will install
* Go to the <a href="http://www.rstudio.com/ide/download/desktop" target="_blank">RStudio Download page</a>
* Under *Installers* select <b>RStudio *current version ##* - Mac OS X 10.6+ (64-bit)</b> to download it.
* Once it's downloaded, double click the file to install it.

Once `R` and `RStudio` are installed, open RStudio to make sure it works and you
don't get any error messages.

## Linux

`R` is available through most `Linux` package managers. You can download the binary
files for your distribution from
<a href="http://cran.r-project.org/index.html" target="_blank">CRAN</a>.
Or you can use your package manager (e.g. for Debian/Ubuntu run
`sudo apt-get install r-base` and for Fedora run `sudo yum install R`).

* To install RStudio, go to the
<a href="http://www.rstudio.com/ide/download/desktop" target="_blank">RStudio Download page</a>
* Under *Installers* select the version for your distribution.
* Once it's downloaded, double click the file to install it.


Once `R` and `RStudio` are installed, open `RStudio` to make sure that it works
and there are no errors when you open it.
