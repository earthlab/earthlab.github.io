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
<h3><a href="{{ site.url }}{{ site.baseurl }}{{ slides.url }}">{{ slides.title }}</a></h3>

{% endfor %}
