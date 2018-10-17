---
layout: single
title: 'Twitter Data and 2013 Boulder Flood'
excerpt: 'This lesson provides an example of analyzing twitter data around a natural disaster.'
authors: ['Martha Morrissey', 'Leah Wasser','Carson Farmer']
modified: 2018-10-08
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/earth-analytics/get-data-using-apis/text-mine-colorado-flood-tweets-science-python/
nav-title: 'Text Mine CO Flood Tweets'
week: 12 
sidebar:
    nav:
author_profile: false
comments: true
order: 4
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Convert a `json` file into a `pandas` `DataFrame`
* Use the `nltk` and `re` packages in `Python` to text mine social media data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 13 Data (~80 MB)](https://ndownloader.figshare.com/files/9751453?private_link=92e248fddafa3af15b98){:data-proofer-ignore='' .btn }

</div>

In the previous lesson you learned the basics of preparing social media data for
analysis. In this lesson you will learn to text mine tweets and filter them by date. 

The structure of twitter data is complex. In this lesson you will only work with  the text data of tweets even though there is much more information that you could analyze.

## Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

For this lesson you will be analyzing data from twitter that has already been collected from the Twitter API and available for you to download from figshare. 

{:.input}
```python
import os
import json
import earthpy as et
import pandas as pd
from pandas.io.json import json_normalize
import re
import nltk
nltk.download('stopwords')
from nltk.corpus import stopwords
import collections
import matplotlib.pyplot as plt
from nltk import bigrams 
%matplotlib inline
from datetime import datetime
```

{:.output}
    [nltk_data] Downloading package stopwords to
    [nltk_data]     /Users/marthamorrissey/nltk_data...
    [nltk_data]   Package stopwords is already up-to-date!



{:.input}
```python
stop_words = set(stopwords.words('english'))
```

You will use the built in `Python` library `json` to read in the json data. Each line from the file is read in and you are able to work with that file because it is now a `Python` `list`. Just taking a quick look at the first few items of the tweets list, shows that this data still looks like a `json` file, to get this data into a `Pandas` `DataFrame` you can use the handy`Pandas` `json_normalize` function. 

{:.input}
```python
tweets = []
for line in open('data/twitter_data/boulder_flood_geolocated_tweets.json', 'r'):
    tweets.append(json.loads(line))
```

{:.input}
```python
tweets[:5]
```

{:.output}
{:.execute_result}



    [{'contributors': None,
      'coordinates': {'coordinates': [-118.10041174, 34.14628356],
       'type': 'Point'},
      'created_at': 'Tue Dec 31 07:14:22 +0000 2013',
      'entities': {'hashtags': [{'indices': [28, 34], 'text': 'drunk'},
        {'indices': [35, 43], 'text': 'islands'},
        {'indices': [44, 55], 'text': 'girlsnight'},
        {'indices': [57, 61], 'text': 'BJs'},
        {'indices': [62, 69], 'text': 'hookah'},
        {'indices': [70, 78], 'text': 'zephyrs'},
        {'indices': [79, 87], 'text': 'boulder'},
        {'indices': [88, 96], 'text': 'marines'}],
       'symbols': [],
       'urls': [{'display_url': 'instagram.com/p/ik8V-PLAV5/',
         'expanded_url': 'http://instagram.com/p/ik8V-PLAV5/',
         'indices': [98, 120],
         'url': 'http://t.co/uYmu7c4o0x'}],
       'user_mentions': []},
      'favorite_count': 0,
      'favorited': False,
      'geo': {'coordinates': [34.14628356, -118.10041174], 'type': 'Point'},
      'id': 417916626596806656,
      'id_str': '417916626596806656',
      'in_reply_to_screen_name': None,
      'in_reply_to_status_id': None,
      'in_reply_to_status_id_str': None,
      'in_reply_to_user_id': None,
      'in_reply_to_user_id_str': None,
      'is_quote_status': False,
      'lang': 'en',
      'place': {'attributes': {},
       'bounding_box': {'coordinates': [[[-118.198346, 34.117025],
          [-118.065582, 34.117025],
          [-118.065582, 34.237595],
          [-118.198346, 34.237595]]],
        'type': 'Polygon'},
       'contained_within': [],
       'country': 'United States',
       'country_code': 'US',
       'full_name': 'Pasadena, CA',
       'id': '10de09f288b1665c',
       'name': 'Pasadena',
       'place_type': 'city',
       'url': 'https://api.twitter.com/1.1/geo/id/10de09f288b1665c.json'},
      'possibly_sensitive': False,
      'retweet_count': 0,
      'retweeted': False,
      'source': '<a href="http://instagram.com" rel="nofollow">Instagram</a>',
      'text': 'Boom bitch get out the way! #drunk #islands #girlsnight  #BJs #hookah #zephyrs #boulder #marines… http://t.co/uYmu7c4o0x',
      'truncated': False,
      'user': {'contributors_enabled': False,
       'created_at': 'Wed Dec 07 00:52:56 +0000 2011',
       'default_profile': True,
       'default_profile_image': False,
       'description': "if you're good at something, never do it for free --The Joker",
       'entities': {'description': {'urls': []},
        'url': {'urls': [{'display_url': 'makeupbydeeaguayo.weebly.com',
           'expanded_url': 'http://www.makeupbydeeaguayo.weebly.com',
           'indices': [0, 22],
           'url': 'http://t.co/QeGU8kLjps'}]}},
       'favourites_count': 2750,
       'follow_request_sent': False,
       'followers_count': 58,
       'following': False,
       'friends_count': 227,
       'geo_enabled': True,
       'has_extended_profile': False,
       'id': 430309700,
       'id_str': '430309700',
       'is_translation_enabled': False,
       'is_translator': False,
       'lang': 'en',
       'listed_count': 2,
       'location': '...City girl.Country feel...',
       'name': 'Dannie Aguayo',
       'notifications': False,
       'profile_background_color': 'C0DEED',
       'profile_background_image_url': 'http://abs.twimg.com/images/themes/theme1/bg.png',
       'profile_background_image_url_https': 'https://abs.twimg.com/images/themes/theme1/bg.png',
       'profile_background_tile': False,
       'profile_banner_url': 'https://pbs.twimg.com/profile_banners/430309700/1409632278',
       'profile_image_url': 'http://pbs.twimg.com/profile_images/581929927320027137/AqqFsVW__normal.jpg',
       'profile_image_url_https': 'https://pbs.twimg.com/profile_images/581929927320027137/AqqFsVW__normal.jpg',
       'profile_link_color': '1DA1F2',
       'profile_sidebar_border_color': 'C0DEED',
       'profile_sidebar_fill_color': 'DDEEF6',
       'profile_text_color': '333333',
       'profile_use_background_image': True,
       'protected': False,
       'screen_name': 'lilcakes3209',
       'statuses_count': 4441,
       'time_zone': None,
       'translator_type': 'none',
       'url': 'http://t.co/QeGU8kLjps',
       'utc_offset': None,
       'verified': False}},
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
       'verified': False}},
     {'contributors': None,
      'coordinates': {'coordinates': [0.13429814, 52.22500698], 'type': 'Point'},
      'created_at': 'Mon Dec 30 20:29:20 +0000 2013',
      'entities': {'hashtags': [{'indices': [20, 28], 'text': 'boulder'}],
       'media': [{'display_url': 'pic.twitter.com/ZMfNKEl0xD',
         'expanded_url': 'https://twitter.com/buns92/status/417754295455723520/photo/1',
         'id': 417754295334088704,
         'id_str': '417754295334088704',
         'indices': [29, 51],
         'media_url': 'http://pbs.twimg.com/media/BcwpUXjIMAA_PrX.jpg',
         'media_url_https': 'https://pbs.twimg.com/media/BcwpUXjIMAA_PrX.jpg',
         'sizes': {'large': {'h': 604, 'resize': 'fit', 'w': 362},
          'medium': {'h': 604, 'resize': 'fit', 'w': 362},
          'small': {'h': 604, 'resize': 'fit', 'w': 362},
          'thumb': {'h': 150, 'resize': 'crop', 'w': 150}},
         'type': 'photo',
         'url': 'http://t.co/ZMfNKEl0xD'}],
       'symbols': [],
       'urls': [],
       'user_mentions': []},
      'extended_entities': {'media': [{'display_url': 'pic.twitter.com/ZMfNKEl0xD',
         'expanded_url': 'https://twitter.com/buns92/status/417754295455723520/photo/1',
         'id': 417754295334088704,
         'id_str': '417754295334088704',
         'indices': [29, 51],
         'media_url': 'http://pbs.twimg.com/media/BcwpUXjIMAA_PrX.jpg',
         'media_url_https': 'https://pbs.twimg.com/media/BcwpUXjIMAA_PrX.jpg',
         'sizes': {'large': {'h': 604, 'resize': 'fit', 'w': 362},
          'medium': {'h': 604, 'resize': 'fit', 'w': 362},
          'small': {'h': 604, 'resize': 'fit', 'w': 362},
          'thumb': {'h': 150, 'resize': 'crop', 'w': 150}},
         'type': 'photo',
         'url': 'http://t.co/ZMfNKEl0xD'}]},
      'favorite_count': 0,
      'favorited': False,
      'geo': {'coordinates': [52.22500698, 0.13429814], 'type': 'Point'},
      'id': 417754295455723520,
      'id_str': '417754295455723520',
      'in_reply_to_screen_name': None,
      'in_reply_to_status_id': None,
      'in_reply_to_status_id_str': None,
      'in_reply_to_user_id': None,
      'in_reply_to_user_id_str': None,
      'is_quote_status': False,
      'lang': 'en',
      'place': {'attributes': {},
       'bounding_box': {'coordinates': [[[0.068616, 52.157943],
          [0.18453, 52.157943],
          [0.18453, 52.23723],
          [0.068616, 52.23723]]],
        'type': 'Polygon'},
       'contained_within': [],
       'country': 'United Kingdom',
       'country_code': 'GB',
       'full_name': 'Cambridge, England',
       'id': 'e0a47a1daac8224e',
       'name': 'Cambridge',
       'place_type': 'city',
       'url': 'https://api.twitter.com/1.1/geo/id/e0a47a1daac8224e.json'},
      'possibly_sensitive': False,
      'retweet_count': 0,
      'retweeted': False,
      'source': '<a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>',
      'text': 'Story of my life! 😂 #boulder http://t.co/ZMfNKEl0xD',
      'truncated': False,
      'user': {'contributors_enabled': False,
       'created_at': 'Wed Apr 01 15:09:30 +0000 2009',
       'default_profile': False,
       'default_profile_image': False,
       'description': "History graduate, 24, not as nerdy as you'd expect. Oh, and have you ever seen Batman and I in the same room? Didn't think so.",
       'entities': {'description': {'urls': []}},
       'favourites_count': 364,
       'follow_request_sent': False,
       'followers_count': 378,
       'following': False,
       'friends_count': 401,
       'geo_enabled': True,
       'has_extended_profile': True,
       'id': 28122813,
       'id_str': '28122813',
       'is_translation_enabled': False,
       'is_translator': False,
       'lang': 'en',
       'listed_count': 2,
       'location': 'Cambridge, England',
       'name': 'Chelsea Hider',
       'notifications': False,
       'profile_background_color': '0F0A02',
       'profile_background_image_url': 'http://pbs.twimg.com/profile_background_images/758730145/66b218fd7040a28f7edaba70457417a2.jpeg',
       'profile_background_image_url_https': 'https://pbs.twimg.com/profile_background_images/758730145/66b218fd7040a28f7edaba70457417a2.jpeg',
       'profile_background_tile': False,
       'profile_banner_url': 'https://pbs.twimg.com/profile_banners/28122813/1415284914',
       'profile_image_url': 'http://pbs.twimg.com/profile_images/914256738823675905/w2-MYg5T_normal.jpg',
       'profile_image_url_https': 'https://pbs.twimg.com/profile_images/914256738823675905/w2-MYg5T_normal.jpg',
       'profile_link_color': '473623',
       'profile_sidebar_border_color': 'BCB302',
       'profile_sidebar_fill_color': '171106',
       'profile_text_color': '8A7302',
       'profile_use_background_image': True,
       'protected': False,
       'screen_name': 'ChelseaHider',
       'statuses_count': 3234,
       'time_zone': 'London',
       'translator_type': 'none',
       'url': None,
       'utc_offset': 0,
       'verified': False}},
     {'contributors': None,
      'coordinates': None,
      'created_at': 'Mon Dec 30 23:02:29 +0000 2013',
      'entities': {'hashtags': [{'indices': [105, 113], 'text': 'Boulder'},
        {'indices': [114, 117], 'text': 'CO'}],
       'symbols': [],
       'urls': [{'display_url': 'jpaxonreyes.tumblr.com/post/710269261…',
         'expanded_url': 'http://jpaxonreyes.tumblr.com/post/71026926143/hit-and-run-in-boulder',
         'indices': [118, 140],
         'url': 'http://t.co/zyk3FkB4og'}],
       'user_mentions': []},
      'favorite_count': 0,
      'favorited': False,
      'geo': None,
      'id': 417792838428925952,
      'id_str': '417792838428925952',
      'in_reply_to_screen_name': None,
      'in_reply_to_status_id': None,
      'in_reply_to_status_id_str': None,
      'in_reply_to_user_id': None,
      'in_reply_to_user_id_str': None,
      'is_quote_status': False,
      'lang': 'en',
      'place': None,
      'possibly_sensitive': False,
      'retweet_count': 0,
      'retweeted': False,
      'source': '<a href="http://www.tweetcaster.com" rel="nofollow">TweetCaster for Android</a>',
      'text': "We're looking for the two who came to help a cyclist after a hit-and-run at 30th/Baseline ~11pm Dec 23rd #Boulder #CO http://t.co/zyk3FkB4og",
      'truncated': False,
      'user': {'contributors_enabled': False,
       'created_at': 'Fri Mar 27 14:59:23 +0000 2009',
       'default_profile': False,
       'default_profile_image': False,
       'description': 'Graduate student at the University of Nebraska - Lincoln.',
       'entities': {'description': {'urls': []},
        'url': {'urls': [{'display_url': 'flickr.com/people/jpaxonr…',
           'expanded_url': 'http://flickr.com/people/jpaxonreyes',
           'indices': [0, 22],
           'url': 'http://t.co/u0aaW84Avc'}]}},
       'favourites_count': 934,
       'follow_request_sent': False,
       'followers_count': 530,
       'following': False,
       'friends_count': 525,
       'geo_enabled': True,
       'has_extended_profile': False,
       'id': 27020339,
       'id_str': '27020339',
       'is_translation_enabled': False,
       'is_translator': False,
       'lang': 'en',
       'listed_count': 20,
       'location': 'Lincoln, Nebraska',
       'name': 'J. Paxon Reyes',
       'notifications': False,
       'profile_background_color': 'FFFFFF',
       'profile_background_image_url': 'http://pbs.twimg.com/profile_background_images/340771307/DSC_0618.jpg',
       'profile_background_image_url_https': 'https://pbs.twimg.com/profile_background_images/340771307/DSC_0618.jpg',
       'profile_background_tile': False,
       'profile_banner_url': 'https://pbs.twimg.com/profile_banners/27020339/1402505068',
       'profile_image_url': 'http://pbs.twimg.com/profile_images/703184656733057025/MGWdgTyY_normal.jpg',
       'profile_image_url_https': 'https://pbs.twimg.com/profile_images/703184656733057025/MGWdgTyY_normal.jpg',
       'profile_link_color': 'FF3300',
       'profile_sidebar_border_color': '279DA3',
       'profile_sidebar_fill_color': 'E0E0E0',
       'profile_text_color': '333333',
       'profile_use_background_image': True,
       'protected': False,
       'screen_name': 'jpreyes',
       'statuses_count': 8220,
       'time_zone': 'Central Time (US & Canada)',
       'translator_type': 'none',
       'url': 'http://t.co/u0aaW84Avc',
       'utc_offset': -21600,
       'verified': False}},
     {'contributors': None,
      'coordinates': {'coordinates': [144.98467167, -37.80312131],
       'type': 'Point'},
      'created_at': 'Wed Jan 01 06:12:15 +0000 2014',
      'entities': {'hashtags': [{'indices': [15, 23], 'text': 'Boulder'}],
       'symbols': [],
       'urls': [],
       'user_mentions': []},
      'favorite_count': 0,
      'favorited': False,
      'geo': {'coordinates': [-37.80312131, 144.98467167], 'type': 'Point'},
      'id': 418263379027820544,
      'id_str': '418263379027820544',
      'in_reply_to_screen_name': None,
      'in_reply_to_status_id': None,
      'in_reply_to_status_id_str': None,
      'in_reply_to_user_id': None,
      'in_reply_to_user_id_str': None,
      'is_quote_status': False,
      'lang': 'en',
      'place': None,
      'retweet_count': 0,
      'retweeted': False,
      'source': '<a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>',
      'text': 'Happy New Year #Boulder !!!! What are some of your New Years resolutions this year?',
      'truncated': False,
      'user': {'contributors_enabled': False,
       'created_at': 'Fri Mar 05 17:05:23 +0000 2010',
       'default_profile': False,
       'default_profile_image': False,
       'description': 'Green Streets transforms communities & people through car-free street experiences. We create measurable social & environmental impact. Ciclovia Is 9/27/2015',
       'entities': {'description': {'urls': []},
        'url': {'urls': [{'display_url': 'bouldergreenstreets.org',
           'expanded_url': 'http://bouldergreenstreets.org',
           'indices': [0, 22],
           'url': 'http://t.co/HT9r4vA9aU'}]}},
       'favourites_count': 140,
       'follow_request_sent': False,
       'followers_count': 1754,
       'following': False,
       'friends_count': 1963,
       'geo_enabled': True,
       'has_extended_profile': False,
       'id': 120161415,
       'id_str': '120161415',
       'is_translation_enabled': False,
       'is_translator': False,
       'lang': 'en',
       'listed_count': 95,
       'location': 'Boulder, Colorado',
       'name': 'Boulder, CO Ciclovia',
       'notifications': False,
       'profile_background_color': '233294',
       'profile_background_image_url': 'http://pbs.twimg.com/profile_background_images/355460837/bgs.logo.web.jpg',
       'profile_background_image_url_https': 'https://pbs.twimg.com/profile_background_images/355460837/bgs.logo.web.jpg',
       'profile_background_tile': True,
       'profile_banner_url': 'https://pbs.twimg.com/profile_banners/120161415/1369270210',
       'profile_image_url': 'http://pbs.twimg.com/profile_images/897682689/BGS.weblogo_normal.jpg',
       'profile_image_url_https': 'https://pbs.twimg.com/profile_images/897682689/BGS.weblogo_normal.jpg',
       'profile_link_color': '0084B4',
       'profile_sidebar_border_color': 'A8C7F7',
       'profile_sidebar_fill_color': 'C0DFEC',
       'profile_text_color': '333333',
       'profile_use_background_image': True,
       'protected': False,
       'screen_name': 'BoulderGreenSts',
       'statuses_count': 1988,
       'time_zone': 'Mountain Time (US & Canada)',
       'translator_type': 'none',
       'url': 'http://t.co/HT9r4vA9aU',
       'utc_offset': -25200,
       'verified': False}}]





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





### Cleaning Data

The text of the tweet is in the text column of the `DataFrame`. Work to clean just this column and determine the most commonly used words. Remember cleaning the tweets invovles: 
* removing special characters 
* removing stop words 
* removing collection words 
For this specific data collection words include "boulderflood" and "coflood"

{:.input}
```python
tweet_lst = df['text']
```

{:.input}
```python
def clean_tweet(tweet):
    return ' '.join(re.sub("([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())
```

{:.input}
```python
cleaned = [clean_tweet(tweet) for tweet in tweet_lst]
```

{:.input}
```python
cleaned[5]
```

{:.output}
{:.execute_result}



    'simon Says so Nearly 60 degrees in Boulder today Great place to live'





{:.input}
```python
words_in_tweet = [tweet.split() for tweet in cleaned] 
words_in_tweet_l = [[w.lower() for w in word] for word in words_in_tweet]
```

{:.input}
```python
tweets_nsw = [[w for w in word if not w in stop_words] for word in words_in_tweet_l]
```

{:.input}
```python
tweets_nsw[0]
```

{:.output}
{:.execute_result}



    ['boom',
     'bitch',
     'get',
     'way',
     'drunk',
     'islands',
     'girlsnight',
     'bjs',
     'hookah',
     'zephyrs',
     'boulder',
     'marines']





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
all_words = [item for sublist in tweets_nsw2 for item in sublist]
```

{:.input}
```python
counts = collections.Counter(all_words)
```

{:.input}
```python
counts.most_common(10)
```

{:.output}
{:.execute_result}



    [('boulder', 7116),
     ('colorado', 2360),
     ('denver', 1528),
     ('flood', 1316),
     ('snow', 1268),
     ('amp', 1243),
     ('weather', 1071),
     ('creek', 973),
     ('water', 901),
     ('rain', 836)]





To visualize the most commonly occuring words you will need to convert the `dictonary` of counts into a `DataFrame`.

{:.input}
```python
df_counts = pd.DataFrame.from_dict(counts, orient='index').reset_index()
df_counts.columns = ['words', 'count']
sorted_df = df_counts.sort_values(by='count', ascending = False)
sorted_df_s = sorted_df[:10]
plt.bar(sorted_df_s['words'], sorted_df_s['count'], color = 'purple');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/12-api/twitter-api/2018-02-05-twitter-04-flood-data_25_0.png">

</figure>




## Bigram Analysis

{:.input}
```python
terms_bigram = [list(bigrams(tweet)) for tweet in tweets_nsw2]
from collections import Counter

bigram_counts = Counter()
for lst in terms_bigram:
    for bigram in lst:
        bigram_counts[bigram] += 1
        
bigram_counts.most_common(20)
```

{:.output}
{:.execute_result}



    [(('boulder', 'colorado'), 469),
     (('boulder', 'creek'), 440),
     (('boulder', 'county'), 272),
     (('flash', 'flood'), 188),
     (('boulder', 'canyon'), 185),
     (('wall', 'water'), 180),
     (('higher', 'ground'), 174),
     (('dailycamera', 'boulder'), 167),
     (('flood', 'warning'), 150),
     (('last', 'night'), 147),
     (('boulder', 'co'), 145),
     (('weather', 'denver'), 144),
     (('big', 'thompson'), 125),
     (('stay', 'safe'), 111),
     (('denver', 'weather'), 109),
     (('denver', 'metro'), 105),
     (('denver', 'boulder'), 104),
     (('boulder', 'flood'), 101),
     (('colorado', 'boulder'), 94),
     (('looks', 'like'), 93)]





## Filtering Tweets by Date

You can learn what the tweet was written from the `created_at` attribute. To filter tweets by date, you can convert them to a `datetime` object, and then filter by a specific range of dates. In this lesson you will just get the tweets created in September of 2013. 

{:.input}
```python
df_small = df[['created_at', 'text']]
```

{:.input}
```python
df_small['created_at'][0]
```

{:.output}
{:.execute_result}



    'Tue Dec 31 07:14:22 +0000 2013'





{:.input}
```python
df_small['dt'] = [datetime.strptime(x, '%a %b %d %X %z %Y') for x in df_small['created_at']]
```

{:.output}
    //anaconda/envs/earth-analytics-python/lib/python3.6/site-packages/ipykernel/__main__.py:1: SettingWithCopyWarning: 
    A value is trying to be set on a copy of a slice from a DataFrame.
    Try using .loc[row_indexer,col_indexer] = value instead
    
    See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/indexing.html#indexing-view-versus-copy
      if __name__ == '__main__':



{:.input}
```python
sept_tweets = df_small[(df_small['dt'] > '2013-09-01') & (df_small['dt'] < '2013-09-30')]
```

{:.input}
```python
sept_tweets.head()
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
      <th>created_at</th>
      <th>text</th>
      <th>dt</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>6490</th>
      <td>Sun Sep 29 23:34:35 +0000 2013</td>
      <td>Temps ~15-25°+ below normal by Friday. Probabl...</td>
      <td>2013-09-29 23:34:35+00:00</td>
    </tr>
    <tr>
      <th>6491</th>
      <td>Sun Sep 29 23:30:58 +0000 2013</td>
      <td>Colorado, thanks for showing us a good time! #...</td>
      <td>2013-09-29 23:30:58+00:00</td>
    </tr>
    <tr>
      <th>6492</th>
      <td>Sun Sep 29 16:36:43 +0000 2013</td>
      <td>Help rebuild #Boulder and the #FrontRange afte...</td>
      <td>2013-09-29 16:36:43+00:00</td>
    </tr>
    <tr>
      <th>6493</th>
      <td>Sun Sep 29 15:40:58 +0000 2013</td>
      <td>The snow capped #Rockies sure look pretty this...</td>
      <td>2013-09-29 15:40:58+00:00</td>
    </tr>
    <tr>
      <th>6494</th>
      <td>Sun Sep 29 19:24:09 +0000 2013</td>
      <td>Wildflowers &amp;amp; lake on #Colorado's Grand Me...</td>
      <td>2013-09-29 19:24:09+00:00</td>
    </tr>
  </tbody>
</table>
</div>




