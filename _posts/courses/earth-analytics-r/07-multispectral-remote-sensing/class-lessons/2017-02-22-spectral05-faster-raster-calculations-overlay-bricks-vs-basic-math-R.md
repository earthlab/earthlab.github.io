---
layout: single
title: "The Fastest Way to Process Rasters in R"
excerpt: "."
authors: ['Leah Wasser']
modified: '2019-08-23'
category: [courses]
class-lesson: ['spectral-data-fire-r']
permalink: /courses/earth-analytics/multispectral-remote-sensing-data/process-rasters-faster-in-R/
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

* Calculate NDVI using NAIP multispectral imagery in `R`.
* Describe what a vegetation index is and how it is used with spectral remote sensing data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
data for week 7 of the course.

{% include /data_subsets/course_earth_analytics/_data-week6-7.md %}

</div>

Below you will find several benchmark tests that demonstrate the fastest way
to process raster data in R.

The summary:

1. For basic raster math - for example subtracting two rasters, it's fastest to
just perform the math!
2. For more complex math calculations like NDVI, the overlay function is faster.
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
naip_multispectral_st <- stack("data/week-07/naip/m_3910505_nw_13_1_20130926/crop/m_3910505_nw_13_1_20130926_crop.tif")
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

Let's use the same function on some more useful data. Calculate the difference
between the lidar DSM and DEM using this function.


```r
# import lidar rasters
lidar_dsm <- raster(x = "data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")
lidar_dtm <- raster(x = "data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# calculate difference  - make sure you provide the rasters in the right order!
lidar_chm <- overlay(lidar_dtm, lidar_dsm,
                     fun = diff_rasters)

plot(lidar_chm,
     main = "Canopy Height Model derived using the overlay function \n and the band_diff function\n that you created")
```

<img src="{{ site.url }}/images/courses/earth-analytics-r/07-multispectral-remote-sensing/class-lessons/2017-02-22-spectral05-faster-raster-calculations-overlay-bricks-vs-basic-math-R/lidar-chm-plot-1.png" title="Canopy Height Model from Lidar-derived rasters." alt="Canopy Height Model from Lidar-derived rasters." width="90%" />

```r

library(microbenchmark)
# is it faster?
microbenchmark((lidar_dsm - lidar_dsm), times = 10)
## Unit: seconds
##                     expr      min       lq    mean   median       uq
##  (lidar_dsm - lidar_dsm) 1.195069 1.225295 1.23376 1.237193 1.246978
##       max neval
##  1.261015    10

microbenchmark(overlay(lidar_dtm, lidar_dsm,
                     fun = diff_rasters), times = 10)
## Unit: seconds
##                                               expr     min       lq
##  overlay(lidar_dtm, lidar_dsm, fun = diff_rasters) 1.90598 1.912913
##      mean   median       uq      max neval
##  1.941824 1.931918 1.948537 2.020614    10
```

The overlay function is actually not faster when you are performing basic
raster calculations in `R`. However, it does become faster when using rasterbricks
and more complex calculations.

Let's test things out on NDVI which is a more complex equation.




```r
# calculate ndvi using the overlay function
# you will have to create the function on your own!
naip_ndvi_ov <- overlay(naip_multispectral_st[[1]],
        naip_multispectral_st[[4]],
        fun = normalized_diff)

plot(naip_ndvi_ov,
     main = "NAIP NDVI calculated using the overlay function")
```

<img src="{{ site.url }}/images/courses/earth-analytics-r/07-multispectral-remote-sensing/class-lessons/2017-02-22-spectral05-faster-raster-calculations-overlay-bricks-vs-basic-math-R/naip-ndvi-ov-plot-lesson-5-1.png" title="NAIP derived NDVI plot calculated using overlay function." alt="NAIP derived NDVI plot calculated using overlay function." width="90%" />


Don't believe overlay is faster? Let's test it using a benchmark.


```r
library(microbenchmark)
# is the raster in memory?
inMemory(naip_multispectral_st)
## [1] FALSE

# How long does it take to calculate ndvi without overlay.
microbenchmark((naip_multispectral_st[[4]] - naip_multispectral_st[[1]]) / (naip_multispectral_st[[4]] + naip_multispectral_st[[1]]), times = 5)
## Unit: seconds
##                                                                                                                      expr
##  (naip_multispectral_st[[4]] - naip_multispectral_st[[1]])/(naip_multispectral_st[[4]] +      naip_multispectral_st[[1]])
##       min       lq     mean   median       uq      max neval
##  2.700787 2.744317 2.753434 2.751233 2.773215 2.797619     5


# is overlay faster?
microbenchmark(overlay(naip_multispectral_st[[1]],
        naip_multispectral_st[[4]],
        fun = normalized_diff), times = 5)
## Unit: seconds
##                                                                                         expr
##  overlay(naip_multispectral_st[[1]], naip_multispectral_st[[4]],      fun = normalized_diff)
##       min       lq     mean   median       uq      max neval
##  2.050929 2.054214 2.054427 2.054597 2.055721 2.056675     5

# what if you make your stack a brick - is it faster?
naip_multispectral_br <- brick(naip_multispectral_st)
inMemory(naip_multispectral_br)
## [1] TRUE

microbenchmark(overlay(naip_multispectral_br[[1]],
        naip_multispectral_br[[4]],
        fun = normalized_diff), times = 5)
## Unit: milliseconds
##                                                                                         expr
##  overlay(naip_multispectral_br[[1]], naip_multispectral_br[[4]],      fun = normalized_diff)
##      min       lq     mean  median       uq      max neval
##  433.885 434.2624 476.2019 490.187 494.3802 528.2952     5
```

Notice that the results above suggest that the `overlay()` function is in fact
just a bit faster than the regular raster math approach. This may seem minor now.
However, you are only working with 55mb files. This will save processing time in the
long run, as you work with larger raster files.

<div class="notice--info" markdown="1">


</div>
