---
layout: single
title: "Spatial Raster Metadata: CRS, Resolution, and Extent in Python"
excerpt: "Raster metadata includes the coordinate reference system (CRS), resolution, and spatial extent. Learn about these metadata and how to access them in Python"
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-04-07
category: [courses]
class-lesson: ['intro-raster-python-tb']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/raster-metadata-in-python/
nav-title: 'Raster Metadata'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: false
order: 2
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/raster-metadata-in-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Be able to define 3 spatial attributes of a raster dataset: extent, coordinate reference system and resolution.
* Access spatial metadata of a raster dataset in **Python**.

</div>

On this page, you will learn about three important spatial attributes associated with raster data that in this lesson: coordinate reference systems (CRS), resolution, and spatial extent. 

## 1. Coordinate Reference System

The Coordinate Reference System or `CRS` of a spatial object tells `Python` where
the raster is located in geographic space. It also tells `Python` what mathematical method should
be used to “flatten” or project the raster in geographic space.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg" alt="Maps of the United States in different projections. Notice the
    differences in shape associated with each different projection. These
    differences are a direct result of the calculations used to 'flatten' the
    data onto a 2-dimensional map. Source: M. Corey, opennews.org">
    </a>
    <figcaption> Maps of the United States in different projections. Notice the
    differences in shape associated with each different projection. These
    differences are a direct result of the calculations used to "flatten" the
    data onto a 2-dimensional map. Source: M. Corey, opennews.org</figcaption>
</figure>

### What Makes Spatial Data Line Up On A Map?

You will discuss Coordinate Reference systems in more detail in next weeks class.
For this week, just remember that data from the same location
but saved in **different coordinate references systems will not line up in any GIS or other
program**. 

Thus, it's important when working with spatial data in a program like
`Python` to identify the coordinate reference system applied to the data and retain
it throughout data processing and analysis.

### View Raster Coordinate Reference System (CRS) in Python

You can view the `CRS` string associated with your `Python` object using the`crs()`
method. 

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import numpy as np
from shapely.geometry import Polygon, mapping
import rasterio as rio
from rasterio.mask import mask
from rasterio.plot import show

# Package created for the earth analytics program
import earthpy as et
```

{:.input}
```python
# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.input}
```python
# Define relative path to file
lidar_dem_path = os.path.join("data", "colorado-flood", "spatial", 
                              "boulder-leehill-rd", "pre-flood", "lidar",
                              "pre_DTM.tif")

# View crs of raster imported with rasterio
with rio.open(lidar_dem_path) as src:
    print(src.crs)
```

{:.output}
    EPSG:32613



You can assign this string to a **Python** object, too.

{:.input}
```python
# Assign crs to myCRS object
myCRS = src.crs

myCRS
```

{:.output}
{:.execute_result}



    CRS.from_epsg(32613)





The `CRS` EPSG code for your `lidar_dem` object  is 32613. 
Next, you can look that EPSG code up on the <a href="http://www.spatialreference.org/ref/epsg/32613/" target="_blank">spatial reference.org website</a> to figure out what CRS it refers to and the associated units. In this case you are using UTM zone 13 North.

Digging deeper <a href="http://www.spatialreference.org/ref/epsg/32613/proj4/" target="_blank">you can view the proj 4 string </a> which tells us that the horizontal units of this project are in meters (`m`). 

<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/UTM-zones.png">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/UTM-zones.png" alt="The UTM zones across the continental United States. Source:
   	Chrismurf, wikimedia.org."></a>
   	<figcaption> The UTM zones across the continental United States. Source:
   	Chrismurf, wikimedia.org.
		</figcaption>
</figure>

The CRS format, returned by python, is in a `EPSG` format. This means that the projection
information is represented by a single number. However on the spatialreference.org website you can also view the proj4 string which will tell you a bit more about the horizontal units that the data are in. An overview of proj4 is below. 

 `+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0`
 
## Converting EPSG to Proj4 in Python

A python package for this class called 'earthpy' contains a dictionary that will help you convert EPSG codes into a Proj4 string. This can be used with **rasterio** in order to determine the metadata for a given EPSG code. For example, if you wish to know the units of the EPSG code above, you can do the following:

{:.input}
```python
# Each key of the dictionary is an EPSG code
print(list(et.epsg.keys())[:10])
```

{:.output}
    ['29188', '26733', '24600', '32189', '4899', '29189', '26734', '7402', '26951', '29190']



{:.input}
```python
# You can convert to proj4 like so:
proj4 = et.epsg['32613']
print(proj4)
```

{:.output}
    +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs



{:.input}
```python
# Finally you can convert this into a rasterio CRS like so:
crs_proj4 = rio.crs.CRS.from_string(proj4)
crs_proj4
```

{:.output}
{:.execute_result}



    CRS.from_epsg(32613)





You'll focus on the first few components of the CRS in this tutorial.

* `+proj=utm` The projection of the dataset. Your data are in Universal
Transverse Mercator (UTM).
* `+zone=18` The UTM projection divides up the world into zones, this element
tells you which zone the data is in. Harvard Forest is in Zone 18.
* `+datum=WGS84` The datum was used to define the center point of the
projection. Your raster uses the `WGS84` datum.
* `+units=m` This is the **horizontal** units that the data are in. Your units
are meters.


<div class="notice--success" markdown="1">
<i fa fa-star></i>**Important:**
You are working with lidar data which has a Z or vertical value as well.
While the horizontal units often match the vertical units of a raster they don't
always! Be sure the check the metadata of your data to figure out the vertical
units!
</div>

## Spatial Extent

Next, you'll learn about spatial extent of your raster data. The spatial extent of a raster or spatial
object is the geographic area that the raster data covers.
<figure>
    <a href="{{ site.baseurl}}/images/earth-analytics/raster-data/raster-spatial-extent-coordinates.png">
    <img src="{{ site.baseurl}}/images/earth-analytics/raster-data/raster-spatial-extent-coordinates.png" alt="The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated
    in some way) the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON).">
    </a>
    <figcaption> The spatial extent of raster data.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON).
    </figcaption>
</figure>


<figure>
    <a href="{{ site.baseurl}}/images/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.baseurl}}/images/earth-analytics/spatial-data/spatial-extent.png" alt="The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON)">
    </a>
    <figcaption> The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON)
    </figcaption>
</figure>

The spatial extent of an `Python` spatial object represents the geographic "edge" or
location that is the furthest north, south, east and west. In other words, `extent`
represents the overall geographic coverage of the spatial object.

You can access the spatial extent using the `.bounds` attribute in `rasterio`.

{:.input}
```python
src.bounds
```

{:.output}
{:.execute_result}



    BoundingBox(left=472000.0, bottom=4434000.0, right=476000.0, top=4436000.0)





## Raster Resolution

A raster has horizontal (x and y) resolution. This resolution represents the
area on the ground that each pixel covers. The units for your data are in meters as determined by the CRS above.
In this case, your data resolution is 1 x 1. This means that each pixel represents
a 1 x 1 meter area on the ground. You can view the resolution of your data using the `.res` function.

{:.input}
```python
# What is the x and y resolution for your raster data?
src.res
```

{:.output}
{:.execute_result}



    (1.0, 1.0)




