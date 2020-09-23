---
layout: single
title: 'Use Raster Data for Earth Data Science'
excerpt: "Raster data is one of the two most common spatial data types. Learn to work with raster data for earth data science."
authors: ['Leah Wasser', 'Nathan Korinek']
category: [courses]
class-lesson: ['spatial-data-formats']
permalink: /courses/intro-to-earth-data-science/file-formats/use-spatial-data/use-raster-data/
nav-title: "Use Raster Data"
dateCreated: 2020-06-20
modified: 2020-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
    spatial-data-and-gis: ['raster-data']
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success alert alert-info' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Fundamentals of Raster Data in Python 

In this lesson, you will learn fundamental concepts related to working with raster data in **Python**, including understanding the spatial attributes of raster data, how to open raster data, and how to visually plot the data. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Open raster data using **Rasterio** in **Python**.
* Be able to plot spatial raster data using **EarthPy** in **Python**.

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Suggested Readings 


Before starting this lesson, read the **What is a Raster** section of [this page](https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/) of the Earth Lab website to familiarize yourself with the concept of raster data. 

</div>


## What is Raster data?

Raster or “gridded” data are stored as a grid of values which are rendered on a map as pixels. Each pixel value represents an area on the Earth’s surface making the data spatial. A raster file is composed of regular grid of cells, all of which are the same size. You've looked at and used rasters before if you've looked at photographs or imagery in a tool like Google Earth. However, the raster files that you will work with are different from photographs in that they are spatially referenced. Each pixel represents an area of land on the ground. That area is defined by the spatial **resolution** of the raster.

<figure>
   <a href="https://www.earthdatascience.org/images/earth-analytics/raster-data/raster-concept.png" target="_blank">
   <img src="https://www.earthdatascience.org/images/earth-analytics/raster-data/raster-concept.png" alt="Raster data concept diagram."></a>
   <figcaption>A raster is composed of a regular grid of cells. Each cell is the same
   size in the x and y direction. Source: Colin Williams, NEON.
   </figcaption>
</figure>


<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** For more information on rasters, how they work, and the types of data stored in rasters, see [this chapter](https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/) on using raster data from the earth data science intermediate textbook.

</div>

## Raster Data Can Have One or More Layers 

Raster data can have one or more layers. An elevation model 
for example will often just have one layer representing the 
elevation of the earth's surface for a particular location. However, 
other data including images and time series data, may result in 
a raster file that is composed of multiple layers. Different 
file types can be used to accomodate different sizes and structures
of raster data. 


## There Are Many Different File Raster File Formats
There are many different file types that are used to store 
raster data. 

### Raster Data Stored As Single Files 

Some datasets such as landsat and NAIP are stored in single files. For landsat, often you will find each band stored as a separate .tif file. NAIP stores all bands in on .tif file. Common file types for raster data stored as a single file include:

- **.tif / .tiff**: Stands for Tagged Image File Format. One of the most common ways to store raster data. How some image satellites, such as Landsat, share their data. 
- **.asc**: Stands for ASCII Raster Files. This is a text based format that stores raster data. This format is used given it's simple to store and distribute. 

#### Hierarchical Data Formats

Hierarchical data formats can store many different types of data in one single file. These formats are optimal for larger data sets where you may want to subset or only work with parts of the data at one time. Hierarchical
data can be a bit more involved to work with but they tend to make processing more efficient. Common file types for this data storage method include: 

- **.hdf / .hdf5**: Stands for Hierarchical Data Format. One of the most common hierarchical was to store raster data. How some image satellites, such as MODIS, share their data. 
- **.nc (NetCDF)**: Stands for Network Common Data Form. A common way to store climate data. 

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** Learn more about working with GeoTiff files in <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/intro-to-the-geotiff-file-format/" target="_blank">this earth data science textbook lesson.</a>. Learn more about working with HDF4 files (the format used to store MODIS data) in <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-hdf4/" target="_blank">this earth data science textbook chapter.</a>
</div>

## What Types of Data Are Stored In Rasters?  

Some examples of data that often are provided in a raster format include:

- Satellite imagery
- Land use over large areas
- Elevation data
- Weather data
- Bathymetry data

Next you will open and work with some raster data. To begin
setup your notebook with the required python packages.

{:.input}
```python
# Import necessary packages
import os

import matplotlib.pyplot as plt
import numpy as np
import geopandas as gpd
import rasterio as rio

# Earthpy is an earthlab package to work with spatial data
import earthpy as et
import earthpy.plot as ep

# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



## Open Raster Data in Open Source Python Using Rasterio

You can open raster data in **Python** using `rasterio`. The code below can 
be used to open up a raster file:  

```python
# Create a connection to the file
with rio.open(lidar_dem_path) as src:
    # Read the data in and call it lidar_dtm (this is the variable name)
    lidar_dtm = src.read(1)
```

The code does the following:

1. `rio.open()` - rio is the alias for rasterio. At the top of your code
you include rasterio: `import rasterio as rio`. 
2. `open()` creates a connection to the file on your computer
3. on the second line, `src.read()` reads the data into python so that you can 
use the data in your code. 
4. `masked=True` in your `.read()` statement will mask all `nodata` values in your array. This means that they will not be plotted and also that they will not be included in math calculations in `Python`.  


The data that you will work with below - filename: `pre_DTM.tif` is lidar 
(Light Detection and Ranging) derived elevation data. The file format is a 
**.tif** file. The data represent a Digital Terrain Model (DTM). You can 
<a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/what-is-lidar-data/lidar-chm-dem-dsm/">learn more about DTMs in this earth data science lesson on lidar data.</a> 

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** For larger raster data processing
it is common to use xarray which is incorporates some of rasterio's functionality but also supports big data processing.
</div>

Below, you create a path to the file you want to open. 

{:.input}
```python
# Create a path to file
lidar_dtm_path = os.path.join("colorado-flood",
                              "spatial",
                              "boulder-leehill-rd",
                              "pre-flood",
                              "lidar",
                              "pre_DTM.tif")
lidar_dtm_path
```

{:.output}
{:.execute_result}



    'colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif'





Next, open up your data.

{:.input}
```python
# Open and read in the digital terrain model
# Note that rio is the alias for rasterio
with rio.open(lidar_dtm_path) as src:
    lidar_dtm = src.read(1, masked=True)

# View the data - notice the data structure is different from geopandas data
# which you explored in the last lesson
lidar_dtm
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





You may notice that the code above used to 
open a raster file is a bit more complex than the code that you used to open 
vector files (shapefiles) with geopandas or tabular data with pandas. The 
`with rio.open()` statement creates what is called a context manager for opening 
files. This allows you to create a connection to the file without modifying 
the file itself. You can learn more about context managers in the 
<a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/open-lidar-raster-python/">raster data in 
python chapter in the earth data science intermediate textbook</a>

## Explore Raster Data Values & Structure 

Next, have a look at the data. Notice that the data structure of `type()` of 
Python object returned by rasterio is a numpy array. Numpy arrays are an
efficient way to store and work with raster data in python. You will learn 
more about working with numpy arrays 
<a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">in the numpy array chapter of the introduction to earth data 
science textbook</a>


{:.input}
```python
type(lidar_dtm)
```

{:.output}
{:.execute_result}



    numpy.ma.core.MaskedArray





{:.input}
```python
# View the min and max values of the array
print(lidar_dtm.min(), lidar_dtm.max())
```

{:.output}
    1676.21 2087.43



{:.input}
```python
# View the dimensions of the array (rows, columns)
lidar_dtm.shape
```

{:.output}
{:.execute_result}



    (2000, 4000)





Finally you can plot your data. For plotting you will use `earthpy.plot_bands`.

{:.input}
```python
ep.plot_bands(lidar_dtm,
              scale=False,
              cmap='Greys',
              title="Lidar Digital Terrain Model")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_12_0.png" alt = "Plot of Lidar digital terrain model.">
<figcaption>Plot of Lidar digital terrain model.</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1:  Explore Elevation Data Values

Look closely at the plot above. What do you think the colors and numbers 
represent in the plot? 

What units do the numbers represents?
</div>

<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2:  Open & Plot a Raster Dataset

The above lidar DTM that you opened represents a dataset produced before a flood occurred in 2013 in Colorado. A path to a second lidar dataset which is for the same area but from data collected after the flood is below. 

Use the code below to create a path to the post-flood data. 
Then do the following using the code above as a guide to open and plot 
your data:

1. Use `rasterio` to open the data as a numpy array following the code 
that you used above
2. View the min and max data values for the output numpy array
3. Create a plot of the data

```python
# Add the code here to open, show, and close the raster dataset.

lidar_dem_path_post_flood = os.path.join("data", "colorado-flood", "spatial",
                                         "boulder-leehill-rd", "post-flood", "lidar",
                                         "post_DTM.tif")
```

Hint: Don't forget to use `rio.open()` and assign the output to a variable!

An example of what your plot should look like is below. 
</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_15_0.png" alt = "Challenge 2 Plot: Lidar Digital Terrain Model">
<figcaption>Challenge 2 Plot: Lidar Digital Terrain Model</figcaption>

</figure>




## Imagery - Another Type of Raster Data 

Another type of raster data that you may see is imagery. 
If you have used Google Maps or another mapping tool that has an imagery layer,
you are looking at raster data. You can open and plot imagery data using Python 
as well.

Below you download and open up some NAIP data that were collected before a fire that occured
close to Nederland, Colorado.

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:**  NAIP data is imagery collected by the United 
States Department of Agriculture every 2 years across the United 
States. Learn more about 
NAIP data in <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/multispectral-remote-sensing/intro-naip/">this chapter of the earth data science intermediate 
textbook. </a>
</div>

{:.input}
```python
# Download NAIP data
et.data.get_data(url="https://ndownloader.figshare.com/files/23070791")
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/23070791
    Extracted output to /root/earth-analytics/data/earthpy-downloads/naip-before-after



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/naip-before-after'





{:.input}
```python
# Create a path for the data file - notice it is a .tif file
naip_pre_fire_path = os.path.join("earthpy-downloads",
                                  "naip-before-after",
                                  "pre-fire",
                                  "crop",
                                  "m_3910505_nw_13_1_20150919_crop.tif")

naip_pre_fire_path
```

{:.output}
{:.execute_result}



    'earthpy-downloads/naip-before-after/pre-fire/crop/m_3910505_nw_13_1_20150919_crop.tif'





{:.input}
```python
# Open the data using rasterio
with rio.open(naip_pre_fire_path) as naip_prefire_src:
    naip_pre_fire = naip_prefire_src.read()

naip_pre_fire
```

{:.output}
{:.execute_result}



    array([[[113, 117, 137, ...,  54,  51,  74],
            [113, 117, 131, ...,  63,  54,  54],
            [111, 117, 120, ...,  78,  76,  52],
            ...,
            [191, 192, 193, ...,  58,  69,  76],
            [192, 192, 193, ...,  53,  62,  71],
            [193, 193, 193, ...,  51,  59,  66]],
    
           [[114, 114, 126, ...,  58,  54,  72],
            [114, 112, 120, ...,  70,  60,  58],
            [111, 114, 115, ...,  85,  87,  58],
            ...,
            [183, 184, 185, ...,  61,  75,  84],
            [184, 185, 185, ...,  56,  66,  78],
            [186, 186, 186, ...,  52,  58,  65]],
    
           [[ 80,  87,  95, ...,  55,  54,  63],
            [ 79,  83,  90, ...,  57,  55,  55],
            [ 81,  84,  87, ...,  62,  65,  55],
            ...,
            [161, 161, 163, ...,  54,  58,  64],
            [162, 164, 165, ...,  53,  58,  62],
            [165, 166, 166, ...,  51,  54,  57]],
    
           [[145, 143, 139, ...,  74,  47,  65],
            [145, 146, 139, ...,  98,  59,  57],
            [142, 144, 144, ..., 119, 107,  54],
            ...,
            [167, 169, 172, ...,  76, 105, 119],
            [170, 171, 171, ...,  60,  81, 105],
            [173, 173, 174, ...,  44,  55,  67]]], dtype=int16)





Plotting imagery is a bit different because imagery is composed of multiple 
bands. While we won't get into the specifics of bands and images in this lesson, 
you can see below that an image is composed of multiple layers of information.

You can plot each band individually as you see below using `plot_bands()`. 
Or you can plot a color image,
similar to the image that your camera stores when you take a picture.

{:.input}
```python
# Plot each layer or band of the image separately
ep.plot_bands(naip_pre_fire, figsize=(10, 5))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_21_0.png" alt = "Plot of all NAIP Data Bands using earthpy plot_bands()">
<figcaption>Plot of all NAIP Data Bands using earthpy plot_bands()</figcaption>

</figure>




{:.input}
```python
# Plot color image
ep.plot_rgb(naip_pre_fire,
            title="naip data pre-fire")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_22_0.png" alt = "RGB color image plot of NAIP data using earthpy plot_rgb()">
<figcaption>RGB color image plot of NAIP data using earthpy plot_rgb()</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge:  Plot NAIP Imagery Post Fire 

In the code below, you see a path to a NAIP dataset that was collected 
after the fire in Colorado. Use that path to:

1. Open the post fire data
2. Plot a color version of data using `plot_rgb()`

</div>


{:.input}
```python
# Add the code here to open the raster and read the numpy array inside it
# Create a path for the data file - notice it is a .tif file
naip_post_fire_path = os.path.join("earthpy-downloads",
                                   "naip-before-after",
                                   "post-fire",
                                   "crop",
                                   "m_3910505_nw_13_1_20170902_crop.tif")

naip_post_fire_path
```

{:.output}
{:.execute_result}



    'earthpy-downloads/naip-before-after/post-fire/crop/m_3910505_nw_13_1_20170902_crop.tif'






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_25_0.png" alt = "Plot of NAIP bands on top and below a NAIP color RGB image.">
<figcaption>Plot of NAIP bands on top and below a NAIP color RGB image.</figcaption>

</figure>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_25_1.png" alt = "Plot of NAIP bands on top and below a NAIP color RGB image.">
<figcaption>Plot of NAIP bands on top and below a NAIP color RGB image.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_26_0.png" alt = "Plot of RGB NAIP data before and after the fire.">
<figcaption>Plot of RGB NAIP data before and after the fire.</figcaption>

</figure>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_26_1.png" alt = "Plot of RGB NAIP data before and after the fire.">
<figcaption>Plot of RGB NAIP data before and after the fire.</figcaption>

</figure>



