---
layout: single
title: "Access twitter data using rtweet"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-04-19'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/use-twitter-api-r/
nav-title: 'Use twitter API'
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 2
lang-lib:
  r: ['rtweet', 'tidytext', 'dplyr']
tags2:
  social-science: ['social-media']
  data-analysis-exploration: ['text-mining']
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
3. Download and install the rtweet and tidytext packages for R.

Once we've done these things, we are reading to begin querying Twitter's API to 
see what we can learn about tweets! 

## Setup Twitter App 

Let's start by setting up an application in twitter that we can use to access
tweets. To setup your app, follow the documentation from `rtweet` here:

<a href="https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html" target="_blank">setup twitter app</a>

<figure>

<img src="http://www.socialmatt.com/wp-content/uploads/2015/03/Boulder_Twitter_Map_Visualizations.jpg">

<figcaption>A heat map of the distrubtion of tweets across the Denver / Boulder region <a href="http://www.socialmatt.com/amazing-denver-twitter-visualization/" target="_blank">source: socialmatt.com</a></figcaption>
</figure>


## Twitter in R

Once we have our twitter app setup, we are ready to dive into accessing tweets in R.
We will use the rtweet package to do this.  




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
```


If authentication is successful works, it should render the following message in 
a browser window:

`Authentication complete. Please close this page and return to R.`

## Rate Limits
https://blog.twitter.com/2008/what-does-rate-limit-exceeded-mean-updated
up to 100 API calls an hour.


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
rstats_tweets <- search_tweets(q="#rstats", n = 500)
# view the first 3 rows of the dataframe
head(rstats_tweets, n=3)
##    screen_name    user_id          created_at          status_id
## 1    sharon000   10915042 2017-04-19 19:31:30 854779510440558595
## 2 dataproblems 3161843418 2017-04-19 19:30:02 854779139060101121
## 3       krmita    4174231 2017-04-19 19:29:44 854779064770600963
##                                                                                                                                            text
## 1 Just updated with several *more* useful R functions from readers &amp; social media #rstats \nhttps://t.co/av3viKiuMC https://t.co/5jLELBC4nM
## 2  RT @KirkDBorne: R and #Python cheatsheets for #DataScientists: https://t.co/1uZN8FgNL9 #abdsc #BigData #DataScience #Rstats #MachineLearnin…
## 3  RT @KirkDBorne: R and #Python cheatsheets for #DataScientists: https://t.co/1uZN8FgNL9 #abdsc #BigData #DataScience #Rstats #MachineLearnin…
##   retweet_count favorite_count is_quote_status    quote_status_id
## 1             0              1            TRUE 845369732148707329
## 2           130              0           FALSE               <NA>
## 3           130              0           FALSE               <NA>
##   is_retweet  retweet_status_id in_reply_to_status_status_id
## 1      FALSE               <NA>                         <NA>
## 2       TRUE 854536038487863296                         <NA>
## 3       TRUE 854536038487863296                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                source media_id media_url media_url_expanded urls
## 1  Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2  HoseMeDownWithData     <NA>      <NA>               <NA> <NA>
## 3 Twitter for Android     <NA>      <NA>               <NA> <NA>
##                                  urls_display
## 1 cwrld.us/6Rfuns twitter.com/sharon000/stat…
## 2                              bit.ly/2ovkvXb
## 3                              bit.ly/2ovkvXb
##                                                                    urls_expanded
## 1 http://cwrld.us/6Rfuns https://twitter.com/sharon000/status/845369732148707329
## 2                                                          http://bit.ly/2ovkvXb
## 3                                                          http://bit.ly/2ovkvXb
##   mentions_screen_name mentions_user_id symbols
## 1                 <NA>             <NA>      NA
## 2           KirkDBorne        534563976      NA
## 3           KirkDBorne        534563976      NA
##                                                 hashtags coordinates
## 1                                                 rstats          NA
## 2 Python DataScientists abdsc BigData DataScience Rstats          NA
## 3 Python DataScientists abdsc BigData DataScience Rstats          NA
##   place_id place_type place_name place_full_name country_code country
## 1     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
## 2     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
## 3     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
##   bounding_box_coordinates bounding_box_type
## 1                     <NA>              <NA>
## 2                     <NA>              <NA>
## 3                     <NA>              <NA>
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
head(rstats_tweets, n=2)
##    screen_name            user_id          created_at          status_id
## 1    sharon000           10915042 2017-04-19 19:31:30 854779510440558595
## 2 rweekly_live 844152803991994368 2017-04-19 19:29:02 854778889519976448
##                                                                                                                                            text
## 1 Just updated with several *more* useful R functions from readers &amp; social media #rstats \nhttps://t.co/av3viKiuMC https://t.co/5jLELBC4nM
## 2                                                   Machine Learning Using Support Vector Machines #rstats #datascience https://t.co/gWGL2h0b1P
##   retweet_count favorite_count is_quote_status    quote_status_id
## 1             0              1            TRUE 845369732148707329
## 2             0              0           FALSE               <NA>
##   is_retweet retweet_status_id in_reply_to_status_status_id
## 1      FALSE              <NA>                         <NA>
## 2      FALSE              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2      R Weekly Live     <NA>      <NA>               <NA> <NA>
##                                  urls_display
## 1 cwrld.us/6Rfuns twitter.com/sharon000/stat…
## 2                        link.rweekly.org/3ba
##                                                                    urls_expanded
## 1 http://cwrld.us/6Rfuns https://twitter.com/sharon000/status/845369732148707329
## 2                                                   https://link.rweekly.org/3ba
##   mentions_screen_name mentions_user_id symbols           hashtags
## 1                 <NA>             <NA>      NA             rstats
## 2                 <NA>             <NA>      NA rstats datascience
##   coordinates place_id place_type place_name place_full_name country_code
## 1          NA     <NA>       <NA>       <NA>            <NA>         <NA>
## 2          NA     <NA>       <NA>       <NA>            <NA>         <NA>
##   country bounding_box_coordinates bounding_box_type
## 1    <NA>                     <NA>              <NA>
## 2    <NA>                     <NA>              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag. 


```r
# view column with screen names
head(rstats_tweets$screen_name)
## [1] "sharon000"       "rweekly_live"    "timelyportfolio" "hrbrmstr"       
## [5] "RLadiesLondon"   "Fran_Quinto"
# get a list of just the unique usernames
unique(rstats_tweets$screen_name)
##   [1] "sharon000"       "rweekly_live"    "timelyportfolio"
##   [4] "hrbrmstr"        "RLadiesLondon"   "Fran_Quinto"    
##   [7] "DiegoKuonen"     "dataandme"       "AndySugs"       
##  [10] "thosjleeper"     "rafaeltaph"      "jhollist"       
##  [13] "Rbloggers"       "Rexercises"      "ShinyappsRecent"
##  [16] "the18gen"        "cascadiarconf"   "pdxrlang"       
##  [19] "sckottie"        "thinkR_fr"       "jtleek"         
##  [22] "richierocks"     "dmedri"          "tjmahr"         
##  [25] "nierhoff"        "msarsar"         "cconcannon1"    
##  [28] "Yeedle"          "drob"            "AedinCulhane"   
##  [31] "garrido_ruben"   "CRANberriesFeed" "innova_scape"   
##  [34] "TransmitScience" "emTr0"           "lawremi"        
##  [37] "phnk"            "MatthewRenze"    "rstudiotips"    
##  [40] "wstrasser"       "FrankBergeron"   "jletteboer"     
##  [43] "jprins"          "Matt_Craddock"   "DataCamp"       
##  [46] "JMBecologist"    "RLangTip"        "DataMic"        
##  [49] "jopxtwits"       "joshua_ulrich"   "opendefra"      
##  [52] "Jemus42"         "StrimasMackey"   "revodavid"      
##  [55] "SteffLocke"      "benjguin"        "r4ecology"      
##  [58] "nanotechBuzz"    "randyzwitch"     "moroam"         
##  [61] "aksingh1985"     "butterflyology"  "rOpenSci"       
##  [64] "BobMuenchen"     "verajosemanuel"  "Biff_Bruise"    
##  [67] "cjdinger"        "CoreySparks1"    "lemur78"        
##  [70] "walkingrandomly" "TeebzR"          "CassieFreund"   
##  [73] "GaryDower"       "jonny_polonsky"  "DeborahTannon"  
##  [76] "ExperianDataLab" "ilustat"         "justminingdata" 
##  [79] "EarthLabCU"      "ThomasKoller"    "Benavent"       
##  [82] "zevross"         "_jennytweets"    "DD_FaFa_"       
##  [85] "AGSBS43"         "MangoTheCat"     "rushworth_a"    
##  [88] "Mooredvdcoll"    "LockeData"       "digr_io"        
##  [91] "LearnRinaDay"    "brochuregroup"   "outilammi"      
##  [94] "ma_salmon"       "csgillespie"     "mahiGaur85"     
##  [97] "kavstats"        "statsforbios"    "vivekbhr"       
## [100] "giveawayjusa"    "JamesEBartlett"  "btorobrob"      
## [103] "Emma_Owl_Cole"   "nic_crane"       "zx8754"         
## [106] "M_Gatta"         "ScientificGems"  "aylmerarellon"  
## [109] "zoltanvarju"     "meetup_r_nantes" "axelrod_eric"   
## [112] "neilcharles_uk"  "stephenelane"    "IronistM"       
## [115] "BitsOfKnowledge" "t_s_institute"   "Prashant_1722"  
## [118] "BigDataInsights" "FirstLink_bdx"   "gombang"        
## [121] "mdsumner"        "mjkrasny"        "dirk_sch"       
## [124] "kearneymw"       "statistik_zh"    "YourStatsGuru"  
## [127] "TimDoherty_"     "DailyRpackage"   "jlmico"         
## [130] "startupshireme"  "DD_NaNa_"        "annemariayritys"
## [133] "awhstin"         "jnmaloof"        "pyguide"        
## [136] "KirkDBorne"      "theotheredgar"   "lenkiefer"      
## [139] "BenBondLamberty" "smgaynor"        "BUStoryWithData"
## [142] "LeahAWasser"     "rbloggersBR"     "postoditacco"   
## [145] "DBaker007"       "yoniceedee"      "DataScienceInR" 
## [148] "WinVectorLLC"    "AnalyticsVidhya" "pakdamie"       
## [151] "adamhsparks"     "macroarb"        "QuakerHealth"   
## [154] "nj_tierney"      "hanleybadger"    "sane_panda"     
## [157] "MilesMcBain"     "scilahn"         "bearloga"       
## [160] "zabormetrics"    "robinson_es"     "ucdlevy"        
## [163] "surlyurbanist"   "SophDavison1"    "Nadia_Gonzalez" 
## [166] "RLadiesNYC"      "rquintino"       "ParkvilleGeek"  
## [169] "b23kelly"        "jaredlander"     "nyhackr"        
## [172] "rossholmberg"    "ucfagls"         "davidmeza1"     
## [175] "CoprimeAnalytic" "GJBotwin"        "nDimensional"   
## [178] "ToferC"          "contefranz"      "elpidiofilho"   
## [181] "buriedinfo"      "pssGuy"          "NovasTaylor"    
## [184] "s_bogdanovic"    "MGCodesandStats" "old_man_chester"
## [187] "AntoViral"       "clarkfitzg"      "jknowles"       
## [190] "wispdx"          "social_lista"    "Biology_SCSU"   
## [193] "jenitive_case"   "jeroenhjanssens" "AriLamstein"    
## [196] "NCrepalde"       "davidjayharris"  "JennyBryan"     
## [199] "CCPQuant"        "_lacion_"        "CollinVanBuren" 
## [202] "beyondvalence"   "hipradhan7"      "SSC_stat"       
## [205] "gshotwell"       "_mikoontz"       "KrisEberwein"   
## [208] "abiyugiday"      "mikkelkrogsholm" "G_Devailly"     
## [211] "thebyrdlab"      "ilarischeinin"   "jaheppler"      
## [214] "ContinuumIO"     "RSSGlasgow1"     "earlconf"       
## [217] "CMastication"    "ZKamvar"         "KKulma"         
## [220] "eyeshakingking_" "AlexCEngler"     "GateB_com"      
## [223] "BroVic"          "Xtophe_Bontemps" "Stato_Grant"    
## [226] "ATHumphries"     "giacomoecce"     "MDFBasha"       
## [229] "kdnuggets"       "dataelixir"      "SpacePlowboy"   
## [232] "HPDSLab"         "sauer_sebastian" "gp_pulipaka"    
## [235] "dirkvandenpoel"  "jaynal83"        "sowasser"       
## [238] "techiexpert"     "ImDataScientist" "TinaACormier"   
## [241] "F1000Research"   "toates_19"       "dmi3k"          
## [244] "AnalyticsPanda"  "ConcejeroPedro"  "Dimitris_Ps"    
## [247] "TomAugust85"
```

We can similarly use the `search_users()` function to just see what users are tweeting
using a particular hashtag. This function returns just a data.frame of the users 
and information about their accounts.


```r
# what users are tweeting with #rstats
users <- search_users("#rstats", n=500)
# just view the first 2 users - the data frame is large!
head(users, n=2)
##     user_id            name screen_name             location
## 1 295344317 One R Tip a Day    RLangTip                 <NA>
## 2   5685812       Боб Рудіс    hrbrmstr Underground Cell #34
##                                                                                                                                                           description
## 1                                                     One tip per day M-F on the R programming language #rstats. Brought to you by the R community team at Microsoft.
## 2 Don't look at me…I do what he does—just slower. #rstats fanatic • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE           41747            11         1263 2011-05-08 20:51:40
## 2     FALSE            7947           295          561 2007-05-01 14:04:24
##   favourites_count utc_offset                  time_zone geo_enabled
## 1                3     -25200 Pacific Time (US & Canada)       FALSE
## 2             8006     -14400 Eastern Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           1627   en                FALSE         FALSE
## 2     TRUE          62658   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   3369B4
## 2                  FALSE                   022330
##                                                     profile_background_image_url
## 1                               http://abs.twimg.com/images/themes/theme1/bg.png
## 2 http://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
##                                                profile_background_image_url_https
## 1                               https://abs.twimg.com/images/themes/theme1/bg.png
## 2 https://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1         http://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
## 2 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                       profile_image_url_https
## 1         https://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
## 2 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                          profile_image_url.1
## 1         http://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
## 2 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                     profile_image_url_https.1
## 1         https://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
## 2 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             3369B4                       3369B4
## 2             94BD5A                       FFFFFF
##   profile_sidebar_fill_color profile_text_color
## 1                     FFFFFF             333333
## 2                     C0DFEC             333333
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                         TRUE           FALSE                 FALSE
##                                         profile_banner_url
## 1                                                     <NA>
## 2 https://pbs.twimg.com/profile_banners/5685812/1398248552
```

Let's learn a bit more about these people tweeting about R. First, where are 
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 313

users %>% 
  ggplot(aes(location)) +
  geom_bar() + coord_flip()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/explore-users-1.png" title=" " alt=" " width="100%" />

Let's sort by count and just plot the top 15 locations.


```r
users %>% 
  count(location, sort=TRUE) %>% 
  mutate(location= reorder(location,n)) %>% 
  top_n(15) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() 
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/unnamed-chunk-2-1.png" title=" " alt=" " width="100%" />

Looking at our data, what do you notice that might improve this plot?
There are 314 unique locations in our list. However, everyone didn't specify their
locations using the approach. For example some just identified their country:
United States for example and others specified a city and state. We may want to 
do some cleaning of these data to be able to better plot this. 

Lets have a look at the time zone field next.



```r
# plot a list of users by time zone
users %>% ggplot(aes(time_zone)) +
  geom_bar() + coord_flip()
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-users-timezone-1.png" title=" " alt=" " width="100%" />

Using the code above, plot users by time zone. List the top 20 time zones. 
What do you notice about the data?

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title=" " alt=" " width="100%" />




The plots above aren't perfect. What do you start to notice about working 
with these data? Can we simply download them and plot the data?

## Data munging  101 

When we work with data from sources like NASA, USGS, etc there are particular 
cleaning steps that we often need to do. For instance:

* we may need to remove nodata values
* we may need to scale the data
* and others

However, the data generally have a set structure in terms of file formats and metadata.

When we work with social media and other text data the user community creates and 
curates the content. This means there are NO RULES! This also means that we may 
have to perform extra steps to clean the data to ensure we are analyzing the right 
thing. 


## Searching for tweets related to fire

Above we learned some things about sorting through social media data and the 
associated types of issues that we may run into when begining to analyze it. Next,
let's look at a different workflow - exploring the actual text of the tweets which 
will involve some text mining. 

In this example, let's find tweets that are using the words "forest fire" in them.



```r

# Find tweet using forest fire in them
forest_fire_tweets <- search_tweets(q="forest fire", n=100, lang="en",
                             include_rts = FALSE)

# it doesn't like the type = recent argument - a bug?
```


Let's look at the results. Note any issues with our data?
It seems like when we search for forest fire, we get tweets that contain the words
forest and fire in them - but these tweets are not necessarily all related to our 
science topic of interest. Or are they?

If we set our query to `q="forest+fire"` rather than `forest fire` then the 
API fill find tweets that use the words together in a string rathen than across
the entire string. Let's try it. 


```r
# Find tweet using forest fire in them
fire_tweets <- search_tweets(q="forest+fire", n=100, lang="en",
                             include_rts = FALSE)
# check data to see if there are emojis
head(fire_tweets$text)
## [1] "Fire at Nebraska National Forest near Halsey nearly contained thanks, in part, to fire suppression system in the sk… https://t.co/sxf0tspdpT"
## [2] "I liked a @YouTube video https://t.co/4KdHKuYc4g Workshop Item Demonstration: Forest Fire"                                                   
## [3] "Trip to CenterParcs Sherwood Forest: https://t.co/F71R5TtA3F via @YouTube"                                                                   
## [4] "Forest fire risk may increase due to warm summer weather https://t.co/n0xjrk2Xir via @fireincanada"                                          
## [5] "@marthaoutlaw A forest fire could say the same thing."                                                                                       
## [6] "The home overlooks Upper Long Lake from Blue Heron Court in a gated community just west of Forest Lake Country... https://t.co/Myp9HCMzz8"
```

## Data clean-up

Looking at the data above, it becomes clear that there is a lot of clean-up
associated with social media data.

For one, we live in an emoji driven world. Yet it's not necessarily useful
for us to look at emojis. We can remove them by converting the data as follows.

- Unfortunately, `R` isn't so great with emojis etc, so we'll strip these.


```r
# check data to see if there are emojis
head(fire_tweets$text)
## [1] "Fire at Nebraska National Forest near Halsey nearly contained thanks, in part, to fire suppression system in the sk… https://t.co/sxf0tspdpT"
## [2] "I liked a @YouTube video https://t.co/4KdHKuYc4g Workshop Item Demonstration: Forest Fire"                                                   
## [3] "Trip to CenterParcs Sherwood Forest: https://t.co/F71R5TtA3F via @YouTube"                                                                   
## [4] "Forest fire risk may increase due to warm summer weather https://t.co/n0xjrk2Xir via @fireincanada"                                          
## [5] "@marthaoutlaw A forest fire could say the same thing."                                                                                       
## [6] "The home overlooks Upper Long Lake from Blue Heron Court in a gated community just west of Forest Lake Country... https://t.co/Myp9HCMzz8"

# strip emojis using iconv then remove na
fire_tweets <- fire_tweets %>%
  mutate(stripped_text = iconv(forest_fire_tweets$text, "ASCII", "UTF-8", sub=""))
```

Next, there are url's in our tweets. If we want to do a text analysis to figure out 
what words are most common in our tweets, the URL's won't be helpful. Let's remove 
those. 


```r
# remove urls tidyverse is failing here for some reason
#fire_tweets %>% 
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually            
fire_tweets$stripped_text <- gsub("http.*","",fire_tweets$stripped_text)
```

Finally, we can clean up our text. If we are trying to create a list of unique
words in our tweets, words with capilitalization will be different from words 
that are all lowercase. Also we don't need punctuation to be returned as a unique
word. 


```r
a_list_of_words <- c("Dog", "dog", "dog", "cat", "cat", ",")
unique(a_list_of_words)
## [1] "Dog" "dog" "cat" ","
```


We can use the `tidytext::unnest_tokens()` function in the tidytext package to 
magically clean up our text! When we use this function:

1. each word found in the text will be converted to lowercase
2. punctuation will be removed, and 
3. a unique id will be added for each occurence of the word 

The unnest_tokens() function takes two arguments:

1. the name of the column where the unique word will be stored and
2. the column name from the data.frame that you are using that you want to pull unique words from.

In our case, we want to use the `stripped_text` column which is where we have our 
cleaned up tweet text stored.



```r
# remove puncuation, convert to lowercase, add id for each tweet!
fire_tweet_text_clean <- fire_tweets %>% 
  dplyr::select(stripped_text) %>% 
  unnest_tokens(word, stripped_text)
```

Now we can plot our data. What do you notice? 


```r
# plot the top 15 words -- notice any issues?
fire_tweet_text_clean %>%
  count(word, sort=TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() 
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-uncleaned-data-1.png" title=" " alt=" " width="100%" />

OUr plot of unique words contains some wors that may not be useful to use. For instance
"a" and "to". In the word of text mining we call those words - 'stop words'. 
We want to remove these words from our analysis as they are fillers used to compose 
a sentence. 

Lucky for use, the tidytext package has a function that will help us clean up stop 
words! TO use this we

1. load the "stop_words" data included with tidytext. This data is simply a list of words that we may want to remove in a natural language analysis.
2. then we use anti_join to remove all stop words from our analysis.

Let's give this a try next!


```r
# load list of stop words - from the tidytext package
data("stop_words")
# view first 6 words
head(stop_words)
## # A tibble: 6 × 2
##        word lexicon
##       <chr>   <chr>
## 1         a   SMART
## 2       a's   SMART
## 3      able   SMART
## 4     about   SMART
## 5     above   SMART
## 6 according   SMART

nrow(fire_tweet_text_clean)
## [1] 1260

# remove stop words from our list of words 
cleaned_tweet_words <- fire_tweet_text_clean %>% 
  anti_join(stop_words)

# there should be fewer words now
nrow(cleaned_tweet_words)
## [1] 783
```

Now that we've performed this final step of cleaning, we can try to plot, once 
again. 


```r
# plot the top 15 words -- notice any issues?
cleaned_tweets %>%
  count(word, sort=TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() 
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-cleaned-words-1.png" title=" " alt=" " width="100%" />

Does the plot look better?



<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://mkearney.github.io/rtweet/articles/intro.html#retrieving-trends" target="_blank">A great overview of the rtweet package by Mike Kearny</a> 
* <a href="https://francoismichonneau.net/2017/04/tidytext-origins-of-species/" target="_blank">A blog post on tidytext by Francois Michonneau</a> 
</div>
