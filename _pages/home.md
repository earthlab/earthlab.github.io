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
feature_row:
  - image_path: learn.png
    alt: "Learn more about our lab."
    title: "Learn"
    excerpt: "Check out our code tutorials. Learn about courses and programs
    we are currently developing."
    url: "/learn/"
    btn_label: "Learn More"
  - image_path: tools.png
    alt: "Get Tools"
    title: "Get Tools"
    excerpt: "We build tools for R, Python and high performance computing environments
     to help you efficiently process data."
    url: "/tools/"
    btn_label: "Learn More"
  - image_path: participate.png
    alt: "Participate"
    title: "Participate"
    excerpt: "Check out our upcoming workshops and training events. Join our weekly meetup."
    url: "/events/"
    btn_label: "Learn More"
github:
  - excerpt: '{::nomarkdown}<iframe style="display: inline-block;" src="https://ghbtns.com/github-btn.html?user=mmistakes&repo=minimal-mistakes&type=star&count=true&size=large" frameborder="0" scrolling="0" width="160px" height="30px"></iframe> <iframe style="display: inline-block;" src="https://ghbtns.com/github-btn.html?user=mmistakes&repo=minimal-mistakes&type=fork&count=true&size=large" frameborder="0" scrolling="0" width="158px" height="30px"></iframe>{:/nomarkdown}'
intro:
  - excerpt: 'Follow us &nbsp; [<i class="fa fa-twitter"></i> @EarthLabCU](https://twitter.com/EarthLabCU){: .btn .btn--twitter}'
sidebar:
  nav: earth-analytics-2017
---

## Welcome

This site contains open, tutorials and course materials in the area of data integration
and data intensive science. Currently, we have {{ site.posts | size }} lessons
available on our site with more under development!

{% for post in site.posts %}
   {% if post.tags2 %}
   just RS: {{ post.tags2.remote-sensing }}
   {% for tag-sect in post.tags2 %}
      THE first main category: {{ tag-sect | first }}
      {% assign sub-tags = tag-sect | last %}
      {% for a-sub-tag in sub-tags %}
        * {{ a-sub-tag }}
      {% endfor %}
   {% endfor %}
   <ul>
      <li>{{ post.title }}:{{ post.tags2 }}</li>
    </ul>
   {% endif %}
{% endfor %}

<div class="sidebar sticky">


<!-- remove for now
{% for tag in site.tags %}
  {% assign t = tag | first %}
  {% assign posts = tag | last %}
  <li>{{ t | downcase | replace:" ","-" }}: {{ posts | size }} posts</li>
{% endfor %}
-->

<nav class="nav__list">
  <ul>
    <li><span class="nav__sub-title"><i class="fa fa-folder-open" aria-hidden="true"></i> Coding languages</span>
      <ul>
            {% for main_lang in site.data.libs %}
            {% assign main_lang_counter = 0 %}
            {% for language in main_lang.lang %}
             {% for post in site.posts %}
               {% if post.lang contains language %}
                 {% assign main_lang_counter = main_lang_counter | plus: 1 %}
                {% endif %}
             {% endfor %}
            {% endfor %}
            <li><span><i class="fa fa-book" aria-hidden="true"></i> {{ main_lang.lang }}: {{ main_lang_counter }} lessons </span></li>
            {% endfor %}
        </ul></li>
    </ul>
    <ul>

      <li><span class="nav__sub-title"><i class="fa fa-folder-open" aria-hidden="true"></i> Science</span>
        <ul>
                <ul>
                {% for main_tag in site.data.tag-hier %}

                {% assign main_tag_counter = 0 %}
                {% for topics in main_tag.topic %}
                 {% for post in site.posts %}

                 {% if post.tags2 contains main_tag.tag %}
                 {% assign the_tag = main_tag.tag %}
                 **get all subtags:** {{ post.tags2[the_tag] }}
                 {% endif %}

                   {% if post.tags contains topics %}
                     {% assign main_tag_counter = main_tag_counter | plus: 1 %}
                    {% endif %}
                 {% endfor %}
                {% endfor %}

              <li><span><i class="fa fa-book" aria-hidden="true"></i> {{ main_tag.tag | replace:"-"," "}}: {{ main_tag_counter }} lessons</span></li>
                {% endfor %}
              </ul>


          </ul></li>
      </ul>
</nav>
</div>

<div class="archive" markdown="1">

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
  {% assign module_posts = site.posts | where:"module-title", {{ module.module-title }} %}
  {% for post in module_posts %}
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
