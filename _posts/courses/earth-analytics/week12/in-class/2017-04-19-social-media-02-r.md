---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
modified: '2017-08-14'
=======
modified: '2017-08-09'
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
category: [course-materials]
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
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
##      screen_name            user_id          created_at          status_id
## 1 SeattleDataGuy 824295666784423937 2017-08-14 23:30:03 897238922425638912
## 2 aocalderon1978 821413864726265856 2017-08-14 23:28:05 897238427732656128
## 3     TodoenpcVE          454843765 2017-08-14 23:27:51 897238369700392960
##                                                                                                                                           text
## 1                          RT @Rbloggers: Reproducibility: A cautionary tale from data journalism https://t.co/HvrvUXWZvz #rstats #DataScience
## 2                                RT @geomenke: @TinaACormier starting Geo with R? Yes we can! workshop @foss4g #rstats https://t.co/RFyPvBTxq5
## 3 RT @R_Programming: R Tip: It is now possible to build Deep Learning models with keras in R #rstats https://t.co/EuEMwNWGgl #datascience htt…
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             4              0           FALSE            <NA>       TRUE
## 2             6              0           FALSE            <NA>       TRUE
## 3            52              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1 897235092195733505                         <NA>
## 2 897067888821104641                         <NA>
## 3 870207365760524288                         <NA>
=======
##    screen_name            user_id          created_at          status_id
## 1    ghislainv           44361445 2017-08-09 14:27:20 895290403620048897
## 2      tipsder 891619862329647105 2017-08-09 14:25:25 895289920729874433
## 3 ggaribotto69          102537203 2017-08-09 14:22:29 895289184566484992
##                                                                                                                                           text
## 1 RT @frod_san: Use cite_packages() to easily get citations for #rstats packages used, ready to paste into your manuscript or report https://…
## 2 Tres maneras de crear la misma matriz en R.\n1 matrix(c(1:9),nrow=3,ncol=3)\n2 array(1:8,dim=c(3,3))\n3 cbind(c(1:3),c(4:6),c(7:9))\n#rstats
## 3                                                              RT @Rbloggers: NYC Airbnb Insights https://t.co/hKIgWxmoBw #rstats #DataScience
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1            40              0           FALSE            <NA>       TRUE
## 2             0              0           FALSE            <NA>      FALSE
## 3             8              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1 895111496979668992                         <NA>
## 2               <NA>                         <NA>
## 3 895182804304134150                         <NA>
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   fr
## 3                       <NA>                           <NA>   en
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
##               source           media_id
## 1 Twitter Web Client               <NA>
## 2 Twitter Web Client 897067882080874496
## 3           TodoEnPC               <NA>
##                                        media_url
## 1                                           <NA>
## 2 http://pbs.twimg.com/media/DHMGfGLXsAAdzGj.jpg
## 3                                           <NA>
##                                               media_url_expanded urls
## 1                                                           <NA> <NA>
## 2 https://twitter.com/geomenke/status/897067888821104641/photo/1 <NA>
## 3                                                           <NA> <NA>
##               urls_display                    urls_expanded
## 1          wp.me/pMm6L-E3V          https://wp.me/pMm6L-E3V
## 2                     <NA>                             <NA>
## 3 rstudio.github.io/keras/ https://rstudio.github.io/keras/
##           mentions_screen_name           mentions_user_id symbols
## 1                    Rbloggers                  144592995      NA
## 2 geomenke TinaACormier foss4g 7159622 169499714 14449583      NA
## 3                R_Programming                 2505271093      NA
##             hashtags coordinates place_id place_type place_name
## 1 rstats DataScience          NA     <NA>       <NA>       <NA>
## 2             rstats          NA     <NA>       <NA>       <NA>
## 3 rstats datascience          NA     <NA>       <NA>       <NA>
##   place_full_name country_code country bounding_box_coordinates
## 1            <NA>         <NA>    <NA>                     <NA>
## 2            <NA>         <NA>    <NA>                     <NA>
## 3            <NA>         <NA>    <NA>                     <NA>
##   bounding_box_type
## 1              <NA>
## 2              <NA>
## 3              <NA>
=======
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 3 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
##      urls_display           urls_expanded mentions_screen_name
## 1            <NA>                    <NA>             frod_san
## 2            <NA>                    <NA>                 <NA>
## 3 wp.me/pMm6L-E17 https://wp.me/pMm6L-E17            Rbloggers
##   mentions_user_id symbols           hashtags coordinates place_id
## 1        326299187      NA             rstats          NA     <NA>
## 2             <NA>      NA             rstats          NA     <NA>
## 3        144592995      NA rstats DataScience          NA     <NA>
##   place_type place_name place_full_name country_code country
## 1       <NA>       <NA>            <NA>         <NA>    <NA>
## 2       <NA>       <NA>            <NA>         <NA>    <NA>
## 3       <NA>       <NA>            <NA>         <NA>    <NA>
##   bounding_box_coordinates bounding_box_type
## 1                     <NA>              <NA>
## 2                     <NA>              <NA>
## 3                     <NA>              <NA>
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
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
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
##       screen_name   user_id          created_at          status_id
## 1 kerry_benjamin1  89314473 2017-08-14 23:27:16 897238219389116416
## 2     nitingupta2 171860561 2017-08-14 23:23:50 897237356578779141
##                                                                                                                     text
## 1                                                     @KKulma Haha. I gotta think of a useful #rstats project like this.
## 2 I published a gist on deploying a blogdown website on Netlify\n\nhttps://t.co/ymSgHLzafl\n\n#rstats #blogdown #netlify
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             1              2           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>           897237891268698112
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                  567537377                         KKulma   en
=======
##   screen_name            user_id          created_at          status_id
## 1     tipsder 891619862329647105 2017-08-09 14:25:25 895289920729874433
## 2    dirk_sch          500162083 2017-08-09 14:20:59 895288803287605248
##                                                                                                                                           text
## 1 Tres maneras de crear la misma matriz en R.\n1 matrix(c(1:9),nrow=3,ncol=3)\n2 array(1:8,dim=c(3,3))\n3 cbind(c(1:3),c(4:6),c(7:9))\n#rstats
## 2       I started working on an R package for HXL a while ago. Contributers are very welcome! https://t.co/D1EIfbOfTx… https://t.co/uB7NZRvlUL
##   retweet_count favorite_count is_quote_status    quote_status_id
## 1             0              0           FALSE               <NA>
## 2             1              1            TRUE 895188965027958785
##   is_retweet retweet_status_id in_reply_to_status_status_id
## 1      FALSE              <NA>                         <NA>
## 2      FALSE              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   fr
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
## 2                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
##                      urls_display
## 1                            <NA>
## 2 gist.github.com/nitingupta2/c0…
##                                                          urls_expanded
## 1                                                                 <NA>
## 2 https://gist.github.com/nitingupta2/c0aa4215dc348eb7782315fe28253de8
##   mentions_screen_name mentions_user_id symbols                hashtags
## 1               KKulma        567537377      NA                  rstats
## 2                 <NA>             <NA>      NA rstats blogdown netlify
##   coordinates place_id place_type place_name place_full_name country_code
## 1          NA     <NA>       <NA>       <NA>            <NA>         <NA>
## 2          NA     <NA>       <NA>       <NA>            <NA>         <NA>
##   country bounding_box_coordinates bounding_box_type
## 1    <NA>                     <NA>              <NA>
## 2    <NA>                     <NA>              <NA>
=======
##                                             urls_display
## 1                                                   <NA>
## 2 github.com/dirkschumacher… twitter.com/i/web/status/8…
##                                                                                urls_expanded
## 1                                                                                       <NA>
## 2 https://github.com/dirkschumacher/rhxl https://twitter.com/i/web/status/895288803287605248
##   mentions_screen_name mentions_user_id symbols hashtags coordinates
## 1                 <NA>             <NA>      NA   rstats          NA
## 2                 <NA>             <NA>      NA     <NA>          NA
##   place_id place_type place_name place_full_name country_code country
## 1     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
## 2     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
##   bounding_box_coordinates bounding_box_type
## 1                     <NA>              <NA>
## 2                     <NA>              <NA>
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
## [1] "kerry_benjamin1" "nitingupta2"     "DeborahTannon"   "Rbloggers"      
## [5] "ledell"          "Kwarizmi"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "kerry_benjamin1" "nitingupta2"     "DeborahTannon"  
##   [4] "Rbloggers"       "ledell"          "Kwarizmi"       
##   [7] "RStudioJoe"      "rnomics"         "astroeringrand" 
##  [10] "revodavid"       "CRANberriesFeed" "megisarecruiter"
##  [13] "databricks"      "dataandme"       "thomasp85"      
##  [16] "AngeBassa"       "realTroyHill"    "znmeb"          
##  [19] "MikeRSpencer"    "kierisi"         "hadleywickham"  
##  [22] "zabormetrics"    "mattkmiecik14"   "rforjournalists"
##  [25] "rOpenSci"        "talkbeck"        "groundwalkergmb"
##  [28] "jsonbecker"      "jslefche"        "seabbs"         
##  [31] "AnaMEcheverri"   "data_gurus"      "Leaker_ZRH"     
##  [34] "DaveOnData"      "HoloMarkeD"      "Displayrr"      
##  [37] "LockeData"       "CardiffRUG"      "DrQz"           
##  [40] "RobertMitchellV" "oducepd"         "guangchuangyu"  
##  [43] "ExcelStrategies" "tvladeck"        "TransmitScience"
##  [46] "bhaskar_vk"      "liberrenaud"     "Rexercises"     
##  [49] "ahmad_m_mobin"   "d8aninja"        "sckottie"       
##  [52] "BigDataInsights" "ezbrooks"        "drsimonj"       
##  [55] "SkBlaz"          "RLangTip"        "drdrewsteen"    
##  [58] "StatnMap"        "rweekly_org"     "rabaath"        
##  [61] "ActivevoiceSw"   "jrosenberg6432"  "geomenke"       
##  [64] "nierhoff"        "carolynwclayton" "StatsInTheWild" 
##  [67] "oaggimenez"      "noamross"        "NicholasStrayer"
##  [70] "EvanKaeding"     "DrDanHolmes"     "jumping_uk"     
##  [73] "hrbrmstr"        "AnalyticsVidhya" "stoltzmaniac"   
##  [76] "abresler"        "tipsder"         "danielk_bcu"    
##  [79] "OrrinEdenfield"  "mjwalds"         "awhstin"        
##  [82] "RLadiesGlobal"   "alittlestats"    "mdsumner"       
##  [85] "jhollist"        "paavopdf"        "RhoBott"        
##  [88] "bass_analytics"  "RLadiesMVD"      "SavranWeb"      
##  [91] "ewen_"           "ramhiser"        "coolbutuseless" 
##  [94] "MathFlashcards"  "PaulCampbell91"  "CatchingPebbles"
##  [97] "martinjhnhadley" "DaveRubal"       "kevinkeenan_"   
## [100] "AndriyGazin"     "vivekbhr"        "AdamJKucharski" 
## [103] "JT_EpiVet"       "_AntoineB"       "metricbrew"     
## [106] "d4t4v1z"         "jody_tubi"       "thosjleeper"    
## [109] "markvdloo"       "AbRahman_25"     "dj_shaily"      
## [112] "axelrod_eric"    "Tatjana_Kec"     "McMcgregory"    
## [115] "DailyRpackage"   "AliceRisely"     "AvrahamAdler"   
## [118] "v_vashishta"     "itsmevidhya_k"   "acalatr"        
## [121] "_GregoryPrince_" "_Data_Science_"  "giant_spacebook"
## [124] "TinaACormier"    "openburgr"       "MilesMcBain"    
## [127] "aksingh1985"     "Emaasit"         "nielsberglund"  
## [130] "pitakakariki"    "PaulLantos"      "jarvmiller"     
## [133] "bramasolo"       "franzViz"        "tonmcg"         
## [136] "AriLamstein"     "thatdnaguy"      "ReneHJHeim"     
## [139] "ChelseaParlett"  "ManningBooks"    "riannone"       
## [142] "MichaelFrasco"   "johnverostek"    "jrboehnke"      
## [145] "BasitAali"       "eddelbuettel"    "nathaneastwood_"
## [148] "rafmarcondes"    "znmeb_dfs"       "nicoleradziwill"
## [151] "KKulma"          "ozjimbob"        "MDFBasha"       
## [154] "antuki13"        "InfonomicsToday" "analyticbridge" 
## [157] "LeviABx"         "gdbassett"       "julian_urbano"  
## [160] "ClausWilke"      "UrbanDemog"      "rstatsdata"     
## [163] "fakeDespommier"  "rweekly_live"    "pehepe50"       
## [166] "pinkyprincess"   "SamGHillman"     "MDMGeek"        
## [169] "monkeylearn"     "gp_pulipaka"     "ThomasMailund"  
## [172] "DJAnderson_07"   "lenkiefer"       "globalizefm"    
## [175] "dataknut"        "DataCamp"        "healthandstats" 
## [178] "KJSBEDI"         "sonnylaskar"     "timelyportfolio"
## [181] "jllopezpino"     "bruce_swihart"   "PaulMinda1"     
## [184] "_glitterworm"    "henrikbengtsson" "dccc_phd"       
## [187] "RMHoge"          "murnane"         "giorgiogarziano"
## [190] "Chuck_Moeller"   "adamhsparks"     "EikoFried"      
## [193] "DataSci_Ireland" "cpwbroadmead"    "darbuo"         
## [196] "emibaldacci"     "DataIns8tsCloud" "Chucheria"      
## [199] "datagistips"     "kamal_hothi"     "LukeBornn"      
## [202] "hannahyan"       "DoctorTegs"      "pachamaltese"   
## [205] "joranelias"      "peterdavenport8" "tleeuwenburg"   
## [208] "dana_karelus"    "dfalbel"         "geoappsmith"    
## [211] "bosshardsurvey"  "MKTJimmyxu"      "HeatherUrry"    
## [214] "WireMonkey"      "JulioTrujillo_"  "OmaymaS_"       
## [217] "pkqstr"          "MadelinePgh"     "phnk"           
## [220] "enricoferrero"   "DrMattCrowson"   "LuisDVerde"     
## [223] "dalejbarr"       "RoelandtN42"     "J_Yagecic"      
## [226] "_pSTS"           "benavides_c_"    "edypurnomo"     
## [229] "davidlaing_92"   "_ColinFay"       "AntoViral"      
## [232] "m_learningnews"  "cjlortie"        "PAdhokshaja"    
## [235] "ldamiano0"       "suman12029"      "ijlyttle"       
## [238] "TedemanCPA"      "sjmgarnier"      "LEG_UFPR"       
## [241] "shanemeister1"   "mrgunn"          "KirkDBorne"     
## [244] "rick_pack2"      "synaptogenesis_" "ma_salmon"      
## [247] "R_Programming"   "pacocuak"        "davidejansen"   
## [250] "RLadiesOrlando"  "najarvg"         "kellenbyrnes"   
## [253] "ParallelRecruit" "jlmico"          "eliaseythorsson"
## [256] "jazzejay_"       "SanghaChick"     "MangoTheCat"    
## [259] "michalovamichle" "ShinyappsRecent" "ameisen_strasse"
## [262] "JameseBowman"    "epb41l2"         "gombang"        
## [265] "jenstirrup"      "superboreen"     "marskar"        
## [268] "yoniceedee"      "hiveminer"       "cabioinformatic"
## [271] "swfknecht"       "RetweetedRajeev" "rbukralia"      
## [274] "EmilyRiederer"   "datapointier"    "OilGains"       
## [277] "granvillejmath"  "tanyacash21"     "amelinda4ever"  
## [280] "theotheredgar"   "GilYardeni"      "Stat_Ron"       
## [283] "d4tagirl"        "BiostatBecky"    "georgetsiminis"
=======
## [1] "tipsder"       "dirk_sch"      "sckottie"      "EarthLabCU"   
## [5] "josvandongen"  "josephmreilly"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "tipsder"         "dirk_sch"        "sckottie"       
##   [4] "EarthLabCU"      "josvandongen"    "josephmreilly"  
##   [7] "stiles"          "CRANberriesFeed" "GioraSimchoni"  
##  [10] "_Axeman_"        "rweekly_live"    "nibrivia"       
##  [13] "ingorohlfing"    "_ColinFay"       "L3viathan2142"  
##  [16] "StrictlyStat"    "henrikbengtsson" "Demografia_CSIC"
##  [19] "t_m_dantas"      "nielsberglund"   "dataandme"      
##  [22] "Talent_metrics"  "howardrunbake"   "DrGMerchant"    
##  [25] "jazzejay_"       "thomasp85"       "drob"           
##  [28] "johnjanuszczak"  "mdsumner"        "LockeData"      
##  [31] "geoappsmith"     "OilGains"        "gdbassett"      
##  [34] "Rfunction_a_day" "seda_adventures" "jdatap"         
##  [37] "CorradoLanera"   "AntoViral"       "InvernessRug"   
##  [40] "v_vashishta"     "guangchuangyu"   "Data_World_Blog"
##  [43] "i_steves"        "tuomaseerola"    "carroll_jono"   
##  [46] "dajb2"           "INWT_Statistics" "PatrickStotz"   
##  [49] "ParallelRecruit" "SteffLocke"      "CardiffRUG"     
##  [52] "VizMonkey"       "ansellbr3"       "csgillespie"    
##  [55] "DataCamp"        "JuliaGustavsen"  "DeborahTannon"  
##  [58] "keyboardpipette" "Rbloggers"       "HighlandDataSci"
##  [61] "ma_salmon"       "ericjnordberg"   "DailyRpackage"  
##  [64] "P_Louis2"        "nj_tierney"      "raphg"          
##  [67] "daranzolin"      "MKTJimmyxu"      "ukituki"        
##  [70] "bramasolo"       "gelliottmorris"  "LucyStats"      
##  [73] "ThomasSpeidel"   "frod_san"        "DataconomyMedia"
##  [76] "CFHammill"       "RLadiesOrlando"  "danpbowen"      
##  [79] "neilfws"         "gachisbar"       "rbloggersBR"    
##  [82] "DrAndrewRate"    "DataRobot"       "sjmgarnier"     
##  [85] "g3rv4"           "msubbaiah1"      "AnalyticsVidhya"
##  [88] "MicheleTobias"   "bass_analytics"  "alyb_batgirl"   
##  [91] "gregorybritten"  "meleksomai"      "davis_egsa"     
##  [94] "arthur_spirling" "rileymsmith19"   "cjlortie"       
##  [97] "tylergbyers"     "n_ashutosh"      "MMHussieni"     
## [100] "znmeb"           "Doctor_Dick_MD"  "alexchubaty"    
## [103] "klopiano"        "ucfagls"         "RLadiesLA"      
## [106] "atulbutte"       "RLadiesSF"       "PetrelStation"  
## [109] "Stat_Ron"        "WeatherDecTech"  "CarldeBoerPhD"  
## [112] "dmi3k"           "rquintino"       "BrentBrewington"
## [115] "globalizefm"     "NelsonStauffer"  "larnsce"        
## [118] "syfi_24"         "AndriyGazin"     "revodavid"      
## [121] "Rap_Ecol"        "graemedblair"    "aecoppock"      
## [124] "TimSalabim3"     "juliasilge"      "KristenSauby"   
## [127] "PlotsWithJon"    "rstatsdata"      "graemeleehickey"
## [130] "pssGuy"          "staywithr"       "eddelbuettel"   
## [133] "macromicropaleo" "thie1e"          "noamross"       
## [136] "stoltzmaniac"    "AaltoSanni"      "oducepd"        
## [139] "ucdlevy"         "SBAmin"          "dyslexicscience"
## [142] "LuigiBiagini"    "pofigster"       "darokun"        
## [145] "zjay91"          "old_man_chester" "gableingaround" 
## [148] "ftzo"            "imtaras"         "mischa_may"     
## [151] "BigDataInsights" "aymanfabuelela"  "AriLamstein"    
## [154] "kwbroman"        "RLangTip"        "TilmanSheets"   
## [157] "zabormetrics"    "Madskoefoed"     "synaptogenesis_"
## [160] "BAnalisis"       "whlevine"        "AedinCulhane"   
## [163] "richierocks"     "kellyproof"      "jimhester_"     
## [166] "Oceanic_Dave"    "EikoFried"       "colbycosh"      
## [169] "nierhoff"        "Kidman007"       "vinuct"         
## [172] "lauretig"        "NKSBarker"       "brookLYNevery1" 
## [175] "expersso"        "MrYeti1"         "bcshaffer"      
## [178] "GSwithR"         "awhstin"         "pavanmirla"     
## [181] "georgetsiminis"  "JeanManguy"      "zevross"        
## [184] "atassSports"     "markvdloo"       "florianhartig"  
## [187] "jyazman2012"     "HenriWallen"     "biodatasci"     
## [190] "jimmuta"         "jrosenberg6432"  "JulHeimer"      
## [193] "TGidoin"         "dalejbarr"       "WarwickRUG"     
## [196] "_AntoineB"       "JoergSteinkamp"  "robertmaidstone"
## [199] "bartzbeielstein" "trianglegirl"    "paavopdf"       
## [202] "earlconf"        "rodolfo_mmendes" "introspection"  
## [205] "HackYourPhd"     "pommedeterre33"  "maxheld"        
## [208] "alinedeschamps"  "southmapr"       "tonkouts"       
## [211] "CharlotteEvePa1" "Jemus42"         "Martin_Ecology" 
## [214] "symbolixAU"      "nhcooper123"     "Rcodes_Official"
## [217] "rosiecblackman"  "datakelpie"      "arcoutte_c"     
## [220] "VascoElbrecht"   "ImDataScientist" "franzViz"       
## [223] "stekhn"          "certifiedwaif"   "scac1041"       
## [226] "MathFlashcards"  "lingtax"         "aschiff"        
## [229] "gavg712"         "dogvile"         "Displayrr"      
## [232] "nomuken25"       "hiveminer"       "newurbangrit"   
## [235] "meisshaily"      "normallyskewed"  "peterdavenport8"
## [238] "ervin_pa"        "ClausWilke"      "RLadiesNYC"     
## [241] "rmkubinec"       "JarthurNavarro"  "KarlskiB"       
## [244] "WatanabeSmith"   "lenkiefer"       "marcusborba"    
## [247] "hadleywickham"   "jtrnyc"          "phnk"           
## [250] "mauro_lepore"    "robert_squared"  "kguidonimartins"
## [253] "vivalosburros"   "J_Yagecic"       "MariaGaragouni" 
## [256] "silgasa"         "ibarraespinosa1" "hardsci"        
## [259] "doorisajar"      "rafmarcondes"    "_hlplab_"       
## [262] "mmmpork"         "TFS_Bournemouth" "Uptake"         
## [265] "SHaymondSays"    "Kwarizmi"        "regionomics"    
## [268] "DeCiccoDonk"     "USGS_R"          "lpreding"       
## [271] "beeonaposy"      "PeteHaitch"      "unsorsodicorda" 
## [274] "eli_sabblah"
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
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
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
## 1    5685812          boB Rudis    hrbrmstr Underground Cell #34
## 2 4911181019 Statistician Jason RStatsJason          Atlanta, GA
##                                                                                                                                                             description
## 1 Don't look at me…I do what he does—just slower. #rstats avuncular • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
## 2                              I tweet about Public Health and other things. Founder and current Chair of #Rstats User Group @CDCGov. Alumnus/Instructor @EmoryRollins.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE            8399           374          581 2007-05-01 14:04:24
## 2     FALSE             316           955           27 2016-02-15 00:48:05
##   favourites_count utc_offset                  time_zone geo_enabled
## 1             9547     -14400 Eastern Time (US & Canada)       FALSE
## 2             3320     -25200 Pacific Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1     TRUE          66616   en                FALSE         FALSE
## 2    FALSE           6243   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   022330
## 2                  FALSE                   F5F8FA
##                                                     profile_background_image_url
## 1 http://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
## 2                                                                           <NA>
##                                                profile_background_image_url_https
## 1 https://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
## 2                                                                            <NA>
=======
## 1 4911181019 Statistician Jason RStatsJason          Atlanta, GA
## 2    5685812          boB Rudis    hrbrmstr Underground Cell #34
##                                                                                                                                                             description
## 1                              I tweet about Public Health and other things. Founder and current Chair of #Rstats User Group @CDCGov. Alumnus/Instructor @EmoryRollins.
## 2 Don't look at me…I do what he does—just slower. #rstats avuncular • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE             317           956           26 2016-02-15 00:48:05
## 2     FALSE            8331           371          581 2007-05-01 14:04:24
##   favourites_count utc_offset                  time_zone geo_enabled
## 1             3295     -25200 Pacific Time (US & Canada)       FALSE
## 2             9430     -14400 Eastern Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           6203   en                FALSE         FALSE
## 2     TRUE          66346   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   F5F8FA
## 2                  FALSE                   022330
##                                                     profile_background_image_url
## 1                                                                           <NA>
## 2 http://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
##                                                profile_background_image_url_https
## 1                                                                            <NA>
## 2 https://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
<<<<<<< HEAD:_posts/courses/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
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
=======
## 1 http://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             1DA1F2                       C0DEED
## 2             94BD5A                       FFFFFF
##   profile_sidebar_fill_color profile_text_color
## 1                     DDEEF6             333333
## 2                     C0DFEC             333333
##   profile_use_background_image default_profile default_profile_image
## 1                         TRUE            TRUE                 FALSE
## 2                         TRUE           FALSE                 FALSE
##                                         profile_banner_url
## 1                                                     <NA>
## 2 https://pbs.twimg.com/profile_banners/5685812/1398248552
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r.md
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 331

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
