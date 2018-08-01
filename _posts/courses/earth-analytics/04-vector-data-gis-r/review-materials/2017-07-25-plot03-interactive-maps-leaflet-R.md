---
layout: single
title: "Make Interactive Maps with Leaflet R - GIS in R"
excerpt: "In this lesson you learn the steps to create a map in R using ggplot."
authors: ['Leah Wasser']
modified: '2018-07-30'
category: [courses]
class-lesson: ['hw-custom-maps-r']
permalink: /courses/earth-analytics/spatial-data-r/make-interactive-maps-with-leaflet-r/
nav-title: 'Interactive Leaflet Maps'
week: 4
course: "earth-analytics"
module-type: "class"
sidebar:
  nav:
author_profile: false
comments: false
order: 3
class-order: 2
topics:
  spatial-data-and-gis: ['vector-data', 'coordinate-reference-systems', 'maps-in-r']
  reproducible-science-and-programming:
---


<!--# remove module-type: 'class' so it doesn't render live -->

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Create an interactive map in `R` using `leaflet()`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

</div>


First, let's import all of the needed libraries.


```r
# load libraries
library(dplyr)
library(rgdal)
library(ggplot2)
library(leaflet)
## Error in library(leaflet): there is no package called 'leaflet'
# set factors to false
options(stringsAsFactors = FALSE)
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
map <- leaflet() %>%
  addTiles() %>%  # use the default base map which is OpenStreetMap tiles
  addMarkers(lng = 174.768, lat = -36.852,
             popup = "The birthplace of R")
map
```




<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/birthplace_r.html" frameborder="0" allowfullscreen></iframe>


Next, import and explore the data.



```r
# import roads
plot_locations <- readOGR("data/week-04/california/SJER/vector_data/SJER_plot_centroids.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "/Users/lewa8222/Dropbox/earth-analytics/data/week-04/california/SJER/vector_data/SJER_plot_centroids.shp", layer: "SJER_plot_centroids"
## with 18 features
## It has 5 fields
# reproject to latitude / longitude so the data line up with leaflet basemaps
plot_locations_latlon <- sjer_aoi_WGS84 <- spTransform(plot_locations,
                                CRS("+proj=longlat +datum=WGS84"))
plot_locations_df <- as.data.frame(plot_locations_latlon, region = "id")
str(plot_locations_df)
## 'data.frame':	18 obs. of  8 variables:
##  $ Plot_ID  : chr  "SJER1068" "SJER112" "SJER116" "SJER117" ...
##  $ Point    : chr  "center" "center" "center" "center" ...
##  $ northing : num  4111568 4111299 4110820 4108752 4110476 ...
##  $ easting  : num  255852 257407 256839 256177 255968 ...
##  $ plot_type: chr  "trees" "trees" "grass" "trees" ...
##  $ coords.x1: num  -120 -120 -120 -120 -120 ...
##  $ coords.x2: num  37.1 37.1 37.1 37.1 37.1 ...
##  $ region   : chr  "id" "id" "id" "id" ...
```

Plot the data and use the plotID field as a popup.


```r
# plot points on top of a leaflet basemap
site_locations <- leaflet(plot_locations_df) %>%
  addTiles() %>%
  addCircleMarkers(lng = ~coords.x1, lat = ~coords.x2, popup = ~Plot_ID)

site_locations
```



<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/site_locations.html" frameborder="0" allowfullscreen></iframe>


Add unique colors according to plot type.


```r
# define colors - you can find colors that look better than these!
pal <- colorFactor(c("navy", "darkgreen", "darkorchid4"), domain = unique(sjer_aoi_WGS84$plot_type))

# plot points on top of a leaflet basemap
site_locations_colors <- leaflet(plot_locations_df) %>%
  addTiles() %>%
  addCircleMarkers(
     color = ~pal(plot_type),
    lng = ~coords.x1, lat = ~coords.x2, popup = ~Plot_ID)

site_locations_colors
```




<iframe title="Basic Map" width="80%" height="600" src="{{ site.url }}/example-leaflet-maps/site_locations_colors.html" frameborder="0" allowfullscreen></iframe>
