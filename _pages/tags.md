---
layout: single
permalink: /tags/
title: "Browse by package"
author_profile: false
published: true
site-map: true
---

{% assign sortedTags = (site.tags | sort:0) %}
{% for tag in sortedTags %}
  <details id="tag-{{ tag[0] }}">
    <summary>
      <a name="{{ tag[0] }}">{{ tag[0] }} <span>({{ tag[1].size }})</span></a>
    </summary>
    <ul>
      {% for post in tag[1] %}
        <li><a href="{{ post.url }}">{{ post.title }}</a> — {{ post.date | date_to_string }}</li>
      {% endfor %}
    </ul>         
  </details>
{% endfor %}
