---
layout: single
title: "Open, Plot and Explore Lidar Data in Raster Format with Python"
excerpt: "This lesson introduces the raster geotiff file format - which is often used
to store lidar raster data. You will learn the 3 key spatial attributes of a raster dataset
including Coordinate reference system, spatial extent and resolution."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-07-27
category: [courses]
class-lesson: ['intro-lidar-raster-python']
permalink: /courses/earth-analytics/raster-lidar-intro/open-lidar-raster-python/
nav-title: 'Open Raster Data Python'
module-title: 'Work with Lidar Raster Data in Python'
module-description: 'This module introduces the raster spatial data format as it
relates to working with lidar data in Python. Learn how to to open, crop and classify raster data in Python.'
module-nav-title: 'Lidar Raster Data in Python'
module-type: 'class'
week: 3
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: false
order: 1
class-order: 2
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

* Open a lidar raster dataset in `Python`.
* Be able to list and define 3 spatial attributes of a raster dataset: extent, crs and resolution.
* Be able to identify the resolution of a raster in `Python`.
* Be able to plot a lidar raster dataset in `Python`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download the 2013 Colorado Flood Teaching Data (~250 MB)](https://ndownloader.figshare.com/files/12395030){:data-proofer-ignore='' .btn }

</div>

In the last lesson, you reviewed the basic principles behind what a lidar raster
dataset is in `Python` and how point clouds are used to derive the raster. In this lesson, you will learn how to open a plot a lidar raster dataset in `Python`. You will also learn about key attributes of a raster dataset:

1. Spatial resolution
2. Spatial extent and
3. Coordinate reference systems

<figure>
  <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/gridding.gif">
  <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/gridding.gif" alt="Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format"></a>
  <figcaption>
  Animation that shows the general process of taking lidar point clouds and
  converting them to a Raster Format. Source: Tristan Goulden, NEON.
  </figcaption>
</figure>


## Open Raster Data in Python

You can use the `rasterio` library combined with `numpy` and `matplotlib` to open, manipulate and plot raster data in `Python`.


### Be sure to set your working directory
`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import rasterio as rio
from rasterio.plot import show
import matplotlib.pyplot as plt
import numpy as np
import os
plt.ion()

from shapely.geometry import Polygon, mapping
from rasterio.mask import mask

import earthpy as et # a package created for this class that will be discussed later in this lesson
```

Note that you import the `rasterio` library using the shortname `rio`.
You use the `rio.open("path-to-raster-here")` function to open a raster dataset using `rio` in `Python`.
Note that you use the `plot()` function to plot the data. The function argument

`title = "Plot title here"` adds a title to the plot.



{:.input}
```python
# open raster data
lidar_dem = rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif')
```

You can quickly plot the raster using the `rasterio` function,  `show()`.

{:.input}
```python
lidar_dem.bounds
```

{:.output}
{:.execute_result}



    BoundingBox(left=472000.0, bottom=4434000.0, right=476000.0, top=4436000.0)





{:.input}
```python
# plot the dem using raster.io
fig, ax = plt.subplots()
show(lidar_dem, title="Lidar Digital Elevation Model (DEM) \n Boulder Flood 2013", ax=ax)
ax.set_axis_off()
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster01-open-lidar-raster-data-python_8_0.png)




### Opening and Closing File Connections

The rasterio library is efficient as it establishes a connection with the 
raster file rather than directly reading it into memory. Because it creates a 
connection, it is important that you close the connection after it is opened
AND after you've finished working with the data!


{:.input}
```python
# close the connection
lidar_dem.close()
```

```
# this returns an error as you have closed the connection to the file. 
show(lidar_dem)
```

```
---------------------------------------------------------------------------
ValueError                                Traceback (most recent call last)
<ipython-input-7-dad244dfd7d3> in <module>()
      1 # this returns an error as you have closed the connection to the file.
----> 2 show(lidar_dem)

~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/rasterio/plot.py in show(source, with_bounds, contour, contour_label_kws, ax, title, **kwargs)
     80     elif isinstance(source, RasterReader):
     81         if source.count == 1:
---> 82             arr = source.read(1, masked=True)
     83         else:
     84             try:

rasterio/_io.pyx in rasterio._io.RasterReader.read (rasterio/_io.c:10647)()

rasterio/_io.pyx in rasterio._io.RasterReader._read (rasterio/_io.c:15124)()

ValueError: can't read closed raster file

```

Once the connection is closed, you can no longer work with the data. You'll need 
to re-open the connection. Like this:

{:.input}
```python
# open raster data connection - again
lidar_dem = rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif')

fig, ax = plt.subplots(figsize = (8,3))
show(lidar_dem, 
     title="Once the connection is re-opened \nyou can work with the raster data", ax=ax)
ax.set_axis_off()
```

{:.input}
```python
lidar_dem.close()
```

## Context Manager to Open/Close Raster Data

A better way to work with raster data in `rasterio` is to use the context manager. This will handle opening and closing the raster file for you. 

`with rio.open('name of file') as scr:
    scr.rasteriofunctionname`


## Raster Plots with Matplotlib

Here you are plotting with `rasterio` - which "wraps" around the python `matplotlib` plotting library to produce a plot. 
However, let's next explore plotting with `matplotlib` directly given that is how you will plot vector data next week. Using `matplotlib` allows you to fully customize your plots.

<!-- How carson gets the bounds element # Get the bounds of the raster (for plotting later)
#bounds = lidar_dem.bounds[::2] + lidar_dem.bounds[1::2]
#bounds -->

{:.input}
```python
# view spatial extent of raster object
with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif') as src:
    print(src.bounds)
```

The bounding box output - which represents the spatial extent of your raster, is 
provided to use in a `rasterio` specific format. To plot with matplotlib, you need to 
provide a vector that contains the spatial extent in the following format:

`[left, right, bottom, top]`

Thus below you create a new spatial extent object that contains the spatial extent
in the correct, `matplotlib`, format. 

{:.input}
```python
# Reshape the bounds into a form that matplotlib wants
spatial_extent = [src.bounds.left, src.bounds.right,
                  src.bounds.bottom, src.bounds.top]
spatial_extent
```

The final step is to convert out `rasterio` raster object to a `numpy array` for plotting in matplotlib.
Remember that a numpy array is simply a matrix of values with no particular spatial attributes associated 
with them.

{:.input}
```python
with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif') as src:

    # convert / read the data into a numpy array:
    lidar_dem_im = src.read()
    # set no data values to numpy nan 
    lidar_dem_im[lidar_dem_im == lidar_dem.nodata] = np.nan
    # view shape of the array -- is it the right size (number of pixels in the x and y directions)?
    print(lidar_dem_im.shape)
```

Finaly, you can plot your data using `imshow()`. Notice that you provide `imshow()` with the 
`spatial_extent` object that you created above to ensure that the x and y axis 
represent the pixel locations of your raster data.  

{:.input}
```python
fig = plt.figure(figsize = (8,3))
ax = fig.add_subplot(111)
ax.imshow(lidar_dem_im[0], cmap = 'Greys', extent = spatial_extent)
ax.set_title("Digital Elevation Model - Pre 2013 Flood")
```

Let's plot again but this time you will:

1. add a colorbar legend
2. turn off the annoying matplotlib message by adding a semicolon `;` to the end of the last line
3. turn off the axes given you don't need the coordinates in your plot
4. increase the title font size using the `as.set_title` function and the `fontsize` argument 

{:.input}
```python
fig = plt.figure(figsize = (8,3))
ax = fig.add_subplot(111)
lidar_plot = ax.imshow(lidar_dem_im[0], cmap = 'Greys', extent = spatial_extent)
ax.set_title("Lidar Digital Elevation Model \n Pre 2013 Boulder Flood | Lee Hill Road", fontsize= 20)
fig.colorbar(lidar_plot)
ax.set_axis_off();
```

Below you tweak the height of your colorbar to ensure it lines up with the top and bottom edges of your plot. To do this you use the `make_axes_locatable` package from the `mpl_toolkits.axes_grid1` library.

<div class="notice--success" markdown="1">

### <i class="fa fa-star"></i> Color Ramps

To plot you can select [pre-determined color ramps](https://matplotlib.org/users/colormaps.html) from `matplotlib`, you can reverse a color ramp by adding `_r` at the end of the color ramps name, for example `cmap = 'viridis_r'`. 

</div>

{:.input}
```python
fig = plt.figure(figsize=(8, 4))
ax = fig.add_subplot(111)
fin_plot = ax.imshow(lidar_dem_im[0], cmap='viridis_r')
ax.set_title("Digital Elevation Model - Pre 2013 Flood", fontsize=17)

# The easiest way to set the colorbar size is to tinker with fraction and pad to get it at the right spot
fig.colorbar(fin_plot, fraction=.024, pad=.02)

ax.set_axis_off()
```

### Explore Raster Data Values with Histograms

Next, let's explore a histogram of your data. A histogram is useful to help 
you better understand the distribution of values within your data. In this 
case given you are looking at elevation data, if there are all small elevation values 
and the histogram looks uniform (not too much variation in values) you can assume 
that your study area is relative "flat" - not too hilly. If there is a different
distribution of elevation values you can begin to understand the 
range of elevation values in your study area and the degree of difference between 
low and high regions (ie is it flat or hilly?). Is it high elevation vs 
low elevation?

{:.input}
```python
lidar_dem_im
```

{:.input}
```python
#format histograms
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
plt.rcParams['axes.facecolor']='white'
plt.rcParams['grid.color'] = 'grey'
plt.rcParams['grid.linestyle'] = '-'
plt.rcParams['grid.linewidth'] = '.5'
plt.rcParams['lines.color'] = 'purple'
plt.rcParams['axes.labelsize'] = 16
```

{:.input}
```python
# plot histogram
fig = plt.figure(figsize = (14,14))
ax = fig.add_subplot(111)

# You need to specifya custom range so that matplotlib can handle the `NaN`s
ax.hist(lidar_dem_im.ravel(), range=[np.nanmin(lidar_dem_im), np.nanmax(lidar_dem_im)], bins=100, color = 'purple')
ax.set_title("Lee Hill Road - Digital elevation (terrain) model - \nDistribution of elevation values", 
             fontsize = 20);
```

{:.input}
```python
# plot histogram
fig = plt.figure(figsize = (20,20))
ax = fig.add_subplot(111)

# Alternatively, you can drop the NaNs from the image
ax.hist(lidar_dem_im.ravel()[~np.isnan(lidar_dem_im.ravel())], bins=100, color = 'purple')
ax.set_title("Lee Hill Road - Digital elevation (terrain) model - \nDistribution of elevation values", 
             fontsize=20);

```

## Zoom in on your Plot

If you zoom in on a small section of the raster, you can see the individual pixels
that make up the raster. Each pixel has one value associated with it. In this
case that value represents the elevation of ground.

In order to zoom, you `crop` your data so that only a small subset remains. You'll
define a box that represents the area you want to zoom in on, and then show this
section alone.


{:.input}
```python
# create a new spatial extent 
print("Full Spatial extent of raster:", spatial_extent)
zoomed_extent = [473000, 473030, 4434000, 4434030]
print("Zoomed in raster extent:", zoomed_extent)
```

Next you'll define a box which you'll focus on. You've provided a small helper function that lets you give the x and y limits of a box, and it returns the `x,y` points corresponding to four corners of this box. It then returns a `shapely` polygon object.

` # code run by the function:`
`et.utils.bounds_to_box??`

{:.input}
```python
# Define the four corners of the box
box = et.utils.bounds_to_box(*zoomed_extent)
```

{:.input}
```python
# Now you'll show the box (see the tiny red square at the bottom)
with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif') as src:
    fig, ax = plt.subplots(figsize = (8,3))
    ax = show(src, extent=spatial_extent, ax=ax)
    x, y = box.exterior.xy
    ax.plot(x, y, '-', lw=3, color='r')
    ax.set_axis_off()
```

You can use this polygon object to "mask" your raster data. Effectively this removes the data that's outside of the box. If you re-plot, you see that the image is now much smaller and the color scale has changed to fit the new range of values.

{:.input}
```python
with rio.open('data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif') as src:
    out_image, out_transform = mask(src, [mapping(box)], crop=True)
    fig, ax = plt.subplots(figsize = (8,8))
    ax.imshow(out_image[0], extent=zoomed_extent)
    ax.set(title="Lidar Raster - Zoomed into to one small region")
    ax.set_axis_off()
```
