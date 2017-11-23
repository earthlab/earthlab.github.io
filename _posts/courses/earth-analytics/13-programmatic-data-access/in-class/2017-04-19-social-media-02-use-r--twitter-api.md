---
layout: single
title: "Twitter Data in R: Analyze and Download Twitter Data"
excerpt: "You can use the Twitter RESTful API to access data about Twitter users and topics. Learn how to analyze social media content using Twitter data in R."
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-23'
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
  find-and-manage-data: ['apis', 'find-data']
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
##   screen_name            user_id          created_at          status_id
## 1 freestatman          278849221 2017-11-23 15:56:31 933725961778024449
## 2   MorphoFun         2699223822 2017-11-23 15:54:38 933725487444017153
## 3    jweisber 817023195823935488 2017-11-23 15:54:18 933725402622840832
##                                                                                                                                                text
## 1 RT @dataandme: This #ggplot \U0001f983 turkey did not fare well…\n"Happy Thanks-ggiving"\nhttps://t.co/7ulPwkiSU8 #rstats https://t.co/fTS2R4Qy06
## 2 RT @dataandme: This #ggplot \U0001f983 turkey did not fare well…\n"Happy Thanks-ggiving"\nhttps://t.co/7ulPwkiSU8 #rstats https://t.co/fTS2R4Qy06
## 3 RT @dataandme: This #ggplot \U0001f983 turkey did not fare well…\n"Happy Thanks-ggiving"\nhttps://t.co/7ulPwkiSU8 #rstats https://t.co/fTS2R4Qy06
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             9              0           FALSE            <NA>       TRUE
## 2             9              0           FALSE            <NA>       TRUE
## 3             9              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1 933705810840031232                         <NA>
## 2 933705810840031232                         <NA>
## 3 933705810840031232                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                source           media_id
## 1 Twitter for Android 933705808281526272
## 2 Twitter for Android 933705808281526272
## 3  Twitter Web Client 933705808281526272
##                                        media_url
## 1 http://pbs.twimg.com/media/DPUwfFNW4AAImC2.jpg
## 2 http://pbs.twimg.com/media/DPUwfFNW4AAImC2.jpg
## 3 http://pbs.twimg.com/media/DPUwfFNW4AAImC2.jpg
##                                                media_url_expanded urls
## 1 https://twitter.com/dataandme/status/933705810840031232/photo/1 <NA>
## 2 https://twitter.com/dataandme/status/933705810840031232/photo/1 <NA>
## 3 https://twitter.com/dataandme/status/933705810840031232/photo/1 <NA>
##      urls_display           urls_expanded mentions_screen_name
## 1 buff.ly/2B5Ar7v https://buff.ly/2B5Ar7v            dataandme
## 2 buff.ly/2B5Ar7v https://buff.ly/2B5Ar7v            dataandme
## 3 buff.ly/2B5Ar7v https://buff.ly/2B5Ar7v            dataandme
##   mentions_user_id symbols      hashtags coordinates place_id place_type
## 1       3230388598      NA ggplot rstats          NA     <NA>       <NA>
## 2       3230388598      NA ggplot rstats          NA     <NA>       <NA>
## 3       3230388598      NA ggplot rstats          NA     <NA>       <NA>
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
##   screen_name    user_id          created_at          status_id
## 1  ahmedjr_16 3145295054 2017-11-23 15:44:31 933722939261837313
## 2 gp_pulipaka 4263007693 2017-11-23 15:26:03 933718294527447042
##                                                                                                                                              text
## 1 11 Best #BigData Courses for #DataScientists \n\nhttps://t.co/yClYWc2MfC  \n\n#AI #ArtificialIntelligence #DataScience… https://t.co/BAg5k0JXUT
## 2    A Comprehensive 264 Page Book - #DataMining for the Masses, Second Edition: with Implementations in #RapidMiner and… https://t.co/1JaxYQymPh
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             2              0           FALSE            <NA>      FALSE
## 2             6              4           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##                source media_id media_url media_url_expanded urls
## 1 Twitter for Android     <NA>      <NA>               <NA> <NA>
## 2              Buffer     <NA>      <NA>               <NA> <NA>
##                                urls_display
## 1 goo.gl/d1lznz twitter.com/i/web/status/9…
## 2               twitter.com/i/web/status/9…
##                                                               urls_expanded
## 1 https://goo.gl/d1lznz https://twitter.com/i/web/status/933722939261837313
## 2                       https://twitter.com/i/web/status/933718294527447042
##   mentions_screen_name mentions_user_id symbols
## 1                 <NA>             <NA>      NA
## 2                 <NA>             <NA>      NA
##                                                       hashtags coordinates
## 1 BigData DataScientists AI ArtificialIntelligence DataScience          NA
## 2                                        DataMining RapidMiner          NA
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
## [1] "ahmedjr_16"    "gp_pulipaka"   "jimmuta"       "AmirSariaslan"
## [5] "edzerpebesma"  "geospacedman"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "ahmedjr_16"      "gp_pulipaka"     "jimmuta"        
##   [4] "AmirSariaslan"   "edzerpebesma"    "geospacedman"   
##   [7] "AlexaLFH"        "thonoir"         "CRANberriesFeed"
##  [10] "dataandme"       "Rbloggers"       "datascienceplus"
##  [13] "bizScienc"       "dougashton"      "axelrod_eric"   
##  [16] "digr_io"         "thinkR_fr"       "ingorohlfing"   
##  [19] "mudwaterclimate" "EnriqueOnieva"   "mauro_lepore"   
##  [22] "sauer_sebastian" "UrbanDemog"      "StephAdams_EDI" 
##  [25] "jstovold"        "TeaStats"        "Cruz_Julian_"   
##  [28] "noticiasSobreR"  "lucazav"         "MangoTheCat"    
##  [31] "rforjournalists" "recleev"         "_ColinFay"      
##  [34] "chainsawriot"    "chibisi"         "milos_agathon"  
##  [37] "scm_marcus"      "RaoOfPhysics"    "CardiffRUG"     
##  [40] "simon_tarr"      "andrzejkoles"    "dataknut"       
##  [43] "DrT_Roa"         "eilis_hannon"    "lemur78"        
##  [46] "stulacy"         "madforsharks"    "_erikaroper"    
##  [49] "aksingh1985"     "ClausWilke"      "lucyleeow"      
##  [52] "neilfws"         "AmeliaMN"        "JennyBryan"     
##  [55] "rensa_co"        "RyanEs"          "rahulxc"        
##  [58] "DerFredo"        "CFHammill"       "ActivevoiceSw"  
##  [61] "robinson_es"     "VizWorld"        "gelliottmorris" 
##  [64] "juliasilge"      "_StuartLee"      "gvegayon"       
##  [67] "PPUAMX"          "PacktDatahub"    "joranelias"     
##  [70] "caparisek"       "GrahamIMac"      "globalizefm"    
##  [73] "tylermorganwall" "tpq__"           "ellis2013nz"    
##  [76] "DapperStats"     "elpidiofilho"    "EikoFried"      
##  [79] "edrubin"         "nathanjrt"       "drob"           
##  [82] "DataSciHeroes"   "KKulma"          "aggieerin"      
##  [85] "eddelbuettel"    "RLionheart92"    "gtumuluri"      
##  [88] "bencasselman"    "carlcarrie"      "Heinonmatti"    
##  [91] "dj_shaily"       "zentree"         "aschinchon"     
##  [94] "v_vashishta"     "LearnRinaDay"    "andreasose"     
##  [97] "McDonnellJack"   "pausempere"      "AriLamstein"    
## [100] "pacocuak"        "gdbassett"       "FarRider"       
## [103] "DataCamp"        "nlmixr"          "jhnmxwll"       
## [106] "prosopis"        "extratp"         "RLadiesRio"     
## [109] "s_newns92"       "RallidaeRule"    "Elliot_Meador"  
## [112] "wmhammond"       "surlyurbanist"   "FanninQED"      
## [115] "l_hansa"         "MDubins"         "peterdalle"     
## [118] "rstatsdata"      "willems_karlijn" "brlockwood"     
## [121] "UnderGardener1"  "azadag"          "JasonAizkalns"  
## [124] "RStudioJoe"      "jhollist"        "ma_salmon"      
## [127] "dirk_sch"        "NumFOCUS"        "mjwalds"        
## [130] "lobrowR"         "Jhovde2121"      "sjackman"       
## [133] "_ms03"           "EnvReportBC"     "TheSeaNikRoute" 
## [136] "TiffanyTimbers"  "stadlmann_"      "j_garrettwalker"
## [139] "InfluxDB"        "axiomsofxyz"     "ucfagls"        
## [142] "reinforcelabtwt" "BigDataInsights" "ecojydrology"   
## [145] "Josh_Ebner"      "RLangTip"        "datavisitor"    
## [148] "MGCodesandStats" "data_cheeves"    "guangchuangyu"  
## [151] "tylerrinker"     "DataScienceInR"  "WinVectorLLC"   
## [154] "ChrisBeeley"     "henrikbengtsson" "ManuVrn"        
## [157] "RanaeDietzel"    "CharliePerretti" "AmidstScience"  
## [160] "daattali"        "tomhouslay"      "ecophiliajones" 
## [163] "AnalyticsVidhya" "romain_francois" "jason_gilby"    
## [166] "CivicAngela"     "MikeTreglia"     "mjfrigaard"     
## [169] "MartinGarlovsky" "tycbrad"         "UOLHEResearch"  
## [172] "tdoyon"          "sthda_en"        "F1000Research"  
## [175] "Emma_SXB"        "lonriesberg"     "fatma_cinar_ftm"
## [178] "sharon000"       "WhatBehaviour"   "williamsanger"  
## [181] "jtrnyc"          "Ipaneman"        "jelorias95"     
## [184] "witteveenlane"   "DataLabTR"       "seabbs"         
## [187] "londonaesthetik" "ImDataScientist" "TeebzR"         
## [190] "IronistM"        "INWT_Statistics" "lumbininep"     
## [193] "urvashidbabaria" "rachitkinger"    "synaptogenesis_"
## [196] "JamesBellOcean"  "JeromyAnglim"    "leleedavid"     
## [199] "RLadiesMAD"      "walkingrandomly" "stephanenardin" 
## [202] "robinlovelace"   "R_Graph_Gallery" "d4t4v1z"        
## [205] "pa_chevalier"    "jonmcalder"      "jessenleon"     
## [208] "G_Devailly"      "AymericBds"      "Jimby19"        
## [211] "Hao_and_Y"       "gombang"         "Torsay"         
## [214] "matrunich"       "JanMulkens"      "RLadiesGlobal"  
## [217] "michcampbell_"   "d_olivaw"        "mixtrak"        
## [220] "sfrechette"      "enpiar"          "oMarceloVentura"
## [223] "Quovantis"       "timelyportfolio" "SanaBau"        
## [226] "cityZenflagNews" "KirkDBorne"      "lilscientista"  
## [229] "hrbrmstr"        "speegled"        "meisshaily"     
## [232] "dccc_phd"        "armaninspace"    "lisafederer"    
## [235] "Edwards_evoeco"  "ToCBDornottoCBD" "DavidZumbach"   
## [238] "scottyd22"       "anqi_fu"         "stefjacinto"    
## [241] "pop_gen_JED"     "apawlows"        "bkmnpol"        
## [244] "Afro_Herper"     "TheSladeLab"     "Georgia_0102"   
## [247] "DeadTreeDude"    "spoonbill_hank"  "datacarpentry"  
## [250] "old_man_chester" "dshkol"          "tommartens68"   
## [253] "babeheim"        "realbluewagon"   "DocGallJr"      
## [256] "OilGains"        "TimothyMastny"   "dataelixir"     
## [259] "aquakora"        "gauravjain49"    "jilly_mackay"   
## [262] "NicholasStrayer" "paulapsobrino"   "ChristinZasada" 
## [265] "mikedelgado"     "DeCiccoDonk"     "jknowles"       
## [268] "cascadiarconf"   "NCrepalde"       "annraiho"       
## [271] "mysticstatistic" "sckottie"        "oaggimenez"     
## [274] "riverpeek"       "PyData"          "jrcajide"       
## [277] "mary_adwies"     "annakrystalli"   "techXhum"       
## [280] "CRP_nature"      "biolabanalytics" "pdxrlang"       
## [283] "daroczig"        "Thoughtfulnz"    "danielequs"     
## [286] "FoxandtheFlu"
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
##      user_id         name screen_name           location
## 1 3230388598 Mara Averick   dataandme      Massachusetts
## 2   13074042  Julia Silge  juliasilge Salt Lake City, UT
##                                                                                                                                                                                                description
## 1 tidyverse dev advocate @rstudio\n\n#rstats, #datanerd, #civictech \U0001f496er, \U0001f3c0 stats junkie, using #data4good (&or \U0001f947 fantasy sports), lesser ½ of @batpigandme \U0001f987\U0001f43d
## 2                                                          Data science and visualization at Stack Overflow, #rstats, author of Text Mining with R, parenthood, reading, food/wine/coffee, #NASADatanauts.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE           17864          2951         1121 2015-05-03 11:44:15
## 2     FALSE           10054           439          375 2008-02-05 00:47:07
##   favourites_count utc_offset                   time_zone geo_enabled
## 1            54647     -18000  Eastern Time (US & Canada)       FALSE
## 2            18399     -25200 Mountain Time (US & Canada)        TRUE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE          21696   en                FALSE         FALSE
## 2    FALSE          16028   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   000000
## 2                  FALSE                   B2DFDA
##                        profile_background_image_url
## 1  http://abs.twimg.com/images/themes/theme1/bg.png
## 2 http://abs.twimg.com/images/themes/theme13/bg.gif
##                   profile_background_image_url_https
## 1  https://abs.twimg.com/images/themes/theme1/bg.png
## 2 https://abs.twimg.com/images/themes/theme13/bg.gif
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 http://pbs.twimg.com/profile_images/930639796510244865/D_N-CofS_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 https://pbs.twimg.com/profile_images/930639796510244865/D_N-CofS_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 http://pbs.twimg.com/profile_images/930639796510244865/D_N-CofS_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 https://pbs.twimg.com/profile_images/930639796510244865/D_N-CofS_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             1B95E0                       000000
## 2             4A913C                       000000
##   profile_sidebar_fill_color profile_text_color
## 1                     000000             000000
## 2                     000000             000000
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                        FALSE           FALSE                 FALSE
##                                            profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/3230388598/1482490217
## 2   https://pbs.twimg.com/profile_banners/13074042/1511394461
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
