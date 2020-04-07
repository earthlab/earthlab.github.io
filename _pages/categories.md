---
layout: archive
permalink: /categories/
title: "Browse by category"
author_profile: false
---

Under construction for the time being

{% comment %}
<!-- We aren't using this page so let's turn it off for the time being -->
{% include toc title="Categories" icon="file-text" %}

{% include base_path %}
{% include group-by-array collection=site.posts field="categories" %}

{% for category in group_names %}
  {% assign posts = group_items[forloop.index0] %}
## {{ category }}
{: .archive__subtitle }
  <!-- <h2 id="{{ category | slugify }}" class="archive__subtitle"></h2> -->
  {% for post in posts %}
    {% include archive-single.html %}
  {% endfor %}
{% endfor %}
{% endcomment %}
