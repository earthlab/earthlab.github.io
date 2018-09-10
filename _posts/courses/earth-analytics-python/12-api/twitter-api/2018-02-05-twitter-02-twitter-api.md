---
layout: single
title: 'Twitter Data in Python Using Tweepy: Analyze and Download Twitter Data'
excerpt: 'You can use the Twitter RESTful API to access data about Twitter users and tweets. Learn how to use rtweet to download and analyze twitter social media data in Python.'
authors: ['Martha Morrissey', 'Leah Wasser','Carson Farmer']
modified: 2018-09-07
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/earth-analytics-python/get-data-using-apis/use-twitter-api-python/
nav-title: 'Get Tweets with Twitter API'
week: 12
sidebar:
    nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Query the twitter RESTful API to access and import into `Python` tweets that contain various text strings.
* Generate a list of users who are tweeting about a particular topic.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>


In this lesson you will explore analyzing social media data accessed from twitter,
in Python. You  will use the Twitter RESTful API to access data about both twitter users
and what they are tweeting about. 

## Getting Started

To get started you'll need to do the following things:

1. Set up a twitter account if you don't have one already.
2. Using your account, setup an application that you will use to access twitter from `Python`
3. Import the `tweepy` package

Once you've done these things, you are ready to begin querying Twitter's API to
see what you can learn about tweets!

## Set up Twitter App 

Get started by setting up an application in twitter that you can use to access tweets. Make sure you already have a twitter account. To setup your app, follow the documentation from `rtweet` here:

<a href="https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html" target="_blank"><i class="fa fa-info-circle" aria-hidden="true"></i>
 TUTORIAL: How to setup a twitter application using your twitter account</a>

NOTE: you will need to provide your cell phone number to twitter to verify your
use of the API.

<figure>

<img src="{{ site.url }}/images/courses/earth-analytics/week-12/boulder_twitter_map_visualizations.jpg" alt="image showing tweet activity across boulder and denver.">

<figcaption>A heat map of the distribution of tweets across the Denver / Boulder region <a href="http://www.socialmatt.com/amazing-denver-twitter-visualization/" target="_blank">source: socialmatt.com</a></figcaption>
</figure>


## Access Twitter API in Python 

Once you have your twitter app setup, you are ready to dive into accessing tweets in `Python`. Begin by importing the necessary `Python` libraries. 

{:.input}
```python
import tweepy
import pandas as pd
```

To access the Twitter API you will need 4 things from the your Twitter App page. These keys are located in your twitter app settings in the `Keys and Access Tokens` tab.

* consumer key
* consumer seceret key
* access token key 
* access token secret key 

Do not share these with anyone else because these values are specific to your app. 

First you will need define your keys

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

### Send a Tweet

Note that your tweet needs to be 140 characters or less.

```python
# post a tweet from Python
api.update_status("Look, I'm tweeting from Python in my #earthanalytics class! @EarthLabCU")
# your tweet has been posted!
```

### Search Twitter for Tweets

Now you are ready to search twitter for recent tweets! Let's start by finding all
tweets that use the `#boco_trails` hashtag.

{:.input}
```python
for tweet in tweepy.Cursor(api.search,q="#boco_trails",
                           lang="en",
                           since="2018-05-20", include_rts=False).items():
    print (tweet.created_at, tweet.text)
```

{:.output}
    2018-05-24 16:15:58 RT @boulderosmp: To help protect a coyote den &amp; young pups, OSMP has instituted leash restrictions on the Community Dtich East &amp; the Coal S…
    2018-05-24 15:59:47 To help protect a coyote den &amp; young pups, OSMP has instituted leash restrictions on the Community Dtich East &amp; the… https://t.co/n4cCm37Q7Q
    2018-05-24 15:45:23 Like to ride Valmont Bike Park? Follow @bikevalmont for conditions updates! #BoCo_trails https://t.co/GBZxaBhPY4
    2018-05-24 15:35:44 Good news for your Wednesday afternoon. #boco_trails https://t.co/zwDzVWAjfB
    2018-05-24 04:14:20 RT @BoCo_trails: @mtnbikechic @RangerFowler @boulderrunner @303cycling @BoulderCountyOS Everything is pretty much perfect except Valmont an…
    2018-05-24 03:51:40 @mtnbikechic @RangerFowler @boulderrunner @303cycling @BoulderCountyOS Everything is pretty much perfect except Val… https://t.co/VGMa1iI6vm
    2018-05-24 00:08:29 RAD squad 🚲🚲🚲🚲🐾 goals on the Aspen Alley trail in West Magnolia @usfsarp trail system near Nederland, CO. Jump line… https://t.co/NLJoh1Nb5N
    2018-05-24 00:04:37 RT @mfbb1: Hall Ranch is dry and awesome!#boco_trails
    2018-05-23 22:56:44 Hall Ranch is dry and awesome!#boco_trails
    2018-05-23 22:43:22 RT @boulderosmp: Trails in Marshall Mesa/Greenbelt Plateau, Doudy/Flatirons Vista/Springbrook areas are now open. Left Hand Trail remains c…
    2018-05-23 22:21:54 Heads up #boco_trails users. https://t.co/aCdew6Vy84
    2018-05-23 20:06:18 Valmont is the bullseye for spring storms. #boco_trails https://t.co/Jg9kbirPUD
    2018-05-23 19:17:04 RT @boulderosmp: Trails in Marshall Mesa/Greenbelt Plateau, Doudy/Flatirons Vista/Springbrook areas are now open. Left Hand Trail remains c…
    2018-05-23 17:24:42 Trails in Marshall Mesa/Greenbelt Plateau, Doudy/Flatirons Vista/Springbrook areas are now open. Left Hand Trail re… https://t.co/oWmGwjpXOL
    2018-05-23 16:22:57 South Boulder / Marshall Mesa area trails are scheduled to reopen this afternoon (Wed). Picture Rock is riding grea… https://t.co/c7Aw0Kgdlp
    2018-05-23 01:25:55 @ErieSingletrack Trails are open, a little rain but it just made for even better conditions. #boco_trails
    2018-05-22 18:03:55 RT @BoCo_trails: Hall, Heil, Walker and Betasso are all riding great. Marshall Mesa area trails still closed, but drying out nicely so watc…
    2018-05-22 16:54:59 RT @BoCo_trails: Hall, Heil, Walker and Betasso are all riding great. Marshall Mesa area trails still closed, but drying out nicely so watc…
    2018-05-22 16:54:50 RT @BoCo_trails: Hall, Heil, Walker and Betasso are all riding great. Marshall Mesa area trails still closed, but drying out nicely so watc…
    2018-05-22 16:22:24 Hall, Heil, Walker and Betasso are all riding great. Marshall Mesa area trails still closed, but drying out nicely… https://t.co/T7NRWAccqj
    2018-05-22 02:48:27 RT @redstonecyclery: Everything out of Lyons is in good shape and the higher ground is riding even better #boco_trails https://t.co/ByQOM4I…
    2018-05-22 02:22:41 RT @RangerGrady: Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #b…
    2018-05-22 02:14:58 RT @redstonecyclery: Everything out of Lyons is in good shape and the higher ground is riding even better #boco_trails https://t.co/ByQOM4I…
    2018-05-22 02:14:40 RT @RangerGrady: The Overland Loop at # Heil Valley Ranch is now counterclockwise in direction for bikes. Enjoy! #boco_trails https://t.co/…
    2018-05-22 00:58:42 RT @redstonecyclery: Everything out of Lyons is in good shape and the higher ground is riding even better #boco_trails https://t.co/ByQOM4I…
    2018-05-22 00:23:49 RT @BoCo_trails: Hall report from Chris E.:
    Hall is riding really well right now. About 10 puddles on the rockgarden, ride thru them or bun…
    2018-05-21 23:28:44 Everything out of Lyons is in good shape and the higher ground is riding even better #boco_trails https://t.co/ByQOM4IJ0X
    2018-05-21 22:19:18 Hall report from Chris E.:
    Hall is riding really well right now. About 10 puddles on the rockgarden, ride thru them… https://t.co/WIv6RJLAMD
    2018-05-21 20:12:13 RT @RangerGrady: The Overland Loop at # Heil Valley Ranch is now counterclockwise in direction for bikes. Enjoy! #boco_trails https://t.co/…
    2018-05-21 20:10:09 Hall Ranch in good shape. A few puddles in the rock garden, minimal mud on the north side of Nelson loop, and Antel… https://t.co/qE4NeVAguk
    2018-05-21 19:20:13 RT @RangerGrady: The Overland Loop at # Heil Valley Ranch is now counterclockwise in direction for bikes. Enjoy! #boco_trails https://t.co/…
    2018-05-21 17:37:55 RT @RangerGrady: The Overland Loop at # Heil Valley Ranch is now counterclockwise in direction for bikes. Enjoy! #boco_trails https://t.co/…
    2018-05-21 17:37:21 The Overland Loop at # Heil Valley Ranch is now counterclockwise in direction for bikes. Enjoy! #boco_trails https://t.co/kmv9Epl100
    2018-05-21 08:51:54 RT @RangerGrady: Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #b…
    2018-05-21 01:24:37 RT @RangerGrady: Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #b…
    2018-05-20 22:10:15 RT @BoCo_trails: Report is that Heil and Hall are both pretty muddy today. #BoCo_trails
    2018-05-20 22:07:52 RT @RangerGrady: Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #b…
    2018-05-20 20:22:26 RT @RangerGrady: Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #b…
    2018-05-20 20:02:40 Report is that Heil and Hall are both pretty muddy today. #BoCo_trails
    2018-05-20 19:52:22 RT @RangerGrady: Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #b…
    2018-05-20 19:33:11 RT @RangerGrady: Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #b…
    2018-05-20 18:54:06 Please avoid Picture Rock trail until it dries out. Thanks! #BoCo_trails https://t.co/ooSn3McRzW
    2018-05-20 18:49:45 RT @RangerGrady: Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #b…
    2018-05-20 18:48:48 Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #boco_trails



{:.input}
```python
q="#boco_trails -filter:retweets"
```


## Retweets

A retweet is when you or someone else shares someone elses tweet so your / their
followers can see it. It is similar to sharing in Facebook where you can add a
quote or text above the retweet if you want or just share the post. Let's use
the same query that you used above but this time ignore all retweets by adding -filer:retweets to your querry. 
The [twitter API documentation](https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/standard-operators) has information on other ways to customize your querries. 


{:.input}
```python
for tweet in tweepy.Cursor(api.search, q="#boco_trails -filter:retweets",
                           lang="en",
                           since="2018-05-20").items():
     print (tweet.created_at, tweet.text)
```

{:.output}
    2018-05-24 15:59:47 To help protect a coyote den &amp; young pups, OSMP has instituted leash restrictions on the Community Dtich East &amp; the… https://t.co/n4cCm37Q7Q
    2018-05-24 15:45:23 Like to ride Valmont Bike Park? Follow @bikevalmont for conditions updates! #BoCo_trails https://t.co/GBZxaBhPY4
    2018-05-24 15:35:44 Good news for your Wednesday afternoon. #boco_trails https://t.co/zwDzVWAjfB
    2018-05-24 03:51:40 @mtnbikechic @RangerFowler @boulderrunner @303cycling @BoulderCountyOS Everything is pretty much perfect except Val… https://t.co/VGMa1iI6vm
    2018-05-24 00:08:29 RAD squad 🚲🚲🚲🚲🐾 goals on the Aspen Alley trail in West Magnolia @usfsarp trail system near Nederland, CO. Jump line… https://t.co/NLJoh1Nb5N
    2018-05-23 22:56:44 Hall Ranch is dry and awesome!#boco_trails
    2018-05-23 22:21:54 Heads up #boco_trails users. https://t.co/aCdew6Vy84
    2018-05-23 20:06:18 Valmont is the bullseye for spring storms. #boco_trails https://t.co/Jg9kbirPUD
    2018-05-23 17:24:42 Trails in Marshall Mesa/Greenbelt Plateau, Doudy/Flatirons Vista/Springbrook areas are now open. Left Hand Trail re… https://t.co/oWmGwjpXOL
    2018-05-23 16:22:57 South Boulder / Marshall Mesa area trails are scheduled to reopen this afternoon (Wed). Picture Rock is riding grea… https://t.co/c7Aw0Kgdlp
    2018-05-23 01:25:55 @ErieSingletrack Trails are open, a little rain but it just made for even better conditions. #boco_trails
    2018-05-22 16:22:24 Hall, Heil, Walker and Betasso are all riding great. Marshall Mesa area trails still closed, but drying out nicely… https://t.co/T7NRWAccqj
    2018-05-21 23:28:44 Everything out of Lyons is in good shape and the higher ground is riding even better #boco_trails https://t.co/ByQOM4IJ0X
    2018-05-21 22:19:18 Hall report from Chris E.:
    Hall is riding really well right now. About 10 puddles on the rockgarden, ride thru them… https://t.co/WIv6RJLAMD
    2018-05-21 20:10:09 Hall Ranch in good shape. A few puddles in the rock garden, minimal mud on the north side of Nelson loop, and Antel… https://t.co/qE4NeVAguk
    2018-05-21 17:37:21 The Overland Loop at # Heil Valley Ranch is now counterclockwise in direction for bikes. Enjoy! #boco_trails https://t.co/kmv9Epl100
    2018-05-20 20:02:40 Report is that Heil and Hall are both pretty muddy today. #BoCo_trails
    2018-05-20 18:54:06 Please avoid Picture Rock trail until it dries out. Thanks! #BoCo_trails https://t.co/ooSn3McRzW
    2018-05-20 18:48:48 Picture Rock trail is muddy in sections, but not closed, please avoid.  Use Hall Ranch or other Heil trails. Thank you. #boco_trails



Next, you will learn who is tweeting about Boulder Open Space using the `#boco_trails` hashtag.

{:.input}
```python
for tweet in tweepy.Cursor(api.search, q="#boco_trails",
                           lang="en",
                           since="2018-05-20").items():
     print (tweet.user.screen_name)
```

{:.output}
    BoCo_trails
    boulderosmp
    boulderbma
    BoCo_trails
    boulderbma
    BoCo_trails
    boulderbma
    boulderbma
    mfbb1
    BoCo_trails
    BoCo_trails
    BoCo_trails
    boulderbma
    boulderosmp
    BoCo_trails
    BoCo_trails
    BoulderCountyOS
    boulderbma
    kathy_hix
    BoCo_trails
    boulderbma
    ColoradoGrass
    BoulderCountyOS
    BoulderCountyOS
    BoCo_trails
    boulderbma
    redstonecyclery
    BoCo_trails
    RangerFowler
    mfbb1
    BoCo_trails
    RangerVroman
    RangerGrady
    HolliPriciPRLN
    BoCo_trails
    boulderbma
    mudandcowbells
    RADBoulder
    BoCo_trails
    RangerHartnett
    RangerFowler
    boulderbma
    jfryarTC
    RangerGrady



{:.input}
```python
names = []
for tweet in tweepy.Cursor(api.search, q="#boco_trails",
                           lang="en",
                           since="2018-05-20").items():
    names.append(tweet.user.screen_name)      
```

{:.input}
```python
names
```

{:.output}
{:.execute_result}



    ['BoCo_trails',
     'boulderosmp',
     'boulderbma',
     'BoCo_trails',
     'boulderbma',
     'BoCo_trails',
     'boulderbma',
     'boulderbma',
     'mfbb1',
     'BoCo_trails',
     'BoCo_trails',
     'BoCo_trails',
     'boulderbma',
     'boulderosmp',
     'BoCo_trails',
     'BoCo_trails',
     'BoulderCountyOS',
     'boulderbma',
     'kathy_hix',
     'BoCo_trails',
     'boulderbma',
     'ColoradoGrass',
     'BoulderCountyOS',
     'BoulderCountyOS',
     'BoCo_trails',
     'boulderbma',
     'redstonecyclery',
     'BoCo_trails',
     'RangerFowler',
     'mfbb1',
     'BoCo_trails',
     'RangerVroman',
     'RangerGrady',
     'HolliPriciPRLN',
     'BoCo_trails',
     'boulderbma',
     'mudandcowbells',
     'RADBoulder',
     'BoCo_trails',
     'RangerHartnett',
     'RangerFowler',
     'boulderbma',
     'jfryarTC',
     'RangerGrady']





Learn a bit more about these people tweeting about boco trails. First, where are they from and what time zone are they tweeting from?

{:.input}
```python
locations = []
for tweet in tweepy.Cursor(api.search, q="#boco_trails",
                           lang="en",
                           since="2018-05-20").items():
    locations.append(tweet.user.location)      
```

{:.input}
```python
locations
```

{:.output}
{:.execute_result}



    ['Boulder County',
     'Boulder, Colorado',
     'Boulder, Colorado',
     'Boulder County',
     'Boulder, Colorado',
     'Boulder County',
     'Boulder, Colorado',
     'Boulder, Colorado',
     '',
     'Boulder County',
     'Boulder County',
     'Boulder County',
     'Boulder, Colorado',
     'Boulder, Colorado',
     'Boulder County',
     'Boulder County',
     'Boulder County Colorado',
     'Boulder, Colorado',
     '',
     'Boulder County',
     'Boulder, Colorado',
     'iPhone: 43.483170,-110.762939',
     'Boulder County Colorado',
     'Boulder County Colorado',
     'Boulder County',
     'Boulder, Colorado',
     'lyons, co',
     'Boulder County',
     'Boulder County, Colorado',
     '',
     'Boulder County',
     '',
     'Boulder, CO',
     'Boulder',
     'Boulder County',
     'Boulder, Colorado',
     'Boulder, CO',
     'Boulder, CO',
     'Boulder County',
     '',
     'Boulder County, Colorado',
     'Boulder, Colorado',
     '',
     'Boulder, CO']





{:.input}
```python
time_zones = []
for tweet in tweepy.Cursor(api.search, q="#boco_trails",
                           lang="en",
                           since="2018-05-20").items():
   time_zones.append(tweet.user.time_zone)  
```

{:.input}
```python
time_zones
```

{:.output}
{:.execute_result}



    [None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None,
     None]





## Putting Data from Twitter into `Pandas Dataframe`

Now you work with `pandas` to organize tweets from your API querry into a dataframe. 

{:.input}
```python
data = pd.DataFrame(data=[tweet.text for tweet in tweets], columns=['Tweets'])
```

{:.input}
```python
tweet_list = []
for tweet in tweepy.Cursor(api.search, q="#boco_trails",
                           lang="en",
                           since="2018-05-20").items():
  tweet_list.append(tweet) 
```

{:.input}
```python
len(tweet_list)
```

{:.output}
{:.execute_result}



    44





{:.input}
```python
def convert(tweet_l):
    df = pd.DataFrame()
    df['user'] = [tweet.user.name for tweet in tweet_l]
    df['text'] = [tweet.text for tweet in tweet_l]
    df['locations'] = [tweet.user.location for tweet in tweet_l]
    df['time_zone'] = [tweet.user.time_zone for tweet in tweet_l]
    return df
```

{:.input}
```python
df_boco_trails_tweets = convert(tweet_list)
```

{:.input}
```python
df_boco_trails_tweets.head()
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>user</th>
      <th>text</th>
      <th>locations</th>
      <th>time_zone</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Boulder Co. Trails</td>
      <td>RT @boulderosmp: To help protect a coyote den ...</td>
      <td>Boulder County</td>
      <td>None</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Boulder OSMP</td>
      <td>To help protect a coyote den &amp;amp; young pups,...</td>
      <td>Boulder, Colorado</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Boulder MTB Alliance</td>
      <td>Like to ride Valmont Bike Park? Follow @bikeva...</td>
      <td>Boulder, Colorado</td>
      <td>None</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Boulder Co. Trails</td>
      <td>Good news for your Wednesday afternoon. #boco_...</td>
      <td>Boulder County</td>
      <td>None</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Boulder MTB Alliance</td>
      <td>RT @BoCo_trails: @mtnbikechic @RangerFowler @b...</td>
      <td>Boulder, Colorado</td>
      <td>None</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
api.rate_limit_status()['resources']['search']
```

{:.output}
{:.execute_result}



    {'/search/tweets': {'limit': 180, 'remaining': 113, 'reset': 1527192818}}





{:.input}
```python
In the next lesson you will dive deeper into the art of "text-mining" to extract
information about a particular topic from twitter.


<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://docs.tweepy.org/en/v3.6.0/index.html" target="_blank">Tweepy Documentation</a>
*
*


</div>
```
