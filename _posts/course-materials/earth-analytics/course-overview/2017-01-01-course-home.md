---
layout: single
category: course-materials
title: "Earth Analytics: Course home page - Earth Lab CU Boulder"
nav-title: "Course home page"
permalink: /course-materials/earth-analytics/
course: "earth-analytics"
module-type: 'overview'
module-title: "Earth Analytics Course"  
week-landing: 0
week: 0
sidebar:
  nav:
comments: false
author_profile: false
overview-order: 1
---

{% include toc title="This course" icon="file-text" %}

{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

{% assign modules = sorted_posts | where:"module-type", 'overview' %}
{% assign modules_course = modules | where:"course", page.course %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to the Earth Analytics Course!

## Key course materials

{% for post in modules_course %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

Earth analytics is an advanced, multidisciplinary course will address major
questions in Earth science and teach students to use the analytical tools
necessary to undertake exploration of heterogeneous ‘big scientific data’. This
course is designed for upper level (junior / senior level) undergraduate students
and graduate students.

Throughout the course we will use computationally intensive techniques to address
scientific questions. We will use a suite of different types of publicly available
data including:

* Satellite and airborne lidar and spectral remote sensing data,
* Data collected using distributed in situ (on the ground) sensor networks
* Social media data, and
* Demographic (census) data.

This course is highly technical. We will use the `R` scientific programming
environment and the `RStudio` graphical interface to work with data.
