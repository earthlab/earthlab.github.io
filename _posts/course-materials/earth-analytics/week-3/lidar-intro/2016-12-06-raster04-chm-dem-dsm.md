---
layout: single
title: "Canopy Height Models, Digital Surface Models & Digital Elevation Models - Work With LiDAR Data in R"
excerpt: "This lesson defines 3 lidar data products: the digital elevation model (DEM), the digital surface model (DSM) and the canopy height model (CHM). We will also create
a CHM using the DSM and DEM via raster subtraction in R."
authors: ['Leah Wasser', 'NEON Data Skills']
lastModified: 2017-01-03
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-3/lidar-chm-dem-dsm/
nav-title: 'CHM, DSM, DEM'
week: 3
sidebar:
  nav:
author_profile: false
comments: false
order: 4
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Define Canopy Height Model (CHM), Digital Elevation Model (DEM) and Digital Surface Model (DSM)
* Describe the key differences between the **CHM**, **DEM**, **DSM**
* Derive a **CHM** in R using raster math.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

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

As we discussed in the previous lesson, LiDAR or **Li**ght **D**etection **a**nd
**R**anging is an active remote sensing system that can be used to measure
vegetation height across wide areas. If the data are discrete return, Lidar point
clouds are most commonly derived data product from a lidar system. However, often
people work with lidar data in raster format given it's smaller in size and
thus easier to work with. In this lesson, we will import and work with
3 of the most common lidar derived data products in `R`:

1. **Digital Terrain Model (or DTM):** ground elevation.
2. **Digital Surface Model (or DSM):** top of the surface (imagine draping a sheet over the canopy of a forest
3. **Canopy Height Model (CHM):** the elevation of the Earth's surface - and it sometimes also called a DEM or digital elevation model.

## 3 Important Lidar Data Products: CHM, DEM, DSM

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/lidarTree-height.png">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/lidarTree-height.png" alt="Lidar derived DSM, DTM and CHM."></a>
   <figcaption>Digital Surface Model (DSM), Digital Elevation Models (DEM) and
   the Canopy Height Model (CHM) are the most common raster format lidar
   derived data products. One way to derive a CHM is to take
   the difference between the digital surface model (DSM, tops of trees, buildings
   and other objects) and the Digital Terrain Model (DTM, ground level). The CHM
   represents the actual height of trees, buildings, etc. with the influence of
   ground elevation removed. Graphic: Colin Williams, NEON
   </figcaption>
</figure>


## Introducing the Digital Elevation Model
We will start with the digital elevation model - the file that we worked with
to better understand raster data in the previous lesson. The digital elevation
model (DEM), also known as a digital terrain model (DTM) represents the elevation
of the earth surfacel. The DEM represents the ground - and thus DOES NOT INCLUDE
trees and buildings and other objects.


```r

# load libraries
library(raster)
library(rgdal)

# set working directory to ensure R can find the file we wish to import
# setwd("working-dir-path-here")
```


```r

# open raster data
lidar_dem <- raster(x="data/week3/lidar/post-flood/postDSM3.tif")

# plot raster data
plot(lidar_dem,
     main="LiDAR Digital Elevation Model")
```

![digital elevation model plot]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster04-chm-dem-dsm/dem-1.png)

Notice in the plot above, the range of elevation values. Let's next look at the
digital SURFACE model (DSM). The DSM represents the top of the earth's surface.
Thus, it INCLUDES TREES, BUILDINGS and other objects that sit on the earth.


```r

# open raster data
lidar_dsm <- raster(x="data/week3/lidar/post-flood/postDSM3.tif")

# plot raster data
plot(lidar_dsm,
     main="LiDAR Digital Surface Model")
```

![digital surface model plot]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster04-chm-dem-dsm/dsm-1.png)

## The Canopy Height Model

The canopy height model (CHM) represents the HEIGHT of the trees. This is not
an elevation value, rather it's the distance between the ground and the top of the
trees. Some canopy height models also include buildings so you need to look closely
are your data to make sure it was properly cleaned before assuming it represents
all trees!


There are different ways to calculate a CHM. One easy way is to subtract the
DEM from the DSM.

DSM - DEM = CHM

This math gives you the residual value or difference between the top of the
earth surface and the ground which should be the heights of the trees (and buildings
if the data haven't been "cleaned").


```r

# open raster data
lidar_chm <- lidar_dsm - lidar_dem

# plot raster data
plot(lidar_chm,
     main="LiDAR Canopy Height Model")
```

![canopy height model plot]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster04-chm-dem-dsm/chm-1.png)

## Plots Using Breaks

Sometimes a gradient of colors is useful to represent a continuous variable.
But other times, it's useful to apply colors to particular ranges of values
in a raster. These ranges may be statistically generated or simply visual.

Let's create breaks in our CHM plot.



```r

# plot raster data
plot(lidar_chm,
     breaks = c(300, 350, 400, 450),
     main="LiDAR Canopy Height Model")
```

![canopy height model breaks]({{ site.baseurl }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2016-12-06-raster04-chm-dem-dsm/chm-breaks-1.png)


## Explore changes before and after the floods

Now that we've learned about the 3 common data products derived from lidar data,
let's use them to do a bit of exploration of our data - as it relates to the 2013
Colorado floods.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge - Calculate Degree of Difference

</div>
