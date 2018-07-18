---
layout: single
category: [courses]
title: "How to Reproject Vector Data in Python Using Geopandas - GIS in Python"
excerpt: "Sometimes two shapefiles do not line up properly even if they cover the same area because they are in different coordinate reference systems. Learn how to reproject vector data in Python using geopandas to ensure your data line up."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-07-18
module-type: 'workshop'
module: "spatial-data-open-source-python"
permalink: /workshops/gis-open-source-python/reproject-vector-data-in-python/
nav-title: 'Reproject Vector Data'
sidebar:
  nav:
author_profile: false
comments: true
order: 5
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Reproject a vector dataset to another `CRS` in `Python`
* Identify the `CRS` of a spatial dataset in `Python`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12447845){:data-proofer-ignore='' .btn }

</div>





## Data in Different Coordinate Reference Systems

Often when data do not line up properly, it is because they are in different 
coordinate reference systems (CRS). In this lesson you will learn how to reproject 
data from one CRS to another - so that the data line up properly. 

You will use the `geopandas`, `numpy` and `matplotlib` libraries in this tutorial.

## Working With Spatial Data From Different Sources
You often need to gather spatial datasets for from
different sources and/or data that cover different spatial `extents`. Spatial
data from different sources and that cover different extents are often in
different Coordinate Reference Systems (CRS).

Some reasons for data being in different CRSs include:

1. The data are stored in a particular CRS convention used by the data
provider which might be a federal agency, or a state planning office.
2. The data are stored in a particular CRS that is customized to a region.
For instance, many states prefer to use a **State Plane** projection customized
for that state.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg" alt="Maps of the United States using data in different projections.">
    </a>

    <figcaption>Maps of the United States using data in different projections.
    Notice the differences in shape associated with each different projection.
    These differences are a direct result of the calculations used to "flatten"
    the data onto a 2-dimensional map. Often data are stored purposefully in a
    particular projection that optimizes the relative shape and size of
    surrounding geographic boundaries (states, counties, countries, etc).
    Source: opennews.org</figcaption>
</figure>

To get started, import the libraries you will need for this lesson into `python`. 

{:.input}
```python
import geopandas as gpd
import numpy as np
import matplotlib.pyplot as plt
import os 
import earthpy as et 
plt.ion()
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

View the CRS of each layer.


{:.input}
```python
# import the data
sjer_roads = gpd.read_file("data/spatial-vector-lidar/california/madera-county-roads/tl_2013_06039_roads.shp")
# aoi stands for area of interest
sjer_aoi = gpd.read_file("data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_crop.shp")

# view the coordinate reference system of both layers 
print(sjer_roads.crs)
print(sjer_aoi.crs)
```

{:.output}
    {'init': 'epsg:4269'}
    {'init': 'epsg:32611'}



Plot your data. Does anything look off?

{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize=(12, 8))

sjer_roads.plot(cmap='Greys', ax=ax, alpha=.5)
sjer_aoi.plot(ax=ax, markersize=10, color='r')

ax.set_title("Madera County Roads with SJER AOI");
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-05-reproject-vector-data-python_7_0.png)




## Different Data, Same Location, Different Spatial Extents 

Note the difference in the units for each object. The extent for
`sjer_aoi` is in UTM - yielding smaller numbers (meters). The spatial extent for the roads is latitude and longitude. 

Imagine drawing a box on a grid using these extents. The two extents DO NOT OVERLAP. Yet you know that your data should overlap. 

{:.input}
```python
print(sjer_aoi.total_bounds)
print(sjer_roads.total_bounds)
```

{:.output}
    [ 254570.567      4107303.07684455  258867.40933092 4112361.92026107]
    [-120.530241   36.771309 -119.031075   37.686847]



## Reproject Vector Data in Geopandas

To plot the data together, they need to be in the same CRS. You can change the CRS which means you are reproject the data from one CRS to another CRS using the geopandas method:

`to_crs(specify-crs-here)`

The CRS can be specified using an epsg code - as follows:

`'init': 'epsg:4269'`

The `to_crs()` function requires two inputs:

1. the name of the object that you wish to transform 
2. the CRS that you wish to transform that object to - - this can be in EPSG format or an entire project 4 string.

<i class="fa fa-star"></i> **Important:** When you reproject data you are modifying it. Thus you are introducing some uncertainty into your data. While this is a slightly less important issue when working with vector data (compared to raster), it's important to consider.
{: .notice--warning }

Often you may consider keeping the data that you are doing the analysis on in the correct projection that best relates spatially to the area that you are working in. To get to the point, be sure to use the CRS that best minimizes errors in distance/ area etc based on your analysis. 

If you are simply reprojecting to create a base map then which data set you reproject matters a lot less because no analysis is involved! However some people with a keen eye for CRSs may give you a hard time for using the wrong CRS for your study area.


<i class="fa fa-star"></i> **Data Tip:** `.to_crs()` will only work if your
original spatial object has a CRS assigned to it AND if that CRS is the
correct CRS!
{: .notice--warning }

{:.input}
```python
# reproject the aoi to match the roads layer
sjer_aoi_wgs84  = sjer_aoi.to_crs({'init': 'epsg:4269'})
```

{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize=(12, 8))

sjer_roads.plot(cmap='Greys', ax=ax, alpha=.5)
sjer_aoi_wgs84.plot(ax=ax, markersize=10, color='r')

ax.set_title("Madera County Roads with SJER AOI");
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-05-reproject-vector-data-python_12_0.png)




Great! you've now reprojected a dataset to be able to map the sjer AOI on top of the roads layer. 


What do you notice about the resultant plot? Do you see the AOI boundary in the 
California area? Is something wrong with your map?


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge
You know what to do! 

Create a map that includes the following layers:

* USA BOUNDARY: `data/spatial-vector-lidar/usa/usa-boundary-dissolved.shp`
* State Boundary: `data/spatial-vector-lidar/usa/usa-states-census-2014.shp`
* SJER AOI: `data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_crop.shp`

HINT: the AOI boundary is very small relative tot he entire united states. Try to zoom in on your map using the following code to set the x and y limits on your plot:

`ax.set(xlim=[-125, -116], ylim=[35, 40])`

You will need to fix the CRS to make this map. Then, answer the following questions:

1. What CRS does each code correspond with?
2. Is the CRS projected or geographic? (you may need to google this)

<!-- 4326 - WGS 84 geographic
32611 - UTM zone 11?? north - projected -->

</div>


{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-05-reproject-vector-data-python_15_0.png)





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

You can turn a single polygon into a point using the `.centroid()` method as follows:

sjer_aoi["geometry"].centroid

Create a plot of the United States with the SJER study site location marked as a POINT marker rather than a polygon. Your map will look like one of the ones below depending upon whether you decide to limit the x and y extents.
</div>


{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-05-reproject-vector-data-python_17_0.png)





{:.output}
{:.display_data}

![png]({{ site.url }}//images/workshops/spatial-data-python-intro/2018-07-20-spatial-05-reproject-vector-data-python_18_0.png)





<div class="notice--info" markdown="1">

## Additional Resources - CRS 

* <a href="http://proj.maptools.org/faq.html" target="_blank">More information on the proj.4 format.</a>
* <a href="http://spatialreference.org" target="_blank">An excellent CRS reference website</a>
</div>
