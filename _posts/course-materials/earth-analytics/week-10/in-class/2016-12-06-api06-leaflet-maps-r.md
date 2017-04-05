---
layout: single
title: "Creating interactive spatial maps in R using leaflet"
excerpt: "This lesson covers the basics of creating an interactive map using the leaflet API in R. We will import data from the Colorado Information warehouse using the SODA RESTful API and then create an interactive map that can be published to an HTML formatted file using knitr and rmarkdown."
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-04-04'
category: [course-materials]
class-lesson: ['intro-APIs-r']
permalink: /course-materials/earth-analytics/week-10/leaflet-r/
nav-title: 'Interactive maps with leaflet '
week: 10
sidebar:
  nav:
author_profile: false
comments: true
order: 6
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Create an interactive leaflet map using R and rmarkdown.
* Customize an interactive map with data-driven popups.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>






```r
library(dplyr)
library(ggplot2)
library(RCurl)
library(rjson)
library(jsonlite)
library(leaflet)
```




## Interactive maps with Leaflet

Static maps are useful for creating figures for reports and presentation. Sometimes,
however, we want to interact with our data. We can use the leaflet package for
R to overlay our data on top of interactive maps. You can think about it like
Google  maps with your data overlaid on top!

### What is leaflet?

<a href="http://leafletjs.com" target="_blank">Leaflet</a> is an open-source `JavaScript` library that can be used to create mobile-friendly interactive maps.

Leaflet:

* Is designed with *simplicity*, *performance* and *usability* in mind,
* Has a beautiful, easy to use, and <a href="http://leafletjs.com/reference.html" target="_blank">well-documented API</a>


The `leaflet` `R` package 'wraps' Leaflet functionality in an easy to use `R` package! Below, you can see some code that creates a basic web-map.


```r
map = leaflet() %>%
  addTiles() %>%  # use the default base map which is OpenStreetMap tiles
  addMarkers(lng=174.768, lat=-36.852,
             popup="The birthplace of R")
print(map)
```


<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/birthplace_r.html" frameborder="0" allowfullscreen></iframe>


## Create your own interactive map

Let's create our own interactive map using the surface water data that we used
in the previous lessons, using leaflet. To do this, we will follow the steps below:

1. Request and get the data from the colorado.gov SODA API in `R` using `getURL()`.
2. Convert the data from JSON to a data.frame in `R` using `fromJSON()`.
3. Address column data types to ensure our numeric data are in fact numeric.
3. Remove `NA` (missing data) values.

The code below is the same code that we used to process the surface water
data in the previous lesson.


```r
base_url <- "https://data.colorado.gov/resource/j5pc-4t32.json?"
full_url <- paste0(base_url, "station_status=Active",
            "&county=BOULDER")
water_data <- getURL(URLencode(full_url))
water_data_df <- fromJSON(water_data)
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)

# turn columns to numeric and remove NA values
water_data_df <- water_data_df %>%
  mutate_each_(funs(as.numeric), c( "amount", "location.latitude", "location.longitude")) %>%
  filter(!is.na(location.latitude))
```

Once our data are cleaned up, we can create our leaflet map. Notice that we are
using pipes `%>%` to set the parameters for the leaflet map.



```r
# create leaflet map
leaflet(water_data_df) %>%
  addTiles() %>%
  addCircleMarkers(lng=~location.longitude, lat=~location.latitude)
```


The code below provides an example of creating the same map without using pipes.


```r
map <- leaflet(water_data_df)
map <- addTiles(map)
map <- addCircleMarkers(map, lng=~location.longitude, lat=~location.latitude)
```



<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/water_map1.html" frameborder="0" allowfullscreen></iframe>

## Customize leaflet maps

We can customize our leaflet map too. Let's do the following:

1. Add custom data-driven popups to our map
2. Adjust the point symbology
2. Adjust the basemap. Let's use a basemap from <a href="https://carto.com/blog/getting-to-know-positron-and-dark-matter" target="_blank">CartoDB</a> called Positron.

Notice in the code below that we can specify the popup text using the `popup=`
argument.

`addMarkers(lng=~location.longitude, lat=~location.latitude, popup=~station_name)`

We specify the basemap using the `addProviderTiles()` argument:

`addProviderTiles("CartoDB.Positron")`


```r
leaflet(water_data_df) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(lng=~location.longitude, lat=~location.latitude, popup=~station_name)
```



<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/water_map2.html" frameborder="0" allowfullscreen></iframe>

### Custom icons

We can even specify a *custom* icon, just for fun. BElow, we are using an icon
from the <a href="http://tinyurl.com/jeybtwj" target="_blank">web</a>.

Notice also that we are customizing the popup even more, adding BOTH the station
name AND the discharge value.

`paste0(station_name, "<br/>Discharge: ", amount)`

We are using `paste0()` to do this. Remember that `paste0()` will paste together
a series of text strings and object values.


```r
# let's look at the output of our popup text before calling it in leaflet
paste0(water_data_df$station_name, "<br/>Discharge: ", water_data_df$amount)
##  [1] "FOUR MILE CREEK AT LOGAN MILL ROAD NEAR CRISMAN, CO<br/>Discharge: 17"              
##  [2] "GOODING A AND D PLUMB DITCH<br/>Discharge: 7.2"                                     
##  [3] "BOULDER RESERVOIR INLET<br/>Discharge: 0"                                           
##  [4] "GOSS DITCH 1<br/>Discharge: 0.01"                                                   
##  [5] "LEFT HAND CREEK NEAR BOULDER, CO.<br/>Discharge: 12.6"                              
##  [6] "SAINT VRAIN CREEK AT LYONS, CO<br/>Discharge: 75.6"                                 
##  [7] "ST. VRAIN CREEK BELOW BOULDER CREEK AT HWY 119 NEAR LONGMONT, CO<br/>Discharge: 144"
##  [8] "BOULDER CREEK NEAR ORODELL<br/>Discharge: 23"                                       
##  [9] "MIDDLE BOULDER CREEK AT NEDERLAND<br/>Discharge: 21.5"                              
## [10] "SOUTH BOULDER CREEK BELOW GROSS RESERVOIR<br/>Discharge: 34.3"                      
## [11] "SOUTH BOULDER CREEK NEAR ELDORADO SPRINGS<br/>Discharge: 44.2"                      
## [12] "LITTLE THOMPSON #1 DITCH<br/>Discharge: 0.72"                                       
## [13] "LITTLE THOMPSON #2 DITCH<br/>Discharge: 0"                                          
## [14] "BONUS DITCH<br/>Discharge: 0"                                                       
## [15] "CLOUGH AND TRUE DITCH<br/>Discharge: 0"                                             
## [16] "DAVIS AND DOWNING DITCH<br/>Discharge: 2.27"                                        
## [17] "DENIO TAYLOR DITCH<br/>Discharge: 0"                                                
## [18] "HAGER MEADOWS DITCH<br/>Discharge: 1.64"                                            
## [19] "JAMES DITCH<br/>Discharge: 0.12"                                                    
## [20] "LEFT HAND CREEK AT HOVER ROAD NEAR LONGMONT, CO<br/>Discharge: 1.4"                 
## [21] "LONGMONT SUPPLY DITCH<br/>Discharge: 0.82"                                          
## [22] "NIWOT DITCH<br/>Discharge: 0.71"                                                    
## [23] "NORTHWEST MUTUAL DITCH<br/>Discharge: 0.02"                                         
## [24] "OLIGARCHY DITCH DIVERSION<br/>Discharge: 0.08"                                      
## [25] "PALMERTON DITCH<br/>Discharge: 0"                                                   
## [26] "ROUGH AND READY DITCH<br/>Discharge: 0"                                             
## [27] "RUNYON DITCH<br/>Discharge: 0"                                                      
## [28] "SAINT VRAIN CREEK BELOW KEN PRATT BLVD AT LONGMONT, CO<br/>Discharge: 25.9"         
## [29] "SMEAD DITCH<br/>Discharge: 0"                                                       
## [30] "SOUTH BRANCH ST. VRAIN CREEK<br/>Discharge: 14.13"                                  
## [31] "SOUTH FLAT DITCH<br/>Discharge: 0.23"                                               
## [32] "SUPPLY DITCH<br/>Discharge: 0"                                                      
## [33] "SWEDE DITCH<br/>Discharge: 0"                                                       
## [34] "TRUE AND WEBSTER DITCH<br/>Discharge: 0.03"                                         
## [35] "UNION RESERVOIR<br/>Discharge: 8595"                                                
## [36] "UNION RESERVOIR<br/>Discharge: 12.17"                                               
## [37] "WEBSTER MCCASLIN DITCH<br/>Discharge: 0.17"                                         
## [38] "ZWECK AND TURNER DITCH<br/>Discharge: 1.8"                                          
## [39] "BOULDER CREEK AT NORTH 75TH STREET NEAR BOULDER<br/>Discharge: 88"                  
## [40] "BOULDER CREEK SUPPLY CANAL TO BOULDER CREEK NEAR BOULDER<br/>Discharge: 2.02"       
## [41] "DRY CREEK CARRIER<br/>Discharge: 0.84"                                              
## [42] "LEGGETT DITCH<br/>Discharge: 0.56"                                                  
## [43] "SAINT VRAIN SUPPLY CANAL NEAR LYONS, CO<br/>Discharge: 48.5"                        
## [44] "BOULDER RESERVOIR<br/>Discharge: 5011.5"                                            
## [45] "SOUTH BOULDER CREEK DIVERSION NEAR ELDORADO SPRINGS<br/>Discharge: 0"               
## [46] "BOULDER CREEK FEEDER CANAL NEAR LYONS<br/>Discharge: 46.6"                          
## [47] "HIGHLAND DITCH AT LYONS, CO<br/>Discharge: 72.7"                                    
## [48] "FOURMILE CREEK AT ORODELL, CO.<br/>Discharge: 4.5"
```

The `<br/>` element in our popup above is HTML. This adds a line break to our
popup so the Discharge text and value are on the second line - below the
station name.

Let's see what the custom icon and popup text looks like on our map.


```r
# Specify custom icon
url = "http://tinyurl.com/jeybtwj"
water = makeIcon(url, url, 24, 24)

leaflet(water_data_df) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=~location.longitude, lat=~location.latitude, icon=water,
             popup=~paste0(station_name,
                           "<br/>Discharge: ",
                           amount))
```



<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/water_map3.html" frameborder="0" allowfullscreen></iframe>

There is a lot more to learn about leaflet. Here, we've just scratched the surface.
