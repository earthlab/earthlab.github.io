---
layout: single
title: "Customize Matplotlib Raster Maps in Python"
excerpt: "Sometimes you want to customize the colorbar and range of values plotted in a raster map. Learn how to create breaks to plot rasters in Python."
authors: ['Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-07-21
category: [courses]
class-lesson: ['customize-raster-plots']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-raster-plots/customize-matplotlib-raster-maps/
nav-title: 'Custom Raster Maps'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
course: 'scientists-guide-to-plotting-data-in-python-textbook'
order: 4
topics:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis:
  reproducible-science-and-programming: ['jupyter-notebook']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/customize-matplotlib-raster-maps/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Customize a raster map in **Python** using **matplotlib**.

</div>

## Customize Matplotlib Raster Plots

You often want to customize the way a raster is plotted in **Python**. In this lesson, you will learn how to create quantitative breaks to visually color sets of raster values. You will also learn how to create a custom labeled colorbar. 

To begin, load all of the required libraries. Notice that you are loading `Patch` and `ListedColormap` from **matplotlib**.

{:.input}
```python
import os
import matplotlib.pyplot as plt
from matplotlib.patches import Patch
from matplotlib.colors import ListedColormap
import matplotlib.colors as colors
import seaborn as sns
import numpy as np
import rasterio as rio
from rasterio.plot import plotting_extent
import earthpy as et
import earthpy.spatial as es
import earthpy.plot as ep

# Prettier plotting with seaborn
sns.set(font_scale=1.5, style="white")

# Import data
data = et.data.get_data("colorado-flood")

# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

You will work with the canopy height model raster that you created in this week's lessons. Below is the code to create that raster if you have not already created it. 

{:.input}
```python
# Open raster data
lidar_chm_path = os.path.join("data", "colorado-flood", "spatial", 
                              "outputs", "lidar_chm.tiff")

with rio.open(lidar_chm_path) as lidar_chm_src:
    lidar_chm = lidar_chm_src.read(1)
```


## Plots Using Breaks

Sometimes assigning colors to specific value ranges in your data can help you 
better understand what is going on in the raster. For example you may chose to highlight 
just the talled pixels with a color that allows you to see how those pixels are distributed 
across the entire raster. 

Maybe by doing this you will visually identify spatial patterns that you want to explore in more depth. To do this, you can create breaks in your CHM plot.

To begin, create a list of colors that you wish to use to color each bin of your raster.
Then assign each color to a bin using `.BoundaryNorm`.

{:.input}
```python
# Define the colors you want
cmap = ListedColormap(["white", "tan", "springgreen", "darkgreen"])

# Define a normalization from values -> colors
norm = colors.BoundaryNorm([0, 2, 10, 20, 30], 5)
```


Once you have the bins and colors defined, ou can plot your data. 
Below, the color map (`cmap`) is set to the listed colormap that you created above. 
The data are then normalized or binned using the bins that you created.

Finally, you create a custom legend by defining labels and then create a patch or a square colored object for each color or range of values rendered in your raster plot.

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 5))

chm_plot = ax.imshow(lidar_chm,
                     cmap=cmap,
                     norm=norm)

ax.set_title("Lidar Canopy Height Model (CHM)")

# Add a legend for labels
legend_labels = {"tan": "short", "springgreen": "medium", "darkgreen": "tall"}

patches = [Patch(color=color, label=label)
           for color, label in legend_labels.items()]

ax.legend(handles=patches,
          bbox_to_anchor=(1.35, 1),
          facecolor="white")

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps04-customize-matplotlib-colorbars-raster/2018-02-05-maps04-customize-matplotlib-colorbars-raster_10_0.png" alt = "Map of a lidar canopy height model with a custom legend.">
<figcaption>Map of a lidar canopy height model with a custom legend.</figcaption>

</figure>




### Colorbars With Custom Labels in Matplotlib
You can also modify the colorbar to the right so that each bin has a human-readable category.


{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 5))

chm_plot = ax.imshow(lidar_chm,
                     cmap=cmap,
                     norm=norm)

ax.set_title("Lidar Canopy Height Model (CHM)")

# Scale color bar to the height of the plot
cbar = ep.colorbar(chm_plot)

boundary_means = [np.mean([norm.boundaries[ii], norm.boundaries[ii - 1]])
                  for ii in range(1, len(norm.boundaries))]

category_names = ['No vegetation', 'Short', 'Medium', 'Tall']
cbar.set_ticks(boundary_means)
cbar.set_ticklabels(category_names)

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/raster-plots/2018-02-05-maps04-customize-matplotlib-colorbars-raster/2018-02-05-maps04-customize-matplotlib-colorbars-raster_13_0.png" alt = "Map of a lidar canopy height model with a custom colorbar legend.">
<figcaption>Map of a lidar canopy height model with a custom colorbar legend.</figcaption>

</figure>



