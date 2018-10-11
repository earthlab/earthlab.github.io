---
layout: single
title: "Work with MODIS Remote Sensing Data in Python"
excerpt: "In this lesson you will explore how to import and work with MODIS remote sensing data in raster geotiff format in R. You will cover importing many files using regular expressions and cleaning raster stack layer names for nice plotting."
authors: ['Megan Cattau', 'Leah Wasser']
modified: 2018-09-26
category: [courses]
class-lesson: ['modis-multispectral-rs-python']
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/use-modis-remote-sensing-data-in-python/
nav-title: 'MODIS Data in Python'
week: 8
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 6
lang-lib:
  r: []
topics:
  remote-sensing: ['modis']
  earth-science: ['fire']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics/week-7/modis-data-in-R/"
---




{:.input}
```python
```{r setup, include=FALSE}

knitr::opts_chunk$set(echo = TRUE, message = FALSE)

```

```



{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">



## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives



After completing this tutorial, you will be able to:



* Open MODIS imagery in `R`.

* Create NBR index using MODIS imagery in `R`.

* Calculate total burned area in `R`.



## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need



You will need a computer with internet access to complete this lesson and the

data for week 6 of the course.



{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>






{:.input}
```python
```{r load-libraries, echo=F, results='hide', message=F, warning=F}

library(raster)

library(rgeos)

library(rgdal)

library(dplyr)

options(stringsAsFactors = FALSE)

# import vector that you used to crop the data

# csf_crop <- readOGR("data/cold-springs-fire/vector_layers/fire_crop_box_500m.shp")



```

```



First, let's import MODIS data. Below notice that you have used a slightly different

version of the `list.files()` `pattern = ` argument.



You have used `glob2rx("*sur_refl*.tif$")` to select all layers that both



1. Contain the word `sur_refl` in them and

2. Contain the extension `.tif`



Let's import our MODIS image stack.




{:.input}
```python
```{r work-with-modis}

# open modis bands (layers with sur_refl in the name)

all_modis_bands_july7 <- list.files("data/week_07/modis/reflectance/07_july_2016/crop",

           pattern = glob2rx("*sur_refl*.tif$"),

           full.names = TRUE)

# create spatial raster stack

all_modis_bands_pre_st <- stack(all_modis_bands_july7)

all_modis_bands_pre_br <- brick(all_modis_bands_pre_st)



# view range of values in stack

all_modis_bands_pre_br[[2]]



# view band names

names(all_modis_bands_pre_br)



# clean up the band names for neater plotting

names(all_modis_bands_pre_br) <- gsub("MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b", "Band",

     names(all_modis_bands_pre_br))



# view cleaned up band names

names(all_modis_bands_pre_br)

```

```





## Reflectance Values Range 0-1



As you've learned in class, the normal range of reflectance values is 0-1 where

1 is the BRIGHTEST values and 0 is the darkest value. Have a close look at the

min and max values in the second raster layer of our stack, above. What do you notice?



The min and max values are widely outside of the expected range of 0-1  - min: -32768, max: 32767

What could be causing this? You need to better understand our data before you can

work with it more. Have a look at the table in the MODIS users guide. The data

that you are working with is the MOD09GA product. Look closely at the table on

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

<a href="{{ site.url }}/images/courses/earth-analytics/raster-data/MOD09GA-metadata.png" target="_blank">

   <img src="{{ site.url }}/images/courses/earth-analytics/raster-data/MOD09GA-metadata.png" alt="MODIS MOD09GA metadata"></a>

   <figcaption>Notice the valid values for the MOD09GA reflectance product. The range

   is -100 to 16000.

   </figcaption>

</figure>



Looking at the table, answer the following questions



1. What is valid range of values for our data?

2. What is the scale factor associated with our data?



## Explore Our Data



Looking at histograms of our data, you can see that the range of values is not

what we'd expect. We'd expect values between -100 to 10000 yet instead you have

much larger numbers.






{:.input}
```python
```{r explore-data, warning=FALSE, message=FALSE, fig.cap="MODIS stack band 2 plot"}

# turn off scientific notation

options("scipen" = 100, "digits" = 4)

# bottom, left, top and right

#par(mfrow=c(4, 2))

hist(all_modis_bands_pre_br,

  col = "springgreen",

  xlab = "Reflectance Value")

mtext("Distribution of MODIS reflectance values for each band\n Data not scaled",

      outer = TRUE, cex = 1.5)



```

```




{:.input}
```python
```{r echo = FALSE, results='hide'}

dev.off()

```

```



## Scale Factor

Looking at the metadata, you can see that our  data have a scale factor. Let's

deal with that before doing anything else. The scale factor is .0001. This means

you should multiple each layer by that value to get the actual reflectance values

of the data.



You can apply this math to all of the layers in our stack using a simple calculation

shown below:




{:.input}
```python
```{r scale-data, fig.cap="MODIS stack histogram plot", fig.width=7, fig.height=8}

# deal with nodata value --  -28672

all_modis_bands_pre_br <- all_modis_bands_pre_br * .0001

# view histogram of each layer in our stack

# par(mfrow=c(4, 2))

hist(all_modis_bands_pre_br,

   xlab = "Reflectance Value",

   col = "springgreen")

mtext("Distribution of MODIS reflectance values for each band\n Scale factor applied", outer = TRUE, cex = 1.5)

```

```



Great - now the range of values in our data appear more reasonable. Next, let's

get rid of data that are outside of the valid data range.



## NoData Values



Next, let's deal with no data values. You can see that our data have a "fill" value

of -28672 which you can presume to be missing data. But also you see that valid

range values begin at -100. Let's set all values less than -100 to NA to remove

the extreme negative values that may impact out analysis.




{:.input}
```python
```{r echo=F, results='hide'}

dev.off()

```

```






{:.input}
```python
```{r assign-no-data, fig.cap="MODIS stack histogram plot with NA removed"}

# deal with nodata value --  -28672

all_modis_bands_pre_br[all_modis_bands_pre_br < -100 ] <- NA

#par(mfrow=c(4,2))

# plot histogram

hist(all_modis_bands_pre_br,

  xlab = "Reflectance Value",

  col = "springgreen")

mtext("Distribution of reflectance values for each band", outer = TRUE, cex = 1.5)

```

```




{:.input}
```python
```{r echo=F, results='hide'}

dev.off()

```

```



Next you plot MODIS layers. Use the MODIS band chart to figure out what bands you

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




{:.input}
```python
```{r import-shapefile, results='hide', echo=F}

# view fire overlay boundary

fire_boundary <- readOGR("data/cold-springs-fire/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")

fire_boundary_sin <- spTransform(fire_boundary,

                                 CRS = crs(all_modis_bands_pre_br))

# export as sinusoidal

# writeOGR(fire_boundary_sin,

#          dsn = "data/cold-springs-fire/vector_layers/fire-boundary-geomac",

#          layer="co_cold_springs_20160711_2200_sin",

#          driver="ESRI Shapefile",

#          overwrite_layer=TRUE)

```

```






{:.input}
```python
```{r plot-modis-layers, echo=F, fig.cap="plot MODIS stack", fig.width=5, fig.height=5}

## 3 = blue, 4 = green, 1= red 2= nir

par(col.axis = "white", col.lab = "white", tck = 0)

plotRGB(all_modis_bands_pre_br,

        r = 1, g = 4, b = 3,

        stretch = "lin",

        main = "MODIS post-fire RGB image\n Cold springs fire site",

        axes = TRUE)

box(col = "white")

# add fire boundary to plot

plot(fire_boundary_sin,

     add = TRUE,

     border = "yellow",

     lwd = 50)



```

```



## MODIS Cloud Mask



Next, you can deal with clouds in the same way that you dealt with them using

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



The MODIS data are also stored natively in a H4 format which you will not be discussing

in this class. For the purposes of this assignment, use the table above to assign

cloud cover "values" and to create a mask.



Use the cloud cover layer `data/week_07/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m`

to create your mask.



Set all values >0 in the cloud cover layer to `NA`.




{:.input}
```python
```{r reset-dev, warning=F, echo=F, message=F, results='hide'}

dev.off()

```

```






{:.input}
```python
```{r create-apply-mask, echo=F, fig.cap="cloud mask plot"}

# import cloud mask

cloud_mask_7July <- raster("data/week_07/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m.tif")

cloud_mask_7July[cloud_mask_7July > 0] <- NA

plot(cloud_mask_7July,

     main = "Landsat cloud mask layer",

     legend = FALSE,

     axes = FALSE, box = FALSE)

legend("topright",

       legend = c("Cloud free", "Clouds"),

       fill = c("yellow", "white"))

```

```




{:.input}
```python
```{r create-mask, fig.cap="Final stack masked", echo=F}

all_modis_bands_st_mask <- mask(all_modis_bands_pre_br,

                                cloud_mask_7July)



## 3 = blue, 4 = green, 1= red 2= nir

```

```



Plot the masked data. Notice that now the clouds are gone as they have been assigned

the value `NA`.




{:.input}
```python
```{r masked-data, echo=F, fig.cap="MODIS with cloud mask", fig.width=7, fig.height=4}

## 3 = blue, 4 = green, 1= red 2= nir

par(col.axis = "white", col.lab = "white", tck = 0)

plotRGB(all_modis_bands_st_mask,

        r = 1, g = 4, b = 3,

        stretch = "lin",

        main = "MODIS data mask applied\n Cold springs fire AOI",

        axes = TRUE)

box(col = "white")

plot(fire_boundary_sin,

     add = TRUE, col = "yellow",

     lwd = 1)

```

```



Finally crop the data to view just the pixels that overlay the Cold Springs fire

study area.




{:.input}
```python
```{r crop-data, echo=F, fig.cap="cropped data"}

all_modis_bands_st_mask <- crop(all_modis_bands_st_mask, fire_boundary_sin)

par(col.axis = "white", col.lab = "white", tck = 0)

plotRGB(all_modis_bands_st_mask,

        r = 1, g = 4, b = 3,

        stretch = "lin",

        ext = extent(fire_boundary_sin),

        axes = TRUE,

        main = "Final MODIS masked data \n Cold Springs fire scar site")

box(col = "white")

plot(fire_boundary_sin, border = "yellow", add = TRUE)



```

```





## Calculate dNBR With MODIS



Once we have the data cleaned up with cloudy pixels set to NA and the scale

factor applied, we are ready to calculate dNBR or whatever other vegetation index

that you'd like to calculate.



1. Figure out what bands you need to use to calculate dNBR with MODIS.

2. Calculate NBR with pre and post fire modis data

3. Subtract post from pre fire NBRto get the dNBR value

4. Classify the data using the dNBR classification matrix.

5. Calculate summary stats of area burned using MODIS



### MODIS Bands



The table below shows the band ranges for the MODIS sensor. You know that the

NBR index will work with any multispectral sensor with a NIR

band between 760 - 900 nm and a SWIR band between 2080 - 2350 nm.

What bands should you use to calculate NBR using MODIS?



| Band | Wavelength range (nm) | Spatial Resolution (m) | Spectral Width (nm)|

|-------------------------------------|------------------|--------------------|----------------|

| Band 1 - red | 620 - 670 | 250 | 2.0 |

| Band 2 - near infrared | 841 - 876 | 250 | 6.0 |

| Band 3 -  blue/green | 459 - 479 | 500 | 6.0 |

| Band 4 - green | 545 - 565 | 500 | 3.0 |

| Band 5 - near infrared  | 1230 – 1250 | 500 | 8.0  |

| Band 6 - mid-infrared | 1628 – 1652 | 500 | 18 |

| Band 7 - mid-infrared | 2105 - 2155 | 500 | 18 |



## Extracting Summary Stats



Similar to what you did with Landsat data, you can then use `extract()` to

select just pixels that are in the burn area and summarize by pixel

classified value




{:.input}
```python
```{r open-fire-boundary, echo = FALSE, results = 'hide'}

# open fire boundary

fire_boundary <- readOGR("data/cold-springs-fire/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp")



# source functions

source('ea-course-functions.R')



fire_severity_classes <- c("High Severity", "Moderate Severity",  "Low Severity",  "Unburned", "Enhanced Regrowth")



# create classification matrix

nbr_reclass <- c(-Inf, -.1, 1,

             -.1, .1, 2,

             .1, .27, 3,

             .27, .66, 4,

             .66, Inf , 5)



# reshape the object into a matrix with columns and rows

nbr_reclass <- matrix(nbr_reclass,

                ncol = 3,

                byrow = TRUE)

```

```






{:.input}
```python
```{r load-modis-data, echo = FALSE}



# source functions

source('ea-course-functions.R')



## Open MODIS pre data



# open modis bands (layers with sur_refl in the name)

all_modis_bands_pre <- list.files("data/week_07/modis/reflectance/07_july_2016/crop",

           pattern = glob2rx("*sur_refl*.tif$"),

           full.names = TRUE)



# create spatial raster stack

modis_bands_pre_st <- stack(all_modis_bands_pre)



# transform the boundary

fire_boundary_sin <- spTransform(fire_boundary,

                                 CRS = crs(modis_bands_pre_st))

#modis_bands_pre_st <- crop(modis_bands_pre_st, fire_boundary_sin)

modis_bands_pre_br <- brick(modis_bands_pre_st)



# scale the data deal with nodata value --  -28672

modis_bands_pre_br <- modis_bands_pre_br * .0001



# account for nodata value --  -28672

modis_bands_pre_br[modis_bands_pre_br < -100 ] <- NA



# import cloud mask

cloud_mask_7July <- raster("data/week_07/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m.tif")

#cloud_mask_7July <- crop(cloud_mask_7July, fire_boundary_sin)

cloud_mask_7July[cloud_mask_7July > 0] <- NA



# apply cloud mask

modis_bands_pre_br <- mask(modis_bands_pre_br,

                                cloud_mask_7July)



# crop to the MODIS data

modis_bands_pre_br <- crop(modis_bands_pre_br, fire_boundary_sin)



# calculate modis NBR

modis_nbr_pre <- overlay(modis_bands_pre_br[[7]], modis_bands_pre_br[[2]],

                     fun = normalized_diff)



# this is a test to ensure nbr is calculating properly - this code should not be

# plotted in student output

# plot(modis_nbr_pre)

# plot(fire_boundary_sin, add = TRUE)



```

```




{:.input}
```python
```{r post-fire-modis, echo = FALSE }

##### Get post fire layers

# open modis bands (layers with sur_refl in the name)

modis_bands_post <- list.files("data/week_07/modis/reflectance/17_july_2016/crop",

           pattern = glob2rx("*sur_refl*.tif$"),

           full.names = TRUE)



modis_bands_post_st <- stack(modis_bands_post)

#modis_bands_post_st <- crop(modis_bands_post_st, fire_boundary_sin)



modis_bands_post_br <- brick(modis_bands_post_st)



# rescale data

modis_bands_post_br <- modis_bands_post_br * .0001



# deal with nodata value --  -28672

modis_bands_post_br[modis_bands_post_br < -100] <- NA



# import cloud mask & mask data

cloud_mask_17July <- raster("data/week_07/modis/reflectance/17_july_2016/crop/cloud_mask_july17_500m.tif")

#cloud_mask_17July <- crop(cloud_mask_17July, fire_boundary_sin)

cloud_mask_17July[cloud_mask_17July > 0] <- NA

modis_bands_post_br <- mask(modis_bands_post_br,

                                cloud_mask_17July)



# calculate NBR

# crop to the MODIS data

modis_bands_post_br <- crop(modis_bands_post_br, fire_boundary_sin)



# calculate modis NBR

modis_nbr_post <- overlay(modis_bands_post_br[[7]], modis_bands_post_br[[2]],

                     fun = normalized_diff)





# this is a test to ensure nbr is calculating properly - this code should not be

# plotted in student output

# plot(modis_nbr_post)

# plot(fire_boundary_sin, add = TRUE)



```

```






{:.input}
```python
```{r diff-nbr-modis, echo = FALSE, fig.cap = "dnbr plotted using MODIS data for the Cold Springs fire."}

# calculate dNBR

modis_dnbr <- modis_nbr_pre - modis_nbr_post



# classify data

# classify data

dnbr_modis_classified <- reclassify(modis_dnbr,

                     nbr_reclass)



# define color ramp

dnbr_colors <- rev(brewer.pal(5, 'RdYlGn'))

# mar bottom, left, top and right

par(mar = c(0, 0, 2, 5))

plot(dnbr_modis_classified,

     col = dnbr_colors,

     legend = FALSE,

     axes = FALSE,

     box = FALSE,

     main = "MODIS dNBR - Cold Spring fire site \n Add comparison dates here")

plot(fire_boundary_sin, add = TRUE,

     lwd = 5)

legend(dnbr_modis_classified@extent@xmax - 100, dnbr_modis_classified@extent@ymax,

       legend = c(fire_severity_classes, "Fire boundary"),

       col =  "black",

       pt.bg = rev(dnbr_colors),

       pch = c(22, 22, 22, 22, 22, NA),

       lty = c(NA, NA, NA, NA, NA, 1),

       cex = .8,

       bty = "n",

       pt.cex = c(1.75),

       xpd = TRUE)

```

```





Finally calculate summary stats of how many pixels fall into each severity class

like you did for the landsat data.




{:.input}
```python
```{r, echo = FALSE}

modis_resolution_here <- 500

```

```






{:.input}
```python
```{r summarize-burn-area, eval = 'FALSE', results = 'hide'}

MODIS_pixels_in_fire_boundary <- extract(dnbr_modis_classified, fire_boundary_sin,

                                           df = TRUE)



MODIS_pixels_in_fire_boundary %>%

  group_by(layer) %>%

  summarize(count = n(), area_meters = (n() * (modis_resolution_here * modis_resolution_here)))



```

```
