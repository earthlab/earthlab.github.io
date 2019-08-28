---
layout: single
category: courses
title: "Introduction to Earth Analytics | Earth Lab CU Boulder"
nav-title: "Intro to Earth Analytics Home"
permalink: /courses/intro-to-earth-analytics/
course: "intro-to-earth-analytics"
modified: 2019-08-28
module-type: 'overview'
module-title: "Intro to Earth Analytics"
week-landing: 0
week: 0
sidebar:
  nav:
comments: false
author_profile: false
overview-order: 1
redirect_from:
  - "/courses/earth-analytics-bootcamp/"
---


{% include toc title="This Textbook" icon="file-text" %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"course", page.course %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Introduction to Earth Analytics!

## Key Materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

## About Introduction to Earth Analytics

Introduction to Earth Analytics is an online textbook for anyone new to open reproducible science and the `Python` programming language. There are no prerequisites for this material, and no prior programming knowledge is assumed. 

This textbook is designed for the Earth Analytics Bootcamp for the <a href="https://www.colorado.edu/earthlab/earth-data-analytics-foundations-professional-certificate" target = "_blank">Earth Data Analytics Professional Certificate </a> taught by instructors at CU Boulder. 

### Overview 

In this textbook, you will learn how to analyze and visualize earth and environmental science data using the `Python` programming language. You will also get familiar with a suite of open source tools that are often used in open reproducible science workflows including `bash`, `git` and `Github.com`, and `Jupyter Notebook`.

This textbook is highly technical, and each chapter covers some aspect of scientific programming and open reproducible science workflows. 

| Part 1: Open Reproducible Science Tools |
|:----------------------------------------------------------|
| Chapter 1: Open Reproducible Science            | 
| Chapter 2: Bash / Shell  |
| Chapter 3: Jupyter Notebook for Python   |
| Chapter 4: Markdown in Jupyter Notebook   |
| Chapter 5: Git/GitHub.com   |

| Part 2: Get Started with Python |
|:----------------------------------------------------------|
| Chapter 6: Python Fundamentals   |
| Chapter 7: Packages and Libraries   |
| Chapter 8: Paths and Filenames   |


