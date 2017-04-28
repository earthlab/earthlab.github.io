---
layout: single
title: "Use tidytext to text mine social media - twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-04-28'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/text-mining-twitter-data-intro-r/
nav-title: 'Text mine twitter data'
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 3
lang-lib:
  r: ['rtweet', 'tidytext', 'dplyr']
tags2:
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

In this lesson we will dive deeper into using twitter to understand a particular
topic or event. We will learn more about text mining.

## Data munging  101

When we work with data from sources like NASA, USGS, etc there are particular
cleaning steps that we often need to do. For instance:

* we may need to remove nodata values
* we may need to scale the data
* and more

However, the data generally have a set structure in terms of file formats and metadata.

When we work with social media and other text data the user community creates and
curates the content. This means there are NO RULES! This also means that we may
have to perform extra steps to clean the data to ensure we are analyzing the right
thing.


## Searching for tweets related to climate

Above we learned some things about sorting through social media data and the
associated types of issues that we may run into when beginning to analyze it. Next,
let's look at a different workflow - exploring the actual text of the tweets which
will involve some text mining.

In this example, let's find tweets that are using the words "forest fire" in them.



```r
climate_tweets <- search_tweets(q="#climatechange", n=10000, 
                                      lang="en",
                                      include_rts = FALSE)
```


Let's look at the results. Note any issues with our data?
It seems like when we search for forest fire, we get tweets that contain the words
forest and fire in them - but these tweets are not necessarily all related to our
science topic of interest. Or are they?

If we set our query to `q="forest+fire"` rather than `forest fire` then the
API fill find tweets that use the words together in a string rathen than across
the entire string. Let's try it.


```r
# Find tweet using forest fire in them
climate_tweets <- search_tweets(q="#climatechange", n=4000, lang="en",
                             include_rts = FALSE)
# check data to see if there are emojis
head(climate_tweets$text)
## [1] "#Climatechange Climate Home Weekly wrap: who controls Africa's clean energy destiny? Climate Home…… https://t.co/WOUz5xQekn"                     
## [2] "Half of All Species Are on the Move—And We're Feeling It @NatGeo https://t.co/iDVP3OO94h #climatechange"                                         
## [3] "How a Professional #ClimateChange Denier Discovered the Lies and Decided to Fight for Science https://t.co/2WHVWF1BRG"                           
## [4] "Just cancelled my NYT subscription because of climate-denier @BretStephensNYT #climatechange"                                                    
## [5] "#Climatechange deniers are like those 40-somethings that tell people they're \"29 again\", only dangerous. #Evidence #factsmatter"               
## [6] "Trees give. Glad to see trees my mother &amp; father planted growing well! #nextgenclimate #climatemarch #climatechange… https://t.co/M9tcuuH5D1"
```

## Data clean-up

Looking at the data above, it becomes clear that there is a lot of clean-up
associated with social media data.

First, there are url's in our tweets. If we want to do a text analysis to figure out
what words are most common in our tweets, the URL's won't be helpful. Let's remove
those.


```r
# remove urls tidyverse is failing here for some reason
#climate_tweets %>%
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually
climate_tweets$stripped_text <- gsub("http.*","",  climate_tweets$text)
climate_tweets$stripped_text <- gsub("https.*","", climate_tweets$stripped_text)
```

Finally, we can clean up our text. If we are trying to create a list of unique
words in our tweets, words with capitalization will be different from words
that are all lowercase. Also we don't need punctuation to be returned as a unique
word.


```r
# note the words that are recognized as unique by R
a_list_of_words <- c("Dog", "dog", "dog", "cat", "cat", ",")
unique(a_list_of_words)
## [1] "Dog" "dog" "cat" ","
```

We can use the `tidytext::unnest_tokens()` function in the tidytext package to
magically clean up our text! When we use this function the following things
will be cleaned up in the text:

1. **Convert text to lowercase:** each word found in the text will be converted to lowercase so ensure that we don't get duplicate words due to variation in capitalization.
2. **Punctuation is removed:** all instances of periods, commas etc will be removed from our list of words , and
3. **Unique id associated with the tweet:** will be added for each occurrence of the word

The `unnest_tokens()` function takes two arguments:

1. The name of the column where the unique word will be stored and
2. The column name from the `data.frame` that you are using that you want to pull unique words from.

In our case, we want to use the `stripped_text` column which is where we have our
cleaned up tweet text stored.



```r
# remove punctuation, convert to lowercase, add id for each tweet!
climate_tweets_clean <- climate_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)
```

Now we can plot our data. What do you notice?


```r
# plot the top 15 words -- notice any issues?
climate_tweets_clean %>%
  count(word, sort=TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
      labs(x="Count",
      y="Unique words",
      title="Count of unique words found in tweets")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-03-r/plot-uncleaned-data-1.png" title="plot of users tweeting about fire." alt="plot of users tweeting about fire." width="100%" />

Our plot of unique words contains some words that may not be useful to use. For instance
"a" and "to". In the word of text mining we call those words - 'stop words'.
We want to remove these words from our analysis as they are fillers used to compose
a sentence.

Lucky for use, the `tidytext` package has a function that will help us clean up stop
words! To use this we:

1. Load the "stop_words" data included with `tidytext`. This data is simply a list of words that we may want to remove in a natural language analysis.
2. Then we use anti_join to remove all stop words from our analysis.

Let's give this a try next!


```r
# load list of stop words - from the tidytext package
data("stop_words")
# view first 6 words
head(stop_words)
## # A tibble: 6 × 2
##        word lexicon
##       <chr>   <chr>
## 1         a   SMART
## 2       a's   SMART
## 3      able   SMART
## 4     about   SMART
## 5     above   SMART
## 6 according   SMART

nrow(climate_tweets_clean)
## [1] 50079

# remove stop words from our list of words
cleaned_tweet_words <- climate_tweets_clean %>%
  anti_join(stop_words)

# there should be fewer words now
nrow(cleaned_tweet_words)
## [1] 29790
```

Now that we've performed this final step of cleaning, we can try to plot, once
again.


```r
# plot the top 15 words -- notice any issues?
cleaned_tweet_words %>%
  count(word, sort=TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
      labs(y="Count",
      x="Unique words",
      title="Count of unique words found in tweets",
      subtitle="Stop words removed from the list")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-03-r/plot-cleaned-words-1.png" title="top 15 words used in tweets" alt="top 15 words used in tweets" width="100%" />

## Explore networks of words

We might also want to explore words that occur together in tweets. LEt's do that 
next. 

ngrams specifies pairs and 2 is the number of words together


```r
# library(devtools)
#install_github("dgrtwo/widyr")
library(widyr)

# remove punctuation, convert to lowercase, add id for each tweet!
climate_tweets_paired_words <- climate_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(paired_words, stripped_text, token = "ngrams", n=2)

climate_tweets_paired_words %>%
  count(paired_words, sort = TRUE)
## # A tibble: 30,901 × 2
##        paired_words     n
##               <chr> <int>
## 1    climate change   231
## 2  on climatechange   155
## 3  of climatechange   153
## 4  climatechange is   147
## 5        the latest   139
## 6              b gt   134
## 7              lt b   134
## 8            in the   114
## 9            of the    93
## 10        the world    91
## # ... with 30,891 more rows
```


```r
library(tidyr)
climate_tweets_separated_words <- climate_tweets_paired_words %>%
  separate(paired_words, c("word1", "word2"), sep = " ")

climate_tweets_filtered <- climate_tweets_separated_words %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts:
climate_words_counts <- climate_tweets_filtered %>% 
  count(word1, word2, sort = TRUE)

head(climate_words_counts)
## Source: local data frame [6 x 3]
## Groups: word1 [5]
## 
##           word1         word2     n
##           <chr>         <chr> <int>
## 1       climate        change   231
## 2         clim8        change    67
## 3 climatechange globalwarming    59
## 4 climatechange      refugees    58
## 5            gt         clim8    50
## 6        change            lt    49
```

FInally, plot the data


```r
library(igraph)
library(ggraph)

# plot climate change word network
climate_words_counts %>%
        filter(n >= 14) %>%
        graph_from_data_frame() %>%
        ggraph(layout = "fr") +
        geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
        geom_node_point(color = "darkslategray4", size = 3) +
        geom_node_text(aes(label = name), vjust = 1.8, size=3) +
        labs(title= "Word Network: Tweets using the hashtag - Climate Change", 
             subtitle="Text mining twitter data ",
             x="", y="") 
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-03-r/word-assoc-plot-1.png" title=" " alt=" " width="100%" />

We expect the words climate & change to have a high 



