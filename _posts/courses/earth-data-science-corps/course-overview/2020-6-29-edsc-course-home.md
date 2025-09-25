---
layout: single
category: courses
title: "Earth Data Science Corps | Earth Lab CU Boulder"
authors: ['Leah Wasser', 'Nathan Korinek','Jenny Palomino', 'Lauren Herwehe', 'Nate Quarderer', 'Elsa Culler']
nav-title: "Earth Data Science Corps Home"
permalink: /courses/earth-data-science-corps/
course: "earth-data-science-corps"
modified: 2022-06-16
module-type: 'overview'
module-title: "Earth Data Science Corps"
week-landing: 0
week: 0
estimated-time: "11 weeks"
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

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to the Earth Data Science Corps!

## Key course materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>

<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

## About This Textbook
This is a collection of readings with interactive exercise for participants in the Earth Data Science Corps program. You will learn how to write scientific Python workflows and work with common Earth Science data types like spatial and time-series data.

For the best results, you should try out the code as you are learning! You can <a href="https://colab.research.google.com/" target = "_blank">run the code on Google Collaboratory (Colab)</a> or <a href="{{site.url}}/workshops/setup-earth-analytics-python/setup-git-bash-conda/install" target = "_blank">install the Earth Analytics Python environment on your computer</a>.

## About the Earth Data Science Corps
The NSF-funded <a href="https://www.colorado.edu/earthlab/nsf-earth-data-science-corps" target = "_blank"> Earth Data Science Corps program </a> is aimed at undergraduate students who are new to data science and interested in applying it to earth and environmental science. Participants are trained through workshops, the Earth Analytics Bootcamp (GEOG 4463/5463) course materials, and a faculty mentor from their institution.

