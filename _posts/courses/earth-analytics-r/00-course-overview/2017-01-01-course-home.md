---
layout: single
category: course-materials
title: "Earth Analytics Course: Learn Data Science"
excerpt: "Earth Analytics is a multidisciplinary course that explores how to use different types of data to address major Earth science questions. Learn more about the course."
nav-title: "Course Home Page"
permalink: /courses/earth-analytics/
course: "earth-analytics"
module-type: 'overview'
module-title: "Earth Analytics R Course"
week-landing: 0
week: 0
sidebar:
  nav:
comments: false
author_profile: false
overview-order: 1
redirect_from:
   - "/course-materials/earth-analytics/"
---

{% include toc title="This course" icon="file-text" %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"course", page.course %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to the Earth Analytics Course!

## Key Course Materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

Earth analytics is an advanced, multidisciplinary course that addresses major
questions in Earth science and teaches students to use the analytical tools
necessary to undertake exploration of heterogeneous 'big scientific data.' This
course is designed for upper level (junior and senior level) undergraduate students
and graduate students.

Throughout the course you will use computationally intensive techniques to address
scientific questions. You will use a suite of different types of publicly available
data including:

* Satellite and airborne lidar and spectral remote sensing data.
* Data collected using distributed in situ (on the ground) sensor networks.
* Social media data.
* Demographic (census) data.

This course is highly technical. You will use the `R` scientific programming
environment and the `RStudio` graphical interface to work with data.
