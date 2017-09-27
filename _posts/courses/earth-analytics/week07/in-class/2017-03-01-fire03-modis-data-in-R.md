---
layout: single
title: "Work with MODIS remote sensing data in in R."
excerpt: "In this lesson we will explore how to import and work with MODIS remote sensing data in raster geotiff format in R. We will cover importing many files using regular expressions and cleaning raster stack layer names for nice plotting."
authors: ['Megan Cattau', 'Leah Wasser']
modified: '2017-09-27'
category: [courses]
class-lesson: ['spectral-data-fire-2-r']
permalink: /courses/earth-analytics/week-7/modis-data-in-R/
nav-title: 'MODIS data in R'
week: 7
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
lang-lib:
  r: []
topics:
  remote-sensing: ['modis']
  earth-science: ['fire']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Open MODIS imagery in `R`
* Create NBR index using MODIS imagery in `R`
* Calculate total burned area in `R`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>




First, let's import MODIS data. Below notice that we have used a slightly different
version of the `list.files()` `pattern=` argument.

We have used `glob2rx("*sur_refl*.tif$")` to select all layers that both

1. Contain the word `sur_refl` in them and
2. Contain the extension `.tif`

Let's import our MODIS image stack.


```r
# open modis bands (layers with sur_refl in the name)
all_modis_bands_july7 <-list.files("data/week06/modis/reflectance/07_july_2016/crop",
           pattern=glob2rx("*sur_refl*.tif$"),
           full.names = T)
# create spatial raster stack
all_modis_bands_st_july7 <- stack(all_modis_bands_july7)
## Error in x[[1]]: subscript out of bounds

# view range of values in stack
all_modis_bands_st_july7[[2]]
## Error in eval(expr, envir, enclos): object 'all_modis_bands_st_july7' not found

# view band names
names(all_modis_bands_st_july7)
## Error in eval(expr, envir, enclos): object 'all_modis_bands_st_july7' not found
# clean up the band names for neater plotting
names(all_modis_bands_st_july7) <- gsub("MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b", "Band",
     names(all_modis_bands_st_july7))
## Error in gsub("MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b", : object 'all_modis_bands_st_july7' not found

# view cleaned up band names
names(all_modis_bands_st_july7)
## Error in eval(expr, envir, enclos): object 'all_modis_bands_st_july7' not found
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

The column headings for the table below:

| Group | Science Data Sets (HDF Layers (21)) | Units | Data Type | Fill Value | Valid Range | Scale Factor |
|---|
| | surf_Refl_b01: 500m Surface Reflectance Band 1 (620-670 nm) | Reflectance | 16-bit signed integer | -28672 | -100 - 16000 | 0.0001 |
| | surf_Refl_b02: 500m Surface Reflectance Band 2 (841-876 nm) | Reflectance | 16-bit signed integer  | -28672 | -100 - 16000 | 0.0001 |
| | surf_Refl_b03: 500m Surface Reflectance Band 3 (459-479 nm)| Reflectance | 16-bit signed integer  | -28672 | -100 - 16000 | 0.0001 |
| | surf_Refl_b04: 500m Surface Reflectance Band 4 (545-565 nm)| Reflectance | 16-bit signed integer  | -28672 | -100 - 16000 | 0.0001 |
| | surf_Refl_b05: 500m Surface Reflectance Band 5 (1230-1250 nm)| Reflectance | 16-bit signed integer  | -28672 | -100 - 16000 | 0.0001 |
| | surf_Refl_b06: 500m Surface Reflectance Band 6 (1628-1652 nm) | Reflectance | 16-bit signed integer  | -28672 | -100 - 16000 | 0.0001 |
| | surf_Refl_b07: 500m Surface Reflectance Band 7 (2105-2155 nm) | Reflectance | 16-bit signed integer  | -28672 | -100 - 16000 | 0.0001 |

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/week-7/MOD09GA-metadata.png" target="_blank">
   <img src="{{ site.url }}/images/courses/earth-analytics/week-7/MOD09GA-metadata.png" alt="MODIS MOD09GA metadata"></a>
   <figcaption>Notice the valid values for the MOD09GA reflectance product. The range
   is -100 to 16000.
   </figcaption>
</figure>

Looking at the table, answer the following questions

1. What is valid range of values for our data?
2. What is the scale factor associated with our data?

## Explore our data

Looking at histograms of our data, we can see that the range of values is not
what we'd expect. We'd expect values between -100 to 10000 yet instead we have
much larger numbers.




```r
# turn off scientific notation
options("scipen"=100, "digits"=4)
# bottom, left, top and right
#par(mfrow=c(4, 2))
hist(all_modis_bands_st_july7,
  col = "springgreen",
  xlab = "Reflectance Value")
## Error in hist(all_modis_bands_st_july7, col = "springgreen", xlab = "Reflectance Value"): object 'all_modis_bands_st_july7' not found
mtext("Distribution of MODIS reflectance values for each band\n Data not scaled",
      outer = TRUE, cex = 1.5)
## Error in mtext("Distribution of MODIS reflectance values for each band\n Data not scaled", : plot.new has not been called yet
```



## Scale Factor
Looking at the metadata, we can see that our  data have a scale factor. Let's
deal with that before doing anything else. The scale factor is .0001. This means
we should multiple each layer by that value to get the actual reflectance values
of the data.

We can apply this math to all of the layers in our stack using a simple calculation
shown below:


```r
# deal with nodata value --  -28672
all_modis_bands_st_july7 <- all_modis_bands_st_july7 * .0001
## Error in eval(expr, envir, enclos): object 'all_modis_bands_st_july7' not found
# view histogram of each layer in our stack
# par(mfrow=c(4, 2))
hist(all_modis_bands_st_july7,
   xlab = "Reflectance Value",
   col = "springgreen")
## Error in hist(all_modis_bands_st_july7, xlab = "Reflectance Value", col = "springgreen"): object 'all_modis_bands_st_july7' not found
mtext("Distribution of MODIS reflectance values for each band\n Scale factor applied", outer = TRUE, cex = 1.5)
## Error in mtext("Distribution of MODIS reflectance values for each band\n Scale factor applied", : plot.new has not been called yet
```

Great - now the range of values in our data appear more reasonable. Next, let's
get rid of data that are outside of the valid data range.

## NoData Values

Next, let's deal with no data values. We can see that our data have a "fill" value
of -28672 which we can presume to be missing data. But also we see that valid
range values begin at -100. Let's set all values less than -100 to NA to remove
the extreme negative values that may impact out analysis.





```r
# deal with nodata value --  -28672
all_modis_bands_st_july7[all_modis_bands_st_july7 < -100 ] <- NA
## Error in all_modis_bands_st_july7[all_modis_bands_st_july7 < -100] <- NA: object 'all_modis_bands_st_july7' not found
#par(mfrow=c(4,2))
# plot histogram
hist(all_modis_bands_st_july7,
  xlab = "Reflectance Value",
  col = "springgreen")
## Error in hist(all_modis_bands_st_july7, xlab = "Reflectance Value", col = "springgreen"): object 'all_modis_bands_st_july7' not found
mtext("Distribution of reflectance values for each band", outer = TRUE, cex = 1.5)
## Error in mtext("Distribution of reflectance values for each band", outer = TRUE, : plot.new has not been called yet
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
## Error in ogrListLayers(dsn = dsn): Cannot open data source
## Error in crs(all_modis_bands_st_july7): object 'all_modis_bands_st_july7' not found
```



```
## Error in plotRGB(all_modis_bands_st_july7, r = 1, g = 4, b = 3, stretch = "lin", : object 'all_modis_bands_st_july7' not found
## Error in box(col = "white"): plot.new has not been called yet
## Error in plot(fire_boundary_sin, add = TRUE, border = "yellow", lwd = 50): object 'fire_boundary_sin' not found
```

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

Use the cloud cover layer `data/week06/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m`
to create your mask.

Set all values >0 in the cloud cover layer to `NA`.





```
## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)
## Error in cloud_mask_7July[cloud_mask_7July > 0] <- NA: object 'cloud_mask_7July' not found
## Error in plot(cloud_mask_7July, main = "Landsat cloud mask layer", legend = F, : object 'cloud_mask_7July' not found
## Error in strwidth(legend, units = "user", cex = cex, font = text.font): plot.new has not been called yet
```


```
## Error in mask(all_modis_bands_st_july7, cloud_mask_7July): object 'all_modis_bands_st_july7' not found
```

Plot the masked data. Notice that now the clouds are gone as they have been assigned
the value `NA`.


```
## Error in plotRGB(all_modis_bands_st_mask, r = 1, g = 4, b = 3, stretch = "lin", : object 'all_modis_bands_st_mask' not found
## Error in box(col = "white"): plot.new has not been called yet
## Error in plot(fire_boundary_sin, add = TRUE, col = "yellow", lwd = 1): object 'fire_boundary_sin' not found
```

Finally crop the data to see just the pixels that overlay our study area.


```
## Error in crop(all_modis_bands_st_mask, fire_boundary_sin): object 'all_modis_bands_st_mask' not found
## Error in plotRGB(all_modis_bands_st_mask, r = 1, g = 4, b = 3, stretch = "lin", : object 'all_modis_bands_st_mask' not found
## Error in box(col = "white"): plot.new has not been called yet
## Error in plot(fire_boundary_sin, border = "yellow", add = TRUE): object 'fire_boundary_sin' not found
```


| SEVERITY LEVEL  | NBR RANGE |
|------------------------------|
| Enhanced Regrowth | -700 to  -100  |
| Unburned       |  -100 to +100  |
| Low Severity     | +100 to +270  |
| Moderate Severity  | +270 to +660  |
| High Severity     |  +660 to +1300 |




```
## Error in overlay(all_modis_bands_st_mask[[2]], all_modis_bands_st_mask[[7]], : object 'all_modis_bands_st_mask' not found
## Error in eval(expr, envir, enclos): object 'modis_nbr' not found
## Error in reclassify(modis_nbr, reclass_m): object 'modis_nbr' not found
## Error in plot(modis_nbr_cl, main = "MODIS NBR for the Cold Springs site", : object 'modis_nbr_cl' not found
## Error in plot(fire_boundary_sin, add = TRUE): object 'fire_boundary_sin' not found
## Error in strwidth(legend, units = "user", cex = cex, font = text.font): plot.new has not been called yet
```

After we've calculated NBR, we may want to calculate total burn AREA. We can do
this using the `freq()` function in R. This function gives us the total number
of pixels associated with each value in our classified raster.

1. **Calculate frequency ignoring NA values:** `freq(modis_nbr_cl, useNA='no')`
2. **Calculate frequency, ignore NA & only include values that equal 5:** `freq(modis_nbr_cl, useNA='no', value=5)`

Let's use the MODIS data from 7 July 2016 to calculate the total area of land
classified as:

1. Burn: moderate severity
2. Burn: high severity



```r
# get summary counts of each class in raster
freq(modis_nbr_cl, useNA='no')
## Error in freq(modis_nbr_cl, useNA = "no"): object 'modis_nbr_cl' not found

final_burn_area_high_sev <- freq(modis_nbr_cl, useNA='no', value=5)
## Error in freq(modis_nbr_cl, useNA = "no", value = 5): object 'modis_nbr_cl' not found
final_burn_area_moderate_sev <- freq(modis_nbr_cl, useNA='no', value=4)
## Error in freq(modis_nbr_cl, useNA = "no", value = 4): object 'modis_nbr_cl' not found
```



```
## Error in x[[1]]: subscript out of bounds
## Error in eval(expr, envir, enclos): object 'all_modis_bands_st_july17' not found
## Error in all_modis_bands_st_july17[all_modis_bands_st_july17 < -100] <- NA: object 'all_modis_bands_st_july17' not found
## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)
## Error in cloud_mask_17July[cloud_mask_17July > 0] <- NA: object 'cloud_mask_17July' not found
## Error in mask(all_modis_bands_st_july17, cloud_mask_17July): object 'all_modis_bands_st_july17' not found
```

We can perform the steps that we performed above, on the MODIS post-fire data
too. Below is a plot of the July 17 data.


```r
par(col.axis="white", col.lab="white", tck=0)
# clouds removed
plotRGB(all_modis_bands_st_mask_july17,
        1,4,3,
        stretch="lin",
        main = "Final data plotted with mask\n Post Fire - 17 July 2016",
        axes=T)
## Error in plotRGB(all_modis_bands_st_mask_july17, 1, 4, 3, stretch = "lin", : object 'all_modis_bands_st_mask_july17' not found
box(col = "white")
## Error in box(col = "white"): plot.new has not been called yet
```

Next we calculate NBR on our post fire data. Then we can crop and finally
plot the final results!


```
## Error in overlay(all_modis_bands_st_mask_july17[[2]], all_modis_bands_st_mask_july17[[7]], : object 'all_modis_bands_st_mask_july17' not found
## Error in eval(expr, envir, enclos): object 'modis_nbr_july17' not found
## Error in reclassify(modis_nbr_july17, reclass_m): object 'modis_nbr_july17' not found
## Error in crop(modis_nbr_july17_cl, fire_boundary_sin): object 'modis_nbr_july17_cl' not found
```

## Post fire NBR results



```r
the_colors = c("palevioletred4","palevioletred1","ivory1")
barplot(modis_nbr_july17_cl,
        main = "Distribution of burn values - Post Fire",
        col = rev(the_colors),
        names.arg=c("Low Severity","Moderate Severity","High Severity"))
## Error in barplot(modis_nbr_july17_cl, main = "Distribution of burn values - Post Fire", : object 'modis_nbr_july17_cl' not found
```


Finally, plot the reclassified data. Note that we only have 3 classes: 2, 3 and 4.



```
## Error in plot(modis_nbr_july17_cl, main = "MODIS NBR for the Cold Springs site \n Post fire", : object 'modis_nbr_july17_cl' not found
## Error in plot(fire_boundary_sin, add = TRUE): object 'fire_boundary_sin' not found
## Error in legend(modis_nbr_july17_cl@extent@xmax - 50, modis_nbr_july17_cl@extent@ymax, : object 'modis_nbr_july17_cl' not found
## Error in freq(modis_nbr_july17_cl, useNA = "no", value = 5): object 'modis_nbr_july17_cl' not found
## Error in freq(modis_nbr_july17_cl, useNA = "no", value = 4): object 'modis_nbr_july17_cl' not found
```




