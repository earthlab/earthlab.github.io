---
layout: single
category: courses
title: "MODIS data in R - fire remote sensing"
permalink: /courses/earth-analytics/spectral-remote-sensing-modis/
modified: '2017-10-19'
week-landing: 8
week: 8
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics"
module-type: 'session'
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! This week we will dive deeper
into working with remote sensing data surrounding the Cold Springs fire. Specifically,
we will learn how to

* Download data from Earth Explorer
* Deal with cloud shadows and cloud coverage
* Deal with scale factors and no data values

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}

</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 9:30 - 10:15  | Questions |   |
| 9:40 - 10:20  | ASD Fieldspec Demo - Mini Class Fieldtrip! | Bogdan Lita  |
| 10:30 - 11:00  | Handling clouds in Remote Sensing Data & Using Cloud Masks in `R`  |    |
| 11:15 - 11:45  | Group activity: Get data from Earth Explorer |    |
|===
| 11:45 - 12:20  | MODIS data in R - NA values & scale factors - Coding  Session |    |


### 1a. Remote sensing readings

### 1b. Fire Readings

Please read the articles below to prepare for next week's class.

* <a href="http://www.denverpost.com/2016/07/13/cold-springs-fire-wednesday/" target="_blank">Denver Post article on the Cold Springs fire.</a>
* <a href="http://www.nature.com/nature/journal/v421/n6926/full/nature01437.html" target="_blank" data-proofer-ignore=''>Fire science for rainforests -  Cochrane 2003.</a>
* <a href="https://www.webpages.uidaho.edu/for570/Readings/2006_Lentile_et_al.pdf
" target="_blank">A review of ways to use remote sensing to assess fire and post-fire effects - Lentile et al 2006.</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0034425710001100" target="_blank"> Comparison of dNBR vs RdNBR accuracy / introduction to fire indices -  Soverel et al 2010.</a>

### 2. Complete the assignment below (15 points)
Please note that like the flood report, this assignment is worth more points than
a usual weekly assignment. You have 2 weeks to complete this assignment. Start
early!

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a report

Create a new `R markdown `document. Name it: **lastName-firstInitial-weeknumber.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `html` format. Submit both the
`.Rmd` file and the `.html` file. Be sure to name your files as instructed above.

#### Use knitr code chunk arguments
In your final report, use the following knitr code chunk arguments to hide messages
and warnings and code as you see fit.

* `message = FALSE`, `warning = FALSE` Hide warnings and messages in a code chunk
* `echo = FALSE` Hide code and just show code output
* `results='hide'` Hide the verbose output from some functions like `readOGR()`.

#### Answer the following questions below in your report

1. What is the spatial resolution of NAIP, Landsat & MODIS data in meters?
   * How can differences in spatial resolution in the data that you are using impact analysis results?
   * Refer to plot 1 below as you answer your question and the compared differences 
   in total burned area between MODIS and Landsat
2. Calculate the area of "high severity" and the area of "moderate severity" burn in meters using the post-fire data for both Landsat and MODIS. State what the area in meters is for each data type (Landsat and MODIS) in your answer. Are the area values different calculated from MODIS vs Landsat? Why / why not? Use plots 4 and 5 to discuss any differences you notice.
3. Describe 3 potential impacts of cloud cover on remote sensing imagery analysis. What are 2 ways that we can deal with clouds when we encounter them in our work? Refer to plots 2 & 3 in your homework to answer this question.

#### Include the plots below.

For all plots:

1. Be sure to describe what each plot shows in your final report using a figure
caption argument in your code chunks: `fig.cap="caption here`.
2. Add appropriate titles that tells someone reading your report what the map shows
3. Use clear legends as appropriate - especially for the classified data plots!


#### Plot 1 - Grid of plots: NAIP, Landsat and MODIS

Use the `plotRGB()` function to create color infrared (also called false color)
image using:

1. NAIP data
2. Landsat data and
3. MODIS data

 **in one figure** collected **pre-fire**.

 For each map be sure to:

* Overlay the fire boundary layer (`vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`)
* Use the band combination r = infrared band, g= green band, b=blue band. You can use `mfrow=c(rows, columns)`
* Render the map to the extent of the fire boundary layer using the `ext=extent()` plot argument.
* Be sure to label each plot with the data type (NAIP vs. Landsat vs. MODIS) and spatial resolution.

Use this figure to help answer question 1 above.
An example of what this plot should look like (without all of the labels that
you need to add), [is here at the bottom of the page.]({{ site.url }}/courses/earth-analytics/multispectral-remote-sensing-modis/grid-of-plots-report/)

#### Plot 2 - Difference NBR (dNBR) using Landsat data

Create a map of the classified dNBR using Landsat data collected before and
after the Cold Springs fire. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the NBR map. Add a legend that clearly describes each burn "class"
that you applied using the table provided in the lessons.

Be sure to use cloud free data.

#### Plot 3 - Difference NBR (dNBR) using MODIS data

Create a map of the classified dNBR using MODIS data collected before and
after the Cold Springs fire. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the NBR map. Add a legend that clearly describes each burn "class"
that you applied using the table provided in the lessons.

Be sure to use cloud free data.

dNBR burn classes

Note that depending on how you scaled your data, you may need to scale the
values below by a factor of 10.

| SEVERITY LEVEL  | dNBR RANGE |
|------------------------------|
| Enhanced Regrowth | <= -100  |
| Unburned       |  -100 to +100  |
| Low Severity     | +100 to +270  |
| Moderate Severity  | +270 to +660  |
| High Severity     |  >= 660|

****

#### Plot 5 - Difference NDVI Landsat data

Create a map of the the difference in NDVI - pre vs post fire. Classify the change
in NDVI as you see fit. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the difference NDVI map. Add a legend that clearly describes each
NDVI difference "class".

Be sure to use cloud free NDVI data.

#### Plot 6 - Difference NDVI MODIS data

Create a map of the the difference in NDVI - pre vs post fire. Classify the change
in NDVI as you see fit. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the difference NDVI map. Add a legend that clearly describes each
NDVI difference "class".

Be sure to use cloud free NDVI data.

## Homework due: Friday March 10, 2017 @ NOON.
Submit your report in both `.Rmd` and `.html` format to the D2l dropbox.

</div>

## Grading


#### .Pdf Report structure & code: 10%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| PDF and RMD submitted |  | Only one of the 2 files are submitted  | | No files submitted |
| Code is written using "clean" code practices following the Hadley Wickham style guide| Spaces are placed after all # comment tags, variable names do not use periods, or function names. | Clean coding is used in some of the code but spaces or variable names are incorrect 2-4 times| | Clean coding is not implemented consistently throughout the report. |
| Code chunk contains code and runs  | All code runs in the document  | There are 1-2 errors in the code in the document that make it not run | | The are more than 3 code errors in the document |
| All required R packages are listed at the top of the document in a code chunk.  | | Some packages are listed at the top of the document and some are lower down. | | |
| Lines of code are broken up at commas to make the code more readable  | |  | | |


####  Knitr pdf output: 10%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Code chunk arguments are used to hide warnings |  |  | | |
| Code chunk arguments are used to hide code and just show output |  | | |  |
| PDf report emphasizes the write up and the code outputs rather than showing each step of the code |  | | |  |

####  Report questions: 40%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| 1. What is the spatial resolution for NAIP, Landsat & MODIS data in meters? |  |  | | |
| 1. Are these data types different in terms of resolution? |  |  | | |
| 1. How could this resolution difference impact analysis using these data? Use plot 1 BELOW to visually show the difference. |  |  | | |
| 2. Calculate the area of “high severity” and the area of “moderate severity” burn in meters using the post-fire data for both Landsat and MODIS. State what the area in meters is for each data type (Landsat and MODIS) in your answer.|  |  | | |
| 2. Are the values different? Why / why not? Use plots 4 and 5 to discuss any differences you notice.|  |  | | |
| 3. Describe 3 potential impacts of cloud cover on remote sensing imagery analysis. What are 2 ways that we can deal with clouds when we encounter them in our work? Refer to plot 2 in your homework to answer this question.|||||
| 3. What are 2 ways that we can deal with clouds when we encounter them in our work? Refer to plot 2 in your homework to answer this question.|||||


### Plots are worth 40% of the assignment grade

#### Plot 1 - Grid of NAIP, Landsat and MODIS

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| All three plots are correct (color infrared with NIR light on the red band.) |  |  | | |
| Plots are stacked vertically (or horizontally) and render properly on the pdf. |  |  | | |
| Plot contains a meaningful title. |  |  | | |
| Plot has a 2-3 sentence figure caption that clearly describes plot contents. |  |  | | |

#### Plot 2 - Pre-fire NBR using landsat data

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| A new landsat image has been downloaded to use for this plot. |  |  | | |
| The landsat image is largely (< 20% clouds) cloud free over the study area. |  |  | | |
| If there are clouds in the scene, a cloud mask has been applied. |  |  | | |
| Plot renders on the pdf. |  |  | | |
| Plot has been classified according to burn severity classes specified in the assignment. |  |  | | |
| Plot contains a meaningful title. |  |  | | |
| Plot has a 2-3 sentence figure caption that clearly describes plot contents. |  |  | | |
| Plot includes a clear legend with each "level" of burn severity labeled clearly. |  |  | | |
| Fire boundary extent has been overlayed on top of the plot |  |  | | |


#### Plot 3 - Pre-fire NBR using landsat data - with cloud mask

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Plot renders on the pdf. |  |  | | |
| Plot has been classified according to burn severity classes specified in the assignment. |  |  | | |
| If there are clouds in the scene, a cloud mask has been applied. |  |  | | |
| Plot has a clear title that describes the data being shown. |  |  | | |
| Plot has a 2-3 sentence figure caption that clearly describes plot contents. |  |  | | |
| Plot includes a clear legend with each "level" of burn severity labeled clearly. |  |  | | |
| Fire boundary extent has been overlayed on top of the plot |  |  | | |


#### Plot 4 - Post-fire NBR using landsat data

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Plot renders on the pdf. |  |  | | |
| Plot has been classified according to burn severity classes specified in the assignment. |  |  | | |
| If there are clouds in the scene, a cloud mask has been applied. |  |  | | |
| Plot has a clear title that describes the data being shown. |  |  | | |
| Plot has a 2-3 sentence figure caption that clearly describes plot contents. |  |  | | |
| Plot includes a clear legend with each "level" of burn severity labeled clearly. |  |  | | |
| Fire boundary exent has been overlayed on top of the plot |  |  | | |

#### Plot 5 - Post-fire NBR MODIS

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Plot renders on the pdf. |  |  | | |
| Plot has been classified according to burn severity classes specified in the assignment. |  |  | | |
| If there are clouds in the scene, a cloud mask has been applied. |  |  | | |
| Plot has a clear title that describes the data being shown. |  |  | | |
| Plot has a 2-3 sentence figure caption that clearly describes plot contents. |  |  | | |
| Plot includes a clear legend with each "level" of burn severity labeled clearly. |  |  | | |
| Fire boundary extent has been overlayed on top of the plot |  |  | | |
| Data have been scaled using the scale factor & the no data value has been applied for values outside of the range of acceptable values for MODIS reflectance.  |  |  | | |



## Plot 1 - NAIP, Landsat & MODIS - Pre Fire

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-08-spectral-remote-sensing-modis/plot-grid-naip-modis-landsat-1.png" title="grid of plots" alt="grid of plots" width="90%" />




```r
fire_severity_classes <- c("High Severity", "Moderate Severity",  "Low Severity",  "Unburned", "Enhanced Regrowth")

# create classification matrix
reclass <- c(-Inf, -.1, 1,
             -.1, .1, 2,
             .1, .27, 3,
             .27, .66, 4,
             .66, Inf , 5)

# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol = 3,
                byrow = TRUE)
```



```r

## Calculate pre fire landsat NBR 
all_landsat_bands_pre <- list.files("data/week_07/Landsat/LC80340322016173-SC20170227185411",
           pattern = glob2rx("*band*.tif$"),
           full.names = TRUE) # use the dollar sign at the end to get all files that END WITH
# create spatial raster stack from the list of file names
all_landsat_bands_pre_st <- stack(all_landsat_bands_pre)
all_landsat_bands_pre_br <- brick(all_landsat_bands_pre_st)

## calculate post-fire NBR 
all_landsat_bands_post <- list.files("data/week_07/Landsat/LC80340322016205-SC20170127160728/crop",
           pattern = glob2rx("*band*.tif$"),
           full.names = TRUE) # use the dollar sign at the end to get all files that END WITH

# stack the data
landsat_post_st <- stack(all_landsat_bands_post)
landsat_post_br <- brick(landsat_post_st)
# Landsat 8 requires bands 7 and 5
landsat_nbr_postfire <- overlay(landsat_post_br[[7]], landsat_post_br[[5]],
                           fun = normalized_diff)

# crop the pre-fire data 
all_landsat_bands_pre_br <- crop(all_landsat_bands_pre_br, extent(landsat_post_br))

# bands 7 and 5
landsat_nbr_prefire <- overlay(all_landsat_bands_pre_br[[7]], all_landsat_bands_pre_br[[5]],
        fun = normalized_diff)

# calculate difference
landsat_nbr_diff <- landsat_nbr_prefire - landsat_nbr_postfire

# classify data
dnbr_landsat_classified <- reclassify(landsat_nbr_diff,
                     reclass_m)

# define color ramp
dnbr_colors <- rev(brewer.pal(5, 'RdYlGn'))
# mar bottom, left, top and right
par(mar = c(0, 0, 2, 5))
plot(nbr_classified,
     col = dnbr_colors,
     legend = FALSE,
     axes = FALSE,
     box = FALSE,
     main = "Landsat NBR - Cold Spring fire site \n Add comparison dates here")
plot(fire_boundary_utm, add = TRUE,
     lwd = 5)
legend(nbr_classified@extent@xmax - 100, nbr_classified@extent@ymax,
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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-08-spectral-remote-sensing-modis/plot-landsat-nbr-1.png" title="plot of chunk plot-landsat-nbr" alt="plot of chunk plot-landsat-nbr" width="90%" />




```r
## Open MODIS pre data

# open modis bands (layers with sur_refl in the name)
all_modis_bands_july7 <- list.files("data/week_07/modis/reflectance/07_july_2016/crop",
           pattern = glob2rx("*sur_refl*.tif$"),
           full.names = TRUE)

# create spatial raster stack
all_modis_bands_pre_st <- stack(all_modis_bands_july7)
all_modis_bands_pre_br <- brick(all_modis_bands_pre_st)

# scale the data deal with nodata value --  -28672
all_modis_bands_pre_br <- all_modis_bands_pre_br * .0001

# deal with nodata value --  -28672
all_modis_bands_pre_br[all_modis_bands_pre_br < -100 ] <- NA

# import cloud mask
cloud_mask_7July <- raster("data/week_07/modis/reflectance/07_july_2016/crop/cloud_mask_july7_500m.tif")
cloud_mask_7July[cloud_mask_7July > 0] <- NA

# apply cloud mask 
all_modis_bands_pre_br_mask <- mask(all_modis_bands_pre_br,
                                cloud_mask_7July)

# crop to the landsat extent
all_modis_bands_pre_br_mask <- crop(all_modis_bands_pre_br_mask, fire_boundary_sin)

# calculate modis NBR
modis_nbr_pre <- overlay(all_modis_bands_pre_br_mask[[7]], all_modis_bands_pre_br_mask[[2]],
                     fun = normalized_diff)

plot(modis_nbr_pre)
plot(fire_boundary_sin, add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-08-spectral-remote-sensing-modis/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="90%" />


```r
##### Get post fire layers
# open modis bands (layers with sur_refl in the name)
all_modis_bands_july17_post <- list.files("data/week_07/modis/reflectance/17_july_2016/crop",
           pattern = glob2rx("*sur_refl*.tif$"),
           full.names = TRUE)

all_modis_bands_post_st <- stack(all_modis_bands_july17_post)
all_modis_bands_post_br <- brick(all_modis_bands_post_st)

# rescale data
all_modis_bands_post_br <- all_modis_bands_post_br * .0001

# deal with nodata value --  -28672
all_modis_bands_post_br[all_modis_bands_post_br < -100] <- NA

# import cloud mask & mask data
cloud_mask_17July <- raster("data/week_07/modis/reflectance/17_july_2016/crop/cloud_mask_july17_500m.tif")
cloud_mask_17July[cloud_mask_17July > 0] <- NA
all_modis_bands_post_br <- mask(all_modis_bands_post_br,
                                cloud_mask_17July)

# calculate NBR
# crop to the landsat extent
all_modis_bands_post_br <- crop(all_modis_bands_post_br, fire_boundary_sin)

# calculate modis NBR
modis_nbr_post <- overlay(all_modis_bands_post_br[[7]], all_modis_bands_post_br[[2]],
                     fun = normalized_diff)

plot(modis_nbr_post)
plot(fire_boundary_sin, add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-08-spectral-remote-sensing-modis/post-fire-modis-1.png" title="plot of chunk post-fire-modis" alt="plot of chunk post-fire-modis" width="90%" />



```r
# calculate dNBR 
modis_dnbr <- modis_nbr_pre - modis_nbr_post

# classify data 
# classify data
dnbr_modis_classified <- reclassify(modis_dnbr,
                     reclass_m)

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

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-08-spectral-remote-sensing-modis/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="90%" />

