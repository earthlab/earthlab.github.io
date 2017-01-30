---
layout: single
title: "Classify a raster in R."
excerpt: "This lesson presents how to classify a raster dataset and export it as a
new raster in R."
authors: ['Leah Wasser']
modified: '2017-01-30'
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-3/classify-raster/
nav-title: 'classify raster'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 5
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Reclassify a raster dataset in R using a set of defined values.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [How to Setup R / RStudio](/course-materials/earth-analytics/week-1/setup-r-rstudio/)
* [Setup your working directory](/course-materials/earth-analytics/week-1/setup-working-directory/)
* [Intro to the R & RStudio Interface](/course-materials/earth-analytics/week-1/intro-to-r-and-rstudio)

### R Libraries to Install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

</div>

In this lesson, we will learn how to reclassify a raster dataset in `R`. Previously,
we plotted a raster value using break points - that is to say, we colored particular
ranges of raster values using a defined set of values that we call `breaks`.
In this lesson, we will learn how to reclassify a raster - to create a new raster
object / file that we can share with colleagues and / or open in other tools such
as QGIS.

<figure>
<img src="http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/geoprocessing_with_3d_analyst/Reclass_Reclass2.gif" alt="reclassification process by ESRI">
<figcaption>When you reclassify...
</figcaption>
</figure>

## Map raster values to new values

The first thing that will need to do is create a reclassification matrix. This
matrix MAPS a range of values to a new defined value. Let's create a classified
canopy height model where we designate short, medium and tall trees.

The values will be defined as follows:

short = 1
medium = 2
tall = 3



```r

# create classification matrix
class.m <- c(0, 10, 1,
             10, 20, 2,
             20, 35, 3)
class.m
## [1]  0 10  1 10 20  2 20 35  3

# reshape the object into a matrix with columns and rows
rcl.m <- matrix(class.m,
                ncol=3,
                byrow=TRUE)
rcl.m
##      [,1] [,2] [,3]
## [1,]    0   10    1
## [2,]   10   20    2
## [3,]   20   35    3
```

## Reclassify raster

Next, we will reclassify the raster


```r
# open canopy height model
lidar_chm <- raster("data/week3/outputs/lidar_chm.tif")
## NOTE: rgdal::checkCRSArgs: no proj_defs.dat in PROJ.4 shared files

# reclassify the raster using the reclass object - rcl.m
chm_classified <- reclassify(lidar_chm,
                     rcl.m)
## NOTE: rgdal::checkCRSArgs: no proj_defs.dat in PROJ.4 shared files
# plot reclassified data
plot(chm_classified,
     col=c("red", "blue", "green"))
## NOTE: rgdal::checkCRSArgs: no proj_defs.dat in PROJ.4 shared files
## NOTE: rgdal::checkCRSArgs: no proj_defs.dat in PROJ.4 shared files
```

![ ]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster05-classify-raster/reclassify-raster-1.png)


## Add custom legend

Finally, let's clean up our plot legend. Given we have discrete values we will
create a CUSTOM legend with the 3 categories that we created in our classification matrix.



```r
# plot reclassified data
plot(chm_classified, 
     legend=F,
     col=c("red", "blue", "green"), axes=F,
     main="Canopy Height Model - Classified: short, medium, tall trees")
## NOTE: rgdal::checkCRSArgs: no proj_defs.dat in PROJ.4 shared files
## NOTE: rgdal::checkCRSArgs: no proj_defs.dat in PROJ.4 shared files

legend("topright", 
       legend = c("short trees", "medium trees", "tall trees"), 
       fill = c("red", "blue", "green"),
       border = F, 
       bty="n") # turn off legend border
```

![ ]({{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster05-classify-raster/plot-w-legend-1.png)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge - plot change over time

1. Create a classified raster map that shows **positive and negative change** in the canopy height model before and after the flood. To do this you will need to calculate the difference
between two canopy height models. 
2. Create a classified raster map that shows **positive and negative change** in terrain extracted from the pre and post flood Digital Terrain Models 
before and after the flood.

For each plot, be sure to add a legend that clearly shows what each color in your 
classified raster represents. Add a title to your plot. You will include these plots
in your final report due next week. 

</div>
