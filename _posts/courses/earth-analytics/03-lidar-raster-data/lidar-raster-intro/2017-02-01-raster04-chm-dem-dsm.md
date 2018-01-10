---
layout: single
title: "Create a Canopy Height Model With Lidar Data"
excerpt: "A canopy height model contains height values trees and can be used to understand landscape change over time. Learn how to use LIDAR elevation data to calculate canopy height and change in terrain over time."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-lidar-raster-r']
permalink: /courses/earth-analytics/lidar-raster-data-r/lidar-chm-dem-dsm/
nav-title: 'CHM, DSM, DEM'
week: 3
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
   - "/course-materials/earth-analytics/week-3/lidar-chm-dem-dsm/"
---

{% include toc title="In This Lesson" icon="file-text" %}




<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Define Canopy Height Model (`CHM`), Digital Elevation Model (`DEM`) and Digital Surface Model (`DSM`).
* Describe the key differences between the **CHM**, **DEM**, **DSM**.
* Derive a **CHM** in `R` using raster math.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* [How to set up R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Set up your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)
* [Intro to the R & RStudio interface](/courses/earth-analytics/document-your-science/intro-to-r-and-rstudio)

### R Libraries to iInstall:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

If you have not already downloaded the week 3 data, please do so now.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

As you learned in the previous lesson, lidar or **Li**ght **D**etection **a**nd
**R**anging is an active remote sensing system that can be used to measure
vegetation height across wide areas. If the data are discrete return, lidar point
clouds are most commonly derived data product from a lidar system. However, often
people work with lidar data in raster format given it's smaller in size and
thus easier to work with. In this lesson, you will import and work with
3 of the most common lidar derived data products in `R`:

1. **Digital Terrain Model (or DTM):** ground elevation or the elevation of the Earth's surface (sometimes also called a `DEM` or digital elevation model).
2. **Digital Surface Model (or DSM):** top of the surface (imagine draping a sheet over the canopy of a forest
3. **Canopy Height Model (CHM):** The height of objects above the ground.

## Three Important Lidar Data Products: CHM, DEM, DSM

<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/lidarTree-height.png">
   <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/lidarTree-height.png" alt="Lidar derived DSM, DTM and CHM."></a>
   <figcaption>Digital Surface Model (DSM), Digital Elevation Models (DEM) and
   the Canopy Height Model (CHM) are the most common raster format lidar
   derived data products. One way to derive a CHM is to take
   the difference between the digital surface model (DSM, tops of trees, buildings
   and other objects) and the Digital Terrain Model (DTM, ground level). The CHM
   represents the actual height of trees, buildings, etc. with the influence of
   ground elevation removed. Graphic: Colin Williams, NEON
   </figcaption>
</figure>


### Digital Elevation Model
In the previous lesson, you opened a digital elevation model. The digital elevation
model (`DEM`), also known as a digital terrain model (`DTM`) represents the elevation
of the Earth's surface. The `DEM` represents the ground - and thus DOES NOT INCLUDE
trees and buildings and other objects.



```r
# load libraries
library(raster)
library(rgdal)

# set working directory to ensure R can find the file you wish to import
# setwd("working-dir-path-here")
```

First, let's open and plot the digital elevation model.


```r
# open raster data
lidar_dem <- raster(x = "data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")

# plot raster data
plot(lidar_dem,
     main = "Lidar Digital Elevation Model (DEM)")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster04-chm-dem-dsm/dem-1.png" title="digital elevation model plot" alt="digital elevation model plot" width="90%" />

Next, let's open the digital SURFACE model (`DSM`). The `DSM` represents the top of
the earth's surface. Thus, it INCLUDES TREES, BUILDINGS and other objects that
sit on the Earth.


```r
# open raster data
lidar_dsm <- raster(x = "data/week-03/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")

# plot raster data
plot(lidar_dsm,
     main = "Lidar Digital Surface Model (DSM)")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster04-chm-dem-dsm/dsm-1.png" title="digital surface model plot" alt="digital surface model plot" width="90%" />

## Canopy Height Model

The canopy height model (`CHM`) represents the HEIGHT of the trees. This is not
an elevation value, rather it's the height or distance between the ground and the top of the
trees. Some canopy height models also include buildings so you need to look closely
at your data to make sure it was properly cleaned before assuming it represents
all trees!

### Calculate Difference Between Two Rasters

There are different ways to calculate a `CHM`. One easy way is to subtract the
`DEM` from the `DSM`.

`DSM` - `DEM` = `CHM`

This math gives you the residual value or difference between the top of the
earth surface and the ground which should be the heights of the trees (and buildings
if the data haven't been "cleaned").


```r
# open raster data
lidar_chm <- lidar_dsm - lidar_dem

# plot raster data
plot(lidar_chm,
     main = "Lidar Canopy Height Model (CHM)")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster04-chm-dem-dsm/chm-1.png" title="canopy height model plot" alt="canopy height model plot" width="90%" />

## Plots Using Breaks

Sometimes a gradient of colors is useful to represent a continuous variable.
But other times, it's useful to apply colors to particular ranges of values
in a raster. These ranges may be statistically generated or simply visual.

Let's create breaks in your `CHM` plot.



```r
# plot raster data
plot(lidar_chm,
     breaks = c(0, 2, 10, 20, 30),
     main = "Lidar Canopy Height Model",
     col = c("white", "brown", "springgreen", "darkgreen"))
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/03-lidar-raster-data/lidar-raster-intro/2017-02-01-raster04-chm-dem-dsm/chm-breaks-1.png" title="canopy height model breaks" alt="canopy height model breaks" width="90%" />

## Export a Raster

We can export a raster file in `R` using the `write.raster()` function. Let's
export the canopy height model that we just created to your data folder. You will
create a new directory called "outputs" within the week 3 directory. This structure
allows us to keep things organized, separating your outputs from the data you downloaded.

NOTE: You can use the code below to check for and create an outputs directory
OR you can create the directory yourself using the finder (MAC) or Windows
Explorer.



```r
# check to see if an output directory exists
dir.exists("data/week-03/outputs")
## [1] TRUE

# if the output directory doesn't exist, create it
if (dir.exists("data/week-03/outputs")) {
  print("the directory exists!")
  } else {
    # if the directory doesn't exist, create it
    # recursive tells R to create the entire directory path (data/week-03/outputs)
    dir.create("data/week-03/outputs", recursive = TRUE)
  }
## [1] "the directory exists!"

# export CHM object to new GeotIFF
writeRaster(lidar_chm, "data/week-03/outputs/lidar_chm.tiff",
            format = "GTiff",  # output format = GeoTIFF
            overwrite = TRUE) # CAUTION: if this is true, it will overwrite an existing file

```

<div class="notice--success" markdown="1">
<i fa fa-star></i>**Data Tip:**
You can simplify the directory code above by using the exclamation `!` which tells
R to return the INVERSE or opposite of the function you have requested `R` run.

```r
# if the output directory doesn't exist, create it
if (!dir.exists("data/week-03/outputs")) {
    # if the directory doesn't exist, create it
    # recursive tells R to create the entire directory path (data/week-03/outputs)
    dir.create("data/week-03/outputs", recursive=TRUE)
}
```
</div>


## Change Detection: Terrain

Now that you've learned about the three common data products derived from lidar data,
let's use them to do a bit of exploration of your data - as it relates to the 2013
Colorado floods.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Calculate Changes in Terrain

* Subtract the pre-flood `DEM` from the post-flood DEM. Do you see any differences in
elevation before and after?
* Create a `CHM` for both pre-flood and post-flood by subtracting the `DEM` from the DTM
for each year.
* Create a `CHM` DIFFERENCE raster by subtracting the pre-flood CHM from the post-flood `CHM`.
* Plot a histogram of the `CHM` DIFFERENCE.
* Export the files as `geotiff`s to your output directory then open them in `QGIS`.
Explore the differences.

What differences do you see in canopy height between the two years?

</div>
