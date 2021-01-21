---
layout: single
category: courses
title: "Earth Analytics Bootcamp Course | Earth Lab CU Boulder"
authors: ['Jenny Palomino', 'Leah Wasser']
nav-title: "Earth Analytics Bootcamp Home"
permalink: /courses/earth-analytics-bootcamp/
course: "earth-analytics-bootcamp"
module-type: 'overview'
module-title: "Earth Analytics Bootcamp Course"
week-landing: 0
week: 0
estimated-time: "12 weeks"
difficulty: "beginner"
sidebar:
  nav:
comments: false
author_profile: false
overview-order: 1
---

{% include toc title="This course" icon="file-text" %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"course", page.course %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to GEOG 4463 / 5463 - Earth Analytics Bootcamp! 

## Key course materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

## About the Earth Analytics Bootcamp
The Earth Analytics Bootcamp is a three-week introductory-level course taught by instructors in Earth Lab and is a part of the <a href="https://www.colorado.edu/earthlab/earth-data-analytics-foundations-professional-certificate" target="_blank">Professional Certificate in Earth Data Analytics - Foundations</a> at CU Boulder.

In this course, you will learn how to analyze and visualize earth and environmental science data using the `Python` programming language. You will also learn how to design and implement open reproducible science workflows using `Bash`/`Shell`, `Git`/`Github.com`, and `Jupyter Notebook`. 

### Course Overview 
This course is highly technical, and you will code every day. We will use the `Python` scientific programming environment and the `Jupyter Notebook` graphical interface to work with data.

<i fa fa-star></i>**Important:** We have a cloud environment (`Jupyter Hub`) available for you to use for your assignments. However, we encourage you to get `Python` set up on your own computer as well, as it's a good skill to have! You will also need to have `Bash` and `Git` installed on your computer for several activities in this course. Please follow the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/" target = "_blank">Setting up Git, Bash, and Anaconda on your computer</a> to install the necessary tools for your operating system (Windows, Mac, Linux).



