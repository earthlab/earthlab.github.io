---
layout: single
category: course-materials
title: "Course template landing page"
nav-title: "Workshop landing page"
permalink: /courses/example-course-name/
course: "example-course-name" # this is the "Course" or module name. it needs to be the same for all lessons in the workshop
module-type: 'overview'
module-title: "Course template landing page"
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

text here...
