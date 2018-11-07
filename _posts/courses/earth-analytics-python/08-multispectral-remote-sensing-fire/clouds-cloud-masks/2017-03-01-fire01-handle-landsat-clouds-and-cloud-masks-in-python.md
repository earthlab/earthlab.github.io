---
layout: single
title: "Clean Remote Sensing Data in Python - Clouds, Shadows & Cloud Masks"
excerpt: "In this lesson, you will learn how to deal with clouds when working with spectral remote sensing data. You will learn how to mask clouds from landsat and MODIS remote sensing data in R using the mask() function. You will also discuss issues associated with cloud cover - particular as they relate to a research topic."
authors: ['Leah Wasser']
modified: 2018-11-06
category: [courses]
class-lesson: ['clouds-remote-sensing-python']
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/cloud-masks-with-spectral-data-python/
nav-title: 'Clouds, Shadows & Masks'
module-title: 'Clouds, shadows & cloud masks in Python'
module-description: 'Cloud cover can impact the quality of remote sensing data and in turn your analysis. Learn how to handle clouds in Landsat and MODIS remote sensing data. '
module-nav-title: 'Clouds in Remote Sensing Data - Python'
module-type: 'class'
class-order: 1
course: "earth-analytics-python"
week: 8
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe the impacts that thick cloud cover can have on analysis of remote sensing data.
* Use a cloud mask to remove portions of an spectral dataset (image) that is covered by clouds / shadows.
* Define cloud mask / describe how a cloud mask can be useful when working with remote sensing data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
data that you already downloaded for the Cold Springs Fire.

{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>


## About Landsat Scenes

Landsat satellites orbit the earth continuously collecting images of the Earth's
surface. These images, are divided into smaller regions - known as scenes.

> Landsat images are usually divided into scenes for easy downloading. Each
> Landsat scene is about 115 miles long and 115 miles wide (or 100 nautical
> miles long and 100 nautical miles wide, or 185 kilometers long and 185 kilometers wide). -*wikipedia*


### Challenges Working with Landsat Remote Sensing Data

In the previous lessons, you learned how to import a set of geotiffs that made
up the bands of a landsat raster. Each geotiff file was a part of a Landsat scene,
that had been downloaded for this class by your instructor. The scene was further
cropped to reduce the file size for the class.

You ran into some challenges when you began to work with the data. The biggest
problem was a large cloud and associated shadow that covered your study
area of interest - the Cold Springs fire burn scar.

### Work with Clouds, Shadows and Bad Pixels in Remote Sensing Data

Clouds and atmospheric conditions present a significant challenge when working
with multispectral remote sensing data. Extreme cloud cover and shadows can make
the data in those areas, un-usable given reflectance values are either washed out
(too bright - as the clouds scatter all light back to the sensor) or are too
dark (shadows which represent blocked or absorbed light).

In this lesson you will learn how to deal with clouds in your remote sensing data.
There is no perfect solution of course. You will just learn one approach.

Begin by loading your spatial libraries.


{:.input}
```python
from glob import glob
import os

import numpy.ma as ma
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import patches as mpatches, colors
from matplotlib.colors import ListedColormap
import matplotlib as mpl
import seaborn as sns

import rasterio as rio
from rasterio.plot import plotting_extent
from rasterio.mask import mask
import geopandas as gpd
from shapely.geometry import mapping

import earthpy as et
import earthpy.spatial as es

plt.ion()
sns.set_style('white')
sns.set(font_scale=1.5)

os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

Next, you will load the landsat bands that you worked with previously in your homework.


{:.input}
```python
# Stack the landsat pre fire data
landsat_paths_pre = glob(
    "data/cold-springs-fire/landsat_collect/LC080340322016070701T1-SC20180214145604/crop/*band*.tif")
path_landsat_pre_st = 'data/cold-springs-fire/outputs/landsat_pre_st.tif'
es.stack_raster_tifs(landsat_paths_pre, path_landsat_pre_st, arr_out=False)

# Read landsat pre fire data
with rio.open(path_landsat_pre_st) as landsat_pre_src:
    landsat_pre = landsat_pre_src.read(masked=True)
    landsat_extent = plotting_extent(landsat_pre_src)
```

When you plotted the pre-fire image, you noticed a large cloud in your scene.
Notice as i'm plotting below, i'm adding a few parameters to force `Python` to add a
title to my plot.

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip:** Check out the additional "How to" lessons for this week to learn more about
customizing plots in `Python`.
{: .notice--success}

Next, get the extent of the landsat data to use to plot your data with matplotlib `imshow()`. Below you see two ways to achieve the same extent object. 

{:.input}
```python
# Define Landast bands for plotting homework plot 1
landsat_rgb = [3, 2, 1]

fig, ax = plt.subplots(1, 1, figsize=(10, 6))

es.plot_rgb(landsat_pre,
            rgb=landsat_rgb,
            ax=ax,
            extent=landsat_extent)
ax.set(title="Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/clouds-cloud-masks/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_7_0.png" alt = "CIR Composite image for the post-Cold Springs fire area on July 8, 2016.">
<figcaption>CIR Composite image for the post-Cold Springs fire area on July 8, 2016.</figcaption>

</figure>




## Raster Masks

Many remote sensing data sets come with quality layers that you can use as a mask 
to remove "bad" pixels from your analysis. In the case of landsat, the mask layers
identify pixels that are likely representative of cloud cover, shadow and even water. 
When you download Landsat 8 data from Earth Explorer, the data came with a processed 
cloud shadow / mask raster layer called `landsat_file_name_pixel_qa.tif`.
Just replace the name of your landsat scene with the text landsat_file_name above. 
For this class the layer is:

`LC80340322016189-SC20170128091153/crop/LC08_L1TP_034032_20160707_20170221_01_T1_pixel_qa_crop.tif`

You will explore using this pixel quality assurance (QA) layer, next. To begin, open
the `pixel_qa` layer using rasterio and plot it with matplotlib.


{:.input}
```python
# Open the pixel_qa layer for your landsat scene
with rio.open("data/cold-springs-fire/landsat_collect/LC080340322016070701T1-SC20180214145604/crop/LC08_L1TP_034032_20160707_20170221_01_T1_pixel_qa_crop.tif") as landsat_pre_cl:
    landsat_qa = landsat_pre_cl.read(1)
    landsat_ext = plotting_extent(landsat_pre_cl)
```

First, plot the pixel_qa layer in matplotlib.

{:.input}
```python
cmap = plt.cm.get_cmap('tab20b', 11)
vals = np.unique(landsat_qa).tolist()
bins = [0] + vals
bounds = [((a + b) / 2) for a, b in zip(bins[:-1], bins[1::1])] + [(bins[-1] - bins[-2]) + bins[-1]]
norm = colors.BoundaryNorm(bounds, cmap.N)

fig, ax = plt.subplots(figsize=(12, 8))
im = ax.imshow(landsat_qa,
               cmap=cmap,
              norm=norm)

ax.set_title("Landsat Collections Pixel_QA Layer \n The colorbar is currently a bit off but will be fixed")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/clouds-cloud-masks/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_11_0.png" alt = "Landsat Collection Pixel QA layer for the Cold Springs fire area.">
<figcaption>Landsat Collection Pixel QA layer for the Cold Springs fire area.</figcaption>

</figure>




In the image above, you can see the cloud and the shadow that is obstructing our landsat image.
Unfortunately for you, this cloud covers a part of your analysis area in the Cold Springs
Fire location. There are a few ways to handle this issue. We will look at one:
simply masking out or removing the cloud for your analysis, first. 

To remove all pixels that are cloud and cloud shadow covered we need to first
determine what each value in our qa raster represents. The table below is from the USGS landsat website.
It describes what all of the values in the pixel_qa layer represent.

We are interested in 

1. cloud shadow
2. cloud and 
3. high confidence cloud

Note that your specific analysis may require a different set of masked pixels. For instance, your analysis may 
require you identify pixels that are low confidence clouds too. We are just using these classes
for the purpose of this class. 

# URL - make sure you click on the landsat 8 tab to view appropriate values

| Attribute                | Pixel Value                                                     | 
|--------------------------|-----------------------------------------------------------------| 
| Fill                     | 1                                                               | 
| Clear                    | 322, 386, 834, 898, 1346                                        | 
| Water                    | 324, 388, 836, 900, 1348                                        | 
| Cloud Shadow             | 328, 392, 840, 904, 1350                                        | 
| Snow/Ice                 | 336, 368, 400, 432, 848, 880, 912, 944, 1352                    | 
| Cloud                    | 352, 368, 416, 432, 480, 864, 880, 928, 944, 992                | 
| Low confidence cloud     | 322, 324, 328, 336, 352, 368, 834, 836, 840, 848, 864, 880      | 
| Medium confidence cloud  | 386, 388, 392, 400, 416, 432, 900, 904, 928, 944                | 
| High confidence cloud    | 480, 992                                                        | 
| Low confidence cirrus    | 322, 324, 328, 336, 352, 368, 386, 388, 392, 400, 416, 432, 480 | 
| High confidence cirrus   | 834, 836, 840, 848, 864, 880, 898, 900, 904, 912, 928, 944, 992 | 
| Terrain occlusion        | 1346, 1348, 1350, 1352                                          | 
==|

To better understand the values above, create a better map of the data. To do that you will:

1. classify the data into x classes where x represents the total number of unique values in the `pixel_qa` raster.
2. plot the data using these classes.

We are reclassifying the data because matplotlib colormaps will assign colors to values along a continuous gradient.
Reclassifying the data allows us to enforce one color for each unique value in our data. 


Next you will create a binary cloud mask layer. In this mask all pixels that you wish to remove from your analysis or mask will be set to `1`. All other pixels which represent pixels you want to use in your analysis will be set to `0`.

{:.input}
```python
# pre-allocate an array of all zeros representing the same sized array as the landsat scene and cloud mask
cl_mask = np.zeros(landsat_qa.shape)
```

{:.input}
```python
# Generate array of all possible cloud / shadow values
cloud_shadow = [328, 392, 840, 904, 1350]
cloud = [352, 368, 416, 432, 480, 864, 880, 928, 944, 992]
high_confidence_cloud = [480, 992]

all_masked_values = cloud_shadow + cloud + high_confidence_cloud
all_masked_values
```

{:.output}
{:.execute_result}



    [328,
     392,
     840,
     904,
     1350,
     352,
     368,
     416,
     432,
     480,
     864,
     880,
     928,
     944,
     992,
     480,
     992]





{:.input}
```python
# is there a way to do this without a loop?
# populate new array with values of 1 for every pixel that is a cloud or cloud shadow
for cval in all_masked_values:
    # create cloud mask for all relevant cloud values, for the primary scene
    cl_mask[landsat_qa == cval] = 1
    # print(cval)
np.unique(cl_mask)
```

{:.output}
{:.execute_result}



    array([0., 1.])





Finally, plot the reclassified raster mask. 

{:.input}
```python
fig, ax = plt.subplots(figsize=(12, 8))
im = ax.imshow(cl_mask,
               cmap=plt.cm.get_cmap('tab20b', 2))
cbar = fig.colorbar(im)
cbar.set_ticks((0.25, .75))
cbar.ax.set_yticklabels(["Clear Pixels", "Cloud / Shadow Pixels"])
ax.set_title("Landsat Cloud Mask | Light Purple Pixels will be Masked")
ax.set_axis_off()

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/clouds-cloud-masks/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_18_0.png" alt = "Landsat image in which the masked pixels (cloud) are rendered in light purple.">
<figcaption>Landsat image in which the masked pixels (cloud) are rendered in light purple.</figcaption>

</figure>






## What Does the Metadata Tell You?

You just explored two layers that potentially have information about cloud cover.
However what do the values stored in those rasters mean? You can refer to the
metadata provided by USGS to learn more about how
each layer in your landsat dataset are both stored and calculated.

When you download remote sensing data, often (but not always), you will find layers
that tell us more about the error and uncertainty in the data. Often whomever
created the data will do some of the work for us to detect where clouds and
shadows are - given they are common challenges that you need to work around when
using remote sensing data.


## Cloud Masks in Python

You can use the cloud mask layer to identify pixels that are likely to be clouds
or shadows. You can then set those pixel values to `masked` so they are not included in
your quantitative analysis in Python.

When you say "mask", you are talking about a layer that "turns off" or sets to `nan`,
the values of pixels in a raster that you don't want to include in an analysis.
It's very similar to setting data points that equal -9999 to `nan` in a time series
data set. You are just doing it with spatial raster data instead.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/raster-data/raster_masks.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/raster-data/raster_masks.jpg" alt="Raster masks">
    </a>

    <figcaption>When you use a raster mask, you are defining what pixels you want to exclude from a quantitative analysis. Notice in this image, the raster max is simply a layer that contains values of 1 (use these pixels) and values of NA (exclude these pixels). If the raster is the same extent and spatial resolution as your remote sensing data (in this case your landsat raster stack) you can then mask ALL PIXELS that occur at the spatial location of clouds and shadows (represented by an NA in the image above). Source: Colin Williams (NEON)
    </figcaption>
</figure>

### Create Mask Layer in Python

To create the mask this you do the following:

1. Make sure you use a raster layer for the mask that is the SAME EXTENT and the same pixel resolution as your landsat scene. In this case you have a mask layer that is already the same spatial resolution and extent as your landsat scene.
2. Set all of the values in that layer that are clouds and / or shadows to `1` (1 to represent `mask = True`)
3. Finally you use the `masked_array` function to apply the mask layer to the numpy array (or the landsat scene that you are working with in Python).  all pixel locations that were flagged as clouds or shadows in your mask to `NA` in your `raster` or in this case `rasterstack`.



{:.input}
```python
# Create a mask for all bands in the landsat scene
landsat_pre_mask = np.broadcast_to(cl_mask == 1, landsat_pre.shape)
```

{:.input}
```python
landsat_pre_cl_free = ma.masked_array(landsat_pre,
                                      mask=landsat_pre_mask)
type(landsat_pre_cl_free)
```

{:.output}
{:.execute_result}



    numpy.ma.core.MaskedArray





{:.input}
```python
# Plot the data
fig, ax = plt.subplots(1, 1, figsize=(8, 6))

ax.imshow(landsat_pre_cl_free[6],
          extent=landsat_extent,
          cmap="Greys")
ax.set(title="Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")
ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/clouds-cloud-masks/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_22_0.png" alt = "CIR Composite image in grey scale with mask applied, covering the post-Cold Springs fire area on July 8, 2016.">
<figcaption>CIR Composite image in grey scale with mask applied, covering the post-Cold Springs fire area on July 8, 2016.</figcaption>

</figure>




{:.input}
```python
# Plot
fig, ax = plt.subplots(1, 1, figsize=(8, 6))

es.plot_rgb(landsat_pre_cl_free,
            rgb=[5, 4, 3],
            extent=landsat_ext,
            ax=ax)
ax.set(title="Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")
ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/clouds-cloud-masks/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_23_0.png" alt = "CIR Composite image with cloud mask applied, covering the post-Cold Springs fire area on July 8, 2016.">
<figcaption>CIR Composite image with cloud mask applied, covering the post-Cold Springs fire area on July 8, 2016.</figcaption>

</figure>



