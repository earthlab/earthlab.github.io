---
layout: single
title: "The Fastest Way to Process Rasters in R"
excerpt: "."
authors: ['Leah Wasser']
modified: '2017-10-11'
category: [courses]
class-lesson: ['spectral-data-fire-r']
permalink: /courses/earth-analytics/spectral-remote-sensing-landsat/process-rasters-faster-in-R/
nav-title: 'Faster Raster Calculations'
week: 7
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
redirect_from:
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Calculate NDVI using NAIP multispectral imagery in `R`
* Describe what a vegetation index is and how it is used with spectral remote sensing data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 7 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>

Below you will find several benchmark tests that demonstrate the fastest way
to process raster data in R.

The summary

1. For basic raster math - for example subtracting two rasters, it's fastest to
just perform the math!
2. For more complex math calculations like NDVI the overlay function is faster.
3. Raster bricks are always faster!


```r
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
# turn off factors
options(stringsAsFactors = FALSE)
```



```r
# import the naip pre-fire data
naip_multispectral_st <- stack("data/week_07/naip/m_3910505_nw_13_1_20130926/crop/m_3910505_nw_13_1_20130926_crop.tif")
## Error in .rasterObjectFromFile(x, objecttype = "RasterBrick", ...): Cannot create a RasterLayer object from this file. (file does not exist)
```



```r
# create a function that subtracts two rasters

diff_rasters <- function(b1, b2){
  # this function calculates the difference between two rasters of the same CRS and extent
  # input: 2 raster layers of the same extent, crs that can be subtracted
  # output: a single different raster of the same extent, crs of the input rasters
  diff <- b2 - b1
  return(diff)
}
```

Let's test things out


```r
# import lidar rasters
lidar_dsm <- raster(x = "data/week_03/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")
lidar_dtm <- raster(x = "data/week_03/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# calculate difference  - make sure our provide the rasters in the right order!
lidar_chm <- overlay(lidar_dtm, lidar_dsm,
                     fun = diff_rasters)

plot(lidar_chm,
     main = "Canopy Height  Model derived using the overlay function \n and the band_diff function\n that you created")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/07-multispectral-remote-sensing/2017-02-22-spectral05-faster-raster-calculations-overlay-bricks-vs-basic-math-R/unnamed-chunk-2-1.png" title=" " alt=" " width="90%" />

```r


library(microbenchmark)
# is it faster?
microbenchmark((lidar_dsm - lidar_dsm), times = 5)
## Unit: milliseconds
##                     expr      min       lq     mean   median       uq
##  (lidar_dsm - lidar_dsm) 622.7785 626.6069 633.4542 629.1448 630.4278
##       max neval
##  658.3128     5

microbenchmark(overlay(lidar_dtm, lidar_dsm,
                     fun = diff_rasters), times = 5)
## Unit: milliseconds
##                                               expr      min      lq
##  overlay(lidar_dtm, lidar_dsm, fun = diff_rasters) 873.2108 905.183
##      mean   median       uq      max neval
##  960.7644 921.2681 1019.586 1084.574     5


lidar_br <- brick(lidar_dtm, lidar_dsm)
inMemory(lidar_br)
## [1] TRUE

microbenchmark(overlay(lidar_br[[1]], lidar_br[[2]],
                     fun = diff_rasters), times = 5)
## Unit: milliseconds
##                                                       expr      min
##  overlay(lidar_br[[1]], lidar_br[[2]], fun = diff_rasters) 251.7571
##        lq     mean   median       uq     max neval
##  258.8365 294.5122 296.5487 324.1719 341.247     5

microbenchmark((lidar_br[[2]] - lidar_br[[1]]), times = 5)
## Unit: milliseconds
##                             expr      min       lq     mean   median
##  (lidar_br[[2]] - lidar_br[[1]]) 189.2413 210.4848 211.1296 211.7415
##        uq      max neval
##  218.5993 225.5812     5
```

Let's test things out on NDVI which is a more complex equation.




```r
# calculate ndvi using the overlay function
# you will have to create the function on your own!
naip_ndvi_ov <- overlay(naip_multispectral_st[[1]],
        naip_multispectral_st[[4]],
        fun = normalized_diff)
## Error in overlay(naip_multispectral_st[[1]], naip_multispectral_st[[4]], : object 'naip_multispectral_st' not found

plot(naip_ndvi_ov,
     main = "NAIP NDVI calculated using the overlay function")
## Error in plot(naip_ndvi_ov, main = "NAIP NDVI calculated using the overlay function"): object 'naip_ndvi_ov' not found
```


Don't believe overlay is faster? Let's test it using a benchmark.


```r
library(microbenchmark)
# is the raster in memory?
inMemory(naip_multispectral_st)
## Error in inMemory(naip_multispectral_st): object 'naip_multispectral_st' not found

# How long does it take to calculate ndvi without overlay.
microbenchmark((naip_multispectral_st[[4]] - naip_multispectral_st[[1]]) / (naip_multispectral_st[[4]] + naip_multispectral_st[[1]]), times = 5)
## Error in microbenchmark((naip_multispectral_st[[4]] - naip_multispectral_st[[1]])/(naip_multispectral_st[[4]] + : object 'naip_multispectral_st' not found


# is the overlay function faster ?
microbenchmark(overlay(naip_multispectral_st[[1]],
        naip_multispectral_st[[4]],
        fun = normalized_diff), times = 5)
## Error in overlay(naip_multispectral_st[[1]], naip_multispectral_st[[4]], : object 'naip_multispectral_st' not found

# what if we make our stack a brick?
naip_multispectral_br <- brick(naip_multispectral_st)
## Error in brick(naip_multispectral_st): object 'naip_multispectral_st' not found
inMemory(naip_multispectral_br)
## Error in inMemory(naip_multispectral_br): object 'naip_multispectral_br' not found

microbenchmark(overlay(naip_multispectral_br[[1]],
        naip_multispectral_br[[4]],
        fun = normalized_diff), times = 5)
## Error in overlay(naip_multispectral_br[[1]], naip_multispectral_br[[4]], : object 'naip_multispectral_br' not found
```

Notice that the results above suggest that the overlay function is in fact
just a bit faster than the regular raster math approach. This may seem minor now.
However, we are only working with 55mb files. This will save processing time in the
long run as you work with larger raster files.

<div class="notice--info" markdown="1">

## Additional Resources



</div>
