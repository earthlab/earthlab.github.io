---
layout: single
title: "Use Tidytext to Text Mine Social Media - Twitter Data Using the Twitter API from Rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2018-01-10'
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

* Use the `tidytext` package in `R` to filter social media data by date.
* Use the `tidytext` package in `R` to text mine social media data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 13 Data (~80 MB)](https://ndownloader.figshare.com/files/9751453?private_link=92e248fddafa3af15b98){:data-proofer-ignore='' .btn }

</div>

In the previous lesson you learned the basics of preparing social media data for
analysis and using `tidytext` to analyze tweets. In this lesson you will learn to 
use `tidytext` to text mine tweets and filter them by date. 

The structure of twitter data is complex. In this lesson you will only work with 
the text data of tweets even though there is much more information that you could 
analyze.


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
## opening fileconnectionoldClass input connection.
##  Found 500 records... Found 1000 records... Found 1500 records... Found 2000 records... Found 2500 records... Found 3000 records... Found 3500 records... Found 4000 records... Found 4500 records... Found 5000 records... Found 5500 records... Found 6000 records... Found 6500 records... Found 7000 records... Found 7500 records... Found 8000 records... Found 8500 records... Found 9000 records... Found 9500 records... Found 10000 records... Found 10500 records... Found 11000 records... Found 11500 records... Found 12000 records... Found 12500 records... Found 13000 records... Found 13500 records... Found 14000 records... Found 14500 records... Found 15000 records... Found 15500 records... Found 16000 records... Found 16500 records... Found 17000 records... Found 17500 records... Found 18000 records... Found 18500 records... Found 18821 records... Imported 18821 records. Simplifying...
## closing fileconnectionoldClass input connection.


## Found 18000 records...
## Found 18500 records...
## Found 18821 records...
## Imported 18821 records. Simplifying...
```

First, create a new dataframe that contains:

* The date
* The twitter handle (username)
* The tweet text 

for each tweet in the imported json file. 


```r
# view the first 6 usernames
head(boulder_flood_tweets$user$screen_name)
## [1] "lilcakes3209"    "coloradowx"      "ChelseaHider"    "jpreyes"        
## [5] "BoulderGreenSts" "RealMatSmith"
# create new df with the tweet text & usernames
tweet_data <- data.frame(date_time = boulder_flood_tweets$created_at,
                         username = boulder_flood_tweets$user$screen_name,
                         tweet_text = boulder_flood_tweets$text)
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
```

Next, clean up the data so that you can work with it. According to the incident 
report, the Colorado flood officially started September 09 2013 and ended on the 24th. 

Let's filter the data to just that time period. To do this, you need to: 

1. convert the date column to a R date / time field.
2. filter by the dates when the flood occured.




```r
#format = "%Y-%m-%d %H:%M:%s"
# flood start date sept 13 - 24 (end of incident)
start_date <- as.POSIXct('2013-09-13 00:00:00')
end_date <- as.POSIXct('2013-09-24 00:00:00')

# cleanup
flood_tweets <- tweet_data %>%
  mutate(date_time = as.POSIXct(date_time, format = "%a %b %d %H:%M:%S +0000 %Y")) %>% 
  filter(date_time >= start_date & date_time <= end_date )

min(flood_tweets$date_time)
## [1] "2013-09-13 00:00:18 MDT"
max(flood_tweets$date_time)
## [1] "2013-09-23 23:52:53 MDT"
```




## Explore Common Words

Next let's explore the content of the tweets using some basic text mining approaches.
Text mining refers to looking for patters in blocks of text.

Generate a list of the most popular words found in the tweets during the
flood event. To do this, you use pipes to:

1. select the `tweet_text` column.
2. stack the words so you can group and count them.


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
## Selecting by n
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/plot-top-15-tweets-1.png" title="unique words found in tweets" alt="unique words found in tweets" width="90%" />

## Remove Stop Words

The plot above contains "stop words". If you recall from the previous
lesson, these are words like **and**, **in** and **of** that aren't useful to us
in an analysis of commonly used words. Rather, you'd like to focus on analysis on 
words that describe the flood event itself.

As you did in the previous lesson, you can remove those words using the
list of `stop_words` provided by the `tm` package.


```r
data("stop_words")
# how many words do you have including the stop words?
nrow(flood_tweet_messages)
## [1] 151536

flood_tweet_clean <- flood_tweet_messages %>%
  anti_join(stop_words) %>%
  filter(!word == "rt")
## Joining, by = "word"

# how many words after removing the stop words?
nrow(flood_tweet_clean)
## [1] 95740
```

Notice that before removing the stop words, you have 151536
rows or words in your data. After removing the stop words you have,
95740 words.

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
## Selecting by n
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/top-15-words-without-stops-1.png" title="unique words found in tweets without stop words" alt="unique words found in tweets without stop words" width="90%" />

Finally, notice that http is the top word in the plot above. Let's remove all 
links from your data using a regular expression. Then you can recreate all of the 
cleanup that you performed above, using one pipe. 

To remove all url's you can use the expression below. 

`gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", "", tweet_text`


```r

# cleanup
flood_tweet_clean <- tweet_data %>%
  mutate(date_time = as.POSIXct(date_time, format = "%a %b %d %H:%M:%S +0000 %Y"),
         tweet_text = gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", 
                           "", tweet_text)) %>% 
  filter(date_time >= start_date & date_time <= end_date ) %>% 
  dplyr::select(tweet_text) %>%
  unnest_tokens(word, tweet_text) %>% 
  anti_join(stop_words) %>%
  filter(!word == "rt") # remove all rows that contain "rt" or retweet
## Joining, by = "word"
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
      title = "Count of unique words found in tweets, ")
## Selecting by n
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/top-15-words-without-stops2-1.png" title="count of unique words found in tweets without links" alt="count of unique words found in tweets without links" width="90%" />

## Paired Word Analysis

As you did in the previous text mining introductory lesson, you can do a paired
words analysis to better understand which words are most often being used together.



Do perform this analysis you need to reclean and organization your data.
In this case you will create a data frame with 2 columns which contain
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
## # A tibble: 57,506 x 2
##            paired_words     n
##                   <chr> <int>
##  1         cowx coflood   358
##  2        boulder creek   273
##  3 boulderflood coflood   242
##  4         coflood cowx   159
##  5 coflood boulderflood   151
##  6       boulder county   130
##  7         big thompson   113
##  8 boulder boulderflood   113
##  9          flash flood   113
## 10    boulderflood cowx   110
## # ... with 57,496 more rows
```

Separate the words into columns and count the unique combinations of words.


```r
flood_tweets_separated <- flood_tweets_paired %>%
  separate(paired_words, c("word1", "word2"), sep = " ")

# new bigram counts:
flood_word_counts <- flood_tweets_separated %>%
  count(word1, word2, sort = TRUE)
flood_word_counts
## # A tibble: 57,506 x 3
##           word1        word2     n
##           <chr>        <chr> <int>
##  1         cowx      coflood   358
##  2      boulder        creek   273
##  3 boulderflood      coflood   242
##  4      coflood         cowx   159
##  5      coflood boulderflood   151
##  6      boulder       county   130
##  7          big     thompson   113
##  8      boulder boulderflood   113
##  9        flash        flood   113
## 10 boulderflood         cowx   110
## # ... with 57,496 more rows
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

Note that "http" is still a value that appears in your word analysis. You likely
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

