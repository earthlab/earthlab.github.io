---
layout: single
title: "Open, Plot and Explore Raster Data with Python and Xarray"
excerpt: "Raster data are gridded data composed of pixels that store values, such as an image or elevation data file. Learn how to open, plot, and explore raster files in Python."
authors: ['Leah Wasser']
dateCreated: 2020-11-05
modified: 2020-11-09
category: [courses]
class-lesson: ['intro-raster-python-tb']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/open-lidar-raster-python-xarray/
nav-title: 'Open Raster Data Python rioXarray'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: false
order: 2
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/open-lidar-raster-python/"
  - "/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/open-lidar-raster-python/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Open, plot, and explore raster data using **Python**.
* Handle no data values in raster data. 
* Create plotting extents so you can plot raster and vector data together using matplotlib.
* Explore raster data using histograms and descriptive statistics.

</div>

## Open Raster Data in Open Source Python

Remember from the previous lesson that raster or “gridded” data are stored as a 
grid of values which are rendered on a map as pixels. Each pixel value 
represents an area on the Earth’s surface. A raster file is composed of 
regular grid of cells, all of which are the same size. Raster data can 
be used to store many different types of scientific data including 

* elevation data
* canopy height models
* surface temperature 
* climate model data outputs
* landuse / landcover data
* and more.

<figure>
   <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-concept.png" target="_blank">
   <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-concept.png" alt="Raster data concept diagram."></a>
   <figcaption>A raster is composed of a regular grid of cells. Each cell is the same
   size in the x and y direction. Source: Colin Williams, NEON.
   </figcaption>
</figure>

In this lesson you will learn more about working with lidar derived raster data
that represents both terrain / elevation data (elevation of the earth's surface),
and surface elevation (elevation at the tops of trees, buildings etc above the earth's
surface). If you want to read more about how lidar data are used to derive 
raster based surface models, you can check out <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/what-is-lidar-data/" target="_blank"> this chapter on lidar remote sensing data and the various raster data products derived from lidar data.</a> 

<figure>
   <a href="https://www.earthdatascience.org/images/earth-analytics/lidar-raster-data/lidarTree-height.png">
   <img src="https://www.earthdatascience.org/images/earth-analytics/lidar-raster-data/lidarTree-height.png" alt="Lidar derived DSM, DTM and CHM."></a>
   <figcaption>Digital Surface Model (DSM), Digital Elevation Models (DEM) and
   the Canopy Height Model (CHM) are the most common raster format lidar
   derived data products. One way to derive a CHM is to take
   the difference between the digital surface model (DSM, tops of trees, buildings
   and other objects) and the Digital Terrain Model (DTM, ground level). The CHM
   represents the actual height of trees, buildings, etc. with the influence of
   ground elevation removed. Graphic: Colin Williams, NEON
   </figcaption>
</figure>

<i class="fa fa-star"></i> **Data Tip:** 
The data used in this lesson are NEON (National Ecological Observatory Network) data. 
{: .notice--success }

To begin load the 
packages that you need to process your raster data.

{:.input}
```python
# Import necessary packages
import os

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
# Use geopandas for vector data and xarray for raster data
import geopandas as gpd
import rioxarray as rxr

import earthpy as et

# Prettier plotting with seaborn
sns.set(font_scale=1.5, style="white")
```

{:.input}
```python
# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



Below, you define the path to a lidar derived digital elevation model (DEM)
that was created using NEON (the National Ecological Observatory Network) data. 

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** DEM's are also sometimes referred to 
as DTM (Digital Terrain Model or 
DTM). You can learn more about the 3 lidar derived elevation data types: <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/what-is-lidar-data/lidar-chm-dem-dsm/" >DEMs,
Canopy Height Models (CHM) and Digital Surface Models (DSMs) in the lidar chapter
of this textbook.</a>
</div>

You then open the data using rioxarray - `rxr.open_rasterio("path-to-raster-here")`.

{:.input}
```python
# Define relative path to file
dem_pre_path = os.path.join("colorado-flood",
                            "spatial",
                            "boulder-leehill-rd",
                            "pre-flood",
                            "lidar",
                            "pre_DTM.tif")

dtm_pre_arr = rxr.open_rasterio(dem_pre_path)
dtm_pre_arr
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

.xr-attrs dt, dd {
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
[8000000 values with dtype=float32]
Coordinates:
  * band         (band) int64 1
  * y            (y) float64 4.436e+06 4.436e+06 ... 4.434e+06 4.434e+06
  * x            (x) float64 4.72e+05 4.72e+05 4.72e+05 ... 4.76e+05 4.76e+05
    spatial_ref  int64 0
Attributes:
    _FillValue:    -3.4028234663852886e+38
    scale_factor:  1.0
    add_offset:    0.0
    grid_mapping:  spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>y</span>: 2000</li><li><span class='xr-has-index'>x</span>: 4000</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-2c8d5f70-54fb-4451-8586-9db6be30c6a1' class='xr-array-in' type='checkbox' checked><label for='section-2c8d5f70-54fb-4451-8586-9db6be30c6a1' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[8000000 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-61e28475-4883-4fd1-a7fd-63d60c604a83' class='xr-section-summary-in' type='checkbox'  checked><label for='section-61e28475-4883-4fd1-a7fd-63d60c604a83' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-216a5e09-9fcc-41d3-8318-1792346115ff' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-216a5e09-9fcc-41d3-8318-1792346115ff' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5e03df5a-19c1-4271-840a-150d332f6b1d' class='xr-var-data-in' type='checkbox'><label for='data-5e03df5a-19c1-4271-840a-150d332f6b1d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.436e+06 4.436e+06 ... 4.434e+06</div><input id='attrs-7ea3cb68-1816-443c-93c5-51672e073f18' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-7ea3cb68-1816-443c-93c5-51672e073f18' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-32e357f7-3629-4a9a-b7d9-ba447323ede5' class='xr-var-data-in' type='checkbox'><label for='data-32e357f7-3629-4a9a-b7d9-ba447323ede5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4435999.5, 4435998.5, 4435997.5, ..., 4434002.5, 4434001.5, 4434000.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.72e+05 4.72e+05 ... 4.76e+05</div><input id='attrs-46d8db7e-cb5e-44df-bc69-0874c694bfa9' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-46d8db7e-cb5e-44df-bc69-0874c694bfa9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a45f426b-8ca3-4df5-9304-783798d014bc' class='xr-var-data-in' type='checkbox'><label for='data-a45f426b-8ca3-4df5-9304-783798d014bc' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([472000.5, 472001.5, 472002.5, ..., 475997.5, 475998.5, 475999.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-84efe9f2-9cc4-4635-b168-2b11e342f22d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-84efe9f2-9cc4-4635-b168-2b11e342f22d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-668b9927-e9fd-4891-a377-7aee8675c18f' class='xr-var-data-in' type='checkbox'><label for='data-668b9927-e9fd-4891-a377-7aee8675c18f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>GeoTransform :</span></dt><dd>472000.0 1.0 0.0 4436000.0 0.0 -1.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-1ce395d1-7329-4dd5-b2a3-2e0130c85ac3' class='xr-section-summary-in' type='checkbox'  checked><label for='section-1ce395d1-7329-4dd5-b2a3-2e0130c85ac3' class='xr-section-summary' >Attributes: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-3.4028234663852886e+38</dd><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





When you open raster data using **xarray** or **rioxarray** you are creating an
`xarray.DataArray`. The. `DataArray` object stores the:

* raster data in a numpy array format
* spatial metadata including the CRS, spatial extent of the object
* and any metadata

`Xarray` and `numpy` provide an efficient way to work with and process 
raster  data. `xarray` also supports dask and parallel processing which 
allows you to more efficiently process larger datasets using the processing power
that you have on your computer

When you add `rioxarray` to your package imports, you further get access 
to spatial data processing using `xarray` objects. Below, you can view
the spatial extent (`bounds()`) and `CRS` of the data that you just opened
above.

{:.input}
```python
# View the Coordinate Reference System (CRS) & spatial extent
print("The CRS for this data is:", dtm_pre_arr.rio.crs)
print("The spatial extent is:", dtm_pre_arr.rio.bounds())
```

{:.output}
    The CRS for this data is: EPSG:32613
    The spatial extent is: (472000.0, 4434000.0, 476000.0, 4436000.0)



The `nodata` value (or fill value) is also stored in the 
`xarray` object.

{:.input}
```python
# View no data value
print("The no data value is:", dtm_pre_arr.rio.nodata)
```

{:.output}
    The no data value is: -3.4028235e+38



Once you have imported your data, you can plot is
using `xarray.plot()`. 

{:.input}
```python
dtm_pre_arr.plot()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-raster-data-xarray/2018-02-05-raster02-open-raster-data-xarray_11_0.png" alt = "When a plot looks off, it is always a good idea to explore whether nodatavalues exist in your data. Often no data values are very large of negative numbers that are not likely to be valid values in your data. These values will skew any plots (or calculations) in your analysis.">
<figcaption>When a plot looks off, it is always a good idea to explore whether nodatavalues exist in your data. Often no data values are very large of negative numbers that are not likely to be valid values in your data. These values will skew any plots (or calculations) in your analysis.</figcaption>

</figure>




The data above should represent terrain model data. However, the range of 
values is not what is expected. These data are for Boulder, Colorado where 
the elevation may range from 1000-3000m. There may be some outlier values 
in the data that may need to be addressed. Below you look at the distribution
of pixel values in the data by plotting a histogram.

Notice that there seem to be a lot of pixel values in the negative range
in that plot.

{:.input}
```python
# A histogram can also be helpful to look at the range of values in your data
# What do you notice about the histogram below?
dtm_pre_arr.plot.hist(color="purple")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-raster-data-xarray/2018-02-05-raster02-open-raster-data-xarray_13_0.png" alt = "Histogram for your lidar DTM. Notice the number of values that are below 0. This suggests that there may be no data values in the data.">
<figcaption>Histogram for your lidar DTM. Notice the number of values that are below 0. This suggests that there may be no data values in the data.</figcaption>

</figure>




Looking at the min and max values of the data, you can see a 
very small negative number for the minimum. This number matches 
the nodata value that you looked at above. 

{:.input}
```python
print("the minimum raster value is: ", np.nanmin(dtm_pre_arr.values))
print("the maximum raster value is: ", np.nanmax(dtm_pre_arr.values))
```

{:.output}
    the minimum raster value is:  -3.4028235e+38
    the maximum raster value is:  2087.43






## Raster Data Exploration - Min and Max Values

Looking at the minimum value of the data, there is one of two things going on
that need to be fixed:

1. there may be no data values in the data with a negative value that are skewing your plot colors
2. there also could be outlier data in your raster

You can explore the first option - that there are no data values by reading 
in the data and masking no data values using the `masked=True` parameter like this:

`rxr.open_rasterio(dem_pre_path, masked=True)`

Above you may have also noticed that the array has an additional dimension for the 
"band". While the raster only has one layer - there is a 1 in the output of 
`shape` that could get in the way of processing.

You can remove that additional dimension using `.squeeze()`

{:.input}
```python
# Notice that the shape of this object has a 1 at the beginning
# This can cause issues with plotting
dtm_pre_arr.shape
```

{:.output}
{:.execute_result}



    (1, 2000, 4000)





{:.input}
```python
# Open the data and mask no data values
# Squeeze reduces the third dimension given there is only one "band" or layer to this data
dtm_pre_arr = rxr.open_rasterio(dem_pre_path, masked=True).squeeze()
# Notice there are now only 2 dimensions to your array
dtm_pre_arr.shape
```

{:.output}
{:.execute_result}



    (2000, 4000)





Plot the data again to see what has changed. Now you have a 
reasonable range of data values and the data plot as you 
might expect it to.

{:.input}
```python
# Plot the data and notice that the scale bar looks better
# No data values are now masked
f, ax = plt.subplots(figsize=(10, 5))
dtm_pre_arr.plot(cmap="Greys_r",
                 ax=ax)
ax.set_title("Lidar Digital Elevation Model (DEM) \n Boulder Flood 2013")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-raster-data-xarray/2018-02-05-raster02-open-raster-data-xarray_22_0.png" alt = "DTM raster plot for Leehill Road in Boulder, Colorado.">
<figcaption>DTM raster plot for Leehill Road in Boulder, Colorado.</figcaption>

</figure>




The histogram has also changed. Now, it shows a reasonable
distribution of pixel values.


{:.input}
```python
f, ax = plt.subplots(figsize=(10, 6))
dtm_pre_arr.plot.hist(color="purple",
                      bins=20)
ax.set_title("Histogram of the Data with No Data Values Removed")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-raster-data-xarray/2018-02-05-raster02-open-raster-data-xarray_24_0.png" alt = "Histogram of dtm values.">
<figcaption>Histogram of dtm values.</figcaption>

</figure>




Notice that now the minimum value looks more like
an elevation value (which should most often not be negative). 

{:.input}
```python
print("The minimum raster value is: ", np.nanmin(dtm_pre_arr.data))
print("The maximum raster value is: ", np.nanmax(dtm_pre_arr.data))
```

{:.output}
    The minimum raster value is:  1676.2099609375
    The maximum raster value is:  2087.429931640625



## Plot Raster and Vector Data Together

If you want, you can also add shapefile overlays to your raster data plot. Below 
you open a single shapefile using Geopandas that contains a boundary layer that you can 
overlay on top of your raster dataset. You will learn more about 
<a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-vector-data-python/vector-data-processing/">working with shapefiles in Geopandas in this chapter of the earthdatascience.org intermediate textbook.</a>


{:.input}
```python
# Open site boundary vector layer
site_bound_path = os.path.join("colorado-flood",
                               "spatial",
                               "boulder-leehill-rd",
                               "clip-extent.shp")
site_bound_shp = gpd.read_file(site_bound_path)

# Plot the vector data
f, ax = plt.subplots(figsize=(8,4))
site_bound_shp.plot(color='teal',
                    edgecolor='black',
                    ax=ax)
ax.set(title="Site Boundary Layer - Shapefile")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-raster-data-xarray/2018-02-05-raster02-open-raster-data-xarray_28_0.png" alt = "Plot of the site boundary using Geopandas.">
<figcaption>Plot of the site boundary using Geopandas.</figcaption>

</figure>




Once you have your shapefile open, can plot the two datasets together
and begin to create a map. 

{:.input}
```python
f, ax = plt.subplots(figsize=(11, 4))

dtm_pre_arr.plot.imshow(cmap="Greys",
                        ax=ax)
site_bound_shp.plot(color='None',
                    edgecolor='teal',
                    linewidth=2,
                    ax=ax,
                    zorder=4)

ax.set(title="Raster Layer with Vector Overlay")
ax.axis('off')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-fundamentals-python/2018-02-05-raster02-open-raster-data-xarray/2018-02-05-raster02-open-raster-data-xarray_30_0.png" alt = "DTM raster layer with a vector study area extent overlayed on top.">
<figcaption>DTM raster layer with a vector study area extent overlayed on top.</figcaption>

</figure>




<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** Customizing Raster Plot Color Ramps
To change the color of a raster plot you set the colormap. Matplotlib has a list of  <a href="https://matplotlib.org/users/colormaps.html" target="_blank">pre-determined color ramps that you can chose from.</a> You can reverse a color ramp by adding `_r` at the end of the color ramp's name, for example `cmap = 'viridis'` vs `cmap = 'viridis_r'`. 

</div>

You now have the basic skills needed to open and plot raster data using
`rioxarray` and `xarray`. In the following lessons, you will learn more 
about exploring and processing raster data. 
