---
layout: single
title: "Calculate Summary Values Using Spatial Areas of Interest (AOIs) including Shapefiles for Climate Data Variables Stored in NetCDF 4 Format: Work With MACA v2 Climate Data in Python"
excerpt: "Climate datasets stored in netcdf 4 format often cover the entire globe or an entire country. Learn how to subset climate data spatially and by time slices using xarray and regionmask in open source python."
authors: ['Leah Wasser']
dateCreated: 2020-10-23
modified: 2020-10-23
category: [courses]
class-lesson: ['netcdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/subset-netcdf4-climate-data-spatially-aoi/
nav-title: 'Spatial Subset Climate Data'
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

You will need a computer with internet access to complete this lesson and the earth-analytics-python
conda environment installed.

</div>

## Subset MACA 2 Climate Data in NetCDF 4 Format By Time and Spatial Extents

In this lesson, you will learn how to subset MACA v2 climate data using the open 
source Python packages `xarray` and `regionmask`.


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
# Spatial subsetting of netcdf files
import regionmask


# Plotting options
sns.set(font_scale=1.3)
sns.set_style("white")

# Optional - set your working directory if you wish to use the data
# accessed lower down in this notebook (the USA state boundary data)
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))
```

## Spatial Subsets of Data Using an AOI

In the previous lesson, you learned how to select a single point and extract 
temperature data at that location. You can also create areas of interest 
(AOIs) that define the geographic region that you wish to extract data for. 

Below you will learn how to use a shapefile that contains a boundary
area of interest that you wish to subset data for. You will then learn 
how to subset the data using the 

1. geographic boundary extent of the AOI (a rectangular extent) and
2. using the actual shape boundary of the AOI (example: the state of California)

To begin, you will open up a new netcdf file. This file contains 
future projected maximum temperature data for the Continental United States(CONUS).  

{:.input}
```python
# Get netcdf file
data_path_monthly = 'http://thredds.northwestknowledge.net:8080/thredds/dodsC/agg_macav2metdata_tasmax_BNU-ESM_r1i1p1_rcp45_2006_2099_CONUS_monthly.nc'

# Open up the data
with xr.open_dataset(data_path_monthly) as file_nc:
    monthly_forecast_temp_xr = file_nc

# View xarray object
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
    coordinate_system:               WGS84,EPSG:4326</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-e5183f3e-807b-4266-a8fd-524edc898820' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-e5183f3e-807b-4266-a8fd-524edc898820' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>crs</span>: 1</li><li><span class='xr-has-index'>lat</span>: 585</li><li><span class='xr-has-index'>lon</span>: 1386</li><li><span class='xr-has-index'>time</span>: 1128</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-7e704a8f-8787-4232-af86-baaad2861c0d' class='xr-section-summary-in' type='checkbox'  checked><label for='section-7e704a8f-8787-4232-af86-baaad2861c0d' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>25.06 25.1 25.15 ... 49.35 49.4</div><input id='attrs-9b1d7836-e393-4c57-be89-aba870d438d8' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9b1d7836-e393-4c57-be89-aba870d438d8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2817b93a-b639-4b33-9a15-c4b785519843' class='xr-var-data-in' type='checkbox'><label for='data-2817b93a-b639-4b33-9a15-c4b785519843' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([25.063078, 25.104744, 25.14641 , ..., 49.312691, 49.354359, 49.396023])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>crs</span></div><div class='xr-var-dims'>(crs)</div><div class='xr-var-dtype'>int32</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-ac28e420-5733-44df-9c76-1b04f9a7e63f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ac28e420-5733-44df-9c76-1b04f9a7e63f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3232c20d-cf61-4e60-abcc-0fe768453667' class='xr-var-data-in' type='checkbox'><label for='data-3232c20d-cf61-4e60-abcc-0fe768453667' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>grid_mapping_name :</span></dt><dd>latitude_longitude</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd></dl></div><div class='xr-var-data'><pre>array([1], dtype=int32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.2 235.3 235.3 ... 292.9 292.9</div><input id='attrs-8f48e80c-f1dd-40a0-a9c0-ba148b159d13' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8f48e80c-f1dd-40a0-a9c0-ba148b159d13' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cb22eae4-0df7-4409-9fc8-0e8d24c8821f' class='xr-var-data-in' type='checkbox'><label for='data-cb22eae4-0df7-4409-9fc8-0e8d24c8821f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.227844, 235.269501, 235.311157, ..., 292.851929, 292.893585,
       292.935242])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2006-01-15 00:00:00 ... 2099-12-...</div><input id='attrs-18b0adea-b907-463d-84fb-2d0e85b96433' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-18b0adea-b907-463d-84fb-2d0e85b96433' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ff42a52c-4298-4035-a3a0-3b31dde8bae2' class='xr-var-data-in' type='checkbox'><label for='data-ff42a52c-4298-4035-a3a0-3b31dde8bae2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2006, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2006, 2, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2006, 3, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-3db15555-25e6-4c40-991a-9bdd30fbd955' class='xr-section-summary-in' type='checkbox'  checked><label for='section-3db15555-25e6-4c40-991a-9bdd30fbd955' class='xr-section-summary' >Data variables: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>air_temperature</span></div><div class='xr-var-dims'>(time, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9a507038-fe35-47ea-924f-7e0cb44477fe' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9a507038-fe35-47ea-924f-7e0cb44477fe' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7ad7a90c-9d0f-4568-bb67-108a97f04ecc' class='xr-var-data-in' type='checkbox'><label for='data-7ad7a90c-9d0f-4568-bb67-108a97f04ecc' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div><div class='xr-var-data'><pre>[914593680 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-822cef7b-717e-4951-9c58-59405b04307c' class='xr-section-summary-in' type='checkbox'  ><label for='section-822cef7b-717e-4951-9c58-59405b04307c' class='xr-section-summary' >Attributes: <span>(46)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>Multivariate Adaptive Constructed Analogs (MACA) method, version 2.3,Dec 2013.</dd><dt><span>id :</span></dt><dd>MACAv2-METDATA</dd><dt><span>naming_authority :</span></dt><dd>edu.uidaho.reacch</dd><dt><span>Metadata_Conventions :</span></dt><dd>Unidata Dataset Discovery v1.0</dd><dt><span>Metadata_Link :</span></dt><dd></dd><dt><span>cdm_data_type :</span></dt><dd>FLOAT</dd><dt><span>title :</span></dt><dd>Monthly aggregation of downscaled daily meteorological data of Monthly Average of Daily Maximum Near-Surface Air Temperature from College of Global Change and Earth System Science, Beijing Normal University (BNU-ESM) using the run r1i1p1 of the rcp45 scenario.</dd><dt><span>summary :</span></dt><dd>This archive contains monthly downscaled meteorological and hydrological projections for the Conterminous United States at 1/24-deg resolution. These monthly values are obtained by aggregating the daily values obtained from the downscaling using the Multivariate Adaptive Constructed Analogs (MACA, Abatzoglou, 2012) statistical downscaling method with the METDATA (Abatzoglou,2013) training dataset. The downscaled meteorological variables are maximum/minimum temperature(tasmax/tasmin), maximum/minimum relative humidity (rhsmax/rhsmin),precipitation amount(pr), downward shortwave solar radiation(rsds), eastward wind(uas), northward wind(vas), and specific humidity(huss). The downscaling is based on the 365-day model outputs from different global climate models (GCMs) from Phase 5 of the Coupled Model Inter-comparison Project (CMIP3) utlizing the historical (1950-2005) and future RCP4.5/8.5(2006-2099) scenarios. </dd><dt><span>keywords :</span></dt><dd>monthly, precipitation, maximum temperature, minimum temperature, downward shortwave solar radiation, specific humidity, wind velocity, CMIP5, Gridded Meteorological Data</dd><dt><span>keywords_vocabulary :</span></dt><dd></dd><dt><span>standard_name_vocabulary :</span></dt><dd>CF-1.0</dd><dt><span>history :</span></dt><dd>No revisions.</dd><dt><span>comment :</span></dt><dd></dd><dt><span>geospatial_bounds :</span></dt><dd>POLYGON((-124.7722 25.0631,-124.7722 49.3960, -67.0648 49.3960,-67.0648, 25.0631, -124.7722,25.0631))</dd><dt><span>geospatial_lat_min :</span></dt><dd>25.0631</dd><dt><span>geospatial_lat_max :</span></dt><dd>49.3960</dd><dt><span>geospatial_lon_min :</span></dt><dd>-124.7722</dd><dt><span>geospatial_lon_max :</span></dt><dd>-67.0648</dd><dt><span>geospatial_lat_units :</span></dt><dd>decimal degrees north</dd><dt><span>geospatial_lon_units :</span></dt><dd>decimal degrees east</dd><dt><span>geospatial_lat_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_lon_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_vertical_min :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_max :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_resolution :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_positive :</span></dt><dd>up</dd><dt><span>time_coverage_start :</span></dt><dd>2091-01-01T00:0</dd><dt><span>time_coverage_end :</span></dt><dd>2095-12-31T00:00</dd><dt><span>time_coverage_duration :</span></dt><dd>P5Y</dd><dt><span>time_coverage_resolution :</span></dt><dd>P1M</dd><dt><span>date_created :</span></dt><dd>2014-05-15</dd><dt><span>date_modified :</span></dt><dd>2014-05-15</dd><dt><span>date_issued :</span></dt><dd>2014-05-15</dd><dt><span>creator_name :</span></dt><dd>John Abatzoglou</dd><dt><span>creator_url :</span></dt><dd>http://maca.northwestknowledge.net</dd><dt><span>creator_email :</span></dt><dd>jabatzoglou@uidaho.edu</dd><dt><span>institution :</span></dt><dd>University of Idaho</dd><dt><span>processing_level :</span></dt><dd>GRID</dd><dt><span>project :</span></dt><dd></dd><dt><span>contributor_name :</span></dt><dd>Katherine C. Hegewisch</dd><dt><span>contributor_role :</span></dt><dd>Postdoctoral Fellow</dd><dt><span>publisher_name :</span></dt><dd>REACCH</dd><dt><span>publisher_email :</span></dt><dd>reacch@uidaho.edu</dd><dt><span>publisher_url :</span></dt><dd>http://www.reacchpna.org/</dd><dt><span>license :</span></dt><dd>Creative Commons CC0 1.0 Universal Dedication(http://creativecommons.org/publicdomain/zero/1.0/legalcode)</dd><dt><span>coordinate_system :</span></dt><dd>WGS84,EPSG:4326</dd></dl></div></li></ul></div></div>





### Open A Shapefile to Use as an AOI

Often you want to subset and summarize climate data by specific regions of 
interest. In the example below, you will open a natural earth layer that 
contains state and region boundaries. You will extract a state boundary (California)
within the United States to use as an AOI.

{:.input}
```python
# Download natural earth data which contains state boundaries to generate AOI
et.data.get_data(
    url="https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lakes.zip")

states_path = "earthpy-downloads/ne_50m_admin_1_states_provinces_lakes"
states_path = os.path.join(
    states_path, "ne_50m_admin_1_states_provinces_lakes.shp")

states_gdf = gpd.read_file(states_path)
states_gdf.head()
```

{:.output}
    Downloading from https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lakes.zip
    Extracted output to /root/earth-analytics/data/earthpy-downloads/ne_50m_admin_1_states_provinces_lakes



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
      <th>featurecla</th>
      <th>scalerank</th>
      <th>adm1_code</th>
      <th>diss_me</th>
      <th>iso_3166_2</th>
      <th>wikipedia</th>
      <th>iso_a2</th>
      <th>adm0_sr</th>
      <th>name</th>
      <th>name_alt</th>
      <th>...</th>
      <th>name_nl</th>
      <th>name_pl</th>
      <th>name_pt</th>
      <th>name_ru</th>
      <th>name_sv</th>
      <th>name_tr</th>
      <th>name_vi</th>
      <th>name_zh</th>
      <th>ne_id</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>AUS-2651</td>
      <td>2651</td>
      <td>AU-WA</td>
      <td>None</td>
      <td>AU</td>
      <td>6</td>
      <td>Western Australia</td>
      <td>None</td>
      <td>...</td>
      <td>West-Australië</td>
      <td>Australia Zachodnia</td>
      <td>Austrália Ocidental</td>
      <td>Западная Австралия</td>
      <td>Western Australia</td>
      <td>Batı Avustralya</td>
      <td>Tây Úc</td>
      <td>西澳大利亚州</td>
      <td>1159315805</td>
      <td>MULTIPOLYGON (((113.13181 -25.95199, 113.14823...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>AUS-2650</td>
      <td>2650</td>
      <td>AU-NT</td>
      <td>None</td>
      <td>AU</td>
      <td>6</td>
      <td>Northern Territory</td>
      <td>None</td>
      <td>...</td>
      <td>Noordelijk Territorium</td>
      <td>Terytorium Północne</td>
      <td>Território do Norte</td>
      <td>Северная территория</td>
      <td>Northern Territory</td>
      <td>Kuzey Toprakları</td>
      <td>Lãnh thổ Bắc Úc</td>
      <td>北領地</td>
      <td>1159315809</td>
      <td>MULTIPOLYGON (((129.00196 -25.99901, 129.00196...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>AUS-2655</td>
      <td>2655</td>
      <td>AU-SA</td>
      <td>None</td>
      <td>AU</td>
      <td>3</td>
      <td>South Australia</td>
      <td>None</td>
      <td>...</td>
      <td>Zuid-Australië</td>
      <td>Australia Południowa</td>
      <td>Austrália Meridional</td>
      <td>Южная Австралия</td>
      <td>South Australia</td>
      <td>Güney Avustralya</td>
      <td>Nam Úc</td>
      <td>南澳大利亚州</td>
      <td>1159313267</td>
      <td>MULTIPOLYGON (((129.00196 -31.69266, 129.00196...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>AUS-2657</td>
      <td>2657</td>
      <td>AU-QLD</td>
      <td>None</td>
      <td>AU</td>
      <td>5</td>
      <td>Queensland</td>
      <td>None</td>
      <td>...</td>
      <td>Queensland</td>
      <td>Queensland</td>
      <td>Queensland</td>
      <td>Квинсленд</td>
      <td>Queensland</td>
      <td>Queensland</td>
      <td>Queensland</td>
      <td>昆士蘭州</td>
      <td>1159315807</td>
      <td>MULTIPOLYGON (((138.00196 -25.99901, 138.00174...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>AUS-2660</td>
      <td>2660</td>
      <td>AU-TAS</td>
      <td>None</td>
      <td>AU</td>
      <td>5</td>
      <td>Tasmania</td>
      <td>None</td>
      <td>...</td>
      <td>Tasmanië</td>
      <td>Tasmania</td>
      <td>Tasmânia</td>
      <td>Тасмания</td>
      <td>Tasmanien</td>
      <td>Tasmanya</td>
      <td>Tasmania</td>
      <td>塔斯馬尼亞州</td>
      <td>1159313261</td>
      <td>MULTIPOLYGON (((147.31246 -43.28038, 147.34238...</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 84 columns</p>
</div>





{:.input}
```python
# You will use the bounds to determine the slice values for this data
# Select any state in the CONUS that you wish here! California is the default
cali_aoi = states_gdf[states_gdf.name == "California"]
# Get the total spatial extent for California
cali_aoi.total_bounds
```

{:.output}
{:.execute_result}



    array([-124.37165376,   32.53336527, -114.12501824,   42.00076797])





Next, convert the bounds of your AOI into the min and max longitude
and latitude values. You will use these values to `slice` your data.

{:.input}
```python
# Get lat min, max
aoi_lat = [float(cali_aoi.total_bounds[1]), float(cali_aoi.total_bounds[3])]
aoi_lon = [float(cali_aoi.total_bounds[0]), float(cali_aoi.total_bounds[2])]
# Notice that the longitude values have negative numbers
# we need these values in a global crs so we can subtract from 360
aoi_lat, aoi_lon
```

{:.output}
{:.execute_result}



    ([32.533365269889316, 42.00076797479207],
     [-124.3716537616361, -114.12501823892204])





The netcdf files use a global lat/lon rather than positive and negative
longitude values. To ensure you are subsetting the data for the correct
region, you can add 360 degrees to each longitude value which represent the 
min x and max x values for the extent.


{:.input}
```python
# The netcdf files use a global lat/lon so adjust values accordingly
aoi_lon[0] = aoi_lon[0] + 360
aoi_lon[1] = aoi_lon[1] + 360
aoi_lon
```

{:.output}
{:.execute_result}



    [235.62834623836392, 245.87498176107795]





Once you have your data AOI defined, you can slice out the 
AOI region using xarray `slice`.

{:.input}
```python
# Slice the data by time and spatial extent
start_date = "2010-01-15"
end_date = "2010-02-15"

two_months_cali = monthly_forecast_temp_xr["air_temperature"].sel(
    time=slice(start_date, end_date),
    lon=slice(aoi_lon[0], aoi_lon[1]),
    lat=slice(aoi_lat[0], aoi_lat[1]))
two_months_cali
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 2, lat: 227, lon: 246)&gt;
[111684 values with dtype=float32]
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9
  * time     (time) object 2010-01-15 00:00:00 2010-02-15 00:00:00
Attributes:
    long_name:      Monthly Average of Daily Maximum Near-Surface Air Tempera...
    units:          K
    grid_mapping:   crs
    standard_name:  air_temperature
    height:         2 m
    cell_methods:   time: maximum(interval: 24 hours);mean over days
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 2</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-e97b3150-bd6e-4a6d-883b-372cd8ceb93b' class='xr-array-in' type='checkbox' checked><label for='section-e97b3150-bd6e-4a6d-883b-372cd8ceb93b' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[111684 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-9e9ea3c2-b591-425e-917d-033819444aa4' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9e9ea3c2-b591-425e-917d-033819444aa4' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-4999548d-d2fe-4595-a217-48e093b9d70f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4999548d-d2fe-4595-a217-48e093b9d70f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cc4daeb2-a825-4d45-89bb-202ad3ac0576' class='xr-var-data-in' type='checkbox'><label for='data-cc4daeb2-a825-4d45-89bb-202ad3ac0576' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-6969b4e2-b511-4c88-b943-6d64ab0b6aba' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6969b4e2-b511-4c88-b943-6d64ab0b6aba' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e949f033-15c8-4891-931d-ed64938f1b27' class='xr-var-data-in' type='checkbox'><label for='data-e949f033-15c8-4891-931d-ed64938f1b27' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2010-01-15 00:00:00 2010-02-15 0...</div><input id='attrs-12391b5a-7843-4957-9478-9ce509e1bf06' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-12391b5a-7843-4957-9478-9ce509e1bf06' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-89b13b16-1d1f-4710-8232-30cbb9bca37e' class='xr-var-data-in' type='checkbox'><label for='data-89b13b16-1d1f-4710-8232-30cbb9bca37e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2010, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2010, 2, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-0c586e7a-5577-419a-b6f7-09331eb74c6f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-0c586e7a-5577-419a-b6f7-09331eb74c6f' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>





{:.input}
```python
# Plot a quick histogram
two_months_cali.plot()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_16_0.png" alt = "Histogram showing the spread of temperature values over time for the selected MACA 2 max temperature dataset and for the AOI (the spatial extend of california). ">
<figcaption>Histogram showing the spread of temperature values over time for the selected MACA 2 max temperature dataset and for the AOI (the spatial extend of california). </figcaption>

</figure>




Remember that these data are spatial. Below you 
plot each time step as a raster dataset. Notice that this spatial extent
is a rectangle representing the entire rectangular extent for the 
state of California.

{:.input}
```python
# Spatial Plot for the selected AOI (California)
two_months_cali.plot(col='time',
                     col_wrap=1)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_18_0.png" alt = "Spatial plots of monthly maximum temperature for two time steps. Notice that the AOI or spatial extent is a square boundary as you subsetted it above. ">
<figcaption>Spatial plots of monthly maximum temperature for two time steps. Notice that the AOI or spatial extent is a square boundary as you subsetted it above. </figcaption>

</figure>




{:.input}
```python
# Only subset by location / not time
cali_ts = monthly_forecast_temp_xr["air_temperature"].sel(
    lon=slice(aoi_lon[0], aoi_lon[1]),
    lat=slice(aoi_lat[0], aoi_lat[1]))
cali_ts
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 1128, lat: 227, lon: 246)&gt;
[62989776 values with dtype=float32]
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9
  * time     (time) object 2006-01-15 00:00:00 ... 2099-12-15 00:00:00
Attributes:
    long_name:      Monthly Average of Daily Maximum Near-Surface Air Tempera...
    units:          K
    grid_mapping:   crs
    standard_name:  air_temperature
    height:         2 m
    cell_methods:   time: maximum(interval: 24 hours);mean over days
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 1128</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-7f7150c1-0a1a-4add-a192-5523fd747db2' class='xr-array-in' type='checkbox' checked><label for='section-7f7150c1-0a1a-4add-a192-5523fd747db2' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[62989776 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-62b94631-5084-44de-b1d7-73cfd618fd6f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-62b94631-5084-44de-b1d7-73cfd618fd6f' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-27f0e41a-6104-45e1-bc25-1e2396c7c9c1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-27f0e41a-6104-45e1-bc25-1e2396c7c9c1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3f1b8322-595b-4f78-8cf8-8193848b4641' class='xr-var-data-in' type='checkbox'><label for='data-3f1b8322-595b-4f78-8cf8-8193848b4641' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-eb073054-c3f2-4b90-845d-75211b774b2e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-eb073054-c3f2-4b90-845d-75211b774b2e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-364fd33e-980b-40ca-a8d7-108c9fa2a393' class='xr-var-data-in' type='checkbox'><label for='data-364fd33e-980b-40ca-a8d7-108c9fa2a393' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2006-01-15 00:00:00 ... 2099-12-...</div><input id='attrs-de82f710-7d6a-4cbc-90b7-017d4854e5ad' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-de82f710-7d6a-4cbc-90b7-017d4854e5ad' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8e80fa30-68bd-48b8-84fb-8ffff7361aef' class='xr-var-data-in' type='checkbox'><label for='data-8e80fa30-68bd-48b8-84fb-8ffff7361aef' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2006, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2006, 2, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2006, 3, 15, 0, 0, 0, 0), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-527424e1-ce01-4516-9ebd-42d14d476ddd' class='xr-section-summary-in' type='checkbox'  checked><label for='section-527424e1-ce01-4516-9ebd-42d14d476ddd' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>





Calculate a summary of max temperature over time for california


{:.input}
```python
# Time series plot of max temperature per year. for California
# You will get a RuntimeWarning warning here because of nan values...
# This is the max value in each pixel across all months for each year
cali_annual_max = cali_ts.groupby('time.year').max(skipna=True)
cali_annual_max
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (year: 94, lat: 227, lon: 246)&gt;
array([[[      nan,       nan,       nan, ..., 314.2675 , 314.05508,
         313.95047],
        [      nan,       nan,       nan, ..., 314.08972, 313.86816,
         313.9082 ],
        [      nan,       nan,       nan, ..., 314.02127, 313.8809 ,
         313.9658 ],
        ...,
        [      nan,       nan,       nan, ..., 304.58743, 304.74078,
         304.8877 ],
        [      nan,       nan,       nan, ..., 303.80627, 303.83685,
         304.6529 ],
        [      nan, 293.99442, 294.31528, ..., 302.92322, 302.578  ,
         303.59604]],

       [[      nan,       nan,       nan, ..., 314.5754 , 314.44275,
         314.34146],
        [      nan,       nan,       nan, ..., 314.50024, 314.32486,
         314.3367 ],
        [      nan,       nan,       nan, ..., 314.4508 , 314.33475,
         314.3861 ],
...
        [      nan,       nan,       nan, ..., 306.28198, 306.4167 ,
         306.61166],
        [      nan,       nan,       nan, ..., 305.46466, 305.49435,
         306.3104 ],
        [      nan, 296.4974 , 296.71976, ..., 304.55817, 304.22375,
         305.2304 ]],

       [[      nan,       nan,       nan, ..., 316.17175, 315.9877 ,
         315.91992],
        [      nan,       nan,       nan, ..., 316.05585, 315.89587,
         315.90164],
        [      nan,       nan,       nan, ..., 316.0458 , 315.94336,
         315.96744],
        ...,
        [      nan,       nan,       nan, ..., 309.6978 , 310.04214,
         310.2721 ],
        [      nan,       nan,       nan, ..., 308.9082 , 308.9424 ,
         309.8799 ],
        [      nan, 296.43567, 296.677  , ..., 307.94104, 307.59906,
         308.6584 ]]], dtype=float32)
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9
  * year     (year) int64 2006 2007 2008 2009 2010 ... 2095 2096 2097 2098 2099</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>year</span>: 94</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-f83f0e79-e03e-48ea-9e12-45dd055c2c2c' class='xr-array-in' type='checkbox' checked><label for='section-f83f0e79-e03e-48ea-9e12-45dd055c2c2c' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan ... 307.64276 307.94104 307.59906 308.6584</span></div><div class='xr-array-data'><pre>array([[[      nan,       nan,       nan, ..., 314.2675 , 314.05508,
         313.95047],
        [      nan,       nan,       nan, ..., 314.08972, 313.86816,
         313.9082 ],
        [      nan,       nan,       nan, ..., 314.02127, 313.8809 ,
         313.9658 ],
        ...,
        [      nan,       nan,       nan, ..., 304.58743, 304.74078,
         304.8877 ],
        [      nan,       nan,       nan, ..., 303.80627, 303.83685,
         304.6529 ],
        [      nan, 293.99442, 294.31528, ..., 302.92322, 302.578  ,
         303.59604]],

       [[      nan,       nan,       nan, ..., 314.5754 , 314.44275,
         314.34146],
        [      nan,       nan,       nan, ..., 314.50024, 314.32486,
         314.3367 ],
        [      nan,       nan,       nan, ..., 314.4508 , 314.33475,
         314.3861 ],
...
        [      nan,       nan,       nan, ..., 306.28198, 306.4167 ,
         306.61166],
        [      nan,       nan,       nan, ..., 305.46466, 305.49435,
         306.3104 ],
        [      nan, 296.4974 , 296.71976, ..., 304.55817, 304.22375,
         305.2304 ]],

       [[      nan,       nan,       nan, ..., 316.17175, 315.9877 ,
         315.91992],
        [      nan,       nan,       nan, ..., 316.05585, 315.89587,
         315.90164],
        [      nan,       nan,       nan, ..., 316.0458 , 315.94336,
         315.96744],
        ...,
        [      nan,       nan,       nan, ..., 309.6978 , 310.04214,
         310.2721 ],
        [      nan,       nan,       nan, ..., 308.9082 , 308.9424 ,
         309.8799 ],
        [      nan, 296.43567, 296.677  , ..., 307.94104, 307.59906,
         308.6584 ]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-f1f91a61-19ca-477f-8aeb-c80c36664b8e' class='xr-section-summary-in' type='checkbox'  checked><label for='section-f1f91a61-19ca-477f-8aeb-c80c36664b8e' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-44ca2131-dcfb-40c7-9e14-5bb835241736' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-44ca2131-dcfb-40c7-9e14-5bb835241736' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e5959b58-9c8e-46f5-aaad-68d6f8b1406a' class='xr-var-data-in' type='checkbox'><label for='data-e5959b58-9c8e-46f5-aaad-68d6f8b1406a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-9f18b5b8-ca8f-43f1-a1d1-2dd2c953929c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9f18b5b8-ca8f-43f1-a1d1-2dd2c953929c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-18fc3e40-1257-4e60-9aa7-4a10865abd98' class='xr-var-data-in' type='checkbox'><label for='data-18fc3e40-1257-4e60-9aa7-4a10865abd98' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>year</span></div><div class='xr-var-dims'>(year)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>2006 2007 2008 ... 2097 2098 2099</div><input id='attrs-a72c88db-3842-46e3-94f5-fad940651b89' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a72c88db-3842-46e3-94f5-fad940651b89' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-11f61e8f-8bbf-4004-85b0-9fba16f5ea01' class='xr-var-data-in' type='checkbox'><label for='data-11f61e8f-8bbf-4004-85b0-9fba16f5ea01' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017,
       2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029,
       2030, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2038, 2039, 2040, 2041,
       2042, 2043, 2044, 2045, 2046, 2047, 2048, 2049, 2050, 2051, 2052, 2053,
       2054, 2055, 2056, 2057, 2058, 2059, 2060, 2061, 2062, 2063, 2064, 2065,
       2066, 2067, 2068, 2069, 2070, 2071, 2072, 2073, 2074, 2075, 2076, 2077,
       2078, 2079, 2080, 2081, 2082, 2083, 2084, 2085, 2086, 2087, 2088, 2089,
       2090, 2091, 2092, 2093, 2094, 2095, 2096, 2097, 2098, 2099])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-9e069e28-0cea-4d07-8f29-2a9b8149e89d' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-9e069e28-0cea-4d07-8f29-2a9b8149e89d' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





### Calculate Annual Summary Data
You can calculate summary values for your aoi using the `.groupby`
method. Below you calculate the max value for each raster in the 
time series 

`.max(["lat", "lon"]` tells xarray to calculate the max on the entire raster.

the data are grouped by year. 


{:.input}
```python
cali_annual_max_val = cali_annual_max.groupby("year").max(["lat", "lon"])
cali_annual_max_val
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (year: 94)&gt;
array([320.67538, 322.2723 , 320.86505, 321.88   , 321.55954, 320.30484,
       322.17026, 322.1134 , 322.16568, 321.32007, 321.67624, 322.07996,
       321.5724 , 320.7888 , 321.4106 , 320.6512 , 322.2032 , 322.18158,
       322.05664, 322.96497, 322.20325, 321.28458, 321.51407, 324.0671 ,
       323.02896, 322.10184, 322.73853, 322.56485, 321.98178, 322.4918 ,
       322.19852, 322.44962, 321.97635, 322.33276, 322.55652, 322.4373 ,
       322.4933 , 323.7776 , 323.3054 , 321.22037, 322.00476, 322.40897,
       323.43805, 323.57452, 322.63904, 321.85776, 324.09442, 323.27408,
       323.67053, 322.62167, 323.70203, 322.82205, 321.93048, 323.48462,
       323.89087, 323.4939 , 324.15057, 322.88406, 322.6229 , 324.0509 ,
       323.06467, 324.27808, 324.30505, 323.27487, 323.3609 , 324.03644,
       323.1147 , 324.6987 , 322.52747, 323.00424, 324.0726 , 322.78583,
       323.49216, 322.4643 , 321.52664, 323.14383, 323.44632, 323.4093 ,
       324.51718, 322.68958, 324.83566, 323.24158, 323.22598, 323.8113 ,
       323.70255, 321.93524, 325.1739 , 322.6527 , 323.33313, 323.01407,
       323.40854, 323.8004 , 321.59985, 324.6846 ], dtype=float32)
Coordinates:
  * year     (year) int64 2006 2007 2008 2009 2010 ... 2095 2096 2097 2098 2099</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>year</span>: 94</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-3a1daf91-8258-4da6-9477-9f860b11e818' class='xr-array-in' type='checkbox' checked><label for='section-3a1daf91-8258-4da6-9477-9f860b11e818' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>320.67538 322.2723 320.86505 321.88 ... 323.8004 321.59985 324.6846</span></div><div class='xr-array-data'><pre>array([320.67538, 322.2723 , 320.86505, 321.88   , 321.55954, 320.30484,
       322.17026, 322.1134 , 322.16568, 321.32007, 321.67624, 322.07996,
       321.5724 , 320.7888 , 321.4106 , 320.6512 , 322.2032 , 322.18158,
       322.05664, 322.96497, 322.20325, 321.28458, 321.51407, 324.0671 ,
       323.02896, 322.10184, 322.73853, 322.56485, 321.98178, 322.4918 ,
       322.19852, 322.44962, 321.97635, 322.33276, 322.55652, 322.4373 ,
       322.4933 , 323.7776 , 323.3054 , 321.22037, 322.00476, 322.40897,
       323.43805, 323.57452, 322.63904, 321.85776, 324.09442, 323.27408,
       323.67053, 322.62167, 323.70203, 322.82205, 321.93048, 323.48462,
       323.89087, 323.4939 , 324.15057, 322.88406, 322.6229 , 324.0509 ,
       323.06467, 324.27808, 324.30505, 323.27487, 323.3609 , 324.03644,
       323.1147 , 324.6987 , 322.52747, 323.00424, 324.0726 , 322.78583,
       323.49216, 322.4643 , 321.52664, 323.14383, 323.44632, 323.4093 ,
       324.51718, 322.68958, 324.83566, 323.24158, 323.22598, 323.8113 ,
       323.70255, 321.93524, 325.1739 , 322.6527 , 323.33313, 323.01407,
       323.40854, 323.8004 , 321.59985, 324.6846 ], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-9ff43592-b242-450c-8bd4-529224a4cfc5' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9ff43592-b242-450c-8bd4-529224a4cfc5' class='xr-section-summary' >Coordinates: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>year</span></div><div class='xr-var-dims'>(year)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>2006 2007 2008 ... 2097 2098 2099</div><input id='attrs-de9eb25b-7a9a-486f-966b-e03006a7fa1f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-de9eb25b-7a9a-486f-966b-e03006a7fa1f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1906e3dd-24da-450b-84bc-3f0812fc6f25' class='xr-var-data-in' type='checkbox'><label for='data-1906e3dd-24da-450b-84bc-3f0812fc6f25' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017,
       2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029,
       2030, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2038, 2039, 2040, 2041,
       2042, 2043, 2044, 2045, 2046, 2047, 2048, 2049, 2050, 2051, 2052, 2053,
       2054, 2055, 2056, 2057, 2058, 2059, 2060, 2061, 2062, 2063, 2064, 2065,
       2066, 2067, 2068, 2069, 2070, 2071, 2072, 2073, 2074, 2075, 2076, 2077,
       2078, 2079, 2080, 2081, 2082, 2083, 2084, 2085, 2086, 2087, 2088, 2089,
       2090, 2091, 2092, 2093, 2094, 2095, 2096, 2097, 2098, 2099])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-4ab0d339-0c3f-407a-8fee-7f504f9fb66c' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-4ab0d339-0c3f-407a-8fee-7f504f9fb66c' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
# Plot the data
f, ax = plt.subplots(figsize=(12, 6))
cali_annual_max_val.plot.line(hue='lat',
                              marker="o",
                              ax=ax,
                              color="grey",
                              markerfacecolor="purple",
                              markeredgecolor="purple")
ax.set(title="Annual Max Temperature (K) in California")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_25_0.png" alt = "Scatter plot showing the annual max temperature as projected in the California from 2009 to 2100 using MACA v2 climate data.">
<figcaption>Scatter plot showing the annual max temperature as projected in the California from 2009 to 2100 using MACA v2 climate data.</figcaption>

</figure>




## Subset a netcdf4 Using a Shapefile Feature or Features

Above you created a rectangular spatial subset and plotted the data. 
Sometimes however you may have an AOI that is a specific polygon boundary.
Below you will modify your subset to represent just the region of the 
state of California. You will use the `regionmask` package to create
this mask.

{:.input}
```python
# This is the AOI of interest. You only want to calculate summary values for
# pixels within this AOI rather the entire rectangular spatial extent.
f, ax = plt.subplots()
cali_aoi.plot(ax=ax)
ax.set(title="California AOI Subset")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_27_0.png" alt = "Plot showing the area of interest - California.">
<figcaption>Plot showing the area of interest - California.</figcaption>

</figure>




You will use the cali_aoi object created above to first create a 
mask.

{:.input}
```python
cali_aoi
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
      <th>featurecla</th>
      <th>scalerank</th>
      <th>adm1_code</th>
      <th>diss_me</th>
      <th>iso_3166_2</th>
      <th>wikipedia</th>
      <th>iso_a2</th>
      <th>adm0_sr</th>
      <th>name</th>
      <th>name_alt</th>
      <th>...</th>
      <th>name_nl</th>
      <th>name_pl</th>
      <th>name_pt</th>
      <th>name_ru</th>
      <th>name_sv</th>
      <th>name_tr</th>
      <th>name_vi</th>
      <th>name_zh</th>
      <th>ne_id</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>53</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>USA-3521</td>
      <td>3521</td>
      <td>US-CA</td>
      <td>http://en.wikipedia.org/wiki/California</td>
      <td>US</td>
      <td>8</td>
      <td>California</td>
      <td>CA|Calif.</td>
      <td>...</td>
      <td>Californië</td>
      <td>Kalifornia</td>
      <td>Califórnia</td>
      <td>Калифорния</td>
      <td>Kalifornien</td>
      <td>Kaliforniya</td>
      <td>California</td>
      <td>加利福尼亚州</td>
      <td>1159308415</td>
      <td>MULTIPOLYGON (((-114.61054 34.99112, -114.6109...</td>
    </tr>
  </tbody>
</table>
<p>1 rows × 84 columns</p>
</div>








{:.output}
{:.execute_result}



    <regionmask.Regions>
    Name:     name
    
    Regions:
     53  California  ...
    
    [1 regions]








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_33_0.png" alt = "Plot showing the mask region for the AOI - California, USA.">
<figcaption>Plot showing the mask region for the AOI - California, USA.</figcaption>

</figure>







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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;region&#x27; (lat: 585, lon: 1386)&gt;
array([[nan, nan, nan, ..., nan, nan, nan],
       [nan, nan, nan, ..., nan, nan, nan],
       [nan, nan, nan, ..., nan, nan, nan],
       ...,
       [nan, nan, nan, ..., nan, nan, nan],
       [nan, nan, nan, ..., nan, nan, nan],
       [nan, nan, nan, ..., nan, nan, nan]])
Coordinates:
  * lat      (lat) float64 25.06 25.1 25.15 25.19 ... 49.27 49.31 49.35 49.4
  * lon      (lon) float64 235.2 235.3 235.3 235.4 ... 292.8 292.9 292.9 292.9</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'region'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>lat</span>: 585</li><li><span class='xr-has-index'>lon</span>: 1386</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-0a107048-4a7a-4f6b-b9a2-5ef7834eb128' class='xr-array-in' type='checkbox' checked><label for='section-0a107048-4a7a-4f6b-b9a2-5ef7834eb128' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... nan nan nan nan nan nan nan nan</span></div><div class='xr-array-data'><pre>array([[nan, nan, nan, ..., nan, nan, nan],
       [nan, nan, nan, ..., nan, nan, nan],
       [nan, nan, nan, ..., nan, nan, nan],
       ...,
       [nan, nan, nan, ..., nan, nan, nan],
       [nan, nan, nan, ..., nan, nan, nan],
       [nan, nan, nan, ..., nan, nan, nan]])</pre></div></div></li><li class='xr-section-item'><input id='section-c21a9bc8-9380-4b90-a4f1-d0b306986412' class='xr-section-summary-in' type='checkbox'  checked><label for='section-c21a9bc8-9380-4b90-a4f1-d0b306986412' class='xr-section-summary' >Coordinates: <span>(2)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>25.06 25.1 25.15 ... 49.35 49.4</div><input id='attrs-6cdaf3c1-9b75-4757-a461-3e76dcd0ea5a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6cdaf3c1-9b75-4757-a461-3e76dcd0ea5a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f9dce57a-04dc-46a5-8bea-0fe8153984c0' class='xr-var-data-in' type='checkbox'><label for='data-f9dce57a-04dc-46a5-8bea-0fe8153984c0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([25.063078, 25.104744, 25.14641 , ..., 49.312691, 49.354359, 49.396023])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.2 235.3 235.3 ... 292.9 292.9</div><input id='attrs-5de7c73c-47b9-4e0b-926d-5913849ff22a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5de7c73c-47b9-4e0b-926d-5913849ff22a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6c34089c-e287-4a52-94e4-0ec36c708b5d' class='xr-var-data-in' type='checkbox'><label for='data-6c34089c-e287-4a52-94e4-0ec36c708b5d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([235.227844, 235.269501, 235.311157, ..., 292.851929, 292.893585,
       292.935242])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-b252a1e2-4d6f-484f-b412-08c947c4a01b' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-b252a1e2-4d6f-484f-b412-08c947c4a01b' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>






{:.output}
{:.execute_result}



    (<xarray.DataArray 'region' ()>
     array(53.),
     <xarray.DataArray 'region' ()>
     array(53.))






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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 2, lat: 227, lon: 246)&gt;
array([[[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]],

       [[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]]], dtype=float32)
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 41.85 41.9 41.94 41.98
  * lon      (lon) float64 235.6 235.7 235.7 235.8 ... 245.7 245.8 245.8 245.9
  * time     (time) object 2010-01-15 00:00:00 2010-02-15 00:00:00
Attributes:
    long_name:      Monthly Average of Daily Maximum Near-Surface Air Tempera...
    units:          K
    grid_mapping:   crs
    standard_name:  air_temperature
    height:         2 m
    cell_methods:   time: maximum(interval: 24 hours);mean over days
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 2</li><li><span class='xr-has-index'>lat</span>: 227</li><li><span class='xr-has-index'>lon</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-f2d615b9-758d-4c36-97c5-8776e881f52a' class='xr-array-in' type='checkbox' checked><label for='section-f2d615b9-758d-4c36-97c5-8776e881f52a' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... nan nan nan nan nan nan nan nan</span></div><div class='xr-array-data'><pre>array([[[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]],

       [[nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        ...,
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan],
        [nan, nan, nan, ..., nan, nan, nan]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-258ea300-ec8d-41ff-b5b0-c7d55556c75a' class='xr-section-summary-in' type='checkbox'  checked><label for='section-258ea300-ec8d-41ff-b5b0-c7d55556c75a' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 41.94 41.98</div><input id='attrs-9a3b6191-0402-47ab-a0ad-52f1b8986e4e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9a3b6191-0402-47ab-a0ad-52f1b8986e4e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6bc312b7-ded5-4f9c-99f7-4ac8ec4a0108' class='xr-var-data-in' type='checkbox'><label for='data-6bc312b7-ded5-4f9c-99f7-4ac8ec4a0108' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 41.896141, 41.937809, 41.979473])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.6 235.7 235.7 ... 245.8 245.9</div><input id='attrs-7ccd0303-872d-4a77-b8e2-34ea75309a53' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7ccd0303-872d-4a77-b8e2-34ea75309a53' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7d1f3602-d577-48b9-a1c1-cd85631d6ad5' class='xr-var-data-in' type='checkbox'><label for='data-7d1f3602-d577-48b9-a1c1-cd85631d6ad5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.644501, 235.686157, 235.727829, ..., 245.769333, 245.811005,
       245.852661])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2010-01-15 00:00:00 2010-02-15 0...</div><input id='attrs-4e74ba3c-088b-4695-b435-812eb5d32f0d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4e74ba3c-088b-4695-b435-812eb5d32f0d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f4658279-4cae-4489-83e2-f842f62f7cb4' class='xr-var-data-in' type='checkbox'><label for='data-f4658279-4cae-4489-83e2-f842f62f7cb4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2010, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2010, 2, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-164d4f85-2b07-4735-bc15-e5ac67fae63b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-164d4f85-2b07-4735-bc15-e5ac67fae63b' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_39_0.png" alt = "Map showing mean temperature for California in Januray and Feb 2010.">
<figcaption>Map showing mean temperature for California in Januray and Feb 2010.</figcaption>

</figure>





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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 2)&gt;
array([286.05795, 286.02655], dtype=float32)
Coordinates:
  * time     (time) object 2010-01-15 00:00:00 2010-02-15 00:00:00</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 2</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-08fd05de-46f9-4c37-8064-361ef794019b' class='xr-array-in' type='checkbox' checked><label for='section-08fd05de-46f9-4c37-8064-361ef794019b' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>286.05795 286.02655</span></div><div class='xr-array-data'><pre>array([286.05795, 286.02655], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-4dd4fa65-dd39-45bc-8cd5-9f6dbf66f964' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4dd4fa65-dd39-45bc-8cd5-9f6dbf66f964' class='xr-section-summary' >Coordinates: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2010-01-15 00:00:00 2010-02-15 0...</div><input id='attrs-62c0ba2c-32d5-4922-997f-3563d0ec0045' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-62c0ba2c-32d5-4922-997f-3563d0ec0045' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-385ed50a-8e89-4939-b98b-b7ac69455292' class='xr-var-data-in' type='checkbox'><label for='data-385ed50a-8e89-4939-b98b-b7ac69455292' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2010, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2010, 2, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-4fb96387-9423-452d-b900-ef646ec84ab7' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-4fb96387-9423-452d-b900-ef646ec84ab7' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





{:.input}
```python
# Create a 3d mask - this contains the true / false values identifying pixels
# inside vs outside of the mask region
cali_mask = regionmask.mask_3D_geopandas(cali_aoi,
                                         monthly_forecast_temp_xr.lon,
                                         monthly_forecast_temp_xr.lat)
cali_mask
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;region&#x27; (region: 1, lat: 585, lon: 1386)&gt;
array([[[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]]])
Coordinates:
  * lat      (lat) float64 25.06 25.1 25.15 25.19 ... 49.27 49.31 49.35 49.4
  * lon      (lon) float64 235.2 235.3 235.3 235.4 ... 292.8 292.9 292.9 292.9
  * region   (region) int64 53</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'region'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>region</span>: 1</li><li><span class='xr-has-index'>lat</span>: 585</li><li><span class='xr-has-index'>lon</span>: 1386</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-f424adb3-f5f5-46ef-964a-45b5e85836d9' class='xr-array-in' type='checkbox' checked><label for='section-f424adb3-f5f5-46ef-964a-45b5e85836d9' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>False False False False False False ... False False False False False</span></div><div class='xr-array-data'><pre>array([[[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]]])</pre></div></div></li><li class='xr-section-item'><input id='section-403f4ee9-caa7-4fb3-9ea1-e64fc6ca6219' class='xr-section-summary-in' type='checkbox'  checked><label for='section-403f4ee9-caa7-4fb3-9ea1-e64fc6ca6219' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>25.06 25.1 25.15 ... 49.35 49.4</div><input id='attrs-9fa6ef22-d21b-4dc0-ad10-b8c7e3f9b232' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-9fa6ef22-d21b-4dc0-ad10-b8c7e3f9b232' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d25b0eeb-5e14-43f7-b0d1-7816b18e6749' class='xr-var-data-in' type='checkbox'><label for='data-d25b0eeb-5e14-43f7-b0d1-7816b18e6749' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([25.063078, 25.104744, 25.14641 , ..., 49.312691, 49.354359, 49.396023])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.2 235.3 235.3 ... 292.9 292.9</div><input id='attrs-3005944e-54f8-43b3-a98f-a0ab135df37e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-3005944e-54f8-43b3-a98f-a0ab135df37e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2d36b5d1-3ae4-4db5-adda-acaa6b3b9cf6' class='xr-var-data-in' type='checkbox'><label for='data-2d36b5d1-3ae4-4db5-adda-acaa6b3b9cf6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([235.227844, 235.269501, 235.311157, ..., 292.851929, 292.893585,
       292.935242])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53</div><input id='attrs-ea0489ee-f1db-47af-b275-edb74d8b11d3' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-ea0489ee-f1db-47af-b275-edb74d8b11d3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-edd69b34-fac0-4886-9320-5e163b427f3c' class='xr-var-data-in' type='checkbox'><label for='data-edd69b34-fac0-4886-9320-5e163b427f3c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-aeb3338d-eb72-4bf1-a469-59e08d39a4a9' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-aeb3338d-eb72-4bf1-a469-59e08d39a4a9' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





To make processing a bit quicker, below you slice out two months of the data.

{:.input}
```python
# Slice out two months of data
two_months = monthly_forecast_temp_xr.sel(
    time=slice('2099-10-25', '2099-12-15'))
```

Next, apply the mask for just the state of California to the data. 

{:.input}
```python
# Apply the mask for California to the data
two_months = two_months.where(cali_mask)
two_months
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
Dimensions:          (crs: 1, lat: 585, lon: 1386, region: 1, time: 2)
Coordinates:
  * lat              (lat) float64 25.06 25.1 25.15 25.19 ... 49.31 49.35 49.4
  * crs              (crs) int32 1
  * lon              (lon) float64 235.2 235.3 235.3 235.4 ... 292.9 292.9 292.9
  * time             (time) object 2099-11-15 00:00:00 2099-12-15 00:00:00
  * region           (region) int64 53
Data variables:
    air_temperature  (time, lat, lon, region) float32 nan nan nan ... nan nan
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
    coordinate_system:               WGS84,EPSG:4326</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-d455592c-7b67-4872-b39d-f8075f88df1b' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-d455592c-7b67-4872-b39d-f8075f88df1b' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>crs</span>: 1</li><li><span class='xr-has-index'>lat</span>: 585</li><li><span class='xr-has-index'>lon</span>: 1386</li><li><span class='xr-has-index'>region</span>: 1</li><li><span class='xr-has-index'>time</span>: 2</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-29abfa69-e460-46de-af9b-f79633050860' class='xr-section-summary-in' type='checkbox'  checked><label for='section-29abfa69-e460-46de-af9b-f79633050860' class='xr-section-summary' >Coordinates: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>25.06 25.1 25.15 ... 49.35 49.4</div><input id='attrs-5d18da9b-ed25-4b25-a42b-342960c40fcd' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5d18da9b-ed25-4b25-a42b-342960c40fcd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-06334f2f-7c75-4b46-a701-a56f1a19533b' class='xr-var-data-in' type='checkbox'><label for='data-06334f2f-7c75-4b46-a701-a56f1a19533b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([25.063078, 25.104744, 25.14641 , ..., 49.312691, 49.354359, 49.396023])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>crs</span></div><div class='xr-var-dims'>(crs)</div><div class='xr-var-dtype'>int32</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-53016e60-53be-43c0-960f-0ce11693123e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-53016e60-53be-43c0-960f-0ce11693123e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-92d7549b-acef-4c14-b391-20333d744a50' class='xr-var-data-in' type='checkbox'><label for='data-92d7549b-acef-4c14-b391-20333d744a50' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>grid_mapping_name :</span></dt><dd>latitude_longitude</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd></dl></div><div class='xr-var-data'><pre>array([1], dtype=int32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.2 235.3 235.3 ... 292.9 292.9</div><input id='attrs-0538ac8f-a03f-477e-8c3c-e63af8e18930' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0538ac8f-a03f-477e-8c3c-e63af8e18930' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a7d9e370-99a0-4faf-b065-3158f892bc80' class='xr-var-data-in' type='checkbox'><label for='data-a7d9e370-99a0-4faf-b065-3158f892bc80' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.227844, 235.269501, 235.311157, ..., 292.851929, 292.893585,
       292.935242])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2099-11-15 00:00:00 2099-12-15 0...</div><input id='attrs-bb6a48ef-bafe-41e0-8922-299e1ab74143' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-bb6a48ef-bafe-41e0-8922-299e1ab74143' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-748e6249-a584-49be-add9-900add5b1123' class='xr-var-data-in' type='checkbox'><label for='data-748e6249-a584-49be-add9-900add5b1123' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53</div><input id='attrs-dc4da1ad-6ba8-404a-b2ef-fb43b97478b0' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-dc4da1ad-6ba8-404a-b2ef-fb43b97478b0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-113db859-e5de-4551-9ca0-f7b966815579' class='xr-var-data-in' type='checkbox'><label for='data-113db859-e5de-4551-9ca0-f7b966815579' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-51bf090d-8f16-4188-a543-1c076a81f850' class='xr-section-summary-in' type='checkbox'  checked><label for='section-51bf090d-8f16-4188-a543-1c076a81f850' class='xr-section-summary' >Data variables: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>air_temperature</span></div><div class='xr-var-dims'>(time, lat, lon, region)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan nan nan ... nan nan nan nan</div><input id='attrs-6d44f8e5-5f78-41bb-8949-b30d1cbbd144' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6d44f8e5-5f78-41bb-8949-b30d1cbbd144' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-837f143b-7076-46e1-9859-1d1908b9e837' class='xr-var-data-in' type='checkbox'><label for='data-837f143b-7076-46e1-9859-1d1908b9e837' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div><div class='xr-var-data'><pre>array([[[[nan],
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
         [nan]]]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-423ed265-9804-4491-ab0c-6649070f4a65' class='xr-section-summary-in' type='checkbox'  ><label for='section-423ed265-9804-4491-ab0c-6649070f4a65' class='xr-section-summary' >Attributes: <span>(46)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>Multivariate Adaptive Constructed Analogs (MACA) method, version 2.3,Dec 2013.</dd><dt><span>id :</span></dt><dd>MACAv2-METDATA</dd><dt><span>naming_authority :</span></dt><dd>edu.uidaho.reacch</dd><dt><span>Metadata_Conventions :</span></dt><dd>Unidata Dataset Discovery v1.0</dd><dt><span>Metadata_Link :</span></dt><dd></dd><dt><span>cdm_data_type :</span></dt><dd>FLOAT</dd><dt><span>title :</span></dt><dd>Monthly aggregation of downscaled daily meteorological data of Monthly Average of Daily Maximum Near-Surface Air Temperature from College of Global Change and Earth System Science, Beijing Normal University (BNU-ESM) using the run r1i1p1 of the rcp45 scenario.</dd><dt><span>summary :</span></dt><dd>This archive contains monthly downscaled meteorological and hydrological projections for the Conterminous United States at 1/24-deg resolution. These monthly values are obtained by aggregating the daily values obtained from the downscaling using the Multivariate Adaptive Constructed Analogs (MACA, Abatzoglou, 2012) statistical downscaling method with the METDATA (Abatzoglou,2013) training dataset. The downscaled meteorological variables are maximum/minimum temperature(tasmax/tasmin), maximum/minimum relative humidity (rhsmax/rhsmin),precipitation amount(pr), downward shortwave solar radiation(rsds), eastward wind(uas), northward wind(vas), and specific humidity(huss). The downscaling is based on the 365-day model outputs from different global climate models (GCMs) from Phase 5 of the Coupled Model Inter-comparison Project (CMIP3) utlizing the historical (1950-2005) and future RCP4.5/8.5(2006-2099) scenarios. </dd><dt><span>keywords :</span></dt><dd>monthly, precipitation, maximum temperature, minimum temperature, downward shortwave solar radiation, specific humidity, wind velocity, CMIP5, Gridded Meteorological Data</dd><dt><span>keywords_vocabulary :</span></dt><dd></dd><dt><span>standard_name_vocabulary :</span></dt><dd>CF-1.0</dd><dt><span>history :</span></dt><dd>No revisions.</dd><dt><span>comment :</span></dt><dd></dd><dt><span>geospatial_bounds :</span></dt><dd>POLYGON((-124.7722 25.0631,-124.7722 49.3960, -67.0648 49.3960,-67.0648, 25.0631, -124.7722,25.0631))</dd><dt><span>geospatial_lat_min :</span></dt><dd>25.0631</dd><dt><span>geospatial_lat_max :</span></dt><dd>49.3960</dd><dt><span>geospatial_lon_min :</span></dt><dd>-124.7722</dd><dt><span>geospatial_lon_max :</span></dt><dd>-67.0648</dd><dt><span>geospatial_lat_units :</span></dt><dd>decimal degrees north</dd><dt><span>geospatial_lon_units :</span></dt><dd>decimal degrees east</dd><dt><span>geospatial_lat_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_lon_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_vertical_min :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_max :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_resolution :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_positive :</span></dt><dd>up</dd><dt><span>time_coverage_start :</span></dt><dd>2091-01-01T00:0</dd><dt><span>time_coverage_end :</span></dt><dd>2095-12-31T00:00</dd><dt><span>time_coverage_duration :</span></dt><dd>P5Y</dd><dt><span>time_coverage_resolution :</span></dt><dd>P1M</dd><dt><span>date_created :</span></dt><dd>2014-05-15</dd><dt><span>date_modified :</span></dt><dd>2014-05-15</dd><dt><span>date_issued :</span></dt><dd>2014-05-15</dd><dt><span>creator_name :</span></dt><dd>John Abatzoglou</dd><dt><span>creator_url :</span></dt><dd>http://maca.northwestknowledge.net</dd><dt><span>creator_email :</span></dt><dd>jabatzoglou@uidaho.edu</dd><dt><span>institution :</span></dt><dd>University of Idaho</dd><dt><span>processing_level :</span></dt><dd>GRID</dd><dt><span>project :</span></dt><dd></dd><dt><span>contributor_name :</span></dt><dd>Katherine C. Hegewisch</dd><dt><span>contributor_role :</span></dt><dd>Postdoctoral Fellow</dd><dt><span>publisher_name :</span></dt><dd>REACCH</dd><dt><span>publisher_email :</span></dt><dd>reacch@uidaho.edu</dd><dt><span>publisher_url :</span></dt><dd>http://www.reacchpna.org/</dd><dt><span>license :</span></dt><dd>Creative Commons CC0 1.0 Universal Dedication(http://creativecommons.org/publicdomain/zero/1.0/legalcode)</dd><dt><span>coordinate_system :</span></dt><dd>WGS84,EPSG:4326</dd></dl></div></li></ul></div></div>





Below you can see that the data for only the region of interest - 
California, is plotted. However, you have a lot of extra white space
surrounding the data.

{:.input}
```python
two_months["air_temperature"].plot(col='time',
                                   col_wrap=1,
                                   figsize=(10, 10))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_47_0.png" alt = "Map showing temperature values where California is masked however the data are not subsetted so you have significant additional white space / no data values in the data.">
<figcaption>Map showing temperature values where California is masked however the data are not subsetted so you have significant additional white space / no data values in the data.</figcaption>

</figure>




If you slice our your data by time and lat lon and apply the mask for your 
AOI you get the d

{:.input}
```python
two_months_masked = monthly_forecast_temp_xr["air_temperature"].sel(time=slice('2099-10-25',
                                                                               '2099-12-15'),
                                                                    lon=slice(aoi_lon[0],
                                                                              aoi_lon[1]),
                                                                    lat=slice(aoi_lat[0],
                                                                              aoi_lat[1])).where(cali_mask)
two_months_masked.dims
```

{:.output}
{:.execute_result}



    ('time', 'lat', 'lon', 'region')





{:.input}
```python
two_months_masked.plot(col='time', col_wrap=1)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_50_0.png" alt = "Map showing temperature for California after the data have been masked and sliced by AOI.">
<figcaption>Map showing temperature for California after the data have been masked and sliced by AOI.</figcaption>

</figure>




## Workflow with Multiple Regions

In the example above, you had one region of interest. Below you will implement a 
workflow where you have multiple regions. For this example, you will subset multiple states
from your shapefile. 

{:.input}
```python
# Start by extracting a few states from the states_gdf
states_gdf["name"]

cali_or_wash_nev = states_gdf[states_gdf.name.isin(
    ["California", "Oregon", "Washington", "Nevada"])]
cali_or_wash_nev.plot()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_52_0.png" alt = "Map showing a new study area containing multiple AOI's which in this case are 4 states in the western United States.">
<figcaption>Map showing a new study area containing multiple AOI's which in this case are 4 states in the western United States.</figcaption>

</figure>




Next, create a mask just like you did above. However this time
you will use the new extent that contains 4 states (4 regions). 

{:.input}
```python
west_mask = regionmask.mask_3D_geopandas(cali_or_wash_nev,
                                         monthly_forecast_temp_xr.lon,
                                         monthly_forecast_temp_xr.lat)
west_mask
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;region&#x27; (region: 4, lat: 585, lon: 1386)&gt;
array([[[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]],

       [[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]],

       [[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]],

       [[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]]])
Coordinates:
  * lat      (lat) float64 25.06 25.1 25.15 25.19 ... 49.27 49.31 49.35 49.4
  * lon      (lon) float64 235.2 235.3 235.3 235.4 ... 292.8 292.9 292.9 292.9
  * region   (region) int64 53 82 86 96</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'region'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>region</span>: 4</li><li><span class='xr-has-index'>lat</span>: 585</li><li><span class='xr-has-index'>lon</span>: 1386</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-7ea31207-f70a-41d7-a9d6-bd98bc617d32' class='xr-array-in' type='checkbox' checked><label for='section-7ea31207-f70a-41d7-a9d6-bd98bc617d32' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>False False False False False False ... False False False False False</span></div><div class='xr-array-data'><pre>array([[[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]],

       [[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]],

       [[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]],

       [[False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        ...,
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False],
        [False, False, False, ..., False, False, False]]])</pre></div></div></li><li class='xr-section-item'><input id='section-1c6d3daf-1202-4259-b189-03c117b5ebea' class='xr-section-summary-in' type='checkbox'  checked><label for='section-1c6d3daf-1202-4259-b189-03c117b5ebea' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>25.06 25.1 25.15 ... 49.35 49.4</div><input id='attrs-1621e910-5dee-44e2-bdfd-a6910a51b5c1' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-1621e910-5dee-44e2-bdfd-a6910a51b5c1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c06b3364-b82e-40eb-96e1-a296cd513c98' class='xr-var-data-in' type='checkbox'><label for='data-c06b3364-b82e-40eb-96e1-a296cd513c98' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([25.063078, 25.104744, 25.14641 , ..., 49.312691, 49.354359, 49.396023])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.2 235.3 235.3 ... 292.9 292.9</div><input id='attrs-37a9265b-e288-4062-8da0-1b799c37d767' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-37a9265b-e288-4062-8da0-1b799c37d767' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ef12ea3c-e4e0-44d6-a7d2-35038a5ff966' class='xr-var-data-in' type='checkbox'><label for='data-ef12ea3c-e4e0-44d6-a7d2-35038a5ff966' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([235.227844, 235.269501, 235.311157, ..., 292.851929, 292.893585,
       292.935242])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53 82 86 96</div><input id='attrs-d0e295a3-e8c5-4c46-87b1-8ec36dc96f4d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-d0e295a3-e8c5-4c46-87b1-8ec36dc96f4d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ecab1682-135d-4b4f-9946-18b6e78624ef' class='xr-var-data-in' type='checkbox'><label for='data-ecab1682-135d-4b4f-9946-18b6e78624ef' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53, 82, 86, 96])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-0fe9f3d0-b74e-4b6b-82c9-8c1a043e8c17' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-0fe9f3d0-b74e-4b6b-82c9-8c1a043e8c17' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





Below is a small helper function that grabs the AOI from a shapefile and 
returns a dictionary that you can use to slice your data. 

{:.input}
```python
def get_aoi(shp, world=True):
    """Takes a geopandas object and converts it to a lat/ lon
    extent 

    Parameters
    -----------
    shp : geopandas object
    world : boolean

    Returns
    -------
    Dictionary of lat and lon spatial bounds
    """

    lon_lat = {}
    # Get lat min, max
    aoi_lat = [float(shp.total_bounds[1]), float(shp.total_bounds[3])]
    aoi_lon = [float(shp.total_bounds[0]), float(shp.total_bounds[2])]

    if world:
        aoi_lon[0] = aoi_lon[0] + 360
        aoi_lon[1] = aoi_lon[1] + 360
    lon_lat["lon"] = aoi_lon
    lon_lat["lat"] = aoi_lat
    return lon_lat


west_bounds = get_aoi(cali_or_wash_nev)
```

Similar to your workflow above, you can subset that data as you wish by time and 
extent. Subsetting the data will make all of your data processing faster!

{:.input}
```python
# Slice the data
start_date = "2010-01-15"
end_date = "2010-02-15"

# Subset
two_months_west_coast = monthly_forecast_temp_xr["air_temperature"].sel(
    time=slice(start_date, end_date),
    lon=slice(west_bounds["lon"][0], west_bounds["lon"][1]),
    lat=slice(west_bounds["lat"][0], west_bounds["lat"][1]))
two_months_west_coast
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 2, lat: 395, lon: 256)&gt;
[202240 values with dtype=float32]
Coordinates:
  * lat      (lat) float64 32.56 32.6 32.65 32.69 ... 48.85 48.9 48.94 48.98
  * lon      (lon) float64 235.3 235.4 235.4 235.4 ... 245.8 245.9 245.9 245.9
  * time     (time) object 2010-01-15 00:00:00 2010-02-15 00:00:00
Attributes:
    long_name:      Monthly Average of Daily Maximum Near-Surface Air Tempera...
    units:          K
    grid_mapping:   crs
    standard_name:  air_temperature
    height:         2 m
    cell_methods:   time: maximum(interval: 24 hours);mean over days
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 2</li><li><span class='xr-has-index'>lat</span>: 395</li><li><span class='xr-has-index'>lon</span>: 256</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-e0d0f46d-4be4-4084-9e67-70e8c9f51917' class='xr-array-in' type='checkbox' checked><label for='section-e0d0f46d-4be4-4084-9e67-70e8c9f51917' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[202240 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-091ec09e-7ea8-45c8-864c-4f2b8a48cdd6' class='xr-section-summary-in' type='checkbox'  checked><label for='section-091ec09e-7ea8-45c8-864c-4f2b8a48cdd6' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>32.56 32.6 32.65 ... 48.94 48.98</div><input id='attrs-290a0869-063a-408d-b8af-a0bdf01e56a1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-290a0869-063a-408d-b8af-a0bdf01e56a1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-47805691-33e2-4bac-bd47-a96603f16a4d' class='xr-var-data-in' type='checkbox'><label for='data-47805691-33e2-4bac-bd47-a96603f16a4d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([32.562958, 32.604626, 32.64629 , ..., 48.89603 , 48.937698, 48.979362])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.3 235.4 235.4 ... 245.9 245.9</div><input id='attrs-6cf89378-b27c-4f0d-8063-6a627104fc45' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6cf89378-b27c-4f0d-8063-6a627104fc45' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e384b007-8844-47ab-a5c4-92a1b954dd21' class='xr-var-data-in' type='checkbox'><label for='data-e384b007-8844-47ab-a5c4-92a1b954dd21' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.311157, 235.352844, 235.394501, ..., 245.852661, 245.894333,
       245.936005])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2010-01-15 00:00:00 2010-02-15 0...</div><input id='attrs-84eb9607-a4dd-4b21-8600-2f1e2aaa753c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-84eb9607-a4dd-4b21-8600-2f1e2aaa753c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cd52f913-f94b-4b7a-a5f1-b95d12a0fa07' class='xr-var-data-in' type='checkbox'><label for='data-cd52f913-f94b-4b7a-a5f1-b95d12a0fa07' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2010, 1, 15, 0, 0, 0, 0),
       cftime.DatetimeNoLeap(2010, 2, 15, 0, 0, 0, 0)], dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-04c34d3f-ce80-41ac-976b-febd9b03a759' class='xr-section-summary-in' type='checkbox'  checked><label for='section-04c34d3f-ce80-41ac-976b-febd9b03a759' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>





Plot the data.

{:.input}
```python
two_months_west_coast.plot(col="time",
                           col_wrap=1,
                           figsize=(5, 8))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_60_0.png" alt = "Map showing temperature data for the entire sliced region of western united states.">
<figcaption>Map showing temperature data for the entire sliced region of western united states.</figcaption>

</figure>




Again following the same steps as above, you can apply your
spatial mask. This will return a new array with the air
temperature data that can be grouped by each of the 4 regions. 

{:.input}
```python
# Apply the mask for the west coast subset
two_months_west_coast = two_months_west_coast.where(west_mask)
two_months_west_coast.dims
```

{:.output}
{:.execute_result}



    ('time', 'lat', 'lon', 'region')





By default region mask takes the index of the geopandas 
object and uses it as a region identifier. If you remember 
from above, california was 53.

{:.input}
```python
cali_or_wash_nev
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
      <th>featurecla</th>
      <th>scalerank</th>
      <th>adm1_code</th>
      <th>diss_me</th>
      <th>iso_3166_2</th>
      <th>wikipedia</th>
      <th>iso_a2</th>
      <th>adm0_sr</th>
      <th>name</th>
      <th>name_alt</th>
      <th>...</th>
      <th>name_nl</th>
      <th>name_pl</th>
      <th>name_pt</th>
      <th>name_ru</th>
      <th>name_sv</th>
      <th>name_tr</th>
      <th>name_vi</th>
      <th>name_zh</th>
      <th>ne_id</th>
      <th>geometry</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>53</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>USA-3521</td>
      <td>3521</td>
      <td>US-CA</td>
      <td>http://en.wikipedia.org/wiki/California</td>
      <td>US</td>
      <td>8</td>
      <td>California</td>
      <td>CA|Calif.</td>
      <td>...</td>
      <td>Californië</td>
      <td>Kalifornia</td>
      <td>Califórnia</td>
      <td>Калифорния</td>
      <td>Kalifornien</td>
      <td>Kaliforniya</td>
      <td>California</td>
      <td>加利福尼亚州</td>
      <td>1159308415</td>
      <td>MULTIPOLYGON (((-114.61054 34.99112, -114.6109...</td>
    </tr>
    <tr>
      <th>82</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>USA-3523</td>
      <td>3523</td>
      <td>US-NV</td>
      <td>http://en.wikipedia.org/wiki/Nevada</td>
      <td>US</td>
      <td>1</td>
      <td>Nevada</td>
      <td>NV|Nev.</td>
      <td>...</td>
      <td>Nevada</td>
      <td>Nevada</td>
      <td>Nevada</td>
      <td>Невада</td>
      <td>Nevada</td>
      <td>Nevada</td>
      <td>Nevada</td>
      <td>内华达州</td>
      <td>1159315345</td>
      <td>POLYGON ((-114.04027 37.00415, -114.04117 36.6...</td>
    </tr>
    <tr>
      <th>86</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>USA-3525</td>
      <td>3525</td>
      <td>US-OR</td>
      <td>http://en.wikipedia.org/wiki/Oregon</td>
      <td>US</td>
      <td>6</td>
      <td>Oregon</td>
      <td>OR|Ore.</td>
      <td>...</td>
      <td>Oregon</td>
      <td>Oregon</td>
      <td>Oregon</td>
      <td>Орегон</td>
      <td>Oregon</td>
      <td>Oregon</td>
      <td>Oregon</td>
      <td>俄勒冈州</td>
      <td>1159309549</td>
      <td>POLYGON ((-120.00081 42.00056, -120.26446 42.0...</td>
    </tr>
    <tr>
      <th>96</th>
      <td>Admin-1 scale rank</td>
      <td>2</td>
      <td>USA-3519</td>
      <td>3519</td>
      <td>US-WA</td>
      <td>http://en.wikipedia.org/wiki/Washington_(state)</td>
      <td>US</td>
      <td>6</td>
      <td>Washington</td>
      <td>WA|Wash.</td>
      <td>...</td>
      <td>Washington</td>
      <td>Waszyngton</td>
      <td>Washington</td>
      <td>Вашингтон</td>
      <td>Washington</td>
      <td>Vaşington</td>
      <td>Washington</td>
      <td>华盛顿州</td>
      <td>1159309547</td>
      <td>MULTIPOLYGON (((-122.78878 48.99303, -122.6863...</td>
    </tr>
  </tbody>
</table>
<p>4 rows × 84 columns</p>
</div>





{:.input}
```python
# Note that the region values align with the index of the geodataframe above
two_months_west_coast.region
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;region&#x27; (region: 4)&gt;
array([53, 82, 86, 96])
Coordinates:
  * region   (region) int64 53 82 86 96</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'region'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>region</span>: 4</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-3f8e7d55-0240-4ba1-8e52-970305963435' class='xr-array-in' type='checkbox' checked><label for='section-3f8e7d55-0240-4ba1-8e52-970305963435' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>53 82 86 96</span></div><div class='xr-array-data'><pre>array([53, 82, 86, 96])</pre></div></div></li><li class='xr-section-item'><input id='section-357c13ab-2151-4eac-8a5f-98bbb6d24caa' class='xr-section-summary-in' type='checkbox'  checked><label for='section-357c13ab-2151-4eac-8a5f-98bbb6d24caa' class='xr-section-summary' >Coordinates: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>region</span></div><div class='xr-var-dims'>(region)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>53 82 86 96</div><input id='attrs-b963b499-121c-47fb-b3a4-f59f3d8071bf' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-b963b499-121c-47fb-b3a4-f59f3d8071bf' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f857b26f-3d1a-4f9a-ac54-b0c80f089486' class='xr-var-data-in' type='checkbox'><label for='data-f857b26f-3d1a-4f9a-ac54-b0c80f089486' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([53, 82, 86, 96])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-9f2cd1c8-70e2-49f9-ab16-304909ca4f12' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-9f2cd1c8-70e2-49f9-ab16-304909ca4f12' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>





Having an additional region dimension in your array makes it easier
to summarize your data by region. Below you plot the 
data by time and region in a matrix. 

{:.input}
```python
two_months_west_coast.plot(col="time",
                           row="region",
                           sharey=False, sharex=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_67_0.png" alt = "Faceted plot showing temperature for each aoi region (on the y axis) and accross time (on the y axis).">
<figcaption>Faceted plot showing temperature for each aoi region (on the y axis) and accross time (on the y axis).</figcaption>

</figure>





## Calculate Mean Air Temperature by Region
Once you have your data subsetted by region, you can 
calculate summary statistics on the data for each region. 

Below, you calculate the mean air temperature value for the 
time subset that you created above. At this point you could export
the dataframe to a csv file if you want!

{:.input}
```python
summary = two_months_west_coast.groupby("time").mean(["lat", "lon"])
summary.to_dataframe()
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
      <th rowspan="4" valign="top">2010-01-15 00:00:00</th>
      <th>53</th>
      <td>286.057922</td>
    </tr>
    <tr>
      <th>82</th>
      <td>280.085175</td>
    </tr>
    <tr>
      <th>86</th>
      <td>279.390350</td>
    </tr>
    <tr>
      <th>96</th>
      <td>278.031158</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">2010-02-15 00:00:00</th>
      <th>53</th>
      <td>286.026550</td>
    </tr>
    <tr>
      <th>82</th>
      <td>279.355438</td>
    </tr>
    <tr>
      <th>86</th>
      <td>278.442688</td>
    </tr>
    <tr>
      <th>96</th>
      <td>277.346008</td>
    </tr>
  </tbody>
</table>
</div>





## The Entire Workflow To Subset netcdf 4 Files by Temporal and Spatial Extents

Putting all of the above together, below is an example workflow that you might use to summarize
climate data in netcdf 4 format by region and over time. 


{:.input}
```python
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
# Here is the entire workflow from start to end

# Download natural earth data which contains state boundaries to generate AOI
et.data.get_data(
    url="https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_1_states_provinces_lakes.zip")

states_path = "earthpy-downloads/ne_50m_admin_1_states_provinces_lakes"
states_path = os.path.join(
    states_path, "ne_50m_admin_1_states_provinces_lakes.shp")

states_gdf = gpd.read_file(states_path)


# Get netcdf file
data_path_monthly = 'http://thredds.northwestknowledge.net:8080/thredds/dodsC/agg_macav2metdata_tasmax_BNU-ESM_r1i1p1_rcp45_2006_2099_CONUS_monthly.nc'

# Open up the data
with xr.open_dataset(data_path_monthly) as file_nc:
    monthly_forecast_temp_xr = file_nc

# View xarray object
monthly_forecast_temp_xr

# Start by extracting a few states from the states_gdf
# I am using this as a shapefile because i presume some of my students
# will want to use custom aoi's so i want to teach using a shapefil rather than
# the regionmask built in shapes as nice as they are :)
states_gdf["name"]

cali_or_wash_nev = states_gdf[states_gdf.name.isin(
    ["California", "Oregon", "Washington", "Nevada"])]

west_mask = regionmask.mask_3D_geopandas(cali_or_wash_nev,
                                         monthly_forecast_temp_xr.lon,
                                         monthly_forecast_temp_xr.lat)
west_mask


west_bounds = get_aoi(cali_or_wash_nev)


# Slice the data
start_date = "2010-01-15"
end_date = "2020-02-15"

# Subset the data - this is now a dataarray rather than a DataSet
two_months_west_coast = monthly_forecast_temp_xr["air_temperature"].sel(
    time=slice(start_date, end_date),
    lon=slice(west_bounds["lon"][0], west_bounds["lon"][1]),
    lat=slice(west_bounds["lat"][0], west_bounds["lat"][1])).where(west_mask)

# This output is a dataarray
two_months_west_coast

# Plot the data - this produces a single histogram
two_months_west_coast.plot()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_74_0.png" alt = "Histogram showing all pixels values in the area of interest.">
<figcaption>Histogram showing all pixels values in the area of interest.</figcaption>

</figure>




Once the data are subsetted, you can begin to create plots and dataframes
with the summary data. 

{:.input}
```python
# Keep in mind that as you add more data to your slice, the processing will slow down.
regional_summary = two_months_west_coast.groupby("region").mean(["lat", "lon"])
regional_summary.plot(col="region",
                      marker="o",
                      color="grey",
                      markerfacecolor="purple",
                      markeredgecolor="purple",
                      col_wrap=2)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-spatial-subsets/2020-10-16-netcdf-03-spatial-subsets_76_0.png" alt = "Facetted scatter plot showing mean temperature data by region over time">
<figcaption>Facetted scatter plot showing mean temperature data by region over time</figcaption>

</figure>




Export to a dataframe.

{:.input}
```python
two_months_west_coast.groupby("region").mean(["lat", "lon"]).to_dataframe()
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
      <th rowspan="4" valign="top">2010-01-15 00:00:00</th>
      <th>53</th>
      <td>286.057922</td>
    </tr>
    <tr>
      <th>82</th>
      <td>280.085175</td>
    </tr>
    <tr>
      <th>86</th>
      <td>279.390350</td>
    </tr>
    <tr>
      <th>96</th>
      <td>278.031158</td>
    </tr>
    <tr>
      <th>2010-02-15 00:00:00</th>
      <th>53</th>
      <td>286.026550</td>
    </tr>
    <tr>
      <th>...</th>
      <th>...</th>
      <td>...</td>
    </tr>
    <tr>
      <th>2020-01-15 00:00:00</th>
      <th>96</th>
      <td>275.706940</td>
    </tr>
    <tr>
      <th rowspan="4" valign="top">2020-02-15 00:00:00</th>
      <th>53</th>
      <td>285.709076</td>
    </tr>
    <tr>
      <th>82</th>
      <td>279.856842</td>
    </tr>
    <tr>
      <th>86</th>
      <td>279.198822</td>
    </tr>
    <tr>
      <th>96</th>
      <td>278.026459</td>
    </tr>
  </tbody>
</table>
<p>488 rows × 1 columns</p>
</div>




