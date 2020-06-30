---
layout: single
category: courses
title: "Earth Data Science Corps | Earth Lab CU Boulder"
authors: ['Leah Wasser', 'Nathan Korinek','Jenny Palomino', 'Lauren Herwehe', 'Nate Quarderer']
nav-title: "Earth Data Science Corps Home"
permalink: /courses/earth-data-science-corps/
course: "earth-data-science-corps"
modified: 2020-06-30
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

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to the Earth Data Sciece Corps!

## Key course materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

## About the Earth Data Science Corps
The NSF-funded <a href="https://www.colorado.edu/earthlab/nsf-earth-data-science-corps" target = "_blank"> Earth Data Science Corps program </a> is aimed at undergraduate students who are new to data science and interested in applying it to earth and environmental science. Participants are trained through workshops, the Earth Analytics Bootcamp (GEOG 4463/5463) course, and a paid applied internship with an earth data science supervisor at CU Boulder Earth Lab or with a partner organization. 


