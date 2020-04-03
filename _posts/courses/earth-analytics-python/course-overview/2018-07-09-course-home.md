---
layout: single
category: courses
title: "Earth Analytics Python Course | Earth Lab CU Boulder"
authors: ['Leah Wasser']
nav-title: "Earth Analytics Home"
permalink: /courses/earth-analytics-python/
course: "earth-analytics-python"
modified: 2020-03-30
module-type: 'overview'
module-title: "Earth Analytics Python Course"
week-landing: 0
week: 0
estimated-time: "12 weeks"
difficulty: "intermediate"
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
## About the Earth Analytics Python Course
Earth analytics is an intermediate, multidisciplinary course that addresses major
questions in Earth science and teaches students to use the analytical tools
necessary to undertake exploration of heterogeneous ‘big scientific data’. This
course is designed for graduate students
and students participating in the <a href="https://www.colorado.edu/earthlab/earth-data-analytics-foundations-professional-certificate" target = "_blank">Earth Data Analytics Professional Certificate.</a>

### Course Overview 
Throughout the course we will use computationally intensive techniques to address
scientific questions. We will use a suite of different types of publicly available
data including:

* Satellite and airborne lidar and spectral remote sensing data,
* Data collected using distributed in situ (on the ground) sensor networks
* Social media data, and
* Basic demographic data.

This course is technical. We will use the `Python` scientific programming
environment and the `Jupyter` graphical interface to work with data.

