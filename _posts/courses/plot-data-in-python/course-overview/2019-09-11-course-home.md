---
layout: single
category: courses
title: "Plot Data in Python: A Quickstart Guide | Earth Lab CU Boulder"
nav-title: "Plot Data in Python Home"
permalink: /courses/plot-data-in-python/
course: "plot-data-in-python"
dateCreated: 2019-09-11
modified: 2019-09-19
module-type: 'overview'
module-title: "Plot Data in Python"
week-landing: 0
week: 0
sidebar:
  nav:
comments: false
author_profile: false
overview-order: 1
---
{% include toc title="This Textbook" icon="file-text" %}

{% include textbook-toc.html %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"course", page.course %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Plot Data in Python: A Quickstart Guide!

## Key Materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

## About Plot Data in Python: A Quickstart Guide

Plot Data in Python: A Quickstart Guide is an online textbook for anyone new to plotting using the **Python** programming language. 

This textbook is designed for the Earth Analytics courses for the <a href="https://www.colorado.edu/earthlab/earth-data-analytics-foundations-professional-certificate" target = "_blank">Earth Data Analytics Professional Certificate </a> taught by instructors in Earth Lab at CU Boulder. 


### Overview 

In this textbook, you will learn how to plot using key packages for plotting in **Python** including matplotlib, a widely used plotting package in the **Python** programming language.

This textbook is highly technical, and each chapter covers some aspect of plotting with **Python**. Additional sections and chapters will continue to be added. 


