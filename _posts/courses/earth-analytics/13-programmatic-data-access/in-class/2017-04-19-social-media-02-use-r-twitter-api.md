---
layout: single
title: "Twitter Data in R Using Rtweet: Analyze and Download Twitter Data"
excerpt: "You can use the Twitter RESTful API to access data about Twitter users and tweets. Learn how to use rtweet to download and analyze twitter social media data in R."
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-12-08'
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
##   screen_name    user_id          created_at          status_id
## 1   rmkubinec 4149978441 2017-12-08 16:33:40 939171126554648578
## 2    aarolsen  104518473 2017-12-08 16:31:33 939170594045734912
## 3     Ammer_B  114968487 2017-12-08 16:28:58 939169944683601922
##                                                                                                                                               text
## 1     One of the really nice things about doing #rstats with @mcmc_stan is that when you are building a model and you kno… https://t.co/pxN9Rg1Ejw
## 2    How to create an interactive visualization of animated 3D arrows using the R package #svgViewR #rstats #3Dviz\nHow-t… https://t.co/KQ0jKPtrxm
## 3 RT @TeebzR: Another cool #rstats data scientist job with @vaccineimpact in London. \n\nhttps://t.co/7uDgckn83L\n\n@RStatsJobs @RLadiesLondon @S…
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
## 3             3              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1               <NA>                         <NA>
## 2               <NA>                         <NA>
## 3 939100795756335105                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 3 Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                  urls_display
## 1 twitter.com/i/web/status/9…
## 2 twitter.com/i/web/status/9…
## 3  jobs.ac.uk/job/BGG849/sen…
##                                                                           urls_expanded
## 1                                   https://twitter.com/i/web/status/939171126554648578
## 2                                   https://twitter.com/i/web/status/939170594045734912
## 3 http://www.jobs.ac.uk/job/BGG849/senior-r-developer-data-scientist-technical-support/
##                            mentions_screen_name
## 1                                     mcmc_stan
## 2                                          <NA>
## 3 TeebzR vaccineimpact RStatsJobs RLadiesLondon
##                                             mentions_user_id symbols
## 1                                                 1175299088      NA
## 2                                                       <NA>      NA
## 3 1408449174 862680370436874240 273824942 722588617231769601      NA
##                hashtags coordinates place_id place_type place_name
## 1                rstats          NA     <NA>       <NA>       <NA>
## 2 svgViewR rstats 3Dviz          NA     <NA>       <NA>       <NA>
## 3                rstats          NA     <NA>       <NA>       <NA>
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
## 1   rmkubinec 4149978441 2017-12-08 16:33:40 939171126554648578
## 2    aarolsen  104518473 2017-12-08 16:31:33 939170594045734912
##                                                                                                                                            text
## 1  One of the really nice things about doing #rstats with @mcmc_stan is that when you are building a model and you kno… https://t.co/pxN9Rg1Ejw
## 2 How to create an interactive visualization of animated 3D arrows using the R package #svgViewR #rstats #3Dviz\nHow-t… https://t.co/KQ0jKPtrxm
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
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                  urls_display
## 1 twitter.com/i/web/status/9…
## 2 twitter.com/i/web/status/9…
##                                         urls_expanded mentions_screen_name
## 1 https://twitter.com/i/web/status/939171126554648578            mcmc_stan
## 2 https://twitter.com/i/web/status/939170594045734912                 <NA>
##   mentions_user_id symbols              hashtags coordinates place_id
## 1       1175299088      NA                rstats          NA     <NA>
## 2             <NA>      NA svgViewR rstats 3Dviz          NA     <NA>
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
## [1] "rmkubinec"  "aarolsen"   "RLadiesTC"  "RLadiesTC"  "aurelberra"
## [6] "atiretoo"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "rmkubinec"       "aarolsen"        "RLadiesTC"      
##   [4] "aurelberra"      "atiretoo"        "janellehajjar"  
##   [7] "ZKamvar"         "Cruz_Julian_"    "ClaytonTLamb"   
##  [10] "Rbloggers"       "gpavolini"       "apreshill"      
##  [13] "heyallisongray"  "seabbs"          "peterwsetter"   
##  [16] "rOpenSci"        "rtweet_pkg"      "G_Thirel"       
##  [19] "BDataScientist"  "datascigeek"     "RonGuymon"      
##  [22] "CRANberriesFeed" "AppsilonDS"      "armaninspace"   
##  [25] "ImDataScientist" "noamross"        "bretsw"         
##  [28] "DerFredo"        "Chandanrtcs"     "nitzrulzx412"   
##  [31] "DeepakTaneja86"  "KirstyElliphant" "ReactDOM"       
##  [34] "duke_data"       "rweekly_live"    "showmeshiny"    
##  [37] "Data_Sue_ATX"    "dataandme"       "thinkR_fr"      
##  [40] "sinarueeger"     "Intelisolutions" "ma_salmon"      
##  [43] "TeebzR"          "Zoe_M_Harris"    "XavierCoadic"   
##  [46] "czechcuckoolab"  "heikomiertzsch"  "SteffLocke"     
##  [49] "vaccineimpact"   "AntoViral"       "eodaGmbH"       
##  [52] "hivemindatwork"  "kenbenoit"       "statsforbios"   
##  [55] "abdnStudyGroup"  "olga_mie"        "GrahamIMac"     
##  [58] "G_Devailly"      "meabhmacmahon"   "kierisi"        
##  [61] "WildlifeSci"     "guangchuangyu"   "CardiffRUG"     
##  [64] "ahmedjr_16"      "FelipeSMBarros"  "TweetHerath"    
##  [67] "ParallelRecruit" "xslates"         "mmznr"          
##  [70] "jetrubyagency"   "aliraiser"       "Raymundo_Pardal"
##  [73] "EvaMaeRey"       "elpidiofilho"    "AStavrakoudis"  
##  [76] "t_s_institute"   "useR_Brussels"   "LynxPro_UK"     
##  [79] "_ColinFay"       "koot_htw_aalen"  "RosanaFerrero"  
##  [82] "vsuarezlledo"    "humeursdevictor" "PatrickStotz"   
##  [85] "Melanie_Smuk"    "confabulatus"    "marvinmilatz"   
##  [88] "strengejacke"    "KKulma"          "AedinCulhane"   
##  [91] "shazanfar"       "janeshdev"       "wmlandau"       
##  [94] "scimirrorbot"    "Ananna16"        "mmmpork"        
##  [97] "o365cloudexpert" "freesharepoint"  "yasmeen_wilson" 
## [100] "tonmcg"          "TheRealEveret"   "SoleneDerville" 
## [103] "ImADataGuy"      "CZAR__KING"      "markdly_"       
## [106] "neilfws"         "MattAshton81"    "clarkfitzg"     
## [109] "joe_r_Odonnell"  "zabormetrics"    "eramirez"       
## [112] "tipsder"         "ileadgen"        "abresler"       
## [115] "kizza_a"         "abtran"          "Zecca_Lehn"     
## [118] "MikeKSmith"      "sctyner"         "jdatap"         
## [121] "MustardBethan"   "watershedwillis" "eSURETY"        
## [124] "millard_joe"     "EconAndrew"      "msarsar"        
## [127] "Talent_metrics"  "payaaru"         "kaneplusplus"   
## [130] "RstatsNE"        "revodavid"       "tdawry"         
## [133] "dgkeyes"         "RLadiesELansing" "axiomsofxyz"    
## [136] "AriLamstein"     "HeathrTurnr"     "DapperStats"    
## [139] "PyData"          "LearnRinaDay"    "drkirmani"      
## [142] "appupio"         "Hill_JasonM"     "tomfinch89"     
## [145] "kyle_e_walker"   "RLadiesSantiago" "robertskeril"   
## [148] "odeleongt"       "Jadirectivestwt" "joe_thorley"    
## [151] "jessenleon"      "JanMulkens"      "ChelseaParlett" 
## [154] "UtahRUG"         "aquakora"        "tim__kiely"     
## [157] "datascienceplus" "mikedelgado"     "jyazman2012"    
## [160] "ismaelgomezs"    "eleafeit"        "LeviABx"        
## [163] "rstatsdata"      "tangming2005"    "sckottie"       
## [166] "VincentGuyader"  "abiyugiday"      "DataIns8tsCloud"
## [169] "Wes_Port"        "M_Kosilo"        "EllenMellon_88" 
## [172] "frod_san"        "NabilSdhu"       "rguha"          
## [175] "jakethomp"       "RSTurner16"      "nacnudus"       
## [178] "yobrenoops"      "randyzwitch"     "kearneymw"      
## [181] "RLangTip"        "useless_ulysses" "jtrnyc"         
## [184] "bfgray3"         "Bruno__Vilela"   "petolauri"      
## [187] "mhawksey"        "jrosenberg6432"  "DataWookie"     
## [190] "spgreenhalgh"    "axelrod_eric"    "digr_io"        
## [193] "RLadiesSarasota" "AvrahamAdler"    "Himmie_He"      
## [196] "asayeed"         "BarkleyBG"       "ElCep"          
## [199] "nihilist_ds"     "Aarleks"         "rmounce"        
## [202] "cdr6934"         "emilynordmann"   "pachamaltese"   
## [205] "bizScienc"       "lucatero_diana"  "OthonHerrera"   
## [208] "nathcun"         "MangoTheCat"     "Nujcharee"      
## [211] "datentaeterin"   "dmi3k"           "DataScienceInR" 
## [214] "WinVectorLLC"    "hipster_79"      "cecilialeehs"   
## [217] "tfkohler"        "jamessandberg"   "Datasaurs"      
## [220] "IKosmidis_"      "d_alburez"       "paavopdf"       
## [223] "krlmlr"          "gvegayon"        "chrbknudsen"    
## [226] "nickholway"      "Vinny_Davies89"  "sharonlflynn"   
## [229] "stephanenardin"  "AchimZeileis"    "drewvid"        
## [232] "RLadiesGlobal"   "lumbininep"      "gombang"        
## [235] "InfonomicsToday" "aksingh1985"     "RConsortium"    
## [238] "fmarin_ES"       "simonbuskens"    "kosinski_rblog" 
## [241] "thanhtungmilan"  "KirkDBorne"      "babainxs"       
## [244] "phoebewong2012"  "MDMGeek"         "meisshaily"     
## [247] "hrbrmstr"        "gmikros"         "dccc_phd"       
## [250] "BigDataGuyJ3D"   "jmertic"         "Tomeopaste"     
## [253] "mauro_lepore"    "feralaes"        "eddelbuettel"   
## [256] "rmflight"        "loellen_c"       "NickDoesData"   
## [259] "danielequs"      "recleev"         "exunckly"       
## [262] "marshprincess"   "hypercompetent"  "LeafyEricScott" 
## [265] "erictleung"      "skunkcabbages"   "triciaaung"     
## [268] "RichieLenne"     "CougRstats"      "azstrata"       
## [271] "rob_choudhury"   "SpinyDag"        "Roisin_White__" 
## [274] "NumFOCUS"        "tomdireill"      "JamesBellOcean" 
## [277] "isomorphisms"    "jdossgollin"     "Cyberskout99"   
## [280] "bibaswanghoshal" "DirkSchaar"      "zentree"        
## [283] "paulvanderlaken" "art_poon"        "peterbijkerk"   
## [286] "MarkShadden1"    "kwbroman"        "petemohanty"    
## [289] "kstierhoff"      "NicoloGiso"      "gavg712"        
## [292] "ewen_"           "ericmranderson"  "DavidJohnBaker" 
## [295] "SvenAT"          "ClementCharles"  "IyueSung"       
## [298] "DrChavaZ"        "EnvReportBC"
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
##      user_id                 name screen_name      location
## 1 3230388598         Mara Averick   dataandme Massachusetts
## 2  229564414 Mine CetinkayaRundel   minebocek    Durham, NC
##                                                                                                                                                                                                description
## 1 tidyverse dev advocate @rstudio\n\n#rstats, #datanerd, #civictech \U0001f496er, \U0001f3c0 stats junkie, using #data4good (&or \U0001f947 fantasy sports), lesser ½ of @batpigandme \U0001f987\U0001f43d
## 2                                                        Duke + @rstudio, #rstats, data, visualization, #statsed, co-founder #RLadies RTP, @OpenIntroOrg, @citizenstat. also, cat videos = instant smiles.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE           18200          2945         1133 2015-05-03 11:44:15
## 2     FALSE            4765           426          191 2010-12-22 18:45:58
##   favourites_count utc_offset                  time_zone geo_enabled
## 1            55890     -18000 Eastern Time (US & Canada)       FALSE
## 2             4303     -18000                      Quito        TRUE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE          22192   en                FALSE         FALSE
## 2    FALSE           2430   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   000000
## 2                  FALSE                   9DC6D8
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
## 2 http://pbs.twimg.com/profile_images/613153826200121345/uQfFlEZQ_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 https://pbs.twimg.com/profile_images/613153826200121345/uQfFlEZQ_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 http://pbs.twimg.com/profile_images/613153826200121345/uQfFlEZQ_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 https://pbs.twimg.com/profile_images/613153826200121345/uQfFlEZQ_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             1B95E0                       000000
## 2             7DA1BF                       000000
##   profile_sidebar_fill_color profile_text_color
## 1                     000000             000000
## 2                     000000             000000
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                        FALSE           FALSE                 FALSE
##                                            profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/3230388598/1482490217
## 2  https://pbs.twimg.com/profile_banners/229564414/1507977054
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
      labs(x = "Count",
      y = "Location",
      title = "Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="90%" />

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="90%" />

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
