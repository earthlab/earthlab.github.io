---
layout: archive
category: course-materials
title: "Data Intensive Course Lab Materials & Courses"
permalink: /course-materials/
comments: false
author_profile: false
---

## Courses

[Earth Analytics ](/course-materials/earth-analytics/)



## Course Materials
Course materials and labs that focus on computational approaches.

{% assign modules = site.posts | where:"order", 1 %}
{% for module in modules %}

<div class="list__item">
  <article class="archive__item" >
  <h2 class="archive__item-title">
  <a href="{{ site.url }}{{ module.permalink }}">{{ module.module-title }}</a></h2>

  <p class='archive__item-excerpt'>{{ module.module-description }}</p>

  {% assign counter = 0 %}
  {% for post in site.categories.[page.category] %}
      {% if post.class-lesson == module.class-lesson %}
        {% assign counter = counter | plus: 1 %}
      {% endif %}
  {% endfor %}

 {% assign slideCounter = 0 %}
  {% for slides in site.slide-shows %}
    {% if slides.class-lesson == module.class-lesson %}
      {% assign slideCounter = slideCounter | plus: 1 %}
    {% endif %}
  {% endfor %}
  <p class="page__meta">lessons: {{ counter }}, presentations {{ slideCounter }}</p>
  </article>
</div>

{% endfor %}
