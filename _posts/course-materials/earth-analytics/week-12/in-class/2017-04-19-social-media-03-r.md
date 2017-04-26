---
layout: single
title: "Use tidytext to text mine social media - twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-04-25'
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


## Searching for tweets related to fire

Above we learned some things about sorting through social media data and the
associated types of issues that we may run into when beginning to analyze it. Next,
let's look at a different workflow - exploring the actual text of the tweets which
will involve some text mining.

In this example, let's find tweets that are using the words "forest fire" in them.



```r
# Find the last 1000 tweets using the forest fire hashtag
forest_fire_tweets <- search_tweets(q="#forestfire", n=1000, lang="en",
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
fire_tweets <- search_tweets(q="#forestfire", n=100, lang="en",
                             include_rts = FALSE)
## Error in curl::curl_fetch_memory(url, handle = handle): Couldn't connect to server
# check data to see if there are emojis
head(fire_tweets$text)
## [1] "I liked a @YouTube video https://t.co/RBuPtSbgCX HARDCORE MINECRAFT ★ FOREST FIRE MAYHEM (3)"                                                    
## [2] "2012: Dust An Elysian Tail\n2013: Fire Emblem Awakening\n2014: Mario Kart 8\n2015: Ori and the Blind Forest\n2016: Fina… https://t.co/qoxMRr01SH"
## [3] "cant really tell but its super smoky out bc theres a forest fire a few towns over https://t.co/S6Zjp4QOLg"                                       
## [4] "probably because jack didnt seT THE ENTIRE FOREST ON FIRE THEREFORE DRAW IN ATTENTION"                                                           
## [5] "I liked a @YouTube video https://t.co/E7IXyxvTiq HARDCORE MINECRAFT ★ FOREST FIRE MAYHEM (3)"                                                    
## [6] "Gotta get a backwood and roll up the forest fire! \U0001f43b\U0001f525"
```

## Data clean-up

Looking at the data above, it becomes clear that there is a lot of clean-up
associated with social media data.

First, there are url's in our tweets. If we want to do a text analysis to figure out
what words are most common in our tweets, the URL's won't be helpful. Let's remove
those.


```r
# remove urls tidyverse is failing here for some reason
#fire_tweets %>%
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually
fire_tweets$stripped_text <- gsub("http.*","",  fire_tweets$text)
fire_tweets$stripped_text <- gsub("https.*","", fire_tweets$stripped_text)
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
fire_tweet_text_clean <- fire_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)
```

Now we can plot our data. What do you notice?


```r
# plot the top 15 words -- notice any issues?
fire_tweet_text_clean %>%
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
## Selecting by n
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

nrow(fire_tweet_text_clean)
## [1] 1484

# remove stop words from our list of words
cleaned_tweet_words <- fire_tweet_text_clean %>%
  anti_join(stop_words)
## Joining, by = "word"

# there should be fewer words now
nrow(cleaned_tweet_words)
## [1] 851
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
## Selecting by n
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
fire_tweets_paired_words <- fire_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(paired_words, stripped_text, token = "ngrams", n=2)

fire_tweets_paired_words %>%
  count(paired_words, sort = TRUE)
## # A tibble: 1,183 × 2
##       paired_words     n
##              <chr> <int>
## 1      forest fire    46
## 2         a forest    22
## 3          start a     9
## 4       the forest     9
## 5  output recovers     8
## 6        oil sands     7
## 7     sands output     7
## 8         to start     6
## 9        a youtube     5
## 10          but it     5
## # ... with 1,173 more rows
```


```r
library(tidyr)
fire_tweets_separated_words <- fire_tweets_paired_words %>%
  separate(paired_words, c("word1", "word2"), sep = " ")

fire_tweets_filtered <- fire_tweets_separated_words %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts:
fire_words_counts <- fire_tweets_filtered %>% 
  count(word1, word2, sort = TRUE)

fire_words_counts
## Source: local data frame [393 x 3]
## Groups: word1 [296]
## 
##       word1      word2     n
##       <chr>      <chr> <int>
## 1    forest       fire    46
## 2    output   recovers     8
## 3       oil      sands     7
## 4     sands     output     7
## 5   youtube      video     5
## 6    forest    service     4
## 7       owl        oil     4
## 8  careless      match     3
## 9      fire disruption     3
## 10     fire management     3
## # ... with 383 more rows

# plot? 

library(igraph)
library(ggraph)

fire_words_counts %>%
        filter(n >= 7) %>%
        graph_from_data_frame() %>%
        ggraph(layout = "fr") +
        geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
        geom_node_point(color = "darkslategray4", size = 5) +
        geom_node_text(aes(label = name), vjust = 1.8) +
        ggtitle(expression(paste("Word Network of forest fire tweets ", 
                                 italic("Text mining twitter data "))))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-03-r/unnamed-chunk-8-1.png" title=" " alt=" " width="100%" />


```r
word_cooccurences <- fire_tweets$stripped_text %>%
        pair_count(linenumber, word, sort = TRUE)
## Error in pair_count_(data, group_col, value_col, unique_pair = unique_pair, : pair_count is deprecated, see pairwise_count in the widyr package instead: https://github.com/dgrtwo/widyr

word_cooccurences
## Error in eval(expr, envir, enclos): object 'word_cooccurences' not found
```

