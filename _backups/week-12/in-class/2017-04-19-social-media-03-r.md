---
layout: single
title: "Map... twitter data using rtweet"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-04-18'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/map-twitter-data-r/
nav-title: 'Mapping twitter data'
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 3
lang-lib:
  r: ['rtweet']
tags2:
  social-science: ['social-media']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

*

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>
## Geographic searches
- How about all recent tweets around Boulder (within 10 miles)?


```r
# About the center of Boulder... give or take
geocode <- '40.0150,-105.2705,50mi'
boulder_tweets <- search_tweets("", n=1000, lang="en",
                       geocode=geocode)
## Searching for tweets...
## Finished collecting tweets!
head(boulder_tweets)
##       screen_name            user_id          created_at
## 1   kissthecosmos          409523047 2017-04-18 23:31:35
## 2  marshagriffin3          545613994 2017-04-18 23:31:34
## 3      iembot_bou           34933149 2017-04-18 23:31:34
## 4        figgy444 834443791788449792 2017-04-18 23:31:34
## 5 AustinWilson808          604865730 2017-04-18 23:31:34
## 6     Aurora_Buzz          130526740 2017-04-18 23:31:34
##            status_id
## 1 854477541435899908
## 2 854477537216413696
## 3 854477536952233989
## 4 854477536830652417
## 5 854477536767614976
## 6 854477534875893760
##                                                                                                                                 text
## 1                                                                                            I just love me some sunshine \U0001f495
## 2                                                ST Engineering Wins Contracts Worth $331 Million in Q1 2017 https://t.co/6N7uJhM1d5
## 3                                                DENVER CO Apr 18 Climate: Hi: 78 Lo: 40 Precip: 0.0 Snow: M https://t.co/M5aGGCr1Bw
## 4              @JulianIsaiahO @bjetpilot @FoxNews Hey genius where did I say anything about police work in reference to finding him?
## 5                                                                             @LifeOfJamo I'm going for the wild card, love that ish
## 6 #Adopt #Dog MARCO: MARCO's Story: Click here to learn more about my Behavior Level Behavior… https://t.co/HQ92q9HFLh Plz RT 2 Help
##   retweet_count favorite_count is_quote_status quote_status_id is_retweet
## 1             0              0           FALSE            <NA>      FALSE
## 2             0              0           FALSE            <NA>      FALSE
## 3             0              0           FALSE            <NA>      FALSE
## 4             0              0           FALSE            <NA>      FALSE
## 5             0              0           FALSE            <NA>      FALSE
## 6             0              0           FALSE            <NA>      FALSE
##   retweet_status_id in_reply_to_status_status_id
## 1              <NA>                         <NA>
## 2              <NA>                         <NA>
## 3              <NA>                         <NA>
## 4              <NA>           854472744481701888
## 5              <NA>           854396133895880704
## 6              <NA>                         <NA>
##   in_reply_to_status_user_id in_reply_to_status_screen_name lang
## 1                       <NA>                           <NA>   en
## 2                       <NA>                           <NA>   en
## 3                       <NA>                           <NA>   en
## 4                  281342048                  JulianIsaiahO   en
## 5                  509111990                     LifeOfJamo   en
## 6                       <NA>                           <NA>   en
##               source media_id media_url media_url_expanded urls
## 1 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 2            dlvr.it     <NA>      <NA>               <NA> <NA>
## 3             iembot     <NA>      <NA>               <NA> <NA>
## 4 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 5 Twitter for iPhone     <NA>      <NA>               <NA> <NA>
## 6            dlvr.it     <NA>      <NA>               <NA> <NA>
##                                urls_display
## 1                                      <NA>
## 2                            dlvr.it/NwYGj4
## 3 mesonet.agron.iastate.edu/p.php?pid=2017…
## 4                                      <NA>
## 5                                      <NA>
## 6                            dlvr.it/NwYGhJ
##                                                                 urls_expanded
## 1                                                                        <NA>
## 2                                                       http://dlvr.it/NwYGj4
## 3 https://mesonet.agron.iastate.edu/p.php?pid=201704182331-KBOU-CDUS45-CLIDEN
## 4                                                                        <NA>
## 5                                                                        <NA>
## 6                                                       http://dlvr.it/NwYGhJ
##              mentions_screen_name                     mentions_user_id
## 1                            <NA>                                 <NA>
## 2                            <NA>                                 <NA>
## 3                            <NA>                                 <NA>
## 4 JulianIsaiahO bjetpilot FoxNews 281342048 778594198731751424 1367531
## 5                      LifeOfJamo                            509111990
## 6                            <NA>                                 <NA>
##   symbols  hashtags coordinates place_id place_type place_name
## 1      NA      <NA>          NA     <NA>       <NA>       <NA>
## 2      NA      <NA>          NA     <NA>       <NA>       <NA>
## 3      NA      <NA>          NA     <NA>       <NA>       <NA>
## 4      NA      <NA>          NA     <NA>       <NA>       <NA>
## 5      NA      <NA>          NA     <NA>       <NA>       <NA>
## 6      NA Adopt Dog          NA     <NA>       <NA>       <NA>
##   place_full_name country_code country bounding_box_coordinates
## 1            <NA>         <NA>    <NA>                     <NA>
## 2            <NA>         <NA>    <NA>                     <NA>
## 3            <NA>         <NA>    <NA>                     <NA>
## 4            <NA>         <NA>    <NA>                     <NA>
## 5            <NA>         <NA>    <NA>                     <NA>
## 6            <NA>         <NA>    <NA>                     <NA>
##   bounding_box_type
## 1              <NA>
## 2              <NA>
## 3              <NA>
## 4              <NA>
## 5              <NA>
## 6              <NA>
```

Where are they from around CO?


```r
boulder_users <- attributes(boulder_tweets)$users
boulder_users$location
##   [1] "Denver, CO"                     "Denver"                        
##   [3] "Boulder, CO"                    "Denver, CO"                    
##   [5] "Denver "                        "Aurora Colorado"               
##   [7] "Longmont, CO"                   "Brighton, Colorado "           
##   [9] "Halifax, Nova Scotia"           "Australia "                    
##  [11] NA                               "Centennial, CO"                
##  [13] "probably crying somewhere "     "Denver, Co"                    
##  [15] "Clinton News Network"           "Denver, CO"                    
##  [17] "NM.✈️ CO."                       "Denver"                        
##  [19] "Denver, CO"                     "Los Angeles"                   
##  [21] "Denver, CO"                     NA                              
##  [23] "Denver"                         "Mattapoisett, MA"              
##  [25] "303 "                           "Phoenix, AZ"                   
##  [27] NA                               "Centennial, CO"                
##  [29] NA                               "Washington State, USA"         
##  [31] NA                               "Loveland, CO"                  
##  [33] "Boulder"                        NA                              
##  [35] "Denver, CO"                     "Boulder, CO"                   
##  [37] " United States"                 "Denver, CO"                    
##  [39] "5280 Mile High "                "Denver, CO"                    
##  [41] NA                               "Centennial, Colorado"          
##  [43] "Denver, CO"                     "Denver, CO"                    
##  [45] "Denver, CO"                     "CDMX♡"                         
##  [47] "Denver, CO"                     "Boulder, CO"                   
##  [49] "Longmont, CO"                   "Denver, CO"                    
##  [51] "Denver, CO"                     "California, USA"               
##  [53] "Illinois, USA"                  "United States"                 
##  [55] "Denver, CO"                     "Denver, CO"                    
##  [57] "denver, co"                     "Athens, Georgia"               
##  [59] "Schweiz"                        "Lakewood, CO"                  
##  [61] "Denver,CO "                     "Denver, Colorado"              
##  [63] "Boulder, Colorado"              "Merica"                        
##  [65] "Longmont, CO"                   "Denver"                        
##  [67] "Denver, CO"                     "Victoria, Australia"           
##  [69] "a City  that Jeffs"             "Norfolk, VA"                   
##  [71] NA                               "the earth"                     
##  [73] "Castle Pines, CO"               "Denver"                        
##  [75] "Boulder County, Colorado"       "Denver, CO"                    
##  [77] NA                               "Denver"                        
##  [79] NA                               "Toronto"                       
##  [81] "Denver, CO"                     "Boulder CO, USA"               
##  [83] "Boulder, CO"                    "private: @wtffselena3"         
##  [85] "Denver, CO"                     "Norfolk, VA"                   
##  [87] NA                               "Denver, CO"                    
##  [89] "Denver"                         "Boulder, CO"                   
##  [91] "Chile"                          "Thornton Colorado"             
##  [93] "Northampton"                    "Boulder, Colorado"             
##  [95] "Fort Collins, CO"               "Denver"                        
##  [97] "in nature somewhere"            "Norfolk, VA"                   
##  [99] "Denver, CO"                     "Denver, CO"                    
## [101] "Northampton"                    "Denver"                        
## [103] "Greeley, CO"                    "aurora, colorado"              
## [105] "Fort Collins, CO"               "Tx. "                          
## [107] "Denver, CO"                     "Rossville,Tn"                  
## [109] "Englewood, CO"                  "Colorado"                      
## [111] "Denver, CO"                     "Denver, CO"                    
## [113] NA                               "Salt Lake City, UT"            
## [115] "Rossville,Tn"                   "Fort Collins, CO"              
## [117] "Dallas, TX"                     NA                              
## [119] "Denver, CO"                     NA                              
## [121] "Denver, CO"                     "Denver, CO"                    
## [123] NA                               "Loveland, CO"                  
## [125] "Denver, CO"                     NA                              
## [127] "Denver, CO"                     "wheat ridge, co "              
## [129] "Parker Colorado"                "Colorado"                      
## [131] "Ireland"                        "Denver, CO"                    
## [133] NA                               "Denver, CO"                    
## [135] "Michigan, USA"                  "Denver, Colorado"              
## [137] "Denver, CO"                     "Denver, Colorado"              
## [139] NA                               "Erie, CO"                      
## [141] "Denver, CO"                     "somewhere in the mountains\n"  
## [143] "Castle Rock, CO"                "Brighton, CO"                  
## [145] "Denver"                         "Denver, CO"                    
## [147] "New York City"                  "Boulder,Co"                    
## [149] "Denver, CO"                     "Boulder, CO"                   
## [151] "Boulder, CO"                    "Loveland, Colorado"            
## [153] "Denver, CO"                     "Fort Collins, CO, USA"         
## [155] "Denver, CO"                     "Greeley, Colorado"             
## [157] "WallStreet"                     "los Angelesos"                 
## [159] " w/ Lauren"                     "Denver, Colorado"              
## [161] "Johnstown, CO"                  "Highlands Ranch, CO"           
## [163] "Denver, CO"                     "Erie, CO"                      
## [165] "Denver, CO"                     "Cherry Hills Village, CO"      
## [167] "Aurora, Colorado "              "Denver, CO"                    
## [169] "Littleton, CO"                  "Denver, CO"                    
## [171] "Denver, CO"                     "Denver, CO"                    
## [173] "Denver, CO"                     "Western Mass."                 
## [175] "Denver, CO "                    "Glendale, CO"                  
## [177] "Longmont, Colorado"             "Denver CO"                     
## [179] "Denver, CO"                     "Castle Rock"                   
## [181] "Greeley Colorado"               "Denver, CO"                    
## [183] "Denver, CO"                     "Denver"                        
## [185] "Denver"                         NA                              
## [187] "Denver, CO"                     "Denver CO"                     
## [189] "Denver"                         "Denver, CO"                    
## [191] "Colorado"                       NA                              
## [193] "Denver, Colorado"               "Denver, Colorado"              
## [195] "Boulder, CO"                    "Coors Field"                   
## [197] "Denver, CO"                     "Denver, CO"                    
## [199] "Chicago"                        "CLT"                           
## [201] "Denver, CO"                     NA                              
## [203] "Denver "                        NA                              
## [205] "Aurora, CO"                     "CLT"                           
## [207] "Denver, Colorado"               "on the roof"                   
## [209] "Denver, CO"                     "Albuquerque, NM"               
## [211] "Littleton, CO"                  "Lone Tree, Colorado"           
## [213] "Living with kyroskoh (SG)"      "California, USA"               
## [215] "Denver, CO"                     "Suitland, MD"                  
## [217] "Westport, CT"                   "Denver, CO"                    
## [219] "Denver, CO"                     "Denver, Colorado."             
## [221] "Fort Collins, CO"               "CLT"                           
## [223] "Denver, CO"                     "Denver, CO"                    
## [225] "Denver"                         "Denver, CO"                    
## [227] "Centennial, CO"                 NA                              
## [229] "Denver, CO"                     "Aurora"                        
## [231] "North Bergen, NJ"               "Denver, Colorado"              
## [233] "Living with @kyroskoh (SG)"     "Denver, CO"                    
## [235] "Fort Collins, CO"               "Islington, London"             
## [237] "Centennial, CO"                 "London, England"               
## [239] "Denver, Colorado"               "Brighton, CO"                  
## [241] "Wellington, New Zealand"        "Fruita, CO"                    
## [243] "Castle Rock, CO"                "Denver, CO"                    
## [245] NA                               "Denver, CO"                    
## [247] "Boulder, CO"                    "Denver, Colorado"              
## [249] "Denver, CO"                     "Denver, CO"                    
## [251] "Castle Rock, CO"                "Denver, CO"                    
## [253] "iPhone: 30.267820,-97.749223"   "Denver, Colorado"              
## [255] "Golden, Colorado"               "Denver"                        
## [257] "Boulder, CO"                    "The Castle"                    
## [259] "Denver, CO"                     "Greeley, CO"                   
## [261] NA                               NA                              
## [263] "Columbine, CO"                  "ny"                            
## [265] "Longmont, Colorado"             "The Moon"                      
## [267] "Denver"                         "Denver, CO"                    
## [269] "wheat ridge, co "               "Centennial, CO"                
## [271] "Greeley, CO"                    "Denver, Colorado, USA"         
## [273] "Boulder, CO"                    "BRONCOS COUNTRY"               
## [275] "Denver, CO"                     "Denver, CO"                    
## [277] "Castle Rock, CO"                "Denver"                        
## [279] "Sverige"                        "Fort Collins,CO"               
## [281] "Charlotte, NC"                  "Denver, CO"                    
## [283] "Minneapolis, MN"                NA                              
## [285] "Denver"                         "Aurora"                        
## [287] "Denver, CO"                     NA                              
## [289] "ISRAEL AKA PALESTINE"           "Denver, CO"                    
## [291] NA                               "Denver, Co"                    
## [293] NA                               NA                              
## [295] NA                               "Calgary, Alberta"              
## [297] "Denver, CO"                     "Boulder, CO"                   
## [299] "Denver, CO"                     "Denver, CO"                    
## [301] "CO"                             "Denver, CO"                    
## [303] "Portland, OR"                   "Fort Collins, CO"              
## [305] "aurora"                         "Boulder, CO"                   
## [307] "Denver, CO"                     "Castle Rock, CO"               
## [309] "Denver, CO"                     "Boulder, Colorado"             
## [311] "In my Den"                      "Denver, CO"                    
## [313] "Littleton, Colorado"            "Bullard,Tx"                    
## [315] "Greeley, Colorado"              "Denver, CO"                    
## [317] "LA USA & Costa Blanca Spain"    NA                              
## [319] "Lakewood, CO"                   "Golden, CO"                    
## [321] "Denver, CO"                     "Arvada, CO"                    
## [323] "Denver, CO. USA"                "Boulder and Longmont, Colorado"
## [325] "Boulder"                        "Denver, CO "                   
## [327] "Coors Field"                    "Denver, CO"                    
## [329] "Westminster, CO"                "Denver, CO"                    
## [331] "Fort Collins, CO"               "Parker, CO"                    
## [333] "Denver, CO"                     "Denver, CO"                    
## [335] "Castle Rock, CO 80104"          "Denver, CO"                    
## [337] "Denver, CO"                     "Boulder, CO"                   
## [339] NA                               "Mid Georgia"                   
## [341] "Denver, CO"                     "Denver, CO"                    
## [343] "Denver, CO"                     "Denver, CO"                    
## [345] "Denver, CO"                     "Littleton, CO"                 
## [347] "Denver, CO"                     "Parker, CO"                    
## [349] "Aurora, Colorado "              "Colorado School of Mines"      
## [351] "Denver"                         "Colorado Springs, CO"          
## [353] "USA"                            "AMC"                           
## [355] NA                               "Fort Collins, CO"              
## [357] "Denver, CO"                     "Firestone Colorado"            
## [359] "Boulder, CO"                    "Denver, CO"                    
## [361] NA                               "Denver"                        
## [363] "Boulder/Denver"                 "aurora"                        
## [365] NA                               "Weld County, Colorado "        
## [367] "Longmont, CO"                   "Australia"                     
## [369] "Boulder, CO"                    "Queens, NY"                    
## [371] "Denver, CO"                     "Fort Collins, CO"              
## [373] "Bullard,Tx"                     NA                              
## [375] NA                               NA                              
## [377] "Denver, CO"                     "Denver, CO"                    
## [379] "Greeley, Colorado"              "Glenwood, IL"                  
## [381] "Denver, CO"                     "Fort Collins, CO"              
## [383] "Broomfield, CO"                 "Boulder, Colorado"             
## [385] "Pennsylvania, USA"              "Connecticut, USA"              
## [387] "Virginia, USA"                  "Centennial, CO"                
## [389] "aurora"                         "Aurora, CO"                    
## [391] "Pennsylvania, USA"              "Aurora, Colorado "             
## [393] "Parker, CO"                     "Parker, CO"                    
## [395] "Denver, CO"                     "Castle Rock, Colorado "        
## [397] "Denver, CO"                     "Denver, CO"                    
## [399] "Bullard,Tx"                     "Denver, CO"                    
## [401] "Denver, CO"                     "Taylor, MI"                    
## [403] "Denver,Co"                      "Rossville,Tn"                  
## [405] "Denver, CO"                     "Virginia, USA"                 
## [407] "Denver, Colorado, USA"          "Vancouver"                     
## [409] NA                               "Denver"                        
## [411] "Boulder, CO"                    NA                              
## [413] "Lakewood, CO"                   NA                              
## [415] "xavier liked: 11/16/15"         "Fort Collins, CO"              
## [417] "Denver, CO"                     NA                              
## [419] "Ft. Collins, CO"                "Denver, CO"                    
## [421] "Denver, CO"                     NA                              
## [423] "Phoenix, AZ"                    "Denver, Co"                    
## [425] "Parker, Colorado"               "Longmont, CO, USA"             
## [427] "Westminster, CO"                NA                              
## [429] "Boulder Colorado"               "Inside your head, tempting you"
## [431] "xavier liked: 11/16/15"         "Centennial, CO"                
## [433] "Denver, CO"                     "Denver, CO"                    
## [435] "Christchurch City, New Zealand" "denver"                        
## [437] "Centennial, CO"                 "Loveland, CO"                  
## [439] NA                               "Denver, Colorado"              
## [441] "Castle Rock, Colorado"          "Denver, CO"                    
## [443] "Greeley, CO"                    "Denver, CO"                    
## [445] "Tokyo"                          "Denver, CO"                    
## [447] "Denver, CO"                     "Denver, Colorado, USA"         
## [449] "Littleton, CO"                  "Fort Collins, CO"              
## [451] "Denver, CO"                     "Denver, CO "                   
## [453] "xavier liked: 11/16/15"         "aurora"                        
## [455] "Loveland, CO"                   "Fort Collins, CO"              
## [457] "Aurora, Colorado "              "Denver, Colorado"              
## [459] "Denver, CO"                     "Denver, CO"                    
## [461] "Denver, CO"                     "Denver Colorado"               
## [463] "Denver, CO"                     "Denver, Co."                   
## [465] "Denver, CO"                     "LARADISE, WY"                  
## [467] "Lakewood, CO"                   "Denver, CO"                    
## [469] "Arvada, CO"                     "Fort Collins, CO"              
## [471] "Japan"                          "Fort Collins, CO"              
## [473] "Denver, CO"                     "The Castle  "                  
## [475] "United States"                  "Denver, CO. USA"               
## [477] "Denver, CO"                     "Greeley Colorado"              
## [479] "Psalms 46:5"                    "Denver"                        
## [481] "Boulder, CO"                    "dirty den"                     
## [483] "Denver, CO"                     "Denver"                        
## [485] "Boulder, CO"                    "Denver, CO"                    
## [487] "Boulder, CO"                    "Englewood,Colorado"            
## [489] "Boulder, CO"                    "Centennial, CO"                
## [491] "Denver, CO 80223"               "Denver, CO"                    
## [493] NA                               NA                              
## [495] "United States"                  "Centennial, CO"                
## [497] "Struggler's Cove"               NA                              
## [499] "22 x OH x CO"                   NA                              
## [501] "Denver, CO"                     "Denver, CO"                    
## [503] "Colorado, USA"                  "aurora"                        
## [505] "Denver, CO"                     "Denver, CO"                    
## [507] "kerjen,Srengat, East Java"      "Fort Collins, CO"              
## [509] "Denver, CO"                     "who knows?"                    
## [511] "Denver, Colorado, USA"          "Denver, CO"                    
## [513] "Las Vegas, NV"                  "Colorado"                      
## [515] "Denver, CO"                     " United States"                
## [517] "Carlsbad, San Diego"            "Erie, CO"                      
## [519] "Denver, CO"                     "Brighton, CO"                  
## [521] NA                               "watch the get down"            
## [523] NA                               "Parker, CO"                    
## [525] "All I know is I'm not home yet" "Denver, CO"                    
## [527] NA                               "aurora"                        
## [529] "Milwaukee, WI"                  "Westminster"                   
## [531] "Fort Collins, CO"               "Denver, CO"                    
## [533] "Denver, CO"                     "Boulder, CO"                   
## [535] "Denver "                        "Littleton, Colorado"           
## [537] "Denver, CO"                     "Boulder, CO"                   
## [539] NA                               "Columbine, CO"                 
## [541] "RED SOX NATION"                 "Montbello, Denver"             
## [543] "Denver, Colorado"               "Alabama, USA"                  
## [545] "Parker, CO"                     "Wheat Ridge, CO"               
## [547] "Boulder, Colorado, USA"         "Denver, CO"                    
## [549] "The waffle house"               "wheat ridge, co "              
## [551] "Erie, CO"                       "Denver, CO"                    
## [553] "Longmont, CO"                   NA                              
## [555] "Denver, CO"                     "Denver, CO"                    
## [557] "denver"                         "Denver, Colorado"              
## [559] "Taylor, MI"                     "Fort Collins"                  
## [561] "Denver, CO"                     "fort collins co"               
## [563] "Boulder, CO"                    NA                              
## [565] "Denver, CO"                     "Downtown Denver"               
## [567] "Boulder, CO"                    "Boulder, CO"                   
## [569] "Denver, CO"                     "Denver, CO"                    
## [571] "Denver, Colorado"               "Loveland Colorado USA"         
## [573] "Denver, CO"                     "Denver, CO"                    
## [575] "Denver, CO"                     NA                              
## [577] "Broomfield, CO"                 "Denver, CO"                    
## [579] NA                               "Denver, CO"                    
## [581] "Denver, CO"                     "Merica"                        
## [583] "Fort Collins, CO"               "ft collins, co"                
## [585] " Denver, Colorado"              "Fort Lupton, CO"               
## [587] "United States"                  NA                              
## [589] "Denver, CO"                     "Denver, CO"                    
## [591] "here there and everywhere, but" "Paradise "                     
## [593] "Denver, CO"                     "Denver, CO"                    
## [595] "Denver, Colorado"               "Centennial, Colorado"          
## [597] "Fort Collins, CO"               "Colorado, USA"                 
## [599] "Loveland, CO"                   "Westminster, CO"               
## [601] "Redondo Beach, CA"              NA                              
## [603] "Be Holy & You Are"              "Aurora, CO"                    
## [605] NA                               "Wheat Ridge, CO"               
## [607] "Fort Collins, Colorado"         NA                              
## [609] "Longmont, CO"                   "Loveland, CO"                  
## [611] "Boulder, CO"                    "Lakewood, CO"                  
## [613] NA                               "Denver, CO"                    
## [615] "Greeley, CO"                    "Boulder, CO"                   
## [617] NA                               "Denver, CO"                    
## [619] "Erie, CO"                       "Boulder County, Colorado"      
## [621] "denver"                         "Miami, FL"                     
## [623] "Denver, CO"                     "Denver, CO"                    
## [625] "Wichita, KS"                    "Hometown - Chicago, Illinois"  
## [627] "Denver, CO"                     "Denver, CO"                    
## [629] "Thornton, CO"                   "Denver, CO"                    
## [631] "dtx//atx"                       "Boulder, CO"                   
## [633] "Denver, CO"                     "Englewood, CO"                 
## [635] "Denver, CO"                     "Loveland, CO"                  
## [637] "Longmont, Colorado"             "Denver, CO"                    
## [639] "Aurora, CO"                     "San Francisco"                 
## [641] "Denver CO"                      "Denver, Colorado"              
## [643] "Denver, CO"                     "Denver, CO"                    
## [645] "Atlanta, GA"                    "Aurora, Colorado "             
## [647] "Denver "                        "Denver, CO"                    
## [649] "Colorado"                       NA                              
## [651] "In My Own Lane"                 "DENVER"                        
## [653] "chicago"                        "San Francisco, CA"             
## [655] "Centennial, CO"                 "Denver, CO"                    
## [657] "Denver, CO"                     "Denver, Colorado, USA"         
## [659] "sheridan MI"                    "Denver, CO"                    
## [661] "Aurora, Colorado "              "Denver, CO"                    
## [663] "Colorado State Capitol, Denver" "Lakewood "                     
## [665] "Denver, Colorado"               "Denver, CO"                    
## [667] "Denver, CO"                     "Denver"                        
## [669] "Dreamville"                     "sheridan MI"                   
## [671] NA                               "Denver Colorado"               
## [673] "Denver, CO"                     "sheridan MI"                   
## [675] "Denver, CO"                     "Westminster, CO"               
## [677] "Kentucky, USA"                  "wheat ridge, co "              
## [679] "Denver, CO"                     "Denver, CO"                    
## [681] "Denver, CO "                    "Boulder, Colorado"             
## [683] "Boulder, Colorado"              "Broomfield, CO"                
## [685] "Co"                             NA                              
## [687] "Denver"                         "Boulder, CO"                   
## [689] "Northglenn, CO"                 "Denver, CO"                    
## [691] "kerjen,Srengat, East Java"      "Thornton, CO"                  
## [693] "ontario, canada"                "ontario, canada"               
## [695] "dtx//atx"                       "Denver, CO"                    
## [697] "Denver, CO"                     "Hometown - Chicago, Illinois"  
## [699] "Thornton, CO"                   "aurora"                        
## [701] "Heaven, USA"                    "Wheat Ridge, CO"               
## [703] NA                               "Littleton, Colorado"           
## [705] "Denver, CO"                     "Denver, CO"                    
## [707] NA                               NA                              
## [709] "Westminster, CO"                "Denver, CO"                    
## [711] "dtx//atx"                       "At the crib"                   
## [713] "Boulder, CO"                    "Littleton, Colorado"           
## [715] "Denver, CO"                     "Denver, Colorado"              
## [717] "Colorado, USA"                  "aurora"                        
## [719] "OU'20"                          NA                              
## [721] "underfoot"                      "Denver, CO"                    
## [723] "Denver, CO"                     "Denver, CO"                    
## [725] "Denver, CO"                     "Centennial, CO"                
## [727] "Denver, CO"                     "New Milford, CT"               
## [729] "Denver, Co. "                   "Denver"                        
## [731] NA                               NA                              
## [733] "Fort Collins, CO"               "Washington, DC"                
## [735] "Aurora, Co"                     "Arvada, CO"                    
## [737] "Denver, CO"                     "Denver, Colorado"              
## [739] NA                               NA                              
## [741] "University of Colorado Boulder" "Denver, CO"                    
## [743] "Colorado"                       NA                              
## [745] "Denver, CO"                     "Venezuela"                     
## [747] "Denver, CO"                     "Fort Collins, CO"              
## [749] "USA"                            "Denver"                        
## [751] "Aberdeen"                       "Denver, CO"                    
## [753] "Boulder, CO"                    "Fort Collins, Colorado"        
## [755] "Denver, CO"                     "Centennial, CO"                
## [757] "Denver, CO"                     "Aurora"                        
## [759] "Denver, CO"                     "Denver, CO"                    
## [761] "Denver, CO"                     "Ventura County, CA"            
## [763] "Fort Collins, CO"               "Denver, Colorado"              
## [765] "Denver, CO"                     "Fort Collins, CO"              
## [767] "Westminster "                   "Estes Park, CO"                
## [769] "United States"                  "kerjen,Srengat, East Java"     
## [771] "Denver"                         "basura"                        
## [773] "Denver, CO"                     "Denver, CO"                    
## [775] "Denver, CO"                     "Denver, CO"                    
## [777] "Denver, USA"                    "Fort Collins, CO"              
## [779] NA                               "Loveland"                      
## [781] "Lakewood, CO"                   "Denver, CO"                    
## [783] "Denver"                         "Denver, CO"                    
## [785] "Denver, CO"                     "bay area"                      
## [787] "Denver, Colorado"               "Lakewood"                      
## [789] "denver "                        NA                              
## [791] "Psalms 46:5"                    "Washington, DC"                
## [793] "22 x OH x CO"                   "22 x OH x CO"                  
## [795] "Denver, Colorado"               NA                              
## [797] "Denver"                         "Peckham"                       
## [799] "Denver, CO"                     "   "                           
## [801] "Psalms 46:5"                    "Denver, Colorado"              
## [803] "Denver, CO"                     "Lakewood, Colorado"            
## [805] "Denver, CO"                     "Psalms 46:5"                   
## [807] "New York"                       NA                              
## [809] "The Loft"                       "New York/Boulder"              
## [811] "aurora"                         "Denver, CO"                    
## [813] "Westminster, CO"                "Denver, CO"                    
## [815] "ohs '19"                        "Johnstown, CO"                 
## [817] "Fort Collins, CO"               NA                              
## [819] "Denver, CO"                     "nose cuddles™"                 
## [821] "United States"                  "Boulder, CO"                   
## [823] "Arbutus, MD"                    "guam"                          
## [825] "Denver, CO"                     "Chicago, IL"                   
## [827] "Denver, CO"                     "Aurora, CO"                    
## [829] "Denver, CO, USA"                "Fort Collins, Colorado"        
## [831] "Denver, CO"                     "Denver, CO"                    
## [833] "Denver, CO"                     "Denver, CO"                    
## [835] "Denver, CO"                     "Denver, CO"                    
## [837] "Denver, CO"                     "Castle Rock, Colorado"         
## [839] "Greeley, CO"                    "Denver, CO"                    
## [841] "Parker, CO"                     "Boulder, CO"                   
## [843] "Greeley, CO"                    "Denver, CO"                    
## [845] "Denver, CO"                     "Denver"                        
## [847] "Boulder, CO"                    "la salle "                     
## [849] "Broomfield, CO"                 "Denver, CO"                    
## [851] "Centennial, Colorado"           "Denver, CO"                    
## [853] "Lakewood CO"                    "Denver, Colorado"              
## [855] "Golden CO"                      "Arvada Colorado"               
## [857] "Denver, CO"                     "Denver, CO"                    
## [859] "Denver, CO"                     "Washington, DC"                
## [861] "Denver, Colorado"               "Boulder, CO"                   
## [863] "Denver, Colorado"               "Boulder, CO"                   
## [865] "lakewood"                       "Denver, Colorado"              
## [867] "Berlin, Germany"                "Brooklyn, NY"                  
## [869] "Greeley, CO"                    "Denver"                        
## [871] "Lakewood, CO"                   "Cherry Hills Village, CO"      
## [873] "Littleton, Colorado"            "Boulder CO"                    
## [875] "Denver "                        "Bakersfield, CA"               
## [877] "Littleton, CO"                  "Cleveland"                     
## [879] "Estes Park, mountains "         "Denver, Colorado"              
## [881] "Denver, CO"                     "Grand Forks, ND"               
## [883] "Denver, CO"                     "Denver, CO"                    
## [885] "Denver, CO"                     "Centennial, CO"                
## [887] "Centennial, CO"                 "Denver, CO"                    
## [889] "Denver, CO"                     "Alabama, USA"                  
## [891] "Berlin, Germany"                "Denver, CO"                    
## [893] "The Moon"                       "Denver, CO"                    
## [895] "LA USA & Costa Blanca Spain"    "Aurora"                        
## [897] "Thornton, CO"                   "Westminster, CO, USA"          
## [899] NA                               "Greeley, CO"                   
## [901] "Centennial, Colorado"           "Denver, CO"                    
## [903] "Alabama, USA"                   "Denver, CO"                    
## [905] "Denver, CO"                     "Golden, CO"                    
## [907] "Berlin, Germany"                "Iolabetty1893@gmail"           
## [909] "Boulder Colorado (USA)"         "Denver, CO"                    
## [911] "Boulder, CO"                    "boulder, colorado"             
## [913] "Denver, CO"                     "Denver, CO"                    
## [915] "Fort Collins, CO"               "Denver, CO"                    
## [917] "Alabama, USA"                   "Fort Collins, CO"              
## [919] "Denver, CO"                     "Denver, Colorado, USA"         
## [921] "Fort Collins, CO"               "Greeley, CO"                   
## [923] "Fort Collins, CO"               "Boulder Colorado (USA)"        
## [925] "Lexington, MS"                  "Denver, CO"                    
## [927] "Alabama, USA"                   "Denver, CO"                    
## [929] "Denver, CO "                    "Denver, CO"                    
## [931] "Englewood,Colorado"             "Miami, FL"                     
## [933] "Aurora, CO"                     "Damascus, MD"                  
## [935] "Broncos Country"                "Greenwood Village, Colorado"   
## [937] "Boulder, CO"                    "Aurora, Colorado"              
## [939] "Centennial, Colorado"           "Lafayette, CO"                 
## [941] "Denver, CO"                     "Boulder, CO"                   
## [943] "Meridian, ID"                   "im 18 and a GIRL tyvm"         
## [945] "Denver"                         "Dove Valley, CO"               
## [947] "Denver, Colorado, USA"          "Denver, CO"                    
## [949] "Louisville, KY"                 "Denver, CO"                    
## [951] "Fort Collins, CO"               "Arizona, USA"                  
## [953] "Boulder, CO"                    "Northglenn, CO"                
## [955] "Denver"                         "Denver, CO"                    
## [957] "Denver, CO"                     "Denver"                        
## [959] "Thornton, CO"                   "Denver, CO"                    
## [961] "Denver, Co"                     "Loveland, CO"                  
## [963] "Denver, Co "                    "Boulder, CO"                   
## [965] "Broomfield, CO"                 "Denver"                        
## [967] "Denver, CO"                     "Denver, CO"                    
## [969] "Denver, CO"                     "Fort Collins, CO"              
## [971] "Denver, CO"                     "Meridian, ID"                  
## [973] "Boulder, CO"                    "Berlin, Germany"               
## [975] "Chicago"                        "Aurora"                        
## [977] "Thornton, CO"                   "Palmer Lake, CO"               
## [979] "Denver, CO"                     "Lakewood"                      
## [981] "The Loft"                       "Denver, CO"                    
## [983] "Denver, CO"                     "Denver, CO"                    
## [985] "Denver, CO"                     "Fort Collins, CO"
```

What type of following do they have?

```r

boulder_users$followers_count
##   [1]  62746   1609     60     38    176   3204    233    510    687  42621
##  [11]    211    683    344    302  13081   3933   1596   3694    330     21
##  [21]    515    148  15620   5337    608   1026    533    683    222   5924
##  [31]     66      8    244      4     46     83    125    599   2449    394
##  [41]    378   2425    256     15    185   1895   7496    110     27     17
##  [51]     19     92   8237   1565   2319    196   8799    194   1539    662
##  [61]    558 350074    892    408    233   1373    115    434    229  21709
##  [71]     72   1044    221      2    344    325      4   3695    159     73
##  [81]   5261  31363   3604   1629     30  21709   8002     25  15620    652
##  [91]    868   2599   8048  19681      2   4691   1045  21709    367    367
## [101]   8048    534    570     73    313   2191    351     60    137     28
## [111]    313      2    179  10802     60   1121   1738    230  13012     62
## [121]     54   7662     88    221    508    461   2909    231    518    199
## [131]   1252     14     66    843     16    933    449   4093      7    583
## [141]     55     84    314    384   1373   5853    422    211   1589    359
## [151]   7280     26      6    460  15900     12   1652     44   1139   2267
## [161]   3848    327   1666    583    127  28442    571    196     10   1625
## [171]    228  40360    713    131    951    556   1646  17703 400730    282
## [181]  17559  52424    464   1373   3677     88   1691  17703    196  64775
## [191]     76    453  20415  20415   1034     48    858    261   1052    305
## [201]   4356    279   3346   1241   1605    305  30250    165    590    508
## [211]     16   6333   4078     59   2397     36   5251    198    261    640
## [221]    427    305   1606    494    277      9      2    554     87     23
## [231]    412   1270    437   5341   1251    416    647   1315    245    208
## [241]    659   1022     18    351     22    511    106   1213   9081 355912
## [251]   3116   7611   1489  35046  66261   2938    385   1979    400    999
## [261]   1488     22      3    226   1646   4267    301    610    231    683
## [271]    390   1726    190   1111    108    256     25    261     50    124
## [281]   1379    361   1734   3165    534     37      8    107    337   2169
## [291]   1980      6    560    560     18    396    210    127   2115  16757
## [301]    251     27    143    474   2577     58     73    275    613   1879
## [311]   3422    256    773   1155   1900    192  18828     27     25     30
## [321]    447    679    306   4326  20885    676     48   1060   4076    113
## [331]   3981     31    186     46    132    115   9880    113    102    286
## [341]    196   2310   1763    771   6126    940  52465     21    571    182
## [351]    966    329     65   1194    518     92     54     47   1392   2495
## [361]    220    323   9002   2577    175    266    320   8734     63    143
## [371]  26162   3166   1155     28    403   2531   6437      7   2187    518
## [381]   2271    336    379     78  15147     83    767     19   2577    753
## [391]  15147    571    182    182   4079   1398      1   1387   1155   2310
## [401]     38   3365    484     60 400730   1158    158   1935     69    534
## [411]     60    536    662     76   1254    313    113    399    206    404
## [421]   1676     38    254     97    144   2706   4076   8073      6   4049
## [431]   1254    683    210    895    213    361     41     77     35    890
## [441]   1651   4453    596   2115   4537   1559   4381   1726    940    623
## [451]    169    398   1254   2577    351    336    571   8080    201    341
## [461]   5209    319    402     57    201    901    203     52     66      2
## [471]     68    313     54    301    491   1729   5853    158    306     57
## [481]    197    356   8787   6690     42  16757    356  42006   3641    932
## [491]   5579    928   7214   7214     78    683  14720    379    468   2156
## [501]    385   7261     47     77    534    196   2750    336   2115   1531
## [511]   1726   1030    295    682     54    125   3529     41    345    377
## [521]    656    393     14    631    237    449     27   2577   8814     50
## [531]    228   1471     46    633    186    773   2159    151   3704    406
## [541]   1673    812 162617   1436    182     21  32252    309    240    231
## [551]    429     39    320  48272   4404   1260  13451     80   3365     58
## [561]     75    198   1392    391    221    336    319    633    196    479
## [571]    207    124     83   1357    333    126    942    332   2775    400
## [581]   1141    408    653     44   4012    217    529    267  70944    186
## [591]    505    801    928    928  53241   1432    262     80     77    543
## [601]    397    556    369    722   3108    540    325     98    220    265
## [611]    190     17     50     49     28    253    126    220    429    344
## [621]    361    109   2159    522    810   1092     46    134      8    479
## [631]    382    523    920    536     21   6088  11348    942     40    314
## [641]    248   1270   3459   1491   1342    571     33    154   1980    398
## [651]   1048  78342     53    211    932    743     31  20990    464      7
## [661]    571    453   9906    706   8080   1993    771   2578    525    464
## [671]    325    133     18    464      6     40   9893    231   6755      8
## [681]    497    404  99068    379     92     24   1373    190   1225    539
## [691]   2750    171     44     44    382  13080    453   1092    622   2577
## [701]   8410   1317    685    505    424   3103    143      9    130   1491
## [711]    382    408    221   6461     16  10500    425   2577   1873    189
## [721]   5761   4655    409   1569    277     64    700  41067     69   7001
## [731]  25082     84  23539    156    242    679    666    419    395    691
## [741]   6935     38   7104     41     96   1201    310    374   1700     46
## [751]     26    425    303    159    472    683    117      9    332   2115
## [761]   2159     13   2081    400    347    196  44136    634    876   2750
## [771]   4691    774  26162    309    688    307   4289  42353   1329   1224
## [781]    324   3318   5950    196  16757    646   1270   1177     51     56
## [791]    306    211    468    468   1323    683   1373    140     54   2200
## [801]    306   2016    256    860    637    306   4158    120   1246    474
## [811]   2577     46      0 379351    193   3848   1156   2182   1611   1407
## [821]    544    448    211    420    184    531  24702     20  23989    518
## [831]    164   1426   1071   1060   1141    928   1458    311    597   2115
## [841]   3533    274   2632    939  26880   6383    190    295    124    318
## [851]    820    332   2846   5489   4342   4160   2571      9     74    767
## [861]  33682    700 120523    127   1301  86792   8198     70     75   1373
## [871]     17      9    234    426     33    480      7    256     43    619
## [881]    282    651   4453    196    126   1185   1185    281    624   4149
## [891]   8198   1362   4267    117  18828      1    189    841    186    404
## [901]     26    343   4149   1488    281      3   8198     33  18299   1149
## [911]    633    378    606    606      2    318   4149   1605     19   6391
## [921]     83   1161    116  18299    482   2712   4149   2323    837    117
## [931]  42006    855     91    176    652   1444     82     83     26    340
## [941]   1378    418    396   1202     54    322   1726    281   1645     71
## [951]    258     50    745     24   1373    382    256    907     62  10685
## [961]    302      8    262    652    942   2415     16  10685    928   3187
## [971]   2265    396    700   8198  10094     23    189    108   4972    323
## [981]   1246    220    766    382    531    374
summary(boulder_users$followers_count)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##       0     186     483    5270    1680  401000
max_val <- max(boulder_users$followers_count)

# looks like there is an outlier -- let's use breaks to make this easier to look at
ggplot(boulder_users, aes(followers_count)) +
         geom_histogram(breaks=c(0,100,1000,10000,100000, 200000,max_val))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-12/in-class/2017-04-19-social-media-03-r/unnamed-chunk-3-1.png" title=" " alt=" " width="100%" />



Basic Mapping and Analysis
========================================================
title: false

<center>

```
## Error in eval(expr, envir, enclos): object 'pres_theme' not found
```
</center>

Adding Some Context...
========================================================

- Plotting on Stamen Terrain basemap provides useful context...


```r
# Create Boulder basemap (geocoding by name)
# NOTE: This doesn't work right now...
Boulder = get_map(location="Boulder, CO, USA",
                  source="stamen", maptype="terrain",
                  crop=FALSE, zoom=10)
# Create base ggmap
ggmap(Boulder) +
  # Start adding elements...
  geom_point(data=xy, aes(x, y), color="red",
             size=5, alpha=0.5) +
  stat_density2d(data=xy, aes(x, y, fill=..level..,
                              alpha=..level..),
                 size=0.01, bins=16, geom='polygon')
```

Twitter with Context
========================================================
title: false
<center>

</center>

Computing 'Clusters'
========================================================

- Or we can compute clusters 'on the fly', again using the powerful `leaflet` package:


```r
# URL for 'custom' icon
url = "http://steppingstonellc.com/wp-content/uploads/twitter-icon-620x626.png"
twitter = makeIcon(url, url, 32, 31)  # Create Icon!
## Error in eval(expr, envir, enclos): could not find function "makeIcon"

# How about auto-clustering?!
map = leaflet(xy) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=~x, lat=~y, popup=~text,
    clusterOptions=markerClusterOptions(),
    icon=twitter)
## Error in eval(expr, envir, enclos): could not find function "leaflet"
```


Interactive Map of Twitter Data
========================================================
title: false


Going a Step Further
========================================================
type: section

It isn't really enough just to grab some web-data and start mapping. Afterall, this session is really about data integration---something web-data and APIs are particularly good for!

Heat Maps are NOT Enough...
========================================================

<center>
[![xkcd Heat Maps](http://imgs.xkcd.com/comics/heatmap.png)](http://xkcd.com/1138/)
</center>

Combining Tweets and Census Info
========================================================

- Let's take another look at our Census data (this time grabbing population counts for Boulder region)

```r
pop = acs.fetch(endyear=2014, span=5, geography=geo,
                table.number="B01003",
                col.names="pretty")
## Error in eval(expr, envir, enclos): could not find function "acs.fetch"
est = pop@estimate  # Grab the Total Population
## Error in eval(expr, envir, enclos): object 'pop' not found
# Create a new data.frame
pop = data.frame(geoid, est[, 1],
                 stringsAsFactors=FALSE)
## Error in data.frame(geoid, est[, 1], stringsAsFactors = FALSE): object 'geoid' not found
rownames(pop) = 1:nrow(inc)  # Rename rows
## Error in nrow(inc): object 'inc' not found
colnames(pop) = c("GEOID", "pop_total")  # Rename columns
## Error in colnames(pop) = c("GEOID", "pop_total"): object 'pop' not found
```
- Create the merged data.frame!

```r
merged = geo_join(tracts, pop, "GEOID", "GEOID")
## Error in eval(expr, envir, enclos): could not find function "geo_join"
```

Big Ol' Chunk of Leaflet Code
========================================================


```r
popup = paste0("GEOID: ", merged$GEOID,
               "<br/>Total Population: ",
               round(merged$pop_total, 2))
## Error in paste0("GEOID: ", merged$GEOID, "<br/>Total Population: ", round(merged$pop_total, : object 'merged' not found
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$pop_total)
## Error in eval(expr, envir, enclos): could not find function "colorNumeric"
map = leaflet() %>%  # Map time!
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data=merged, popup=popup,
              fillColor=~pal(pop_total),
              color="#b2aeae", # This is a 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2) %>%
  addCircles(data=xy, lng=~x, lat=~y,
             popup=~text, radius=5) %>%
  addLegend(pal=pal, values=merged$pop_total,
            position="bottomright",
            title="Total Population")
## Error in eval(expr, envir, enclos): could not find function "leaflet"
```



Interactive Map of Twitter Data
========================================================
title: false


Controlling for Population
========================================================

- That's all fine and good, but are areas with lots of tweets associated with areas of high population? Its hard to tell from the map...

```r
library(sp)
# Make the points a SpatialPointsDataFrame
coordinates(xy) = ~x+y
## Error in `coordinates<-`(`*tmp*`, value = ~x + y): setting coordinates cannot be done on Spatial objects, where they have already been set
proj4string(xy) = CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0")
# Put the x/y data back into the data slot for later...
xy@data = as.data.frame(xy)
```
- And now we count 'points in polygon':

```r
overlay = over(xy, merged)
## Error in over(xy, merged): object 'merged' not found
res = as.data.frame(table(overlay$GEOID))
## Error in overlay$GEOID: object of type 'closure' is not subsettable
colnames(res) = c("GEOID", "count")
## Error in `colnames<-`(`*tmp*`, value = c("GEOID", "count")): attempt to set 'colnames' on an object with less than two dimensions
```

Tweet Score?
========================================================

- We can then join counts back onto the counties:

```r
merged@data = join(merged@data, res, by="GEOID")
## Error in eval(expr, envir, enclos): could not find function "join"
# And compute a 'tweet score'... based on logged pop
merged$percapita = merged$count/log(merged$pop_total)
## Error in eval(expr, envir, enclos): object 'merged' not found
```
- Based on this new variable, we setup a new pallette:

```r
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$percapita)
## Error in eval(expr, envir, enclos): could not find function "colorNumeric"
# Also create a nice popup for display...
popup = paste0("GEOID: ", merged$GEOID, "<br>",
               "Score: ", round(merged$percapita, 2))
## Error in paste0("GEOID: ", merged$GEOID, "<br>", "Score: ", round(merged$percapita, : object 'merged' not found
```
- And we plot it!

Plotting the Tweets
========================================================
title: false





Wanna See the Code for That One?
========================================================


```r
leaflet() %>%
  addProviderTiles("CartoDB.Positron", group="Base") %>%
  addPolygons(data=merged, popup=popup,
              fillColor=~pal(percapita),
              color="#b2aeae", # This is a 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2, group="Score") %>%
  addCircleMarkers(data=xy, lng=~x, lat=~y, radius=4,
                   stroke=FALSE, popup=~text,
                   group="Tweets") %>%
  addLayersControl(overlayGroups=c("Tweets", "Score"),
                   options=layersControlOptions(
                     collapsed=FALSE)) %>%
  addLegend(pal=pal, values=merged$percapita,
            position="bottomright",
            title="Score")
```

That's All Folks!
========================================================
type: section

## Data Harmonization + Working with Web and Social Media Data
Earth Analytics---Spring 2016

Carson J. Q. Farmer
[carson.farmer@colorado.edu]()

babs buttenfield
[babs@colorado.edu]()

References
========================================================
type: sub-section

- Most of the content in this tutorial was 'borrowed' from one of the following sources:
    - [Leaflet for `R`](https://rstudio.github.io/leaflet/)
    - [An Introduction to `R` for Spatial Analysis & Mapping](https://us.sagepub.com/en-us/nam/an-introduction-to-r-for-spatial-analysis-and-mapping/book241031)
    - [Manipulating and mapping US Census data in `R`](http://zevross.com/blog/2015/10/14/manipulating-and-mapping-us-census-data-in-r-using-the-acs-tigris-and-leaflet-packages-3/#census-data-the-hard-way)
- Data was courtesy of:
    - [Colorado Information Marketplace](https://data.colorado.gov)
    - [Twitter's API](https://dev.twitter.com/rest/public)
    - [US Census ACS 5-Year Data API](https://www.census.gov/data/developers/data-sets/acs-survey-5-year-data.html)

Want to Play Some More?
========================================================

- Check out the [EnviroCar API](http://envirocar.github.io/enviroCar-server/api/)
    - Data on vehicle trajectories annotated with CO^2 emmisions!
- [PHL API](http://phlapi.com)---Open Data for the City of Philly
- [NYC Open Data Portal](https://nycopendata.socrata.com)---Open Data for NYC
- [SF OpenData](https://data.sfgov.org)---Open Data for San Fran
- ... you get the point!

- In general, the [Programmable Web](http://www.programmableweb.com/) is a good resource
    - Here are [146 location APIs](http://www.programmableweb.com/news/146-location-apis-foursquare-panoramio-and-geocoder/2012/06/20) for example...
