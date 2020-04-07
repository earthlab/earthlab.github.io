---
layout: single
title: "Classify and Plot Raster Data in Python"
excerpt: "Reclassifying raster data allows you to use a set of defined values to organize pixel values into new bins or categories. Learn how to classify a raster dataset and export it as a new raster in Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-03-30
category: [courses]
class-lesson: ['raster-processing-python']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/classify-plot-raster-data-in-python/
nav-title: 'Classify and Plot Raster'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/classify-plot-raster-data-in-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Reclassify a raster dataset in **Python** using a set of defined values and `np.digitize`. 
* Explore a raster and produce histograms to help define appropriate raster break points for classification.

</div>

### Manually Reclassifying Raster Data 

In this lesson, you will learn how to reclassify a raster dataset in `Python`. When you reclassify
a raster, you create a **new** raster object / file that can be exported and shared with colleagues and / or open in other tools such as QGIS. In that raster each pixel is mapped to a new value based on some approach. This approach can vary depending upon your science question.

<figure>
<img src="http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/geoprocessing_with_3d_analyst/Reclass_Reclass2.gif" alt="reclassification process by ESRI">
<figcaption>When you reclassify a raster, you create a new raster. In that raster, each cell from the old raster is mapped to the new raster. The values in the new raster are applied using a defined range of values or a raster map. For example above you can see that all cells that
contains the values 1-3 are assigned the new value of 5. Image source: ESRI.
</figcaption>
</figure>


## Raster Classification Steps

You can break your raster processing workflow into several steps as follows:

* **Data import / cleanup:** load and "clean" the data. This includes cropping, removing with `nodata` values
* **Data Exploration:** understand the range and distribution of values in your data. This may involve plotting histograms and scatter plots to determine what classes are appropriate for our data
* **Reclassify the Data:** Once you understand the distribution of your data, you are ready to reclassify. There are statistical and non-statistical approaches to reclassification. Here you will learn how to manually reclassify a raster using bins that you define in your data exploration step. 

Please note - working with data is not a linear process. Above you see a potential workflow. You will develop your own workflow and approach.  

To get started, first load the required libraries and then open up your raster. In this case, you are using the lidar canopy height model (CHM) that you calculated in the previous lesson.


{:.input}
```python
import os
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
import numpy as np
import rasterio as rio
from rasterio.plot import plotting_extent
import earthpy as et
import earthpy.plot as ep

# Prettier plotting with seaborn
import seaborn as sns
sns.set(font_scale=1.5, style="whitegrid")

# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```


To begin, open the `lidar_chm.tif` file that you created in the previous lesson. A copy of it is also in your outputs directory of this week's data.

{:.input}
```python
# Define relative paths to files
dtm_path = os.path.join("data", "colorado-flood", "spatial", 
                        "boulder-leehill-rd", "pre-flood", "lidar",
                        "pre_DTM.tif")

dsm_path = os.path.join("data", "colorado-flood", "spatial", 
                        "boulder-leehill-rd", "pre-flood", "lidar",
                        "pre_DSM.tif")

with rio.open(dtm_path) as src:
    lidar_dtm_im = src.read(1, masked=True)
    spatial_extent = plotting_extent(src)

with rio.open(dsm_path) as src:
    lidar_dsm_im = src.read(1, masked=True)
    spatial_extent = plotting_extent(src)

lidar_chm_im = lidar_dsm_im - lidar_dtm_im
lidar_chm_im
```

{:.output}
{:.execute_result}



    masked_array(
      data=[[--, --, --, ..., 0.0, 0.1700439453125, 0.9600830078125],
            [--, --, --, ..., 0.0, 0.090087890625, 1.6400146484375],
            [--, --, --, ..., 0.0, 0.0, 0.0799560546875],
            ...,
            [--, --, --, ..., 0.0, 0.0, 0.0],
            [--, --, --, ..., 0.0, 0.0, 0.0],
            [--, --, --, ..., 0.0, 0.0, 0.0]],
      mask=[[ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            ...,
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False]],
      fill_value=-3.402823e+38,
      dtype=float32)






### What Classification Values to Use?

There are many different approaches to classification. Some use highly sophisticated spatial algorithms that identify patterns in the data that can in turn be used to classify particular pixels into particular "classes". In this case, you are simply going to create the classes manually using the range of quantitative values found in our data.

Assuming that our data represent trees (you know there are some buildings in the data), classify your raster into 3 classes:

* Short trees
* Medium trees
* Tall trees

To perform this classification, you need to understand which values represent short trees vs medium trees vs tall trees in your raster. This is where histograms can be extremely useful.

Start by looking at the min and max values in your CHM.

{:.input}
```python
# View min and max values in the data
print('CHM min value:', lidar_chm_im.min())
print('CHM max value:', lidar_chm_im.max())
```

{:.output}
    CHM min value: 0.0
    CHM max value: 26.930054



### Get to Know Raster Summary Statistics 

Get to know your data by looking at a histogram. A histogram quantifies
the distribution of values found in your data.

{:.input}
```python
ep.hist(lidar_chm_im.ravel(),
        title="Distribution of Raster Cell Values in the CHM Data",
        xlabel="Height (m)",
        ylabel="Number of Pixels")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_12_0.png" alt = "Histogram of Canopy Height Model values.">
<figcaption>Histogram of Canopy Height Model values.</figcaption>

</figure>






### Explore Raster Histograms

Further explore your histogram, by constraining the x axis limits using the
`xlim` and `ylim` arguments. The lims arguments visually zooms in on the data in the plot. It does not modify the data.

You might also chose to adjust the number of bins in your plot. Below you plot a bin for each increment on the x axis calculated using:

`hist_range(*xlim)`

You could also set `bins = 100` or some other arbitrary number if you wish.

{:.input}
```python
# Histogram
xlim = [0, 25]
f, ax = ep.hist(lidar_chm_im.ravel(),
                hist_range=xlim,
                bins=range(*xlim),
                ylabel="Number of Pixels", xlabel="Height (m)",
                title="Distribution of raster cell values in the DTM difference data\nZoomed in to {} on the x axis".format(xlim))
ax.set(xlim=xlim, ylim=[0, 250000])
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_16_0.png" alt = "Histogram of CHM data zoomed in to 0-25 on the x axis.">
<figcaption>Histogram of CHM data zoomed in to 0-25 on the x axis.</figcaption>

</figure>




You can look at the values that `Python` used to draw your histogram too. To do this, you can
collect the outputs that are returned when you call `hist`. This consists of three things:

* `counts`, which represents the number of items in each bin
* `bins`, which represents the edges of the bins (there will be one extra item in bins compared to counts)
* `patches`, which are `matplotlib` objects that represent the visualized bar corresponding to each bin. These are useful if you want to change the visual appearance of the bars after plotting.

Note: if you don't want to worry about a particular variable that is returned by a function, simply replace it with a `_` as shown in the comment below:


{:.input}
```python
# Patches = the matplotlib objects drawn
counts, bins = np.histogram(lidar_chm_im,
                            bins=50, range=xlim)


# Print histogram outputs
print("counts:", counts)
print("bins:", bins)
```

{:.output}
    counts: [5292785  155317  128037  116551  109743  110395  107528   98579   89234
       83947   79123   73934   71669   70521   67043   61639   56389   51932
       46193   40674   36442   31877   28428   24553   21620   18613   16095
       13776   11424    9402    7504    6195    4883    3901    2954    2306
        1776    1342    1027     706     525     358     271     160     113
          99      47      44      21      16]
    bins: [ 0.   0.5  1.   1.5  2.   2.5  3.   3.5  4.   4.5  5.   5.5  6.   6.5
      7.   7.5  8.   8.5  9.   9.5 10.  10.5 11.  11.5 12.  12.5 13.  13.5
     14.  14.5 15.  15.5 16.  16.5 17.  17.5 18.  18.5 19.  19.5 20.  20.5
     21.  21.5 22.  22.5 23.  23.5 24.  24.5 25. ]



Each bin represents a bar on your histogram plot. Each bar represents the frequency
or number of pixels that have a value within that bin. For instance, there
is a break between 0 and 1 in the histogram results above. And there are 76,057 pixels
in the counts element that fall into that bin.

Notice that you have adjusted the x and y lims to zoom into the region of the histogram that you are interested in exploring.

### Histogram with Custom Breaks

Next, customize your histogram with breaks that you think might make sense as breaks to use for your raster map. in the example below, breaks are added in 5 meter increments using the `bins =` argument. 

`bins=[0, 5, 10, 15, 20, 30]`

{:.input}
```python
ep.hist(lidar_chm_im.ravel(),
        bins=[0, 5, 10, 15, 20, 30],
        title="Histogram with Custom Breaks",
        xlabel="Height (m)", ylabel="Number of Pixels")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_21_0.png" alt = "Histogram with custom breaks applied.">
<figcaption>Histogram with custom breaks applied.</figcaption>

</figure>




You may want to play with the distribution of breaks. Below it appears as if there are many values close to 0. In the case of this lidar instrument, you know that values between 0 and 2 meters are not reliable (you know this if you read the documentation about the NEON sensor and how these data were processed). Let's create a bin between 0-2.

You know you want to create bins for short, medium and tall trees so let's experiment
with those bins also.

Below following breaks are used:

* 0 - 2 = no trees
* 2 - 7 = short trees
* 7 - 12 = medium trees
* `>` 12 = tall trees

{:.input}
```python
ep.hist(lidar_chm_im.ravel(),
        colors='purple',
        bins=[0, 2, 7, 12, 30],
        title="Histogram with Custom Breaks",
        xlabel="Height (m)",
        ylabel="Number of Pixels")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_23_0.png" alt = "Histogram with custom breaks applied.">
<figcaption>Histogram with custom breaks applied.</figcaption>

</figure>




You may want to play around with the setting specific bins associated with your science question and the study area. Regardless, let's use the classes above to reclassify our CHM raster.


## Map Raster Values to New Values

To reclassify our raster, first you need to create a reclassification matrix. This
matrix MAPS a range of values to a new defined value. Let's create a classified
canopy height model where you designate short, medium and tall trees.

The newly defined values will be as follows:

* No trees: (0m - 2m tall) = NA
* Short trees: (2m - 7m tall) = 1
* Medium trees: (7m - 12m tall) = 2
* Tall trees:  (> 12m tall) = 3

Notice in the list above that you set cells with a value between 0 and 2 meters to
NA or `nodata` value. This means you are assuming that there are no trees in those
locations!

Notice in the matrix below that you use `Inf` to represent the largest or max value
found in the raster. So our assignment is as follows:

* 0 - 2 meters -> 1
* 2 - 7 meters -> 2 (short trees)
* 7 - 12 meters -> 3 (medium trees)
* `>` 12 or 12 - Inf -> 4 (tall trees)

Let's create the matrix!

<!-- https://github.com/EarthScientist/AK_LandCarbon/blob/master/new_rasterio_stuff.py this is an examiple of how to reclassify...-->



### `np.digitize`
Numpy has a function called `digitize` that is useful for classifying the values in an array. It is similar to how `histogram` works, because it categorizes datapoints into bins. However, unlike `histogram`, it doesn't aggregate/count the number of values within each bin.

Instead, `digitize` will replace each datapoint with an integer corresponding to which bin it belongs to. You can use this to determine which datapoints fall within certain ranges. When you use `np.digitize`, the bins that you create work as following

* The starting value by default is included in each bin. The ending value of the bin is not and will be the beginning of the next bin. You can add the argument `right = True` if you want the second value in the bin to be included but not the first. 
* Any values BELOW the bins as defined will be assigned a `0`. Any values ABOVE the highest value in your bins will be assigned the next value available. Thus if you have

`class_bins = [0, 2, 7, 12, 30]`

Any values that are equal to 30 or larger will be assigned a value of `5`. Any values that are `< 0` will be assigned a value of `0`.

You can use `np.inf` in your array to tell python to include all values greater than the last value.
You can use `-np.inf` in your array to tell python to include all values less than the first value.



{:.input}
```python
# View the fill value for your array
lidar_chm_im.fill_value
```

{:.output}
{:.execute_result}



    -3.402823e+38





Below you define 4 bins. However you end up with a `fifth class == 0` which represents values smaller than `0` which is the minimum value in your chm. These values <0 come from the `numpy` mask fill value which you can see identified above this text.

{:.input}
```python
# Define bins that you want, and then classify the data
class_bins = [lidar_chm_im.min(), 2, 7, 12, np.inf]

# You'll classify the original image array, then unravel it again for plotting
lidar_chm_im_class = np.digitize(lidar_chm_im, class_bins)

# Note that you have an extra class in the data (0)
print(np.unique(lidar_chm_im_class))
```

{:.output}
    [0 1 2 3 4]



{:.input}
```python
type(lidar_chm_im_class)
```

{:.output}
{:.execute_result}



    numpy.ndarray





After running the classification you have one extra class. This class - the first class - is your missing data value. Your classified array output is also a regular (not a masked) array. 
You can reassign the first class in your data to a mask using `np.ma.masked_where()`.

{:.input}
```python
# Reassign all values that are classified as 0 to masked (no data value)
# This will prevent pixels that == 0 from being rendered on a map in matplotlib
lidar_chm_class_ma = np.ma.masked_where(lidar_chm_im_class == 0,
                                        lidar_chm_im_class,
                                        copy=True)
lidar_chm_class_ma
```

{:.output}
{:.execute_result}



    masked_array(
      data=[[--, --, --, ..., 1, 1, 1],
            [--, --, --, ..., 1, 1, 1],
            [--, --, --, ..., 1, 1, 1],
            ...,
            [--, --, --, ..., 1, 1, 1],
            [--, --, --, ..., 1, 1, 1],
            [--, --, --, ..., 1, 1, 1]],
      mask=[[ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            ...,
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False],
            [ True,  True,  True, ..., False, False, False]],
      fill_value=999999)





Below you plot the data. 

{:.input}
```python
# A cleaner seaborn style for raster plots
sns.set_style("white")

# Plot newly classified and masked raster
ep.plot_bands(lidar_chm_class_ma,
              scale=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_33_0.png" alt = "CHM plot with NA values applied to the data.">
<figcaption>CHM plot with NA values applied to the data.</figcaption>

</figure>








Below the raster is plotted with slightly improved colors

{:.input}
```python
np.unique(lidar_chm_class_ma)
```

{:.output}
{:.execute_result}



    masked_array(data=[1, 2, 3, 4, --],
                 mask=[False, False, False, False,  True],
           fill_value=999999)





{:.input}
```python
# Plot data using nicer colors
colors = ['linen', 'lightgreen', 'darkgreen', 'maroon']

cmap = ListedColormap(colors)
norm = BoundaryNorm(class_bins, len(colors))

ep.plot_bands(lidar_chm_class_ma,
              cmap=cmap,
              title="Classified Canopy Height Model",
              scale=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_39_0.png" alt = "Canopy height model plot with a better colormap applied.">
<figcaption>Canopy height model plot with a better colormap applied.</figcaption>

</figure>




## Add a Custom Legend to Your Plot with EarthPy

The plot looks OK but the legend does not represent the data well. The legend is continuous - with a range between 1.0 and 4.0 However you want to plot the data using discrete bins.

Given you have discrete values, you can create a custom legend with the four categories that you created in your classification matrix.

There are a few tricky pieces to creating a custom legend.

1. Notice below that you first create a list of legend items (or labels):

`height_class_labels = ["Short trees", "Less short trees", "Medium trees", "Tall trees"]`

This represents the text that will appear in your legend. 

2. Next you create the colormap from a list of colors. 

This code: `colors = ['linen', 'lightgreen', 'darkgreen', 'maroon']` creates the color list.

And this code: `cmap = ListedColormap(colors)` creates the colormap to be used in the plot code.  

{:.input}
```python
np.unique(lidar_chm_class_ma)
```

{:.output}
{:.execute_result}



    masked_array(data=[1, 2, 3, 4, --],
                 mask=[False, False, False, False,  True],
           fill_value=999999)





{:.input}
```python
# Create a list of labels to use for your legend
height_class_labels = ["Short trees", "Medium trees",
                       "Tall trees", "Really tall trees"]

# Create a colormap from a list of colors
colors = ['linen', 'lightgreen', 'darkgreen', 'maroon']
cmap = ListedColormap(colors)

f, ax = plt.subplots(figsize=(12, 12))

im = ax.imshow(lidar_chm_class_ma, 
               cmap=cmap)

ep.draw_legend(im, titles=height_class_labels)
ax.set_axis_off()

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_42_0.png" alt = "Canopy height model with a better colormap and a legend.">
<figcaption>Canopy height model with a better colormap and a legend.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Plot Change Over Time

1. Create a classified raster map that shows **positive and negative change**
in the canopy height model before and after the flood. To do this you will need
to calculate the difference between two canopy height models.
2. Create a classified raster map that shows **positive and negative change**
in terrain extracted from the pre and post flood Digital Terrain Models before
and after the flood.

For each plot, be sure to:

* Add a legend that clearly shows what each color in your classified raster represents.
* Use better colors than I used in my example above!
* Add a title to your plot.

You will include these plots in your final report due next week.

Check out <a href="https://matplotlib.org/users/colormaps.html" target="_blank">this cheatsheet for more on colors in `matplotlib`. </a>


</div>
