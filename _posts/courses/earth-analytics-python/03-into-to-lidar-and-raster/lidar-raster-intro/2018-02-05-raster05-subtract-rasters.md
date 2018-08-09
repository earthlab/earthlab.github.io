---
layout: single
title: "Subtract One Raster from Another and Export a New Geotiff in Python"
excerpt: "Often you need to process two raster datasets together to create a new raster output. You then want to save that output as a new file. Learn how to subtract rasters and create a new geotiff file using open source Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-08-09
category: [courses]
class-lesson: ['intro-lidar-raster-python']
permalink: /courses/earth-analytics-python/raster-lidar-intro/subtract-raster/
nav-title: 'Subtract Rasters & Export Geotiffs'
week: 3
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:
* Derive a **CHM** in `Python` using raster math.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and a working version of python version 3.x.
Your instructors recommend the Python Anaconda distribution. 

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}


</div>

### Be sure to set your working directory
`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import rasterio as rio
from rasterio.plot import plotting_extent
import numpy as np
import earthpy as et
import matplotlib.pyplot as plt
from matplotlib.patches import Patch
from matplotlib.colors import ListedColormap
# note that you have to have colors loaded for BoundaryNorm to work below
import matplotlib.colors as colors
import earthpy.spatial as es
import os
plt.ion()
# set plot parameters
plt.rcParams['figure.figsize'] = (8, 8)
# prettier plotting with seaborn
import seaborn as sns; 
sns.set(font_scale=1.5)
```

Next, let's open and plot the digital elevation model (DEM). Note that when you read the data, you can use the argument `masked = True` to ensure that the no data values do not plot and are assign `nan` or `no data`. 

<!-- 
If we use masked=True we can skip this step
# Insert nans
#lidar_dem_im[lidar_dem_im == lidar_dem.nodata] = np.nan
-->

{:.input}
```python
# open raster data
with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif') as lidar_dem:
    lidar_dem_im = lidar_dem.read(1, masked=True)
    # get bounds for plotting
    bounds = plotting_extent(lidar_dem)

```

### Import Digital Surface Model (DSM)

Next, let's open the digital surface model (DSM). The DSM represents the top of
the earth's surface. Thus, it INCLUDES TREES, BUILDINGS and other objects that
sit on the earth.

{:.input}
```python
with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DSM.tif') as lidar_dsm:
    lidar_dsm_im = lidar_dsm.read(1, masked=True)
    
lidar_dsm_im
```

{:.output}
{:.execute_result}



    masked_array(
      data=[[--, --, --, ..., 1695.6300048828125, 1695.5899658203125,
             1696.3900146484375],
            [--, --, --, ..., 1695.5999755859375, 1695.6300048828125, 1697.0],
            [--, --, --, ..., 1695.3800048828125, 1695.43994140625,
             1695.449951171875],
            ...,
            [--, --, --, ..., 1681.449951171875, 1681.3900146484375, 1681.25],
            [--, --, --, ..., 1681.719970703125, 1681.5699462890625,
             1681.5599365234375],
            [--, --, --, ..., 1681.8900146484375, 1681.8099365234375,
             1681.739990234375]],
      mask=[[ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            ...,
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False]],
      fill_value=-3.402823e+38,
      dtype=float32)






## Canopy Height Model

The canopy height model (CHM) represents the HEIGHT of the trees. This is not
an elevation value, rather it's the height or distance between the ground and the top of the
trees (or buildings or whatever object that the lidar system detected and recorded). Some canopy height models also include buildings so you need to look closely
are your data to make sure it was properly cleaned before assuming it represents
all trees!

### Calculate difference between two rasters

There are different ways to calculate a CHM. One easy way is to subtract the
DEM from the DSM.

**DSM - DEM = CHM**

This math gives you the residual value or difference between the top of the
earth surface and the ground which should be the heights of the trees (and buildings
if the data haven't been "cleaned").

<i class="fa fa-star"></i> **Data Tip:** Note that this method of subtracting 2 rasters to create a CHM may not give you the most accurate results! There are better ways to create CHM's using the point clouds themselves. However, in this lesson you learn this method as a means to get more familiar with the CHM dataset and to understand how to perform raster calculations in `Python`. 
{: .notice--success}

Before you subtract the two rasters, be sure to check to see if they cover the same area! 

{:.input}
```python
# are the bounds the same?
print("Is the spatial extent the same?", lidar_dem.bounds == lidar_dsm.bounds), 

## is the resolution the same ??
print("Is the resolution the same?", lidar_dem.res == lidar_dsm.res)
```

{:.output}
    Is the spatial extent the same? True
    Is the resolution the same? True



It looks like the bounds and resolution are the same. This means it is safe for us to subtract the two rasters without worrying about clipping the data. 

{:.input}
```python
# calculate canopy height model
lidar_chm = lidar_dsm_im - lidar_dem_im
```

Finally, plot your newly created chm!

{:.input}
```python
# plot the data
fig, ax = plt.subplots(figsize = (10,10))
chm_plot = ax.imshow(lidar_chm, 
                     cmap='viridis')
es.colorbar(chm_plot)
ax.set_title("Lidar Canopy Height Model (CHM)")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_13_0.png">

</figure>




{:.input}
```python
fig, ax = plt.subplots()
ax.hist(lidar_chm.ravel(), 
        color = 'purple')
ax.set_title("Histogram of CHM Values");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_14_0.png">

</figure>




Take a close look at the output CHM. Do you think that the data just represents trees? Or do you see anything that may suggest that there are other types of objects represented in the data?


### Explore the CHM Data

Next, explore the data values in your CHM. Think about the values representing things like trees and buildings in your data.

Do the data make sense?

{:.input}
```python
print('CHM minimum value: ', lidar_chm.min())
print('CHM max value: ', lidar_chm.max())
```

{:.output}
    CHM minimum value:  0.0
    CHM max value:  26.930054




## Plots Using Breaks

Sometimes assigning colors to specific value ranges in your data can help you 
better understand what is going on in the raster. For example you may chose to highlight 
just the talled pixels with a color that allows you to see how those pixels are distributed 
across the entire raster. 

Maybe by doing this you will visually identify spatial patterns that you want  
to explore in more depth.To do this, you can create breaks in your CHM plot.

{:.input}
```python
# Define the colors you want
cmap = ListedColormap(["white", "tan", "springgreen", "darkgreen"])

# Define a normalization from values -> colors
norm = colors.BoundaryNorm([0, 2, 10, 20, 30], 5)
```

{:.input}
```python
fig, ax = plt.subplots()
chm_plot = ax.imshow(lidar_chm, 
                     cmap=cmap, 
                     norm=norm)
ax.set_title("Lidar Canopy Height Model (CHM)")

# Add a legend for labels
legend_labels = {"tan": "short", "springgreen": "medium", "darkgreen": "tall"}

patches = [Patch(color=color, label=label) for color, label in legend_labels.items()]
ax.legend(handles=patches, 
          bbox_to_anchor = (1.35,1), 
          facecolor="white")
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_19_0.png">

</figure>




## Export a Raster

You can export a raster file in `python` using the `rasterio` `write()` function. Export the canopy height model that you just created to your data folder. You will create a new directory called "outputs" within the `colorado-flood` directory. This structure allows you to keep things organized, separating your outputs from the data you downloaded.

NOTE: you can use the code below to check for and create an outputs directory. OR, you can create the directory yourself using the finder (MAC) or windows
explorer.

{:.input}
```python
if os.path.exists('data/colorado-flood/spatial/outputs'):
    print('The directory exists!')
else:
    os.makedirs('data/colorado-flood/spatial/outputs')
```

{:.output}
    The directory exists!



### Exporting Numpy Arrays to Geotiffs

Next, you need to consider the metdata associated with your chm. Remember that the chm was generated using 2 numpy arrays. Neither of these arrays has spatial data directly associated with it. BUT you do have the rasterio object that has metadata that you can use if you want to assign all of the spatial attributes that are needed to save a usable geotiff file.

You can use the syntax

`**dictionary-metadata-object-here` 

to apply all of the spatial attributes from one of your raster objects, when you write out your new chm raster.

To begin, have a look at the lidar_dem metadata dictionary. Looking at the example below, all of the metadata in that dictionary are the same as what we expect the output chm to have. Thus we can use the metadata as they are. 

{:.input}
```python
lidar_dem.meta
```

{:.output}
{:.execute_result}



    {'driver': 'GTiff',
     'dtype': 'float32',
     'nodata': -3.4028234663852886e+38,
     'width': 4000,
     'height': 2000,
     'count': 1,
     'crs': CRS({'init': 'epsg:32613'}),
     'transform': Affine(1.0, 0.0, 472000.0,
            0.0, -1.0, 4436000.0)}





Next, let's update the no data value. The number being used currently is difficult to remember. A more standard value like `-999.99` could be a better option. To implement this we will do two things

1. we will assign all masked pixels values which represent no data values to -999.99 using the `np.ma.filled()` function.
2. Then we will create a new metadata dictionary that contained the updated nodata value.

{:.input}
```python
# fill the masked pixels with a set no data value
nodatavalue = -999.99
lidar_chm = np.ma.filled(lidar_chm, fill_value=nodatavalue)
```

Then update the metadata dictionary. 

{:.input}
```python
# update the metadata to ensure the nodata value is properly documented 

# create dictionary copy
chm_meta = lidar_dem.meta.copy()
# update the nodata value to be an easier to use number
chm_meta.update({'nodata': nodatavalue})
chm_meta
```

{:.output}
{:.execute_result}



    {'driver': 'GTiff',
     'dtype': 'float32',
     'nodata': -999.99,
     'width': 4000,
     'height': 2000,
     'count': 1,
     'crs': CRS({'init': 'epsg:32613'}),
     'transform': Affine(1.0, 0.0, 472000.0,
            0.0, -1.0, 4436000.0)}





If you want, you can check things like the shape of the numpy array to ensure that it is the same as the width and height of the dem. It should be! 

{:.input}
```python
# note the width and height of the dem above. Is the numpy array shape the same?
lidar_chm.shape
```

{:.output}
{:.execute_result}



    (2000, 4000)





Finally, you can export your raster layer. Below you do the following

1. you use the same `rio.open()` syntax that you are used to using except now you specify that you are writing a new file with the 'w' argument.
2. you specify the new file name and destination in the `rio.open()` function eg: `'data/colorado-flood/spatial/outputs/lidar_chm.tiff'`
2. you specify the metadata as an "unpacked" dictionary using `**lidar_dem.meta` - doing this allows you to NOT have to specify EACH and EVERY metadata element individually in your output statement - which would be tedious!
3. finally you write the file. `output_file.write(your-object-name, layer)`  Notice that when you make this call you specify both the object name and the layer that you wish to write to a new file. Also notice the `outf` is the name of the rasterio object as defined below. 

{:.input}
```python
out_path = "data/colorado-flood/spatial/outputs/lidar_chm.tiff"
with rio.open(out_path, 'w', **chm_meta) as outf:
    outf.write(lidar_chm, 1)
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge

Practice your skills. Open the lidar_chm geotiff file that you just created. 
Do the following:

1. View the crs - is it correct?
2. View the x and y spatial resolution. 
3. Plot the data using a color bar of your choice. 

Your plot should look like the one below (athough the colors may be different.
</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_33_0.png">

</figure>




### Colorbars With Custom Labels in Matplotlib
You can also modify the colorbar to the right so that each bin has a human-readable category.

{:.input}
```python
fig, ax = plt.subplots()
chm_plot = ax.imshow(lidar_chm_im, 
                     cmap=cmap, 
                     norm=norm, extent=plotting_extent(lidar_chm))
ax.set_title("Lidar Canopy Height Model (CHM)");
# scale color bar to the height of the plot
#divider = make_axes_locatable(ax)
#cax = divider.append_axes("right", size="3%", pad=0.15)
cbar = es.colorbar(chm_plot);

boundary_means = [np.mean([norm.boundaries[ii], norm.boundaries[ii - 1]])
                  for ii in range(1, len(norm.boundaries))]
category_names = ['No vegetation', 'Short', 'Medium', 'Tall']
cbar.set_ticks(boundary_means)
cbar.set_ticklabels(category_names)
ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_35_0.png">

</figure>



<div class="notice--success" markdown="1">

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip:** You can simplify the directory code above by using the exclamation `not` which tells Python to return the INVERSE or opposite of the function you have requested Python to run.
</div>