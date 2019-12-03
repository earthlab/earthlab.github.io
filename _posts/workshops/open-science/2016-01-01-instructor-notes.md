---
layout: single
authors: [Naupaka Zimmerman, Leah Wasser]
title: 'Open Science Lesson Instructor Notes'
excerpt: 'Instructor notes for the open science lesson.'
category: [course-materials]
modified: '2016-01-01'
nav-title: 'Instructor Notes'
module: ['intro-open-science']
module-type: 'workshop'
permalink: /workshops/open-science-instructor-notes/
sidebar:
  nav:
author_profile: false
comments: false
order: 2
---

## About
This lesson challenges students to critically think about good file and process
management and organization in support of reproducible open science.

 <div class='notice--success' markdown="1">

## Background Materials

Students should review the following presentation PRIOR to participating in the
activity.

* <a href="{{ site.baseurl }}/slide-shows/1_intro-reprod-science/" target="_blank">Introduction to Reproducible Science Slide Show </a>

* <a href="{{ site.baseurl }}/slide-shows/2-file-naming-jenny-bryan/" target="_blank">File Naming 101</a>


[Download Lesson Data](https://ndownloader.figshare.com/files/6433086
){: .btn .btn--large}
</div>

## Activity Overview

| Time (Mins)  |Topic   |
|---|---|---|---|---|
|  10 | Intro to Reproducibility   |
|  25 | Group Work - Identify issues   |
|  20 | Discuss Issues  |
| 05 | Wrap up / Survey |


## First 10 Minutes

- Introduction to Reproducibility
- Definition
- Story about some element where it would have been helpful

**Four Facets**

* Organization
* Documentation
* Automation
* Dissemination

**Why It Makes Science Better**

* Laziness
* Help out your future self
* Contribute to building upon research efforts
* Error checking

List any other reasons / motivation for it.

## The Scenario

 You are in a lab and a colleague has moved on to a new job and left you their
 research which you are tasked by your supervisor with picking up and moving forward.
 Have a look at the files that were left for you to work with and answer the following
 questions:

 1. Are the contents of the directory easy to understand?
 2. Do you feel confident that you can easily recreate the workflow associated with the data / code?
 3. Do you have access to the data? What data are available and where / how were
 they collected?

 Have the students work in small groups to:

 1. Create a list of things that would make the working directory
 easier to work with.
 2. Break that list into general "areas" / categories of reproducibility.




## Files for an exercise on file, data, and code documentation and organization

Files in the subdirectory `messy-dir-example` can be used to help
students identify problems that make it difficult to share or reuse
analyses. There are many problems with the folder structure, file
nameing, data organization, and code organization in this example
directory.


## Identified Problems

Some of the problems within this directory include:

1. No metadata or readme
1. No directory structure
1. Background info is a picture of text instead of searchable text
1. Multiple files with similar content and different names; ambiguous naming
1. Some vector GIS files are missing and it is unclear why
1. Tabular data is in proprietary format
1. Not clear which sites different files are from
1. Not clear the order in which the script were run or should be run
1. In the code:
    * Multiple copies of similar code pasted near each other but with slight changes
    * Very few comments
    * Unclear about the order in which lines should be run
1. In the tabular file foliar chem:
    * Notes at bottom of files
    * Notes off to the right in unlabeled column
    * Gap between columns
    * Column name starting with a number
    * Duplicate column names
    * Spaces in column names
    * Misspellings in columns that might be used as categorical variables
    * Different values for missing data
    * Dealing with dates in Excel (DANGER)
    * Units for values?
    * Where is metadata?
    * Using colors rather than machine readible column flags
    * Multiple tabs

There are more issues with the repo that participants will find.



## About This Lesson
This lesson was originally taught as part of the NEON Data Institute 2016 by
[Naupaka Zimmerman](https://github.com/naupaka). The data and files are
for the most part derived from various NEON remote sensing data
products from the D17 California field sites.
