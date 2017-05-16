---
layout: archive
category: course-materials
title: "Data Intensive Course Lab Materials & Courses"
excerpt: "Data intensive courses, course lessons and tutorials that teach scientific programming, reproducible open science workflows and general scientific data skills. "
permalink: /course-materials/
comments: false
author_profile: false
---

## Courses

{% assign courses = site.posts | where:"overview-order", 1 %}
{% for course in courses %}
* <a href="{{ site.url }}{{ course.permalink }}">{{ course.module-title }}</a>
{% endfor %}

## Course Materials
Course materials and labs that focus on computational approaches.

{% include course-module-list.html %}
