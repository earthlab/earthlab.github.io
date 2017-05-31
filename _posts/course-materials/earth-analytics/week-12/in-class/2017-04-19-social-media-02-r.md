---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-05-12'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/use-twitter-api-r/
nav-title: 'Explore twitter data'
week: 12
course: "earth-analytics"
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





```
## Error in gzfile(file, "rb"): cannot open the connection
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
##     screen_name            user_id          created_at          status_id
## 1 ZarahPattison         1322389208 2017-05-12 20:39:15 863131479219597314
## 2     dataandme         3230388598 2017-05-12 20:38:53 863131385061670913
## 3 DeborahTannon 821976676842242050 2017-05-12 20:36:22 863130752191516674
##                                                                                                                                                  text
## 1                                                              @drmikeographer @LimnoGeek1 Any time you open R studio #rstats https://t.co/HCy6OJBZTq
## 2 V cool, @mjfrigaard! “How to explore and manipulate a dataset from the fivethirtyeight \U0001f4e6 in R” https://t.co/yzpNurgGJe @storybench #rstats
## 3                                                                     #RStats —Shiny Application Layouts Exercises (Part-7) : https://t.co/OuApiGZjZO
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             1              4           FALSE            <NA>      FALSE
## 3             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>           862752852917329921
## 2              <NA>                         <NA>
## 3              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                 1019552053                 drmikeographer   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                source           media_id
## 1 Twitter for Android 863131465860743169
## 2              Buffer               <NA>
## 3               IFTTT               <NA>
##                                                    media_url
## 1 http://pbs.twimg.com/tweet_video_thumb/C_p1fsEXgAEwZZF.jpg
## 2                                                       <NA>
## 3                                                       <NA>
##                                                    media_url_expanded urls
## 1 https://twitter.com/ZarahPattison/status/863131479219597314/photo/1 <NA>
## 2                                                                <NA> <NA>
## 3                                                                <NA> <NA>
##      urls_display          urls_expanded      mentions_screen_name
## 1            <NA>                   <NA> drmikeographer LimnoGeek1
## 2 buff.ly/2raxUF3 http://buff.ly/2raxUF3     mjfrigaard storybench
## 3  ift.tt/2pGTkrj  http://ift.tt/2pGTkrj                      <NA>
##                mentions_user_id symbols hashtags coordinates place_id
## 1 1019552053 803697434094436352      NA   rstats          NA     <NA>
## 2          314845003 2866489102      NA   rstats          NA     <NA>
## 3                          <NA>      NA   RStats          NA     <NA>
##   place_type place_name place_full_name country_code country
## 1       <NA>       <NA>            <NA>         <NA>    <NA>
## 2       <NA>       <NA>            <NA>         <NA>    <NA>
## 3       <NA>       <NA>            <NA>         <NA>    <NA>
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
# view top 2 rows of data
head(rstats_tweets, n=2)
##     screen_name    user_id          created_at          status_id
## 1 ZarahPattison 1322389208 2017-05-12 20:39:15 863131479219597314
## 2     dataandme 3230388598 2017-05-12 20:38:53 863131385061670913
##                                                                                                                                                  text
## 1                                                              @drmikeographer @LimnoGeek1 Any time you open R studio #rstats https://t.co/HCy6OJBZTq
## 2 V cool, @mjfrigaard! “How to explore and manipulate a dataset from the fivethirtyeight \U0001f4e6 in R” https://t.co/yzpNurgGJe @storybench #rstats
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             1              4           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>           862752852917329921
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                 1019552053                 drmikeographer   en
## 2                       <NA>                           <NA>   en
##                source           media_id
## 1 Twitter for Android 863131465860743169
## 2              Buffer               <NA>
##                                                    media_url
## 1 http://pbs.twimg.com/tweet_video_thumb/C_p1fsEXgAEwZZF.jpg
## 2                                                       <NA>
##                                                    media_url_expanded urls
## 1 https://twitter.com/ZarahPattison/status/863131479219597314/photo/1 <NA>
## 2                                                                <NA> <NA>
##      urls_display          urls_expanded      mentions_screen_name
## 1            <NA>                   <NA> drmikeographer LimnoGeek1
## 2 buff.ly/2raxUF3 http://buff.ly/2raxUF3     mjfrigaard storybench
##                mentions_user_id symbols hashtags coordinates place_id
## 1 1019552053 803697434094436352      NA   rstats          NA     <NA>
## 2          314845003 2866489102      NA   rstats          NA     <NA>
##   place_type place_name place_full_name country_code country
## 1       <NA>       <NA>            <NA>         <NA>    <NA>
## 2       <NA>       <NA>            <NA>         <NA>    <NA>
##   bounding_box_coordinates bounding_box_type
## 1                     <NA>              <NA>
## 2                     <NA>              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "ZarahPattison"  "dataandme"      "DeborahTannon"  "DeborahTannon" 
## [5] "StatsInTheWild" "Rbloggers"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "ZarahPattison"   "dataandme"       "DeborahTannon"  
##   [4] "StatsInTheWild"  "Rbloggers"       "LottyBrand22"   
##   [7] "bio_diverse"     "d4tagirl"        "rweekly_live"   
##  [10] "groundwalkergmb" "DataCamp"        "GuillaumeLarocq"
##  [13] "ucfagls"         "colinaverill"    "pinkyprincess"  
##  [16] "revodavid"       "lam_bis"         "nielsberglund"  
##  [19] "storybench"      "jaheppler"       "maynardandking" 
##  [22] "AriLamstein"     "GreeneScientist" "EamonCaddigan"  
##  [25] "Michael_Toth"    "jknowles"        "chipoglesby"    
##  [28] "MangoTheCat"     "BoobsBumsBlog"   "YurikitoKSP"    
##  [31] "MarchiMax"       "optimlog_"       "scottistical"   
##  [34] "hrbrmstr"        "odeleongt"       "ArnoCandel"     
##  [37] "Hossein_Estiri"  "TransmitScience" "RStudioJoe"     
##  [40] "earlconf"        "rmflight"        "GeroldBaier"    
##  [43] "spatialanalysis" "RLadiesNash"     "martinjhnhadley"
##  [46] "vasantmarur"     "micro_marian"    "SeanlNguyen"    
##  [49] "jletteboer"      "dccc_phd"        "CRANberriesFeed"
##  [52] "Rexercises"      "TeebzR"          "hjpimentel"     
##  [55] "RLangTip"        "IndoorEcology"   "thinkR_fr"      
##  [58] "NESREANigeria"   "mattmayo13"      "RanaeDietzel"   
##  [61] "logtrust"        "philmikejones"   "SigNarvaez"     
##  [64] "giorapac"        "CSJCampbell"     "ActivevoiceSw"  
##  [67] "jasonjb82"       "JessieMinx"      "ExperianDataLab"
##  [70] "kyle_e_walker"   "abresler"        "RyanEs"         
##  [73] "cpjfb"           "AnalyticsVidhya" "_TeresaMK"      
##  [76] "sascha_wolfer"   "jrcajide"        "BobMuenchen"    
##  [79] "SoothCaster"     "Biff_Bruise"     "zeligproject"   
##  [82] "bashfulScripter" "ma_salmon"       "ibddoctor"      
##  [85] "lemur78"         "pablobrugarolas" "anobelodisho"   
##  [88] "Ko_Ver"          "elfloruso"       "jody_tubi"      
##  [91] "agpena_"         "wmlandau"        "DrCatherineBall"
##  [94] "ImDataScientist" "GuloThoughts"    "nacnudus"       
##  [97] "lisadebruine"    "danilobzdok"     "noticiasSobreR" 
## [100] "SSNAR17"         "CollinVanBuren"  "joedgallagher"  
## [103] "nathaneastwood_" "DrMarkDunning"   "LockeData"      
## [106] "zkajdan"         "Mooredvdcoll"    "BigDataInsights"
## [109] "Boomwool"        "MDFBasha"        "kdnuggets"      
## [112] "r4ecology"       "d4t4v1z"         "daattali"       
## [115] "boyce_kathryn"   "inesgn"          "celiassiu"      
## [118] "outilammi"       "RolandLangrock"  "africaeconomist"
## [121] "michalwrabel"    "YourStatsGuru"   "benrfitzpatrick"
## [124] "DailyRpackage"   "kwbroman"        "jessenleon"     
## [127] "neilfws"         "iamVaalPaiyan_"  "DBaker007"      
## [130] "healthandstats"  "KirkDBorne"      "hiveminer"      
## [133] "DrRhysPockett"   "JosiahParry"     "dataelixir"     
## [136] "vijayv2k"        "ricardokriebel"  "sane_panda"     
## [139] "prem_adh"        "tangming2005"    "theRcast"       
## [142] "datascienceplus" "henrikbengtsson" "datalies"       
## [145] "mdsumner"        "jfish111j"       "iprophage"      
## [148] "tteoh"           "ceptional"       "VickiVanDamme"  
## [151] "kearneymw"       "TimSalabim3"     "Diversity_Index"
## [154] "aschinchon"      "beeonaposy"      "BigDataBlender" 
## [157] "LearnRinaDay"    "datakelpie"      "eric_bickel"    
## [160] "elpidiofilho"    "alistaire"       "bhaskar_vk"     
## [163] "_mikoontz"       "DrLekkiWood"     "joachimgoedhart"
## [166] "riannone"        "davidmeza1"      "EikoFried"      
## [169] "williamsanger"   "tripartio"       "natetrek"       
## [172] "kevin_purcell"   "jebyrnes"        "cpsievert"      
## [175] "Larnsce"         "GaryDower"       "pssGuy"         
## [178] "buriedinfo"      "InfonomicsToday" "JonPuritz"      
## [181] "sckottie"        "sjackman"        "plotlygraphs"   
## [184] "josephsirosh"    "jminguezc"       "cehagmann"      
## [187] "Rzhevsky"        "DagHjermann"     "mdancho84"      
## [190] "bizScienc"       "MaarekClaire"    "n_ashutosh"     
## [193] "bjoerngruening"  "neo4j"           "cascadiarconf"  
## [196] "ExcelStrategies" "analyticbridge"  "pavanmirla"     
## [199] "DataSci_Ireland" "julian_urbano"   "EngelhardtCR"   
## [202] "yodacomplex"     "CaptCalculator"  "JakeWengroff"   
## [205] "NovasTaylor"     "EcographyJourna" "mikelove"       
## [208] "OmaymaS_"        "epb41l2"         "yanglinguist"   
## [211] "sauer_sebastian" "M_Gatta"         "lefft"          
## [214] "jtrnyc"          "TheJoeyAvraham"  "jeroen_dries"   
## [217] "mysnuggle"       "jesseberger"     "mikeleeco"      
## [220] "JeffMettel"      "dmi3k"           "Benavent"       
## [223] "egolinko"        "guangchuangyu"   "axelrod_eric"   
## [226] "digr_io"         "SpinyDag"        "PacktPub"       
## [229] "tsaari1"         "AMaxEll17"       "benmarwick"     
## [232] "JimGrange"       "klmr"            "KevinBCohen"    
## [235] "ThomasMailund"   "rushworth_a"     "Xtophe_Bontemps"
## [238] "sarah_gis"       "lapply"          "MangoMattGlover"
## [241] "SynBioAlex"      "yaminapressler"  "g_garciadonato" 
## [244] "michael_at_work" "EarthSurfS"      "_ColinFay"      
## [247] "Samosthenurus"   "edouard_lgp"     "tdawry"         
## [250] "gp_pulipaka"     "ClinicoChile"    "NotAPomegranite"
## [253] "tylerjrichards"  "emTr0"           "postoditacco"   
## [256] "Talent_metrics"  "campanell"       "cogitoergobacon"
## [259] "tjmahr"          "TimDoherty_"     "badtom"         
## [262] "PPUAMX"          "lifedispersing"  "chrishaid"      
## [265] "lisafederer"     "StefanieButland" "DataScienceCtrl"
## [268] "Aleponcem"       "Datatitian"      "TATA_BOX"       
## [271] "bioinformagic"   "RobertMylesMc"   "EssentialQuant" 
## [274] "graph_lib"       "seankross"
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
##     user_id            name screen_name       location
## 1 295344317 One R Tip a Day    RLangTip           <NA>
## 2  24228154   Hilary Parker      hspter San Francisco 
##                                                                                                                description
## 1          One tip per day M-F on the R programming language #rstats. Brought to you by the R community team at Microsoft.
## 2 Data Scientist @StitchFix, formerly @Etsy. Biostatistics PhD from Hopkins. Co-host of @NSSDeviations #rstats #rcatladies
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE           42345            11         1280 2011-05-08 20:51:40
## 2     FALSE           14033          2002          670 2009-03-13 18:59:32
##   favourites_count utc_offset                  time_zone geo_enabled
## 1                3     -25200 Pacific Time (US & Canada)       FALSE
## 2            26460     -14400 Eastern Time (US & Canada)        TRUE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           1644   en                FALSE         FALSE
## 2    FALSE          21442   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   3369B4
## 2                  FALSE                   352726
##                                                                     profile_background_image_url
## 1                                               http://abs.twimg.com/images/themes/theme1/bg.png
## 2 http://pbs.twimg.com/profile_background_images/750034226/bef865f13b9261684fd75ac9544a04ed.jpeg
##                                                                profile_background_image_url_https
## 1                                               https://abs.twimg.com/images/themes/theme1/bg.png
## 2 https://pbs.twimg.com/profile_background_images/750034226/bef865f13b9261684fd75ac9544a04ed.jpeg
##   profile_background_tile
## 1                   FALSE
## 2                    TRUE
##                                                            profile_image_url
## 1         http://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
## 2 http://pbs.twimg.com/profile_images/611535712710729728/ZrqMrN21_normal.jpg
##                                                       profile_image_url_https
## 1         https://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
## 2 https://pbs.twimg.com/profile_images/611535712710729728/ZrqMrN21_normal.jpg
##                                                          profile_image_url.1
## 1         http://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
## 2 http://pbs.twimg.com/profile_images/611535712710729728/ZrqMrN21_normal.jpg
##                                                     profile_image_url_https.1
## 1         https://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
## 2 https://pbs.twimg.com/profile_images/611535712710729728/ZrqMrN21_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             3369B4                       3369B4
## 2             D02B55                       FFFFFF
##   profile_sidebar_fill_color profile_text_color
## 1                     FFFFFF             333333
## 2                     99CC33             3E4415
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                         TRUE           FALSE                 FALSE
##                                          profile_banner_url
## 1                                                      <NA>
## 2 https://pbs.twimg.com/profile_banners/24228154/1468982290
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 311

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
