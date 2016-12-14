---
layout: single
permalink: /authors/
title: "Earth Lab Education Materials - Contributing Authors"
author_profile: false
published: true
site-map: true
---


{{ site.data.authors | size }} people have contributed to Earth Lab lessons as
of today!

{% for author in site.data.authors %}

<details id="{{ author.slug }}">
  <summary>
    <a href="/authors/{{ author.slug }}" name="/authors/{{ author.slug }}">{{ author.name }}</a>
  </summary>
  {% if author.bio %}{{ author.bio }} {% endif %}
</details>

{% endfor %}
