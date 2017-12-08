---
layout: single
title: "Clip Raster in R"
excerpt: "You can clip a raster to a polygon extent to save processing time and make image sizes smaller. Learn how to crop a raster dataset in R."
authors: ['Leah Wasser']
modified: '2017-12-08'
category: [courses]
class-lesson: ['intro-lidar-raster-r']
permalink: /courses/earth-analytics/lidar-raster-data-r/crop-raster-data-in-r/
nav-title: 'Crop a raster'
week: 3
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
   - "/course-materials/earth-analytics/week-3/crop-raster-data-in-r/"
---

{% include toc title="In this lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives

After completing this tutorial, you will be able to:

* Crop a raster dataset in `R` using a vector extent object derived from a shapefile
* Open a shapefile in `R`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* [How to setup R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Setup your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)
* [Intro to the R & RStudio interface](/courses/earth-analytics/document-your-science/intro-to-r-and-rstudio)

### R libraries to install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`
* * **sf:** `install.packages("sf")`

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download week 3 data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

In this lesson, we will learn how to crop a raster dataset in `R`. Previously,
we reclassified a raster in `R`, however the edges of our raster dataset were uneven.
In this lesson, we will learn how to crop a raster - to create a new raster
object / file that we can share with colleagues and / or open in other tools such
as `QGIS`.

## Load libraries


```r
# load the raster and rgdal libraries
library(raster)
library(rgdal)
# if you want to use sf. we will use sf for future lessons!
```

## Open raster and vector layers

First, we will use the `raster()` function to open a raster layer. Let's open the
canopy height model that we created in the previous lesson


```r
# open raster layer
lidar_chm <- raster("data/week-03/BLDR_LeeHill/outputs/lidar_chm.tif")

# plot CHM
plot(lidar_chm,
     col = rev(terrain.colors(50)))
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster06-crop-raster/open-raster-1.png" title="lidar chm plot" alt="lidar chm plot" width="90%" />

## Open vector layer

Next, let's open up a vector layer that contains the crop extent that we want
to use to crop our data. To open a shapefile we use the `readOGR()` function.



```r
# import the vector boundary
crop_extent <- readOGR("data/week-03/BLDR_LeeHill/clip-extent.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week-03/BLDR_LeeHill/clip-extent.shp", layer: "clip-extent"
## with 1 features
## It has 1 fields
## Integer64 fields read as strings:  id

# plot imported shapefile
# notice that we use add = T to add a layer on top of an existing plot in R.
plot(crop_extent,
     main = "Shapefile imported into R - crop extent",
     axes = TRUE,
     border="blue")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster06-crop-raster/plot-w-legend-1.png" title="shapefile crop extent plot" alt="shapefile crop extent plot" width="90%" />

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="The spatial extent of a shapefile or R spatial object represents the geographic 'edge' or location that is the furthest north, south east and west."></a>
    <figcaption>The spatial extent of a shapefile or `R` spatial object represents
    the geographic "edge" or location that is the furthest north, south east and
    west. Thus is represents the overall geographic coverage of the spatial
    object. Image Source: Colin Williams, NEON.
    </figcaption>
</figure>

Now that we have imported the shapefile. We can use the `crop()` function in `R` to
crop the raster data using the vector shapefile.


```r
# crop the lidar raster using the vector extent
lidar_chm_crop <- crop(lidar_chm, crop_extent)
plot(lidar_chm_crop, main = "Cropped lidar chm")

# add shapefile on top of the existing raster
plot(crop_extent, add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster06-crop-raster/crop-and-plot-raster-1.png" title="lidar chm cropped with vector extent on top" alt="lidar chm cropped with vector extent on top" width="90%" />

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge: Crop change over time layers

In the previous lesson, you created 2 plots:

1. A classified raster map that shows **positive and negative change** in the canopy
height model before and after the flood. To do this you will need to calculate the
difference between two canopy height models.
2. A classified raster map that shows **positive and negative change** in terrain
extracted from the pre and post flood Digital Terrain Models before and after the flood.

Create the same two plots except this time CROP each of the rasters that you plotted
using the shapefile: `data/week-03/BLDR_LeeHill/crop_extent.shp`

For each plot, be sure to:

* Add a legend that clearly shows what each color in your classified raster represents
* Use proper colors
* Add a title to your plot

You will include these plots in your final report due next week.

Check out <a href="https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf" target="_blank">this cheatsheet for more on colors in `R`. </a>

Or type: `grDevices::colors()` into the r console for a nice list of colors!
</div>
