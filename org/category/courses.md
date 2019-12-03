---
layout: archive
category: courses
title: "Earth Data Science Courses & Workshops"
excerpt: "Data intensive courses, course lessons and tutorials that teach scientific programming, reproducible open science workflows and general scientific data skills. "
permalink: /courses/
comments: false
author_profile: false
redirect_from:
  - "/course-materials/"
---


<div class = "prof-cert-wrapper">
<div id = "right">
<a href="http://bit.ly/2jc5SXy" target="_blank"><img src="{{ site.url }}/images/earth-data-analytics-professional-certificate-banner.png" alt="Get a professional Certificate in Earth Data Analytics at University of Colorado, Boulder"></a></div>
<div id = "left" markdown="1">Learn how you can integrate earth science understanding and
data science skills to better understand Earth by working through free,
self-paced courses online. In the Earth Analytics course, explore how the
`R` programming language and `R Markdown` is used to work with time series, GIS,
remote sensing and social media data. No previous programming experience is
required! Stay tuned for a second course build in Python using all open source
tools!

All Earth Data Science courses, are developed and taught as a part of the
<a href="https://www.colorado.edu/earthlab/earth-data-analytics-foundations-professional-certificate" target="_blank">professional Certificate and Masters program in Earth Data Analytics</a>
offered by <a href="https://www.colorado.edu/earthlab" target = "_blank">Earth Lab</a> at the University of Colorado - Boulder.
</div>

</div>

## Current Courses

{% assign courses = site.posts | where:"overview-order", 1 %}
{% for course in courses %}
* <a href="{{ site.url }}{{ course.permalink }}">{{ course.module-title }}</a>
{% endfor %}

## Earth Data Science Course Modules

Want to improve your earth data science skills? Complete a set of short,
self-paced technical lessons that together create full courses. Following the materials available online for each
module, you will learn how to perform a specific workflow using a specific tool
that is commonly used in the earth data science field.

{% include course-module-list.html %}
