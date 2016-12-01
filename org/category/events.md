---
layout: single
title: "Earth Lab Events"
permalink: /events/
header:
  overlay_color: "#999"
  cta_label: "Join Our Meetup"
  cta_url: "/meetup/"
  overlay_filter: rgba(0, 0, 0, 0.5)
  caption:
excerpt: 'Supporting data intensive community.'
modified: 2016-11-31T12:19:29-04:00
author_profile: false
---

{% capture nowyear %}{{'now' | date: '%Y'}}{% endcapture %}
{% capture nowday %}{{'now' | date: '%j'}}{% endcapture %}


## Upcoming events

{% for event in site.events reversed %}
  {% capture eventyear %}{{event.date | date: '%Y'}}{% endcapture %}
  {% capture eventday %}{{event.date | date: '%j'}}{% endcapture %}
  {% if eventyear > nowyear or eventday >= nowday and eventyear >= nowyear %}
  <li>
    <span class="event-date">{{ event.date | date: "%b %-d, %Y" }}</span>
    {% if event.link %}
    <a href="{{ event.link }}" class="event-link" target="_blank">{{ event.title }}</a>
    {% else %}
    <a href="{{ site.url }}{{ site.baseurl }}{{ event.permalink }}" class="event-link">{{ event.title }}</a>
    {% endif %}
  </li>
  {% endif %}
{% endfor %}


## Past events

{% for event in site.events reversed %}
  {% capture eventyear %}{{event.date | date: '%Y'}}{% endcapture %}
  {% capture eventday %}{{event.date | date: '%j'}}{% endcapture %}
  {% if eventyear < nowyear or eventday < nowday and eventyear == nowyear %}
  <li>
    <span class="event-date">{{ event.date | date: "%b %-d, %Y" }}</span>
    <a class="event-link" href="{{ event.link }}">{{ event.title }}</a>
  </li>
  {% endif %}
{% endfor %}


Questions? Tweet: <a href="http://twitter.com/leahawasser" class="btn btn--twitter"><i class="fa fa-twitter"></i>@leahawasser</a> or <a href="http://twitter.com/mxwlj" class="btn btn--twitter"><i class="fa fa-twitter"></i>@mxwlj</a>
