## ----eval=FALSE----------------------------------------------------------
## # Find the last 1000 tweets using the forest fire hashtag
## forest_fire_tweets <- search_tweets(q="#forestfire", n=1000, lang="en",
##                              include_rts = FALSE)
## 

## ------------------------------------------------------------------------
# Find tweet using forest fire in them
fire_tweets <- search_tweets(q="#forestfire", n=100, lang="en",
                             include_rts = FALSE)
# check data to see if there are emojis
head(fire_tweets$text)

## ------------------------------------------------------------------------
# remove urls tidyverse is failing here for some reason
#fire_tweets %>%
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually
fire_tweets$stripped_text <- gsub("http.*","",  fire_tweets$text)
fire_tweets$stripped_text <- gsub("https.*","", fire_tweets$stripped_text)


## ------------------------------------------------------------------------
# note the words that are recognized as unique by R
a_list_of_words <- c("Dog", "dog", "dog", "cat", "cat", ",")
unique(a_list_of_words)

## ------------------------------------------------------------------------
# remove punctuation, convert to lowercase, add id for each tweet!
fire_tweet_text_clean <- fire_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)

## ----plot-uncleaned-data, fig.cap="plot of users tweeting about fire."----
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

## ----plot-cleaned-words, fig.cap="top 15 words used in tweets"-----------
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

## ------------------------------------------------------------------------
# library(devtools)
#install_github("dgrtwo/widyr")
library(widyr)

# remove punctuation, convert to lowercase, add id for each tweet!
fire_tweets_paired_words <- fire_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(paired_words, stripped_text, token = "ngrams", n=2)

fire_tweets_paired_words %>%
  count(paired_words, sort = TRUE)




## ------------------------------------------------------------------------
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


## ------------------------------------------------------------------------
word_cooccurences <- fire_tweets$stripped_text %>%
        pair_count(linenumber, word, sort = TRUE)

word_cooccurences

