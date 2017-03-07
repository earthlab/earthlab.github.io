---
layout: single
title: "An example of creating modular code in R - Efficient scientific programming"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Max Joseph', 'Software Carpentry', 'Leah Wasser']
modified: '2017-03-07'
category: [course-materials]
class-lesson: ['automating-your-science-r']
permalink: /course-materials/earth-analytics/week-8/function-example-modular-code-r/
nav-title: 'Function example'
week: 8
sidebar:
  nav:
author_profile: false
comments: true
order: 2
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe how functions can make your code easier to read / follow

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data that we already downloaded for week 6 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>



```r

# set working dir
setwd("~/Documents/earth-analytics")

# load spatial packages
library(raster)
library(rgdal)
library(rgeos)
library(RColorBrewer)
# turn off factors
options(stringsAsFactors = F)

# set colors

nbr_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")
ndvi_colors = c("brown","ivory1","seagreen1","seagreen4")

# get list of tif files
all_landsat_bands <- list.files("data/week6/Landsat/LC80340322016189-SC20170128091153/crop",
                                pattern=glob2rx("*band*.tif$"),
                                full.names = T)

# stack the data (create spatial object)
landsat_stack_csf <- stack(all_landsat_bands)

# calculate normalized index - NDVI
landsat_ndvi <- (landsat_stack_csf[[5]] - landsat_stack_csf[[4]]) / (landsat_stack_csf[[5]] + landsat_stack_csf[[4]])

# create classification matrix
# note i line it up like this so it looks more like the arcgis reclass table!
reclass <- c(-1, -.2, 1,
             -.2, .2, 2,
             .2, .5, 3,
             .5, 1, 4)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                    ncol=3,
                    byrow=TRUE)

ndvi_classified <- reclassify(landsat_ndvi,
                             reclass_m)

# set colors
the_colors = c("palevioletred4","palevioletred1","ivory1","seagreen1","seagreen4")
# plot classified data
plot(ndvi_classified,
     box=F, axes=F, legend=F,
     main="NDVI - Pre fire")
legend(ndvi_classified@extent@xmax, ndvi_classified@extent@ymax,
       legend=c("class one", "class two", "class three"),
       fill = the_colors, bty="n", xpd=T)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-8/in-class/2016-12-06-automation02-function-example-r/unnamed-chunk-1-1.png" title=" " alt=" " width="100%" />



```r
# calculate normalized index = NBR
landsat_nbr <- (landsat_stack_csf[[4]] - landsat_stack_csf[[7]]) / (landsat_stack_csf[[4]] + landsat_stack_csf[[7]])

# create classification matrix
reclass <- c(-1.0, -.1, 1,
             -.1, .1, 2,
             .1, .27, 3,
             .27, .66, 4,
             .66, 1.3, 5)
# reshape the object into a matrix with columns and rows
reclass_m <- matrix(reclass,
                ncol=3,
                byrow=TRUE)

nbr_classified <- reclassify(landsat_nbr,
                     reclass_m)

# plot classified data
plot(ndvi_classified,
     box=F, axes=F, legend=F,
     main="Landsat NBR - Pre Fire \n Julian Day 189")
legend(nbr_classified@extent@xmax-100, nbr_classified@extent@ymax,
       c("Enhanced Regrowth", "Unburned", "Low Severity", "Moderate Severity", "High Severity"),
       fill=rev(the_colors),
       cex=.9, bty="n", xpd=T)
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-8/in-class/2016-12-06-automation02-function-example-r/unnamed-chunk-2-1.png" title=" " alt=" " width="100%" />


# Example using functions


```r
# code to go here
```
