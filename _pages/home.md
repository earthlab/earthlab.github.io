---
layout: splash
permalink: /
<<<<<<< HEAD
=======
splash_header: 'Free online courses, tutorials and tools'
title: 'Earth Lab: Free, online courses, tutorials and tools'
>>>>>>> 7564f8e1cb08ccd2d92fa67ef7068e0b6a911faf
header:
  overlay_image: about-header.jpg
  cta_label: "Join our meetup!"
  cta_url: "/meetup/"
  overlay_filter: rgba(0, 0, 0, 0.5)
  caption:
<<<<<<< HEAD
excerpt: 'We support computationally intensive, transformative science'
=======
excerpt: 'Learn to use earth science and other data in R & Python'
>>>>>>> 7564f8e1cb08ccd2d92fa67ef7068e0b6a911faf
intro:
  - excerpt: 'Follow us &nbsp; [<i class="fa fa-twitter"></i> @EarthLabCU](https://twitter.com/EarthLabCU){: .btn .btn--twitter}'
feature_row:
  - image_path: learn.png
    alt: "Learn more about our lab."
    title: "Learn"
    excerpt: "Check out our data tutorials. Learn about earth analytic focused courses and programs
    we are currently developing."
    url: "/learn/"
    btn_label: "Learn More"
  - image_path: tools.png
    alt: "Get Tools"
    title: "Get Tools"
    excerpt: "Check out our tools for R, Python and high performance computing environments
     that help you efficiently process data."
    url: "/tools/"
    btn_label: "Learn More"
  - image_path: participate.png
    alt: "Participate"
    title: "Participate"
    excerpt: "Learn about upcoming workshops and training events. Come to our weekly data meetup or suggest a topic for us to cover!"
    url: "/events/"
    btn_label: "Learn More"
github:
  - excerpt: '{::nomarkdown}<iframe style="display: inline-block;" src="https://ghbtns.com/github-btn.html?user=mmistakes&repo=minimal-mistakes&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe> <iframe style="display: inline-block;" src="https://ghbtns.com/github-btn.html?user=mmistakes&repo=minimal-mistakes&type=fork&count=true&size=large" frameborder="0" scrolling="0" width="158px" height="30px"></iframe>{:/nomarkdown}'
sidebar:
  nav: earth-analytics-2017
---

<<<<<<< HEAD


=======
>>>>>>> 7564f8e1cb08ccd2d92fa67ef7068e0b6a911faf
<!-- hiding this until the functionality is fully working -->
<div class="sidebar notsticky">
  {% include sidebar_home.html %}
</div>

<div class="archive" markdown="1">

<<<<<<< HEAD
## Welcome to Earth * Data * Science !
=======
## Welcome to Earth Data Science !
>>>>>>> 7564f8e1cb08ccd2d92fa67ef7068e0b6a911faf

{% assign course_sessions = site.posts | where:"module-type", 'session' %}
{% assign course_overview = site.posts | where:"module-type", 'overview' %}

{% assign total_posts = site.posts | size  %}
{% assign session_posts = course_sessions | size %}
{% assign overview_posts = course_overview | size %}
{% assign posts_minus_sessions = total_posts | minus: session_posts  %}
{% assign posts_minus_overview = posts_minus_sessions | minus: overview_posts %}

This site contains open, tutorials and course materials covering topics including data integration, GIS
and data intensive science. Currently, we have {{ posts_minus_overview }} lessons
available on our site with more under development!

<<<<<<< HEAD
## Recent course modules
=======
## Online courses

{% assign courses = site.posts | where:"overview-order", 1 %}
{% for course in courses %}
* <a href="{{ site.url }}{{ course.permalink }}">{{ course.module-title }}</a>
{% endfor %}

## Newest lessons

<div class="list__item">
We are always adding to our course lesson materials. Below are the top 3
newest lessons that we've added to our courses.
</div>

{% assign lesson_posts = site.posts | where:"module-type", "class" or "homework" %}
{% for post in lesson_posts limit:3 %}
  <div class="list__item">
  <article class="archive__item">
    <h2 class="archive__item-title"><a href="{{ site.baseurl }}{{ post.url}}">{{ post.title }}</a></h2>
    <p class="archive__item-excerpt">{{ post.excerpt }}</p>
    <p class="archive__item-excerpt"><i>{% if post.course %}Course: {{ post.course }},{% endif %} {% if post.modified %}last updated: {{ post.modified | date_to_string }}{% endif %}</i></p>
  </article>
  </div>

{% endfor %}

## Recent course lesson sets

<div class="list__item">
Below, are the most recently develop course units. These units include a series
of lessons that are developed around a particular topic. You may want to take
the entire lesson set.
</div>
>>>>>>> 7564f8e1cb08ccd2d92fa67ef7068e0b6a911faf

{% assign modules = site.posts | where:"order", 1 %}
{% for module in modules limit:3 %}

<div class="list__item">
  <article class="archive__item" >
  <h2 class="archive__item-title">
  <a href="{{ site.url }}{{ module.permalink }}">{{ module.module-title }}</a></h2>
  <p class='archive__item-excerpt'>{{ module.module-description | truncatewords:35 }} <a href="{{ site.url }}{{ module.permalink }}">read more.</a>  </p>

  {% assign counter = 0 %}

  <!-- this may not work -->
  {% assign module_posts = site.posts | where:"class-lesson", {{ module.class-lesson }} %}
  {% for post in site.posts %}
      {% if post.class-lesson == module.class-lesson %}
        {% assign counter = counter | plus: 1 %}
      {% endif %}
  {% endfor %}

  <p class="archive__item-excerpt"><i>lessons: {{ counter }}, last updated: {{ module.modified | date_to_string }}</i></p>
  </article>
</div>

{% endfor %}

<<<<<<< HEAD
<a href="{{ site.url}}/course-materials/">View all modules </a>
=======
<a href="{{ site.url}}/courses/">View all modules </a>
>>>>>>> 7564f8e1cb08ccd2d92fa67ef7068e0b6a911faf

## Recent tutorials

{% for post in site.categories.['tutorials'] limit:3 %}
<!-- List the most recent 3 tutorials  -->
<div class="list__item">
<article class="archive__item">
  <h2 class="archive__item-title"><a href="{{ site.baseurl }}{{ post.url}}">{{ post.title }}</a></h2>
  <p class="archive__item-excerpt">{{ post.excerpt }}</p>
</article>
</div>
{% endfor %}

</div>
{% include feature_row id="intro" type="center" %}

{% include feature_row %}
