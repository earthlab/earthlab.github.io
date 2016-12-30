---
layout: archive
permalink: /categories/
title: "Browse by category"
author_profile: false
---

{% include base_path %}
{% include group-by-array collection=site.posts field="categories" %}

{% for category in group_names %}
  {% assign posts = group_items[forloop.index0] %}
  <h1 id="{{ category | slugify }}" class="archive__subtitle">{{ category }}</h1>
  {% for post in posts %}
    {% include archive-single.html %}
  {% endfor %}
{% endfor %}
