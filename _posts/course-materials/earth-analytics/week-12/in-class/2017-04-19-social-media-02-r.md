---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-04-25'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/use-twitter-api-r/
nav-title: 'Explore twitter data'
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
## Error in curl::curl_fetch_memory(url, handle = handle): Couldn't connect to server
# view the first 3 rows of the dataframe
head(rstats_tweets, n=3)
##       screen_name    user_id          created_at          status_id
## 1 ExperianDataLab 2596836636 2017-04-25 20:17:38 856965446242717696
## 2 QuantStratTradR  432994402 2017-04-25 20:13:49 856964485877293056
## 3   mjhendrickson  404107193 2017-04-25 20:11:05 856963798489583616
##                                                                                                                                          text
## 1                                 SPEAKER ANNOUNCEMENT: San Francisco EARL https://t.co/1FpkgDFGF0 @Rbloggers #Rstats https://t.co/odL1MBnczT
## 2               @RobinhoodApp do you guys ever intend to make an #rstats API so that I could have my vol trading strat execute automatically?
## 3 Visualization is most of the fun of analytics. Here are some ways to do just that in #rstats and #python. Tutorial… https://t.co/JLnSg5h3Dc
##   retweet_count favorite_count is_quote_status    quote_status_id
## 1             0              0           FALSE               <NA>
## 2             0              0           FALSE               <NA>
## 3             0              0            TRUE 850000363675680769
##   is_retweet retweet_status_id in_reply_to_status_status_id
## 1      FALSE              <NA>                         <NA>
## 2      FALSE              <NA>                         <NA>
## 3      FALSE              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                 1265037073                   RobinhoodApp   en
## 3                       <NA>                           <NA>   en
##               source           media_id
## 1            dlvr.it 856965444183261184
## 2 Twitter Web Client               <NA>
## 3             Buffer               <NA>
##                                        media_url
## 1 http://pbs.twimg.com/media/C-SNh_VUAAA7bDn.jpg
## 2                                           <NA>
## 3                                           <NA>
##                                                      media_url_expanded
## 1 https://twitter.com/ExperianDataLab/status/856965446242717696/photo/1
## 2                                                                  <NA>
## 3                                                                  <NA>
##   urls                urls_display
## 1 <NA>              dlvr.it/NzgL7c
## 2 <NA>                        <NA>
## 3 <NA> twitter.com/i/web/status/8…
##                                         urls_expanded mentions_screen_name
## 1                               http://dlvr.it/NzgL7c            Rbloggers
## 2                                                <NA>         RobinhoodApp
## 3 https://twitter.com/i/web/status/856963798489583616                 <NA>
##   mentions_user_id symbols      hashtags coordinates place_id place_type
## 1        144592995      NA        Rstats          NA     <NA>       <NA>
## 2       1265037073      NA        rstats          NA     <NA>       <NA>
## 3             <NA>      NA rstats python          NA     <NA>       <NA>
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
followers can see it. It is similar to sharing in facebook where you can add a
quote or text above the retweet if you want or just share the post. Let's use
the same query that we used above but this time ignore all retweets by setting
the `include_rts` argument to `FALSE`. We can get tweet / retweet stats from
our dataframe, separately.


```r
# find recent tweets with #rstats but ignore retweets
rstats_tweets <- search_tweets("#rstats", n = 500,
                             include_rts = FALSE)
## Error in curl::curl_fetch_memory(url, handle = handle): Couldn't connect to server
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
users <- search_users("#rstats", 
                      n=500)
## Error in curl::curl_fetch_memory(url, handle = handle): Couldn't connect to server
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
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title="plot of users by location" alt="plot of users by location" width="100%" />




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
