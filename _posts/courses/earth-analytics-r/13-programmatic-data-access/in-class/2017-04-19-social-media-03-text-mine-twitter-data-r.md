---
layout: single
title: "Text Mining Twitter Data With TidyText in R"
excerpt: "Text mining is used to extract useful information from text - such as Tweets. Learn how to use the Tidytext package in R to analyze twitter data."
authors: ['Leah Wasser','Carson Farmer']
modified: '2019-08-20'
category: [courses]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/get-data-using-apis/text-mining-twitter-data-intro-r/
nav-title: 'Twitter Data Text Mining'
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
redirect_from:
   - "/course-materials/earth-analytics/week-12/text-mining-twitter-data-intro-r/"
---


{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Clean or "munge" social media data to prepare it for analysis.
* Use the `tidytext` package in `R` to explore and analyze word counts associated with tweets.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In this lesson, you will dive deeper into using twitter to understand a particular
topic or event. You will learn more about text mining.

## Data Munging  101

When you work with data from sources like NASA, USGS, etc., there are particular
cleaning steps that you often need to do. For instance:

* you may need to remove nodata values
* you may need to scale the data
* and more

However, the data generally have a set structure in terms of file formats and metadata.

When you work with social media and other text data the user community creates and
curates the content. This means there are NO RULES! This also means that you may
have to perform extra steps to clean the data to ensure you are analyzing the right
thing.


## Searching for Tweets Related to Climate

Next, let's look at a different workflow - exploring the actual text of the tweets 
which will involve some text mining.

In this example, let's find tweets that are using the words "forest fire" in them.




First, you load the `rtweet` and other needed `R` packages. Note you are introducing
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
climate_tweets <- search_tweets(q = "#climatechange", n = 10000,
                                      lang = "en",
                                      include_rts = FALSE)
```


Let's look at the results. Note any issues with your data?
It seems like when you search for forest fire, you get tweets that contain the words
forest and fire in them - but these tweets are not necessarily all related to your
science topic of interest. Or are they?

If you set your query to `q="forest+fire"` rather than `forest fire` then the
API fill find tweets that use the words together in a string rathen than across
the entire string. Let's try it.


```r
# Find tweet using forest fire in them
climate_tweets <- search_tweets(q = "#climatechange", n = 10000, lang = "en",
                             include_rts = FALSE)
# check data to see if there are emojis
head(climate_tweets$text)
## [1] "Global sea level rise is already happening! Greenland's Massive Ice Melt Wasn't Supposed To Happen Until 2070 #ClimateChange #ClimateCrisis  via @forbes https://t.co/Ncp1rE83Dh https://t.co/w8ub4U4VG1"                                                                                                        
## [2] "@rjacktrag @GretaThunberg Lovely tweet , thanks\ngetting ready for the 20th of september?\n  We must have IMPACT..please join climate strike\n #SaveTheEarth #savetheplanet #climatechange #ClimateEmergency #ClimateCrisis #climatestrike #ClimateAction #IMPACT https://t.co/okUZaXGcg7"                       
## [3] "@anasselbiyad @GretaThunberg Well said\n  getting ready for the 20th of september\n  We must have IMPACT\n #SaveTheEarth #savetheplanet #climatechange #ClimateEmergency #ClimateCrisis #climatestrike #ClimateAction #IMPACT https://t.co/jkrafKMRK0"                                                           
## [4] "@WJvanDinter @SMusalima Emergencies are everywhere.\n, and clearly visible\nWe need to unite and act.\n\n#SaveTheEarth #savetheplanet #climatechange #ClimateEmergency #ClimateCrisis #climatestrike #ClimateAction #climatechange #gretathunberg #ipcc #giec https://t.co/jUe5TmgvbE"                           
## [5] "@dr_l_alexandre @rioujeanpierre Climate news of the day..hell in Spain,Turkey  and Brazil\nAnd some Arctic news\nhttps://t.co/UBpICKRzvi\nhttps://t.co/qqj4MzAbOn\nhttps://t.co/8LGeGmh802\nhttps://t.co/3oSDDioDFY\n#rechauffementclimatique #gretathunberg #climat \n#climatechange #gretathunberg #ipcc #giec"
## [6] "@CiGloFe @GretaThunberg Lovely tweet , thanks.\ngetting ready for the 20th of september?\n  We must have IMPACT..join climate strike\n #SaveTheEarth #savetheplanet #climatechange #ClimateEmergency #ClimateCrisis #climatestrike #ClimateAction #IMPACT"
```

## Data Clean-Up

Looking at the data above, it becomes clear that there is a lot of clean-up
associated with social media data.

First, there are url's in your tweets. If you want to do a text analysis to figure out
what words are most common in your tweets, the URL's won't be helpful. Let's remove
those.


```r
# remove urls tidyverse is failing here for some reason
# climate_tweets %>%
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually
climate_tweets$stripped_text <- gsub("http.*","",  climate_tweets$text)
climate_tweets$stripped_text <- gsub("https.*","", climate_tweets$stripped_text)
```

Finally, you can clean up your text. If you are trying to create a list of unique
words in your tweets, words with capitalization will be different from words
that are all lowercase. Also you don't need punctuation to be returned as a unique
word.


```r
# note the words that are recognized as unique by R
a_list_of_words <- c("Dog", "dog", "dog", "cat", "cat", ",")
unique(a_list_of_words)
## [1] "Dog" "dog" "cat" ","
```

You can use the `tidytext::unnest_tokens()` function in the tidytext package to
magically clean up your text! When you use this function the following things
will be cleaned up in the text:

1. **Convert text to lowercase:** each word found in the text will be converted to lowercase, so ensure that you don't get duplicate words due to variation in capitalization.
2. **Punctuation is removed:** all instances of periods, commas etc will be removed from your list of words , and
3. **Unique id associated with the tweet:** will be added for each occurrence of the word

The `unnest_tokens()` function takes two arguments:

1. The name of the column where the unique word will be stored and
2. The column name from the `data.frame` that you are using that you want to pull unique words from.

In your case, you want to use the `stripped_text` column which is where you have your
cleaned up tweet text stored.



```r
# remove punctuation, convert to lowercase, add id for each tweet!
climate_tweets_clean <- climate_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)
```

Now you can plot your data. What do you notice?


```r
# plot the top 15 words -- notice any issues?
climate_tweets_clean %>%
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

<img src="{{ site.url }}/images/courses/earth-analytics-r/13-programmatic-data-access/in-class/plot-uncleaned-data-1.png" title="plot of users tweeting about fire." alt="plot of users tweeting about fire." width="90%" />

You plot of unique words contains some words that may not be useful to use. For instance
"a" and "to". In the word of text mining you call those words - 'stop words'.
You want to remove these words from your analysis as they are fillers used to compose
a sentence.

Lucky for use, the `tidytext` package has a function that will help us clean up stop
words! To use this you:

1. Load the `stop_words` data included with `tidytext`. This data is simply a list of words that you may want to remove in a natural language analysis.
2. Then you use `anti_join` to remove all stop words from your analysis.

Let's give this a try next!


```r
# load list of stop words - from the tidytext package
data("stop_words")
# view first 6 words
head(stop_words)
## # A tibble: 6 x 2
##   word      lexicon
##   <chr>     <chr>  
## 1 a         SMART  
## 2 a's       SMART  
## 3 able      SMART  
## 4 about     SMART  
## 5 above     SMART  
## 6 according SMART

nrow(climate_tweets_clean)
## [1] 240845

# remove stop words from your list of words
cleaned_tweet_words <- climate_tweets_clean %>%
  anti_join(stop_words)

# there should be fewer words now
nrow(cleaned_tweet_words)
## [1] 129594
```

Now that you've performed this final step of cleaning, you can try to plot, once
again.


```r
# plot the top 15 words -- notice any issues?
cleaned_tweet_words %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
      labs(y = "Count",
      x = "Unique words",
      title = "Count of unique words found in tweets",
      subtitle = "Stop words removed from the list")
```

<img src="{{ site.url }}/images/courses/earth-analytics-r/13-programmatic-data-access/in-class/plot-cleaned-words-1.png" title="top 15 words used in tweets" alt="top 15 words used in tweets" width="90%" />

## Explore Networks of Words

You might also want to explore words that occur together in tweets. LEt's do that
next.

ngrams specifies pairs and 2 is the number of words together


```r
# library(devtools)
#install_github("dgrtwo/widyr")
library(widyr)

# remove punctuation, convert to lowercase, add id for each tweet!
climate_tweets_paired_words <- climate_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(paired_words, stripped_text, token = "ngrams", n = 2)

climate_tweets_paired_words %>%
  count(paired_words, sort = TRUE)
## # A tibble: 126,206 x 2
##    paired_words            n
##    <chr>               <int>
##  1 climate change       1215
##  2 in the                922
##  3 of the                785
##  4 climatechange is      591
##  5 of climatechange      469
##  6 is a                  438
##  7 to climatechange      396
##  8 on the                391
##  9 about climatechange   390
## 10 to the                370
## # … with 126,196 more rows
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
## # A tibble: 6 x 3
##   word1         word2                n
##   <chr>         <chr>            <int>
## 1 climate       change            1215
## 2 climatechange climatecrisis      262
## 3 glacier       lost               232
## 4 climatechange check              188
## 5 climatechange globalwarming      167
## 6 climatechange climateemergency   148
```

Finally, plot the data






