---
layout: single
authors: [Leah A. Wasser]
category: [course-materials]
title: 'Convert points to rasters using IDW deterministic interpolation using R - Intro to raster and gstat packages'
excerpt: 'In this lesson, we dive deeper into the IDW interpolation method. We use R to interpolate some sparse points with the gstat::idw function.'
dateCreated: 2016-10-25
modified: 2017-07-25
module-title: 'Intro to gridding & interpolation in R - Raster and gstat'
module-description: 'In this module we overview various interpolation approaches and explore how to apply them using the R programming language.'
permalink: /course-materials/intro-to-spatial-interpolation-in-r/
nav-title: 'IDW in R'
sidebar:
  nav:
class-lesson: ['intro-interpolation']
topics:
  spatial-data-and-gis: ['raster-data', 'gridding-and-spatial-interpolation']
author_profile: false
comments: false
order: 2
---

## Overview

In this lesson we will review the IDW deterministic interpolation approach to
convert a set of spatial points with elevation values to a raster in `R`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this tutorial, you will be able to:

* Interpolate data using Inverse Distance Weighted (IDW) interpolator in R using the `gstat` package
* Export a raster to geotiff format using `writeRaster()`

****

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }


</div>

1. Interpolate data using Inverse Distance Weighted (IDW) interpolator
1. Export a raster to geotiff format using `writeRaster()`



## Converting points to rasters

If you recall from the previous lessons, interpolators allow us to create a surface
using point locations with known values. If we just grid our data and turn it
into a raster, we will have gaps in our raster in locations where we are missing
point data. However, we can use an interpolator to estimate values in areas where
we don't have point data. There are many different types of interpolators and associated
reasons to use one interpolator over another. In this lesson, we will learn how to
apply the IDW deterministic interpolator to a set of points with sea elevation data.

<i class="fa fa-star" aria-hidden="true"></i> **Tip:** A deterministic interpolator
is one that uses a mathametical equation - often related to weighted area or distance
to estimate an unknown value in a grid location using surrounding point data.
{: .notice--success }

### Inverse Distance Weighted (IDW)

Inverse distance weighted interpolation (IDW) calculates the values of a query point
(a cell with an unknown value)  using a linearly weighted combination of values
from nearby points. As mentioned in the previous lesson, IDW is ideal for data where
points are dense and distributed throughout the spatial extent of the data. IDW
is often preferred over kriging and other probabilistic (geo statistical) approaches
given faster processing time over large point clouds and when the data are not
necessarily statistically correlated.

<figure>
    <a href="https://docs.qgis.org/2.2/en/_images/idw_interpolation.png">
	<img src="https://docs.qgis.org/2.2/en/_images/idw_interpolation.png"></a>

    <figcaption>
	IDW interpolation calculates the value of an unknown cell center value (a
	query point) using 	surrounding points with the assumption that closest points
	will be the most similar to the value of interest.
</figcaption>

</figure>


**Key Attributes of IDW Interpolation:**

* Raster is derived based upon an assumed linear relationship between the
location of interest and the distance to surrounding sample points.
* Sample points closest to the cell of interest are assumed to be more related
to its value than those further away.
* Exact - Can not interpolate beyond the min/max range of data point values.
* Can only estimate within the range of EXISTING sample point values - this can
yield "flattened" peaks and valleys" especially if the data didn't capture those
high and low points.
* Point average values
* Good for data that are equally distributed and  dense. Assumes a consistent
trend / relationship between points and does not accommodate trends within the data
(e.g. east to west, etc).

<figure>
    <a href="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted_files/image001.gif">
	<img src="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted_files/image001.gif">
	</a>

  <figcaption>
	IDW interpolation looks at the linear distance between the unknown value
	and surrounding points.
  </figcaption>
</figure>


#### Power

The power setting in IDW interpolation specifies how strongly points further
away from the cell value of interest impact the calculated value for that cell.
Power values range from 0-3+ with a default settings generally being 2. A larger
power value produces a more localized result - values further away from the cell
have less impact on it's calculated value, values closer to the cell impact it's
value more. A smaller power value produces a more averaged result where sample points
further away from the cell have a greater impact on the cell's calculated value.

<figure>
    <a href="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted_files/image003.gif
"><img src="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted_files/image003.gif
"></a>

    <figcaption>
	The solid line represents more power and the dashed line represents less power.
	The higher the power, the more localized an affect a sample point's value has on
	the resulting surface. A smaller power value yields are smoothed or more averaged
	surface. IMAGE SOURCE: http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted.htm

</figcaption>
</figure>

In this lesson, we will apply the IDW interpolator to some points that are sparsely
distributed using the `gstat::idw` function. We will explore the `power` and `maxdistance`
arguments to better understand how they impact our data.
## Setup

First, we load all the libraries that we plan to use in our code and
ensure that the working directory is set.


```r
# set working dir
#setwd("~/Documents/earth-analytics/data/")
# load libraries
library(tidyr)
library(gstat)
## Error in library(gstat): there is no package called 'gstat'
library(rgdal)
library(raster)
library(rgeos)
library(scales)
options(stringsAsFactors = FALSE)
```

Next, let's get the data.
The data that we are using today - similar to yesterday are stored
on [Figshare](https://figshare.com/articles/OSS_data_-_2017_monday/5136289). We will use R to

1. download the data and
2. unzip it into the SAME data directory that we used yesterday


```r
# download the data from a figshare URL
download.file("https://ndownloader.figshare.com/files/8955466",
              destfile = "./tues-data.zip",
              method='curl')
# unzip the data into our oss2017 data directory
unzip("tues-data.zip")
```

## Going from points to raster - spatial interpolation in R

First we open some point data. Here we have sea level elevation for the
year 2000.


```r
# import the data
sea_level_2000_sp <- readOGR("gulf-data/sea-level/sea_level_2000.shp")
## Error in ogrListLayers(dsn = dsn): Cannot open data source
# check out the elevation values - this is what we will be interpolating.
sea_level_2000_sp$elev_mm
## Error in eval(expr, envir, enclos): object 'sea_level_2000_sp' not found
```

If you have a csv, you'll need to convert it to a spatial points object.
You can follow the code below to do that. **However if you have a shapefile
you can skip the code below and continue on!**


```r
# import csv file
sea_level_2000 <- read.csv("gulf-data/sea-level/sea_lev_2000.csv")

# check out our data
sea_level_2000$elev_mm

# remove NA values
sea_level_2000 <- sea_level_2000 %>%
  drop_na()

# `~long + lat` simply tells R to use the x and y columns to respectively to
# convert a non spatial object into a spatial object.
# convert the data into spatial coordinates
coordinates(sea_level_2000_sp) <- ~long + lat
# make sure that your object is spatial
class(sea_level_2000_sp)
```

In the next step, we will setup our raster that we will use to interpolation
into. We will need to do the following:

1. We create an EMPTY grid across a spatial extent that we with to interpolate our data within
1. We populate that grid with interpolated values generated from the points layer that we created above.

In the example below, we use the Inverse Distance Weighted (IDW)
interpolator.

First, let's create our grid. We are going to use a specified (in this case)
spatial extent to populate this grid. There is no magic here associated
with creating the grid area. You will have to decide that area that you
think is reasonable to perform the interpolation on.


```r
# create an empty grid of values ranging from the xmin-xmax, ymin-ymax
grd <- expand.grid(x = seq(from = -99, to = -80, by = 0.1),
                   y = seq(from = 24, to = 32, by = 0.1))
class(grd)
## [1] "data.frame"
```

Next we will convert this grid into a spatial points and then spatial
pixels object.


```r
# Convert grd object to a matrix and then turn into a spatial
# points object
coordinates(grd) <- ~x + y
# turn into a spatial pixels object
gridded(grd) <- TRUE
class(grd)
## [1] "SpatialPixels"
## attr(,"package")
## [1] "sp"
```

Next, let's have a look at our grid to ensure things look the way we expect them
to.


```r
#### view grid with points overlayed
plot(grd, cex = 1.5, col = "grey",
     main = "Empty spatial grid with point location overlaid on top")
```

<img src="{{ site.url }}/images/rfigs/course-materials/spatial-modules/gridding-and-interpolation/2017-07-25-intro-to-IDW-interpolation-in-r/plot-grid-1.png" title="Map of empty grid layer with points overlayed on top." alt="Map of empty grid layer with points overlayed on top." width="100%" />

```r
plot(sea_level_2000_sp,
       pch = 15,
       col = "red",
       cex = 1,
       add = TRUE)
## Error in plot(sea_level_2000_sp, pch = 15, col = "red", cex = 1, add = TRUE): object 'sea_level_2000_sp' not found
```

In the last step we use `idw()` to interpolate our points to a grid.
`idw()` takes several arguments

1. first the formula: elev_mm ~ 1 tells r to use the x,y coordinates combined with the elev_mm value to perform the griding
1. locations = represents the spatial points objects that you wish to grid
1. newdata = represents the grid object that you will insert the values into
1. finally we specify the power. Generally power values range between 1-3 with a smaller number creating a smoother surface (stronger influence from surrounding points) and a larger number creating a surface that is more true to the actual data and in turn a less smooth surface potentially.



```r
# make sure both layers have the same CRS
crs(sea_level_2000_sp)
## Error in crs(sea_level_2000_sp): object 'sea_level_2000_sp' not found
crs(grd)
## CRS arguments: NA
crs(grd) <- crs(sea_level_2000_sp)
## Error in crs(sea_level_2000_sp): object 'sea_level_2000_sp' not found
# interpolate the data
idw_pow1 <- idw(formula = elev_mm ~ 1,
           locations = sea_level_2000_sp,
           newdata = grd,
           idp = 1)
## Error in idw(formula = elev_mm ~ 1, locations = sea_level_2000_sp, newdata = grd, : could not find function "idw"

# Notice that the output data is a SpatialPixelsDataFrame
class(idw_pow1)
## Error in eval(expr, envir, enclos): object 'idw_pow1' not found
# plot the data
plot(idw_pow1,
     main = "IDW raster: Power = 1",
     col = terrain.colors(55))
## Error in plot(idw_pow1, main = "IDW raster: Power = 1", col = terrain.colors(55)): object 'idw_pow1' not found
```

## Export to geotiff

We can export our geotiff in R too. Below we first convert our
`spatialpixelsdataframe` to a raster using the `raster()` function.
Then we export to a geotiff using `writeRaster()`.


```r
# convert spatial pixels df to raster
idw_pow1_ras <- raster(idw_pow1)
# export to geotif
writeRaster(idw_pow1_ras,
            filename = "idw_pow1.tif", "GTiff")
```

Let's create a difference surface with a larger power to see how it impacts
our data.


```r
# interpolate the data
idw_pow3 <- idw(formula = elev_mm ~ 1,
           locations = sea_level_2000_sp,
           newdata = grd,
           idp = 3)
## Error in idw(formula = elev_mm ~ 1, locations = sea_level_2000_sp, newdata = grd, : could not find function "idw"

# plot the data
plot(idw_pow3,
     main = "IDW raster: Power = 3",
     col = terrain.colors(55))
## Error in plot(idw_pow3, main = "IDW raster: Power = 3", col = terrain.colors(55)): object 'idw_pow3' not found
```

Finally, let's explore how distance impacts our interpolation.


```r
# interpolate the data
idw_dist1 <- idw(formula = elev_mm ~ 1,
           locations = sea_level_2000_sp,
           newdata = grd,
           idp = 1,
           maxdist = 4)
## Error in idw(formula = elev_mm ~ 1, locations = sea_level_2000_sp, newdata = grd, : could not find function "idw"
# plot the data
plot(idw_dist1,
     main = "IDW: distance = 1 degree, power = 1")
## Error in plot(idw_dist1, main = "IDW: distance = 1 degree, power = 1"): object 'idw_dist1' not found
```


```r
# interpolate the data
idw_dist5 <- idw(formula = elev_mm ~ 1,
           locations = sea_level_2000_sp,
           newdata = grd,
           idp = .2,
           maxdist = 5)
## Error in idw(formula = elev_mm ~ 1, locations = sea_level_2000_sp, newdata = grd, : could not find function "idw"

plot(idw_dist5,
     main = "IDW: distance = 5 degrees, power = 1")
## Error in plot(idw_dist5, main = "IDW: distance = 5 degrees, power = 1"): object 'idw_dist5' not found
```

Let's increase the distance even more.


```rd
# interpolate the data
idw_dist15 <- idw(formula = elev_mm ~ 1,
           locations = sea_level_2000_sp,
           newdata = grd,
           idp = .2,
           maxdist = 15)

plot(idw_dist15,
     main = "IDW: distance = 15 degrees, power = .2")
```


<div class="notice--info" markdown="1">

## Interpolation Resources

* [More on interpolation in R](http://rspatial.org/analysis/rst/4-interpolation.html)
* [An overview of interpolators](http://neondataskills.org/spatial-data/spatial-interpolation-basics)
* [Nice tutorial on kriging](https://rpubs.com/nabilabd/118172)
8 [Spatial R tutorial - by the people who created / maintain many of the key raster packages ](http://rspatial.org/analysis/rst/4-interpolation.html#data-preparation)
* [A dated but still VERY nice overall spatial tutorial!! ](https://pakillo.github.io/R-GIS-tutorial/#interpolation)


</div>
