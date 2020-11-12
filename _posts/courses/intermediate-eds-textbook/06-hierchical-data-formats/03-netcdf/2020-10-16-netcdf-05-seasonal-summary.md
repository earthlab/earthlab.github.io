---
layout: single
title: "Calculate Seasonal Summary Values from Climate Data Variables Stored in NetCDF 4 Format: Work With MACA v2 Climate Data in Python"
excerpt: "Learn how to calculate seasonal summary values for MACA 2 climate data using xarray and region mask in open source Python."
authors: ['Leah Wasser']
dateCreated: 2020-10-23
modified: 2020-11-12
category: [courses]
class-lesson: ['netcdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/summarize-climate-data-by-season/
nav-title: 'Seasonal Summary'
week: 6
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
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
sns.set(font_scale=1.3)
sns.set_style("white")

# Optional - set your working directory if you wish to use the data
# accessed lower down in this notebook (the USA state boundary data)
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))
```

To begin, you can download and open up a MACA v2 netcdf file. The file below is a 
projected maximum temperature dataset downscaled using the `BNU-ESM` model for 2006-2099.

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
    coordinate_system:               WGS84,EPSG:4326</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-c3f2cf49-8828-4988-b184-9bb684bc3fcc' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-c3f2cf49-8828-4988-b184-9bb684bc3fcc' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>crs</span>: 1</li><li><span class='xr-has-index'>lat</span>: 585</li><li><span class='xr-has-index'>lon</span>: 1386</li><li><span class='xr-has-index'>time</span>: 1128</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-643d1deb-8a7d-4913-858a-87b6f571d33f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-643d1deb-8a7d-4913-858a-87b6f571d33f' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>25.06 25.1 25.15 ... 49.35 49.4</div><input id='attrs-ec3390bd-4b3b-4ee8-991a-c057e01152b3' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ec3390bd-4b3b-4ee8-991a-c057e01152b3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3ca4d785-d4c6-4035-8e3c-514c4a40d335' class='xr-var-data-in' type='checkbox'><label for='data-3ca4d785-d4c6-4035-8e3c-514c4a40d335' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([25.063078, 25.104744, 25.14641 , ..., 49.312691, 49.354359, 49.396023])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>crs</span></div><div class='xr-var-dims'>(crs)</div><div class='xr-var-dtype'>int32</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-6528918e-c0de-4bb3-b92a-d2d44c63c12e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6528918e-c0de-4bb3-b92a-d2d44c63c12e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a214190d-d21a-45c6-897c-44188563a065' class='xr-var-data-in' type='checkbox'><label for='data-a214190d-d21a-45c6-897c-44188563a065' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>grid_mapping_name :</span></dt><dd>latitude_longitude</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd></dl></div><div class='xr-var-data'><pre>array([1], dtype=int32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.2 235.3 235.3 ... 292.9 292.9</div><input id='attrs-130b06c4-c9cc-44e5-994c-b1ada8e3dd9a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-130b06c4-c9cc-44e5-994c-b1ada8e3dd9a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-601b433f-cf21-40b0-b5a5-4b4b498046ff' class='xr-var-data-in' type='checkbox'><label for='data-601b433f-cf21-40b0-b5a5-4b4b498046ff' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.227844, 235.269501, 235.311157, ..., 292.851929, 292.893585,
       292.935242])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2006-01-15 00:00:00 ... 2099-12-...</div><input id='attrs-1695178d-06b6-4f6a-a264-b7e49a423027' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1695178d-06b6-4f6a-a264-b7e49a423027' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-25aa99be-bfa2-4af8-92b9-15a03a3cdc0c' class='xr-var-data-in' type='checkbox'><label for='data-25aa99be-bfa2-4af8-92b9-15a03a3cdc0c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2006, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2006, 2, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2006, 3, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-b4cf79e4-0ed6-41b6-94be-6328b6415279' class='xr-section-summary-in' type='checkbox'  checked><label for='section-b4cf79e4-0ed6-41b6-94be-6328b6415279' class='xr-section-summary' >Data variables: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>air_temperature</span></div><div class='xr-var-dims'>(time, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-904efffa-cf02-4ae2-88c5-228d44c3e40e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-904efffa-cf02-4ae2-88c5-228d44c3e40e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-62460e70-803a-44e7-bf77-3d07efe00085' class='xr-var-data-in' type='checkbox'><label for='data-62460e70-803a-44e7-bf77-3d07efe00085' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div><div class='xr-var-data'><pre>[914593680 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-ff08385a-ad1a-41c8-8c0a-4e8f105f02d4' class='xr-section-summary-in' type='checkbox'  ><label for='section-ff08385a-ad1a-41c8-8c0a-4e8f105f02d4' class='xr-section-summary' >Attributes: <span>(46)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>Multivariate Adaptive Constructed Analogs (MACA) method, version 2.3,Dec 2013.</dd><dt><span>id :</span></dt><dd>MACAv2-METDATA</dd><dt><span>naming_authority :</span></dt><dd>edu.uidaho.reacch</dd><dt><span>Metadata_Conventions :</span></dt><dd>Unidata Dataset Discovery v1.0</dd><dt><span>Metadata_Link :</span></dt><dd></dd><dt><span>cdm_data_type :</span></dt><dd>FLOAT</dd><dt><span>title :</span></dt><dd>Monthly aggregation of downscaled daily meteorological data of Monthly Average of Daily Maximum Near-Surface Air Temperature from College of Global Change and Earth System Science, Beijing Normal University (BNU-ESM) using the run r1i1p1 of the rcp45 scenario.</dd><dt><span>summary :</span></dt><dd>This archive contains monthly downscaled meteorological and hydrological projections for the Conterminous United States at 1/24-deg resolution. These monthly values are obtained by aggregating the daily values obtained from the downscaling using the Multivariate Adaptive Constructed Analogs (MACA, Abatzoglou, 2012) statistical downscaling method with the METDATA (Abatzoglou,2013) training dataset. The downscaled meteorological variables are maximum/minimum temperature(tasmax/tasmin), maximum/minimum relative humidity (rhsmax/rhsmin),precipitation amount(pr), downward shortwave solar radiation(rsds), eastward wind(uas), northward wind(vas), and specific humidity(huss). The downscaling is based on the 365-day model outputs from different global climate models (GCMs) from Phase 5 of the Coupled Model Inter-comparison Project (CMIP3) utlizing the historical (1950-2005) and future RCP4.5/8.5(2006-2099) scenarios. </dd><dt><span>keywords :</span></dt><dd>monthly, precipitation, maximum temperature, minimum temperature, downward shortwave solar radiation, specific humidity, wind velocity, CMIP5, Gridded Meteorological Data</dd><dt><span>keywords_vocabulary :</span></dt><dd></dd><dt><span>standard_name_vocabulary :</span></dt><dd>CF-1.0</dd><dt><span>history :</span></dt><dd>No revisions.</dd><dt><span>comment :</span></dt><dd></dd><dt><span>geospatial_bounds :</span></dt><dd>POLYGON((-124.7722 25.0631,-124.7722 49.3960, -67.0648 49.3960,-67.0648, 25.0631, -124.7722,25.0631))</dd><dt><span>geospatial_lat_min :</span></dt><dd>25.0631</dd><dt><span>geospatial_lat_max :</span></dt><dd>49.3960</dd><dt><span>geospatial_lon_min :</span></dt><dd>-124.7722</dd><dt><span>geospatial_lon_max :</span></dt><dd>-67.0648</dd><dt><span>geospatial_lat_units :</span></dt><dd>decimal degrees north</dd><dt><span>geospatial_lon_units :</span></dt><dd>decimal degrees east</dd><dt><span>geospatial_lat_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_lon_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_vertical_min :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_max :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_resolution :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_positive :</span></dt><dd>up</dd><dt><span>time_coverage_start :</span></dt><dd>2091-01-01T00:0</dd><dt><span>time_coverage_end :</span></dt><dd>2095-12-31T00:00</dd><dt><span>time_coverage_duration :</span></dt><dd>P5Y</dd><dt><span>time_coverage_resolution :</span></dt><dd>P1M</dd><dt><span>date_created :</span></dt><dd>2014-05-15</dd><dt><span>date_modified :</span></dt><dd>2014-05-15</dd><dt><span>date_issued :</span></dt><dd>2014-05-15</dd><dt><span>creator_name :</span></dt><dd>John Abatzoglou</dd><dt><span>creator_url :</span></dt><dd>http://maca.northwestknowledge.net</dd><dt><span>creator_email :</span></dt><dd>jabatzoglou@uidaho.edu</dd><dt><span>institution :</span></dt><dd>University of Idaho</dd><dt><span>processing_level :</span></dt><dd>GRID</dd><dt><span>project :</span></dt><dd></dd><dt><span>contributor_name :</span></dt><dd>Katherine C. Hegewisch</dd><dt><span>contributor_role :</span></dt><dd>Postdoctoral Fellow</dd><dt><span>publisher_name :</span></dt><dd>REACCH</dd><dt><span>publisher_email :</span></dt><dd>reacch@uidaho.edu</dd><dt><span>publisher_url :</span></dt><dd>http://www.reacchpna.org/</dd><dt><span>license :</span></dt><dd>Creative Commons CC0 1.0 Universal Dedication(http://creativecommons.org/publicdomain/zero/1.0/legalcode)</dd><dt><span>coordinate_system :</span></dt><dd>WGS84,EPSG:4326</dd></dl></div></li></ul></div></div>





In the example below you subset data for the state of 
California similar to what you did in the previous lesson. You can 
select any state that you wish for this analysis!


{:.input}
```python
# Download natural earth data to generate AOI
et.data.get_data(
    url="https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lakes.zip")

states_path = "earthpy-downloads/ne_50m_admin_1_states_provinces_lakes"
states_path = os.path.join(
    states_path, "ne_50m_admin_1_states_provinces_lakes.shp")

states_gdf = gpd.read_file(states_path)
cali_aoi = states_gdf[states_gdf.name == "California"]
```

{:.input}
```python
# Would this be better if it only returned 4 values?? probably so
# Helper Function to extract AOI
def get_aoi(shp, world=True):
    """Takes a geopandas object and converts it to a lat/ lon
    extent """

    lon_lat = {}
    # Get lat min, max
    aoi_lat = [float(shp.total_bounds[1]), float(shp.total_bounds[3])]
    aoi_lon = [float(shp.total_bounds[0]), float(shp.total_bounds[2])]

    # Handle the 0-360 lon values
    if world:
        aoi_lon[0] = aoi_lon[0] + 360
        aoi_lon[1] = aoi_lon[1] + 360
    lon_lat["lon"] = aoi_lon
    lon_lat["lat"] = aoi_lat
    return lon_lat
```

{:.input}
```python
# Get lat min, max from Cali aoi extent
cali_bounds = get_aoi(cali_aoi)

# Slice by time & aoi location
start_date = "2059-12-15"
end_date = "2099-12-15"

cali_temp = monthly_forecast_temp_xr["air_temperature"].sel(
    time=slice(start_date, end_date),
    lon=slice(cali_bounds["lon"][0], cali_bounds["lon"][1]),
    lat=slice(cali_bounds["lat"][0], cali_bounds["lat"][1]))
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
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 481</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-916698f2-f68d-470c-8ec5-03409deec071' class='xr-array-in' type='checkbox' checked><label for='section-916698f2-f68d-470c-8ec5-03409deec071' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[26860002 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-483b9ad7-ff71-42b5-a824-e4b61389db64' class='xr-section-summary-in' type='checkbox'  checked><label for='section-483b9ad7-ff71-42b5-a824-e4b61389db64' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-977816bb-84f4-4b4d-aca5-f592071541cf' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-977816bb-84f4-4b4d-aca5-f592071541cf' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f8f87369-56fa-48b8-9541-6771ed94a71f' class='xr-var-data-in' type='checkbox'><label for='data-f8f87369-56fa-48b8-9541-6771ed94a71f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-3cd9d249-b16a-416a-a94c-acd782925e34' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3cd9d249-b16a-416a-a94c-acd782925e34' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-48b82123-3b06-43ef-9c02-bf858d4b3328' class='xr-var-data-in' type='checkbox'><label for='data-48b82123-3b06-43ef-9c02-bf858d4b3328' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-15 00:00:00 ... 2099-12-...</div><input id='attrs-8311576b-071e-4aa4-a6a2-493af8dbf971' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8311576b-071e-4aa4-a6a2-493af8dbf971' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5b15a8b5-048c-42a0-9648-8fc14794c60c' class='xr-var-data-in' type='checkbox'><label for='data-5b15a8b5-048c-42a0-9648-8fc14794c60c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 2, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-585aa3f6-939e-4092-b7f5-ea7ee52edce4' class='xr-section-summary-in' type='checkbox'  checked><label for='section-585aa3f6-939e-4092-b7f5-ea7ee52edce4' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>





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
# cali_region = regionmask.from_geopandas(cali_aoi,
#                                         names="name",
#                                         name="name",
#                                         abbrevs="iso_3166_2")
cali_mask = regionmask.mask_3D_geopandas(cali_aoi,
                                         monthly_forecast_temp_xr.lon,
                                         monthly_forecast_temp_xr.lat)
# Mask the netcdf data
cali_temp_masked = cali_temp.where(cali_mask)
cali_temp_masked.dims
```

{:.output}
{:.execute_result}



    ('time', 'lat', 'lon', 'region')





{:.input}
```python
cali_temp.values.shape
```

{:.output}
{:.execute_result}



    (481, 227, 246)






Calculate the mean temperature for each season across the entire dataset. 
This will produce 4 arrays - one representing mean temperature for each seasons. 

{:.input}
```python
cali_season_summary = cali_temp_masked.groupby(
    'time.season').mean('time', skipna=True)

# This will create 4 arrays - one for each season showing mean temperature values
cali_season_summary.shape
```

{:.output}
{:.execute_result}



    (4, 227, 246, 1)





Plot the seasonal data.

{:.input}
```python
# Create a plot showing mean temperature aross seasons
cali_season_summary.plot(col='season', col_wrap=2, figsize=(10, 10))
plt.suptitle("Mean Temperature Across All Selected Years By Season \n California, USA",
             y=1.05)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-05-seasonal-summary/2020-10-16-netcdf-05-seasonal-summary_18_0.png" alt = "Facet plot showing seasonal mean temperature values for the State of California summarized over time.">
<figcaption>Facet plot showing seasonal mean temperature values for the State of California summarized over time.</figcaption>

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
cali_season_mean_all_years = cali_temp_masked.resample(
    time='QS-DEC', keep_attrs=True).mean()
cali_season_mean_all_years.shape
```

{:.output}
{:.execute_result}



    (161, 227, 246, 1)





{:.input}
```python
# Summarize each array into one single (mean) value
cali_seasonal_mean = cali_season_mean_all_years.groupby('time').mean([
    "lat", "lon"])
cali_seasonal_mean.shape
```

{:.output}
{:.execute_result}



    (161, 1)





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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-05-seasonal-summary/2020-10-16-netcdf-05-seasonal-summary_23_0.png" alt = "Scatter plot showing seasonal mean temperature values for the State of California displayed over time.">
<figcaption>Scatter plot showing seasonal mean temperature values for the State of California displayed over time.</figcaption>

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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-05-seasonal-summary/2020-10-16-netcdf-05-seasonal-summary_28_0.png" alt = "Scatter plot showing seasonal mean temperature values for the State of California summarized over time and colored by season.">
<figcaption>Scatter plot showing seasonal mean temperature values for the State of California summarized over time and colored by season.</figcaption>

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
  * time     (time) object 2059-12-15 00:00:00 ... 2099-12-15 00:00:00</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'days_in_month'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 481</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-f600e8e6-a4a8-47e6-8eb8-c7b21123bf73' class='xr-array-in' type='checkbox' checked><label for='section-f600e8e6-a4a8-47e6-8eb8-c7b21123bf73' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>31 31 28 31 30 31 30 31 31 30 31 ... 28 31 30 31 30 31 31 30 31 30 31</span></div><div class='xr-array-data'><pre>array([31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31, 30,
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
       31, 30, 31, 30, 31])</pre></div></div></li><li class='xr-section-item'><input id='section-6dc8270c-1f88-4913-8db8-3b1ea5b84ed7' class='xr-section-summary-in' type='checkbox'  checked><label for='section-6dc8270c-1f88-4913-8db8-3b1ea5b84ed7' class='xr-section-summary' >Coordinates: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-15 00:00:00 ... 2099-12-...</div><input id='attrs-0506f432-8392-46a4-93e6-bea855ca4339' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0506f432-8392-46a4-93e6-bea855ca4339' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-93a649c9-cf2c-4992-96af-62c296fca313' class='xr-var-data-in' type='checkbox'><label for='data-93a649c9-cf2c-4992-96af-62c296fca313' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 2, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-0612c0a9-6a21-45dc-826a-b376ba97c6f6' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-0612c0a9-6a21-45dc-826a-b376ba97c6f6' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





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
cali_weighted_mean.shape
```

{:.output}
{:.execute_result}



    (161, 227, 246)





{:.input}
```python
cali_weighted_season_value = cali_weighted_mean.groupby('time').mean([
    "lat", "lon"])
cali_weighted_season_value.shape
```

{:.output}
{:.execute_result}



    (161,)





{:.input}
```python
colors = {3: "grey", 6: "lightgreen", 9: "green", 12: "purple"}
seasons = {3: "Spring", 6: "Summer", 9: "Fall", 12: "Winter"}

f, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 7), sharey=True)
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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-05-seasonal-summary/2020-10-16-netcdf-05-seasonal-summary_35_0.png" alt = "Comparison of seasonal mean values - weighted vs unweighted by days in each month and colored by season.">
<figcaption>Comparison of seasonal mean values - weighted vs unweighted by days in each month and colored by season.</figcaption>

</figure>




If you want, you can compare the difference between weighted vs unweighted 
values.

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
  * region   (region) int64 53</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 161</li><li><span class='xr-has-index'>region</span>: 1</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-286ebd26-844a-4765-bdfe-5213e2fb1039' class='xr-array-in' type='checkbox' checked><label for='section-286ebd26-844a-4765-bdfe-5213e2fb1039' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>2.424 1.115 0.5635 1.42 2.1 0.9975 ... 1.818 0.8586 0.462 1.721 1.993</span></div><div class='xr-array-data'><pre>array([[2.42445398],
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
       [1.99271339]])</pre></div></div></li><li class='xr-section-item'><input id='section-e614ead2-0e01-408d-b0dd-eda737da4c08' class='xr-section-summary-in' type='checkbox'  checked><label for='section-e614ead2-0e01-408d-b0dd-eda737da4c08' class='xr-section-summary' >Coordinates: <span>(2)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-01 00:00:00 ... 2099-12-...</div><input id='attrs-4facf572-da5d-45a7-99e7-926f6f3611ba' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-4facf572-da5d-45a7-99e7-926f6f3611ba' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3d377870-e0ab-4fc2-ac10-cc5edebf0064' class='xr-var-data-in' type='checkbox'><label for='data-3d377870-e0ab-4fc2-ac10-cc5edebf0064' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 1, 0, 0, 0, 0),
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
       cftime.DatetimeNoLeap(2099, 12, 1, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53</div><input id='attrs-06d759f4-79d2-44a5-bc5f-1955bf8f3a69' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-06d759f4-79d2-44a5-bc5f-1955bf8f3a69' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8d9bae26-28c0-439d-bbaf-483c4051b002' class='xr-var-data-in' type='checkbox'><label for='data-8d9bae26-28c0-439d-bbaf-483c4051b002' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-72e3be09-0bff-46c4-8b82-0e5998dea57f' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-72e3be09-0bff-46c4-8b82-0e5998dea57f' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





## The Same Analysis for the West Coast

Above you calculate seasonal summaries for the state of California. You can 
implement the same analysis for each aoi region in a shapefile if you want 
following the workflow that you learned in the previous lesson. 

{:.input}
```python
# Create AOI Subset
cali_or_wash_nev = states_gdf[states_gdf.name.isin(
    ["California", "Oregon", "Washington", "Nevada"])]
west_bounds = get_aoi(cali_or_wash_nev)

# Create the mask
west_mask = regionmask.mask_3D_geopandas(cali_or_wash_nev,
                                         monthly_forecast_temp_xr.lon,
                                         monthly_forecast_temp_xr.lat)


# Slice by time & aoi location
start_date = "2059-12-15"
end_date = "2099-12-15"

west_temp = monthly_forecast_temp_xr["air_temperature"].sel(
    time=slice(start_date, end_date),
    lon=slice(west_bounds["lon"][0], west_bounds["lon"][1]),
    lat=slice(west_bounds["lat"][0], west_bounds["lat"][1]))

# Apply the mask
west_temp_masked = west_temp.where(west_mask)
west_temp_masked
# Resample the data by season across all years
#west_season_mean_all_years = west_temp_masked.groupby('region').resample(time='QS-DEC', keep_attrs=True).mean()
# cali_seasonal_mean = cali_season_mean_all_years.groupby('time').mean(["lat", "lon"])
# cali_seasonal_mean
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 481, lat: 395, lon: 256, region: 4)&gt;
array([[[[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]],

        [[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]],

        [[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
...
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]],

        [[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]],

        [[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]]]], dtype=float32)
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 48.85 48.9 48.94 48.98
  * lon      (lon) float64 235.3 235.4 235.4 235.4 ... 245.8 245.9 245.9 245.9
  * time     (time) object 2059-12-15 00:00:00 ... 2099-12-15 00:00:00
  * region   (region) int64 53 82 86 96
Attributes:
    long_name:      Monthly Average of Daily Maximum Near-Surface Air Tempera...
    units:          K
    grid_mapping:   crs
    standard_name:  air_temperature
    height:         2 m
    cell_methods:   time: maximum(interval: 24 hours);mean over days
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 481</li><li><span class='xr-has-index'>lat</span>: 395</li><li><span class='xr-has-index'>lon</span>: 256</li><li><span class='xr-has-index'>region</span>: 4</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-e11e9c94-56f2-49f4-9eef-c717860dad5a' class='xr-array-in' type='checkbox' checked><label for='section-e11e9c94-56f2-49f4-9eef-c717860dad5a' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... nan nan nan nan nan nan nan nan</span></div><div class='xr-array-data'><pre>array([[[[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]],

        [[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]],

        [[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
...
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]],

        [[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]],

        [[nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         ...,
         [nan, nan, nan, nan],
         [nan, nan, nan, nan],
         [nan, nan, nan, nan]]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-2e8b9a6f-3c48-4931-826a-583a0fe9d910' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2e8b9a6f-3c48-4931-826a-583a0fe9d910' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 48.94 48.98</div><input id='attrs-f5a83e72-690a-45b8-8e18-b6821cc5e5f9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f5a83e72-690a-45b8-8e18-b6821cc5e5f9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-315623c5-507c-4c8b-a7b1-3c3a1eab4b0f' class='xr-var-data-in' type='checkbox'><label for='data-315623c5-507c-4c8b-a7b1-3c3a1eab4b0f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 48.89603 , 48.937698, 48.979362])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.3 235.4 235.4 ... 245.9 245.9</div><input id='attrs-29192a4a-bdb5-4a09-8bc0-1dd940bc6175' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-29192a4a-bdb5-4a09-8bc0-1dd940bc6175' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8eacb854-0471-4016-9c95-36f8427e3440' class='xr-var-data-in' type='checkbox'><label for='data-8eacb854-0471-4016-9c95-36f8427e3440' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.311157, 235.352844, 235.394501, ..., 245.852661, 245.894333,
       245.936005])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2059-12-15 00:00:00 ... 2099-12-...</div><input id='attrs-d99d17fc-9426-4ff9-8892-f185cf02fdb9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d99d17fc-9426-4ff9-8892-f185cf02fdb9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-88efabd9-9d76-4a0a-b794-be397115b94c' class='xr-var-data-in' type='checkbox'><label for='data-88efabd9-9d76-4a0a-b794-be397115b94c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2059, 12, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2060, 2, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53 82 86 96</div><input id='attrs-728b6cc9-3e16-48fc-8ea0-3d15ec45a19f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-728b6cc9-3e16-48fc-8ea0-3d15ec45a19f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-feb18383-fc63-46f7-91c3-9abaf89f68eb' class='xr-var-data-in' type='checkbox'><label for='data-feb18383-fc63-46f7-91c3-9abaf89f68eb' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53, 82, 86, 96])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-eb1b06d7-ff8c-47f7-a67d-4526fb889e6a' class='xr-section-summary-in' type='checkbox'  checked><label for='section-eb1b06d7-ff8c-47f7-a67d-4526fb889e6a' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>





{:.input}
```python
# This produces a raster for each season over time across regions
west_coast_mean_temp_raster = west_temp_masked.resample(
    time='QS-DEC', keep_attrs=True).mean()
west_coast_mean_temp_raster.shape
```

{:.output}
{:.execute_result}



    (161, 395, 256, 4)





{:.input}
```python
# This produces a regional summary
regional_summary = west_coast_mean_temp_raster.groupby('time').mean([
    "lat", "lon"])
regional_summary.plot(col="region",
                      marker="o",
                      color="grey",
                      markerfacecolor="purple",
                      markeredgecolor="purple",
                      col_wrap=2,
                      figsize=(12, 8))

plt.suptitle("Seasonal Temperature by Region", y=1.03)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-05-seasonal-summary/2020-10-16-netcdf-05-seasonal-summary_41_0.png" alt = "Facet plot showing seasonal mean temperature values for the several areas of interest (aoi's) including California, Washington, Oregon and Nevada and summarized over time.">
<figcaption>Facet plot showing seasonal mean temperature values for the several areas of interest (aoi's) including California, Washington, Oregon and Nevada and summarized over time.</figcaption>

</figure>




{:.input}
```python
# The data can then be easily converted to a dataframe
regional_summary.to_dataframe()
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
      <th rowspan="4" valign="top">2059-12-01 00:00:00</th>
      <th>53</th>
      <td>287.588531</td>
    </tr>
    <tr>
      <th>82</th>
      <td>281.238739</td>
    </tr>
    <tr>
      <th>86</th>
      <td>280.193787</td>
    </tr>
    <tr>
      <th>96</th>
      <td>279.038940</td>
    </tr>
    <tr>
      <th>2060-03-01 00:00:00</th>
      <th>53</th>
      <td>294.914886</td>
    </tr>
    <tr>
      <th>...</th>
      <th>...</th>
      <td>...</td>
    </tr>
    <tr>
      <th>2099-09-01 00:00:00</th>
      <th>96</th>
      <td>290.840363</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">2099-12-01 00:00:00</th>
      <th>53</th>
      <td>289.929504</td>
    </tr>
    <tr>
      <th>82</th>
      <td>284.486908</td>
    </tr>
    <tr>
      <th>86</th>
      <td>282.051971</td>
    </tr>
    <tr>
      <th>96</th>
      <td>280.577484</td>
    </tr>
  </tbody>
</table>
<p>644 rows × 1 columns</p>
</div>




