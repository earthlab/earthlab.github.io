---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-11-09'
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
##      screen_name    user_id          created_at          status_id
## 1    Tatjana_Kec   21197393 2017-11-09 22:37:44 928753498648403969
## 2 HannahDirector 2944187942 2017-11-09 22:36:47 928753262290862081
## 3    Tatjana_Kec   21197393 2017-11-09 22:34:37 928752716544987136
##                                                                                                                                                                text
## 1                      RT @b23kelly: My sister is looking for a spring internship or research experience #math #economics #rstats she's applying to grad schools a…
## 2                      RT @AedinCulhane: #rstats @Bioconductor Our dept is seeking undergraduates from low income, first generation college, minorities, disabilit…
## 3 RT @ma_salmon: Dear #rstats tweeps please webscrape responsibly to be a good citizen \U0001f607 &amp; to get zero legal issue \U0001f625. How? Read this post by…
##   retweet_count favorite_count is_quote_status    quote_status_id
## 1             3              0           FALSE               <NA>
## 2             8              0            TRUE 928319041588158464
## 3            16              0           FALSE               <NA>
##   is_retweet  retweet_status_id in_reply_to_status_status_id
## 1       TRUE 928635814162128896                         <NA>
## 2       TRUE 928677065477558273                         <NA>
## 3       TRUE 928572557871153152                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 2 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 3 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
##   urls_display urls_expanded      mentions_screen_name    mentions_user_id
## 1         <NA>          <NA>                  b23kelly  722471022704922624
## 2         <NA>          <NA> AedinCulhane Bioconductor 818903275 407200271
## 3         <NA>          <NA>                 ma_salmon          2865404679
##   symbols              hashtags coordinates place_id place_type place_name
## 1      NA math economics rstats          NA     <NA>       <NA>       <NA>
## 2      NA                rstats          NA     <NA>       <NA>       <NA>
## 3      NA                rstats          NA     <NA>       <NA>       <NA>
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
##   screen_name            user_id          created_at          status_id
## 1 CivicAngela 742379544309567489 2017-11-09 22:32:16 928752124393123840
## 2 MaryELennon         3016051375 2017-11-09 22:26:06 928750574333497345
##                                                                                                                                                    text
## 1 Folks, I got my act together and finally set up a personal website \U0001f389 (built on @xieyihui's #blogdown package!) Expe… https://t.co/D7AGQnH0BG
## 2                    Great ManchesteR meetup tonight! Talks on neural nets, reproducibility, and the limitations of #rstats in production. #DataScience
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              1           FALSE            <NA>      FALSE
## 2             0              1           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
##                source media_id media_url media_url_expanded urls
## 1  Twitter Web Client     <NA>      <NA>               <NA> <NA>
## 2 Twitter for Android     <NA>      <NA>               <NA> <NA>
##                  urls_display
## 1 twitter.com/i/web/status/9…
## 2                        <NA>
##                                         urls_expanded mentions_screen_name
## 1 https://twitter.com/i/web/status/928752124393123840             xieyihui
## 2                                                <NA>                 <NA>
##   mentions_user_id symbols           hashtags coordinates place_id
## 1         39010299      NA           blogdown          NA     <NA>
## 2             <NA>      NA rstats DataScience          NA     <NA>
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
## [1] "CivicAngela"  "MaryELennon"  "madforsharks" "jebyrnes"    
## [5] "dataandme"    "marcel_dmg"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "CivicAngela"     "MaryELennon"     "madforsharks"   
##   [4] "jebyrnes"        "dataandme"       "marcel_dmg"     
##   [7] "rOpenSci"        "spottheoutlier"  "hearkz"         
##  [10] "Dr_mcj"          "AdamGruer"       "NJBurgo"        
##  [13] "raphg"           "ixek"            "nimchuk"        
##  [16] "worldbankdata"   "cehagmann"       "thomasp85"      
##  [19] "CSJCampbell"     "coolbutuseless"  "expersso"       
##  [22] "kinseytedford"   "mdsumner"        "berdaniera"     
##  [25] "statsforbios"    "witteveenlane"   "rajcs4"         
##  [28] "jtrnyc"          "dirkvandenpoel"  "CRANberriesFeed"
##  [31] "NoorDinTech"     "ahmedjr_16"      "dccc_phd"       
##  [34] "juliesquid"      "DerFredo"        "JennyBryan"     
##  [37] "maximaformacion" "rgaiacs"         "InfonomicsToday"
##  [40] "JMFradeRue"      "noe11e__"        "Cruz_Julian_"   
##  [43] "Rbloggers"       "shoshievass"     "ledell"         
##  [46] "mauro_lepore"    "acgerstein"      "daattali"       
##  [49] "RLadiesLivUK"    "drob"            "RosanaFerrero"  
##  [52] "rstatsdata"      "c_bonsell"       "lobrowR"        
##  [55] "Robin_Mesnage"   "vuorre"          "surlyurbanist"  
##  [58] "G_Thirel"        "wjchulme"        "MikeKSmith"     
##  [61] "hi_em"           "joannaxwu"       "bearloga"       
##  [64] "TimAssal"        "alaynatokash"    "RobertMitchellV"
##  [67] "DavidGohel"      "bizScienc"       "AedinCulhane"   
##  [70] "d_olivaw"        "guangchuangyu"   "Lincoln81"      
##  [73] "LeviABx"         "noticiasSobreR"  "BigDataInsights"
##  [76] "chlalanne"       "Antoine__V"      "revodavid"      
##  [79] "hannahyan"       "globalizefm"     "RLangTip"       
##  [82] "groundwalkergmb" "dd_rookie"       "mattmayo13"     
##  [85] "leonawicz"       "rtelmore"        "sauer_sebastian"
##  [88] "pdalgd"          "DavidMcDou"      "thanhtungmilan" 
##  [91] "achompas"        "smllmp"          "robctuck"       
##  [94] "afmagee42"       "R_by_Ryo"        "ZKamvar"        
##  [97] "tladeras"        "ma_salmon"       "nierhoff"       
## [100] "kellyproof"      "hugobowne"       "MangoTheCat"    
## [103] "FarRider"        "infotroph"       "sckottie"       
## [106] "awhstin"         "JanStanstrup"    "b23kelly"       
## [109] "kklmmr"          "CSchmert"        "kyle_e_walker"  
## [112] "foundinblank"    "strnr"           "lemur78"        
## [115] "schluppeck"      "EJSbrocco"       "datascienceplus"
## [118] "ingorohlfing"    "MiguelCos"       "thinkR_fr"      
## [121] "ewen_"           "primesty22"      "zevross"        
## [124] "abresler"        "yoniceedee"      "regionomics"    
## [127] "ML_Nantes"       "ISOP1"           "FlorianZenoni"  
## [130] "meetup_r_nantes" "KirkDBorne"      "eodaGmbH"       
## [133] "WireMonkey"      "DennisMurray"    "nlmixr"         
## [136] "prof_rtpa"       "F1000Research"   "nj_tierney"     
## [139] "gabyfarries"     "brodriguesco"    "ParallelRecruit"
## [142] "SteffLocke"      "vivekbhr"        "brennanpcardiff"
## [145] "_ColinFay"       "deksta"          "FranLoew"       
## [148] "lucaborger"      "CardiffRUG"      "ThomasLClegg"   
## [151] "PsyBrief"        "ravikk"          "FreshwaterIzzy" 
## [154] "Kunkakom"        "filipwastberg"   "jrcajide"       
## [157] "AchimZeileis"    "JameseBowman"    "Nujcharee"      
## [160] "rgiordano79"     "DavidZenz"       "juli_schuess"   
## [163] "USC_Analytics"   "kdnuggets"       "new_sentry"     
## [166] "FootEnStats"     "potterzot"       "gp_pulipaka"    
## [169] "jody_tubi"       "lan24hd"         "neilfws"        
## [172] "vivalosburros"   "_julionovoa"     "SamAllocate"    
## [175] "lenkiefer"       "danwwilson"      "DJPMoore"       
## [178] "pete_cowman"     "sharon000"       "gdbassett"      
## [181] "gorafle"         "Blair09M"        "fletcherjherman"
## [184] "dataelixir"      "TheRealEveret"   "LeahAWasser"    
## [187] "drdesante"       "d8aninja"        "ibddoctor"      
## [190] "charlesminshew"  "henrikbengtsson" "ucfagls"        
## [193] "ImDataScientist" "zentree"         "AlexCEngler"    
## [196] "gatesdupont"     "DavidZumbach"    "MKJCKTZN"       
## [199] "recleev"         "katzkagaya"      "aimandel"       
## [202] "GeospatialUCD"   "andrewheiss"     "AnalyticsVidhya"
## [205] "sellorm"         "healthandstats"  "wb_research"    
## [208] "symbolixAU"      "eleakin775"      "debashis_dutta" 
## [211] "ikashnitsky"     "OilGains"        "cimentadaj"     
## [214] "Dannoflagellate" "tylerhoecker"    "DrGMerchant"    
## [217] "LuisDVerde"      "fhoces"          "ProfTucker"     
## [220] "alisonmarigold"  "algaraca"        "tommartens68"   
## [223] "SamRPJRoss"      "brad_weiner"     "hambue"         
## [226] "stephhazlitt"    "LazioB"          "RachelNiaHager" 
## [229] "jorgefabrega"    "gvegayon"        "rnomics"        
## [232] "jscarto"         "PeterBChi"       "edzerpebesma"   
## [235] "elpidiofilho"    "v_vashishta"     "Zecca_Lehn"     
## [238] "DataScienceLA"   "TanyaLMS"        "STEMxicanEd"    
## [241] "tangming2005"    "Roisin_White__"  "mishafredmeyer" 
## [244] "AriLamstein"     "antuki13"        "scottakenhead"  
## [247] "tipsder"         "annraiho"        "JARS3N"         
## [250] "jarvmiller"      "Jack_Simpson"    "mirallesjm"     
## [253] "schubtom"        "Timcdlucas"      "Voovarb"        
## [256] "apreshill"       "mkdyderski"      "LeafyEricScott" 
## [259] "MicheleTobias"   "r_metalheads"    "hoytemerson"    
## [262] "MaryHeskel"      "FJavierRubio1"   "RCharlie425"    
## [265] "NDTechUK"        "CougRstats"      "mjhendrickson"  
## [268] "lucazav"         "ashiklom711"     "gelliottmorris" 
## [271] "briansarnacki"   "kaelen_medeiros" "Carles_"        
## [274] "juliasilge"      "CaseyYoungflesh" "gkalinkat"      
## [277] "dj_shaily"       "Elias_Be"        "gumgumeo"       
## [280] "imtaraas"        "jamesfeigenbaum" "LeedsDataSoc"   
## [283] "old_man_chester" "canoodleson"     "ManningBooks"   
## [286] "ttso"            "Mooniac"         "robinson_es"    
## [289] "dvaughan32"      "Aerin_J"         "askdrstats"     
## [292] "chainsawriot"    "RicSchuster"     "fubits"         
## [295] "EllenEq"         "kobblumor"       "ISUBiomass"     
## [298] "NPilakouta"      "eddelbuettel"    "williamsanger"  
## [301] "ThomasHopper"    "CurtBurk"        "RLadiesGlobal"  
## [304] "chrbknudsen"
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
##     user_id           name screen_name        location
## 1 316842679 Carson Sievert   cpsievert Minneapolis, MN
## 2 111093392         Hao Ye   Hao_and_Y Gainesville, FL
##                                                                                                                                                description
## 1                                                                     Freelance data scientist. #rstats developer @plotlygraphs.   https://t.co/3Q2O81veoL
## 2 Postdoc @UF/@Weecology (ecosystem temporal dynamics); builds models in #Rstats & #LEGO; @MozOpenLeaders alum; he/him; You can't spell chaos w/out 'hao'.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE            2055           590           99 2011-06-14 01:44:36
## 2     FALSE             756           948           43 2010-02-03 20:00:43
##   favourites_count utc_offset                  time_zone geo_enabled
## 1             4390     -21600 Central Time (US & Canada)       FALSE
## 2            10654     -28800 Pacific Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           3053   en                FALSE         FALSE
## 2    FALSE           7413   en                FALSE         FALSE
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
## 1 http://pbs.twimg.com/profile_images/852244896316440576/IZ1IliKF_normal.jpg
## 2 http://pbs.twimg.com/profile_images/771375747214684161/Lg3U4IXS_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/852244896316440576/IZ1IliKF_normal.jpg
## 2 https://pbs.twimg.com/profile_images/771375747214684161/Lg3U4IXS_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/852244896316440576/IZ1IliKF_normal.jpg
## 2 http://pbs.twimg.com/profile_images/771375747214684161/Lg3U4IXS_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/852244896316440576/IZ1IliKF_normal.jpg
## 2 https://pbs.twimg.com/profile_images/771375747214684161/Lg3U4IXS_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             3B94D9                       000000
## 2             ABB8C2                       000000
##   profile_sidebar_fill_color profile_text_color
## 1                     000000             000000
## 2                     000000             000000
##   profile_use_background_image default_profile default_profile_image
## 1                        FALSE           FALSE                 FALSE
## 2                        FALSE           FALSE                 FALSE
##                                           profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/316842679/1508788537
## 2 https://pbs.twimg.com/profile_banners/111093392/1477467490
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 326

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
