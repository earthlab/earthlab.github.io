---
layout: splash
permalink: /
header:
  overlay_image: about-header.jpg
  cta_label: "Join our meetup!"
  cta_url: "/meetup/"
  overlay_filter: rgba(0, 0, 0, 0.5)
  caption:
excerpt: 'We support computationally intensive, transformative science'
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



<!-- hiding this until the functionality is fully working -->
<div class="sidebar notsticky">
  {% include sidebar_home.html %}
</div>

<div class="archive" markdown="1">

## Welcome to Earth * Data * Science !

This site contains open, tutorials and course materials covering topics including data integration, GIS
and data intensive science. Currently, we have {{ site.posts | size }} lessons
available on our site with more under development!

## Recent course modules

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
