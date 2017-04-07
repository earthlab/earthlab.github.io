---
layout: single
title: "Creating interactive spatial maps in R using leaflet"
excerpt: "This lesson covers the basics of creating an interactive map using the leaflet API in R. We will import data from the Colorado Information warehouse using the SODA RESTful API and then create an interactive map that can be published to an HTML formatted file using knitr and rmarkdown."
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-04-07'
category: [course-materials]
class-lesson: ['intro-APIs-r']
permalink: /course-materials/earth-analytics/week-10/leaflet-r/
nav-title: 'Interactive maps with leaflet '
week: 10
sidebar:
  nav:
author_profile: false
comments: true
order: 7
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
map <- leaflet() %>%
  addTiles() %>%  # use the default base map which is OpenStreetMap tiles
  addMarkers(lng=174.768, lat=-36.852,
             popup="The birthplace of R")
map
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
##  [3] "LEFT HAND CREEK NEAR BOULDER, CO.<br/>Discharge: 18.5"                             
##  [4] "SAINT VRAIN CREEK AT LYONS, CO<br/>Discharge: 110"                                 
##  [5] "BOULDER CREEK NEAR ORODELL<br/>Discharge: 25.8"                                    
##  [6] "MIDDLE BOULDER CREEK AT NEDERLAND<br/>Discharge: 19"                               
##  [7] "SOUTH BOULDER CREEK BELOW GROSS RESERVOIR<br/>Discharge: 24.6"                     
##  [8] "SOUTH BOULDER CREEK NEAR ELDORADO SPRINGS<br/>Discharge: 23.2"                     
##  [9] "LITTLE THOMPSON #1 DITCH<br/>Discharge: 0.72"                                      
## [10] "LITTLE THOMPSON #2 DITCH<br/>Discharge: 0"                                         
## [11] "BONUS DITCH<br/>Discharge: 0"                                                      
## [12] "CLOUGH AND TRUE DITCH<br/>Discharge: 0"                                            
## [13] "DAVIS AND DOWNING DITCH<br/>Discharge: 2.27"                                       
## [14] "DENIO TAYLOR DITCH<br/>Discharge: 0"                                               
## [15] "GOSS DITCH 1<br/>Discharge: 0"                                                     
## [16] "HAGER MEADOWS DITCH<br/>Discharge: 1.7"                                            
## [17] "JAMES DITCH<br/>Discharge: 0.08"                                                   
## [18] "LEFT HAND CREEK AT HOVER ROAD NEAR LONGMONT, CO<br/>Discharge: 1.4"                
## [19] "LONGMONT SUPPLY DITCH<br/>Discharge: 0.82"                                         
## [20] "NIWOT DITCH<br/>Discharge: 0.66"                                                   
## [21] "NORTHWEST MUTUAL DITCH<br/>Discharge: 0"                                           
## [22] "OLIGARCHY DITCH DIVERSION<br/>Discharge: 0.08"                                     
## [23] "PALMERTON DITCH<br/>Discharge: 8.92"                                               
## [24] "ROUGH AND READY DITCH<br/>Discharge: 0"                                            
## [25] "RUNYON DITCH<br/>Discharge: 0"                                                     
## [26] "SAINT VRAIN CREEK BELOW KEN PRATT BLVD AT LONGMONT, CO<br/>Discharge: 30.3"        
## [27] "SMEAD DITCH<br/>Discharge: 0"                                                      
## [28] "SOUTH BRANCH ST. VRAIN CREEK<br/>Discharge: 13.76"                                 
## [29] "SOUTH FLAT DITCH<br/>Discharge: 0.23"                                              
## [30] "SUPPLY DITCH<br/>Discharge: 0"                                                     
## [31] "SWEDE DITCH<br/>Discharge: 0"                                                      
## [32] "TRUE AND WEBSTER DITCH<br/>Discharge: 0.03"                                        
## [33] "UNION RESERVOIR<br/>Discharge: 8564.8"                                             
## [34] "UNION RESERVOIR<br/>Discharge: 11.37"                                              
## [35] "WEBSTER MCCASLIN DITCH<br/>Discharge: 0.17"                                        
## [36] "ZWECK AND TURNER DITCH<br/>Discharge: 4.54"                                        
## [37] "BOULDER CREEK AT NORTH 75TH STREET NEAR BOULDER<br/>Discharge: 36"                 
## [38] "BOULDER CREEK SUPPLY CANAL TO BOULDER CREEK NEAR BOULDER<br/>Discharge: 3.28"      
## [39] "BOULDER RESERVOIR INLET<br/>Discharge: 68"                                         
## [40] "DRY CREEK CARRIER<br/>Discharge: 0.84"                                             
## [41] "LEGGETT DITCH<br/>Discharge: 0.12"                                                 
## [42] "SAINT VRAIN SUPPLY CANAL NEAR LYONS, CO<br/>Discharge: 52.1"                       
## [43] "ST. VRAIN CREEK BELOW BOULDER CREEK AT HWY 119 NEAR LONGMONT, CO<br/>Discharge: 87"
## [44] "SOUTH BOULDER CREEK DIVERSION NEAR ELDORADO SPRINGS<br/>Discharge: 0"              
## [45] "BOULDER CREEK FEEDER CANAL NEAR LYONS<br/>Discharge: 50.1"                         
## [46] "HIGHLAND DITCH AT LYONS, CO<br/>Discharge: 93.8"                                   
## [47] "BOULDER RESERVOIR<br/>Discharge: 5114"                                             
## [48] "FOURMILE CREEK AT ORODELL, CO.<br/>Discharge: 6.3"
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




Here we use `addAwesomeMarkers()` and adjust the color accordingly. 

<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/water_map_unique_markers1.html" frameborder="0" allowfullscreen></iframe>



Here we use `addCircleMarkers()` and adjust the color accordingly. 

<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/water_map_unique_markers2.html" frameborder="0" allowfullscreen></iframe>
