---
layout: single
title: "Subtract Raster Data in Python"
excerpt: "You will create a CHM using the DSM and DEM via raster subtraction in Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-07-27
category: [courses]
class-lesson: ['intro-lidar-raster-python']
permalink: /courses/earth-analytics-python/raster-lidar-intro/subtract-raster/
nav-title: 'Subtract Raster'
week: 3
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming:
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

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download the 2013 Colorado Flood Teaching Data (~250 MB)](https://ndownloader.figshare.com/files/12395030){:data-proofer-ignore='' .btn } 

</div>

### Be sure to set your working directory
`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import rasterio as rio
import numpy as np
import earthpy as et
import matplotlib.pyplot as plt
from matplotlib.patches import Patch
from mpl_toolkits.axes_grid1 import make_axes_locatable
import os
plt.ion()
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
    lidar_dem_im = lidar_dem.read(masked=True)
    bounds = lidar_dem.bounds

    # Reshape the bounds into a form that matplotlib wants
    bounds = [bounds.left, bounds.right, bounds.bottom, bounds.top]
```

### Import Digital Surface Model (DSM)

Next, let's open the digital surface model (DSM). The DSM represents the top of
the earth's surface. Thus, it INCLUDES TREES, BUILDINGS and other objects that
sit on the earth.

{:.input}
```python
with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DSM.tif') as lidar_dsm:
    lidar_dsm_im = lidar_dsm.read(masked=True)
```

{:.input}
```python
lidar_dsm_im
```

{:.output}
{:.execute_result}



    masked_array(
      data=[[[--, --, --, ..., 1695.6300048828125, 1695.5899658203125,
              1696.3900146484375],
             [--, --, --, ..., 1695.5999755859375, 1695.6300048828125,
              1697.0],
             [--, --, --, ..., 1695.3800048828125, 1695.43994140625,
              1695.449951171875],
             ...,
             [--, --, --, ..., 1681.449951171875, 1681.3900146484375,
              1681.25],
             [--, --, --, ..., 1681.719970703125, 1681.5699462890625,
              1681.5599365234375],
             [--, --, --, ..., 1681.8900146484375, 1681.8099365234375,
              1681.739990234375]]],
      mask=[[[ True,  True,  True, ..., False, False, False],
             [ True,  True,  True, ..., False, False, False],
             [ True,  True,  True, ..., False, False, False],
             ...,
             [ True,  True,  True, ..., False, False, False],
             [ True,  True,  True, ..., False, False, False],
             [ True,  True,  True, ..., False, False, False]]],
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

<i fa fa-star></i>**Data Tip:** Note that this method of subtracting 2 rasters to create a CHM may not give you the most accurate results! There are better ways to create CHM's using the point clouds themselves. However, in this lesson you learn this method as a means to get more familiar with the CHM dataset and to understand how to perform raster calculations in `Python`. 
{: .notice--success}


{:.input}
```python
# calculate canopy height model
lidar_chm = lidar_dsm_im - lidar_dem_im
```

{:.input}
```python
fig, ax = plt.subplots(figsize = (10,10))
chm_plot = ax.imshow(lidar_chm[0], cmap='viridis')
ax.set_axis_off()

# scale color bar to the height of the plot
divider = make_axes_locatable(ax)
cax = divider.append_axes("right", size="3%", pad=0.15)
fig.colorbar(chm_plot, cax = cax)
ax.set_title("Lidar Canopy Height Model (CHM)", 
             fontsize = 16);
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_11_0.png)




{:.input}
```python
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
plt.rcParams['axes.facecolor']='white'
plt.rcParams['grid.color'] = 'grey'
plt.rcParams['grid.linestyle'] = '-'
plt.rcParams['grid.linewidth'] = '.5'
plt.rcParams['lines.color'] = 'purple'
```

{:.input}
```python
fig, ax = plt.subplots(figsize = (14,14))
ax.hist(lidar_chm.ravel(), color = 'purple');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_13_0.png)




Take a close look at the output CHM. Do you think that the data just represents trees? Or do you see anything that may suggest that there are other types of objects represented in the data?


### Exploring your CHM

Let's explore your data a bit more to better understand the range of tree (and building) heights that you have in your CHM. 

{:.input}
```python
print('CHM minimum value: ', lidar_chm.min())
print('CHM max value: ', lidar_chm.max())
```

{:.output}
    CHM minimum value:  0.0
    CHM max value:  26.930054




## Plots Using Breaks

Sometimes a gradient of colors is useful to represent a continuous variable.
But other times, it's useful to apply colors to particular ranges of values
in a raster. These ranges may be statistically generated or simply visually.

Create breaks in your CHM plot.

{:.input}
```python
from matplotlib.colors import ListedColormap
# note that you have to have colors loaded to for BoundaryNorm to work
import matplotlib.colors as colors
```

{:.input}
```python
# Define the colors you want
cmap = ListedColormap(["white", "tan", "springgreen", "darkgreen"])

# Define a normalization from values -> colors
norm = colors.BoundaryNorm([0, 2, 10, 20, 30], 5)
```

{:.input}
```python
fig, ax = plt.subplots(figsize=(20, 20))
chm_plot = ax.imshow(lidar_chm[0], cmap=cmap, norm=norm)
ax.set_title("Lidar Canopy Height Model (CHM)", fontsize=16)

# scale color bar to the height of the plot
divider = make_axes_locatable(ax)
cax = divider.append_axes("right", size="3%", pad=0.15)
plt.colorbar(chm_plot, cax=cax, spacing="proportional")

# Add a legend for labels
legend_labels = {"tan": "short", "springgreen": "medium", "darkgreen": "tall"}
patches = [Patch(color=color, label=label) for color, label in legend_labels.items()]
ax.legend(handles=patches)
ax.set_axis_off();
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_19_0.png)




## Export a Raster

You can export a raster file in `python` using the `rasterio` `write()` function. Let's
export the canopy height model that you just created to your data folder. You will create a new directory called "outputs" within the week 3 directory. This structure allows you to keep things organized, separating your outputs from the data you downloaded.

NOTE: you can use the code below to check for and create an outputs directory. OR, you can create the directory yourself using the finder (MAC) or windows
explorer.

{:.input}
```python
if os.path.exists('data/colorado-flood/spatial/outputs'):
    print('The directory exists!')
else:
    os.makedirs('data/colorado-flood/spatial/outputs')
```

{:.input}
```python
with rio.open('data/colorado-flood/spatial/outputs/lidar_chm.tiff', 'w', driver='GTiff',
              width=lidar_dem.width, height=lidar_dem.height, count=lidar_dem.count, crs=lidar_dem.crs,
              dtype=lidar_dem.dtypes[0], nodata=lidar_chm.fill_value, affine=lidar_dem.affine) as ff:
    ff.write(lidar_chm)
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Practice your skills. Open the lidar_chm geotiff file that you just created. 
Do the following:

1. View the crs - is it correct?
2. View the x and y spatial resolution. 
3. Plot the data using a color bar of your choice. 

Your plot should look like the one below (athough the colors may be different.
</div>


{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_24_0.png)




You can also modify the colorbar to the right so that each bin has a human-readable category.

{:.input}
```python
fig, ax = plt.subplots(figsize=(20, 20))
chm_plot = ax.imshow(lidar_chm_b[0], cmap=cmap, norm=norm, extent=spatial_extent)
ax.set_title("Lidar Canopy Height Model (CHM)", fontsize=16);
# scale color bar to the height of the plot
divider = make_axes_locatable(ax)
cax = divider.append_axes("right", size="3%", pad=0.15)
cbar = plt.colorbar(chm_plot, cax=cax);

boundary_means = [np.mean([norm.boundaries[ii], norm.boundaries[ii - 1]])
                  for ii in range(1, len(norm.boundaries))]
category_names = ['No vegetation', 'Short', 'Medium', 'Tall']
cbar.set_ticks(boundary_means)
cbar.set_ticklabels(category_names)
ax.set_axis_off();
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster05-subtract-rasters_26_0.png)



<div class="notice--success" markdown="1">

<i class="fa fa-star" aria-hidden="true"></i>**Data Tip:** You can simplify the directory code above by using the exclamation `not` which tells Python to return the INVERSE or opposite of the function you have requested Python to run.
</div>