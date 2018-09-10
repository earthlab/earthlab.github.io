---
layout: single
title: "Streaming Twitter Data"
excerpt: "This lesson provides an example of how to collect twitter data in real time."
authors: ['Martha Morrissey', 'Leah Wasser']
modified: 2018-09-07
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/earth-analytics/get-data-using-apis/stream-tweets/
nav-title: 'Stream Tweet Locations'
week: 12
sidebar:
    nav:
author_profile: false
comments: true
order: 6
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Use the `Python` package `tweepy` to stream data 
* Store tweets as a `json` file

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>


In the previous lesson, you querried the twitter API to find tweets from the past, now you will collect tweets in real time. 

## Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import tweepy
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
import time
```

## Access Twitter API in Python 
To access the Twitter API you will need 4 things from the your Twitter App page. These keys are located in your twitter app settings in the `Keys and Access Tokens` tab.

* consumer key
* consumer seceret key
* access token key 
* access token secret key 

Do not share these with anyone else because these values are specific to your app.


First you will need define your keys:

```Python
consumer_key= 'yourkeyhere'
consumer_secret= 'yourkeyhere'
access_token= 'yourkeyhere'
access_token_secret= 'yourkeyhere'
```

{:.input}
```python
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth,wait_on_rate_limit=True)
```

## Streaming Twitter Data

In previous lessons, you were not streaming twitter data, you were pulling data from twitter using a REST API. So you were looking at a sample of historical tweets from the last two weeks, now you will be colleting tweets in real-time. You will be pushing data using the streaming API which requires three steps: 

1. Create a class inheriting from StreamListener
2. Using that class create a Stream object
3. Connect to the Twitter API using the Stream.


### What to Stream 

To specify keywords you want to filter tweets by you can add a word or multiple to the `track` argument of the `filter` function from tweepy's built in `StreamListener` class. 
For example if you want to search for the words: climatechange, fires, and hurricanes you would by:

```python
stream.filter(track = ['climatechange', 'fires', 'hurricanes'])
```


### Stop Streaming 
Eventually you will run into an API rate limit if you continue to stream twitter data indefintily. You might want to stop streaming after a certain period of time.

```Python
class StdOutListener(StreamListener):
    """ A listener handles tweets that are received from the stream.
    This is a basic listener that just prints received tweets to stdout.
    """
    def on_data(self, data):
        print(data)
        return True

    def on_error(self, status):
        print(status)
        
        
        
l = StdOutListener()
auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
stream = Stream(auth, l)
stream.filter(track=['climatechange'])    

```
The code above would stream tweets about climatechange until an API limit was reached or until a memory error occured. 

## Stopping Streamed Data

{:.input}
```python
class MyStreamListener(tweepy.StreamListener):
    def __init__(self, time_limit=60):
        self.start_time = time.time()
        self.limit = time_limit
        self.saveFile = open('test_stream.json', 'a')
        super(MyStreamListener, self).__init__()

    def on_data(self, data):
        if (time.time() - self.start_time) < self.limit:
            self.saveFile.write(data)
            self.saveFile.write('\n')
            return True
        else:
            self.saveFile.close()
            return False

myStream = tweepy.Stream(auth=api.auth, listener=MyStreamListener(time_limit=20))
myStream.filter(track=['climatechange'])
```

## Saving Streamed Data

One common practice with streamed twitter data is to save it into a database such as `Postgresql` or `mysql` so it can be analyzed later. In this lesson you will save the streamed data into a `json` file since you will not be collecting a large amount of data. One advantage of writing to a database is that you are able to collect much more data that way because files are written into your computer's disc instead of memory. 

{:.input}
```python
class MyStreamListener(tweepy.StreamListener):
    def __init__(self, time_limit=60):
        self.start_time = time.time()
        self.limit = time_limit
        self.saveFile = open('streamed_cc.json', 'a')
        super(MyStreamListener, self).__init__()

    def on_data(self, data):
        if (time.time() - self.start_time) < self.limit:
            self.saveFile.write(data)
            self.saveFile.write('\n')
            return True
        else:
            self.saveFile.close()
            return False

myStream = tweepy.Stream(auth=api.auth, listener=MyStreamListener(time_limit=20))
myStream.filter(track=['climatechange'])
```
