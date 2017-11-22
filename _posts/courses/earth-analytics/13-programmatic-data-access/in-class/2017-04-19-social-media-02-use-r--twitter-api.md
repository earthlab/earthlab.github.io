---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-21'
category: [courses]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/get-data-using-apis/use-twitter-api-r/
nav-title: 'Get Tweets - Twitter API'
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

{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Query the twitter RESTful API to access and import into `R` tweets that contain various text strings.
* Generate a list of users that are tweeting about a particular topic
* Use the `tidytext` package in `R` to explore and analyze word counts associated with tweets.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>


In this lesson you will explore analyzing social media data accessed from twitter,
in R. You  will use the Twitter RESTful API to access data about both twitter users
and what they are tweeting about

## Getting Started

To get started we'll need to do the following things:

1. Setup a twitter account if you don't have one already
2. Using your account, setup an application that you will use to access twitter from R
3. Download and install the `rtweet` and `tidytext` packages for R.

Once we've done these things, you are reading to begin querying Twitter's API to
see what you can learn about tweets!

## Setup Twitter App

Let's start by setting up an application in twitter that you can use to access
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

Once you have our twitter app setup, you are ready to dive into accessing tweets in R.

You  will use the `rtweet` package to do this.




```r
# load twitter library - the rtweet library is recommended now over twitteR
library(rtweet)
# plotting and pipes - tidyverse!
library(ggplot2)
library(dplyr)
# text mining library
library(tidytext)
```






The first thing that you need to setup in our code is our authentication. When
you set up your app, it provides you with 3 unique identification elements:

1. appnam
2. key
3. secret

These keys are located in your twitter app settings in the `Keys and Access
Tokens` tab. You will need to copy those into your code as i did below replacing the filler
text that I used in this lesson for the text that twitter gives you in your app.

Next, you need to pass a suite of keys to the API.


```r
# whatever name you assigned to your created app
appname <- "your-app-name"

## api key (example below is not a real key)
key <- "yourLongApiKeyHere"

## api secret (example below is not a real key)
secret <- "yourSecretKeyHere"

```

Finally, you can create a token that authenticates access to tweets!
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
# post a tweet from R
post_tweet("Look, i'm tweeting from R in my #rstats #earthanalytics class!")
## your tweet has been posted!
```

### Search twitter for tweets

Now you are ready to search twitter for recent tweets! Let's start by finding all
tweets that use the `#rstats` hashtag. Notice below you use the `rtweet::search_tweets()`
function to search. `search_tweets()` requires the following arguments:

1. **q:** the query word that you want to look for
2. **n:** the number of tweets that you want returned. You can request up to a
maximum of 18,000 tweets.

To see what other arguments you can use with this function, use the `R` help:

`?search_tweets`



```r
## search for 500 tweets using the #rstats hashtag
rstats_tweets <- search_tweets(q = "#rstats",
                               n = 500)
# view the first 3 rows of the dataframe
head(rstats_tweets, n = 3)
##     screen_name    user_id          created_at          status_id
## 1  edzerpebesma  148518970 2017-11-21 18:28:25 933039412832763904
## 2 PernilleSarup 1974945102 2017-11-21 18:28:16 933039375490932743
## 3     pievarino  325503256 2017-11-21 18:26:50 933039015481225217
##                                                                                                                                             text
## 1   RT @zevross: Advance notice for Twitter folks: We're hiring an #rstats coder with package development and Shiny app experience. Willingness…
## 2                                                       RT @noamross: It begins...again\nhttps://t.co/AM5vLz29ii #rstats https://t.co/DcgxmGEwF0
## 3 Analyse the migration of scientific researchers based on #ORCID data\nhttps://t.co/RgsOXhkm04\nMovement by continents… https://t.co/nnS5KsKcS8
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1            15              0           FALSE            <NA>       TRUE
## 2           111              0           FALSE            <NA>       TRUE
## 3             1              0           FALSE            <NA>      FALSE
##    retweet_status_id in_reply_to_status_status_id
## 1 932959799268052992                         <NA>
## 2 932788092439814145                         <NA>
## 3               <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##               source           media_id
## 1 Twitter Web Client               <NA>
## 2 Twitter Web Client 932787473897414656
## 3 Twitter Web Client               <NA>
##                                        media_url
## 1                                           <NA>
## 2 http://pbs.twimg.com/media/DPHtQ_CW4AAAlJF.jpg
## 3                                           <NA>
##                                               media_url_expanded urls
## 1                                                           <NA> <NA>
## 2 https://twitter.com/noamross/status/932788092439814145/photo/1 <NA>
## 3                                                           <NA> <NA>
##                                                         urls_display
## 1                                                               <NA>
## 2                                 noamross.github.io/data-driven-sc…
## 3 towardsdatascience.com/analyse-the-mi… twitter.com/i/web/status/9…
##                                                                                                                                     urls_expanded
## 1                                                                                                                                            <NA>
## 2                                                                                               https://noamross.github.io/data-driven-scroogery/
## 3 https://towardsdatascience.com/analyse-the-migration-of-scientific-researchers-5184a9500615 https://twitter.com/i/web/status/933039015481225217
##   mentions_screen_name mentions_user_id symbols hashtags coordinates
## 1              zevross       1909185565      NA   rstats          NA
## 2             noamross         97582853      NA   rstats          NA
## 3                 <NA>             <NA>      NA    ORCID          NA
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
followers can see it. It is similar to sharing in Facebook where you can add a
quote or text above the retweet if you want or just share the post. Let's use
the same query that you used above but this time ignore all retweets by setting
the `include_rts` argument to `FALSE`. You  can get tweet / retweet stats from
our dataframe, separately.


```r
# find recent tweets with #rstats but ignore retweets
rstats_tweets <- search_tweets("#rstats", n = 500,
                             include_rts = FALSE)
# view top 2 rows of data
head(rstats_tweets, n = 2)
##    screen_name    user_id          created_at          status_id
## 1    pievarino  325503256 2017-11-21 18:26:50 933039015481225217
## 2 pachamaltese 2300614526 2017-11-21 18:26:11 933038851437858818
##                                                                                                                                             text
## 1 Analyse the migration of scientific researchers based on #ORCID data\nhttps://t.co/RgsOXhkm04\nMovement by continents… https://t.co/nnS5KsKcS8
## 2    it'a really annoying that software by @intel does not suggest/link dependencies and that makes MKL and other tools not working D: ! #rstats
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             1              0           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                                                         urls_display
## 1 towardsdatascience.com/analyse-the-mi… twitter.com/i/web/status/9…
## 2                                                               <NA>
##                                                                                                                                     urls_expanded
## 1 https://towardsdatascience.com/analyse-the-migration-of-scientific-researchers-5184a9500615 https://twitter.com/i/web/status/933039015481225217
## 2                                                                                                                                            <NA>
##   mentions_screen_name mentions_user_id symbols hashtags coordinates
## 1                 <NA>             <NA>      NA    ORCID          NA
## 2                intel          2803191      NA   rstats          NA
##   place_id place_type place_name place_full_name country_code country
## 1     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
## 2     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
##   bounding_box_coordinates bounding_box_type
## 1                     <NA>              <NA>
## 2                     <NA>              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "pievarino"    "pachamaltese" "rOpenSci"     "sckottie"    
## [5] "DaSciDance"   "FrancoisKeck"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "pievarino"       "pachamaltese"    "rOpenSci"       
##   [4] "sckottie"        "DaSciDance"      "FrancoisKeck"   
##   [7] "ByranSmucker"    "tmllr"           "SuzanB_"        
##  [10] "ahmedjr_16"      "Rbloggers"       "dataandme"      
##  [13] "LeahAWasser"     "janeshdev"       "_neilch"        
##  [16] "sauer_sebastian" "daattali"        "AedinCulhane"   
##  [19] "BigDataInsights" "revodavid"       "l_hansa"        
##  [22] "CRANberriesFeed" "JohnBVincent"    "pdalgd"         
##  [25] "LWpaulbivand"    "RLangTip"        "Talent_metrics" 
##  [28] "jtrnyc"          "CMastication"    "rweekly_live"   
##  [31] "maximaformacion" "daniellequinn88" "rencontres_R"   
##  [34] "philsf79"        "fredpolicarpo"   "TomTraubert2009"
##  [37] "NicholasStrayer" "DarrinLRogers"   "LWylie_"        
##  [40] "thegoodphyte"    "AlissaJ_Brown"   "markvdloo"      
##  [43] "d4tagirl"        "robertstats"     "neilcharles_uk" 
##  [46] "Cruz_Julian_"    "LockeData"       "sellorm"        
##  [49] "KirkegaardEmil"  "sqlsatvienna"    "sqlpass_AT"     
##  [52] "DerFredo"        "benmarwick"      "kdnuggets"      
##  [55] "fmic_"           "gabyfarries"     "pacocuak"       
##  [58] "storybench"      "RLadiesLivUK"    "thinkR_fr"      
##  [61] "segasi"          "sthda_en"        "AnalyticsVidhya"
##  [64] "RCharlie425"     "polesasunder"    "PhilippeLucarel"
##  [67] "brodriguesco"    "MangoTheCat"     "fatma_cinar_ftm"
##  [70] "NumFOCUS"        "Disha_SH_"       "ingorohlfing"   
##  [73] "SwampThingPaul"  "ctokelly"        "timelyportfolio"
##  [76] "ImDataScientist" "bkkkk"           "jati33o"        
##  [79] "marinereilly"    "thosjleeper"     "zevross"        
##  [82] "v_vashishta"     "Megannzhang"     "TeebzR"         
##  [85] "drob"            "LilithElina"     "karstetter"     
##  [88] "armaninspace"    "murnane"         "Nujcharee"      
##  [91] "CardiffRUG"      "scac1041"        "gorkemmeral"    
##  [94] "tvganesh_85"     "romain_francois" "recleev"        
##  [97] "thonoir"         "wb_research"     "sinibara"       
## [100] "WarwickRUG"      "chainsawriot"    "danielequs"     
## [103] "tapundemek"      "SynBioAlex"      "vickythegme"    
## [106] "schnllr"         "DrNatalieKelly"  "expersso"       
## [109] "neilfws"         "MGCodesandStats" "jessenleon"     
## [112] "joejps84"        "petermacp"       "thomasp85"      
## [115] "manugrapevine"   "zx8754"          "HollyKirk"      
## [118] "statistik_zh"    "MorrisonLisbeth" "DiegoKuonen"    
## [121] "AsmusOlsen"      "SteffenBank"     "_arnaudr"       
## [124] "climbertobby"    "DynamicWebPaige" "fmarin_ES"      
## [127] "Red_Global"      "mmznr"           "gombang"        
## [130] "satyakamrai"     "Rexercises"      "jdatap"         
## [133] "Nico_Younes"     "ace_ebert"       "michael_chirico"
## [136] "samclifford"     "g_inberg"        "alexwhan"       
## [139] "SeemaSheth"      "Ozan_Harman"     "jclopeztavera"  
## [142] "lobrowR"         "Edwards_evoeco"  "dd_rookie"      
## [145] "TimDoherty_"     "apreshill"       "ThomasSpeidel"  
## [148] "zentree"         "DavidJohnGibson" "aggieerin"      
## [151] "JLucibello"      "nicobaguio"      "Displayrr"      
## [154] "kwinkunks"       "noamross"        "AndyDeines"     
## [157] "DapperStats"     "LjStatEst"       "tjmahr"         
## [160] "TermehKousha"    "PWaryszak"       "_ColinFay"      
## [163] "peekabooworld"   "erictleung"      "healthandstats" 
## [166] "colbycosh"       "jacquiemills_"   "mroutley"       
## [169] "bobehayes"       "jmtroos"         "joranelias"     
## [172] "sehosking"       "_mikoontz"       "tipsder"        
## [175] "elpidiofilho"    "cantabile"       "jasdumas"       
## [178] "gregrs_uk"       "rmflight"        "TylerSaville"   
## [181] "aschinchon"      "AmirSariaslan"   "RLadiesMunich"  
## [184] "stephhazlitt"    "lisafederer"     "rutgersdh"      
## [187] "RanaeDietzel"    "SachaEpskamp"    "sebredhh"       
## [190] "CougRstats"      "SimonKassel"     "LauraBlissEco"  
## [193] "pssGuy"          "AlexaLFH"        "JidduAlexander" 
## [196] "aliraiser"       "danilofreire"    "peterdalle"     
## [199] "harcun21"        "MartJ42"         "wouldeye125"    
## [202] "gregfreedman"    "gvegayon"        "AriLamstein"    
## [205] "LearningPlaces"  "rstatsdata"      "SteffLocke"     
## [208] "PredaGabi"       "Jemus42"         "chrglez"        
## [211] "tonmcg"          "UChicagoCAPP"    "longhowlam"     
## [214] "globalizefm"     "InfonomicsToday" "lksmth"         
## [217] "MafaldaSViana"   "SamAllocate"     "infotroph"      
## [220] "n_ashutosh"      "hrbrmstr"        "BrodieGaslam"   
## [223] "FoxandtheFlu"    "bencapistrant"   "SEMDocs"        
## [226] "RLadiesGlobal"   "jknowles"        "jude_c"         
## [229] "joshuafmask"     "datascienceplus" "m_cadek"        
## [232] "DataIns8tsCloud" "abtran"          "nerdhockeyAG"   
## [235] "rweekly_org"     "jessicakabbott"  "statsforbios"   
## [238] "jarvmiller"      "hadleywickham"   "bejcal"         
## [241] "pabloc_ds"       "DataScienceInR"  "WinVectorLLC"   
## [244] "jonmcalder"      "DRHill_PhD"      "IT_securitynews"
## [247] "askdrstats"      "Jadirectivestwt" "m_parent"       
## [250] "rmkubinec"       "rtse999"         "dragonflystats" 
## [253] "WireMonkey"      "AgentZeroNine"   "klmr"           
## [256] "hlynur"          "RosanaFerrero"   "davidengaut"    
## [259] "tweetupkzoo"     "rushworth_a"     "mdlap"          
## [262] "GarethNetto"     "jmgomez"         "Statistikaka"   
## [265] "d0choa"          "geodatascience"  "unsorsodicorda" 
## [268] "drewvid"         "LynxPro_UK"      "adamhsparks"    
## [271] "duc_qn"          "napbot"          "joethedataguy"
```

You  can similarly use the `search_users()` function to just see what users are tweeting
using a particular hashtag. This function returns just a data.frame of the users
and information about their accounts.


```r
# what users are tweeting with #rstats
users <- search_users("#rstats",
                      n = 500)
# just view the first 2 users - the data frame is large!
head(users, n = 2)
##      user_id         name screen_name        location
## 1 3230388598 Mara Averick   dataandme   Massachusetts
## 2  111093392       Hao Ye   Hao_and_Y Gainesville, FL
##                                                                                                                                                                                                description
## 1 tidyverse dev advocate @rstudio\n\n#rstats, #datanerd, #civictech \U0001f496er, \U0001f3c0 stats junkie, using #data4good (&or \U0001f947 fantasy sports), lesser ½ of @batpigandme \U0001f987\U0001f43d
## 2                                                 Postdoc @UF/@Weecology (ecosystem temporal dynamics); builds models in #Rstats & #LEGO; @MozOpenLeaders alum; he/him; You can't spell chaos w/out 'hao'.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE           17839          2952         1122 2015-05-03 11:44:15
## 2     FALSE             776           966           43 2010-02-03 20:00:43
##   favourites_count utc_offset                  time_zone geo_enabled
## 1            54417     -18000 Eastern Time (US & Canada)       FALSE
## 2            11020     -28800 Pacific Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE          21633   en                FALSE         FALSE
## 2    FALSE           7562   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   000000
## 2                  FALSE                   000000
##                       profile_background_image_url
## 1 http://abs.twimg.com/images/themes/theme1/bg.png
## 2 http://abs.twimg.com/images/themes/theme1/bg.png
##                  profile_background_image_url_https
## 1 https://abs.twimg.com/images/themes/theme1/bg.png
## 2 https://abs.twimg.com/images/themes/theme1/bg.png
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 http://pbs.twimg.com/profile_images/771375747214684161/Lg3U4IXS_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 https://pbs.twimg.com/profile_images/771375747214684161/Lg3U4IXS_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 http://pbs.twimg.com/profile_images/771375747214684161/Lg3U4IXS_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 https://pbs.twimg.com/profile_images/771375747214684161/Lg3U4IXS_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             1B95E0                       000000
## 2             ABB8C2                       000000
##   profile_sidebar_fill_color profile_text_color
## 1                     000000             000000
## 2                     000000             000000
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                        FALSE           FALSE                 FALSE
##                                            profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/3230388598/1482490217
## 2  https://pbs.twimg.com/profile_banners/111093392/1477467490
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 320

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x = "Count",
      y = "Location",
      title = "Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r--twitter-api/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="90%" />

Let's sort by count and just plot the top locations. To do this you use top_n().
Note that in this case you are grouping our data by user. Thus top_n() will return
locations with atleast 15 users associated with it.


```r
users %>%
  count(location, sort = TRUE) %>%
  mutate(location = reorder(location, n)) %>%
  top_n(20) %>%
  ggplot(aes(x = location, y = n)) +
  geom_col() +
  coord_flip() +
      labs(x = "Count",
      y = "Location",
      title = "Where Twitter users are from - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r--twitter-api/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="90%" />

It looks like you have some `NA` or no data values in our list. Let's remove those
with `na.omit()`.


```r
users %>%
  count(location, sort = TRUE) %>%
  mutate(location= reorder(location,n)) %>%
  na.omit() %>%
  top_n(20) %>%
  ggplot(aes(x = location,y = n)) +
  geom_col() +
  coord_flip() +
      labs(x = "Location",
      y = "Count",
      title = "Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r--twitter-api/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="90%" />

Looking at our data, what do you notice that might improve this plot?
There are 314 unique locations in our list. However, everyone didn't specify their
locations using the approach. For example some just identified their country:
United States for example and others specified a city and state. You  may want to
do some cleaning of these data to be able to better plot this distribution - especially
if you want to create a map of these data!

### Users by time zone

Lets have a look at the time zone field next.




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Use the example above, plot users by time zone. List time zones that have atleast
20 users associated with them. What do you notice about the data?
</div>

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r--twitter-api/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="90%" />

The plots above aren't perfect. What do you start to notice about working
with these data? Can you simply download them and plot the data?

## Data munging  101

When you work with data from sources like NASA, USGS, etc there are particular
cleaning steps that you often need to do. For instance:

* you may need to remove nodata values
* you may need to scale the data
* and others

In the next lesson you will dive deeper into the art of "text-mining" to extract
information about a particular topic from twitter.


<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://tidytextmining.com/" target="_blank">Tidy text mining online book</a>
* <a href="https://mkearney.github.io/rtweet/articles/intro.html#retrieving-trends" target="_blank">A great overview of the rtweet package by Mike Kearny</a>
* <a href="https://francoismichonneau.net/2017/04/tidytext-origins-of-species/" target="_blank">A blog post on tidytext by Francois Michonneau</a>
*  <a href="https://blog.twitter.com/2008/what-does-rate-limit-exceeded-mean-updated" target="_blank">About the twitter API rate limit</a>

</div>
