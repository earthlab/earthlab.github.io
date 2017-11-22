---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-22'
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
## 1    uow_bionet 3159552913 2017-11-22 20:19:05 933429651279458304
## 2 talkdatatomee 4690840926 2017-11-22 20:11:45 933427803550289920
## 3      FarRider    4022851 2017-11-22 20:11:42 933427791424606210
##                                                                                                                                           text
## 1 RT @ToCBDornottoCBD: Learning how to use #Rstats  - bye bye SPSS! Thanks @uow_bionet @UOW_CSES for supporting the workshop https://t.co/Jpt…
## 2           RT @DataCamp: New Course: Working with Dates and Times in R by @CVWickham! https://t.co/J6XZCjgXrh #rstats https://t.co/yoyxbCbMlo
## 3                                         #Docker tutorial for reproducible research with R.\n\n#rstats #DataScience \nhttps://t.co/lYkiRISmpw
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             3              0           FALSE            <NA>       TRUE
## 2             1              0           FALSE            <NA>       TRUE
## 3             0              0           FALSE            <NA>      FALSE
##    retweet_status_id in_reply_to_status_status_id
## 1 933161457973280768                         <NA>
## 2 933427582229458946                         <NA>
## 3               <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                source           media_id
## 1  Twitter for iPhone               <NA>
## 2           TweetDeck 933427404680384513
## 3 Twitter for Android               <NA>
##                                        media_url
## 1                                           <NA>
## 2 http://pbs.twimg.com/media/DPQzR2-W0AEeuBO.jpg
## 3                                           <NA>
##                                               media_url_expanded urls
## 1                                                           <NA> <NA>
## 2 https://twitter.com/DataCamp/status/933427582229458946/photo/1 <NA>
## 3                                                           <NA> <NA>
##                             urls_display
## 1                                   <NA>
## 2           datacamp.com/courses/workin…
## 3 ropenscilabs.github.io/r-docker-tutor…
##                                                        urls_expanded
## 1                                                               <NA>
## 2 https://www.datacamp.com/courses/working-with-dates-and-times-in-r
## 3                   http://ropenscilabs.github.io/r-docker-tutorial/
##                  mentions_screen_name                 mentions_user_id
## 1 ToCBDornottoCBD uow_bionet UOW_CSES 4382886205 3159552913 4516224193
## 2                  DataCamp CVWickham             1568606814 381642287
## 3                                <NA>                             <NA>
##   symbols                  hashtags coordinates place_id place_type
## 1      NA                    Rstats          NA     <NA>       <NA>
## 2      NA                    rstats          NA     <NA>       <NA>
## 3      NA Docker rstats DataScience          NA     <NA>       <NA>
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
## 1    FarRider    4022851 2017-11-22 20:11:42 933427791424606210
## 2    DataCamp 1568606814 2017-11-22 20:10:52 933427582229458946
##                                                                                                                   text
## 1                 #Docker tutorial for reproducible research with R.\n\n#rstats #DataScience \nhttps://t.co/lYkiRISmpw
## 2 New Course: Working with Dates and Times in R by @CVWickham! https://t.co/J6XZCjgXrh #rstats https://t.co/yoyxbCbMlo
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             1              1           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##                source           media_id
## 1 Twitter for Android               <NA>
## 2  Twitter Web Client 933427404680384513
##                                        media_url
## 1                                           <NA>
## 2 http://pbs.twimg.com/media/DPQzR2-W0AEeuBO.jpg
##                                               media_url_expanded urls
## 1                                                           <NA> <NA>
## 2 https://twitter.com/DataCamp/status/933427582229458946/photo/1 <NA>
##                             urls_display
## 1 ropenscilabs.github.io/r-docker-tutor…
## 2           datacamp.com/courses/workin…
##                                                        urls_expanded
## 1                   http://ropenscilabs.github.io/r-docker-tutorial/
## 2 https://www.datacamp.com/courses/working-with-dates-and-times-in-r
##   mentions_screen_name mentions_user_id symbols                  hashtags
## 1                 <NA>             <NA>      NA Docker rstats DataScience
## 2            CVWickham        381642287      NA                    rstats
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
## [1] "FarRider"        "DataCamp"        "nlmixr"          "jhnmxwll"       
## [5] "aschinchon"      "Jadirectivestwt"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "FarRider"        "DataCamp"        "nlmixr"         
##   [4] "jhnmxwll"        "aschinchon"      "Jadirectivestwt"
##   [7] "Cruz_Julian_"    "CRANberriesFeed" "_ColinFay"      
##  [10] "prosopis"        "extratp"         "RLadiesRio"     
##  [13] "s_newns92"       "dataandme"       "RallidaeRule"   
##  [16] "Elliot_Meador"   "wmhammond"       "ahmedjr_16"     
##  [19] "surlyurbanist"   "FanninQED"       "l_hansa"        
##  [22] "MDubins"         "peterdalle"      "rstatsdata"     
##  [25] "willems_karlijn" "brlockwood"      "UnderGardener1" 
##  [28] "carlcarrie"      "azadag"          "JasonAizkalns"  
##  [31] "RStudioJoe"      "jhollist"        "JennyBryan"     
##  [34] "ma_salmon"       "lucazav"         "dirk_sch"       
##  [37] "NumFOCUS"        "mjwalds"         "DerFredo"       
##  [40] "gvegayon"        "lobrowR"         "Jhovde2121"     
##  [43] "sjackman"        "Rbloggers"       "_ms03"          
##  [46] "EnvReportBC"     "TheSeaNikRoute"  "TiffanyTimbers" 
##  [49] "stadlmann_"      "j_garrettwalker" "InfluxDB"       
##  [52] "axiomsofxyz"     "ucfagls"         "reinforcelabtwt"
##  [55] "BigDataInsights" "ecojydrology"    "thinkR_fr"      
##  [58] "Josh_Ebner"      "RLangTip"        "datavisitor"    
##  [61] "MGCodesandStats" "data_cheeves"    "EikoFried"      
##  [64] "guangchuangyu"   "tylerrinker"     "DataScienceInR" 
##  [67] "WinVectorLLC"    "ChrisBeeley"     "henrikbengtsson"
##  [70] "ManuVrn"         "RanaeDietzel"    "CharliePerretti"
##  [73] "AmidstScience"   "daattali"        "tomhouslay"     
##  [76] "ecophiliajones"  "AnalyticsVidhya" "romain_francois"
##  [79] "jason_gilby"     "CivicAngela"     "MikeTreglia"    
##  [82] "mjfrigaard"      "MartinGarlovsky" "drob"           
##  [85] "tycbrad"         "UOLHEResearch"   "tdoyon"         
##  [88] "sthda_en"        "F1000Research"   "Emma_SXB"       
##  [91] "lonriesberg"     "fatma_cinar_ftm" "ingorohlfing"   
##  [94] "sharon000"       "WhatBehaviour"   "williamsanger"  
##  [97] "jtrnyc"          "Ipaneman"        "jelorias95"     
## [100] "witteveenlane"   "CardiffRUG"      "DataLabTR"      
## [103] "seabbs"          "v_vashishta"     "londonaesthetik"
## [106] "ImDataScientist" "TeebzR"          "milos_agathon"  
## [109] "IronistM"        "INWT_Statistics" "lumbininep"     
## [112] "urvashidbabaria" "rachitkinger"    "synaptogenesis_"
## [115] "JamesBellOcean"  "aksingh1985"     "recleev"        
## [118] "JeromyAnglim"    "leleedavid"      "RLadiesMAD"     
## [121] "walkingrandomly" "stephanenardin"  "robinlovelace"  
## [124] "elpidiofilho"    "R_Graph_Gallery" "d4t4v1z"        
## [127] "pa_chevalier"    "jonmcalder"      "jessenleon"     
## [130] "G_Devailly"      "AymericBds"      "Jimby19"        
## [133] "Hao_and_Y"       "gombang"         "gp_pulipaka"    
## [136] "Torsay"          "matrunich"       "JanMulkens"     
## [139] "RLadiesGlobal"   "rensa_co"        "michcampbell_"  
## [142] "d_olivaw"        "mixtrak"         "sfrechette"     
## [145] "enpiar"          "oMarceloVentura" "Quovantis"      
## [148] "timelyportfolio" "SanaBau"         "cityZenflagNews"
## [151] "KirkDBorne"      "lilscientista"   "hrbrmstr"       
## [154] "speegled"        "meisshaily"      "dccc_phd"       
## [157] "armaninspace"    "lisafederer"     "Edwards_evoeco" 
## [160] "ToCBDornottoCBD" "DavidZumbach"    "scottyd22"      
## [163] "anqi_fu"         "stefjacinto"     "pop_gen_JED"    
## [166] "apawlows"        "bkmnpol"         "Afro_Herper"    
## [169] "TheSladeLab"     "Georgia_0102"    "datascienceplus"
## [172] "DeadTreeDude"    "spoonbill_hank"  "datacarpentry"  
## [175] "old_man_chester" "dshkol"          "nathanjrt"      
## [178] "tommartens68"    "babeheim"        "realbluewagon"  
## [181] "DocGallJr"       "OilGains"        "TimothyMastny"  
## [184] "dataelixir"      "aquakora"        "gauravjain49"   
## [187] "jilly_mackay"    "NicholasStrayer" "paulapsobrino"  
## [190] "ChristinZasada"  "mikedelgado"     "DeCiccoDonk"    
## [193] "jknowles"        "cascadiarconf"   "NCrepalde"      
## [196] "annraiho"        "mysticstatistic" "sckottie"       
## [199] "oaggimenez"      "riverpeek"       "PyData"         
## [202] "jrcajide"        "sauer_sebastian" "mary_adwies"    
## [205] "annakrystalli"   "techXhum"        "zentree"        
## [208] "CRP_nature"      "biolabanalytics" "pdxrlang"       
## [211] "daroczig"        "Thoughtfulnz"    "danielequs"     
## [214] "FoxandtheFlu"    "OrrinEdenfield"  "alice_data"     
## [217] "fazepher"        "kwbroman"        "miishke"        
## [220] "MangoTheCat"     "MangoMattGlover" "_AntoineB"      
## [223] "JGreenbrookHeld" "richatmango"     "jdatap"         
## [226] "kearneymw"       "HighlandDataSci" "Zecca_Lehn"     
## [229] "storybench"      "InfonomicsToday" "pievarino"      
## [232] "pachamaltese"    "rOpenSci"        "DaSciDance"     
## [235] "FrancoisKeck"    "ByranSmucker"    "tmllr"          
## [238] "SuzanB_"         "LeahAWasser"     "janeshdev"      
## [241] "_neilch"         "AedinCulhane"    "revodavid"      
## [244] "JohnBVincent"    "pdalgd"          "LWpaulbivand"   
## [247] "Talent_metrics"  "CMastication"    "rweekly_live"   
## [250] "maximaformacion" "daniellequinn88" "rencontres_R"   
## [253] "philsf79"        "fredpolicarpo"   "TomTraubert2009"
## [256] "DarrinLRogers"   "LWylie_"         "thegoodphyte"   
## [259] "AlissaJ_Brown"   "markvdloo"       "d4tagirl"       
## [262] "robertstats"     "neilcharles_uk"  "LockeData"      
## [265] "sellorm"         "KirkegaardEmil"  "sqlsatvienna"   
## [268] "sqlpass_AT"      "benmarwick"      "kdnuggets"      
## [271] "fmic_"           "gabyfarries"     "pacocuak"       
## [274] "RLadiesLivUK"    "segasi"          "RCharlie425"    
## [277] "polesasunder"    "PhilippeLucarel" "brodriguesco"   
## [280] "Disha_SH_"       "jumping_uk"      "SwampThingPaul" 
## [283] "ctokelly"        "bkkkk"           "jati33o"        
## [286] "marinereilly"    "thosjleeper"     "zevross"        
## [289] "Megannzhang"     "LilithElina"     "murnane"        
## [292] "Nujcharee"       "scac1041"        "gorkemmeral"    
## [295] "tvganesh_85"     "thonoir"         "wb_research"    
## [298] "sinibara"        "WarwickRUG"      "chainsawriot"   
## [301] "tapundemek"      "SynBioAlex"      "vickythegme"    
## [304] "schnllr"         "DrNatalieKelly"  "expersso"       
## [307] "neilfws"
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
##      user_id         name screen_name      location
## 1 3230388598 Mara Averick   dataandme Massachusetts
## 2 2440258777 Jesse Maegan     kierisi    Dallas, TX
##                                                                                                                                                                                                description
## 1 tidyverse dev advocate @rstudio\n\n#rstats, #datanerd, #civictech \U0001f496er, \U0001f3c0 stats junkie, using #data4good (&or \U0001f947 fantasy sports), lesser ½ of @batpigandme \U0001f987\U0001f43d
## 2                                                                                                                                          https://t.co/ONQjXxQqV2 https://t.co/4C1erITZP4  #NetNeutrality
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE           17851          2951         1122 2015-05-03 11:44:15
## 2     FALSE            2620           499          196 2014-04-12 16:34:36
##   favourites_count utc_offset                  time_zone geo_enabled
## 1            54568     -18000 Eastern Time (US & Canada)       FALSE
## 2            14517     -21600 Central Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE          21677   en                FALSE         FALSE
## 2    FALSE           2891   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   000000
## 2                  FALSE                   000000
##                                                     profile_background_image_url
## 1                               http://abs.twimg.com/images/themes/theme1/bg.png
## 2 http://pbs.twimg.com/profile_background_images/640657768827871232/q5NEGbtV.png
##                                                profile_background_image_url_https
## 1                               https://abs.twimg.com/images/themes/theme1/bg.png
## 2 https://pbs.twimg.com/profile_background_images/640657768827871232/q5NEGbtV.png
##   profile_background_tile
## 1                   FALSE
## 2                    TRUE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 http://pbs.twimg.com/profile_images/835630946988736513/uKSeGfUO_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 https://pbs.twimg.com/profile_images/835630946988736513/uKSeGfUO_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 http://pbs.twimg.com/profile_images/835630946988736513/uKSeGfUO_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/812016485069680640/tKpsducS_normal.jpg
## 2 https://pbs.twimg.com/profile_images/835630946988736513/uKSeGfUO_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             1B95E0                       000000
## 2             19CF86                       000000
##   profile_sidebar_fill_color profile_text_color
## 1                     000000             000000
## 2                     000000             000000
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                         TRUE           FALSE                 FALSE
##                                            profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/3230388598/1482490217
## 2 https://pbs.twimg.com/profile_banners/2440258777/1503766072
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
