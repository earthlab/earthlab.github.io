---
layout: single
category: course-materials
title: "Earth Analytics: Course home page - Earth Lab CU Boulder"
nav-title: "Course home page"
permalink: /course-materials/earth-analytics/
course: "Earth Analytics"
module-type: 'overview'
week-landing: 0
week: 0
sidebar:
  nav:
comments: false
author_profile: false
overview-order: 1
---

{% include toc title="This course" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to the Earth Analytics Course!



</div>
<!-- an overview module specifies the overview content for the course including syllabus and any assignments  module-type: 'session' specified a week or a particular set of content surrounding a topic - eg internship seminar, etc -->

<!-- only grab pages related to the course listed on this page -->
{% assign course_posts = site.posts | course: page.course %}
{% assign sorted_posts = course_posts | sort:'overview-order' %}

## Create a list of all weeks

Note: an overview module type contains the overview content for a course.

{% assign modules = sorted_posts | where:"module-type", 'overview' %}

## Overview Stuff
{% for post in modules %}
 * <a href="{{ site.url }}{{ post.permalink }}">{{ post.title }}</a>
{% endfor %}

{% assign weeks = course_posts | where:"module-type", 'session' %}
{% assign sorted_weeks = weeks | sort:'week' %}

## Sessions

{% for post in sorted_weeks %}
 * {{ post.title }}
{% endfor %}
