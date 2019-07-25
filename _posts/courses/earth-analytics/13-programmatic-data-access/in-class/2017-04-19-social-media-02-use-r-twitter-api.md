---
layout: single
title: "Twitter Data in R Using Rtweet: Analyze and Download Twitter Data"
excerpt: "You can use the Twitter RESTful API to access data about Twitter users and tweets. Learn how to use rtweet to download and analyze twitter social media data in R."
authors: ['Leah Wasser','Carson Farmer']
modified: '2019-07-25'
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
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)
```


If authentication is successful works, it should render the following message in
a browser window:

`Authentication complete. Please close this page and return to R.`

### Send a Tweet

Note that your tweet needs to be 140 characters or less.


```r
# post a tweet from R
post_tweet("Look, i'm tweeting from R in my #rstats #earthanalytics class! @EarthLabCU")
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
## # A tibble: 3 x 90
##   user_id status_id created_at          screen_name text  source
##   <chr>   <chr>     <dttm>              <chr>       <chr> <chr> 
## 1 388530… 11544465… 2019-07-25 17:41:21 thomhutter  "The… Twitt…
## 2 101181… 11544464… 2019-07-25 17:41:00 rstatstweet #rst… rstat…
## 3 101181… 11544464… 2019-07-25 17:40:59 rstatstweet @Pra… rstat…
## # … with 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>,
## #   ext_media_url <list>, ext_media_t.co <list>,
## #   ext_media_expanded_url <list>, ext_media_type <chr>,
## #   mentions_user_id <list>, mentions_screen_name <list>, lang <chr>,
## #   quoted_status_id <chr>, quoted_text <chr>, quoted_created_at <dttm>,
## #   quoted_source <chr>, quoted_favorite_count <int>,
## #   quoted_retweet_count <int>, quoted_user_id <chr>,
## #   quoted_screen_name <chr>, quoted_name <chr>,
## #   quoted_followers_count <int>, quoted_friends_count <int>,
## #   quoted_statuses_count <int>, quoted_location <chr>,
## #   quoted_description <chr>, quoted_verified <lgl>,
## #   retweet_status_id <chr>, retweet_text <chr>,
## #   retweet_created_at <dttm>, retweet_source <chr>,
## #   retweet_favorite_count <int>, retweet_retweet_count <int>,
## #   retweet_user_id <chr>, retweet_screen_name <chr>, retweet_name <chr>,
## #   retweet_followers_count <int>, retweet_friends_count <int>,
## #   retweet_statuses_count <int>, retweet_location <chr>,
## #   retweet_description <chr>, retweet_verified <lgl>, place_url <chr>,
## #   place_name <chr>, place_full_name <chr>, place_type <chr>,
## #   country <chr>, country_code <chr>, geo_coords <list>,
## #   coords_coords <list>, bbox_coords <list>, status_url <chr>,
## #   name <chr>, location <chr>, description <chr>, url <chr>,
## #   protected <lgl>, followers_count <int>, friends_count <int>,
## #   listed_count <int>, statuses_count <int>, favourites_count <int>,
## #   account_created_at <dttm>, verified <lgl>, profile_url <chr>,
## #   profile_expanded_url <chr>, account_lang <lgl>,
## #   profile_banner_url <chr>, profile_background_url <chr>,
## #   profile_image_url <chr>
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
## # A tibble: 2 x 90
##   user_id status_id created_at          screen_name text  source
##   <chr>   <chr>     <dttm>              <chr>       <chr> <chr> 
## 1 146292… 11544461… 2019-07-25 17:39:55 JonTheGeek  #rst… Twitt…
## 2 488480… 11544445… 2019-07-25 17:33:18 rmflight    @Pra… Tweet…
## # … with 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>,
## #   ext_media_url <list>, ext_media_t.co <list>,
## #   ext_media_expanded_url <list>, ext_media_type <chr>,
## #   mentions_user_id <list>, mentions_screen_name <list>, lang <chr>,
## #   quoted_status_id <chr>, quoted_text <chr>, quoted_created_at <dttm>,
## #   quoted_source <chr>, quoted_favorite_count <int>,
## #   quoted_retweet_count <int>, quoted_user_id <chr>,
## #   quoted_screen_name <chr>, quoted_name <chr>,
## #   quoted_followers_count <int>, quoted_friends_count <int>,
## #   quoted_statuses_count <int>, quoted_location <chr>,
## #   quoted_description <chr>, quoted_verified <lgl>,
## #   retweet_status_id <chr>, retweet_text <chr>,
## #   retweet_created_at <dttm>, retweet_source <chr>,
## #   retweet_favorite_count <int>, retweet_retweet_count <int>,
## #   retweet_user_id <chr>, retweet_screen_name <chr>, retweet_name <chr>,
## #   retweet_followers_count <int>, retweet_friends_count <int>,
## #   retweet_statuses_count <int>, retweet_location <chr>,
## #   retweet_description <chr>, retweet_verified <lgl>, place_url <chr>,
## #   place_name <chr>, place_full_name <chr>, place_type <chr>,
## #   country <chr>, country_code <chr>, geo_coords <list>,
## #   coords_coords <list>, bbox_coords <list>, status_url <chr>,
## #   name <chr>, location <chr>, description <chr>, url <chr>,
## #   protected <lgl>, followers_count <int>, friends_count <int>,
## #   listed_count <int>, statuses_count <int>, favourites_count <int>,
## #   account_created_at <dttm>, verified <lgl>, profile_url <chr>,
## #   profile_expanded_url <chr>, account_lang <lgl>,
## #   profile_banner_url <chr>, profile_background_url <chr>,
## #   profile_image_url <chr>
```

Next, let's figure out who is tweeting about `R` using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "JonTheGeek"    "rmflight"      "TomPinckney27" "OpenAnalytics"
## [5] "brad_weiner"   "brad_weiner"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "JonTheGeek"      "rmflight"        "TomPinckney27"  
##   [4] "OpenAnalytics"   "brad_weiner"     "thecomeonman"   
##   [7] "ElinVidevall"    "rocitations"     "dannigadd"      
##  [10] "HugoPedder"      "Lucy_Kinski"     "datawookie"     
##  [13] "earlconf"        "leN_a"           "mortejen"       
##  [16] "benjaminknoll28" "michael_chirico" "phillynerd"     
##  [19] "SteveOrmerod"    "tidyversetweets" "datasartoriasf" 
##  [22] "AppliedInfoNott" "verajosemanuel"  "MattCrump_"     
##  [25] "CRANberriesFeed" "YrBFFAnna"       "cimentadaj"     
##  [28] "Argaadya1"       "rladieskc"       "nssmmn"         
##  [31] "_ColinFay"       "R_by_Ryo"        "HamzaRa15004619"
##  [34] "LarissaKostiw"   "d_olivaw"        "jlservadio"     
##  [37] "dataandme"       "NSchmerSchmer"   "oscar_b123"     
##  [40] "university_data" "TarasNovak"      "juliafstrand"   
##  [43] "BrockTibert"     "StatsMarin"      "LisaScheiwe"    
##  [46] "ilustat"         "spgreenhalgh"    "gp_pulipaka"    
##  [49] "_abichat"        "tangming2005"    "MangoTheCat"    
##  [52] "lorelai66"       "MikeRSpencer"    "kareem_carr"    
##  [55] "antoine_fabri"   "Rkatlady"        "arthur_spirling"
##  [58] "WitJakuczun"     "ZurichRUsers"    "joranelias"     
##  [61] "geoffjentry"     "BrodieGaslam"    "SwampThingPaul" 
##  [64] "zappingseb"      "JosephineLukito" "ingorohlfing"   
##  [67] "radmuzom"        "EvaMaeRey"       "leonawicz"      
##  [70] "ntweetor"        "rushworth_a"     "ste_mueller"    
##  [73] "mdsumner"        "BillPetti"       "jordimunozm"    
##  [76] "divadnojnarg"    "ameisen_strasse" "mmrbcd"         
##  [79] "opencpu"         "javierluraschi"  "NumFOCUS"       
##  [82] "dsquintana"      "DavidJohnBaker"  "caprico_aries"  
##  [85] "barcanumbers"    "frasermorton"    "StockViz"       
##  [88] "sinafala"        "hrbrmstr"        "jtrecenti"      
##  [91] "traffordDataLab" "mdancho84"       "nmorstanlee"    
##  [94] "mrjoh3"          "EpiBiostats_UCT" "rugnepal"       
##  [97] "Shedimus"        "danidlsa"        "diwastha"       
## [100] "RLangPackage"    "bluedept4"       "antonwasson"    
## [103] "RobCalver5"      "erinhsiao3"      "malko_dee"      
## [106] "MalariaAtlas"    "Psychology_Andy" "OdioEstadistica"
## [109] "hlageek"         "UK_PetDogPop"    "BlasBenito"     
## [112] "r_vaquerizo"     "jlopezper"       "LjJot"          
## [115] "vpettorino"      "ngamita"         "RLadiesJozi"    
## [118] "DiegoKuonen"     "RealDrPaul"      "Highcharts"     
## [121] "iiijohan"        "ina_kostakis"    "fruce_ki"       
## [124] "Minerva_stat"    "derboyausleu"    "RookieNumeric"  
## [127] "HMetcalfe1"      "Arfness"         "RBrinks"        
## [130] "ElenLeFoll"      "jo_rainer"       "NoorDinTech"    
## [133] "THEAdamGabriel"  "rushanicus"      "juli_tkotz"     
## [136] "Alice_R_Jones"   "rvidal"          "DataSkillsDev"  
## [139] "rweekly_live"    "avoundji"        "perspectivalean"
## [142] "ConallOM"        "Godskid_CFC"     "shibettes"      
## [145] "mjfrigaard"      "PositronicNetRJ" "humanfactorsio" 
## [148] "vosonlab"        "obergr"          "rstudio"        
## [151] "ImKintsugi"      "vizualdatos"     "fellgernon"     
## [154] "theRcast"        "pakinproton"     "vishal_katti"   
## [157] "SuperCroup"      "latimerchris1"   "andreaketchum"  
## [160] "daily_r_sheets"  "AndrewRenninger" "CalenRyan"      
## [163] "cenuno_"         "lenkiefer"       "bduckles"       
## [166] "MattMotyl"       "ClaytonTLamb"    "coolbutuseless" 
## [169] "AllbriteAllday"  "DKMonroeonIT"    "raericksonWI"   
## [172] "kevinwxsoo"      "DerFredo"        "Rbloggers"      
## [175] "RLadiesChicago"  "GiuseppeMinar14" "IhaddadenFodil" 
## [178] "wouldeye125"     "thecarpentries"  "DrRachelHeath"  
## [181] "KirkDBorne"      "ozjimbob"        "NeptuneML"      
## [184] "kdillmcfarland"  "paulonabike"     "renbaires"      
## [187] "bencasselman"    "rlbarter"        "RevDocGabriel"  
## [190] "dataquestio"     "elaragon"        "Harkive"        
## [193] "JuniperLSimonis" "khailper"        "gabrielacaesar" 
## [196] "OgorekDataSci"   "pjbull"          "beccabryanne"   
## [199] "duc_qn"          "mickle_od"       "ncsulibresearch"
## [202] "regionomics"     "JDHaltigan"      "stevenvmiller"  
## [205] "yooylee"         "MihiretuKebede1" "PodsProgram"    
## [208] "arvind_ilamaran" "LanderAnalytics" "TuQmano"        
## [211] "J0HNST0N"        "kiernxn"         "crimny"         
## [214] "jakekaupp"       "Juanma_MN"       "DocGallJr"      
## [217] "tylermorganwall" "W_R_Chase"       "rstatsdata"     
## [220] "krlmlr"          "murielburi"      "mmparker"       
## [223] "JosiahParry"     "NCrepalde"       "ryantimpe"      
## [226] "hsianghui"       "kearneymw"       "frasmcm"        
## [229] "NestorMontano"   "RLadiesGlobal"   "gjmount"        
## [232] "harrocyranka"    "potterzot"       "Hao_and_Y"      
## [235] "OmniAnalytics"   "bowmanimal"      "jhollist"       
## [238] "DataCamp"        "RLangTip"        "_ashleykern"    
## [241] "jtleek"          "alexwhan"        "Dr_Joe_Roberts" 
## [244] "LindsayRCPlatt"  "meharpsingh"     "ProCogia"       
## [247] "IW_lovescience"  "EstadisticaUVa"  "gshotwell"      
## [250] "aggieerin"       "BenjaminWolfe"   "OilGains"       
## [253] "tech_jessi"      "thinkR_fr"       "noccaea"        
## [256] "james_azam"      "aschinchon"      "Wences91"       
## [259] "Revistas_Cult"   "revodavid"       "ryanpkyle"      
## [262] "er13_r"          "AndrewBarnas"    "sckottie"       
## [265] "YYCist"          "LeoCynosure"     "trizniak"       
## [268] "GonzoScientist1" "GwenAntell"      "ChetanChawla"   
## [271] "NTGuardian"      "rOpenSci"        "R_Hisp"         
## [274] "taraskaduk"      "r_medicine"      "ninarbrooks"    
## [277] "humeursdevictor" "laubolgo"        "NateApathy"     
## [280] "jonathon_mifsud" "Kuprinasha"      "R4DScommunity"  
## [283] "EANBoard"        "ClarkGRichards"  "chrismainey"    
## [286] "thomas_mock"     "adolfoalvarez"   "sharon000"      
## [289] "opisthokonta"    "EJSbrocco"       "markrt"         
## [292] "JamieSimonson"   "patilindrajeets" "BenjaminSchwetz"
## [295] "mario_angst_sci" "jafcpereira"     "Diego_Koz"      
## [298] "KKulma"          "RefaelLav"       "DionneArgy"     
## [301] "orchid00"        "joedgallagher"   "ZKamvar"        
## [304] "cambUP_maths"    "biologeek"       "exegeticdata"   
## [307] "yangliubeijing"  "cortina_borja"   "walkingrandomly"
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
## # A tibble: 2 x 90
##   user_id status_id created_at          screen_name text  source
##   <chr>   <chr>     <dttm>              <chr>       <chr> <chr> 
## 1 101181… 11544464… 2019-07-25 17:41:00 rstatstweet #rst… rstat…
## 2 107501… 11544276… 2019-07-25 16:26:26 rstats4ds   Make… R sta…
## # … with 84 more variables: display_text_width <dbl>,
## #   reply_to_status_id <chr>, reply_to_user_id <chr>,
## #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
## #   favorite_count <int>, retweet_count <int>, quote_count <int>,
## #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
## #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
## #   media_t.co <list>, media_expanded_url <list>, media_type <list>,
## #   ext_media_url <list>, ext_media_t.co <list>,
## #   ext_media_expanded_url <list>, ext_media_type <chr>,
## #   mentions_user_id <list>, mentions_screen_name <list>, lang <chr>,
## #   quoted_status_id <chr>, quoted_text <chr>, quoted_created_at <dttm>,
## #   quoted_source <chr>, quoted_favorite_count <int>,
## #   quoted_retweet_count <int>, quoted_user_id <chr>,
## #   quoted_screen_name <chr>, quoted_name <chr>,
## #   quoted_followers_count <int>, quoted_friends_count <int>,
## #   quoted_statuses_count <int>, quoted_location <chr>,
## #   quoted_description <chr>, quoted_verified <lgl>,
## #   retweet_status_id <chr>, retweet_text <chr>,
## #   retweet_created_at <dttm>, retweet_source <chr>,
## #   retweet_favorite_count <int>, retweet_retweet_count <int>,
## #   retweet_user_id <chr>, retweet_screen_name <chr>, retweet_name <chr>,
## #   retweet_followers_count <int>, retweet_friends_count <int>,
## #   retweet_statuses_count <int>, retweet_location <chr>,
## #   retweet_description <chr>, retweet_verified <lgl>, place_url <chr>,
## #   place_name <chr>, place_full_name <chr>, place_type <chr>,
## #   country <chr>, country_code <chr>, geo_coords <list>,
## #   coords_coords <list>, bbox_coords <list>, status_url <chr>,
## #   name <chr>, location <chr>, description <chr>, url <chr>,
## #   protected <lgl>, followers_count <int>, friends_count <int>,
## #   listed_count <int>, statuses_count <int>, favourites_count <int>,
## #   account_created_at <dttm>, verified <lgl>, profile_url <chr>,
## #   profile_expanded_url <chr>, account_lang <lgl>,
## #   profile_banner_url <chr>, profile_background_url <chr>,
## #   profile_image_url <chr>
```

Let's learn a bit more about these people tweeting about `R`. First, where are
they from?


```r
# how many locations are represented
length(unique(users$location))
## [1] 320

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
      labs(x = "Count",
      y = "Location",
      title = "Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/courses/earth-analytics-r/13-programmatic-data-access/in-class/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="90%" />

Let's sort by count and just plot the top locations. To do this, you use top_n().
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

<img src="{{ site.url }}/images/courses/earth-analytics-r/13-programmatic-data-access/in-class/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="90%" />

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

<img src="{{ site.url }}/images/courses/earth-analytics-r/13-programmatic-data-access/in-class/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="90%" />

Looking at your data, what do you notice that might improve this plot?
There are 314 unique locations in your list. However, everyone didn't specify their
locations using the approach. For example some just identified their country:
United States for example and others specified a city and state. You may want to
do some cleaning of these data to be able to better plot this distribution - especially
if you want to create a map of these data!

### Users by Time Zone

Let's have a look at the time zone field next.



```r
users %>% na.omit() %>%
  ggplot(aes(time_zone)) +
  geom_bar() + coord_flip() +
      labs(x = "Count",
      y = "Time Zone",
      title = "Twitter users - unique time zones ")
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge

Use the example above, plot users by time zone. List time zones that have at least
20 users associated with them. What do you notice about the data?
</div>



The plots above aren't perfect. What do you start to notice about working
with these data? Can you simply download them and plot the data?

## Data munging  101

When you work with data from sources like NASA, USGS, etc. there are particular
cleaning steps that you often need to do. For instance:

* you may need to remove nodata values
* you may need to scale the data
* and others

In the next lesson, you will dive deeper into the art of "text-mining" to extract
information about a particular topic from twitter.


<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://tidytextmining.com/" target="_blank">Tidy text mining online book</a>
* <a href="https://mkearney.github.io/rtweet/articles/intro.html#retrieving-trends" target="_blank">A great overview of the rtweet package by Mike Kearny</a>
* <a href="https://francoismichonneau.net/2017/04/tidytext-origins-of-species/" target="_blank">A blog post on tidytext by Francois Michonneau</a>
*  <a href="https://blog.twitter.com/2008/what-does-rate-limit-exceeded-mean-updated" target="_blank">About the twitter API rate limit</a>

</div>
