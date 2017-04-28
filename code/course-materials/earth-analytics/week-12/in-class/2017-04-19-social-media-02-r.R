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
rstats_tweets <- search_tweets(q="#rstats", 
                               n = 500)
# view the first 3 rows of the dataframe
head(rstats_tweets, n=3)

## ----no-retweets---------------------------------------------------------
# find recent tweets with #rstats but ignore retweets
rstats_tweets <- search_tweets("#rstats", n = 500,
                             include_rts = FALSE)
# view top 2 rows of data
head(rstats_tweets, n=2)


## ----view-screennames----------------------------------------------------
# view column with screen names - top 6 
head(rstats_tweets$screen_name)
# get a list of unique usernames
unique(rstats_tweets$screen_name)


## ----find-users----------------------------------------------------------
# what users are tweeting with #rstats
users <- search_users("#rstats", 
                      n=500)
# just view the first 2 users - the data frame is large!
head(users, n=2)


## ----explore-users, fig.cap="plot of users tweeting about R"-------------
# how many locations are represented
length(unique(users$location))

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")

## ----users-tweeting, fig.cap="top 15 locations where people are tweeting"----
users %>%
  count(location, sort=TRUE) %>%
  mutate(location= reorder(location,n)) %>%
  top_n(20) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() +
      labs(x="Count",
      y="Location",
      title="Where Twitter users are from - unique locations ")

## ----users-tweeting2, fig.cap="top 15 locations where people are tweeting - na removed"----
users %>%
  count(location, sort=TRUE) %>%
  mutate(location= reorder(location,n)) %>%
  na.omit() %>% 
  top_n(20) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() +
      labs(x="Location",
      y="Count",
      title="Twitter users - unique locations ")

## ----clean-data, echo=FALSE, eval=FALSE, fig.cap="plot of users by time zone cleaned up."----
## users %>% na.omit() %>%
##   ggplot(aes(time_zone)) +
##   geom_bar() + coord_flip() +
##       labs(x="Count",
##       y="Time Zone",
##       title="Twitter users - unique time zones ")

## ----plot-timezone-cleaned, echo=FALSE, fig.cap="plot of users by location"----
users %>%
  count(time_zone, sort=TRUE) %>%
  mutate(location= reorder(time_zone,n)) %>%
  top_n(20) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() +
      labs(y="Count",
      x="Time Zone",
      title="Twitter users - unique time zones ")

