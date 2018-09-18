---
layout: single
category: courses
title: "Intro to Spatial Data"
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/intro-use-vector-spatial-data-in-open-source-python/
week-landing: 4
week: 4
modified: 2018-09-18
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

<!-- 
### 1. Complete the Assignment Below

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework (5 points): Due 

### Produce a Report

Create a new `Jupyter Notebook` document. Name it: **lastName-firstInitial-week4.ipynb**
Within your `.ipynb` document, include the plots listed below.

You will submit an `.ipynb` file. Be sure to name your file as instructed above!

In your report, include the plots below. The important part of this week is that you document each step of your workflow using comments. And that you break up the sections of your analysis into SEPARATE code chunks.
 




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
-->


## Plot 1 - Roads Map and Legend

Create a map of California roads:

1. Import the `madera-county-roads/tl_2013_06039_roads.shp` layer located in your `spatial-vector-lidar` data download.
2. Create a map that shows the madera roads layer, sjer plot locations and the `sjer_aoi` boundary (`sjer_crop.shp`).
3. Plot the roads so different **road types** (using the RTTYP field) are represented using unique symbology. Use the `RTTYP` field to plot unique road types.
4. Map the plot locations by the attribute **plot type** using unique symbology for each "type".
4. Add a **title** to your plot.
5. Adjust your plot legend so that the full name for each `RTTYP` name is clearly represented in your legend. HINT: You will need to consult the metadata for that layer to determine what each `RTTYP` type represents.
6. Be sure that your plot legend is not covering your data.

**IMPORTANT:** be sure that all of the data are within the same `EXTENT` and `crs` of the `sjer_aoi` layer. This means that you may have to crop and reproject your data prior to plotting it!

{:.input}
```python
#help(clip_points)
```


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_5_0.png" alt = "Map showing the SJER field site roads and plot locations clipped to the site boundary.">
<figcaption>Map showing the SJER field site roads and plot locations clipped to the site boundary.</figcaption>

</figure>




## Calculate Total Length of Road Siskiyou, Modoc, Del Norte County in California

Create a geopandas `data.frame` that shows the total length of road in each county in the state of California.
To calculate this use the following layers:

* Counties in California: `spatial-vector-lidar/california/ca_counties/CA_Counties_TIGER2016.shp` layer 
* Roads: `spatial-vector-lidar/global/ne_10m_roads/ne_10m_roads.shp` layer 

IMPORTANT: before performing this calculation, REPROJECT both data layers to albers `.to_crs({'init': 'epsg:5070'})`
Tips

* Both layers need to the in the SAME coordinate reference system for you to work with them together. 
* You will want to clip the roads to the boundary of California. The `unary_union` attribute will be useful for this clip operation!
* you may need to rename a column for this to work properly. You can use `dataframe.rename(columns = {'old-col-name':'new-col-name'}, inplace = True)` to rename a column in pandas. 
* To assign each road to it's respective county, you will need to do a spatial join using `.sjoin()`

* Finally calculate the length of each road segment. 

To calculate length of each line in your geodataframe , you can use the syntax `geopandas_dataframe_name.length`. Create a new column using the syntax:

`geopandas_dataframe_name["length"] = geopandas_dataframe_name.length`

* Summarize the data to calculate total length using pandas `.groupby()` on the county column name.

HINT: use: `pd.options.display.float_format = '{:.4f}'.format` if you'd like to turn off scientific notation for your outputs.


## Plot Roads in Siskiyou, Modoc, Del Norte County in California


## Plot xx - Roads in Del Norte, Modoc & Siskiyou Counties

Using the dataframe that you created above with each road assigned to the county that it is within, create a map of roads by county. Color the roads in each county using a unique color.

Below is a map of the road layers clipped to the three counties to help you check your answer!
HINT: use the `legend=True` argument in `.plot()` to create a legend.


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_9_0.png" alt = "Map showing the roads layer clipped to the three counties and colored according to which county the road is in.">
<figcaption>Map showing the roads layer clipped to the three counties and colored according to which county the road is in.</figcaption>

</figure>




## Quantile Map for The USA

The 2014 census layer: `"data/spatial-vector-lidar/usa/usa-states-census-2014.shp"` contains an `ALAND` and `AWATER` attribute columns that represent calculated total land and water area for each state in the continental United States. Use this layer to summarize the data by `region`. Then provide a table that shows summary values for each attribute 

Use this layer to calculate mean values for `ALAND` and `AWATER` found in the attributes. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_11_0.png">

</figure>




{:.input}
```python
# Print out the table
mean_region_val
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
      <th>ALAND</th>
      <th>AWATER</th>
    </tr>
    <tr>
      <th>region</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Midwest</th>
      <td>(POLYGON Z ((-82.863342 41.693693 0, -82.82571...</td>
      <td>1943869253244</td>
      <td>184383393833</td>
    </tr>
    <tr>
      <th>Northeast</th>
      <td>(POLYGON Z ((-76.04621299999999 38.025533 0, -...</td>
      <td>869066138232</td>
      <td>108922434345</td>
    </tr>
    <tr>
      <th>Southeast</th>
      <td>(POLYGON Z ((-81.81169299999999 24.568745 0, -...</td>
      <td>1364632039655</td>
      <td>103876652998</td>
    </tr>
    <tr>
      <th>Southwest</th>
      <td>POLYGON Z ((-94.48587499999999 33.637867 0, -9...</td>
      <td>1462631530997</td>
      <td>24217682268</td>
    </tr>
    <tr>
      <th>West</th>
      <td>(POLYGON Z ((-118.594033 33.035951 0, -118.540...</td>
      <td>2432336444730</td>
      <td>57568049509</td>
    </tr>
  </tbody>
</table>
</div>





You can use the code below to download and unzip the data from the Natural Earth website.
Please note that the download function was written to take

1. a download path - this is the directory where you want to store your data
2. a url - this is the URL where the data are located. The URL below might look odd as it has two "http" strings in it but it is how the url's are organized on natural earth and should work. 

The `download()` function will unzip your data for you and place it in the directory that you specify. 

## Plot XX

1. Download the natural earth data using the code below. Be sure to add the download packate to the TOP of your notebook. It is just here as an example to highlight that you will need to use this package to download the data.

After you have downloaded the data, import the data and 
1. subset the data to include the following columns: `["REGION_WB", "CONTINENT", "POP_RANK","POP_EST", 'geometry']`
2. Dissolve the data by region (`REGION_WB`) column and aggregate by sum and mean. HINT: you can provide the aggfun= argument with a [list] of functions in quotes and it will summarize numeric columns using each function
3. Create two plots within one matplotlib figure 
    a. Create a plot of the sum estimated population (`POP_EST`) by region
    b. Create a plot of the mean population range (`POP_RANK`) by region

{:.input}
```python
# Add this line importing the download package to your top cell with the other packages!
from download import download

# Get the data from natural earth
url = "https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip"

# Please note that this is the directory name where your data will be unzipped
download_path = os.path.join("data", "spatial-vector-lidar", "global","ne_10m_admin_0_countries")
download(url, download_path, kind='zip', verbose=False)
country_path = os.path.join(download_path, "ne_10m_admin_0_countries.shp")
```


{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/pandas/core/reshape/merge.py:544: UserWarning: merging between different levels can give an unintended result (1 levels on the left, 2 on the right)
      warnings.warn(msg, UserWarning)




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_17_0.png" alt = "Natural Earth Global Mean population rank and total estimated population">
<figcaption>Natural Earth Global Mean population rank and total estimated population</figcaption>

</figure>



