---
layout: single
title: "Twitter Data in R Using Rtweet: Analyze and Download Twitter Data"
excerpt: "You can use the Twitter RESTful API to access data about Twitter users and tweets. Learn how to use rtweet to download and analyze twitter social media data in R."
authors: ['Leah Wasser','Carson Farmer']
modified: '2020-03-11'
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
## 1 885513… 12378770… 2020-03-11 23:04:18 Taieb_Bot   "Dee… Js_10…
## 2 885513… 12378696… 2020-03-11 22:34:52 Taieb_Bot   "Ste… Js_10…
## 3 885513… 12378676… 2020-03-11 22:27:04 Taieb_Bot   "How… Js_10…
## # … with 84 more variables: display_text_width <dbl>, reply_to_status_id <chr>,
## #   reply_to_user_id <chr>, reply_to_screen_name <chr>, is_quote <lgl>,
## #   is_retweet <lgl>, favorite_count <int>, retweet_count <int>,
## #   quote_count <int>, reply_count <int>, hashtags <list>, symbols <list>,
## #   urls_url <list>, urls_t.co <list>, urls_expanded_url <list>,
## #   media_url <list>, media_t.co <list>, media_expanded_url <list>,
## #   media_type <list>, ext_media_url <list>, ext_media_t.co <list>,
## #   ext_media_expanded_url <list>, ext_media_type <chr>,
## #   mentions_user_id <list>, mentions_screen_name <list>, lang <chr>,
## #   quoted_status_id <chr>, quoted_text <chr>, quoted_created_at <dttm>,
## #   quoted_source <chr>, quoted_favorite_count <int>,
## #   quoted_retweet_count <int>, quoted_user_id <chr>, quoted_screen_name <chr>,
## #   quoted_name <chr>, quoted_followers_count <int>,
## #   quoted_friends_count <int>, quoted_statuses_count <int>,
## #   quoted_location <chr>, quoted_description <chr>, quoted_verified <lgl>,
## #   retweet_status_id <chr>, retweet_text <chr>, retweet_created_at <dttm>,
## #   retweet_source <chr>, retweet_favorite_count <int>,
## #   retweet_retweet_count <int>, retweet_user_id <chr>,
## #   retweet_screen_name <chr>, retweet_name <chr>,
## #   retweet_followers_count <int>, retweet_friends_count <int>,
## #   retweet_statuses_count <int>, retweet_location <chr>,
## #   retweet_description <chr>, retweet_verified <lgl>, place_url <chr>,
## #   place_name <chr>, place_full_name <chr>, place_type <chr>, country <chr>,
## #   country_code <chr>, geo_coords <list>, coords_coords <list>,
## #   bbox_coords <list>, status_url <chr>, name <chr>, location <chr>,
## #   description <chr>, url <chr>, protected <lgl>, followers_count <int>,
## #   friends_count <int>, listed_count <int>, statuses_count <int>,
## #   favourites_count <int>, account_created_at <dttm>, verified <lgl>,
## #   profile_url <chr>, profile_expanded_url <chr>, account_lang <lgl>,
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
## 1 123787… 12378767… 2020-03-11 23:03:18 iloverstud… "Enj… rstat…
## 2 233585… 12378764… 2020-03-11 23:02:10 CRANberrie… "CRA… CRANb…
## # … with 84 more variables: display_text_width <dbl>, reply_to_status_id <chr>,
## #   reply_to_user_id <chr>, reply_to_screen_name <chr>, is_quote <lgl>,
## #   is_retweet <lgl>, favorite_count <int>, retweet_count <int>,
## #   quote_count <int>, reply_count <int>, hashtags <list>, symbols <list>,
## #   urls_url <list>, urls_t.co <list>, urls_expanded_url <list>,
## #   media_url <list>, media_t.co <list>, media_expanded_url <list>,
## #   media_type <list>, ext_media_url <list>, ext_media_t.co <list>,
## #   ext_media_expanded_url <list>, ext_media_type <chr>,
## #   mentions_user_id <list>, mentions_screen_name <list>, lang <chr>,
## #   quoted_status_id <chr>, quoted_text <chr>, quoted_created_at <dttm>,
## #   quoted_source <chr>, quoted_favorite_count <int>,
## #   quoted_retweet_count <int>, quoted_user_id <chr>, quoted_screen_name <chr>,
## #   quoted_name <chr>, quoted_followers_count <int>,
## #   quoted_friends_count <int>, quoted_statuses_count <int>,
## #   quoted_location <chr>, quoted_description <chr>, quoted_verified <lgl>,
## #   retweet_status_id <chr>, retweet_text <chr>, retweet_created_at <dttm>,
## #   retweet_source <chr>, retweet_favorite_count <int>,
## #   retweet_retweet_count <int>, retweet_user_id <chr>,
## #   retweet_screen_name <chr>, retweet_name <chr>,
## #   retweet_followers_count <int>, retweet_friends_count <int>,
## #   retweet_statuses_count <int>, retweet_location <chr>,
## #   retweet_description <chr>, retweet_verified <lgl>, place_url <chr>,
## #   place_name <chr>, place_full_name <chr>, place_type <chr>, country <chr>,
## #   country_code <chr>, geo_coords <list>, coords_coords <list>,
## #   bbox_coords <list>, status_url <chr>, name <chr>, location <chr>,
## #   description <chr>, url <chr>, protected <lgl>, followers_count <int>,
## #   friends_count <int>, listed_count <int>, statuses_count <int>,
## #   favourites_count <int>, account_created_at <dttm>, verified <lgl>,
## #   profile_url <chr>, profile_expanded_url <chr>, account_lang <lgl>,
## #   profile_banner_url <chr>, profile_background_url <chr>,
## #   profile_image_url <chr>
```

Next, let's figure out who is tweeting about `R` using the `#rstats` hashtag.


```r
# view column with screen names - top 6
head(rstats_tweets$screen_name)
## [1] "iloverstudio"    "CRANberriesFeed" "CRANberriesFeed" "CRANberriesFeed"
## [5] "CRANberriesFeed" "CRANberriesFeed"
# get a list of unique usernames
unique(rstats_tweets$screen_name)
##   [1] "iloverstudio"    "CRANberriesFeed" "tidyversetweets" "rweekly_live"   
##   [5] "eddelbuettel"    "gp_pulipaka"     "rkatlady"        "dcruvolo"       
##   [9] "tomjemmett"      "JocelynGee2"     "noatamir"        "ludictech"      
##  [13] "conor_tompkins"  "DeepSingularity" "deanmarchiori"   "MT_statistics"  
##  [17] "R4DScommunity"   "datalorax_"      "icymi_r"         "KrohnZone"      
##  [21] "uwepidemiology"  "le_james94"      "DerFredo"        "gavinprm"       
##  [25] "r_vaquerizo"     "dickoah"         "kenglish95"      "jebyrnes"       
##  [29] "Rbloggers"       "rajat1589"       "brshallo"        "Ammer_B"        
##  [33] "JZKoehn"         "dirk_sch"        "southmapr"       "KnoxDataSci"    
##  [37] "grrrck"          "PHExaminer"      "rolandomirabalh" "marcus_volz"    
##  [41] "AppDemography"   "StatsForBios"    "allhoff_joachim" "earlconf"       
##  [45] "Simmie_kafaru"   "gbganalyst"      "serdarbalci"     "villasenor_jc"  
##  [49] "crcgrubbsd"      "csgillespie"     "_RachaelDempsey" "johnmutiso_"    
##  [53] "alexpghayes"     "EnCZ7"           "_Riinu_"         "data_nurse"     
##  [57] "oc_rug"          "d_olivaw"        "gamestat254"     "rstatsdata"     
##  [61] "MadelinePgh"     "ScienceUoA"      "djhocking"       "celebRtion2020" 
##  [65] "OB_scholarship"  "dgkeyes"         "hadleywickham"   "curso_r"        
##  [69] "dsquintana"      "ektaaa11"        "KateSouthern22"  "NumFOCUS"       
##  [73] "Rachel23865732"  "clasticdetritus" "zenrhino"        "clinarmo"       
##  [77] "drdcarpenter"    "kholy"           "States_AI_IA"    "freitas_lucas_" 
##  [81] "jmsjsph"         "pradeeperanti"   "janetrosenbaum"  "daszlosek"      
##  [85] "chlorophileB"    "benzorn"         "SineAndie"       "DianeBELDAME"   
##  [89] "divadnojnarg"    "Nickalenpsych"   "jessenleon"      "RLadiesMTL"     
##  [93] "knapply_"        "dreznik"         "DaveHWalsh"      "znmeb"          
##  [97] "smelly_waders"   "CorrelAid"       "abmathewks"      "MikeKSmith"     
## [101] "jladata"         "patri_vaquero_"  "mercuriusio"     "kearneymw"      
## [105] "Biohonos"        "Denironyx"       "ClaytonBesaw"    "adriannebrdfrd" 
## [109] "dbeau83"         "danicassol"      "JenWilkinsMango" "footloose_nil"  
## [113] "AnthonyBouc974"  "lukas_cycling"   "Eeysirhc"        "terrychristiani"
## [117] "RussIvanac"      "lkbobadilla"     "gorkang"         "RLangTip"       
## [121] "tylermorganwall" "YaNiPaper"       "Adam_C_Garber"   "anderbrooke"    
## [125] "ChrisJulien22"   "RoelandtN42"     "_J_sinclair"     "nosimpler_me"   
## [129] "MarsjaSe"        "AndgTrader"      "GonzoScientist1" "dataccino"      
## [133] "segasi"          "ThadryanJS"      "Satrdays_DC"     "ji_timedreamer" 
## [137] "AchimZeileis"    "BenjaminWolfe"   "jenstirrup"      "NHSrCommunity"  
## [141] "daniebrant"      "delaBJL"         "L_A_Kelly"       "RLadiesAnkara"  
## [145] "JulieTheBatgirl" "hrbrmstr"        "EJSbrocco"       "Ceo_Branding"   
## [149] "thomaselove"     "economeager"     "mdancho84"       "lobrowR"        
## [153] "dataandme"       "infoworld"       "MeghanMHall"     "StatnMap"       
## [157] "statworx"        "guangchuangyu"   "paleolimbot"     "jmcastagnetto"  
## [161] "haro_ca_"        "ByPeers"         "rdwinkelman"     "henrikbengtsson"
## [165] "BrodieGaslam"    "McKibbinUSA"     "Trifenol"        "HeathnEcologist"
## [169] "AliceRisely"     "Fahim_AY"        "patilindrajeets" "davsjob"        
## [173] "_Sandeep_N"      "NalimR"          "gladymar85"      "chainsawriot"   
## [177] "eliasdabbas"     "ace_ebert"       "BenBondLamberty" "fistful_of_bass"
## [181] "Primary_Immune"  "BeaCurious"      "DataChaz"        "haematobot"     
## [185] "MilesMcBain"     "pgshky"          "DylHicks"        "datavizpyr"     
## [189] "MyKo101AB"       "BroVic"          "RLangPackage"    "GrantChalmers"  
## [193] "D_Rodziewicz"    "jumping_uk"      "policyanddata"   "Xtophe_Bontemps"
## [197] "pH_Analytics"    "EswatiniUseR"    "ChrisKla47"      "Gummifot"       
## [201] "lapply"          "xavbarbier"      "martabofillr"    "iamJarrod1980"  
## [205] "Carike_B"        "EssexSumSchool"  "samukweku"       "icaroagostino"  
## [209] "amc_corporation" "_stephanieboyle" "BorisMericskay"  "hrhotz"         
## [213] "Fcorowe"         "chrishanretty"   "blog_SLR"        "Vdot_Spain"     
## [217] "caprico_aries"   "rooksbym"        "RLadiesBrisbane" "DavidZumbach"   
## [221] "verajosemanuel"  "DrLeo037"        "christoph_sax"   "MattyAnselmo"   
## [225] "danyaljaveed"    "Hung_TT_Nguyen"  "MadhanAlisha"    "agusnieto77"    
## [229] "Nithink70251862" "hanwengutierrez" "calvinmdewilde"  "drewroc6"       
## [233] "katieontheridge" "mickresearch"    "vinuct"          "canoodleson"    
## [237] "neilfws"         "nj_tierney"      "erikaris"        "FthrsAnalytics" 
## [241] "jim_gruman"      "threadreaderapp" "bluecology"      "abeer_shahreyar"
## [245] "daily_r_sheets"  "wild_ecology"    "ernestomirt"     "m_ezkiel"       
## [249] "regionomics"     "andre_peralta"   "dstrausser83"    "xvaca"          
## [253] "KirkDBorne"      "JasonWilliamsNY" "KathiJoH2O"      "ECOuture9"      
## [257] "Ubuntu8Touch"    "danilobzdok"     "MikeMahoney218"  "mjhendrickson"  
## [261] "Seferin4"        "WinVectorLLC"    "generativist"    "MikeMaieli"     
## [265] "krassowski_m"    "andrewheiss"     "FedeMolinaMagne" "scoutlais"      
## [269] "certifiedwaif"   "Aaron_Hawn"      "jucapitanio"     "sarah_sauve"    
## [273] "mikedecr"        "kdpsinghlab"     "jaseziv"         "rrvanderbilt"   
## [277] "vsbd"            "AnnoDomaini"     "marcel_campelo"  "DoctaDom"       
## [281] "dkelle"          "lovetheants"     "JeromyAnglim"    "yabellini"      
## [285] "noticiasSobreR"  "carlishganzino"  "g_casteleiro"    "gzanlorenssi"   
## [289] "RobertFrey40"    "ArielOrtizBobea" "Pedro_Rafael1"   "yanxian_l"      
## [293] "emilynz"         "ai_korg"         "rladiesbuchares" "brodriguesco"
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
## 1 961691… 12377838… 2020-03-11 16:54:02 FC_rstats   "@fo… Twitt…
## 2 101181… 12378736… 2020-03-11 22:51:02 rstatstweet "A C… rstat…
## # … with 84 more variables: display_text_width <dbl>, reply_to_status_id <chr>,
## #   reply_to_user_id <chr>, reply_to_screen_name <chr>, is_quote <lgl>,
## #   is_retweet <lgl>, favorite_count <int>, retweet_count <int>,
## #   quote_count <int>, reply_count <int>, hashtags <list>, symbols <list>,
## #   urls_url <list>, urls_t.co <list>, urls_expanded_url <list>,
## #   media_url <list>, media_t.co <list>, media_expanded_url <list>,
## #   media_type <list>, ext_media_url <list>, ext_media_t.co <list>,
## #   ext_media_expanded_url <list>, ext_media_type <chr>,
## #   mentions_user_id <list>, mentions_screen_name <list>, lang <chr>,
## #   quoted_status_id <chr>, quoted_text <chr>, quoted_created_at <dttm>,
## #   quoted_source <chr>, quoted_favorite_count <int>,
## #   quoted_retweet_count <int>, quoted_user_id <chr>, quoted_screen_name <chr>,
## #   quoted_name <chr>, quoted_followers_count <int>,
## #   quoted_friends_count <int>, quoted_statuses_count <int>,
## #   quoted_location <chr>, quoted_description <chr>, quoted_verified <lgl>,
## #   retweet_status_id <chr>, retweet_text <chr>, retweet_created_at <dttm>,
## #   retweet_source <chr>, retweet_favorite_count <int>,
## #   retweet_retweet_count <int>, retweet_user_id <chr>,
## #   retweet_screen_name <chr>, retweet_name <chr>,
## #   retweet_followers_count <int>, retweet_friends_count <int>,
## #   retweet_statuses_count <int>, retweet_location <chr>,
## #   retweet_description <chr>, retweet_verified <lgl>, place_url <chr>,
## #   place_name <chr>, place_full_name <chr>, place_type <chr>, country <chr>,
## #   country_code <chr>, geo_coords <list>, coords_coords <list>,
## #   bbox_coords <list>, status_url <chr>, name <chr>, location <chr>,
## #   description <chr>, url <chr>, protected <lgl>, followers_count <int>,
## #   friends_count <int>, listed_count <int>, statuses_count <int>,
## #   favourites_count <int>, account_created_at <dttm>, verified <lgl>,
## #   profile_url <chr>, profile_expanded_url <chr>, account_lang <lgl>,
## #   profile_banner_url <chr>, profile_background_url <chr>,
## #   profile_image_url <chr>
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
      labs(x = "Count",
      y = "Location",
      title = "Twitter users - unique locations ")
```

<img src="{{ site.url }}/images/courses/earth-analytics-r/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/explore-users-1.png" title="plot of users tweeting about R" alt="plot of users tweeting about R" width="90%" />

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

<img src="{{ site.url }}/images/courses/earth-analytics-r/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/users-tweeting-1.png" title="top 15 locations where people are tweeting" alt="top 15 locations where people are tweeting" width="90%" />

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

<img src="{{ site.url }}/images/courses/earth-analytics-r/13-programmatic-data-access/in-class/2017-04-19-social-media-02-use-r-twitter-api/users-tweeting2-1.png" title="top 15 locations where people are tweeting - na removed" alt="top 15 locations where people are tweeting - na removed" width="90%" />

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
* <a href="https://rtweet.info/articles/intro.html" target="_blank">A great overview of the rtweet package by Mike Kearny</a>
* <a href="https://francoismichonneau.net/2017/04/tidytext-origins-of-species/" target="_blank">A blog post on tidytext by Francois Michonneau</a>
*  <a href="https://blog.twitter.com/2008/what-does-rate-limit-exceeded-mean-updated" target="_blank">About the twitter API rate limit</a>

</div>
