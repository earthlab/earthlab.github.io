---
layout: single
title: "Extract raster values using vector boundaries in Python"
excerpt: "This lesson reviews how to extract data from a raster dataset using a
vector dataset. "
authors: ['Chris Holdgraf', 'Carson Farmer', 'Leah Wasser']
modified: 2018-07-27
category: [courses]
class-lesson: ['remote-sensing-uncertainty-python']
permalink: /courses/earth-analytics-python/lidar-remote-sensing-uncertainty/summarize-and-compare-lidar-insitu-tree-height/
nav-title: 'Compare Lidar to Measured Tree Height'
course: 'earth-analytics-python'
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 3
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Summarize tabular data using `pandas` in `Python`
* Create a scatter plot with a one to one line in `Python` using `Matplotlib`
* Merge two data frames in `Python`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson. You will also need the data you downloaded for last week of this class: `spatial-vector-lidar data subset`. 

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12447845){:data-proofer-ignore='' .btn }


</div>

In this lesson series your overall goal is to compare tree height measurements taken by humans in the field to height values extracted from a lidar remote sensing canopy height model. You are working with two different types of data:

1. a raster - the lidar canopy height model and
2. vector point location data

In the previous lesson, you learned how to extract raster values from a buffer area around each point in a shapefile. 
In this lesson you will summarize the human made measurements and then compare them to lidar. 

To begin, load all of the required libraries. 


{:.input}
```python
# import all libraries
import os
import numpy as np
import rasterio as rio
import matplotlib.pyplot as plt
import seaborn as sns
import geopandas as gpd
import rasterstats as rs
import pandas as pd
from earthpy import spatial as es
import earthpy as et

#from rasterio import plot as riop
plt.ion()

# be sure to set your working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

```

If you already don't have the `SJER_chm_data` array created from the previous lesson, you can download 
and import the pre-processed data by clicking on the link below. 

[<i class="fa fa-download" aria-hidden="true"></i> Download the processed CHM layer here (16 MB)](https://ndownloader.figshare.com/files/12388304){:data-proofer-ignore='' .btn }

Make sure the path to the data that you downloaded here is:
`data/spatial-vector-lidar/outputs/sjer_chm_zero_removed.tif`

{:.input}
```python
# you only need to reimport the data and follow these steps if you don't have final SJER_lidar_height_df that was
# created in the previous lessons
lidar_path = 'data/spatial-vector-lidar/outputs/sjer_chm_zero_removed.tif'

# open the masked CHM geotiff
with rio.open(lidar_path) as lidar_chm_src:
    SJER_chm_data = lidar_chm_src.read(1, masked=True)
   
# import the buffer layer that you created in the previous lesson
plot_buffer_path = 'data/spatial-vector-lidar/outputs/plot_buffer.shp'

# Extract zonal stats
sjer_tree_heights = rs.zonal_stats(plot_buffer_path, 
            lidar_path, 
            geojson_out=True,
            copy_properties=True,
            stats="count min mean max")

# turn extracted data into a pandas geo data frame 
SJER_lidar_height_df = gpd.GeoDataFrame.from_features(sjer_tree_heights)
```

## Is Lidar Tree Height the Same As Human Measured?

You have now done the following:

1. you've opened and cleaned up some lidar canopy height model data
2. you've extracted height values for the field plot locations where humans measured trees.

Next, you need to summarize the *in situ* collected
tree height data, measured within circular plots across our study area. You will then compare
the maximum measured tree height value to the maximum LiDAR derived height value
for each circular plot.

For this lesson, you will use the a `.csv` (comma separate value) file,
located in `SJER/2013/insitu/veg_structure/D17_2013_SJER_vegStr.csv`.

First determine the number many plots are in the tree height data. Note that the tree
height data is stored in `.csv` format.

{:.input}
```python
# import in situ data
path_insitu = 'data/spatial-vector-lidar/california/neon-sjer-site/2013/insitu/veg_structure/D17_2013_SJER_vegStr.csv'
SJER_insitu = pd.read_csv(path_insitu)
# what is the structure of the data
type(SJER_insitu)
# view the first 5 rows of data
SJER_insitu.head()
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>siteid</th>
      <th>sitename</th>
      <th>plotid</th>
      <th>easting</th>
      <th>northing</th>
      <th>taxonid</th>
      <th>scientificname</th>
      <th>indvidual_id</th>
      <th>pointid</th>
      <th>individualdistance</th>
      <th>...</th>
      <th>canopyform</th>
      <th>livingcanopy</th>
      <th>inplotcanopy</th>
      <th>materialsampleid</th>
      <th>dbhqf</th>
      <th>stemmapqf</th>
      <th>plant_group</th>
      <th>common_name</th>
      <th>aop_plot</th>
      <th>unique_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER128</td>
      <td>257085.7</td>
      <td>4111381.5</td>
      <td>PISA2</td>
      <td>Pinus sabiniana</td>
      <td>1485</td>
      <td>center</td>
      <td>9.7</td>
      <td>...</td>
      <td>NaN</td>
      <td>100</td>
      <td>100</td>
      <td>NaN</td>
      <td>0</td>
      <td>0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER2796</td>
      <td>256047.7</td>
      <td>4111548.5</td>
      <td>ARVI4</td>
      <td>Arctostaphylos viscida</td>
      <td>1622</td>
      <td>NE</td>
      <td>5.8</td>
      <td>...</td>
      <td>Hemisphere</td>
      <td>70</td>
      <td>100</td>
      <td>f095</td>
      <td>0</td>
      <td>0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER272</td>
      <td>256722.9</td>
      <td>4112170.2</td>
      <td>ARVI4</td>
      <td>Arctostaphylos viscida</td>
      <td>1427</td>
      <td>center</td>
      <td>6.0</td>
      <td>...</td>
      <td>Hemisphere</td>
      <td>35</td>
      <td>100</td>
      <td>NaN</td>
      <td>0</td>
      <td>0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER112</td>
      <td>257421.4</td>
      <td>4111308.2</td>
      <td>ARVI4</td>
      <td>Arctostaphylos viscida</td>
      <td>1511</td>
      <td>center</td>
      <td>17.2</td>
      <td>...</td>
      <td>Sphere</td>
      <td>70</td>
      <td>100</td>
      <td>f035</td>
      <td>0</td>
      <td>0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER272</td>
      <td>256720.5</td>
      <td>4112177.2</td>
      <td>ARVI4</td>
      <td>Arctostaphylos viscida</td>
      <td>1431</td>
      <td>center</td>
      <td>9.9</td>
      <td>...</td>
      <td>Sphere</td>
      <td>80</td>
      <td>100</td>
      <td>f087</td>
      <td>0</td>
      <td>0</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 30 columns</p>
</div>





## Summarize Tree Height Data  Using Pandas 
You want to calculate a summary value of max tree height (the tallest tree measured) in each plot. 
You have a unique id for each plot - **plotid** that can be used to group the data. The tree height values themselves are located in the **stemheight** column.

You can calculate this by using the `.groupy()` method in pandas. 

The steps are

1. `.groupby()` - group the data by the plotid column - your unique identifier for each plot.
2. `.agg()` - provide the summary statistics that you want to return for each plot. in this case `max` and `mean`.
3. below `['stemheight`]` is the name of the column that you want to summarize.


`SJER_insitu.groupby('plotid').agg(['mean', 'min', 'max'])['stemheight']`

{:.input}
```python
statistics = SJER_insitu.groupby('plotid').agg(['mean', 'min', 'max'])['stemheight']
statistics[:5]
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>mean</th>
      <th>min</th>
      <th>max</th>
    </tr>
    <tr>
      <th>plotid</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>SJER1068</th>
      <td>3.866667</td>
      <td>0.0</td>
      <td>19.3</td>
    </tr>
    <tr>
      <th>SJER112</th>
      <td>8.221429</td>
      <td>1.0</td>
      <td>23.9</td>
    </tr>
    <tr>
      <th>SJER116</th>
      <td>8.218750</td>
      <td>3.7</td>
      <td>16.0</td>
    </tr>
    <tr>
      <th>SJER117</th>
      <td>6.512500</td>
      <td>3.5</td>
      <td>11.0</td>
    </tr>
    <tr>
      <th>SJER120</th>
      <td>7.600000</td>
      <td>6.4</td>
      <td>8.8</td>
    </tr>
  </tbody>
</table>
</div>





You are almost done sumarizing your data. For expressive and reproducible reasons, add the word `insitu` to each column header so it's very clear which data columns are human measured. This is important given you will MERGE this data frame with the data frame containing lidar mean, min and max values.

{:.input}
```python
# add insitu to each column name to make keeping track of variables easier
statistics.columns = ['insitu_' + col for col in statistics.columns]
statistics[:5]
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>insitu_mean</th>
      <th>insitu_min</th>
      <th>insitu_max</th>
    </tr>
    <tr>
      <th>plotid</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>SJER1068</th>
      <td>3.866667</td>
      <td>0.0</td>
      <td>19.3</td>
    </tr>
    <tr>
      <th>SJER112</th>
      <td>8.221429</td>
      <td>1.0</td>
      <td>23.9</td>
    </tr>
    <tr>
      <th>SJER116</th>
      <td>8.218750</td>
      <td>3.7</td>
      <td>16.0</td>
    </tr>
    <tr>
      <th>SJER117</th>
      <td>6.512500</td>
      <td>3.5</td>
      <td>11.0</td>
    </tr>
    <tr>
      <th>SJER120</th>
      <td>7.600000</td>
      <td>6.4</td>
      <td>8.8</td>
    </tr>
  </tbody>
</table>
</div>





## Merge InSitu Data With Spatial data.frame

Once you have our summarized insitu data, we can `merge` it into the centroids
`data frame`. Merge requires two data.frames and the names of the columns
containing the unique ID that we will merge the data on. In this case, we will
merge the data on the `plot_id` column. Notice that it's spelled slightly differently
in both data.frames so we'll need to tell Python what it's called in each data.frame.

Note that if you want to merge two GeoDataFrames together, you **cannot** use the standard Pandas `merge` function. This will turn the GeoDataFrame into a regular DataFrame. Instead, we need to use the `merge` *method* of a GeoDataFrame object, like so:

{:.input}
```python
# First rename columns so that we know which columns represent lidar values 
SJER_lidar_height_df = SJER_lidar_height_df.rename(
    columns={'max': 'lidar_max', 'mean': 'lidar_mean', 'min': 'lidar_min'})

# join lidar and human measured tree height data
SJER_final_height = SJER_lidar_height_df.merge(insitu_stem_ht,
                                               left_on='Plot_ID',
                                               right_on='plotid')

```

## Plot Data (CHM vs Measured)

You've now merged the two dataframes together. Your are ready to create your first scatterplot of the data. 
You can use the pandas `.plot()` to create a scatterplot (or you can use matplotlib directly). The example below uses pandas plotting.  


{:.input}
```python
# Convert to a dataframe so we can use standard pandas plotting
SJER_final_height_df = pd.DataFrame(SJER_final_height)

fig, ax = plt.subplots(figsize=(10, 10))

#csfont = {'fontname':'Myriad Pro'}
SJER_final_height_df.plot('lidar_max', 'insitu_maxht', 
                       kind='scatter',
                       fontsize=14, s=60, ax=ax)

ax.set(xlabel="Lidar derived max tree height", 
       ylabel="Measured tree height (m)")
ax.set_title("Lidar vs Measured Max Tree Height \n NEON SJER Field Site", 
             fontsize=30);

```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data_14_0.png)






Next, let's fix the plot adding a 1:1 line and making the x and y axis the same .


{:.input}
```python
# this plot should be a scatter plot with labels and such
# how to add x and y labels
# http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.plot.html
# Prettier plots: https://datasciencelab.wordpress.com/2013/12/21/beautiful-plots-with-pandas-and-matplotlib/
fig, ax = plt.subplots(figsize=(10, 10))

SJER_final_height_df.plot('lidar_max', 'insitu_maxht', 
                       kind='scatter',
                       fontsize=14, s=60, ax=ax)

ax.set(xlabel="Lidar derived max tree height", 
       ylabel="Measured tree height (m)")
ax.set_title("Lidar vs Measured Max Tree Height \n NEON SJER Field Site", 
             fontsize=30)

# Add a diagonal line
ax.plot((0, 1), (0, 1), transform=ax.transAxes, ls='--', c='k')

# adjust x and y axis limits
ax.set(xlim=[0, 30], ylim=[0, 30]);

```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data_16_0.png)




You have now successfully compared your two variables using a scatterplot.

### Export Results as a .csv File

You may want to export your final analysis file as a .csv. You can use the `.to_csv` method to quickly do thhat with Pandas. For this method to work you need to specify a location (a directory that exists on your computer) and a file name like this:

`dataframe_name.to_csv("data/spatial-vector-lidar/outputs/sjer-lidar-insitu-merge.csv")`


{:.input}
```python
# export the final data frame as a csv file.
SJER_final_height_df.to_csv("data/spatial-vector-lidar/outputs/sjer-lidar-insitu-merge.csv")
```


## Create Difference Bar Plot: Lidar vs Measured
The last comparison that you may wish to explore is the plot by plot difference between lidar and measured tree height data. This is often helpful when you are tryign to trouble shoot. For instance you may notice that a few plots are "outliers" or very different from the others in terms of hte difference between lidar and measured height. 

You may decide to either:

1. visit the sites if you are close to the field site or
2. explore imagery for the sites to see if you can figure out a good reason for why the results may be so different. 

Below you do the following
1. you first subtract field measured tree height from lidar estimates
2. then you create a barplot of that value 


{:.input}
```python
# Calculate difference
SJER_final_height["lidar_measured"] = SJER_final_height["lidar_max"] - SJER_final_height["insitu_maxht"]

# creat bar plot
fig, ax = plt.subplots(figsize=(10, 5))
ax.bar(SJER_final_height['plotid'], 
       SJER_final_height['lidar_measured'])
ax.set_title("Difference Between lidar and Measured Tree Height (m)")
ax.set(xlabel='Plot ID', ylabel='Difference (Lidar - Measured) meters')
plt.setp(ax.get_xticklabels(), 
         rotation=45, horizontalalignment='right');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data_20_0.png)




## Plot by height

Finally, you may want to create a map where points are sized according to tree height. To do that you

1. Create or use a point geometry for each site location. In the case below we are using the data.frame that had the buffered points, and updating the geometry so that it is a point rather than the buffered polygon geometry.
2. Then you set the point markersize using an attribute in your geodataframe. In the example below you use `insitu_maxht`

`markersize=SJER_final_height['insitu_maxht'] * 80`

{:.input}
```python
# Convert the geometry column to contain points
SJER_final_height['geometry'] = SJER_final_height.centroid
SJER_final_height.head()

SJER_final_height['insitu_maxht']
```

{:.output}
{:.execute_result}



    0     19.3
    1     23.9
    2     16.0
    3     11.0
    4      8.8
    5     18.2
    6     13.7
    7     12.4
    8      9.4
    9     17.9
    10     9.2
    11    11.8
    12    11.5
    13    10.8
    14     5.2
    15    26.5
    16    18.4
    17     7.7
    Name: insitu_maxht, dtype: float64





{:.input}
```python

# assign cleaned lidar path
lidar_export_path = 'data/spatial-vector-lidar/outputs/sjer_chm_zero_removed.tif'
with rio.open(lidar_export_path) as src:
    SJER_chm = src.read(masked=True)[0]
    sjer_bounds = src.bounds
    

fig, ax = plt.subplots(figsize=(10, 10))
ax.imshow(es.bytescale(SJER_chm), 
          cmap='Greys', 
          extent=[sjer_bounds[ii] for ii in [0, 2, 1, 3]])

# Plot centroids of each geometry as points so that we can control their size
SJER_final_height.centroid.plot(ax=ax,
                          marker='o',
                          markersize=SJER_final_height['insitu_maxht'] * 80,
                          c = 'purple');

```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/in-class/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data_23_0.png)



