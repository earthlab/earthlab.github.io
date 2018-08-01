---
layout: single
title: "Extract Raster Values Using Vector Boundaries in R"
excerpt: "This lesson reviews how to extract pixels from a raster dataset using a
vector boundary. You can use the extracted pixels to calculate mean and max tree height for a study area (in this case a field site where tree heights were measured on the ground. Finally you will compare tree heights derived from lidar data compared to tree height measured by humans on the ground. "
authors: ['Leah Wasser']
modified: '2018-07-30'
category: [courses]
class-lesson: ['remote-sensing-uncertainty-r']
permalink: /courses/earth-analytics/remote-sensing-uncertainty/extract-data-from-raster/
nav-title: 'Extract Data From Raster'
week: 5
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  remote-sensing: ['lidar']
  earth-science: ['vegetation', 'uncertainty']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['vector-data', 'raster-data']
redirect_from:
   - "/course-materials/earth-analytics/week-5/extract-data-from-raster/"
   - "/courses/earth-analytics/week-5/extract-data-from-raster/"
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Use the `extract()` function to extract raster values using a vector extent or set of extents.
* Create a scatter plot with a one-to-one line in `R`.
* Understand the concept of uncertainty as it's associated with remote sensing data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>




```r
# load libraries
library(raster)
library(rgdal)
library(rgeos)
library(ggplot2)
library(dplyr)

options(stringsAsFactors = FALSE)

# set working directory
# setwd("path-here/earth-analytics")
```

## Import Canopy Height Model

First, you will import a canopy height model created by the NEON project. In the
previous lessons / weeks you learned how to make a canopy height model by
subtracting the digital elevation model (`DEM`) from the digital surface model (`DSM`).


```r
# import canopy height model (CHM).
SJER_chm <- raster("data/week-04/california/SJER/2013/lidar/SJER_lidarCHM.tif")
SJER_chm
## class       : RasterLayer 
## dimensions  : 5059, 4296, 21733464  (nrow, ncol, ncell)
## resolution  : 1, 1  (x, y)
## extent      : 254571, 258867, 4107303, 4112362  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Dropbox/earth-analytics/data/week-04/california/SJER/2013/lidar/SJER_lidarCHM.tif 
## names       : SJER_lidarCHM 
## values      : 0, 45.88  (min, max)

# view distribution of pixel values
hist(SJER_chm,
     main = "Histogram of Canopy Height\n NEON SJER Field Site",
     col = "springgreen",
     xlab = "Height (m)")
## Warning in .hist1(x, maxpixels = maxpixels, main = main, plot = plot, ...):
## 0% of the raster cells were used. 100000 values used.
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial02-extract-raster-values/import-chm-1.png" title="Histogram of CHM values" alt="Histogram of CHM values" width="90%" />


There are a lot of values in your `CHM` that == 0. Let's set those to `NA` and plot
again.



```r

# set values of 0 to NA as these are not trees
SJER_chm[SJER_chm == 0] <- NA

# plot the modified data
hist(SJER_chm,
     main = "Histogram of Canopy Height\n pixels==0 set to NA",
     col = "springgreen",
     xlab = "Height (m)")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial02-extract-raster-values/view-histogram-na-0-1.png" title="histogram of chm values" alt="histogram of chm values" width="90%" />

## Part 2. Does Your CHM Data Compare to Field Measured Tree Heights?

You now have a canopy height model for your study area in California. However, how
do the height values extracted from the `CHM` compare to your laboriously collected,
field measured canopy height data? To figure this out, you will use *in situ* collected
tree height data, measured within circular plots across your study area. You will compare
the maximum measured tree height value to the maximum lidar derived height value
for each circular plot using regression.

For this activity, you will use the a `csv` (comma separate value) file,
located in `SJER/2013/insitu/veg_structure/D17_2013_SJER_vegStr.csv`.


```r
# import plot centroids
SJER_plots <- readOGR("data/week-04/california/SJER/vector_data/SJER_plot_centroids.shp")
## OGR data source with driver: ESRI Shapefile 
## Source: "/Users/lewa8222/Dropbox/earth-analytics/data/week-04/california/SJER/vector_data/SJER_plot_centroids.shp", layer: "SJER_plot_centroids"
## with 18 features
## It has 5 fields

# Overlay the centroid points and the stem locations on the CHM plot
plot(SJER_chm,
     main = "SJER Plot Locations",
     col = gray.colors(100, start = .3, end = .9))

# pch 0 = square
plot(SJER_plots,
     pch = 16,
     cex = 2,
     col = 2,
     add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial02-extract-raster-values/read-plot-data-1.png" title="canopy height model / plot locations plot" alt="canopy height model / plot locations plot" width="90%" />

### Extract CMH Data Within 20m Radius of Each Plot Centroid

Next, you will create a boundary region (called a buffer) representing the spatial
extent of each plot (where trees were measured). You will then extract all `CHM` pixels
that fall within the plot boundary to use to estimate tree height for that plot.

There are a few ways to go about this task. If your plots are circular, then you can
use the `extract()` function.

<figure>
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/buffer-circular.png" alt="buffer circular">
    <figcaption>The extract function in R allows you to specify a circular buffer
    radius around an x,y point location. Values for all pixels in the specified
    raster that fall within the circular buffer are extracted. In this case, you
    will tell R to extract the maximum value of all pixels using the fun=max
    command. Source: Colin Williams, NEON
    </figcaption>
</figure>

### Extract Plot Data Using Circle: 20m Radius Plots


```r
# Insitu sampling took place within 40m x 40m square plots, so you use a 20m radius.
# Note that below will return a data.frame containing the max height
# calculated from all pixels in the buffer for each plot
SJER_height <- raster::extract(SJER_chm,
                    SJER_plots,
                    buffer = 20, # specify a 20 m radius
                    fun = mean, # extract the MEAN value from each plot
                    sp = TRUE, # create spatial object
                    stringsAsFactors = FALSE)

# view structure of the spatial data frame attribute table
head(SJER_height@data)
##    Plot_ID  Point northing  easting plot_type SJER_lidarCHM
## 1 SJER1068 center  4111568 255852.4     trees     11.544348
## 2  SJER112 center  4111299 257407.0     trees     10.355685
## 3  SJER116 center  4110820 256838.8     grass      7.511956
## 4  SJER117 center  4108752 256176.9     trees      7.675347
## 5  SJER120 center  4110476 255968.4     grass      4.591176
## 6  SJER128 center  4111389 257078.9     trees      8.979005
# note that this is a spatial points data frame
class(SJER_height)
## [1] "SpatialPointsDataFrame"
## attr(,"package")
## [1] "sp"
```

Looking at your new spatial points data frame, you can see a field named SJER_lidarCHM.
This is the column name of the mean height for each plot location. Let's rename that
to be something more meaningful.


```r
# raname
colnames(SJER_height@data)[6]
## [1] "SJER_lidarCHM"

# rename the column
colnames(SJER_height@data)[6] <- "lidar_mean_ht"
head(SJER_height@data)
##    Plot_ID  Point northing  easting plot_type lidar_mean_ht
## 1 SJER1068 center  4111568 255852.4     trees     11.544348
## 2  SJER112 center  4111299 257407.0     trees     10.355685
## 3  SJER116 center  4110820 256838.8     grass      7.511956
## 4  SJER117 center  4108752 256176.9     trees      7.675347
## 5  SJER120 center  4110476 255968.4     grass      4.591176
## 6  SJER128 center  4111389 257078.9     trees      8.979005
```

#### Explore the Data Distribution

If you want to explore the data distribution of pixel height values in each plot,
you could remove the `fun` call to max and generate a list.
`cent_ovrList <- extract(chm,centroid_sp,buffer = 20)`. It's good to look at the
distribution of values you've extracted for each plot. Then you could generate a
histogram for each plot `hist(cent_ovrList[[2]])`. If you wanted, you could loop
through several plots and create histograms using a `for loop`.


```r
# cent_ovrList <- extract(chm,centroid_sp,buffer = 20)
# create histograms for the first 5 plots of data
# for (i in 1:5) {
#  hist(cent_ovrList[[i]], main=(paste("plot",i)))
#  }

```


## Plot by Height


```r
# plot canopy height model
plot(SJER_chm,
     main = "Vegetation Plots \nSymbol size by Average Tree Height",
     legend = FALSE)

# add plot location sized by tree height
plot(SJER_height,
     pch = 19,
     cex = (SJER_height$lidar_mean_ht)/10, # size symbols according to tree height attribute normalized by 10
     add = TRUE)

# place legend outside of the plot
par(xpd = TRUE)
legend(SJER_chm@extent@xmax + 250,
       SJER_chm@extent@ymax,
       legend = "plot location \nsized by \ntree height",
       pch = 19,
       bty = 'n')
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial02-extract-raster-values/create-spatial-plot-1.png" title="Plots sized by vegetation height" alt="Plots sized by vegetation height" width="90%" />
