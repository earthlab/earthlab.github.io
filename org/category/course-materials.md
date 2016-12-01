---
layout: archive
category: course-materials
title: "Data Intensive Course Lab Materials & Courses"
permalink: /course-materials/
comments: false
author_profile: false
---


## Course Materials

Course materials and labs that focus on computational approaches.

{% for member in site.data.class-lessons %}
{% if member.active %}
<div class="list__item">
  <article class="archive__item" >
  <h2 class="archive__item-title">
  <a href="{{ site.url }}{{ site.baseurl }}{{ page.permalink }}{{ member.slug}}">{{ member.name }} </a></h2>
  <p class='archive__item-excerpt'>{{ member.description }}</p>
  {% assign counter = 0 %}
  {% for post in site.categories.[page.category] %}
      {% if post.class-lesson contains member.slug %}
        {% assign counter = counter | plus: 1 %}
      {% endif %}
  {% endfor %}

 {% assign slideCounter = 0 %}
  {% for slides in site.slide-shows %}
    {% if slides.class-lesson contains member.slug %}
      {% assign slideCounter = slideCounter | plus: 1 %}
    {% endif %}
  {% endfor %}
  <p class="page__meta">lessons: {{ counter }}, presentations {{ slideCounter }}</p>
  </article>
</div>
{% endif %}
{% endfor %}
