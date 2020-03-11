---
layout: single
category: courses
title: "Use Data for Earth and Environmental Science in Open Source Python | Earth Lab CU Boulder"
nav-title: "Use Data for Earth and Environmental Science in Open Source Python Home"
permalink: /courses/use-data-open-source-python/
course: "intermediate-earth-data-science-textbook"
modified: 2020-03-11
module-type: 'overview'
module-title: "Use Data for Earth and Environmental Science in Open Source Python Textbook"
week-landing: 0
week: 0
sidebar:
  nav:
comments: false
author_profile: false
overview-order: 1
redirect_from:
  - "/courses/intermediate-earth-data-science-textbook/" 
---


{% include toc title="This Textbook" icon="file-text" %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"course", page.course %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to the Use Data for Earth and Environmental Science in Open Source Python Textbook!

## Key Materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

## About the Use Data for Earth and Environmental Science in Open Source Python Textbook

Use Data for Earth and Environmental Science in Open Source Python is an intermediate and multidisciplinary online textbook that addresses major questions in Earth science and teaches students to use the analytical tools necessary to undertake exploration of heterogeneous "big" scientific data.

This textbook assumes that readers have reviewed the <a href="{{ site.url }}/courses/intro-to-earth-data-science/">Introduction to Earth Data Science textbook </a> or are familiar with the **Python** programming language, **Jupyter Notebook**, and **git/GitHub**. 

This textbook is designed for the Earth Analytics Python course for the <a href="https://www.colorado.edu/earthlab/earth-data-analytics-foundations-professional-certificate" target = "_blank">Earth Data Analytics Professional Certificate </a> taught by instructors at CU Boulder. 


### Overview 

In this textbook, you will learn computationally intensive techniques to address scientific questions using a suite of different types of publicly available data including:

* Satellite and airborne lidar and spectral remote sensing data,
* Data collected using distributed in situ (on the ground) sensor networks
* Social media data, and
* Basic demographic data.

This textbook is highly technical, and each chapter covers some aspect of scientific programming with **Python** and open reproducible science workflows. 

{% include textbook-toc.html %}

