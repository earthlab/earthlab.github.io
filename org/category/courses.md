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

## Courses

{% assign courses = site.posts | where:"overview-order", 1 %}
{% for course in courses %}
* <a href="{{ site.url }}{{ course.permalink }}">{{ course.module-title }}</a>
{% endfor %}

## Workshops

Check out our Earth Analytic workshop materials.

{% include course-module-list.html %}
