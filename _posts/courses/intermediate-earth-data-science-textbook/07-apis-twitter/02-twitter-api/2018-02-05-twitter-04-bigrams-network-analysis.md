---
layout: single
title: 'Analyze Co-occurrence and Networks of Words Using Twitter Data and Tweepy in Python'
excerpt: 'One common way to analyze Twitter data is to identify the co-occurrence and networks of words in Tweets. Learn how to analyze word co-occurrence (i.e. bigrams) and networks of words using Python.'
authors: ['Martha Morrissey', 'Leah Wasser', 'Jeremey Diaz', 'Jenny Palomino']
modified: 2020-03-31
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/use-data-open-source-python/using-apis-natural-language-processing-twitter/calculate-tweet-word-bigrams-networks-in-python/
nav-title: 'Tweet Word Bigrams and Network Analysis'
week: 7 
sidebar:
    nav:
author_profile: false
comments: true
order: 4
course: "intermediate-earth-data-science-textbook"
topics:
    find-and-manage-data: ['apis']
redirect_from:
  - "/courses/earth-analytics-python/using-apis-natural-language-processing-twitter/calculate-tweet-word-bigrams-networks-in-python/"
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Identify co-occurring words (i.e. bigrams) in Tweets.
* Create networks of words in Tweets.  

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

## Get and Clean Tweets Related to Climate

In the previous lesson, you learned how to collect and clean data that you collected using `Tweepy` and the Twitter API. Begin by reviewing how to authenticate to the Twitter API and how to search for tweets.

{:.input}
```python
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import itertools
import collections

import tweepy as tw
import nltk
from nltk import bigrams
from nltk.corpus import stopwords
import re
import networkx as nx

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

{:.input}
```python
# Create a custom search term and define the number of tweets
search_term = "#climate+change -filter:retweets"

tweets = tw.Cursor(api.search,
                   q=search_term,
                   lang="en",
                   since='2018-11-01').items(1000)
```

Next, grab and clean up 1000 recent tweets. For this analysis, you need to remove URLs, lower case the words, and remove stop and collection words from the tweets. 

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
# Remove URLs
tweets_no_urls = [remove_url(tweet.text) for tweet in tweets]

# Create a sublist of lower case words for each tweet
words_in_tweet = [tweet.lower().split() for tweet in tweets_no_urls]

# Download stopwords
nltk.download('stopwords')
stop_words = set(stopwords.words('english'))

# Remove stop words from each tweet list of words
tweets_nsw = [[word for word in tweet_words if not word in stop_words]
              for tweet_words in words_in_tweet]

# Remove collection words
collection_words = ['climatechange', 'climate', 'change']

tweets_nsw_nc = [[w for w in word if not w in collection_words]
                 for word in tweets_nsw]
```

{:.output}
    [nltk_data] Downloading package stopwords to /root/nltk_data...
    [nltk_data]   Unzipping corpora/stopwords.zip.



## Explore Co-occurring Words (Bigrams)

To identify co-occurrence of words in the tweets, you can use `bigrams` from `nltk`. 

Begin with a list comprehension to create a list of all bigrams (i.e. co-occurring words) in the tweets. 

{:.input}
```python
# Create list of lists containing bigrams in tweets
terms_bigram = [list(bigrams(tweet)) for tweet in tweets_nsw_nc]

# View bigrams for the first tweet
terms_bigram[0]
```

{:.output}
{:.execute_result}



    [('covid19', 'lockdown'),
     ('lockdown', 'saved'),
     ('saved', 'trillions'),
     ('trillions', 'gallon'),
     ('gallon', 'water'),
     ('water', 'wasted'),
     ('wasted', 'tourism'),
     ('tourism', 'sector'),
     ('sector', 'water'),
     ('water', 'crisis')]





Notice that the words are paired by co-occurrence. You can remind yourself of the original tweet or the cleaned list of words to see how co-occurrence is identified.  

{:.input}
```python
# Original tweet without URLs
tweets_no_urls[0]
```

{:.output}
{:.execute_result}



    'Covid19 Lockdown saved trillions of gallon water wasted in the Tourism sector Water crisis Climate change'





{:.input}
```python
# Clean tweet 
tweets_nsw_nc[0]
```

{:.output}
{:.execute_result}



    ['covid19',
     'lockdown',
     'saved',
     'trillions',
     'gallon',
     'water',
     'wasted',
     'tourism',
     'sector',
     'water',
     'crisis']





Similar to what you learned in the previous lesson on word frequency counts, you can use a counter to capture the bigrams as dictionary keys and their counts are as dictionary values. 

Begin by flattening the list of bigrams. You can then create the counter and query the top 20 most common bigrams across the tweets. 

{:.input}
```python
# Flatten list of bigrams in clean tweets
bigrams = list(itertools.chain(*terms_bigram))

# Create counter of words in clean bigrams
bigram_counts = collections.Counter(bigrams)

bigram_counts.most_common(20)
```

{:.output}
{:.execute_result}



    [(('coronavirus', 'pandemic'), 15),
     (('gpwx', 'globalwarming'), 13),
     (('global', 'warming'), 9),
     (('great', 'barrier'), 9),
     (('barrier', 'reef'), 9),
     (('links', 'science'), 7),
     (('teach', 'us'), 7),
     (('roll', 'back'), 6),
     (('back', 'obamaera'), 6),
     (('antarctic', 'ice'), 6),
     (('ice', 'sheet'), 6),
     (('science', 'links'), 6),
     (('investor', 'ideas'), 6),
     (('cleantech', 'podcast'), 6),
     (('trump', 'roll'), 5),
     (('obamaera', 'clean'), 5),
     (('clean', 'car'), 5),
     (('car', 'rules'), 5),
     (('rules', 'huge'), 5),
     (('huge', 'blow'), 5)]





Once again, you can create a `Pandas Dataframe` from the counter. 

{:.input}
```python
bigram_df = pd.DataFrame(bigram_counts.most_common(20),
                             columns=['bigram', 'count'])

bigram_df
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
      <th>bigram</th>
      <th>count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>(coronavirus, pandemic)</td>
      <td>15</td>
    </tr>
    <tr>
      <th>1</th>
      <td>(gpwx, globalwarming)</td>
      <td>13</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(global, warming)</td>
      <td>9</td>
    </tr>
    <tr>
      <th>3</th>
      <td>(great, barrier)</td>
      <td>9</td>
    </tr>
    <tr>
      <th>4</th>
      <td>(barrier, reef)</td>
      <td>9</td>
    </tr>
    <tr>
      <th>5</th>
      <td>(links, science)</td>
      <td>7</td>
    </tr>
    <tr>
      <th>6</th>
      <td>(teach, us)</td>
      <td>7</td>
    </tr>
    <tr>
      <th>7</th>
      <td>(roll, back)</td>
      <td>6</td>
    </tr>
    <tr>
      <th>8</th>
      <td>(back, obamaera)</td>
      <td>6</td>
    </tr>
    <tr>
      <th>9</th>
      <td>(antarctic, ice)</td>
      <td>6</td>
    </tr>
    <tr>
      <th>10</th>
      <td>(ice, sheet)</td>
      <td>6</td>
    </tr>
    <tr>
      <th>11</th>
      <td>(science, links)</td>
      <td>6</td>
    </tr>
    <tr>
      <th>12</th>
      <td>(investor, ideas)</td>
      <td>6</td>
    </tr>
    <tr>
      <th>13</th>
      <td>(cleantech, podcast)</td>
      <td>6</td>
    </tr>
    <tr>
      <th>14</th>
      <td>(trump, roll)</td>
      <td>5</td>
    </tr>
    <tr>
      <th>15</th>
      <td>(obamaera, clean)</td>
      <td>5</td>
    </tr>
    <tr>
      <th>16</th>
      <td>(clean, car)</td>
      <td>5</td>
    </tr>
    <tr>
      <th>17</th>
      <td>(car, rules)</td>
      <td>5</td>
    </tr>
    <tr>
      <th>18</th>
      <td>(rules, huge)</td>
      <td>5</td>
    </tr>
    <tr>
      <th>19</th>
      <td>(huge, blow)</td>
      <td>5</td>
    </tr>
  </tbody>
</table>
</div>





## Visualize Networks of Bigrams

You can now use this `Pandas Dataframe` to visualize the top 20 occurring bigrams as networks using the `Python` package `NetworkX`.

{:.input}
```python
# Create dictionary of bigrams and their counts
d = bigram_df.set_index('bigram').T.to_dict('records')
```

{:.input}
```python
# Create network plot 
G = nx.Graph()

# Create connections between nodes
for k, v in d[0].items():
    G.add_edge(k[0], k[1], weight=(v * 10))

G.add_node("china", weight=100)
```



{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 8))

pos = nx.spring_layout(G, k=1)

# Plot networks
nx.draw_networkx(G, pos,
                 font_size=16,
                 width=3,
                 edge_color='grey',
                 node_color='purple',
                 with_labels = False,
                 ax=ax)

# Create offset labels
for key, value in pos.items():
    x, y = value[0]+.135, value[1]+.045
    ax.text(x, y,
            s=key,
            bbox=dict(facecolor='red', alpha=0.25),
            horizontalalignment='center', fontsize=13)
    
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/07-apis-twitter/02-twitter-api/2018-02-05-twitter-04-bigrams-network-analysis/2018-02-05-twitter-04-bigrams-network-analysis_23_0.png" alt = "This plot displays the networks of co-occurring words in tweets on climate change.">
<figcaption>This plot displays the networks of co-occurring words in tweets on climate change.</figcaption>

</figure>




