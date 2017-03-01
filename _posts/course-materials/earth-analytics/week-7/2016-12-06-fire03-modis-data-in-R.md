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
all_modis_bands_july7 <-list.files("data/week6/modis/reflectance/07_july_2016/crop",
           pattern=glob2rx("*sur_refl*.tif$"),
           full.names = T)
# create spatial raster stack
all_modis_bands_st_july7 <- stack(all_modis_bands_july7)

# view range of values in stack
str(all_modis_bands_st_july7[[2]])
## Formal class 'RasterLayer' [package "raster"] with 12 slots
##   ..@ file    :Formal class '.RasterFile' [package "raster"] with 13 slots
##   .. .. ..@ name        : chr "/Users/lewa8222/Documents/earth-analytics/data/week6/modis/reflectance/07_july_2016/crop/MOD09GA.A2016189.h09v05.006.2016191073"| __truncated__
##   .. .. ..@ datanotation: chr "INT2S"
##   .. .. ..@ byteorder   : chr "little"
##   .. .. ..@ nodatavalue : num -Inf
##   .. .. ..@ NAchanged   : logi FALSE
##   .. .. ..@ nbands      : int 1
##   .. .. ..@ bandorder   : chr "BIL"
##   .. .. ..@ offset      : int 0
##   .. .. ..@ toptobottom : logi TRUE
##   .. .. ..@ blockrows   : int 1
##   .. .. ..@ blockcols   : int 2400
##   .. .. ..@ driver      : chr "gdal"
##   .. .. ..@ open        : logi FALSE
##   ..@ data    :Formal class '.SingleLayerData' [package "raster"] with 13 slots
##   .. .. ..@ values    : logi(0) 
##   .. .. ..@ offset    : num 0
##   .. .. ..@ gain      : num 1
##   .. .. ..@ inmemory  : logi FALSE
##   .. .. ..@ fromdisk  : logi TRUE
##   .. .. ..@ isfactor  : logi FALSE
##   .. .. ..@ attributes: list()
##   .. .. ..@ haveminmax: logi TRUE
##   .. .. ..@ min       : num -32768
##   .. .. ..@ max       : num 32767
##   .. .. ..@ band      : int 1
##   .. .. ..@ unit      : chr ""
##   .. .. ..@ names     : chr "MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b02_1"
##   ..@ legend  :Formal class '.RasterLegend' [package "raster"] with 5 slots
##   .. .. ..@ type      : chr(0) 
##   .. .. ..@ values    : logi(0) 
##   .. .. ..@ color     : logi(0) 
##   .. .. ..@ names     : logi(0) 
##   .. .. ..@ colortable: logi(0) 
##   ..@ title   : chr(0) 
##   ..@ extent  :Formal class 'Extent' [package "raster"] with 4 slots
##   .. .. ..@ xmin: num -10007555
##   .. .. ..@ xmax: num -8895604
##   .. .. ..@ ymin: num 3335852
##   .. .. ..@ ymax: num 4447802
##   ..@ rotated : logi FALSE
##   ..@ rotation:Formal class '.Rotation' [package "raster"] with 2 slots
##   .. .. ..@ geotrans: num(0) 
##   .. .. ..@ transfun:function ()  
##   ..@ ncols   : int 2400
##   ..@ nrows   : int 2400
##   ..@ crs     :Formal class 'CRS' [package "sp"] with 1 slot
##   .. .. ..@ projargs: chr "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs"
##   ..@ history : list()
##   ..@ z       : list()
```


## Reflectance values range 0-1

As we've discussed in class, the normal range of reflectance values is 0-1 where
1 is the BRIGHTEST values and 0 is the darkest value. Have a close look at the 
min and max values in the second raster layer of our stack, above. What do you notice?

The min and max values are widely outside of the expected range of 0-1  - min: -32768, max: 32767
What could be causing this? We need to better understand our data before we can 
work with it more. Have a look at the table in the MODIS users guide. The data 
that we are working with is the MOD09GA product. Look closely at the table on 
page 14 of the guide. Part of the table can be seen below. 

<a href="http://modis-sr.ltdri.org/guide/MOD09_UserGuide_v1_3.pdf" target="_blank">Click here to check out the MODIS user guide - check out page 14 for the MOD09GA table.</a>

<figure>
<a href="{{ site.url }}/images/course-materials/earth-analytics/week-7/MOD09GA-metadata.png" target="_blank">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-7/MOD09GA-metadata.png
" alt="MODIS MOD09GA metadata"></a>
   <figcaption>Notice the valid values for the MOD09GA reflectance product. The range
   is -100 to 10000.
   </figcaption>
</figure>

Looking at the table, answer the following questions

1. What is valid range of values for our data?
2. What is the scale factor associated with our data?

## NoData Values

Let's first deal with no data values. we can see that our data have a "fill" value
of -28672 which we can presume to be missing data. But also we see that valid 
range values begin at -100. Let's set all values less than -100 to NA to remove
the extreme negative values that may impact out analysis. 


```r
# deal with nodata value --  -28672 
all_modis_bands_st_july7[all_modis_bands_st_july7 < -100 ] <- NA
# options("scipen"=100, "digits"=4)
plot(all_modis_bands_st_july7[[2]])
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/assign-no-data-1.png" title=" " alt=" " width="100%" />

After assigning our No data values to NA


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




<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/plot-modis-layers-1.png" title="plot MODIS stack" alt="plot MODIS stack" width="100%" />

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


<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/create-apply-mask-1.png" title="cloud mask plot" alt="cloud mask plot" width="100%" />


```r
all_modis_bands_st_mask <- mask(all_modis_bands_st_july7,
                                cloud_mask_7July)

## 3 = blue, 4 = green, 1= red 2= nir
```

Plot the masked data. Notice that now the clouds are gone as they have been assigned
the value `NA`.

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/masked-data-1.png" title="MODIS with cloud mask" alt="MODIS with cloud mask" width="100%" />

Finally crop the data to see just the pixels that overlay our study area.

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/crop-data-1.png" title="cropped data" alt="cropped data" width="100%" />


| SEVERITY LEVEL  | NBR RANGE |
|------------------------------|
| Enhanced Regrowth | -700 to  -100  |
| Unburned       |  -100 to +100  |
| Low Severity     | +100 to +270  |
| Moderate Severity  | +270 to +660  |
| High Severity     |  +660 to +1300 |



<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/create-apply-mask2-1.png" title=" " alt=" " width="100%" />

After we've calculated NBR, we may want to calculate total burn AREA. We can do 
this using the `freq()` function in R. This function gives us the total number
of pixels associated with each value in our classified raster. 

Calculate frequency - ignoring NA values: freq(modis_nbr_cl, useNA='no')
Calculate frequency, ignore NA & only could values == 5 (freq(modis_nbr_cl, useNA='no', value=5)


```r
# get summary counts of each class in raster
freq(modis_nbr_cl, useNA='no')
##      value count
## [1,]     4    24

final_burn_area_high_sev <- freq(modis_nbr_cl, useNA='no', value=5)
final_burn_area_moderate_sev <- freq(modis_nbr_cl, useNA='no', value=4)
```

Using MODIS data from 7 July 2016 - calculate the total area of land classified as:

1. Burn: moderate severity 
2. Burn: high severity  




```r
# clouds removed 
plotRGB(all_modis_bands_st_mask_july17, 
        1,4,3,
        stretch="lin",
        main="Final data with mask")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/plot-rgb-post-fire-1.png" title="RGB post fire" alt="RGB post fire" width="100%" />

Next we calculate NBR on our post fire data. Then we can crop and finally
plot the final results!



## Post fire NBR results
Don't use these colors! :)


```r
the_colors = c("palevioletred4","palevioletred1","ivory1")
barplot(modis_nbr_july17_cl,
        main="Distribution of burn values",
        col=rev(the_colors),
        names.arg=c("Low Severity","Moderate Severity","High Severity"))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/view-barplot-1.png" title="barplot of final post fire classified data." alt="barplot of final post fire classified data." width="100%" />


Finally, plot the reclassified data. Note that we only have 3 classes: 2, 3 and 4. 


<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-7/2016-12-06-fire03-modis-data-in-R/plot-data-reclass-1.png" title=" " alt=" " width="100%" />





