---
layout: single
title: "Customize your Maps in Python using Matplotlib: GIS in Python"
excerpt: "In this lesson you will review how to customize matplotlib maps created using vector data in Python. You will review how to add legends, titles and how to customize map colors."
authors: ['Chris Holdgraf', 'Leah Wasser']
modified: 2020-04-04
category: [courses]
class-lesson: ['hw-custom-maps-python']
module-title: 'Custom Plots in Python'
module-description: 'This tutorial covers the basics of creating custom plot legends in Python'
module-nav-title: 'Spatial Data: Custom Plots in Python'
module-type: 'homework'
permalink: /courses/intro-to-earth-analytics/spatial-data-vector-shapefiles/python-customize-map-legends-geopandas/
nav-title: 'Customize Python Maps'
course: 'earth-analytics-python'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Create a map containing multiple vector datasets, colored by unique attributes in `Python`.
* Add a custom legend to a map in `Python` with subheadings, unique colors.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}


</div>

## Create Custom Maps with Python

In this lesson you will learn how to customize map symbology or the colors and symbols used to represent vector data, in Python. There are many different ways to create maps in `Python`. In this lesson, you will use the `geopandas`  and `matplotlib`.

To begin, import all of the required libraries.

{:.input}
```python
# Import libraries
import os
import numpy as np
import geopandas as gpd
import matplotlib.pyplot as plt
from shapely.geometry import box
import earthpy as et

os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# Get the data
data = et.data.get_data('spatial-vector-lidar')
```

### Import Data

Next, import and explore your spatial data. In this case you are importing the same roads layer that you used in earlier lessons which is stored in shapefile (`.shp`) format. 

{:.input}
```python
# Import roads shapefile
sjer_roads = gpd.read_file(
    "data/spatial-vector-lidar/california/madera-county-roads/tl_2013_06039_roads.shp")
# View data type
print(type(sjer_roads['RTTYP']))
```

{:.output}
    <class 'pandas.core.series.Series'>



{:.input}
```python
# View unique attributes for each road in the data
print(sjer_roads['RTTYP'].unique())
```

{:.output}
    ['M' None 'S' 'C']



## Replace Missing Data Values

It looks like you have some missing values in your road types. You want to plot all
road types even those that are set to `None` - which is python's default missing data value. Change the roads with an `RTTYP` attribute of `None` to "unknown".

{:.input}
```python
# Map each value to a new value
sjer_roads['RTTYP'].replace(np.nan, 'Unknown', inplace=True)

print(sjer_roads['RTTYP'].unique())
```

{:.output}
    ['M' 'Unknown' 'S' 'C']



<i class="fa fa-star"></i> **Data Tip:** There are many different ways to deal with missing data in Python. Another way to replace all values of None is to use the `.isnull()` function like this:
`sjer_roads.loc[sjer_roads['RTTYP'].isnull(), 'RTTYP'] = 'Unknown' `
{: .notice--success}

If you plot your data using the standard geopandas `.plot()`, geopandas will select colors for your lines. You can add a legend using the `legend=True` argument however notice that the legend is composed of circles representing each line type rather than a line. You also don't have full control over what color is applied to which line, line width and other symbology attributes.

{:.input}
```python
fig, ax = plt.subplots(figsize=(14, 6))
sjer_roads.plot(column='RTTYP',
                categorical=True,
                legend=True,
                ax=ax)

# adjust legend location
leg = ax.get_legend()
leg.set_bbox_to_anchor((1.15,0.5))
ax.set_axis_off()

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_9_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>





## Plot by Attribute 

To plot a vector layer by attribute value so each road layer is colored 
according to it's respective attribute value, and so the legend also represents that same symbology you need to do three things.

1. You need to create a dictionary that associates a particular color with a particular attribute value
2. You then need to loop through and apply that color to each attribute value
3. Finally you need to add a `label` argument to your plot so you can call `ax.legend()` to make your final legend.

To begin, create a dictionary that defines what color you want each road type to be plotting using.


{:.input}
```python
# Create a dictionary where you assign each attribute value to a particular color
roadPalette = {'M': 'blue',
               'S': 'green',
               'C': 'purple',
               'Unknown': 'grey'}
roadPalette
```

{:.output}
{:.execute_result}



    {'M': 'blue', 'S': 'green', 'C': 'purple', 'Unknown': 'grey'}





Next, you loop through each attribute value and plot the lines with that attribute value using the color specified in the dictionary. To ensure your legend generates properly, you add a `label=` argument to your plot call. The label value will be the attribute value that you used to plot. Below that value is defined by the `ctype` variable.

Then you can call `ax.legend()` to create a legend.

{:.input}
```python
# Plot data
fig, ax = plt.subplots(figsize=(10, 10))

# Loop through each attribute type and plot it using the colors assigned in the dictionary
for ctype, data in sjer_roads.groupby('RTTYP'):
    # Define the color for each group using the dictionary
    color = roadPalette[ctype]
    # Plot each group using the color defined above
    data.plot(color=color,
              ax=ax,
              label=ctype)

ax.legend(bbox_to_anchor=(1.0, .5), prop={'size': 12})
ax.set(title='Madera County Roads')

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_13_0.png" alt = "One way to customize plots is to create a dictionary that contains the symbology or colors and symbols that you wish to use for each attribute type in the map and legend.">
<figcaption>One way to customize plots is to create a dictionary that contains the symbology or colors and symbols that you wish to use for each attribute type in the map and legend.</figcaption>

</figure>




### Adjust Line Width

You can adjust the width of your plot lines using the `linewidth=` attribute. If you set the `linewidth` to 4, you can create a truly ugly plot. In this example every line is `width=4`. 

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 10))

# Loop through each group (unique attribute value) in the roads layer and assign it a color
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    data.plot(color=color,
              ax=ax,
              label=ctype,
              linewidth=4)  # Make all lines thicker

# Add title and legend to plot
ax.legend()
ax.set(title='Madera County Roads')
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_15_0.png" alt = "Here the line width is adjusted on the roads layer.">
<figcaption>Here the line width is adjusted on the roads layer.</figcaption>

</figure>




### Adjust Line Width by Attribute

Similar to how you adjust colors, you can create a dictionary to adjust line widths. Then you can call `dictionaryName[ctype]`
where dictionaryName is a dictionary of what line width you want to assign to each attribute
value and ctype is the attribute value. 

`lineWidths = {'M': 1, 'S': 1, 'C': 4, 'Unknown': .5}`

Here you are assigning the linewidth of each respective attibute value a line width as follows: 

* M: 1
* S: 1
* C: 4
* Unknown = 4

{:.input}
```python
# Create dictionary to map each attribute value to a line width
lineWidths = {'M': 1, 'S': 1, 'C': 4, 'Unknown': .5}

# Plot data adjusting the linewidth attribute
fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    data.plot(color=color,
              ax=ax,
              label=ctype,
              # Assign each group to a line width using the dictionary created above
              linewidth=lineWidths[ctype])
ax.legend()
ax.set(title='Madera County \n Line width varies by TYPE Attribute Value')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_17_0.png" alt = "You can refine plot symbology to make nicer looking plots.">
<figcaption>You can refine plot symbology to make nicer looking plots.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Plot Line Width by Attribute

You can customize the width of each line, according to specific attribute value, too. To do this, you create a vector of line width values, and map that vector to the factor levels - using the same syntax that you used above for colors.

HINT: `lwd=(vector of line width thicknesses)[spatialObject$factorAttribute]`

Create a plot of roads using the following line thicknesses:
1. **unknown** lwd = 3

2. **M** lwd = 1

3. **S** lwd = 2

4. **C** lwd = 1.5

</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_19_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>




## Customize Plot Legend

Above you created a legend using the `label=` argument and `ax.legend()`. You may want to move your legend around to make a cleaner map. You can use the `loc=` argument in the call to `ax.legend()` to adjust your legend location. This location can be numeric or descriptive.

Below you specify the `loc=` to be in the **lower right** hand part of the plot. 

`ax.legend(loc='lower right')`

When you add a legend, you use the following elements to customize legend labels and colors:

* **loc=(how-far-right, how-far-above-0)**: specify an x and Y location of the plot Or generally specify the location e.g. 'bottom right', 'top', 'top right', etc. If you use numeric values the first value is the position to the RIGHT of the plot and the second is the vertical position (how far above 0). Otherwise you can provide text for example "lower right" or "upper left".
* **fontsize:** the size of the fonts used in the legend
* **frameon:** Boolean Values: True of False - if you want a box around your legend use `True`

The `bbox_to_anchor=(1, 1)` argument is also often helpful to customization the location further. Read more about that argument <a href="https://matplotlib.org/users/legend_guide.html" target="_blank">here in the matplotlib documentation</a>. 

{:.input}
```python
lineWidths = {'M': 1, 'S': 2, 'C': 1.5, 'Unknown': 3}

fig, ax = plt.subplots(figsize=(10, 10))

# Loop through each attribute value and assign each 
# with the correct color & width specified in the dictionary
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype
    data.plot(color=color,
              ax=ax,
              linewidth=lineWidths[ctype],
              label=label)


ax.set(title='Madera County \n Line width varies by TYPE Attribute Value')

# Place legend in the lower right hand corner of the plot
ax.legend(loc='lower right',
          fontsize=20,
          frameon=True)
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_21_0.png" alt = "If you set the label argument in your plot, that will be added to your legend when you call ax.legend().">
<figcaption>If you set the label argument in your plot, that will be added to your legend when you call ax.legend().</figcaption>

</figure>




See what happens when you set the frameon attribute of your legend to `False` and adjust the line widths - does your legend change? Also notice below the `loc=()` argument is given a tuple - two  numbers that define the x and y location of the legend relative to the plot figure region.

{:.input}
```python
lineWidths = {'M': 1, 'S': 2, 'C': 1.5, 'Unknown': 3}

fig, ax = plt.subplots(figsize=(10, 10))

for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype if len(ctype) > 0 else 'unknown'
    data.plot(color=color,
              ax=ax,
              linewidth=lineWidths[ctype],
              label=label)

ax.set(title='Madera County \n Line width varies by TYPE Attribute Value')
ax.legend(loc=(1, .5),
          fontsize=20,
          frameon=False,
          title="LEGEND")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_23_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>




Adjust the plot colors.

{:.input}
```python
roadPalette = {'M': 'springgreen', 'S': "blue",
               'C': "magenta", 'Unknown': "grey"}
lineWidths = {'M': 1, 'S': 2, 'C': 1.5, 'Unknown': 3}

fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype
    data.plot(color=color,
              ax=ax,
              linewidth=lineWidths[ctype],
              label=label)
ax.set(title='Madera County Roads \n Pretty Colors')
ax.legend(loc='lower right',
          fontsize=20,
          frameon=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_25_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>






##  Plot Lines by Attribute


Play with colors one more time. Create a plot that emphasizes only roads designated as C or S (County or State). To emphasize these types of roads, make the lines that are assigned the RTTYP attribute of C or S, THICKER than the other lines.

Be sure to add a title and legend to your map! You might consider a color palette that has all County and State roads displayed in a bright color. All other lines can be grey.

{:.input}
```python
# Define colors and line widths
roadPalette = {'M': 'grey', 'S': "blue",
               'C': "magenta", 'Unknown': "lightgrey"}
lineWidths = {'M': .5, 'S': 2, 'C': 2, 'Unknown': .5}

fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype
    data.plot(color=color,
              ax=ax,
              linewidth=lineWidths[ctype],
              label=label)
ax.set(title='Madera County Roads\n County and State recognized roads')
ax.legend(loc='lower right',
          fontsize=20,
          frameon=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_27_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>




<!-- C = County
I = Interstate
M = Common Name
O = Other
S = State recognized
U = U.S.-->

## Add a Point Shapefile to your Map 

Next, add another layer to your map to see how you can create a more complex map with a legend that represents both layers. You will add the same SJER_plot_centroids shapefile that you worked with in previous lessons to your map.

If you recall, this layer contains 3 plot_types: grass, soil and trees. 

{:.input}
```python
# Import points layer
sjer_plots = gpd.read_file(
    "data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_plot_centroids.shp")
# View first 5 rows
sjer_plots.head(5)
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
      <th>Plot_ID</th>
      <th>Point</th>
      <th>northing</th>
      <th>easting</th>
      <th>plot_type</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>SJER1068</td>
      <td>center</td>
      <td>4111567.818</td>
      <td>255852.376</td>
      <td>trees</td>
      <td>POINT (255852.376 4111567.818)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>SJER112</td>
      <td>center</td>
      <td>4111298.971</td>
      <td>257406.967</td>
      <td>trees</td>
      <td>POINT (257406.967 4111298.971)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>SJER116</td>
      <td>center</td>
      <td>4110819.876</td>
      <td>256838.760</td>
      <td>grass</td>
      <td>POINT (256838.760 4110819.876)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>SJER117</td>
      <td>center</td>
      <td>4108752.026</td>
      <td>256176.947</td>
      <td>trees</td>
      <td>POINT (256176.947 4108752.026)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>SJER120</td>
      <td>center</td>
      <td>4110476.079</td>
      <td>255968.372</td>
      <td>grass</td>
      <td>POINT (255968.372 4110476.079)</td>
    </tr>
  </tbody>
</table>
</div>





Just like you did above, create a dictionary that specifies the colors associated with each plot type. 
Then you can plot your data just like you did with the lines

{:.input}
```python
pointsPalette = {'trees': 'chartreuse',
                 'grass': 'darkgreen', 'soil': 'burlywood'}
lineWidths = {'M': .5, 'S': 2, 'C': 2, 'Unknown': .5}

fig, ax = plt.subplots(figsize=(10, 10))

for ctype, data in sjer_plots.groupby('plot_type'):
    color = pointsPalette[ctype]
    label = ctype if len(ctype) > 0 else 'unknown'
    data.plot(color=color,
              ax=ax,
              label=label,
              markersize=100)
ax.set(title='Study area plot locations\n by plot type (grass, soil and trees)')
ax.legend(fontsize=20,
          frameon=True,
          loc=(1, .1),
          title="LEGEND")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_31_0.png" alt = "A similar approach can be taken to customize points on a plot.">
<figcaption>A similar approach can be taken to customize points on a plot.</figcaption>

</figure>




### Overlay points on top of roads

Next, plot the plot data on top of the roads layer. Then create a custom legend that contains both lines and points. 

NOTE: In this example the projection for the roads layer is already changed and the layer has been cropped! You will have to do the same before this code will work.


{:.input}
```python
sjer_aoi = gpd.read_file(
    "data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_crop.shp")

# Reproject the data
sjer_roads_utm = sjer_roads.to_crs(crs=sjer_aoi.crs)
```

## Clip (Intersect) the Data

Next, clip the roads layer to the boundary of the sjer_aoi layer. This will remove all roads and road segments that are outside of your square AOI layer. 


{:.output}
    /opt/conda/lib/python3.7/site-packages/geopandas/geoseries.py:358: UserWarning: GeoSeries.notna() previously returned False for both missing (None) and empty geometries. Now, it only returns False for missing values. Since the calling GeoSeries contains empty geometries, the result has changed compared to previous versions of GeoPandas.
    Given a GeoSeries 's', you can use '~s.is_empty & s.notna()' to get back the old behaviour.
    
    To further ignore this warning, you can do: 
    import warnings; warnings.filterwarnings('ignore', 'GeoSeries.notna', UserWarning)
      return self.notna()



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_35_1.png">

</figure>




{:.input}
```python
sjer_roads_utm_cl = sjer_roads_utm
```

<div class="notice--info" markdown="1">

## OPTIONAL - Create Custom Legend Labels

You do not need to do this for your homework but below you can see how you'd add custom labels to your legend. You need to do the following

1. You need to loop through each "Group" that you wish to plot to create an collection object (discussed below)
2. Then you need to create the legend using those collections.

To begin to customize legends using matplotlib you need to work with collections. Matplotlib stores groups of points, lines or polygons as a collection. In the example above each road type is stored as a collection of type `path` for line. If you call collections AFTER the call to plot in matplotlib, you can see how many collections were created. 

Notice below there are 3 collections - one for each road type.

</div>


{:.input}
```python
# View list of collections created for the plot above.
ax.collections
```

{:.output}
{:.execute_result}



    [<matplotlib.collections.PathCollection at 0x7f6d22202750>,
     <matplotlib.collections.PathCollection at 0x7f6d22202d90>,
     <matplotlib.collections.PathCollection at 0x7f6d2221d290>]





You can subset a collection using standard list subsetting.

{:.input}
```python
# Get the first 2 (out of 3) collection objects
lines = ax.collections[0:2]
lines
```

{:.output}
{:.execute_result}



    [<matplotlib.collections.PathCollection at 0x7f6d22202750>,
     <matplotlib.collections.PathCollection at 0x7f6d22202d90>]





When working with collections pay close attention to the collection type:

`PathCollection` represents a point
`LineCollection` represents a line


By plotting the data within a for loop, you can customize the line width, color and any other attribute that you wish. You can then use those attributes to create a custom legend. Below you create a loop that cycles through each group (each road type) and applies dictionary values for color and line width. Notice you also define the label in each cycle to be the group name (road type in this example).

{:.input}
```python
# Create line dictionary to specify colors and line widths
roadPalette = {'M': 'green', 'S': "blue",
               'C': "magenta", 'Unknown': "lightgrey"}
lineWidths = {'M': .5, 'S': 2, 'C': 2, 'Unknown': .5}

fig, ax = plt.subplots(figsize=(10, 10))

for rtype, data in sjer_roads_utm_cl.groupby('RTTYP'):
    data.plot(color=roadPalette[rtype],
              ax=ax,
              linewidth=lineWidths[rtype],
              label=rtype)
ax.set_title("Map of Roads for SJER Field Site")
ax.legend(title="Roads Type",
          loc=(1.1, .5))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_43_0.png" alt = "Custom legends in matplotlib using collections">
<figcaption>Custom legends in matplotlib using collections</figcaption>

</figure>




Once you have created your plot loop, you can then loop through each collection, and grab the label. Matplotlib also has the color and attributes of that collection stored so it can create the legend symbology using that label.

{:.input}
```python
# Create line dictionary to specify colors and line widths
roadPalette = {'M': 'green', 'S': "blue",
               'C': "magenta", 'Unknown': "lightgrey"}
lineWidths = {'M': .5, 'S': 2, 'C': 2, 'Unknown': .5}

fig, ax = plt.subplots(figsize=(10, 10))

# Plot roads using a for loop to allow for a custom legend
for rtype, data in sjer_roads_utm_cl.groupby('RTTYP'):
    data.plot(color=roadPalette[rtype],
              ax=ax,
              linewidth=lineWidths[rtype],
              label=rtype)

# Get all three collections - one for each line type
lines = ax.collections[:3]

leg1 = ax.legend(lines, [line.get_label() for line in lines],
                 loc=(1.1, .1),
                 frameon=False,
                 title='Roads')
ax.add_artist(leg1)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_45_0.png" alt = "Once you have setup a loop, you can access the collections and define the legend using the collection attributes.">
<figcaption>Once you have setup a loop, you can access the collections and define the legend using the collection attributes.</figcaption>

</figure>




When you create a legend in `Python`, you will add each feature element to it by defining the label element within your for loop as follows:

`label = c_label`

And then specifying it in the `data.plot()` function.

The code looks like this:

`for ctype, data in sjer_plots.groupby('plot_type'):
    color = pointsPalette[ctype]
    label = ctype
    data.plot(color=color, ax=ax, label=label)`





Next, add subheadings to your legend. Here, you will add a "Plots" and a "Roads" subheading to make the legend easier to read. To do this you will create 2 legend elements, each with a specific title that will create the subheading. 

```python

# Set up legend
points = ax.collections[:3]
lines = ax.collections[3:]
leg1 = ax.legend(points, [point.get_label() for point in points], 
       loc=(1.1, .1), 
       prop={'size': 16, 'family': 'serif'},
       frameon=False, 
       title='Roads')
ax.add_artist(leg1)

leg2 = ax.legend(lines, [line.get_label() for line in lines], 
                 loc=(1.1, .3), 
                 prop={'size': 16},
                 frameon=False, 
                 title='Markers')
ax.add_artist(leg2)
```

### Customize legend fonts

Note that you can customize the look of legend elements using the `prop=` argument. Below you set the font family to cursive and the font size to 16. 

`prop={'size': 16, 'family': 'cursive'}`


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_51_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>





### Refine legend

You can refine each element of the legend. To adjust the legend sub heading titles 
you use 

`plt.setp(leg1.get_title())`

where leg1 is the variable name for the first legend element (the plot types in this case). You then can add various text attributes including fontsize, weight and family. 

`plt.setp(leg1.get_title(), fontsize='15', weight='bold')`

## Set Plot Attributes Globally 

There are different ways to adjust title font sizes. Below you use a call to  `plt.rcParams` to set the fonts universally for ALL PLOTS in your notebook. This is a nice option to use if you want to maintain the same plot look throughout your document. 


{:.input}
```python
plt.rcParams['font.family'] = 'sans'
plt.rcParams['font.size'] = 22
plt.rcParams['legend.fontsize'] = 'small'
```


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/scientists-guide-to-plotting-data-in-python-textbook/01-plot-with-matplotlib/plotting-geopandas/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots/2019-09-11-intro-to-spatial-plotting-matplotlib-01-customize-matplotlib-plots_56_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>



