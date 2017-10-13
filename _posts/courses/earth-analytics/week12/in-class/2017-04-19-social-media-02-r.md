---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-10-11'
category: [courses]
class-lesson: ['social-media-r']
permalink: /courses/earth-analytics/week-12/use-twitter-api-r/
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
##     screen_name    user_id          created_at          status_id
## 1 dantonnoriega   75965553 2017-10-11 16:39:21 918154061794377734
## 2     ClearDiff 3054297324 2017-10-11 16:38:50 918153933805182978
## 3       ZKamvar 2840658614 2017-10-11 16:38:28 918153838468714496
##                                                                                                                                           text
## 1 possible to use #dplyr to create new tables server side w/o building pure sql statement? i.e. not using `collect`, `db_write_table`. #rstats
## 2    RT @cboettig: Our preprint on the https://t.co/14ItyCozH8: @Docker Containers for #rstats, is now on the @arxiv!  https://t.co/rRp8qPnRN5
## 3 RT @TeebzR: We may get 2y funding on #rstats pkg dev with #RECONepi (London); any name to suggest? @RLadiesLondon @rOpenSci @RStatsJobs @da…
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             2              0           FALSE            <NA>       TRUE
## 3             1              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1               <NA>                         <NA>
## 2 918153176779333632                         <NA>
## 3 918152292125245445                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 3          TweetDeck     <NA>      <NA>               <NA> <NA>
##                                  urls_display
## 1                                        <NA>
## 2 rocker-project.org arxiv.org/abs/1710.03675
## 3                                        <NA>
##                                                urls_expanded
## 1                                                       <NA>
## 2 http://rocker-project.org https://arxiv.org/abs/1710.03675
## 3                                                       <NA>
##                       mentions_screen_name
## 1                                     <NA>
## 2                    cboettig Docker arxiv
## 3 TeebzR RLadiesLondon rOpenSci RStatsJobs
##                                    mentions_user_id symbols
## 1                                              <NA>      NA
## 2           105529826 1138959692 808633423300624384      NA
## 3 1408449174 722588617231769601 342250615 273824942      NA
##          hashtags coordinates place_id place_type place_name
## 1    dplyr rstats          NA     <NA>       <NA>       <NA>
## 2          rstats          NA     <NA>       <NA>       <NA>
## 3 rstats RECONepi          NA     <NA>       <NA>       <NA>
##   place_full_name country_code country bounding_box_coordinates
## 1            <NA>         <NA>    <NA>                     <NA>
## 2            <NA>         <NA>    <NA>                     <NA>
## 3            <NA>         <NA>    <NA>                     <NA>
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
##     screen_name   user_id          created_at          status_id
## 1 dantonnoriega  75965553 2017-10-11 16:39:21 918154061794377734
## 2      cboettig 105529826 2017-10-11 16:35:50 918153176779333632
##                                                                                                                                           text
## 1 possible to use #dplyr to create new tables server side w/o building pure sql statement? i.e. not using `collect`, `db_write_table`. #rstats
## 2                  Our preprint on the https://t.co/14ItyCozH8: @Docker Containers for #rstats, is now on the @arxiv!  https://t.co/rRp8qPnRN5
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             2              2           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                                  urls_display
## 1                                        <NA>
## 2 rocker-project.org arxiv.org/abs/1710.03675
##                                                urls_expanded
## 1                                                       <NA>
## 2 http://rocker-project.org https://arxiv.org/abs/1710.03675
##   mentions_screen_name              mentions_user_id symbols     hashtags
## 1                 <NA>                          <NA>      NA dplyr rstats
## 2         Docker arxiv 1138959692 808633423300624384      NA       rstats
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
## [1] "dantonnoriega"  "cboettig"       "TeebzR"         "ucfagls"       
## [5] "ThorleyJack"    "unsorsodicorda"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "dantonnoriega"   "cboettig"        "TeebzR"         
##   [4] "ucfagls"         "ThorleyJack"     "unsorsodicorda" 
##   [7] "MaryELennon"     "BigDataInsights" "stephlabou"     
##  [10] "DrQz"            "Cruz_Julian_"    "CRANberriesFeed"
##  [13] "RLangTip"        "pdxrlang"        "sckottie"       
##  [16] "sellorm"         "darribas"        "mihobu"         
##  [19] "thinkR_fr"       "mattmayo13"      "grssnbchr"      
##  [22] "LucyStats"       "medlockgreg"     "Physical_Prep"  
##  [25] "mauro_lepore"    "massyfigini"     "lenkiefer"      
##  [28] "ThomasMailund"   "Torontosj"       "dustinkincaid"  
##  [31] "AnalyticsVidhya" "williamsanger"   "hfmuehleisen"   
##  [34] "RyanEs"          "MangoTheCat"     "bytebiscuit"    
##  [37] "kdnuggets"       "rweekly_live"    "MTHallworth"    
##  [40] "JamesGrecian"    "pteetor"         "dcaicollective" 
##  [43] "EarthLabCU"      "m_wegmann"       "RiaRGhai"       
##  [46] "botherchou"      "BC0808"          "tipsder"        
##  [49] "showmeshiny"     "Talent_metrics"  "RLadiesTbilisi" 
##  [52] "fubits"          "PaulZH"          "FrancoisKeck"   
##  [55] "datentaeterin"   "axelrod_eric"    "KKulma"         
##  [58] "LordGenome"      "JScurrell"       "d8aninja"       
##  [61] "RLadiesDublin"   "Stephen8Vickers" "CMacQuar"       
##  [64] "naasvanheerden"  "mgwhitfield"     "Displayrr"      
##  [67] "mariamedp"       "ImDataScientist" "jlmico"         
##  [70] "noticiasSobreR"  "HendirkB"        "statistik_zh"   
##  [73] "rgaiacs"         "aurelberra"      "_AntoineB"      
##  [76] "sowasser"        "toates_19"       "birdnirdfoley"  
##  [79] "AniMove"         "EBac_BI"         "RosanaFerrero"  
##  [82] "HBossier"        "drewvid"         "DerFredo"       
##  [85] "leach_jim"       "CardiffRUG"      "chainsawriot"   
##  [88] "thosjleeper"     "meisshaily"      "RezurvRide"     
##  [91] "meetup_r_nantes" "VizMonkey"       "robustgar"      
##  [94] "cloudaus"        "ZurichRUsers"    "HeathrTurnr"    
##  [97] "Rbloggers"       "AhmedMoustafa"   "_julionovoa"    
## [100] "bass_analytics"  "RLadiesAU"       "stephenaramsey" 
## [103] "CJPHD"           "KirkDBorne"      "PaulLantos"     
## [106] "OilGains"        "JGreenbrookHeld" "Sakkaden"       
## [109] "yoniceedee"      "zentree"         "kinzer_ryan"    
## [112] "benmarwick"      "vbern"           "jeff_o_hanson"  
## [115] "hearkz"          "tpq__"           "jblistman"      
## [118] "JennyBryan"      "dataandme"       "AvrahamAdler"   
## [121] "ba_davies"       "JasonWilliamsNY" "ahmed7emedan"   
## [124] "seanrife"        "jtrnyc"          "regionomics"    
## [127] "JasonAizkalns"   "TilmanSheets"    "znmeb"          
## [130] "ToxicDeal"       "rmflight"        "our_codingclub" 
## [133] "carlcarrie"      "mishafredmeyer"  "nj_tierney"     
## [136] "timabe"          "DavidJohnBaker"  "ExcelStrategies"
## [139] "carlmcqueen"     "lobrowR"         "jyazman2012"    
## [142] "TheAtavism"      "MineDogucu"      "jaminday"       
## [145] "Data_Sue_ATX"    "desertnaut"      "lifedispersing" 
## [148] "analyticbridge"  "droxburgh"       "tonmcg"         
## [151] "frod_san"        "GonzoScientist1" "revodavid"      
## [154] "RBirdPersons"    "statsforbios"    "VickySteeves"   
## [157] "katieschro8"     "MicheleTobias"   "LearnRinaDay"   
## [160] "sctyner"         "Riedelbc"        "speegled"       
## [163] "yodacomplex"     "rkahne"          "zevross"        
## [166] "ewen_"           "InsightsHound"   "joelgombin"     
## [169] "cortinah"        "daattali"        "tanyacash21"    
## [172] "EngelhardtCR"    "ShahAnalytics"   "thomasp85"      
## [175] "spsaaibi"        "superboreen"     "rstatsdata"     
## [178] "drob"            "ChrisRDunleavy"  "tom_auer"       
## [181] "nibrivia"        "gshotwell"       "beckfrydenborg" 
## [184] "APlaceforData"   "sergiouribe"     "vapetyuk"       
## [187] "genetics_blog"   "AriLamstein"     "hianalytics"    
## [190] "Georgi_Demirev"  "dickoah"         "thanhtungmilan" 
## [193] "m_ezkiel"        "seb_renaut"      "EnvReportBC"    
## [196] "mutwirimaorwe"   "schluppeck"      "markvdloo"      
## [199] "BelloPardo"      "wojteksupko"     "DrGMerchant"    
## [202] "old_man_chester" "MaxGhenis"       "lumbininep"     
## [205] "hammerheadbat"   "jrcajide"        "G_Devailly"     
## [208] "hadleywickham"   "zhao_shirley"    "hannahyan"      
## [211] "d4tagirl"        "_ColinFay"       "RConsortium"    
## [214] "pssGuy"          "segasi"          "earlconf"       
## [217] "antuki13"        "ScientistJake"   "mryap"          
## [220] "fvanrenterghem"  "KNRamesh1"       "RSButner"       
## [223] "marskar"         "southmapr"       "nacnudus"       
## [226] "FlorianZenoni"   "moorejh"         "TheRealEveret"  
## [229] "robinlovelace"   "nuance_r"        "noamross"       
## [232] "NumFOCUS"        "rhiacoon"        "mixtrak"        
## [235] "tudosgar"        "mdancho84"       "jaredlander"    
## [238] "basilesimon"     "rifcoru"         "awakenting"     
## [241] "bizScienc"       "hivemindatwork"  "fragrack"       
## [244] "mchapple"        "DrPeteWhite"     "BenBondLamberty"
## [247] "aliraiser"       "u_ribo"          "bhaskar_vk"     
## [250] "georgefirican"   "hrbrmstr"        "RLadiesGlobal"  
## [253] "eodaGmbH"        "noolpost"        "paulvanderlaken"
## [256] "RPubsHotEntry"   "kailashawati"    "PacktPub"       
## [259] "martinjhnhadley" "neilfws"         "olga_mie"       
## [262] "ioannides_alex"  "giupo"           "LilithElina"    
## [265] "rushworth_a"     "a_leininger"     "GarrettRMooney" 
## [268] "ido87"           "Sheffield_R_"    "fjnogales"      
## [271] "lenwood"         "tommartens68"    "rensa_co"       
## [274] "earino"          "ma_salmon"       "uzERP"          
## [277] "RCCUQ"           "QFAB_Bioinfo"    "mjfrigaard"     
## [280] "TheScrogster"    "JakeFishtad"     "aneil_ad"       
## [283] "gp_pulipaka"     "REALMattRichie"  "QuixoticQuant"  
## [286] "michael_chirico" "Doctor_Dick_MD"  "mycareerscore"  
## [289] "PaulieJTails"    "UrbanDemog"      "ActivevoiceSw"  
## [292] "RefaelLav"       "EricMilgram"     "dpereira14"     
## [295] "sheriferson"     "arakbar"         "salamander_gal" 
## [298] "PPUAMX"          "tjmahr"          "clarkforamerica"
## [301] "daniellequinn88" "DataSciHeroes"   "adaptive_plant" 
## [304] "pabloc_ds"       "b23kelly"        "brookLYNevery1" 
## [307] "ChristopherSkyi" "BioSciEconomist"
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
## 1     FALSE            8771           394          597 2007-05-01 14:04:24
## 2     FALSE           46381            11         1328 2011-05-08 20:51:40
##   favourites_count utc_offset                  time_zone geo_enabled
## 1            10229     -14400 Eastern Time (US & Canada)       FALSE
## 2                3     -25200 Pacific Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1     TRUE          68762   en                FALSE         FALSE
## 2    FALSE           1748   en                FALSE         FALSE
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
## [1] 324

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="90%" />




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
