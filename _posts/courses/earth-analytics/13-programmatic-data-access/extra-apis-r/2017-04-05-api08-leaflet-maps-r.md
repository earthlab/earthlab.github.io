---
layout: single
title: "Creating Interactive Spatial Maps in R Using Leaflet"
excerpt: "This lesson covers the basics of creating an interactive map using the leaflet API in R. We will import data from the Colorado Information warehouse using the SODA RESTful API and then create an interactive map that can be published to an HTML formatted file using knitr and rmarkdown."
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-APIs-r']
permalink: /courses/earth-analytics/get-data-using-apis/leaflet-r/
nav-title: 'Interactive Maps with Leaflet '
week: 13
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 8
topics:
  find-and-manage-data: ['apis']
redirect_from:
   - "/courses/earth-analytics/week-10/leaflet-r/"
---


{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Create an interactive leaflet map using `R` and rmarkdown.
* Customize an interactive map with data-driven popups.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>






```r
# load packages
library(dplyr)
library(ggplot2)
library(rjson)
library(jsonlite)
library(leaflet)
library(RCurl)
```




## Interactive Maps with Leaflet

Static maps are useful for creating figures for reports and presentation. Sometimes,
however, you want to interact with your data. You can use the leaflet package for
R to overlay your data on top of interactive maps. You can think about it like
Google  maps with your data overlaid on top!

### What is Leaflet?

<a href="http://leafletjs.com" target="_blank">Leaflet</a> is an open-source `JavaScript` library that can be used to create mobile-friendly interactive maps.

Leaflet:

* Is designed with *simplicity*, *performance* and *usability* in mind.
* Has a beautiful, easy to use, and <a href="http://leafletjs.com/reference.html" target="_blank">well-documented API</a>.


The `leaflet` `R` package 'wraps' Leaflet functionality in an easy to use `R` package! Below, you can see some code that creates a basic web-map.


```r
r_birthplace_map <- leaflet() %>%
  addTiles() %>%  # use the default base map which is OpenStreetMap tiles
  addMarkers(lng=174.768, lat=-36.852,
             popup="The birthplace of R")
r_birthplace_map
```



<iframe title = "Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/birthplace_r.html" frameborder="0" allowfullscreen></iframe>

### Grey Background When You Knit

If your interactive map has a grey background when you knit to html, you can
try to change the provider tile background as described <a href="{{ site.url }}/courses/earth-analytics/get-data-using-apis/leaflet-r/"> below on this page.</a>

## Create Your Own Interactive Map

Let's create your own interactive map using the surface water data that you used
in the previous lessons, using leaflet. To do this, you will follow the steps below:

1. Request and get the data from the colorado.gov SODA API in `R` using `fromJSON()`.
1. Address column data types to ensure your quantitative data (number values) data are in fact numeric.
1. Remove `NA` (missing data) values.

The code below is the same code that you used to process the surface water
data in the previous lesson.


```r
base_url <- "https://data.colorado.gov/resource/j5pc-4t32.json?"
full_url <- paste0(base_url, "station_status=Active",
            "&county=BOULDER")
water_data <- getURL(URLencode(full_url))

# you can then pipe this
water_data_df <- fromJSON(water_data) %>%
  flatten(recursive = TRUE) # remove the nested data frame

# turn columns to numeric and remove NA values
water_data_df <- water_data_df %>%
  mutate_at(vars(amount, location.latitude, location.longitude), funs(as.numeric)) %>%
  filter(!is.na(location.latitude))
```

Once your data are cleaned up, you can create your leaflet map. Notice that you are
using pipes `%>%` to set the parameters for the leaflet map.



```r
# create leaflet map
water_locations_map <- leaflet(water_data_df) %>%
  addTiles() %>%
  addCircleMarkers(lng = ~location.longitude,
                   lat = ~location.latitude)
```


<div class="notice--success" markdown="1">
<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** The code
below provides an example of creating the same map without using pipes.


```r
water_locations_map <- leaflet(water_data_df)
water_locations_map <- addTiles(water_locations_map)
water_locations_map <- addCircleMarkers(water_locations_map, lng = ~location.longitude,
                        lat = ~location.latitude)
water_locations_map
```


</div>

<iframe title = "Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/water_map1.html" frameborder="0" allowfullscreen></iframe>

## Customize Leaflet Maps

You can customize your leaflet map too. Let's do the following:

1. Add custom data-driven popups to your map.
2. Adjust the point symbology.
2. Adjust the basemap. Let's use a basemap from <a href="https://carto.com/blog/getting-to-know-positron-and-dark-matter" target="_blank">CartoDB</a> called Positron.

Notice in the code below that you can specify the popup text using the `popup=`
argument.

`addMarkers(lng=~location.longitude, lat = ~location.latitude, popup = ~station_name)`

You specify the basemap using the `addProviderTiles()` argument. In the example
below, you use the `CartoDB.Positron` basemap:

`addProviderTiles("CartoDB.Positron")`


```r
leaflet(water_data_df) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(lng = ~location.longitude, lat = ~location.latitude,
             popup = ~station_name)
```



<iframe title = "Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/water_map2.html" frameborder="0" allowfullscreen></iframe>

### Custom Icons

You can specify a *custom* icon, too. Below, you are using an icon
from the <a href="http://tinyurl.com/jeybtwj" target="_blank">web</a>.

Notice also that you are customizing the popup even more, adding BOTH the station
name AND the discharge value.

`paste0(station_name, "<br/>Discharge: ", amount)`

You are using `paste0()` to do this. Remember that `paste0()` will paste together
a series of text strings and object values.


```r
# let's look at the output of your popup text before calling it in leaflet
# use head() to just look at the first 6 lines of the output
head(paste0(water_data_df$station_name, "<br/>Discharge: ", water_data_df$amount))
## [1] "LITTLE THOMPSON #1 DITCH<br/>Discharge: 0"              
## [2] "LITTLE THOMPSON #2 DITCH<br/>Discharge: 0"              
## [3] "BONUS DITCH<br/>Discharge: 0"                           
## [4] "BUTTONROCK (RALPH PRICE) RESERVOIR<br/>Discharge: 16146"
## [5] "CLOUGH AND TRUE DITCH<br/>Discharge: 0"                 
## [6] "DAVIS AND DOWNING DITCH<br/>Discharge: 1.8"
```

The `<br/>` element in your popup above is HTML. This adds a line break to your
popup so the Discharge text and value are on the second line - below the
station name.

Let's see what the custom icon and popup text looks like on your map.


```r
# Specify custom icon
url <- "http://tinyurl.com/jeybtwj"
water <- makeIcon(url, url, 24, 24)

leaflet(water_data_df) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng = ~location.longitude, lat = ~location.latitude, icon=water,
             popup = ~paste0(station_name,
                           "<br/>Discharge: ",
                           amount))
```


```r
url <- "http://tinyurl.com/jeybtwj"
water <-  makeIcon(url, url, 24, 24)

map = leaflet(water_data_df) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng = ~location.longitude, lat=~location.latitude, icon=water,
             popup = ~paste0(station_name, "<br/>Discharge: ", amount))
saveWidget(widget=map,
           file="water_map3.html",
           selfcontained=TRUE)
```

<iframe title = "Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/water_map3.html" frameborder="0" allowfullscreen></iframe>

There is a lot more to learn about leaflet. Here, you've just scratched the surface.



```r
# water_data_df
water_data_df$station_type <- factor(water_data_df$station_type)

new <- c("red", "green","blue")[water_data_df$station_type]

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = new
)

unique_markers_map2 <- leaflet(water_data_df) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addAwesomeMarkers(lng=~location.longitude, lat=~location.latitude, icon=icons,
                    popup=~station_name,
                    label=~as.character(station_name))

```


```
## Error in resolveSizing(x, x$sizingPolicy, standalone = standalone, knitrOptions = knitrOptions): object 'unique_markers_map2' not found
```

Here you use `addAwesomeMarkers()` and adjust the color of each point on the map
accordingly.

<iframe title = "Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/water_map_unique_markers1.html" frameborder="0" allowfullscreen></iframe>


```r

pal <- colorFactor(c("navy", "red", "green"),
                   domain = unique(water_data_df$station_type))

unique_markers_map <- leaflet(water_data_df) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(
    color = ~pal(station_type),
    stroke = FALSE, fillOpacity = 0.5,
    lng = ~location.longitude, lat = ~location.latitude,
    label = ~as.character(station_type)
  )

unique_markers_map

```


```
## Error in resolveSizing(x, x$sizingPolicy, standalone = standalone, knitrOptions = knitrOptions): object 'unique_markers_map' not found
```

Here you use `addCircleMarkers()` and adjust the color accordingly.

<iframe title = "Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/water_map_unique_markers2.html" frameborder="0" allowfullscreen></iframe>
