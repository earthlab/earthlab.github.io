---
layout: single
title: "An example of creating modular code in R - Efficient scientific programming"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-03-30'
category: [course-materials]
class-lesson: ['intro-APIs-r']
permalink: /course-materials/earth-analytics/week-10/leaflet-r/
nav-title: 'Leaflet '
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

*

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data that we already downloaded for week 6 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>






```r
library("knitr")
library("dplyr")
library("ggplot2")
library("RCurl")
library("rjson")
library("jsonlite")
```





## Interactive maps with Leaflet

Static maps are useful for adding context, but often times we want to interact with our data and explore things geographically--perhaps via an interactive web-map...

...this is after all, web-data we're working with!

- [Leaflet](http://leafletjs.com) is an open-source `JavaScript` library for mobile-friendly interactive maps
    - It is designed with *simplicity*, *performance* and *usability* in mind
    - It also has a beautiful, easy to use, and [well-documented API](http://leafletjs.com/reference.html)
- Even better, the `leaflet` `R` package 'wraps' Leaflet functionality in an easy to use `R` package!
  - Now, a basic web-map is as easy as:



<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/birthplace_r.html" frameborder="0" allowfullscreen></iframe>

Sometimes we want to interact with our data geographically.  We can create interactive
web maps using Leaflet. <a href="http://leafletjs.com" target="_blank">Leaflet</a>
is an open-source `JavaScript` library that can be used to create mobile-friendly interactive maps.

Leaflet is designed with *simplicity*, *performance* and *usability* in mind. It also
has an easy to use, and <a href="http://leafletjs.com/reference.html" target="_blank">well-documented API</a>

The `leaflet` `R` package 'wraps' Leaflet functionality in an easy to use `R` package.
Now, a basic web-map is as easy as:


```r
library(leaflet)

map = leaflet() %>%
  addTiles() %>%  # use the default base map which is OpenStreetMap tiles
  addMarkers(lng=174.768, lat=-36.852,
             popup="The birthplace of R")
print(map)
```




## Map our CO Water Data


- Getting back to our previous example, let's plot the current surface water conditions again, this time using `leaflet`. First we get the data and clean it as follows:

1. We download the data from the colorado.gov SODA API.
2. We convert the data from JSON to a data.frame in R using fromJSON()
3. We address column data types to ensure our numeric data are in fact numeric.
3. we remove NA values


```r
base_url <- "https://data.colorado.gov/resource/j5pc-4t32.json?"
full_url <- paste0(base, "station_status=Active",
            "&county=BOULDER")
water_data <- getURL(URLencode(full_url))
water_data_df <- fromJSON(water_data)
## Error: lexical error: invalid char in json text.
##                                        <!DOCTYPE html>  <html>      <h
##                      (right here) ------^
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)

# turn columns to numeric and remove NA values
water_data_df <- water_data_df %>%
  mutate_each_(funs(as.numeric), c( "amount", "location.latitude", "location.longitude")) %>%
  filter(!is.na(location.latitude))

# Note the code above is the same as doing the following below:
#water_data_df$amount <- as.numeric(water_data_df$amount)
# lat and long should also be numeric
# i'm also removing the nested location of these variables
#water_data_df$location.longitude <- as.numeric(water_data_df$location.longitude)
#water_data_df$location.latitude <- as.numeric(water_data_df$location.latitude)
```

Now, we can create our leaflet map. Notice that we are using pipes %>%  once again
to set the parameters for the leaflet map.



```r
# create leaflet map
leaflet(water_data_df) %>%
  addTiles() %>%
  addCircleMarkers(lng=~location.longitude, lat=~location.latitude)
```


## Leaflet could be a bonus / optonal how to

- In case you’re not familiar with the [`magrittr`](https://cran.r-project.org/web/packages/magrittr/index.html) pipe operator `(%>%)`, here is the equivalent *without* pipes:


```r
map = leaflet(water_data_df)
## Error in eval(expr, envir, enclos): could not find function "leaflet"
map = addTiles(map)
## Error in eval(expr, envir, enclos): could not find function "addTiles"
map = addCircleMarkers(map, lng=~location.longitude, lat=~location.latitude)
## Error in eval(expr, envir, enclos): could not find function "addCircleMarkers"
```


```
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```


<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/water_map1.html" frameborder="0" allowfullscreen></iframe>

## Customize leaflet maps

We can customize our leaflet map too. Let's add some popups to our map and
adjust the marker symbology!

We can also specify different basemaps to make our map look different. For example,
we can use a basemap from <a href="https://cartodb.com" target="_blank">CartoDB</a>
called Positron:


```r
leaflet(water_data_df) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(lng=~location.longitude, lat=~location.latitude, popup=~station_name)
```


```
## Error in eval(expr, envir, enclos): could not find function "leaflet"
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```


<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/water_map2.html" frameborder="0" allowfullscreen></iframe>

### Further customization

We can even specify a *custom* icon, just for fun:


```r
# Nothing special, just found this one online...
url = "http://tinyurl.com/jeybtwj"
water = makeIcon(url, url, 24, 24)

leaflet(water_data_df) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=~location.longitude, lat=~location.latitude, icon=water,
             popup=~paste0(station_name,
                           "<br/>Discharge: ",
                           amount))
```


```
## Error in eval(expr, envir, enclos): could not find function "makeIcon"
## Error in eval(expr, envir, enclos): could not find function "leaflet"
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```

<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/leaflet-maps/water_map3.html" frameborder="0" allowfullscreen></iframe>

That's it. Experiment with leaflet a bit more to learn more about customizing your maps.
