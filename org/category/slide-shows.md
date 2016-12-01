---
layout: post-by-category
category: slide-shows
title: "Data Intensive Tutorials"
permalink: /slide-shows/
comments: false
author_profile: true
---

## Online Presentations!

Presentations created using markdown.

{% for slides in site.slide-shows %}
<h3><a href="{{ slides.url}}">{{ slides.title }}</a></h3>

{% endfor %}

## testing another collection
{% for lidar in site.veg-structure-lidar %}
<h3><a href="{{ lidar.url}}">{{ lidar.title }}</a></h3>

{% endfor %}
