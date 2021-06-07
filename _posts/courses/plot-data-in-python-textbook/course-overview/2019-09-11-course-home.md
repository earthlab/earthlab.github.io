---
layout: single
category: courses
title: "Scientist's Guide to Plotting Data in Python Textbook | Earth Lab CU Boulder"
authors: ['Leah Wasser', 'Jenny Palomino']
nav-title: "Scientist's Guide to Plotting Data in Python Home"
permalink: /courses/scientists-guide-to-plotting-data-in-python/
course: 'scientists-guide-to-plotting-data-in-python-textbook'
dateCreated: 2019-09-11
modified: 2021-06-07
module-type: 'overview'
module-title: "Scientist's Guide to Plotting Data in Python Textbook"
week-landing: 0
week: 0
estimated-time: "3+ hours"
difficulty: "beginner"
sidebar:
  nav:
comments: false
author_profile: false
overview-order: 1
redirect_from:
  - "/courses/scientists-guide-to-plotting-data-in-python-textbook/" 
---
{% include toc title="This Textbook" icon="file-text" %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"course", page.course %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to the Scientist's Guide to Plotting Data in Python!

## Key Materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

## About the Scientist's Guide to Plotting Data in Python

The Scientist's Guide to Plotting Data in Python is an online textbook for anyone new to plotting scientific data using the **Python** programming language. 

This textbook is designed for the Earth Analytics courses for the <a href="https://earthlab.colorado.edu/earth-data-analytics-professional-graduate-certificate?utm_source=eds&utm_medium=website&utm_campaign=certificate-2018" target = "_blank">Earth Data Analytics Professional Certificate </a> taught by instructors in Earth Lab at CU Boulder. 


### Overview 

In this textbook, you will learn how to plot using key packages for plotting in **Python** including matplotlib, a widely used plotting package in the **Python** programming language.

This textbook is highly technical, and each chapter covers some aspect of plotting with **Python**. Additional sections and chapters will continue to be added. 

{% include textbook-toc.html %}

