---
layout: archive
permalink: /tools/
title: "Earth Data Science Tools"
header1: "Earth Data Science: Tools For Science"
excerpt: "Earth Data Science relies on free, open-source computational tools for science, such as OpenTopoDL and smapr. Explore Earth data science tools."
author_profile: false
published: true
site-map: true
---

The University of Colorado Boulder Earth Lab creates computational Earth data 
science tools. You can use these computational tools for science. Use them to help 
you with your research or simply increase your knowledge of earth processes! Many 
are openly sourced and permissively licensed.


<div class="grid__wrapper">
  {% for post in site.tools %}
    {% include archive-single.html type="grid" %}
  {% endfor %}
</div>
