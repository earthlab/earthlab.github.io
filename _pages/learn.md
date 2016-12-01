---
layout: archive
title: "Learn"
permalink: /learn/
header:
  overlay_color: "#333"
  cta_label: "CU Students, Enroll Now - GEOG 4100 / 5100"
  cta_url: "/courses/earth-systems-analytics"
  overlay_filter: rgba(0, 0, 0, 0.5)
  caption:
excerpt: 'Data intensive learning.'
modified: 2016-08-21T17:19:29-04:00
author_profile: false
---

## Recent Classroom Modules

Below, is a list of the most recent classroom modules. Classroom modules consist
of background materials, readings and student activities. Classroom modules are
data intensive, however many contain pre-populated interactive plots and maps
that can be used to teach a class without having to actually process data.

Check out the instructor notes to better understand how each lesson can be taught.

{% for member in site.data.class-lessons limit:3 %}
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

[View All Class Lessons]({{ site.url }}{{ site.baseurl }}/course-materials/)

## Recent code tutorials

Check out our latest code tutorials. Leave questions in the comment box at
the bottom. We'll try our best to help!

  {% for post in site.categories.tutorials limit:3 %}
  <div class="list__item">
    <article class="archive__item" >
    {% if post.link %}
      <h2 class="archive__item-title"><a href="{{ site.url }}{{ site.baseurl }}{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a> <a href="{{ post.link }}" target="_blank" title="{{ post.title }}"><i class="icon-link"></i></h2>
    {% else %}
      <h2 class="archive__item-title"><a href="{{ site.url }}{{ site.baseurl }}{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a></h2>
      <span class="post-date">
      {% if post.lastModified %}Last modified: {{ post.lastModified | date: "%b %-d, %Y" }}{% endif %}
      {% if post.packagesLibraries %} - Libraries: {{ post.packagesLibraries | join: ', ' %}}{% endif %}
      </span>
      <p class='archive__item-excerpt'>{% if post.excerpt %}{{ post.excerpt }}{% else %}{{ post.content | strip_html | strip_newlines | truncate: 120 }}{% endif %}</p>
    {% endif %}
  </article>
  </div>
{% endfor %}

[View All Tutorials]({{ site.url }}{{ site.baseurl }}/tutorials/)

## Data Intensive Courses
A newly designed
[Earth Systems Analytics course - GEOG 4100 / 5100](/courses/earth-systems-analytics)
will be taught January 2017. This course fuses key topics related to the grand
challenges in science, remote sensing and computationally intensive approaches.
The course will be held in Spring 2017 at the CU Boulder campus. Stay tuned for
course materials as they develop.


Questions? Tweet: <a href="http://twitter.com/leahawasser" class="btn btn--twitter"><i class="fa fa-twitter"></i>@leahawasser</a> or <a href="http://twitter.com/mxwlj" class="btn btn--twitter"><i class="fa fa-twitter"></i>@mxwlj</a>
