---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-04-28'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/use-twitter-api-r/
nav-title: 'Explore twitter data'
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

<img src="{{ site.url }}/images/course-materials/earth-analytics/week-12/boulder_twitter_map_visualizations.jpg" alt="image showing tweet activity across boulder and denver.">

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
##       screen_name    user_id          created_at          status_id
## 1   hadleywickham   69133574 2017-04-28 22:15:36 858082297161162752
## 2 machinelearnbot 4820804277 2017-04-28 22:12:56 858081625430773760
## 3       garthtarr  237998293 2017-04-28 22:12:09 858081429565001729
##                                                                                                                                               text
## 1 RT @beeonaposy: .@RLadiesAustin needs Lightning Talks! Topics include:\n\nMay: Useful packages\nJune: Learning #rstats\nJuly: Statistics + mach…
## 2                         RT @kdnuggets: How to do factor analysis using #rstats? https://t.co/b57JNHGHPs #MachineLearning https://t.co/CEEw1bQXv9
## 3               A nice excercise for learning data science with #rstats - exploring Opal Tap on/off with time and location https://t.co/brA2lnSNam
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             3              0           FALSE            <NA>       TRUE
## 2            10              0           FALSE            <NA>       TRUE
## 3             0              0           FALSE            <NA>      FALSE
##    retweet_status_id in_reply_to_status_status_id
## 1 857961072262860800                         <NA>
## 2 858007408748228608                         <NA>
## 3               <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                   source           media_id
## 1       Tweetbot for iΟS               <NA>
## 2 Machine learning Bot 6 858007406059569152
## 3     Twitter Web Client               <NA>
##                                        media_url
## 1                                           <NA>
## 2 http://pbs.twimg.com/media/C-hBMJzVwAARfk6.jpg
## 3                                           <NA>
##                                                media_url_expanded urls
## 1                                                            <NA> <NA>
## 2 https://twitter.com/kdnuggets/status/858007408748228608/photo/1 <NA>
## 3                                                            <NA> <NA>
##                                    urls_display
## 1                                          <NA>
## 2                               buff.ly/2qbeaR5
## 3 opendata.transport.nsw.gov.au/dataset/opal-t…
##                                                           urls_expanded
## 1                                                                  <NA>
## 2                                                http://buff.ly/2qbeaR5
## 3 https://opendata.transport.nsw.gov.au/dataset/opal-tap-on-and-tap-off
##       mentions_screen_name             mentions_user_id symbols
## 1 beeonaposy RLadiesAustin 215035672 809427007587155968      NA
## 2                kdnuggets                     20167623      NA
## 3                     <NA>                         <NA>      NA
##                 hashtags coordinates         place_id place_type
## 1                 rstats          NA             <NA>       <NA>
## 2 rstats MachineLearning          NA             <NA>       <NA>
## 3                 rstats          NA 01cc83b303f0c068       city
##   place_name            place_full_name country_code   country
## 1       <NA>                       <NA>         <NA>      <NA>
## 2       <NA>                       <NA>         <NA>      <NA>
## 3  Newcastle Newcastle, New South Wales           AU Australia
##                                                                                            bounding_box_coordinates
## 1                                                                                                              <NA>
## 2                                                                                                              <NA>
## 3 151.555001504 151.824398944 151.824398944 151.555001504 -33.120457027 -33.120457027 -32.8328690325 -32.8328690325
##   bounding_box_type
## 1              <NA>
## 2              <NA>
## 3           Polygon
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
##       screen_name    user_id          created_at          status_id
## 1       garthtarr  237998293 2017-04-28 22:12:09 858081429565001729
## 2 datascienceplus 3409901933 2017-04-28 22:11:42 858081316218306561
##                                                                                                                                 text
## 1 A nice excercise for learning data science with #rstats - exploring Opal Tap on/off with time and location https://t.co/brA2lnSNam
## 2                             Introductory Data Analysis with Python https://t.co/xCkefH2ZcM #rstats #introduction #datamanipulation
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2             Google     <NA>      <NA>               <NA> <NA>
##                                    urls_display
## 1 opendata.transport.nsw.gov.au/dataset/opal-t…
## 2                              goo.gl/fb/3HjKCi
##                                                           urls_expanded
## 1 https://opendata.transport.nsw.gov.au/dataset/opal-tap-on-and-tap-off
## 2                                              https://goo.gl/fb/3HjKCi
##   mentions_screen_name mentions_user_id symbols
## 1                 <NA>             <NA>      NA
## 2                 <NA>             <NA>      NA
##                               hashtags coordinates         place_id
## 1                               rstats          NA 01cc83b303f0c068
## 2 rstats introduction datamanipulation          NA             <NA>
##   place_type place_name            place_full_name country_code   country
## 1       city  Newcastle Newcastle, New South Wales           AU Australia
## 2       <NA>       <NA>                       <NA>         <NA>      <NA>
##                                                                                            bounding_box_coordinates
## 1 151.555001504 151.824398944 151.824398944 151.555001504 -33.120457027 -33.120457027 -32.8328690325 -32.8328690325
## 2                                                                                                              <NA>
##   bounding_box_type
## 1           Polygon
## 2              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names - top 6 
head(rstats_tweets$screen_name)
## [1] "garthtarr"       "datascienceplus" "lingtax"         "timelyportfolio"
## [5] "rweekly_live"    "jhollist"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "garthtarr"       "datascienceplus" "lingtax"        
##   [4] "timelyportfolio" "rweekly_live"    "jhollist"       
##   [7] "DeborahTannon"   "MDFBasha"        "RStudioJoe"     
##  [10] "mattmayo13"      "kdnuggets"       "LearnRinaDay"   
##  [13] "akoo"            "eleafeit"        "elpidiofilho"   
##  [16] "hwitteman"       "jminguezc"       "joranelias"     
##  [19] "kyle_e_walker"   "JedediahSmith"   "MaryELennon"    
##  [22] "revodavid"       "dataandme"       "msarsar"        
##  [25] "richatmango"     "rcatlord"        "appupio"        
##  [28] "AlexCEngler"     "KatheMathBio"    "MikeTreglia"    
##  [31] "bhaskar_vk"      "jonny_polonsky"  "Rbloggers"      
##  [34] "cloudyRproject"  "f_dion"          "ArieSpirgel"    
##  [37] "davidejansen"    "mikenewkirk"     "AnalyticsVidhya"
##  [40] "LeBow"           "buriedinfo"      "dweitzel"       
##  [43] "datalies"        "thinkR_fr"       "axiomsofxyz"    
##  [46] "AbsLawson"       "old_man_chester" "nitingupta2"    
##  [49] "pdxrlang"        "sckottie"        "fragrack"       
##  [52] "riverpeek"       "wabarree"        "jtrnyc"         
##  [55] "wareFLO"         "alice_data"      "jarvmiller"     
##  [58] "hlynur"          "inesgn"          "v_vashishta"    
##  [61] "rstudiotips"     "TransmitScience" "RLadiesGlobal"  
##  [64] "PhilRack"        "nc233"           "fe_gro"         
##  [67] "GeroElGranGero"  "StatHorizons"    "MangoTheCat"    
##  [70] "F1000"           "earlconf"        "mdsumner"       
##  [73] "axelrod_eric"    "digr_io"         "banedata"       
##  [76] "jletteboer"      "ImDataScientist" "ThomasMailund"  
##  [79] "avidalvi"        "Rexercises"      "ExploratoryData"
##  [82] "RLangTip"        "lemur78"         "fhi360research" 
##  [85] "DD_Serena_"      "cjlortie"        "jeroenhjanssens"
##  [88] "zevross"         "christi19962006" "techXhum"       
##  [91] "pol_ferrando"    "CRANberriesFeed" "moroam"         
##  [94] "flexiodata"      "r_senninger"     "graemeleehickey"
##  [97] "beeonaposy"      "AyRenay"         "abresler"       
## [100] "yodacomplex"     "CoreySparks1"    "timknut"        
## [103] "emilynordmann"   "NickFoxQRPs"     "_ms03"          
## [106] "ma_salmon"       "DD_FaFa_"        "jody_tubi"      
## [109] "_ColinFay"       "AGSBS43"         "westbrobby"     
## [112] "NovasTaylor"     "Benavent"        "thosjleeper"    
## [115] "medlockgreg"     "justminingdata"  "ctricot"        
## [118] "DaniRabaiotti"   "DataFlairWS"     "rabaath"        
## [121] "r4ecology"       "lifedispersing"  "_Data_Science_" 
## [124] "StuartBorrett"   "statsforbios"    "meetup_r_nantes"
## [127] "climbercarmich"  "CoderShirts"     "priyaank"       
## [130] "martinjhnhadley" "Aurelou"         "LockeData"      
## [133] "M_Gatta"         "beckerhopper"    "zx8754"         
## [136] "giacomoecce"     "andyofsmeg"      "BigDataInsights"
## [139] "d4t4v1z"         "gombang"         "lindenashcroft" 
## [142] "outilammi"       "douradobot"      "franzViz"       
## [145] "JMBecologist"    "insightlane"     "YourStatsGuru"  
## [148] "mgvolz"          "daranzolin"      "RonGuymon"      
## [151] "JuhaKarvanen"    "lucacerone"      "TheDataSciDude" 
## [154] "DailyRpackage"   "setophaga"       "mrghalib"       
## [157] "ActivevoiceSw"   "majidrusiya"     "nielsberglund"  
## [160] "zentree"         "odeleongt"       "RyanKuhnCPA"    
## [163] "MaxGhenis"       "abfleishman"     "lovetheants"    
## [166] "jkzorz"          "rlevitin"        "MKTJimmyxu"     
## [169] "GaryDower"       "WendyRijners"    "bluecology"     
## [172] "LudvigOlsen"     "JeromyAnglim"    "bobgrossman"    
## [175] "seb_renaut"      "PPUAMX"          "carian_2996"    
## [178] "marcusborba"     "cityZenflagNews" "joe_thorley"    
## [181] "tladeras"        "GeorgetownCCPE"  "PacktPub"       
## [184] "tanyacash21"     "noticiasSobreR"  "shoilipal"      
## [187] "FrankSmithXYZ"   "ChengJunWang"    "AriLamstein"    
## [190] "isomorphisms"    "Cocotross"       "RLadiesSF"      
## [193] "EricMilgram"     "d8aninja"        "drsimonj"       
## [196] "kippwjohnson"    "TEDxRioCuarto"   "nicoleebaker"   
## [199] "rOpenSci"        "cpsievert"       "drob"           
## [202] "DJPMoore"        "HBossier"        "Research_Tim"   
## [205] "andrewheiss"     "irJerad"         "pehenne"        
## [208] "horstwilmes"     "spleonard1"      "lisafederer"    
## [211] "paulonabike"     "exaptive"        "walkingrandomly"
## [214] "dmi3k"           "CyrilCR"         "AvrahamAdler"   
## [217] "contefranz"      "attractchinese"  "ErinChiou"      
## [220] "datiobd"         "Voovarb"         "monkmanmh"      
## [223] "mjcavaretta"     "hrbrmstr"        "our_codingclub" 
## [226] "PeterOliverCaya" "stevepowell99"   "tom_auer"       
## [229] "BecAndTheBrain"  "raccoonrebels"   "UrbanDemog"     
## [232] "brennanpcardiff" "BananaData"      "desertnaut"     
## [235] "aleszubajak"     "noamross"        "patternproject" 
## [238] "apodkul"         "davidmeza1"      "klmr"           
## [241] "VickiVanDamme"   "sharon000"       "SoleDeEsteban"  
## [244] "KirkDBorne"      "CollinVanBuren"  "jeremy_data"    
## [247] "beekme"          "ezbrooks"        "EamonCaddigan"  
## [250] "gp_pulipaka"     "andreas_io"      "rgaiacs"        
## [253] "Biff_Bruise"     "BobMuenchen"     "MEhrenmueller"  
## [256] "eodaGmbH"        "NPilakouta"      "PabloRMier"     
## [259] "BarkleyBG"       "claytonfinney"   "SEIO_ES"        
## [262] "mikkopiippo"     "AlexSeupt"       "celiassiu"      
## [265] "robinlovelace"   "_stephanieboyle" "schnllr"        
## [268] "massyfigini"     "DD_NaNa_"        "LuigiBiagini"   
## [271] "IainMoppett"     "jmgomez"         "neilfws"        
## [274] "jwgayler"        "DataJunkie"      "strengejacke"   
## [277] "Emil_Hvitfeldt"  "TechnologicDesk" "alspeed09"      
## [280] "eelrekab"        "vazquezbrust"    "alramadona"
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
##      user_id           name screen_name      location
## 1 4911181019 Alt-Hypothesis RStatsJason   Atlanta, GA
## 2 2167059661    Jenny Bryan  JennyBryan Vancouver, BC
##                                                                                                                                                      description
## 1 I tweet about Public Health and other things. Founder and current Chair of R User Group @CDCGov. #Rstats Instructor @EmoryRollins. Recently took up gardening.
## 2                                                                            @rstudio, humane #rstats, statistics, @ropensci, teach @STAT545, on leave from @UBC
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE             252           752           19 2016-02-15 00:48:05
## 2     FALSE            9948           519          439 2013-10-31 18:32:37
##   favourites_count utc_offset                  time_zone geo_enabled
## 1             2708     -25200 Pacific Time (US & Canada)       FALSE
## 2            17618     -25200 Pacific Time (US & Canada)        TRUE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           5402   en                FALSE         FALSE
## 2    FALSE           8343   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   F5F8FA
## 2                  FALSE                   000000
##                       profile_background_image_url
## 1                                             <NA>
## 2 http://abs.twimg.com/images/themes/theme1/bg.png
##                  profile_background_image_url_https
## 1                                              <NA>
## 2 https://abs.twimg.com/images/themes/theme1/bg.png
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 http://pbs.twimg.com/profile_images/660978605606875137/s3YrJetD_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 https://pbs.twimg.com/profile_images/660978605606875137/s3YrJetD_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 http://pbs.twimg.com/profile_images/660978605606875137/s3YrJetD_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 https://pbs.twimg.com/profile_images/660978605606875137/s3YrJetD_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             1DA1F2                       C0DEED
## 2             ABB8C2                       000000
##   profile_sidebar_fill_color profile_text_color
## 1                     DDEEF6             333333
## 2                     000000             000000
##   profile_use_background_image default_profile default_profile_image
## 1                         TRUE            TRUE                 FALSE
## 2                        FALSE           FALSE                 FALSE
##                                            profile_banner_url
## 1                                                        <NA>
## 2 https://pbs.twimg.com/profile_banners/2167059661/1442682715
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 318

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="100%" />




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
