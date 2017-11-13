---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-08'
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
##    screen_name   user_id          created_at          status_id
## 1 alevergara78 104520454 2017-11-08 21:21:28 928371918331351040
## 2   Fly_Agaric  37037418 2017-11-08 21:20:47 928371749242118144
## 3     gvegayon  73013091 2017-11-08 21:20:44 928371736176836608
##                                                                                                                                                      text
## 1 RT @jscarto: Frequency of scores from every #NBA\U0001f3c0 game #dataviz https://t.co/mr2ydQpIJA\n\nData + #rstats code: https://t.co/0mwVQLbQr8 https…
## 2 RT @jscarto: Frequency of scores from every #NBA\U0001f3c0 game #dataviz https://t.co/mr2ydQpIJA\n\nData + #rstats code: https://t.co/0mwVQLbQr8 https…
## 3                                  "Reboot of rgexf" https://t.co/hwPeThtVjh #rgexf @gephi @gexf #rstats @jorgefabrega @pabloparedesn @yrochat @p_barbera
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             2              0           FALSE            <NA>       TRUE
## 2             2              0           FALSE            <NA>       TRUE
## 3             0              0           FALSE            <NA>      FALSE
##    retweet_status_id in_reply_to_status_status_id
## 1 928371199423414273                         <NA>
## 2 928371199423414273                         <NA>
## 3               <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                source media_id media_url media_url_expanded urls
## 1 realtimeApp_reactjs     <NA>      <NA>               <NA> <NA>
## 2  Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 3  Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                                                 urls_display
## 1 reddit.com/r/dataisbeauti… gist.github.com/anonymous/0ac1…
## 2 reddit.com/r/dataisbeauti… gist.github.com/anonymous/0ac1…
## 3                         gvegayon.github.io/post/reboot-of…
##                                                                                                                                                              urls_expanded
## 1 https://www.reddit.com/r/dataisbeautiful/comments/7avtkz/the_frequency_of_every_final_score_that_has/ https://gist.github.com/anonymous/0ac179f7d78d5c9c9380226008d12953
## 2 https://www.reddit.com/r/dataisbeautiful/comments/7avtkz/the_frequency_of_every_final_score_that_has/ https://gist.github.com/anonymous/0ac179f7d78d5c9c9380226008d12953
## 3                                                                                                                         https://gvegayon.github.io/post/reboot-of-rgexf/
##                                      mentions_screen_name
## 1                                                 jscarto
## 2                                                 jscarto
## 3 Gephi gexf jorgefabrega pabloparedesn yrochat p_barbera
##                                          mentions_user_id symbols
## 1                                                16692909      NA
## 2                                                16692909      NA
## 3 22749856 89715925 120665900 2483009432 15516583 4515151      NA
##             hashtags coordinates place_id place_type place_name
## 1 NBA dataviz rstats          NA     <NA>       <NA>       <NA>
## 2 NBA dataviz rstats          NA     <NA>       <NA>       <NA>
## 3       rgexf rstats          NA     <NA>       <NA>       <NA>
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
##   screen_name   user_id          created_at          status_id
## 1    gvegayon  73013091 2017-11-08 21:20:44 928371736176836608
## 2     rnomics 177684507 2017-11-08 21:19:16 928371365434023937
##                                                                                                                                         text
## 1                     "Reboot of rgexf" https://t.co/hwPeThtVjh #rgexf @gephi @gexf #rstats @jorgefabrega @pabloparedesn @yrochat @p_barbera
## 2 https://t.co/M4t9gkC5kz Stephen Turner on Twitter: "cbioRNASeq: #Rstats pkg for bcbio RNA-seq analysis https://t.co/4vRYecU8ln from mjste…
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
## 2              IFTTT     <NA>      <NA>               <NA> <NA>
##                                                    urls_display
## 1                            gvegayon.github.io/post/reboot-of…
## 2 twitter.com/i/web/status/9… f1000research.com/articles/6-197…
##                                                                                      urls_expanded
## 1                                                 https://gvegayon.github.io/post/reboot-of-rgexf/
## 2 https://twitter.com/i/web/status/928336879975567361 https://f1000research.com/articles/6-1976/v1
##                                      mentions_screen_name
## 1 Gephi gexf jorgefabrega pabloparedesn yrochat p_barbera
## 2                                                    <NA>
##                                          mentions_user_id symbols
## 1 22749856 89715925 120665900 2483009432 15516583 4515151      NA
## 2                                                    <NA>      NA
##       hashtags coordinates place_id place_type place_name place_full_name
## 1 rgexf rstats          NA     <NA>       <NA>       <NA>            <NA>
## 2       Rstats          NA     <NA>       <NA>       <NA>            <NA>
##   country_code country bounding_box_coordinates bounding_box_type
## 1         <NA>    <NA>                     <NA>              <NA>
## 2         <NA>    <NA>                     <NA>              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "gvegayon"    "rnomics"     "jscarto"     "PeterBChi"   "KirkDBorne" 
## [6] "ikashnitsky"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "gvegayon"        "rnomics"         "jscarto"        
##   [4] "PeterBChi"       "KirkDBorne"      "ikashnitsky"    
##   [7] "rweekly_live"    "edzerpebesma"    "CRANberriesFeed"
##  [10] "v_vashishta"     "zentree"         "Zecca_Lehn"     
##  [13] "zevross"         "DataScienceLA"   "TanyaLMS"       
##  [16] "STEMxicanEd"     "tangming2005"    "Roisin_White__" 
##  [19] "mishafredmeyer"  "AriLamstein"     "antuki13"       
##  [22] "scottakenhead"   "tipsder"         "ahmedjr_16"     
##  [25] "Cruz_Julian_"    "NoorDinTech"     "vuorre"         
##  [28] "annraiho"        "DerFredo"        "stephhazlitt"   
##  [31] "kdnuggets"       "Rbloggers"       "JARS3N"         
##  [34] "dataandme"       "jarvmiller"      "Jack_Simpson"   
##  [37] "mirallesjm"      "schubtom"        "lobrowR"        
##  [40] "Timcdlucas"      "Voovarb"         "rstatsdata"     
##  [43] "strnr"           "apreshill"       "maximaformacion"
##  [46] "LuisDVerde"      "henrikbengtsson" "mkdyderski"     
##  [49] "LeafyEricScott"  "MiguelCos"       "MicheleTobias"  
##  [52] "CSJCampbell"     "r_metalheads"    "hoytemerson"    
##  [55] "healthandstats"  "MaryHeskel"      "revodavid"      
##  [58] "sckottie"        "RCharlie425"     "NDTechUK"       
##  [61] "BigDataInsights" "CougRstats"      "mjhendrickson"  
##  [64] "thinkR_fr"       "lucazav"         "RLangTip"       
##  [67] "ashiklom711"     "gelliottmorris"  "briansarnacki"  
##  [70] "kaelen_medeiros" "Carles_"         "juliasilge"     
##  [73] "CaseyYoungflesh" "gkalinkat"       "_ColinFay"      
##  [76] "dj_shaily"       "Elias_Be"        "andrewheiss"    
##  [79] "gumgumeo"        "imtaraas"        "nierhoff"       
##  [82] "jamesfeigenbaum" "eodaGmbH"        "LeedsDataSoc"   
##  [85] "guangchuangyu"   "old_man_chester" "canoodleson"    
##  [88] "dccc_phd"        "ManningBooks"    "ttso"           
##  [91] "Mooniac"         "robinson_es"     "dvaughan32"     
##  [94] "Aerin_J"         "askdrstats"      "chainsawriot"   
##  [97] "gabyfarries"     "RicSchuster"     "fubits"         
## [100] "EllenEq"         "kobblumor"       "datascienceplus"
## [103] "ISUBiomass"      "NPilakouta"      "ma_salmon"      
## [106] "eddelbuettel"    "williamsanger"   "gdbassett"      
## [109] "ThomasHopper"    "CurtBurk"        "RLadiesGlobal"  
## [112] "abresler"        "chrbknudsen"     "katzkagaya"     
## [115] "ingorohlfing"    "annakrystalli"   "bass_analytics" 
## [118] "drboothroyd"     "DurhamEcon"      "ngamita"        
## [121] "MangoTheCat"     "martinjhnhadley" "JRBerrendero"   
## [124] "lumbininep"      "HelicityBoson"   "sharoz"         
## [127] "recleev"         "furrer_ebpi"     "johnstamford"   
## [130] "ProfesAllende"   "IstvanHajnal"    "rintukutum"     
## [133] "xslates"         "derekgreene"     "CardiffRUG"     
## [136] "thomasp85"       "maartenzam"      "shellie_wall"   
## [139] "MrThreadzilla"   "rgaiacs"         "Antoine__V"     
## [142] "jessenleon"      "KellyBodwin"     "KKulma"         
## [145] "Kamandeh_"       "kiwiskiNZ"       "ZacharyST"      
## [148] "lucyleeow"       "jacquietran"     "NBvGersdorff"   
## [151] "rdpeng"          "RetweetedRajeev" "rbukralia"      
## [154] "HannahDirector"  "cjlortie"        "kamal_hothi"    
## [157] "benrfitzpatrick" "LeahAWasser"     "phoebewong2012" 
## [160] "bhc3"            "tetsuroito"      "thatdnaguy"     
## [163] "cigrainger"      "StableMarkets"   "jhollist"       
## [166] "birgit_szabo"    "AnalyticsVidhya" "__jsta"         
## [169] "mr_corcorana"    "stannals"        "shoshievass"    
## [172] "DavidJohnBaker"  "TermehKousha"    "samfirke"       
## [175] "AchimZeileis"    "KatheMathBio"    "sellorm"        
## [178] "nj_tierney"      "TimAssal"        "MilesMcBain"    
## [181] "hlw_phd"         "TheDCPope"       "ManuSaunders"   
## [184] "jk_kueper"       "jkassof"         "JLucibello"     
## [187] "stephenkinsella" "EBac_BI"         "BC0808"         
## [190] "milos_agathon"   "jenitive_case"   "ChristinZasada" 
## [193] "v_matzek"        "bluecology"      "fmic_"          
## [196] "tonkouts"        "SimplyApprox"    "picocluster"    
## [199] "iainmwallace"    "Datatitian"      "jent103"        
## [202] "Schw4rzR0tG0ld"  "TechMktEJ"       "MikeRSpencer"   
## [205] "petermacp"       "hearkz"          "Jemus42"        
## [208] "mmznr"           "verajosemanuel"  "MichaelFrasco"  
## [211] "andreas_io"      "_neilch"         "adolfoalvarez"  
## [214] "ptrckprry"       "tmllr"           "JeanManguy"     
## [217] "SmartCity_eu"    "mikkopiippo"     "CMastication"   
## [220] "statistik_zh"    "CRANPolicyWatch" "jazzejay_"      
## [223] "fmarin_ES"       "RLadiesNYC"      "IngridPollet"   
## [226] "alice_data"      "evanodell"       "PWaryszak"      
## [229] "MicrosoftR"      "JAlexBranham"    "demian_gz"      
## [232] "hughbartling"    "SuseJohnston"    "migenic"        
## [235] "DataScienceInR"  "WinVectorLLC"    "payaaru"        
## [238] "sapo83"          "tladeras"        "HBossier"       
## [241] "HugDorothea"     "EcographyJourna" "fjnogales"      
## [244] "andyboyan"       "GrahamIMac"      "SteffenBank"    
## [247] "d4tagirl"        "DrScranto"       "AvrahamAdler"   
## [250] "cricketcrocker"  "dataEcologist"   "Rexercises"     
## [253] "David_McGaughey" "VRaoRao"         "sthda_en"       
## [256] "geodatascience"  "CJPHD"           "brodriguesco"   
## [259] "gagliol"         "jeroenhjanssens" "zabormetrics"   
## [262] "feralaes"        "h21k"            "kearneymw"      
## [265] "gp_pulipaka"     "sergiouribe"     "NumFOCUS"       
## [268] "jrosenberg6432"  "staffanbetner"   "RLadiesOrlando" 
## [271] "B_W_Campbell"    "mikeloukides"    "_AntoineB"      
## [274] "joshua_ulrich"   "Josh_Ebner"      "yoniceedee"     
## [277] "mdsumner"        "opencpu"         "romain_francois"
## [280] "BeginTry"        "SamuelJenness"   "UKIRSC_SMM"     
## [283] "bnurusers"       "RLadiesMAD"      "JohnTWaller"    
## [286] "earlconf"        "Elliot_Meador"   "noticiasSobreR" 
## [289] "atassSports"     "joaquinarma"     "zemcunha"       
## [292] "alexcipro"       "reid_jf"         "lapply"         
## [295] "tccafrica"       "markvdloo"       "FrancoisKeck"   
## [298] "sauer_sebastian" "kessler_mathieu" "doris_swf"      
## [301] "HendirkB"
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
## 1 295344317 One R Tip a Day    RLangTip                 <NA>
## 2   5685812       boB Rudis    hrbrmstr Underground Cell #34
##                                                                                                                                                             description
## 1                                                       One tip per day M-F on the R programming language #rstats. Brought to you by the R community team at Microsoft.
## 2 Don't look at me…I do what he does—just slower. #rstats avuncular • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE           47136            11         1343 2011-05-08 20:51:40
## 2     FALSE            8854           394          599 2007-05-01 14:04:24
##   favourites_count utc_offset                  time_zone geo_enabled
## 1                3     -28800 Pacific Time (US & Canada)       FALSE
## 2            10485     -18000 Eastern Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           1767   en                FALSE         FALSE
## 2     TRUE          69666   en                FALSE         FALSE
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

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 328

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-r/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-r/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-r/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="90%" />




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
