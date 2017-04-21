---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-04-21'
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
  data-analysis-exploration: ['text-mining']
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
##    screen_name            user_id          created_at          status_id
## 1 sk_thanaporn 759944341787848704 2017-04-21 17:03:36 855467065049665536
## 2    dataandme         3230388598 2017-04-21 17:02:09 855466699147149312
## 3 AvrahamAdler           27011937 2017-04-21 17:02:05 855466680163516416
##                                                                                                                                                    text
## 1 RT @dataandme: \U0001f44d stuff in today's @dataelixir, incl. @jokergoo's “Circular Visualization in R” https://t.co/9eRffVtWl9 #rstats #dataviz htt…
## 2     \U0001f44d stuff in today's @dataelixir, incl. @jokergoo's “Circular Visualization in R” https://t.co/9eRffVtWl9 #rstats… https://t.co/rZizAECHD4
## 3           @wrathematics Did you ever fix it? I eventually got Delaporte to pass its #rstats CRAN checks. But I'm running out… https://t.co/k8YmARkINH
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             1              0           FALSE            <NA>       TRUE
## 2             1              2           FALSE            <NA>      FALSE
## 3             0              0           FALSE            <NA>      FALSE
##    retweet_status_id in_reply_to_status_status_id
## 1 855466699147149312                         <NA>
## 2               <NA>                         <NA>
## 3               <NA>           850507489980411905
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                 1222710751                   wrathematics   en
##                source media_id media_url media_url_expanded urls
## 1 Twitter for Android     <NA>      <NA>               <NA> <NA>
## 2              Buffer     <NA>      <NA>               <NA> <NA>
## 3  Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                                  urls_display
## 1                             buff.ly/2pLEl0G
## 2 buff.ly/2pLEl0G twitter.com/i/web/status/8…
## 3                 twitter.com/i/web/status/8…
##                                                                urls_expanded
## 1                                                     http://buff.ly/2pLEl0G
## 2 http://buff.ly/2pLEl0G https://twitter.com/i/web/status/855466699147149312
## 3                        https://twitter.com/i/web/status/855466680163516416
##            mentions_screen_name               mentions_user_id symbols
## 1 dataandme dataelixir jokergoo 3230388598 2789733414 41072725      NA
## 2           dataelixir jokergoo            2789733414 41072725      NA
## 3                  wrathematics                     1222710751      NA
##         hashtags coordinates place_id place_type place_name
## 1 rstats dataviz          NA     <NA>       <NA>       <NA>
## 2         rstats          NA     <NA>       <NA>       <NA>
## 3         rstats          NA     <NA>       <NA>       <NA>
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
head(rstats_tweets, n=2)
##    screen_name    user_id          created_at          status_id
## 1    dataandme 3230388598 2017-04-21 17:02:09 855466699147149312
## 2 AvrahamAdler   27011937 2017-04-21 17:02:05 855466680163516416
##                                                                                                                                                text
## 1 \U0001f44d stuff in today's @dataelixir, incl. @jokergoo's “Circular Visualization in R” https://t.co/9eRffVtWl9 #rstats… https://t.co/rZizAECHD4
## 2       @wrathematics Did you ever fix it? I eventually got Delaporte to pass its #rstats CRAN checks. But I'm running out… https://t.co/k8YmARkINH
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             1              2           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>           850507489980411905
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                 1222710751                   wrathematics   en
##               source media_id media_url media_url_expanded urls
## 1             Buffer     <NA>      <NA>               <NA> <NA>
## 2 Twitter Web Client     <NA>      <NA>               <NA> <NA>
##                                  urls_display
## 1 buff.ly/2pLEl0G twitter.com/i/web/status/8…
## 2                 twitter.com/i/web/status/8…
##                                                                urls_expanded
## 1 http://buff.ly/2pLEl0G https://twitter.com/i/web/status/855466699147149312
## 2                        https://twitter.com/i/web/status/855466680163516416
##   mentions_screen_name    mentions_user_id symbols hashtags coordinates
## 1  dataelixir jokergoo 2789733414 41072725      NA   rstats          NA
## 2         wrathematics          1222710751      NA   rstats          NA
##   place_id place_type place_name place_full_name country_code country
## 1     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
## 2     <NA>       <NA>       <NA>            <NA>         <NA>    <NA>
##   bounding_box_coordinates bounding_box_type
## 1                     <NA>              <NA>
## 2                     <NA>              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names
head(rstats_tweets$screen_name)
## [1] "dataandme"       "AvrahamAdler"    "RanaeDietzel"    "TransmitScience"
## [5] "rweekly_live"    "JayPykw"
# get a list of just the unique usernames
unique(rstats_tweets$screen_name)
##   [1] "dataandme"       "AvrahamAdler"    "RanaeDietzel"   
##   [4] "TransmitScience" "rweekly_live"    "JayPykw"        
##   [7] "rweekly_org"     "rushworth_a"     "contefranz"     
##  [10] "sckottie"        "IstvanHajnal"    "hrbrmstr"       
##  [13] "AndreaCirilloAC" "LearnRinaDay"    "Rexercises"     
##  [16] "revodavid"       "cascadiarconf"   "RLangTip"       
##  [19] "buriedinfo"      "ana_valdi"       "kooldudz"       
##  [22] "thinkR_fr"       "Torontosj"       "LeviABx"        
##  [25] "the18gen"        "amcdan"          "ExperianDataLab"
##  [28] "jaredlander"     "tladeras"        "krishanu_c"     
##  [31] "dwhitena"        "jtrnyc"          "alecbarrett"    
##  [34] "zabormetrics"    "CRANberriesFeed" "thomascwells"   
##  [37] "LockeData"       "drob"            "kwbroman"       
##  [40] "datanerd_jaya"   "odeleongt"       "geografiard"    
##  [43] "ChrisGandrud"    "pavopax"         "jknowles"       
##  [46] "nyhackr"         "alice_data"      "nhcooper123"    
##  [49] "tangming2005"    "RSButner"        "BenBondLamberty"
##  [52] "emilynordmann"   "0ttlngr"         "saraannhart"    
##  [55] "bhaskar_vk"      "gshotwell"       "HarvinderSAtwal"
##  [58] "RyanGuggenmos"   "AlexPawlowski_"  "bshor"          
##  [61] "zx8754"          "GaryDower"       "digr_io"        
##  [64] "sharon000"       "Hoog10HK"        "mvkorpel"       
##  [67] "nwstephens"      "CollinVanBuren"  "andrzejkoles"   
##  [70] "EcographyJourna" "PoGibas"         "AntoViral"      
##  [73] "carlcarrie"      "pdalgd"          "jmgomez"        
##  [76] "noteratfi"       "szasulja"        "DeborahTannon"  
##  [79] "Rbloggers"       "jamyt123"        "KirkegaardEmil" 
##  [82] "BigDataInsights" "YourStatsGuru"   "combine_au"     
##  [85] "LeahAWasser"     "andduer"         "ExploratoryData"
##  [88] "clavitolo"       "DailyRpackage"   "rdata_lu"       
##  [91] "brodriguesco"    "stephanenardin"  "mattmoehr"      
##  [94] "InfonomicsToday" "blightersort"    "lenkiefer"      
##  [97] "aksingh1985"     "ChicagoCDO"      "AndySugs"       
## [100] "ata_aman"        "KevinBCohen"     "SpacePlowboy"   
## [103] "yoniceedee"      "DanielRLevesque" "ImDataScientist"
## [106] "mikedecr"        "kamal_hothi"     "mihobu"         
## [109] "neilfws"         "MikeTreglia"     "wahalulu"       
## [112] "BenSadeghi"      "StrimasMackey"   "mjcavaretta"    
## [115] "iprophage"       "JennyBryan"      "LisaVaughnFox26"
## [118] "DBaker007"       "hannah_recht"    "robtougher"     
## [121] "GeorgetownCCPE"  "FantasyADHD"     "mercecrosas"    
## [124] "Megan_McNellie"  "AedinCulhane"    "yoseljaimes"    
## [127] "Biff_Bruise"     "FelipeSMBarros"  "statlab"        
## [130] "manraralz"       "bearloga"        "AriLamstein"    
## [133] "nimbusaeta"      "maxheld"         "xinye"          
## [136] "jaheppler"       "RLadiesNYC"      "tylerrinker"    
## [139] "elpidiofilho"    "abresler"        "polesasunder"   
## [142] "hspter"          "leonawicz"       "jhollist"       
## [145] "Still_Benn"      "nielsberglund"   "kosinski_rblog" 
## [148] "DataMic"         "rahulxc"         "BenceArato"     
## [151] "wrathematics"    "romain_francois" "RLadiesParis"   
## [154] "CoreySparks1"    "Fisher85M"       "awhstin"        
## [157] "UrbanDemog"      "AnalyticsVidhya" "rmflight"       
## [160] "AgentZeroNine"   "williamsanger"   "imdaviddietrich"
## [163] "rOpenSci"        "jessenleon"      "jletteboer"     
## [166] "thonoir"         "pdxrlang"        "denglishbi"     
## [169] "datavisitor"     "RLadiesDC"       "jefmouram"      
## [172] "AlbrightLCB"     "LCBNicaragua"    "BroVic"         
## [175] "gp_pulipaka"     "eleafeit"        "Physacourses"   
## [178] "mikkopiippo"     "clarler"         "groundwalkergmb"
## [181] "tng_konrad"      "KanAugust"       "thosjleeper"    
## [184] "ctricot"         "gracypoelman"    "innova_scape"   
## [187] "jlmico"          "dataelixir"      "kyle_e_walker"  
## [190] "genetics_blog"   "ChelskiLittle"   "joranelias"     
## [193] "AndrewZimolzak"  "rasyidstat"      "gregoriosz"     
## [196] "r4ecology"       "koen_hufkens"    "shari_linn"     
## [199] "KirkDBorne"      "giacomoecce"     "atassSports"    
## [202] "jminguezc"       "ByunLab"         "PacktPub"       
## [205] "mrcroissant"     "SSNAR17"         "chi2innovations"
## [208] "Dhabolt"         "_ColinFay"       "delferts"       
## [211] "meetup_r_nantes" "IsabellGru"      "d4t4v1z"        
## [214] "SEACOasia"       "zkajdan"         "jwgayler"       
## [217] "nierhoff"        "MangoTheCat"     "ActivevoiceSw"  
## [220] "TimDoherty_"     "Data_Road"       "mikkelkrogsholm"
## [223] "theRcast"        "MilesMcBain"     "CloudNewsIndia" 
## [226] "mjfrigaard"      "_Data_Science_"  "eddelbuettel"   
## [229] "ThomasHopper"    "mdsumner"        "MRHelmus"       
## [232] "cjacuff"         "jduckles"        "DennisMurray"   
## [235] "infotroph"       "sane_panda"      "ecologician"    
## [238] "markusweinmann"  "rquintino"       "adamson"        
## [241] "ShinyappsRecent" "ozjimbob"        "orlandomezquita"
## [244] "JaiBroome"       "CorrelViz"       "rbloggersBR"    
## [247] "AlexaLFH"
```

We can similarly use the `search_users()` function to just see what users are tweeting
using a particular hashtag. This function returns just a data.frame of the users
and information about their accounts.


```r
# what users are tweeting with #rstats
users <- search_users("#rstats", n=500)
# just view the first 2 users - the data frame is large!
head(users, n=2)
##      user_id           name screen_name             location
## 1    5685812      Боб Рудіс    hrbrmstr Underground Cell #34
## 2 4911181019 Alt-Hypothesis RStatsJason          Atlanta, GA
##                                                                                                                                                           description
## 1 Don't look at me…I do what he does—just slower. #rstats fanatic • \U0001f34aResistance Fighter • Cook • Christian • [Master] Chef des Données de Sécurité @ @rapid7
## 2      I tweet about Public Health and other things. Founder and current Chair of R User Group @CDCGov. #Rstats Instructor @EmoryRollins. Recently took up gardening.
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE            7971           298          562 2007-05-01 14:04:24
## 2     FALSE             251           752           17 2016-02-15 00:48:05
##   favourites_count utc_offset                  time_zone geo_enabled
## 1             8030     -14400 Eastern Time (US & Canada)       FALSE
## 2             2698     -25200 Pacific Time (US & Canada)       FALSE
##   verified statuses_count lang contributors_enabled is_translator
## 1     TRUE          62709   en                FALSE         FALSE
## 2    FALSE           5380   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   022330
## 2                  FALSE                   F5F8FA
##                                                     profile_background_image_url
## 1 http://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
## 2                                                                           <NA>
##                                                profile_background_image_url_https
## 1 https://pbs.twimg.com/profile_background_images/445410888028155904/ltOYCDU9.png
## 2                                                                            <NA>
##   profile_background_tile
## 1                   FALSE
## 2                   FALSE
##                                                            profile_image_url
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
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 314

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x="Count",
      y="Location",
      title="Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/explore-users-1.png" title=" " alt=" " width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/unnamed-chunk-2-1.png" title=" " alt=" " width="100%" />

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

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-users-timezone-1.png" title=" " alt=" " width="100%" />

Using the code above, plot users by time zone. List the top 20 time zones.
What do you notice about the data?

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-02-r/plot-timezone-cleaned-1.png" title=" " alt=" " width="100%" />




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
## [1] "FL | LAKELAND |BRUSH FIRE| 2700 BLK JIM JOHNSOIN RD | FD O/S W/ WRKNG BRUSH FIRE. PD &amp; FOREST SVCE O/S ASSISTING.... https://t.co/5f6VnZ7Tg8"
## [2] "Now Playing on WNR: Black Forest Fire - Live News Feed - Click to listen to WNR: https://t.co/ZNJgRccx2n"                                        
## [3] "Spirit of Forest Fire oversoul medien https://t.co/lN7fI57G60"                                                                                   
## [4] "#Photography: Fire #Fine Art #park,leaves,fire,landscape,red,forest,retro,nature,travel,sun,light,guidance,old,vint… https://t.co/2NSaRbmrpO"    
## [5] "Hypnotic Animations Show Why Trees Depend on Forest Fires https://t.co/UJbmLCwv1x https://t.co/uipl7xbgGR"                                       
## [6] "What's the connection between forest structure, fuels and wildland fire? join the webinar on 4/27 to find out! https://t.co/c9lRCaSvwZ"
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
