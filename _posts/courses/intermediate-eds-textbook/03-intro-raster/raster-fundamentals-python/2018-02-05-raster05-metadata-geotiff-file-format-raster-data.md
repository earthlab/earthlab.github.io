---
layout: single
title: "About the Geotiff (.tif) Raster File Format: Raster Data in Python"
excerpt: "Metadata describe the key characteristics of a dataset such as a raster. For spatial data, these characteristics including the coordinate reference system (CRS), resolution and spatial extent. Learn about the use of TIF tags or metadata embedded within a GeoTIFF file to explore the metadata programatically."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-06
modified: 2020-11-10
category: ['courses']
class-lesson: ['intro-raster-python-tb']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/intro-to-the-geotiff-file-format/
nav-title: 'Geotiff File Format'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: false
order: 5
topics:
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
  find-and-manage-data: ['metadata']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/intro-to-the-geotiff-file-format/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Access metadata stored within a geotiff raster file via tif tags in Python.
* Describe the difference between embedded metadata and non embedded metadata.
* Use `.meta` to quickly view key spatial metadata attributes associated with a spatial file.

</div>


## What is a GeoTIFF?

A GeoTIFF is a standard `.tif` or image file format that includes additional spatial
(georeferencing) information embedded in the .tif file as tags. These embedded
tags are called `tif tags`. These tags can include the following raster metadata:

1. **Spatial Extent:** What area does this dataset cover?
2. **Coordinate reference system:** What spatial projection / coordinate reference
system is used to store the data? Will it line up with other data?
3. **Resolution:** The data appears to be in **raster** format. This means it is
composed of pixels. What area on the ground does each pixel cover - i.e. What is
its spatial resolution?
4. **`nodata` value**
5. How many layers are in the .tif file. (more on that later)

You discussed spatial extent and resolution in the previous lesson. When you work with
geotiffs the spatial information that describes the raster data are embedded within
the file itself.

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** Your camera uses embedded tags to store
information about pictures that you take including the camera make and model,
and the time the image was taken.
</div>
{: .notice--success }

More about the  `.tif` format:

* <a href="https://en.wikipedia.org/wiki/GeoTIFF" target="_blank"> GeoTIFF on Wikipedia</a>
* <a href="https://trac.osgeo.org/geotiff/" target="_blank"> OSGEO TIFF documentation</a>

### Geotiffs in Python

The **rasterio** package in **Python** allows us to both open geotiff files and also to
directly access `.tif tags` programmatically. You can quickly view the spatial **extent**,
**coordinate reference system** and **resolution** of your raster data.

NOTE: not all GeoTIFFs contain tif tags!

{:.input}
```python
# Import necessary packages
import os
import rioxarray as rxr
import earthpy as et

# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



Next let's open up a raster file in geotiff format (.tif). 

{:.input}
```python
# Define relative path to file
lidar_dem_path = os.path.join("colorado-flood",
                              "spatial",
                              "boulder-leehill-rd",
                              "pre-flood",
                              "lidar",
                              "pre_DTM.tif")

pre_lidar_dem = rxr.open_rasterio(lidar_dem_path,
                                 masked=True)
pre_lidar_dem.rio.bounds()
```

{:.output}
{:.execute_result}



    (472000.0, 4434000.0, 476000.0, 4436000.0)





<i class = "fa fa-star"></i> **Data Tip:** Rioxarray wraps around much of the rasterio functionality. Read more about attributes associated with rasterio objects and how they map to gdal objects.
{: .notice--success }

You can view spatial attibutes associated with the raster file too. Below you explore viewing a general list of attributes and then specific attributes including number of bands and horizontal (x, y) resolution.

{:.input}
```python
# View generate metadata associated with the raster file
print("The crs of your data is:", pre_lidar_dem.rio.crs)
print("The nodatavalue of your data is:", pre_lidar_dem.rio.nodata)
print("The shape of your data is:", pre_lidar_dem.shape)
print("The spatial resolution for your data is:", pre_lidar_dem.rio.resolution())
print("The metadata for your data is:", pre_lidar_dem.attrs)
```

{:.output}
    The crs of your data is: EPSG:32613
    The nodatavalue of your data is: nan
    The shape of your data is: (1, 2000, 4000)
    The spatial resolution for your data is: (1.0, -1.0)
    The metadata for your data is: {'scale_factor': 1.0, 'add_offset': 0.0, 'grid_mapping': 'spatial_ref'}



{:.input}
```python
# What is the spatial resolution?
pre_lidar_dem.rio.resolution()
```

{:.output}
{:.execute_result}



    (1.0, -1.0)








<div class='notice--success alert alert-info' markdown="1">

The information returned from the various attributes called above includes:

* x and y resolution
* projection
* data format (in this case your data are stored in float format which means they contain decimals)

and more. You can also extract or view individual metadata attributes.
</div>

{:.input}
```python
print("The CRS of this data is: ", pre_lidar_dem.rio.crs)
print("The spatial extent of this data is: ",pre_lidar_dem.rio.bounds())
```

{:.output}
    The CRS of this data is:  EPSG:32613
    The spatial extent of this data is:  (472000.0, 4434000.0, 476000.0, 4436000.0)



If you extract metadata from your data, you can then perform tests on the data as you process it. For instance, you can ask the question: 

* Do both datasets have the same spatial extent?

Find out the answer to this question this using `Python`.

{:.input}
```python
# Define relative path to file
lidar_dsm_path = os.path.join("colorado-flood", 
                              "spatial",
                              "boulder-leehill-rd", 
                              "pre-flood", 
                              "lidar",
                              "pre_DSM.tif")

# Open lidar dsm
pre_lidar_dsm = rxr.open_rasterio(lidar_dsm_path)
```

{:.input}
```python
if pre_lidar_dem.rio.bounds() == pre_lidar_dsm.rio.bounds():
    print("Both datasets cover the same spatial extent.")
```

{:.output}
    Both datasets cover the same spatial extent.



How about resolution? Do both datasets have the same horizontal (x and y) resolution?

{:.input}
```python
# Do both layers have the same spatial resolution?
pre_lidar_dem.rio.resolution() == pre_lidar_dsm.rio.resolution()
```

{:.output}
{:.execute_result}



    True





### Extra Metadata with EPSG
EPSG is short-hand way of specifying many CRS parameters at once. Each EPSG code correspondings to a Proj4 code. In **rasterio**, more metadata is available if you use Proj4 instead of EPSG. 

To see the Proj4 parameters for a given EPSG code, you can either <a href="http://www.spatialreference.org/ref/epsg/32613/" target="_blank"> look them up online </a> or use the EPSG to Proj4 dictionary:

{:.input}
```python
# Get crs of a crs object
pre_lidar_dem.rio.crs
```

{:.output}
{:.execute_result}



    CRS.from_epsg(32613)





You can use `et.epsg` lookup to get the proj4 string for an epsg code too.
Earthpy is a python package build for you by your instructors. We are working on better documentation for it
but for the time being you will find snippets of how to use it here. 

{:.input}
```python
et.epsg['32613']
```

{:.output}
{:.execute_result}



    '+proj=utm +zone=13 +datum=WGS84 +units=m +no_defs'





## Single Layer (or Band) vs Multi-Layer (Band Geotiffs)

You will learn more about multi vs single band imagery when you work with RGB (color) imagery in later weeks
of this course. However geotiffs can also store more than one band or layer. You
can see if a raster object has more than one layer using the `.shape` attribute. The first
dimension of the `.shape` output represents the number of bands.

{:.input}
```python
print(pre_lidar_dem.shape)
```

{:.output}
    (1, 2000, 4000)



Another way to see the number of bands is to use the `.rio.count` attribute.

{:.input}
```python
# How many bands / layers does the object have?
print("Number of bands", pre_lidar_dem.rio.count)
```

{:.output}
    Number of bands 1



## Wrap Up

You've now learned how to open and explore raster format spatial data using xarray and rioxarray
in open source Python. The next lesson will allow you to practice what you've learned through
challenge activities. 

You may also choose to move on to the next chapter of this textbook which will introduce you to 
processing approaches for raster data including how to

* perform raster math (subtract one raster from another)
* clip raster data, 
* reproject raster data, and 
* classify raster data 

Using open source in **python**.
