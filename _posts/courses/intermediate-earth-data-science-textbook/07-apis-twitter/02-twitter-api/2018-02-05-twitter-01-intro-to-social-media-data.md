---
layout: single
title: "Use Twitter Social Media Data in Python - An Introduction"
excerpt: "You can access twitter social media data using the twitter API automatically in Python. Learn about the basics of downloading twitter data using open source Python."
authors: ['Leah Wasser', 'Martha Morrissey']
modified: 2020-04-01
category: [courses]
class-lesson: ['social-media-python']
permalink: /courses/use-data-open-source-python/intro-to-apis/social-media-text-mining-python/
nav-title: "Twitter Data for Science"
module-title: "Introduction to using Twitter Social media data in Python"
module-description: "Social media data can be used to address many social and environmental issues and challenges. Learn how to use Twitter social media data combined with basic natural language processing techniques to better understand the social impacts and perceptions of natural disturbances and other events."
module-nav-title: 'Twitter Data'
module-type: 'class'
class-order: 2
chapter: 16
week: 7
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  social-science: ['social-media']
  data-exploration-and-analysis: ['text-mining', 'data-visualization']
redirect_from:
   - "/course-materials/earth-analytics-python/api-intro/intro-to-social-media-text-mining-python/"
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List and discuss 4 challenges associated with working with social media data to address scientific questions.
* List one key package in `Python` that is used to deal with text mining.
* Define hashtag and username in the context of Twitter.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>


## Social Media Data in Science

Social media data typically describes information created and curated by individual users and collected using public platforms. These public platforms include social media networks like Twitter, Facebook, Snapchat and Instagram but also include crowd sourced data including Yelp, Zillow and others.

Social media data can be a powerful source of information given it *can* provide
a near real-time outlook on both social processes such as politics, current
day events, and natural processes including weather events (tornados, rainfall,
snow), disturbances (floods, and other natural disasters), and more.

<figure>
<img src="{{ site.url }}/images/courses/earth-analytics/week-12/social-media-3.png" alt="image showing overall stats for several platforms from 2014">
<figcaption>A graphic showing the use of several social media platforms from 2014. Note that while use of these platforms has changed over the past few years, this provides a general summary of overall use by platform. Source: <a href="https://www.leveragestl.com/social-media-infographic" target="_blank">https://www.leveragestl.com/social-media-infographic</a>
    </figcaption>
</figure>

### Challenges Working with Social Media Data

There are many challenges associated with social media data including:

1. **Non standard text:** because social media data are often a combination of text, graphics and videos, there is a significant data cleaning involved. Often, you need to find information about something in non-standard text format - some words may be capitalized, abbreviations may be used, punctuation and even emojiis all have to be considered when working with text.
2. **Text mining:** Text mining is the process of examining blocks of text to perform quantitative analysis. Pulling useful information out of blocks of non-standard text is it's own science.
3. **Non-standard or lack of consistent geolocation information:** Not all social media is spatially located (geolocated). It is thus often tricky to figure out where the data are coming from. Sometimes you have some geolocation information in non-standard text formats - for instance Colorado may be in the forms: CO or Co or Colorado or COLORADO or Boulder, Colorado.
4. **Large data volume:** In the examples that you will use in this class, you will only be working with small numbers of tweets (18000 is the max number you can request from twitter at one time). However, in reality, collecting tweets could result in billions of records that you need to sort through. This can be a big data challenge!
5. **API limitations:** If you can sort through all of the items above, sometimes you are left with a data gathering challenge. Most APIs don't allow users to download everything. In the case of Twitter, you are limited to 6-9 days of historical tweets, 18,000 tweets per API call and also to 100 requests per hour, per account. This means that you need to think strategically about what data you need and what you need to do to get it. This may mean thinking ahead and starting a streaming data collection effort when a particular event (for instance the election or a flood event) starts.

## Twitter

This week, you are going to look at the use of <a href="http://twitter.com" target="_blank">Twitter</a> as a source of information to better understand the impacts of weather and disturbance events on people.

> Twitter is an online news and social networking service where users post and interact with messages, "tweets," restricted to 140 characters. Registered users can post tweets, but those who are unregistered can only read them. - Source: Wikipedia

Many people use Twitter to discuss relevant topics. These topics may be related anything of interest to those posting on twitter and may including: science, data science, computing, sports, politics, weather, news, media and more.

### Why Use Twitter?

There are many reasons why Twitter is used as a source for information associated with a disturbance including:

1. **Data from mixed sources:** Anyone can use Twitter and thus the sources of information can include media, individuals, official and others. Mixed sources of information provides a more well-rounded perspective of the impacts of the particular event and the actions being taken to deal with that event.
1. **Embedded content:** Twitter allows users to embed pictures, videos and more to capture various elements of a disturbance both visually and quantitatively.
1. **Instantaneous coverage:** Twitter allows users to communicate directly in real time. Thus, reports on what is going on during an event can happen as the incident unfolds.

### The Structure of a Tweet

There are various components of a tweet that you can use to extract information:

* **User Name:** This is how each unique user is identified.
* **Time Stamp:** When the tweet was sent.
* **Tweet Text:** The body of the tweet - needs to be 140 characters of less!
* **Hashtags:** Always proceeded by a # symbol. A hashtag is often describes a particular event or can be related to a particular topic. It is a way for users to communicate with a particular group of people on twitter - for instance those attending a conference `#agu2016` or those using r `#rstats`.
* **Links:** Links can be embedded within a tweet. Links are a way that users share information.
* **Embedded Media:** tweets can contain pictures and videos. The most popular tweets often contain pictures.
* **Replies:** When someone posts a tweet, another user can reply directly to that user - similar to a text message except the message is visible to the public.
* **Retweets:** a retweet is when someone shares a tweet with their followers.
* **Favorites:** You can "like" a tweet to keep a history of content that you like in your account.
* **Latitude/Longitude:** about 1% of all tweets contains coordinate information.

### Twitter Usernames
Twitter accounts are organized by unique usernames. When you sign up for an account, you create a username through which the twitter community "sees" you. Someone can then send you a tweet using the `@username` syntax on twitter.

### Hashtags

Twitter data or tweets are loosely organized around hashtags. A hashtag can be
used to organize tweets by topic, event or even brand. There are some often used and recognized hashtags, such as:

* **science:** for all things science
* **python:** popular for discussions related to the Python programming language
* **datascience:** for things related to data science

Anyone can create a hashtag, so sometimes hashtags evolve.

For example, there was a large flood in Colorado in 2013 which impacted the city of
Boulder. Some people used '#BoulderFlood' as a hashtag. However, other hashtags were
also used during this time ,making data collection of tweets describing the flood
challenging!

## Access Tweets Using the Twitter REST API

Twitter has an API which allows us to access everyone's tweets. The API has certain limitations including:

1. **You can only access tweets from the last 6-9 days:** This means that you need to think ahead if you want to collect tweets for a particular event.
2. **You can only request 18,000 tweets in one call:** You can stream tweets and collect them using ongoing protocols however there are limitations to how much data you can collect!

### Twitter Data Access in `Python`

Lucky for us, there are several `Python` packages that can be used to collect tweets from the Twitter API. These include:

* `python-twitter`
* `tweepy`

Several more `Python` packages as well as packages in other programming languages for Twitter API access are reccomended in the <a href="https://developer.twitter.com/en/docs/developer-utilities/twitter-libraries" target="_blank">Twitter developer documentation</a>. In this course, you will mainly work with `tweepy`. 

## Text Mining and Cleaning in `Python`

There are numerous packages available for dealing with natural language processing or non-standard, large blocks of text in `Python`. The packages `nltk` and `re` are commonly used. 
