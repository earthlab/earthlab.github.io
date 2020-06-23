---
layout: single
title: "Open, Plot and Explore Raster Data with Python"
excerpt: "Raster data are gridded data composed of pixels that store values, such as an image or elevation data file. Learn how to open, plot, and explore raster files in Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-06-23
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
* Handle no data values in raster data. 
* Create plotting extents so you can plot raster and vector data together using matplotlib.
* Explore raster data using histograms and descriptive statistics.

</div>

## Open Raster Data in Open Source Python

In previous chapters you learned <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-vector-data-python/spatial-data-vector-shapefiles/" target="_blank">how to use the open source 
Python package **Geopandas** to open vector data stored in shapefile
format.</a> In this chapter you will learn how to use the open source packages **rasterio** combined with **numpy** and **earthpy** to open, manipulate and plot raster data in **Python**. 

To begin load the packages that you need to process your raster data.

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import seaborn as sns
# Use geopandas for vector data and rasterio for raster data
import geopandas as gpd
import rasterio as rio
# Plotting extent is used to plot raster & vector data together
from rasterio.plot import plotting_extent

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





Below, you define the path to a lidar derived digital elevation model (DEM)
that was created using NEON (the National Ecological Observatory Network) data. 

<div class='notice--success alert alert-info' markdown="1">
<i class="fa fa-star"></i> **Data Tip:** DEM's are also sometimes referred to 
as DTM (Digital Terrain Model or 
DTM). You can learn more about the 3 lidar derived elevation data types: <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/what-is-lidar-data/lidar-chm-dem-dsm/" >DEMs,
Canopy Height Models (CHM) and Digital Surface Models (DSMs) in the lidar chapter
of this textbook.</a>
</div>

You then open the data using `rio.open("path-to-raster-here")`.

{:.input}
```python
# Define relative path to file
dem_pre_path = os.path.join("colorado-flood", "spatial",
                              "boulder-leehill-rd", "pre-flood", "lidar",
                              "pre_DTM.tif")

# Open the file using a context manager ("with rio.open" statement)
with rio.open(dem_pre_path) as dem_src:
    dtm_pre_arr = dem_src.read(1)
```

Finally you can plot your data using earthpy `plot_bands()`.

{:.input}
```python
# Plot your data using earthpy
ep.plot_bands(dtm_pre_arr,
              title="Lidar Digital Elevation Model (DEM) \n Boulder Flood 2013",
              cmap="Greys")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_8_0.png" alt = "A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO.">
<figcaption>A plot of a Lidar derived digital elevation model for Lee Hill Road in Boulder, CO.</figcaption>

</figure>




The data above should represent terrain model data. However, the range of 
values is not what is expected. These data are for Boulder, Colorado where 
the elevation may range from 1000-3000m. 

There may be some outlier values in the data that may need to be addressed. 
Below you check out the min and max values of the data. 


{:.input}
```python
print("the minimum raster value is: ", dtm_pre_arr.min())
print("the maximum raster value is: ", dtm_pre_arr.max())
```

{:.output}
    the minimum raster value is:  -3.4028235e+38
    the maximum raster value is:  2087.43



{:.input}
```python
# A histogram can also be helpful to look at the range of values in your data
# What do you notice about the histogram below?
ep.hist(dtm_pre_arr,
       figsize=(10,6))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_11_0.png">

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
with rio.open(dem_pre_path) as dem_src:
    # Masked=True will mask all no data values
    dtm_pre_arr = dem_src.read(1, masked=True)
```

Notice that now the minimum value looks more like
an elevation value (which should most often not be negative). 

{:.input}
```python
print("the minimum raster value is: ", dtm_pre_arr.min())
print("the maximum raster value is: ", dtm_pre_arr.max())
```

{:.output}
    the minimum raster value is:  1676.21
    the maximum raster value is:  2087.43



{:.input}
```python
# A histogram can also be helpful to look at the range of values in your data
ep.hist(dtm_pre_arr,
       figsize=(10,6),
       title="Histogram of the Data with No Data Values Removed")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_16_0.png">

</figure>




Plot your data again to see how it looks. 

{:.input}
```python
# Plot data using earthpy
ep.plot_bands(dtm_pre_arr,
              title="Lidar Digital Elevation Model (DEM) \n Boulder Flood 2013",
              cmap="Greys")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_18_0.png">

</figure>




## Rasterio Reads Files into Python as Numpy Arrays

When you call `src.read()` above, rasterio is reading in the data as a 
**numpy array**. A **numpy array** is a matrix of values. **Numpy arrays** are an 
efficient structure for working with large and potentially multi-dimensional (layered) matrices.

The numpy array below is type `numpy.ma.core.MaskedArray`. It is a masked
array because you chose to mask the no data values in your data. Masking
ensures that when you plot and perform other math operations on your data, 
those no data values are not included in the operations. 

<i fa fa-star></i>**Data Tip:** <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/" target="_blank">If you want to learn more about Numpy arrays, check out the intro to earth 
datascience textbook chapter on Numpy arrays. </a>
{: .notice--success }

{:.input}
```python
with rio.open(dem_pre_path) as dem_src:
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
reference system. You will learn more about 
<a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/raster-metadata-in-python/" target="_blank">raster metadata in the raster metadata lesson in this chapter.</a>


{:.input}
```python
with rio.open(dem_pre_path) as dem_src:
    lidar_dem_im = dem_src.read(1, masked=True)
    # Create an object called lidar_dem_meta that contains the spatial metadata
    lidar_dem_meta = dem_src.profile

lidar_dem_meta
```

{:.output}
{:.execute_result}



    {'driver': 'GTiff', 'dtype': 'float32', 'nodata': -3.4028234663852886e+38, 'width': 4000, 'height': 2000, 'count': 1, 'crs': CRS.from_epsg(32613), 'transform': Affine(1.0, 0.0, 472000.0,
           0.0, -1.0, 4436000.0), 'blockxsize': 128, 'blockysize': 128, 'tiled': True, 'compress': 'lzw', 'interleave': 'band'}






## Context Managers to Open and Close File Connections

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
   dtm_pre_arr = dem_src.read(1, masked=True)
```

Notice that the first line of the context manager is not indented.
It contains two parts

1. `rio.open()`: This is the code that will open a connection to your .tif file using a path you provide. 
2. `file_src`: this is a rasterio reader object that you can use to read in the actual data. You can also use this object to access the metadata for the raster file.

The second line of your with statement 

  `dtm_pre_arr = dem_src.read(1, masked=True)`

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
lidar_dem = rio.open(dem_pre_path)
lidar_dem.close()
```
</div>

{:.input}
```python
# Notice here the src object is printed and returns an "open" DatasetReader object
with rio.open(dem_pre_path) as src:
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





## Plot Raster and Vector Data Together: Plot Extents

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

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_28_0.png">

</figure>




You can try to plot the two datasets together but you will see below that 
the output plot does not look correct. This is because the raster layer has no 
spatial information associated with it. 

{:.input}
```python
fig, ax = plt.subplots(figsize=(10,5))

ep.plot_bands(dtm_pre_arr, ax=ax)

site_bound_shp.plot(color='teal',
                    edgecolor='black', ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_30_0.png">

</figure>




{:.input}
```python
with rio.open(dem_pre_path) as dem_src:
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

ep.plot_bands(dtm_pre_arr,
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

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_33_0.png">

</figure>







<div class="notice--success" markdown="1">
<i class="fa fa-star"></i> **Data Tip:** Customizing Raster Plot Color Ramps
To change the color of a raster plot you set the colormap. Matplotlib has a list of  <a href="https://matplotlib.org/users/colormaps.html" target="_blank">pre-determined color ramps that you can chose from.</a> You can reverse a color ramp by adding `_r` at the end of the color ramp's name, for example `cmap = 'viridis'` vs `cmap = 'viridis_r'`. 

</div>


<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Open And Plot Hillshade
 
It's time to practice your raster skills. Do the following:

Use the `pre_DTM_hill.tif` layer in the `colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar` directory.

1. Open the `pre_DTM_hill.tif` layer using rasterio.
2. Plot the data using `ep.plot_bands()`. 
3. Set the colormap (`cmap=`) parameter value to Greys: `cmap="Greys"`

Give you plot a title.

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_39_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Overlay DTM Over DTM Hillshade

In the challenge above, you opened and plotted a hillshade of the 
lidar digital terrain model create from NEON lidar data before
the 2013 Colorado Flood. In this challenge, you will use the hillshade
to create a map that looks more 3-dimensional by overlaying the 
DTM data on top of the hillshade. 

To do this, you will need to plot each layer using `ep.plot_bands()`

1. Plot the hillshade layer `pre_DTM_hill.tif` that you opened in Challenge 1. Similar to Challenge one set `cmap="Greys"`
2. Plot the DTM that you opened above `dtm_pre_arr`
  * When you plot the DTM, use the `alpha=` parameter to adjust the opacity of the DTM so that you can see the shading on the hillshade underneath the DTM. 
  * Set the colormap to viridis (or any colormap that you prefer) `cmap='viridis'` for the DTM layer. 


HINT: be sure to use the `ax=` parameter to make sure both 
layers are on the same figure. 

</div>

*****

<div class='notice--success alert alert-info' markdown="1">
<i class="fa fa-star"></i> **Data Tip:** 

* <a href="https://www.earthdatascience.org/courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/overlay-raster-maps/" target="_blank">Check out this lesson on overlaying rasters if you get stuck trying to complete this challenge.</a>

* <a href="https://matplotlib.org/3.1.0/tutorials/colors/colormaps.html" target="_blank">Check out the matplotlib colormap documentation for most on colormap options.</a>

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_41_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 3: Add A Site Boundary to Your Raster Plot

Take all of the code that you wrote above to plot the DTM on top 
of your hillshade layer. Add the site boundary layer that you opened above 
`site_bound_shp` to your plot. 

HINT: remember that the `plotting_extent()` object (`lidar_dem_plot_ext`) 
will be needed to add this final layer to your plot.

</div>

*****

<div class='notice--success alert alert-info' markdown="1">
<i class="fa fa-star"></i> **Data Tip:** Plotting Raster and Vector Together

You can learn more about overlaying vector data on top of raster data to 
create maps in Python in <a href="https://www.earthdatascience.org/courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/plotting-extents/" >this lesson on setting plotting extents.</a>
</div>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_43_0.png">

</figure>






<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 4 (Optional): Open Post Flood Raster 


Above, you opened up a lidar derived Digital Terrain Model (DTM or DEM) that was created from data collected
before the 2013 flood. In the post-flood directory, you will find a DTM containing 
data collected after the 2013 flood. 

Create a figure with two plots.

IN the first subplot, plot the pre-flood data that you opened above.
In the second subplot, open and plot the post-flood DTM data. You wil
find the file `post_DTM.tif` in the post-flood directory of your 
colorado-flood dataset downloaded using earthpy. 

* Add a super title (a title for the entire figure) using `plt.suptitle("Title Here")`
* Adjust the location of your suptitle `plt.tight_layout(rect=[0, 0.03, 1, 0.9])`



</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-lidar-raster-data-python/2018-02-05-raster02-open-lidar-raster-data-python_46_0.png">

</figure>














