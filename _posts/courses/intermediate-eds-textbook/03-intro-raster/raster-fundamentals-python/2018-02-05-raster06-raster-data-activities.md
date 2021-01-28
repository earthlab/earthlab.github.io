---
layout: single
title: "Test Your Skills: Open Raster Data Using Rasterio In Open Source Python "
excerpt: "Challenge your skills. Practice opening, cleaning and plotting raster data in Python"
authors: ['Leah Wasser', 'Nathan Korinek']
dateCreated: 2020-06-23
modified: 2021-01-28
category: [courses]
class-lesson: ['intro-raster-python-tb']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/raster-data-exercises/
nav-title: 'Raster Exercises'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: false
order: 6
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Practice your skills manipulating raster data using **rioxarray**. 
</div>


{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import seaborn as sns
import geopandas as gpd
import rioxarray as rxr 
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

<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Open And Plot Hillshade
 
It's time to practice your raster skills. Do the following:

Use the `pre_DTM_hill.tif` layer in the `colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar` directory.

1. Open the `pre_DTM_hill.tif` layer using rasterio.
2. Plot the data using `ep.plot_bands()`. 
3. Set the colormap (`cmap=`) parameter value to Greys: `cmap="gray"`

Give you plot a title.

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster06-raster-data-activities/2018-02-05-raster06-raster-data-activities_5_0.png" alt = "Plot of a Lidar Digital Terrain Model overlayed on top of a hillshade. Your challenge 1 plot should look something like this one.">
<figcaption>Plot of a Lidar Digital Terrain Model overlayed on top of a hillshade. Your challenge 1 plot should look something like this one.</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Overlay DTM Over DTM Hillshade

In the challenge above, you opened and plotted a hillshade of the 
lidar digital terrain model create from NEON lidar data before
the 2013 Colorado Flood. In this challenge, you will use the hillshade
to create a map that looks more 3-dimensional by overlaying the 
DTM data on top of the hillshade. 

To do this, you will need to plot each layer using `ep.plot_bands()`

1. Plot the hillshade layer `pre_DTM_hill.tif` that you opened in Challenge 1. Similar to Challenge one set `cmap="gray"`
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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster06-raster-data-activities/2018-02-05-raster06-raster-data-activities_7_0.png" alt = "Plot of a Lidar Digital Terrain Model colored using the viridis colormap in this example, overlayed on top of a hillshade. Your challenge 2 plot should look something like this one.">
<figcaption>Plot of a Lidar Digital Terrain Model colored using the viridis colormap in this example, overlayed on top of a hillshade. Your challenge 2 plot should look something like this one.</figcaption>

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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster06-raster-data-activities/2018-02-05-raster06-raster-data-activities_9_0.png" alt = "Plot of a Lidar Digital Terrain Model overlayed on top of a hillshade. In this plot the site boundary is also overlayed. Your challenge 3 plot should look something like this one.">
<figcaption>Plot of a Lidar Digital Terrain Model overlayed on top of a hillshade. In this plot the site boundary is also overlayed. Your challenge 3 plot should look something like this one.</figcaption>

</figure>







<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 4 (Optional): Open Post Flood Raster 


Above, you opened up a lidar derived Digital Terrain Model (DTM or DEM) that was created from data collected
before the 2013 flood. In the post-flood directory, you will find a DTM containing 
data collected after the 2013 flood. 

Create a figure with two plots.

In the first subplot, plot the pre-flood data that you opened above.
In the second subplot, open and plot the post-flood DTM data. You wil
find the file `post_DTM.tif` in the post-flood directory of your 
colorado-flood dataset downloaded using earthpy. 

* Add a super title (a title for the entire figure) using `plt.suptitle("Title Here")`
* Adjust the location of your suptitle `plt.tight_layout(rect=[0, 0.03, 1, 0.9])`



</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster06-raster-data-activities/2018-02-05-raster06-raster-data-activities_13_0.png" alt = "Plots of Lidar Digital Terrain Models pre and post flood. Your challenge 5 plot should look something like this one.">
<figcaption>Plots of Lidar Digital Terrain Models pre and post flood. Your challenge 5 plot should look something like this one.</figcaption>

</figure>











