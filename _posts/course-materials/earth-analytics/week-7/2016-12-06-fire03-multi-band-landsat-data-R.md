---
layout: single
title: "Working with multiple bands in R."
excerpt: "In this lesson we will review how to open up a multi-band image in R. "
authors: ['Megan Cattau', 'Leah Wasser']
modified: '2017-02-27'
category: [course-materials]
class-lesson: ['spectral-data-fire-2-r']
permalink: /course-materials/earth-analytics/week-6/naip-imagery-raster-stacks-in-r/
nav-title: 'Modis data in R'
week: 7
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

* Open an RGB image with 3-4 bands in R using `plotRGB()`
* Export an RGB image as a Geotiff using `writeRaster()`
* Identify the number of bands stored in a multi-band raster in `R`.
* Plot various band composits in R including True Color (RGB), and Color Infrared (CIR)

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7636975){:data-proofer-ignore='' .btn }
</div>







```r
# open modis bands
all_modis_bands <-list.files("data/week6/modis/reflectance/07_july_2016/crop",
           pattern=glob2rx("*sur_refl*.tif$"),
           full.names = T)

all_modis_bands_st <- stack(all_modis_bands)
## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st,
        r=1, g =4, b=3,
        stretch="lin")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-multi-band-landsat-data-R/work-with-modis-1.png" title=" " alt=" " width="100%" />

```r

# view fire overlay boundary
fire_boundary <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp", layer: "co_cold_springs_20160711_2200_dd83"
## with 1 features
## It has 21 fields
fire_boundary_sin <- spTransform(fire_boundary,
                                 CRS=crs(all_modis_bands_st))

# export as sinusoidal
writeOGR(fire_boundary_sin,
         dsn = "data/week6/vector_layers/fire-boundary-geomac",
         layer="co_cold_springs_20160711_2200_sin",
         driver="ESRI Shapefile",
         overwrite_layer=TRUE)


# plot(fire_boundary_sin, lwd=100)

```

## NOTE they don't have this cloud layer in their data.

| State | Translated Value | Cloud Condition|
|----|
| 00 | 0 | clear |
| 01 | 1 | cloudy |
| 10 | 2 | mixed |
| 11 | 3 | not set, assumed clear |



```r
# import cloud mask
cloud_mask_7July <- raster("data/week6/modis/reflectance/07_july_2016/crop/cloud_mask_500m.tif")
cloud_mask_7July[cloud_mask_7July > 0] <- NA
plot(cloud_mask_7July)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-multi-band-landsat-data-R/create-apply-mask-1.png" title=" " alt=" " width="100%" />

```r

all_modis_bands_st_mask <- mask(all_modis_bands_st,
                                cloud_mask_7July)

## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st,
        r=1, g =4, b=3,
        stretch="lin")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-multi-band-landsat-data-R/create-apply-mask-2.png" title=" " alt=" " width="100%" />

```r

## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st_mask,
        r=1, g =4, b=3,
        stretch="lin")

fire_bound_sin <- readOGR("data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_sin.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_sin.shp", layer: "co_cold_springs_20160711_2200_sin"
## with 1 features
## It has 21 fields
plot(fire_bound_sin, add=T, col="yellow", lwd=1)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-multi-band-landsat-data-R/create-apply-mask-3.png" title=" " alt=" " width="100%" />



< -0.25
High post-fire regrowth
-0.25 to -0.1
Low post-fire regrowth
-0.1 to +0.1
Unburned
0.1 to 0.27
Low-severity burn
0.27 to 0.44
Moderate-low severity burn
0.44 to 0.66
Moderate-high severity burn
> 0.66
High-severity burn


| SEVERITY LEVEL  | | dNBR RANGE |
|------------------------------|
| Enhanced Regrowth | |-.50 to  -.10  |
| Unburned       |  |-.10 to .10  |
| Low Severity     | |.10 to .27  |
| Moderate Severity  | | .27 to .66  |
| High Severity     |  | > .660 |


# Band 4 includes wavelengths from 0.76-0.90 µm (NIR) and Band 7 includes wavelengths between 2.09-2.35 µm (SWIR).
B4 - b7 / b4 + b7


```r
# calculate modis NBR
modis_nbr <- overlay(all_modis_bands_st_mask[[2]], all_modis_bands_st_mask[[7]],
                     fun=get_veg_index)

# create classification matrix
reclass <- c(cellStats(modis_nbr, min), -.1, 1,
             -.1, .1, 2,
             .1, .27, 3,
             .27, .66, 4,
             .66, cellStats(modis_nbr, max), 5)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

modis_nbr_cl <- reclassify(modis_nbr,
                     reclass_m)
# reclass data
plot(modis_nbr_cl)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-multi-band-landsat-data-R/create-apply-mask2-1.png" title=" " alt=" " width="100%" />

```r

# get summary counts of each class in raster
freq(modis_nbr_cl, useNA='no')
##      value   count
## [1,]    -3       2
## [2,]     1 3125510
## [3,]     2 2059400
## [4,]     3   94041
## [5,]     4     129
## [6,]     5      60
```
