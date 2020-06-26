---
layout: splash
permalink: /
splash_header: 'Free online courses, tutorials and tools'
title: 'Earth Lab: Free, online courses, tutorials and tools'
header:
  overlay_image: about-header.jpg
  cta_label: "Join our meetup!"
  cta_url: "/meetup/"
  overlay_filter: rgba(0, 0, 0, 0.5)
  caption:
excerpt: 'Learn to use earth science and other data in R & Python'
intro:
  - excerpt: 'Follow us &nbsp; [<i class="fa fa-twitter"></i> @EarthLabCU](https://twitter.com/EarthLabCU){: .btn .btn--twitter}'
feature_row2:
  - image_path: learn.png
    alt: "Introduction to Earth Data Science Textbook."
    title: "Intro to Earth Data Science Textbook"
    excerpt: "Learn about using core data science tools including Python programming, Git, GitHub and Bash to support developing scientific data workflows in Open Source Python."
    url: "/courses/intro-to-earth-data-science/"
    btn_label: "Learn More"
  - image_path: learn.png
    alt: "Intermediate to Earth Data Science Textbook."
    title: "Intermediate Earth Data Science Textbook"
    excerpt: "Dive into working with different types of data including GIS, remote sensing, twitter data and more. Explore different data types and structures including geotiff, HDF, CSV, & JSON."
    url: "/courses/use-data-open-source-python/"
    btn_label: "Learn More"
  - image_path: learn.png
    alt: "Python Open Source Plotting Guide"
    title: "Python Open Source Plotting Guide"
    excerpt: "Plotting different types of data can be tricky. Learn how to create maps, plot time series data and more in this open source Python plotting guidebook."
    url: "/courses/scientists-guide-to-plotting-data-in-python/"
    btn_label: "Learn More"
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

<div class="notice--info" markdown="1">
**Check out our *new* Earth Data Science Textbooks**
</div>

{% include feature_row id="feature_row2" %}

<!-- hiding this until the functionality is fully working -->
<div class="sidebar notsticky">
  {% include sidebar_home.html %}
</div>

<div class="archive" markdown="1">

## Welcome to Earth Data Science !

{% assign course_sessions = site.posts | where:"module-type", 'session' %}
{% assign course_overview = site.posts | where:"module-type", 'overview' %}

{% assign total_posts = site.posts | size  %}
{% assign session_posts = course_sessions | size %}
{% assign overview_posts = course_overview | size %}
{% assign posts_minus_sessions = total_posts | minus: session_posts  %}
{% assign posts_minus_overview = posts_minus_sessions | minus: overview_posts %}



<div class = "prof-cert-wrapper">
<div id = "right" >
<a href="http://bit.ly/2jc5SXy" target="_blank"><img src="{{ site.url }}/images/earth-data-analytics-professional-certificate-banner.png" alt="Get a professional Certificate in Earth Data Analytics at University of Colorado, Boulder"></a>
</div>

<div id = "left" markdown="1">This site contains open, tutorials and course materials covering topics including data integration, GIS
and data intensive science.

Explore our **{{ posts_minus_overview }} earth data science lessons**
that will help you learn how to work with data in the `R` and `Python` programming languages.

Also be sure to check back often as we are posting a suite of new `Python` lessons and courses!
</div>
</div>


## Online Earth Data Science Courses

{% assign courses = site.posts | where:"overview-order", 1 %}
{% for course in courses %}
* <a href="{{ site.url }}{{ course.permalink }}">{{ course.module-title }}</a>
{% endfor %}


## Earth Analytics Workshops

{% assign workshops = site.posts | where:"module-type", 'workshop' %}
{% assign workshop_landing_pages = workshops | where:"order", 1 %}

{% for workshop in workshop_landing_pages limit:3 %}
<div class="list__item">
  <article class="archive__item" >
  <h2 class="archive__item-title">
    <a href="{{ site.url }}{{ workshop.permalink }}">{{ workshop.module-title }} </a></h2>
    <p class='archive__item-excerpt'>{{ workshop.module-description | truncatewords:35 }}
      <br><i>Last updated: {{ workshop.modified | date_to_string }}</i> </p>
  </article>
</div>

{% endfor %}

<a href="{{ site.url}}/workshops/">View all earth analytics workshops. </a>

## Recent Tutorials

{% for post in site.categories['tutorials'] limit:3 %}
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
