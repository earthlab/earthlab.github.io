---
layout: single
title: 'Create Word Frequency Counts and Sentiments Using Twitter Data and Tweepy in Python'
excerpt: 'One common way to analyze Twitter data is to calculate word frequencies to understand how often words are used in tweets on a particular topic. Another common task is to analyze sentiment in Twitter data. Both require some data cleanup. Learn how to use clean twitter data, calculate word frequencies, and analyze sentiments in Python.'
authors: ['Martha Morrissey', 'Leah Wasser','Jeremey Diaz']
modified: 2018-11-28
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/earth-analytics-python/get-data-using-apis/calculate-tweet-word-frequencies-sentiments-in-python/
nav-title: 'Tweet Word Frequency and Sentiment Analysis'
week: 13 
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
* Analyze sentiments (i.e. attitudes) in tweets. 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In this lesson, you will learn how to take a set of tweets and clean them in order to 
analyze the frequency of words found in the tweets. You will learn how to do several things 
including:

1. Remove URLs from tweets.
2. Clean up tweet text including differences in case (e.g. upper, lower) that will affect unique word counts. 
3. Summarize and count individual and sets of words found in tweets.


## Get and Analyze Tweets Related to Climate

When you work with social media and other text data, the user community creates and curates the content. This means there are NO RULES! This also means that you may have to perform extra steps to clean the data to ensure you are analyzing the right thing.

Next, you will explore the text associated with a set of tweets that you access using tweepy and the Twitter API. You will use some standard natural language processing (also known as text mining) approaches to do this.

{:.input}
```python
import numpy as np
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

Now that you've authenticated you're ready to search for tweets that contain `#climatechange`. Below you grab 1000 recent tweets.

{:.input}
```python
search_term = "#climate+change -filter:retweets"

tweets = tw.Cursor(api.search,
                   q=search_term,
                   lang="en",
                   since='2018-11-01').items(1000)

all_tweets = [tweet.text for tweet in tweets]
all_tweets[:5]
```

{:.output}
{:.execute_result}



    ['#Climate change is fueling wildfires, warns National Climate Assessment https://t.co/cKFbSq4pgP',
     '@CNN @AC360 @andersoncooper To deny #ClimateCchange is to put America at risk and has failed at protection. Houston… https://t.co/U8H9rSf3E1',
     '...And CNN has Rick Santorum back spouting nonsense about #climate change @andersoncooper #ClimateChangeIsReal… https://t.co/vxgTCPKHDI',
     '@CNN @andersoncooper please STOP bringing @RickSantorum onto your show. He knows nothing about #climate change and… https://t.co/oltssRwwr3',
     '#Environment World must triple efforts or face catastrophic #climate change, says UN https://t.co/2FTyUE11nW']





### Clean Up Twitter Data - Remove URLs (links) From Each Tweet

The tweets above have some elements that you do not want in your word counts. For instance, URLs will not be analyzed in this lesson. You can remove URLs (links) using regular expressions accessed from the `re` package. Re stands for `regular expressions`. Regular expressions are a special syntax that is used to identify patterns in a string. 

While this lesson will not cover regular expressions, it is helpful to understand that this syntax below:

`([^0-9A-Za-z \t])|(\w+:\/\/\S+)`

Tells the search to find all strings that look like a URL, and replace it with nothing -- `""`. It also removes other punctionation including hashtags - `#`.

`re.sub` allows you to substitute a selection of characters defined using a regular expression, with something else. 

In the function defined below, this line takes the text in each tweet and replaces the URL with `""` (nothing):
`re.sub("([^0-9A-Za-z \t])|(\w+:\/\/\S+)", "", tweet`

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

After defining the function, you can call it in a list comprehension to create a list of the clean tweets. 

{:.input}
```python
all_tweets_no_urls = [remove_url(tweet) for tweet in all_tweets]
all_tweets_no_urls[:5]
```

{:.output}
{:.execute_result}



    ['Climate change is fueling wildfires warns National Climate Assessment',
     'CNN AC360 andersoncooper To deny ClimateCchange is to put America at risk and has failed at protection Houston',
     'And CNN has Rick Santorum back spouting nonsense about climate change andersoncooper ClimateChangeIsReal',
     'CNN andersoncooper please STOP bringing RickSantorum onto your show He knows nothing about climate change and',
     'Environment World must triple efforts or face catastrophic climate change says UN']





### Text Cleanup - Address Case Issues

Capitalization is also a challenge when analyzing text data. If you are trying to create a list of unique words in your tweets, words with capitalization will be different from words that are all lowercase.

{:.input}
```python
# Note how capitalization impacts unique returned values
ex_list = ["Dog", "dog", "dog", "cat", "cat", ","]

# Get unique elements in the list
set(ex_list)
```

{:.output}
{:.execute_result}



    {',', 'Dog', 'cat', 'dog'}





To account for this, you can make each word lowercase using the string method `.lower()`. In the code below, this method is applied using a list comprehension.

{:.input}
```python
# Note how capitalization impacts unique returned values
words_list = ["Dog", "dog", "dog", "cat", "cat", ","]

# Make all elements in the list lowercase
lower_case = [word.lower() for word in words_list]

# Get all elements in the list
lower_case
```

{:.output}
{:.execute_result}



    ['dog', 'dog', 'dog', 'cat', 'cat', ',']





Now all of the words in your list are lower case. You can again use `set()` function to return only unique words.

{:.input}
```python
# Now you have only unique words
set(lower_case)
```

{:.output}
{:.execute_result}



    {',', 'cat', 'dog'}





### Create List of Words from Tweets

Right now you have a list of lists that contains each full tweet. However, to do a word frequency analysis, you need a list of all of the words associated with each tweet. You can use `.split()` to split out each word into a unique element in a list.

{:.input}
```python
# Split the words from one tweet into unique elements
all_tweets_no_urls[0].split()
```

{:.output}
{:.execute_result}



    ['Climate',
     'change',
     'is',
     'fueling',
     'wildfires',
     'warns',
     'National',
     'Climate',
     'Assessment']





Of course, you will notice above that you have a capital word in your list of words. You can combine `.lower()` with `.split()` to remove capital letters and split up the tweet in one step. 

{:.input}
```python
# Split the words from one tweet into unique elements
all_tweets_no_urls[0].lower().split()
```

{:.output}
{:.execute_result}



    ['climate',
     'change',
     'is',
     'fueling',
     'wildfires',
     'warns',
     'national',
     'climate',
     'assessment']





To split words in all of the tweets, you can then string both methods together in a list comprehension.


{:.input}
```python
# Create a sublist of words for each tweet, all lower case
words_in_tweet = [tweet.lower().split() for tweet in all_tweets_no_urls]
```

### Tweet Length Analysis

A tweet is limited to 280 characters. You can explore how many words (not including links) were used by people that recently tweeted about climate change. To do this, you will use the `len()` function to calculate the length of each list of words that are associated with each tweet.

{:.input}
```python
tweet_word_count = [len(word) for word in words_in_tweet]
tweet_word_count[:3]
```

{:.output}
{:.execute_result}



    [9, 18, 13]





You can use the list you created above to plot the distribution of tweet length.

{:.input}
```python
# Get the average word count
average_word_count = np.mean(tweet_word_count)

# Print this value out in a text statement
print('The average number of words in each tweet is %0.6f' % average_word_count)

fig, ax = plt.subplots(figsize=(8, 6))

# Plot the histogram
ax.hist(tweet_word_count,
        bins=50, color="purple")

# Add labels of specified sizes
ax.set(xlabel="Word Count",
       ylabel="Frequency",
       title="Tweet Word Count Distribution")

# Plot a line for the average value
ax.axvline(x=average_word_count,
           lw=2,
           color='red',
           linestyle='--')
plt.show()
```

{:.output}
    The average number of words in each tweet is 15.650000



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-03-word-frequency-analysis_26_1.png">

</figure>




## Remove Stopwords From Tweet Text With `nltk`

The `Python` package `nltk` is commonly used for text analysis. Included in this package is a list of "stop words". These include commonly appearing words such as who, what, you, ect. that generally do not add meaningful information to the text you are trying to analysis. 

{:.input}
```python
nltk.download('stopwords')
```

{:.output}
    [nltk_data] Downloading package stopwords to
    [nltk_data]     /home/jpalomino/nltk_data...
    [nltk_data]   Package stopwords is already up-to-date!



{:.output}
{:.execute_result}



    True





{:.input}
```python
stop_words = set(stopwords.words('english'))

# View a few words from the set
list(stop_words)[0:10]
```

{:.output}
{:.execute_result}



    ['against', 'on', "it's", 'does', 're', 'ma', 'd', 'can', 'was', 'haven']





Notice that the stop words provided by `nltk` are all lower-case. This works well given you already have converted all of your tweet words to lower case using the `Python` `string` method `.lower()`. 

Next, you will remove all stop words from each tweet. First, have a look at the words in the first tweet below.

{:.input}
```python
words_in_tweet[0]
```

{:.output}
{:.execute_result}



    ['climate',
     'change',
     'is',
     'fueling',
     'wildfires',
     'warns',
     'national',
     'climate',
     'assessment']





Below, you remove all of the stop words in each tweet. The list comprehension below might look confusing as it is nested. The list comprehension below is the same as calling:

```python
for all_words in words_in_tweet:
    for a word in all_words:
        # remove stop words
```

Compare the words in the original tweet to the words in the tweet once the stop words are removed: 

{:.input}
```python
# Remove stop words from each tweet list of words
tweets_nsw = [[word for word in tweet_words if not word in stop_words]
              for tweet_words in words_in_tweet]

tweets_nsw[0]
```

{:.output}
{:.execute_result}



    ['climate',
     'change',
     'fueling',
     'wildfires',
     'warns',
     'national',
     'climate',
     'assessment']





### Remove Collection Words

In additional to removing stopwords, it is common to also remove collection words. Collection words are the words that you used to query your data from Twitter. In this case, you used `climate change` as a collection term. Thus, you can expect that these terms will be found in each tweet. This could skew your word frequency analysis. 

Remove the words - climate, change, and climatechange - from the tweets. 

{:.input}
```python
collection_words = ['climatechange', 'climate', 'change']
```

{:.input}
```python
tweets_nsw_nc = [[w for w in word if not w in collection_words]
                 for word in tweets_nsw]

tweets_nsw_nc[0]
```

{:.output}
{:.execute_result}



    ['fueling', 'wildfires', 'warns', 'national', 'assessment']





### Calculate Word Frequency

Now that you have cleaned up your data, you are ready to calculate word frequencies. 

To begin, flatten your list. Note that you could flatten your list with another list comprehension like this:
`all_words = [item for sublist in tweets_nsw for item in sublist]`

But it's actually faster to use itertools to flatten the list as follows.

{:.input}
```python
# All words
all_words = list(itertools.chain(*tweets_nsw))
len(all_words)
```

{:.output}
{:.execute_result}



    10513





{:.input}
```python
# All words not including the collection words
all_words_nocollect = list(itertools.chain(*tweets_nsw_nc))
len(all_words_nocollect)
```

{:.output}
{:.execute_result}



    8865





Now you have two lists of words from your tweets: one with and one without the collection words. Remember that in this sample, the average tweet length was about 16 words, before the stop words are removed, so the number of words seem reasonable. 

To get the count of how many times each words appears in the sample, you can use the built-in `Python` library `collections`, which helps create a special type of a `Python dictonary.`

{:.input}
```python
counts_with_collection_words = collections.Counter(all_words)
type(counts_with_collection_words)
```

{:.output}
{:.execute_result}



    collections.Counter





Look at the counts for your data including the collection words. Notice that the words climate, change and climatechange are prevalent in your analysis given they were a collection term. 

Thus, it likely does make sense to remove them from this analysis.

The `collection.Counter` object has a useful built-in method `most_common` that will return the most commonly used words, and the number of times that they are used. 

{:.input}
```python
# View word counts for list that includes collection terms
counts_with_collection_words.most_common(15)
```

{:.output}
{:.execute_result}



    [('climate', 927),
     ('change', 599),
     ('report', 159),
     ('climatechange', 122),
     ('trump', 105),
     ('us', 96),
     ('new', 67),
     ('amp', 59),
     ('believe', 57),
     ('government', 49),
     ('globalwarming', 44),
     ('national', 40),
     ('via', 40),
     ('world', 37),
     ('says', 36)]





{:.input}
```python
# View word counts for list that does NOT INCLUDE collection terms
cleaned_tweet_word_list = collections.Counter(all_words_nocollect)
cleaned_tweet_word_list.most_common(15)
```

{:.output}
{:.execute_result}



    [('report', 159),
     ('trump', 105),
     ('us', 96),
     ('new', 67),
     ('amp', 59),
     ('believe', 57),
     ('government', 49),
     ('globalwarming', 44),
     ('national', 40),
     ('via', 40),
     ('world', 37),
     ('says', 36),
     ('gpwx', 36),
     ('could', 36),
     ('assessment', 35)]





To find out the number of unique words, you can take the `len()` of the object counts you just created. 

{:.input}
```python
len(cleaned_tweet_word_list)
```

{:.output}
{:.execute_result}



    3536





Finally, you can turn your list of words into a `Pandas Dataframe` for analysis and plotting.

{:.input}
```python
df_tweet_words = pd.DataFrame.from_dict(cleaned_tweet_word_list,
                                        orient='index').reset_index()

df_tweet_words.columns = ['words', 'count']
df_tweet_words.head()
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
      <th>0</th>
      <td>fueling</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>wildfires</td>
      <td>12</td>
    </tr>
    <tr>
      <th>2</th>
      <td>warns</td>
      <td>24</td>
    </tr>
    <tr>
      <th>3</th>
      <td>national</td>
      <td>40</td>
    </tr>
    <tr>
      <th>4</th>
      <td>assessment</td>
      <td>35</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Sort dataframe by word count
sorted_df = df_tweet_words.sort_values(by='count',
                                       ascending=False)

# Select top 16 words with highest word counts
sorted_df_s = sorted_df[:16]
sorted_df_s = sorted_df_s.sort_values(by='count', ascending=True)
```

{:.input}
```python
fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph
ax.barh(sorted_df_s['words'], 
        sorted_df_s['count'], 
        color = 'purple');

ax.set(xlabel="Count", ylabel="Words",)

ax.set_title("Common Words Found in Tweets")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-03-word-frequency-analysis_50_0.png">

</figure>




## Explore Networks of Words

You might also want to explore words that occur together in tweets. You can do that next using `bigrams` from `nltk`. 

Begin by creating a list of bigrams (i.e. co-occurring) in the tweets. 

{:.input}
```python
from nltk import bigrams
```

{:.input}
```python
# Create list of bigrams in tweets
terms_bigram = [list(bigrams(tweet)) for tweet in tweets_nsw_nc]

# View bigrams for the first tweet
terms_bigram[0]
```

{:.output}
{:.execute_result}



    [('fueling', 'wildfires'),
     ('wildfires', 'warns'),
     ('warns', 'national'),
     ('national', 'assessment')]





Notice that the words are paired due to co-occurrence. You can remind yourself of the original tweet or the cleaned list of words to see how co-occurrence is identified.  

{:.input}
```python
all_tweets_no_urls[0]
```

{:.output}
{:.execute_result}



    'Climate change is fueling wildfires warns National Climate Assessment'





{:.input}
```python
tweets_nsw_nc[0]
```

{:.output}
{:.execute_result}



    ['fueling', 'wildfires', 'warns', 'national', 'assessment']





You can use a counter combined with a for loop to calculate the count of occurrence for each bigram. The counter is used to store the bigrams as dictionary keys and their counts are as dictionary values.

You can then query attributes of the counter to identify the top 20 common bigrams across the tweets. 

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



    [(('gpwx', 'globalwarming'), 34),
     (('national', 'assessment'), 29),
     (('government', 'report'), 25),
     (('dont', 'believe'), 20),
     (('report', 'warns'), 19),
     (('us', 'government'), 14),
     (('new', 'report'), 13),
     (('doesnt', 'believe'), 13),
     (('global', 'warming'), 13),
     (('us', 'economy'), 12),
     (('climateaction', 'climatechangeisreal'), 11),
     (('climatechangeisreal', 'poetry'), 11),
     (('poetry', 'poem'), 11),
     (('federal', 'report'), 11),
     (('trump', 'administration'), 10),
     (('fourth', 'national'), 10),
     (('soil', 'takes'), 10),
     (('takes', 'decades'), 10),
     (('decades', 'catch'), 10),
     (('catch', 'changes'), 10)]





## Visualizing Bigrams

You can visualize the top 20 occurring bigrams using the `Python` packages `NetworkX`. To do this, it is helpful to understand how to query the bigrams and their counts. 

Note that you can select from the top 20 occurring bigrams using indexing (e.g. `[1]` to select the second most occurring bigram and count, and then `[0]` to select the bigram words without the counts). 

{:.input}
```python
bigram_counts.most_common(20)[1][0]
```

{:.output}
{:.execute_result}



    ('national', 'assessment')





You can use indexing to create lists of the bigrams and their counts. 

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



    [('gpwx', 'globalwarming'),
     ('national', 'assessment'),
     ('government', 'report'),
     ('dont', 'believe'),
     ('report', 'warns'),
     ('us', 'government'),
     ('new', 'report'),
     ('doesnt', 'believe'),
     ('global', 'warming'),
     ('us', 'economy'),
     ('climateaction', 'climatechangeisreal'),
     ('climatechangeisreal', 'poetry'),
     ('poetry', 'poem'),
     ('federal', 'report'),
     ('trump', 'administration'),
     ('fourth', 'national'),
     ('soil', 'takes'),
     ('takes', 'decades'),
     ('decades', 'catch'),
     ('catch', 'changes')]





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



    [34,
     29,
     25,
     20,
     19,
     14,
     13,
     13,
     13,
     12,
     11,
     11,
     11,
     11,
     10,
     10,
     10,
     10,
     10,
     10]





You can then combine these lists into a `Pandas Dataframe`.

{:.input}
```python
bigram_df = pd.DataFrame({'bigram': bigrams, 'count': bigram_count})
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
      <td>(gpwx, globalwarming)</td>
      <td>34</td>
    </tr>
    <tr>
      <th>1</th>
      <td>(national, assessment)</td>
      <td>29</td>
    </tr>
    <tr>
      <th>2</th>
      <td>(government, report)</td>
      <td>25</td>
    </tr>
    <tr>
      <th>3</th>
      <td>(dont, believe)</td>
      <td>20</td>
    </tr>
    <tr>
      <th>4</th>
      <td>(report, warns)</td>
      <td>19</td>
    </tr>
    <tr>
      <th>5</th>
      <td>(us, government)</td>
      <td>14</td>
    </tr>
    <tr>
      <th>6</th>
      <td>(new, report)</td>
      <td>13</td>
    </tr>
    <tr>
      <th>7</th>
      <td>(doesnt, believe)</td>
      <td>13</td>
    </tr>
    <tr>
      <th>8</th>
      <td>(global, warming)</td>
      <td>13</td>
    </tr>
    <tr>
      <th>9</th>
      <td>(us, economy)</td>
      <td>12</td>
    </tr>
    <tr>
      <th>10</th>
      <td>(climateaction, climatechangeisreal)</td>
      <td>11</td>
    </tr>
    <tr>
      <th>11</th>
      <td>(climatechangeisreal, poetry)</td>
      <td>11</td>
    </tr>
    <tr>
      <th>12</th>
      <td>(poetry, poem)</td>
      <td>11</td>
    </tr>
    <tr>
      <th>13</th>
      <td>(federal, report)</td>
      <td>11</td>
    </tr>
    <tr>
      <th>14</th>
      <td>(trump, administration)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>15</th>
      <td>(fourth, national)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>16</th>
      <td>(soil, takes)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>17</th>
      <td>(takes, decades)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>18</th>
      <td>(decades, catch)</td>
      <td>10</td>
    </tr>
    <tr>
      <th>19</th>
      <td>(catch, changes)</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>





You can also use the `Pandas Dataframe` to plot a network of the bigrams using the `Python` package `networkx`. 

{:.input}
```python
# Create dictionary of bigrams and their counts
d = bigram_df.set_index('bigram').T.to_dict('records')
```

{:.input}
```python
import networkx as nx

G = nx.Graph()

# Create connections between nodes
for k, v in d[0].items():
    G.add_edge(k[0], k[1], weight=(v * 10))

G.add_node("china", weight=100)
```

{:.input}
```python
fig, ax = plt.subplots(figsize=(16, 20))

pos = nx.spring_layout(G, k=1)

# Plot networks
nx.draw_networkx(G, pos,
                 font_size=15,
                 width=3,
                 edge_color='grey',
                 node_color='purple',
                 with_labels = False,
                 ax=ax)

# Create offset labels
for key, value in pos.items():
    x, y = value[0]+.01, value[1]+.05
    ax.text(x, y,
            s=key,
            bbox=dict(facecolor='red', alpha=0.5),
            horizontalalignment='center')
    
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-03-word-frequency-analysis_73_0.png">

</figure>




## Sentiment Analysis

You may also want to analyze the tweets to identify attitudes (i.e. sentiments) toward the subject of interest. To do this, you can use the `Python` package `textblob`.  

Sentiment is scored using polarity values in a range from 1 to -1, in which values closer to 1 indicate more positivity and values closer to -1 indicate more negativity. 

Begin with the climate+change tweets that you previously cleaned up to remove URLs, and recall that it is helpful for the tweets to be formatted as lower case.  

{:.input}
```python
from textblob import TextBlob
```

{:.input}
```python
# All tweets
all_tweets_no_urls

# Format tweets as lower case
tweets_clean = [tweet.lower() for tweet in all_tweets_no_urls]
tweets_clean[0]
```

{:.output}
{:.execute_result}



    'climate change is fueling wildfires warns national climate assessment'





{:.input}
```python
# Create textblob objects of the tweets
sentiment_number = [TextBlob(tweet) for tweet in tweets_clean]
sentiment_number[0]
```

{:.output}
{:.execute_result}



    TextBlob("climate change is fueling wildfires warns national climate assessment")





{:.input}
```python
# Calculate the polarity values for the textblob objects
s_n = [[tweet.sentiment.polarity, str(tweet)] for tweet in sentiment_number]
s_n[0]
```

{:.output}
{:.execute_result}



    [0.0, 'climate change is fueling wildfires warns national climate assessment']





{:.input}
```python
# Create dataframe containing the polarity value and tweet text
sent_df = pd.DataFrame(s_n, columns=["polarity", "tweet"])
sent_df.head()
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
      <td>climate change is fueling wildfires warns nati...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.5</td>
      <td>cnn ac360 andersoncooper to deny climatecchang...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.0</td>
      <td>and cnn has rick santorum back spouting nonsen...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.0</td>
      <td>cnn andersoncooper please stop bringing ricksa...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.0</td>
      <td>environment world must triple efforts or face ...</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
fig, ax = plt.subplots()

# Plot histogram of the polarity values
sent_df.hist(bins=[-1, -0.75, -0.5, -0.25, 0.25, 0.5, 0.75, 1],
             ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-03-word-frequency-analysis_80_0.png">

</figure>




What does the histogram of the polarity values tell you about sentiments in the tweets gathered from the search "#climate+change -filter:retweets"? Are they more positive or negative?

### Get and Analyze Tweets Related to the Camp Fire

Next, explore a new topic, the recent Camp Fire in California. Begin by reviewing what you have learned about searching for and cleaning tweets. 

{:.input}
```python
search_term = "#CampFire -filter:retweets"

tweets = tw.Cursor(api.search,
                   q=search_term,
                   lang="en",
                   since='2018-09-23').items(1000)

all_tweets = [TextBlob(remove_url(tweet.text.lower())) for tweet in tweets]

all_tweets[:5]
```

{:.output}
{:.execute_result}



    [TextBlob("support cafirefound this givingtuesday as they continue to support the families affected by the campfire and"),
     TextBlob("were supporting the butte county community by brewing resilienceipa we will donate 100 of resilience sales to t"),
     TextBlob("1 missingpets foundpets1127 campfire campfirepets paradise foundcat cats these kitties are all at san"),
     TextBlob("drove up from la at 5am this morning to volunteer with north state public radio nsprnews to report on the"),
     TextBlob("more than 1000 breweries from around the world help sierra nevada brew resilience ipa to help campfire victims")]





Then, you can calculate the polarity values and plot the histogram for the Camp Fire tweets, just like you did for the climate change data. 

{:.input}
```python
wild_sent = [[tweet.sentiment.polarity, str(tweet)] for tweet in all_tweets]
wild_sent_df = pd.DataFrame(wild_sent, columns=["polarity", "tweet"])

fig, ax = plt.subplots(figsize=(8, 8))

wild_sent_df.hist(bins=[-1, -0.75, -0.5, -0.25, 0.25, 0.5, 0.75, 1],
                  ax=ax,
                  color="purple")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-03-word-frequency-analysis_84_0.png">

</figure>




It can also be helpful to remove the polarity values equal to zero and create a break in the histogram at zero, so you can get a better visual of the polarity values. 

Does this revised histogram highlight whether sentiments from the Camp Fire tweets are more positive or negative?

{:.input}
```python
# Create dataframe without polarity values equal to zero
df = wild_sent_df[wild_sent_df.polarity != 0]

fig, ax = plt.subplots()

df.hist(bins=[-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],
        ax=ax, color="purple")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/13-twitter-api/twitter-api/2018-02-05-twitter-03-word-frequency-analysis_86_0.png">

</figure>



