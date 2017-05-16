---
layout: single
title: "Introduction to spatial metadata embedded within tif tags - raster data in R "
excerpt: "This lesson introduces the concept of metadata - or data about the data. Metadata describe key characteristics of a data set. For spatial data these characteristics including CRS, resolution and spatial extent. Here we discuss the use of tif tags or metadata embedded within a geotiff file as they can be used to explore data programatically."
authors: ['Leah Wasser', 'NEON Data Skills']
modified: '2017-05-12'
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-3/introduction-to-spatial-metadata-r/
nav-title: 'Embedded metadata - geotiff'
week: 3
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: false
order: 5
topics:
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
  find-and-manage-data: ['metadata']
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Access metadata stored within a geotiff raster file via tif tags in R.
* Describe the difference between embedded metadata and non embedded metadata.
* Use `GDALinfo()` to quickly view key spatial metadata attributes associated with a spatial file.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>





<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-3/lidar-intro/2017-02-01-raster05-metadata-geotiff-file-format-raster-data-r/open-raster-1.png" title="raster data example of embedded metadata" alt="raster data example of embedded metadata" width="100%" />

<div class="notice--warning" markdown="1">
## Understand metadata

The figure above was created from a dataset that you are given called:
`pre_DTM.tif`. Looking at the figure, what do you know about that data? Can
you answer any of the following questions:

* What is the resolution of the data?
* What is the spatial extent (what area does the data cover)?
* Who collected the data?
* How were the data collected?

Consider these data. If you had to share this
with a colleague, what information do they need to know, to efficiently work
with it?

</div>

## What are Metadata?
To address many if not all of the questions posed above, we use metadata.
Metadata are (sometimes) structured information that describes a dataset. Metadata
can include a suite of information about the data including:

* Contact information,
* Spatial attributes including: extent, coordinate reference system, resolution,
* Data collection & processing methods,
* and much more.

Without sufficient documentation, it is difficult for us to work with external
data - data that we did not collect ourselves.

## Why Do We Need Metadata?

Looking at the map above, we are missing information needed to begin working
with the data effectively, including:

**Spatial Information**

* **Spatial Extent:** What area does this dataset cover?
* **Coordinate reference system:** What spatial projection / coordinate reference
system is used to store the data? Will it line up with other data?
* **Resolution:** The data appears to be in **raster** format. This means it is
composed of pixels. What area on the ground does each pixel cover - i.e. What is
its spatial resolution?

**Data Collection / Processing Methods**

* **When was the data collected?** Is it recent or historical?
* **How was this data generated?** Is this an output from a model, is it an image
from a remote sensing instrument such as a satellite (e.g. Landsat) or collected
from an airplane? How were the data collected?
* **Units:** We can see a scale bar of values to the right of the data, however,
what metric and in what units does this represent? Temperature? Elevation? Precipitation?
* **How were the data processed?**

**Contact Information**

* **Who created this data?**
* **Who do we contact:** We might need permission to use it, have questions
about the data, or need more information to give correct attribution.

When we are given a dataset, or when we download it online, we do not know
anything about it without proper documentation. This documentation is called
**metadata** - data about the data.

### Why Are Metadata Needed?

We need metadata to understand how to work with our data. FOr example we may need
to know what the spatial resolution is (pixel size) of a raster. The metadata
can provide this information. When metadata are embedded
in a file or in provided in a machine readable format, we can access it directly
in tools like `R` or `Python` to support automated workflows.

## Metadata Formats

Metadata come in different formats. In this lesson we will focus on structured
metadata associated with the geotiff file format. However below we mention
several different structures that can be used to format metadata:

* **Structured Embedded Metadata:** Some file formats supported embedded
metadata which you can access from a tool like `R` or `Python` directly from the
imported data (e.g. **GeoTIFF** and **HDF5**). This data is contained in the same
file (or file set as for shapefiles) as the data.
* **Structured Metadata Files:** Structured metadata files, such as the
Ecological Metadata Language (**EML**), are stored in a machine readable format
which means they can be accessed using a tool like `R` or `Python`. These files
must be shared with and accompany the separate data files. There are
different file formats and standards so it's important to understand that
standards will vary.
* **Unstructured Metadata Files:** This broad group includes text files,
web pages and other documentation that does not follow a particular standard or
format, but documents key attributes required to work with the data.

Structured metadata formats are ideal if you can find them because they are most
often:

* In a standard, documented format that others use.
* Are machine readable which means you can use them in scripts and algorithms.

<i class="fa fa-star"></i> **Data Note:** When you find metadata stored on a website
for a dataset that you are working with, **DOWNLOAD AND SAVE IT** immediately to
the directory on your computer where you saved the data. It is also a good idea to document
the URL where you found the metadata and the data in a "readme" text file that
is also stored with the data!
{: .notice}


## Embedded Metadata - GeoTIFF

If we want to automate workflows, it's ideal for key metadata required to
process our data to be embedded directly in our data files. The **GeoTIFF**
(`fileName.tif`) is one common spatial data format that can store
**metadata** directly in the `.tif` file itself.

### What is a GeoTIFF??

A **GeoTIFF** file stores metadata or attributes about the file as embedded
`tif tags`. A GeoTIFF is a standard `.tif` image format with additional spatial
(georeferencing) information embedded in the file as tags. These tags can
include the following raster metadata:

1. A Coordinate Reference System (`crs()`)
2. Spatial Extent (`extent()`)
3. Values for when no data is provided (NoData Value)
4. The resolution of the data

<i class="fa fa-star"></i> **Data Note:**  Your camera uses embedded tags to store
information about pictures that you take including the camera make and model,
and the time the image was taken.
{: .notice }

More about the  `.tif` format:

* <a href="https://en.wikipedia.org/wiki/GeoTIFF" target="_blank"> GeoTIFF on Wikipedia</a>
* <a href="https://trac.osgeo.org/geotiff/" target="_blank"> OSGEO TIFF documentation</a>


The `raster` package in `R` allows us to directly access `.tif tags`
programmatically. We can quickly view the spatial **extent**,
**coordinate reference system** and **resolution** of the data.

NOTE: not all geotiffs contain tif tags!


In the previous lesson we were actually exploring the metadata associated with
our lidar derived rasters. Let's have a look.



```r
# view attributes associated with our DTM geotiff
GDALinfo("data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")
## rows        2000 
## columns     4000 
## bands       1 
## lower left origin.x        472000 
## lower left origin.y        4434000 
## res.x       1 
## res.y       1 
## ysign       -1 
## oblique.x   0 
## oblique.y   0 
## driver      GTiff 
## projection  +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs 
## file        data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif 
## apparent band summary:
##    GDType hasNoDataValue   NoDataValue blockSize1 blockSize2
## 1 Float32           TRUE -3.402823e+38        128        128
## apparent band statistics:
##          Bmin       Bmax Bmean Bsd
## 1 -4294967295 4294967295    NA  NA
## Metadata:
## AREA_OR_POINT=Area
```

Note that we can use the GDALinfo() function to look at the key spatial tif tags
associated with our raster including:

* x and y resolution
* projection
* data format (in this case our data are stored in float format which means they contain decimals)

and more.

We can also extract individual metadata attributes.


```r
# view attributes / metadata of raster
# open raster data
lidar_dem <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DTM.tif")
# view crs
crs(lidar_dem)
## CRS arguments:
##  +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

# view extent
lidar_dem@extent
## class       : Extent 
## xmin        : 472000 
## xmax        : 476000 
## ymin        : 4434000 
## ymax        : 4436000
```

If we extract metadata from our data, we can then perform tests on the data as
we process it. For instance, we can ask the question:

> do both datasets in the same spatial extent?

Let's find out the answer to this question this using R.


```r
lidar_dsm <- raster(x="data/week3/BLDR_LeeHill/pre-flood/lidar/pre_DSM.tif")

extent_lidar_dsm <- extent(lidar_dsm)
extent_lidar_dem <- extent(lidar_dem)

# Do the two datasets cover the same spatial extents?
if(extent_lidar_dem == extent_lidar_dsm){
  print("Both datasets cover the same spatial extent")
}
## [1] "Both datasets cover the same spatial extent"
```

There is a lot more to metadata than covered in this lesson. We will explore
understanding metadata associated with other data types in later weeks of this course.
