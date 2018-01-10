---
layout: single
title: "Twitter Data in R Using Rtweet: Analyze and Download Twitter Data"
excerpt: "You can use the Twitter RESTful API to access data about Twitter users and tweets. Learn how to use rtweet to download and analyze twitter social media data in R."
authors: ['Leah Wasser','Carson Farmer']
modified: '2018-01-10'
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
* Generate a list of users who are tweeting about a particular topic.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>


In this lesson you will explore analyzing social media data accessed from twitter,
in R. You  will use the Twitter RESTful API to access data about both twitter users
and what they are tweeting about

## Getting Started

To get started you'll need to do the following things:

1. Set up a twitter account if you don't have one already.
2. Using your account, setup an application that you will use to access twitter from R
3. Download and install the `rtweet` and `tidytext` packages for R.

Once you've done these things, you are ready to begin querying Twitter's API to
see what you can learn about tweets!

## Set up Twitter App

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

Once you have your twitter app setup, you are ready to dive into accessing tweets in `R`.

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






The first thing that you need to setup in your code is your authentication. When
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

### Send a Tweet

Note that your tweet needs to be 140 characters or less.


```r
# post a tweet from R
post_tweet("Look, i'm tweeting from R in my #rstats #earthanalytics class!")
## your tweet has been posted!
```

### Search Twitter for Tweets

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
##       screen_name   user_id          created_at          status_id
## 1 LuckyStrike1984  93801333 2018-01-10 22:57:50 951226606747561984
## 2   renato_umeton  31367101 2018-01-10 22:56:42 951226322117955584
## 3   itknowingness 213339721 2018-01-10 22:55:03 951225904046526464
##                                                                                                                                              text
## 1 RT @walkingrandomly: x=seq(-2,2,0.001)\ny=Re((sqrt(cos(x))*cos(200*x)+sqrt(abs(x))-0.7)*(4-x*x)^0.01)\nplot(x,y)\n#rstats https://t.co/trpgEnN…
## 2                                                RT @Rbloggers: Direct forecast X Recursive forecast https://t.co/tGLPqglRD3 #rstats #DataScience
## 3                                                RT @Rbloggers: Direct forecast X Recursive forecast https://t.co/tGLPqglRD3 #rstats #DataScience
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1            36              0           FALSE            <NA>       TRUE
## 2             2              0           FALSE            <NA>       TRUE
## 3             2              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1 696747727909093378                         <NA>
## 2 951225902259679233                         <NA>
## 3 951225902259679233                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                  source media_id media_url media_url_expanded urls
## 1    Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 2        rtapp315156161     <NA>      <NA>               <NA> <NA>
## 3 ttools it knowingness     <NA>      <NA>               <NA> <NA>
##      urls_display           urls_expanded mentions_screen_name
## 1            <NA>                    <NA>      walkingrandomly
## 2 wp.me/pMm6L-F4y https://wp.me/pMm6L-F4y            Rbloggers
## 3 wp.me/pMm6L-F4y https://wp.me/pMm6L-F4y            Rbloggers
##   mentions_user_id symbols           hashtags coordinates place_id
## 1         92746008      NA             rstats          NA     <NA>
## 2        144592995      NA rstats DataScience          NA     <NA>
## 3        144592995      NA rstats DataScience          NA     <NA>
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
followers can see it. It is similar to sharing in Facebook where you can add a
quote or text above the retweet if you want or just share the post. Let's use
the same query that you used above but this time ignore all retweets by setting
the `include_rts` argument to `FALSE`. You can get tweet / retweet stats from
your dataframe, separately.


```r
# find recent tweets with #rstats but ignore retweets
rstats_tweets <- search_tweets("#rstats", n = 500,
                             include_rts = FALSE)
# view top 2 rows of data
head(rstats_tweets, n = 2)
##     screen_name   user_id          created_at          status_id
## 1     Rbloggers 144592995 2018-01-10 22:55:02 951225902259679233
## 2 guangchuangyu  20828110 2018-01-10 22:54:10 951225682578821127
##                                                                                                        text
## 1                         Direct forecast X Recursive forecast https://t.co/tGLPqglRD3 #rstats #DataScience
## 2 custom background list for ReactomePA https://t.co/o51G2edp82 https://t.co/4guwmJBYKw #reactomepa #rstats
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             2              0           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##           source media_id media_url media_url_expanded urls
## 1 r-bloggers.com     <NA>      <NA>               <NA> <NA>
## 2          IFTTT     <NA>      <NA>               <NA> <NA>
##                    urls_display
## 1               wp.me/pMm6L-F4y
## 2 ift.tt/2Di8hsq ift.tt/1ZjPYGD
##                                 urls_expanded mentions_screen_name
## 1                     https://wp.me/pMm6L-F4y                 <NA>
## 2 http://ift.tt/2Di8hsq http://ift.tt/1ZjPYGD                 <NA>
##   mentions_user_id symbols           hashtags coordinates place_id
## 1             <NA>      NA rstats DataScience          NA     <NA>
## 2             <NA>      NA  reactomepa rstats          NA     <NA>
##   place_type place_name place_full_name country_code country
## 1       <NA>       <NA>            <NA>         <NA>    <NA>
## 2       <NA>       <NA>            <NA>         <NA>    <NA>
##   bounding_box_coordinates bounding_box_type
## 1                     <NA>              <NA>
## 2                     <NA>              <NA>
```

Next, let's figure out who is tweeting about `R` using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "Rbloggers"       "guangchuangyu"   "ImDataScientist" "LessCrime"      
## [5] "martinjhnhadley" "Rbloggers"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "Rbloggers"       "guangchuangyu"   "ImDataScientist"
##   [4] "LessCrime"       "martinjhnhadley" "hspter"         
##   [7] "tipsder"         "kierisi"         "dataandme"      
##  [10] "pscheid92"       "leila_etaati"    "Nujcharee"      
##  [13] "mauro_lepore"    "JidduAlexander"  "ludmila_janda"  
##  [16] "albz_marocchino" "CRANberriesFeed" "LearnRinaDay"   
##  [19] "rweekly_live"    "devlintufts"     "zentree"        
##  [22] "mementonature"   "edelponte"       "annakasdan"     
##  [25] "mattwilkinsbio"  "DerFredo"        "ma_salmon"      
##  [28] "MikeRSpencer"    "statstools"      "jtrnyc"         
##  [31] "bettytalknerdy"  "AriLamstein"     "maxheld"        
##  [34] "NovasTaylor"     "mackfinkel"      "RLadiesNYC"     
##  [37] "thosjleeper"     "benmarwick"      "StefanieButland"
##  [40] "sammydeprez"     "nataliemahara"   "KenSteif"       
##  [43] "EarthLabCU"      "tangming2005"    "Cruz_Julian_"   
##  [46] "taavipall"       "swansea_r"       "travisgerke"    
##  [49] "DruidSmith"      "thanhtungmilan"  "osazuwa"        
##  [52] "joranelias"      "AppsilonDS"      "gjmount"        
##  [55] "Progressive_MA"  "lincolnmullen"   "cainesap"       
##  [58] "rstatsdata"      "jebyrnes"        "marinereilly"   
##  [61] "MorrisonLisbeth" "mtrost2"         "RebeccaNLewis"  
##  [64] "Gaming_Dude"     "SamuelJenness"   "lisafederer"    
##  [67] "rtelmore"        "AniMove"         "LeafyEricScott" 
##  [70] "ucfagls"         "FrancoisKeck"    "kklmmr"         
##  [73] "MatthewRenze"    "_ColinFay"       "statwonk"       
##  [76] "WarwickRUG"      "alex__morley"    "boxuancui"      
##  [79] "ZipperSam"       "pkqstr"          "microheather"   
##  [82] "neuromusic"      "FourMInfo"       "nielsberglund"  
##  [85] "danws7"          "paulvanderlaken" "BigDataInsights"
##  [88] "Jemus42"         "JMFradeRue"      "AnalyticsVidhya"
##  [91] "sharon000"       "d_mathlete"      "RLangTip"       
##  [94] "VascoElbrecht"   "thinkR_fr"       "anthonytowry"   
##  [97] "jarostat"        "_arnaudr"        "zevross"        
## [100] "jlisic"          "BradleyJEck"     "BroVic"         
## [103] "humeursdevictor" "j_ken95"         "henrikbengtsson"
## [106] "n_ashutosh"      "f_chiare"        "Ognyanova"      
## [109] "thonoir"         "bizScienc"       "eleafeit"       
## [112] "axiomsofxyz"     "pofigster"       "GeostatsGuy"    
## [115] "DesertIsleSQL"   "SimplyApprox"    "peterdalle"     
## [118] "njogukennly"     "sthda_en"        "moorejh"        
## [121] "jhollist"        "ecoevoenviro"    "juliasilge"     
## [124] "datascienceplus" "londonaesthetik" "bobehayes"      
## [127] "tjmahr"          "expersso"        "GarethNetto"    
## [130] "rushworth_a"     "blebeau11"       "OilGains"       
## [133] "murnane"         "hrbrmstr"        "Ed_pheasant"    
## [136] "Benavent"        "coraman"         "MikeTaylorSEMO" 
## [139] "ilustat"         "ingorohlfing"    "m4xl1n"         
## [142] "znmeb"           "f2harrell"       "jonclayden"     
## [145] "mdsumner"        "ixek"            "RLadiesPhilly"  
## [148] "LeNematode"      "mgvolz"          "moroam"         
## [151] "auth0"           "Jadirectivestwt" "ZarahPattison"  
## [154] "zx8754"          "jamesday87"      "DBNTechEvents"  
## [157] "Xtophe_Bontemps" "jananivijayan1"  "sqlsatvienna"   
## [160] "statsforbios"    "jetrubyagency"   "ParmutiaMakui"  
## [163] "deekareithi"     "msciain"         "datasetfree"    
## [166] "MattOldach"      "statlurker"      "marcbeldata"    
## [169] "cvonbastian"     "KevinWang009"    "lassehmadsen"   
## [172] "biobenkj"        "gombang"         "whatsgoodio"    
## [175] "forrestdougan"   "GVPhD"           "MikeTreglia"    
## [178] "ChristinZasada"  "tonmcg"          "acalatr"        
## [181] "John_deVillier"  "brodriguesco"    "ThomasSpeidel"  
## [184] "daattali"        "USGS_LMG"        "gdisney_melb"   
## [187] "jasonbaik94"     "bramasolo"       "translatedmed"  
## [190] "DeanLittle"      "TermehKousha"    "tetsuroito"     
## [193] "LuisDVerde"      "jrescalante"     "nlj"            
## [196] "mlandstat"       "brendankness"    "scottyd22"      
## [199] "orlandomezquita" "peterdavenport8" "d_joseph_parker"
## [202] "NicoleAlineData" "BrockTibert"     "monkmanmh"      
## [205] "chendaniely"     "spkaluzny"       "julianjon"      
## [208] "PlantLearner"    "StatStas"        "tjardine"       
## [211] "Benjaming_G"     "NickDoesData"    "_jwinget"       
## [214] "starryflo"       "nj_tierney"      "rudeboybert"    
## [217] "presidual"       "earowang"        "ReddTrain"      
## [220] "GojThomson"      "abresler"        "CasalsTMarti"   
## [223] "alspur"          "AedinCulhane"    "sellorm"        
## [226] "DJAnderson_07"   "Gui42"           "pabloc_ds"      
## [229] "mjhendrickson"   "adolfoalvarez"   "daniellequinn88"
## [232] "jbryer"          "paleolimbot"     "TheBIccountant" 
## [235] "gladwinmuchena"  "HFazelinia"      "madforsharks"   
## [238] "SwindleApe"      "lumbininep"      "dgkeyes"        
## [241] "_djli"           "Kwarizmi"        "dj_shaily"      
## [244] "NCrepalde"       "JohnBVincent"    "jdossgollin"    
## [247] "PyData"          "RLadiesQuito"    "TELLlab"        
## [250] "timelyportfolio" "revodavid"       "villasenor_jc"  
## [253] "hadleywickham"   "NumFOCUS"        "joshua_ulrich"  
## [256] "dccc_phd"        "abiyugiday"      "HansLive"       
## [259] "natedayta"       "gbasultoe"       "MineDogucu"     
## [262] "riverpeek"       "southerndsc"     "nolauren"       
## [265] "StatGarrett"     "Elmore_Ecology"  "GIST_ORNL"      
## [268] "thmscwlls"       "dpereira14"      "kwbroman"       
## [271] "JesseOPiburn"    "seabbs"          "AgentZeroNine"  
## [274] "StrictlyStat"    "robertstats"     "SteffLocke"     
## [277] "gokhan_ciflikli" "d8aninja"        "DWPDigital"     
## [280] "verajosemanuel"  "RR_Oxford"
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
##     user_id        name screen_name                              location
## 1 517921400 Leah Wasser LeahAWasser                     Boulder, Colorado
## 2 342250615    rOpenSci    rOpenSci Berkeley, Portland, Kamloops, Utrecht
##                                                                                                                                                                                        description
## 1 Director, Earth Analytics Education @CUBoulder @EarthLabcu #remoteSensing #ecology #openScience #GIS #rstats #python #education \n\U0001f49c\U0001f49c Mountain Ultra Trail \U0001f49c\U0001f49c
## 2                                           rOpenSci develops #rstats-based tools to facilitate open science and access to open data. Tweets by @sckottie,  @_inundata, @StefanieButland, @opencpu
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE            1579          1392          132 2012-03-07 20:42:07
## 2     FALSE           16560           508          719 2011-07-25 18:24:54
##   favourites_count utc_offset                   time_zone geo_enabled
## 1             2994     -25200 Mountain Time (US & Canada)       FALSE
## 2              875     -28800  Pacific Time (US & Canada)        TRUE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           4044   en                FALSE         FALSE
## 2     TRUE           3915   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   000000
## 2                  FALSE                   C0DEED
##                       profile_background_image_url
## 1 http://abs.twimg.com/images/themes/theme8/bg.gif
## 2 http://abs.twimg.com/images/themes/theme1/bg.png
##                  profile_background_image_url_https
## 1 https://abs.twimg.com/images/themes/theme8/bg.gif
## 2 https://abs.twimg.com/images/themes/theme1/bg.png
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/895843973704466432/eBl5QwIb_normal.jpg
## 2 http://pbs.twimg.com/profile_images/878348237496762368/yUU7Pefs_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/895843973704466432/eBl5QwIb_normal.jpg
## 2 https://pbs.twimg.com/profile_images/878348237496762368/yUU7Pefs_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/895843973704466432/eBl5QwIb_normal.jpg
## 2 http://pbs.twimg.com/profile_images/878348237496762368/yUU7Pefs_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/895843973704466432/eBl5QwIb_normal.jpg
## 2 https://pbs.twimg.com/profile_images/878348237496762368/yUU7Pefs_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             981CEB                       000000
## 2             1DA1F2                       C0DEED
##   profile_sidebar_fill_color profile_text_color
## 1                     000000             000000
## 2                     DDEEF6             333333
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                         TRUE            TRUE                 FALSE
##                                           profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/517921400/1439854963
## 2 https://pbs.twimg.com/profile_banners/342250615/1398878552
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 304

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x = "Count",
      y = "Location",
      title = "Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="90%" />

Let's sort by count and just plot the top locations. To do this you use top_n().
Note that in this case you are grouping your data by user. Thus top_n() will return
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

It looks like you have some `NA` or no data values in your list. Let's remove those
with `na.omit()`.


```r
users %>%
  count(location, sort = TRUE) %>%
  mutate(location = reorder(location,n)) %>%
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

Looking at your data, what do you notice that might improve this plot?
There are 314 unique locations in your list. However, everyone didn't specify their
locations using the approach. For example some just identified their country:
United States for example and others specified a city and state. You  may want to
do some cleaning of these data to be able to better plot this distribution - especially
if you want to create a map of these data!

### Users by Time Zone

Let's have a look at the time zone field next.




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge

Use the example above, plot users by time zone. List time zones that have at least
20 users associated with them. What do you notice about the data?
</div>

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="90%" />

The plots above aren't perfect. What do you start to notice about working
with these data? Can you simply download them and plot the data?

## Data munging  101

When you work with data from sources like NASA, USGS, etc. there are particular
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
