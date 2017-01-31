---
layout: single
title: "Add a basemap to a R markdown report using ggmap"
excerpt: "."
authors: ['Leah Wasser']
modified: '2017-01-31'
category: [course-materials]
class-lesson: ['hw-lidar-r']
permalink: /course-materials/earth-analytics/week-3/overlay-rasters/
nav-title: 'Overlay rasters'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 3
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Overlay 2 rasters in R 

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* install **devtools**: `install.packages('devtools')`
* install **ggmap** from github: `devtools::install_github("dkahle/ggmap")`

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)

</div>


```r
# load raster and rgdal libraries for spatial data
library(raster)
library(rgdal)
```

## Overlay rasters in R 

Here, we will cover overlaying rasters on top of a hillshade for nicer looking 
plots in R. To overlay a raster will will use the add=T argument in the R plot() 
function. We will use alpha to adjust the transparency of one of our rasters so 
the terrain hillshade gives the raster texture! Also we will turn of the legend
for the hillshade plot as the legend we want to see is the DEM elevation values.


```r
# open raster DTM data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# open dem hillshade
lidar_dem_hill <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM_hill.tif")

# plot raster data
plot(lidar_dem_hill,
     main="Lidar Digital Elevation Model (DEM)",
     col=grey(1:100/100),
     legend=F)

plot(lidar_dem,
     main="Lidar Digital Elevation Model (DEM)",
     add=T, alpha=.5)
```

![overlay plot]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/hw-ggmap-markdown/2016-12-06-hw03-overlay-rasters/create-base-map-1.png)
