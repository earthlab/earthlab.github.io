---
layout: single
title: "About the geotiff (.tif) raster file format - raster data in R "
excerpt: "This lesson introduces the geotiff file format. Further it introduces the
concept of metadata - or data about the data. Metadata describe key characteristics of a data set. For spatial data these characteristics including CRS, resolution and spatial extent. Here we discuss the use of tif tags or metadata embedded within a geotiff file as they can be used to explore data programatically."
authors: ['Leah Wasser', 'NEON Data Skills']
<<<<<<< HEAD:_posts/courses/earth-analytics/week03/lidar-raster-intro/2017-02-01-raster06-metadata-geotiff-file-format-raster-data-r.md
modified: '2017-08-14'
=======
modified: '2017-08-09'
>>>>>>> 3400483006d5fe55f51bb6f4628f355e2b36071c:_posts/course-materials/earth-analytics/week03/lidar-raster-intro/2017-02-01-raster06-metadata-geotiff-file-format-raster-data-r.md
category: [course-materials]
class-lesson: ['intro-lidar-raster-r']
permalink: /courses/earth-analytics/week-3/introduction-to-spatial-metadata-r/
nav-title: 'Intro to the geotiff'
week: 3
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: false
order: 3
topics:
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
  find-and-manage-data: ['metadata']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Access metadata stored within a geotiff raster file via tif tags in R
* Describe the difference between embedded metadata and non embedded metadata
* Use `GDALinfo()` to quickly view key spatial metadata attributes associated with a spatial file

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you Need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>



## What is a GeoTIFF??

A GeoTIFF is a standard `.tif` or image file format that includes additional spatial
(georeferencing) information embedded in the .tif file as tags. We call these embedded
tags, `tif tags`. These tags can include the following raster metadata:

1. **Spatial Extent:** What area does this dataset cover?
2. **Coordinate reference system:** What spatial projection / coordinate reference
system is used to store the data? Will it line up with other data?
3. **Resolution:** The data appears to be in **raster** format. This means it is
composed of pixels. What area on the ground does each pixel cover - i.e. What is
its spatial resolution?
4. **No data value**
5. **Layers:** How many layers are in the .tif file. (more on that later)

We discussed spatial extent and resolution in the previous lesson. When we work with
geotiffs the spatial information that describes the raster data are embedded within
the file itself.

<i class="fa fa-star"></i> **Data Note:**  Your camera uses embedded tags to store
information about pictures that you take including the camera make and model,
and the time the image was taken.
{: .notice--success }

More about the  `.tif` format:

* <a href="https://en.wikipedia.org/wiki/GeoTIFF" target="_blank"> GeoTIFF on Wikipedia</a>
* <a href="https://trac.osgeo.org/geotiff/" target="_blank"> OSGEO TIFF documentation</a>

### Geotiffs in R

The `raster` package in `R` allows us to both open geotiff files and also directly 
access `.tif tags` programmatically. We can quickly view the spatial **extent**,
**coordinate reference system** and **resolution** of our raster data.

NOTE: not all geotiffs contain tif tags!

We can use `GDALinfo()` to view all of the relevant tif tags embedded within a
geotiff before we open it in `R`.


```r
# view attributes associated with our DTM geotiff
GDALinfo("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")
## Error in eval(expr, envir, enclos): could not find function "GDALinfo"
```

The information returned from `GDALinfo()` includes:

* x and y resolution
* projection
* data format (in this case our data are stored in float format which means they contain decimals)

and more.

We can also extract or view individual metadata attributes.


```r
# view attributes / metadata of raster
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")
## Error in eval(expr, envir, enclos): could not find function "raster"
# view crs
crs(lidar_dem)
## Error in eval(expr, envir, enclos): could not find function "crs"

# view extent via the slot - note that slot names can change so this may not always work.
lidar_dem@extent
## Error in eval(expr, envir, enclos): object 'lidar_dem' not found
```

If we extract metadata from our data, we can then perform tests on the data as
we process it. For instance, we can ask the question:

> Do both datasets have the same spatial extent?

Let's find out the answer to this question using R.


```r
lidar_dsm <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")
## Error in eval(expr, envir, enclos): could not find function "raster"

extent_lidar_dsm <- extent(lidar_dsm)
## Error in eval(expr, envir, enclos): could not find function "extent"
extent_lidar_dem <- extent(lidar_dem)
## Error in eval(expr, envir, enclos): could not find function "extent"

# Do the two datasets cover the same spatial extents?
if(extent_lidar_dem == extent_lidar_dsm){
  print("Both datasets cover the same spatial extent")
}
## Error in eval(expr, envir, enclos): object 'extent_lidar_dem' not found
```

Does the data have the same spatial extents?


```r
compareRaster(lidar_dsm, lidar_dem,
              extent=TRUE)
## Error in eval(expr, envir, enclos): could not find function "compareRaster"
```

or resolution?


```r
compareRaster(lidar_dsm, lidar_dem,
              res=TRUE)
## Error in eval(expr, envir, enclos): could not find function "compareRaster"
```


## Single layer (or band) vs multi-layer (band geotiffs)

We will discuss this further when we work with RGB (color) imagery in later weeks
of this course, however geotiffs can also store more than one band or layer. We
can see if a raster object has more than one layer using the `nlayers()` function
in R.


```r
nlayers(lidar_dsm)
## Error in eval(expr, envir, enclos): could not find function "nlayers"
```

Now that we better understand the geotiff file format, we will work with some
other LiDAR raster data layers.
