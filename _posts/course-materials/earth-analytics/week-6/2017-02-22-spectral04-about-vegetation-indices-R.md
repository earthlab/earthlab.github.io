---
layout: single
title: "Vegetation indices in R"
excerpt: "A vegetation index is a single value that quantifies vegetation health or structure. In this lesson, we will review the basic principles associated with calculating a vegetation index from raster formated, landsat remote sensing data in R. We will then export the calculated index raster as a geotiff using the writeRaster() function."
authors: ['Leah Wasser', 'Megan Cattau']
modified: '2017-05-01'
category: [course-materials]
class-lesson: ['spectral-data-fire-r']
permalink: /course-materials/earth-analytics/week-6/vegetation-indices-NDVI-in-R/
nav-title: 'NDVI vegetation index'
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 4
tags2:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  scientific-programming: ['r']
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Calculate NDVI in R
* Describe what a vegetation index is and how it is used with spectral remote sensing data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>

## About vegetation indices

A vegetation index is a single value that quantifies vegetation health or structure.
The math associated with calculating a vegetation index is derived from the physics
of light reflection and absorption across bands. For instance, it is known that
healthy vegetation reflects light strongly in the near infrared band and less strongly
in the visible portion of the spectrum. Thus, if you create a ratio between light
reflected in the near infrared and light reflected in the visible spectrum, it
will represent areas that potentially have healthy vegetation.


## Normalized difference vegetation index (NDVI)
The Normalized Difference Vegetation Index (NDVI) is a quantitative index of
greenness ranging from 0-1 where 0 represents minimal or no greenness and 1
represents maximum greenness.

NDVI is often used for a quantitate proxy measure of vegetation health, cover
and phenology (life cycle stage) over large areas.

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
library(RColorBrewer)
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

The normalized difference vegetation index (NDVI) uses a ratio between near infrared
and red light within the electromagnetic spectrum. To calculate NDVI we use the
following formula where NIR is near infrared light and
red represents red light. For our raster data, we will take the reflectance value
in the red and near infrared bands to calculate the index.
.
`(NIR - Red) / (NIR + Red)`


```r
# calculate NDVI
landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])

plot(landsat_ndvi,
     main="Landsat derived NDVI\n 23 July 2016")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2017-02-22-spectral04-about-vegetation-indices-R/calculate-ndvi-1.png" title="landsat derived NDVI plot" alt="landsat derived NDVI plot" width="100%" />

### View distribution of NDVI values


```r
# view distribution of NDVI values
hist(landsat_ndvi,
  main="NDVI: Distribution of pixels\n Landsat 2016 Cold Springs fire site",
  col="springgreen")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-6/2017-02-22-spectral04-about-vegetation-indices-R/ndvi-hist-1.png" title="histogram" alt="histogram" width="100%" />

## Export raster
When you are done, you may want to export your rasters so you could use them in
QGIS or ArcGIS or share them with your colleagues. To do this you use the writeRaster()
function.


```r
# export raster
# NOTE: this won't work if you don't have an outputs directory in your week6 dir!
writeRaster(x = landsat_ndvi,
              filename="data/week6/outputs/landsat_ndvi.tif",
              format = "GTiff", # save as a tif
              datatype='INT2S', # save as a INTEGER rather than a float
              overwrite = T)  # OPTIONAL - be careful. this will OVERWRITE previous files.
```



<div class="notice--info" markdown="1">

## Additional Resources

* <a href="<a href="https://phenology.cr.usgs.gov/ndvi_foundation.php" target="_blank">USGS Remote sensing phenology</a>
* <a href="http://earthobservatory.nasa.gov/Features/MeasuringVegetation/measuring_vegetation_2.php" target="_blank">NASA Earth Observatory - Vegetation indices</a>

</div>
