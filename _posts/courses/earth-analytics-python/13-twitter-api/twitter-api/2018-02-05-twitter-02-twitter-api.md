---
layout: single
title: 'Get and Work With Twitter Data in Python Using Tweepy'
excerpt: 'You can use the Twitter RESTful API to access tweet data from Twitter. Learn how to use tweepy to download and work with twitter social media data in Python.'
authors: ['Martha Morrissey', 'Leah Wasser','Carson Farmer']
modified: 2018-11-28
category: [courses]
class-lesson: ['social-media-Python']
permalink: /courses/earth-analytics-python/get-data-using-apis/get-and-use-twitter-data-in-python/
nav-title: 'Get Twitter Data'
week: 13
sidebar:
    nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Connect to the twitter RESTful API to access twitter data with `Python`.
* Generate custom queries that download tweet data into `Python` using `Tweepy`.
* Access tweet metadata including users in `Python` using `Tweepy`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In this lesson, you will explore analyzing social media data accessed from Twitter using Python. You will use the Twitter RESTful API to access data about both Twitter users and what they are tweeting about. 

## Getting Started

To get started, you'll need to do the following things:

1. Set up a Twitter account if you don't have one already.
2. Using your Twitter account, you will need to apply for Developer Access and then create an application that will generate the API credentials that you will use to access Twitter from `Python`. 
3. Import the `tweepy` package.

Once you've done these things, you are ready to begin querying Twitter's API to see what you can learn about tweets!

## Set up Twitter App 

After you have applied for <a href = "https://apps.twitter.com/" target="_blank">Developer Access</a>, you can create an application in Twitter that you can use to access tweets. Make sure you already have a Twitter account. 

To create your application, you can follow a useful tutorial from `rtweet`, which includes a section on Create an application that is not specific to R:

<a href="https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html" target="_blank"><i class="fa fa-info-circle" aria-hidden="true"></i>TUTORIAL: How to setup a Twitter application using your Twitter account</a>

NOTE: you will need to provide a phone number that can receive text messages (e.g. mobile or Google phone number) to Twitter to verify your use of the API.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/week-12/boulder_twitter_map_visualizations.jpg" >
 <img src="{{ site.url }}/images/courses/earth-analytics/week-12/boulder_twitter_map_visualizations.jpg"  alt="Image showing tweet activity across Boulder and Denver."></a>
    <figcaption>A heat map of the distribution of tweets across the Denver / Boulder region. <a href="http://www.socialmatt.com/amazing-denver-twitter-visualization/" target="_blank">Source: socialmatt.com</a>
    </figcaption>
</figure>

## Access Twitter API in Python 

Once you have your Twitter app set-up, you are ready to access tweets in `Python`. Begin by importing the necessary `Python` libraries. 

{:.input}
```python
import tweepy as tw
import pandas as pd
```

To access the Twitter API, you will need 4 things from the your Twitter App page. These keys are located in your Twitter app settings in the `Keys and Access Tokens` tab.

* consumer key
* consumer seceret key
* access token key 
* access token secret key 

Do not share these with anyone else because these values are specific to your app. 

First you will need define your keys

```Python
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

### Send a Tweet

You can send tweets using your API access. Note that your tweet needs to be 280 characters or less.

```python
# Post a tweet from Python
api.update_status("Look, I'm tweeting from #Python in my #earthanalytics class! @EarthLabCU")
# Your tweet has been posted!
```

### Search Twitter for Tweets

Now you are ready to search Twitter for recent tweets! Start by finding recent tweets that use the `#wildfires` hashtag. You will use the `.Cursor` method to get an object containing tweets containing the hashtag `#wildfires`. 

To create this query, you will define the:
1. Search term - in this case `#wildfires`
2. the start date of your search

Remember that the Twitter API only allows you to access the past few weeks of tweets, so you cannot dig into the history too far.

{:.input}
```python
# Define the search term and the date_since date as variables
search_words = "#wildfires"
date_since = "2018-11-16"
```

Below you use `.Cursor()` to search twitter for tweets containing the search term #wildfires. You can restrict the number of tweets returned by specifying a number in the `.items()` method. `.items(5)` will return 5 of the most recent tweets.

{:.input}
```python
# Collect tweets
tweets = tw.Cursor(api.search,
              q=search_words,
              lang="en",
              since=date_since).items(5)
tweets
```

{:.output}
{:.execute_result}



    <tweepy.cursor.ItemIterator at 0x7fafc296e400>





`.Cursor()` returns an object that you can iterate or loop over to access the data collected. Each item in the iterator has various attributes that you can access to get information about each tweet including:

1. the text of the tweet
2. who sent the tweet
3. the date the tweet was sent

and more. The code below loops through the object and prints the text associated with each tweet.

{:.input}
```python
# Collect tweets
tweets = tw.Cursor(api.search,
              q=search_words,
              lang="en",
              since=date_since).items(5)

# Iterate on tweets
for tweet in tweets:
    print(tweet.text)
```

{:.output}
    2/2 provide forest products to local mills, provide jobs to local communities, and improve the ecological health of… https://t.co/XemzXvyPyX
    1/2 Obama's Forest Service Chief in 2015 --&gt;"Treating these acres through commercial thinning, hazardous fuels remo… https://t.co/01obvjezQW
    RT @EnviroEdgeNews: US-#Volunteers care for abandoned #pets found in #California #wildfires; #Dogs, #cats, [#horses], livestock get care an…
    RT @FairWarningNews: The wildfires that ravaged CA have been contained, but the health impacts from the resulting air pollution will be sev…
    RT @chiarabtownley: If you know anybody who has been affected by the wildfires, please refer them to @awarenow_io It is one of the companie…



The above approach uses a standard for loop. However, this is an excellent place to use a Python list comprehension. A list comprehension provides an efficient way to collect object elements contained within an iterator as a list.  

{:.input}
```python
# Collect tweets
tweets = tw.Cursor(api.search,
                       q=search_words,
                       lang="en",
                       since=date_since).items(5)

# Collect a list of tweets
[tweet.text for tweet in tweets]
```

{:.output}
{:.execute_result}



    ['2/2 provide forest products to local mills, provide jobs to local communities, and improve the ecological health of… https://t.co/XemzXvyPyX',
     '1/2 Obama\'s Forest Service Chief in 2015 --&gt;"Treating these acres through commercial thinning, hazardous fuels remo… https://t.co/01obvjezQW',
     'RT @EnviroEdgeNews: US-#Volunteers care for abandoned #pets found in #California #wildfires; #Dogs, #cats, [#horses], livestock get care an…',
     'RT @FairWarningNews: The wildfires that ravaged CA have been contained, but the health impacts from the resulting air pollution will be sev…',
     'RT @chiarabtownley: If you know anybody who has been affected by the wildfires, please refer them to @awarenow_io It is one of the companie…']





## To Keep or Remove Retweets

A retweet is when someone shares someone else's tweet. It is similar to sharing in Facebook. Sometimes you may want to remove retweets as they contain duplicate content that might skew your analysis if you are only looking at word frequency. Other times, you may want to keep retweets. 

Below you ignore all retweets by adding `-filter:retweets` to your query. The <a href="https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/standard-operators" target="_blank">Twitter API documentation</a> has information on other ways to customize your queries. 

{:.input}
```python
new_search = search_words + " -filter:retweets"
new_search
```

{:.output}
{:.execute_result}



    '#wildfires -filter:retweets'





{:.input}
```python
tweets = tw.Cursor(api.search,
                       q=new_search,
                       lang="en",
                       since=date_since).items(5)

[tweet.text for tweet in tweets]
```

{:.output}
{:.execute_result}



    ['2/2 provide forest products to local mills, provide jobs to local communities, and improve the ecological health of… https://t.co/XemzXvyPyX',
     '1/2 Obama\'s Forest Service Chief in 2015 --&gt;"Treating these acres through commercial thinning, hazardous fuels remo… https://t.co/01obvjezQW',
     '"Start packing up!" Video shows how gender-reveal stunt sparked wildfire https://t.co/gvfNLI8NbO #Heatwave #Wildfires',
     'The pictures and stories coming out of the California #wildfires are heartbreaking, but there are plenty of good st… https://t.co/s4D7JB3VGu',
     'The wildfires that ravaged CA have been contained, but the health impacts from the resulting air pollution will be… https://t.co/bSdg9uHkqH']





## Who is Tweeting About Wildfires?

You can access a wealth of information associated with each tweet. Below is an example of accessing the users who are sending the tweets related to #wildfires and their locations. Note that user locations are manually entered into Twitter by the user. Thus, you will see a lot of variation in the format of this value. 

* `tweet.user.screen_name` provides the user's twitter handle associated with each tweet. 
* `tweet.user.location` provides the user's provided location. 

You can experiment with other items available within each tweet by typing `tweet.` and using the tab button to see all of the available attributes stored. 

{:.input}
```python
tweets = tw.Cursor(api.search, 
                           q=new_search,
                           lang="en",
                           since=date_since).items(5)


users_locs = [[tweet.user.screen_name, tweet.user.location] for tweet in tweets]
users_locs
```

{:.output}
{:.execute_result}



    [['TamaraHinton', 'Washington, DC'],
     ['TamaraHinton', 'Washington, DC'],
     ['robinsnewswire', "RT's Are FYI Purposes Only"],
     ['PublicityErika', 'Seattle area'],
     ['FairWarningNews', 'Los Angeles']]





## Create a `Pandas Dataframe` From A List of Tweet Data

One you have a list of items that you wish to work with, you can create a pandas dataframe that contains that data. 

{:.input}
```python
tweet_text = pd.DataFrame(data=users_locs, 
                    columns=['user', "location"])
tweet_text
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
      <th>user</th>
      <th>location</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>TamaraHinton</td>
      <td>Washington, DC</td>
    </tr>
    <tr>
      <th>1</th>
      <td>TamaraHinton</td>
      <td>Washington, DC</td>
    </tr>
    <tr>
      <th>2</th>
      <td>robinsnewswire</td>
      <td>RT's Are FYI Purposes Only</td>
    </tr>
    <tr>
      <th>3</th>
      <td>PublicityErika</td>
      <td>Seattle area</td>
    </tr>
    <tr>
      <th>4</th>
      <td>FairWarningNews</td>
      <td>Los Angeles</td>
    </tr>
  </tbody>
</table>
</div>





## Customizing Twitter Queries

As mentioned above, you can customize your Twitter search queries by following the <a href="https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/standard-operators" target="_blank">Twitter API documentation</a>. 

For instance, if you search for `climate+change`, Twitter will return all tweets that contain both of those words (in a row) in each tweet. 

Note that the code below creates a list that can be queried using Python indexing to return the first five tweets. 

{:.input}
```python
new_search = "climate+change -filter:retweets"

tweets = tw.Cursor(api.search,
                   q=new_search,
                   lang="en",
                   since='2018-04-23').items(1000)

all_tweets = [tweet.text for tweet in tweets]
all_tweets[:5]
```

{:.output}
{:.execute_result}



    ['“But as climate change is happening in real time, the practice of climate science...has never been at greater risk.… https://t.co/hIo1VtDnfW',
     '“Climate Change isn’t real.” https://t.co/hzY4vQ09xM',
     'BBC News - Climate change: CO2 emissions rising for first time in four years https://t.co/cxrzCQmmml',
     "Ooh LOL. Anderson Cooper - giving Trump's ignorance a whipping. https://t.co/wbivZx8YHX",
     '#NCA2018 makes it abundantly clear: the U.S. must do more to limit carbon emissions and combat the effects of clima… https://t.co/Xc81JouHQb']





In the next lesson, you will explore calculating word frequencies associated with tweets using `Python`.

<div class = "notice--info" markdown = "1" >

## Additional Resources

* <a href = "http://docs.tweepy.org/en/v3.6.0/index.html" target="_blank"> View `tweepy` Documentation</a>
* <a href="https://developer.twitter.com/en/docs/tweets/rules-and-filtering/overview/standard-operators" target="_blank">Twitter API documentation</a>

</div >
