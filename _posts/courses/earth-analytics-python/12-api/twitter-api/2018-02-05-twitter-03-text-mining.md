---
layout: single
title: 'Twitter Data in Python Using Tweepy: Clean Twitter Data'
excerpt: 'Learn how to use clean twitter data in Python before analysis.'
authors: ['Martha Morrissey', 'Jeremey Diaz', 'Leah Wasser']
modified: 2018-07-27
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/earth-analytics-python/get-data-using-apis/text-mining-python/
nav-title: 'Intro to Text Mining'
week: 12 
sidebar:
    nav:
author_profile: false
comments: true
order: 3
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Clean or "munge" social media data to prepare it for analysis.
* Explore and analyze word counts associated with tweets.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In this lesson you will dive deeper into using twitter to understand a particular
topic or event. You will learn more about text mining.

## Data Munging  101

When you work with social media and other text data the user community creates and
curates the content. This means there are NO RULES! This also means that you may
have to perform extra steps to clean the data to ensure you are analyzing the right
thing.

When you work with data from sources like NASA, USGS, etc there are particular
cleaning steps that you often need to do and the data generally have a set structure in terms of file formats and metadata. For instance:

* you may need to remove nodata values
* you may need to scale the data
* and more



## Searching for Tweets Related to Climate

Next, look at a different workflow - exploring the actual text of the tweets 
which will involve some text mining.

In this example, you will find tweets that are using the words "climate change" in them.

First, you will load the `tweepy` and other needed `Python` packages. 

{:.input}
```python
import tweepy 
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import nltk
nltk.download('stopwords')
from nltk.corpus import stopwords
import re
import networkx
import matplotlib.pyplot as plt
%matplotlib inline
```

{:.output}
    [nltk_data] Downloading package stopwords to
    [nltk_data]     /Users/marthamorrissey/nltk_data...
    [nltk_data]   Package stopwords is already up-to-date!



Remember to define your keys: 

```python 
consumer_key= 'yourkeyhere'
consumer_secret= 'yourkeyhere'
access_token= 'yourkeyhere'
access_token_secret= 'yourkeyhere'
```

{:.input}
```python
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth,wait_on_rate_limit=True)
```

Now that you've authenticated you're ready to search for tweets that contain `#climatechange`

{:.input}
```python
cc_tweets = []
for tweet in tweepy.Cursor(api.search, q="#climatechange -filter:retweets",
                           lang="en", since = '2018-04-23').items(1000):
     cc_tweets.append(tweet.text)
```

{:.input}
```python
cc_tweets[:5]
```

{:.output}
{:.execute_result}



    ['Heard of cactus pear? Why this food-of-last-resort deserves a place on the menu 👉 https://t.co/jLT7O307T7 #climatechange #ZeroHunger',
     'Webinar and Conference: Humid #Climate Conference, May 21-22, #Austin, #TX: https://t.co/9syQzY9Apt @phius1… https://t.co/DsRVeqeObp',
     'Last week Year 10 students had a lesson live from the Arctic Circle!\n\nWe looked at how our pollution is acidifying… https://t.co/wiQYkKvpjh',
     'New issue of Climate Change Daily is out! https://t.co/FOGznfcdyi #climatechange',
     '#Pakistan has gone from water surplus to water-stressed, via @etribune h/t @thedailyclimate:… https://t.co/DGO7YWPypD']





Look at the results. Note any issues with your data? It seems like when you search for climate change, you get tweets that contain the words climate and change in them - but these tweets are not necessarily all related to your science topic of interest. Or are they? You can modify your search querry to look for tweets that include the words climate change together. 

{:.input}
```python
cc_tweets2 = []
for tweet in tweepy.Cursor(api.search, q="#climate+change -filter:retweets",
                           lang="en").items(1000):
     cc_tweets2.append(tweet.text)
```

{:.input}
```python
len(cc_tweets2)
```

{:.output}
{:.execute_result}



    1000





{:.input}
```python
cc_tweets2[:5]
```

{:.output}
{:.execute_result}



    ['Linguistic analysis shows #Oilcompanies are giving up on #climatechange - #ClimateAction #climate #Oil #oilmarket… https://t.co/x2EHCnEBDx',
     '“The UN’s Intergovernmental Panel on Climate Change (the IPCC), [has failed] to educate global leaders on all criti… https://t.co/P3gS9W1B6U',
     '“The UN’s Intergovernmental Panel on Climate Change (the IPCC), [has failed] to educate global leaders on all criti… https://t.co/4vI5qk6zBo',
     'Is it time for insurance policies for reefs, mangroves and fish as #climate change hits oceans?… https://t.co/pjV4oA5chJ',
     'Latest @pewresearch poll shows slight narrowing of partisan gap on #climate, thanks to millennial Republicans. Mean… https://t.co/H8ePopGWLg']





### Data Clean-Up
Looking at the data above, it becomes clear that there is a lot of clean-up associated with social media data.

First, there are url’s in your tweets. If you want to do a text analysis to figure out what words are most common in your tweets, the URL’s won’t be helpful. Let’s remove those:

{:.input}
```python
def clean_tweet(tweet):
    return ' '.join(re.sub("([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())
```

{:.input}
```python
cleaned = [clean_tweet(tweet) for tweet in cc_tweets2]
```

{:.input}
```python
cleaned[:5]
```

{:.output}
{:.execute_result}



    ['Maybe these sorts of numbers can become efficiency dividend targets by TurnbullMalcolm and the Coalition to real',
     'Achieving the toughest climate change target set in the ParisAgreement will save the world about 30tn in damages',
     'MBjorklund1963 This is global Climate Change friendly propaganda He s hitting right wing media w his oil and gas BS',
     'Getting rid of fossilfuels by mid century and making the switch to large scale renewableenergy sources and nucle',
     'If climate change causes the ice sheet to thin these troughs could increase the speed at which ice flows from th']





Now was have a list of tweets without hypyterlinks and punctuation. Now, you can clean up your text a little more to make it usable for analysis. If you are trying to create a list of unique words in your tweets, words with capitalization will be different from words that are all lowercase.

{:.input}
```python
# note the elements of the list that Python thinks are unique
ex_list  = ["Dog", "dog", "dog", "cat", "cat", ","]
set(ex_list)
```

{:.output}
{:.execute_result}



    {',', 'Dog', 'cat', 'dog'}





Right now you have a list of lists that contains each tweet, now create a list of lists that has each word of the tweet as elements of the sublist. A tweet is limited to 140 characters, but let's see how many words (not including links) people that recently tweeted about climate change used.

{:.input}
```python
words_in_tweet = [tweet.split() for tweet in cleaned] 
```

{:.input}
```python
tweet_word_count = [len(word) for word in words_in_tweet]
```

{:.input}
```python
tweet_word_count[1]
```

{:.output}
{:.execute_result}



    18





{:.input}
```python
# Getting the average word count
average_word_count = np.mean(tweet_word_count)
# Printing this value out in a text statement
print('The average number of words written is %0.6f' % average_word_count)

# Plotting the histogram
plt.hist(tweet_word_count,
         bins = 50)                    
# Adding labels of specified sizes
plt.xlabel('Word Count', fontsize = 15)
plt.ylabel('Frequency', fontsize = 15)
plt.title("What's the word count distribution?", fontsize = 18)
# Plot a line for the average value
plt.axvline(x = average_word_count,
            lw = 2,                       # Make this line thicker...
            color = 'red',                # And red...
            linestyle = '--');            # And dashed...
plt.style.use('seaborn')
```

{:.output}
    The average number of words written is 15.808000



{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/12-api/twitter-api/2018-02-05-twitter-03-text-mining_22_1.png)




## Removing Stopwords using `nltk`

The `python` package `nltk` is commonly used for text analysis. Included in this apckage is a list of "stop words", tese include commonly appearing words such as  who, what, you, ect. that generally don't add meaningful information to the text you are tyring to analysis. 

{:.input}
```python
stop_words = set(stopwords.words('english'))
stop_words
```

{:.output}
{:.execute_result}



    {'a',
     'about',
     'above',
     'after',
     'again',
     'against',
     'ain',
     'all',
     'am',
     'an',
     'and',
     'any',
     'are',
     'aren',
     "aren't",
     'as',
     'at',
     'be',
     'because',
     'been',
     'before',
     'being',
     'below',
     'between',
     'both',
     'but',
     'by',
     'can',
     'couldn',
     "couldn't",
     'd',
     'did',
     'didn',
     "didn't",
     'do',
     'does',
     'doesn',
     "doesn't",
     'doing',
     'don',
     "don't",
     'down',
     'during',
     'each',
     'few',
     'for',
     'from',
     'further',
     'had',
     'hadn',
     "hadn't",
     'has',
     'hasn',
     "hasn't",
     'have',
     'haven',
     "haven't",
     'having',
     'he',
     'her',
     'here',
     'hers',
     'herself',
     'him',
     'himself',
     'his',
     'how',
     'i',
     'if',
     'in',
     'into',
     'is',
     'isn',
     "isn't",
     'it',
     "it's",
     'its',
     'itself',
     'just',
     'll',
     'm',
     'ma',
     'me',
     'mightn',
     "mightn't",
     'more',
     'most',
     'mustn',
     "mustn't",
     'my',
     'myself',
     'needn',
     "needn't",
     'no',
     'nor',
     'not',
     'now',
     'o',
     'of',
     'off',
     'on',
     'once',
     'only',
     'or',
     'other',
     'our',
     'ours',
     'ourselves',
     'out',
     'over',
     'own',
     're',
     's',
     'same',
     'shan',
     "shan't",
     'she',
     "she's",
     'should',
     "should've",
     'shouldn',
     "shouldn't",
     'so',
     'some',
     'such',
     't',
     'than',
     'that',
     "that'll",
     'the',
     'their',
     'theirs',
     'them',
     'themselves',
     'then',
     'there',
     'these',
     'they',
     'this',
     'those',
     'through',
     'to',
     'too',
     'under',
     'until',
     'up',
     've',
     'very',
     'was',
     'wasn',
     "wasn't",
     'we',
     'were',
     'weren',
     "weren't",
     'what',
     'when',
     'where',
     'which',
     'while',
     'who',
     'whom',
     'why',
     'will',
     'with',
     'won',
     "won't",
     'wouldn',
     "wouldn't",
     'y',
     'you',
     "you'd",
     "you'll",
     "you're",
     "you've",
     'your',
     'yours',
     'yourself',
     'yourselves'}





Notice that the stop words provided by nltk are all lower-case, you will need to change all of the words in the tweets to lower-case. This can be done with the built in `python` `string` method `.lower()`

{:.input}
```python
words_in_tweet_l = [[w.lower() for w in word] for word in words_in_tweet]

words_in_tweet_l[0]
```

{:.output}
{:.execute_result}



    ['maybe',
     'these',
     'sorts',
     'of',
     'numbers',
     'can',
     'become',
     'efficiency',
     'dividend',
     'targets',
     'by',
     'turnbullmalcolm',
     'and',
     'the',
     'coalition',
     'to',
     'real']





Compare the words in that tweet, to the words in the tweet once the stop words are removed: 

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



    ['maybe',
     'sorts',
     'numbers',
     'become',
     'efficiency',
     'dividend',
     'targets',
     'turnbullmalcolm',
     'coalition',
     'real']





### Remove Collection Words

In additional to removing stopwords it's common to also remove collection words, to gain more information. Let's try to remove climate, change, and climatechange from the tweets. Since you used "climate change" as a filter for these tweets you know that they're already about. 

{:.input}
```python
collection_words = ['climatechange', 'climate', 'change']
```

{:.input}
```python
tweets_nsw_nc = [[w for w in word if not w in collection_words] for word in tweets_nsw]
```

{:.input}
```python
tweets_nsw_nc[0]
```

{:.output}
{:.execute_result}



    ['maybe',
     'sorts',
     'numbers',
     'become',
     'efficiency',
     'dividend',
     'targets',
     'turnbullmalcolm',
     'coalition',
     'real']





Now you'll investigate the number of times that an individual word occurs in the sample of 1000 tweets about climate chnage that you're working with. 

{:.input}
```python
all_words = [item for sublist in tweets_nsw for item in sublist]
```

{:.input}
```python
all_words2 = [item for sublist in tweets_nsw_nc for item in sublist]
```

Now you have a list that is not nested, the list contains over 10,000 words from the 1,000 sample tweets. Remember that from this sample the average tweet length was about 16 words, before the stop words are removed, so this number seems reasonable. 

{:.input}
```python
len(all_words)
```

{:.output}
{:.execute_result}



    10478





{:.input}
```python
len(all_words2)
```

{:.output}
{:.execute_result}



    8877





To get the count of how many times each words appears in the sample you can use the built-in `Python` library `collections`, it helps create a special type of a `Python dictonary.`


{:.input}
```python
import collections

counts = collections.Counter(all_words)
```

{:.input}
```python
type(counts)
```

{:.output}
{:.execute_result}



    collections.Counter





{:.input}
```python
counts.most_common(15)
```

{:.output}
{:.execute_result}



    [('climate', 912),
     ('change', 599),
     ('climatechange', 90),
     ('new', 61),
     ('amp', 61),
     ('global', 56),
     ('science', 43),
     ('world', 37),
     ('oil', 37),
     ('via', 37),
     ('could', 36),
     ('warming', 35),
     ('scientists', 34),
     ('major', 33),
     ('report', 31)]





{:.input}
```python
counts2 = collections.Counter(all_words2)
```

{:.input}
```python
counts2.most_common(15)
```

{:.output}
{:.execute_result}



    [('new', 61),
     ('amp', 61),
     ('global', 56),
     ('science', 43),
     ('world', 37),
     ('oil', 37),
     ('via', 37),
     ('could', 36),
     ('warming', 35),
     ('scientists', 34),
     ('major', 33),
     ('report', 31),
     ('nasa', 30),
     ('us', 30),
     ('energy', 29)]





To find out the number of unique words you can take the len of the object counts you just created. The `collection.Counter` object has a useful built-in method `most_common` that will return the most commonly used words, and the number of times that they are used. 

{:.input}
```python
len(counts)
```

{:.output}
{:.execute_result}



    3517





{:.input}
```python
counts.most_common(15)
```

{:.output}
{:.execute_result}



    [('climate', 910),
     ('change', 621),
     ('climatechange', 69),
     ('new', 52),
     ('need', 49),
     ('world', 46),
     ('amp', 45),
     ('science', 40),
     ('global', 36),
     ('via', 35),
     ('carbon', 34),
     ('report', 33),
     ('environment', 32),
     ('unfccc', 30),
     ('us', 29)]





{:.input}
```python
counts2.most_common(15)
```

{:.output}
{:.execute_result}



    [('new', 52),
     ('need', 49),
     ('world', 46),
     ('amp', 45),
     ('science', 40),
     ('global', 36),
     ('via', 35),
     ('carbon', 34),
     ('report', 33),
     ('environment', 32),
     ('unfccc', 30),
     ('us', 29),
     ('news', 29),
     ('free', 27),
     ('officially', 27)]





{:.input}
```python
df_counts = pd.DataFrame.from_dict(counts2, orient='index').reset_index()
```

{:.input}
```python
df_counts.columns = ['words', 'count']
```

{:.input}
```python
sorted_df = df_counts.sort_values(by='count', ascending = False)
```

{:.input}
```python
sorted_df_s = sorted_df[:16]
```

{:.input}
```python
sorted_df_s
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
      <th>words</th>
      <th>count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>66</th>
      <td>new</td>
      <td>61</td>
    </tr>
    <tr>
      <th>330</th>
      <td>amp</td>
      <td>61</td>
    </tr>
    <tr>
      <th>20</th>
      <td>global</td>
      <td>56</td>
    </tr>
    <tr>
      <th>111</th>
      <td>science</td>
      <td>43</td>
    </tr>
    <tr>
      <th>28</th>
      <td>oil</td>
      <td>37</td>
    </tr>
    <tr>
      <th>174</th>
      <td>via</td>
      <td>37</td>
    </tr>
    <tr>
      <th>16</th>
      <td>world</td>
      <td>37</td>
    </tr>
    <tr>
      <th>48</th>
      <td>could</td>
      <td>36</td>
    </tr>
    <tr>
      <th>77</th>
      <td>warming</td>
      <td>35</td>
    </tr>
    <tr>
      <th>352</th>
      <td>scientists</td>
      <td>34</td>
    </tr>
    <tr>
      <th>716</th>
      <td>major</td>
      <td>33</td>
    </tr>
    <tr>
      <th>453</th>
      <td>report</td>
      <td>31</td>
    </tr>
    <tr>
      <th>107</th>
      <td>nasa</td>
      <td>30</td>
    </tr>
    <tr>
      <th>277</th>
      <td>us</td>
      <td>30</td>
    </tr>
    <tr>
      <th>1181</th>
      <td>free</td>
      <td>29</td>
    </tr>
    <tr>
      <th>1415</th>
      <td>carbon</td>
      <td>29</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
plt.bar(sorted_df_s['words'], sorted_df_s['count'], color = 'purple');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/12-api/twitter-api/2018-02-05-twitter-03-text-mining_55_0.png)




## Explore Networks of Words
You might also want to explore words that occur together in tweets. You'll do that next usig `bigrams` from `nltk` 

{:.input}
```python
from nltk import bigrams 
 
terms_bigram = [list(bigrams(tweet)) for tweet in tweets_nsw_nc]
```

{:.input}
```python
terms_bigram[0]
```

{:.output}
{:.execute_result}



    [('maybe', 'sorts'),
     ('sorts', 'numbers'),
     ('numbers', 'become'),
     ('become', 'efficiency'),
     ('efficiency', 'dividend'),
     ('dividend', 'targets'),
     ('targets', 'turnbullmalcolm'),
     ('turnbullmalcolm', 'coalition'),
     ('coalition', 'real')]





{:.input}
```python
from collections import Counter

bigram_counts = Counter()
for lst in terms_bigram:
    for bigram in lst:
        bigram_counts[bigram] += 1
```

{:.input}
```python
bigram_counts.most_common(20)
```

{:.output}
{:.execute_result}



    [(('global', 'warming'), 23),
     (('insect', 'wipeout'), 20),
     (('track', 'cause'), 20),
     (('cause', 'major'), 20),
     (('major', 'insect'), 19),
     (('wipeout', 'scientists'), 19),
     (('scientists', 'warn'), 18),
     (('download', 'free'), 17),
     (('free', 'book'), 15),
     (('gpwx', 'globalwarming'), 14),
     (('1', '5'), 14),
     (('latest', 'daily'), 14),
     (('white', 'house'), 12),
     (('fossil', 'fuel'), 11),
     (('oil', 'gas'), 10),
     (('big', 'oil'), 10),
     (('eu', 'court'), 10),
     (('nasa', 'chief'), 10),
     (('sea', 'level'), 9),
     (('trump', 'administration'), 9)]





## Visualizing Bigrams

You will visualize the top occuring bigrams using the `Python` packages `NetworkX`.

{:.input}
```python
bigram_counts.most_common(20)[1][0]
```

{:.output}
{:.execute_result}



    ('insect', 'wipeout')





{:.input}
```python
bigram_count = [bigram_counts.most_common(20)[x][1] for x in np.arange(20)]
```

{:.input}
```python
bigram_count
```

{:.output}
{:.execute_result}



    [23, 20, 20, 20, 19, 19, 18, 17, 15, 14, 14, 14, 12, 11, 10, 10, 10, 10, 9, 9]





{:.input}
```python
bigrams = [bigram_counts.most_common(20)[x][0] for x in np.arange(20)]
```

{:.input}
```python
bigrams
```

{:.output}
{:.execute_result}



    [('global', 'warming'),
     ('insect', 'wipeout'),
     ('track', 'cause'),
     ('cause', 'major'),
     ('major', 'insect'),
     ('wipeout', 'scientists'),
     ('scientists', 'warn'),
     ('download', 'free'),
     ('free', 'book'),
     ('gpwx', 'globalwarming'),
     ('1', '5'),
     ('latest', 'daily'),
     ('white', 'house'),
     ('fossil', 'fuel'),
     ('oil', 'gas'),
     ('big', 'oil'),
     ('eu', 'court'),
     ('nasa', 'chief'),
     ('sea', 'level'),
     ('trump', 'administration')]





{:.input}
```python
bigram_df = pd.DataFrame({'bigram':bigrams, 'count':bigram_count})
```

{:.input}
```python
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
      <td>(global, warming)</td>
      <td>23</td>
    </tr>
    <tr>
      <th>1</th>
      <td>(insect, wipeout)</td>
      <td>20</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(track, cause)</td>
      <td>20</td>
    </tr>
    <tr>
      <th>3</th>
      <td>(cause, major)</td>
      <td>20</td>
    </tr>
    <tr>
      <th>4</th>
      <td>(major, insect)</td>
      <td>19</td>
    </tr>
    <tr>
      <th>5</th>
      <td>(wipeout, scientists)</td>
      <td>19</td>
    </tr>
    <tr>
      <th>6</th>
      <td>(scientists, warn)</td>
      <td>18</td>
    </tr>
    <tr>
      <th>7</th>
      <td>(download, free)</td>
      <td>17</td>
    </tr>
    <tr>
      <th>8</th>
      <td>(free, book)</td>
      <td>15</td>
    </tr>
    <tr>
      <th>9</th>
      <td>(gpwx, globalwarming)</td>
      <td>14</td>
    </tr>
    <tr>
      <th>10</th>
      <td>(1, 5)</td>
      <td>14</td>
    </tr>
    <tr>
      <th>11</th>
      <td>(latest, daily)</td>
      <td>14</td>
    </tr>
    <tr>
      <th>12</th>
      <td>(white, house)</td>
      <td>12</td>
    </tr>
    <tr>
      <th>13</th>
      <td>(fossil, fuel)</td>
      <td>11</td>
    </tr>
    <tr>
      <th>14</th>
      <td>(oil, gas)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>15</th>
      <td>(big, oil)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>16</th>
      <td>(eu, court)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>17</th>
      <td>(nasa, chief)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>18</th>
      <td>(sea, level)</td>
      <td>9</td>
    </tr>
    <tr>
      <th>19</th>
      <td>(trump, administration)</td>
      <td>9</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
d = bigram_df.set_index('bigram').T.to_dict('records')
```

{:.input}
```python
import networkx as nx
G = nx.Graph()
for k, v in d[0].items():
    G.add_edge(k[0], k[1], weight=v* 10)
```

{:.input}
```python
plt.figure(figsize=(16, 20))
pos=nx.spring_layout(G, k= 1)
nx.draw_networkx(G, pos, font_size=15, width=3, edge_color='grey', node_color= 'purple')
plt.show()
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/12-api/twitter-api/2018-02-05-twitter-03-text-mining_71_0.png)



