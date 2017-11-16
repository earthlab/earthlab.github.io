---
layout: single
title: "Use tidytext to text mine social media - twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-09'
category: [courses]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/week-12/text-mining-twitter-data-intro-r/
nav-title: 'Text mine twitter data'
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
output: html_document
redirect_from:
   - "/course-materials/earth-analytics/week-12/text-mining-twitter-data-intro-r/"
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
# coupled words analysis
library(widyr)
# plotting packages
library(igraph)
library(ggraph)
options(stringsAsFactors = FALSE)
```


```r
json_file <- "~/Documents/twitter-data/lookup_tweets/apps/test_data/boulder_flood_geolocated_tweets.json"
# import json file
boulder_flood_tweets <- stream_in(file(json_file))
## opening file input connection.
##  Found 500 records... Found 1000 records... Found 1500 records... Found 2000 records... Found 2500 records... Found 3000 records... Found 3500 records... Found 4000 records... Found 4500 records... Found 5000 records... Found 5500 records... Found 6000 records... Found 6500 records... Found 7000 records... Found 7500 records... Found 8000 records... Found 8500 records... Found 9000 records... Found 9500 records... Found 10000 records... Found 10500 records... Found 11000 records... Found 11500 records... Found 12000 records... Found 12500 records... Found 13000 records... Found 13500 records... Found 14000 records... Found 14500 records... Found 15000 records... Found 15500 records... Found 16000 records... Found 16500 records... Found 17000 records... Found 17500 records... Found 18000 records... Found 18500 records... Found 18821 records... Imported 18821 records. Simplifying...
## closing file input connection.
# explore the data 
# str(boulder_flood_tweets)
head(boulder_flood_tweets$user$screen_name)
## [1] "lilcakes3209"    "coloradowx"      "ChelseaHider"    "jpreyes"        
## [5] "BoulderGreenSts" "RealMatSmith"
# create new df with just the tweets & usernames  
tweet_data <- data.frame(date_time = boulder_flood_tweets$created_at,
                         username = boulder_flood_tweets$user$screen_name, 
                         tweet_text = boulder_flood_tweets$text,
                         coords = boulder_flood_tweets$coordinates)
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
## Warning: Too few values at 14878 locations: 2, 4, 6, 7, 8, 9, 10, 11, 12,
## 15, 19, 21, 22, 23, 26, 27, 28, 29, 30, 31, ...
## Warning in evalq(as.numeric(long), <environment>): NAs introduced by
## coercion


#tail(tweet_data$date_time)
#Thu Sep 12 04:08:56 +0000 2013

#as.POSIXct(tail(tweet_data$date_time), format = "%a %b %d %H:%M:%S +0000 %Y", tz = "MST")
 
 
min(tweet_data_cl$date_time)
## [1] "2013-09-12 04:01:27 MDT"
max(tweet_data_cl$date_time)
## [1] "2014-01-01 06:59:33 MST"

# filter by time and remove URL's from the tweet. Note this uses regular expressions
flood_tweets <- tweet_data_cl  %>% 
  filter(date_time >= start_date & date_time <= end_date ) %>% 
  mutate(tweet_text = gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", "", tweet_text))

#flood_tweets$tweet_text

#gsub("\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)", "", string)
#head(unlist(boulder_flood_tweets$coordinates))
#head(boulder_flood_tweets$created_at)
#write.csv(tweet_data_cl, file = "tweet_cleaned_boulder.csv")

# 
```

let's map the tweets


```r
library(maps)
library(ggthemes)

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

to_plot <- tweet_data_cl %>% 
  na.omit() 

world +
  geom_point(data = to_plot, aes(x = long, y = lat), 
             colour = 'purple', alpha = .5) +
  scale_size_continuous(range = c(1, 8), 
                        breaks = c(250, 500, 750, 1000))
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="90%" />

```r

points(tweet_data_cl$lat, tweet_data$long)
## Error in plot.xy(xy.coords(x, y), type = type, ...): plot.new has not been called yet
```




```r
library(gganimate)
devtools::install_github("tidyverse/ggplot2")
## Skipping install of 'ggplot2' from a github remote, the SHA1 (53dbed71) has not changed since last install.
##   Use `force = TRUE` to force installation
library(ggplot2)
library(lubridate)
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
## Warning: Ignoring unknown aesthetics: frame
p
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" />

```r
gganimate(p, width = 5)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-2.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-3.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-4.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-5.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-6.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-7.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-8.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-9.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-10.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-11.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-12.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-13.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-14.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-15.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-16.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-17.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-18.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-19.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-20.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-21.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-22.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-23.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-24.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-25.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-26.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-27.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-28.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-29.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-30.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-31.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-32.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" />

```r

# this works 
p <- ggplot(to_plot_final, aes(long_round, lat_round, frame = day, size = total_count), colour = 'purple') +
  geom_point() +
  borders("usa", colour = "gray85", fill = "gray80") +
  theme_map() 
p
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-33.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" />

```r
gganimate(p)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-34.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-35.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-36.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-37.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-38.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-39.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-40.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-41.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-42.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-43.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-44.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-45.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-46.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-47.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-48.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-49.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-50.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-51.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-52.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-53.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-54.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-55.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-56.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-57.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-58.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-59.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-60.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-61.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-62.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-63.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-3-64.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" />

```r

# but when i try to add a basemap it fails

#map <- world +
#  geom_point(data = to_plot, aes(x = long, y = lat,
#                 frame = date_time, cumulative = TRUE), 
#             colour = 'purple', alpha = .5)  +
#  scale_size_continuous(range = c(1, 8), breaks = c(250, 500, 750, 1000)) 

#devtools::install_github("dgrtwo/gganimate")
library(gganimate)
ani.options(interval = 0.2)
## Error in ani.options(interval = 0.2): could not find function "ani.options"
gganimate(map)
## Error in plot_clone(plot): attempt to apply non-function
```

next do some text mining!

```r
# get a list of words 
flood_tweet_messages <- flood_tweets %>%
  dplyr::select(tweet_text) %>%
  unnest_tokens(word, tweet_text)
```



```r
# plot the top 15 words -- notice any issues?
flood_tweet_messages %>%
  count(word, sort=TRUE) %>%
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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="90%" />


# clean out the stop words

also get rid of rt as that stands for retweet!


```r
data("stop_words")
nrow(flood_tweet_messages)
## [1] 136645

flood_tweet_clean <- flood_tweet_messages %>% 
  anti_join(stop_words) %>% 
  filter(!word == "rt")
## Joining, by = "word"
  

nrow(flood_tweet_clean)
## [1] 80892
```


```r
# plot the top 15 words -- notice any issues?
flood_tweet_clean %>%
  count(word, sort=TRUE) %>%
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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="90%" />

Paired word analysis

1. probably remove all stop words from the 


```r
library("tm")
## Loading required package: NLP
## 
## Attaching package: 'NLP'
## The following object is masked from 'package:ggplot2':
## 
##     annotate
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
library(igraph)
library(ggraph)

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-04-twitter-data-boulder-flood-r/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" width="90%" />

Note that urls are still in there for some reason! http.
