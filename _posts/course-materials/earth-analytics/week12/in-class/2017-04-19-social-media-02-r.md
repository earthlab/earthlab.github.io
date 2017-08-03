---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-08-03'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/use-twitter-api-r/
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
##     screen_name   user_id          created_at          status_id
## 1 eliotmcintire 195422804 2017-08-03 23:00:30 893245220590043136
## 2     odeleongt 199302553 2017-08-03 22:59:16 893244910274523139
## 3  mugahayaliey  53341007 2017-08-03 22:53:24 893243430184386564
##                                                                                                                                             text
## 1                                             RT @alexchubaty: our latest #rstats package just hit CRAN : https://t.co/WSvMJEjTql @eliotmcintire
## 2 Presenting new #rstats package `postr`\nEasily prepare templates and render print ready images for conference posters\nhttps://t.co/9QApqkyoJe
## 3                               RT @Rbloggers: Parallel Computing Exercises: Snow and Rmpi (Part-3) https://t.co/qSD0ryvP3Y #rstats #DataScience
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             1              0           FALSE            <NA>       TRUE
## 2             0              0           FALSE            <NA>      FALSE
## 3             2              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1 893240821482364928                         <NA>
## 2               <NA>                         <NA>
## 3 893226187367075841                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                source media_id media_url media_url_expanded urls
## 1  Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2  Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 3 Twitter for Android     <NA>      <NA>               <NA> <NA>
##                         urls_display
## 1 cran.r-project.org/package=quickP…
## 2         github.com/odeleongt/postr
## 3                    wp.me/pMm6L-DXU
##                                  urls_expanded      mentions_screen_name
## 1 https://cran.r-project.org/package=quickPlot alexchubaty eliotmcintire
## 2           https://github.com/odeleongt/postr                      <NA>
## 3                      https://wp.me/pMm6L-DXU                 Rbloggers
##      mentions_user_id symbols           hashtags coordinates place_id
## 1 148548277 195422804      NA             rstats          NA     <NA>
## 2                <NA>      NA             rstats          NA     <NA>
## 3           144592995      NA rstats DataScience          NA     <NA>
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
##      screen_name   user_id          created_at          status_id
## 1      odeleongt 199302553 2017-08-03 22:59:16 893244910274523139
## 2 GeorgetownCCPE 380983795 2017-08-03 22:50:12 893242625221853185
##                                                                                                                                             text
## 1 Presenting new #rstats package `postr`\nEasily prepare templates and render print ready images for conference posters\nhttps://t.co/9QApqkyoJe
## 2         . @FreddieMac #hiring a Senior #DataScientist in McLean, VA https://t.co/11e4XUlnkW #datajobs #RStats #SQL #Python #Hadoop #Linux #PHD
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             1              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2          Hootsuite     <NA>      <NA>               <NA> <NA>
##                 urls_display                      urls_expanded
## 1 github.com/odeleongt/postr https://github.com/odeleongt/postr
## 2          ow.ly/GSbD30e9uZo           http://ow.ly/GSbD30e9uZo
##   mentions_screen_name mentions_user_id symbols
## 1                 <NA>             <NA>      NA
## 2           FreddieMac         31522400      NA
##                                                           hashtags
## 1                                                           rstats
## 2 hiring DataScientist datajobs RStats SQL Python Hadoop Linux PHD
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
## [1] "odeleongt"      "GeorgetownCCPE" "revodavid"      "alexchubaty"   
## [5] "OmaymaS_"       "rweekly_live"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "odeleongt"       "GeorgetownCCPE"  "revodavid"      
##   [4] "alexchubaty"     "OmaymaS_"        "rweekly_live"   
##   [7] "StatStas"        "jayjacobs"       "KirkDBorne"     
##  [10] "joranelias"      "DeborahTannon"   "coolbutuseless" 
##  [13] "briansarnacki"   "CRANberriesFeed" "maartenzam"     
##  [16] "rana_usman"      "mikedelgado"     "hrbrmstr"       
##  [19] "LearnRinaDay"    "Rbloggers"       "ibarraespinosa1"
##  [22] "RBrainInc"       "pedro_jordano"   "kennethrose82"  
##  [25] "comprobar_url"   "dataandme"       "sharon000"      
##  [28] "dodger487"       "groundwalkergmb" "DBarriosONeill" 
##  [31] "BananaData"      "DrScranto"       "what_fish_eat"  
##  [34] "nielsberglund"   "NEON_sci"        "AllbriteAllday" 
##  [37] "v_vashishta"     "steffilazerte"   "DrGMerchant"    
##  [40] "ml_review"       "FarRider"        "jrosenberg6432" 
##  [43] "sTeamTraen"      "number_three"    "AlexaLFH"       
##  [46] "stoltzmaniac"    "KyleScotShank"   "TimSalabim3"    
##  [49] "ThomasMailund"   "rstatsdata"      "jonsjoberg"     
##  [52] "Rexercises"      "nitingupta2"     "abcronkhite"    
##  [55] "ronpatz"         "ChrisRDunleavy"  "mfczap"         
##  [58] "ucfagls"         "compbiologist"   "mikedecr"       
##  [61] "Dr_EOC"          "LeafyEricScott"  "nierhoff"       
##  [64] "oducepd"         "lmonasterio"     "DemocObserver"  
##  [67] "siminaboca"      "cyruslentin"     "iamchriswalker" 
##  [70] "kellenbyrnes"    "RLadiesOrlando"  "liberrenaud"    
##  [73] "sellorm"         "TrestleJeff"     "nathaneastwood_"
##  [76] "MalditoBarbudo"  "RLangTip"        "amelinda4ever"  
##  [79] "DataScienceLA"   "romain_francois" "o_gonzales"     
##  [82] "tsawallis"       "larnsce"         "vuorre"         
##  [85] "sauer_sebastian" "evolution_v2"    "clarkfitzg"     
##  [88] "duc_qn"          "mdsumner"        "datactivi_st"   
##  [91] "joelgombin"      "jsonbecker"      "devlintufts"    
##  [94] "danawanzer"      "matungawalla"    "earlconf"       
##  [97] "handaa1224"      "lizardschwartz"  "dantonnoriega"  
## [100] "fellgernon"      "drob"            "minebocek"      
## [103] "beeonaposy"      "chrbknudsen"     "jtrnyc"         
## [106] "csgillespie"     "MGCodesandStats" "maureviv"       
## [109] "hannah_recht"    "thomasp85"       "CSJCampbell"    
## [112] "StrictlyStat"    "DenitzaV"        "conjugateprior" 
## [115] "sfcheung"        "_ColinFay"       "RDub2"          
## [118] "FelipeSMBarros"  "keyboardpipette" "morebento"      
## [121] "f_dion"          "nubededatos"     "wrathematics"   
## [124] "wajdi_bs"        "ImDataScientist" "rick_pack2"     
## [127] "pallavipnt"      "geoappsmith"     "emble64"        
## [130] "desertnaut"      "brodriguesco"    "yelkhatib"      
## [133] "DataWookie"      "KevinWang009"    "Julie_B92"      
## [136] "jody_tubi"       "kklmmr"          "CardiffRUG"     
## [139] "MangoTheCat"     "climbertobby"    "ma_salmon"      
## [142] "carolin_correia" "iamjayakumars"   "DeoSahil"       
## [145] "jmgomez"         "cristianquirozd" "bramasolo"      
## [148] "ChrisGandrud"    "ActivevoiceSw"   "Displayrr"      
## [151] "paulonabike"     "OilGains"        "ClausWilke"     
## [154] "DailyRpackage"   "ctricot"         "MathFlashcards" 
## [157] "DarrenKoppel"    "dmi3k"           "zentree"        
## [160] "dataandpolitics" "yake_84"         "amykfoster"     
## [163] "BecAndTheBrain"  "d4tagirl"        "sfrechette"     
## [166] "certifiedwaif"   "gabrieldance"    "LucyStats"      
## [169] "DrDanHolmes"     "SHaymondSays"    "Craig_R_White"  
## [172] "rquintino"       "DataCamp"        "moietymouse"    
## [175] "cboettig"        "arvi1000"        "PStrafo"        
## [178] "thosjleeper"     "thatdnaguy"      "elpidiofilho"   
## [181] "GrunerDaniel"    "lksmth"          "AriLamstein"    
## [184] "ianmcook"        "kyle_e_walker"   "Emz3l"          
## [187] "czeildi"         "wfins"           "RubenRemelgado" 
## [190] "LuigiBiagini"    "ellis2013nz"     "ngil92"         
## [193] "PPackmohr"       "randyzwitch"     "Jacquelyn_Neal" 
## [196] "AnalyticsVidhya" "tmllr"           "SienaDuplan"    
## [199] "alice_data"      "daattali"        "chemstateric"   
## [202] "davidmasp"       "Remibacha"       "hannahyan"      
## [205] "MaarekClaire"    "ichbinjras"      "awhstin"        
## [208] "TunnelOfFire"    "dggoldst"        "yodacomplex"    
## [211] "sckottie"        "rOpenSci"        "datinci"        
## [214] "TATA_BOX"        "BigDataInsights" "EamonCaddigan"  
## [217] "owenjonesuob"    "hspter"          "najarvg"        
## [220] "askdrstats"      "MilesMcBain"     "anilopez"       
## [223] "statsforbios"    "rguha"           "NicholasStrayer"
## [226] "the18gen"        "GuillaumeLarocq" "MaryELennon"    
## [229] "Kwarizmi"        "gachisbar"       "nj_tierney"     
## [232] "lucazav"         "mjcavaretta"     "lpreding"       
## [235] "marcusborba"     "tjmahr"          "ArthurEnd"      
## [238] "tipsder"         "mattmayo13"      "LockeData"      
## [241] "genetics_blog"   "LatifOzkan7"     "Rap_Ecol"       
## [244] "ashiklom711"     "dacta_fr"        "00017843"       
## [247] "ASamuelRosa"     "mhiggins2000"    "cytel"          
## [250] "ozkesali"        "JCox_Ento"       "HighlandDataSci"
## [253] "RobBriersNapier" "Chuck_Moeller"   "jessenleon"     
## [256] "JacobAnhoej"     "MDFBasha"        "kdnuggets"      
## [259] "FabriceJaine"    "antoniosch"      "alexcipro"      
## [262] "SBarfort"        "boafamilia"      "marvinmilatz"   
## [265] "jcoenep"         "RLadiesQuito"    "RetweetedRajeev"
## [268] "rbukralia"       "wilkinshau"      "wild_ecology"   
## [271] "rpradeepmenon"   "BrunaLab"        "Nature_Ty"      
## [274] "tylerrinker"     "LeviABx"         "rbloggersBR"    
## [277] "RLadiesLA"       "sim_pod"         "ideaofhappiness"
## [280] "jherndon01"      "heyallisongray"  "znmeb"          
## [283] "DrMattCrowson"   "cjlortie"
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
##      user_id        name screen_name             location
## 1    5685812   boB Rudis    hrbrmstr Underground Cell #34
## 2 2167059661 Jenny Bryan  JennyBryan        Vancouver, BC
##                                                                                                                                                             description
## 1 Don't look at me…I do what he does—just slower. #rstats avuncular • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
## 2                                                                                   @rstudio, humane #rstats, statistics, @ropensci, teach @STAT545, on leave from @UBC
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE            8321           371          581 2007-05-01 14:04:24
## 2     FALSE           11148           524          469 2013-10-31 18:32:37
##   favourites_count utc_offset                  time_zone geo_enabled
## 1             9393     -14400 Eastern Time (US & Canada)       FALSE
## 2            18552     -25200 Pacific Time (US & Canada)        TRUE
##   verified statuses_count lang contributors_enabled is_translator
## 1     TRUE          66277   en                FALSE         FALSE
## 2    FALSE           8877   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   022330
## 2                  FALSE                   000000
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
## 2 http://pbs.twimg.com/profile_images/660978605606875137/s3YrJetD_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2 https://pbs.twimg.com/profile_images/660978605606875137/s3YrJetD_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2 http://pbs.twimg.com/profile_images/660978605606875137/s3YrJetD_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
## 2 https://pbs.twimg.com/profile_images/660978605606875137/s3YrJetD_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             94BD5A                       FFFFFF
## 2             ABB8C2                       000000
##   profile_sidebar_fill_color profile_text_color
## 1                     C0DFEC             333333
## 2                     000000             000000
##   profile_use_background_image default_profile default_profile_image
## 1                         TRUE           FALSE                 FALSE
## 2                        FALSE           FALSE                 FALSE
##                                            profile_banner_url
## 1    https://pbs.twimg.com/profile_banners/5685812/1398248552
## 2 https://pbs.twimg.com/profile_banners/2167059661/1442682715
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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week12/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="100%" />




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
