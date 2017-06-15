---
layout: single
title: "Get twitter data using the twitter API from rtweet in R"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Leah Wasser','Carson Farmer']
modified: '2017-06-15'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/use-twitter-api-r/
nav-title: 'Explore twitter data'
week: 12
course: "earth-analytics"
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
##       screen_name    user_id          created_at          status_id
## 1       klunkySQL   17518751 2017-06-15 20:12:10 875445849236615168
## 2 Luca_Parlamento 1328247444 2017-06-15 20:11:00 875445558856400897
## 3   martinwildash  293195222 2017-06-15 20:10:58 875445550551769088
##                                                                                                                                           text
## 1                                                RT @Rbloggers: Introducing Our Instructor Pages! https://t.co/PODVNWa1xi #rstats #DataScience
## 2           RT @revodavid: See real-time predictions from Microsoft R in action, at 1M transactions per second https://t.co/heptY8KGB2 #rstats
## 3 RT @drob: New blog post: "Developers who use spaces make more money than those who use tabs" https://t.co/mLHlDrbEBm #rstats https://t.co/n…
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             4              0           FALSE            <NA>       TRUE
## 2             2              0           FALSE            <NA>       TRUE
## 3           232              0           FALSE            <NA>       TRUE
##    retweet_status_id in_reply_to_status_status_id
## 1 875430195137839105                         <NA>
## 2 875412953033519104                         <NA>
## 3 875340314231361536                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
##                source media_id media_url media_url_expanded urls
## 1  Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 2  Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 3 Twitter for Android     <NA>      <NA>               <NA> <NA>
##                                   urls_display
## 1                              wp.me/pMm6L-Dwf
## 2 blog.revolutionanalytics.com/2017/06/real-t…
## 3           stackoverflow.blog/2017/06/15/dev…
##                                                                      urls_expanded
## 1                                                          https://wp.me/pMm6L-Dwf
## 2           http://blog.revolutionanalytics.com/2017/06/real-time-predictions.html
## 3 https://stackoverflow.blog/2017/06/15/developers-use-spaces-make-money-use-tabs/
##   mentions_screen_name mentions_user_id symbols           hashtags
## 1            Rbloggers        144592995      NA rstats DataScience
## 2            revodavid         34677653      NA             rstats
## 3                 drob         46245868      NA             rstats
##   coordinates place_id place_type place_name place_full_name country_code
## 1          NA       NA         NA         NA              NA           NA
## 2          NA       NA         NA         NA              NA           NA
## 3          NA       NA         NA         NA              NA           NA
##   country bounding_box_coordinates bounding_box_type
## 1      NA                       NA                NA
## 2      NA                       NA                NA
## 3      NA                       NA                NA
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
##     screen_name    user_id          created_at          status_id
## 1   EHeitlinger 4883153423 2017-06-15 20:09:16 875445122489618434
## 2 rileymsmith19  210046218 2017-06-15 19:59:48 875442739084615685
##                                                                                                                                               text
## 1        @IRILifeSciences Among other great projects: @GaetanBurgio and myself looking for a PhD student with  #Bioinformatics and #rstats skills.
## 2 imo, tabs are unintuitive and less versatile, so: [use of spaces] ~~ [intuitive &amp; versatile code / programming skil… https://t.co/AQZuIDpQtl
##   retweet_count favorite_count is_quote_status    quote_status_id
## 1             0              0           FALSE               <NA>
## 2             0              0            TRUE 875340314231361536
##   is_retweet retweet_status_id in_reply_to_status_status_id
## 1      FALSE              <NA>           874365094305701892
## 2      FALSE              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                 4155249821                IRILifeSciences   en
## 2                       <NA>                           <NA>   en
##                source media_id media_url media_url_expanded urls
## 1 Twitter for Android     <NA>      <NA>               <NA> <NA>
## 2  Twitter for iPhone     <NA>      <NA>               <NA> <NA>
##                  urls_display
## 1                        <NA>
## 2 twitter.com/i/web/status/8…
##                                         urls_expanded
## 1                                                <NA>
## 2 https://twitter.com/i/web/status/875442739084615685
##           mentions_screen_name      mentions_user_id symbols
## 1 IRILifeSciences GaetanBurgio 4155249821 2731401072      NA
## 2                         <NA>                  <NA>      NA
##                hashtags coordinates place_id place_type place_name
## 1 Bioinformatics rstats          NA     <NA>       <NA>       <NA>
## 2                  <NA>          NA     <NA>       <NA>       <NA>
##   place_full_name country_code country bounding_box_coordinates
## 1            <NA>         <NA>    <NA>                     <NA>
## 2            <NA>         <NA>    <NA>                     <NA>
##   bounding_box_type
## 1              <NA>
## 2              <NA>
```

Next, let's figure out who is tweeting about `R` / using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "EHeitlinger"   "rileymsmith19" "rweekly_live"  "DerFredo"     
## [5] "peterwsetter"  "DeborahTannon"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "EHeitlinger"     "rileymsmith19"   "rweekly_live"   
##   [4] "DerFredo"        "peterwsetter"    "DeborahTannon"  
##   [7] "Rbloggers"       "thomasp85"       "Rexercises"     
##  [10] "kzeller"         "rstatsdata"      "CRANberriesFeed"
##  [13] "UT_OIT"          "AnalyticsVidhya" "sckottie"       
##  [16] "edzerpebesma"    "groundwalkergmb" "dataandme"      
##  [19] "analisereal"     "DataScienceCtrl" "dwhitena"       
##  [22] "nielsberglund"   "cehagmann"       "revodavid"      
##  [25] "hrbrmstr"        "lukeberman"      "chrissuthy"     
##  [28] "Hacktuarial"     "KenSteif"        "fgilardi"       
##  [31] "tangming2005"    "LucasANell"      "BroVic"         
##  [34] "ellamkaye"       "RobThomas14"     "pachamaltese"   
##  [37] "DaveOnData"      "EikoFried"       "hannah_recht"   
##  [40] "liberrenaud"     "BobMuenchen"     "apreshill"      
##  [43] "JulHeimer"       "jazzejay_"       "CFGT_Edinburgh" 
##  [46] "kennethrose82"   "alex_filazzola"  "KrisEberwein"   
##  [49] "jletteboer"      "BigDataInsights" "fmic_"          
##  [52] "mherradora"      "gshotwell"       "ryanalight"     
##  [55] "iliastsergoulas" "aneil_ad"        "RLangTip"       
##  [58] "zkajdan"         "raccoonrebels"   "Carles_"        
##  [61] "StephenEglen"    "RLadiesBA"       "jaimedash"      
##  [64] "Pillolaio"       "Ognyanova"       "moroam"         
##  [67] "KVittingSeerup"  "suman12029"      "thinkR_fr"      
##  [70] "RobCalver5"      "Euliostat"       "rmflight"       
##  [73] "MilesMcBain"     "drob"            "DennisMurray"   
##  [76] "sjGoring"        "HelixHacker"     "aridhia"        
##  [79] "Larnsce"         "thosjleeper"     "sharon000"      
##  [82] "CoreySparks1"    "davidjayharris"  "v_vashishta"    
##  [85] "jonintweet"      "duc_qn"          "sociographie"   
##  [88] "ttso"            "meetup_r_nantes" "LockeData"      
##  [91] "ConcejeroPedro"  "ma_salmon"       "MangoTheCat"    
##  [94] "AmidstScience"   "BeckySpake"      "JeanManguy"     
##  [97] "kklmmr"          "znmeb"           "CardiffRUG"     
## [100] "seolinxx"        "EcographyJourna" "SanghaChick"    
## [103] "ErmiaBivatan"    "nikkirubinstein" "axiomsofxyz"    
## [106] "pjs_228"         "YourStatsGuru"   "Samosthenurus"  
## [109] "LeMoussel"       "daattali"        "DailyRpackage"  
## [112] "CookieSci"       "DataWookie"      "shanemeister1"  
## [115] "ansellbr3"       "DataconomyMedia" "andrewheiss"    
## [118] "KermytAnderson"  "ASpannbauer"     "zentree"        
## [121] "wilkinshau"      "TimDoherty_"     "RABigdatajobs"  
## [124] "timelyportfolio" "BrodieGaslam"    "rbloggersBR"    
## [127] "cartesianfaith"  "regionomics"     "joewillage"     
## [130] "YaleSportsGroup" "PPUAMX"          "nj_tierney"     
## [133] "KirkDBorne"      "guangchuangyu"   "acalatr"        
## [136] "tladeras"        "RStudioJoe"      "Klaus_Schlp"    
## [139] "MDFBasha"        "kdnuggets"       "mdsumner"       
## [142] "pimpmymemory"    "AvrahamAdler"    "wlharder"       
## [145] "aschinchon"      "BilliyoRS"       "brennanpcardiff"
## [148] "m_ezkiel"        "tjmahr"          "Tazmaaan"       
## [151] "Suitsgeeks"      "elpidiofilho"    "SergeyKochergan"
## [154] "jakub_nowosad"   "the18gen"        "adnan_hashmi"   
## [157] "ajinkyakale"     "abresler"        "beckfrydenborg" 
## [160] "rushworth_a"     "alexpghayes"     "BrunaLab"       
## [163] "AriLamstein"     "TinaACormier"    "ismaelgomezs"   
## [166] "StrictlyStat"    "espinielli"      "dsacademybr"    
## [169] "pherreraariza"   "conjugateprior"  "KamilSJaron"    
## [172] "gregrs_uk"       "DevBizInfoGuy"   "rOpenSci"       
## [175] "NicholasStrayer" "old_man_chester" "CSCU_Cornell"   
## [178] "henrikbengtsson" "HaPaMuyGuapo"    "FloodHydrology" 
## [181] "cpsievert"       "TransmitScience" "PStrafo"        
## [184] "matamix"         "n_ashutosh"      "gigi_rose"      
## [187] "RLadiesLdnOnt"   "AniMove"         "stoltzmaniac"   
## [190] "csgillespie"     "markvdloo"       "david_body"     
## [193] "APlaceforData"   "ioannides_alex"  "kazlabtwitt"    
## [196] "JBoyle_Paleo"    "Morgs_John"      "willpkay"       
## [199] "kxsystems"       "nbrodnax"        "awhstin"        
## [202] "ingorohlfing"    "MaHorn16"        "rick_pack2"     
## [205] "BrockTibert"     "noamross"        "hfmuehleisen"   
## [208] "lgatt0"          "datascienceplus" "DrOliverHooker" 
## [211] "VizMonkey"       "Xtophe_Bontemps" "lucaborger"     
## [214] "4orgexcellence"  "Emz3l"           "DataSci_Ireland"
## [217] "PatersonHelena"  "MrYeti1"         "SteffLocke"     
## [220] "jmgomez"         "AppsilonDS"      "matej_hruska"   
## [223] "scottyd22"       "UrologyMatch"    "statsforbios"   
## [226] "Mista_Woza"      "_jimduggan"      "fjnogales"      
## [229] "anchorage40"     "_J_sinclair"     "statsepi"       
## [232] "zkuralt"         "symbolixAU"      "d4t4v1z"        
## [235] "truemoid"        "janschulz"       "neilkutty"      
## [238] "ctlente"         "DBaker007"       "thomas_sandmann"
## [241] "aksingh1985"     "eddelbuettel"    "tomelliottnz"
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
##    user_id           name screen_name       location
## 1 24228154  Hilary Parker      hspter San Francisco 
## 2 46245868 David Robinson        drob   New York, NY
##                                                                                                                description
## 1 Data Scientist @StitchFix, formerly @Etsy. Biostatistics PhD from Hopkins. Co-host of @NSSDeviations #rstats #rcatladies
## 2                                                                 Data Scientist at @StackOverflow, #rstats fan/evangelist
##   protected followers_count friends_count listed_count          created_at
## 1     FALSE           14543          1858          675 2009-03-13 18:59:32
## 2     FALSE           11299           414          510 2009-06-10 22:36:18
##   favourites_count utc_offset                  time_zone geo_enabled
## 1            27075     -14400 Eastern Time (US & Canada)        TRUE
## 2             6569     -14400 Eastern Time (US & Canada)        TRUE
##   verified statuses_count lang contributors_enabled is_translator
## 1    FALSE          21705   en                FALSE         FALSE
## 2    FALSE           5899   en                FALSE         FALSE
##   is_translation_enabled profile_background_color
## 1                  FALSE                   352726
## 2                  FALSE                   C0DEED
##                                                                     profile_background_image_url
## 1 http://pbs.twimg.com/profile_background_images/750034226/bef865f13b9261684fd75ac9544a04ed.jpeg
## 2                                               http://abs.twimg.com/images/themes/theme1/bg.png
##                                                                profile_background_image_url_https
## 1 https://pbs.twimg.com/profile_background_images/750034226/bef865f13b9261684fd75ac9544a04ed.jpeg
## 2                                               https://abs.twimg.com/images/themes/theme1/bg.png
##   profile_background_tile
## 1                    TRUE
## 2                   FALSE
##                                                            profile_image_url
## 1 http://pbs.twimg.com/profile_images/611535712710729728/ZrqMrN21_normal.jpg
## 2    http://pbs.twimg.com/profile_images/777175344/David_Robinson_normal.jpg
##                                                       profile_image_url_https
## 1 https://pbs.twimg.com/profile_images/611535712710729728/ZrqMrN21_normal.jpg
## 2    https://pbs.twimg.com/profile_images/777175344/David_Robinson_normal.jpg
##                                                          profile_image_url.1
## 1 http://pbs.twimg.com/profile_images/611535712710729728/ZrqMrN21_normal.jpg
## 2    http://pbs.twimg.com/profile_images/777175344/David_Robinson_normal.jpg
##                                                     profile_image_url_https.1
## 1 https://pbs.twimg.com/profile_images/611535712710729728/ZrqMrN21_normal.jpg
## 2    https://pbs.twimg.com/profile_images/777175344/David_Robinson_normal.jpg
##   profile_link_color profile_sidebar_border_color
## 1             D02B55                       FFFFFF
## 2             1DA1F2                       C0DEED
##   profile_sidebar_fill_color profile_text_color
## 1                     99CC33             3E4415
## 2                     DDEEF6             333333
##   profile_use_background_image default_profile default_profile_image
## 1                         TRUE           FALSE                 FALSE
## 2                         TRUE            TRUE                 FALSE
##                                          profile_banner_url
## 1 https://pbs.twimg.com/profile_banners/24228154/1468982290
## 2                                                      <NA>
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 306

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
