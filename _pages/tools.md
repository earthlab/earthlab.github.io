---
layout: archive
permalink: /tools/
title: "Tools"
author_profile: false
published: true
site-map: true
---

The Earth Data Science tools below provide resources to access and work with
data using R and Python and to setup `R` and `Python` environments. Our custom
`docker` containers are pre-built environments that you can install on your
computer that contain all of the software programs, libraries and tools that
you need to process specific types of data. We have several pre built docker
containers including ones to work with spatial data in `R` and `Python`.
All Earth Lab libraries are open source and permissively licensed.

Many of these tools are open source and permissively licensed.

<div class="grid__wrapper">
  {% for post in site.tools %}
    {% include archive-single.html type="grid" %}
  {% endfor %}
</div>
