---
layout: single
title: 'Use Raster Data for Earth Data Science'
excerpt: "Raster data is one of the two most common spatial data types. Learn to work with raster data for earth data science."
authors: ['Leah Wasser', 'Nathan Korinek']
category: [courses]
class-lesson: ['spatial-data-formats']
permalink: /courses/intro-to-earth-data-science/file-formats/use-spatial-data/use-raster-data/
nav-title: "Use Raster Data"
dateCreated: 2020-06-20
modified: 2021-09-16
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
    spatial-data-and-gis: ['raster-data']
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success alert alert-info' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Fundamentals of Raster Data in Python 

In this lesson, you will learn fundamental concepts related to working with raster data in **Python**, including understanding the spatial attributes of raster data, how to open raster data, and how to visually plot the data. 


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Open raster data using **Rioxarray** in **Python**.
* Be able to plot spatial raster data using **EarthPy** in **Python**.

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Suggested Readings 


Before starting this lesson, read the **What is a Raster** section of [this page](https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/) of the Earth Lab website to familiarize yourself with the concept of raster data. 

</div>


## What is Raster data?

Raster or “gridded” data are stored as a grid of values which are rendered on a map as pixels. Each pixel value represents an area on the Earth’s surface making the data spatial. A raster file is composed of regular grid of cells, all of which are the same size. You've looked at and used rasters before if you've looked at photographs or imagery in a tool like Google Earth. However, the raster files that you will work with are different from photographs in that they are spatially referenced. Each pixel represents an area of land on the ground. That area is defined by the spatial **resolution** of the raster.

<figure>
   <a href="https://www.earthdatascience.org/images/earth-analytics/raster-data/raster-concept.png" target="_blank">
   <img src="https://www.earthdatascience.org/images/earth-analytics/raster-data/raster-concept.png" alt="Raster data concept diagram."></a>
   <figcaption>A raster is composed of a regular grid of cells. Each cell is the same
   size in the x and y direction. Source: Colin Williams, NEON.
   </figcaption>
</figure>


<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** For more information on rasters, how they work, and the types of data stored in rasters, see [this chapter](https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/) on using raster data from the earth data science intermediate textbook.

</div>

## Raster Data Can Have One or More Layers 

Raster data can have one or more layers. An elevation model 
for example will often just have one layer representing the 
elevation of the earth's surface for a particular location. However, 
other data including images and time series data, may result in 
a raster file that is composed of multiple layers. Different 
file types can be used to accomodate different sizes and structures
of raster data. 


## There Are Many Different File Raster File Formats
There are many different file types that are used to store 
raster data. 

### Raster Data Stored As Single Files 

Some datasets such as landsat and NAIP are stored in single files. For landsat, often you will find each band stored as a separate .tif file. NAIP stores all bands in on .tif file. Common file types for raster data stored as a single file include:

- **.tif / .tiff**: Stands for Tagged Image File Format. One of the most common ways to store raster data. How some image satellites, such as Landsat, share their data. 
- **.asc**: Stands for ASCII Raster Files. This is a text based format that stores raster data. This format is used given it's simple to store and distribute. 

#### Hierarchical Data Formats

Hierarchical data formats can store many different types of data in one single file. These formats are optimal for larger data sets where you may want to subset or only work with parts of the data at one time. Hierarchical
data can be a bit more involved to work with but they tend to make processing more efficient. Common file types for this data storage method include: 

- **.hdf / .hdf5**: Stands for Hierarchical Data Format. One of the most common hierarchical was to store raster data. How some image satellites, such as MODIS, share their data. 
- **.nc (NetCDF)**: Stands for Network Common Data Form. A common way to store climate data. 

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** Learn more about working with GeoTiff files in <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/intro-to-the-geotiff-file-format/" target="_blank">this earth data science textbook lesson.</a>. Learn more about working with HDF4 files (the format used to store MODIS data) in <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/hierarchical-data-formats-hdf/intro-to-hdf4/" target="_blank">this earth data science textbook chapter.</a>
</div>

## What Types of Data Are Stored In Rasters?  

Some examples of data that often are provided in a raster format include:

- Satellite imagery
- Land use over large areas
- Elevation data
- Weather data
- Bathymetry data

Next you will open and work with some raster data. To begin
setup your notebook with the required python packages.

{:.input}
```python
# Import necessary packages
import os

import matplotlib.pyplot as plt
import numpy as np
import geopandas as gpd
import rioxarray as rxr

# Earthpy is an earthlab package to work with spatial data
import earthpy as et
import earthpy.plot as ep

# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



## Open Raster Data in Open Source Python Using Rioxarray

You can open raster data in **Python** using `rioxarray`. The code below can 
be used to open up a raster file:  

```python
# Read the data in and call it lidar_dtm (this is the variable name)
lidar_dtm = rxr.open_rasterio(lidar_dem_path, masked=True)
```

The code does the following:

1. `rxr.open_rasterio` - rxr is the alias for rioxarray. At the top of your code you include rioxarray: `import rioxarray as rxr`. 
2. `masked=True` statement will mask all `nodata` values in your array. This means that they will not be plotted and also that they will not be included in math calculations in `Python`.  


The data that you will work with below - filename: `pre_DTM.tif` is lidar 
(Light Detection and Ranging) derived elevation data. The file format is a 
**.tif** file. The data represent a Digital Terrain Model (DTM). You can 
<a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/what-is-lidar-data/lidar-chm-dem-dsm/">learn more about DTMs in this earth data science lesson on lidar data.</a> 

Below, you create a path to the file you want to open. 

{:.input}
```python
# Create a path to file
lidar_dtm_path = os.path.join("colorado-flood",
                              "spatial",
                              "boulder-leehill-rd",
                              "pre-flood",
                              "lidar",
                              "pre_DTM.tif")
lidar_dtm_path
```

{:.output}
{:.execute_result}



    'colorado-flood/spatial/boulder-leehill-rd/pre-flood/lidar/pre_DTM.tif'





Next, open up your data.

{:.input}
```python
# Open and read in the digital terrain model
# Note that rxr is the alias for rioxarray
lidar_dtm = rxr.open_rasterio(lidar_dtm_path, masked=True)

# View the data - notice the data structure is different from geopandas data
# which you explored in the last lesson
lidar_dtm
```

{:.output}
{:.execute_result}



<div><svg style="position: absolute; width: 0; height: 0; overflow: hidden">
<defs>
<symbol id="icon-database" viewBox="0 0 32 32">
<path d="M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z"></path>
<path d="M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
<path d="M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
</symbol>
<symbol id="icon-file-text2" viewBox="0 0 32 32">
<path d="M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z"></path>
<path d="M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
</symbol>
</defs>
</svg>
<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.
 *
 */

:root {
  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));
  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));
  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));
  --xr-border-color: var(--jp-border-color2, #e0e0e0);
  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);
  --xr-background-color: var(--jp-layout-color0, white);
  --xr-background-color-row-even: var(--jp-layout-color1, white);
  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);
}

html[theme=dark],
body.vscode-dark {
  --xr-font-color0: rgba(255, 255, 255, 1);
  --xr-font-color2: rgba(255, 255, 255, 0.54);
  --xr-font-color3: rgba(255, 255, 255, 0.38);
  --xr-border-color: #1F1F1F;
  --xr-disabled-color: #515151;
  --xr-background-color: #111111;
  --xr-background-color-row-even: #111111;
  --xr-background-color-row-odd: #313131;
}

.xr-wrap {
  display: block;
  min-width: 300px;
  max-width: 700px;
}

.xr-text-repr-fallback {
  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */
  display: none;
}

.xr-header {
  padding-top: 6px;
  padding-bottom: 6px;
  margin-bottom: 4px;
  border-bottom: solid 1px var(--xr-border-color);
}

.xr-header > div,
.xr-header > ul {
  display: inline;
  margin-top: 0;
  margin-bottom: 0;
}

.xr-obj-type,
.xr-array-name {
  margin-left: 2px;
  margin-right: 10px;
}

.xr-obj-type {
  color: var(--xr-font-color2);
}

.xr-sections {
  padding-left: 0 !important;
  display: grid;
  grid-template-columns: 150px auto auto 1fr 20px 20px;
}

.xr-section-item {
  display: contents;
}

.xr-section-item input {
  display: none;
}

.xr-section-item input + label {
  color: var(--xr-disabled-color);
}

.xr-section-item input:enabled + label {
  cursor: pointer;
  color: var(--xr-font-color2);
}

.xr-section-item input:enabled + label:hover {
  color: var(--xr-font-color0);
}

.xr-section-summary {
  grid-column: 1;
  color: var(--xr-font-color2);
  font-weight: 500;
}

.xr-section-summary > span {
  display: inline-block;
  padding-left: 0.5em;
}

.xr-section-summary-in:disabled + label {
  color: var(--xr-font-color2);
}

.xr-section-summary-in + label:before {
  display: inline-block;
  content: '►';
  font-size: 11px;
  width: 15px;
  text-align: center;
}

.xr-section-summary-in:disabled + label:before {
  color: var(--xr-disabled-color);
}

.xr-section-summary-in:checked + label:before {
  content: '▼';
}

.xr-section-summary-in:checked + label > span {
  display: none;
}

.xr-section-summary,
.xr-section-inline-details {
  padding-top: 4px;
  padding-bottom: 4px;
}

.xr-section-inline-details {
  grid-column: 2 / -1;
}

.xr-section-details {
  display: none;
  grid-column: 1 / -1;
  margin-bottom: 5px;
}

.xr-section-summary-in:checked ~ .xr-section-details {
  display: contents;
}

.xr-array-wrap {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 20px auto;
}

.xr-array-wrap > label {
  grid-column: 1;
  vertical-align: top;
}

.xr-preview {
  color: var(--xr-font-color3);
}

.xr-array-preview,
.xr-array-data {
  padding: 0 5px !important;
  grid-column: 2;
}

.xr-array-data,
.xr-array-in:checked ~ .xr-array-preview {
  display: none;
}

.xr-array-in:checked ~ .xr-array-data,
.xr-array-preview {
  display: inline-block;
}

.xr-dim-list {
  display: inline-block !important;
  list-style: none;
  padding: 0 !important;
  margin: 0;
}

.xr-dim-list li {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.xr-dim-list:before {
  content: '(';
}

.xr-dim-list:after {
  content: ')';
}

.xr-dim-list li:not(:last-child):after {
  content: ',';
  padding-right: 5px;
}

.xr-has-index {
  font-weight: bold;
}

.xr-var-list,
.xr-var-item {
  display: contents;
}

.xr-var-item > div,
.xr-var-item label,
.xr-var-item > .xr-var-name span {
  background-color: var(--xr-background-color-row-even);
  margin-bottom: 0;
}

.xr-var-item > .xr-var-name:hover span {
  padding-right: 5px;
}

.xr-var-list > li:nth-child(odd) > div,
.xr-var-list > li:nth-child(odd) > label,
.xr-var-list > li:nth-child(odd) > .xr-var-name span {
  background-color: var(--xr-background-color-row-odd);
}

.xr-var-name {
  grid-column: 1;
}

.xr-var-dims {
  grid-column: 2;
}

.xr-var-dtype {
  grid-column: 3;
  text-align: right;
  color: var(--xr-font-color2);
}

.xr-var-preview {
  grid-column: 4;
}

.xr-var-name,
.xr-var-dims,
.xr-var-dtype,
.xr-preview,
.xr-attrs dt {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 10px;
}

.xr-var-name:hover,
.xr-var-dims:hover,
.xr-var-dtype:hover,
.xr-attrs dt:hover {
  overflow: visible;
  width: auto;
  z-index: 1;
}

.xr-var-attrs,
.xr-var-data {
  display: none;
  background-color: var(--xr-background-color) !important;
  padding-bottom: 5px !important;
}

.xr-var-attrs-in:checked ~ .xr-var-attrs,
.xr-var-data-in:checked ~ .xr-var-data {
  display: block;
}

.xr-var-data > table {
  float: right;
}

.xr-var-name span,
.xr-var-data,
.xr-attrs {
  padding-left: 25px !important;
}

.xr-attrs,
.xr-var-attrs,
.xr-var-data {
  grid-column: 1 / -1;
}

dl.xr-attrs {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 125px auto;
}

.xr-attrs dt,
.xr-attrs dd {
  padding: 0;
  margin: 0;
  float: left;
  padding-right: 10px;
  width: auto;
}

.xr-attrs dt {
  font-weight: normal;
  grid-column: 1;
}

.xr-attrs dt:hover span {
  display: inline-block;
  background: var(--xr-background-color);
  padding-right: 10px;
}

.xr-attrs dd {
  grid-column: 2;
  white-space: pre-wrap;
  word-break: break-all;
}

.xr-icon-database,
.xr-icon-file-text2 {
  display: inline-block;
  vertical-align: middle;
  width: 1em;
  height: 1.5em !important;
  stroke-width: 0;
  stroke: currentColor;
  fill: currentColor;
}
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (band: 1, y: 2000, x: 4000)&gt;
[8000000 values with dtype=float64]
Coordinates:
  * band         (band) int64 1
  * y            (y) float64 4.436e+06 4.436e+06 ... 4.434e+06 4.434e+06
  * x            (x) float64 4.72e+05 4.72e+05 4.72e+05 ... 4.76e+05 4.76e+05
    spatial_ref  int64 0
Attributes:
    scale_factor:  1.0
    add_offset:    0.0
    grid_mapping:  spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>y</span>: 2000</li><li><span class='xr-has-index'>x</span>: 4000</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-5d9f9688-7d4e-4bb4-91f3-96ec5e52d784' class='xr-array-in' type='checkbox' checked><label for='section-5d9f9688-7d4e-4bb4-91f3-96ec5e52d784' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[8000000 values with dtype=float64]</pre></div></div></li><li class='xr-section-item'><input id='section-91cfce04-60a6-4632-bb17-46a99149f19a' class='xr-section-summary-in' type='checkbox'  checked><label for='section-91cfce04-60a6-4632-bb17-46a99149f19a' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-e699a093-2af6-427d-b83d-61e1d2691258' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e699a093-2af6-427d-b83d-61e1d2691258' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f03a2b58-f5bf-4728-8f1d-1baa88943cdb' class='xr-var-data-in' type='checkbox'><label for='data-f03a2b58-f5bf-4728-8f1d-1baa88943cdb' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.436e+06 4.436e+06 ... 4.434e+06</div><input id='attrs-0547e662-eeaa-4d47-9edd-01c7602e60eb' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-0547e662-eeaa-4d47-9edd-01c7602e60eb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cde56aae-62b7-44f0-b476-98588f2122b4' class='xr-var-data-in' type='checkbox'><label for='data-cde56aae-62b7-44f0-b476-98588f2122b4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4435999.5, 4435998.5, 4435997.5, ..., 4434002.5, 4434001.5, 4434000.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.72e+05 4.72e+05 ... 4.76e+05</div><input id='attrs-14f842bb-4ebf-440d-90d0-91df9d9400f9' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-14f842bb-4ebf-440d-90d0-91df9d9400f9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7f24a376-2afa-47a3-b5a5-7c511d35bfae' class='xr-var-data-in' type='checkbox'><label for='data-7f24a376-2afa-47a3-b5a5-7c511d35bfae' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([472000.5, 472001.5, 472002.5, ..., 475997.5, 475998.5, 475999.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-8997c8ff-6eab-4512-bac2-dd65d1f8b311' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8997c8ff-6eab-4512-bac2-dd65d1f8b311' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8f20fe3d-3f2d-4f00-a7a1-fccdd482c9f8' class='xr-var-data-in' type='checkbox'><label for='data-8f20fe3d-3f2d-4f00-a7a1-fccdd482c9f8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;WGS 84 / UTM zone 13N&quot;,GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;WGS_1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;,0,AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;32613&quot;]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;WGS 84 / UTM zone 13N&quot;,GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;WGS_1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;,0,AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;32613&quot;]]</dd><dt><span>GeoTransform :</span></dt><dd>472000.0 1.0 0.0 4436000.0 0.0 -1.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-adab5b46-b9f6-4e2a-a427-cfe1ae501fa5' class='xr-section-summary-in' type='checkbox'  checked><label for='section-adab5b46-b9f6-4e2a-a427-cfe1ae501fa5' class='xr-section-summary' >Attributes: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





## Explore Raster Data Values & Structure 

Next, have a look at the data. Notice that the data structure of `type()` of 
Python object returned by rioxarray is an xarray DataArray. This contains metadata about the array, as well as the data for the array stored in a numpy array. Numpy arrays are an
efficient way to store and work with raster data in python. You will learn 
more about working with numpy arrays 
<a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">in the numpy array chapter of the introduction to earth data 
science textbook</a>


<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:**  To view the numpy array stored inside of an xarray DataArray, you can access it by putting `.values` at the end of your Rioxarray variable's name. For example, `rioxarray_name.values` will return a numpy array with all the values stored in it. We use `.values` to plot with the earthpy `plot_rgb` function, since that needs a numpy array as an input!
</div>

{:.input}
```python
type(lidar_dtm)
```

{:.output}
{:.execute_result}



    xarray.core.dataarray.DataArray





{:.input}
```python
# View the min and max values of the array
print(lidar_dtm.min(), lidar_dtm.max())
```

{:.output}
    <xarray.DataArray ()>
    array(1676.20996094)
    Coordinates:
        spatial_ref  int64 0 <xarray.DataArray ()>
    array(2087.42993164)
    Coordinates:
        spatial_ref  int64 0



{:.input}
```python
# View the dimensions of the array (rows, columns)
lidar_dtm.shape
```

{:.output}
{:.execute_result}



    (1, 2000, 4000)





Finally you can plot your data. For plotting you will use `earthpy.plot_bands`.

{:.input}
```python
ep.plot_bands(lidar_dtm,
              scale=False,
              cmap='Greys',
              title="Lidar Digital Terrain Model")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_12_0.png" alt = "Plot of Lidar digital terrain model.">
<figcaption>Plot of Lidar digital terrain model.</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1:  Explore Elevation Data Values

Look closely at the plot above. What do you think the colors and numbers 
represent in the plot? 

What units do the numbers represents?
</div>

<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2:  Open & Plot a Raster Dataset

The above lidar DTM that you opened represents a dataset produced before a flood occurred in 2013 in Colorado. A path to a second lidar dataset which is for the same area but from data collected after the flood is below. 

Use the code below to create a path to the post-flood data. 
Then do the following using the code above as a guide to open and plot 
your data:

1. Use `rioxarray` to open the data as a numpy array following the code 
that you used above
2. View the min and max data values for the output numpy array
3. Create a plot of the data

```python
# Add the code here to open, show, and close the raster dataset.

lidar_dem_path_post_flood = os.path.join("data", "colorado-flood", "spatial",
                                         "boulder-leehill-rd", "post-flood", "lidar",
                                         "post_DTM.tif")
```

Hint: Don't forget to use `rxr.open_rasterio()` and assign the output to a variable! Also, don't forget to call `.values` on your rioxarray when plotting it with `plot_rgb`, that function needs a numpy array input to work!

An example of what your plot should look like is below. 
</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_15_0.png" alt = "Challenge 2 Plot: Lidar Digital Terrain Model">
<figcaption>Challenge 2 Plot: Lidar Digital Terrain Model</figcaption>

</figure>




## Imagery - Another Type of Raster Data 

Another type of raster data that you may see is imagery. 
If you have used Google Maps or another mapping tool that has an imagery layer,
you are looking at raster data. You can open and plot imagery data using Python 
as well.

Below you download and open up some NAIP data that were collected before a fire that occured
close to Nederland, Colorado.

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:**  NAIP data is imagery collected by the United 
States Department of Agriculture every 2 years across the United 
States. Learn more about 
NAIP data in <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/multispectral-remote-sensing/intro-naip/">this chapter of the earth data science intermediate 
textbook. </a>
</div>

{:.input}
```python
# Download NAIP data
et.data.get_data(url="https://ndownloader.figshare.com/files/23070791")
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/23070791
    Extracted output to /root/earth-analytics/data/earthpy-downloads/naip-before-after



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/naip-before-after'





{:.input}
```python
# Create a path for the data file - notice it is a .tif file
naip_pre_fire_path = os.path.join("earthpy-downloads",
                                  "naip-before-after",
                                  "pre-fire",
                                  "crop",
                                  "m_3910505_nw_13_1_20150919_crop.tif")

naip_pre_fire_path
```

{:.output}
{:.execute_result}



    'earthpy-downloads/naip-before-after/pre-fire/crop/m_3910505_nw_13_1_20150919_crop.tif'





{:.input}
```python
# Open the data using rioxarray
naip_pre_fire = rxr.open_rasterio(naip_pre_fire_path)

naip_pre_fire
```

{:.output}
{:.execute_result}



<div><svg style="position: absolute; width: 0; height: 0; overflow: hidden">
<defs>
<symbol id="icon-database" viewBox="0 0 32 32">
<path d="M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z"></path>
<path d="M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
<path d="M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
</symbol>
<symbol id="icon-file-text2" viewBox="0 0 32 32">
<path d="M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z"></path>
<path d="M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
</symbol>
</defs>
</svg>
<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.
 *
 */

:root {
  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));
  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));
  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));
  --xr-border-color: var(--jp-border-color2, #e0e0e0);
  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);
  --xr-background-color: var(--jp-layout-color0, white);
  --xr-background-color-row-even: var(--jp-layout-color1, white);
  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);
}

html[theme=dark],
body.vscode-dark {
  --xr-font-color0: rgba(255, 255, 255, 1);
  --xr-font-color2: rgba(255, 255, 255, 0.54);
  --xr-font-color3: rgba(255, 255, 255, 0.38);
  --xr-border-color: #1F1F1F;
  --xr-disabled-color: #515151;
  --xr-background-color: #111111;
  --xr-background-color-row-even: #111111;
  --xr-background-color-row-odd: #313131;
}

.xr-wrap {
  display: block;
  min-width: 300px;
  max-width: 700px;
}

.xr-text-repr-fallback {
  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */
  display: none;
}

.xr-header {
  padding-top: 6px;
  padding-bottom: 6px;
  margin-bottom: 4px;
  border-bottom: solid 1px var(--xr-border-color);
}

.xr-header > div,
.xr-header > ul {
  display: inline;
  margin-top: 0;
  margin-bottom: 0;
}

.xr-obj-type,
.xr-array-name {
  margin-left: 2px;
  margin-right: 10px;
}

.xr-obj-type {
  color: var(--xr-font-color2);
}

.xr-sections {
  padding-left: 0 !important;
  display: grid;
  grid-template-columns: 150px auto auto 1fr 20px 20px;
}

.xr-section-item {
  display: contents;
}

.xr-section-item input {
  display: none;
}

.xr-section-item input + label {
  color: var(--xr-disabled-color);
}

.xr-section-item input:enabled + label {
  cursor: pointer;
  color: var(--xr-font-color2);
}

.xr-section-item input:enabled + label:hover {
  color: var(--xr-font-color0);
}

.xr-section-summary {
  grid-column: 1;
  color: var(--xr-font-color2);
  font-weight: 500;
}

.xr-section-summary > span {
  display: inline-block;
  padding-left: 0.5em;
}

.xr-section-summary-in:disabled + label {
  color: var(--xr-font-color2);
}

.xr-section-summary-in + label:before {
  display: inline-block;
  content: '►';
  font-size: 11px;
  width: 15px;
  text-align: center;
}

.xr-section-summary-in:disabled + label:before {
  color: var(--xr-disabled-color);
}

.xr-section-summary-in:checked + label:before {
  content: '▼';
}

.xr-section-summary-in:checked + label > span {
  display: none;
}

.xr-section-summary,
.xr-section-inline-details {
  padding-top: 4px;
  padding-bottom: 4px;
}

.xr-section-inline-details {
  grid-column: 2 / -1;
}

.xr-section-details {
  display: none;
  grid-column: 1 / -1;
  margin-bottom: 5px;
}

.xr-section-summary-in:checked ~ .xr-section-details {
  display: contents;
}

.xr-array-wrap {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 20px auto;
}

.xr-array-wrap > label {
  grid-column: 1;
  vertical-align: top;
}

.xr-preview {
  color: var(--xr-font-color3);
}

.xr-array-preview,
.xr-array-data {
  padding: 0 5px !important;
  grid-column: 2;
}

.xr-array-data,
.xr-array-in:checked ~ .xr-array-preview {
  display: none;
}

.xr-array-in:checked ~ .xr-array-data,
.xr-array-preview {
  display: inline-block;
}

.xr-dim-list {
  display: inline-block !important;
  list-style: none;
  padding: 0 !important;
  margin: 0;
}

.xr-dim-list li {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.xr-dim-list:before {
  content: '(';
}

.xr-dim-list:after {
  content: ')';
}

.xr-dim-list li:not(:last-child):after {
  content: ',';
  padding-right: 5px;
}

.xr-has-index {
  font-weight: bold;
}

.xr-var-list,
.xr-var-item {
  display: contents;
}

.xr-var-item > div,
.xr-var-item label,
.xr-var-item > .xr-var-name span {
  background-color: var(--xr-background-color-row-even);
  margin-bottom: 0;
}

.xr-var-item > .xr-var-name:hover span {
  padding-right: 5px;
}

.xr-var-list > li:nth-child(odd) > div,
.xr-var-list > li:nth-child(odd) > label,
.xr-var-list > li:nth-child(odd) > .xr-var-name span {
  background-color: var(--xr-background-color-row-odd);
}

.xr-var-name {
  grid-column: 1;
}

.xr-var-dims {
  grid-column: 2;
}

.xr-var-dtype {
  grid-column: 3;
  text-align: right;
  color: var(--xr-font-color2);
}

.xr-var-preview {
  grid-column: 4;
}

.xr-var-name,
.xr-var-dims,
.xr-var-dtype,
.xr-preview,
.xr-attrs dt {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 10px;
}

.xr-var-name:hover,
.xr-var-dims:hover,
.xr-var-dtype:hover,
.xr-attrs dt:hover {
  overflow: visible;
  width: auto;
  z-index: 1;
}

.xr-var-attrs,
.xr-var-data {
  display: none;
  background-color: var(--xr-background-color) !important;
  padding-bottom: 5px !important;
}

.xr-var-attrs-in:checked ~ .xr-var-attrs,
.xr-var-data-in:checked ~ .xr-var-data {
  display: block;
}

.xr-var-data > table {
  float: right;
}

.xr-var-name span,
.xr-var-data,
.xr-attrs {
  padding-left: 25px !important;
}

.xr-attrs,
.xr-var-attrs,
.xr-var-data {
  grid-column: 1 / -1;
}

dl.xr-attrs {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 125px auto;
}

.xr-attrs dt,
.xr-attrs dd {
  padding: 0;
  margin: 0;
  float: left;
  padding-right: 10px;
  width: auto;
}

.xr-attrs dt {
  font-weight: normal;
  grid-column: 1;
}

.xr-attrs dt:hover span {
  display: inline-block;
  background: var(--xr-background-color);
  padding-right: 10px;
}

.xr-attrs dd {
  grid-column: 2;
  white-space: pre-wrap;
  word-break: break-all;
}

.xr-icon-database,
.xr-icon-file-text2 {
  display: inline-block;
  vertical-align: middle;
  width: 1em;
  height: 1.5em !important;
  stroke-width: 0;
  stroke: currentColor;
  fill: currentColor;
}
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (band: 4, y: 2312, x: 4377)&gt;
[40478496 values with dtype=int16]
Coordinates:
  * band         (band) int64 1 2 3 4
  * y            (y) float64 4.427e+06 4.427e+06 ... 4.425e+06 4.425e+06
  * x            (x) float64 4.572e+05 4.572e+05 ... 4.615e+05 4.615e+05
    spatial_ref  int64 0
Attributes:
    STATISTICS_MAXIMUM:  239
    STATISTICS_MEAN:     nan
    STATISTICS_MINIMUM:  32
    STATISTICS_STDDEV:   nan
    _FillValue:          -32768.0
    scale_factor:        1.0
    add_offset:          0.0
    grid_mapping:        spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 4</li><li><span class='xr-has-index'>y</span>: 2312</li><li><span class='xr-has-index'>x</span>: 4377</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-cc876053-4206-4ccd-a9aa-042610d90f5b' class='xr-array-in' type='checkbox' checked><label for='section-cc876053-4206-4ccd-a9aa-042610d90f5b' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[40478496 values with dtype=int16]</pre></div></div></li><li class='xr-section-item'><input id='section-2c337d5a-8dd0-461e-af3d-342c1bf96e19' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2c337d5a-8dd0-461e-af3d-342c1bf96e19' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1 2 3 4</div><input id='attrs-ab4f6705-5ac5-4a94-811c-25ff226c58b7' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-ab4f6705-5ac5-4a94-811c-25ff226c58b7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2f5dc52c-9e00-4e2c-8fd9-81494c2799ba' class='xr-var-data-in' type='checkbox'><label for='data-2f5dc52c-9e00-4e2c-8fd9-81494c2799ba' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1, 2, 3, 4])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.427e+06 4.427e+06 ... 4.425e+06</div><input id='attrs-3c2b827a-28e4-4124-b995-f479b5d6049b' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-3c2b827a-28e4-4124-b995-f479b5d6049b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6ba9e7c7-683b-4f73-86c5-4ca34539b6b4' class='xr-var-data-in' type='checkbox'><label for='data-6ba9e7c7-683b-4f73-86c5-4ca34539b6b4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4426951.5, 4426950.5, 4426949.5, ..., 4424642.5, 4424641.5, 4424640.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.572e+05 4.572e+05 ... 4.615e+05</div><input id='attrs-94775e64-7208-4125-9f33-e658b64432a6' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-94775e64-7208-4125-9f33-e658b64432a6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c5b235b7-bff8-48b4-9bf1-3201addf1033' class='xr-var-data-in' type='checkbox'><label for='data-c5b235b7-bff8-48b4-9bf1-3201addf1033' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([457163.5, 457164.5, 457165.5, ..., 461537.5, 461538.5, 461539.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-d160fdc8-88a8-4a59-9837-848739bea873' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d160fdc8-88a8-4a59-9837-848739bea873' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5c2f6ba3-82c0-4678-b8b8-ae8e87762173' class='xr-var-data-in' type='checkbox'><label for='data-5c2f6ba3-82c0-4678-b8b8-ae8e87762173' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;GRS 1980(IUGG, 1980)&quot;,DATUM[&quot;unknown&quot;,SPHEROID[&quot;GRS80&quot;,6378137,298.257222101],TOWGS84[0,0,0,0,0,0,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314140356</dd><dt><span>inverse_flattening :</span></dt><dd>298.257222101</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>GRS80</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>GRS 1980(IUGG, 1980)</dd><dt><span>horizontal_datum_name :</span></dt><dd>unknown</dd><dt><span>projected_crs_name :</span></dt><dd>UTM Zone 13, Northern Hemisphere</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>towgs84 :</span></dt><dd>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;GRS 1980(IUGG, 1980)&quot;,DATUM[&quot;unknown&quot;,SPHEROID[&quot;GRS80&quot;,6378137,298.257222101],TOWGS84[0,0,0,0,0,0,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>457163.0 1.0 0.0 4426952.0 0.0 -1.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-a44d1939-9cac-40c9-84d7-156fe98877ae' class='xr-section-summary-in' type='checkbox'  checked><label for='section-a44d1939-9cac-40c9-84d7-156fe98877ae' class='xr-section-summary' >Attributes: <span>(8)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>STATISTICS_MAXIMUM :</span></dt><dd>239</dd><dt><span>STATISTICS_MEAN :</span></dt><dd>nan</dd><dt><span>STATISTICS_MINIMUM :</span></dt><dd>32</dd><dt><span>STATISTICS_STDDEV :</span></dt><dd>nan</dd><dt><span>_FillValue :</span></dt><dd>-32768.0</dd><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





Plotting imagery is a bit different because imagery is composed of multiple 
bands. While we won't get into the specifics of bands and images in this lesson, 
you can see below that an image is composed of multiple layers of information.

You can plot each band individually as you see below using `plot_bands()`. 
Or you can plot a color image,
similar to the image that your camera stores when you take a picture.

{:.input}
```python
# Plot each layer or band of the image separately
ep.plot_bands(naip_pre_fire, figsize=(10, 5))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_21_0.png" alt = "Plot of all NAIP Data Bands using earthpy plot_bands()">
<figcaption>Plot of all NAIP Data Bands using earthpy plot_bands()</figcaption>

</figure>




{:.input}
```python
# Plot color image
#
ep.plot_rgb(naip_pre_fire.values,
            title="naip data pre-fire")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_22_0.png" alt = "RGB color image plot of NAIP data using earthpy plot_rgb()">
<figcaption>RGB color image plot of NAIP data using earthpy plot_rgb()</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge:  Plot NAIP Imagery Post Fire 

In the code below, you see a path to a NAIP dataset that was collected 
after the fire in Colorado. Use that path to:

1. Open the post fire data
2. Plot a color version of data using `plot_rgb()`

</div>


{:.input}
```python
# Add the code here to open the raster and read the numpy array inside it
# Create a path for the data file - notice it is a .tif file
naip_post_fire_path = os.path.join("earthpy-downloads",
                                   "naip-before-after",
                                   "post-fire",
                                   "crop",
                                   "m_3910505_nw_13_1_20170902_crop.tif")

naip_post_fire_path
```

{:.output}
{:.execute_result}



    'earthpy-downloads/naip-before-after/post-fire/crop/m_3910505_nw_13_1_20170902_crop.tif'






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_25_0.png" alt = "Plot of NAIP bands on top and below a NAIP color RGB image.">
<figcaption>Plot of NAIP bands on top and below a NAIP color RGB image.</figcaption>

</figure>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_25_1.png" alt = "Plot of NAIP bands on top and below a NAIP color RGB image.">
<figcaption>Plot of NAIP bands on top and below a NAIP color RGB image.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_26_0.png" alt = "Plot of RGB NAIP data before and after the fire.">
<figcaption>Plot of RGB NAIP data before and after the fire.</figcaption>

</figure>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/05-spatial-data-formats-eds/2020-06-19-spatial-data-formats-02-raster-data/2020-06-19-spatial-data-formats-02-raster-data_26_1.png" alt = "Plot of RGB NAIP data before and after the fire.">
<figcaption>Plot of RGB NAIP data before and after the fire.</figcaption>

</figure>



