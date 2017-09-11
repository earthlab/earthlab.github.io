---
layout: single
title: "Layer a \raster dataset over a hillshade using R baseplot to create a beautiful basemap that represents topography"
excerpt: "This lesson covers how to overlay raster data on a hillshade in R using baseplot and layer opacity arguments."
authors: ['Leah Wasser']
modified: '2017-09-10'
category: [courses]
class-lesson: ['hw-lidar-r']
permalink: /courses/earth-analytics/week-3/overlay-raster-on-hillshade-r/
nav-title: 'Overlay rasters'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics"
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data', 'vector-data']
---


{% include toc title="In this lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives

After completing this tutorial, you will be able to:

* Overlay 2 rasters in `R` to create a plot

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* Install **devtools**: `install.packages('devtools')`
* Install **ggmap** from github: `devtools::install_github("dkahle/ggmap")`

* [How to setup R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Setup your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)

</div>


```r
# load raster and rgdal libraries for spatial data
library(raster)
library(rgdal)
```

## Overlay rasters in R

Here, we will cover overlaying rasters on top of a hillshade for nicer looking
plots in `R`. To overlay a raster we will use the `add=T` argument in the `R` `plot()`
function. We will use alpha to adjust the transparency of one of our rasters so
the terrain hillshade gives the raster texture! Also we will turn off the legend
for the hillshade plot as the legend we want to see is the `DEM` elevation values.


```r
# open raster DTM data
lidar_dem <- raster(x="data/week_03/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# open dem hillshade
lidar_dem_hill <- raster(x="data/week_03/BLDR_LeeHill/pre-flood/lidar/pre_DTM_hill.tif")

# plot raster data
plot(lidar_dem_hill,
     main="Lidar Digital Elevation Model (DEM)\n overlayed on top of a hillshade",
     col=grey(1:100/100),
     legend=F)

plot(lidar_dem,
     main="Lidar Digital Elevation Model (DEM)",
     add=T, alpha=.5)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/hw-ggmap-markdown/2017-02-01-hw03-overlay-rasters/create-base-map-1.png" title="overlay plot" alt="overlay plot" width="90%" />
