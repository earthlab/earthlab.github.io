---
layout: single
title: "Overlay Raster and Vector Spatial Data in A Matplotlib Plot Using Extents in Python"
excerpt: "When plotting raster and vector data together, the extent of the plot needs to be defined for the data to overlay with each other correctly. Learn how to define plotting extents for Python Matplotlib Plots."
authors: ['Leah Wasser', 'Nathan Korinek', 'Jenny Palomino']
dateCreated: 2020-03-26
modified: 2020-07-21
category: [courses]
class-lesson: ['customize-raster-plots']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/plotting-extents/
nav-title: 'Spatial Extents For Raster Plots'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
course: 'scientists-guide-to-plotting-data-in-python-textbook'
order: 5
topics:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis:
  reproducible-science-and-programming: ['jupyter-notebook']  
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Create a custom `plotting_extent` object using **rasterio**.
* Use a `plotting_extent` object to plot spatial vector and raster data together using **matplotlib**.

</div>

## About Extents for matplotlib Plots  

You often want to create a map that includes a raster layer (for example a 
satelite image) with vector data such as political boundaries or study area boundaries 
overlayed on top of that raster layer. 

If you are reading in your raster data using **rasterio**, your data will be 
returned as a **numpy array** containing the raster data values. The spatial 
information will be stored separately in a metadata dictionary.

If you plot the numpy array using matplotlib, the corner location of the raster 
is unknown and so the plot will begin at the x,y location: `0,0`. If you 
want to overlay a spatial vector layer on top of that raster, the data 
will not line up correctly.

In order to plot the raster and vector data together in the same plot, 
you need to identify the spatial **extent** of the raster data file so that matplotlib
can correctly place the raster data in geographic space. 

If you are working with **rasterio** in **Python** to import raster data, 
you can use the `plotting_extent` function create the spatial plotting extent
for a raster layer stored as a numpy array. 

To begin, load all of the required libraries. Notice that you are loading 
the `plotting_extent()` function from the **plot** module of the **rasterio** 
package.

{:.input}
```python
# Import needed packages
import os
import matplotlib.pyplot as plt
import matplotlib as mpl
import geopandas as gpd
import rasterio as rio
from rasterio.plot import plotting_extent
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep

# Get data and set working directory
et.data.get_data('cold-springs-fire')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# Set figure size and title size of plots
mpl.rcParams['figure.figsize'] = (14, 14)
mpl.rcParams['axes.titlesize'] = 20
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960109
    Extracted output to /root/earth-analytics/data/cold-springs-fire/.



### Open Vector Data for Plot

To begin, open up the Cold Springs fire boundary data. You will use this data 
to both crop your raster data and as a visual overlay on your final plot. 


{:.input}
```python
# Import fire boundary
fire_boundary_path = os.path.join("data",
                                  "cold-springs-fire",
                                  "vector_layers",
                                  "fire-boundary-geomac",
                                  "co_cold_springs_20160711_2200_dd83.shp")

# Open fire boundary data with geopandas
fire_boundary = gpd.read_file(fire_boundary_path)
```

### Check CRS of Vector Data

When cropping or overlaying data, it is important to make sure the Coordinate Reference System, or CRS, is the same for the two datasets. 

Recall that you can check the CRS of a GeoPandas GeoDataFrame with the `.crs` attribute, as shown below. 

{:.input}
```python
fire_boundary.crs
```

{:.output}
{:.execute_result}



    <Geographic 2D CRS: EPSG:4269>
    Name: NAD83
    Axis Info [ellipsoidal]:
    - Lat[north]: Geodetic latitude (degree)
    - Lon[east]: Geodetic longitude (degree)
    Area of Use:
    - name: North America - NAD83
    - bounds: (167.65, 14.92, -47.74, 86.46)
    Datum: North American Datum 1983
    - Ellipsoid: GRS 1980
    - Prime Meridian: Greenwich





## Get Plotting Extent of Raster Data File

If you open up raster data using the `.read()` method in rasterio, you can  
create the `plotting_extent` object within the rasterio context manager
using the **rasterio** `DatasetReader` object (or the `src` object).

```python
with rio.open(naip_path) as naip_src:
    naip_extent = plotting_extent(naip_src)
```

Below you open up National Agriculture Imagery Program (NAIP) imagery 
data with **rasterio** and get the plotting extent from the `DatasetReader` 
object called `naip_src`.

{:.input}
```python
# Define path to NAIP data
naip_path = os.path.join("data",
                         "cold-springs-fire",
                         "naip",
                         "m_3910505_nw_13_1_20150919",
                         "crop",
                         "m_3910505_nw_13_1_20150919_crop.tif")
```

{:.input}
```python
# Open NAIP data in read ('r') mode
with rio.open(naip_path) as naip_src:
    naip_data = naip_src.read()

    # Project fire boundary to match NAIP data
    fire_bound_utmz13 = fire_boundary.to_crs(naip_src.crs)

    # Create plotting extent from DatasetReader object
    naip_plot_extent = plotting_extent(naip_src)
```

### Order of Coordinates for Plotting Extent

The `plotting_extent` object is a re-ordering of the `.bounds` of the 
**rasterio** `DatasetReader` object and provides the correct object type 
and order of coordinates for **matplotlib**. 

It defines the coordinates as a `tuple` in the appropriate order for **matplotlib** as:

`(leftmost coordinate, rightmost coordinate, bottom coordinate, top coordinate)`

{:.input}
```python
# See coordinates of plotting extent
naip_plot_extent
```

{:.output}
{:.execute_result}



    (457163.0, 461540.0, 4424640.0, 4426952.0)





{:.input}
```python
# See object type
type(naip_plot_extent)
```

{:.output}
{:.execute_result}



    tuple





This order differs from the coordinates provided by `.bounds` of the 
`DatasetReader` object, which provides the coordinates as a `BoundingBox` in 
a slightly different order:

`(leftmost coordinate, bottom coordinate, rightmost coordinate, top coordinate)`

{:.input}
```python
# See bounds attribute
naip_src.bounds
```

{:.output}
{:.execute_result}



    BoundingBox(left=457163.0, bottom=4424640.0, right=461540.0, top=4426952.0)





{:.input}
```python
# See object type
type(naip_src.bounds)
```

{:.output}
{:.execute_result}



    rasterio.coords.BoundingBox





So while the `.bounds` attribute is useful for other purposes, it does not 
provide the appropriate structure needed for **matplotlib**. 

Instead, you can always use `plotting_extent()` to create an object that you 
can provide to **matplotlib** to plot the array of the raster data in the 
appropriate geographic space of the plot. 

{:.input}
```python
# Plot uncropped array
f, ax = plt.subplots()

ep.plot_rgb(naip_data,
            rgb=[0, 1, 2],
            ax=ax,
            title="Fire boundary overlayed on top of uncropped NAIP data",
            extent=naip_plot_extent)  # Use plotting extent from DatasetReader object

fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_18_0.png" alt = "Map of the un cropped NAIP RGB imagery overlayed with the Cold Springs Fire vector layer.">
<figcaption>Map of the un cropped NAIP RGB imagery overlayed with the Cold Springs Fire vector layer.</figcaption>

</figure>




## Get Plotting Extent of Cropped Raster Layer

If you crop your data, the process of getting the the `plotting_extent()` 
is slightly different. The cropped layer does not have the same spatial 
attributes of the original dataset. In this case, you will have to use the metadata 
dictionary, returned from the crop function to create your plotting extent. 

For a cropped array, the `plotting_extent()` function needs an additional 
parameter for the `affine` information, which can be accessed from the 
`transform` key in the metadata dictionary.  


{:.input}
```python
# Open NAIP data
with rio.open(naip_path) as naip_src:

    # Project fire boundary to match NAIP data
    fire_bound_utmz13 = fire_boundary.to_crs(naip_src.crs)

    # Crop raster data to fire boundary
    naip_data_crop, naip_meta_crop = es.crop_image(
        naip_src, fire_bound_utmz13)

# Define plotting extent using cropped array and transform from metadata
naip_crop_plot_extent = plotting_extent(
    naip_data_crop[0], naip_meta_crop["transform"])
```

{:.input}
```python
naip_crop_plot_extent
```

{:.output}
{:.execute_result}



    (457667.0, 461037.0, 4425145.0, 4426450.0)





## Plot Vector and Raster Data Overlays With Plotting Extent

Using the extent objects you created, you can now plot either uncropped or cropped arrays with the fire boundary using the `extent` parameter of plot functions that rely on **matplotlib**.

For example, to plot an `RGB` image, you can use `plot_rgb()`from **earthpy** (which uses **matplotlib**) and use the `extent` parameter to provide the appropriate plotting extent. 

{:.input}
```python
# Plot cropped data
f, ax = plt.subplots()

ep.plot_rgb(naip_data_crop,
            rgb=[0, 1, 2],
            ax=ax,
            title="Fire boundary overlayed on top of cropped NAIP data",
            extent=naip_crop_plot_extent)  # Use plotting extent from cropped array

fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_23_0.png" alt = "Map of the cropped NAIP RGB imagery overlayed with the Cold Springs Fire vector layer.">
<figcaption>Map of the cropped NAIP RGB imagery overlayed with the Cold Springs Fire vector layer.</figcaption>

</figure>




## Importance of Using Appropriate Plotting Extents

Below is an example of what happens if you do not define the plotting extent for a plot overlaying vector and raster data (array). 

First, notice that both datasets plot fine individually.

{:.input}
```python
# Plot of uncropped array
f, ax = plt.subplots()

ep.plot_rgb(naip_data,
            rgb=[0, 1, 2],
            ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_25_0.png" alt = "Map of the NAIP RGB imagery of the Cold Springs fire area without the fire overlayed.">
<figcaption>Map of the NAIP RGB imagery of the Cold Springs fire area without the fire overlayed.</figcaption>

</figure>




{:.input}
```python
# Plot of fire boundary
f, ax = plt.subplots()

fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_26_0.png" alt = "Map of the Cold Springs fire area without imagery underneath.">
<figcaption>Map of the Cold Springs fire area without imagery underneath.</figcaption>

</figure>




Now notice that the plot does not render appropriately when you try to overlay the vector and raster data. 

{:.input}
```python
# Incorrect plot because plotting extent is not defined
f, ax = plt.subplots(figsize=(12, 4))

ep.plot_rgb(naip_data,
            rgb=[0, 1, 2],
            ax=ax,
           title="Plot without a raster extent defined. Notice the data do not line up")

fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_28_0.png" alt = "Map of the NAIP RGB imagery of the Cold Springs fire area with the fire overlayed without settting the plotting extent. No data is visible, it's just a long white box.">
<figcaption>Map of the NAIP RGB imagery of the Cold Springs fire area with the fire overlayed without settting the plotting extent. No data is visible, it's just a long white box.</figcaption>

</figure>




### Use the Appropriate Plotting Extent for Your Data

When you are plotting spatial data, it is important to consider which plotting
extent you will need. You will need to create a unique plotting extent for each 
dataset in your project that is is either 

1. in a differennt CRS 
2. a different resolution and/or
3. cropped differently

Even if the area that the plot covers is similar, if you use the wrong extent 
it can produce a plot that is skewed, stretched or in the incorrect geographic
location

To demonstrate this, try to plot MODIS data using the NAIP extent that's 
been cropped to the same area as the MODIS data, and see how the plot 
comes out. As the two satellites use differnet CRS's, the data should 
be plotted in an illegible way. 

{:.input}
```python
# Open up and crop the MODIS data like you did with the NAIP data

modis_path = os.path.join('data', 
                          'cold-springs-fire', 
                          'modis', 
                          'reflectance', 
                          '07_july_2016',
                          'crop', 
                          'MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b04_1.tif')

# Open MODIS data in read ('r') mode
with rio.open(modis_path) as modis_src:

    # Project fire boundary to match MODIS data
    fire_bound_WGS84 = fire_boundary.to_crs(modis_src.crs)

    # Crop raster data to fire boundary
    modis_data_crop, modis_meta_crop = es.crop_image(
        modis_src, fire_bound_WGS84)

# Define plotting extent using cropped array and transform from metadata
modis_crop_plot_extent = plotting_extent(
    modis_data_crop[0], modis_meta_crop["transform"])
```

{:.input}
```python
# Plot the MODIS data with the proper extent

# Plot cropped data
f, ax = plt.subplots()

ep.plot_bands(modis_data_crop,
              ax=ax,
              extent=modis_crop_plot_extent,
              cbar=False)

fire_bound_WGS84.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_31_0.png" alt = "Map of the cropped MODIS imagery overlayed with the Cold Springs Fire vector layer.">
<figcaption>Map of the cropped MODIS imagery overlayed with the Cold Springs Fire vector layer.</figcaption>

</figure>




That skinny line below the plot code below is your actual plot! The plotting 
for NAIP data does not work for MODIS data as NAIP is:

1. in a different corrdinate reference system and 
2. is at a different spatial resolution

Thus, you must create a unique plotting extent object for your MODIS data.

{:.input}
```python
# Plotting MODIS with the NAIP extent

# Plot cropped data
f, ax = plt.subplots()

ep.plot_bands(modis_data_crop,
              ax=ax,
              extent=naip_crop_plot_extent,
              cbar=False,
             title="Plot with the incorrect extent")

fire_bound_WGS84.plot(ax=ax)

plt.show()


```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_33_0.png" alt = "Map of the cropped MODIS RGB imagery overlayed with the Cold Springs Fire vector layer. The NAIP extent is used instead of the MODIS extent, so no data is visible, only a long black line.">
<figcaption>Map of the cropped MODIS RGB imagery overlayed with the Cold Springs Fire vector layer. The NAIP extent is used instead of the MODIS extent, so no data is visible, only a long black line.</figcaption>

</figure>



