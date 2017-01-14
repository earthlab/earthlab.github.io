---
title: "Key Spatial Attributes - About Spatial Resolution and Extent"
authors: [Leah Wasser]
contributors: [NEON Data Skills]
dateCreated: 2015-10-23
lastModified: 2016-11-29
packagesLibraries: [ ]
category: [course-materials]
excerpt: "This lesson reviews spatial resolution and extent - two key attributes
of spatial data."
permalink: course-materials/spatial-data/spatial-resolution-extent
sidebar:
  nav:
class-lesson: ['intro-spatial-data-r']
author_profile: false
comments: false
nav-title: 'resolution & extent'
order: 6
---


## About

This lesson covers two key concepts that you need to understand when working with
spatial data: spatial extent and spatial resolution.

**R Skill Level:** Beginner - you've got the basics of `R` down.

<div class="notice--success" markdown="1">

# Goals / Objectives

After completing this activity, you will:

* Be able to define spatial extent.
* Be able to figure out the spatial extent of a raster and / or a vector data layer in R
* Be able to explain how the spatial extent of a raster data layer is defined.


## Things You’ll Need To Complete This Lesson
To complete this lesson you will need the most current version of `R`, and
preferably, `RStudio` loaded on your computer.

### Install R Packages

* **Raster:** `install.packages("raster")`

### Download Data


****

### Additional Resources
* Read more on coordinate reference systems in the
<a href="http://docs.qgis.org/2.0/en/docs/gentle_gis_introduction/coordinate_reference_systems.html" target="_blank">
QGIS documentation.</a>
* NEON Data Skills Lesson <a href="{{ site.baseurl }}/GIS-Spatial-Data/Working-With-Rasters/" target="_blank">The Relationship Between Raster Resolution, Spatial extent & Number of Pixels - in R</a>

</div>

## Spatial Metadata
There are three core spatial metadata elements that are crucial to understand
in order to effectively work with spatial data:

* **Extent**
* **Resolution**
* **Coordinate Reference System** (CRS)

In this lesson, we will talk about `extent` and `resolution`. In the following
lesson, we will cover coordinate reference systems.

## Spatial Extent

The spatial extent of a spatial object represents how much area it covers. For example,
the boundary of the city of Paris, located within the country of France, has a
smaller spatial extent than the boundary of France.



### Extent in Vector Data

<figure>
    <a href="{{ site.url }}{{ site.baseurl }}/images/dc-spatial-intro/spatial-extent-vector.png">
    <img src="{{ site.url }}{{ site.baseurl }}/images/dc-spatial-intro/spatial-extent-vector.png"></a>
    <figcaption>The spatial extent of a vector layer, represents the outer most
    top bottom left and right (north, south, east and west) coordinates of the
    vector layer. This area in turn relates to the area on the ground that the data
    layer covers.</figcaption>
</figure>

### Extent in Raster Data
The spatial extent of a raster, represents the x, y coordinates of the corners
of the raster in geographic space. This information, in addition to the cell
size or spatial resolution, tells the program how to place or render each pixel
in 2 dimensional space.  Tools like `R`, using supporting packages such as
`rgdal`, and associated raster tools have functions that allow you to view and
define the extent of a new raster.


```r

# load raster library
library(raster)
library(rgdal)

# import canopy height model
chm_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")

# View the extent of the raster
chm_HARV@extent
## class       : Extent 
## xmin        : 731453 
## xmax        : 733150 
## ymin        : 4712471 
## ymax        : 4713838
```

<figure>
    <a href="{{ site.baseurl }}/images/dc-spatial-intro/pixelDetail.png">
    <img src="{{ site.baseurl }}/images/dc-spatial-intro/pixelDetail.png"></a>
    <figcaption>The spatial resolution of a raster refers the size of each cell
    in meters. This size in turn relates to the area on the ground that the pixel
    represents.</figcaption>
</figure>


<figure>
    <a href="{{ site.url }}{{ site.baseurl }}/images/dc-spatial-intro/raster2.png">
    <img src="{{ site.url }}{{ site.baseurl }}/images/dc-spatial-intro/raster2.png"></a>
    <figcaption>If you double the extent value of a raster - the pixels will be
    stretched over the larger area making it look more "blury".
    </figcaption>
</figure>


### How to Calculate Raster Extent

To calculate the extent of a raster, we first need the bottom left X, Y
coordinate of the raster. In the case of the UTM coordinate system which is in
meters, to calculate the raster's extent, we can add the number of columns and
rows to the X, Y corner
coordinate location of the raster, multiplied by the resolution (the pixel size)
of the raster.

Let's explore that next.


```r
# create a raster from the matrix
myRaster1 <- raster(nrow=4, ncol=4)

# assign some random data to the raster
myRaster1[]<- 1:ncell(myRaster1)

# view attributes of the raster
myRaster1
## class       : RasterLayer 
## dimensions  : 4, 4, 16  (nrow, ncol, ncell)
## resolution  : 90, 45  (x, y)
## extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 
## data source : in memory
## names       : layer 
## values      : 1, 16  (min, max)

# is the CRS defined?
myRaster1@crs
## CRS arguments:
##  +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0

# what are the data extents?
myRaster1@extent
## class       : Extent 
## xmin        : -180 
## xmax        : 180 
## ymin        : -90 
## ymax        : 90
plot(myRaster1, main="Raster with 16 pixels")
```

![ ]({{ site.baseurl }}/images/rfigs/dc-spatial-intro/06-spatial-resolution-extent/calculate-raster-extent-1.png)

### Units
The units of the extent are defined by the coordinate reference system that the
spatial data are in.

## Spatial Resolution
A raster consists of a series of pixels, each with the same dimensions
and shape. In the case of rasters derived from airborne sensors, each pixel
represents an area of space on the Earth's surface. The size of the area on the
surface that each pixel covers is known as the spatial resolution of the image.
For instance, an image that has a 1 m spatial resolution means that each pixel in
the image represents a 1 m x 1 m area.

<figure>
    <a href="{{ site.baseurl }}/images/hyperspectral/pixelDetail.png">
    <img src="{{ site.baseurl }}/images/hyperspectral/pixelDetail.png"></a>
    <figcaption>The spatial resolution of a raster refers the size of each cell
    in meters. This size in turn relates to the area on the ground that the pixel
    represents.</figcaption>
</figure>


<figure>
    <a href="{{ site.url }}{{ site.baseurl }}/images/dc-spatial-intro/raster-resolution.png">
    <img src="{{ site.url }}{{ site.baseurl }}/images/dc-spatial-intro/raster-resolution.png"></a>
    <figcaption>A raster at the same extent with more pixels will have a higher
    resolution (it looks more "crisp"). A raster that is stretched over the same
    extent with fewer pixels will look more blury and will be of lower resolution.
    </figcaption>
</figure>

Let's open up a raster in `R` to see how the attributes are stored.


```r


# import canopy height model
chm_HARV <- raster("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")

chm_HARV
## class       : RasterLayer 
## dimensions  : 1367, 1697, 2319799  (nrow, ncol, ncell)
## resolution  : 1, 1  (x, y)
## extent      : 731453, 733150, 4712471, 4713838  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
## data source : /Users/lewa8222/Documents/data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif 
## names       : HARV_chmCrop 
## values      : 0, 38.17  (min, max)
```

Notice that this raster (in GeoTIFF format) already has defined:

* extent
* resolution (1 in both x and y directions), and
* CRS (units in meters).


For more on the relationship between extent & resolution, visit

http://neondataskills.org/GIS-Spatial-Data/Working-With-Rasters/

***
***

## Additional Resources

* ESRI help on CRS
* QGIS help on CRS
* NCEAS cheatsheets
