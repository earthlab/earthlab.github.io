---
layout: single
title: "The Fastest Way to Process Rasters in R"
excerpt: "."
authors: ['Leah Wasser']
<<<<<<< HEAD
modified: '2017-10-16'
=======
modified: '2017-10-13'
>>>>>>> 6372458388f8a575c7eda33957800a42f30d34cb
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

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>

Below you will find several benchmark tests that demonstrate the fastest way
to process raster data in R.

The summary:

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
lidar_dsm <- raster(x = "data/week_03/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")
lidar_dtm <- raster(x = "data/week_03/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# calculate difference  - make sure you provide the rasters in the right order!
lidar_chm <- overlay(lidar_dtm, lidar_dsm,
                     fun = diff_rasters)

plot(lidar_chm,
     main = "Canopy Height  Model derived using the overlay function \n and the band_diff function\n that you created")
```

<img src="{{ site.url }}/images/rfigs/earth-analytics/00-course-overview/2017-01-01-course-home/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="90%" />

```r


library(microbenchmark)
# is it faster?
microbenchmark((lidar_dsm - lidar_dsm), times = 10)
## Unit: milliseconds
<<<<<<< HEAD
##                     expr      min       lq     mean   median      uq
##  (lidar_dsm - lidar_dsm) 969.3645 1004.799 1176.493 1100.125 1177.52
##       max neval
##  2045.088    10

microbenchmark(overlay(lidar_dtm, lidar_dsm,
                     fun = diff_rasters), times = 10)
## Unit: seconds
##                                               expr      min       lq
##  overlay(lidar_dtm, lidar_dsm, fun = diff_rasters) 1.752081 1.854199
##      mean   median       uq      max neval
##  2.315343 2.396342 2.703976 2.971181    10
=======
##                     expr      min       lq     mean   median       uq
##  (lidar_dsm - lidar_dsm) 586.6788 626.6211 634.1002 630.3315 634.3593
##       max neval
##  708.5057    10

microbenchmark(overlay(lidar_dtm, lidar_dsm,
                     fun = diff_rasters), times = 10)
## Unit: milliseconds
##                                               expr      min       lq
##  overlay(lidar_dtm, lidar_dsm, fun = diff_rasters) 875.1747 880.9694
##      mean   median       uq      max neval
##  912.3684 889.5246 922.4531 1024.926    10
>>>>>>> 6372458388f8a575c7eda33957800a42f30d34cb
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

<<<<<<< HEAD
<img src="{{ site.url }}/images/rfigs/earth-analytics/00-course-overview/2017-01-01-course-home/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" />
=======
<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/07-multispectral-remote-sensing/2017-02-22-spectral05-faster-raster-calculations-overlay-bricks-vs-basic-math-R/unnamed-chunk-3-1.png" title=" " alt=" " width="90%" />
>>>>>>> 6372458388f8a575c7eda33957800a42f30d34cb


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
<<<<<<< HEAD
##       min       lq     mean  median       uq      max neval
##  2.319132 2.343443 2.792462 2.44435 3.335952 3.519432     5
=======
##       min       lq     mean   median      uq      max neval
##  1.539887 1.610209 1.617421 1.632245 1.64767 1.657093     5
>>>>>>> 6372458388f8a575c7eda33957800a42f30d34cb


# is overlay faster?
microbenchmark(overlay(naip_multispectral_st[[1]],
        naip_multispectral_st[[4]],
        fun = normalized_diff), times = 5)
## Unit: seconds
##                                                                                         expr
##  overlay(naip_multispectral_st[[1]], naip_multispectral_st[[4]],      fun = normalized_diff)
<<<<<<< HEAD
##       min       lq     mean   median       uq      max neval
##  1.589334 1.602794 1.674545 1.681973 1.708959 1.789667     5
=======
##       min      lq     mean   median       uq      max neval
##  1.017689 1.05975 1.078894 1.095966 1.106077 1.114986     5
>>>>>>> 6372458388f8a575c7eda33957800a42f30d34cb

# what if you make your stack a brick - is it faster?
naip_multispectral_br <- brick(naip_multispectral_st)
inMemory(naip_multispectral_br)
## [1] FALSE

microbenchmark(overlay(naip_multispectral_br[[1]],
        naip_multispectral_br[[4]],
        fun = normalized_diff), times = 5)
## Unit: milliseconds
##                                                                                         expr
##  overlay(naip_multispectral_br[[1]], naip_multispectral_br[[4]],      fun = normalized_diff)
<<<<<<< HEAD
##       min       lq    mean   median       uq      max neval
##  712.4077 898.3845 896.107 910.6299 922.6388 1036.474     5
=======
##       min       lq     mean   median       uq      max neval
##  618.7955 658.7078 744.6838 676.6389 807.7829 961.4938     5
>>>>>>> 6372458388f8a575c7eda33957800a42f30d34cb
```

Notice that the results above suggest that the `overlay()` function is in fact
just a bit faster than the regular raster math approach. This may seem minor now.
However, you are only working with 55mb files. This will save processing time in the
long run as you work with larger raster files.

<div class="notice--info" markdown="1">


</div>
