---
layout: single
title: "Use tidytext to text mine social media - twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-22'
category: [courses]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/get-data-using-apis/text-mine-colorado-flood-tweets-science-r/
nav-title: 'Text Mine CO Flood Tweets'
week: 13
course: "earth-analytics"
module-type: 'class'
sidebar:
  nav:
author_profile: false
comments: true
order: 4
lang-lib:
  r: ['rtweet', 'tidytext', 'dplyr']
topics:
  social-science: ['social-media']
  data-exploration-and-analysis: ['text-mining']
---



{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Query the twitter RESTful API to access and import into `R` tweets that contain various text strings.
* Generate a list of users that are tweeting about a particular topic
* Use the `tidytext` package in `R` to explore and analyze word counts associated with tweets.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 13 Data (~80 MB)](https://ndownloader.figshare.com/files/9751453?private_link=92e248fddafa3af15b98){:data-proofer-ignore='' .btn }

</div>



```r
# json support
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
# plotting packages
library(igraph)
library(ggraph)

options(stringsAsFactors = FALSE)
```





```r
# create file path
json_file <- "~/Documents/earth-analytics/data/week-13/boulder_flood_geolocated_tweets.json"
# import json file line by line to avoid syntax errors
# this takes a few seconds
boulder_flood_tweets <- stream_in(file(json_file))
##  Found 500 records... Found 1000 records... Found 1500 records... Found 2000 records... Found 2500 records... Found 3000 records... Found 3500 records... Found 4000 records... Found 4500 records... Found 5000 records... Found 5500 records... Found 6000 records... Found 6500 records... Found 7000 records... Found 7500 records... Found 8000 records... Found 8500 records... Found 9000 records... Found 9500 records... Found 10000 records... Found 10500 records... Found 11000 records... Found 11500 records... Found 12000 records... Found 12500 records... Found 13000 records... Found 13500 records... Found 14000 records... Found 14500 records... Found 15000 records... Found 15500 records... Found 16000 records... Found 16500 records... Found 17000 records... Found 17500 records... Found 18000 records... Found 18500 records... Found 18821 records... Imported 18821 records. Simplifying...


## Found 18000 records...
## Found 18500 records...
## Found 18821 records...
## Imported 18821 records. Simplifying...
```

The structure of these data is complex. In this lesson you will just look at a
few parts of the data.


```r
# view the first 6 usernames
head(boulder_flood_tweets$user$screen_name)
## [1] "lilcakes3209"    "coloradowx"      "ChelseaHider"    "jpreyes"        
## [5] "BoulderGreenSts" "RealMatSmith"
# create new df with the tweet text & usernames
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

Next, clean up the data so that you can work with it. Below you:

1. format the date field as a date/time field and
2. split the location information into 2 columns that are numeric (for mapping)


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
September 09 2013 and ended on the 24th. Filter the data to just that
time period.


```r
# filter by time and remove URL's from the tweet. Note this uses regular expressions
flood_tweets <- tweet_data_cl  %>%
  filter(date_time >= start_date & date_time <= end_date ) %>%
  mutate(tweet_text = gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", "", tweet_text))
```



## Explore Common Words

Next let's explore the content of the tweets using some basic text mining approaches.
Text mining refers to looking for patters in blocks of text.

Generate a list of the most popular words found in the tweets during the
flood event. To do this, you use pipes to:

1. select the `tweet_text` column and
2. stack the words so you can group and count them


```r
# get a list of words
flood_tweet_messages <- flood_tweets %>%
  dplyr::select(tweet_text) %>%
  unnest_tokens(word, tweet_text)

head(flood_tweet_messages)
##            word
## 1      download
## 1.1 centurylink
## 1.2   community
## 1.3       flood
## 1.4      impact
## 1.5      report
```

Next, plot the top 15 words found in the tweet text. What do you notice about
the plot below?


```r
# plot the top 15 words
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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/plot-top-15-tweets-1.png" title="plot of chunk plot-top-15-tweets" alt="plot of chunk plot-top-15-tweets" width="90%" />

## Remove Stop Words

The plot above contains "stop words". If you recall from the previous
lesson, these are words like **and**, **in** and **of** that aren't useful to us
in an analysis of commonly
used words. Rather, we'd like to focus on analysis on words that describe the flood
event itself.

As you did in the previous lesson, you can remove those words using the
list of `stop_words` provided by the `tm` package.


```r
data("stop_words")
# how many words do we have including the stop words?
nrow(flood_tweet_messages)
## [1] 136645

flood_tweet_clean <- flood_tweet_messages %>%
  anti_join(stop_words) %>%
  filter(!word == "rt")

# how many words after removing the stop words?
nrow(flood_tweet_clean)
## [1] 80892
```

Notice that before removing the stop words, we have 136645
rows or words in our data. After removing the stop words we have,
80892 words.

Once you've removed the stop words, you can plot the top 15 words again.


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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/top-15-words-without-stops-1.png" title="plot of chunk top-15-words-without-stops" alt="plot of chunk top-15-words-without-stops" width="90%" />

## Paired word analysis

As we did in the previous text mining introductory lesson, we can do a paired
words analysis to better understand which words are most often being used together.



Do perform this analysis you need to reclean and organization your data.
In this case we will create a data frame with 2 columns which contain
word pairs found in the data and a 3rd column that has the count of how many
time that word pair is found in the data. Examples of word pairs includes:

* boulder flood
* colorado flood

To begin, clean up the data by removing stop words and


```r

flood_tweets_paired <- flood_tweets %>%
  dplyr::select(tweet_text) %>%
  mutate(tweet_text = removeWords(tweet_text, stop_words$word)) %>%
  mutate(tweet_text = gsub("\\brt\\b|\\bRT\\b", "", tweet_text)) %>%
  mutate(tweet_text = gsub("http://*", "", tweet_text)) %>%
  unnest_tokens(paired_words, tweet_text, token = "ngrams", n = 2)

flood_tweets_paired %>%
  count(paired_words, sort = TRUE)
## # A tibble: 51,619 x 2
##            paired_words     n
##                   <chr> <int>
##  1         cowx coflood   361
##  2        boulder creek   273
##  3 boulderflood coflood   249
##  4         coflood cowx   163
##  5 coflood boulderflood   156
##  6       boulder county   130
##  7 boulder boulderflood   123
##  8         big thompson   113
##  9          flash flood   113
## 10    boulderflood cowx   110
## # ... with 51,609 more rows
```

Separate the words into columns and count the unique combinations of words.


```r
flood_tweets_separated <- flood_tweets_paired %>%
  separate(paired_words, c("word1", "word2"), sep = " ")

# new bigram counts:
flood_word_counts <- flood_tweets_separated %>%
  count(word1, word2, sort = TRUE)
flood_word_counts
## # A tibble: 51,619 x 3
##           word1        word2     n
##           <chr>        <chr> <int>
##  1         cowx      coflood   361
##  2      boulder        creek   273
##  3 boulderflood      coflood   249
##  4      coflood         cowx   163
##  5      coflood boulderflood   156
##  6      boulder       county   130
##  7      boulder boulderflood   123
##  8          big     thompson   113
##  9        flash        flood   113
## 10 boulderflood         cowx   110
## # ... with 51,609 more rows
```

Finally, plot the word network.


```r
# plot climate change word network
flood_word_counts %>%
        filter(n >= 50) %>%
        graph_from_data_frame() %>%
        ggraph(layout = "fr") +
        geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
        geom_node_point(color = "darkslategray4", size = 3) +
        geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
        labs(title = "Word Network: Tweets during the 2013 Colorado Flood Event",
             subtitle = "September 2013 - Text mining twitter data ",
             x = "", y = "") +
        theme_void()
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/plot-word-pairs-1.png" title="plot of chunk plot-word-pairs" alt="plot of chunk plot-word-pairs" width="90%" />

Note that "http" is still a value that appears in our word analysis. You likely
need to do a bit more cleaning to complete this analysis! The next step might be
a <a href="http://tidytextmining.com/sentiment.html" target = "_blank">sentiment analysis. </a>
This analysis would attempt to capture the general mood of the social media posts
during and after the flood events. While this is beyond the scope of the class,
the tidytextmining book link above has a very useful section on this topic.

In the next lesson, you will will take the tweet location data and create an
interactive map.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://tidytextmining.com/" target = "_blank">Tidy text mining e-book is a great resource for text mining in `R`.  </a>

</div>
