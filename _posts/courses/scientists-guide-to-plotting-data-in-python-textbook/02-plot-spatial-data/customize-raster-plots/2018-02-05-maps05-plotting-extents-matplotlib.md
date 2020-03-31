---
layout: single
title: "Customize Matplotlib Plotting Extents in Python"
excerpt: "When plotting raster and vector data together, the extent of the plot needs to be defined for the data to overlay with each other correctly. Learn how to define plotting extents in Python."
authors: ['Leah Wasser', 'Nathan Korinek', 'Jenny Palomino']
dateCreated: 2020-03-26
modified: 2020-03-31
category: [courses]
class-lesson: ['customize-raster-plots']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/plotting-extents/
nav-title: 'Raster Plotting Extents'
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

## Why Use Plotting Extents

When plotting raster data (e.g. imagery), it is very common to want to overlay some sort of vector data over it, such as political boundaries, study boundaries, etc. 

Recall that when you read in a raster data file with **rasterio**, you are provided with a **numpy array** of the data values without the spatial information.

Thus, in order to plot the raster and vector data together in the same plot, you need to identify the spatial extent of the raster data file to let the plot know *where the array should be plotted within the geographic space of the plot*. 

In **Python**, you can use the `plotting_extent` function from **rasterio** to get the spatial extent of a raster data file. 

To begin, load all of the required libraries. Notice that you are loading the `plotting_extent()` function from the **plot** module of the **rasterio** package.

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

In order to overlay the data in the same plot, you need data that overlap spatially. 

Below, you open up the Cold Springs fire boundary data that you will use to crop and overlay with imagery (raster data) of the study area.

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

If you open up raster data without cropping it (i.e. using `.read()`), the process to define a plotting extent is quite simple. 

Within the context manager, you can open the raster data file and get the plotting extent from the **rasterio** `DatasetReader` object (e.g. `src` object).

Below you open up National Agriculture Imagery Program (NAIP) imagery data with **rasterio** and get the plotting extent from the `DatasetReader` object called `naip_src`.

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

    # Get plotting extent from DatasetReader object
    naip_plot_extent = plotting_extent(naip_src)
```

### Order of Coordinates for Plotting Extent

The `plotting_extent` object is a re-ordering of the `.bounds` of the **rasterio** `DatasetReader` object and provides the correct object type and order of coordinates for **matplotlib**. 

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





This order differs from the coordinates provided by `.bounds` of the `DatasetReader` object, which provides the coordinates as a `BoundingBox` in a slightly different order:

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





So while the `.bounds` attribute is useful for other purposes, it does not provide the appropriate structure needed for **matplotlib**. 

Instead, you can always use `plotting_extent()` to create an object that you can provide to **matplotlib** to plot the array of the raster data in the appropriate geographic space of the plot. 

## Get Plotting Extent of Cropped Array

In addition to defining the plotting extent of a `DatasetReader` object, the `plotting_extent()` function can also define plotting extents for cropped arrays.

This distinction is important because if you are cropping the raster data, the original **rasterio** `DatasetReader` object will no longer provide the extent that you actually want to plot.

Instead, you will need to use the array produced by the cropping function to define the plotting extent. 

For a cropped array, the `plotting_extent()` function needs an additional parameter for the `affine` information, which can be accessed from the `transform` attribute of the metadata.  

Luckily, the outputs of `es.crop_image()` provide everything that you need to define a plotting extent for a cropped array!

{:.input}
```python
# Open NAIP data in read ('r') mode
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
# Plot uncropped array
f, ax = plt.subplots()

ep.plot_rgb(naip_data,
            rgb=[0, 1, 2],
            ax=ax,
            extent=naip_plot_extent)  # Use plotting extent from DatasetReader object

fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_22_0.png" alt = "Map of the un cropped NAIP RGB imagery overlayed with the Cold Springs Fire vector layer.">
<figcaption>Map of the un cropped NAIP RGB imagery overlayed with the Cold Springs Fire vector layer.</figcaption>

</figure>




{:.input}
```python
# Plot cropped data
f, ax = plt.subplots()

ep.plot_rgb(naip_data_crop,
            rgb=[0, 1, 2],
            ax=ax,
            extent=naip_crop_plot_extent)  # Use plotting extent from cropped array

fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_23_0.png" alt = "Map of the cropped NAIP RGB imagery overlayed with the Cold Springs Fire vector layer.">
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

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_25_0.png" alt = "Map of the NAIP RGB imagery of the Cold Springs fire area without the fire overlayed.">
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

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_26_0.png" alt = "Map of the Cold Springs fire area without imagery underneath.">
<figcaption>Map of the Cold Springs fire area without imagery underneath.</figcaption>

</figure>




Now notice that the plot does not render appropriately when you try to overlay the vector and raster data. 

{:.input}
```python
# Incorrect plot because plotting extent is not defined
f, ax = plt.subplots(figsize=(6, 6))

ep.plot_rgb(naip_data,
            rgb=[0, 1, 2],
            ax=ax)

fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_28_0.png" alt = "Map of the NAIP RGB imagery of the Cold Springs fire area with the fire overlayed without settting the plotting extent. No data is visible, it's just a long white box.">
<figcaption>Map of the NAIP RGB imagery of the Cold Springs fire area with the fire overlayed without settting the plotting extent. No data is visible, it's just a long white box.</figcaption>

</figure>




### Use the Appropriate Plotting Extent for Data

Another important aspect of plotting extents to consider is that each raster dataset should have its own plotting extent defined. Even if the area the plot covers is similar, if you use the wrong extent it can produce a less than ideal plot. 

To demonstrate this, try to plot MODIS data using the NAIP extent that's been cropped to the same area as the MODIS data, and see how the plot comes out. As the two satellites use differnet CRS's, the data should be plotted in an illegible way. 

{:.input}
```python
# Open up and crop the MODIS data like you did with the NAIP data

modis_path = os.path.join('data', 'cold-springs-fire', 'modis', 'reflectance', '07_july_2016',
             'crop', 'MOD09GA.A2016189.h09v05.006.2016191073856_sur_refl_b04_1.tif')

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

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_31_0.png" alt = "Map of the cropped MODIS imagery overlayed with the Cold Springs Fire vector layer.">
<figcaption>Map of the cropped MODIS imagery overlayed with the Cold Springs Fire vector layer.</figcaption>

</figure>




{:.input}
```python
# Plotting MODIS with the NAIP extent

# Plot cropped data
f, ax = plt.subplots()

ep.plot_bands(modis_data_crop,
              ax=ax,
              extent=naip_crop_plot_extent,
              cbar=False)

fire_bound_WGS84.plot(ax=ax)

plt.show()

# That skinny line below is the actual plot! The plotting extents are non-transferable.
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_32_0.png" alt = "Map of the cropped MODIS RGB imagery overlayed with the Cold Springs Fire vector layer. The NAIP extent is used instead of the MODIS extent, so no data is visible, only a long black line.">
<figcaption>Map of the cropped MODIS RGB imagery overlayed with the Cold Springs Fire vector layer. The NAIP extent is used instead of the MODIS extent, so no data is visible, only a long black line.</figcaption>

</figure>



