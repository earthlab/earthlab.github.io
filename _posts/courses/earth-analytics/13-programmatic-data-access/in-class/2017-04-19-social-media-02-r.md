---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-15'
category: [courses]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/get-data-using-apis/use-twitter-api-r/
nav-title: 'Explore twitter data'
week: 13
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
redirect_from:
   - "/course-materials/earth-analytics/week-12/use-twitter-api-r/"
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
## Error in structure(list(appname = appname, secret = secret, key = key, : object 'appname' not found
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
##      screen_name            user_id          created_at          status_id
## 1   ZoltanSzuhai 727819240489799681 2017-11-15 20:47:16 930900028868186112
## 2   ZoltanSzuhai 727819240489799681 2017-11-15 20:47:04 930899976741359616
## 3 Roisin_White__         2905132587 2017-11-15 20:45:37 930899613741191168
##                                                                                                                                           text
## 1                                                RT @Rbloggers: How to plot basic maps with ggmap https://t.co/J9c7sfK7jH #rstats #DataScience
## 2                                                 RT @Rbloggers: Mapping data using R and leaflet https://t.co/BZWlJj5jUD #rstats #DataScience
## 3 In today's We R meeting, we have Christian Lopez from the dept. of industrial engineering back to give us a tutoria… https://t.co/BwwOzvxlf8
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1            58              0           FALSE            <NA>       TRUE
## 2            45              0           FALSE            <NA>       TRUE
## 3             0              0           FALSE            <NA>      FALSE
##    retweet_status_id in_reply_to_status_status_id
## 1 930684293583724545                         <NA>
## 2 930605002703429632                         <NA>
## 3               <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 2 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 3 Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                  urls_display
## 1             wp.me/pMm6L-EKR
## 2             wp.me/pMm6L-EKN
## 3 twitter.com/i/web/status/9…
##                                         urls_expanded mentions_screen_name
## 1                             https://wp.me/pMm6L-EKR            Rbloggers
## 2                             https://wp.me/pMm6L-EKN            Rbloggers
## 3 https://twitter.com/i/web/status/930899613741191168                 <NA>
##   mentions_user_id symbols           hashtags coordinates place_id
## 1        144592995      NA rstats DataScience          NA     <NA>
## 2        144592995      NA rstats DataScience          NA     <NA>
## 3             <NA>      NA               <NA>          NA     <NA>
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
##      screen_name    user_id          created_at          status_id
## 1 Roisin_White__ 2905132587 2017-11-15 20:45:37 930899613741191168
## 2        eldenvo  296545428 2017-11-15 20:43:44 930899136483876870
##                                                                                                                                           text
## 1 In today's We R meeting, we have Christian Lopez from the dept. of industrial engineering back to give us a tutoria… https://t.co/BwwOzvxlf8
## 2               @RLadiesGlobal @drob not even a data scientist but started an #rstats based blog to put some things on https://t.co/7KdST3wgD3
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>           930494182027923457
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2         770490229769789440                  RLadiesGlobal   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                                 urls_display
## 1                twitter.com/i/web/status/9…
## 2 lookatthhedata.netlify.com/2017-11-12-map…
##                                                                                                          urls_expanded
## 1                                                                  https://twitter.com/i/web/status/930899613741191168
## 2 https://lookatthhedata.netlify.com/2017-11-12-mapping-your-oyster-card-journeys-in-london-with-tidygraph-and-ggraph/
##   mentions_screen_name            mentions_user_id symbols hashtags
## 1                 <NA>                        <NA>      NA     <NA>
## 2   RLadiesGlobal drob 770490229769789440 46245868      NA   rstats
##   coordinates place_id place_type place_name place_full_name country_code
## 1          NA     <NA>       <NA>       <NA>            <NA>         <NA>
## 2          NA     <NA>       <NA>       <NA>            <NA>         <NA>
##   country bounding_box_coordinates bounding_box_type
## 1    <NA>                     <NA>              <NA>
## 2    <NA>                     <NA>              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "Roisin_White__" "eldenvo"        "gatesdupont"    "TheAtavism"    
## [5] "LeahAWasser"    "l_hansa"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "Roisin_White__"  "eldenvo"         "gatesdupont"    
##   [4] "TheAtavism"      "LeahAWasser"     "l_hansa"        
##   [7] "rstudiotips"     "d4tagirl"        "benRick3"       
##  [10] "aschinchon"      "GJanssenswillen" "Cruz_Julian_"   
##  [13] "LucyStats"       "jessenleon"      "RobertMitchellV"
##  [16] "zentree"         "lisafederer"     "dataandme"      
##  [19] "jstevens112358"  "sauer_sebastian" "_ColinFay"      
##  [22] "anthonytowry"    "ProwessConsult"  "RStudioJoe"     
##  [25] "rweekly_live"    "ngil92"          "IstvanHajnal"   
##  [28] "rstatsdata"      "pabloc_ds"       "cjlortie"       
##  [31] "jebyrnes"        "ipnosimmia"      "birderboone"    
##  [34] "DerFredo"        "sampyxis"        "GabyEclissi"    
##  [37] "Rbloggers"       "mianromu"        "ExcelStrategies"
##  [40] "Md_Harris"       "OshnGirl"        "GioraSimchoni"  
##  [43] "britten_bryan"   "arbrace"         "maximaformacion"
##  [46] "edinb_r"         "MTHallworth"     "ludmila_janda"  
##  [49] "joshmccrain"     "kelbel314"       "StefanieButland"
##  [52] "HenrikSingmann"  "RLadiesMVD"      "RLadiesAustin"  
##  [55] "tomsgoms"        "drob"            "hrbrmstr"       
##  [58] "CRANberriesFeed" "reinforcelabtwt" "AnalyticsVidhya"
##  [61] "PacktPub"        "RLangTip"        "DrGMerchant"    
##  [64] "jH_wisc"         "JLaData"         "noamross"       
##  [67] "daroczig"        "chefpikpik"      "FanninQED"      
##  [70] "TinaACormier"    "worldbankdata"   "setophaga"      
##  [73] "bfgray3"         "daattali"        "Josh_Ebner"     
##  [76] "DataCamp"        "tonmcg"          "jasonrdalton"   
##  [79] "Unsichtbarer"    "Stephen8Vickers" "statsforbios"   
##  [82] "TrestleJeff"     "SteffLocke"      "robinson_es"    
##  [85] "N_Rudolfson"     "RLadiesMAD"      "jim_vine"       
##  [88] "wytham88"        "thomasp85"       "jhollist"       
##  [91] "r_metalheads"    "Mooniac"         "rick_pack2"     
##  [94] "_paulineia"      "hadleywickham"   "Jemus42"        
##  [97] "lpreding"        "traffordDataLab" "ma_salmon"      
## [100] "Pilarhrod"       "Stat_Ron"        "d8aninja"       
## [103] "salankia"        "zevross"         "PlantPathSecret"
## [106] "SachaEpskamp"    "berdaniera"      "brenborbon"     
## [109] "gdbassett"       "thinkR_fr"       "statsepi"       
## [112] "tspreckelsen"    "Ananna16"        "berkorbay"      
## [115] "antuki13"        "Cole_Kev"        "akastrin"       
## [118] "lakshmineelk"    "coolbutuseless"  "frod_san"       
## [121] "MangoTheCat"     "DavidZumbach"    "dalejbarr"      
## [124] "neotomadb"       "danielerotolo"   "hfmuehleisen"   
## [127] "macrovogel"      "EikoFried"       "lowdecarie"     
## [130] "gpavolini"       "HadiEOind"       "wojteksupko"    
## [133] "wolfgangkhuber"  "CardiffRUG"      "LockeData"      
## [136] "Rexercises"      "sannemenning"    "_neilch"        
## [139] "Bluczkfox"       "schubtom"        "zanols"         
## [142] "wixotgames"      "MaryELennon"     "twentestat"     
## [145] "kamal_hothi"     "buidiengiau"     "jody_tubi"      
## [148] "Petzoldt"        "BrigitteColin75" "v_vashishta"    
## [151] "WesleyPasfield"  "gztstatistics"   "eric_bickel"    
## [154] "rensa_co"        "TorridZone"      "dabernathy"     
## [157] "MarshMicrobe"    "JasonAizkalns"   "tetsuroito"     
## [160] "uncmbbtrivia"    "synaptogenesis_" "alexpghayes"    
## [163] "SherlockpHolmes" "bmzzcc"          "STEMxicanEd"    
## [166] "yutannihilation" "nyhackr"         "alicesweeting"  
## [169] "RLadiesGlobal"   "markvdloo"       "lenkiefer"      
## [172] "PaulMinda1"      "madforsharks"    "_StuartLee"     
## [175] "JLucibello"      "tonyfischetti"   "juliasilge"     
## [178] "n_ashutosh"      "jeffreyhorner"   "data_lulz"      
## [181] "gelliottmorris"  "CougRstats"      "aggieerin"      
## [184] "olyerickson"     "matteodefelice"  "jaredlander"    
## [187] "jasonbaik94"     "tipsder"         "_AntoineB"      
## [190] "imtaraas"        "joranelias"      "statstools"     
## [193] "DamonCrockett"   "Hao_and_Y"       "JENewmiller"    
## [196] "Physical_Prep"   "brodriguesco"    "neilfws"        
## [199] "camhouser"       "jacquietran"     "ByJohnRRoby"    
## [202] "R_by_Ryo"        "eliaseythorsson" "emilybartha"    
## [205] "sckottie"        "micro_marian"    "kdnuggets"      
## [208] "gvegayon"        "alinexss"        "AgentZeroNine"  
## [211] "jimduquettesuck" "RLadiesTucson"   "danilobzdok"    
## [214] "verajosemanuel"  "AriLamstein"     "gmbeisbol"      
## [217] "zx8754"          "Kwarizmi"        "TimSalabim3"    
## [220] "KirkegaardEmil"  "GioCirco"        "dccc_phd"       
## [223] "awhstin"         "DanielCanueto"   "armaninspace"   
## [226] "BigDataInsights" "RichieEvPsych"   "mccallrogers"   
## [229] "_stephanieboyle" "CurtKarboski"    "thanhtungmilan" 
## [232] "Gaming_Dude"     "TheRealEveret"   "presidual"      
## [235] "monkmanmh"       "d4t4v1z"         "ijlyttle"       
## [238] "andrewheiss"     "just_add_data"   "denishaine"     
## [241] "padpadpadpad"    "dirk_sch"        "nierhoff"       
## [244] "beeonaposy"      "martinjhnhadley" "jrcajide"       
## [247] "timelyportfolio" "ParallelRecruit" "BenBondLamberty"
## [250] "RosanaFerrero"   "jent103"         "kaelen_medeiros"
## [253] "VRaoRao"         "sthda_en"        "pacocuak"       
## [256] "dustintingley"   "NumFOCUS"        "ameisen_strasse"
## [259] "InakiHdez"       "jsbreker"        "benrfitzpatrick"
## [262] "BrockTibert"     "dnietolugilde"   "AKitsche"       
## [265] "jamesfeigenbaum" "R_Forwards"      "ezbrooks"       
## [268] "FinanzasZone"    "seandavis12"     "meetup_r_nantes"
## [271] "meisshaily"      "gauravjain49"    "MattOldach"     
## [274] "kklmmr"          "BlasBenito"      "Tjido"          
## [277] "RLadiesLivUK"    "rforjournalists" "janschulz"      
## [280] "mdsumner"        "jgendrinal"      "VincentBroute"  
## [283] "EddieICook"      "oaggimenez"      "duc_qn"
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
##     user_id            name screen_name             location
## 1   5685812       boB Rudis    hrbrmstr Underground Cell #34
## 2 295344317 One R Tip a Day    RLangTip                 <NA>
##                                                                                                                                                             description
## 1 Don't look at me…I do what he does—just slower. #rstats avuncular • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
## 2                                                       One tip per day M-F on the R programming language #rstats. Brought to you by the R community team at Microsoft.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE            8875           396          601 2007-05-01 14:04:24
## 2     FALSE           47306            11         1346 2011-05-08 20:51:40
##   favourites_count utc_offset                  time_zone geo_enabled
## 1            10506     -18000 Eastern Time (US & Canada)       FALSE
## 2                3     -28800 Pacific Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1     TRUE          69780   en                FALSE         FALSE
## 2    FALSE           1772   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   022330
## 2                  FALSE                   3369B4
##                                                     profile_background_image_url
## 1 http://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
## 2                               http://abs.twimg.com/images/themes/theme1/bg.png
##                                                profile_background_image_url_https
## 1 https://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
## 2                               https://abs.twimg.com/images/themes/theme1/bg.png
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2         http://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2         https://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2         http://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2         https://pbs.twimg.com/profile_images/1344530309/RLangTip_normal.png
##   profile_link_color profile_sidebar_border_color
## 1             94BD5A                       FFFFFF
## 2             3369B4                       3369B4
##   profile_sidebar_fill_color profile_text_color
## 1                     C0DFEC             333333
## 2                     FFFFFF             333333
##   profile_use_background_image default_profile default_profile_image
## 1                         TRUE           FALSE                 FALSE
## 2                        FALSE           FALSE                 FALSE
##                                         profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/5685812/1398248552
## 2                                                     <NA>
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 321

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")
## Error in get(Info[i, 1], envir = env): lazy-load database '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/ggplot2/R/ggplot2.rdb' is corrupt
```

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
## Error in get(Info[i, 1], envir = env): lazy-load database '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/ggplot2/R/ggplot2.rdb' is corrupt
```

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
## Error in get(Info[i, 1], envir = env): lazy-load database '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/ggplot2/R/ggplot2.rdb' is corrupt
```

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


```
## Error in get(Info[i, 1], envir = env): lazy-load database '/Library/Frameworks/R.framework/Versions/3.4/Resources/library/ggplot2/R/ggplot2.rdb' is corrupt
```




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
