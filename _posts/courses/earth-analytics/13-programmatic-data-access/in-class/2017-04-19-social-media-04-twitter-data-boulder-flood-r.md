---
layout: single
title: "Use tidytext to text mine social media - twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-15'
category: [courses]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/get-data-using-apis/use-colorado-flood-tweets-for-science-r/
nav-title: 'CO Flood Tweets'
week: 13
course: "earth-analytics"
module-type: 'class'
sidebar:
  nav:
author_profile: false
comments: true
order: 3
lang-lib:
  r: ['rtweet', 'tidytext', 'dplyr']
topics:
  social-science: ['social-media']
  data-exploration-and-analysis: ['text-mining']
---



{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Query the twitter RESTful API to access and import into R tweets that contain various text strings.
* Generate a list of users that are tweeting about a particular topic
* Use the tidytext package in R to explore and analyze word counts associated with tweets.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>



```r
# load twitter library - the rtweet library is recommended now over twitteR
library(rjson)
library(jsonlite)
# plotting and pipes - tidyverse!
library(ggplot2)
library(dplyr)
library(tidyr)
# text mining library
library(tidytext)
library(tm)
# coupled words analysis
library(widyr)
## Error in library(widyr): there is no package called 'widyr'
# plotting packages
library(igraph)
library(ggraph)

# animated maps
#devtools::install_github("dgrtwo/gganimate")
library(gganimate)
library(lubridate)
library(maps)
library(ggthemes)

options(stringsAsFactors = FALSE)
```





```r
# create file path
json_file <- "~/Documents/earth-analytics/data/week-13/boulder_flood_geolocated_tweets.json"
# import json file line by line to avoid syntax errors
# this takes a few seconds
boulder_flood_tweets <- stream_in(file(json_file))
##  Found 500 records... Found 1000 records... Found 1500 records... Found 2000 records... Found 2500 records... Found 3000 records... Found 3500 records... Found 4000 records... Found 4500 records... Found 5000 records... Found 5500 records... Found 6000 records... Found 6500 records... Found 7000 records... Found 7500 records... Found 8000 records... Found 8500 records... Found 9000 records... Found 9500 records... Found 10000 records... Found 10500 records... Found 11000 records... Found 11500 records... Found 12000 records... Found 12500 records... Found 13000 records... Found 13500 records... Found 14000 records... Found 14500 records... Found 15000 records... Found 15500 records... Found 16000 records... Found 16500 records... Found 17000 records... Found 17500 records... Found 18000 records... Found 18500 records... Found 18821 records... Imported 18821 records. Simplifying...
# explore the data
```

The structure of these data is complex. In this lesson we will just look at a 
few parts of the data to keep things a bit more simple. 


```r
# view the first 6 usernames 
head(boulder_flood_tweets$user$screen_name)
## [1] "lilcakes3209"    "coloradowx"      "ChelseaHider"    "jpreyes"        
## [5] "BoulderGreenSts" "RealMatSmith"
# create new df with just the tweet texts & usernames
tweet_data <- data.frame(date_time = boulder_flood_tweets$created_at,
                         username = boulder_flood_tweets$user$screen_name,
                         tweet_text = boulder_flood_tweets$text,
                         coords = boulder_flood_tweets$coordinates)
head(tweet_data)
##                        date_time        username
## 1 Tue Dec 31 07:14:22 +0000 2013    lilcakes3209
## 2 Tue Dec 31 18:49:31 +0000 2013      coloradowx
## 3 Mon Dec 30 20:29:20 +0000 2013    ChelseaHider
## 4 Mon Dec 30 23:02:29 +0000 2013         jpreyes
## 5 Wed Jan 01 06:12:15 +0000 2014 BoulderGreenSts
## 6 Mon Dec 30 21:05:27 +0000 2013    RealMatSmith
##                                                                                                                                     tweet_text
## 1                     Boom bitch get out the way! #drunk #islands #girlsnight  #BJs #hookah #zephyrs #boulder #marines… http://t.co/uYmu7c4o0x
## 2     @WeatherDude17 Not that revved up yet due to model inconsistency. I'd say 0-2" w/ a decent chance of &gt;1" #snow #COwx #weather #Denver
## 3                                                                                 Story of my life! \U0001f602 #boulder http://t.co/ZMfNKEl0xD
## 4 We're looking for the two who came to help a cyclist after a hit-and-run at 30th/Baseline ~11pm Dec 23rd #Boulder #CO http://t.co/zyk3FkB4og
## 5                                                          Happy New Year #Boulder !!!! What are some of your New Years resolutions this year?
## 6                                              @simon_Says_so Nearly 60 degrees in #Boulder today. Great place to live. http://t.co/cvAcbpDQTC
##   coords.type    coords.coordinates
## 1       Point  -118.10041, 34.14628
## 2        <NA>                  NULL
## 3       Point 0.1342981, 52.2250070
## 4        <NA>                  NULL
## 5       Point  144.98467, -37.80312
## 6        <NA>                  NULL
```

Next, let's clean up the data so that we can work with it. Below we

1. format the date field as a date/time field
2. we split the location information into 2 columns that are numeric (for mapping)


```r
#format = "%Y-%m-%d %H:%M:%s"
# flood start date sept 13 - 24 (end of incident)
start_date <- as.POSIXct('2013-09-13 00:00:00')
end_date <- as.POSIXct('2013-09-24 00:00:00')

# cleanup
tweet_data_cl <- tweet_data %>%
  mutate(coords.coordinates = gsub("\\)|c\\(", "", coords.coordinates),
         date_time = as.POSIXct(date_time, format = "%a %b %d %H:%M:%S +0000 %Y")) %>%
  separate(coords.coordinates, c("long", "lat"), sep = ", ") %>%
  mutate_at(c("lat", "long"), as.numeric)

min(tweet_data_cl$date_time)
## [1] "2013-09-12 04:01:27 MDT"
max(tweet_data_cl$date_time)
## [1] "2014-01-01 06:59:33 MST"
```

According to the incident report, the boulder flood officially started 
September 09 2013 and ended on the 24th. Let's next filter our data to just that 
time period. 


```r
# filter by time and remove URL's from the tweet. Note this uses regular expressions
flood_tweets <- tweet_data_cl  %>%
  filter(date_time >= start_date & date_time <= end_date ) %>%
  mutate(tweet_text = gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", "", tweet_text))
```



Let's create a map that shows the location of the tweets.


```r


world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map()

to_plot <- tweet_data_cl %>%
  na.omit()

world +
  geom_point(data = to_plot, aes(x = long, y = lat),
             colour = 'purple', alpha = .5) +
  scale_size_continuous(range = c(1, 8),
                        breaks = c(250, 500, 750, 1000)) +
  labs(title = "Tweet Locations During the Boulder Flood Event")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" />

We can animate this over time to see what was occuring day by day.
Note that this requires ImageMagick to be installed on your computer. 

If you are on a mac and have homebrew installed you can use

```
brew install imagemagick
```

If not, you can go here, 

https://www.imagemagick.org/script/index.php

to download it and install. 


```r
# summarize by day?
# perhaps round the lat long and then do it?
# since it's all in sept
to_plot_final <- to_plot %>%
  mutate(day = day(date_time),
         long_round = round(long, 2),
         lat_round = round(lat, 2)) %>%
  group_by(day,long_round, lat_round) %>%
  summarise(total_count = n())

# this also works -- plotting across the world here...
p <- world + geom_point(data = to_plot_final,
                        aes(long_round, lat_round, frame = day, size = total_count),
                        color = "purple", alpha = .5) + coord_fixed() +
  labs(title = "Twitter Activity during the 2013 Colorado Floods")
p
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" width="90%" />


## Animate Maps with GGAnimate

# embed gif image here

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/flood_tweets.gif">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/flood_tweets.gif" alt="Spatial extent.">
    </a>
    <figcaption>
    </figcaption>
</figure>



```r

gganimate(p, width = 22, height = 10, "data/week-13/flood_tweets.gif")

# this works
p <- ggplot(to_plot_final, aes(long_round, lat_round, frame = day, size = total_count), colour = 'purple') +
  geom_point() +
  borders("usa", colour = "gray85", fill = "gray80") +
  theme_map()
p
gganimate(p)

```

## Explore Common Words

Next do some text mining!
Let's have a look at some of the most popular words in the tweets during the event


```r
# get a list of words
flood_tweet_messages <- flood_tweets %>%
  dplyr::select(tweet_text) %>%
  unnest_tokens(word, tweet_text)
```



```r
# plot the top 15 words -- notice any issues?
flood_tweet_messages %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
      labs(x = "Count",
      y = "Unique words",
      title = "Count of unique words found in tweets")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="90%" />

## Remove Stop Words 

The plot above contains a lot "stop words". If you recall from the previous 
lesson, these are words like and, in and of that aren't useful to us as commonly 
used words. Rather, we'd like to focus on analysis on words that describe the flood
event itself. 



```r
data("stop_words")
nrow(flood_tweet_messages)
## [1] 136645

flood_tweet_clean <- flood_tweet_messages %>%
  anti_join(stop_words) %>%
  filter(!word == "rt")


nrow(flood_tweet_clean)
## [1] 80892
```


```r
# plot the top 15 words -- notice any issues?
flood_tweet_clean %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
      labs(x = "Count",
      y = "Unique words",
      title = "Count of unique words found in tweets")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-9-1.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="90%" />

Paired word analysis

1. probably remove all stop words from the


```r

#removeWords(str, stop_words$word)
flood_tweets_paired <- flood_tweets %>%
  dplyr::select(tweet_text) %>%
  mutate(tweet_text = removeWords(tweet_text, stop_words$word)) %>%
  mutate(tweet_text = gsub("\\brt\\b|\\bRT\\b", "", tweet_text)) %>%
  unnest_tokens(paired_words, tweet_text, token = "ngrams", n = 2)

#gsub("\\brt\\b", "", " rt mitchellbyars")


flood_tweets_paired %>%
  count(paired_words, sort = TRUE)
## # A tibble: 51,670 x 2
##            paired_words     n
##                   <chr> <int>
##  1         cowx coflood   360
##  2        boulder creek   273
##  3 boulderflood coflood   248
##  4         coflood cowx   162
##  5 coflood boulderflood   156
##  6       boulder county   130
##  7 boulder boulderflood   123
##  8         big thompson   113
##  9          flash flood   113
## 10    boulderflood cowx   110
## # ... with 51,660 more rows
```


```r
flood_tweets_separated <- flood_tweets_paired %>%
  separate(paired_words, c("word1", "word2"), sep = " ")

# new bigram counts:
flood_word_counts <- flood_tweets_separated %>%
  count(word1, word2, sort = TRUE)
flood_word_counts
## # A tibble: 51,670 x 3
##           word1        word2     n
##           <chr>        <chr> <int>
##  1         cowx      coflood   360
##  2      boulder        creek   273
##  3 boulderflood      coflood   248
##  4      coflood         cowx   162
##  5      coflood boulderflood   156
##  6      boulder       county   130
##  7      boulder boulderflood   123
##  8          big     thompson   113
##  9        flash        flood   113
## 10 boulderflood         cowx   110
## # ... with 51,660 more rows
```


```r
# plot climate change word network
flood_word_counts %>%
        filter(n >= 50) %>%
        graph_from_data_frame() %>%
        ggraph(layout = "fr") +
        geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
        geom_node_point(color = "darkslategray4", size = 3) +
        geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
        labs(title = "Word Network: Tweets using the hashtag - Climate Change",
             subtitle = "Text mining twitter data ",
             x = "", y = "")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-12-1.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" width="90%" />

Note that urls are still in there for some reason! http.
