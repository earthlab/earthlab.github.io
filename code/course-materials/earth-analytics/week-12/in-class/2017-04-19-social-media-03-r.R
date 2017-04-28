## ----eval=FALSE----------------------------------------------------------
## climate_tweets <- search_tweets(q="#climatechange", n=10000,
##                                       lang="en",
##                                       include_rts = FALSE)

## ------------------------------------------------------------------------
# Find tweet using forest fire in them
climate_tweets <- search_tweets(q="#climatechange", n=4000, lang="en",
                             include_rts = FALSE)
# check data to see if there are emojis
head(climate_tweets$text)

## ------------------------------------------------------------------------
# remove urls tidyverse is failing here for some reason
#climate_tweets %>%
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually
climate_tweets$stripped_text <- gsub("http.*","",  climate_tweets$text)
climate_tweets$stripped_text <- gsub("https.*","", climate_tweets$stripped_text)


## ----unique-words--------------------------------------------------------
# note the words that are recognized as unique by R
a_list_of_words <- c("Dog", "dog", "dog", "cat", "cat", ",")
unique(a_list_of_words)

## ------------------------------------------------------------------------
# remove punctuation, convert to lowercase, add id for each tweet!
climate_tweets_clean <- climate_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)

## ----plot-uncleaned-data, fig.cap="plot of users tweeting about fire."----
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

## ------------------------------------------------------------------------
# load list of stop words - from the tidytext package
data("stop_words")
# view first 6 words
head(stop_words)

nrow(climate_tweets_clean)

# remove stop words from our list of words
cleaned_tweet_words <- climate_tweets_clean %>%
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
climate_tweets_paired_words <- climate_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(paired_words, stripped_text, token = "ngrams", n=2)

climate_tweets_paired_words %>%
  count(paired_words, sort = TRUE)




## ------------------------------------------------------------------------
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


## ----word-assoc-plot-----------------------------------------------------
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


## ----echo=FALSE, eval=FALSE----------------------------------------------
## # what happens if we remove climate change from the plot as that's a given
## 
## climate_words_counts %>%
##         filter(n >= 15 && n < max(max(climate_words_counts$n))) %>%  graph_from_data_frame() %>%
##         ggraph(layout = "fr") +
##         geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
##         geom_node_point(color = "darkslategray4", size = 5) +
##         geom_node_text(aes(label = name), vjust = 1.8) +
##         ggtitle(expression(paste("Word Network: Tweets using the hashtag - Climate Change",
##                                  italic("Text mining twitter data "))))

