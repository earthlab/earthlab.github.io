---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-10-16'
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



```r
# when you do this, it
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)

# get wd
file_name <- file.path(getwd(), "earth_analytics_twitter_token.rds")
## save token to home directory
saveRDS(twitter_token, file = file_name)
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
##    screen_name            user_id          created_at          status_id
## 1 rweekly_live 844152803991994368 2017-10-16 23:12:04 920064830714859525
## 2   mjfrigaard          314845003 2017-10-16 23:10:50 920064520923488257
## 3    Tableteer            7888762 2017-10-16 23:02:35 920062445799931904
##                                                                                                                                           text
## 1                                                                     Data acquisition in R (1/4) #rstats #datascience https://t.co/gs3F25Cw5O
## 2 RT @hadleywickham: Another step in our ladder to make DBs as easy as possible to use from #rstats: high qual drivers for commercial dbs htt…
## 3                                RT @Rbloggers: Can we use B-splines to generate non-linear data? https://t.co/yo03dWoZL4 #rstats #DataScience
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2            34              0           FALSE            <NA>       TRUE
## 3             6              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1               <NA>                         <NA>
## 2 919963690773942274                         <NA>
## 3 919953542957318145                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   it
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                source media_id media_url media_url_expanded urls
## 1       R Weekly Live     <NA>      <NA>               <NA> <NA>
## 2  Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 3 Twitter for Android     <NA>      <NA>               <NA> <NA>
##           urls_display                urls_expanded mentions_screen_name
## 1 link.rweekly.org/6lb https://link.rweekly.org/6lb                 <NA>
## 2                 <NA>                         <NA>        hadleywickham
## 3      wp.me/pMm6L-EzH      https://wp.me/pMm6L-EzH            Rbloggers
##   mentions_user_id symbols           hashtags coordinates place_id
## 1             <NA>      NA rstats datascience          NA     <NA>
## 2         69133574      NA             rstats          NA     <NA>
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
##     screen_name            user_id          created_at          status_id
## 1  rweekly_live 844152803991994368 2017-10-16 23:12:04 920064830714859525
## 2 PeterFlomStat          138815908 2017-10-16 23:00:57 920062033902624769
##                                                                                     text
## 1               Data acquisition in R (1/4) #rstats #datascience https://t.co/gs3F25Cw5O
## 2 How user friendly should statistical software be? #rstats #SAS https://t.co/fEOi5W8aci
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   it
## 2                       <NA>                           <NA>   en
##          source media_id media_url media_url_expanded urls
## 1 R Weekly Live     <NA>      <NA>               <NA> <NA>
## 2     Hootsuite     <NA>      <NA>               <NA> <NA>
##           urls_display                urls_expanded mentions_screen_name
## 1 link.rweekly.org/6lb https://link.rweekly.org/6lb                 <NA>
## 2    ow.ly/SrtP30fx8St     http://ow.ly/SrtP30fx8St                 <NA>
##   mentions_user_id symbols           hashtags coordinates place_id
## 1             <NA>      NA rstats datascience          NA     <NA>
## 2             <NA>      NA         rstats SAS          NA     <NA>
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
## [1] "rweekly_live"  "PeterFlomStat" "peterflom"     "dmi3k"        
## [5] "rweekly_live"  "DerFredo"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "rweekly_live"    "PeterFlomStat"   "peterflom"      
##   [4] "dmi3k"           "DerFredo"        "orchid00"       
##   [7] "theotheredgar"   "ImDataScientist" "RosanaFerrero"  
##  [10] "mrhunsaker"      "Rbloggers"       "AntoViral"      
##  [13] "AriLamstein"     "jtrnyc"          "PetrelStation"  
##  [16] "JeanVAdams"      "LearnRinaDay"    "joeydm"         
##  [19] "CRANberriesFeed" "Gui42"           "dccc_phd"       
##  [22] "blebeau11"       "RanaeDietzel"    "AwfulDodger"    
##  [25] "IndoorEcology"   "ClausWilke"      "NostraKosher"   
##  [28] "MicheleTobias"   "michaelhoffman"  "lnalborczyk"    
##  [31] "Hao_and_Y"       "abresler"        "Cruz_Julian_"   
##  [34] "AndriyGazin"     "kdnuggets"       "TrevorHPaulsen" 
##  [37] "anthonytowry"    "davina_hill"     "nubededatos"    
##  [40] "Kwarizmi"        "willems_karlijn" "rstatsdata"     
##  [43] "lobrowR"         "sjewor"          "HighlandDataSci"
##  [46] "dataandme"       "kyle_e_walker"   "pommedeterre33" 
##  [49] "AFS_Students"    "ian_prc"         "CardiffRUG"     
##  [52] "tmllr"           "whymandesign"    "jkregenstein"   
##  [55] "Turner1Jonny"    "our_codingclub"  "claytonyochum"  
##  [58] "jon_c_silva"     "sewestrick"      "benj_robinson"  
##  [61] "daattali"        "rctatman"        "Torontosj"      
##  [64] "TransmitScience" "mdancho84"       "cjlortie"       
##  [67] "thomasp85"       "hadleywickham"   "revodavid"      
##  [70] "whatsgoodio"     "IrvSeq"          "MangoTheCat"    
##  [73] "moritzkoerber"   "Sheffield_R_"    "BigDataInsights"
##  [76] "d4tagirl"        "thinkR_fr"       "AnalyticsVidhya"
##  [79] "RLangTip"        "rstudiotips"     "LuisDVerde"     
##  [82] "lgnbhl"          "JennyBryan"      "saouderkirk"    
##  [85] "dsacademybr"     "kierisi"         "mgaldino"       
##  [88] "rOpenSci"        "sellorm"         "nwstephens"     
##  [91] "meisshaily"      "clasticdetritus" "polesasunder"   
##  [94] "ScientistJake"   "TrestleJeff"     "OilGains"       
##  [97] "awhstin"         "vinuct"          "SteffLocke"     
## [100] "CurtBurk"        "Pillolaio"       "datascienceplus"
## [103] "BradleyJEck"     "philrufin"       "HumboldtRemSens"
## [106] "Stephen8Vickers" "kklmmr"          "bradleyboehmke" 
## [109] "wesmckinn"       "RLadiesLivUK"    "ido87"          
## [112] "JMateosGarcia"   "joelgombin"      "DavidZumbach"   
## [115] "thonoir"         "conormacd"       "lfgilroy"       
## [118] "DataDrivenEcon"  "jazzejay_"       "precariobecario"
## [121] "HoloMarkeD"      "joedgallagher"   "bizScienc"      
## [124] "JarbaloJardine"  "ConnorKP"        "jonmcalder"     
## [127] "dj_shaily"       "olyerickson"     "noticiasSobreR" 
## [130] "_ColinFay"       "eodaGmbH"        "riccardoras"    
## [133] "ameisen_strasse" "adamhsparks"     "benmarwick"     
## [136] "pboesu"          "pol_ferrando"    "alinedeschamps" 
## [139] "Displayrr"       "planktoncounter" "geodatascience" 
## [142] "FarRider"        "JiuJitsuLab"     "JessKasza"      
## [145] "joe_thorley"     "acalatr"         "axiomsofxyz"    
## [148] "lenkiefer"       "zentree"         "t_s_institute"  
## [151] "BeardedApathy"   "STEMxicanEd"     "benrfitzpatrick"
## [154] "andrewheiss"     "v_vashishta"     "Bigdatahires"   
## [157] "henrikbengtsson" "RABigdatajobs"   "JGreenbrookHeld"
## [160] "_Jack_FG"        "stefanvdwalt"    "znmeb"          
## [163] "R_Forwards"      "Bud_T"           "TimSalabim3"    
## [166] "keithseru"       "8bitscollider"   "Doctor_Dick_MD" 
## [169] "pbaumgartner"    "HaleForster"     "RLadiesAU"      
## [172] "iprophage"       "czeildi"         "krisshaffer"    
## [175] "WinVectorLLC"    "DataScienceInR"  "masquesig"      
## [178] "JohnMillerTX"    "Rfunction_a_day" "joe_litt"       
## [181] "AdiePrestone"    "McAdam_lab"      "stuff_kali"     
## [184] "gp_pulipaka"     "realDevineni"    "bass_analytics" 
## [187] "Rexercises"      "gdbassett"       "aruhil"         
## [190] "Alexkvienna"     "rgiordano79"     "WireMonkey"     
## [193] "jscarto"         "carlcarrie"      "sharon000"      
## [196] "Dhabolt"         "torkildl"        "ucfagls"        
## [199] "toates_19"       "paulvanderlaken" "ahmedjr_16"     
## [202] "lumbininep"      "embubiz"         "RLadiesTbilisi" 
## [205] "danilobzdok"     "DataBzh"         "datentaeterin"  
## [208] "LeviWaldron1"    "RBirdPersons"    "GBDevUX"        
## [211] "jblefevre60"     "PaulLantos"      "stephenaramsey" 
## [214] "MDubins"         "VRaoRao"         "tylermorganwall"
## [217] "ellis2013nz"     "Srirama_Sri"     "tipsder"        
## [220] "haozhu233"       "kristenobacter"  "ScientistTrump" 
## [223] "hughparsonage"   "wajdi_bs"        "denishaine"     
## [226] "TropPlantPathol" "Triamus1"        "sjgknight"      
## [229] "b23kelly"        "Schw4rzR0tG0ld"  "Zalazhar"       
## [232] "DaveOnData"      "gbwanderson"     "BenDilday"      
## [235] "ElinWaring"      "matthague1"      "CarlJParker"    
## [238] "vijay_ivaturi"   "benjaminlmoore"  "lisachwinter"   
## [241] "bhaskar_vk"      "timtrice"        "unsorsodicorda" 
## [244] "SmartITcompany"  "nickteff"        "TermehKousha"   
## [247] "CSchmert"        "ecotrombonegal"  "snoylnimajneb"  
## [250] "RLadiesOrlando"  "alexhanna"       "tomaz_tsql"     
## [253] "JanMulkens"      "SanghaChick"     "Zecca_Lehn"     
## [256] "msarsar"         "LynnetteKTaylor" "privlko"        
## [259] "minebocek"       "JRBerrendero"    "tonmcg"         
## [262] "Gaming_Dude"     "RLadiesMAD"      "Thoughtfulnz"   
## [265] "lemur78"         "xmacex"          "DavoOZ"
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
##     user_id        name screen_name             location
## 1 517921400 Leah Wasser LeahAWasser    Boulder, Colorado
## 2   5685812   boB Rudis    hrbrmstr Underground Cell #34
##                                                                                                                                                                                      description
## 1 Director, Earth Analytics Education @CUBoulder @EarthLabcu #remoteSensing #ecology #data #openScience #GIS #rstats #education \n\U0001f49c\U0001f49c Mountain Ultra Trail \U0001f49c\U0001f49c
## 2                          Don't look at me…I do what he does—just slower. #rstats avuncular • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE            1278          1023          125 2012-03-07 20:42:07
## 2     FALSE            8786           394          596 2007-05-01 14:04:24
##   favourites_count utc_offset                   time_zone geo_enabled
## 1             2347     -21600 Mountain Time (US & Canada)       FALSE
## 2            10278     -14400  Eastern Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           3693   en                FALSE         FALSE
## 2     TRUE          68960   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   000000
## 2                  FALSE                   022330
##                                                     profile_background_image_url
## 1                               http://abs.twimg.com/images/themes/theme8/bg.gif
## 2 http://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
##                                                profile_background_image_url_https
## 1                               https://abs.twimg.com/images/themes/theme8/bg.gif
## 2 https://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/895843973704466432/eBl5QwIb_normal.jpg
## 2 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/895843973704466432/eBl5QwIb_normal.jpg
## 2 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/895843973704466432/eBl5QwIb_normal.jpg
## 2 http://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/895843973704466432/eBl5QwIb_normal.jpg
## 2 https://pbs.twimg.com/profile_images/824974380803334144/Vpmh_s3x_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             981CEB                       000000
## 2             94BD5A                       FFFFFF
##   profile_sidebar_fill_color profile_text_color
## 1                     000000             000000
## 2                     C0DFEC             333333
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                         TRUE           FALSE                 FALSE
##                                           profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/517921400/1439854963
## 2   https://pbs.twimg.com/profile_banners/5685812/1398248552
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 327

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



```r
users %>% na.omit() %>%
  ggplot(aes(time_zone)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Time Zone",
      title="Twitter users - unique time zones ")
```

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
