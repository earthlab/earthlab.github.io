---
layout: single
title: "Intro to Raster Data in R"
authors: [Leah Wasser]
contributors: [NEON Data Skills]
dateCreated: 2016-09-23
lastModified: 2016-11-29
packagesLibraries: [raster, rgdal, sp]
category: [course-materials]
excerpt: "This tutorial introduces the raster data format, stored in .GeoTIFF
format."
permalink: course-materials/spatial-data/about-raster-data
class-lesson: ['intro-spatial-data-r']
author_profile: false
sidebar:
  nav:
nav-title: 'raster intro'
comments: false
order: 4
---


This tutorial introduces the raster data format, stored in .GeoTIFF
format.

**R Skill Level:** Beginner

<div class="notice--success" markdown="1">


# Goals / Objectives

After completing this activity, you will:

* Understand the basic structure of a GeoTiff file as a key raster spatial data
format.

### Install R Packages

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`


****

### Additional Resources

* Wikipedia article on
<a href="https://en.wikipedia.org/wiki/GIS_file_formats" target="_blank">
GIS file formats.</a>

</div>



In this tutorial, we will focus on raster spatial data.


## Raster Data

Raster or "gridded" data are saved on a uniform grid and rendered on a map
as pixels. Each pixel contains a value that represents an area on the Earth's
surface.

<figure>
    <a href="{{site.baseurl}}/images/dc-spatial-intro/raster_concept.png">
    <img src="{{site.baseurl}}/images/dc-spatial-intro/raster_concept.png">
    </a>
    <figcaption> Source: National Ecological Observatory Network (NEON)
    </figcaption>
</figure>


### GeoTIFF

There are many different raster data file formats. In this tutorial series, we
will focus on the `GeoTIFF`. The `GeoTIFF` format is similar to the `.tif`
format, however the `GeoTIFF` format stores additional spatial `metadata`.


```r

# view attributes for a geotif file
GDALinfo("NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
## rows        1367 
## columns     1697 
## bands       1 
## lower left origin.x        731453 
## lower left origin.y        4712471 
## res.x       1 
## res.y       1 
## ysign       -1 
## oblique.x   0 
## oblique.y   0 
## driver      GTiff 
## projection  +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs 
## file        NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif 
## apparent band summary:
##    GDType hasNoDataValue NoDataValue blockSize1 blockSize2
## 1 Float64           TRUE       -9999          1       1697
## apparent band statistics:
##   Bmin  Bmax   Bmean      Bsd
## 1    0 38.17 18.0978 5.321834
## Metadata:
## AREA_OR_POINT=Area

# import geotiff
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


### Metadata in .tif Files

The `tif` and `GeoTIFF` formats stores `metadata` as embedded `tif tags`. These
tags can include the following raster metadata:

1. A Coordinate Reference System (`CRS`)
2. Spatial Extent (`extent`)
3. Values for when no data is provided (`NoData Value`)
4. The `resolution` of the data


We will explore metadata in tif files in the next, tutorial -
[Spatial Intro 03: Data About Data -- Intro to Metadata File Formats and Structure]({{ site.baseurl }}R/metadata-file-formats-structures)

IMPORTANT: just because a `.tif` file can store metadata tags, doesn't mean
that metadata are always included! If the data creator doesn't actively add
`.tif` tags, then they may not be there for us to use.

### Metadata - Saving .tif Files in R

In `R`, and many other `GIS` tools, it's important to ensure that `.tif` tags
are properly saved when you export a `.tif`. For example, when using the
`writeRaster()`function in `R`, if you do not specify the `NA` (noData) value
when you export a GeoTIFF, it will default to a different value which could be
read incorrectly in other programs!


```r
# if you want a NA value of -9999, then you have to specify this when you
# export a raster file in R
exampleRaster <- writeRaster(rasterObject,  # object to export/write
                             FileName.tif,  # name of new .tif file
                             datatype = "INT1U",  # the data type
                             NAflag = -9999)  # your desired NA or noData value
```

We cover writing `NA` values using the `writeRaster` function in R in
[*Raster Calculations in R - Subtract One Raster from Another and Extract Pixel Values For Defined Locations* tutorial](http://neondataskills.org/R/Raster-Calculations-In-R).

<i class="fa fa-star"></i> **Data Note:** `Tif tags` - metadata tags stored
within a `tif` or `GeoTIFF` file are also what your camera uses to store
information about how and when a picture was taken! And how your computer reads
this metadata and identifies, for example, the make and model of the camera or
the date the photo was taken.
{: .notice}

### Other Raster File Formats

* **.asc:** A comma separated text file with a spatial heading.
* **Hierarchical Data Format (HDF5):** An open file format that supports large,
complex, heterogeneous data. More on HDF5 formated rasters can be found in the
NEON Data Skills [tutorials focusing on HDF5](http://neondataskills.org/HDF5/).
* **.grd:** An ESRI specific raster format.
* **netCDF:**
    + <a href="http://www.unidata.ucar.edu/software/netcdf/docs/faq.html" target="_blank">About netCDF (UCAR)</a>
    + <a href="https://publicwiki.deltares.nl/display/OET/Creating+a+netCDF+file+with+R" target="_blank">Create netCDF in R</a>
    + <a href="http://geog.uoregon.edu/bartlein/courses/geog607/Rmd/netCDF_01.htm" target="_blank">A tutorial for version 3 in R</a>
* **GRIB:** <a href="http://luckgrib.com/tutorials/2015/07/23/what-is-grib.html" target="_blank">What is Grib?</a>
