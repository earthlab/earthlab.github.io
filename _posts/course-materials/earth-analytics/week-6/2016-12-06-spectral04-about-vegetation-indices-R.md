---
layout: single
title: "Landsat tif files in R"
excerpt: ". "
authors: ['Leah Wasser']
modified: '2017-02-21'
category: [course-materials]
class-lesson: ['spectral-data-fire-r']
permalink: /course-materials/earth-analytics/week-6/landsat-vegetation-indices-in-R/
nav-title: 'Veg indices in R'
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 4
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Calculate NDVI and NBR in R
* Describe what a vegetation index is and how it is used with spectral remote sensing data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.


</div>

## About vegetation indices

https://phenology.cr.usgs.gov/ndvi_foundation.php
http://earthobservatory.nasa.gov/Features/MeasuringVegetation/measuring_vegetation_2.php

## About NDVI
The Normalized Difference Vegetation Index (NDVI) is a quantitative index of
greenness ranging from 0-1 where 0 represents minimal or no greenness and 1
represents maximum greenness.

NDVI is often used for a quantitate proxy measure of vegetation health, cover
and phenology (life cycle stage) over large areas. Our NDVI data is a Landsat
derived single band product saved as a GeoTIFF for different times of the year.

<figure>
 <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/Images/ndvi_example.jpg">
 <img src="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/Images/ndvi_example.jpg" alt="NDVI image from NASA that shows reflectance."></a>
    <figcaption>NDVI is calculated from the visible and near-infrared light
    reflected by vegetation. Healthy vegetation (left) absorbs most of the
    visible light that hits it, and reflects a large portion of
    near-infrared light. Unhealthy or sparse vegetation (right) reflects more
    visible light and less near-infrared light. Source: NASA
    </figcaption>
</figure>

* <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/measuring_vegetation_2.php" target="_blank">
More on NDVI from NASA</a>

## Calculate NDVI

Sometimes we are able to download already calculated NDVI data products. In this
case, we need to calculate NDVI ourselves using the reflectance data that we have. 


```r
# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
# turn off factors
options(stringsAsFactors = F)
```



```r
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern=glob2rx("*band*.tif$"),
           full.names = T) # use the dollar sign at the end to get all files that END WITH
all_landsat_bands
## [1] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band1_crop.tif"
## [2] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band2_crop.tif"
## [3] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band3_crop.tif"
## [4] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band4_crop.tif"
## [5] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band5_crop.tif"
## [6] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band6_crop.tif"
## [7] "data/week6/Landsat/LC80340322016205-SC20170127160728/crop/LC80340322016205LGN00_sr_band7_crop.tif"

# stack the data
landsat_stack_csf <- stack(all_landsat_bands)
```


## Calculate NDVI
(NIR - Red) / (NIR + Red)


```r

landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])

plot(landsat_ndvi,
     main="Landsat derived NDVI\n 23 July 2016")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral04-about-vegetation-indices-R/calculate-ndvi-1.png" title="landsat derived NDVI plot" alt="landsat derived NDVI plot" width="100%" />

### View distribution of NDVI values


```r
# view distribution of NDVI values
hist(landsat_ndvi)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral04-about-vegetation-indices-R/ndvi-hist-1.png" title="histogram" alt="histogram" width="100%" />

## Calculate NBR

figure:
nbr_index.png


This index highlights burned areas in large fire zones greater than 500 acres. The formula is similar to a normalized difference vegetation index (NDVI), except that it uses near-infrared (NIR) and shortwave-infrared (SWIR) wavelengths (Lopez, 1991; Key and Benson, 1995).


The NBR was originally developed for use with Landsat TM and ETM+ bands 4 and 7, but it will work with any multispectral sensor (including Landsat 8) with a NIR band between 0.76-0.9 µm and a SWIR band between 2.08-2.35
µm.

Look at the table. what bands do you need to calculate Nbr?

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2016-12-06-spectral04-about-vegetation-indices-R/calculate-nbr-1.png" title="landsat derived NDVI plot" alt="landsat derived NDVI plot" width="100%" />
