---
layout: single
title: "How to Replace Raster Cell Values with Values from A Different Raster Data Set in Python"
excerpt: "Most remote sensing data sets contain no data values represented as nan or none in Python. This normally represents pixels that contain not valid data. Learn how to handle no data values in Python for better raster processing."
authors: ['Leah Wasser']
modified: 2018-10-23
category: [courses]
class-lesson: ['clouds-remote-sensing-python']
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/replace-raster-cell-values-in-remote-sensing-images-in-python/
nav-title: 'Replace Raster Cell Values'
week: 8
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  remote-sensing: ['landsat']
  reproducible-science-and-programming: ['python']
  earth-science: ['fire']
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Replace (masked)values in one numpy array with values in another array


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the Cold Springs Fire course data.

{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>

Sometimes you have many bad pixels in a landsat scene that you wish to replace or fill in with pixels from another scene. In this lesson you will learn how to replace pixels in one scene with those from another using Numpy. 

To begin, open both of the pre-fire raster stacks. You got the cloud free data as a part of your homework, last week. The scene with the cloud is in the cold spring fire data that you downloaded last week. 

{:.input}
```python
import numpy.ma as ma 
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import patches as mpatches
from matplotlib.colors import ListedColormap
import matplotlib as mpl
import seaborn as sns
import rasterio as rio
import geopandas as gpd
from rasterio.plot import show
from rasterio.mask import mask
from shapely.geometry import mapping, box

from glob import glob
import os
import earthpy as et
import earthpy.spatial as es

plt.ion()
sns.set_style('white')

mpl.rcParams['figure.figsize'] = (10.0, 6.0);
mpl.rcParams['axes.titlesize'] = 20
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

First, open the masked raster stack that you exported in the previous lesson. 

{:.input}
```python
path_landsat_pre_st = 'data/cold-springs-fire/outputs/all_bands_masked.tif'

# read in the pre-fire landsat data (this data has clouds)
with rio.open(path_landsat_pre_st) as ff:
    landsat_pre_cloud = ff.read(masked=True)
    landsat_cloud_bounds = ff.bounds
    landsat_cloud_crs = ff.crs
```

Plot the data to ensure it looks as it should. 

{:.input}
```python
# plot the data
bound_order = [0,2,1,3]
extent_landsat = [landsat_cloud_bounds[i] for i in bound_order]

landsat_plot_indices = [3,2,1]
land_rgb = (landsat_pre_cloud[landsat_plot_indices]).transpose(1, 2, 0)

fig, ax = plt.subplots(1, 1, figsize=(8, 6))

ax.imshow(es.bytescale(land_rgb), 
          extent=extent_landsat)
ax.set(title = "Masked Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016");
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/clouds-cloud-masks/2017-03-01-fire02-replace-na-values-in-raster-with-different-raster_6_0.png" alt = "Masked Landsat CIR Composite image for the post-Cold Springs fire on July 8, 2016.">
<figcaption>Masked Landsat CIR Composite image for the post-Cold Springs fire on July 8, 2016.</figcaption>

</figure>




### Read and Stack Cloud Free Data
Next, read in and stack the cloud free landsat data. 
Below you create a `bounds` object that contains the spatial extent of the cloud free raster. You will use this to ensure that the bounds of both datasets are the same before replacing pixel values. 

{:.input}
```python
# read in the "cloud free" landsat data that you downloaded as a part of your homework
path_landsat_pre_st_clfree = "data/cold-springs-fire/cold-springs-landsat-hw"
landsat_paths_pre_clfree = glob("data/cold-springs-landsat-hw/*band*.tif")

# stack the data
es.stack_raster_tifs(landsat_paths_pre_clfree, path_landsat_pre_st_clfree)

# read in the pre-fire landsat data (this data has clouds)
with rio.open(path_landsat_pre_st_clfree) as ff:
    landsat_pre_nocloud = ff.read(masked=True)
    landsat_clfree_bounds = ff.bounds
    landsat_clfree_crs = ff.crs
```

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)



{:.input}
```python
# next view the shape of each scene? are they the same?
landsat_clfree_bounds == landsat_cloud_bounds

```

{:.output}
{:.execute_result}



    (<shapely.geometry.polygon.Polygon at 0x169e65c18>,
     <shapely.geometry.polygon.Polygon at 0x169e65cf8>)





{:.input}
```python
cloud_free_scene_bds = box(*landsat_clfree_bounds)
 = box(*landsat_cloud_bounds)

cloud_free_scene_bds.intersects(cloudy_scene_bds)
```

{:.output}
{:.execute_result}



    True





{:.input}
```python
# plot the boundaries
x,y = cloud_free_scene_bds.exterior.xy
x1,y1 = cloudy_scene_bds.exterior.xy
fig, ax = plt.subplots(1, 1, figsize=(8, 6))
ax.plot(x, y, color='#6699cc', alpha=0.7,
    linewidth=3, solid_capstyle='round', zorder=2)
ax.plot(x1, y1, color='purple', alpha=0.7,
    linewidth=3, solid_capstyle='round', zorder=2)
ax.set_title('Do the Spatial Extents Ovelap?');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/clouds-cloud-masks/2017-03-01-fire02-replace-na-values-in-raster-with-different-raster_11_0.png" alt = "Overlapping spatial extents of the masked Landsat image and the image that will be used to fill in the masked values.">
<figcaption>Overlapping spatial extents of the masked Landsat image and the image that will be used to fill in the masked values.</figcaption>

</figure>




{:.input}
```python
# is the CRS the same in each raster?
landsat_clfree_crs == landsat_cloud_crs
landsat_cloud_crs
```

{:.output}
{:.execute_result}



    CRS({'init': 'epsg:32613'})





{:.input}
```python
landsat_pre_cloud.shape == landsat_pre_nocloud.shape
landsat_pre_cloud.shape, landsat_pre_nocloud.shape
```

{:.output}
{:.execute_result}



    ((7, 177, 246), (7, 7911, 7791))





You've now determined that

1. the data are in the same Coordinate Reference System 
2. the data have the same CRS and
3. the data do overlap (or intersect).

However they do not cover the same spatial extent. The next step is to CROP the cloud-free data (which has a larger spatial extent) to the spatial extent of the cloudy data so we can then reassign all cloud covered pixels to the values in the cloud free data (in the same location).

{:.input}
```python
# turn the cloud free data boundary into a geojson object for clipping
landsat_clouds_clip = mapping(box(*landsat_cloud_bounds))
```

{:.input}
```python
# read in the pre-fire landsat data (this data has clouds) and crop it
with rio.open(path_landsat_pre_st_clfree) as ff:
    landsat_pre_noclouds_crop, landsat_pre_meta = es.crop_image(ff, [landsat_clouds_clip])

```

{:.input}
```python
# next view the shape of each scene. are they the same?
landsat_pre_noclouds_crop.shape, landsat_pre_cloud.shape
```

{:.output}
{:.execute_result}



    ((7, 177, 246), (7, 177, 246))





{:.input}
```python
# once the data are cropped to the same extent, you can replace values using 
# get the mask layer from the pre_cloud data
mask = landsat_pre_cloud.mask

# copy the pre_cloud_data to a new array so you don't impact the original array (optional but suggested!)
landsat_pre_cloud_c = np.copy(landsat_pre_cloud)

# assign every cell in the new array that is masked to the value in the same cell location as the cloud free data
landsat_pre_cloud_c[mask] = landsat_pre_noclouds_crop[mask]

```

Finally, plot the data. Does it look like it reassigned values correctly?

{:.input}
```python
land_rgb = (landsat_pre_cloud_c[landsat_plot_indices]).transpose(1, 2, 0)

fig, ax = plt.subplots(1, 1, figsize=(8, 6))

ax.imshow(es.bytescale(land_rgb), 
          extent=extent_landsat)
ax.set(title = "Masked Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016");
ax.set_axis_off();

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/clouds-cloud-masks/2017-03-01-fire02-replace-na-values-in-raster-with-different-raster_20_0.png" alt = "Landsat CIR Composite image after replacement of masked pixel values using a cloud-free image for the post-Cold Springs fire.">
<figcaption>Landsat CIR Composite image after replacement of masked pixel values using a cloud-free image for the post-Cold Springs fire.</figcaption>

</figure>




The above answer is not perfect! You can see that the boundaries of the masked area are still visible. Also there are dark shadowed pixels that were not replaced given the raster `pixel_qa` layer did not assign those as pixels to be masked. Thus you may need to do a significant amount of further analysis to get this image to where you'd like it to be. But you at least have a start at getting there!

In the case of this class, a large enough portion of the study area is covered by clouds that it makes more sense to find a new scene with cloud cover. However, it is good to understand how to replace pixel values in the case that you may need to do so for smaller areas in the future. 


{:.input}
```python
# the code below essentially replicates the cover function in R using Numpy arrays 
import numpy as np
array_a = np.array([[[0.564,-999,-999],
 [0.234,-999,0.898],
 [-999,0.124,0.687], 
 [0.478,0.786,-999]],
 [[0.564,-999,-999],
 [0.234,-999,-999],
 [-999,-999,0.687], 
 [0.478,0.786,-999]]], np.float16)


array_b = np.array([[[0.324,0.254,0.204],
 [0.469,0.381,0.292],
 [0.550,0.453,0.349], 
 [0.605,0.582,0.551]],
 [[0.324,0.954,0.404],
 [0.469,0.381,0.292],
 [0.550,0.453,0.349], 
 [0.605,0.582,0.551]]])


new_array = np.copy(array_a)
# assign values of -999 to mask = true
new_masked_array = np.ma.masked_values(array_a, -999)
# get the mask from the array
new_masked_array.mask
new_array[new_masked_array.mask] = array_b[new_masked_array.mask]

```
