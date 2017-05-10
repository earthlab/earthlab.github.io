---
layout: single
title: "The syntax of the R scientific programming language - Data Science for scientists 101"
excerpt: "This lesson introduces the basic syntax associated with the R scientific programming language. We will introduce assignment operators (<-), comments and basic functions that are available to use in R to perform basic tasks including head(), qplot() to quickly plot data and others. This lesson is designed for someone who has not used R before. We will work with precipitation and
stream discharge data for Boulder County."
authors: ['Mollie Buckland', 'Leah Wasser']
category: [course-materials]
class-lesson: ['earth-lab-internship']
permalink: /course-materials/internship/
nav-title: 'Syllabus'
dateCreated: 2016-12-13
modified: '2017-05-10'
module-title: 'Earth Lab Internship '
module-nav-title: 'Internship'
module-description: 'Text (2-4 sentences) describing the internship.'
module-type: 'class'
course: "Earth Analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:

---

{% include toc title="In This Lesson" icon="file-text" %}


In this tutorial, we will explore the basic syntax (structure) or the `R` programming
language. We will introduce assignment operators (`<-`, comments (`#`) and functions
as used in `R`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Understand the basic concept of a function and be able to use a function in your code.
* Know how to use key operator commands in R (`<-`)

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)
* [Intro to the R & RStudio Interface](/course-materials/earth-analytics/week-1/intro-to-r-and-rstudio)

</div>

In the [previous module](/course-materials/earth-analytics/week-1/setup-r-rstudio), we
setup `RStudio` and `R` and got to know the `RStudio` interface.
We also created a basic
`RMarkdown` report using `RStudio`. In this module, we will explore the basic
syntax of the `R` programming language. We will learn how to work with packages and
functions, how to work with vector objects in R and finally how to import data
into a data.frame which is the `R` equivalent of a spreadsheet.
