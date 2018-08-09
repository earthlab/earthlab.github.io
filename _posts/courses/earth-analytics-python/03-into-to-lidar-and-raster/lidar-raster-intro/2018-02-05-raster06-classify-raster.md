---
layout: single
title: "Classify and Plot Raster Data in Python"
excerpt: "This lesson presents how to classify a raster dataset and export it as a
new raster in Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
modified: 2018-08-09
category: [courses]
class-lesson: ['intro-lidar-raster-python']
permalink: /courses/earth-analytics-python/raster-lidar-intro/classify-plot-raster-data-in-python/
nav-title: 'Classify and Plot Raster'
week: 3
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Reclassify a raster dataset in `Python` using a set of defined values.
* Describe the difference between using breaks to plot a raster compared to reclassifying a raster object.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}


</div>

### Reclassification vs. Breaks

In this lesson, you will learn how to reclassify a raster dataset in `Python`. Previously,
you plotted a raster dataset using break points - that is to say, you colored particular
ranges of raster pixels using a defined set of values that you call `breaks`.
In this lesson, you will learn how to reclassify a raster. When you reclassify
a raster, you
create a **new** raster
object / file that can be exported and shared with colleagues and / or open in other tools such
as QGIS. In that raster each pixel is mapped to a new value based on some approach. This approach can vary depending upon your science question.


<figure>
<img src="http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/geoprocessing_with_3d_analyst/Reclass_Reclass2.gif" alt="reclassification process by ESRI">
<figcaption>When you reclassify a raster, you create a new raster. In that raster, each cell from the old raster is mapped to the new raster. The values in the new raster are applied using a defined range of values or a raster map. For example above you can see that all cells that
contains the values 1-3 are assigned the new value of 5. Image source: ESRI.
</figcaption>
</figure>


## Raster Classification Steps

You can break your raster processing workflow into several steps as follows:

* **Data import / cleanup:** load and "clean" the data. This may include cropping, dealing with NA values, etc
* **Data Exploration:** understand the range and distribution of values in your data. This may involve plotting histograms scatter plots, etc
* **More Data Processing & Analysis:** This may include the final data processing steps that you determined based upon the data exploration phase.
* **Final Data Analysis:** The final steps of your analysis - often performed using information gathered in the early data processing / exploration stages of your workflow.
* **Presentation:** Refining your results into a final plot or set of plots that are cleaned up, labeled, etc.

Please note - working with data is not a linear process. There are no defined
steps. As you work with data more, you will develop your own workflow and approach.

To get started, first load the required libraries and then open up our raster. In this case you are using the lidar
canopy height model (CHM) that you calculated in the previous lesson.


### Be sure to set your working directory
`os.chdir("path-to-you-dir-here/earth-analytics/data")`

{:.input}
```python
import rasterio as rio
import numpy as np
import os
import matplotlib.pyplot as plt
import pandas as pd
import earthpy as et
plt.ion()
```

{:.input}
```python
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 20
plt.rcParams['axes.facecolor']='white'
plt.rcParams['grid.color'] = 'grey'
plt.rcParams['grid.linestyle'] = '-'
plt.rcParams['grid.linewidth'] = '.5'
plt.rcParams['lines.color'] = 'purple'
```

{:.input}
```python
# open raster data
with rio.open('data/colorado-flood/spatial/outputs/lidar_chm.tiff') as lidar_chm:
    lidar_chm_im = lidar_chm.read()

bounds = lidar_chm.bounds

# Reshape the bounds into a form that matplotlib wants
bounds = [bounds.left, bounds.right, bounds.bottom, bounds.top]
bounds
```

{:.output}
{:.execute_result}



    [472000.0, 476000.0, 4434000.0, 4436000.0]





### What Classification Values to Use?

There are many different approaches to classification. Some use highly sophisticated spatial algorithms that identify patterns in the data that can in turn be used to classify particular pixels into particular "classes". In this case, you are simply going to create the classes manually using the range of quantitative values found in our data.

Assuming that our data represent trees (you know there are some buildings in the data), classify your raster into 3 classes:

* Short trees
* Medium trees
* Tall trees

To perform this classification, you need to understand which values represent short trees vs medium trees vs tall trees in your raster. This is where histograms can be extremely useful.

Let's begin by looking at the min and max values in our CHM.

{:.input}
```python
with rio.open('data/colorado-flood/spatial/outputs/lidar_chm.tiff') as lidar_chm:
    lidar_chm_im_unmasked = lidar_chm.read()
```

{:.input}
```python
# view min and max values in the data
print('CHM min value:' ,lidar_chm_im_unmasked.min())
print('CHM max value:' ,lidar_chm_im_unmasked.max())
```

{:.output}
    CHM min value: -3.402823e+38
    CHM max value: 2074.32



That value for `min` is *really* small. In addition the value for `max` looks large too. This is probably because the value actually represents "not a number" (NAN) or missing data. Some data uses a special number (usually extremely small or large so it doesn't get confused with the "real" data) to represent missing values. Let's see if this is the case by visualizing our data.

### Get to Know Raster Summary Statistics 

Let's explore the data further by looking at a histogram. A histogram quantifies
the distribution of values found in your data.

{:.input}
```python
fig, ax = plt.subplots()
lidar_chm_hist = lidar_chm_im.ravel()
ax.hist(lidar_chm_hist, color='purple', edgecolor='white')
ax.set_title("Distribution of raster cell values in the DTM difference data",
             fontsize = 16)
ax.set(xlabel="Height (m)", ylabel="Number of Pixels");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_11_0.png">

</figure>




This looks weird - there are only two bars, but you know that the data should have a range according to each pixel's height. The reason there are only two bars is because matplotlib automatically chose bins that were too wide.

Moreover, since you have some datapoints with extreme values, these are dominating the visualization. Let's set those pixels to `NaN` and re-plot the histogram.

{:.input}
```python
# Turn the really small and really large numbers to NaN
min_val = 0
max_val = 100
lidar_chm_im_cleaned = lidar_chm_im.copy()
mask_extreme_values = np.logical_or(lidar_chm_im_cleaned < min_val, lidar_chm_im_cleaned > max_val)
lidar_chm_im_cleaned[mask_extreme_values] = np.nan
lidar_chm_cleaned_hist = lidar_chm_im_cleaned.ravel()
```

Note: Matplotlib doesn't handle `NaN` values well when plotting histograms. To get around this, give your own range when calling `ax.hist`. You can calculate the min and max of an array _disregarding the NaNs_ by using `np.nanmin` and `np.nanmax`.

{:.input}
```python
fig, ax = plt.subplots(figsize =(14,14))

# Set a custom range
ax.hist(lidar_chm_cleaned_hist, color='purple', edgecolor='white',
        range=[np.nanmin(lidar_chm_cleaned_hist),
               np.nanmax(lidar_chm_cleaned_hist)])

ax.set_title("Distribution of raster cell values in the DTM difference data",
             fontsize = 16)
ax.set(xlabel="Height (m)", ylabel="Number of Pixels");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_15_0.png">

</figure>




{:.input}
```python
print(lidar_chm_cleaned_hist.min())
print(lidar_chm_cleaned_hist.max())
```

{:.output}
    nan
    nan



{:.input}
```python
print(np.nanmin(lidar_chm_cleaned_hist))
print(np.nanmax(lidar_chm_cleaned_hist))
```

{:.output}
    0.0
    26.930054



### Exploring Raster Histograms

You can further explore our histogram, by constraining the x axis limits using the
`xlim` and `ylim` arguments. The lims arguments visually zooms in on the data in the plot. It does not modify the data!

{:.input}
```python
# plot still not working
fig, ax = plt.subplots(figsize = (14,14))
xlim = [0, 25]
ax.hist(lidar_chm_cleaned_hist, color='purple', edgecolor='white', range=xlim,
        bins=range(*xlim))
ax.set(ylabel="Number of Pixels", xlabel="Height (m)",
       xlim=[2, 25], ylim=[0, 600000]);
ax.set_title("Distribution of raster cell values in the DTM difference data\nZoomed in to {} on the x axis".format(xlim),
             fontsize=16);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_19_0.png">

</figure>




You can look at the values that `Python` used to draw our histogram too. To do this, you can
collect the outputs that are returned when you call `hist`. This consists of three things:

* `counts`, which represents the number of items in each bin
* `bins`, which represents the edges of the bins (there will be one extra item in bins compared to counts)
* `patches`, which are `matplotlib` objects that represent the visualized bar corresponding to each bin. These are useful if you want to change the visual appearance of the bars after plotting.

Note: if you don't want to worry about a particular variable that is returned by a function, simply replace it with a `_` as shown in the comment below:

{:.input}
```python
# patches = the matplotlib objects drawn
counts, bins, patches = ax.hist(lidar_chm_cleaned_hist, color='springgreen', bins=50, range=xlim)

# could just do this with numpy without the drawing:
counts, bins = np.histogram(lidar_chm_cleaned_hist, bins=50, range=xlim)
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

If you want to customize your histogram further, you can customize the number of
breaks that Python uses to create it.

{:.input}
```python
fig, ax = plt.subplots(figsize=(14,14))
ax.hist(lidar_chm_cleaned_hist, color='purple', edgecolor='white', bins=50, range=xlim)
ax.set(title="Distribution of raster cell values in the CHM",
       xlabel="Height (m)", ylabel="Number of Pixels");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_24_0.png">

</figure>




Notice that you've adjusted the x and y lims to zoom into the region of the histogram
that you am interested in exploring.

### Histogram with Custom Breaks

You can create custom breaks or bins in a histogram too. To do this, you pass the
same breaks argument a vector of numbers that represent the range for each bin
in our histogram.

By using custom breaks, you can explore how our data may look when you classify it.

{:.input}
```python
fig, ax = plt.subplots(figsize=(14,14))
ax.hist(lidar_chm_hist, color='purple', edgecolor='white', bins=[0, 5, 10, 15, 20, 30])
ax.set(title="Histogram with custom breaks",
       xlabel="Height (m)", ylabel="Number of Pixels");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_26_0.png">

</figure>




You may want to play with the distribution of breaks. Below it appears as if there are many values close to 0. In the case of this lidar instrument you know that values between 0 and 2 meters are not reliable (you know this if you read the documentation about the NEON sensor and how these data were processed). Let's create a bin between 0-2.

You know you want to create bins for short, medium and tall trees so let's experiment
with those bins also.

Below following breaks are used:

* 0 - 2 = no trees
* 2-4 = short trees
* 4 - 7 = medium trees
* `>` 7 = tall trees

{:.input}
```python
fig, ax = plt.subplots(figsize=(14,14))
ax.hist(lidar_chm_hist, color='purple', edgecolor='white', bins=[0, 2, 4, 7, 30])
ax.set(title="Histogram with custom breaks",
       xlabel="Height (m)", ylabel="Number of Pixels");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_28_0.png">

</figure>




You may want to play around with the setting specific bins associated with your science question and the study area. Regardless, let's use the classes above to
reclassify our CHM raster.


## Map Raster Values to New Values

To reclassify our raster, first you need to create a reclassification matrix. This
matrix MAPS a range of values to a new defined value. Let's create a classified
canopy height model where you designate short, medium and tall trees.

The newly defined values will be as follows:

* No trees: (0m - 2m tall) = NA
* Short trees: (2m - 4m tall) = 1
* Medium trees: (4m - 7m tall) = 2
* Tall trees:  (> 7m tall) = 3

Notice in the list above that you set cells with a value between 0 and 2 meters to
NA or no data value. This means you are assuming that thereare no trees in those
locations!

Notice in the matrix below that you use `Inf` to represent the largest or max value
found in the raster. So our assignment is as follows:

* 0 - 2 meters -> NA
* 2 - 4 meters -> 1 (short trees)
* 4-7 meters -> 2 (medium trees)
* `>` 7 or 7 - Inf -> 3 (tall trees)

Let's create the matrix!

<!-- https://github.com/EarthScientist/AK_LandCarbon/blob/master/new_rasterio_stuff.py this is an examiple of how to reclassify...-->



### `np.digitize`
Numpy has a function called `digitize` that is useful for classifying the values in an array. It is similar to how `histogram` works, because it categorizes datapoints into bins. However, unlike `histogram`, it doesn't aggregate/count the number of values within each bin.

Instead, `digitize` will replace each datapoint with an integer corresponding to which bin it belongs to. You can use this to determine which datapoints fall within certain ranges.

{:.input}
```python
# Define bins that you want, and then classify the data
class_bins = [0, 2, 4, 7, np.inf]

# You'll classify the original image array, then unravel it again for plotting
# Set all `nans` to 0, so that they will be classified correctly
lidar_chm_im_cleaned[np.isnan(lidar_chm_im_cleaned)] = 0
lidar_chm_im_cleaned_classified = np.digitize(lidar_chm_im_cleaned, class_bins)
classes = lidar_chm_im_cleaned_classified.ravel()

# Note that there will be 1 fewer classes than there are items in your bin edges
print(np.unique(classes))
```

{:.output}
    [1 2 3 4]



{:.input}
```python
# You can set the first class to `NaN`
# First you need to change classes so that it contains floats instead of ints
classes = classes.astype(float)
classes[classes == 1] = np.nan
counts, bins = np.histogram(classes[~np.isnan(classes)], bins=range(2, 6))
```

You can view the distribution of pixels assigned to each class using the barplot().


{:.input}
```python
fig, ax = plt.subplots(figsize = (14,14))
ax.bar(bins[1:], counts, color = 'purple')
ax.set(title="Number of pixels in each class");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_34_0.png">

</figure>




{:.input}
```python
xlabels = ["short trees", "medium trees", "tall trees"]

fig, ax = plt.subplots(figsize = (14,14))
ax.bar(bins[:-1], counts, color = 'purple')

ax.set(title="Classified Canopy Height Model \n short, medium, tall trees")
ax.set_xticks(bins[:-1])
ax.set_xticklabels(xlabels);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_35_0.png">

</figure>




{:.input}
```python
colors = ['r', 'b', 'g']
xlabels = ["short trees", "medium trees", "tall trees"]

fig, ax = plt.subplots(figsize = (14,14))
ax.bar(bins[:-1], counts, color=colors)

ax.set(title="Classified Canopy Height Model \n short, medium, tall trees")
ax.set_xticks(bins[:-1])
ax.set_xticklabels(xlabels);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_36_0.png">

</figure>




{:.input}
```python
from matplotlib.patches import Patch
fig, ax = plt.subplots()
colors = ['r', 'b', 'g']
xlabels = ["short trees", "medium trees", "tall trees"]

ax.bar(bins[1:], counts, color=colors)
legend_patches = [Patch(color=icolor, label=label)
                  for icolor, label in zip(colors, xlabels)]
ax.legend(handles=legend_patches)

ax.set(title="Classified Canopy Height Model \n short, medium, tall trees")
ax.set_xticks(bins[1:])
ax.set_xticklabels(xlabels);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_37_0.png">

</figure>




Then, finally you can plot your raster. Notice the colors that I selected are not ideal! You can pick better colors for your plot.

{:.input}
```python
fig, ax = plt.subplots()
ax.imshow(lidar_chm_im_cleaned_classified[0]);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_39_0.png">

</figure>




{:.input}
```python
from matplotlib.colors import ListedColormap, BoundaryNorm
cmap = ListedColormap(['w'] + colors)
norm = BoundaryNorm(class_bins, len(colors))

fig, ax = plt.subplots(figsize=(10, 10))
ax.imshow(lidar_chm_im_cleaned_classified[0], cmap=cmap);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_40_0.png">

</figure>




## Add custom legend
The plot looks OK but the legend doesn't represent the data well. The legend is continuous - with a range between 0 and 3. However you want to plot the data using discrete bins.



Finally, clean up our plot legend. Given you have discrete values you will create a CUSTOM legend with the 3 categories that you created in our classification matrix.

{:.input}
```python
from matplotlib.colors import ListedColormap, BoundaryNorm
cmap = ListedColormap(['w'] + colors)
norm = BoundaryNorm(class_bins, len(colors))

fig, ax = plt.subplots(figsize=(10, 10))
ax.imshow(lidar_chm_im_cleaned_classified[0], cmap=cmap)
ax.legend(handles=legend_patches);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-into-to-lidar-and-raster/lidar-raster-intro/2018-02-05-raster06-classify-raster_42_0.png">

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
