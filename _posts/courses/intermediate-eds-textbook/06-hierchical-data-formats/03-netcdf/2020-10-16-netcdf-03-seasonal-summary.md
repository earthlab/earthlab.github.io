---
layout: single
title: "Calculate Seasonal Summary Values from Climate Data Variables Stored in NetCDF 4 Format: Work With MACA v2 Climate Data in Python"
excerpt: "."
authors: ['Leah Wasser']
dateCreated: 2020-03-01
modified: 2020-10-20
category: [courses]
class-lesson: ['netcdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/summarize-climate-data-seasonally/
nav-title: 'Summarize Data Seasonally'
week: 6
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['modis']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter 13 - NETCDF 4 Climate Data in Open Source Python 

In this chapter, you will learn how to work with Climate Data Sets (MACA v2 for the United states) stored in netcdf 4 format using open source **Python**.

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Summarize MACA v 2 climate data stored in netcdf 4 format by seasons across all time periods using `xarray`.
* Summarize MACA v 2 climate data stored in netcdf 4 format by seasons and across years using `xarray`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and ...

</div>

## Calculate Seasonal Averages Using MACA vs Climate Data 

In this lesson, you will learn how to calculate seasonal averages over several years
using MACA v 2 Climate Data downloaded in `netcdf4` format using 
`xarray`.

In this example you will use the forecast temperature data downloaded from the 
northwestknowledge.net website. 




{:.input}
```python
import os

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import seaborn as sns
import geopandas as gpd
import earthpy as et
import xarray as xr
import regionmask

# Plotting options
sns.set(font_scale=1.5)
sns.set_style("white")

# Optional - set your working directory if you wish to use the data
# accessed lower down in this notebook (the USA state boundary data)
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

TO begin, you can download and open up a MACA v2 netcdf file. The file below is a 
maximum temperature file downscaled using the `BNU-ESM` model for 2006-2099.

{:.input}
```python
# Get netcdf file
data_path_monthly = 'http://thredds.northwestknowledge.net:8080/thredds/dodsC/agg_macav2metdata_tasmax_BNU-ESM_r1i1p1_rcp45_2006_2099_CONUS_monthly.nc'

# Open up the data
with xr.open_dataset(data_path_monthly) as file_nc:
    monthly_forecast_temp_xr = file_nc

# xarray object
monthly_forecast_temp_xr
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:          (crs: 1, lat: 585, lon: 1386, time: 1128)
Coordinates:
  * lat              (lat) float64 25.06 25.1 25.15 25.19 ... 49.31 49.35 49.4
  * crs              (crs) int32 1
  * lon              (lon) float64 235.2 235.3 235.3 235.4 ... 292.9 292.9 292.9
  * time             (time) object 2006-01-15 00:00:00 ... 2099-12-15 00:00:00
Data variables:
    air_temperature  (time, lat, lon) float32 ...
Attributes:
    description:                     Multivariate Adaptive Constructed Analog...
    id:                              MACAv2-METDATA
    naming_authority:                edu.uidaho.reacch
    Metadata_Conventions:            Unidata Dataset Discovery v1.0
    Metadata_Link:                   
    cdm_data_type:                   FLOAT
    title:                           Monthly aggregation of downscaled daily ...
    summary:                         This archive contains monthly downscaled...
    keywords:                        monthly, precipitation, maximum temperat...
    keywords_vocabulary:             
    standard_name_vocabulary:        CF-1.0
    history:                         No revisions.
    comment:                         
    geospatial_bounds:               POLYGON((-124.7722 25.0631,-124.7722 49....
    geospatial_lat_min:              25.0631
    geospatial_lat_max:              49.3960
    geospatial_lon_min:              -124.7722
    geospatial_lon_max:              -67.0648
    geospatial_lat_units:            decimal degrees north
    geospatial_lon_units:            decimal degrees east
    geospatial_lat_resolution:       0.0417
    geospatial_lon_resolution:       0.0417
    geospatial_vertical_min:         0.0
    geospatial_vertical_max:         0.0
    geospatial_vertical_resolution:  0.0
    geospatial_vertical_positive:    up
    time_coverage_start:             2091-01-01T00:0
    time_coverage_end:               2095-12-31T00:00
    time_coverage_duration:          P5Y
    time_coverage_resolution:        P1M
    date_created:                    2014-05-15
    date_modified:                   2014-05-15
    date_issued:                     2014-05-15
    creator_name:                    John Abatzoglou
    creator_url:                     http://maca.northwestknowledge.net
    creator_email:                   jabatzoglou@uidaho.edu
    institution:                     University of Idaho
    processing_level:                GRID
    project:                         
    contributor_name:                Katherine C. Hegewisch
    contributor_role:                Postdoctoral Fellow
    publisher_name:                  REACCH
    publisher_email:                 reacch@uidaho.edu
    publisher_url:                   http://www.reacchpna.org/
    license:                         Creative Commons CC0 1.0 Universal Dedic...
    coordinate_system:               WGS84,EPSG:4326</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-bde6f829-44a5-4f79-a66b-17bf56d802a4' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-bde6f829-44a5-4f79-a66b-17bf56d802a4' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>crs</span>: 1</li><li><span class='xr-has-index'>lat</span>: 585</li><li><span class='xr-has-index'>lon</span>: 1386</li><li><span class='xr-has-index'>time</span>: 1128</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-4d2547f7-ccb6-4358-9259-00a523c78e24' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4d2547f7-ccb6-4358-9259-00a523c78e24' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>25.06 25.1 25.15 ... 49.35 49.4</div><input id='attrs-91287962-6228-4059-8fab-b4cbc11ebdbb' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-91287962-6228-4059-8fab-b4cbc11ebdbb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b3ec05ac-4e57-4fcb-8085-c1206b05740f' class='xr-var-data-in' type='checkbox'><label for='data-b3ec05ac-4e57-4fcb-8085-c1206b05740f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([25.063078, 25.104744, 25.14641 , ..., 49.312691, 49.354359, 49.396023])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>crs</span></div><div class='xr-var-dims'>(crs)</div><div class='xr-var-dtype'>int32</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-6c876215-5233-4c25-b359-aee4dc6fdc16' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6c876215-5233-4c25-b359-aee4dc6fdc16' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-824c3ecb-fd96-47f3-b357-21c1bab1d7e7' class='xr-var-data-in' type='checkbox'><label for='data-824c3ecb-fd96-47f3-b357-21c1bab1d7e7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>grid_mapping_name :</span></dt><dd>latitude_longitude</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd></dl></div><div class='xr-var-data'><pre>array([1], dtype=int32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.2 235.3 235.3 ... 292.9 292.9</div><input id='attrs-d75bdba3-652f-4f8e-a97b-f058d2a42665' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d75bdba3-652f-4f8e-a97b-f058d2a42665' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fd066828-055c-4401-a43d-c1f7fa80420b' class='xr-var-data-in' type='checkbox'><label for='data-fd066828-055c-4401-a43d-c1f7fa80420b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.227844, 235.269501, 235.311157, ..., 292.851929, 292.893585,
       292.935242])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2006-01-15 00:00:00 ... 2099-12-...</div><input id='attrs-fe9ffc4e-8765-47a3-8300-ce04c34e3849' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-fe9ffc4e-8765-47a3-8300-ce04c34e3849' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-922ce67d-55d6-4057-b761-4e0c5a17bed0' class='xr-var-data-in' type='checkbox'><label for='data-922ce67d-55d6-4057-b761-4e0c5a17bed0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2006, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2006, 2, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2006, 3, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-ff338a56-e010-494d-b841-860802f31153' class='xr-section-summary-in' type='checkbox'  checked><label for='section-ff338a56-e010-494d-b841-860802f31153' class='xr-section-summary' >Data variables: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>air_temperature</span></div><div class='xr-var-dims'>(time, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-ab5cec71-90a4-4071-a775-b1d4e78017ba' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ab5cec71-90a4-4071-a775-b1d4e78017ba' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c1997758-070b-47a2-8363-be41e017352e' class='xr-var-data-in' type='checkbox'><label for='data-c1997758-070b-47a2-8363-be41e017352e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div><div class='xr-var-data'><pre>[914593680 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-7a32c123-2956-42cb-acb7-1325c4b92b89' class='xr-section-summary-in' type='checkbox'  ><label for='section-7a32c123-2956-42cb-acb7-1325c4b92b89' class='xr-section-summary' >Attributes: <span>(46)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>Multivariate Adaptive Constructed Analogs (MACA) method, version 2.3,Dec 2013.</dd><dt><span>id :</span></dt><dd>MACAv2-METDATA</dd><dt><span>naming_authority :</span></dt><dd>edu.uidaho.reacch</dd><dt><span>Metadata_Conventions :</span></dt><dd>Unidata Dataset Discovery v1.0</dd><dt><span>Metadata_Link :</span></dt><dd></dd><dt><span>cdm_data_type :</span></dt><dd>FLOAT</dd><dt><span>title :</span></dt><dd>Monthly aggregation of downscaled daily meteorological data of Monthly Average of Daily Maximum Near-Surface Air Temperature from College of Global Change and Earth System Science, Beijing Normal University (BNU-ESM) using the run r1i1p1 of the rcp45 scenario.</dd><dt><span>summary :</span></dt><dd>This archive contains monthly downscaled meteorological and hydrological projections for the Conterminous United States at 1/24-deg resolution. These monthly values are obtained by aggregating the daily values obtained from the downscaling using the Multivariate Adaptive Constructed Analogs (MACA, Abatzoglou, 2012) statistical downscaling method with the METDATA (Abatzoglou,2013) training dataset. The downscaled meteorological variables are maximum/minimum temperature(tasmax/tasmin), maximum/minimum relative humidity (rhsmax/rhsmin),precipitation amount(pr), downward shortwave solar radiation(rsds), eastward wind(uas), northward wind(vas), and specific humidity(huss). The downscaling is based on the 365-day model outputs from different global climate models (GCMs) from Phase 5 of the Coupled Model Inter-comparison Project (CMIP3) utlizing the historical (1950-2005) and future RCP4.5/8.5(2006-2099) scenarios. </dd><dt><span>keywords :</span></dt><dd>monthly, precipitation, maximum temperature, minimum temperature, downward shortwave solar radiation, specific humidity, wind velocity, CMIP5, Gridded Meteorological Data</dd><dt><span>keywords_vocabulary :</span></dt><dd></dd><dt><span>standard_name_vocabulary :</span></dt><dd>CF-1.0</dd><dt><span>history :</span></dt><dd>No revisions.</dd><dt><span>comment :</span></dt><dd></dd><dt><span>geospatial_bounds :</span></dt><dd>POLYGON((-124.7722 25.0631,-124.7722 49.3960, -67.0648 49.3960,-67.0648, 25.0631, -124.7722,25.0631))</dd><dt><span>geospatial_lat_min :</span></dt><dd>25.0631</dd><dt><span>geospatial_lat_max :</span></dt><dd>49.3960</dd><dt><span>geospatial_lon_min :</span></dt><dd>-124.7722</dd><dt><span>geospatial_lon_max :</span></dt><dd>-67.0648</dd><dt><span>geospatial_lat_units :</span></dt><dd>decimal degrees north</dd><dt><span>geospatial_lon_units :</span></dt><dd>decimal degrees east</dd><dt><span>geospatial_lat_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_lon_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_vertical_min :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_max :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_resolution :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_positive :</span></dt><dd>up</dd><dt><span>time_coverage_start :</span></dt><dd>2091-01-01T00:0</dd><dt><span>time_coverage_end :</span></dt><dd>2095-12-31T00:00</dd><dt><span>time_coverage_duration :</span></dt><dd>P5Y</dd><dt><span>time_coverage_resolution :</span></dt><dd>P1M</dd><dt><span>date_created :</span></dt><dd>2014-05-15</dd><dt><span>date_modified :</span></dt><dd>2014-05-15</dd><dt><span>date_issued :</span></dt><dd>2014-05-15</dd><dt><span>creator_name :</span></dt><dd>John Abatzoglou</dd><dt><span>creator_url :</span></dt><dd>http://maca.northwestknowledge.net</dd><dt><span>creator_email :</span></dt><dd>jabatzoglou@uidaho.edu</dd><dt><span>institution :</span></dt><dd>University of Idaho</dd><dt><span>processing_level :</span></dt><dd>GRID</dd><dt><span>project :</span></dt><dd></dd><dt><span>contributor_name :</span></dt><dd>Katherine C. Hegewisch</dd><dt><span>contributor_role :</span></dt><dd>Postdoctoral Fellow</dd><dt><span>publisher_name :</span></dt><dd>REACCH</dd><dt><span>publisher_email :</span></dt><dd>reacch@uidaho.edu</dd><dt><span>publisher_url :</span></dt><dd>http://www.reacchpna.org/</dd><dt><span>license :</span></dt><dd>Creative Commons CC0 1.0 Universal Dedication(http://creativecommons.org/publicdomain/zero/1.0/legalcode)</dd><dt><span>coordinate_system :</span></dt><dd>WGS84,EPSG:4326</dd></dl></div></li></ul></div></div>





Similar to the previous lesson, you can subset the data. 
In the example below you are subsetting data for the state of 
California similar to what you did in the previous lesson. You can 
select any state that you wish for this analysis!


{:.input}
```python
# Download natural earth data to generate AOI
et.data.get_data(url="https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lakes.zip")

states_path = "earthpy-downloads/ne_50m_admin_1_states_provinces_lakes"
states_path = os.path.join(states_path, "ne_50m_admin_1_states_provinces_lakes.shp")

states_gdf = gpd.read_file(states_path)

```

Subset the data to a single state. Note that when you slice the data, you 
will use the total extent boundary of the subsetted object. This means that
some of your data will be for an area outside of the state of California. 

{:.input}
```python
cali_aoi = states_gdf[states_gdf.name == "California"]
f, ax = plt.subplots()
cali_aoi.plot(ax=ax)
ax.set(title="California AOI Subset")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-seasonal-summary/2020-10-16-netcdf-03-seasonal-summary_11_0.png">

</figure>




{:.input}
```python
# Get lat min, max from Cali aoi extent
aoi_lat = [float(cali_aoi.bounds.miny), float(cali_aoi.bounds.maxy)]
aoi_lon = [float(cali_aoi.bounds.minx), float(cali_aoi.bounds.maxx)]

# Adjust for global lat lon vs wgs84 coords
aoi_lon[0] = aoi_lon[0]+360
aoi_lon[1] = aoi_lon[1]+360

# Slice by time & aoi location
start_date = "2059-12-15"
end_date = "2099-12-15"

cali_temp = monthly_forecast_temp_xr["air_temperature"].sel(
    time=slice(start_date, end_date),
    lon=slice(aoi_lon[0], aoi_lon[1]),
    lat=slice(aoi_lat[0], aoi_lat[1]))
cali_temp
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 481, lat: 227, lon: 246)&gt;
[26860002 values with dtype=float32]
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9
  * time     (time) object 2059-12-15 00:00:00 ... 2099-12-15 00:00:00
Attributes:
    long_name:      Monthly Average of Daily Maximum Near-Surface Air Tempera...
    units:          K
    grid_mapping:   crs
    standard_name:  air_temperature
    height:         2 m
    cell_methods:   time: maximum(interval: 24 hours);mean over days
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 481</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-868deb19-c8a8-4a8a-bb86-5f374c6198f5' class='xr-array-in' type='checkbox' checked><label for='section-868deb19-c8a8-4a8a-bb86-5f374c6198f5' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[26860002 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-5d663e63-5ab0-486c-844b-0618a1e11a35' class='xr-section-summary-in' type='checkbox'  checked><label for='section-5d663e63-5ab0-486c-844b-0618a1e11a35' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-6c7e7d50-1e28-429f-adcc-90ccf3988789' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6c7e7d50-1e28-429f-adcc-90ccf3988789' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f3cff25b-e9f0-492b-b29f-d67dd93557bd' class='xr-var-data-in' type='checkbox'><label for='data-f3cff25b-e9f0-492b-b29f-d67dd93557bd' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-cdb2ce44-9212-49e3-9456-ef275b4743e3' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-cdb2ce44-9212-49e3-9456-ef275b4743e3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c8be6155-bb6f-4bc1-85ea-6f2ec7bef1d1' class='xr-var-data-in' type='checkbox'><label for='data-c8be6155-bb6f-4bc1-85ea-6f2ec7bef1d1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-15 00:00:00 ... 2099-12-...</div><input id='attrs-2b8a141f-0679-4291-b59e-c208c80bfa88' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2b8a141f-0679-4291-b59e-c208c80bfa88' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-637bf4b6-f2cf-494c-9b54-8054a0321e2c' class='xr-var-data-in' type='checkbox'><label for='data-637bf4b6-f2cf-494c-9b54-8054a0321e2c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 2, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-3fd5d2e6-8114-44c8-bf56-c27de4918fb6' class='xr-section-summary-in' type='checkbox'  checked><label for='section-3fd5d2e6-8114-44c8-bf56-c27de4918fb6' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>





{:.input}
```python
print("Time Period start: ", cali_temp.time.min().values)
print("Time Period end: ", cali_temp.time.max().values)
```

{:.output}
    Time Period start:  2059-12-15 00:00:00
    Time Period end:  2099-12-15 00:00:00



{:.input}
```python
# Create the region mask object - this is used to identify each region
cali_region = regionmask.from_geopandas(cali_aoi,
                                        names="name",
                                        name="name",
                                        abbrevs="iso_3166_2")
cali_mask = regionmask.mask_3D_geopandas(cali_aoi,
                                         monthly_forecast_temp_xr.lon,
                                         monthly_forecast_temp_xr.lat)
# Mask the netcdf data
cali_temp_masked = cali_temp.where(cali_mask)
cali_temp_masked
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 481, lat: 227, lon: 246, region: 1)&gt;
array([[[[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
...
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]]]], dtype=float32)
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9
  * time     (time) object 2059-12-15 00:00:00 ... 2099-12-15 00:00:00
  * region   (region) int64 53
Attributes:
    long_name:      Monthly Average of Daily Maximum Near-Surface Air Tempera...
    units:          K
    grid_mapping:   crs
    standard_name:  air_temperature
    height:         2 m
    cell_methods:   time: maximum(interval: 24 hours);mean over days
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 481</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li><li><span class='xr-has-index'>region</span>: 1</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-f64fab7a-bcc2-4ff1-9f96-95c8a51ac10e' class='xr-array-in' type='checkbox' checked><label for='section-f64fab7a-bcc2-4ff1-9f96-95c8a51ac10e' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... nan nan nan nan nan nan nan nan</span></div><div class='xr-array-data'><pre>array([[[[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
...
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-c8a8a2f6-18d1-4027-8d4d-0876fc72090d' class='xr-section-summary-in' type='checkbox'  checked><label for='section-c8a8a2f6-18d1-4027-8d4d-0876fc72090d' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-83cb7a46-9d5c-4877-9128-98a7538158d4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-83cb7a46-9d5c-4877-9128-98a7538158d4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4568fb3c-bcdd-4f32-b2a0-0ecf2f9e2bcf' class='xr-var-data-in' type='checkbox'><label for='data-4568fb3c-bcdd-4f32-b2a0-0ecf2f9e2bcf' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-75a6046d-35de-429d-aad9-ed9c5e614e8a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-75a6046d-35de-429d-aad9-ed9c5e614e8a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-18f0d67f-0f16-4e5a-a933-736bb346b319' class='xr-var-data-in' type='checkbox'><label for='data-18f0d67f-0f16-4e5a-a933-736bb346b319' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-15 00:00:00 ... 2099-12-...</div><input id='attrs-4419326f-47db-48d8-b22d-623db67755e5' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4419326f-47db-48d8-b22d-623db67755e5' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e2642616-1198-470e-b883-6c729b5d5b18' class='xr-var-data-in' type='checkbox'><label for='data-e2642616-1198-470e-b883-6c729b5d5b18' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 2, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53</div><input id='attrs-6561ec76-5763-46c2-8f50-d9f5698f3b16' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6561ec76-5763-46c2-8f50-d9f5698f3b16' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-09f3c9a1-7564-4ad6-95b1-fe0be4609961' class='xr-var-data-in' type='checkbox'><label for='data-09f3c9a1-7564-4ad6-95b1-fe0be4609961' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-dbcf9726-d2e6-4e01-9817-5c8f85f2b703' class='xr-section-summary-in' type='checkbox'  checked><label for='section-dbcf9726-d2e6-4e01-9817-5c8f85f2b703' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>





{:.input}
```python
cali_temp.values.shape
```

{:.output}
{:.execute_result}



    (481, 227, 246)





{:.input}
```python
# Compare mean values for masked vs unmasked
print(cali_temp.where(pd.notnull(cali_temp)).mean())

print(cali_temp_masked.mean())

```

{:.output}
    <xarray.DataArray 'air_temperature' ()>
    array(296.44388, dtype=float32)
    <xarray.DataArray 'air_temperature' ()>
    array(297.7149, dtype=float32)



Calculate the mean temperature for each season across the entire dataset. 
This will produce 4 arrays - one representing mean temperature for each seasons. 

{:.input}
```python
cali_season_summary = cali_temp_masked.groupby('time.season').mean('time', skipna=True)

# This will create 4 arrays - one for each season showing mean temperature values
cali_season_summary
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (season: 4, lat: 227, lon: 246, region: 1)&gt;
array([[[[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
...
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]]]], dtype=float32)
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9
  * region   (region) int64 53
  * season   (season) object &#x27;DJF&#x27; &#x27;JJA&#x27; &#x27;MAM&#x27; &#x27;SON&#x27;</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>season</span>: 4</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li><li><span class='xr-has-index'>region</span>: 1</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-01654f34-32f0-46c0-9ec6-824d2e057b8f' class='xr-array-in' type='checkbox' checked><label for='section-01654f34-32f0-46c0-9ec6-824d2e057b8f' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... nan nan nan nan nan nan nan nan</span></div><div class='xr-array-data'><pre>array([[[[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
...
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-cc11979d-bab9-4601-afcc-79236307f99b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-cc11979d-bab9-4601-afcc-79236307f99b' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-7c0d952d-6035-4437-bccb-f4515b0d107d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7c0d952d-6035-4437-bccb-f4515b0d107d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ea9f6f01-4a32-40ba-9d19-83b6b6856e6f' class='xr-var-data-in' type='checkbox'><label for='data-ea9f6f01-4a32-40ba-9d19-83b6b6856e6f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-78478728-7f6c-4acd-87a8-399ab8b846eb' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-78478728-7f6c-4acd-87a8-399ab8b846eb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ed319d3b-34c4-40ca-89ab-962aebafb59c' class='xr-var-data-in' type='checkbox'><label for='data-ed319d3b-34c4-40ca-89ab-962aebafb59c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53</div><input id='attrs-522bc508-3c15-45a1-b286-8b2088ec2fca' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-522bc508-3c15-45a1-b286-8b2088ec2fca' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-377af409-6dc1-4768-8f17-cdfbc07c579d' class='xr-var-data-in' type='checkbox'><label for='data-377af409-6dc1-4768-8f17-cdfbc07c579d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>season</span></div><div class='xr-var-dims'>(season)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>&#x27;DJF&#x27; &#x27;JJA&#x27; &#x27;MAM&#x27; &#x27;SON&#x27;</div><input id='attrs-96073e31-0953-40ed-8cf1-e40985daea53' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-96073e31-0953-40ed-8cf1-e40985daea53' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-30a69445-3c83-4128-95be-20d65a74e111' class='xr-var-data-in' type='checkbox'><label for='data-30a69445-3c83-4128-95be-20d65a74e111' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;DJF&#x27;, &#x27;JJA&#x27;, &#x27;MAM&#x27;, &#x27;SON&#x27;], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-9aee2ea1-be6e-439f-a141-ab813e6f7006' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-9aee2ea1-be6e-439f-a141-ab813e6f7006' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





Plot the seasonal data!

{:.input}
```python
# Create a plot showing mean temperature aross seasons
cali_season_summary.plot(col='season', col_wrap=2, figsize=(10,10))
plt.suptitle("Mean Temperature Across All Selected Years By Season \n California, USA", y=1.05)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-seasonal-summary/2020-10-16-netcdf-03-seasonal-summary_20_0.png">

</figure>




## Calculate UnWeighted Seasonal Averages For By Season Across Each Year

Above you created one single value per season which summarized seasonal data across all years.
However you may want to look at seasonal variation year to year in the projected data.
You can calculate seasonal statistcs by 

1. resampling the data and then
2. grouping the data and summarizing it

{:.input}
```python
# Resample the data by season across all years
cali_season_mean_all_years = cali_temp_masked.resample(time='QS-DEC', keep_attrs=True).mean()
cali_season_mean_all_years
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 161, lat: 227, lon: 246, region: 1)&gt;
array([[[[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
...
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]]]], dtype=float32)
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9
  * region   (region) int64 53</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li><li><span class='xr-has-index'>region</span>: 1</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-d1635e2c-dbd6-4f5e-9b13-2e2019c32ac1' class='xr-array-in' type='checkbox' checked><label for='section-d1635e2c-dbd6-4f5e-9b13-2e2019c32ac1' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... nan nan nan nan nan nan nan nan</span></div><div class='xr-array-data'><pre>array([[[[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
...
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]],

        [[nan],
         [nan],
         [nan],
         ...,
         [nan],
         [nan],
         [nan]]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-e55faddd-90c0-4cd3-95f2-645cac686ceb' class='xr-section-summary-in' type='checkbox'  checked><label for='section-e55faddd-90c0-4cd3-95f2-645cac686ceb' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-8f4dbb10-9bc6-491e-8ad0-9ad853aa8380' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-8f4dbb10-9bc6-491e-8ad0-9ad853aa8380' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c23e32f0-b2e2-4ac0-abcc-f971dc5bfe0d' class='xr-var-data-in' type='checkbox'><label for='data-c23e32f0-b2e2-4ac0-abcc-f971dc5bfe0d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-7596572f-329c-4656-9b3c-4de981cf8b8c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7596572f-329c-4656-9b3c-4de981cf8b8c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6ed845e6-0694-473c-9eea-dcaaa1b0c3a7' class='xr-var-data-in' type='checkbox'><label for='data-6ed845e6-0694-473c-9eea-dcaaa1b0c3a7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-a7cb032b-ce48-4c6b-ae70-5357a9d35b50' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a7cb032b-ce48-4c6b-ae70-5357a9d35b50' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-876129eb-ad27-4ce7-b7ee-8b7675d2fc84' class='xr-var-data-in' type='checkbox'><label for='data-876129eb-ad27-4ce7-b7ee-8b7675d2fc84' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53</div><input id='attrs-1c6936dc-bba3-453c-9ce8-a6fa10ef954a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-1c6936dc-bba3-453c-9ce8-a6fa10ef954a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ab7409e5-4c58-4c1b-bd79-0d7452bd94ff' class='xr-var-data-in' type='checkbox'><label for='data-ab7409e5-4c58-4c1b-bd79-0d7452bd94ff' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-e9ba7671-38af-4446-93a0-520ebe00adbc' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-e9ba7671-38af-4446-93a0-520ebe00adbc' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
# Summarize each array into one single (mean) value
cali_seasonal_mean = cali_season_mean_all_years.groupby('time').mean(["lat", "lon"])
cali_seasonal_mean
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 161, region: 1)&gt;
array([[287.58853],
       [294.91492],
       [307.54965],
       [296.1992 ],
       [286.9227 ],
       [297.44305],
       [308.05768],
       [297.38226],
       [287.22467],
       [297.08362],
       [307.30133],
       [300.2796 ],
       [288.07535],
       [295.8151 ],
       [306.7827 ],
       [299.51282],
       [287.12833],
       [296.31116],
       [307.38702],
       [299.31223],
...
       [296.82205],
       [306.6316 ],
       [297.50574],
       [288.43213],
       [297.6081 ],
       [308.86887],
       [299.97482],
       [290.37555],
       [298.52206],
       [308.26926],
       [300.14514],
       [287.64072],
       [298.70792],
       [306.78052],
       [298.5175 ],
       [289.85388],
       [296.71042],
       [308.56342],
       [300.00516],
       [289.92953]], dtype=float32)
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00
  * region   (region) int64 53</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>region</span>: 1</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-f9e6bdab-830f-49e3-9e65-64d5e5a0421f' class='xr-array-in' type='checkbox' checked><label for='section-f9e6bdab-830f-49e3-9e65-64d5e5a0421f' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>287.58853 294.91492 307.54965 ... 308.56342 300.00516 289.92953</span></div><div class='xr-array-data'><pre>array([[287.58853],
       [294.91492],
       [307.54965],
       [296.1992 ],
       [286.9227 ],
       [297.44305],
       [308.05768],
       [297.38226],
       [287.22467],
       [297.08362],
       [307.30133],
       [300.2796 ],
       [288.07535],
       [295.8151 ],
       [306.7827 ],
       [299.51282],
       [287.12833],
       [296.31116],
       [307.38702],
       [299.31223],
...
       [296.82205],
       [306.6316 ],
       [297.50574],
       [288.43213],
       [297.6081 ],
       [308.86887],
       [299.97482],
       [290.37555],
       [298.52206],
       [308.26926],
       [300.14514],
       [287.64072],
       [298.70792],
       [306.78052],
       [298.5175 ],
       [289.85388],
       [296.71042],
       [308.56342],
       [300.00516],
       [289.92953]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-421a7473-103b-4652-9d03-0cd6a4929536' class='xr-section-summary-in' type='checkbox'  checked><label for='section-421a7473-103b-4652-9d03-0cd6a4929536' class='xr-section-summary' >Coordinates: <span>(2)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-940a538b-29d7-4e90-ad03-7cb6f90a01ce' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-940a538b-29d7-4e90-ad03-7cb6f90a01ce' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ae50aa4c-af8c-40c6-98d5-bb4b63a402d4' class='xr-var-data-in' type='checkbox'><label for='data-ae50aa4c-af8c-40c6-98d5-bb4b63a402d4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53</div><input id='attrs-a160a0ba-2958-4aed-a22b-580f13c98de4' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a160a0ba-2958-4aed-a22b-580f13c98de4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9bca3c18-bb07-4ab1-82be-f2b2179cb395' class='xr-var-data-in' type='checkbox'><label for='data-9bca3c18-bb07-4ab1-82be-f2b2179cb395' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-a2dba0fa-ff32-4863-87ed-789afffcfdfa' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-a2dba0fa-ff32-4863-87ed-789afffcfdfa' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
# This data now has one value per season rather than an array
cali_seasonal_mean.shape
```

{:.output}
{:.execute_result}



    (161, 1)





{:.input}
```python
# Plot the data
f, ax = plt.subplots(figsize=(10, 4))
cali_seasonal_mean.plot(marker="o",
                        color="grey",
                        markerfacecolor="purple",
                        markeredgecolor="purple")
ax.set(title="Seasonal Mean Temperature")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-seasonal-summary/2020-10-16-netcdf-03-seasonal-summary_25_0.png">

</figure>




### Export Seasonal Climate Project Data To .csv File
At this point you can convert the data to a dataframe and export 
it to a `.csv` format if you wish.

{:.input}
```python
# Convert to a dataframe
cali_seasonal_mean_df = cali_seasonal_mean.to_dataframe()
cali_seasonal_mean_df
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
      <th></th>
      <th>air_temperature</th>
    </tr>
    <tr>
      <th>time</th>
      <th>region</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2059-12-01 00:00:00</th>
      <th>53</th>
      <td>287.588531</td>
    </tr>
    <tr>
      <th>2060-03-01 00:00:00</th>
      <th>53</th>
      <td>294.914917</td>
    </tr>
    <tr>
      <th>2060-06-01 00:00:00</th>
      <th>53</th>
      <td>307.549652</td>
    </tr>
    <tr>
      <th>2060-09-01 00:00:00</th>
      <th>53</th>
      <td>296.199188</td>
    </tr>
    <tr>
      <th>2060-12-01 00:00:00</th>
      <th>53</th>
      <td>286.922699</td>
    </tr>
    <tr>
      <th>...</th>
      <th>...</th>
      <td>...</td>
    </tr>
    <tr>
      <th>2098-12-01 00:00:00</th>
      <th>53</th>
      <td>289.853882</td>
    </tr>
    <tr>
      <th>2099-03-01 00:00:00</th>
      <th>53</th>
      <td>296.710419</td>
    </tr>
    <tr>
      <th>2099-06-01 00:00:00</th>
      <th>53</th>
      <td>308.563416</td>
    </tr>
    <tr>
      <th>2099-09-01 00:00:00</th>
      <th>53</th>
      <td>300.005157</td>
    </tr>
    <tr>
      <th>2099-12-01 00:00:00</th>
      <th>53</th>
      <td>289.929535</td>
    </tr>
  </tbody>
</table>
<p>161 rows × 1 columns</p>
</div>





{:.input}
```python
# Export a csv file
cali_seasonal_mean_df.to_csv("cali-seasonal-temp.csv")
```

### Plot Seasonal Data By Season 

Using `groupby()` you can group the data and plot it by season to better look at seasonal trends. 

{:.input}
```python
colors = {3: "grey", 6: "lightgreen", 9: "green", 12: "purple"}
seasons = {3: "spring", 6: "summer", 9: "fall", 12: "winter"}

f, ax = plt.subplots(figsize=(10, 7))
for month, arr in cali_seasonal_mean.groupby('time.month'):
    arr.plot(ax=ax,
             color="grey",
             marker="o",
             markerfacecolor=colors[month],
             markeredgecolor=colors[month],
             label=seasons[month])

ax.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
ax.set(title="Seasonal Change in Mean Temperature Over Time")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-seasonal-summary/2020-10-16-netcdf-03-seasonal-summary_30_0.png">

</figure>




## Weighted Summary by Season

To begin, you will generate a list of days in each month which will be used to weight
your seasonal summary data according to the the days in each month. 

* TODO -- redo this section to use the approach above which is perfect

{:.input}
```python
# Calculate seasonal averages
# http://xarray.pydata.org/en/stable/examples/monthly-means.html

month_length = cali_temp_masked.time.dt.days_in_month
month_length
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;days_in_month&#x27; (time: 481)&gt;
array([31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30,
       31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30,
       31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28,
       31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31,
       31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31,
       31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31,
       30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31,
       30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31,
       30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31,
       30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31,
       28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30,
       31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30,
       31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30,
       31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30,
       31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28,
       31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31,
       31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31,
       31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31,
       30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31,
       30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31,
       30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31,
       30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31,
       28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30,
       31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30,
       31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30,
       31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30,
       31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28,
       31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31,
       31, 30, 31, 30, 31])
Coordinates:
  * time     (time) object 2059-12-15 00:00:00 ... 2099-12-15 00:00:00</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'days_in_month'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 481</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-9dd2ddf5-7763-4d95-ada0-8754259a7cc5' class='xr-array-in' type='checkbox' checked><label for='section-9dd2ddf5-7763-4d95-ada0-8754259a7cc5' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>31 31 28 31 30 31 30 31 31 30 31 ... 28 31 30 31 30 31 31 30 31 30 31</span></div><div class='xr-array-data'><pre>array([31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30,
       31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30,
       31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28,
       31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31,
       31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31,
       31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31,
       30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31,
       30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31,
       30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31,
       30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31,
       28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30,
       31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30,
       31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30,
       31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30,
       31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28,
       31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31,
       31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31,
       31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31,
       30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31,
       30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31,
       30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31,
       30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31,
       28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30,
       31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30,
       31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30,
       31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30,
       31, 30, 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28,
       31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30, 31, 30, 31,
       31, 30, 31, 30, 31])</pre></div></div></li><li class='xr-section-item'><input id='section-29ab15a7-c505-4c44-8d98-0371967b98d1' class='xr-section-summary-in' type='checkbox'  checked><label for='section-29ab15a7-c505-4c44-8d98-0371967b98d1' class='xr-section-summary' >Coordinates: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-15 00:00:00 ... 2099-12-...</div><input id='attrs-253ddc08-6913-446c-8d60-19aaa991c1d9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-253ddc08-6913-446c-8d60-19aaa991c1d9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ad924cac-6c56-4e1d-8957-ea039777ea09' class='xr-var-data-in' type='checkbox'><label for='data-ad924cac-6c56-4e1d-8957-ea039777ea09' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 2, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-b329ef40-c78b-4f89-8da8-eceabda2b976' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-b329ef40-c78b-4f89-8da8-eceabda2b976' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





Next, divide the data grouped by season by the total days represented
in each season to create weighted values


{:.input}
```python
# This is returning values of 0 rather than na 
# Calculate a weighted mean by season
cali_weighted_mean = ((cali_temp * month_length).resample(time='QS-DEC').sum() /
          month_length.resample(time='QS-DEC').sum())
# Replace 0 values with nan
cali_weighted_mean = cali_weighted_mean.where(cali_weighted_mean)
cali_weighted_mean
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 161, lat: 227, lon: 246)&gt;
array([[[         nan,          nan,          nan, ..., 293.5801985 ,
         293.7889974 , 293.90551826],
        [         nan,          nan,          nan, ..., 294.02546794,
         294.18081868, 294.23653463],
        [         nan,          nan,          nan, ..., 294.24290195,
         294.20305481, 294.21427036],
        ...,
        [         nan,          nan,          nan, ..., 276.85069716,
         276.99935404, 277.01003689],
        [         nan,          nan,          nan, ..., 276.43595988,
         276.36333211, 276.91017863],
        [         nan, 288.33420851, 288.36123454, ..., 275.67130907,
         275.48182136, 276.18686761]],

       [[         nan,          nan,          nan, ..., 304.58926591,
         304.68364749, 304.79025633],
        [         nan,          nan,          nan, ..., 304.84524636,
         304.83542898, 304.93177862],
        [         nan,          nan,          nan, ..., 304.89216647,
         304.79319697, 304.89644955],
...
        [         nan,          nan,          nan, ..., 293.35862682,
         293.59940984, 293.81863403],
        [         nan,          nan,          nan, ..., 292.58462826,
         292.60206051, 293.47256302],
        [         nan, 292.99421843, 293.19931299, ..., 291.62713992,
         291.39074942, 292.33850332]],

       [[         nan,          nan,          nan, ..., 296.90481567,
         297.07461548, 297.19067383],
        [         nan,          nan,          nan, ..., 297.28579712,
         297.44973755, 297.48822021],
        [         nan,          nan,          nan, ..., 297.48461914,
         297.45352173, 297.4385376 ],
        ...,
        [         nan,          nan,          nan, ..., 280.73175049,
         280.88598633, 280.91375732],
        [         nan,          nan,          nan, ..., 280.28771973,
         280.18481445, 280.7489624 ],
        [         nan, 289.49255371, 289.53207397, ..., 279.49191284,
         279.28921509, 279.95019531]]])
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-52a6d922-7117-4fe4-8cb9-7b292990097e' class='xr-array-in' type='checkbox' checked><label for='section-52a6d922-7117-4fe4-8cb9-7b292990097e' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan ... 280.3 278.9 279.4 279.5 279.3 280.0</span></div><div class='xr-array-data'><pre>array([[[         nan,          nan,          nan, ..., 293.5801985 ,
         293.7889974 , 293.90551826],
        [         nan,          nan,          nan, ..., 294.02546794,
         294.18081868, 294.23653463],
        [         nan,          nan,          nan, ..., 294.24290195,
         294.20305481, 294.21427036],
        ...,
        [         nan,          nan,          nan, ..., 276.85069716,
         276.99935404, 277.01003689],
        [         nan,          nan,          nan, ..., 276.43595988,
         276.36333211, 276.91017863],
        [         nan, 288.33420851, 288.36123454, ..., 275.67130907,
         275.48182136, 276.18686761]],

       [[         nan,          nan,          nan, ..., 304.58926591,
         304.68364749, 304.79025633],
        [         nan,          nan,          nan, ..., 304.84524636,
         304.83542898, 304.93177862],
        [         nan,          nan,          nan, ..., 304.89216647,
         304.79319697, 304.89644955],
...
        [         nan,          nan,          nan, ..., 293.35862682,
         293.59940984, 293.81863403],
        [         nan,          nan,          nan, ..., 292.58462826,
         292.60206051, 293.47256302],
        [         nan, 292.99421843, 293.19931299, ..., 291.62713992,
         291.39074942, 292.33850332]],

       [[         nan,          nan,          nan, ..., 296.90481567,
         297.07461548, 297.19067383],
        [         nan,          nan,          nan, ..., 297.28579712,
         297.44973755, 297.48822021],
        [         nan,          nan,          nan, ..., 297.48461914,
         297.45352173, 297.4385376 ],
        ...,
        [         nan,          nan,          nan, ..., 280.73175049,
         280.88598633, 280.91375732],
        [         nan,          nan,          nan, ..., 280.28771973,
         280.18481445, 280.7489624 ],
        [         nan, 289.49255371, 289.53207397, ..., 279.49191284,
         279.28921509, 279.95019531]]])</pre></div></div></li><li class='xr-section-item'><input id='section-9da4f22a-848a-496b-b843-c94dbd458e68' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9da4f22a-848a-496b-b843-c94dbd458e68' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-6c8b607d-8f0c-42db-b812-16e04a8a305a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6c8b607d-8f0c-42db-b812-16e04a8a305a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5894d241-1f8a-4a38-8571-2fd0a73b603e' class='xr-var-data-in' type='checkbox'><label for='data-5894d241-1f8a-4a38-8571-2fd0a73b603e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-1abe04e5-cc74-4758-9d91-0e24d0ac2d38' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1abe04e5-cc74-4758-9d91-0e24d0ac2d38' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-488a3598-477a-4c3a-9c09-9ecdaa4a9c00' class='xr-var-data-in' type='checkbox'><label for='data-488a3598-477a-4c3a-9c09-9ecdaa4a9c00' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-718705ef-5c25-42f9-b5cc-5e64a328fe95' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-718705ef-5c25-42f9-b5cc-5e64a328fe95' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-99c1a2bd-8827-4dae-89a5-d443098e2b26' class='xr-var-data-in' type='checkbox'><label for='data-99c1a2bd-8827-4dae-89a5-d443098e2b26' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-9b1884fc-68fa-4a0a-ab60-5dd58337cd61' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-9b1884fc-68fa-4a0a-ab60-5dd58337cd61' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
cali_weighted_season_value = cali_weighted_mean.groupby('time').mean(["lat", "lon"])
cali_weighted_season_value
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 161)&gt;
array([285.16407751, 293.79996189, 306.98615802, 294.77932632,
       284.82245493, 296.44557757, 307.31390129, 295.70712021,
       285.57019637, 296.45601256, 306.99317631, 298.81013847,
       286.25070601, 294.61612351, 306.4603253 , 297.99370087,
       285.09726893, 295.13013248, 307.1514788 , 297.53097714,
       287.26984206, 296.25708791, 306.71672108, 296.89218473,
       286.36740771, 297.24143145, 306.46996674, 298.81953928,
       286.03366479, 294.02122663, 306.78343022, 295.55949342,
       286.2310138 , 294.23101431, 306.02180452, 296.95916358,
       288.62539293, 295.1887236 , 305.95994985, 296.71104921,
       283.1951595 , 296.18705839, 306.73675871, 297.28644583,
       284.76433623, 295.73587267, 308.11169027, 297.19411634,
       286.2774662 , 297.09159452, 306.80903549, 300.39860528,
       288.96237763, 294.44719037, 308.79952357, 297.69844024,
       286.22835951, 298.16376591, 306.82220713, 295.16858695,
       283.72391772, 293.19469229, 306.70733221, 294.42640223,
       283.52739571, 295.48116212, 308.26444041, 295.77001857,
       286.44464165, 293.21426966, 305.84438029, 295.73327818,
       285.85987935, 298.04532182, 306.33336142, 297.41282914,
       284.97498232, 293.51959672, 306.66991511, 298.62212731,
...
       286.8210598 , 294.88417661, 304.95919097, 295.99584827,
       289.21132301, 296.39106781, 307.1274106 , 296.6061649 ,
       286.17263662, 293.66540287, 306.84476519, 296.60133774,
       287.36416823, 294.03276049, 308.0179198 , 298.90408256,
       287.59856449, 298.15348904, 306.1131631 , 295.23901222,
       286.20220511, 294.81196504, 307.34874777, 296.92115512,
       286.33505622, 294.26560419, 307.29997578, 295.20834502,
       284.53121298, 294.06814239, 307.45949272, 296.87583649,
       286.5424181 , 295.75026453, 306.73097012, 295.84583573,
       286.72037115, 295.18204131, 308.00289871, 297.09959624,
       285.76162616, 294.02287488, 305.66818861, 296.27705966,
       287.96770812, 294.94218196, 308.13923011, 295.23481543,
       287.88978961, 294.62053934, 307.50433499, 297.34962238,
       286.62029419, 298.16973229, 307.39600104, 297.42513259,
       286.68849867, 295.77891911, 306.08222736, 296.21427709,
       286.31492746, 296.74431998, 308.69835651, 298.47319273,
       288.30366768, 297.47621866, 307.6869003 , 298.69840565,
       285.2477415 , 297.61472959, 306.15385019, 296.8390027 ,
       288.03558802, 295.85186717, 308.10138946, 298.28386676,
       287.93682153])
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-1eccf908-c429-4927-863e-e972e1c8d86b' class='xr-array-in' type='checkbox' checked><label for='section-1eccf908-c429-4927-863e-e972e1c8d86b' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>285.2 293.8 307.0 294.8 284.8 296.4 ... 288.0 295.9 308.1 298.3 287.9</span></div><div class='xr-array-data'><pre>array([285.16407751, 293.79996189, 306.98615802, 294.77932632,
       284.82245493, 296.44557757, 307.31390129, 295.70712021,
       285.57019637, 296.45601256, 306.99317631, 298.81013847,
       286.25070601, 294.61612351, 306.4603253 , 297.99370087,
       285.09726893, 295.13013248, 307.1514788 , 297.53097714,
       287.26984206, 296.25708791, 306.71672108, 296.89218473,
       286.36740771, 297.24143145, 306.46996674, 298.81953928,
       286.03366479, 294.02122663, 306.78343022, 295.55949342,
       286.2310138 , 294.23101431, 306.02180452, 296.95916358,
       288.62539293, 295.1887236 , 305.95994985, 296.71104921,
       283.1951595 , 296.18705839, 306.73675871, 297.28644583,
       284.76433623, 295.73587267, 308.11169027, 297.19411634,
       286.2774662 , 297.09159452, 306.80903549, 300.39860528,
       288.96237763, 294.44719037, 308.79952357, 297.69844024,
       286.22835951, 298.16376591, 306.82220713, 295.16858695,
       283.72391772, 293.19469229, 306.70733221, 294.42640223,
       283.52739571, 295.48116212, 308.26444041, 295.77001857,
       286.44464165, 293.21426966, 305.84438029, 295.73327818,
       285.85987935, 298.04532182, 306.33336142, 297.41282914,
       284.97498232, 293.51959672, 306.66991511, 298.62212731,
...
       286.8210598 , 294.88417661, 304.95919097, 295.99584827,
       289.21132301, 296.39106781, 307.1274106 , 296.6061649 ,
       286.17263662, 293.66540287, 306.84476519, 296.60133774,
       287.36416823, 294.03276049, 308.0179198 , 298.90408256,
       287.59856449, 298.15348904, 306.1131631 , 295.23901222,
       286.20220511, 294.81196504, 307.34874777, 296.92115512,
       286.33505622, 294.26560419, 307.29997578, 295.20834502,
       284.53121298, 294.06814239, 307.45949272, 296.87583649,
       286.5424181 , 295.75026453, 306.73097012, 295.84583573,
       286.72037115, 295.18204131, 308.00289871, 297.09959624,
       285.76162616, 294.02287488, 305.66818861, 296.27705966,
       287.96770812, 294.94218196, 308.13923011, 295.23481543,
       287.88978961, 294.62053934, 307.50433499, 297.34962238,
       286.62029419, 298.16973229, 307.39600104, 297.42513259,
       286.68849867, 295.77891911, 306.08222736, 296.21427709,
       286.31492746, 296.74431998, 308.69835651, 298.47319273,
       288.30366768, 297.47621866, 307.6869003 , 298.69840565,
       285.2477415 , 297.61472959, 306.15385019, 296.8390027 ,
       288.03558802, 295.85186717, 308.10138946, 298.28386676,
       287.93682153])</pre></div></div></li><li class='xr-section-item'><input id='section-36acd77e-aef7-476c-996d-f336a75c8f9c' class='xr-section-summary-in' type='checkbox'  checked><label for='section-36acd77e-aef7-476c-996d-f336a75c8f9c' class='xr-section-summary' >Coordinates: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-e1b192ea-fec6-49e2-be60-5518fd55463f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e1b192ea-fec6-49e2-be60-5518fd55463f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3814b41c-ac6d-4882-93ee-86db8a5096e9' class='xr-var-data-in' type='checkbox'><label for='data-3814b41c-ac6d-4882-93ee-86db8a5096e9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-ee261606-3bab-4a21-b2f8-30ae98f2a6d2' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-ee261606-3bab-4a21-b2f8-30ae98f2a6d2' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
colors = {3: "grey", 6: "lightgreen", 9: "green", 12: "purple"}
seasons = {3: "Spring", 6: "Summer", 9: "Fall", 12: "Winter"}

f, (ax1, ax2) = plt.subplots(2,1,figsize=(10, 7), sharey=True)
for month, arr in cali_weighted_season_value.groupby('time.month'):
    arr.plot(ax=ax1,
             color="grey",
             marker="o",
             markerfacecolor=colors[month],
             markeredgecolor=colors[month],
             label=seasons[month])

ax1.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
ax1.set(title="Weighted Seasonal Change in Mean Temperature Over Time")

for month, arr in cali_seasonal_mean.groupby('time.month'):
    arr.plot(ax=ax2,
             color="grey",
             marker="o",
             markerfacecolor=colors[month],
             markeredgecolor=colors[month],
             label=seasons[month])

ax2.set(title="Unweighted Seasonal Change in Mean Temperature Over Time")
f.tight_layout()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-seasonal-summary/2020-10-16-netcdf-03-seasonal-summary_37_0.png">

</figure>




The difference between weighted vs unweighted values is not huge but worth considering 
in this analysis

{:.input}
```python
# What does the difference look like weighted vs unweighted?
cali_seasonal_mean - cali_weighted_season_value
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 161, region: 1)&gt;
array([[2.42445398],
       [1.1149551 ],
       [0.56349408],
       [1.41986191],
       [2.10024405],
       [0.99747663],
       [0.74377694],
       [1.67514298],
       [1.65447404],
       [0.6276056 ],
       [0.30815426],
       [1.46946358],
       [1.82464189],
       [1.19897048],
       [0.32238954],
       [1.51911652],
       [2.03105749],
       [1.18102475],
       [0.23554512],
       [1.7812482 ],
...
       [1.04313289],
       [0.54936444],
       [1.29146021],
       [2.11720145],
       [0.86377328],
       [0.17050946],
       [1.50163027],
       [2.07188164],
       [1.04584555],
       [0.58235629],
       [1.44673595],
       [2.39297506],
       [1.09318667],
       [0.62666739],
       [1.67848387],
       [1.81829381],
       [0.85855153],
       [0.46202606],
       [1.72129072],
       [1.99271339]])
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00
  * region   (region) int64 53</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>region</span>: 1</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-79f7c3df-7700-44dd-b75d-78808d24ab9b' class='xr-array-in' type='checkbox' checked><label for='section-79f7c3df-7700-44dd-b75d-78808d24ab9b' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>2.424 1.115 0.5635 1.42 2.1 0.9975 ... 1.818 0.8586 0.462 1.721 1.993</span></div><div class='xr-array-data'><pre>array([[2.42445398],
       [1.1149551 ],
       [0.56349408],
       [1.41986191],
       [2.10024405],
       [0.99747663],
       [0.74377694],
       [1.67514298],
       [1.65447404],
       [0.6276056 ],
       [0.30815426],
       [1.46946358],
       [1.82464189],
       [1.19897048],
       [0.32238954],
       [1.51911652],
       [2.03105749],
       [1.18102475],
       [0.23554512],
       [1.7812482 ],
...
       [1.04313289],
       [0.54936444],
       [1.29146021],
       [2.11720145],
       [0.86377328],
       [0.17050946],
       [1.50163027],
       [2.07188164],
       [1.04584555],
       [0.58235629],
       [1.44673595],
       [2.39297506],
       [1.09318667],
       [0.62666739],
       [1.67848387],
       [1.81829381],
       [0.85855153],
       [0.46202606],
       [1.72129072],
       [1.99271339]])</pre></div></div></li><li class='xr-section-item'><input id='section-66e75128-0f31-402f-bfbd-e2ea3c664524' class='xr-section-summary-in' type='checkbox'  checked><label for='section-66e75128-0f31-402f-bfbd-e2ea3c664524' class='xr-section-summary' >Coordinates: <span>(2)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-915a529c-844b-4b9c-81e7-02c56df6885e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-915a529c-844b-4b9c-81e7-02c56df6885e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0ed3b76c-5120-4cd0-b4b7-fb248f5b4e64' class='xr-var-data-in' type='checkbox'><label for='data-0ed3b76c-5120-4cd0-b4b7-fb248f5b4e64' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53</div><input id='attrs-2832e750-337a-4292-b3f4-54fc81d25356' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2832e750-337a-4292-b3f4-54fc81d25356' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4029e99d-183c-4736-8e1c-61e618d41910' class='xr-var-data-in' type='checkbox'><label for='data-4029e99d-183c-4736-8e1c-61e618d41910' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-123391aa-1949-4c18-a214-bd879e75c5a5' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-123391aa-1949-4c18-a214-bd879e75c5a5' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





Summary values for an AOI by season
Over the entire time period.

# TODO -- look into this more... 

{:.input}
```python
# This returns 481 values. i'm not sure what this did
cali_temp.resample(time='QS-DEC').mean(["lat", "lon"])
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 481)&gt;
array([283.21924, 285.52246, 286.92047, 288.83652, 291.1661 , 301.3123 ,
       303.25623, 308.98602, 308.59595, 302.95462, 295.75073, 285.60028,
       284.82547, 283.63202, 286.1371 , 291.85513, 296.00623, 301.4612 ,
       303.75082, 309.11307, 308.96286, 303.78427, 298.15125, 285.1043 ,
       284.23212, 284.83176, 287.8692 , 292.7199 , 295.0182 , 301.58356,
       303.45746, 309.46057, 307.94745, 304.88913, 299.24423, 292.28262,
       286.4731 , 286.9489 , 285.23145, 291.6242 , 296.045  , 296.2252 ,
       303.6182 , 307.58627, 308.0848 , 305.29395, 300.27798, 288.33307,
       285.92957, 284.98907, 284.29556, 290.93335, 295.83243, 298.64728,
       305.6518 , 307.69888, 308.05542, 303.76172, 298.9711 , 289.81213,
       287.7474 , 285.22812, 289.00162, 293.67963, 295.7007 , 299.373  ,
       303.32684, 309.0597 , 307.65427, 305.34555, 297.03424, 288.29202,
       284.83847, 286.99207, 287.36856, 293.637  , 296.7503 , 301.32114,
       303.16147, 308.41632, 307.7254 , 304.27255, 301.30313, 290.8002 ,
       286.68057, 285.20572, 286.23407, 292.53345, 292.9853 , 296.5115 ,
       304.29962, 309.5059 , 306.46463, 303.65265, 297.37973, 285.58542,
       282.9543 , 286.0591 , 290.04913, 292.44077, 292.8973 , 297.31198,
       302.21396, 309.38556, 306.34305, 304.32965, 298.557  , 287.93753,
       287.01315, 289.93137, 288.96445, 290.9254 , 294.0334 , 300.57007,
       302.70355, 308.53555, 306.53568, 304.2551 , 296.75525, 289.12134,
...
       305.72543, 309.60828, 308.60153, 301.39102, 299.23123, 290.6055 ,
       287.74747, 283.30704, 286.2806 , 289.90445, 293.3539 , 298.7887 ,
       303.3212 , 306.20465, 307.40298, 302.32056, 297.44836, 289.02322,
       284.73126, 288.46088, 291.00488, 294.40692, 289.27728, 300.95966,
       305.52023, 310.3775 , 308.43546, 303.5837 , 295.1606 , 286.96262,
       286.72882, 289.52655, 287.363  , 287.99387, 295.43845, 300.4557 ,
       306.3647 , 308.2086 , 307.90295, 305.35043, 297.09253, 289.6145 ,
       286.43567, 284.48492, 289.18884, 293.6479 , 297.68906, 303.15677,
       305.07208, 308.68054, 308.36038, 304.9792 , 297.1523 , 290.15298,
       286.68393, 287.527  , 285.7652 , 293.1749 , 296.29672, 297.88184,
       302.63672, 307.98203, 307.5168 , 304.05786, 295.06503, 289.55823,
       281.70554, 285.95563, 291.816  , 295.4631 , 292.56195, 302.07297,
       308.0311 , 309.04053, 309.00192, 305.75046, 299.68695, 289.94162,
       288.184  , 287.90863, 288.87354, 293.49466, 298.28757, 300.6726 ,
       305.06854, 309.19012, 308.71756, 304.43915, 300.01627, 291.59586,
       285.68298, 285.05856, 284.9753 , 294.47025, 294.19205, 304.07147,
       303.72116, 307.20517, 307.45676, 304.69077, 297.34164, 288.46786,
       288.02673, 287.43356, 288.71194, 293.3253 , 293.74182, 300.42047,
       305.63116, 310.22174, 308.37158, 303.37503, 302.5817 , 288.75165,
       287.9368 ], dtype=float32)
Dimensions without coordinates: time</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span>time</span>: 481</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-f426c85d-59d8-418d-bed1-d88cf8c0aaff' class='xr-array-in' type='checkbox' checked><label for='section-f426c85d-59d8-418d-bed1-d88cf8c0aaff' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>283.21924 285.52246 286.92047 ... 302.5817 288.75165 287.9368</span></div><div class='xr-array-data'><pre>array([283.21924, 285.52246, 286.92047, 288.83652, 291.1661 , 301.3123 ,
       303.25623, 308.98602, 308.59595, 302.95462, 295.75073, 285.60028,
       284.82547, 283.63202, 286.1371 , 291.85513, 296.00623, 301.4612 ,
       303.75082, 309.11307, 308.96286, 303.78427, 298.15125, 285.1043 ,
       284.23212, 284.83176, 287.8692 , 292.7199 , 295.0182 , 301.58356,
       303.45746, 309.46057, 307.94745, 304.88913, 299.24423, 292.28262,
       286.4731 , 286.9489 , 285.23145, 291.6242 , 296.045  , 296.2252 ,
       303.6182 , 307.58627, 308.0848 , 305.29395, 300.27798, 288.33307,
       285.92957, 284.98907, 284.29556, 290.93335, 295.83243, 298.64728,
       305.6518 , 307.69888, 308.05542, 303.76172, 298.9711 , 289.81213,
       287.7474 , 285.22812, 289.00162, 293.67963, 295.7007 , 299.373  ,
       303.32684, 309.0597 , 307.65427, 305.34555, 297.03424, 288.29202,
       284.83847, 286.99207, 287.36856, 293.637  , 296.7503 , 301.32114,
       303.16147, 308.41632, 307.7254 , 304.27255, 301.30313, 290.8002 ,
       286.68057, 285.20572, 286.23407, 292.53345, 292.9853 , 296.5115 ,
       304.29962, 309.5059 , 306.46463, 303.65265, 297.37973, 285.58542,
       282.9543 , 286.0591 , 290.04913, 292.44077, 292.8973 , 297.31198,
       302.21396, 309.38556, 306.34305, 304.32965, 298.557  , 287.93753,
       287.01315, 289.93137, 288.96445, 290.9254 , 294.0334 , 300.57007,
       302.70355, 308.53555, 306.53568, 304.2551 , 296.75525, 289.12134,
...
       305.72543, 309.60828, 308.60153, 301.39102, 299.23123, 290.6055 ,
       287.74747, 283.30704, 286.2806 , 289.90445, 293.3539 , 298.7887 ,
       303.3212 , 306.20465, 307.40298, 302.32056, 297.44836, 289.02322,
       284.73126, 288.46088, 291.00488, 294.40692, 289.27728, 300.95966,
       305.52023, 310.3775 , 308.43546, 303.5837 , 295.1606 , 286.96262,
       286.72882, 289.52655, 287.363  , 287.99387, 295.43845, 300.4557 ,
       306.3647 , 308.2086 , 307.90295, 305.35043, 297.09253, 289.6145 ,
       286.43567, 284.48492, 289.18884, 293.6479 , 297.68906, 303.15677,
       305.07208, 308.68054, 308.36038, 304.9792 , 297.1523 , 290.15298,
       286.68393, 287.527  , 285.7652 , 293.1749 , 296.29672, 297.88184,
       302.63672, 307.98203, 307.5168 , 304.05786, 295.06503, 289.55823,
       281.70554, 285.95563, 291.816  , 295.4631 , 292.56195, 302.07297,
       308.0311 , 309.04053, 309.00192, 305.75046, 299.68695, 289.94162,
       288.184  , 287.90863, 288.87354, 293.49466, 298.28757, 300.6726 ,
       305.06854, 309.19012, 308.71756, 304.43915, 300.01627, 291.59586,
       285.68298, 285.05856, 284.9753 , 294.47025, 294.19205, 304.07147,
       303.72116, 307.20517, 307.45676, 304.69077, 297.34164, 288.46786,
       288.02673, 287.43356, 288.71194, 293.3253 , 293.74182, 300.42047,
       305.63116, 310.22174, 308.37158, 303.37503, 302.5817 , 288.75165,
       287.9368 ], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-95bd98a2-3f9f-4bc6-8f43-6550127960a1' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-95bd98a2-3f9f-4bc6-8f43-6550127960a1' class='xr-section-summary'  title='Expand/collapse section'>Coordinates: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'></ul></div></li><li class='xr-section-item'><input id='section-8d5b6dd1-fe08-46eb-b6ed-a7606dc1be66' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-8d5b6dd1-fe08-46eb-b6ed-a7606dc1be66' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
# This gives me an array represenging the mean for each pixel across all days in each season
q_resample = cali_temp.resample(time='QS-DEC', keep_attrs=True).mean()
```

{:.input}
```python
q_resample
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 161, lat: 227, lon: 246)&gt;
array([[[      nan,       nan,       nan, ..., 293.64474, 293.8548 ,
         293.97183],
        [      nan,       nan,       nan, ..., 294.09103, 294.24606,
         294.30237],
        [      nan,       nan,       nan, ..., 294.3073 , 294.2671 ,
         294.27966],
        ...,
        [      nan,       nan,       nan, ..., 276.8613 , 277.01025,
         277.0203 ],
        [      nan,       nan,       nan, ..., 276.44614, 276.3746 ,
         276.9216 ],
        [      nan, 288.37057, 288.397  , ..., 275.68213, 275.4948 ,
         276.20026]],

       [[      nan,       nan,       nan, ..., 304.58087, 304.67538,
         304.78232],
        [      nan,       nan,       nan, ..., 304.83682, 304.8269 ,
         304.92352],
        [      nan,       nan,       nan, ..., 304.8834 , 304.78452,
         304.88806],
...
        [      nan,       nan,       nan, ..., 293.30728, 293.54752,
         293.76645],
        [      nan,       nan,       nan, ..., 292.53418, 292.55142,
         293.4209 ],
        [      nan, 292.97745, 293.18143, ..., 291.5775 , 291.34177,
         292.28836]],

       [[      nan,       nan,       nan, ..., 296.90482, 297.07462,
         297.19067],
        [      nan,       nan,       nan, ..., 297.2858 , 297.44974,
         297.48822],
        [      nan,       nan,       nan, ..., 297.48462, 297.45352,
         297.43854],
        ...,
        [      nan,       nan,       nan, ..., 280.73175, 280.886  ,
         280.91376],
        [      nan,       nan,       nan, ..., 280.28772, 280.1848 ,
         280.74896],
        [      nan, 289.49255, 289.53207, ..., 279.4919 , 279.2892 ,
         279.9502 ]]], dtype=float32)
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-bee2e7cf-22d8-4b4e-b7e6-125e13551115' class='xr-array-in' type='checkbox' checked><label for='section-bee2e7cf-22d8-4b4e-b7e6-125e13551115' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan ... 278.92868 279.40625 279.4919 279.2892 279.9502</span></div><div class='xr-array-data'><pre>array([[[      nan,       nan,       nan, ..., 293.64474, 293.8548 ,
         293.97183],
        [      nan,       nan,       nan, ..., 294.09103, 294.24606,
         294.30237],
        [      nan,       nan,       nan, ..., 294.3073 , 294.2671 ,
         294.27966],
        ...,
        [      nan,       nan,       nan, ..., 276.8613 , 277.01025,
         277.0203 ],
        [      nan,       nan,       nan, ..., 276.44614, 276.3746 ,
         276.9216 ],
        [      nan, 288.37057, 288.397  , ..., 275.68213, 275.4948 ,
         276.20026]],

       [[      nan,       nan,       nan, ..., 304.58087, 304.67538,
         304.78232],
        [      nan,       nan,       nan, ..., 304.83682, 304.8269 ,
         304.92352],
        [      nan,       nan,       nan, ..., 304.8834 , 304.78452,
         304.88806],
...
        [      nan,       nan,       nan, ..., 293.30728, 293.54752,
         293.76645],
        [      nan,       nan,       nan, ..., 292.53418, 292.55142,
         293.4209 ],
        [      nan, 292.97745, 293.18143, ..., 291.5775 , 291.34177,
         292.28836]],

       [[      nan,       nan,       nan, ..., 296.90482, 297.07462,
         297.19067],
        [      nan,       nan,       nan, ..., 297.2858 , 297.44974,
         297.48822],
        [      nan,       nan,       nan, ..., 297.48462, 297.45352,
         297.43854],
        ...,
        [      nan,       nan,       nan, ..., 280.73175, 280.886  ,
         280.91376],
        [      nan,       nan,       nan, ..., 280.28772, 280.1848 ,
         280.74896],
        [      nan, 289.49255, 289.53207, ..., 279.4919 , 279.2892 ,
         279.9502 ]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-d1174797-d75a-42c6-841e-340ab3bb890c' class='xr-section-summary-in' type='checkbox'  checked><label for='section-d1174797-d75a-42c6-841e-340ab3bb890c' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-7db32ae3-78e7-40d8-b355-b29a12ec7ed2' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-7db32ae3-78e7-40d8-b355-b29a12ec7ed2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-df5ac8ed-591d-4b36-b22c-c0c9a2781a8e' class='xr-var-data-in' type='checkbox'><label for='data-df5ac8ed-591d-4b36-b22c-c0c9a2781a8e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-ca99dbff-7c60-4594-a2d1-4ee6ba8f9a1c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ca99dbff-7c60-4594-a2d1-4ee6ba8f9a1c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bac6f80d-512b-45fd-9efe-1cc7915e4bb3' class='xr-var-data-in' type='checkbox'><label for='data-bac6f80d-512b-45fd-9efe-1cc7915e4bb3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-25451ef5-e979-4cc9-a74c-f8729f7abd4b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-25451ef5-e979-4cc9-a74c-f8729f7abd4b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5020e50b-25ee-42c5-bf79-160676194856' class='xr-var-data-in' type='checkbox'><label for='data-5020e50b-25ee-42c5-bf79-160676194856' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-cef8db13-41cf-4471-9d8d-5891f11b813a' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-cef8db13-41cf-4471-9d8d-5891f11b813a' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
q_resample.groupby('time').mean(["lat", "lon"])
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 161)&gt;
array([285.22076, 293.77164, 306.94604, 294.76855, 284.86487, 296.44083,
       307.27557, 295.68   , 285.64435, 296.44055, 306.9551 , 298.80533,
       286.2178 , 294.63147, 306.42978, 297.96832, 285.0714 , 295.1377 ,
       307.13535, 297.51498, 287.3257 , 296.25107, 306.68024, 296.8906 ,
       286.3997 , 297.23615, 306.43442, 298.79193, 286.04013, 294.01013,
       306.7567 , 295.53928, 286.3542 , 294.21667, 305.98087, 296.94144,
       288.63632, 295.1763 , 305.9249 , 296.71054, 283.27634, 296.20123,
       306.70065, 297.24802, 284.7609 , 295.74963, 308.0916 , 297.1863 ,
       286.29242, 297.11542, 306.78107, 300.40024, 288.92178, 294.44333,
       308.80652, 297.71222, 286.226  , 298.16696, 306.80563, 295.18463,
       283.7464 , 293.18933, 306.6747 , 294.42184, 283.6219 , 295.45923,
       308.2704 , 295.74802, 286.4943 , 293.2021 , 305.80734, 295.75333,
       285.90787, 298.06155, 306.27576, 297.38858, 285.0301 , 293.52307,
       306.63974, 298.58563, 289.48148, 297.53348, 306.5504 , 297.1229 ,
       286.8561 , 294.89792, 304.90878, 295.97888, 289.25128, 296.38586,
       307.0961 , 296.60086, 286.261  , 293.6666 , 306.81085, 296.59137,
       287.29486, 294.013  , 308.00278, 298.8735 , 287.71368, 298.1353 ,
       306.09607, 295.2343 , 286.25723, 294.7974 , 307.3095 , 296.9137 ,
       286.39087, 294.27072, 307.27878, 295.2093 , 284.6368 , 294.06717,
       307.44168, 296.85178, 286.59613, 295.7446 , 306.67963, 295.83432,
       286.7176 , 295.14847, 307.9784 , 297.0759 , 285.77838, 294.0157 ,
       305.64297, 296.26407, 288.06567, 294.8813 , 308.11105, 295.23566,
       287.87277, 294.62933, 307.49207, 297.35245, 286.7032 , 298.16455,
       307.371  , 297.42816, 286.65872, 295.7845 , 306.04517, 296.22702,
       286.49237, 296.69934, 308.6912 , 298.45972, 288.32202, 297.48495,
       307.65875, 298.68378, 285.23895, 297.57794, 306.1277 , 296.83344,
       288.0574 , 295.8292 , 308.07483, 298.2361 , 287.9368 ],
      dtype=float32)
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-1e3b4e04-c19c-4bdb-a903-7523b6532e68' class='xr-array-in' type='checkbox' checked><label for='section-1e3b4e04-c19c-4bdb-a903-7523b6532e68' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>285.22076 293.77164 306.94604 ... 308.07483 298.2361 287.9368</span></div><div class='xr-array-data'><pre>array([285.22076, 293.77164, 306.94604, 294.76855, 284.86487, 296.44083,
       307.27557, 295.68   , 285.64435, 296.44055, 306.9551 , 298.80533,
       286.2178 , 294.63147, 306.42978, 297.96832, 285.0714 , 295.1377 ,
       307.13535, 297.51498, 287.3257 , 296.25107, 306.68024, 296.8906 ,
       286.3997 , 297.23615, 306.43442, 298.79193, 286.04013, 294.01013,
       306.7567 , 295.53928, 286.3542 , 294.21667, 305.98087, 296.94144,
       288.63632, 295.1763 , 305.9249 , 296.71054, 283.27634, 296.20123,
       306.70065, 297.24802, 284.7609 , 295.74963, 308.0916 , 297.1863 ,
       286.29242, 297.11542, 306.78107, 300.40024, 288.92178, 294.44333,
       308.80652, 297.71222, 286.226  , 298.16696, 306.80563, 295.18463,
       283.7464 , 293.18933, 306.6747 , 294.42184, 283.6219 , 295.45923,
       308.2704 , 295.74802, 286.4943 , 293.2021 , 305.80734, 295.75333,
       285.90787, 298.06155, 306.27576, 297.38858, 285.0301 , 293.52307,
       306.63974, 298.58563, 289.48148, 297.53348, 306.5504 , 297.1229 ,
       286.8561 , 294.89792, 304.90878, 295.97888, 289.25128, 296.38586,
       307.0961 , 296.60086, 286.261  , 293.6666 , 306.81085, 296.59137,
       287.29486, 294.013  , 308.00278, 298.8735 , 287.71368, 298.1353 ,
       306.09607, 295.2343 , 286.25723, 294.7974 , 307.3095 , 296.9137 ,
       286.39087, 294.27072, 307.27878, 295.2093 , 284.6368 , 294.06717,
       307.44168, 296.85178, 286.59613, 295.7446 , 306.67963, 295.83432,
       286.7176 , 295.14847, 307.9784 , 297.0759 , 285.77838, 294.0157 ,
       305.64297, 296.26407, 288.06567, 294.8813 , 308.11105, 295.23566,
       287.87277, 294.62933, 307.49207, 297.35245, 286.7032 , 298.16455,
       307.371  , 297.42816, 286.65872, 295.7845 , 306.04517, 296.22702,
       286.49237, 296.69934, 308.6912 , 298.45972, 288.32202, 297.48495,
       307.65875, 298.68378, 285.23895, 297.57794, 306.1277 , 296.83344,
       288.0574 , 295.8292 , 308.07483, 298.2361 , 287.9368 ],
      dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-23ac52ec-c520-4cd9-98a3-5d48762b8527' class='xr-section-summary-in' type='checkbox'  checked><label for='section-23ac52ec-c520-4cd9-98a3-5d48762b8527' class='xr-section-summary' >Coordinates: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-2272937f-2ecf-4d8c-a9d6-58ecf7ea22eb' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2272937f-2ecf-4d8c-a9d6-58ecf7ea22eb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9636e9b4-757b-46b6-8a5b-6214f393ee69' class='xr-var-data-in' type='checkbox'><label for='data-9636e9b4-757b-46b6-8a5b-6214f393ee69' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-252076d4-1161-4087-bcbd-056289fb4e7b' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-252076d4-1161-4087-bcbd-056289fb4e7b' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
# If i want a single value per season i'd have to group by
q_resample
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 161, lat: 227, lon: 246)&gt;
array([[[      nan,       nan,       nan, ..., 293.64474, 293.8548 ,
         293.97183],
        [      nan,       nan,       nan, ..., 294.09103, 294.24606,
         294.30237],
        [      nan,       nan,       nan, ..., 294.3073 , 294.2671 ,
         294.27966],
        ...,
        [      nan,       nan,       nan, ..., 276.8613 , 277.01025,
         277.0203 ],
        [      nan,       nan,       nan, ..., 276.44614, 276.3746 ,
         276.9216 ],
        [      nan, 288.37057, 288.397  , ..., 275.68213, 275.4948 ,
         276.20026]],

       [[      nan,       nan,       nan, ..., 304.58087, 304.67538,
         304.78232],
        [      nan,       nan,       nan, ..., 304.83682, 304.8269 ,
         304.92352],
        [      nan,       nan,       nan, ..., 304.8834 , 304.78452,
         304.88806],
...
        [      nan,       nan,       nan, ..., 293.30728, 293.54752,
         293.76645],
        [      nan,       nan,       nan, ..., 292.53418, 292.55142,
         293.4209 ],
        [      nan, 292.97745, 293.18143, ..., 291.5775 , 291.34177,
         292.28836]],

       [[      nan,       nan,       nan, ..., 296.90482, 297.07462,
         297.19067],
        [      nan,       nan,       nan, ..., 297.2858 , 297.44974,
         297.48822],
        [      nan,       nan,       nan, ..., 297.48462, 297.45352,
         297.43854],
        ...,
        [      nan,       nan,       nan, ..., 280.73175, 280.886  ,
         280.91376],
        [      nan,       nan,       nan, ..., 280.28772, 280.1848 ,
         280.74896],
        [      nan, 289.49255, 289.53207, ..., 279.4919 , 279.2892 ,
         279.9502 ]]], dtype=float32)
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-71cd4c7d-f0cc-4160-b9ef-2d662723d0f8' class='xr-array-in' type='checkbox' checked><label for='section-71cd4c7d-f0cc-4160-b9ef-2d662723d0f8' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan ... 278.92868 279.40625 279.4919 279.2892 279.9502</span></div><div class='xr-array-data'><pre>array([[[      nan,       nan,       nan, ..., 293.64474, 293.8548 ,
         293.97183],
        [      nan,       nan,       nan, ..., 294.09103, 294.24606,
         294.30237],
        [      nan,       nan,       nan, ..., 294.3073 , 294.2671 ,
         294.27966],
        ...,
        [      nan,       nan,       nan, ..., 276.8613 , 277.01025,
         277.0203 ],
        [      nan,       nan,       nan, ..., 276.44614, 276.3746 ,
         276.9216 ],
        [      nan, 288.37057, 288.397  , ..., 275.68213, 275.4948 ,
         276.20026]],

       [[      nan,       nan,       nan, ..., 304.58087, 304.67538,
         304.78232],
        [      nan,       nan,       nan, ..., 304.83682, 304.8269 ,
         304.92352],
        [      nan,       nan,       nan, ..., 304.8834 , 304.78452,
         304.88806],
...
        [      nan,       nan,       nan, ..., 293.30728, 293.54752,
         293.76645],
        [      nan,       nan,       nan, ..., 292.53418, 292.55142,
         293.4209 ],
        [      nan, 292.97745, 293.18143, ..., 291.5775 , 291.34177,
         292.28836]],

       [[      nan,       nan,       nan, ..., 296.90482, 297.07462,
         297.19067],
        [      nan,       nan,       nan, ..., 297.2858 , 297.44974,
         297.48822],
        [      nan,       nan,       nan, ..., 297.48462, 297.45352,
         297.43854],
        ...,
        [      nan,       nan,       nan, ..., 280.73175, 280.886  ,
         280.91376],
        [      nan,       nan,       nan, ..., 280.28772, 280.1848 ,
         280.74896],
        [      nan, 289.49255, 289.53207, ..., 279.4919 , 279.2892 ,
         279.9502 ]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-4d35851f-cd09-47d5-ad47-f96746a822d8' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4d35851f-cd09-47d5-ad47-f96746a822d8' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-5c963128-24f3-4b81-8493-4e0a890e4e6b' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5c963128-24f3-4b81-8493-4e0a890e4e6b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-497e1af8-12d7-4443-ae19-9e7d27ba756e' class='xr-var-data-in' type='checkbox'><label for='data-497e1af8-12d7-4443-ae19-9e7d27ba756e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-3333659c-5845-49ab-b568-ba67cdc2fb44' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3333659c-5845-49ab-b568-ba67cdc2fb44' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9a7328a0-43e1-44b8-828a-79086aab6e60' class='xr-var-data-in' type='checkbox'><label for='data-9a7328a0-43e1-44b8-828a-79086aab6e60' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-47dd153f-61c5-47f0-a503-c4bbc00ab601' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-47dd153f-61c5-47f0-a503-c4bbc00ab601' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-603e5e1c-b771-4db3-84e3-fef84a1e5b05' class='xr-var-data-in' type='checkbox'><label for='data-603e5e1c-b771-4db3-84e3-fef84a1e5b05' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-6c44e572-3ecf-42e0-ab64-7d02adf111c9' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-6c44e572-3ecf-42e0-ab64-7d02adf111c9' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
# It looks like this is a way to calculate summary by season
# without all of the silly loops i used above
# https://stackoverflow.com/questions/59234745/is-there-any-easy-where-way-to-compute-seasonal-mean-with-xarray
result = ((cali_temp * month_length).resample(time='QS-DEC').sum() /
          month_length.resample(time='QS-DEC').sum())
result
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 161, lat: 227, lon: 246)&gt;
array([[[  0.        ,   0.        ,   0.        , ..., 293.5801985 ,
         293.7889974 , 293.90551826],
        [  0.        ,   0.        ,   0.        , ..., 294.02546794,
         294.18081868, 294.23653463],
        [  0.        ,   0.        ,   0.        , ..., 294.24290195,
         294.20305481, 294.21427036],
        ...,
        [  0.        ,   0.        ,   0.        , ..., 276.85069716,
         276.99935404, 277.01003689],
        [  0.        ,   0.        ,   0.        , ..., 276.43595988,
         276.36333211, 276.91017863],
        [  0.        , 288.33420851, 288.36123454, ..., 275.67130907,
         275.48182136, 276.18686761]],

       [[  0.        ,   0.        ,   0.        , ..., 304.58926591,
         304.68364749, 304.79025633],
        [  0.        ,   0.        ,   0.        , ..., 304.84524636,
         304.83542898, 304.93177862],
        [  0.        ,   0.        ,   0.        , ..., 304.89216647,
         304.79319697, 304.89644955],
...
        [  0.        ,   0.        ,   0.        , ..., 293.35862682,
         293.59940984, 293.81863403],
        [  0.        ,   0.        ,   0.        , ..., 292.58462826,
         292.60206051, 293.47256302],
        [  0.        , 292.99421843, 293.19931299, ..., 291.62713992,
         291.39074942, 292.33850332]],

       [[  0.        ,   0.        ,   0.        , ..., 296.90481567,
         297.07461548, 297.19067383],
        [  0.        ,   0.        ,   0.        , ..., 297.28579712,
         297.44973755, 297.48822021],
        [  0.        ,   0.        ,   0.        , ..., 297.48461914,
         297.45352173, 297.4385376 ],
        ...,
        [  0.        ,   0.        ,   0.        , ..., 280.73175049,
         280.88598633, 280.91375732],
        [  0.        ,   0.        ,   0.        , ..., 280.28771973,
         280.18481445, 280.7489624 ],
        [  0.        , 289.49255371, 289.53207397, ..., 279.49191284,
         279.28921509, 279.95019531]]])
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-fb54e100-54a7-4f0f-a616-a64eb812000f' class='xr-array-in' type='checkbox' checked><label for='section-fb54e100-54a7-4f0f-a616-a64eb812000f' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>0.0 0.0 0.0 0.0 0.0 0.0 0.0 ... 280.3 278.9 279.4 279.5 279.3 280.0</span></div><div class='xr-array-data'><pre>array([[[  0.        ,   0.        ,   0.        , ..., 293.5801985 ,
         293.7889974 , 293.90551826],
        [  0.        ,   0.        ,   0.        , ..., 294.02546794,
         294.18081868, 294.23653463],
        [  0.        ,   0.        ,   0.        , ..., 294.24290195,
         294.20305481, 294.21427036],
        ...,
        [  0.        ,   0.        ,   0.        , ..., 276.85069716,
         276.99935404, 277.01003689],
        [  0.        ,   0.        ,   0.        , ..., 276.43595988,
         276.36333211, 276.91017863],
        [  0.        , 288.33420851, 288.36123454, ..., 275.67130907,
         275.48182136, 276.18686761]],

       [[  0.        ,   0.        ,   0.        , ..., 304.58926591,
         304.68364749, 304.79025633],
        [  0.        ,   0.        ,   0.        , ..., 304.84524636,
         304.83542898, 304.93177862],
        [  0.        ,   0.        ,   0.        , ..., 304.89216647,
         304.79319697, 304.89644955],
...
        [  0.        ,   0.        ,   0.        , ..., 293.35862682,
         293.59940984, 293.81863403],
        [  0.        ,   0.        ,   0.        , ..., 292.58462826,
         292.60206051, 293.47256302],
        [  0.        , 292.99421843, 293.19931299, ..., 291.62713992,
         291.39074942, 292.33850332]],

       [[  0.        ,   0.        ,   0.        , ..., 296.90481567,
         297.07461548, 297.19067383],
        [  0.        ,   0.        ,   0.        , ..., 297.28579712,
         297.44973755, 297.48822021],
        [  0.        ,   0.        ,   0.        , ..., 297.48461914,
         297.45352173, 297.4385376 ],
        ...,
        [  0.        ,   0.        ,   0.        , ..., 280.73175049,
         280.88598633, 280.91375732],
        [  0.        ,   0.        ,   0.        , ..., 280.28771973,
         280.18481445, 280.7489624 ],
        [  0.        , 289.49255371, 289.53207397, ..., 279.49191284,
         279.28921509, 279.95019531]]])</pre></div></div></li><li class='xr-section-item'><input id='section-b9399bc4-5fb6-4eee-8558-98edbfcd3174' class='xr-section-summary-in' type='checkbox'  checked><label for='section-b9399bc4-5fb6-4eee-8558-98edbfcd3174' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-512af8ac-057f-4085-909d-157034fa0e61' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-512af8ac-057f-4085-909d-157034fa0e61' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cd786311-7328-4799-91b7-d135e8a370d3' class='xr-var-data-in' type='checkbox'><label for='data-cd786311-7328-4799-91b7-d135e8a370d3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-3d550c7e-10af-40d3-8b4a-26c299760c17' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3d550c7e-10af-40d3-8b4a-26c299760c17' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ccc505bb-1550-4d39-ac1d-598359251e33' class='xr-var-data-in' type='checkbox'><label for='data-ccc505bb-1550-4d39-ac1d-598359251e33' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-d73e0291-7e8a-4323-b52d-0504c7670e10' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d73e0291-7e8a-4323-b52d-0504c7670e10' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-58a092bf-f1bb-431e-ab9a-e80bc2cdf7ed' class='xr-var-data-in' type='checkbox'><label for='data-58a092bf-f1bb-431e-ab9a-e80bc2cdf7ed' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-107bb3f8-c3c9-45ca-a776-76dc421f6a9d' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-107bb3f8-c3c9-45ca-a776-76dc421f6a9d' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
result
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 161, lat: 227, lon: 246)&gt;
array([[[  0.        ,   0.        ,   0.        , ..., 293.5801985 ,
         293.7889974 , 293.90551826],
        [  0.        ,   0.        ,   0.        , ..., 294.02546794,
         294.18081868, 294.23653463],
        [  0.        ,   0.        ,   0.        , ..., 294.24290195,
         294.20305481, 294.21427036],
        ...,
        [  0.        ,   0.        ,   0.        , ..., 276.85069716,
         276.99935404, 277.01003689],
        [  0.        ,   0.        ,   0.        , ..., 276.43595988,
         276.36333211, 276.91017863],
        [  0.        , 288.33420851, 288.36123454, ..., 275.67130907,
         275.48182136, 276.18686761]],

       [[  0.        ,   0.        ,   0.        , ..., 304.58926591,
         304.68364749, 304.79025633],
        [  0.        ,   0.        ,   0.        , ..., 304.84524636,
         304.83542898, 304.93177862],
        [  0.        ,   0.        ,   0.        , ..., 304.89216647,
         304.79319697, 304.89644955],
...
        [  0.        ,   0.        ,   0.        , ..., 293.35862682,
         293.59940984, 293.81863403],
        [  0.        ,   0.        ,   0.        , ..., 292.58462826,
         292.60206051, 293.47256302],
        [  0.        , 292.99421843, 293.19931299, ..., 291.62713992,
         291.39074942, 292.33850332]],

       [[  0.        ,   0.        ,   0.        , ..., 296.90481567,
         297.07461548, 297.19067383],
        [  0.        ,   0.        ,   0.        , ..., 297.28579712,
         297.44973755, 297.48822021],
        [  0.        ,   0.        ,   0.        , ..., 297.48461914,
         297.45352173, 297.4385376 ],
        ...,
        [  0.        ,   0.        ,   0.        , ..., 280.73175049,
         280.88598633, 280.91375732],
        [  0.        ,   0.        ,   0.        , ..., 280.28771973,
         280.18481445, 280.7489624 ],
        [  0.        , 289.49255371, 289.53207397, ..., 279.49191284,
         279.28921509, 279.95019531]]])
Coordinates:
  * time     (time) object 2059-12-01 00:00:00 ... 2099-12-01 00:00:00
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-5b2809c9-3f9e-4eca-ab26-d74369e08ee3' class='xr-array-in' type='checkbox' checked><label for='section-5b2809c9-3f9e-4eca-ab26-d74369e08ee3' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>0.0 0.0 0.0 0.0 0.0 0.0 0.0 ... 280.3 278.9 279.4 279.5 279.3 280.0</span></div><div class='xr-array-data'><pre>array([[[  0.        ,   0.        ,   0.        , ..., 293.5801985 ,
         293.7889974 , 293.90551826],
        [  0.        ,   0.        ,   0.        , ..., 294.02546794,
         294.18081868, 294.23653463],
        [  0.        ,   0.        ,   0.        , ..., 294.24290195,
         294.20305481, 294.21427036],
        ...,
        [  0.        ,   0.        ,   0.        , ..., 276.85069716,
         276.99935404, 277.01003689],
        [  0.        ,   0.        ,   0.        , ..., 276.43595988,
         276.36333211, 276.91017863],
        [  0.        , 288.33420851, 288.36123454, ..., 275.67130907,
         275.48182136, 276.18686761]],

       [[  0.        ,   0.        ,   0.        , ..., 304.58926591,
         304.68364749, 304.79025633],
        [  0.        ,   0.        ,   0.        , ..., 304.84524636,
         304.83542898, 304.93177862],
        [  0.        ,   0.        ,   0.        , ..., 304.89216647,
         304.79319697, 304.89644955],
...
        [  0.        ,   0.        ,   0.        , ..., 293.35862682,
         293.59940984, 293.81863403],
        [  0.        ,   0.        ,   0.        , ..., 292.58462826,
         292.60206051, 293.47256302],
        [  0.        , 292.99421843, 293.19931299, ..., 291.62713992,
         291.39074942, 292.33850332]],

       [[  0.        ,   0.        ,   0.        , ..., 296.90481567,
         297.07461548, 297.19067383],
        [  0.        ,   0.        ,   0.        , ..., 297.28579712,
         297.44973755, 297.48822021],
        [  0.        ,   0.        ,   0.        , ..., 297.48461914,
         297.45352173, 297.4385376 ],
        ...,
        [  0.        ,   0.        ,   0.        , ..., 280.73175049,
         280.88598633, 280.91375732],
        [  0.        ,   0.        ,   0.        , ..., 280.28771973,
         280.18481445, 280.7489624 ],
        [  0.        , 289.49255371, 289.53207397, ..., 279.49191284,
         279.28921509, 279.95019531]]])</pre></div></div></li><li class='xr-section-item'><input id='section-1636ae39-6604-4929-a180-ef75d9cc5919' class='xr-section-summary-in' type='checkbox'  checked><label for='section-1636ae39-6604-4929-a180-ef75d9cc5919' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-fcf17165-015c-4969-95a6-d879c93cb895' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-fcf17165-015c-4969-95a6-d879c93cb895' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e1b72126-a6fb-48ca-a1be-5c85ce053621' class='xr-var-data-in' type='checkbox'><label for='data-e1b72126-a6fb-48ca-a1be-5c85ce053621' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2061, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2062, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2063, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2064, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2065, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2066, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2067, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2068, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2069, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2070, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2071, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2072, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2073, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2074, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2075, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2076, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2077, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2078, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2079, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2080, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2081, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2082, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2083, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2084, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2085, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2086, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2087, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2088, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2089, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2090, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2091, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2092, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2093, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2094, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2095, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2096, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2097, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2098, 12, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 3, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 6, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 9, 1, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-b8914b6c-6910-4e66-9c6b-e28773140e24' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b8914b6c-6910-4e66-9c6b-e28773140e24' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-14c1a8b9-f26e-40a7-a8e3-cc785a0f9c00' class='xr-var-data-in' type='checkbox'><label for='data-14c1a8b9-f26e-40a7-a8e3-cc785a0f9c00' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-0c53f678-0572-483e-a8f8-25ffc6d997dd' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0c53f678-0572-483e-a8f8-25ffc6d997dd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-193edb47-c465-4554-beea-1c3b2a208e7b' class='xr-var-data-in' type='checkbox'><label for='data-193edb47-c465-4554-beea-1c3b2a208e7b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-733a3a95-fdab-4e5c-992f-442b662c27ea' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-733a3a95-fdab-4e5c-992f-442b662c27ea' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
#r1 = mask_3D.sel(region=3)
```
