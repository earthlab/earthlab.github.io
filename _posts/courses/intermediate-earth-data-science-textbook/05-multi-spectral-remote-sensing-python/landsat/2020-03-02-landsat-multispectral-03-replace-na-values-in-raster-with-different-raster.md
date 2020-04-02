---
layout: single
title: "How to Replace Raster Cell Values with Values from A Different Raster Data Set in Python"
excerpt: "Most remote sensing data sets contain no data values that represent pixels that contain invalid data. Learn how to handle no data values in Python for better raster processing."
authors: ['Leah Wasser']
dateCreated: 2017-03-01
modified: 2020-04-02
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-landsat']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/replace-raster-cell-values-in-remote-sensing-images-in-python/
nav-title: 'Replace Raster Cell Values'
week: 5
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  remote-sensing: ['landsat']
  reproducible-science-and-programming: ['python']
  earth-science: ['fire']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-modis/replace-raster-cell-values-in-remote-sensing-images-in-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Replace (masked) values in one numpy array with values in another array.

</div>

Sometimes you have many bad pixels in a landsat scene that you wish to replace or fill in with pixels from another scene. In this lesson you will learn how to replace pixels in one scene with those from another using Numpy. 

To begin, open both of the pre-fire raster stacks. You got the cloud free data as a part of your homework, last week. The scene with the cloud is in the cold spring fire data that you downloaded last week. 

{:.input}
```python
import os
from glob import glob
import matplotlib.pyplot as plt
from matplotlib import patches as mpatches
from matplotlib.colors import ListedColormap
import seaborn as sns
import numpy as np
import numpy.ma as ma
import pandas as pd
from shapely.geometry import mapping, box
import geopandas as gpd
import rasterio as rio
from rasterio.plot import plotting_extent
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep
import earthpy.mask as em

# Prettier plotting with seaborn
sns.set_style('white')
sns.set(font_scale=1.5)

# Download data and set working directory
data = et.data.get_data('cold-springs-fire')
data_2 = et.data.get_data('cs-test-landsat')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

First, open the masked raster stack that you exported in the previous lesson. If you did not complete the previous lesson, you will need to make a masked raster stack of the cold springs cloud data to continue on with this lesson. (If you exported your masked raster stack from the last lesson, you can read that file in and skip the following code.)

{:.input}
```python
# Stack the Landsat pre fire data
landsat_paths_pre_path = os.path.join("data", "cold-springs-fire", "landsat_collect", 
                                      "LC080340322016070701T1-SC20180214145604", "crop", 
                                      "*band*.tif")

landsat_paths_pre = glob(landsat_paths_pre_path)
landsat_paths_pre.sort()

landsat_pre_cloud, landsat_pre_meta = es.stack(
    landsat_paths_pre, nodata=-9999)

# Calculate bounds object
landsat_pre_cloud_ext_bds = rio.transform.array_bounds(
    landsat_pre_cloud.shape[1],
    landsat_pre_cloud.shape[2],
    landsat_pre_meta["transform"])

# Open the pixel_qa layer for your landsat scene
landsat_pre_cl_path = os.path.join("data", "cold-springs-fire", "landsat_collect", 
                                   "LC080340322016070701T1-SC20180214145604", "crop", 
                                   "LC08_L1TP_034032_20160707_20170221_01_T1_pixel_qa_crop.tif")

with rio.open(landsat_pre_cl_path) as landsat_pre_cl:
    landsat_qa = landsat_pre_cl.read(1)
    #landsat_pre_cloud_ext_bds  = landsat_pre_cl.bounds
    
# Generate array of all possible cloud / shadow values
cloud_shadow = [328, 392, 840, 904, 1350]
cloud = [352, 368, 416, 432, 480, 864, 880, 928, 944, 992]
high_confidence_cloud = [480, 992]

vals_to_mask = cloud_shadow + cloud + high_confidence_cloud

# Call the earthpy mask function using pixel QA layer
landsat_pre_cloud_masked = em.mask_pixels(landsat_pre_cloud, landsat_qa,
                                          vals=vals_to_mask)
```

Plot the data to ensure that the cloud covered pixels are masked. 

{:.input}
```python
ep.plot_rgb(landsat_pre_cloud_masked,
            rgb=[3, 2, 1],
            title="Masked Landsat Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-03-replace-na-values-in-raster-with-different-raster/2020-03-02-landsat-multispectral-03-replace-na-values-in-raster-with-different-raster_6_0.png" alt = "Plotting the image and the mask together to ensure the mask does indeed cover the cloud in the image.">
<figcaption>Plotting the image and the mask together to ensure the mask does indeed cover the cloud in the image.</figcaption>

</figure>




### Read and Stack Cloud Free Data
Next, read in and stack the cloud free landsat data. 
Below you create a `bounds` object that contains the spatial extent of the cloud free raster. You will use this to ensure that the bounds of both datasets are the same before replacing pixel values. 


{:.input}
```python
# Read in the "cloud free" landsat data that you downloaded as a part of your homework
landsat_paths_pre_cloud_free = glob(
    os.path.join("data", "cs-test-landsat", "*band*.tif"))

landsat_paths_pre_cloud_free.sort()

# Stack the data
landsat_pre_cloud_free, landsat_pre_cloud_free_meta = es.stack(
    landsat_paths_pre_cloud_free,
    nodata=-9999)

# Calculate bounds - this is just for comparison later, not required
landsat_no_clouds_bds = rio.transform.array_bounds(
    landsat_pre_cloud_free.shape[1],
    landsat_pre_cloud_free.shape[2],
    landsat_pre_cloud_free_meta["transform"])
```


{:.input}
```python
# Are the bounds the same?
landsat_no_clouds_bds == landsat_pre_cloud_ext_bds
```

{:.output}
{:.execute_result}



    False





{:.input}
```python
# Reorder the min and max values
cloud_free_scene_bds = box(*landsat_no_clouds_bds)
cloudy_scene_bds = box(*landsat_pre_cloud_ext_bds)

# Do the data overlap spatially?
cloud_free_scene_bds.intersects(cloudy_scene_bds)
```

{:.output}
{:.execute_result}



    True





{:.input}
```python
# Plot the boundaries
x, y = cloud_free_scene_bds.exterior.xy
x1, y1 = cloudy_scene_bds.exterior.xy

fig, ax = plt.subplots(1, 1, figsize=(8, 6))

ax.plot(x, y, color='#6699cc', alpha=0.7,
        linewidth=3, solid_capstyle='round', zorder=2)

ax.plot(x1, y1, color='purple', alpha=0.7,
        linewidth=3, solid_capstyle='round', zorder=2)

ax.set_title('Are the spatial extents different?')

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-03-replace-na-values-in-raster-with-different-raster/2020-03-02-landsat-multispectral-03-replace-na-values-in-raster-with-different-raster_13_0.png" alt = "Overlapping spatial extents of the masked Landsat image and the image that will be used to fill in the masked values.">
<figcaption>Overlapping spatial extents of the masked Landsat image and the image that will be used to fill in the masked values.</figcaption>

</figure>




{:.input}
```python
# Is the CRS the same in each raster?
landsat_pre_meta["crs"] == landsat_pre_cloud_free_meta["crs"]
```

{:.output}
{:.execute_result}



    True





{:.input}
```python
# Are the shapes the same?
landsat_pre_cloud.shape == landsat_pre_cloud_free.shape
```

{:.output}
{:.execute_result}



    False





You've now determined that

1. the data do not have the same bounds
2. the data are in the same Coordinate Reference System and
3. the data do overlap (or intersect).

Since the two images do not cover the same spatial extent, the next step is to CROP the cloud-free data (which has a larger spatial extent) to the spatial extent of the cloudy data so we can then reassign all cloud covered pixels to the values in the cloud free data (in the same location).


{:.input}
```python
landsat_clouds_clip = es.extent_to_json(list(landsat_pre_cloud_ext_bds))
```

{:.input}
```python
# Export the cloud free data as a tiff and reimport / crop the data
landsat_cloud_free_out_path = os.path.join("data", "outputs", "cloud_mask")

if not os.path.exists(landsat_cloud_free_out_path):
    os.makedirs(landsat_cloud_free_out_path)

cropped_cloud_list = es.crop_all(landsat_paths_pre_cloud_free, 
                                 landsat_cloud_free_out_path, 
                                 [landsat_clouds_clip], overwrite=True)

landsat_pre_cloud_free, landsat_pre_clod_free_meta = es.stack(
    cropped_cloud_list)
```

{:.input}
```python
# View the shape of each scene. are they the same?
landsat_pre_cloud_free.shape, landsat_pre_cloud_masked.shape
```

{:.output}
{:.execute_result}



    ((7, 177, 246), (7, 177, 246))






Once the data are cropped to the same extent, you can replace values using numpy.

{:.input}
```python
# Get the mask layer from the pre_cloud data
mask = landsat_pre_cloud_masked.mask

# Copy the pre_cloud_data to a new array 
# so you don't impact the original array (optional but suggested!)
landsat_pre_cloud_masked_copy = np.copy(landsat_pre_cloud_masked)

# Assign every cell in the new array that is masked 
# to the value in the same cell location as the cloud free data
#landsat_pre_cloud_c[mask] = landsat_pre_noclouds_crop[mask]
landsat_pre_cloud_masked_copy[mask] = landsat_pre_cloud_free[mask]
```

Finally, plot the data. Does it look like it reassigned values correctly?

{:.input}
```python
ep.plot_rgb(landsat_pre_cloud_masked_copy,
            rgb=[3, 2, 1],
            title="Masked Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-03-replace-na-values-in-raster-with-different-raster/2020-03-02-landsat-multispectral-03-replace-na-values-in-raster-with-different-raster_25_0.png" alt = "Landsat CIR Composite image after replacement of masked pixel values using a cloud-free image for the post-Cold Springs fire.">
<figcaption>Landsat CIR Composite image after replacement of masked pixel values using a cloud-free image for the post-Cold Springs fire.</figcaption>

</figure>




The above answer is not perfect! You can see that the boundaries of the masked area are still visible. Also there are dark shadowed pixels that were not replaced given the raster `pixel_qa` layer did not assign those as pixels to be masked. Thus you may need to do a significant amount of further analysis to get this image to where you'd like it to be. But you at least have a start at getting there!

In the case of this class, a large enough portion of the study area is covered by clouds that it makes more sense to find a new scene with cloud cover. However, it is good to understand how to replace pixel values in the case that you may need to do so for smaller areas in the future. 


