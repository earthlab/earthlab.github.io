---
layout: single
title: "Spatial Raster Metadata: CRS, Resolution, and Extent in Python"
excerpt: "Raster metadata includes the coordinate reference system (CRS), resolution, and spatial extent. Learn about these metadata and how to access them in Python"
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-06
modified: 2020-11-05
category: [courses]
class-lesson: ['intro-raster-python-tb']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/raster-metadata-in-python/
nav-title: 'Raster Metadata'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: false
order: 4
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/raster-metadata-in-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Be able to define 3 spatial attributes of a raster dataset: extent, coordinate reference system and resolution.
* Access spatial metadata of a raster dataset in **Python**.

</div>

On this page, you will learn about three important spatial attributes associated with raster data that in this lesson: coordinate reference systems (CRS), resolution, and spatial extent. 

## 1. Coordinate Reference System

The Coordinate Reference System or `CRS` of a spatial object tells `Python` where
the raster is located in geographic space. It also tells `Python` what mathematical method should
be used to “flatten” or project the raster in geographic space.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg" alt="Maps of the United States in different projections. Notice the
    differences in shape associated with each different projection. These
    differences are a direct result of the calculations used to 'flatten' the
    data onto a 2-dimensional map. Source: M. Corey, opennews.org">
    </a>
    <figcaption> Maps of the United States in different projections. Notice the
    differences in shape associated with each different projection. These
    differences are a direct result of the calculations used to "flatten" the
    data onto a 2-dimensional map. Source: M. Corey, opennews.org</figcaption>
</figure>

### What Makes Spatial Data Line Up On A Map?

You will discuss Coordinate Reference systems in more detail in next weeks class.
For this week, just remember that data from the same location
but saved in **different coordinate references systems will not line up in any GIS or other
program**. 

Thus, it's important when working with spatial data in a program like
`Python` to identify the coordinate reference system applied to the data and retain
it throughout data processing and analysis.

### View Raster Coordinate Reference System (CRS) in Python

You can view the `CRS` string associated with your `Python` object using the`crs()`
method. 

{:.input}
```python
# Import necessary packages
import os

import matplotlib.pyplot as plt
#import numpy as np
#from shapely.geometry import Polygon, mapping

import rioxarray as rxr

# Package created for the earth analytics program
import earthpy as et
```

{:.input}
```python
# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME, 
                      'earth-analytics',
                     'data'))
```

{:.input}
```python
# Define relative path to file
lidar_dem_path = os.path.join("colorado-flood", 
                              "spatial", 
                              "boulder-leehill-rd", 
                              "pre-flood", 
                              "lidar",
                              "pre_DTM.tif")

# View crs of raster imported with rasterio
lidar_dem = rxr.open_rasterio(lidar_dem_path, masked=True)
lidar_dem.rio.crs
```

{:.output}
{:.execute_result}



    CRS.from_epsg(32613)





You can assign this string to a **Python** object, too. The example below 
only shows the code example to set a crs. In this case your data
already has a defined CRS so this step is not necessary.

{:.input}
```python
a_crs = lidar_dem.rio.crs
# Assign crs to myCRS object
lidar_dem.rio.set_crs(a_crs)

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
[8000000 values with dtype=float64]
Coordinates:
  * band         (band) int64 1
  * y            (y) float64 4.436e+06 4.436e+06 ... 4.434e+06 4.434e+06
  * x            (x) float64 4.72e+05 4.72e+05 4.72e+05 ... 4.76e+05 4.76e+05
    spatial_ref  int64 0
Attributes:
    scale_factor:  1.0
    add_offset:    0.0
    grid_mapping:  spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>y</span>: 2000</li><li><span class='xr-has-index'>x</span>: 4000</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-c4591c18-3f93-41be-974d-aead8312171f' class='xr-array-in' type='checkbox' checked><label for='section-c4591c18-3f93-41be-974d-aead8312171f' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[8000000 values with dtype=float64]</pre></div></div></li><li class='xr-section-item'><input id='section-4d1ae1f8-5990-4a66-949e-99a0d108c66e' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4d1ae1f8-5990-4a66-949e-99a0d108c66e' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-f59243ac-b803-4535-a903-259118bbc329' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-f59243ac-b803-4535-a903-259118bbc329' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5603adbe-9f2b-4ee1-bdb0-616f83777dd3' class='xr-var-data-in' type='checkbox'><label for='data-5603adbe-9f2b-4ee1-bdb0-616f83777dd3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.436e+06 4.436e+06 ... 4.434e+06</div><input id='attrs-5036b36b-ec80-4a25-ba8c-44f204fbbaa8' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5036b36b-ec80-4a25-ba8c-44f204fbbaa8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-345cd412-b0fb-424f-bc20-ecc224ae80d7' class='xr-var-data-in' type='checkbox'><label for='data-345cd412-b0fb-424f-bc20-ecc224ae80d7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4435999.5, 4435998.5, 4435997.5, ..., 4434002.5, 4434001.5, 4434000.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.72e+05 4.72e+05 ... 4.76e+05</div><input id='attrs-7778c73b-651c-459c-bfd7-4bb700658ce5' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-7778c73b-651c-459c-bfd7-4bb700658ce5' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2feeab15-76c6-40db-9f38-8ac5879ae176' class='xr-var-data-in' type='checkbox'><label for='data-2feeab15-76c6-40db-9f38-8ac5879ae176' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([472000.5, 472001.5, 472002.5, ..., 475997.5, 475998.5, 475999.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-537ca2c7-bb66-44ef-8f73-26c9df98ada3' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-537ca2c7-bb66-44ef-8f73-26c9df98ada3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8473e862-68bf-4b7e-bcdf-eed5ec982078' class='xr-var-data-in' type='checkbox'><label for='data-8473e862-68bf-4b7e-bcdf-eed5ec982078' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>GeoTransform :</span></dt><dd>472000.0 1.0 0.0 4436000.0 0.0 -1.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-e6794b93-eba5-452f-b540-aeebf5210c3d' class='xr-section-summary-in' type='checkbox'  checked><label for='section-e6794b93-eba5-452f-b540-aeebf5210c3d' class='xr-section-summary' >Attributes: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





The `CRS` EPSG code for your `lidar_dem` object  is 32613. 
Next, you can look that EPSG code up on the <a href="http://www.spatialreference.org/ref/epsg/32613/" target="_blank">spatial reference.org website</a> to figure out what CRS it refers to and the associated units. In this case you are using UTM zone 13 North.

Digging deeper <a href="http://www.spatialreference.org/ref/epsg/32613/proj4/" target="_blank">you can view the proj 4 string </a> which tells us that the horizontal units of this project are in meters (`m`). 

<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/UTM-zones.png">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/UTM-zones.png" alt="The UTM zones across the continental United States. Source:
   	Chrismurf, wikimedia.org."></a>
   	<figcaption> The UTM zones across the continental United States. Source:
   	Chrismurf, wikimedia.org.
		</figcaption>
</figure>

The CRS format, returned by python, is in a `EPSG` format. This means that the projection
information is represented by a single number. However on the spatialreference.org website you can also view the proj4 string which will tell you a bit more about the horizontal units that the data are in. An overview of proj4 is below. 

 `+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0`
 
## Converting EPSG to Proj4 in Python

A python package for this class called 'earthpy' contains a dictionary that will help you convert EPSG codes into a Proj4 string. This can be used with **rasterio** in order to determine the metadata for a given EPSG code. For example, if you wish to know the units of the EPSG code above, you can do the following:

{:.input}
```python
# Each key of the dictionary is an EPSG code
print(list(et.epsg.keys())[:10])
```

{:.output}
    ['29188', '26733', '24600', '32189', '4899', '29189', '26734', '7402', '26951', '29190']



{:.input}
```python
# You can convert to proj4 like so:
proj4 = et.epsg['32613']
print(proj4)
```

{:.output}
    +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs



You'll focus on the first few components of the CRS in this tutorial.

* `+proj=utm` The projection of the dataset. Your data are in Universal
Transverse Mercator (UTM).
* `+zone=18` The UTM projection divides up the world into zones, this element
tells you which zone the data is in. Harvard Forest is in Zone 18.
* `+datum=WGS84` The datum was used to define the center point of the
projection. Your raster uses the `WGS84` datum.
* `+units=m` This is the **horizontal** units that the data are in. Your units
are meters.


<div class="notice--success" markdown="1">
<i fa fa-star></i>**Important:**
You are working with lidar data which has a Z or vertical value as well.
While the horizontal units often match the vertical units of a raster they don't
always! Be sure the check the metadata of your data to figure out the vertical
units!
</div>

## Spatial Extent

Next, you'll learn about spatial extent of your raster data. The spatial extent of a raster or spatial
object is the geographic area that the raster data covers.
<figure>
    <a href="{{ site.baseurl}}/images/earth-analytics/raster-data/raster-spatial-extent-coordinates.png">
    <img src="{{ site.baseurl}}/images/earth-analytics/raster-data/raster-spatial-extent-coordinates.png" alt="The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated
    in some way) the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON).">
    </a>
    <figcaption> The spatial extent of raster data.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON).
    </figcaption>
</figure>


<figure>
    <a href="{{ site.baseurl}}/images/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.baseurl}}/images/earth-analytics/spatial-data/spatial-extent.png" alt="The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON)">
    </a>
    <figcaption> The spatial extent of vector data which you will learn next week.
    Notice that the spatial extent represents the rectangular area that the data cover.
    Thus, if the data are not rectangular (i.e. points OR an image that is rotated in some way)
    the spatial extent covers portions of the dataset where there are no data.
    Image Source: National Ecological Observatory Network (NEON)
    </figcaption>
</figure>

The spatial extent of an `Python` spatial object represents the geographic "edge" or
location that is the furthest north, south, east and west. In other words, `extent`
represents the overall geographic coverage of the spatial object.

You can access the spatial extent using the `.bounds` attribute in `rasterio`.

{:.input}
```python
lidar_dem.rio.bounds()
```

{:.output}
{:.execute_result}



    (472000.0, 4434000.0, 476000.0, 4436000.0)





## Raster Resolution

A raster has horizontal (x and y) resolution. This resolution represents the
area on the ground that each pixel covers. The units for your data are in meters as determined by the CRS above.
In this case, your data resolution is 1 x 1. This means that each pixel represents
a 1 x 1 meter area on the ground. You can view the resolution of your data using the `.res` function.

{:.input}
```python
# What is the x and y resolution for your raster data?
lidar_dem.rio.resolution()
```

{:.output}
{:.execute_result}



    (1.0, -1.0)




