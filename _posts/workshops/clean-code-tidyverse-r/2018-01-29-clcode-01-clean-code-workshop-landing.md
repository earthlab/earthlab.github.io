---
layout: single
category: courses
title: "Learn to Use tidyverse and Clean Code to Work With Data in R"
excerpt: 'When working with data, you often spend the most amount of time cleaning your data. Learn how to write more efficient code using the tidyverse in R.'
authors: ['Leah Wasser', 'Max Joseph']
modified: '2020-04-02'
nav-title: "Tidyverse Workshop Setup"
permalink: /workshops/clean-coding-tidyverse-intro/
module: "clean-coding-tidyverse-intro"
module-type: 'workshop'
module-title: "Introduction to Clean Coding and the tidyverse in R"
module-description: 'When working with data, you often spend the most amount of time cleaning your data. Learn how to write more efficient code using the tidyverse in R.'
estimated-time: "3+ hours"
difficulty: "intermediate"
sidebar:
  nav:
comments: false
author_profile: false
order: 1
---

{% include toc title="This course" icon="file-text" %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"module", page.module %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Introduction to Git / Github workshop

## Important Workshop Materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

## What you need

To participate in this workshop, you need to have `R` and `RStudio` installed on your
computer. Also, please install the following R packages:

<!--
Should we list packages like this? Another option would be:
install.packages(c('pak1', 'pak2', ...))
^ has a bit less duplication
-->

* `install.packages("readr", "lubridate", "dplyr", "ggplot2")`

## Pre-requisites

This workshop is geared towards participants with background using
`R` to work with data.

### Data

All of the data required to complete this workshop is located in a GitHub
repository.
You may access the data in one of two ways:

1. If you already use git or want to learn, set it up on your computer.
2. Then use `git clone https://github.com/earthlab/version-control-hot-mess` to
clone or copy the workshop repo to your computer.
3. If you are not comfortable using git or would rather download the repository:
 * Visit this url: <a href="https://github.com/earthlab/version-control-hot-mess" target = "_blank">https://github.com/earthlab/version-control-hot-mess</a> and look for
the green "Clone or download" button.
 * Select "Download ZIP" to download the repo as a zip file.
 * Download the repo and unzip it somewhere on your computer where you will work.

Be sure that you save things in a directory on your computer that you can find
and use during the workshop!

</div>

<!-- Still need to fill this schedule out? -->

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Workshop schedule

| time        | topic                                               | instructor |
|:------------|:----------------------------------------------------|:-----------|
| 1:00 - 1:30 |   Welcome / Clean Code Group Activity |    Leah / Max    | 
| 1:30 - 2:20 | Intro to Pseudocode, Tidyverse & NA values | Max            |
| 2:30 - 2:40 | Break                                               |            |
| 2:40 - 3:20 | Automate Code with Loops            |   Leah      |
| 3:20 - 4:00 | Practice Your Skills             |   Leah  / Max    |
