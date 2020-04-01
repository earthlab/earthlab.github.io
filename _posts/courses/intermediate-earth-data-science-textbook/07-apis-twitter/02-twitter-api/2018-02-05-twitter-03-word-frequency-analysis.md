---
layout: single
title: 'Analyze Word Frequency Counts Using Twitter Data and Tweepy in Python'
excerpt: 'One common way to analyze Twitter data is to calculate word frequencies to understand how often words are used in tweets on a particular topic. To complete any analysis, you need to first prepare the data. Learn how to clean Twitter data and calculate word frequencies using Python.'
authors: ['Martha Morrissey', 'Leah Wasser', 'Jeremey Diaz', 'Jenny Palomino']
modified: 2020-04-01
category: [courses]
class-lesson: ['social-media-python']
permalink: /courses/use-data-open-source-python/intro-to-apis/calculate-tweet-word-frequencies-in-python/
nav-title: 'Tweet Word Frequency Analysis'
week: 7 
sidebar:
    nav:
author_profile: false
comments: true
order: 3
course: "intermediate-earth-data-science-textbook"
topics:
    find-and-manage-data: ['apis']
redirect_from:
  - "/courses/earth-analytics-python/using-apis-natural-language-processing-twitter/calculate-tweet-word-frequencies-in-python/"
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

In this lesson, you will learn how to take a set of tweets and clean them, in order to analyze the frequency of words found in the tweets. You will learn how to do several things including:

1. Remove URLs from tweets.
2. Clean up tweet text, including differences in case (e.g. upper, lower) that will affect unique word counts and removing words that are not useful for the analysis. 
3. Summarize and count words found in tweets.


## Get Tweets Related to Climate

When you work with social media and other text data, the user community creates and curates the content. This means there are NO RULES! This also means that you may have to perform extra steps to clean the data to ensure you are analyzing the right thing.

Next, you will explore the text associated with a set of tweets that you access using `Tweepy` and the Twitter API. You will use some standard natural language processing (also known as text mining) approaches to do this.

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

Now that you've authenticated you're ready to search for tweets that contain `#climatechange`. Below you grab 1000 recent tweets and add them to a list. 

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



    ['Different kind of #climate change. https://t.co/yIVrqSdMzP',
     'Some forests, particularly in more arid regions, have become more drought tolerant, primarily thanks to the death o… https://t.co/VDRfQ5ymo8',
     'England’s water resource muddle. The UK Department of Environment, Food &amp; Rural Affairs has issued a warning: large… https://t.co/aC1zKPhhg4',
     'Covid-19 and climate change – The epidemic provides a chance to do good by the #climate \n#environmentaljustice\nhttps://t.co/1W6SkvbFRl',
     "@realDonaldTrump That's a lie. In your obsessive need to deconstruct the @BarackObama-era legislation, now you've r… https://t.co/RWp9jBvX5R"]





## Remove URLs (links)

The tweets above have some elements that you do not want in your word counts. For instance, URLs will not be analyzed in this lesson. You can remove URLs (links) using regular expressions accessed from the `re` package. 

Re stands for `regular expressions`. Regular expressions are a special syntax that is used to identify patterns in a string. 

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



    ['Different kind of climate change',
     'Some forests particularly in more arid regions have become more drought tolerant primarily thanks to the death o',
     'Englands water resource muddle The UK Department of Environment Food amp Rural Affairs has issued a warning large',
     'Covid19 and climate change The epidemic provides a chance to do good by the climate environmentaljustice',
     'realDonaldTrump Thats a lie In your obsessive need to deconstruct the BarackObamaera legislation now youve r']





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





Now all of the words in your list are lowercase. You can again use `set()` function to return only unique words.

{:.input}
```python
# Now you have only unique words
set(lower_case)
```

{:.output}
{:.execute_result}



    {',', 'cat', 'dog'}





## Create List of Lower Case Words from Tweets

Right now, you have a list of lists that contains each full tweet and you know how to lowercase the words.

However, to do a word frequency analysis, you need a list of all of the words associated with each tweet. You can use `.split()` to split out each word into a unique element in a list, as shown below.

{:.input}
```python
# Split the words from one tweet into unique elements
all_tweets_no_urls[0].split()
```

{:.output}
{:.execute_result}



    ['Different', 'kind', 'of', 'climate', 'change']





Of course, you will notice above that you have a capital word in your list of words. 

You can combine `.lower()` with `.split()` to remove capital letters and split up the tweet in one step. Below is an example of applying these methods to the first tweet in the list. 

{:.input}
```python
# Split the words from one tweet into unique elements
all_tweets_no_urls[0].lower().split()
```

{:.output}
{:.execute_result}



    ['different', 'kind', 'of', 'climate', 'change']





To split and lower case words in all of the tweets, you can string both methods `.lower()` and `.split()` together in a list comprehension.

{:.input}
```python
# Create a list of lists containing lowercase words for each tweet
words_in_tweet = [tweet.lower().split() for tweet in all_tweets_no_urls]
words_in_tweet[:2]
```

{:.output}
{:.execute_result}



    [['different', 'kind', 'of', 'climate', 'change'],
     ['some',
      'forests',
      'particularly',
      'in',
      'more',
      'arid',
      'regions',
      'have',
      'become',
      'more',
      'drought',
      'tolerant',
      'primarily',
      'thanks',
      'to',
      'the',
      'death',
      'o']]





### Calculate and Plot Word Frequency

To get the count of how many times each word appears in the sample, you can use the built-in `Python` library `collections`, which helps create a special type of a `Python dictonary.` The `collection.Counter` object has a useful built-in method `most_common` that will return the most commonly used words and the number of times that they are used. 

To begin, flatten your list, so that all words across the tweets are in one list. Note that you could flatten your list with another list comprehension like this:
`all_words = [item for sublist in tweets_nsw for item in sublist]`

However, it is actually faster to use `itertools` to flatten the list as follows.

{:.input}
```python
# List of all words across tweets
all_words_no_urls = list(itertools.chain(*words_in_tweet))

# Create counter
counts_no_urls = collections.Counter(all_words_no_urls)

counts_no_urls.most_common(15)
```

{:.output}
{:.execute_result}



    [('climate', 570),
     ('the', 538),
     ('change', 421),
     ('to', 347),
     ('and', 239),
     ('of', 236),
     ('a', 207),
     ('is', 167),
     ('in', 154),
     ('for', 133),
     ('we', 117),
     ('coronavirus', 95),
     ('on', 91),
     ('climatechange', 72),
     ('how', 72)]





Based on the counter, you can create a `Pandas Dataframe` for analysis and plotting that includes only the top 15 most common words. 

{:.input}
```python
clean_tweets_no_urls = pd.DataFrame(counts_no_urls.most_common(15),
                             columns=['words', 'count'])

clean_tweets_no_urls.head()
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
      <td>climate</td>
      <td>570</td>
    </tr>
    <tr>
      <th>1</th>
      <td>the</td>
      <td>538</td>
    </tr>
    <tr>
      <th>2</th>
      <td>change</td>
      <td>421</td>
    </tr>
    <tr>
      <th>3</th>
      <td>to</td>
      <td>347</td>
    </tr>
    <tr>
      <th>4</th>
      <td>and</td>
      <td>239</td>
    </tr>
  </tbody>
</table>
</div>





Using this `Pandas Dataframe`, you can create a horizontal bar graph of the top 15 most common words in the tweets as shown below.  

{:.input}
```python
fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph
clean_tweets_no_urls.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets (Including All Words)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/07-apis-twitter/02-twitter-api/2018-02-05-twitter-03-word-frequency-analysis/2018-02-05-twitter-03-word-frequency-analysis_29_0.png" alt = "This plot displays the frequency of all words in the tweets on climate change, after URLs have been removed.">
<figcaption>This plot displays the frequency of all words in the tweets on climate change, after URLs have been removed.</figcaption>

</figure>







{:.output}
{:.execute_result}



    [5, 18, 18]








## Remove Stopwords With `nltk`

In addition to lowercase words, you may also want to perform additional clean-up, such as removing words that do not add meaningful information to the text you are trying to analysis. These words referred to as "stop words" and include commonly appearing words such as who, what, you, etc.

The `Python` package `nltk`, commonly used for text analysis, provides a list of "stop words" that you can use to clean your Twitter data.

{:.input}
```python
nltk.download('stopwords')
```

{:.output}
    [nltk_data] Downloading package stopwords to /root/nltk_data...
    [nltk_data]   Unzipping corpora/stopwords.zip.



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



    ['after',
     "that'll",
     'not',
     'being',
     'very',
     'couldn',
     'ourselves',
     'more',
     'under',
     'which']





Notice that the stop words provided by `nltk` are all lower-case. This works well given you already have converted all of your tweet words to lower case using the `Python` `string` method `.lower()`. 

Next, you will remove all stop words from each tweet. First, have a look at the words in the first tweet below.

{:.input}
```python
words_in_tweet[0]
```

{:.output}
{:.execute_result}



    ['different', 'kind', 'of', 'climate', 'change']





Below, you remove all of the stop words in each tweet. The list comprehension below might look confusing as it is nested. The list comprehension below is the same as calling:

```python
for all_words in words_in_tweet:
    for a word in all_words:
        # remove stop words
```

Now, compare the words in the original tweet to the words in the tweet after the stop words are removed: 

{:.input}
```python
# Remove stop words from each tweet list of words
tweets_nsw = [[word for word in tweet_words if not word in stop_words]
              for tweet_words in words_in_tweet]

tweets_nsw[0]
```

{:.output}
{:.execute_result}



    ['different', 'kind', 'climate', 'change']





Again, you can flatten your list and create a counter to return the most commonly used words and the number of times that they are used.  

{:.input}
```python
all_words_nsw = list(itertools.chain(*tweets_nsw))

counts_nsw = collections.Counter(all_words_nsw)

counts_nsw.most_common(15)
```

{:.output}
{:.execute_result}



    [('climate', 570),
     ('change', 421),
     ('coronavirus', 95),
     ('climatechange', 72),
     ('covid19', 71),
     ('amp', 49),
     ('new', 48),
     ('us', 44),
     ('crisis', 41),
     ('global', 36),
     ('pandemic', 35),
     ('science', 34),
     ('world', 33),
     ('globalwarming', 30),
     ('fight', 29)]





Then, you can create the `Pandas Dataframe` and plot the word frequencies without the stop words. 

{:.input}
```python
clean_tweets_nsw = pd.DataFrame(counts_nsw.most_common(15),
                             columns=['words', 'count'])

fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph
clean_tweets_nsw.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets (Without Stop Words)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/07-apis-twitter/02-twitter-api/2018-02-05-twitter-03-word-frequency-analysis/2018-02-05-twitter-03-word-frequency-analysis_44_0.png" alt = "This plot displays the frequency of the words in the tweets on climate change, after URLs and stop words have been removed.">
<figcaption>This plot displays the frequency of the words in the tweets on climate change, after URLs and stop words have been removed.</figcaption>

</figure>




## Remove Collection Words

In additional to removing stopwords, it is common to also remove collection words. Collection words are the words that you used to query your data from Twitter. 

In this case, you used "climate change" as a collection term. Thus, you can expect that these terms will be found in each tweet. This could skew your word frequency analysis. 

Below you remove the collection words - climate, change, and climatechange - from the tweets through list comprehension.  

{:.input}
```python
collection_words = ['climatechange', 'climate', 'change']
```

{:.input}
```python
tweets_nsw_nc = [[w for w in word if not w in collection_words]
                 for word in tweets_nsw]
```

Compare the words in first tweet with and without the collection words.

{:.input}
```python
tweets_nsw[0]
```

{:.output}
{:.execute_result}



    ['different', 'kind', 'climate', 'change']





{:.input}
```python
tweets_nsw_nc[0]
```

{:.output}
{:.execute_result}



    ['different', 'kind']





## Calculate and Plot Word Frequency of Clean Tweets

Now that you have cleaned up your data, you are ready to calculate and plot the final word frequency results.

Using the skills you have learned, you can flatten the list and create the counter for the words in the tweets. 

{:.input}
```python
# Flatten list of words in clean tweets
all_words_nsw_nc = list(itertools.chain(*tweets_nsw_nc))

# Create counter of words in clean tweets
counts_nsw_nc = collections.Counter(all_words_nsw_nc)

counts_nsw_nc.most_common(15)
```

{:.output}
{:.execute_result}



    [('coronavirus', 95),
     ('covid19', 71),
     ('amp', 49),
     ('new', 48),
     ('us', 44),
     ('crisis', 41),
     ('global', 36),
     ('pandemic', 35),
     ('science', 34),
     ('world', 33),
     ('globalwarming', 30),
     ('fight', 29),
     ('environment', 28),
     ('need', 28),
     ('like', 27)]





To find out the number of unique words across all of the tweets, you can take the `len()` of the object counts that you just created. 

{:.input}
```python
len(counts_nsw_nc)
```

{:.output}
{:.execute_result}



    2801





Last, you can create the `Pandas Dataframe` of the words and their counts and plot the top 15 most common words from the clean tweets (i.e. no URLs, stop words, or collection words). 

{:.input}
```python
clean_tweets_ncw = pd.DataFrame(counts_nsw_nc.most_common(15),
                             columns=['words', 'count'])
clean_tweets_ncw.head()
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
      <td>coronavirus</td>
      <td>95</td>
    </tr>
    <tr>
      <th>1</th>
      <td>covid19</td>
      <td>71</td>
    </tr>
    <tr>
      <th>2</th>
      <td>amp</td>
      <td>49</td>
    </tr>
    <tr>
      <th>3</th>
      <td>new</td>
      <td>48</td>
    </tr>
    <tr>
      <th>4</th>
      <td>us</td>
      <td>44</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
fig, ax = plt.subplots(figsize=(8, 8))

# Plot horizontal bar graph
clean_tweets_ncw.sort_values(by='count').plot.barh(x='words',
                      y='count',
                      ax=ax,
                      color="purple")

ax.set_title("Common Words Found in Tweets (Without Stop or Collection Words)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/07-apis-twitter/02-twitter-api/2018-02-05-twitter-03-word-frequency-analysis/2018-02-05-twitter-03-word-frequency-analysis_57_0.png" alt = "This plot displays the frequency of all words in the tweets on climate change, after URLs, stop words, and collection words have been removed.">
<figcaption>This plot displays the frequency of all words in the tweets on climate change, after URLs, stop words, and collection words have been removed.</figcaption>

</figure>




You now know how to clean Twitter data, including how to remove URLs as well as stop and collection words. You also learned how to calculate and plot word frequencies. 

In the lessons that follow, you will analyze co-occurrence of words (i.e. bigrams) and attitudes (i.e. sentiments) in Tweets.
