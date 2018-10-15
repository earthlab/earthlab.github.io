---
layout: single
title: 'Twitter Data and Sentiment Analysis'
excerpt: 'This lesson provides an example of analyzing twitter data around a natural disaster.'
authors: ['Martha Morrissey', 'Leah Wasser', 'Carson Farmer']
modified: 2018-10-08
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/earth-analytics/get-data-using-apis/text-mine-colorado-flood-tweets-sentiment-python/
nav-title: 'Tweet Sentiment Analysis'
week: 12
sidebar:
    nav:
author_profile: false
comments: true
order: 7
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Use the `textblob` package in `Python` to perform a sentiment analysis of tweets.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>
In the previous lessons you learned to use text mining approaches to understand what people are tweeting about and create maps of tweet locations. This lesson will take that analysis a step further by performing a sentiment analysis of tweets.

## Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import tweepy
import textblob 
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import json
from pandas.io.json import json_normalize
import re

from textblob import TextBlob
import nltk
from nltk.corpus import stopwords
nltk.download('stopwords')
from nltk.corpus import stopwords
```

{:.output}
    [nltk_data] Downloading package stopwords to
    [nltk_data]     /Users/marthamorrissey/nltk_data...
    [nltk_data]   Package stopwords is already up-to-date!



## Convert json to `Pandas DataFrame`

{:.input}
```python
file = "data/twitter_data/boulder_flood_geolocated_tweets.json"
```

{:.input}
```python
tweets = []
for line in open('data/twitter_data/boulder_flood_geolocated_tweets.json', 'r'):
    tweets.append(json.loads(line))
```

{:.input}
```python
tweets[1]
```

{:.output}
{:.execute_result}



    {'contributors': None,
     'coordinates': None,
     'created_at': 'Tue Dec 31 18:49:31 +0000 2013',
     'entities': {'hashtags': [{'indices': [108, 113], 'text': 'snow'},
       {'indices': [114, 119], 'text': 'COwx'},
       {'indices': [120, 128], 'text': 'weather'},
       {'indices': [129, 136], 'text': 'Denver'}],
      'symbols': [],
      'urls': [],
      'user_mentions': [{'id': 1214463582,
        'id_str': '1214463582',
        'indices': [0, 14],
        'name': 'WeatherDude',
        'screen_name': 'WeatherDude17'}]},
     'favorite_count': 0,
     'favorited': False,
     'geo': None,
     'id': 418091565161017345,
     'id_str': '418091565161017345',
     'in_reply_to_screen_name': 'WeatherDude17',
     'in_reply_to_status_id': 418091408994471937,
     'in_reply_to_status_id_str': '418091408994471937',
     'in_reply_to_user_id': 1214463582,
     'in_reply_to_user_id_str': '1214463582',
     'is_quote_status': False,
     'lang': 'en',
     'place': None,
     'retweet_count': 0,
     'retweeted': False,
     'source': '<a href="https://about.twitter.com/products/tweetdeck" rel="nofollow">TweetDeck</a>',
     'text': '@WeatherDude17 Not that revved up yet due to model inconsistency. I\'d say 0-2" w/ a decent chance of &gt;1" #snow #COwx #weather #Denver',
     'truncated': False,
     'user': {'contributors_enabled': False,
      'created_at': 'Fri Jul 09 23:15:25 +0000 2010',
      'default_profile': True,
      'default_profile_image': False,
      'description': "Bringing you weather information & forecasts for the Denver metro area and Colorado. Previously worked at NOAA's CPC & @capitalweather.",
      'entities': {'description': {'urls': []},
       'url': {'urls': [{'display_url': 'weather5280.com',
          'expanded_url': 'http://www.weather5280.com',
          'indices': [0, 23],
          'url': 'https://t.co/TFT5G0nnPh'}]}},
      'favourites_count': 14777,
      'follow_request_sent': False,
      'followers_count': 2181,
      'following': False,
      'friends_count': 458,
      'geo_enabled': True,
      'has_extended_profile': False,
      'id': 164856599,
      'id_str': '164856599',
      'is_translation_enabled': False,
      'is_translator': False,
      'lang': 'en',
      'listed_count': 199,
      'location': 'Denver, CO',
      'name': 'Josh Larson',
      'notifications': False,
      'profile_background_color': 'C0DEED',
      'profile_background_image_url': 'http://abs.twimg.com/images/themes/theme1/bg.png',
      'profile_background_image_url_https': 'https://abs.twimg.com/images/themes/theme1/bg.png',
      'profile_background_tile': False,
      'profile_image_url': 'http://pbs.twimg.com/profile_images/910542678072238082/DYfwLSOF_normal.jpg',
      'profile_image_url_https': 'https://pbs.twimg.com/profile_images/910542678072238082/DYfwLSOF_normal.jpg',
      'profile_link_color': '1DA1F2',
      'profile_sidebar_border_color': 'C0DEED',
      'profile_sidebar_fill_color': 'DDEEF6',
      'profile_text_color': '333333',
      'profile_use_background_image': True,
      'protected': False,
      'screen_name': 'coloradowx',
      'statuses_count': 18024,
      'time_zone': 'Mountain Time (US & Canada)',
      'translator_type': 'none',
      'url': 'https://t.co/TFT5G0nnPh',
      'utc_offset': -25200,
      'verified': False}}





{:.input}
```python
df = json_normalize(tweets)
```

{:.input}
```python
df.columns
```

{:.output}
{:.execute_result}



    Index(['contributors', 'coordinates', 'coordinates.coordinates',
           'coordinates.type', 'created_at', 'entities.hashtags', 'entities.media',
           'entities.symbols', 'entities.urls', 'entities.user_mentions',
           ...
           'user.profile_text_color', 'user.profile_use_background_image',
           'user.protected', 'user.screen_name', 'user.statuses_count',
           'user.time_zone', 'user.translator_type', 'user.url', 'user.utc_offset',
           'user.verified'],
          dtype='object', length=241)





{:.input}
```python
df.head()
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
      <th>contributors</th>
      <th>coordinates</th>
      <th>coordinates.coordinates</th>
      <th>coordinates.type</th>
      <th>created_at</th>
      <th>entities.hashtags</th>
      <th>entities.media</th>
      <th>entities.symbols</th>
      <th>entities.urls</th>
      <th>entities.user_mentions</th>
      <th>...</th>
      <th>user.profile_text_color</th>
      <th>user.profile_use_background_image</th>
      <th>user.protected</th>
      <th>user.screen_name</th>
      <th>user.statuses_count</th>
      <th>user.time_zone</th>
      <th>user.translator_type</th>
      <th>user.url</th>
      <th>user.utc_offset</th>
      <th>user.verified</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>None</td>
      <td>NaN</td>
      <td>[-118.10041174, 34.14628356]</td>
      <td>Point</td>
      <td>Tue Dec 31 07:14:22 +0000 2013</td>
      <td>[{'text': 'drunk', 'indices': [28, 34]}, {'tex...</td>
      <td>NaN</td>
      <td>[]</td>
      <td>[{'url': 'http://t.co/uYmu7c4o0x', 'expanded_u...</td>
      <td>[]</td>
      <td>...</td>
      <td>333333</td>
      <td>True</td>
      <td>False</td>
      <td>lilcakes3209</td>
      <td>4441</td>
      <td>None</td>
      <td>none</td>
      <td>http://t.co/QeGU8kLjps</td>
      <td>NaN</td>
      <td>False</td>
    </tr>
    <tr>
      <th>1</th>
      <td>None</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>Tue Dec 31 18:49:31 +0000 2013</td>
      <td>[{'text': 'snow', 'indices': [108, 113]}, {'te...</td>
      <td>NaN</td>
      <td>[]</td>
      <td>[]</td>
      <td>[{'screen_name': 'WeatherDude17', 'name': 'Wea...</td>
      <td>...</td>
      <td>333333</td>
      <td>True</td>
      <td>False</td>
      <td>coloradowx</td>
      <td>18024</td>
      <td>Mountain Time (US &amp; Canada)</td>
      <td>none</td>
      <td>https://t.co/TFT5G0nnPh</td>
      <td>-25200.0</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2</th>
      <td>None</td>
      <td>NaN</td>
      <td>[0.13429814, 52.22500698]</td>
      <td>Point</td>
      <td>Mon Dec 30 20:29:20 +0000 2013</td>
      <td>[{'text': 'boulder', 'indices': [20, 28]}]</td>
      <td>[{'id': 417754295334088704, 'id_str': '4177542...</td>
      <td>[]</td>
      <td>[]</td>
      <td>[]</td>
      <td>...</td>
      <td>8A7302</td>
      <td>True</td>
      <td>False</td>
      <td>ChelseaHider</td>
      <td>3234</td>
      <td>London</td>
      <td>none</td>
      <td>None</td>
      <td>0.0</td>
      <td>False</td>
    </tr>
    <tr>
      <th>3</th>
      <td>None</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>Mon Dec 30 23:02:29 +0000 2013</td>
      <td>[{'text': 'Boulder', 'indices': [105, 113]}, {...</td>
      <td>NaN</td>
      <td>[]</td>
      <td>[{'url': 'http://t.co/zyk3FkB4og', 'expanded_u...</td>
      <td>[]</td>
      <td>...</td>
      <td>333333</td>
      <td>True</td>
      <td>False</td>
      <td>jpreyes</td>
      <td>8220</td>
      <td>Central Time (US &amp; Canada)</td>
      <td>none</td>
      <td>http://t.co/u0aaW84Avc</td>
      <td>-21600.0</td>
      <td>False</td>
    </tr>
    <tr>
      <th>4</th>
      <td>None</td>
      <td>NaN</td>
      <td>[144.98467167, -37.80312131]</td>
      <td>Point</td>
      <td>Wed Jan 01 06:12:15 +0000 2014</td>
      <td>[{'text': 'Boulder', 'indices': [15, 23]}]</td>
      <td>NaN</td>
      <td>[]</td>
      <td>[]</td>
      <td>[]</td>
      <td>...</td>
      <td>333333</td>
      <td>True</td>
      <td>False</td>
      <td>BoulderGreenSts</td>
      <td>1988</td>
      <td>Mountain Time (US &amp; Canada)</td>
      <td>none</td>
      <td>http://t.co/HT9r4vA9aU</td>
      <td>-25200.0</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 241 columns</p>
</div>





{:.input}
```python
df_small = df[['text', 'created_at']]
```

{:.input}
```python
df_small.head()
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
      <th>text</th>
      <th>created_at</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Boom bitch get out the way! #drunk #islands #g...</td>
      <td>Tue Dec 31 07:14:22 +0000 2013</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@WeatherDude17 Not that revved up yet due to m...</td>
      <td>Tue Dec 31 18:49:31 +0000 2013</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Story of my life! 😂 #boulder http://t.co/ZMfNK...</td>
      <td>Mon Dec 30 20:29:20 +0000 2013</td>
    </tr>
    <tr>
      <th>3</th>
      <td>We're looking for the two who came to help a c...</td>
      <td>Mon Dec 30 23:02:29 +0000 2013</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Happy New Year #Boulder !!!! What are some of ...</td>
      <td>Wed Jan 01 06:12:15 +0000 2014</td>
    </tr>
  </tbody>
</table>
</div>





## Clean Tweet Data
Remember to remove special characters, stop words, and collection words from the data before conducting sentiment analysis with the `Python` package `Textblob`.

{:.input}
```python
def clean_tweet(tweet):
    return ' '.join(re.sub("([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())
```

{:.input}
```python
stop_words = set(stopwords.words('english'))
```

{:.input}
```python
cleaned = [clean_tweet(tweet) for tweet in df_small['text']]
words_in_tweet = [tweet.split() for tweet in cleaned] 
words_in_tweet_l = [[w.lower() for w in word] for word in words_in_tweet]
tweets_nsw = [[w for w in word if not w in stop_words] for word in words_in_tweet_l]
```

{:.input}
```python
collection_word_list= ['rt', 'boulderflood', 'coflood', 'cowx']
```

{:.input}
```python
tweets_nsw2 = [[w for w in word if not w in collection_word_list] for word in tweets_nsw]
```

{:.input}
```python
" ".join(tweets_nsw2[6])
```

{:.output}
{:.execute_result}



    'deer boulder onlyinboulder'





{:.input}
```python
sentiment_number = [TextBlob(" ".join(tweet)) for tweet in tweets_nsw2]

s_n = [tweet.sentiment.polarity for tweet in sentiment_number]
```

{:.input}
```python
s_n[:10]
```

{:.output}
{:.execute_result}



    [-0.5,
     0.02083333333333333,
     0.0,
     0.0,
     0.3575757575757576,
     0.34545454545454546,
     0.0,
     0.0,
     0.6700000000000002,
     -0.4]





{:.input}
```python
np.min(s_n)
```

{:.output}
{:.execute_result}



    -1.0





{:.input}
```python
np.max(s_n)
```

{:.output}
{:.execute_result}



    1.0





{:.input}
```python
np.mean(s_n)
```

{:.output}
{:.execute_result}



    0.0802237619722942





{:.input}
```python
df_small['polarity'] = s_n
```

{:.output}
    //anaconda/envs/earth-analytics-python/lib/python3.6/site-packages/ipykernel/__main__.py:1: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
      if __name__ == '__main__':



## Exploring Most Positive and Negative Tweets

Since the sentiment value of each tweet, as determined by `textblob` is now a column in your dataframe you can sort by descending and ascending sentiment values to check out some of the most positive and negative tweets. Remember that sentiment values range from -1 to 1. For more information on `Textblob` checkout its [documentation](http://textblob.readthedocs.io/en/dev/quickstart.html). 

{:.input}
```python
df_neg = df_small.sort_values(by = ['polarity'], ascending = True)

df_neg[:10]
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
      <th>text</th>
      <th>created_at</th>
      <th>polarity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>15303</th>
      <td>All the years living in Oklahoma have not prep...</td>
      <td>Fri Sep 13 04:14:30 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>13217</th>
      <td>Praying for my friends and family in #Boulder ...</td>
      <td>Fri Sep 13 18:49:39 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>15482</th>
      <td>BREAKING: Devastating rain totals out of Color...</td>
      <td>Fri Sep 13 02:48:50 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>14483</th>
      <td>RT @PhotoLesa: Never been so grateful to be on...</td>
      <td>Fri Sep 13 06:17:11 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>6923</th>
      <td>Boulder healers volunteer to help rebuild comm...</td>
      <td>Thu Sep 26 17:54:51 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>15427</th>
      <td>RT @NowInAmerica: Shocking photos of #boulderf...</td>
      <td>Fri Sep 13 03:29:54 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>2168</th>
      <td>I wish I could sleep from tonight until the we...</td>
      <td>Tue Dec 03 13:34:58 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>2942</th>
      <td>Hysterical MT @jfleck: From Colorado, a call f...</td>
      <td>Sun Nov 24 17:17:10 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>18189</th>
      <td>RT @crescentcomp: Broadway &amp;amp; Dellwood. Not...</td>
      <td>Thu Sep 12 08:45:07 +0000 2013</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>18164</th>
      <td>RT @JimCantore: Just up hearing about this.  A...</td>
      <td>Thu Sep 12 09:13:59 +0000 2013</td>
      <td>-1.0</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
df_pos = df_small.sort_values(by = ['polarity'], ascending = False)
df_pos[:10]
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
      <th>text</th>
      <th>created_at</th>
      <th>polarity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>13196</th>
      <td>It may have been flooding, but we made the bes...</td>
      <td>Fri Sep 13 19:14:19 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>4743</th>
      <td>Surprise someone with the perfect sushi dinner...</td>
      <td>Wed Oct 30 20:25:52 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>4704</th>
      <td>Def the best day ever! RT @kkinnetz: The best ...</td>
      <td>Wed Oct 30 18:49:38 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>3098</th>
      <td>Perfect day ✌️ #classicwhitegirlpost #starbuck...</td>
      <td>Fri Nov 22 00:21:44 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>5411</th>
      <td>Delicious almond milk chai in #Boulder on a wo...</td>
      <td>Mon Oct 21 00:05:42 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>844</th>
      <td>This is why Colorado is the best state. #1DtoC...</td>
      <td>Mon Dec 16 00:01:41 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>5977</th>
      <td>Perfect days for some chai, no?  http://t.co/n...</td>
      <td>Mon Oct 14 19:43:51 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>847</th>
      <td>Showing my cousin @courtneysmiller the best of...</td>
      <td>Sat Dec 14 19:27:47 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>8927</th>
      <td>The awesome @MarianCall is holding an online c...</td>
      <td>Tue Sep 17 18:59:27 +0000 2013</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>10646</th>
      <td>Sending you strength and well-wishes, @heyheyg...</td>
      <td>Sun Sep 15 18:55:05 +0000 2013</td>
      <td>1.0</td>
    </tr>
  </tbody>
</table>
</div>




