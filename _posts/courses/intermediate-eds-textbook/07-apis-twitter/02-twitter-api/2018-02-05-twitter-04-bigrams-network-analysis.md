---
layout: single
title: 'Analyze Co-occurrence and Networks of Words Using Twitter Data and Tweepy in Python'
excerpt: 'One common way to analyze Twitter data is to identify the co-occurrence and networks of words in Tweets. Learn how to analyze word co-occurrence (i.e. bigrams) and networks of words using Python.'
authors: ['Martha Morrissey', 'Leah Wasser', 'Jeremey Diaz', 'Jenny Palomino']
modified: 2020-09-11
category: [courses]
class-lesson: ['social-media-python']
permalink: /courses/use-data-open-source-python/intro-to-apis/calculate-tweet-word-bigrams/
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

{:.output}
    /opt/conda/lib/python3.8/site-packages/nltk/parse/malt.py:206: SyntaxWarning: "is not" with a literal. Did you mean "!="?
      if ret is not 0:



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
    
    url_pattern = re.compile(r'https?://\S+|www\.\S+')
    no_url = url_pattern.sub(r'', txt)

    return no_url
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
    [nltk_data]   Package stopwords is already up-to-date!



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



    [('#climate', 'causing'),
     ('causing', 'wildfires'),
     ('wildfires', 'become'),
     ('become', 'intense'),
     ('intense', '#globalwarming'),
     ('#globalwarming', '#climatechange')]





Notice that the words are paired by co-occurrence. You can remind yourself of the original tweet or the cleaned list of words to see how co-occurrence is identified.  

{:.input}
```python
# Original tweet without URLs
tweets_no_urls[0]
```

{:.output}
{:.execute_result}



    '#CLIMATE change causing wildfires to become more intense   #GlobalWarming #climatechange'





{:.input}
```python
# Clean tweet 
tweets_nsw_nc[0]
```

{:.output}
{:.execute_result}



    ['#climate',
     'causing',
     'wildfires',
     'become',
     'intense',
     '#globalwarming',
     '#climatechange']





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



    [(('#climate', '#change'), 55),
     (('#globalwarming', '#climatechange'), 35),
     (('#climate', 'change,'), 21),
     (('@faosdgs', 'h.e.'), 21),
     (('#climate', 'change.'), 20),
     (('@undeveloppolicy', '@ungeneva'), 19),
     (('@unesco', '@faosdgs'), 19),
     (('h.e.', '@antonioguterres'), 19),
     (('#climate', 'could'), 17),
     (('#gpwx', '#globalwarming'), 16),
     (('@ungeneva', '@sustdev'), 14),
     (('#change', '#climatechange'), 12),
     (('#climatechange', '#climate'), 12),
     (('#global', '#warming'), 12),
     (('#change', 'links'), 12),
     (('@sustdev', '@undesa'), 12),
     (('@undesa', '@unesco'), 12),
     (('achieve', '#globalgoals'), 11),
     (('#co2', '#global'), 10),
     (('#climate', 'change…'), 9)]





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
      <td>(#climate, #change)</td>
      <td>55</td>
    </tr>
    <tr>
      <th>1</th>
      <td>(#globalwarming, #climatechange)</td>
      <td>35</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(#climate, change,)</td>
      <td>21</td>
    </tr>
    <tr>
      <th>3</th>
      <td>(@faosdgs, h.e.)</td>
      <td>21</td>
    </tr>
    <tr>
      <th>4</th>
      <td>(#climate, change.)</td>
      <td>20</td>
    </tr>
    <tr>
      <th>5</th>
      <td>(@undeveloppolicy, @ungeneva)</td>
      <td>19</td>
    </tr>
    <tr>
      <th>6</th>
      <td>(@unesco, @faosdgs)</td>
      <td>19</td>
    </tr>
    <tr>
      <th>7</th>
      <td>(h.e., @antonioguterres)</td>
      <td>19</td>
    </tr>
    <tr>
      <th>8</th>
      <td>(#climate, could)</td>
      <td>17</td>
    </tr>
    <tr>
      <th>9</th>
      <td>(#gpwx, #globalwarming)</td>
      <td>16</td>
    </tr>
    <tr>
      <th>10</th>
      <td>(@ungeneva, @sustdev)</td>
      <td>14</td>
    </tr>
    <tr>
      <th>11</th>
      <td>(#change, #climatechange)</td>
      <td>12</td>
    </tr>
    <tr>
      <th>12</th>
      <td>(#climatechange, #climate)</td>
      <td>12</td>
    </tr>
    <tr>
      <th>13</th>
      <td>(#global, #warming)</td>
      <td>12</td>
    </tr>
    <tr>
      <th>14</th>
      <td>(#change, links)</td>
      <td>12</td>
    </tr>
    <tr>
      <th>15</th>
      <td>(@sustdev, @undesa)</td>
      <td>12</td>
    </tr>
    <tr>
      <th>16</th>
      <td>(@undesa, @unesco)</td>
      <td>12</td>
    </tr>
    <tr>
      <th>17</th>
      <td>(achieve, #globalgoals)</td>
      <td>11</td>
    </tr>
    <tr>
      <th>18</th>
      <td>(#co2, #global)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>19</th>
      <td>(#climate, change…)</td>
      <td>9</td>
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

pos = nx.spring_layout(G, k=2)

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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/07-apis-twitter/02-twitter-api/2018-02-05-twitter-04-bigrams-network-analysis/2018-02-05-twitter-04-bigrams-network-analysis_23_0.png" alt = "This plot displays the networks of co-occurring words in tweets on climate change.">
<figcaption>This plot displays the networks of co-occurring words in tweets on climate change.</figcaption>

</figure>




