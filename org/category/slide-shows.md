---
layout: post-by-category
category: slide-shows
title: "Data Intensive Tutorials"
permalink: /slide-shows/
comments: false
author_profile: true
<<<<<<< HEAD
=======
sitemap: false
>>>>>>> 7564f8e1cb08ccd2d92fa67ef7068e0b6a911faf
---

## Online Presentations!

Presentations created using markdown.

{% for slides in site.slide-shows %}
<h3><a href="{{ site.url }}{{ site.baseurl }}{{ slides.url }}">{{ slides.title }}</a></h3>

{% endfor %}
