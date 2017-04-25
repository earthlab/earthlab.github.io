---
layout: single
title: "Introduction to working with social media data in R - Twitter"
excerpt: "This lesson will discuss some of the challenges associated with working with social media data in science. These challenges include working with non standard text, large volumes of data, API limitations, and geolocation issues."
authors: ['Leah Wasser']
modified: '2017-04-25'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/intro-to-social-media-text-mining-r/
nav-title: "Twitter data in R"
module-title: "Intro to Social Media Data in R"
module-description: "This module explores the use of social media data - specifically Twitter data to better understand the social impacts and perceptions of natural disturbances and other events. Working with social media requires the use of API's to access data, text mining to extract useful information from non-standard text and then finally analysis using text-mining workflows"
module-nav-title: 'twitter APIs'
module-type: 'class'
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 1
lang-lib:
  r: ['rtweet']
tags2:
  social-science: ['social-media']
  data-exploration-and-analysis:
    topics: ['text-mining', 'data-visualization']
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List and discuss 4 challenges associated with working with social media data to address scientific questions.
* List one key package in R that is used to deal with text mining.
* Define hashtag and username in the context of twitter.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>


## Social media data in science

Social media data typically describes information created and curated by
individual users and collected using public platforms. These public platforms
include social media networks like Twitter, Facebook, Snapchat and Instagram but
also include crowd sourced data including Yelp, Zillow and others.

Social media data can be a powerful source of information given it *can* provide
a near real-time outlook on both social processes such as politics, and current
day events and also natural processes including weather events (tornados, rainfall,
snow), disturbances (floods, and other natural disasters) and more.

### Challenges working with social media data

There are many challenges associated with social media data including:

1. **Non standard text:** because social media data are often a combination of text, graphics and videos, there is a significant data cleaning involved. Often,
we need to find information about something in non-standard text format - some
words may be capitalized, abbreviations may be used, punctuation and even
emojiis all have to be considered when working with text.
1. ***Text mining:** Text mining is the process of examining blocks of text to
perform quantitative analysis. Pulling useful information out of blocks of non-standard text is it's own science.
1. **Non standard of lack of consistent geolocation information:** Not all social media is spatially located (geolocated). It's thus often tricky to figure
out where the data are coming from. Sometimes we have some geolocation information
in non-standard text formats - for instance Colorado may be in the forms: CO or Co
or Colorado or COLORADO or Boulder, Colorado.
1. **Large data volume:** In the examples that we will use in this class, we will
only be working with small numbers of tweets (18000 is the max number we can request from twitter at one time). However in reality, collecting tweets could result in billions of records that we need to sort through. This can be a big-data challenge!
1. **API limitations:** If we can sort through all of the items above, sometimes we are left with a data gathering challenge. Most API's don't allow users to download everything. In the case of twitter we are limited to 6-9 days of historical tweets, 18,000 tweets per API call and also to 100 requests per hour, per account. This means that we need to think strategically about what data we need and what we need to do to get it. This may mean thinking ahead and starting a streaming data collection effort when a particular event (for instance the election or a flood event) starts.

## Twitter

This week, we are going to look at the use of <a href="http://twitter.com" target="_blank">Twitter</a> as a source of information
to better understand the impacts of weather and disturbance events on people.

> Twitter is an online news and social networking service where users post and interact with messages, "tweets," restricted to 140 characters. Registered users can post tweets, but those who are unregistered can only read them. - Source: wikipedia

Many people use twitter to discuss relevant topics. These topics may be related
anything of interest to those posting on twitter and may including: science, data science, computing, sports, politics, weather, news, media and more.

### Why use twitter?

There are many reasons why twitter is used as a source for information associate with a disturbance including:

1. **Data from mixed sources:** Anyone can use twitter and thus the sources of information can include - (media, individuals, official and others). Mixed sources of information provides a more rounded perspective of the impacts of the particular event and the actions being taken to deal with that event.
1. **Embedded content:** twitter allows users to embed pictures, videos and more to capture various elements of a disturbance both visually and quantitatively.
1. **Instantaneous coverage:** Twitter allows users to communicate directly, in real time. Thus reports on what is going on during an event can happen as the incident unfolds.

### The structure of a tweet

There are various components of a tweet that we can use to extract information:

* **User Name:** This is how each unique user is identified.
* **Time Stamp:** When the tweet was sent.
* **Tweet Text:** The body of the tweet - needs to be 140 characters of less!
* Hashtags: Always proceeded by a # symbol. A hashtag is often describes a particular event or can be related to a particular, mor e
* Links
* Embedded Media
* Replies
* Retweets
* Favorites
* Latitude/Longitude

#### Twitter usernames
Twitter accounts are organized by unique usernames. When you sign up for an account,
you create a username that because the way that the twitter community "sees" you.
Someone can then send you a tweet using the `@username` syntax on twitter.

### Hashtags

Twitter data or tweets are loosely organized around hashtags. A hashtag can be
used to organize tweets by topic, event or even brand. While there are some recognized well used hashtags:

for instance:

* **science:** for all things science
* **rstats:** popular for discussions related to the r scientific programming language

Anyone can create a hashtag so sometimes hashtags evolve.

For example there was a large flood in Colorado in 2013 which impacted the city of
Boulder. Some people used '#BoulderFlood' as a hashtag. However other hashtags were
also used during this time making data collection of tweets describing the flood
challenging!

## Access tweets using the Twitter REST API

Remember that last week we explored data access using API's. Twitter has an API
which allows us to access everyone's tweets. The API has certain limitations including:

1. **You can only access tweets from the last 6-9 days:** This means that you need
to think ahead if you want to collect tweets for a particular event.
2. **You can only request 18,000 tweets in one call:** You can stream tweets and collect them using ongoing protocols however there are limitations to how much data you can collect!

### Twitter data access in R

Lucky for us, there are several `R` packages that can be used to collect tweets
from the twitter API. These include:

* `twitteR`
* `rtweet`

`rtweet` is a newer package that facilitates importing twitter data into
the  `data.frame` format. The `rtweet` package is becoming the standard tool to
access twitter data and thus we will use it in our class this week.

## Text mining in R

There are numerous packages available for dealing with natural language processing
or non standard or large blocks of text in `R`. The `tm` package is popular but
in recent years, `tidytext` has become more widely used to process text data.

`Tidytext` uses the `dplyr` piping syntax that we have used throughout this course.
We can thus use it to send data to `ggplot()` to plot which is what we will do
in the next lesson!
