---
layout: single
title: "Social Media Data"
excerpt: "This lesson will discuss how social media data are used in science."
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-04-18'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/social-media/
nav-title: "Social media intro"
module-title: "Intro to Social Media Data in R"
module-description: "Coming soon. "
module-nav-title: 'twitter APIs'
module-type: 'class'
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

*

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>


## Social media data in science

Social media data typically describes information created and curated by
individual users and collected using public platforms. These public platforms
include social media networks like Twitter, Facebook, Snapchat and Instagram but
also could be crowd sourced data including Yelp, Zillow and others.

Social media data can be a powerful source of information given it *can* provide
a near real-time outlook on both social processes such as politics, and current
day events and also natural processes including weather events (tornados, rainfall,
snow), disturbances (floods, and other natural disasters) and more.

There are many challenges associated with working social media data.

1. Text mining: because social media data are often a combination of text, graphics and videos, there is a significant text mining component involved - where you are trying to find information about something in non-standard text.
2. Geolocation: Not all social media is geolocated so it's often tricky to figure
out where the data are coming from.

###
Something about the volumne of data produced by social media platforms and twitter.


### twitter

This week, we are going to look at the use of <a href="http://twitter.com" target="_blank">Twitter</a> as a source of information
to better understand the impacts of weather and disturbance events on people.

> Twitter is an online news and social networking service where users post and interact with messages, "tweets," restricted to 140 characters. Registered users can post tweets, but those who are unregistered can only read them. - Source: wikipedia


Remember that last week we explored data access using API's. Twitter has an API
which allows you to access everyone's tweets. The API has certain limitations including:

1. **You can only access tweets from the last 6-9 days:** This means that you need
to think ahead if you want to collect tweets for a particular event.
2. others...

### Twitter data access in R

Lucky for us, there are several R packages that can be used to collect tweets
from the twitter API. These include:

* `twitteR`
* `rtweet`

`rtweet` is a newer package that facilitates importing twitter data into data.frames.
This package is becoming the standard tool to access twitter data and thus we will
use it in our class this week!


Getting Started
========================================================

- We'll start by querying Twitter's API for a few different query types
- Building on this, we'll conduct some (very basic) analysis
- We'll finish with basic web-mapping similar to previous examples
<center>
[![Twitter Heat Map -- $%^& You!](http://www.socialmatt.com/wp-content/uploads/2015/03/Boulder_Twitter_Map_Visualizations.jpg)](http://www.socialmatt.com/amazing-denver-twitter-visualization/)
</center>

Lots of Setup...
========================================================

1. Log into the [Twitter Developers section](https://dev.twitter.com/)
    - If you have a Twitter account, you can login with those credentials
2. Go to [Create an app](Create an app)
    - Fill in details of the app you'll be using to connect
    - Name should be unique: I used "CarsonResearch"
3. Click on "Create your Twitter application"
    - Details of app are shown along with *consumer key* and *consumer secret*
4. You'll need access tokens
    - Scroll down and click "Create my access token"
    - Page should refresh on "Details" tab with new access tokens

Some More Setup...
========================================================

- Now that we have those details, we need to tell the `twitteR` package to use our credentials when making queries:


```r
library(twitteR)

# Setup authorization codes/secrets
consumer_key = "l0ong_@lph@_num3r1C_k3y"
consumer_secret = "l0ong_@lph@_num3r1C_s3cr37"
access_token = "l0ong_@lph@_num3r1C_t0k3n"
access_secret = "l0ong_@lph@_num3r1C_s3cr37"

# Authorization 'hand-off'
setup_twitter_oauth(consumer_key, consumer_secret,
                    access_token, access_secret)
```



Time to Start Querying
========================================================

- Let's query for the 100 most recent 'forest fire' tweets:


```r
query <- "forest+fire"
fire_tweets <- searchTwitter(query, n=100, lang="en",
                            resultType="recent")
```

- How about all recent tweets around Boulder (within 10 miles)?


```r
# About the center of Boulder... give or take
geocode <- '40.0150,-105.2705,50mi'
tweets <- searchTwitter("", n=1000, lang="en",
                       geocode=geocode,
                       resultType="recent")
head(tweets)
## [[1]]
## [1] "DesertLover46: @PamilaJastrebs3 Thanks for the follow"
## 
## [[2]]
## [1] "dfc: I posted a new photo to Facebook https://t.co/sDUd8Fgh4e"
## 
## [[3]]
## [1] "Restrantek: RT @ulalaunch: Fun Fact: ULA and our heritage rockets have launched many of the Tracking and Data Relay Satellites tracking this mission #A…"
## 
## [[4]]
## [1] "bagpiper1980: RT @tamcohen: If you don't vote, you can't complain about the result. Here's the link: https://t.co/KPa426RgfX"
## 
## [[5]]
## [1] "Nycki_o: She like didn't understand it so naturally my dick self was like, \"it's because they don't care whether they pass or fail in that class\""
## 
## [[6]]
## [1] "tjfrane: RT @Vista_lacrosse: Huge top 3 matchup tomorrow night 6pm at Regis! https://t.co/r5lUVqjkAI"

# returns a nice data frame
tweets_2 <- search_tweets("", n=1000, lang="en",
              geocode = '40.0150,-105.2705,50mi',
              include_rts = FALSE)
## Searching for tweets...
## Finished collecting tweets!
tweets_2
##         screen_name            user_id          created_at
## 1         enviroish         2508784110 2017-04-18 15:30:42
## 2    mybookshepherd          118853353 2017-04-18 15:30:42
## 3      Kent_Systems           22943922 2017-04-18 15:30:42
## 4          NJHealth           18309666 2017-04-18 15:30:42
## 5   ChristineYJones           32488304 2017-04-18 15:30:42
## 6              aorn           17873356 2017-04-18 15:30:41
## 7          PR_Heath           26243058 2017-04-18 15:30:41
## 8        DENAirport           59256282 2017-04-18 15:30:41
## 9        Car_Guy_CO 740356629741359104 2017-04-18 15:30:41
## 10        0scaRoyal 851303963441934337 2017-04-18 15:30:41
## 11         mcsaxman            6839912 2017-04-18 15:30:41
## 12    VigarooDenver 831975701339373568 2017-04-18 15:30:40
## 13     laceyryckman          352092106 2017-04-18 15:30:40
## 14        trendypet             876681 2017-04-18 15:30:40
## 15   DenPublicWorks           19548166 2017-04-18 15:30:40
## 16           MPIRMC           47043690 2017-04-18 15:30:39
## 17     KendraLeeKLA           39599450 2017-04-18 15:30:39
## 18          Nycki_o 829932562789199875 2017-04-18 15:30:38
## 19     Burgundywave          174441685 2017-04-18 15:30:38
## 20   MileHighSports           26130423 2017-04-18 15:30:37
## 21     RAYMONDB4646         1589842530 2017-04-18 15:30:37
## 22        GrowPi_v1 841094307280953344 2017-04-18 15:30:37
## 23    goddessgarden           16148780 2017-04-18 15:30:37
## 24      SloansTandB         3279751760 2017-04-18 15:30:36
## 25        dohertyjf           17582682 2017-04-18 15:30:36
## 26         Jonique5          443099111 2017-04-18 15:30:36
## 27     MyFedTrainer          493661598 2017-04-18 15:30:36
## 28         EdMcNeal          160602594 2017-04-18 15:30:34
##              status_id
## 1   854356522566123520
## 2   854356522473836544
## 3   854356520527679488
## 4   854356520087191552
## 5   854356519676260353
## 6   854356518946340864
## 7   854356518036271105
## 8   854356517700739074
## 9   854356517197418496
## 10  854356517088374785
## 11  854356516379480065
## 12  854356514785636353
## 13  854356514596823041
## 14  854356514122891265
## 15  854356513464487938
## 16  854356509576355842
## 17  854356508955598849
## 18  854356504769576960
## 19  854356502814932992
## 20  854356502001442818
## 21  854356500764123136
## 22  854356499400761344
## 23  854356498251698177
## 24  854356496259440641
## 25  854356495323901953
## 26  854356495198179328
## 27  854356494548185088
## 28  854356489275928576
##                                                                                                                                                                                                       text
## 1                                                                                     Depending on where you live, you can cut your annual energy bill by... @EPA @realdonaldtrump https://t.co/UJDxLynufl
## 2                                                                                                        Every #author needs how to create a #book #publishing foundation-podcast: https://t.co/XlDMXWl5hq
## 3                                                                                                                                      Everyone loves LEGOs. https://t.co/b3mSoM7WBN #lego #plastic #video
## 4                                                              Ready to quit #tobacco? To be successful, you need a quit plan. Get help from our experts. https://t.co/eLXlk7WKXc #quitsmokingtips #health
## 5                                                              ChildrensMinMag: Need help finding and selecting your VBS for amazing outreach this summer? Click here for 15 opti… https://t.co/KLZqBqutpc
## 6                                                                FREE Continuing Education Webinar: Lessons from an Outbreak Investigation. Register here https://t.co/uCR4ukgI9B… https://t.co/vhUtJTX2we
## 7                                                             Another record month in Feb w/ 4.2 million passenger! That's the 18th consecutive month of year-over-year traffic i… https://t.co/xcLUqV1QMN
## 8                                                             Another record month in Feb w/ 4.2 million passenger! That's the 18th consecutive month of year-over-year traffic i… https://t.co/8D4ZjGEMTd
## 9                                                                                                                      What’s the best Porsche Panamera? It’s a plug-in hybrid now https://t.co/ZOfRcvG55D
## 10                                                                                                                                                          I'm not feeling it today, honestly. \U0001f4af
## 11                                                                      @ApostropheHC - we both made @9NEWS this morning: https://t.co/8sVkYP9MLL\n\nGood luck tomorrow at Demo Day.  #techstars  #DemoDay
## 12                                                                A disappointing debut for Samsung’s smart assistant, Bixby  #DIA #VCinvesting #COS #jobs https://t.co/sm230QmBvb https://t.co/JsEzOip3g1
## 13                                                                                                                                                                      nasal spray is my best good friend
## 14                                                             Do you have a senior pet ?Join the NEW Senior Dog FB support group and collaborate today!  #dogs #pets #seniorpets… https://t.co/rs0L8CFCvm
## 15                                                                             Let Paul show you how street sweeping helps keep Denver's streets, air and water clean! https://t.co/shT0Bei9hr #TuesdayTip
## 16                                                               There's still time to meet us in #vail for @mpirmc #RoadTrip 4.23.17 - C U THERE! #mpirmc https://t.co/2yh2kKWMQn https://t.co/JFy99eMmy6
## 17                                                                    Why you don't rank on @Google and how to fix it. Learn simple strategies to implement now. #webinar on 4/21… https://t.co/wCwIgee6Mt
## 18                                                                                                                                                      Kara thinks I should make dick quotes on Pinterest
## 19                                                                             @richardterry85 @rapidsrabbi I didn't say we weren't at the bottom, I'm just pointing out that it's not quite comparable ;)
## 20                                                                                                     ICYMI: Former Steelers wide receiver Emmanuel Sanders remembers Dan Rooney\nhttps://t.co/Y3XtpBtOxb
## 21                                                                                                           @BrookeWagnerTV @chrisparente I just watched #RogueOne yesterday I can't wait for the new one
## 22                                                            |Blue| | LIGHT: 7644LUX | TEMP ZONE A: 18.0C/72.0F | HUM: 25.0% | UV INDEX: 0.0 | IR: 0um | TEMP ZONE B: 19.0C/67.0… https://t.co/bHqieMQumx
## 23                                                                                                                                         For #EarthWeek, the Lorax said it best. https://t.co/MsSYUGEkw4
## 24                                                                                                        Chef's Bison back ribs with red cabbage slaw &amp; beans #NewMenuTasting https://t.co/n08DD6Njxv
## 25                                                                                                  Part of me craves this. Part of me thinks it's absurd. https://t.co/EaYSbHO5ni https://t.co/PtsdcunpKk
## 26                                                                                                                                 #sexy nipple bars oral sex and std transmission https://t.co/b15k10oxwI
## 27                                                                @Grant_Chat @Grant_Hub I'll have to check out the recap. Heading to Washington DC to speak at the #ngma2017 conference. Happy #grantchat
## 28                                                                                                                                                               Color me shocked. https://t.co/nkRADB10eh
##     retweet_count favorite_count is_quote_status    quote_status_id
## 1               0              0           FALSE               <NA>
## 2               0              0           FALSE               <NA>
## 3               0              0           FALSE               <NA>
## 4               0              0           FALSE               <NA>
## 5               0              0           FALSE               <NA>
## 6               0              0           FALSE               <NA>
## 7               0              0           FALSE               <NA>
## 8               0              0           FALSE               <NA>
## 9               0              0           FALSE               <NA>
## 10              0              0           FALSE               <NA>
## 11              0              0           FALSE               <NA>
## 12              0              0           FALSE               <NA>
## 13              0              0           FALSE               <NA>
## 14              0              0           FALSE               <NA>
## 15              0              0           FALSE               <NA>
## 16              0              0           FALSE               <NA>
## 17              0              0           FALSE               <NA>
## 18              0              0           FALSE               <NA>
## 19              0              0           FALSE               <NA>
## 20              0              0           FALSE               <NA>
## 21              0              0           FALSE               <NA>
## 22              0              0           FALSE               <NA>
## 23              0              0           FALSE               <NA>
## 24              0              0           FALSE               <NA>
## 25              0              0           FALSE               <NA>
## 26              0              0           FALSE               <NA>
## 27              0              0           FALSE               <NA>
## 28              0              0            TRUE 854353870977462274
##     is_retweet retweet_status_id in_reply_to_status_status_id
## 1        FALSE              <NA>                         <NA>
## 2        FALSE              <NA>                         <NA>
## 3        FALSE              <NA>                         <NA>
## 4        FALSE              <NA>                         <NA>
## 5        FALSE              <NA>                         <NA>
## 6        FALSE              <NA>                         <NA>
## 7        FALSE              <NA>                         <NA>
## 8        FALSE              <NA>                         <NA>
## 9        FALSE              <NA>                         <NA>
## 10       FALSE              <NA>                         <NA>
## 11       FALSE              <NA>                         <NA>
## 12       FALSE              <NA>                         <NA>
## 13       FALSE              <NA>                         <NA>
## 14       FALSE              <NA>                         <NA>
## 15       FALSE              <NA>                         <NA>
## 16       FALSE              <NA>                         <NA>
## 17       FALSE              <NA>                         <NA>
## 18       FALSE              <NA>           854356436863799296
## 19       FALSE              <NA>           854356157779111937
## 20       FALSE              <NA>                         <NA>
## 21       FALSE              <NA>           854355883249332224
## 22       FALSE              <NA>                         <NA>
## 23       FALSE              <NA>                         <NA>
## 24       FALSE              <NA>                         <NA>
## 25       FALSE              <NA>                         <NA>
## 26       FALSE              <NA>                         <NA>
## 27       FALSE              <NA>           854330933838852096
## 28       FALSE              <NA>                         <NA>
##     in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                         <NA>                           <NA>   en
## 2                         <NA>                           <NA>   en
## 3                         <NA>                           <NA>   en
## 4                         <NA>                           <NA>   en
## 5                         <NA>                           <NA>   en
## 6                         <NA>                           <NA>   en
## 7                         <NA>                           <NA>   en
## 8                         <NA>                           <NA>   en
## 9                         <NA>                           <NA>   en
## 10                        <NA>                           <NA>   en
## 11          702632613337366528                   ApostropheHC   en
## 12                        <NA>                           <NA>   en
## 13                        <NA>                           <NA>   en
## 14                        <NA>                           <NA>   en
## 15                        <NA>                           <NA>   en
## 16                        <NA>                           <NA>   en
## 17                        <NA>                           <NA>   en
## 18          829932562789199875                        Nycki_o   en
## 19                    64559204                 richardterry85   en
## 20                        <NA>                           <NA>   en
## 21                   469357880                 BrookeWagnerTV   en
## 22                        <NA>                           <NA>   en
## 23                        <NA>                           <NA>   en
## 24                        <NA>                           <NA>   en
## 25                        <NA>                           <NA>   en
## 26                        <NA>                           <NA>   en
## 27                  2493472075                     Grant_Chat   en
## 28                        <NA>                           <NA>   en
##                                      source           media_id
## 1                                 Hootsuite               <NA>
## 2                                 Hootsuite               <NA>
## 3                                 Hootsuite               <NA>
## 4                                 Hootsuite               <NA>
## 5                                     IFTTT 854356472645300226
## 6                                 Hootsuite               <NA>
## 7                                 Hootsuite               <NA>
## 8                                 Hootsuite               <NA>
## 9                             WordPress.com               <NA>
## 10                       Twitter for iPhone               <NA>
## 11                                TweetDeck               <NA>
## 12           vigaroo to vigaroodenver posts 854356512319340544
## 13                       Twitter for iPhone               <NA>
## 14                               Meet Edgar               <NA>
## 15                                Hootsuite               <NA>
## 16                                Hootsuite 854356506971701248
## 17                                Hootsuite               <NA>
## 18                       Twitter for iPhone               <NA>
## 19                       Twitter Web Client               <NA>
## 20                                Hootsuite               <NA>
## 21                      Twitter for Android               <NA>
## 22                                   GrowPi               <NA>
## 23                                Hootsuite 854356496108408832
## 24                       Twitter for iPhone 854356488537522178
## 25                       Twitter Web Client 854356487677722624
## 26                       Twitter Web Client 854211081211973633
## 27                      Twitter for Android               <NA>
## 28                       Twitter for iPhone               <NA>
##                                                                                  media_url
## 1                                                                                     <NA>
## 2                                                                                     <NA>
## 3                                                                                     <NA>
## 4                                                                                     <NA>
## 5                                           http://pbs.twimg.com/media/C9tIr2-UMAIXeTJ.jpg
## 6                                                                                     <NA>
## 7                                                                                     <NA>
## 8                                                                                     <NA>
## 9                                                                                     <NA>
## 10                                                                                    <NA>
## 11                                                                                    <NA>
## 12                                          http://pbs.twimg.com/media/C9tIuKxWAAA-akm.jpg
## 13                                                                                    <NA>
## 14                                                                                    <NA>
## 15                                                                                    <NA>
## 16                                          http://pbs.twimg.com/media/C9tIt22XgAA-h2p.jpg
## 17                                                                                    <NA>
## 18                                                                                    <NA>
## 19                                                                                    <NA>
## 20                                                                                    <NA>
## 21                                                                                    <NA>
## 22                                                                                    <NA>
## 23                                          http://pbs.twimg.com/media/C9tItOYW0AAukvj.jpg
## 24                                          http://pbs.twimg.com/media/C9tIsyLUQAIzDdW.jpg
## 25                                          http://pbs.twimg.com/media/C9tIsu-UwAAYgKW.jpg
## 26  http://pbs.twimg.com/ext_tw_video_thumb/854211081211973633/pu/img/SX1aXs_lE6hXyfkr.jpg
## 27                                                                                    <NA>
## 28                                                                                    <NA>
##                                                        media_url_expanded
## 1                                                                    <NA>
## 2                                                                    <NA>
## 3                                                                    <NA>
## 4                                                                    <NA>
## 5   https://twitter.com/ChildrensMinMag/status/854356474721599488/photo/1
## 6                                                                    <NA>
## 7                                                                    <NA>
## 8                                                                    <NA>
## 9                                                                    <NA>
## 10                                                                   <NA>
## 11                                                                   <NA>
## 12    https://twitter.com/VigarooDenver/status/854356514785636353/photo/1
## 13                                                                   <NA>
## 14                                                                   <NA>
## 15                                                                   <NA>
## 16           https://twitter.com/MPIRMC/status/854356509576355842/photo/1
## 17                                                                   <NA>
## 18                                                                   <NA>
## 19                                                                   <NA>
## 20                                                                   <NA>
## 21                                                                   <NA>
## 22                                                                   <NA>
## 23    https://twitter.com/goddessgarden/status/854356498251698177/photo/1
## 24      https://twitter.com/SloansTandB/status/854356496259440641/photo/1
## 25        https://twitter.com/dohertyjf/status/854356495323901953/photo/1
## 26  https://twitter.com/UblOwNeo6279GrE/status/854211250942881792/video/1
## 27                                                                   <NA>
## 28                                                                   <NA>
##     urls                                                    urls_display
## 1   <NA>                                               ow.ly/xHWW30aUGpx
## 2   <NA>                                               ow.ly/8zYo30anK4K
## 3   <NA>                                               ow.ly/qJvi30aUOQq
## 4   <NA>                                               ow.ly/mGAt30aQgzt
## 5   <NA>                                                            <NA>
## 6   <NA>                      bit.ly/2ptHYbn twitter.com/i/web/status/8…
## 7   <NA>                                     twitter.com/i/web/status/8…
## 8   <NA>                                     twitter.com/i/web/status/8…
## 9   <NA>             automotivereviewsblog.wordpress.com/2017/04/18/wha…
## 10  <NA>                                                            <NA>
## 11  <NA>                                              on9news.tv/2nZppyV
## 12  <NA>                                                   goo.gl/Y1TYEd
## 13  <NA>                                                            <NA>
## 14  <NA>                                     twitter.com/i/web/status/8…
## 15  <NA>                                               ow.ly/VECn30aV9xS
## 16  <NA>                                               ow.ly/MhhD30aVm93
## 17  <NA>                                     twitter.com/i/web/status/8…
## 18  <NA>                                                            <NA>
## 19  <NA>                                                            <NA>
## 20  <NA>                              milehighsports.com/former-steeler…
## 21  <NA>                                                            <NA>
## 22  <NA>                                     twitter.com/i/web/status/8…
## 23  <NA>                                                            <NA>
## 24  <NA>                                                            <NA>
## 25  <NA>                                   newyorker.com/magazine/2017/…
## 26  <NA>                                                            <NA>
## 27  <NA>                                                            <NA>
## 28  <NA>                                     twitter.com/noladefender/s…
##                                                                                                                                                                                                                                                                                                                                                                                                                     urls_expanded
## 1                                                                                                                                                                                                                                                                                                                                                                                                        http://ow.ly/xHWW30aUGpx
## 2                                                                                                                                                                                                                                                                                                                                                                                                        http://ow.ly/8zYo30anK4K
## 3                                                                                                                                                                                                                                                                                                                                                                                                        http://ow.ly/qJvi30aUOQq
## 4                                                                                                                                                                                                                                                                                                                                                                                                        http://ow.ly/mGAt30aQgzt
## 5                                                                                                                                                                                                                                                                                                                                                                                                                            <NA>
## 6                                                                                                                                                                                                                                                                                                                                                       http://bit.ly/2ptHYbn https://twitter.com/i/web/status/854356518946340864
## 7                                                                                                                                                                                                                                                                                                                                                                             https://twitter.com/i/web/status/854356518036271105
## 8                                                                                                                                                                                                                                                                                                                                                                             https://twitter.com/i/web/status/854356517700739074
## 9                                                                                                                                                                                                                                                                                                                 https://automotivereviewsblog.wordpress.com/2017/04/18/whats-the-best-porsche-panamera-its-a-plug-in-hybrid-now
## 10                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 11                                                                                                                                                                                                                                                                                                                                                                                                      http://on9news.tv/2nZppyV
## 12                                                                                                                                                                                                                                                                                                                                                                                                           http://goo.gl/Y1TYEd
## 13                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 14                                                                                                                                                                                                                                                                                                                                                                            https://twitter.com/i/web/status/854356514122891265
## 15                                                                                                                                                                                                                                                                                                                                                                                                       http://ow.ly/VECn30aV9xS
## 16                                                                                                                                                                                                                                                                                                                                                                                                       http://ow.ly/MhhD30aVm93
## 17                                                                                                                                                                                                                                                                                                                                                                            https://twitter.com/i/web/status/854356508955598849
## 18                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 19                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 20                                                                                                                                                                                                                                                                                                                                 http://milehighsports.com/former-steelers-wide-receiver-emmanuel-sanders-remembers-dan-rooney/
## 21                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 22                                                                                                                                                                                                                                                                                                                                                                            https://twitter.com/i/web/status/854356499400761344
## 23                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 24                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 25                                                                                                                                                                                                                                                                                        http://www.newyorker.com/magazine/2017/04/24/vanlife-the-bohemian-social-media-movement?mbid=synd_digg&utm_source=digg&utm_medium=email
## 26                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 27                                                                                                                                                                                                                                                                                                                                                                                                                           <NA>
## 28                                                                                                                                                                                                                                                                                                                                                                     https://twitter.com/noladefender/status/854353870977462274
##                                                                                           mentions_screen_name
## 1                                                                                          EPA realDonaldTrump
## 2                                                                                                         <NA>
## 3                                                                                                         <NA>
## 4                                                                                                         <NA>
## 5                                                                                                         <NA>
## 6                                                                                                         <NA>
## 7                                                                                                         <NA>
## 8                                                                                                         <NA>
## 9                                                                                                         <NA>
## 10                                                                                                        <NA>
## 11                                                                                          ApostropheHC 9NEWS
## 12                                                                                                        <NA>
## 13                                                                                                        <NA>
## 14                                                                                                        <NA>
## 15                                                                                                        <NA>
## 16                                                                                                      MPIRMC
## 17                                                                                                      Google
## 18                                                                                                        <NA>
## 19                                                                                  richardterry85 rapidsrabbi
## 20                                                                                                        <NA>
## 21                                                                                 BrookeWagnerTV chrisparente
## 22                                                                                                        <NA>
## 23                                                                                                        <NA>
## 24                                                                                                        <NA>
## 25                                                                                                        <NA>
## 26                                                                                                        <NA>
## 27                                                                                        Grant_Chat Grant_Hub
## 28                                                                                                        <NA>
##                                                                             mentions_user_id
## 1                                                                          14615871 25073877
## 2                                                                                       <NA>
## 3                                                                                       <NA>
## 4                                                                                       <NA>
## 5                                                                                       <NA>
## 6                                                                                       <NA>
## 7                                                                                       <NA>
## 8                                                                                       <NA>
## 9                                                                                       <NA>
## 10                                                                                      <NA>
## 11                                                               702632613337366528 19032473
## 12                                                                                      <NA>
## 13                                                                                      <NA>
## 14                                                                                      <NA>
## 15                                                                                      <NA>
## 16                                                                                  47043690
## 17                                                                                  20536157
## 18                                                                                      <NA>
## 19                                                                       64559204 2602681358
## 20                                                                                      <NA>
## 21                                                                        469357880 15957671
## 22                                                                                      <NA>
## 23                                                                                      <NA>
## 24                                                                                      <NA>
## 25                                                                                      <NA>
## 26                                                                                      <NA>
## 27                                                                     2493472075 2849302196
## 28                                                                                      <NA>
##            symbols
## 1             <NA>
## 2             <NA>
## 3             <NA>
## 4             <NA>
## 5             <NA>
## 6             <NA>
## 7             <NA>
## 8             <NA>
## 9             <NA>
## 10            <NA>
## 11            <NA>
## 12            <NA>
## 13            <NA>
## 14            <NA>
## 15            <NA>
## 16            <NA>
## 17            <NA>
## 18            <NA>
## 19            <NA>
## 20            <NA>
## 21            <NA>
## 22            <NA>
## 23            <NA>
## 24            <NA>
## 25            <NA>
## 26            <NA>
## 27            <NA>
## 28            <NA>
##                                                                   hashtags
## 1                                                                     <NA>
## 2                                                   author book publishing
## 3                                                       lego plastic video
## 4                                           tobacco quitsmokingtips health
## 5                                                                     <NA>
## 6                                                                     <NA>
## 7                                                                     <NA>
## 8                                                                     <NA>
## 9                                                                     <NA>
## 10                                                                    <NA>
## 11                                                       techstars DemoDay
## 12                                                DIA VCinvesting COS jobs
## 13                                                                    <NA>
## 14                                                    dogs pets seniorpets
## 15                                                              TuesdayTip
## 16                                                    vail RoadTrip mpirmc
## 17                                                                 webinar
## 18                                                                    <NA>
## 19                                                                    <NA>
## 20                                                                    <NA>
## 21                                                                RogueOne
## 22                                                                    <NA>
## 23                                                               EarthWeek
## 24                                                          NewMenuTasting
## 25                                                                    <NA>
## 26                                                                    sexy
## 27                                                      ngma2017 grantchat
## 28                                                                    <NA>
##     coordinates         place_id place_type        place_name
## 1            NA             <NA>       <NA>              <NA>
## 2            NA             <NA>       <NA>              <NA>
## 3            NA             <NA>       <NA>              <NA>
## 4            NA             <NA>       <NA>              <NA>
## 5            NA             <NA>       <NA>              <NA>
## 6            NA             <NA>       <NA>              <NA>
## 7            NA             <NA>       <NA>              <NA>
## 8            NA             <NA>       <NA>              <NA>
## 9            NA             <NA>       <NA>              <NA>
## 10           NA             <NA>       <NA>              <NA>
## 11           NA             <NA>       <NA>              <NA>
## 12           NA             <NA>       <NA>              <NA>
## 13           NA b49b3053b5c25bf5       city            Denver
## 14           NA             <NA>       <NA>              <NA>
## 15           NA             <NA>       <NA>              <NA>
## 16           NA             <NA>       <NA>              <NA>
## 17           NA             <NA>       <NA>              <NA>
## 18           NA             <NA>       <NA>              <NA>
## 19           NA             <NA>       <NA>              <NA>
## 20           NA             <NA>       <NA>              <NA>
## 21           NA             <NA>       <NA>              <NA>
## 22           NA             <NA>       <NA>              <NA>
## 23           NA             <NA>       <NA>              <NA>
## 24           NA b49b3053b5c25bf5       city            Denver
## 25           NA             <NA>       <NA>              <NA>
## 26           NA             <NA>       <NA>              <NA>
## 27           NA             <NA>       <NA>              <NA>
## 28           NA             <NA>       <NA>              <NA>
##           place_full_name country_code       country
## 1                    <NA>         <NA>          <NA>
## 2                    <NA>         <NA>          <NA>
## 3                    <NA>         <NA>          <NA>
## 4                    <NA>         <NA>          <NA>
## 5                    <NA>         <NA>          <NA>
## 6                    <NA>         <NA>          <NA>
## 7                    <NA>         <NA>          <NA>
## 8                    <NA>         <NA>          <NA>
## 9                    <NA>         <NA>          <NA>
## 10                   <NA>         <NA>          <NA>
## 11                   <NA>         <NA>          <NA>
## 12                   <NA>         <NA>          <NA>
## 13             Denver, CO           US United States
## 14                   <NA>         <NA>          <NA>
## 15                   <NA>         <NA>          <NA>
## 16                   <NA>         <NA>          <NA>
## 17                   <NA>         <NA>          <NA>
## 18                   <NA>         <NA>          <NA>
## 19                   <NA>         <NA>          <NA>
## 20                   <NA>         <NA>          <NA>
## 21                   <NA>         <NA>          <NA>
## 22                   <NA>         <NA>          <NA>
## 23                   <NA>         <NA>          <NA>
## 24             Denver, CO           US United States
## 25                   <NA>         <NA>          <NA>
## 26                   <NA>         <NA>          <NA>
## 27                   <NA>         <NA>          <NA>
## 28                   <NA>         <NA>          <NA>
##                                                                        bounding_box_coordinates
## 1                                                                                          <NA>
## 2                                                                                          <NA>
## 3                                                                                          <NA>
## 4                                                                                          <NA>
## 5                                                                                          <NA>
## 6                                                                                          <NA>
## 7                                                                                          <NA>
## 8                                                                                          <NA>
## 9                                                                                          <NA>
## 10                                                                                         <NA>
## 11                                                                                         <NA>
## 12                                                                                         <NA>
## 13      -105.109815 -104.734372 -104.734372 -105.109815 39.614151 39.614151 39.812975 39.812975
## 14                                                                                         <NA>
## 15                                                                                         <NA>
## 16                                                                                         <NA>
## 17                                                                                         <NA>
## 18                                                                                         <NA>
## 19                                                                                         <NA>
## 20                                                                                         <NA>
## 21                                                                                         <NA>
## 22                                                                                         <NA>
## 23                                                                                         <NA>
## 24      -105.109815 -104.734372 -104.734372 -105.109815 39.614151 39.614151 39.812975 39.812975
## 25                                                                                         <NA>
## 26                                                                                         <NA>
## 27                                                                                         <NA>
## 28                                                                                         <NA>
##     bounding_box_type
## 1                <NA>
## 2                <NA>
## 3                <NA>
## 4                <NA>
## 5                <NA>
## 6                <NA>
## 7                <NA>
## 8                <NA>
## 9                <NA>
## 10               <NA>
## 11               <NA>
## 12               <NA>
## 13            Polygon
## 14               <NA>
## 15               <NA>
## 16               <NA>
## 17               <NA>
## 18               <NA>
## 19               <NA>
## 20               <NA>
## 21               <NA>
## 22               <NA>
## 23               <NA>
## 24            Polygon
## 25               <NA>
## 26               <NA>
## 27               <NA>
## 28               <NA>
##  [ reached getOption("max.print") -- omitted 971 rows ]
```

- Now what?

Working with Twitter Responses
========================================================

- We need to extract some properties from the tweets
  - Such as the Tweet content:
    
    ```r
    text <- sapply(tweets, function(x) x$getText())
    ```
  - And the Tweet location information:
    
    ```r
    # Grab lat/long and make data.frame out of it
    xy <- sapply(tweets, function(x) {
      as.numeric(c(x$getLongitude(),
                   x$getLatitude()))
      })
    xy[!sapply(xy, length)] = NA  # Empty coords get NA
    xy = as.data.frame(do.call("rbind", xy))
    ```
  - Next, we'll clean things up a bit...

Cleaning Things Up
========================================================

- Unfortunately, `R` isn't so great with emojis etc, so we'll strip these :(


```r
text = iconv(text, "ASCII", "UTF-8", sub="")
xy$text = text  # Add tweet text to data.frame
colnames(xy) = c("x", "y", "text")
```

- Next, we'll drop any rows that have missing (`NA`) coordinates


```r
xy = subset(xy, !is.na(x) & !is.na(y))
```

- Finally, some simple density estimation/plotting...


```r
m = ggplot(data=xy, aes(x=x, y=y)) +
  stat_density2d(geom="raster", aes(fill=..density..),
                 contour=FALSE, alpha=1) +
  geom_point() + coord_equal()
## Error in eval(expr, envir, enclos): could not find function "ggplot"
print(m)
## Error in print(m): object 'm' not found
```

Basic Mapping and Analysis
========================================================
title: false

<center>

```
## Error in eval(expr, envir, enclos): object 'm' not found
```
</center>

Adding Some Context...
========================================================

- Plotting on Stamen Terrain basemap provides useful context...


```r
# Create Boulder basemap (geocoding by name)
# NOTE: This doesn't work right now...
Boulder = get_map(location="Boulder, CO, USA",
                  source="stamen", maptype="terrain",
                  crop=FALSE, zoom=10)
# Create base ggmap
ggmap(Boulder) +
  # Start adding elements...
  geom_point(data=xy, aes(x, y), color="red",
             size=5, alpha=0.5) +
  stat_density2d(data=xy, aes(x, y, fill=..level..,
                              alpha=..level..),
                 size=0.01, bins=16, geom='polygon')
```

Twitter with Context
========================================================
title: false
<center>

</center>

Computing 'Clusters'
========================================================

- Or we can compute clusters 'on the fly', again using the powerful `leaflet` package:


```r
# URL for 'custom' icon
url = "http://steppingstonellc.com/wp-content/uploads/twitter-icon-620x626.png"
twitter = makeIcon(url, url, 32, 31)  # Create Icon!
## Error in eval(expr, envir, enclos): could not find function "makeIcon"

# How about auto-clustering?!
map = leaflet(xy) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=~x, lat=~y, popup=~text,
    clusterOptions=markerClusterOptions(),
    icon=twitter)
## Error in eval(expr, envir, enclos): could not find function "leaflet"
```

```
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```

Interactive Map of Twitter Data
========================================================
title: false

<iframe  title="Twitter Map" width="1100" height="900"
  src="./twitter_map.html"
  frameborder="0" allowfullscreen></iframe>

Going a Step Further
========================================================
type: section

It isn't really enough just to grab some web-data and start mapping. Afterall, this session is really about data integration---something web-data and APIs are particularly good for!

Heat Maps are NOT Enough...
========================================================

<center>
[![xkcd Heat Maps](http://imgs.xkcd.com/comics/heatmap.png)](http://xkcd.com/1138/)
</center>

Combining Tweets and Census Info
========================================================

- Let's take another look at our Census data (this time grabbing population counts for Boulder region)

```r
pop = acs.fetch(endyear=2014, span=5, geography=geo,
                table.number="B01003",
                col.names="pretty")
## Error in eval(expr, envir, enclos): could not find function "acs.fetch"
est = pop@estimate  # Grab the Total Population
## Error in eval(expr, envir, enclos): object 'pop' not found
# Create a new data.frame
pop = data.frame(geoid, est[, 1],
                 stringsAsFactors=FALSE)
## Error in data.frame(geoid, est[, 1], stringsAsFactors = FALSE): object 'geoid' not found
rownames(pop) = 1:nrow(inc)  # Rename rows
## Error in nrow(inc): object 'inc' not found
colnames(pop) = c("GEOID", "pop_total")  # Rename columns
## Error in colnames(pop) = c("GEOID", "pop_total"): object 'pop' not found
```
- Create the merged data.frame!

```r
merged = geo_join(tracts, pop, "GEOID", "GEOID")
## Error in eval(expr, envir, enclos): could not find function "geo_join"
```

Big Ol' Chunk of Leaflet Code
========================================================


```r
popup = paste0("GEOID: ", merged$GEOID,
               "<br/>Total Population: ",
               round(merged$pop_total, 2))
## Error in paste0("GEOID: ", merged$GEOID, "<br/>Total Population: ", round(merged$pop_total, : object 'merged' not found
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$pop_total)
## Error in eval(expr, envir, enclos): could not find function "colorNumeric"
map = leaflet() %>%  # Map time!
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data=merged, popup=popup,
              fillColor=~pal(pop_total),
              color="#b2aeae", # This is a 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2) %>%
  addCircles(data=xy, lng=~x, lat=~y,
             popup=~text, radius=5) %>%
  addLegend(pal=pal, values=merged$pop_total,
            position="bottomright",
            title="Total Population")
## Error in eval(expr, envir, enclos): could not find function "leaflet"
```


```
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```

Interactive Map of Twitter Data
========================================================
title: false

<iframe  title="Twitter Map" width="1100" height="900"
  src="./dual_map.html"
  frameborder="0" allowfullscreen></iframe>

Controlling for Population
========================================================

- That's all fine and good, but are areas with lots of tweets associated with areas of high population? Its hard to tell from the map...

```r
library(sp)
# Make the points a SpatialPointsDataFrame
coordinates(xy) = ~x+y
proj4string(xy) = CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0")
# Put the x/y data back into the data slot for later...
xy@data = as.data.frame(xy)
```
- And now we count 'points in polygon':

```r
overlay = over(xy, merged)
## Error in over(xy, merged): object 'merged' not found
res = as.data.frame(table(overlay$GEOID))
## Error in table(overlay$GEOID): object 'overlay' not found
colnames(res) = c("GEOID", "count")
## Error in colnames(res) = c("GEOID", "count"): object 'res' not found
```

Tweet Score?
========================================================

- We can then join counts back onto the counties:

```r
merged@data = join(merged@data, res, by="GEOID")
## Error in eval(expr, envir, enclos): could not find function "join"
# And compute a 'tweet score'... based on logged pop
merged$percapita = merged$count/log(merged$pop_total)
## Error in eval(expr, envir, enclos): object 'merged' not found
```
- Based on this new variable, we setup a new pallette:

```r
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$percapita)
## Error in eval(expr, envir, enclos): could not find function "colorNumeric"
# Also create a nice popup for display...
popup = paste0("GEOID: ", merged$GEOID, "<br>",
               "Score: ", round(merged$percapita, 2))
## Error in paste0("GEOID: ", merged$GEOID, "<br>", "Score: ", round(merged$percapita, : object 'merged' not found
```
- And we plot it!

Plotting the Tweets
========================================================
title: false


```
## Error in eval(expr, envir, enclos): could not find function "leaflet"
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```

<iframe  title="Twitter Map" width="1100" height="900"
  src="./final_map.html"
  frameborder="0" allowfullscreen></iframe>


Wanna See the Code for That One?
========================================================


```r
leaflet() %>%
  addProviderTiles("CartoDB.Positron", group="Base") %>%
  addPolygons(data=merged, popup=popup,
              fillColor=~pal(percapita),
              color="#b2aeae", # This is a 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2, group="Score") %>%
  addCircleMarkers(data=xy, lng=~x, lat=~y, radius=4,
                   stroke=FALSE, popup=~text,
                   group="Tweets") %>%
  addLayersControl(overlayGroups=c("Tweets", "Score"),
                   options=layersControlOptions(
                     collapsed=FALSE)) %>%
  addLegend(pal=pal, values=merged$percapita,
            position="bottomright",
            title="Score")
```

That's All Folks!
========================================================
type: section

## Data Harmonization + Working with Web and Social Media Data
Earth Analytics---Spring 2016

Carson J. Q. Farmer
[carson.farmer@colorado.edu]()

babs buttenfield
[babs@colorado.edu]()

References
========================================================
type: sub-section

- Most of the content in this tutorial was 'borrowed' from one of the following sources:
    - [Leaflet for `R`](https://rstudio.github.io/leaflet/)
    - [An Introduction to `R` for Spatial Analysis & Mapping](https://us.sagepub.com/en-us/nam/an-introduction-to-r-for-spatial-analysis-and-mapping/book241031)
    - [Manipulating and mapping US Census data in `R`](http://zevross.com/blog/2015/10/14/manipulating-and-mapping-us-census-data-in-r-using-the-acs-tigris-and-leaflet-packages-3/#census-data-the-hard-way)
- Data was courtesy of:
    - [Colorado Information Marketplace](https://data.colorado.gov)
    - [Twitter's API](https://dev.twitter.com/rest/public)
    - [US Census ACS 5-Year Data API](https://www.census.gov/data/developers/data-sets/acs-survey-5-year-data.html)

Want to Play Some More?
========================================================

- Check out the [EnviroCar API](http://envirocar.github.io/enviroCar-server/api/)
    - Data on vehicle trajectories annotated with CO^2 emmisions!
- [PHL API](http://phlapi.com)---Open Data for the City of Philly
- [NYC Open Data Portal](https://nycopendata.socrata.com)---Open Data for NYC
- [SF OpenData](https://data.sfgov.org)---Open Data for San Fran
- ... you get the point!

- In general, the [Programmable Web](http://www.programmableweb.com/) is a good resource
    - Here are [146 location APIs](http://www.programmableweb.com/news/146-location-apis-foursquare-panoramio-and-geocoder/2012/06/20) for example...
