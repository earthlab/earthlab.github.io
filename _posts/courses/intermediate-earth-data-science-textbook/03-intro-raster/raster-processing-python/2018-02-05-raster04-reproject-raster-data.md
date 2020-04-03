---
layout: single
title: "Reproject Raster Data Python"
excerpt: "Sometimes you will work with multiple rasters that are not in the same projections, and thus, need to reproject the rasters, so they are in the same coordinate reference system. Learn how to reproject raster data in Python using Rasterio."
authors: ['Leah Wasser', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-03-06
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

Sometimes you will work with multiple rasters and they might not always be in the same projections. You will need to reproject the raster so they are in the same coordinate reference system.

### Reproject using Rasterio

{:.input}
```python
import os
import numpy as np
import rasterio as rio
from rasterio.warp import calculate_default_transform, reproject, Resampling
import earthpy as et

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

lidar_dem = rio.open(lidar_dem_path)
print(lidar_dem.meta)
```

{:.output}
    {'driver': 'GTiff', 'dtype': 'float32', 'nodata': -3.4028234663852886e+38, 'width': 4000, 'height': 2000, 'count': 1, 'crs': CRS.from_epsg(32613), 'transform': Affine(1.0, 0.0, 472000.0,
           0.0, -1.0, 4436000.0)}




{:.input}
```python
dst_crs = 'EPSG:3857' # CRS for web meractor 

projected_lidar_dem_path = os.path.join("data", "colorado-flood", "spatial", 
                                        "boulder-leehill-rd", "pre-flood", "lidar",
                                        "pre_DTM_reproject.tif")

with rio.open(lidar_dem_path) as src:
    transform, width, height = calculate_default_transform(
        src.crs, dst_crs, src.width, src.height, *src.bounds)
    kwargs = src.meta.copy()
    kwargs.update({
        'crs': dst_crs,
        'transform': transform,
        'width': width,
        'height': height
    })

    with rio.open(projected_lidar_dem_path, 'w', **kwargs) as dst:
        for i in range(1, src.count + 1):
            reproject(
                source=rio.band(src, i),
                destination=rio.band(dst, i),
                src_transform=src.transform,
                src_crs=src.crs,
                dst_transform=transform,
                dst_crs=dst_crs,
                resampling=Resampling.nearest)
```

{:.input}
```python
lidar_dem2 = rio.open(projected_lidar_dem_path)

print(lidar_dem2.meta)
```

{:.output}
    {'driver': 'GTiff', 'dtype': 'float32', 'nodata': -3.4028234663852886e+38, 'width': 4004, 'height': 2020, 'count': 1, 'crs': CRS.from_epsg(3857), 'transform': Affine(1.3063652820086313, 0.0, -11725101.307458913,
           0.0, -1.3063652820086313, 4876690.453258085)}



{:.input}
```python
lidar_dem2.close()
```

If you have many raster files to re-project the rasterio method has several lines of code that could get repetitive to type. Therefore your instructions have wrapped the `rasterio` reproject code into a function called `reproject_et` notice that this function contains all of the same code, but allows the input path, the output path, and the new CRS components to change every time the function is called.

{:.input}
```python
def reproject_et(inpath, outpath, new_crs):
    dst_crs = new_crs # CRS for web meractor 

    with rio.open(inpath) as src:
        transform, width, height = calculate_default_transform(
            src.crs, dst_crs, src.width, src.height, *src.bounds)
        kwargs = src.meta.copy()
        kwargs.update({
            'crs': dst_crs,
            'transform': transform,
            'width': width,
            'height': height
        })

        with rio.open(outpath, 'w', **kwargs) as dst:
            for i in range(1, src.count + 1):
                reproject(
                    source=rio.band(src, i),
                    destination=rio.band(dst, i),
                    src_transform=src.transform,
                    src_crs=src.crs,
                    dst_transform=transform,
                    dst_crs=dst_crs,
                    resampling=Resampling.nearest)
```

{:.input}
```python
reproject_et(inpath = os.path.join("data", "colorado-flood", "spatial", 
                                   "boulder-leehill-rd", "pre-flood", "lidar", "pre_DTM.tif"), 
             outpath = os.path.join("data", "colorado-flood", "spatial", 
                                    "boulder-leehill-rd", "pre-flood", "lidar", "pre_DTM_reproject_2.tif"), 
             new_crs = 'EPSG:3857')
```

{:.input}
```python
projected_lidar_dem_path = os.path.join("data", "colorado-flood", "spatial", 
                                        "boulder-leehill-rd", "pre-flood", "lidar",
                                        "pre_DTM_reproject_2.tif")

# Check to make sure function worked, then close raster
lidar_dem3 = rio.open(projected_lidar_dem_path)
print(lidar_dem3.meta)

lidar_dem3.close()
```

{:.output}
    {'driver': 'GTiff', 'dtype': 'float32', 'nodata': -3.4028234663852886e+38, 'width': 4004, 'height': 2020, 'count': 1, 'crs': CRS.from_epsg(3857), 'transform': Affine(1.3063652820086313, 0.0, -11725101.307458913,
           0.0, -1.3063652820086313, 4876690.453258085)}


