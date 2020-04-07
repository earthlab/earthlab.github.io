---
layout: single
title: 'Analyze The Sentiment of Tweets From Twitter Data and Tweepy in Python'
excerpt: 'One way to analyze Twitter data is to analyze attitudes (or sentiment) in the tweet text. Learn how to analyze sentiments in Twitter data using open source Python.'
authors: ['Martha Morrissey', 'Leah Wasser', 'Jeremey Diaz', 'Jenny Palomino']
modified: 2020-04-01
category: [courses]
class-lesson: ['social-media-python']
permalink: /courses/use-data-open-source-python/intro-to-apis/analyze-tweet-sentiment-in-python/
nav-title: 'Tweet Sentiment Analysis'
week: 7 
sidebar:
    nav:
author_profile: false
comments: true
order: 5
course: "intermediate-earth-data-science-textbook"
topics:
    find-and-manage-data: ['apis']
redirect_from:
  - "/courses/earth-analytics-python/using-apis-natural-language-processing-twitter/analyze-tweet-sentiments-in-python/"
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Explain how text data can be analyzed to identify sentiments (i.e. attitudes) toward a particular subject.
* Analyze sentiments in tweets. 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

## Sentiment Analysis

Sentiment analysis is a method of identifying attitudes in text data about a subject of interest. It is scored using polarity values that range from 1 to -1. Values closer to 1 indicate more positivity, while values closer to -1 indicate more negativity. 

In this lesson, you will apply sentiment analysis to Twitter data using the `Python` package `textblob`. You will calculate a polarity value for each tweet on a given subject and then plot these values in a histogram to identify the overall sentiment toward the subject of interest. 

### Get and Clean Tweets Related to Climate

Begin by reviewing how to search for and clean tweets that you will use to analyze sentiments in Twitter data.

_test - force trigger rebuild_

{:.input}
```python
import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import itertools
import collections

import tweepy as tw
import nltk
from nltk.corpus import stopwords
import re
import networkx
from textblob import TextBlob

import warnings
warnings.filterwarnings("ignore")

sns.set(font_scale=1.5)
sns.set_style("whitegrid")
```

Remember to define your keys: 

```python 
consumer_key= 'yourkeyhere'
consumer_secret= 'yourkeyhere'
access_token= 'yourkeyhere'
access_token_secret= 'yourkeyhere'
```


{:.input}
```python
auth = tw.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tw.API(auth, wait_on_rate_limit=True)
```

Using what you have learned in the previous lessons, grab and clean up 1000 recent tweets. For this analysis, you only need to remove URLs from the tweets. 

{:.input}
```python
def remove_url(txt):
    """Replace URLs found in a text string with nothing 
    (i.e. it will remove the URL from the string).

    Parameters
    ----------
    txt : string
        A text string that you want to parse and remove urls.

    Returns
    -------
    The same txt string with url's removed.
    """

    return " ".join(re.sub("([^0-9A-Za-z \t])|(\w+:\/\/\S+)", "", txt).split())
```

{:.input}
```python
# Create a custom search term and define the number of tweets
search_term = "#climate+change -filter:retweets"

tweets = tw.Cursor(api.search,
                   q=search_term,
                   lang="en",
                   since='2018-11-01').items(1000)

# Remove URLs
tweets_no_urls = [remove_url(tweet.text) for tweet in tweets]
```

## Analyze Sentiments in Tweets

You can use the `Python` package `textblob` to calculate the polarity values of individual tweets on climate change. 

Begin by creating `textblob` objects, which assigns polarity values to the tweets. You can identify the polarity value using the attribute `.polarity` of `texblob` object.

{:.input}
```python
# Create textblob objects of the tweets
sentiment_objects = [TextBlob(tweet) for tweet in tweets_no_urls]

sentiment_objects[0].polarity, sentiment_objects[0]
```

{:.output}
{:.execute_result}



    (0.0,
     TextBlob("What does the virus do for the outlook and fond hope of climate change alarmists who want to get everyone travellin"))





You can apply list comprehension to create a list of the polarity values and text for each tweet, and then create a `Pandas Dataframe` from the list. 

{:.input}
```python
# Create list of polarity valuesx and tweet text
sentiment_values = [[tweet.sentiment.polarity, str(tweet)] for tweet in sentiment_objects]

sentiment_values[0]
```

{:.output}
{:.execute_result}



    [0.0,
     'What does the virus do for the outlook and fond hope of climate change alarmists who want to get everyone travellin']





{:.input}
```python
# Create dataframe containing the polarity value and tweet text
sentiment_df = pd.DataFrame(sentiment_values, columns=["polarity", "tweet"])

sentiment_df.head()
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>polarity</th>
      <th>tweet</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.0</td>
      <td>What does the virus do for the outlook and fon...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.6</td>
      <td>In addition to COVID19 the world also faces an...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.0</td>
      <td>Heres the state of our climate the news is no ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.0</td>
      <td>BBC News Climate change Warming clips the nigh...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.2</td>
      <td>This is one to read now and follow up on Clima...</td>
    </tr>
  </tbody>
</table>
</div>





These polarity values can be plotted in a histogram, which can help to highlight in the overall sentiment (i.e. more positivity or negativity) toward the subject. 

{:.input}
```python
fig, ax = plt.subplots(figsize=(8, 6))

# Plot histogram of the polarity values
sentiment_df.hist(bins=[-1, -0.75, -0.5, -0.25, 0.25, 0.5, 0.75, 1],
             ax=ax,
             color="purple")

plt.title("Sentiments from Tweets on Climate Change")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/07-apis-twitter/02-twitter-api/2018-02-05-twitter-05-sentiment-analysis/2018-02-05-twitter-05-sentiment-analysis_16_0.png" alt = "This plot displays a histogram of polarity values for tweets on climate change.">
<figcaption>This plot displays a histogram of polarity values for tweets on climate change.</figcaption>

</figure>




To get a better visual of the polarit values, it can be helpful to remove the polarity values equal to zero and create a break in the histogram at zero.

{:.input}
```python
# Remove polarity values equal to zero
sentiment_df = sentiment_df[sentiment_df.polarity != 0]
```

{:.input}
```python
fig, ax = plt.subplots(figsize=(8, 6))

# Plot histogram with break at zero
sentiment_df.hist(bins=[-1, -0.75, -0.5, -0.25, 0.0, 0.25, 0.5, 0.75, 1],
             ax=ax,
             color="purple")

plt.title("Sentiments from Tweets on Climate Change")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/07-apis-twitter/02-twitter-api/2018-02-05-twitter-05-sentiment-analysis/2018-02-05-twitter-05-sentiment-analysis_19_0.png" alt = "This plot displays a revised histogram of polarity values for tweets on climate change. For this histogram, polarity values equal to zero have been removed, and a break has been added at zero, to better highlight the distribution of polarity values.">
<figcaption>This plot displays a revised histogram of polarity values for tweets on climate change. For this histogram, polarity values equal to zero have been removed, and a break has been added at zero, to better highlight the distribution of polarity values.</figcaption>

</figure>




What does the histogram of the polarity values tell you about sentiments in the tweets gathered from the search "#climate+change -filter:retweets"? Are they more positive or negative?

### Get and Analyze Tweets Related to the Camp Fire

Next, explore a new topic, the 2018 Camp Fire in California. 

Begin by searching for the tweets and combining the cleaning of the data (i.e. removing URLs) with the creation of the `textblob` objects. 

{:.input}
```python
search_term = "#CampFire -filter:retweets"

tweets = tw.Cursor(api.search,
                   q=search_term,
                   lang="en",
                   since='2018-09-23').items(1000)

# Remove URLs and create textblob object for each tweet
all_tweets_no_urls = [TextBlob(remove_url(tweet.text)) for tweet in tweets]

all_tweets_no_urls[:5]
```

{:.output}
{:.execute_result}



    [TextBlob("No this isnt a dream nor an April Fools joke This is what I entirely thought of the W branding in general"),
     TextBlob("FREE checklist 19 ways to connect with young people during this time from SearchInstitute"),
     TextBlob("Its really tough to think we have to do something this hard yet again But we will campfire Paradisestrong"),
     TextBlob("SalesmanCalendar Sample Vintage 1956 Boys at Campfire FREE USA SHIP"),
     TextBlob("For the first day of NorthlandScouts CampAtHome initiative weve got a virtual campfire by Anna from the 93rd N")]





Then, you can create the `Pandas Dataframe` of the polarity values and plot the histogram for the Camp Fire tweets, just like you did for the climate change data. 

{:.input}
```python
# Calculate polarity of tweets
wild_sent_values = [[tweet.sentiment.polarity, str(tweet)] for tweet in all_tweets_no_urls]

# Create dataframe containing polarity values and tweet text
wild_sent_df = pd.DataFrame(wild_sent_values, columns=["polarity", "tweet"])
wild_sent_df = wild_sent_df[wild_sent_df.polarity != 0]

wild_sent_df.head()
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>polarity</th>
      <th>tweet</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.025000</td>
      <td>No this isnt a dream nor an April Fools joke T...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.250000</td>
      <td>FREE checklist 19 ways to connect with young p...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-0.340278</td>
      <td>Its really tough to think we have to do someth...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.400000</td>
      <td>SalesmanCalendar Sample Vintage 1956 Boys at C...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.250000</td>
      <td>For the first day of NorthlandScouts CampAtHom...</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
fig, ax = plt.subplots(figsize=(8, 6))

wild_sent_df.hist(bins=[-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],
        ax=ax, color="purple")

plt.title("Sentiments from Tweets on the Camp Fire")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/07-apis-twitter/02-twitter-api/2018-02-05-twitter-05-sentiment-analysis/2018-02-05-twitter-05-sentiment-analysis_24_0.png" alt = "This plot displays a histogram of polarity values for tweets on the Camp Fire in California. For this histogram, polarity values equal to zero have been removed and a break has been added at zero, to better highlight the distribution of polarity values.">
<figcaption>This plot displays a histogram of polarity values for tweets on the Camp Fire in California. For this histogram, polarity values equal to zero have been removed and a break has been added at zero, to better highlight the distribution of polarity values.</figcaption>

</figure>




Based on this histogram, would you say that the sentiments from the Camp Fire tweets are more positive or negative?
