---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-08-17'
category: [courses]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/week-12/use-twitter-api-r/
nav-title: 'Explore twitter data'
week: 12
course: "earth-analytics"
module-type: 'class'
sidebar:
  nav:
author_profile: false
comments: true
order: 2
lang-lib:
  r: ['rtweet', 'tidytext', 'dplyr']
topics:
  social-science: ['social-media']
  data-exploration-and-analysis: ['text-mining']
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Query the twitter RESTful API to access and import into R tweets that contain various text strings.
* Generate a list of users that are tweeting about a particular topic
* Use the tidytext package in R to explore and analyze word counts associated with tweets.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>


In this lesson we will explore analyzing social media data accessed from twitter,
in R. We will use the Twitter RESTful API to access data about both twitter users
and what they are tweeting about

## Getting Started

To get started we'll need to do the following things:

1. Setup a twitter account if you don't have one already
2. Using your account, setup an application that we will use to access twitter from R
3. Download and install the `rtweet` and `tidytext` packages for R.

Once we've done these things, we are reading to begin querying Twitter's API to
see what we can learn about tweets!

## Setup Twitter App

Let's start by setting up an application in twitter that we can use to access
tweets. To setup your app, follow the documentation from `rtweet` here:

<a href="https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html" target="_blank"><i class="fa fa-info-circle" aria-hidden="true"></i>
 TUTORIAL: How to setup a twitter application using your twitter account</a>

NOTE: you will need to provide your cell phone number to twitter to verify your
use of the API.

<figure>

<img src="{{ site.url }}/images/courses/earth-analytics/week-12/boulder_twitter_map_visualizations.jpg" alt="image showing tweet activity across boulder and denver.">

<figcaption>A heat map of the distribution of tweets across the Denver / Boulder region <a href="http://www.socialmatt.com/amazing-denver-twitter-visualization/" target="_blank">source: socialmatt.com</a></figcaption>
</figure>


## Twitter in R

Once we have our twitter app setup, we are ready to dive into accessing tweets in R.

We will use the `rtweet` package to do this.




```r
# load twitter library - the rtweet library is recommended now over twitteR
library(rtweet)
# plotting and pipes - tidyverse!
library(ggplot2)
library(dplyr)
# text mining library
library(tidytext)
```






The first thing that we need to setup in our code is our authentication. When
you set up your app, it provides you with 3 unique identification elements:

1. appnam
2. key
3. secret

These keys are located in your  twitter app settings in the `Keys and Access
Tokens` tab. You will need to copy those into your code as i did below replacing the filler
text that i used in this lesson for the text that twitter gives you in your app.

Next, we need to pass a suite of keys to the API.


```r
# whatever name you assigned to your created app
appname <- "your-app-name"

## api key (example below is not a real key)
key <- "yourLongApiKeyHere"

## api secret (example below is not a real key)
secret <- "yourSecretKeyHere"

```

Finally, we can create a token that authenticates access to tweets!
Note that the authentication process below will open a window in your browser.



```r
# create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)
## Error in structure(list(appname = appname, secret = secret, key = key), : object 'appname' not found
```


If authentication is successful works, it should render the following message in
a browser window:

`Authentication complete. Please close this page and return to R.`

### Send a tweet

Note that your tweet needs to be 140 characters or less.


```r
post_tweet("Look, i'm tweeting from R in my #rstats #earthanalytics class!")
# this throws an error but then says it's posted but ofcourse doesn't post.
```

### Search twitter for tweets

Now we are ready to search twitter for recent tweets! Let's start by finding all
tweets that use the `#rstats` hashtag. Notice below we use the `rtweet::search_tweets()`
function to search. `search_tweets()` requires the following arguments:

1. q: the query word that you want to look for
2. n: the number of tweets that you want returned. You can request up to a
maximum of 18,000 tweets.

To see what other arguments you can use with this function, use the `R` help:

`?search_tweets`



```r
## search for 500 tweets using the #rstats hashtag
rstats_tweets <- search_tweets(q="#rstats",
                               n = 500)
# view the first 3 rows of the dataframe
head(rstats_tweets, n=3)
##   screen_name            user_id          created_at          status_id
## 1   kdnuggets           20167623 2017-08-17 15:20:01 898202763905183744
## 2    nibrivia 760968765811064832 2017-08-17 15:18:22 898202349143035904
## 3 kellerboris          147011669 2017-08-17 15:18:15 898202318885318656
##                                                                                                                                           text
## 1       Top 10 Essential Books for the Data Enthusiast https://t.co/ZFv3W8LTVs #BigData #MachineLearning #DataScience… https://t.co/12e0CQBEDV
## 2 @NoelleTakesPics @StackOverflow Definitely #rstats: that is how you know how quickly find, understand and use the a… https://t.co/PRwiJIjyMv
## 3 RT @anilpsori: This is an amazing resource of R tutorials with corresponding code. If you do any work in R, check it out! #rstats https://t…
##   retweet_count favorite_count is_quote_status    quote_status_id
## 1             0              2           FALSE               <NA>
## 2             0              0           FALSE               <NA>
## 3             6              0            TRUE 897707028948373504
##   is_retweet  retweet_status_id in_reply_to_status_status_id
## 1      FALSE               <NA>                         <NA>
## 2      FALSE               <NA>           898201393445695489
## 3       TRUE 897997923849445381                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                  633284461                NoelleTakesPics   en
## 3                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1             Buffer     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 3          TweetDeck     <NA>      <NA>               <NA> <NA>
##                                  urls_display
## 1 buff.ly/2w8A5i2 twitter.com/i/web/status/8…
## 2                 twitter.com/i/web/status/8…
## 3                                        <NA>
##                                                                 urls_expanded
## 1 https://buff.ly/2w8A5i2 https://twitter.com/i/web/status/898202763905183744
## 2                         https://twitter.com/i/web/status/898202349143035904
## 3                                                                        <NA>
##            mentions_screen_name    mentions_user_id symbols
## 1                          <NA>                <NA>      NA
## 2 NoelleTakesPics StackOverflow 633284461 128700677      NA
## 3                     anilpsori  783815947962322945      NA
##                              hashtags coordinates place_id place_type
## 1 BigData MachineLearning DataScience          NA     <NA>       <NA>
## 2                              rstats          NA     <NA>       <NA>
## 3                              rstats          NA     <NA>       <NA>
##   place_name place_full_name country_code country bounding_box_coordinates
## 1       <NA>            <NA>         <NA>    <NA>                     <NA>
## 2       <NA>            <NA>         <NA>    <NA>                     <NA>
## 3       <NA>            <NA>         <NA>    <NA>                     <NA>
##   bounding_box_type
## 1              <NA>
## 2              <NA>
## 3              <NA>
```

## Retweets

A retweet is when you or someone else shares someone elses tweet so your / their
followers can see it. It is similar to sharing in facebook where you can add a
quote or text above the retweet if you want or just share the post. Let's use
the same query that we used above but this time ignore all retweets by setting
the `include_rts` argument to `FALSE`. We can get tweet / retweet stats from
our dataframe, separately.


```r
# find recent tweets with #rstats but ignore retweets
rstats_tweets <- search_tweets("#rstats", n = 500,
                             include_rts = FALSE)
# view top 2 rows of data
head(rstats_tweets, n=2)
##   screen_name            user_id          created_at          status_id
## 1   kdnuggets           20167623 2017-08-17 15:20:01 898202763905183744
## 2    nibrivia 760968765811064832 2017-08-17 15:18:22 898202349143035904
##                                                                                                                                           text
## 1       Top 10 Essential Books for the Data Enthusiast https://t.co/ZFv3W8LTVs #BigData #MachineLearning #DataScience… https://t.co/12e0CQBEDV
## 2 @NoelleTakesPics @StackOverflow Definitely #rstats: that is how you know how quickly find, understand and use the a… https://t.co/PRwiJIjyMv
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              1           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>           898201393445695489
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                  633284461                NoelleTakesPics   en
##               source media_id media_url media_url_expanded urls
## 1             Buffer     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                                  urls_display
## 1 buff.ly/2w8A5i2 twitter.com/i/web/status/8…
## 2                 twitter.com/i/web/status/8…
##                                                                 urls_expanded
## 1 https://buff.ly/2w8A5i2 https://twitter.com/i/web/status/898202763905183744
## 2                         https://twitter.com/i/web/status/898202349143035904
##            mentions_screen_name    mentions_user_id symbols
## 1                          <NA>                <NA>      NA
## 2 NoelleTakesPics StackOverflow 633284461 128700677      NA
##                              hashtags coordinates place_id place_type
## 1 BigData MachineLearning DataScience          NA     <NA>       <NA>
## 2                              rstats          NA     <NA>       <NA>
##   place_name place_full_name country_code country bounding_box_coordinates
## 1       <NA>            <NA>         <NA>    <NA>                     <NA>
## 2       <NA>            <NA>         <NA>    <NA>                     <NA>
##   bounding_box_type
## 1              <NA>
## 2              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "kdnuggets"       "nibrivia"        "jd_wilko"        "NoelleTakesPics"
## [5] "thonoir"         "QuentinDRead"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "kdnuggets"       "nibrivia"        "jd_wilko"       
##   [4] "NoelleTakesPics" "thonoir"         "QuentinDRead"   
##   [7] "swfknecht"       "StefanieButland" "ActivevoiceSw"  
##  [10] "RickWicklin"     "PacktPub"        "nierhoff"       
##  [13] "sgivan"          "g_fiske"         "globalizefm"    
##  [16] "kspatial"        "ingorohlfing"    "GeospatialUCD"  
##  [19] "MicheleTobias"   "jhollist"        "dreamRs_fr"     
##  [22] "DavidZenz"       "LuigiBiagini"    "BDataScientist" 
##  [25] "pdxrlang"        "sckottie"        "KyleScotShank"  
##  [28] "jamie_jezebel"   "rweekly_live"    "CRANberriesFeed"
##  [31] "heyallisongray"  "v_vashishta"     "aimandel"       
##  [34] "RLadiesChicago"  "suman12029"      "the18gen"       
##  [37] "jlmico"          "DingemanseMark"  "data_gurus"     
##  [40] "ido87"           "tjpalanca"       "wrathematics"   
##  [43] "nielsberglund"   "jumping_uk"      "SharePointSwiss"
##  [46] "CardiffRUG"      "LockeData"       "dataandme"      
##  [49] "mdsumner"        "ClaireMKBowen"   "R_Forwards"     
##  [52] "chrisderv"       "olgunaydinn"     "IronistM"       
##  [55] "BillPetti"       "hadleywickham"   "rhodyrstats"    
##  [58] "MrYeti1"         "statsforbios"    "mikeloukides"   
##  [61] "FelipeSMBarros"  "adamhsparks"     "cpwbroadmead"   
##  [64] "thinkR_fr"       "ellamkaye"       "TeebzR"         
##  [67] "_AntoineB"       "maxheld"         "R_Graph_Gallery"
##  [70] "JRBerrendero"    "jenstirrup"      "jrcajide"       
##  [73] "LearnRinaDay"    "vivekbhr"        "ma_salmon"      
##  [76] "aymanfabuelela"  "RossTrendlock"   "gombang"        
##  [79] "KVittingSeerup"  "MilesMcBain"     "AngelosVanKr"   
##  [82] "jody_tubi"       "MColebrook"      "uuinfolab"      
##  [85] "jessenleon"      "Rexercises"      "DeborahTannon"  
##  [88] "Rbloggers"       "datacarpentry"   "DailyRpackage"  
##  [91] "groundwalkergmb" "starry_flounder" "bluecology"     
##  [94] "TrevorABranch"   "KirkDBorne"      "TweetSKS"       
##  [97] "joranelias"      "rzembo"          "f_dion"         
## [100] "lenkiefer"       "NickFoxstats"    "cloudaus"       
## [103] "anilpsori"       "obrl_soil"       "potterzot"      
## [106] "2Engenheiros"    "alexpghayes"     "JaneLSumner"    
## [109] "SavranWeb"       "vivalosburros"   "LeahAWasser"    
## [112] "AnalyticsVidhya" "TedHayes007"     "jwgayler"       
## [115] "PeterFlomStat"   "peterflom"       "symbolixAU"     
## [118] "jyazman2012"     "n_ashutosh"      "benmarwick"     
## [121] "benmatheson"     "guangchuangyu"   "RLadiesLA"      
## [124] "olyerickson"     "staffanbetner"   "dvaughan32"     
## [127] "RoelandtN42"     "FFDataStream"    "AriLamstein"    
## [130] "DerFredo"        "angeld_az"       "Torontosj"      
## [133] "czeildi"         "noamross"        "arosenberger"   
## [136] "pherreraariza"   "sctyner"         "kierisi"        
## [139] "ellis2013nz"     "rstatsdata"      "pinkyprincess"  
## [142] "regionomics"     "PaulLantos"      "dmi3k"          
## [145] "feralaes"        "Hao_and_Y"       "satoru0"        
## [148] "RStudioJoe"      "nubededatos"     "lan24hd"        
## [151] "itschekkers"     "pie_says_no"     "peterdalle"     
## [154] "fabian_zehner"   "kevinkeenan_"    "MathIsEH"       
## [157] "MDFBasha"        "oducepd"         "PaulCampbell91" 
## [160] "hrbrmstr"        "rstudiotips"     "fubits"         
## [163] "bunnefeld"       "PeterBChi"       "sociographie"   
## [166] "maureviv"        "ctorrez2011"     "thatdnaguy"     
## [169] "daroczig"        "revodavid"       "RLadiesNYC"     
## [172] "ImDataScientist" "austinwpearce"   "BigDataInsights"
## [175] "ryangas2"        "andyteucher"     "RLangTip"       
## [178] "marskar"         "EamonCaddigan"   "larnsce"        
## [181] "johnjanuszczak"  "emljames"        "BrockTibert"    
## [184] "worldquantu"     "robinson_es"     "pakdamie"       
## [187] "YaleSportsGroup" "tipsder"         "seanmhoban"     
## [190] "expersso"        "Displayrr"       "McMcgregory"    
## [193] "sedgeboy"        "sveurope"        "rogilmore"      
## [196] "benheubl"        "thomasp85"       "AlexDunhill"    
## [199] "fellgernon"      "Talent_metrics"  "jrosenberg6432" 
## [202] "bass_analytics"  "fredpolicarpo"   "IvanLQF"        
## [205] "berndweiss"      "dangerpeel"      "LuisDVerde"     
## [208] "kdubovikov"      "matthrussell"    "malpaso"        
## [211] "RICarpenter"     "aschinchon"      "MarcosFontela"  
## [214] "bobehayes"       "n_samples"       "StephanRoess"   
## [217] "seabbs"          "Data_World_Blog" "HelicityBoson"  
## [220] "JT_EpiVet"       "CharlotteRobin"  "datentaeterin"  
## [223] "journocode"      "oaggimenez"      "Jap0nism"       
## [226] "QuixoticQuant"   "lbusetto74"      "pdalgd"         
## [229] "TempoReale24"    "mKachala"        "_ColinFay"      
## [232] "gavin_fay"       "_GregoryPrince_" "_Data_Science_" 
## [235] "R_Programming"   "kenbenoit"       "robertstats"    
## [238] "InfonomicsToday" "BobLovesData"    "riannone"       
## [241] "pommedeterre33"  "m_mina"          "tetsuroito"     
## [244] "yuichiotsuka"    "wmlandau"        "stephenelane"   
## [247] "OilGains"        "KanAugust"       "coolbutuseless" 
## [250] "anamanarye"      "AngeBassa"       "mjwalds"        
## [253] "stevonio"        "NicholasStrayer" "jaminday"       
## [256] "Emaasit"         "kellenbyrnes"    "KKulma"         
## [259] "stfnmllr"        "brennanpcardiff" "DataCamp"       
## [262] "robert_squared"  "fredericksolt"   "pbaumgartner"   
## [265] "lariebyrd"       "Datatitian"
```

We can similarly use the `search_users()` function to just see what users are tweeting
using a particular hashtag. This function returns just a data.frame of the users
and information about their accounts.


```r
# what users are tweeting with #rstats
users <- search_users("#rstats",
                      n=500)
# just view the first 2 users - the data frame is large!
head(users, n=2)
##      user_id               name screen_name             location
## 1    5685812          boB Rudis    hrbrmstr Underground Cell #34
## 2 4911181019 Statistician Jason RStatsJason          Atlanta, GA
##                                                                                                                                                             description
## 1 Don't look at me…I do what he does—just slower. #rstats avuncular • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
## 2                              I tweet about Public Health and other things. Founder and current Chair of #Rstats User Group @CDCGov. Alumnus/Instructor @EmoryRollins.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE            8562           376          582 2007-05-01 14:04:24
## 2     FALSE             319           956           27 2016-02-15 00:48:05
##   favourites_count utc_offset                  time_zone geo_enabled
## 1             9597     -14400 Eastern Time (US & Canada)       FALSE
## 2             3340     -25200 Pacific Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1     TRUE          66721   en                FALSE         FALSE
## 2    FALSE           6285   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   022330
## 2                  FALSE                   F5F8FA
##                                                     profile_background_image_url
## 1 http://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
## 2                                                                           <NA>
##                                                profile_background_image_url_https
## 1 https://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
## 2                                                                            <NA>
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2 http://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2 https://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2 http://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2 https://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             94BD5A                       FFFFFF
## 2             1DA1F2                       C0DEED
##   profile_sidebar_fill_color profile_text_color
## 1                     C0DFEC             333333
## 2                     DDEEF6             333333
##   profile_use_background_image default_profile default_profile_image
## 1                         TRUE           FALSE                 FALSE
## 2                         TRUE            TRUE                 FALSE
##                                         profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/5685812/1398248552
## 2                                                     <NA>
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 329

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="100%" />

Let's sort by count and just plot the top locations. To do this we use top_n().
Note that in this case we are grouping our data by user. Thus top_n() will return
locations with atleast 15 users associated with it.


```r
users %>%
  count(location, sort=TRUE) %>%
  mutate(location= reorder(location,n)) %>%
  top_n(20) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() +
      labs(x="Count",
      y="Location",
      title="Where Twitter users are from - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="100%" />

It looks like we have some `NA` or no data values in our list. Let's remove those
with `na.omit()`.


```r
users %>%
  count(location, sort=TRUE) %>%
  mutate(location= reorder(location,n)) %>%
  na.omit() %>%
  top_n(20) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() +
      labs(x="Location",
      y="Count",
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="100%" />

Looking at our data, what do you notice that might improve this plot?
There are 314 unique locations in our list. However, everyone didn't specify their
locations using the approach. For example some just identified their country:
United States for example and others specified a city and state. We may want to
do some cleaning of these data to be able to better plot this distribution - especially
if we want to create a map of these data!

### Users by time zone

Lets have a look at the time zone field next.




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Use the example above, plot users by time zone. List time zones that have atleast
20 users associated with them. What do you notice about the data?
</div>

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="100%" />




The plots above aren't perfect. What do you start to notice about working
with these data? Can we simply download them and plot the data?

## Data munging  101

When we work with data from sources like NASA, USGS, etc there are particular
cleaning steps that we often need to do. For instance:

* we may need to remove nodata values
* we may need to scale the data
* and others

In the next lesson we will dive deeper into the art of "text-mining" to extract
information about a particular topic from twitter.


<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://tidytextmining.com/" target="_blank">Tidy text mining online book</a>
* <a href="https://mkearney.github.io/rtweet/articles/intro.html#retrieving-trends" target="_blank">A great overview of the rtweet package by Mike Kearny</a>
* <a href="https://francoismichonneau.net/2017/04/tidytext-origins-of-species/" target="_blank">A blog post on tidytext by Francois Michonneau</a>
*  <a href="https://blog.twitter.com/2008/what-does-rate-limit-exceeded-mean-updated" target="_blank">About the twitter API rate limit</a>

</div>
