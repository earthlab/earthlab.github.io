---
layout: single
title: "Customize your Maps in Python using Matplotlib: GIS in Python"
excerpt: "In this lesson you will review how to customize matplotlib maps created using vector data in Python. You will review how to add legends, titles and how to customize map colors."
authors: ['Chris Holdgraf', 'Leah Wasser']
modified: 2018-09-18
category: [courses]
class-lesson: ['hw-custom-maps-python']
module-title: 'Custom plots in Python'
module-description: 'This tutorial covers the basics of creating custom plot legends in Python'
module-nav-title: 'Spatial Data: Custom Plots in Python'
module-type: 'homework'
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/python-customize-map-legends-geopandas/
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

In this lesson you will review one way to create custom maps using the `Python` programming language.
Keep in mind that there are many different ways to create maps in `Python`. In this lesson, you will use the `geopandas` library to create your maps. Geopandas plotting relies heavily on the base plotting functionality of `matplotlib` however if you recall from earlier lessons, you call the plot function as a function of the geodataframe created by 
geopandas as follows:

`dataframename.plot(plot-attributes-here)`

To begin, you will import all of the required libraries.

{:.input}
```python
# import libraries
import os
import numpy as np
import geopandas as gpd
import os
import matplotlib.pyplot as plt
plt.ion()
```

### Import Data

To begin, import and explore your spatial data. In this case you are importing the same roads layer that you used in earlier lessons which is stored in shapefile (.shp) format. 

{:.input}
```python
# import roads shapefile
sjer_roads = gpd.read_file("data/spatial-vector-lidar/california/madera-county-roads/tl_2013_06039_roads.shp")
type(sjer_roads)
```

{:.output}
{:.execute_result}



    geopandas.geodataframe.GeoDataFrame





{:.input}
```python
# view data type 
print(type(sjer_roads['RTTYP']))
# view unique attributes for each road in the data
print(sjer_roads['RTTYP'].unique())
```

{:.output}
    <class 'pandas.core.series.Series'>
    ['M' '' 'S' 'C']



## Replace missing data values

It looks like you have some missing values in your road types. You want to plot all
road types even those that are set to `None` - which is python's default missing data value. Change the roads with an `RTTYP` attribute of `None` to "unknown".

{:.input}
```python
# map each value to a new value 
sjer_roads = sjer_roads.replace({'RTTYP': {'': "Unknown"}})
print(sjer_roads['RTTYP'].unique())
```

{:.output}
    ['M' 'Unknown' 'S' 'C']



<i class="fa fa-star"></i> **Data Tip:** There are many different ways to deal with missing data in Python. Another way to replace all values of None is to use the `.isnull()` function like this:
`sjer_roads.loc[sjer_roads['RTTYP'].isnull(), 'RTTYP'] = 'Unknown' `
{: .notice}

{:.input}
```python
# how many line features are associated with each attribute value?
sjer_roads['RTTYP'].value_counts()
```

{:.output}
{:.execute_result}



    Unknown    5149
    M          4456
    S            25
    C            10
    Name: RTTYP, dtype: int64





{:.input}
```python
# view attributes of the data including count, number of unique attribute values and the attribute associated the most features
sjer_roads['RTTYP'].describe()
```

{:.output}
{:.execute_result}



    count        9640
    unique          4
    top       Unknown
    freq         5149
    Name: RTTYP, dtype: object






## Plot by attribute 

To plot a vector layer by attribute value so each road layer is colored 
according to it's respective attribute value, you need to do two things.

1. You need to create a dictionary that associates a particular color with a particular attribute value
2. You then need to loop through and apply that color to each attribute value

Note that there are other ways to plot as well that require less code. For instance, 
you could simply plot using `geopandas` like this.


{:.input}
```python
sjer_roads.plot(column='RTTYP',
               categorical=True,
               legend=True, figsize=(14,6));
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_12_0.png">

</figure>




However, you will plot using the more explicit approach of specifying a dictionary to allow for 
better legend generation later in this lesson.

To begin, create a dictionary that associated a color with each road type. Remember that you have 4 road types so you will need to select 4 colors associated with those types.

{:.input}
```python
# Create a dictionary where you assign each attribute value to a particular color
roadPalette = {'M': 'blue', 'S': 'green', 'C': 'purple', 'Unknown': 'grey'}
roadPalette
```

{:.output}
{:.execute_result}



    {'C': 'purple', 'M': 'blue', 'S': 'green', 'Unknown': 'grey'}





Next, you loop through each attribute value and plot the lines with that attribute value using the color specified in the dictionary. 

{:.input}
```python
# setup plot 
fig, ax = plt.subplots(figsize=(10, 10))
# turn off axes
ax.set_axis_off()
# loop through each attribute type and plot it using the colors assigned in the dictionary
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    data.plot(color=color, ax=ax)
# add title to plot    
ax.set(title='Madera County Roads');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_16_0.png">

</figure>




### Adjust Line Width

You can adjust the width of your plot lines using the `linewidth=` attribute. Set the `linewidth` to 4 to see if you can make a truly ugly plot.

{:.input}
```python
fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
# loop through each xxx in the roads layer and assign it a color 
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    data.plot(color=color, ax=ax, linewidth=4)  # Make lines thicker
# Add title to plot    
ax.set(title='Madera County Roads');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_18_0.png">

</figure>




### Adjust Line Width by Attribute

Above you successfully created a nice ugly map! Now refine it. 

You can assign each attribute a unique line width using the syntax `lineWidths[ctype]`
where lineWidths is a dictionary of what line width you want to assign to each attribute
value just like you did with the colors above

`lineWidths = {'M': 1, 'S': 1, 'C': 4, 'Unknown': .5}`

Here you are assigning the linewidth of each respective attibute value a line width as follows: 

* M: 1
* S: 1
* C: 4
* Unknown = 4

{:.input}
```python
# create dictionary to map each attribute value to a line width
lineWidths = {'M': 1, 'S': 1, 'C': 4, 'Unknown': .5}

# then plot data adjusting the linewidth attribute 
fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    data.plot(color=color, ax=ax, linewidth=lineWidths[ctype])
ax.set(title='Madera County \n Line width varies by TYPE Attribute Value');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_20_0.png">

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge: Plot line width by attribute

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

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_22_0.png">

</figure>




## Add Plot Legend
You can add a legend to your plot using the `ax.legend()` method. Here you specify the `loc=` to be in the **lower right** hand part of the plot. 

`ax.legend(loc='lower right')`

When you add a legend, you use the following elements to specify labels and colors:

* **location**: specify an x and Y location of the plot Or generally specify the location e.g. 'bottom right', 'top', 'top right', etc.
* **fontsize:** the size of the fonts used in the legend
* **frameon:** Boolean Values: True of False - if you want a box around your legend use `True`

Add a legend to your plot.

{:.input}
```python
lineWidths = {'M': 1, 'S': 2, 'C': 1.5, 'Unknown': 3}

fig, ax = plt.subplots(figsize=(10, 10))
# turn off axis
ax.set_axis_off()

# loop through each attribute value and assign it the correct color & width specified in the dictionary
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label=ctype
    data.plot(color=color, ax=ax, linewidth=lineWidths[ctype], label=label)

    # add title to plot
ax.set(title='Madera County \n Line width varies by TYPE Attribute Value')
# place legend in the lower right hand corner of the plot 
ax.legend(loc='lower right', 
          fontsize=20, 
          frameon=True);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_24_0.png">

</figure>




See what happens when you set the frameon attribute of your legend to `False` and adjust the line widths - does your legend change?

{:.input}
```python
lineWidths = {'M': 1, 'S': 2, 'C': 1.5, 'Unknown': 3}

fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype if len(ctype) > 0 else 'unknown'
    data.plot(color=color, ax=ax, linewidth=lineWidths[ctype], label=label)
ax.set(title='Madera County \n Line width varies by TYPE Attribute Value')
ax.legend(loc='lower right', fontsize=20, frameon=False);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_26_0.png">

</figure>




Change the colors that you're using the plot.

{:.input}
```python
roadPalette = {'M': 'springgreen', 'S': "blue", 'C': "magenta", 'Unknown': "grey"}
lineWidths = {'M': 1, 'S': 2, 'C': 1.5, 'Unknown': 3}

fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype
    data.plot(color=color, ax=ax, linewidth=lineWidths[ctype], label=label)
ax.set(title='Madera County Roads \n Pretty Colors')
ax.legend(loc='lower right', 
          fontsize=20, 
          frameon=False);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_28_0.png">

</figure>






##  Plot Lines by Attribute


Play with colors one more time. Create a plot that emphasizes only roads designated as C or S (County or State). To emphasize these types of roads, make the lines that are assigned the RTTYP attribute of C or S, THICKER than the other lines.

Be sure to add a title and legend to your map! You might consider a color palette that has all County and State roads displayed in a bright color. All other lines can be grey.

{:.input}
```python
# define colors and line widths
roadPalette = {'M': 'grey', 'S': "blue", 'C': "magenta", 'Unknown': "lightgrey"}
lineWidths = {'M': .5, 'S': 2, 'C': 2, 'Unknown': .5}

# create figure 
fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
for ctype, data in sjer_roads.groupby('RTTYP'):
    color = roadPalette[ctype]
    label = ctype
    data.plot(color=color, ax=ax, linewidth=lineWidths[ctype], label=label)
ax.set(title='Madera County Roads\n County and State recognized roads')
ax.legend(loc='lower right', fontsize=20, frameon=False);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_30_0.png">

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
# import points layer
sjer_plots = gpd.read_file("data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_plot_centroids.shp")
# view first 5 rows
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
      <td>POINT (256838.76 4110819.876)</td>
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
pointsPalette = {'trees': 'chartreuse', 'grass': 'darkgreen', 'soil': 'burlywood'}
roadPalette = {'M': 'grey', 'S': "blue", 'C': "magenta", '': "lightgrey"}
lineWidths = {'M': .5, 'S': 2, 'C': 2, '': .5}

fig, ax = plt.subplots(figsize=(10, 10))
ax.set_axis_off()
for ctype, data in sjer_plots.groupby('plot_type'):
    color = pointsPalette[ctype]
    label = ctype if len(ctype) > 0 else 'unknown'
    data.plot(color=color, ax=ax, label=label, markersize=100)
ax.set(title='Study area plot locations\n by plot type (grass, soil and trees)')
ax.legend(loc='lower right', fontsize=20, frameon=True);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_34_0.png">

</figure>




### Overlay points on top of roads

Next, plot the plot data on top of the roads layer. Then create a custom legend that contains both lines and points. 

NOTE: In this example the projection for the roads layer is already changed and the layer has been cropped! You will have to do the same before this code will work.


{:.input}
```python
sjer_aoi = gpd.read_file("data/spatial-vector-lidar/california/neon-sjer-site/vector_data/SJER_crop.shp")

# reproject the data 
sjer_roads_utm = sjer_roads.to_crs(crs=sjer_aoi.crs)
```

## Clip (Intersect) the Data

Next, clip the roads layer to the boundary of the sjer_aoi layer. This will remove all roads and road segments that are outside of your square AOI layer. To do this you will use the Polygon module from the shapely.geometry library.

To clip your data you need to do the following

1. create a boundary layer that will create the clipping rectangle
2. use the `intersection()` function to clip or intersect the data

{:.input}
```python
sjer_aoi.total_bounds
```

{:.output}
{:.execute_result}



    array([ 254570.567     , 4107303.07684455,  258867.40933092,
           4112361.92026107])





{:.input}
```python
# from shapely.geometry import Polygon

# # extract the xmin / max and y min/max values from the aoi layer 
# xmin, ymin, xmax, ymax = sjer_aoi.total_bounds
# bounds = Polygon( [(xmin,ymin), (xmin,ymax), (xmax,ymax), (xmax,ymin)] )

# # Crop all lines and take the part inside the bounding box
# sjer_roads_utm['geometry'] = sjer_roads_utm['geometry'].intersection(bounds)

# # plot the data to see if the clip worked
# sjer_roads_utm.plot(figsize=(8, 8),
#                     column='RTTYP',
#                     categorical=True,
#                     legend=True);
```

{:.input}
```python
from shapely.geometry import box

bounds = box(*sjer_aoi.total_bounds)
sjer_roads_utm.geometry.intersection(bounds)

# plot the data to see if the clip worked
sjer_roads_utm.plot(figsize=(8, 8),
                    column='RTTYP',
                    categorical=True,
                    legend=True);
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_40_0.png">

</figure>




When you create a legend in `Python`, you will add each feature element to it by defining the label element within your for loop as follows:

`label = c_label`

And then specifying it in the `data.plot()` function.

The code looks like this:

`for ctype, data in sjer_plots.groupby('plot_type'):
    color = pointsPalette[ctype]
    **label = ctype**
    data.plot(color=color, ax=ax, **label=label**)`

## Modify the Legend Location 


Next, adjust the legend location. Previously the legend has plotted wtihin the plot area - so it is often covering the data. Plot the legend next to your data. To do this, you simply specify the **loc**ation argument within the `ax.legend()` element. 

`ax.legend(loc=(how-far-right, how-far-above-0))`

Above the first value is the position to the RIGHT of the plot and the second is the vertical position (how far above 0). 

Next, add subheadings to your legend. Here, you will add a "Plots" and a "Roads" subheading to make the legend easier to read. To do this you will create 2 legend elements, each with a specific title that will create the subheading. 

```python

# Set up legend
points = ax.collections[:3]
lines = ax.collections[3:]
leg1 = ax.legend(points, [point.get_label() for point in points], 
       loc=(1.1, .1), 
       prop={'size': 16, 'family': 'cursive'},
       frameon=False, title='Roads')
ax.add_artist(leg1)

leg2 = ax.legend(lines, [line.get_label() for line in lines], loc=(1.1, .3), prop={'size': 16},
                  frameon=False, title='Markers')                 
```

### Customize legend fonts

Note that you can customize the look of legend elements using the `prop=` argument. Below you set the font family to cursive and the font size to 16. 

`prop={'size': 16, 'family': 'cursive'}`


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_44_0.png">

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
plt.rcParams['font.weight'] = 'bold'
plt.rcParams['font.size'] = 22

plt.rcParams['legend.fontsize'] = 'small'
```


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/additional-lessons/2018-02-05-plot01-customize-python-matplotlib-plots_48_0.png">

</figure>



