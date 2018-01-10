---
layout: single
title: "Layer a Raster Dataset Over a Hillshade Using R Baseplot to Create a Beautiful Basemap That Represents Topography"
excerpt: "This lesson covers how to overlay raster data on a hillshade in R using baseplot and layer opacity arguments."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['hw-lidar-r']
permalink: /courses/earth-analytics/lidar-raster-data-r/overlay-raster-on-hillshade-r/
nav-title: 'Overlay Rasters'
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


{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Overlay 2 rasters in `R` to create a plot.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* Install **devtools**: `install.packages('devtools')`
* Install **ggmap** from github: `devtools::install_github("dkahle/ggmap")`

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)

</div>


```r
# load raster and rgdal libraries for spatial data
library(raster)
library(rgdal)
```

## Overlay Rasters in R

Here, you will cover overlaying rasters on top of a hillshade for nicer looking
plots in `R`. To overlay a raster you will use the `add = T` argument in the `R` `plot()`
function. You will use alpha to adjust the transparency of one of your rasters so
the terrain hillshade gives the raster texture! Also you will turn off the legend
for the hillshade plot as the legend you want to see is the `DEM` elevation values.


```r
# open raster DTM data
lidar_dem <- raster(x = "data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# open dem hillshade
lidar_dem_hill <- raster(x = "data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DTM_hill.tif")

# plot raster data
plot(lidar_dem_hill,
     main = "Lidar Digital Elevation Model (DEM)\n overlayed on top of a hillshade",
     col = grey(1:100/100),
     legend = FALSE)

plot(lidar_dem,
     main = "Lidar Digital Elevation Model (DEM)",
     add = TRUE, alpha = .5)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/hw-ggmap-markdown/2017-02-01-hw03-overlay-rasters/create-base-map-1.png" title="overlay plot" alt="overlay plot" width="90%" />
