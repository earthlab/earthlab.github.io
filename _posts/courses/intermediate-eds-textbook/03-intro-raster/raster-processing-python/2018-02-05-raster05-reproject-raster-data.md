---
layout: single
title: "Reproject Raster Data Python"
excerpt: "Sometimes you will work with multiple rasters that are not in the same projections, and thus, need to reproject the rasters, so they are in the same coordinate reference system. Learn how to reproject raster data in Python using Rasterio."
authors: ['Leah Wasser', 'Nathan Korinek', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-11-09
category: ['courses']
class-lesson: ['raster-processing-python']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/reproject-raster/
nav-title: 'Reproject Raster'
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
  - "/courses/earth-analytics-python/lidar-raster-data/reproject-raster/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives

* Reproject a raster in **Python** using **rasterio**.

</div>


## Reprojecting 

Sometimes you your raster data are not all in the same Coordinate Reference Systems (CRS).
When this happens, you may need to reproject your data from it's current CRS to match the 
CRS of other data that you are using. 

<i class="fa fa-star"></i> **Data Tip:** Proceed with caution when you are reprojecting raster data. Often it's best to 
reproject your vector data as reprojecting a raster means that the entire dataset are 
interpolated and cast into a new grid system. This adds error and uncertainty to your analysis. There are times when you need to reproject your data. However, consider carefully whether
you need to do this, before implementimg it in an analysis.
{: .notice--success}

Below you will learn how to reproject raster data to another crs using both a CRS string 
that you create using the **rasterio CRS** module and using the crs object from another 
spatial layer. 

{:.input}
```python
import os

import matplotlib.pyplot as plt
import numpy as np
import geopandas as gpd
from rasterio.crs import CRS
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



In this lesson, you have a few different layers that are in different 
coordinate reference systems

1. Boulder County Roads: You have a shapefile representing roads in Boulder County, Colorado
2. You have a AOI extent that represents your study area in Boulder, Colorado
3. You have a raster layer for that study area.

Typically, when it is possible, you want to avoid reprojecting raster data.
It's often easier and carries less error when you reproject the vector layers.
However, in this lesson the goal is to learn how to reproject raster data.
As such, for this lesson you will reproject a raster layer to align with 
the CRS of your vector data.

To begin, open up the road centerline data for Boulder, Colorado.
Take note of the CRS of the road centerlines vector data. 


{:.input}
```python
# Get data from Boulder Open Data portal
boulder_roads = gpd.read_file(
    "https://opendata.arcgis.com/datasets/5388d74deeb8450e8b0a45a542488ec8_0.geojson")

boulder_roads.crs
```

{:.output}
{:.execute_result}



    <Geographic 2D CRS: EPSG:4326>
    Name: WGS 84
    Axis Info [ellipsoidal]:
    - Lat[north]: Geodetic latitude (degree)
    - Lon[east]: Geodetic longitude (degree)
    Area of Use:
    - name: World
    - bounds: (-180.0, -90.0, 180.0, 90.0)
    Datum: World Geodetic System 1984
    - Ellipsoid: WGS 84
    - Prime Meridian: Greenwich





Next, open up a shapefile that you will use to clip the 
vector data opened above to the extent of your study area
which is LeeHill Road in Boulder, Colorado.


{:.input}
```python
# Clip the boulder data to the extent of the study area aoo
aoi_path = os.path.join("colorado-flood",
                        "spatial",
                        "boulder-leehill-rd",
                        "clip-extent.shp")

# Open crop extent (your study area extent boundary)
crop_extent = gpd.read_file(aoi_path)
# Reproject the crop extent data to match the roads layer.
crop_extent_wgs84 = crop_extent.to_crs(boulder_roads.crs)

# Clip the buildings and roads to the extent of the study area using geopandas
roads_clip = gpd.clip(boulder_roads, crop_extent_wgs84)
```

{:.input}
```python
# Plot the clipped data
f, ax = plt.subplots(figsize=(10, 4))

crop_extent_wgs84.plot(ax=ax,
                       edgecolor="blue",
                       color="white")

roads_clip.plot(ax=ax,
                color="grey")
ax.set(title="Plot of study area with roads")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster05-reproject-raster-data/2018-02-05-raster05-reproject-raster-data_8_0.png" alt = "Plot showing the roads data for Boulder, County, Colorado clipped to your study area extent.">
<figcaption>Plot showing the roads data for Boulder, County, Colorado clipped to your study area extent.</figcaption>

</figure>




### Open Up Your Raster Data

Next, you will open up the digital terrain model for your study area.
Note the CRS of your raster data which is UTM zone 13  epgs `32613`.

{:.input}
```python
# Open up a DTM
lidar_dem_path = os.path.join("colorado-flood",
                              "spatial",
                              "boulder-leehill-rd",
                              "pre-flood",
                              "lidar",
                              "pre_DTM.tif")

lidar_dem = rxr.open_rasterio(lidar_dem_path,
                              masked=True).squeeze()
# CHeck the CRS
lidar_dem.rio.crs
```

{:.output}
{:.execute_result}



    CRS.from_epsg(32613)





Below you plot your data. Notice that the data in the plot do not 
line up as you need it to for processing.

{:.input}
```python
# When you try to overlay the building footprints the data don't line up
f, ax = plt.subplots()
lidar_dem.plot.imshow(ax=ax,
                      cmap='Greys')
roads_clip.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster05-reproject-raster-data/2018-02-05-raster05-reproject-raster-data_12_0.png" alt = "Plot showing what happens when the data are not in the same CRS. The data do not plot properly.">
<figcaption>Plot showing what happens when the data are not in the same CRS. The data do not plot properly.</figcaption>

</figure>




## Reproject Your Raster Data Using RioXarray

You can reproject your data using the crs of the roads data using `rioxarray`.
Below, you reproject your data using:

`xarray-object-name.rio.reproject(crs-value-here)`

You can provide the crs by

1. grabbing the CRS of another spatial layer 
2. as an Proj4 string 

Below you use the crs value for the Geopandas layer that you opened above. 

{:.input}
```python
# Reproject the data using the crs from the roads layer
lidar_dem_wgs84 = lidar_dem.rio.reproject(roads_clip.crs)
lidar_dem_wgs84.rio.crs
```

{:.output}
{:.execute_result}



    CRS.from_epsg(4326)





Below you reproject the same data using a Proj4 string.
Note that either approach will work well. This lesson simply
shows you both options!

{:.input}
```python
# Reproject the data to another crs - 4326?

# Create a rasterio crs object for wgs 84 crs - lat / lon
crs_wgs84 = CRS.from_string('EPSG:4326')

# Reproject the data using the crs object
lidar_dem_wgs84_2 = lidar_dem.rio.reproject(crs_wgs84)
lidar_dem_wgs84_2.rio.crs
```

{:.output}
{:.execute_result}



    CRS.from_epsg(4326)





Once the data have been reprojected, you can plot the 
DEM with the roads layer and it will line up.

{:.input}
```python
# Plot your newly converted data
f, ax = plt.subplots(figsize=(10, 4))

lidar_dem_wgs84.plot.imshow(ax=ax,
                            cmap='Greys')
roads_clip.plot(ax=ax)
ax.set(title="Plot Showing Roads Overlayed on Elevation Data")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster05-reproject-raster-data/2018-02-05-raster05-reproject-raster-data_18_0.png" alt = "Plot showing your final data - reprojected raster data with roads overlayed on top.">
<figcaption>Plot showing your final data - reprojected raster data with roads overlayed on top.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge: Reproject a Hillshade Layer

Below there is code to open up a hillshade for this 
same study area. Reproject the hillshade object using rioxarray. 
Then add it to the map that you created above as an underlay. 

HINT: you can set the `alpha=` parameter to a value less than 1 
to add transparency to a layer in your plot. 

Your final plot should look like the one below: 

</div>

{:.input}
```python
# Open up a hillshade
lidar_dem_path_hill = os.path.join("colorado-flood",
                                   "spatial",
                                   "boulder-leehill-rd",
                                   "pre-flood",
                                   "lidar",
                                   "pre_DTM_hill.tif")

lidar_dem_hill = rxr.open_rasterio(lidar_dem_path_hill,
                                   masked=True).squeeze()
# CHeck the CRS
lidar_dem_hill.rio.crs
```

{:.output}
{:.execute_result}



    CRS.from_epsg(32613)






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster05-reproject-raster-data/2018-02-05-raster05-reproject-raster-data_21_0.png" alt = "Final plot showing the reprojected data with a reprojected hillshade layer.">
<figcaption>Final plot showing the reprojected data with a reprojected hillshade layer.</figcaption>

</figure>











