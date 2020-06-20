---
layout: single
title: "Open, Plot and Explore Raster Data with Python"
excerpt: "Rasters are gridded data composed of pixels that store values, such as an image or elevation data file. Learn how to open, plot, and explore raster files in Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-06-20
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
order: 2
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

You can use the **rasterio** library combined with **numpy** and **earthpy** to open, manipulate and plot raster data in **Python**. To begin load the packages that 
you need to process your raster data.

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import seaborn as sns
#import numpy as np
#from shapely.geometry import Polygon, box
import geopandas as gpd
# Import rasterio using the alias rio
import rasterio as rio
# Plotting extent is used to plot raster and vector data together
from rasterio.plot import plotting_extent
#from rasterio.mask import mask

import earthpy as et
import earthpy.plot as ep

# Prettier plotting with seaborn
sns.set(font_scale=1.5, style="white")
```

{:.input}
```python
# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



# TODO -- Add link to DTM explanation on lidar lesson and link to neon in new tabs

Below, you define the path to a lidar derived digital terrain model that was 
created using NEON (the National Ecological Observatory Network) data. 
You then open the data using `rio.open("path-to-raster-here")`.

{:.input}
```python
# Define relative path to file
lidar_dem_path = os.path.join("colorado-flood", "spatial",
                              "boulder-leehill-rd", "pre-flood", "lidar",
                              "pre_DTM.tif")

# Open the file using a context manager ("with rio.open" statement)
with rio.open(lidar_dem_path) as dem_src:
    lidar_dem_arr = dem_src.read(1)
```

Finally you can plot your data using earthpy `plot_bands()`.

{:.input}
```python
# Plot your data using earthpy
ep.plot_bands(lidar_dem_arr,
              title="Lidar Digital Elevation Model (DEM) \n Boulder Flood 2013",
              cmap="Greys")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_7_0.png" alt = "A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO.">
<figcaption>A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO.</figcaption>

</figure>




The data above should represent terrain model data. However, the range of 
values is not what is expected. These data are for Boulder, Colorado where 
the elevation may range from 1000-3000m. 

There may be some outlier values in the data that may need to be addressed. 
Below you check out the min and max values of the data. 


{:.input}
```python
print("the minimum raster value is: ", lidar_dem_arr.min())
print("the maximum raster value is: ", lidar_dem_arr.max())
```

{:.output}
    the minimum raster value is:  -3.4028235e+38
    the maximum raster value is:  2087.43



{:.input}
```python
# A histogram can also be helpful to look at the range of values in your data
# What do you notice about the histogram below?
ep.hist(lidar_dem_arr,
       figsize=(10,6))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_10_0.png">

</figure>




Looking at the minimum value of the data, there is one of two things going on
that need to be fixed

1. there may be no data values in the data with a negative value that are skewing your plot colors
2. there also could be outlier data in your raster

You can explore the first option - that there are no data values by reading 
in the data and masking no data values using rasterio. To do this, you will use the `masked=True` parameter for the `.read()` function - like this:

`dem_src.read(1, masked=True)`

{:.input}
```python
# Read in your data and mask the no data values
with rio.open(lidar_dem_path) as dem_src:
    # Masked=True will mask all no data values
    lidar_dem_arr = dem_src.read(1, masked=True)
```

Notice that now the minimum value looks more like
an elevation value (which should most often not be negative). 

{:.input}
```python
print("the minimum raster value is: ", lidar_dem_arr.min())
print("the maximum raster value is: ", lidar_dem_arr.max())
```

{:.output}
    the minimum raster value is:  1676.21
    the maximum raster value is:  2087.43



{:.input}
```python
# A histogram can also be helpful to look at the range of values in your data
ep.hist(lidar_dem_arr,
       figsize=(10,6),
       title="Histogram of the Data with No Data Values Removed")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_15_0.png">

</figure>




Plot your data again to see how it looks. 

{:.input}
```python
# Plot data using earthpy
ep.plot_bands(lidar_dem_arr,
              title="Lidar Digital Elevation Model (DEM) \n Boulder Flood 2013",
              cmap="Greys")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_17_0.png">

</figure>




# TODO - link to numpy lessons

## Rasterio Reads Files into Python as Numpy Arrays

When you call `src.read()` above, rasterio is reading in the data as a 
**numpy array**. A **numpy array** is a matrix of values. **Numpy arrays** are an 
efficient structure for working with large and potentially multi-dimensional (layered) matrices.

The numpy array below is type `numpy.ma.core.MaskedArray`. It is a masked
array because you chose to mask the no data values in your data. Masking
ensures that when you plot and perform other math operations on your data, 
those no data values are not included in the operations.

{:.input}
```python
with rio.open(lidar_dem_path) as dem_src:
    lidar_dem_im = dem_src.read(1, masked=True)

print("Numpy Array Shape:", lidar_dem_im.shape)
print("Object type:", type(lidar_dem_im))
```

{:.output}
    Numpy Array Shape: (2000, 4000)
    Object type: <class 'numpy.ma.core.MaskedArray'>



A numpy array does not by default store spatial information. However, your 
raster data is spatial - it represents a location on the earth's surface. 

You can acccess the spatial metadata within the context manager using 
`dem_src.profile`. Notice that the `.profile` object contains information including
the no data values for your data, the shape, the file type and even the coordinate 
reference system. You will learn more about raster metadata in a later lesson
in this chapter.

# TODO -- link to raster metadata lessons


{:.input}
```python
with rio.open(lidar_dem_path) as dem_src:
    lidar_dem_im = dem_src.read(1, masked=True)
    # Create an object called lidar_dem_meta that contains the spatial metadata
    lidar_dem_meta = dem_src.profile

lidar_dem_meta
```

{:.output}
{:.execute_result}



    {'driver': 'GTiff', 'dtype': 'float32', 'nodata': -3.4028234663852886e+38, 'width': 4000, 'height': 2000, 'count': 1, 'crs': CRS.from_epsg(32613), 'transform': Affine(1.0, 0.0, 472000.0,
           0.0, -1.0, 4436000.0), 'blockxsize': 128, 'blockysize': 128, 'tiled': True, 'compress': 'lzw', 'interleave': 'band'}






## Context Managers to Open and Close File Connections - "With" Statements in Python

The steps above represent the steps you need to open and plot a raster 
dataset using rasterio in python. The `with rio.open()` statement creates
what is known as a context manager. A context manager allows you to open 
the data and work with it. Within the context manager, Python makes 
a temporary connection to the file that you are trying to open. 

In the example above this was a file called `pre_DTM.tif`.

To break this code down, the context manager has a few parts. 
First, it has a `with` statement. The `with` statement creates 
a connection to the file that you want to open. The default connection
type is read only. This means that you can NOT modify that file
by default. Not being able to modify the original data is a good thing
because it prevents you from making unintended changes to your 
original data.

```
with rio.open(`file-path-here`) as file_src:
   lidar_dem_arr = dem_src.read(1, masked=True)
```

Notice that the first line of the context manager is not indented.
It contains two parts

1 `rio.open()`: This is the code that will open a connection to your .tif file using a path you provide. 
2. `file_src`: this is a rasterio reader object that you can use to read in the actual data. You can also use this object to access the metadata for the raster file.

The second line of your with statement 

  `lidar_dem_arr = dem_src.read(1, masked=True)`

is indented. Any code that is indented
directly below the with statement will become a part of the context manager.
This code has direct access to the `file_src` object which is you recall above is
the rasterio reader object.

Opening and closing files using rasterio and context managers is efficient as it establishes a connection to the raster file rather than directly reading it into memory. 

Once you are done opening and reading in the data, the context manager closes
that connection to the file. This efficiently ensures that the file won't be modified 
later in your code. 



<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:**  You can open and close files without 
a context manager using the syntax below. This approach however is generally
not recommended. 

```
lidar_dem = rio.open(lidar_dem_path)
lidar_dem.close()
```
</div>

{:.input}
```python
# Notice here the src object is printed and returns an "open" DatasetReader object
with rio.open(lidar_dem_path) as src:
    print(src)
```

{:.output}
    <open DatasetReader name='colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif' mode='r'>



{:.input}
```python
# Note that the src object is now closed because it's not within the indented
# part of the context manager above
print(src)
```

{:.output}
    <closed DatasetReader name='colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif' mode='r'>





## Plotting Raster and Vector Data Together -- Plot Extents

Numpy arrays are an efficient way to store and process data. However, by default
they do not contain spatial information. To plot raster and vector data together 
on a map, you will need to create an extent object that defines the spatial extent
of your raster layer. This will then allow you to plot a raster and vector
data together to create a map.  

Below you open a single shapefile that contains a boundary layer that you can 
overlay on top of your raster dataset.


{:.input}
```python
# Open site boundary vector layer
site_bound_path = os.path.join("colorado-flood",
                               "spatial",
                               "boulder-leehill-rd",
                               "clip-extent.shp")
site_bound_shp = gpd.read_file(site_bound_path)

# Plot the vector data
site_bound_shp.plot(color='teal',
                    edgecolor='black')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_27_0.png">

</figure>




You can try to plot the two datasets together but you will see below that 
the output plot does not look correct. This is because the raster layer has no 
spatial information associated with it. 

{:.input}
```python
fig, ax = plt.subplots()

ep.plot_bands(lidar_dem_arr, ax=ax)

site_bound_shp.plot(color='teal',
                    edgecolor='black', ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_29_0.png">

</figure>




{:.input}
```python
with rio.open(lidar_dem_path) as dem_src:
    lidar_dem_im = dem_src.read(1, masked=True)
    # Create an object called lidar_dem_meta that contains the spatial metadata
    lidar_dem_plot_ext = plotting_extent(dem_src)

# This plotting extent object will be used below to ensure your data overlay correctly
lidar_dem_plot_ext
```

{:.output}
{:.execute_result}



    (472000.0, 476000.0, 4434000.0, 4436000.0)





Next try to plot. This time however, use the `extent=` parameter
to specify the plotting extent within `ep.plot_bands()`

{:.input}
```python
fig, ax = plt.subplots()

ep.plot_bands(lidar_dem_arr,
              ax=ax,
              extent=lidar_dem_plot_ext)

site_bound_shp.plot(color='None',
                    edgecolor='teal',
                    linewidth=2,
                    ax=ax)
# Turn off the outline or axis border on your plot
ax.axis('off')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_32_0.png">

</figure>




## TODO -- make this a little customize your plot challenge

Let's plot again but this time you will:

1. add a colorbar legend
2. increase the title font size using the `as.set_title` function and the `fontsize` argument 

EarthPy's `plot_bands()` function adds a colorbar to your plot automatically. In the last plot, you'll notice the argument called `cbar` is set to `False`. This turns off the colorbar. The default value for the `cbar` argument is `True`. This means if you don't modify that argument, the colorbar will automatically appear! However, you may also notice a new argument in this plot, `scale=False`. By default, `plot_bands()` will scale values in a raster from 0 to 255. Since this is elevation data, you can avoid this by setting `scale=False`. 

Additionally, you will be using **matplotlib** and `earthpy.plot` together in this plot, in order to modify the title font size. `plot_bands()` can be added into any normal matplotlib plot by just giving it an axis object in the `ax=` argument. 

{:.input}
```python
# fig, ax = plt.subplots(figsize=(12, 10))
# ep.plot_bands(lidar_dem_im,
#               cmap='Greys',
#               extent=spatial_extent,
#               scale=False,
#               ax=ax)
# ax.set_title("Lidar Digital Elevation Model \n Pre 2013 Boulder Flood | Lee Hill Road",
#              fontsize=24)
# plt.show()
```

# TODO - make this a data tip

<div class="notice--success" markdown="1">

### <i class="fa fa-star"></i> Color Ramps

To plot you can select <a href="https://matplotlib.org/users/colormaps.html" target="_blank">pre-determined color ramps</a> from **matplotlib**, you can reverse a color ramp by adding `_r` at the end of the color ramps name, for example `cmap = 'viridis_r'`. 

</div>


# POSSIBLY REMOVE THIS AS THENEXT LESSON COVERS?
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

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_39_0.png" alt = "A histogram of lidar derived elevation values for Boulder, CO.">
<figcaption>A histogram of lidar derived elevation values for Boulder, CO.</figcaption>

</figure>




# TODO -- ove this to the plotting chapter?? 
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
# # Turn extent into geodataframe
# zoom_ext_gdf = gpd.GeoDataFrame()
# zoom_ext_gdf.loc[0, 'geometry'] = box(*zoomed_extent)
```

{:.input}
```python
# # Plot the original data with the boundary box
# fig, ax = plt.subplots(figsize=(8, 3))

# ep.plot_bands(lidar_dem_im,
#               extent=spatial_extent,
#               title="Lidar Raster Full Spatial Extent w Zoom Box Overlayed",
#               ax=ax,
#               scale=False)

# zoom_ext_gdf.plot(ax=ax)

# ax.set_axis_off()
```

{:.input}
```python
# # Plot the data but set the x and y lim
# fig, ax = plt.subplots(figsize=(8, 3))

# ep.plot_bands(lidar_dem_im,
#               extent=spatial_extent,
#               title="Lidar Raster Zoomed on a Smaller Spatial Extent",
#               ax=ax,
#               scale=False)

# # Set x and y limits of the plot
# ax.set_xlim(zoomed_extent[0], zoomed_extent[2])
# ax.set_ylim(zoomed_extent[1], zoomed_extent[3])

# ax.set_axis_off()
# plt.show()
```
