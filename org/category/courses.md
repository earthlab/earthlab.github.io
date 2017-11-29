---
layout: archive
category: courses
title: "Earth Data Science Courses"
header1: "Earth Data Science Courses Online"
excerpt: "Earth data science courses integrate Earth sciences with data science skills to address environmental challenges. Learn how to work with Earth systems data."
permalink: /courses/
comments: false
author_profile: false
redirect_from:
  - "/course-materials/"
---

## Courses

These earth data science courses are highly technical. We will use the `R` scientific 
programming environment and the `RStudio` graphical interface to work with data. 
These Earth data science courses are available entirely online. All University of 
Colorado Boulder Earth data science courses online can be found on this website.


{% assign courses = site.posts | where:"overview-order", 1 %}
{% for course in courses %}
* <a href="{{ site.url }}{{ course.permalink }}">{{ course.module-title }}</a>
{% endfor %}

## Workshops

Check out our Earth Analytic workshop materials.

{% include course-module-list.html %}
