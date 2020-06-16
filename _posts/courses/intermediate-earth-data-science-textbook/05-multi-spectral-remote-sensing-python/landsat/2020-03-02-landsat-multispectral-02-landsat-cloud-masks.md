---
layout: single
title: "Clean Remote Sensing Data in Python - Clouds, Shadows & Cloud Masks"
excerpt: "Landsat remote sensing data often has pixels that are covered by clouds and cloud shadows. Learn how to remove cloud covered landsat pixels using open source Python."
authors: ['Leah Wasser']
dateCreated: 2017-03-01
modified: 2020-04-02
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-landsat']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/remove-clouds-from-landsat-data/
nav-title: 'Clouds, Shadows & Masks'
course: "intermediate-earth-data-science-textbook"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-modis/cloud-masks-with-spectral-data-python/"
  - "/courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/cloud-masks-with-spectral-data-python/" 
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe the impacts of cloud cover on analysis of remote sensing data.
* Use a mask to remove portions of an spectral dataset (image) that is covered by clouds / shadows.
* Define mask / describe how a mask can be useful when working with remote sensing data.

</div>


## About Landsat Scenes

Landsat satellites orbit the earth continuously collecting images of the Earth's
surface. These images, are divided into smaller regions - known as scenes.

> Landsat images are usually divided into scenes for easy downloading. Each
> Landsat scene is about 115 miles long and 115 miles wide (or 100 nautical
> miles long and 100 nautical miles wide, or 185 kilometers long and 185 kilometers wide). -*wikipedia*


### Challenges Working with Landsat Remote Sensing Data

In the previous lessons, you learned how to import a set of geotiffs that made
up the bands of a Landsat raster. Each geotiff file was a part of a Landsat scene,
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



{:.input}
```python
import os
from glob import glob
import matplotlib.pyplot as plt
from matplotlib import patches as mpatches, colors
from matplotlib.colors import ListedColormap
import seaborn as sns
import numpy as np
import numpy.ma as ma
import pandas as pd
import rasterio as rio
from rasterio.plot import plotting_extent
from rasterio.mask import mask
import geopandas as gpd
from shapely.geometry import mapping
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep
import earthpy.mask as em

# Prettier plotting with seaborn
sns.set_style('white')
sns.set(font_scale=1.5)

# Download data and set working directory
data = et.data.get_data('cold-springs-fire')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

Next, you will load and plot landsat data. If you are completing the earth analytics course, you have worked with these data already in your homework.


{:.input}
```python
landsat_paths_pre_path = os.path.join("data", "cold-springs-fire", "landsat_collect", 
                                      "LC080340322016070701T1-SC20180214145604", "crop", 
                                      "*band*.tif")

landsat_paths_pre = glob(landsat_paths_pre_path)
landsat_paths_pre.sort()

# Stack the Landsat pre fire data
landsat_pre_st_path = os.path.join("data", "cold-springs-fire", 
                                   "outputs", "landsat_pre_st.tif")

es.stack(landsat_paths_pre, landsat_pre_st_path)

# Read landsat pre fire data
with rio.open(landsat_pre_st_path) as landsat_pre_src:
    landsat_pre = landsat_pre_src.read(masked=True)
    landsat_extent = plotting_extent(landsat_pre_src)
    
ep.plot_rgb(landsat_pre,
            rgb=[3, 2, 1],
            extent=landsat_extent,
            title="Landsat True Color Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-landsat-cloud-masks/2020-03-02-landsat-multispectral-02-landsat-cloud-masks_4_0.png" alt = "RGB Landsat image for the Cold Springs fire area with a cloud blocking part of the image.">
<figcaption>RGB Landsat image for the Cold Springs fire area with a cloud blocking part of the image.</figcaption>

</figure>




Notice in the data above there is a large cloud in your scene. This cloud will impact any quantitative analysis that you perform on the data. You can remove cloudy pixels using a mask. Masking "bad" pixels:

1. Allows you to remove them from any quantitative analysis that you may perform such as calculating NDVI. 
2. Allows you to replace them (if you want) with better pixels from another scene. This replacement if often performed when performing time series analysis of data. The following lesson will teach you have to replace pixels in a scene. 

## Cloud Masks in Python

You can use the cloud mask layer to identify pixels that are likely to be clouds
or shadows. You can then set those pixel values to `masked` so they are not included in
your quantitative analysis in Python.

When you say "mask", you are talking about a layer that "turns off" or sets to `nan`,
the values of pixels in a raster that you don't want to include in an analysis.
It's very similar to setting data points that equal -9999 to `nan` in a time series
data set. You are just doing it with spatial raster data instead.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/raster_masks.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/raster_masks.jpg" alt="Raster masks">
    </a>

    <figcaption>When you use a raster mask, you are defining what pixels you want to exclude from a quantitative analysis. Notice in this image, the raster max is simply a layer that contains values of 1 (use these pixels) and values of NA (exclude these pixels). If the raster is the same extent and spatial resolution as your remote sensing data (in this case your landsat raster stack) you can then mask ALL PIXELS that occur at the spatial location of clouds and shadows (represented by an NA in the image above). Source: Colin Williams (NEON)
    </figcaption>
</figure>




The code below demonstrated how to mask a landsat scene using the pixel_qa layer. 


## Raster Masks for Remote Sensing Data

Many remote sensing data sets come with quality layers that you can use as a mask 
to remove "bad" pixels from your analysis. In the case of Landsat, the mask layers
identify pixels that are likely representative of cloud cover, shadow and even water. 
When you download Landsat 8 data from Earth Explorer, the data came with a processed 
cloud shadow / mask raster layer called `landsat_file_name_pixel_qa.tif`.
Just replace the name of your Landsat scene with the text landsat_file_name above. 
For this class the layer is:

`LC80340322016189-SC20170128091153/crop/LC08_L1TP_034032_20160707_20170221_01_T1_pixel_qa_crop.tif`

You will explore using this pixel quality assurance (QA) layer, next. To begin, open
the `pixel_qa` layer using rasterio and plot it with matplotlib.



{:.input}
```python
landsat_pre_cl_path = os.path.join("data", "cold-springs-fire", "landsat_collect", 
                                   "LC080340322016070701T1-SC20180214145604", "crop", 
                                   "LC08_L1TP_034032_20160707_20170221_01_T1_pixel_qa_crop.tif")

# Open the pixel_qa layer for your landsat scene
with rio.open(landsat_pre_cl_path) as landsat_pre_cl:
    landsat_qa = landsat_pre_cl.read(1)
    landsat_ext = plotting_extent(landsat_pre_cl)
```

First, plot the pixel_qa layer in matplotlib.


{:.input}
```python
# This is optional code to plot the qa layer - don't worry too much about the details.
# Create a colormap with 11 colors
cmap = plt.cm.get_cmap('tab20b', 11)
# Get a list of unique values in the qa layer
vals = np.unique(landsat_qa).tolist()
bins = [0] + vals
# Normalize the colormap 
bounds = [((a + b) / 2) for a, b in zip(bins[:-1], bins[1::1])] + \
    [(bins[-1] - bins[-2]) + bins[-1]]
norm = colors.BoundaryNorm(bounds, cmap.N)

# Plot the data
fig, ax = plt.subplots(figsize=(12, 8))

im = ax.imshow(landsat_qa,
               cmap=cmap,
               norm=norm)

ep.draw_legend(im,
               classes=vals,
               cmap=cmap, titles=vals)

ax.set_title("Landsat Collection Quality Assessment Layer")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-landsat-cloud-masks/2020-03-02-landsat-multispectral-02-landsat-cloud-masks_14_0.png" alt = "Landsat Collection Pixel QA layer for the Cold Springs fire area.">
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




This next section shows you how to create a mask using the earthpy mask helper function `_create_mask` to create a binary cloud mask layer. In this mask all pixels that you wish to remove from your analysis or mask will be set to `1`. All other pixels which represent pixels you want to use in your analysis will be set to `0`.

### NOTE:
This step can be done by changing the inputs into the main `mask_pixels` function. We include it here so you can see what is going on in the function. See lower down in the lesson for this call. 

{:.input}
```python
vals
```

{:.output}
{:.execute_result}



    [322, 324, 328, 352, 386, 416, 480, 834, 864, 928, 992]





{:.input}
```python
# You can grab the cloud pixel values from earthpy
high_cloud_confidence = em.pixel_flags["pixel_qa"]["L8"]["High Cloud Confidence"]
cloud = em.pixel_flags["pixel_qa"]["L8"]["Cloud"]
cloud_shadow = em.pixel_flags["pixel_qa"]["L8"]["Cloud Shadow"]

all_masked_values = cloud_shadow + cloud + high_cloud_confidence
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
# This is using a helper function from earthpy to create the mask so we can plot it
# You don't need to do this in your workflow as you can perform the mask in one step
# But we have it here for demonstration purposes
cl_mask = em._create_mask(landsat_qa, all_masked_values)
np.unique(cl_mask)
```

{:.output}
{:.execute_result}



    array([0, 1], dtype=int16)







Below is the plot of the reclassified raster mask created from the `_create_mask` helper function.


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-landsat-cloud-masks/2020-03-02-landsat-multispectral-02-landsat-cloud-masks_28_0.png" alt = "Landsat image in which the masked pixels (cloud) are rendered in light purple.">
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


### Create Mask Layer in Python

To create the mask this you do the following:

1. Make sure you use a raster layer for the mask that is the SAME EXTENT and the same pixel resolution as your landsat scene. In this case you have a mask layer that is already the same spatial resolution and extent as your landsat scene.
2. Set all of the values in that layer that are clouds and / or shadows to `1` (1 to represent `mask = True`)
3. Finally you use the `masked_array` function to apply the mask layer to the numpy array (or the landsat scene that you are working with in Python).  all pixel locations that were flagged as clouds or shadows in your mask to `NA` in your `raster` or in this case `rasterstack`.

## Mask A Landsat Scene Using EarthPy
Below you mask your data in one single step. This function `em.mask_pixels()` creates the mask as you saw above and then masks your data. 

{:.input}
```python
# Call the earthpy mask function using your mask layer
landsat_pre_cl_free = em.mask_pixels(landsat_pre, cl_mask)
```

Alternatively, you can directly input your mask values and the pixel QA layer into the `mask_pixels` function. This is the easiest way to mask your data!

{:.input}
```python
# Call the earthpy mask function using pixel QA layer
landsat_pre_cl_free = em.mask_pixels(
    landsat_pre, landsat_qa, vals=all_masked_values)
```



{:.input}
```python
# Plot the data
ep.plot_bands(landsat_pre_cl_free[6],
              extent=landsat_extent,
              cmap="Greys",
              title="Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016",
              cbar=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-landsat-cloud-masks/2020-03-02-landsat-multispectral-02-landsat-cloud-masks_35_0.png" alt = "CIR Composite image in grey scale with mask applied, covering the post-Cold Springs fire area on July 8, 2016.">
<figcaption>CIR Composite image in grey scale with mask applied, covering the post-Cold Springs fire area on July 8, 2016.</figcaption>

</figure>




{:.input}
```python
# Plot data
ep.plot_rgb(landsat_pre_cl_free,
            rgb=[4, 3, 2],
            extent=landsat_ext,
            title="Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-02-landsat-cloud-masks/2020-03-02-landsat-multispectral-02-landsat-cloud-masks_36_0.png" alt = "CIR Composite image with cloud mask applied, covering the post-Cold Springs fire area on July 8, 2016.">
<figcaption>CIR Composite image with cloud mask applied, covering the post-Cold Springs fire area on July 8, 2016.</figcaption>

</figure>




















