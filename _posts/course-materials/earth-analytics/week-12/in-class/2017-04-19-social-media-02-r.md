---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-04-25'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/use-twitter-api-r/
nav-title: 'Get twitter data'
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 2
lang-lib:
  r: ['rtweet', 'tidytext', 'dplyr']
tags2:
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


<figure>

<img src="{{ site.url }}/images/course-materials/earth-analytics/week-12/boulder_twitter_map_visualizations.jpg">

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
rstats_tweets <- search_tweets(q="#rstats", n = 500)
# view the first 3 rows of the dataframe
head(rstats_tweets, n=3)
##       screen_name            user_id          created_at
## 1   codingbot1000 828692314826477569 2017-04-25 20:29:52
## 2 rodriguesloures 749387892305367042 2017-04-25 20:18:47
## 3 ExperianDataLab         2596836636 2017-04-25 20:17:38
##            status_id
## 1 856968522890489856
## 2 856965735431720961
## 3 856965446242717696
##                                                                                                                                            text
## 1 RT @nielsberglund: [Blog]: "Interesting Stuff - Week 16" https://t.co/ij282pv2f4\n#datascience #sqlserver #RStats #CLR #sqlserver2017 #python
## 2                        RT @RLangTip: Find interactive charts you can create with R at the htmlwidgets gallery https://t.co/dBDCUfssba #rstats
## 3                                   SPEAKER ANNOUNCEMENT: San Francisco EARL https://t.co/1FpkgDFGF0 @Rbloggers #Rstats https://t.co/odL1MBnczT
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             7              0           FALSE            <NA>       TRUE
## 2             8              0           FALSE            <NA>       TRUE
## 3             0              0           FALSE            <NA>      FALSE
##    retweet_status_id in_reply_to_status_status_id
## 1 856215363155087361                         <NA>
## 2 856950770427719680                         <NA>
## 3               <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                     source           media_id
## 1 twitterbot-codingbot1000               <NA>
## 2      Twitter for Android               <NA>
## 3                  dlvr.it 856965444183261184
##                                        media_url
## 1                                           <NA>
## 2                                           <NA>
## 3 http://pbs.twimg.com/media/C-SNh_VUAAA7bDn.jpg
##                                                      media_url_expanded
## 1                                                                  <NA>
## 2                                                                  <NA>
## 3 https://twitter.com/ExperianDataLab/status/856965446242717696/photo/1
##   urls            urls_display                   urls_expanded
## 1 <NA>          bit.ly/2oW5mjA           http://bit.ly/2oW5mjA
## 2 <NA> gallery.htmlwidgets.org http://gallery.htmlwidgets.org/
## 3 <NA>          dlvr.it/NzgL7c           http://dlvr.it/NzgL7c
##   mentions_screen_name mentions_user_id symbols
## 1        nielsberglund         57372793      NA
## 2             RLangTip        295344317      NA
## 3            Rbloggers        144592995      NA
##                                                hashtags coordinates
## 1 datascience sqlserver RStats CLR sqlserver2017 python          NA
## 2                                                rstats          NA
## 3                                                Rstats          NA
##   place_id place_type place_name place_full_name country_code country
## 1     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
## 2     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
## 3     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
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
head(rstats_tweets, n=2)
##       screen_name    user_id          created_at          status_id
## 1 ExperianDataLab 2596836636 2017-04-25 20:17:38 856965446242717696
## 2 QuantStratTradR  432994402 2017-04-25 20:13:49 856964485877293056
##                                                                                                                            text
## 1                   SPEAKER ANNOUNCEMENT: San Francisco EARL https://t.co/1FpkgDFGF0 @Rbloggers #Rstats https://t.co/odL1MBnczT
## 2 @RobinhoodApp do you guys ever intend to make an #rstats API so that I could have my vol trading strat execute automatically?
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                 1265037073                   RobinhoodApp   en
##               source           media_id
## 1            dlvr.it 856965444183261184
## 2 Twitter Web Client               <NA>
##                                        media_url
## 1 http://pbs.twimg.com/media/C-SNh_VUAAA7bDn.jpg
## 2                                           <NA>
##                                                      media_url_expanded
## 1 https://twitter.com/ExperianDataLab/status/856965446242717696/photo/1
## 2                                                                  <NA>
##   urls   urls_display         urls_expanded mentions_screen_name
## 1 <NA> dlvr.it/NzgL7c http://dlvr.it/NzgL7c            Rbloggers
## 2 <NA>           <NA>                  <NA>         RobinhoodApp
##   mentions_user_id symbols hashtags coordinates place_id place_type
## 1        144592995      NA   Rstats          NA     <NA>       <NA>
## 2       1265037073      NA   rstats          NA     <NA>       <NA>
##   place_name place_full_name country_code country bounding_box_coordinates
## 1       <NA>            <NA>         <NA>    <NA>                     <NA>
## 2       <NA>            <NA>         <NA>    <NA>                     <NA>
##   bounding_box_type
## 1              <NA>
## 2              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names
head(rstats_tweets$screen_name)
## [1] "ExperianDataLab" "QuantStratTradR" "mjhendrickson"   "Datatitian"     
## [5] "GuillaumeLarocq" "nielsberglund"
# get a list of just the unique usernames
unique(rstats_tweets$screen_name)
##   [1] "ExperianDataLab" "QuantStratTradR" "mjhendrickson"  
##   [4] "Datatitian"      "GuillaumeLarocq" "nielsberglund"  
##   [7] "haozhu233"       "mbojan"          "karigunnars"    
##  [10] "keegankorthauer" "hrbrmstr"        "MangoTheCat"    
##  [13] "RCharlie425"     "LauriListak"     "kyle_e_walker"  
##  [16] "timelyportfolio" "Rbloggers"       "RLangTip"       
##  [19] "ezbrooks"        "juliesquid"      "juliasilge"     
##  [22] "kevinykuo"       "dataandme"       "pssGuy"         
##  [25] "PlethodoNick"    "seb_renaut"      "thinkR_fr"      
##  [28] "hadleywickham"   "NCrepalde"       "StineNielsenEPI"
##  [31] "Dalal_EL_Hanna"  "ipnosimmia"      "abresler"       
##  [34] "DataSciHeroes"   "emhrt_"          "AriLamstein"    
##  [37] "matiocre"        "l_hansa"         "jayusor"        
##  [40] "ConcejeroPedro"  "dsacademybr"     "OilGains"       
##  [43] "kwbroman"        "DeborahTannon"   "PAdhokshaja"    
##  [46] "basecamp_ai"     "Fisher85M"       "Mooniac"        
##  [49] "TransmitScience" "tcbanalytics"    "AmeliaMN"       
##  [52] "arnicas"         "Michael_Toth"    "rushworth_a"    
##  [55] "jhollist"        "jletteboer"      "Rexercises"     
##  [58] "RSSGlasgow1"     "BrandenDunbar"   "KirkDBorne"     
##  [61] "JudgeLord"       "zkajdan"         "rweekly_live"   
##  [64] "Anthony_Rentsch" "FarRider"        "ucfagls"        
##  [67] "_ms03"           "DD_Serena_"      "emilynordmann"  
##  [70] "datapointier"    "KirkegaardEmil"  "wahalulu"       
##  [73] "NovasTaylor"     "jtrnyc"          "SamuelJenness"  
##  [76] "RiinuOts"        "moroam"          "CollinVanBuren" 
##  [79] "Saudistat"       "DrRuthODonnell"  "Drs_limnology"  
##  [82] "cpsievert"       "msarsar"         "joranelias"     
##  [85] "krisshaffer"     "AntGuilllot"     "CoreySparks1"   
##  [88] "AnalyticsVidhya" "koen_hufkens"    "hpgomide"       
##  [91] "ElizabethGannon" "paulcdjo"        "SMBittner"      
##  [94] "G_Devailly"      "kennethrose82"   "steffilazerte"  
##  [97] "Biff_Bruise"     "ingorohlfing"    "MattDowle"      
## [100] "awhstin"         "csbq_qcbs"       "RLadiesGlobal"  
## [103] "LockeData"       "rmkubinec"       "josvandongen"   
## [106] "unixgod"         "alaynatokash"    "GaryDower"      
## [109] "axelrod_eric"    "OFrost"          "digr_io"        
## [112] "DataScienceInR"  "ctricot"         "lucaborger"     
## [115] "michael_fop"     "jordifpages"     "outilammi"      
## [118] "ellis2013nz"     "noteratfi"       "asigaru_taichou"
## [121] "rgaiacs"         "DD_NaNa_"        "Benavent"       
## [124] "TheDataSciDude"  "algonpaje"       "roger_light"    
## [127] "IvanKasanicky"   "AymericBds"      "BigDataInsights"
## [130] "SaschaDittmann"  "andreas_io"      "mikkelkrogsholm"
## [133] "celiassiu"       "Sanna_Kuusisto"  "alice_data"     
## [136] "KKulma"          "YourStatsGuru"   "verajosemanuel" 
## [139] "nordholmen"      "jody_tubi"       "MaHorn16"       
## [142] "DataLion_EN"     "jonny_polonsky"  "OmgHowthat"     
## [145] "LoquaciousCasey" "DailyRpackage"   "xanthi_and"     
## [148] "naupakaz"        "eclairredondo"   "VickiVanDamme"  
## [151] "bass_analytics"  "McCurdyColton"   "tangming2005"   
## [154] "synflyn28"       "mitchdata"       "lenkiefer"      
## [157] "SpacePlowboy"    "DataCamp"        "JennyBryan"     
## [160] "JohnBVincent"    "HarvinderSAtwal" "_ColinFay"      
## [163] "pavanmirla"      "PPUAMX"          "RCatLadies"     
## [166] "AGSBS43"         "FoxandtheFlu"    "v_vashishta"    
## [169] "apodkul"         "SCBeatty"        "ThomasMailund"  
## [172] "axiomsofxyz"     "jacksantucci"    "mammykins_"     
## [175] "andyofsmeg"      "sesync"          "cascadiarconf"  
## [178] "RLadiesBA"       "at_plhjr"        "UrbanDemog"     
## [181] "hnrklndbrg"      "joreag"          "AedinCulhane"   
## [184] "keithgw"         "Xtophe_Bontemps" "tom_auer"       
## [187] "_Data_Science_"  "acgerstein"      "elpidiofilho"   
## [190] "AngeBassa"       "RyanThomasRT"    "ZKamvar"        
## [193] "rOpenSci"        "riannone"        "AdStreamz"      
## [196] "stoltzmaniac"    "ExcelStrategies" "LearnRinaDay"   
## [199] "NikDOppes"       "samfirke"        "sckottie"       
## [202] "RobKnell1"       "CoprimeAnalytic" "jessenleon"     
## [205] "Prashant_1722"   "StatsInTheWild"  "tcarpenter216"  
## [208] "mikkopiippo"     "KristaOke"       "setophaga"      
## [211] "AlexCEngler"     "chemstateric"    "LeafyEricScott" 
## [214] "AutoboxForecast" "rstudiotips"     "mmparker"       
## [217] "ido87"           "just_add_data"   "dccc_phd"       
## [220] "AndySugs"        "BroVic"          "DaniMRodz"      
## [223] "aeronlaffere"    "itsrainingdata"  "jfish111j"      
## [226] "tomdireill"      "eleafeit"        "DrQz"           
## [229] "storybench"      "adamgreatkind"   "arvi1000"       
## [232] "cjlortie"        "ilustat"         "BRAHMAAN"       
## [235] "R_Programming"   "tladeras"        "pdxrlang"       
## [238] "LuigiBiagini"    "r4ecology"       "markruddy"      
## [241] "fdavidcl"        "lanceanz"        "bearloga"       
## [244] "DrScranto"       "EvaMaeRey"       "DagmedyaVeri"   
## [247] "gp_pulipaka"     "ml_barnett"      "graemeleehickey"
## [250] "ikashnitsky"     "CRANberriesFeed" "NTGuardian"     
## [253] "revodavid"       "tylergbyers"     "DaveRubal"      
## [256] "bruno_nicenboim" "TrashBirdEcol"   "Torontosj"      
## [259] "paleolimbot"     "tweetupkzoo"     "nurupo889"      
## [262] "shinichiroinaba" "cortinah"        "TeebzR"         
## [265] "d8aninja"        "munichrocker"    "jebyrnes"       
## [268] "DesertIsleSQL"   "giveawayflavato" "mdsumner"       
## [271] "CiaranNash"      "statspecialist"  "JMateosGarcia"  
## [274] "rweekly_org"     "joelgombin"      "noamross"       
## [277] "AntoViral"       "JohanvdBrink"    "sfcheung"       
## [280] "JoergSteinkamp"  "MikeRSpencer"    "RLadiesLondon"  
## [283] "regionomics"     "adamhsparks"     "FelipeSMBarros" 
## [286] "m45ib"           "YiJuTseng"       "InsightBrief"   
## [289] "peterdalle"      "mtersmitten"     "AmirSariaslan"  
## [292] "ioannides_alex"  "DataBzh"         "gzileni"        
## [295] "enricoferrero"   "skrol"           "ma_salmon"      
## [298] "Ewen_"           "chainsawriot"    "gombang"        
## [301] "jrcajide"        "znmeb"           "giveawayqombat" 
## [304] "jwgayler"        "numerage"        "msubbaiah1"
```

We can similarly use the `search_users()` function to just see what users are tweeting
using a particular hashtag. This function returns just a data.frame of the users
and information about their accounts.


```r
# what users are tweeting with #rstats
users <- search_users("#rstats", n=500)
# just view the first 2 users - the data frame is large!
head(users, n=2)
##      user_id           name screen_name           location
## 1 4911181019 Alt-Hypothesis RStatsJason        Atlanta, GA
## 2   13074042    Julia Silge  juliasilge Salt Lake City, UT
##                                                                                                                                                      description
## 1 I tweet about Public Health and other things. Founder and current Chair of R User Group @CDCGov. #Rstats Instructor @EmoryRollins. Recently took up gardening.
## 2                                              Data science and visualization at Stack Overflow, #rstats, parenthood, reading, food/wine/coffee, #NASADatanauts.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE             252           752           17 2016-02-15 00:48:05
## 2     FALSE            5920           392          272 2008-02-05 00:47:07
##   favourites_count utc_offset                   time_zone geo_enabled
## 1             2701     -25200  Pacific Time (US & Canada)       FALSE
## 2            12288     -21600 Mountain Time (US & Canada)        TRUE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE           5396   en                FALSE         FALSE
## 2    FALSE          14239   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   F5F8FA
## 2                  FALSE                   B2DFDA
##                        profile_background_image_url
## 1                                              <NA>
## 2 http://abs.twimg.com/images/themes/theme13/bg.gif
##                   profile_background_image_url_https
## 1                                               <NA>
## 2 https://abs.twimg.com/images/themes/theme13/bg.gif
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 http://pbs.twimg.com/profile_images/811947326700863490/L8J9GjAT_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 https://pbs.twimg.com/profile_images/811947326700863490/L8J9GjAT_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 http://pbs.twimg.com/profile_images/811947326700863490/L8J9GjAT_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/841011873046704129/P-yMNslR_normal.jpg
## 2 https://pbs.twimg.com/profile_images/811947326700863490/L8J9GjAT_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             1DA1F2                       C0DEED
## 2             4A913C                       000000
##   profile_sidebar_fill_color profile_text_color
## 1                     DDEEF6             333333
## 2                     000000             000000
##   profile_use_background_image default_profile default_profile_image
## 1                         TRUE            TRUE                 FALSE
## 2                        FALSE           FALSE                 FALSE
##                                          profile_banner_url
## 1                                                      <NA>
## 2 https://pbs.twimg.com/profile_banners/13074042/1348369115
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 305

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="100%" />

Let's sort by count and just plot the top 15 locations.


```r
users %>%
  count(location, sort=TRUE) %>%
  mutate(location= reorder(location,n)) %>%
  top_n(15) %>%
  ggplot(aes(x=location,y=n)) +
  geom_col() +
  coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="100%" />

Looking at our data, what do you notice that might improve this plot?
There are 314 unique locations in our list. However, everyone didn't specify their
locations using the approach. For example some just identified their country:
United States for example and others specified a city and state. We may want to
do some cleaning of these data to be able to better plot this.

Lets have a look at the time zone field next.



```r
# plot a list of users by time zone
users %>% ggplot(aes(time_zone)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Time Zone",
      title="Twitter users - unique time zones ")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-users-timezone-1.png" title="Users tweeting by time zone" alt="Users tweeting by time zone" width="100%" />

Using the code above, plot users by time zone. List the top 20 time zones.
What do you notice about the data?

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="100%" />




The plots above aren't perfect. What do you start to notice about working
with these data? Can we simply download them and plot the data?

## Data munging  101

When we work with data from sources like NASA, USGS, etc there are particular
cleaning steps that we often need to do. For instance:

* we may need to remove nodata values
* we may need to scale the data
* and others

However, the data generally have a set structure in terms of file formats and metadata.

When we work with social media and other text data the user community creates and
curates the content. This means there are NO RULES! This also means that we may
have to perform extra steps to clean the data to ensure we are analyzing the right
thing.


## Searching for tweets related to fire

Above we learned some things about sorting through social media data and the
associated types of issues that we may run into when begining to analyze it. Next,
let's look at a different workflow - exploring the actual text of the tweets which
will involve some text mining.

In this example, let's find tweets that are using the words "forest fire" in them.



```r

# Find tweet using forest fire in them
forest_fire_tweets <- search_tweets(q="forest fire", n=100, lang="en",
                             include_rts = FALSE)

# it doesn't like the type = recent argument - a bug?
```


Let's look at the results. Note any issues with our data?
It seems like when we search for forest fire, we get tweets that contain the words
forest and fire in them - but these tweets are not necessarily all related to our
science topic of interest. Or are they?

If we set our query to `q="forest+fire"` rather than `forest fire` then the
API fill find tweets that use the words together in a string rathen than across
the entire string. Let's try it.


```r
# Find tweet using forest fire in them
fire_tweets <- search_tweets(q="forest+fire", n=100, lang="en",
                             include_rts = FALSE)
# check data to see if there are emojis
head(fire_tweets$text)
## [1] "I liked a @YouTube video https://t.co/RBuPtSbgCX HARDCORE MINECRAFT ★ FOREST FIRE MAYHEM (3)"                                                    
## [2] "2012: Dust An Elysian Tail\n2013: Fire Emblem Awakening\n2014: Mario Kart 8\n2015: Ori and the Blind Forest\n2016: Fina… https://t.co/qoxMRr01SH"
## [3] "cant really tell but its super smoky out bc theres a forest fire a few towns over https://t.co/S6Zjp4QOLg"                                       
## [4] "probably because jack didnt seT THE ENTIRE FOREST ON FIRE THEREFORE DRAW IN ATTENTION"                                                           
## [5] "I liked a @YouTube video https://t.co/E7IXyxvTiq HARDCORE MINECRAFT ★ FOREST FIRE MAYHEM (3)"                                                    
## [6] "Gotta get a backwood and roll up the forest fire! \U0001f43b\U0001f525"
```

## Data clean-up

Looking at the data above, it becomes clear that there is a lot of clean-up
associated with social media data.

First, there are url's in our tweets. If we want to do a text analysis to figure out
what words are most common in our tweets, the URL's won't be helpful. Let's remove
those.


```r
# remove urls tidyverse is failing here for some reason
#fire_tweets %>%
#  mutate_at(c("stripped_text"), gsub("http.*","",.))

# remove http elements manually
fire_tweets$stripped_text <- gsub("http.*","",fire_tweets$stripped_text)
## Error in `$<-.data.frame`(`*tmp*`, "stripped_text", value = character(0)): replacement has 0 rows, data has 100
fire_tweets$stripped_text <- gsub("https.*","",fire_tweets$stripped_text)
## Error in `$<-.data.frame`(`*tmp*`, "stripped_text", value = character(0)): replacement has 0 rows, data has 100
```

Finally, we can clean up our text. If we are trying to create a list of unique
words in our tweets, words with capitalization will be different from words
that are all lowercase. Also we don't need punctuation to be returned as a unique
word.


```r
a_list_of_words <- c("Dog", "dog", "dog", "cat", "cat", ",")
unique(a_list_of_words)
## [1] "Dog" "dog" "cat" ","
```


We can use the `tidytext::unnest_tokens()` function in the tidytext package to
magically clean up our text! When we use this function the following things
will be cleaned up in the text:

1. **Convert text to lowercase:** each word found in the text will be converted to lowercase so ensure that we don't get duplicate words due to variation in capitalization.
2. **Punctuation is removed:** all instances of periods, commas etc will be removed from our list of words , and
3. **Unique id associated with the tweet:** will be added for each occurrence of the word

The `unnest_tokens()` function takes two arguments:

1. The name of the column where the unique word will be stored and
2. The column name from the `data.frame` that you are using that you want to pull unique words from.

In our case, we want to use the `stripped_text` column which is where we have our
cleaned up tweet text stored.



```r
# remove punctuation, convert to lowercase, add id for each tweet!
fire_tweet_text_clean <- fire_tweets %>%
  dplyr::select(stripped_text) %>%
  unnest_tokens(word, stripped_text)
## Error in eval(expr, envir, enclos): object 'stripped_text' not found
```

Now we can plot our data. What do you notice?


```r
# plot the top 15 words -- notice any issues?
fire_tweet_text_clean %>%
  count(word, sort=TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
      labs(x="Count",
      y="Unique words",
      title="Count of unique words found in tweets")
## Error in eval(expr, envir, enclos): object 'fire_tweet_text_clean' not found
```

Our plot of unique words contains some words that may not be useful to use. For instance
"a" and "to". In the word of text mining we call those words - 'stop words'.
We want to remove these words from our analysis as they are fillers used to compose
a sentence.

Lucky for use, the `tidytext` package has a function that will help us clean up stop
words! To use this we:

1. Load the "stop_words" data included with `tidytext`. This data is simply a list of words that we may want to remove in a natural language analysis.
2. Then we use anti_join to remove all stop words from our analysis.

Let's give this a try next!


```r
# load list of stop words - from the tidytext package
data("stop_words")
# view first 6 words
head(stop_words)
## # A tibble: 6 × 2
##        word lexicon
##       <chr>   <chr>
## 1         a   SMART
## 2       a's   SMART
## 3      able   SMART
## 4     about   SMART
## 5     above   SMART
## 6 according   SMART

nrow(fire_tweet_text_clean)
## Error in nrow(fire_tweet_text_clean): object 'fire_tweet_text_clean' not found

# remove stop words from our list of words
cleaned_tweet_words <- fire_tweet_text_clean %>%
  anti_join(stop_words)
## Error in eval(expr, envir, enclos): object 'fire_tweet_text_clean' not found

# there should be fewer words now
nrow(cleaned_tweet_words)
## Error in nrow(cleaned_tweet_words): object 'cleaned_tweet_words' not found
```

Now that we've performed this final step of cleaning, we can try to plot, once
again.


```r
# plot the top 15 words -- notice any issues?
cleaned_tweet_words %>%
  count(word, sort=TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
      labs(x="Count",
      y="Unique words",
      title="Count of unique words found in tweets",
      subtitle="Stop words removed from the list")
## Error in eval(expr, envir, enclos): object 'cleaned_tweet_words' not found
```

Does the plot look better than the previous plot??



<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://mkearney.github.io/rtweet/articles/intro.html#retrieving-trends" target="_blank">A great overview of the rtweet package by Mike Kearny</a>
* <a href="https://francoismichonneau.net/2017/04/tidytext-origins-of-species/" target="_blank">A blog post on tidytext by Francois Michonneau</a>
*  <a href="https://blog.twitter.com/2008/what-does-rate-limit-exceeded-mean-updated" target="_blank">About the twitter API rate limit</a>

</div>
