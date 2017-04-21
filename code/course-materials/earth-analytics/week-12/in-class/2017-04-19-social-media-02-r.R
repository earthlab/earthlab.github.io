## ----setup, echo=FALSE---------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ----load-packages-------------------------------------------------------
# load twitter library - the rtweet library is recommended now over twitteR
library(rtweet)
# plotting and pipes - tidyverse!
library(ggplot2)
library(dplyr)
# text mining library
library(tidytext)


## ----create-twitter-token, echo=FALSE, eval=FALSE------------------------
## # when you do this, it
## twitter_token <- create_token(
##   app = appname,
##   consumer_key = key,
##   consumer_secret = secret)
## 
## # get wd
## file_name <- file.path(getwd(), "earth_analytics_twitter_token.rds")
## ## save token to home directory
## saveRDS(twitter_token, file = file_name)

## ----read-token, echo=FALSE, results='hide'------------------------------
# read in the rds file that allows us to access the API
# this avoids storing api info on github - rather it's on my computer locally
readRDS(file = 'earth_analytics_twitter_token.rds')

## ----app-name-example, eval=FALSE----------------------------------------
## # whatever name you assigned to your created app
## appname <- "your-app-name"
## 
## ## api key (example below is not a real key)
## key <- "yourLongApiKeyHere"
## 
## ## api secret (example below is not a real key)
## secret <- "yourSecretKeyHere"
## 

## ----create-token--------------------------------------------------------
# create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)


## ----eval=FALSE----------------------------------------------------------
## post_tweet("Look, i'm tweeting from R in my #rstats #earthanalytics class!")
## # this throws an error but then says it's posted but ofcourse doesn't post.

## ----get-tweets----------------------------------------------------------
## search for 500 tweets using the #rstats hashtag
rstats_tweets <- search_tweets(q="#rstats", n = 500)
# view the first 3 rows of the dataframe
head(rstats_tweets, n=3)

## ----no-retweets---------------------------------------------------------
# find recent tweets with #rstats but ignore retweets
rstats_tweets <- search_tweets("#rstats", n = 500,
                             include_rts = FALSE)
head(rstats_tweets, n=2)


## ----view-screennames----------------------------------------------------
# view column with screen names
head(rstats_tweets$screen_name)
# get a list of just the unique usernames
unique(rstats_tweets$screen_name)


## ----find-users----------------------------------------------------------
# what users are tweeting with #rstats
users <- search_users("#rstats", n=500)
# just view the first 2 users - the data frame is large!
head(users, n=2)


## ----explore-users-------------------------------------------------------
# how many locations are represented
length(unique(users$location))

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")

## ------------------------------------------------------------------------
users %>%
  count(location, sort=TRUE) %>%
  mutate(location= reorder(location,n)) %>%
  top_n(15) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")

## ----plot-users-timezone-------------------------------------------------
# plot a list of users by time zone
users %>% ggplot(aes(time_zone)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Time Zone",
      title="Twitter users - unique time zones ")


## ----plot-timezone-cleaned, echo=FALSE-----------------------------------
users %>%
  count(time_zone, sort=TRUE) %>%
  mutate(location= reorder(time_zone,n)) %>%
  top_n(20) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() +
      labs(x="Count",
      y="Time Zone",
      title="Twitter users - unique time zones ")

## ----clean-data, echo=FALSE, eval=FALSE----------------------------------
## users %>% na.omit() %>%
##   ggplot(aes(time_zone)) +
##   geom_bar() + coord_flip() +
##       labs(x="Count",
##       y="Time Zone",
##       title="Twitter users - unique time zones ")

## ----eval=FALSE----------------------------------------------------------
## 
## # Find tweet using forest fire in them
## forest_fire_tweets <- search_tweets(q="forest fire", n=100, lang="en",
##                              include_rts = FALSE)
## 
## # it doesn't like the type = recent argument - a bug?

## ------------------------------------------------------------------------
# Find tweet using forest fire in them
fire_tweets <- search_tweets(q="forest+fire", n=100, lang="en",
                             include_rts = FALSE)
# check data to see if there are emojis
head(fire_tweets$text)

## ------------------------------------------------------------------------
# remove urls tidyverse is failing here for some reason
#fire_tweets %>%
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually
fire_tweets$stripped_text <- gsub("http.*","",fire_tweets$stripped_text)
fire_tweets$stripped_text <- gsub("https.*","",fire_tweets$stripped_text)


## ------------------------------------------------------------------------
a_list_of_words <- c("Dog", "dog", "dog", "cat", "cat", ",")
unique(a_list_of_words)

## ------------------------------------------------------------------------
# remove punctuation, convert to lowercase, add id for each tweet!
fire_tweet_text_clean <- fire_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)

## ----plot-uncleaned-data-------------------------------------------------
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

## ------------------------------------------------------------------------
# load list of stop words - from the tidytext package
data("stop_words")
# view first 6 words
head(stop_words)

nrow(fire_tweet_text_clean)

# remove stop words from our list of words
cleaned_tweet_words <- fire_tweet_text_clean %>%
  anti_join(stop_words)

# there should be fewer words now
nrow(cleaned_tweet_words)

## ----plot-cleaned-words--------------------------------------------------
# plot the top 15 words -- notice any issues?
cleaned_tweet_words %>%
  count(word, sort=TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
      labs(x="Count",
      y="Unique words",
      title="Count of unique words found in tweets",
      subtitle="Stop words removed from the list")

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## fire_tweets_corpus <- Corpus(VectorSource(fire_tweet_text))
## fire_tweets_dtm <- DocumentTermMatrix(fire_tweets_corpus)
## str(fire_tweets_dtm)
## 
## freq <- sort(colSums(as.matrix(fire_tweets_dtm)), decreasing=TRUE)
## wf <- data.frame(word=names(freq), freq=freq)
## wf$freq
## 
## # remove values <=3
## wf %>%
##   subset(freq > 3) %>%
##   ggplot(aes(reorder(word, freq), freq)) +
##         geom_bar(stat="identity", fill="darkred", colour="darkgreen") +
##         coord_flip()
## 

