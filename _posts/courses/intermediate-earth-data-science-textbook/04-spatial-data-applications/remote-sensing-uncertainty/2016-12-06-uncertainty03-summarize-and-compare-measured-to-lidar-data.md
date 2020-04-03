---
layout: single
title: "Compare Lidar to Measured Tree Height"
excerpt: "To explore uncertainty in remote sensing data, it is helpful to compare ground-based measurements and data that are collected via airborne instruments or satellites. Learn how to create scatter plots that compare values across two datasets."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Carson Farmer']
dateCreated: 2016-12-06
modified: 2020-03-06
category: [courses]
class-lesson: ['remote-sensing-uncertainty-python-tb']
permalink: /courses/use-data-open-source-python/spatial-data-applications/lidar-remote-sensing-uncertainty/summarize-and-compare-lidar-insitu-tree-height/
nav-title: 'Compare Lidar to Measured Tree Height'
course: 'intermediate-earth-data-science-textbook'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-remote-sensing-uncertainty/summarize-and-compare-lidar-insitu-tree-height/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Review how to summarize tabular data using **pandas** in **Python**.
* Create a scatter plot with a one to one line in **Python** using **matplotlib**.
* Merge two dataframes in **Python**.

</div>

In this lesson series, your overall goal is to compare tree height measurements taken by humans in the field to height values extracted from a lidar remote sensing canopy height model. You are working with two different types of data:

1. Raster of the lidar canopy height model and
2. Vector point location data

In the previous lesson, you learned how to extract raster values from an area derived by creating a buffer region around each point in a shapefile. In this lesson, you will summarize the human made measurements and then compare them to lidar. 

To begin, load all of the required libraries. 


{:.input}
```python
import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd
import rasterio as rio
from rasterio.plot import plotting_extent
import geopandas as gpd
import rasterstats as rs
from earthpy import spatial as es
import earthpy as et
import earthpy.plot as ep

# Setting consistent plotting style throughout notebook
sns.set_style("white")
sns.axes_style("white")
sns.set(font_scale=1.5)

# Download data and set working directory
data = et.data.get_data("spatial-vector-lidar")
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```



For this lesson you will work with the Lidar Canopy Height Model created by NEON located here:

`data/spatial-vector-lidar/california/neon-sjer-site/2013/lidar/SJER_lidarCHM.tif`

{:.input}
```python
sjer_lidar_chm_path = os.path.join("data", "spatial-vector-lidar", 
                                   "california", "neon-sjer-site", 
                                   "2013", "lidar", "SJER_lidarCHM.tif")

# Load data
with rio.open(sjer_lidar_chm_path) as sjer_lidar_chm_src:
    SJER_chm_data = sjer_lidar_chm_src.read(1, masked=True)
    sjer_chm_meta = sjer_lidar_chm_src.profile
    sjer_chm_plt = plotting_extent(sjer_lidar_chm_src)

plot_buffer_path = 'data/spatial-vector-lidar/outputs/plot_buffer.shp'

# Extract zonal stats & create geodataframe
sjer_tree_heights = rs.zonal_stats(plot_buffer_path,
                                   SJER_chm_data,
                                   affine=sjer_chm_meta['transform'],
                                   geojson_out=True,
                                   copy_properties=True,
                                   nodata=0,
                                   stats="count mean max")

SJER_lidar_height_df = gpd.GeoDataFrame.from_features(sjer_tree_heights)
```

## Is Lidar Derived Tree Height the Same As Human Measured Tree Height?

You have now done the following:

1. You've opened and cleaned up some lidar canopy height model data
2. You've extracted height values for the field plot locations where humans measured trees.

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
# Import & view insitu (field measured) data
path_insitu = os.path.join("data", "spatial-vector-lidar", 
                           "california", "neon-sjer-site", 
                           "2013", "insitu", "veg_structure", 
                           "D17_2013_SJER_vegStr.csv")

SJER_insitu_all = pd.read_csv(path_insitu)

# View columns in data
SJER_insitu_all.columns
```

{:.output}
{:.execute_result}



    Index(['siteid', 'sitename', 'plotid', 'easting', 'northing', 'taxonid',
           'scientificname', 'indvidual_id', 'pointid', 'individualdistance',
           'individualazimuth', 'dbh', 'dbhheight', 'basalcanopydiam',
           'basalcanopydiam_90deg', 'maxcanopydiam', 'canopydiam_90deg',
           'stemheight', 'stemremarks', 'stemstatus', 'canopyform', 'livingcanopy',
           'inplotcanopy', 'materialsampleid', 'dbhqf', 'stemmapqf', 'plant_group',
           'common_name', 'aop_plot', 'unique_id'],
          dtype='object')





Before you go any further, you may want to select just the columns that you will need in your analysis. This will make your data a bit cleaner. In some cases you will not want to drop columns. However for this lesson, there is no reason to keep the extra data as you won't use it in this analysis!

{:.input}
```python
SJER_insitu = SJER_insitu_all[[
    "siteid", "sitename", "plotid", "stemheight", "scientificname"]]

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
      <th>stemheight</th>
      <th>scientificname</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER128</td>
      <td>18.2</td>
      <td>Pinus sabiniana</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER2796</td>
      <td>3.3</td>
      <td>Arctostaphylos viscida</td>
    </tr>
    <tr>
      <th>2</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER272</td>
      <td>1.7</td>
      <td>Arctostaphylos viscida</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER112</td>
      <td>2.1</td>
      <td>Arctostaphylos viscida</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SJER</td>
      <td>San Joaquin</td>
      <td>SJER272</td>
      <td>3.0</td>
      <td>Arctostaphylos viscida</td>
    </tr>
  </tbody>
</table>
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
insitu_stem_ht = SJER_insitu.groupby('plotid').agg(
    ['mean', 'max'])['stemheight']

insitu_stem_ht.head()
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
      <th>max</th>
    </tr>
    <tr>
      <th>plotid</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>SJER1068</th>
      <td>3.866667</td>
      <td>19.3</td>
    </tr>
    <tr>
      <th>SJER112</th>
      <td>8.221429</td>
      <td>23.9</td>
    </tr>
    <tr>
      <th>SJER116</th>
      <td>8.218750</td>
      <td>16.0</td>
    </tr>
    <tr>
      <th>SJER117</th>
      <td>6.512500</td>
      <td>11.0</td>
    </tr>
    <tr>
      <th>SJER120</th>
      <td>7.600000</td>
      <td>8.8</td>
    </tr>
  </tbody>
</table>
</div>





You are almost done sumarizing your data. For expressive and reproducible reasons, add the word `insitu` to each column header so it's very clear which data columns are human measured. This is important given you will MERGE this data frame with the data frame containing lidar mean, min and max values.

Notice that below you use a pythonic approach to creating for loops. Rather than looping through each column and appending the word "insitu", you create a pythonic for loop which populates a list. You then reassign that list fo the column names for the `insitu_stem_ht` dataframe.

{:.input}
```python
['insitu_' + col for col in insitu_stem_ht.columns]
```

{:.output}
{:.execute_result}



    ['insitu_mean', 'insitu_max']





Rename each column - appending "insitu". 

{:.input}
```python
# Add insitu to each column name to make your data more expressive
insitu_stem_ht.columns = ['insitu_' + col for col in insitu_stem_ht.columns]

# Reset the index (plotid)
insitu_stem_ht = insitu_stem_ht.reset_index()
insitu_stem_ht.head()
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
      <th>plotid</th>
      <th>insitu_mean</th>
      <th>insitu_max</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>SJER1068</td>
      <td>3.866667</td>
      <td>19.3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SJER112</td>
      <td>8.221429</td>
      <td>23.9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>SJER116</td>
      <td>8.218750</td>
      <td>16.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SJER117</td>
      <td>6.512500</td>
      <td>11.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SJER120</td>
      <td>7.600000</td>
      <td>8.8</td>
    </tr>
  </tbody>
</table>
</div>





## Merge InSitu Data With Spatial Dataframe

Once you have our summarized insitu data, you can `merge` it into the centroids
`data frame`. Merge requires two data.frames and the names of the columns
containing the unique ID that we will merge the data on. In this case, you will
merge the data on the `plot_id` column. Notice that it's spelled slightly differently
in both data.frames so we'll need to tell Python what it's called in each `dataframe`.

Note that if you want to merge two GeoDataFrames together, you **cannot** use the standard Pandas `merge` function. This will turn the GeoDataFrame into a regular DataFrame. Instead, you need to use the `merge` *method* of a GeoDataFrame object, like so:

{:.input}
```python
# Rename columns so that we know which columns represent lidar values
SJER_lidar_height_df = SJER_lidar_height_df.rename(
    columns={'max': 'lidar_max', 'mean': 'lidar_mean', 'min': 'lidar_min'})

# Join lidar and human measured tree height data
SJER_final_height = SJER_lidar_height_df.merge(insitu_stem_ht,
                                               left_on='Plot_ID',
                                               right_on='plotid')
SJER_final_height.head()
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
      <th>geometry</th>
      <th>Plot_ID</th>
      <th>Point</th>
      <th>northing</th>
      <th>easting</th>
      <th>plot_type</th>
      <th>lidar_max</th>
      <th>lidar_mean</th>
      <th>count</th>
      <th>plotid</th>
      <th>insitu_mean</th>
      <th>insitu_max</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>POLYGON ((255872.376 4111567.818, 255872.280 4...</td>
      <td>SJER1068</td>
      <td>center</td>
      <td>4111567.818</td>
      <td>255852.376</td>
      <td>trees</td>
      <td>19.049999</td>
      <td>11.544348</td>
      <td>161</td>
      <td>SJER1068</td>
      <td>3.866667</td>
      <td>19.3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>POLYGON ((257426.967 4111298.971, 257426.871 4...</td>
      <td>SJER112</td>
      <td>center</td>
      <td>4111298.971</td>
      <td>257406.967</td>
      <td>trees</td>
      <td>24.019999</td>
      <td>10.369277</td>
      <td>443</td>
      <td>SJER112</td>
      <td>8.221429</td>
      <td>23.9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>POLYGON ((256858.760 4110819.876, 256858.664 4...</td>
      <td>SJER116</td>
      <td>center</td>
      <td>4110819.876</td>
      <td>256838.760</td>
      <td>grass</td>
      <td>16.070000</td>
      <td>7.518398</td>
      <td>643</td>
      <td>SJER116</td>
      <td>8.218750</td>
      <td>16.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>POLYGON ((256196.947 4108752.026, 256196.851 4...</td>
      <td>SJER117</td>
      <td>center</td>
      <td>4108752.026</td>
      <td>256176.947</td>
      <td>trees</td>
      <td>11.059999</td>
      <td>7.675347</td>
      <td>245</td>
      <td>SJER117</td>
      <td>6.512500</td>
      <td>11.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>POLYGON ((255988.372 4110476.079, 255988.276 4...</td>
      <td>SJER120</td>
      <td>center</td>
      <td>4110476.079</td>
      <td>255968.372</td>
      <td>grass</td>
      <td>5.740000</td>
      <td>4.591176</td>
      <td>17</td>
      <td>SJER120</td>
      <td>7.600000</td>
      <td>8.8</td>
    </tr>
  </tbody>
</table>
</div>





### Column Names Matter

Take note that while you you don't have to rename the columns as you did above in order to successfully computer your final merged dataframe, it helps if you do because

1. Now anyone looking at your data knows what each column represents.
2. If you export the data to a text file, your columns are named expressively
3. If you return to this analysis in 6 months, you will still be able to quickly understand what data are in each column if they are well named!

## Plot Data (CHM vs Measured)

You've now merged the two dataframes together. Your are ready to create your first scatterplot of the data. 
You can use the pandas `.plot()` to create a scatterplot (or you can use matplotlib directly). The example below uses pandas plotting.  


{:.input}
```python
# Convert to a dataframe so you can use standard pandas plotting
SJER_final_height_df = pd.DataFrame(SJER_final_height)

fig, ax = plt.subplots(figsize=(10, 10))

SJER_final_height_df.plot('lidar_max',
                          'insitu_max',
                          kind='scatter',
                          fontsize=14, s=60,
                          color="purple",
                          ax=ax)

ax.set(xlabel="Lidar derived max tree height",
       ylabel="Measured tree height (m)",
       title="Lidar vs Measured Max Tree Height \n NEON SJER Field Site")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data_22_0.png" alt = "Scatterplot showing the relationship between lidar and measured tree height without a 1:1 line.">
<figcaption>Scatterplot showing the relationship between lidar and measured tree height without a 1:1 line.</figcaption>

</figure>








Next, let's fix the plot adding a 1:1 line and making the x and y axis the same .


{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 10))

SJER_final_height_df.plot('lidar_max',
                          'insitu_max',
                          kind='scatter',
                          fontsize=14,
                          color="purple",
                          s=60, ax=ax)

ax.set(xlabel="Lidar Derived Max Tree Height (m)",
       ylabel="Measured Tree Height (m)",
       title="Lidar vs. Measured Max Tree Height \n NEON SJER Field Site")

# Add 1:1 line
ax.plot((0, 1), (0, 1),
        transform=ax.transAxes, ls='--', c='k')

# Adjust x and y axis limits
ax.set(xlim=[0, 30], ylim=[0, 30])
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data_25_0.png" alt = "Scatterplot showing the relationship between lidar and measured tree height with a 1:1 line.">
<figcaption>Scatterplot showing the relationship between lidar and measured tree height with a 1:1 line.</figcaption>

</figure>




****

<div class="notice--info" markdown="1">

### OPTIONAL - Export Results as a .csv File

You may want to export your final analysis file as a `.csv` file. You can use the Pandas `.to_csv()` method to export a dataframe. .to_csv requires a directory that exists on your computer and a file name like this:

`dataframe_name.to_csv("data/spatial-vector-lidar/outputs/sjer-lidar-insitu-merge.csv")`

</div>


{:.input}
```python
# Export the final data frame as a csv file
outpath = os.path.join("data", "spatial-vector-lidar", 
                       "outputs", "sjer-lidar-insitu-merge.csv")

SJER_final_height_df.to_csv(outpath)
```



## Create Map of Plot Locations Sized by Tree Height

Finally, you may want to create a map where points are sized according to tree height. To do that you

1. Create or use a point geometry for each site location. In the case below we are using the data.frame that had the buffered points, and updating the geometry so that it is a point rather than the buffered polygon geometry.
2. Then you set the point markersize using an attribute in your geodataframe. In the example below you use `insitu_maxht`



{:.input}
```python
# Convert the geometry column to contain points
SJER_final_height['geometry'] = SJER_final_height.centroid
SJER_final_height.head()

SJER_final_height['insitu_max']
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
    Name: insitu_max, dtype: float64





Plot the points by tree height. 

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 10))
ep.plot_bands(SJER_chm_data,
          cmap='Greys',
          extent=sjer_chm_plt,
          ax=ax,
          scale=False)

# Plot centroids of each geometry as points so that you can control their size
SJER_final_height.centroid.plot(ax=ax,
                                marker='o',
                                markersize=SJER_final_height['insitu_max'] * 80,
                                c='purple')
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data_31_0.png" alt = "Map showing plot locations with points sized by the height of vegetation in each plot overlayed on top of a canopy height model.">
<figcaption>Map showing plot locations with points sized by the height of vegetation in each plot overlayed on top of a canopy height model.</figcaption>

</figure>




****

<div class="notice--info" markdown="1">

## Optional - Create Difference Bar Plot: Lidar vs Measured
The last comparison that you may wish to explore is the plot by plot difference between lidar and measured tree height data. This is often helpful when you are trying to troubleshoot outlier values in your data. For instance you may notice that a few plots have very large differences between lidar and measured tree height.

You may decide to either:

1. Visit the sites if you are close to the field site or
2. Explore imagery for the sites to see if you can figure out a good reason for why the results may be so different. 

Below you do the following
1. You first subtract field measured tree height from lidar estimates
2. Then you create a barplot of that value 
</div>

{:.input}
```python
# Calculate difference
SJER_final_height["lidar_measured"] = SJER_final_height["lidar_max"] - \
    SJER_final_height["insitu_max"]

# Create a bar plot
fig, ax = plt.subplots(figsize=(12, 7))
ax.bar(SJER_final_height['plotid'],
       SJER_final_height['lidar_measured'],
       color="purple")

ax.set(xlabel='Plot ID', ylabel='(Lidar - Measured) Height Difference (m)',
       title='Difference Between lidar and Measured Tree Height')

plt.setp(ax.get_xticklabels(),
         rotation=45, horizontalalignment='right')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data/2016-12-06-uncertainty03-summarize-and-compare-measured-to-lidar-data_33_0.png" alt = "Barplot showing the difference between lidar and measured tree height for each plot.">
<figcaption>Barplot showing the difference between lidar and measured tree height for each plot.</figcaption>

</figure>



