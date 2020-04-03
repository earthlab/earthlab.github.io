---
layout: single
title: "Open, Plot and Explore Raster Data with Python"
excerpt: "Rasters are gridded data composed of pixels that store values, such as an image or elevation data file. Learn how to open, plot, and explore raster files in Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-03-06
category: [courses]
class-lesson: ['intro-raster-python-tb']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/open-lidar-raster-python/
nav-title: 'Open Raster Data Python'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: false
order: 3
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/open-lidar-raster-python/"
  - "/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/open-lidar-raster-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Open, plot, and explore raster data using **Python**.

</div>


## Open Raster Data in Python

You can use the **rasterio** library combined with **numpy** and **matplotlib** to open, manipulate and plot raster data in **Python**.

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from shapely.geometry import Polygon, box
import geopandas as gpd
import rasterio as rio
from rasterio.plot import show
from rasterio.mask import mask

# Package created for the earth analytics program
import earthpy as et
import earthpy.plot as ep

# Prettier plotting with seaborn
sns.set(font_scale=1.5, style="white")
```

{:.input}
```python
# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



Note that you imported the **rasterio** library using the shortname `rio`.

Now, you can use the `rio.open("path-to-raster-here")` function to open a raster dataset.

{:.input}
```python
# Define relative path to file
lidar_dem_path = os.path.join("data", "colorado-flood", "spatial", 
                              "boulder-leehill-rd", "pre-flood", "lidar",
                              "pre_DTM.tif")
# Open raster data
lidar_dem = rio.open(lidar_dem_path)
```

To check your data, you can query the spatial extent of the data using the attribute `.bounds`. 

You can also quickly plot the raster using the **rasterio** function called `show()`. The function argument `title = "Plot title here"` adds a title to the plot.

{:.input}
```python
# Query the spatial extent of the data
lidar_dem.bounds
```

{:.output}
{:.execute_result}



    BoundingBox(left=472000.0, bottom=4434000.0, right=476000.0, top=4436000.0)





{:.input}
```python
# Plot the dem using raster.io
fig, ax = plt.subplots(figsize = (8,3))

show(lidar_dem, 
     title="Lidar Digital Elevation Model (DEM) \n Boulder Flood 2013", 
     ax=ax)

ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster01-open-lidar-raster-data-python/2018-02-05-raster01-open-lidar-raster-data-python_8_0.png" alt = "A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO.">
<figcaption>A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO.</figcaption>

</figure>




### Opening and Closing File Connections

The rasterio library is efficient as it establishes a connection with the 
raster file rather than directly reading it into memory. Because it creates a 
connection, it is important that you close the connection after it is opened
AND after you've finished working with the data!


{:.input}
```python
# Close the connection
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
# Open raster data connection - again
lidar_dem = rio.open(lidar_dem_path)

fig, ax = plt.subplots(figsize = (8,3))

show(lidar_dem, 
     title="Once the connection is re-opened \nyou can work with the raster data", 
     ax=ax)

ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster01-open-lidar-raster-data-python/2018-02-05-raster01-open-lidar-raster-data-python_13_0.png" alt = "A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO.">
<figcaption>A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO.</figcaption>

</figure>




{:.input}
```python
lidar_dem.close()
```

## Context Manager to Open/Close Raster Data

A better way to work with raster data in **rasterio** is to use the context manager. This will handle opening and closing the raster file for you. 

`with rio.open(path-to-file') as src:
    src.rasteriofunctionname`


{:.input}
```python
with rio.open(lidar_dem_path) as src:
    print(src.bounds)
```

{:.output}
    BoundingBox(left=472000.0, bottom=4434000.0, right=476000.0, top=4436000.0)



With a context manager, you create a connection to the file that you'd like to open. 
However, once your are outside of the `with` statement, that connection closes. Thus
you don't have to worry about opening and closing files using this syntax.

{:.input}
```python
# Note that the src object is now closed
src
```

{:.output}
{:.execute_result}



    <closed DatasetReader name='data/colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif' mode='r'>





## Raster Plots with Matplotlib

Above you used the `show()` function to plot a rasterio object. Show "wraps" around the **matplotlib** plotting library to produce a plot. 

However, you will explore plotting a numpy array with **matplotlib** directly. Using **matplotlib** allows you to fully customize your plots. Alongside **matplotlib**, you will also be exploring using another "wrapper" function to aide in the plotting, `earthpy.plot`.

To plot using **matplotlib** and **earthpy** directly you:

1. open the raster
2. `create a spatial_extent` object that contains the boundary information needed to plot your raster in space using `rio.plot.plotting_extent`
3. Read in the raster data itself into a numpy array using `.read()`




{:.input}
```python
with rio.open(lidar_dem_path) as src:
    
    # Convert / read the data into a numpy array:
    lidar_dem_im = src.read()
    
    # Create a spatial extent object using rio.plot.plotting
    spatial_extent = rio.plot.plotting_extent(src)
    
    # Get bounds of object
    bounds = src.bounds
```

You can use the `rio.plot.plotting_extent` function to create a spatial extent in the format 
that **matplotlib** needs to plot your raster. 

### Spatial Extents and Plotting 

The bounding box output - which represents the spatial extent of your raster, is 
provided to use in a **rasterio** specific format. To plot with **matplotlib**, you need to 
provide a vector that contains the spatial extent in the following format:

`[left, right, bottom, top]`

However, if you just use the `.bounds` object that rasterio provides, the numbers are not in the correct order. You can use `rio.plot.plotting_extent(rasterio-object-name-here)` function to get a spatial extent in the format that matplotlib requires

{:.input}
```python
# This is the format that matplotlib wants
print("spatial extent:", spatial_extent)

# This is the format that rasterio provides with the bounds attribute
print("rasterio bounds:", bounds)
```

{:.output}
    spatial extent: (472000.0, 476000.0, 4434000.0, 4436000.0)
    rasterio bounds: BoundingBox(left=472000.0, bottom=4434000.0, right=476000.0, top=4436000.0)




### Read Files with Rasterio into Numpy

Next let's explore how you read in a raster using rasterio. When you use `.read()`, rasterio imports the data from your raster into a **numpy array**. 

Remember that a **numpy array** is simply a matrix of values with no particular spatial attributes associated 
with them. **Numpy arrays** are, however, a very efficient structure for working with large and potentially multi-dimensional (layered) matrices.

{:.input}
```python
with rio.open(lidar_dem_path) as src:
    # Convert / read the data into a numpy array
    # masked = True turns `nodata` values to nan
    lidar_dem_im = src.read(1, masked=True)
    
    # Create a spatial extent object using rio.plot.plotting
    spatial_extent = rio.plot.plotting_extent(src)

print("object shape:", lidar_dem_im.shape)
print("object type:", type(lidar_dem_im))
```

{:.output}
    object shape: (2000, 4000)
    object type: <class 'numpy.ma.core.MaskedArray'>



Below you read in the data using `src.read` where
`src` is the name of the object that you defined within the context manager and
`read(1)` reads in just the first layer in your raster. Specifying the `1` is important as it will force rasterio to import the raster into a 2 dimensional vs a 3 dimensional array. 

See the example below

{:.input}
```python
with rio.open(lidar_dem_path) as src:
    
    # Convert / read the data into a numpy array:
    lidar_dem_im2 = src.read(1)

with rio.open(lidar_dem_path) as src:
    
    # Convert / read the data into a numpy array:
    lidar_dem_im3 = src.read()

print("Array Shape Using read(1):", lidar_dem_im2.shape)

# Notice that without the (1), your numpy array has a third dimension
print("Array Shape Using read():", lidar_dem_im3.shape)
```

{:.output}
    Array Shape Using read(1): (2000, 4000)
    Array Shape Using read(): (1, 2000, 4000)



Also notice that you used the argument `masked=True` in your `.read()` statement. This sets all `nodata` values in your data to `nan` which you will want for plotting!

## Plot Numpy Array

Finally, you can plot your data using `ep.plot_bands()`. Notice that you provide `ep.plot_bands()` with the 
`spatial_extent` object that you created above to ensure that the x and y axis 
represent the pixel locations of your raster data.  

{:.input}
```python
ep.plot_bands(lidar_dem_im,
              cmap='Greys',
              extent=spatial_extent,
              title="Digital Elevation Model - Pre 2013 Flood",
              cbar=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster01-open-lidar-raster-data-python/2018-02-05-raster01-open-lidar-raster-data-python_32_0.png" alt = "A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO with a grey color map applied.">
<figcaption>A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO with a grey color map applied.</figcaption>

</figure>




Let's plot again but this time you will:

1. add a colorbar legend
2. increase the title font size using the `as.set_title` function and the `fontsize` argument 

EarthPy's `plot_bands()` function adds a colorbar to your plot automatically. In the last plot, you'll notice the argument called `cbar` is set to `False`. This turns off the colorbar. The default value for the `cbar` argument is `True`. This means if you don't modify that argument, the colorbar will automatically appear! However, you may also notice a new argument in this plot, `scale=False`. By default, `plot_bands()` will scale values in a raster from 0 to 255. Since this is elevation data, you can avoid this by setting `scale=False`. 

Additionally, you will be using **matplotlib** and `earthpy.plot` together in this plot, in order to modify the title font size. `plot_bands()` can be added into any normal matplotlib plot by just giving it an axis object in the `ax=` argument. 

{:.input}
```python
fig, ax = plt.subplots(figsize=(12, 10))
ep.plot_bands(lidar_dem_im,
              cmap='Greys',
              extent=spatial_extent,
              scale=False,
              ax=ax)
ax.set_title("Lidar Digital Elevation Model \n Pre 2013 Boulder Flood | Lee Hill Road", 
             fontsize=24)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster01-open-lidar-raster-data-python/2018-02-05-raster01-open-lidar-raster-data-python_34_0.png" alt = "A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO with a colorbar.">
<figcaption>A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO with a colorbar.</figcaption>

</figure>




<div class="notice--success" markdown="1">

### <i class="fa fa-star"></i> Color Ramps

To plot you can select <a href="https://matplotlib.org/users/colormaps.html" target="_blank">pre-determined color ramps</a> from **matplotlib**, you can reverse a color ramp by adding `_r` at the end of the color ramps name, for example `cmap = 'viridis_r'`. 

</div>


### Explore Raster Data Values with Histograms

Next, you will explore a histogram of your data. A histogram is useful to help 
you better understand the distribution of values within your data. In this 
case given you are looking at elevation data, if there are all small elevation values 
and the histogram looks uniform (not too much variation in values) you can assume 
that your study area is relative "flat" - not too hilly. If there is a different
distribution of elevation values you can begin to understand the 
range of elevation values in your study area and the degree of difference between 
low and high regions (i.e. is it flat or hilly?). Is it high elevation vs 
low elevation?

{:.input}
```python
lidar_dem_im
```

{:.output}
{:.execute_result}



    masked_array(
      data=[[--, --, --, ..., 1695.6300048828125, 1695.419921875,
             1695.429931640625],
            [--, --, --, ..., 1695.5999755859375, 1695.5399169921875,
             1695.3599853515625],
            [--, --, --, ..., 1695.3800048828125, 1695.43994140625,
             1695.3699951171875],
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
      fill_value=-3.4028235e+38,
      dtype=float32)







{:.input}
```python
# Plot histogram
ep.hist(lidar_dem_im[~lidar_dem_im.mask].ravel(),
        bins=100,
        title="Lee Hill Road - Digital elevation (terrain) model - \nDistribution of elevation values")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster01-open-lidar-raster-data-python/2018-02-05-raster01-open-lidar-raster-data-python_41_0.png" alt = "A histogram of lidar derived elevation values for Boulder, CO.">
<figcaption>A histogram of lidar derived elevation values for Boulder, CO.</figcaption>

</figure>





## Adjust Plot Extent to "Zoom in" on Your Raster Data

If you want to quickly zoom in on a portion of your raster data, you can adjust the x and y 
spatial extents of your matplotlib plot. To do this, you will create a new spatial extent that is smaller than the 
original spatial extent of the data. 


{:.input}
```python
# Define a spatial extent that is "smaller"
# minx, miny, maxx, maxy, ccw=True
zoomed_extent = [472500, 4434000, 473030, 4435030]
```

Next you'll define a box which you'll focus on. You've provided a small helper function that lets you give the x and y limits of a box, and it returns the `x,y` points corresponding to four corners of this box. It then returns a `shapely` polygon object.




{:.input}
```python
# Turn extent into geodataframe
zoom_ext_gdf = gpd.GeoDataFrame()
zoom_ext_gdf.loc[0, 'geometry'] = box(*zoomed_extent)
```

{:.input}
```python
# Plot the original data with the boundary box
fig, ax = plt.subplots(figsize=(8, 3))

ep.plot_bands(lidar_dem_im,
              extent=spatial_extent,
              title="Lidar Raster Full Spatial Extent w Zoom Box Overlayed",
              ax=ax,
              scale=False)

zoom_ext_gdf.plot(ax=ax)

ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster01-open-lidar-raster-data-python/2018-02-05-raster01-open-lidar-raster-data-python_49_0.png" alt = "A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO with an extent box overlayed on top.">
<figcaption>A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO with an extent box overlayed on top.</figcaption>

</figure>




{:.input}
```python
# Plot the data but set the x and y lim
fig, ax = plt.subplots(figsize=(8, 3))

ep.plot_bands(lidar_dem_im,
              extent=spatial_extent,
              title="Lidar Raster Zoomed on a Smaller Spatial Extent",
              ax=ax,
              scale=False)

# Set x and y limits of the plot
ax.set_xlim(zoomed_extent[0], zoomed_extent[2])
ax.set_ylim(zoomed_extent[1], zoomed_extent[3])

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster01-open-lidar-raster-data-python/2018-02-05-raster01-open-lidar-raster-data-python_50_0.png" alt = "A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO clipped to a smaller spatial extent using the x and y lim plot parameters.">
<figcaption>A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO clipped to a smaller spatial extent using the x and y lim plot parameters.</figcaption>

</figure>



