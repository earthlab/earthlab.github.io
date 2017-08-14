---
layout: single
title: "Use tidytext to text mine social media - twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
modified: '2017-08-14'
=======
modified: '2017-08-09'
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/week-12/text-mining-twitter-data-intro-r/
nav-title: 'Text mine twitter data'
week: 12
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




First, we load the `rtweet` and other needed `R` packages. Note we are introducing
2 new packages lower in this lesson: igraph and ggraph.


```r
# load twitter library - the rtweet library is recommended now over twitteR
library(rtweet)
# plotting and pipes - tidyverse!
library(ggplot2)
library(dplyr)
# text mining library
library(tidytext)
# plotting packages
library(igraph)
library(ggraph)
```


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
climate_tweets <- search_tweets(q="#climatechange", n=10000, lang="en",
                             include_rts = FALSE)
# check data to see if there are emojis
head(climate_tweets$text)
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
## [1] "In educating others about #GlobalWarming , please avoid the fossil fuel industry's misleading term #ClimateChange."                                       
## [2] "The biggest threat facing the nation is stupid leadership not #climatechange #friendlydb #freespeech"                                                     
## [3] "MT: #ClimateChange is coming for another beloved ocean animal. via @PopSci  @therightblue https://t.co/hbPceHeGcj https://t.co/wFU9xJK9m3"                
## [4] "Seeking #practices, #policies, #technologies, &amp; more that help tackle global #climatechange. https://t.co/Z9jf6yBrZn"                                 
## [5] "Fun &amp; Inspiring!\nA must read! \U0001f603 https://t.co/lrsKlkpuDn\n\n#money #sustainability #aid #tech #innovation #business… https://t.co/WSXyxrpc3S"
## [6] "#climatechange #climate refugees will be pouring into America soon.\nCanada 'll build a wall to stop American Climat… https://t.co/Pr7aP2ZDqw"
=======
## [1] "Scientist released US gov #ClimateChange report to @nytimes. A lot there so maybe start w/@colbertlateshow's summary https://t.co/UEKQPKc0mK"
## [2] "Spicing things right the fuck up by having Earl Grey instead of English Breakfast tea. With milk NATURALLY. #climatechange"                  
## [3] "In  reality, #climatechange touches all areas of security, peace building, and development. #ClimateWednesday #Youth4Peace #YouthDay"        
## [4] "Seeking to green your city's purchasing? @ASU's @SustainPurch offers 8 actionable recommendations #climatechange… https://t.co/7W4fX9tyJ4"   
## [5] "Going to get much harder for client change deniers. Science + basic life experience ultimately overwhelming. #climatechange #globalwarming"  
## [6] "In Sweltering South, #ClimateChange Is Now a #Workplace #Hazard https://t.co/Nfhc0yVeUY"
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-03-r/plot-uncleaned-data-1.png" title="plot of users tweeting about fire." alt="plot of users tweeting about fire." width="100%" />

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
## # A tibble: 6 x 2
##        word lexicon
##       <chr>   <chr>
## 1         a   SMART
## 2       a's   SMART
## 3      able   SMART
## 4     about   SMART
## 5     above   SMART
## 6 according   SMART

nrow(climate_tweets_clean)
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
## [1] 124297
=======
## [1] 125848
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md

# remove stop words from our list of words
cleaned_tweet_words <- climate_tweets_clean %>%
  anti_join(stop_words)

# there should be fewer words now
nrow(cleaned_tweet_words)
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
## [1] 72739
=======
## [1] 73480
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-03-r/plot-cleaned-words-1.png" title="top 15 words used in tweets" alt="top 15 words used in tweets" width="100%" />

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
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
## # A tibble: 67,794 x 2
##           paired_words     n
##                  <chr> <int>
##  1      climate change   666
##  2    climatechange is   443
##  3    of climatechange   341
##  4    on climatechange   335
##  5              of the   286
##  6              in the   284
##  7    to climatechange   210
##  8          the latest   205
##  9 about climatechange   190
## 10                is a   185
## # ... with 67,784 more rows
=======
## # A tibble: 64,350 x 2
##         paired_words     n
##                <chr> <int>
##  1    climate change   968
##  2  of climatechange   737
##  3  climatechange is   524
##  4         impact of   500
##  5 government report   486
##  6    drastic impact   471
##  7      report finds   462
##  8     finds drastic   423
##  9            on u.s   383
## 10            of the   375
## # ... with 64,340 more rows
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
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
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
## Source: local data frame [6 x 3]
## Groups: word1 [4]
## 
## # A tibble: 6 x 3
##           word1           word2     n
##           <chr>           <chr> <int>
## 1       climate          change   666
## 2 climatechange   climatechange   144
## 3 climatechange   globalwarming   144
## 4        global         warming   133
## 5 climatechange realdonaldtrump    99
## 6           ice           sheet    99
=======
## # A tibble: 6 x 3
##           word1         word2     n
##           <chr>         <chr> <int>
## 1       climate        change   968
## 2    government        report   486
## 3       drastic        impact   471
## 4 climatechange        report   224
## 5        emails        reveal   217
## 6          term climatechange   210
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-03-r.md
```

FInally, plot the data


```r
library(igraph)
library(ggraph)

# plot climate change word network
climate_words_counts %>%
        filter(n >= 24) %>%
        graph_from_data_frame() %>%
        ggraph(layout = "fr") +
        geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
        geom_node_point(color = "darkslategray4", size = 3) +
        geom_node_text(aes(label = name), vjust = 1.8, size=3) +
        labs(title= "Word Network: Tweets using the hashtag - Climate Change",
             subtitle="Text mining twitter data ",
             x="", y="")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-03-r/word-assoc-plot-1.png" title="word associations for climate change tweets" alt="word associations for climate change tweets" width="100%" />

We expect the words climate & change to have a high





