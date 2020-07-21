---
layout: single
title: "Customize Map Legends and Colors in Python using Matplotlib: GIS in Python"
excerpt: "When making maps, you often want to add legends and customize the map colors. Learn how to customize legends and colors in matplotlib maps created using vector data in Python."
authors: ['Chris Holdgraf', 'Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-07-21
category: [courses]
class-lesson: ['hw-custom-maps-python-tb']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-vector-plots/python-customize-map-legends-geopandas/
nav-title: 'Customize Map Legends and Colors'
course: 'scientists-guide-to-plotting-data-in-python-textbook'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['vector-data']
redirect_from:
  - "/courses/earth-analytics-python/spatial-data-vector-shapefiles/python-customize-map-legends-geopandas/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Create a map containing multiple vector datasets, colored by unique attributes in **Python**.
* Add a custom legend to a map in **Python** with subheadings, unique colors.

</div>


## Create Custom Maps with Python

In this lesson, you will learn how to customize map symbology or the colors and symbols used to represent vector data in Python. There are many different ways to create maps in **Python**. In this lesson, you will use the **geopandas**  and **matplotlib**.

To begin, import all of the required libraries.

{:.input}
```python
# Import libraries
import os
import matplotlib.pyplot as plt
import numpy as np
from shapely.geometry import box
import geopandas as gpd
import earthpy as et

# Get the data & set working dir
data = et.data.get_data('spatial-vector-lidar')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12459464
    Extracted output to /root/earth-analytics/data/spatial-vector-lidar/.



### Import Data

Next, import and explore your spatial data. In this case you are importing the same roads layer that you used in earlier lessons which is stored in shapefile (`.shp`) format. 

{:.input}
```python
# Import roads shapefile
sjer_roads_path = os.path.join("spatial-vector-lidar", 
                               "california", "madera-county-roads", 
                               "tl_2013_06039_roads.shp")

sjer_roads = gpd.read_file(sjer_roads_path)

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

# Adjust legend location
leg = ax.get_legend()
leg.set_bbox_to_anchor((1.15,0.5))

ax.set_axis_off()

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_9_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>





## Plot Color by Attribute 

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

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_13_0.png" alt = "One way to customize plots is to create a dictionary that contains the symbology or colors and symbols that you wish to use for each attribute type in the map and legend.">
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

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_15_0.png" alt = "Here the line width is adjusted on the roads layer.">
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

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_17_0.png" alt = "You can refine plot symbology to make nicer looking plots.">
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

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_19_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
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
          fontsize=15,
          frameon=True)

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_21_0.png" alt = "If you set the label argument in your plot, that will be added to your legend when you call ax.legend().">
<figcaption>If you set the label argument in your plot, that will be added to your legend when you call ax.legend().</figcaption>

</figure>




See what happens when you set the frameon attribute of your legend to `False` and adjust the line widths - does your legend change? Also notice below the `loc=()` argument is given a tuple - two  numbers that define the x and y location of the legend relative to the plot figure region.

{:.input}
```python
lineWidths = {'M': 1, 'S': 2, 'C': 1.5, 'Unknown': 3}

fig, ax = plt.subplots(figsize=(10, 10))

for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype
    data.plot(color=color,
              ax=ax,
              linewidth=lineWidths[ctype],
              label=label)

ax.set(title='Madera County \n Line width varies by TYPE Attribute Value')
ax.legend(loc=(1, .5),
          fontsize=15,
          frameon=False,
          title="LEGEND")

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_23_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
<figcaption>Geopandas plot of roads colored according to an attribute.</figcaption>

</figure>




Now, adjust both the plot colors and line widths.

{:.input}
```python
roadPalette = {'M': 'grey', 'S': "blue",
               'C': "magenta", 'Unknown': "lightgrey"}

lineWidths = {'M': 1, 'S': 2, 'C': 1.5, 'Unknown': 3}

fig, ax = plt.subplots(figsize=(10, 10))

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

ax.set_axis_off()

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_25_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
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

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_27_0.png" alt = "Geopandas plot of roads colored according to an attribute.">
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
sjer_plots_path = os.path.join("spatial-vector-lidar", 
                               "california", 
                               "neon-sjer-site", 
                               "vector_data", 
                               "SJER_plot_centroids.shp")

sjer_plots = gpd.read_file(sjer_plots_path)

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
    label = ctype
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

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_31_0.png" alt = "A similar approach can be taken to customize points on a plot.">
<figcaption>A similar approach can be taken to customize points on a plot.</figcaption>

</figure>




### Overlay points on top of roads

Next, plot the plot data on top of the roads layer. Then create a custom legend that contains both lines and points. 

NOTE: In this example, the projection for the roads layer has to match the projection of the SJER plot locations. 

{:.input}
```python
# Reproject the data
sjer_roads_utm = sjer_roads.to_crs(sjer_plots.crs)
```

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 10))

for ctype, data in sjer_plots.groupby('plot_type'):
    color = pointsPalette[ctype]
    label = ctype
    data.plot(color=color,
              ax=ax,
              label=label,
              markersize=100)
    
for ctype, data in sjer_roads_utm.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype    
    data.plot(color=color,
              ax=ax,
              linewidth=lineWidths[ctype],
              label=label)
    
ax.set(title='Study area plot locations\n by plot type (grass, soil and trees)')

ax.legend(fontsize=15,
          frameon=False,
          loc=('lower right'),
          title="LEGEND")

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/02-plot-spatial-data/vector-plots/2018-02-05-plot02-customize-python-matplotlib-plots/2018-02-05-plot02-customize-python-matplotlib-plots_34_0.png" alt = "You can customize points and lines in one plot by using the ax object for both plots.">
<figcaption>You can customize points and lines in one plot by using the ax object for both plots.</figcaption>

</figure>







































