---
layout: archive
category: courses
title: "Data Intensive Course Lab Materials & Courses"
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
<div id = "left">Learn how to combine earth science with data science to better understand the earth. Take our self-paced our open courses. In the first course, earth analytics, learn how to use the R programming language and R markdown to work with time series, gis, remote sensing, social media data and more. No previous programming experience is required to complete the Earth Analytics course. We are currently building a second, Earth Analytics course in Python. </div>

</div>

## Courses

{% assign courses = site.posts | where:"overview-order", 1 %}
{% for course in courses %}
* <a href="{{ site.url }}{{ course.permalink }}">{{ course.module-title }}</a>
{% endfor %}

## Workshops

Check out our Earth Analytic workshop materials.

{% include course-module-list.html %}
