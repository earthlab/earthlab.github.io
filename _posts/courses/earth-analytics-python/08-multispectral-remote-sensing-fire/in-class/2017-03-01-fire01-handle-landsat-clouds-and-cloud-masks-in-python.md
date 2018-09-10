---
layout: single
title: "Clean Remote Sensing Data in Python - Clouds, Shadows & Cloud Masks"
excerpt: "In this lesson, you will learn how to deal with clouds when working with spectral remote sensing data. You will learn how to mask clouds from landsat and MODIS remote sensing data in R using the mask() function. You will also discuss issues associated with cloud cover - particular as they relate to a research topic."
authors: ['Leah Wasser','Megan Cattau']
modified: 2018-09-07
category: [courses]
class-lesson: ['modis-multispectral-rs-python']
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/cloud-masks-with-spectral-data-python/
nav-title: 'Clouds, Shadows & Masks'
module-title: 'Clouds, shadows & cloud masks in Python'
module-description: 'In this module you will learn more about dealing with clouds, shadows and other elements that can interfere with scientific analysis of remote sensing data. '
module-nav-title: 'Fire / spectral remote sensing data - in Python'
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
lang-lib:
  r: []
redirect_from:
  - "/courses/earth-analytics/week-7/intro-spectral-data-r/"
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
data that you already downloaded for week 6 of the course.

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
from shapely.geometry import mapping

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

Next, you will load the landsat bands that you worked with previously in your homework.


{:.input}
```python
# Stack the landsat pre fire data
landsat_paths_pre = glob("data/cold-springs-fire/landsat_collect/LC080340322016070701T1-SC20180214145604/crop/*band*.tif")
path_landsat_pre_st = 'data/cold-springs-fire/outputs/landsat_pre_st.tif'
es.stack_raster_tifs(landsat_paths_pre, path_landsat_pre_st)

# open and crop landsat data
with rio.open(path_landsat_pre_st) as ff:
    # crop landsat data using the fire boundary reprojected 
    #landsat_pre_crop, landsat_pre_meta = es.crop_image(landsat_pre, [landsat_clip])
    landsat_pre = ff.read(masked=True)
    landsat_bounds = ff.bounds
    landsat_meta = ff.profile
    
```

{:.output}
    /Users/lewa8222/anaconda3/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)



When you plotted the pre-fire image, you noticed a large cloud in your scene.
Notice as i'm plotting below, i'm adding a few parameters to force `Python` to add a
title to my plot.

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip:** Check out the additional "How to" lessons for this week to learn more about
customizing plots in `Python`.
{: .notice--success}

Next, get the extent of the landsat data to use to plot your data with matplotlib `imshow()`. Below you see two ways to achieve the same extent object. 

{:.input}
```python
extent_landsat = [landsat_bounds.left, landsat_bounds.right,
                  landsat_bounds.bottom,landsat_bounds.top]
```

{:.input}
```python
bound_order = [0,2,1,3]
extent_landsat = [landsat_bounds[i] for i in bound_order]
```

{:.input}
```python
# Define Landast bands for plotting homework plot 1
landsat_plot_indices = [3, 2, 1]
landsat_pre_data = ma.masked_where(landsat_pre < 0, landsat_pre)
landsat_cir_post_plot = es.bytescale(landsat_pre_data[landsat_plot_indices]).transpose(1, 2, 0)

fig, ax = plt.subplots(1, 1, figsize=(8, 6))

ax.imshow(landsat_cir_post_plot, extent=extent_landsat)
ax.set(title = "Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016");
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_9_0.png">

</figure>





https://landsat.usgs.gov/landsat-8-cloud-cover-assessment-validation-data

https://landsat.usgs.gov/sites/default/files/documents/lasrc_product_guide.pdf

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
# open the pixel_qa layer for your landsat scene
with rio.open("data/cold-springs-fire/landsat_collect/LC080340322016070701T1-SC20180214145604/crop/LC08_L1TP_034032_20160707_20170221_01_T1_pixel_qa_crop.tif") as ff:
    landsat_qa = ff.read(1)
    bounds_landsat = ff.bounds
    mask_profile = ff.profile
```

First, plot the pixel_qa layer in matplotlib.

{:.input}
```python
# need to figure out how to add optional labels to this color map 
# so more arguments are needed in the function
fig, ax = plt.subplots(figsize=(12, 12))
im = ax.imshow(landsat_qa, 
               cmap = plt.cm.get_cmap('tab20b', 11))
cbar = es.colorbar(im)
ax.set_title("Landsat Collections Pixel_QA Layer")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_13_0.png">

</figure>




# get links to the landsat cloud mask info usgs

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

To better understand the values above, let's produce a better map of the data. To do that we will

1. classify the data into x classes where x represents the total number of unique values in the pixel_qa raster.
2. plot the data using these classes.

We are reclassifying the data because matplotlib colormaps will assign colors to values along a continuous gradient.
Reclassifying the data allows us to enforce one color for each unique value in our data. 


{:.input}
```python
np.arange(0,12,1) +.5
```

{:.output}
{:.execute_result}



    array([ 0.5,  1.5,  2.5,  3.5,  4.5,  5.5,  6.5,  7.5,  8.5,  9.5, 10.5,
           11.5])





{:.input}
```python
# create reclassification bins
bins = (np.unique(landsat_qa)+.5)
# reclassify the mask layer using digitize (this is just for plotting)
class_mask = np.digitize(landsat_qa, bins).astype("int16")
# need to figure out how to add optional labels to this color map 
# so more arguments are needed in the function
fig, ax = plt.subplots(figsize=(12, 12))
im = ax.imshow(class_mask, 
               cmap = plt.cm.get_cmap('tab20b', 11))
cbar = es.colorbar(im)
# label each colorbar tick
cbar.set_ticks((np.arange(0,12,1))+.5)
cbar.ax.set_yticklabels(np.unique(landsat_qa))
ax.set_title("Landsat Collections Pixel_QA Layer")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_17_0.png">

</figure>




Next you will create a binary cloud mask layer. In this mask all pixels that you wish to remove from your analysis or mask will be set to `1`. All other pixels which represent pixels you want to use in your analysis will be set to `0`.

{:.input}
```python
# pre-allocate an array of all zeros representing the same sized array as the landsat scene and cloud mask
cl_mask = np.zeros(landsat_qa.shape)
```

{:.input}
```python
# generate an array of all possible cloud / shadow values
cloud_shadow =[328, 392, 840, 904, 1350]
cloud =[352, 368, 416, 432, 480, 864, 880, 928, 944, 992]
high_confidence_cloud =[480, 992]

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
        cl_mask[landsat_qa == cval ] = 1
        #print(cval)
np.unique(cl_mask)
```

{:.output}
{:.execute_result}



    array([0., 1.])






{:.output}
    /Users/lewa8222/anaconda3/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)



Finally, plot the reclassified raster mask. 

{:.input}
```python
fig, ax = plt.subplots(figsize=(12, 12))
im = ax.imshow(cl_mask, 
               cmap = plt.cm.get_cmap('tab20b', 2))
cbar = es.colorbar(im);
cbar.set_ticks((0.25,.75))
cbar.ax.set_yticklabels(["Clear Pixels", "Cloud / Shadow Pixels"])
ax.set_title("Landsat Cloud Mask | Purple Pixels will be masked");
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_24_0.png">

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
# create a mask for all bands in the landsat scene
landsat_pre_mask = np.broadcast_to(cl_mask == 1, landsat_pre_data.shape)
landsat_pre_mask.shape, landsat_pre_data.shape
landsat_pre_mask
```

{:.output}
{:.execute_result}



    array([[[False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            ...,
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False]],
    
           [[False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            ...,
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False]],
    
           [[False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            ...,
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False]],
    
           ...,
    
           [[False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            ...,
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False]],
    
           [[False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            ...,
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False]],
    
           [[False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            ...,
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False],
            [False, False, False, ..., False, False, False]]])





{:.input}
```python
landsat_pre_mask = ma.masked_array(landsat_pre_data, 
                                   mask=landsat_pre_mask)
landsat_pre_mask
```

{:.output}
{:.execute_result}



    masked_array(
      data=[[[405, 405, 395, ..., 197, 229, 282],
             [372, 377, 390, ..., 208, 245, 305],
             [330, 346, 344, ..., 237, 306, 354],
             ...,
             [330, 265, 329, ..., 260, 229, 128],
             [457, 516, 464, ..., 279, 287, 195],
             [273, 149, 246, ..., 305, 337, 288]],
    
            [[443, 456, 446, ..., 213, 251, 293],
             [408, 420, 436, ..., 226, 272, 332],
             [356, 375, 373, ..., 261, 329, 383],
             ...,
             [407, 427, 428, ..., 306, 273, 216],
             [545, 552, 580, ..., 307, 315, 252],
             [350, 221, 233, ..., 320, 348, 315]],
    
            [[635, 641, 629, ..., 360, 397, 454],
             [601, 617, 620, ..., 380, 418, 509],
             [587, 600, 573, ..., 431, 513, 603],
             ...,
             [679, 742, 729, ..., 493, 482, 459],
             [816, 827, 824, ..., 461, 502, 485],
             [526, 388, 364, ..., 463, 501, 512]],
    
            ...,
    
            [[2080, 1942, 1950, ..., 1748, 1802, 2135],
             [2300, 2045, 1939, ..., 1716, 1783, 2131],
             [2582, 2443, 2347, ..., 1836, 2002, 2241],
             ...,
             [2076, 1993, 2145, ..., 1914, 2066, 2166],
             [1910, 1899, 1962, ..., 1787, 2038, 2300],
             [1633, 1611, 1738, ..., 1714, 1848, 2194]],
    
            [[2083, 1985, 1927, ..., 1011, 1151, 1251],
             [1896, 1932, 1845, ..., 1130, 1240, 1505],
             [1887, 1771, 1672, ..., 1283, 1561, 1793],
             ...,
             [1942, 1683, 1885, ..., 1589, 1539, 1608],
             [1865, 1850, 1572, ..., 1553, 1507, 1560],
             [1199, 994, 1113, ..., 1656, 1665, 1715]],
    
            [[1443, 1387, 1283, ..., 576, 675, 696],
             [1198, 1274, 1183, ..., 657, 738, 907],
             [1108, 1036, 983, ..., 759, 949, 1147],
             ...,
             [1541, 1244, 1359, ..., 1012, 919, 989],
             [1375, 1602, 1245, ..., 1002, 942, 929],
             [894, 619, 693, ..., 1058, 1044, 1056]]],
      mask=[[[False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             ...,
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False]],
    
            [[False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             ...,
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False]],
    
            [[False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             ...,
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False]],
    
            ...,
    
            [[False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             ...,
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False]],
    
            [[False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             ...,
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False]],
    
            [[False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             ...,
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False],
             [False, False, False, ..., False, False, False]]],
      fill_value=-32768,
      dtype=int16)





{:.input}
```python
#landsat_pre_data = ma.masked_where(landsat_pre < 0, landsat_pre)
fig, ax = plt.subplots(1, 1, figsize=(8, 6))

ax.imshow(landsat_pre_mask[6], 
          extent=extent_landsat,
          cmap = "Greys")
ax.set(title = "Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016");
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_28_0.png">

</figure>




{:.input}
```python
#%matplotlib notebook
land_rgb = (landsat_pre_mask[landsat_plot_indices]).transpose(1, 2, 0)

fig, ax = plt.subplots(1, 1, figsize=(8, 6))

ax.imshow(es.bytescale(land_rgb), extent=extent_landsat)
ax.set(title = "Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016");
ax.set_axis_off();

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_29_0.png">

</figure>





{:.output}
{:.execute_result}



    True





Above notice that matplotlib doesn't plot the image as you would expect. There is an unusual set of colored pixels in the area that should be masked by matplotlib. 

<a href="https://stackoverflow.com/questions/48206605/plotting-segmented-color-images-using-numpy-masked-array-and-imshow" target="_blank">View Stack Overflow post on this issue.</a>

To fix this, you can create an alpha channel for your rgb image.
Typically, programs expect a 4th band to be an alpha channel. In this case we will create a 4th band where

1. all pixels that should be masked are labelend with a 0 and
2. all pixels that should be visible are labaled with a 255

Matplotlib imshow will apply this alpha mask properly across each band in your raster. 

To begin, first you create a mask. This involves 2 steps

1. accessing just one band of the mask object from the numpy array. 
2. Creating an alpha mask

## Alpha Mask Bands in Python
An alpha mask channel or band in an image represents the areas that should be masked out in all bands of your data. 
IN an alpha mask the value of 255 will be DRAWN in your plot. Values of 0 will be masked. 

THe alpha mask is actually the opposite of a python numpy array mask. In an numpy array, values of True (which equate to 1) are masked. and values of False (0) are drawn. 

To create an alpha challenge you can thus 

1. invert the mask object
2. multiply the mask layer by 255

Thus all values of 255 will be drawn by matplotlib. The rest will be masked.  

{:.input}
```python
# the steps broken down

# get just one "layer" or band of the mask
mask = land_rgb[:,:,0].mask

# Invert the data and multiply by 255
mask = ~mask * 255
```

You can combine the above steps into one single line of code as follows to create an alpha channel:

{:.input}
```python
mask = ~(land_rgb[:,:,0].mask) *255
mask
```

{:.output}
{:.execute_result}



    array([[255, 255, 255, ..., 255, 255, 255],
           [255, 255, 255, ..., 255, 255, 255],
           [255, 255, 255, ..., 255, 255, 255],
           ...,
           [255, 255, 255, ..., 255, 255, 255],
           [255, 255, 255, ..., 255, 255, 255],
           [255, 255, 255, ..., 255, 255, 255]])





{:.input}
```python
land_rgb.shape, mask.shape
```

{:.output}
{:.execute_result}



    ((177, 246, 3), (177, 246))





{:.input}
```python
# Add the mask as a 4th channel to the array
land_rgb_alpha = np.dstack((es.bytescale(land_rgb), mask))
land_rgb_alpha[0:3,0:3]
```

{:.output}
{:.execute_result}



    masked_array(
      data=[[[ 38,  39,  27, 255],
             [ 41,  39,  28, 255],
             [ 40,  39,  27, 255]],
    
            [[ 35,  37,  25, 255],
             [ 38,  38,  26, 255],
             [ 39,  38,  27, 255]],
    
            [[ 31,  36,  22, 255],
             [ 31,  37,  23, 255],
             [ 31,  35,  23, 255]]],
      mask=False,
      fill_value=999999)





Once your data are masked, you can plot the three band + alpha channel image.

{:.input}
```python
fig, ax = plt.subplots(1, 1, figsize=(8, 6))

ax.imshow(land_rgb_alpha, 
          extent=extent_landsat)
ax.set(title = "Masked Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016");
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_38_0.png">

</figure>




{:.input}
```python

rgb_band_meta = landsat_meta.copy()
rgb_band_meta['count'] = land_rgb.shape[2]
rgb_band_meta, land_rgb_alpha.shape
```

{:.output}
{:.execute_result}



    ({'affine': Affine(30.0, 0.0, 455655.0,
           0.0, -30.0, 4428465.0),
      'count': 3,
      'crs': CRS({'init': 'epsg:32613'}),
      'driver': 'GTiff',
      'dtype': 'int16',
      'height': 177,
      'interleave': 'pixel',
      'nodata': -32768.0,
      'tiled': False,
      'transform': (455655.0, 30.0, 0.0, 4428465.0, 0.0, -30.0),
      'width': 246},
     (177, 246, 4))





You want to write the original masked data, rather than bothering wtih the alpha channel

{:.input}
```python
# transpose the data
land_rgb_fin = land_rgb.transpose(2,0,1)
# coerce to 16 bit integer
land_rgb_fin = land_rgb_fin.astype("int16")
land_rgb_fin.shape
```

{:.output}
{:.execute_result}



    (3, 177, 246)





{:.input}
```python
# export the full raster setting no data values to all masked pixels 
fin_masked = np.ma.filled(land_rgb_fin, fill_value=rgb_band_meta['nodata'])
# then write out the masked value
with rio.open("data/cold-springs-fire/outputs/rgb_masked.tif", 
              'w', **rgb_band_meta) as dst:
    dst.write(fin_masked)
```

{:.output}
    /Users/lewa8222/anaconda3/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)



Next, you can calculate a vegetation index on your masked data.

{:.input}
```python
# calculate ndvi with landsat
landsat_ndvi = es.normalized_diff(landsat_pre_mask[3], landsat_pre_mask[4])

# plot the outputs
fig, ax = plt.subplots(1, 1, figsize=(8, 6))

im = ax.imshow((landsat_ndvi), 
          extent=extent_landsat, cmap = 'PiYG',
              vmin = -1, vmax = 1)
es.colorbar(im)
ax.set(title = "Masked Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016");
ax.set_axis_off();

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_44_0.png">

</figure>




{:.input}
```python
# or use the earthpy plot_rgb function to plot the cloud masked image
es.plot_rgb(landsat_pre_mask, rgb = landsat_plot_indices)

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/in-class/2017-03-01-fire01-handle-landsat-clouds-and-cloud-masks-in-python_45_0.png">

</figure>



