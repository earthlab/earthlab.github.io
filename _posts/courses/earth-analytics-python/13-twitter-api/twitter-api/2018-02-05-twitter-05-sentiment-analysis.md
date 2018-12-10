---
layout: single
title: 'Analyze Sentiments Using Twitter Data and Tweepy in Python'
excerpt: 'One common way to analyze Twitter data is to analyze attitudes (i.e. sentiment) in the tweet text. Learn how to analyze sentiments in Twitter data using Python.'
authors: ['Martha Morrissey', 'Leah Wasser', 'Jeremey Diaz', 'Jenny Palomino']
modified: 2018-12-10
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/earth-analytics-python/get-data-using-apis/analyze-tweet-sentiments-in-python/
nav-title: 'Tweet Sentiment Analysis'
week: 13 
sidebar:
    nav:
author_profile: false
comments: true
order: 5
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
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

{:.input}
```python
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
     TextBlob("trees and Nativeforests are immensely valuable SaveOurNativeForests ecocide is a crime against humanity"))





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
     'trees and Nativeforests are immensely valuable SaveOurNativeForests ecocide is a crime against humanity']





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
      <td>0.00</td>
      <td>trees and Nativeforests are immensely valuable...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.20</td>
      <td>At the end of the day if what you care about i...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.00</td>
      <td>World Bank to raise 200 billion to fight clima...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.25</td>
      <td>TheWorld Bankis to make about 200bn 157bn avai...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.00</td>
      <td>Can thank Harper conservatives and now the Tru...</td>
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

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-05-sentiment-analysis_14_0.png" alt = "This plot displays a histogram of polarity values for tweets on climate change.">
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

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-05-sentiment-analysis_17_0.png" alt = "This plot displays a revised histogram of polarity values for tweets on climate change. For this histogram, polarity values equal to zero have been removed, and a break has been added at zero, to better highlight the distribution of polarity values.">
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



    [TextBlob("Paradises evacuation notifications and protocols MTI research associate and deputy director of the National Tran"),
     TextBlob("Missing tally in Californias CampFire down to 25hbbp ParadiseCA the whole town that burned down had 26000 ppl"),
     TextBlob("Collecting 70000 images over 17000 acres resulting in 14 trillion pixels of data Thats what a squadron of"),
     TextBlob("Tuxita Chiquita Lolita is a little under the weather so we did our best to cheer her up CampFire moggyblog"),
     TextBlob("An entire homeowners insurance company is going under because of the CampFire home claims I doubt this will be th")]





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
      <th>1</th>
      <td>-0.077778</td>
      <td>Missing tally in Californias CampFire down to ...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.406250</td>
      <td>Tuxita Chiquita Lolita is a little under the w...</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-0.092857</td>
      <td>The communities may have very limited services...</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.136364</td>
      <td>Opal at the vet hospital playroom while we kee...</td>
    </tr>
    <tr>
      <th>7</th>
      <td>-0.125000</td>
      <td>California regulator takes over small failing ...</td>
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

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-05-sentiment-analysis_22_0.png" alt = "This plot displays a histogram of polarity values for tweets on the Camp Fire in California. For this histogram, polarity values equal to zero have been removed and a break has been added at zero, to better highlight the distribution of polarity values.">
<figcaption>This plot displays a histogram of polarity values for tweets on the Camp Fire in California. For this histogram, polarity values equal to zero have been removed and a break has been added at zero, to better highlight the distribution of polarity values.</figcaption>

</figure>




Based on this histogram, would you say that the sentiments from the Camp Fire tweets are more positive or negative?
