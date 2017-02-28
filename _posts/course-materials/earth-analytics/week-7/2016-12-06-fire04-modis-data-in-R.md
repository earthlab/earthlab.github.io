---
layout: single
title: "MODIS data in in R."
excerpt: "In this lesson we will explore working with MODIS data in R. "
authors: ['Megan Cattau', 'Leah Wasser']
modified: '2017-02-28'
category: [course-materials]
class-lesson: ['spectral-data-fire-2-r']
permalink: /course-materials/earth-analytics/week-7/modis-data-in-R/
nav-title: 'MODIS data in R'
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

* Open MODIS imagery in R
* Create NBR index using MODIS imagery in R
* Calculate total burned area in R.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>




First, let's import MODIS data. Below notice that we have used a slightly different
version of the list.files() pattern argument. 

We have used `glob2rx("*sur_refl*.tif$")` to select all layers that both

1. have the word `sur_refl` in them and 
2. contain the extention `.tif`

Let's import our MODIS layer. 


```r
# open modis bands (layers with sur_refl in the name)
all_modis_bands <-list.files("data/week6/modis/reflectance/07_july_2016/crop",
           pattern=glob2rx("*sur_refl*.tif$"),
           full.names = T)

all_modis_bands_st <- stack(all_modis_bands)
```

Next we plot MODIS layers. Use the MODIS band chart to figure out what bands you
need to plot to create a RGB (true color) image. 

| Band | Wavelength range (nm) | Spatial Resolution (m) | Spectral Width (nm)|
|-------------------------------------|------------------|--------------------|----------------|
| Band 1 - red | 620 - 670 | 250 | 2.0 |
| Band 2 - near infrared | 841 - 876 | 250 | 6.0 |
| Band 3 -  blue/green | 459 - 479 | 500 | 6.0 |
| Band 4 - green | 545 - 565 | 500 | 3.0 |
| Band 5 - near infrared  | 1230 – 1250 | 500 | 8.0  |
| Band 6 - mid-infrared | 1628 – 1652 | 500 | 18 |
| Band 7 - mid-infrared | 2105 - 2155 | 500 | 18 |

In the plot below, i've called attention to the AOI boundary with a yellow color.
Why is it so hard to figure out where the study area is in this MODIS image?


```
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week6/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp", layer: "co_cold_springs_20160711_2200_dd83"
## with 1 features
## It has 21 fields
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire04-modis-data-in-R/plot-modis-layers-1.png" title=" " alt=" " width="100%" />

## MODIS cloud mask

Next, we can deal with clouds in the same way that we dealt with them using 
Landsat data. However, our cloud mask in this case is slightly different with 
slightly different cloud cover values as follows:
 
| State | Translated Value | Cloud Condition|
|----|
| 00 | 0 | clear |
| 01 | 1 | cloudy |
| 10 | 2 | mixed |
| 11 | 3 | not set, assumed clear |

The metadata for the MODIS data are a bit trickier to figure out. If you are interested,
the link to the MODIS user guide is below. 

* <a href="http://modis-sr.ltdri.org/guide/MOD09_UserGuide_v1_3.pdf" target="_blank">MODIS user guide</a>

The MODIS data are also stored natively in a H4 format which we will not be discussing 
in this class. For the purposes of this assignment, use the table above to assign 
cloud cover "values" and to create a mask.

Use the cloud cover layer `data/week6/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m` 
to create your mask.

Set all values >0 to `NA`.


<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire04-modis-data-in-R/create-apply-mask-1.png" title=" " alt=" " width="100%" />


```r
all_modis_bands_st_mask <- mask(all_modis_bands_st,
                                cloud_mask_7July)

## 3 = blue, 4 = green, 1= red 2= nir
plotRGB(all_modis_bands_st,
        r=1, g =4, b=3,
        stretch="lin")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire04-modis-data-in-R/create-mask-1.png" title=" " alt=" " width="100%" />

Plot the masked data.

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire04-modis-data-in-R/masked-data-1.png" title=" " alt=" " width="100%" />

```
## Error in plot(fire_bound_sin, add = T, col = "yellow", lwd = 1): object 'fire_bound_sin' not found
```

Finally crop the data to see just the pixels that overlay our study area.


```
## Error in .local(x, y, ...): Cannot get an Extent object from argument y
## Error in extent(fire_bound_sin): object 'fire_bound_sin' not found
## Error in plot(fire_bound_sin, border = "yellow", add = T): object 'fire_bound_sin' not found
```


| SEVERITY LEVEL  | NBR RANGE |
|------------------------------|
| Enhanced Regrowth | -700 to  -100  |
| Unburned       |  -100 to +100  |
| Low Severity     | +100 to +270  |
| Moderate Severity  | +270 to +660  |
| High Severity     |  +660 to +1300 |



<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire04-modis-data-in-R/create-apply-mask2-1.png" title=" " alt=" " width="100%" />

After we've calculated NBR, we may want to calculate total burn AREA. We can do 
this using the `freq()` function in R. This function gives us the total number
of pixels associated with each value in our classified raster. 

Calculate frequency - ignoring NA values: freq(modis_nbr_cl, useNA='no')
Calculate frequency, ignore NA & only could values == 5 (freq(modis_nbr_cl, useNA='no', value=5)


```r
# get summary counts of each class in raster
freq(modis_nbr_cl, useNA='no')
##       value   count
## [1,] -14333       1
## [2,]      1   94290
## [3,]      2 2059575
## [4,]      3 1415999
## [5,]      4 1569852
## [6,]      5  139425

final_burn_area <- freq(modis_nbr_cl, useNA='no', value=5)
```

What is the final area of high severity burn according to MODIS??

