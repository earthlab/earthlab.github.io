---
layout: single
title: "Customize Matplotlib Plotting Extents in Python"
excerpt: "When plotting raster and vector data together, the extent of the plots needs to be modified. Learn how to ensure your plotting extents are correct in Python."
authors: ['Leah Wasser', 'Nathan Korinek']
dateCreated: 2020-03-26
modified: 2020-03-26
category: [courses]
class-lesson: ['customize-raster-plots']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/plotting-extents/
nav-title: 'Custom Raster Maps'
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

* Create a custom `plotting_extent` object using **rasterio** and **matplotlib**.
* Use `plotting_extent` to plot spatial vector and raster data together.

</div>

## Use Plotting Extents

When plotting satellite data, it is very common to want to overlay some sort of vector data over it, such as political boundaries, study boundaries, etc. In order to do this, you must get the extent of the raster data to let the vector data know where the satellite data is geographically. You can use `plotting_extent` in **rasterio** to do this. 

To begin, load all of the required libraries. Notice that you are loading `plotting_extent` from **rasterio**.

{:.input}
```python
import os
import matplotlib.pyplot as plt
import matplotlib as mpl

import geopandas as gpd
import rasterio as rio
from rasterio.plot import plotting_extent

import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep

# Set working directory & get data
et.data.get_data('cold-springs-fire')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# Setting the firgure size and title size of plots for the notebook. 
mpl.rcParams['figure.figsize'] = (14, 14)
mpl.rcParams['axes.titlesize'] = 20
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960109
    Extracted output to /root/earth-analytics/data/cold-springs-fire/.



# Overlay the Fire Boundary

In order to overlay the data, you need data that overlap spatially. Below, you'll open up data that has already been cropped, as well as pre cropped data to see how to grab the `plotting_extent` in both cases. Additionally, you'll open up the fire boundary data that you will use to crop the data and that you will overlay with the satellite data. 

{:.input}
```python
# Import the fire boundary
fire_boundary_path = os.path.join("data",
                                  "cold-springs-fire",
                                  "vector_layers",
                                  "fire-boundary-geomac",
                                  "co_cold_springs_20160711_2200_dd83.shp")

# Open the fire boundary data with GeoPandas
fire_boundary = gpd.read_file(fire_boundary_path)
```

### CRS Issues

When cropping data or overlaying it, it's important to make sure the Coordinate Reference System, or CRS, is the same for the two datasets. You can check GeoDataFrame CRS's by pulling up their `.crs` attribute, as shown below. 

{:.input}
```python
fire_boundary.crs
```

{:.output}
{:.execute_result}



    {'init': 'epsg:4269'}





### Opening up Cropped Satellite Data

Below you'll open up the NAIP data with the `es.crop_image()` function to crop the data to the extent of the fire boundary GeoPandas object. With the outputs of `es.crop_image()` you can get the plotting extent you need!

The `plotting_extent()` function takes two arguments, `source` and `transform`. The source argument takes either an array or a rasterio dataset object opened in `r` mode. The distinction between these two datatypes can be tricky. To clarify what the difference is, see the small example below.

```
with rio.open(path) as dataset:
    array = dataset.read()
```

The `dataset` variable above is a rasterio dataset object opened in `r` mode. When `.read()` was used on that object, it produced an `array`. 

This distinction is important when creating a `plotting_extent` object. The `source` object needs to have the extent of the data you want to plt. So, in a case where you aren't modifying the extent of the satellite data at all, i.e. if you aren't cropping it, you can simply use the rasterio dataset object. However, if you **are** cropping the data, you must use the array produced by the cropping function, as the rasterio dataset object doesn't have the correct extent. 

If you use an array to create a `plotting_extent` object, you also need to provide the `Affine` object from the array metadata. This can be accessed by getting the `transform` attribute from the metadata. This contains the `Affine` object needed. If you are using a rasterio dataset object, you don't need to provide the `transform` argument. 

{:.input}
```python
# open NAIP data
naip_path = os.path.join("data",
                         "cold-springs-fire",
                         "naip",
                         "m_3910505_nw_13_1_20150919",
                         "crop",
                         "m_3910505_nw_13_1_20150919_crop.tif")

# Create crop extent with cropped data
with rio.open(naip_path) as naip_crop:
    
    # Putting the GeoDataFrame into the correct CRS
    fire_bound_utmz13 = fire_boundary.to_crs(naip_crop.crs)
    
    # Cropping the data to the extent of the GeoDataFrame
    naip_data_crop, naip_meta_crop = es.crop_image(naip_crop, fire_bound_utmz13)
    
# Creating the Plotting Extent data. See how we can provide it the array and the 
# affine object produced by `crop_image()`
    
plot_extent_naip_crop = plotting_extent(naip_data_crop[0], naip_meta_crop["transform"])
```

### Opening up Un-Cropped Satellite Data

As stated before, if you are opening up satellite data without cropping it, the process is much easier. All you have to do is provide the rasterio dataset object opened in `r` mode. Because the object has to be in `r` mode, you must get the extent within the `with` statement used to open the data. 

{:.input}
```python
# Create regular extent with un-cropped data

with rio.open(naip_path) as naip_src:
    
    # Correcting the CRS of the boundary data
    fire_bound_utmz13 = fire_boundary.to_crs(naip_src.crs)
    naip_data = naip_src.read()
    
    # Here, we can just provide naip_src to create the extent. 
    plot_extent_naip = plotting_extent(naip_src)
```

### What is in Extent

The extent object is simply a re-ordering of the bounds object rasterio provides to be in the correct order for matplotlib. It changes the order of the bounds object from (left, bottom, right, top) to (left, right, bottom, top). You can see the actual contents of the object below.

{:.input}
```python
# Re-ordered bounds
plot_extent_naip
```

{:.output}
{:.execute_result}



    (457163.0, 461540.0, 4424640.0, 4426952.0)





### Why Use Extent

Below is an example of what happens if you forget to use the extent of the plot while plotting. While both datasets would plot fine individually, they create a rather ugly plot when plotted together!

{:.input}
```python
# Plot your data - note that this plot doesn't work correctly.
# This is because the plot extent is not defined properly.

f, ax = plt.subplots(figsize=(6, 6))
ep.plot_rgb(naip_data_crop,
            ax=ax)
fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_15_0.png">

</figure>




### Plot the Data with the Extents

Using the extent objects you created, see how both the cropped and uncropped extents plot the data. 

{:.input}
```python
# Plot your cropped data.

f, ax = plt.subplots()
ep.plot_rgb(naip_data_crop,
            ax=ax,
            extent=plot_extent_naip_crop)
fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_17_0.png">

</figure>




{:.input}
```python
# Plot your uncropped data.
f, ax = plt.subplots()
ep.plot_rgb(naip_data,
            ax=ax,
            extent=plot_extent_naip)
fire_bound_utmz13.plot(ax=ax)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/02-plot-spatial-data/customize-raster-plots/2018-02-05-maps05-plotting-extents-matplotlib/2018-02-05-maps05-plotting-extents-matplotlib_18_0.png">

</figure>



