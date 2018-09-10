---
layout: single
category: courses
title: "Intro to Spatial Data"
permalink: /courses/earth-analytics-python/spatial-data/introduction-to-spatial-data-in-open-source-python/
week-landing: 4
week: 4
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! This week, you will dive deeper into working with spatial data in `Python`. You will learn how to handle data in different coordinate reference systems, how to create custom maps and legends and how to extract data from a raster file. You are on your way towards integrating many different
types of data into your analysis which involves knowing how to deal with things
like coordinate reference systems and varying data structures.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course. Note that the data  download below is large (172MB)
however it contains data that you will use for the next 2 weeks!

[<i class="fa fa-download" aria-hidden="true"></i> Download spatial-vector-lidar data subset (~172 MB)](https://ndownloader.figshare.com/files/12447845){:data-proofer-ignore='' .btn }

</div>

| Time  | Topic | Speaker |  |  |
|:--------------|:-------|:--------|:-|:-|
| 9:30 AM   | Questions / `Python`   | Leah |  |  |
| 9:45 - 10:15  | Coordinate reference systems & spatial metadata 101 |  |  |  |
| 10:25 - 12:20 | `Python` coding session - spatial data in `Python`  | Leah |  |  |

### 1. Complete the Assignment Below

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework (5 points): Due 

### Produce a Report

Create a new `Jupyter Notebook` document. Name it: **lastName-firstInitial-week4.ipynb**
Within your `.ipynb` document, include the plots listed below.

You will submit an `.ipynb` file. Be sure to name your file as instructed above!

In your report, include the plots below. The important part of this week is that you document each step of your workflow using comments. And that you break up the sections of your analysis into SEPARATE code chunks.



#### Plot 1 - Roads Map and Legend

Create a map of California roads:

1. Import the `madera-county-roads/tl_2013_06039_roads.shp` layer located in your `week_04` data download.
2. Create a map that shows the madera roads layer, sjer plot locations and the sjer_aoi boundary (sjer_crop.shp).
3. Plot the roads so different **road types** (using the RTTYP field) are represented using unique symbology. Use the `RTTYP` field to plot unique road types.
4. Map the plot locations by the attribute **plot type** using unique symbology for each "type".
4. Add a **title** to your plot.
5. Adjust your plot legend so that the full name for each `RTTYP` name is clearly represented in your legend. HINT: You will need to consult the metadata for that layer to determine what each `RTTYP` type represents.
6. Be sure that your plot legend is not covering your data.

**IMPORTANT:** be sure that all of the data are within the same `EXTENT` and `crs` of the `sjer_aoi` layer. This means that you may have to crop and reproject your data prior to plotting it!

 

### Calculate Total Length of Road for each County in California

Create a geopandas `data.frame` that shows the total length of road in each county in the state of California.
To calculate this use the following layers:

* COUNTIES in California: `spatial-vector-lidar/california/ca_counties/CA_Counties_TIGER2016.shp` layer 
* Roads: `spatial-vector-lidar/global/ne_10m_roads/ne_10m_roads.shp` layer 

IMPORTANT: before performing this calculation, REPROJECT both data layers to albers `.to_crs({'init': 'epsg:5070'})`
Tips

* remember that both layers need to he in the SAME coordinate reference system for you to work wtih them together. 
* You will want to clip the roads to the boundary of California. The `unary_union` attribute will be useful for this clip operation!
* HINT: you may need to rename a column for this to work properly. You can use `dataframe.rename(columns = {'old-col-name':'new-col-name'}, inplace = True)` to rename a column in pandas. 


### Submit to D2L

Submit your report in both `.ipynb` and `.html` format to the D2l week 4 dropbox by 

</div>

## .html Report Structure & Code: 20%

| Full Credit | No Credit  |
|:----|----|
| .ipynb file submitted  |   |   |
| Code is written using "clean" code practices following the Python PEP 8 style guide |  |  |
| First markdown cell contains a title, author and date  | |
| All cells contain code that run   |  |
| All required `Python` packages are listed at the top of the document in a code chunk. |     |


## PLOT: Map of Madera County with Roads 40%

| Full Credit | No Credit  |
|:----|----|
| Roads, plot locations & AOI boundary are included on the map  |   |   |
| Road lines are symbolized by type |  |  |
| Plot location points are symbolized by type | |
| Plots has a title that clearly defines plot contents   |  |
| Plots have a 2-3 sentence caption that clearly describes plot contents |     |
| Plot legend is next to the map (on the side or below) and doesn't overlay the plot contents |     |
| Plot legend is formatted with the correctly symbology that matches the map and is easy to read |     |

## PLOT: Map of Madera County with Roads 30%

| Full Credit | No Credit  |
|:----|----|
| Road length for each county is correct  |   |   |



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_2_0.png">

</figure>




### Road Length For Del Norte, Modoc & Siskiyou Counties
Below is a map of the road layers clipped to the three counties to help you check your answer!

{:.input}
```python
f, ax = plt.subplots()
three_counties.plot(ax=ax, facecolor="none", 
                         edgecolor = "black")
roads_county.plot(ax=ax, column = "NAME", legend = True)
ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_4_0.png">

</figure>





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
      <th>length</th>
    </tr>
    <tr>
      <th>NAME</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Del Norte</th>
      <td>121307.4618</td>
    </tr>
    <tr>
      <th>Modoc</th>
      <td>245029.4067</td>
    </tr>
    <tr>
      <th>Siskiyou</th>
      <td>472428.0129</td>
    </tr>
  </tbody>
</table>
</div>




