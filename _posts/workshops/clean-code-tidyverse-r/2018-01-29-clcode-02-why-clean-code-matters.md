---
layout: single
authors: ['Max Joseph', 'Leah Wasser']
category: courses
title: 'Get Started with Clean Coding in R'
attribution: ''
excerpt: 'Clean code refers to writing code that runs efficiently, isn't redundant and is easy for anyone to understand. Learn how to write clean code using the R scientific programming language.'
dateCreated: 2018-01-29
modified: '2019-08-29'
module-title: 'Introduction to clean code'
module-description: 'This module includes a high level overview of clean code concepts in R, with an activity to identify problems in a sample of messy code.'
module-nav-title: 'Clean Code'
nav-title: 'Get Started with Clean Code'
sidebar:
  nav:
module: "clean-coding-tidyverse-intro"
permalink: /workshops/clean-coding-tidyverse-intro/importance-of-clean-code/
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['literate-expressive-programming']
---

{% include toc title="In this lesson" icon="file-text" %}

<!--  This is the top block with the learning objectives (LO) -->
<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives
At the end of this activity, you will be able to:

* Identify issues that can be improved in your code in the areas of syntax, modularity, documentation and expressiveness.
* Define syntax, documentation, modularity and expressiveness.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

* You need internet access to complete this activity

</div>


[<i class="fa fa-download" aria-hidden="true"></i> Overview of clean code ]({{ site.url }}/courses/earth-analytics/automate-science-workflows/write-efficient-code-for-science-r/){:data-proofer-ignore='' .btn }

## What is Clean Code?

The theme of this workshop is clean code. When we say clean code, we are 
referring to code that is written in a way that is easy to understand (for you, 
your future self and your colleagues), efficient in it's implementation and 
well documented.

In this workshop, we will explore several tricks and tips that you can use to
write more efficient code. These include:

1. Writing pseudocode before executable code to organize your approach. 
Pseudocode refers to writing out the steps and process that you will need to 
implement in your code - in plain old english - BEFORE you code. We will 
discuss pseudocode more in the next lesson.
2. Writing more expressive code by using meaningful variable names and 
`tidyverse` functions and syntax in `R`.
3. Automating your code rather than using a "copy pasta" approach. Writing 
pseudocode can help with identifying repetitive tasks.

### Core Principles of Clean Code

In this workshop, you will learn how to write better, more efficient and easier
to read, well-documented code. You can segment the concept of clean code into
4 main components:

1. **Syntax:** Syntax is the format or style that you use to write your code. 
When a group of scientists use the same syntax, the code becomes more familiar 
and thus easier to quicly scan, read and understnd. Different style guides have 
been developed
2. **Modularity:** Is your code more "script like" written from beginning to 
end with repeated tasks? Or does it consist of sections and functions that 
capture tasks that are repeated?
3. **Documentation:** Is your code well documented? Documentation can range 
from comments found within your code to thorough `readme` files that describe 
your entire workflow. 
4. **Expressiveness:** Expressiveness refers to writing code that makes your 
intention transparent. This includes using meaningful names for objects and 
files, that indicate something about their contents and intended use. 

### Don't Repeat Yourself  (DRY)

The DRY approach to programming refers to writing functions and automating 
sections of code that are repeated. If you perform the same task multiple times 
in your code, consider a function or a loop to make your workflow more 
efficient.

## About The Data

The goal of this workshop is as follows:

You have been given access to some precipitation data for Colorado across 
several locations This data is stored in the cloud and your colleague has started 
to explore the data in `R`.

Your colleague has given you two things:

1. A `.csv` file containing a list of URL's for each `.csv` data file
2. Some thoughtfully composed code (see below) that they wrote to explore the 
data and help you get started.

Unfortunately, your colleague is trekking among the tallest peaks
in the Himalaya. Thus, you are left to your own crafty devices to figure out
how to work with these data.

Your goal in this workshop is to create a plot of the data in `R`. 
Something like this:








