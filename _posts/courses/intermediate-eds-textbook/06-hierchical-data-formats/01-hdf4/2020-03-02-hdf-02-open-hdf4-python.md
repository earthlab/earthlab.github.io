---
layout: single
title: "Open and Use MODIS Data in HDF4 format in Open Source Python"
excerpt: "MODIS is remote sensing data that is stored in the HDF4 file format. Learn how to open and use MODIS data in HDF4 form in Open Source Python."
authors: ['Leah Wasser', 'Nathan Korinek', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2021-11-17
category: [courses]
class-lesson: ['hdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/open-MODIS-hdf4-files-python/
nav-title: 'Open HDF4'
module-type: 'class'
chapter: 12
week: 6
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  remote-sensing: ['modis']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Read MODIS data in **HDF4** format into **Python** using open source packages (**xarray**).
* Extract metadata from **HDF4** files.
* Plot data extracted from HDF4 files.

</div>

In this lesson, you will learn how to open a MODIS HDF4 format file using **xarray**. 

To begin, import your packages.

{:.input}
```python
# Import packages
import os
import warnings

import matplotlib.pyplot as plt
import numpy.ma as ma
import xarray as xr
import rioxarray as rxr
from shapely.geometry import mapping, box
import geopandas as gpd
import earthpy as et
import earthpy.plot as ep

warnings.simplefilter('ignore')

# Get the MODIS data
et.data.get_data('cold-springs-modis-h4')

# This download contains the fire boundary
et.data.get_data('cold-springs-fire')

# Set working directory
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960112
    Extracted output to /root/earth-analytics/data/cold-springs-modis-h4/.





## Hierarchical Data Formats - HDF4 - EOS in Python

In the previous lesson, you learned about the HDF4 file format, which is 
a common format used to store MODIS remote sensing data. In this lesson, 
you will learn how to open and process remote sensing data stored in HDF4 
format.

You can use **rioxarray** to open HDF4 data.
Note that both tools wrap around **gdal** and will make the code needed
to open your HDF4 data, simpler.  

To begin, create a path to your HDF4 file.

{:.input}
```python
# Create a path to the pre-fire MODIS h4 data
modis_pre_path = os.path.join("cold-springs-modis-h4",
                              "07_july_2016",
                              "MOD09GA.A2016189.h09v05.006.2016191073856.hdf")
modis_pre_path
```

{:.output}
{:.execute_result}



    'cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf'





## Open HDF4 Files Using Open Source Python and Xarray

HDF files are hierarchical and self describing (the metadata is contained 
within the data). Because the data are hierarchical, you will have to loop
through the main dataset and the subdatasets nested within the main dataset 
to access the reflectance data (the bands) and the **qa** layers. 

Below you open the  HDF4 file. Notice that `rioxarray`  
returns a list rather than an single xarray object. 
Within that list are two xarray objects representing
the two groups in the h4 file.

{:.input}
```python
# Open data with rioxarray
modis_pre = rxr.open_rasterio(modis_pre_path,
                              masked=True)
type(modis_pre)
```

{:.output}
{:.execute_result}



    list





The first object returned in the list contains all of the quality 
control layers. Notice that each layer is stored as a data variable.

{:.input}
```python
# This is just a data exploration step
modis_pre_qa = modis_pre[0]
modis_pre_qa
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:               (y: 1200, x: 1200, band: 1)
Coordinates:
  * y                     (y) float64 4.447e+06 4.446e+06 ... 3.336e+06
  * x                     (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06
  * band                  (band) int64 1
    spatial_ref           int64 0
Data variables:
    num_observations_1km  (band, y, x) float32 ...
    granule_pnt_1         (band, y, x) float32 ...
    state_1km_1           (band, y, x) float32 ...
    SensorZenith_1        (band, y, x) float32 ...
    SensorAzimuth_1       (band, y, x) float32 ...
    Range_1               (band, y, x) float32 ...
    SolarZenith_1         (band, y, x) float32 ...
    SolarAzimuth_1        (band, y, x) float32 ...
    gflags_1              (band, y, x) float32 ...
    orbit_pnt_1           (band, y, x) float32 ...
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-1d26942c-4fac-47a5-be3e-51322a0a0b13' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-1d26942c-4fac-47a5-be3e-51322a0a0b13' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 1200</li><li><span class='xr-has-index'>x</span>: 1200</li><li><span class='xr-has-index'>band</span>: 1</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-4b1fb5d7-ba80-45b6-bf38-0a60e145ae41' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4b1fb5d7-ba80-45b6-bf38-0a60e145ae41' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-ac8f96be-816c-4e85-91e5-6be2122deb23' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-ac8f96be-816c-4e85-91e5-6be2122deb23' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-27949b0c-d74b-4fbe-9a3d-62f46f3e6ad0' class='xr-var-data-in' type='checkbox'><label for='data-27949b0c-d74b-4fbe-9a3d-62f46f3e6ad0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-a161f7fd-ec47-4b2e-b5f8-85f7ac07210d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a161f7fd-ec47-4b2e-b5f8-85f7ac07210d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-73b44e06-dc8f-4f91-a2ed-67d0bb4c858b' class='xr-var-data-in' type='checkbox'><label for='data-73b44e06-dc8f-4f91-a2ed-67d0bb4c858b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-37319d67-666d-4cc4-a44b-df636c79a94a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-37319d67-666d-4cc4-a44b-df636c79a94a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-925b4943-f8db-4b38-931d-73b86e582c7d' class='xr-var-data-in' type='checkbox'><label for='data-925b4943-f8db-4b38-931d-73b86e582c7d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-abec749b-e932-4643-bafb-06317503dc4b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-abec749b-e932-4643-bafb-06317503dc4b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-710a64df-de82-43f7-af24-d4138fd08fff' class='xr-var-data-in' type='checkbox'><label for='data-710a64df-de82-43f7-af24-d4138fd08fff' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-7d0a940a-a711-4f8f-97de-e5f64b60dba7' class='xr-section-summary-in' type='checkbox'  checked><label for='section-7d0a940a-a711-4f8f-97de-e5f64b60dba7' class='xr-section-summary' >Data variables: <span>(10)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_1km</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-866af432-f95c-438c-9f61-3016a54c89bb' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-866af432-f95c-438c-9f61-3016a54c89bb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-eb2f2bb6-533b-4e83-a979-53d643d9e964' class='xr-var-data-in' type='checkbox'><label for='data-eb2f2bb6-533b-4e83-a979-53d643d9e964' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>granule_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9f44c425-9f56-4ba0-a0d2-58737f8f006a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9f44c425-9f56-4ba0-a0d2-58737f8f006a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-28bbbe11-e0af-4a3b-803a-18fa4adda599' class='xr-var-data-in' type='checkbox'><label for='data-28bbbe11-e0af-4a3b-803a-18fa4adda599' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Granule Pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>state_1km_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-001c4990-ddb1-4c94-b8eb-f13c5d1e5cb1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-001c4990-ddb1-4c94-b8eb-f13c5d1e5cb1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-922deb62-818d-4e48-a1ab-569e83ec5f4e' class='xr-var-data-in' type='checkbox'><label for='data-922deb62-818d-4e48-a1ab-569e83ec5f4e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>1km Reflectance Data State QA - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-41301acb-b838-41e3-ae8f-9fe7b839f2cc' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-41301acb-b838-41e3-ae8f-9fe7b839f2cc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1844b06a-c71e-4e20-8d51-ea0f5ac62125' class='xr-var-data-in' type='checkbox'><label for='data-1844b06a-c71e-4e20-8d51-ea0f5ac62125' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-564fa29e-b3e7-4676-8a44-7fb0ae4a45ac' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-564fa29e-b3e7-4676-8a44-7fb0ae4a45ac' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e1cc20a9-98f5-431d-b3ba-539df5d7e58f' class='xr-var-data-in' type='checkbox'><label for='data-e1cc20a9-98f5-431d-b3ba-539df5d7e58f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>Range_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-72b62ea2-1d93-45bd-96f8-a28109bc3210' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-72b62ea2-1d93-45bd-96f8-a28109bc3210' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-204c159f-43fe-46d4-8897-7f0736bfe9f6' class='xr-var-data-in' type='checkbox'><label for='data-204c159f-43fe-46d4-8897-7f0736bfe9f6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>25.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Range (pixel to sensor) - first layer</dd><dt><span>units :</span></dt><dd>meters</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-f3000e18-8cca-450d-a7ac-1861871a4efb' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f3000e18-8cca-450d-a7ac-1861871a4efb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e04995e9-fed9-40f1-83d3-a163919a47f2' class='xr-var-data-in' type='checkbox'><label for='data-e04995e9-fed9-40f1-83d3-a163919a47f2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-1e8e6228-bf3b-4bda-91e1-0ff7f75ed28f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1e8e6228-bf3b-4bda-91e1-0ff7f75ed28f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c15e8c40-06eb-404f-b436-01d8b5864ba6' class='xr-var-data-in' type='checkbox'><label for='data-c15e8c40-06eb-404f-b436-01d8b5864ba6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>gflags_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-b058477a-8115-4ddb-9239-d5af24127ed7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b058477a-8115-4ddb-9239-d5af24127ed7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ab3f83ec-db2c-4cf4-9a8f-0841e44fde34' class='xr-var-data-in' type='checkbox'><label for='data-ab3f83ec-db2c-4cf4-9a8f-0841e44fde34' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Geolocation flags - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>orbit_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-5a371d58-9165-4824-885c-b0377d04cf4f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5a371d58-9165-4824-885c-b0377d04cf4f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5d5f94d6-d68c-47c6-bb0b-781bd7dee5c2' class='xr-var-data-in' type='checkbox'><label for='data-5d5f94d6-d68c-47c6-bb0b-781bd7dee5c2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Orbit pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-73266b45-b4f1-4c5c-a9ee-41cd1dbb80ac' class='xr-section-summary-in' type='checkbox'  ><label for='section-73266b45-b4f1-4c5c-a9ee-41cd1dbb80ac' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





You can access a data variable in a similar fashion to 
how you would  access a  column in a pandas DataFrame using 
the `["variable-name-here"]`.

{:.input}
```python
modis_pre_qa["num_observations_1km"]
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;num_observations_1km&#x27; (band: 1, y: 1200, x: 1200)&gt;
[1440000 values with dtype=float32]
Coordinates:
  * y            (y) float64 4.447e+06 4.446e+06 ... 3.337e+06 3.336e+06
  * x            (x) float64 -1.001e+07 -1.001e+07 ... -8.897e+06 -8.896e+06
  * band         (band) int64 1
    spatial_ref  int64 0
Attributes:
    scale_factor:  1.0
    add_offset:    0.0
    long_name:     Number of Observations
    units:         none</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'num_observations_1km'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>y</span>: 1200</li><li><span class='xr-has-index'>x</span>: 1200</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-8023fa95-8a92-4da4-940c-b0ca5f67ee76' class='xr-array-in' type='checkbox' checked><label for='section-8023fa95-8a92-4da4-940c-b0ca5f67ee76' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[1440000 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-7bb862c4-dac3-45d8-b54d-00972ed70e73' class='xr-section-summary-in' type='checkbox'  checked><label for='section-7bb862c4-dac3-45d8-b54d-00972ed70e73' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-910c8377-4f5e-4495-be25-2a9bc28d2804' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-910c8377-4f5e-4495-be25-2a9bc28d2804' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-aa850a46-6b06-41a8-8801-68b76e0a1fdd' class='xr-var-data-in' type='checkbox'><label for='data-aa850a46-6b06-41a8-8801-68b76e0a1fdd' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-a7c0dc57-d8f0-45db-ae00-95fc6c010d1a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a7c0dc57-d8f0-45db-ae00-95fc6c010d1a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b8ccbe04-1e9f-45e7-bff7-68f948794e31' class='xr-var-data-in' type='checkbox'><label for='data-b8ccbe04-1e9f-45e7-bff7-68f948794e31' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-6c44f2a7-d867-4277-a6fb-9c4025dfc3fa' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6c44f2a7-d867-4277-a6fb-9c4025dfc3fa' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b3335477-ebaa-4529-8429-fcdc9a19c35e' class='xr-var-data-in' type='checkbox'><label for='data-b3335477-ebaa-4529-8429-fcdc9a19c35e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-40f65afc-f13e-4534-ac2b-53ec4a10fa14' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-40f65afc-f13e-4534-ac2b-53ec4a10fa14' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ec05187b-b1ab-46df-82de-ad53d52b2c5e' class='xr-var-data-in' type='checkbox'><label for='data-ec05187b-b1ab-46df-82de-ad53d52b2c5e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-942aaffc-44ae-4ad0-bd9f-83aff98ff183' class='xr-section-summary-in' type='checkbox'  checked><label for='section-942aaffc-44ae-4ad0-bd9f-83aff98ff183' class='xr-section-summary' >Attributes: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div></li></ul></div></div>





The second element in the list contains the reflectance data. This is 
the data that you will want to use for your analysis

{:.input}
```python
# Reflectance data
modis_pre_bands = modis_pre[1]
modis_pre_bands
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:                (y: 2400, x: 2400, band: 1)
Coordinates:
  * y                      (y) float64 4.448e+06 4.447e+06 ... 3.336e+06
  * x                      (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06
  * band                   (band) int64 1
    spatial_ref            int64 0
Data variables:
    num_observations_500m  (band, y, x) float32 ...
    sur_refl_b01_1         (band, y, x) float32 ...
    sur_refl_b02_1         (band, y, x) float32 ...
    sur_refl_b03_1         (band, y, x) float32 ...
    sur_refl_b04_1         (band, y, x) float32 ...
    sur_refl_b05_1         (band, y, x) float32 ...
    sur_refl_b06_1         (band, y, x) float32 ...
    sur_refl_b07_1         (band, y, x) float32 ...
    QC_500m_1              (band, y, x) float64 ...
    obscov_500m_1          (band, y, x) float32 ...
    iobs_res_1             (band, y, x) float32 ...
    q_scan_1               (band, y, x) float32 ...
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-25457bb6-b0b5-436c-980e-a820bc542a09' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-25457bb6-b0b5-436c-980e-a820bc542a09' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li><li><span class='xr-has-index'>band</span>: 1</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-4ef80d60-256e-4e39-8860-ca491e487b93' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4ef80d60-256e-4e39-8860-ca491e487b93' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-85cdd4df-9b49-4207-9bfc-dfd9df60d0ac' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-85cdd4df-9b49-4207-9bfc-dfd9df60d0ac' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-399f2b01-2538-4733-9d3c-ba601143a948' class='xr-var-data-in' type='checkbox'><label for='data-399f2b01-2538-4733-9d3c-ba601143a948' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-dbb274c1-9f2d-4554-a289-37b14e7ac98b' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-dbb274c1-9f2d-4554-a289-37b14e7ac98b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4fcbccc8-28b8-473e-9bb0-8f847a107f58' class='xr-var-data-in' type='checkbox'><label for='data-4fcbccc8-28b8-473e-9bb0-8f847a107f58' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-5522fde1-4c7c-461d-ba0b-74ed56169a7d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5522fde1-4c7c-461d-ba0b-74ed56169a7d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-12ca2843-b37f-4d9c-85b8-107f913ca9a2' class='xr-var-data-in' type='checkbox'><label for='data-12ca2843-b37f-4d9c-85b8-107f913ca9a2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-e6803f5a-7caa-4d38-bfc5-155cad69c761' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e6803f5a-7caa-4d38-bfc5-155cad69c761' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ff74d11f-d6a4-4616-8109-cefd839d9fd9' class='xr-var-data-in' type='checkbox'><label for='data-ff74d11f-d6a4-4616-8109-cefd839d9fd9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-ec5584c8-6f35-4ac9-9881-5e545405b41f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-ec5584c8-6f35-4ac9-9881-5e545405b41f' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-239c49ff-9e77-4708-80f7-972ba2a73b99' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-239c49ff-9e77-4708-80f7-972ba2a73b99' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-02d37a72-d9f5-49b1-a625-983c746d741d' class='xr-var-data-in' type='checkbox'><label for='data-02d37a72-d9f5-49b1-a625-983c746d741d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-428d3278-2776-4eff-ba88-68e98709436f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-428d3278-2776-4eff-ba88-68e98709436f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-440f1696-b176-4bd4-8b4d-395dc73efa62' class='xr-var-data-in' type='checkbox'><label for='data-440f1696-b176-4bd4-8b4d-395dc73efa62' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d600118e-3627-4df8-8232-cd9778ca98a8' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d600118e-3627-4df8-8232-cd9778ca98a8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-97e68e82-d0a6-4def-9c9e-608195ee9f8a' class='xr-var-data-in' type='checkbox'><label for='data-97e68e82-d0a6-4def-9c9e-608195ee9f8a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9a589f12-2875-4eb9-8915-89986dc0566a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9a589f12-2875-4eb9-8915-89986dc0566a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a68ef6bb-f3ce-486c-8456-dfc0b5af99e5' class='xr-var-data-in' type='checkbox'><label for='data-a68ef6bb-f3ce-486c-8456-dfc0b5af99e5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3bb855b0-cf35-4ffa-a975-83699776bcf6' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3bb855b0-cf35-4ffa-a975-83699776bcf6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-524d293a-e5fd-44b4-bd48-56ffa990787e' class='xr-var-data-in' type='checkbox'><label for='data-524d293a-e5fd-44b4-bd48-56ffa990787e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-24267a7d-7a80-48a8-87f4-b383fb223bd7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-24267a7d-7a80-48a8-87f4-b383fb223bd7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d1598b8f-a7f8-43ac-b594-a50cfa827d45' class='xr-var-data-in' type='checkbox'><label for='data-d1598b8f-a7f8-43ac-b594-a50cfa827d45' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4746d294-3889-42aa-aed1-77b796214774' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4746d294-3889-42aa-aed1-77b796214774' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b115ba92-424f-4657-92e4-0b077b0f542c' class='xr-var-data-in' type='checkbox'><label for='data-b115ba92-424f-4657-92e4-0b077b0f542c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-064938fb-6719-4c8d-8a97-3d08312dfb9a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-064938fb-6719-4c8d-8a97-3d08312dfb9a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-dcfd88ee-9290-4d23-9d12-41e90cfbc0b8' class='xr-var-data-in' type='checkbox'><label for='data-dcfd88ee-9290-4d23-9d12-41e90cfbc0b8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-29bb3259-6bda-4c94-9a49-6110ca25455a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-29bb3259-6bda-4c94-9a49-6110ca25455a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f2f6f61f-d7fa-4513-8d59-97697c51514e' class='xr-var-data-in' type='checkbox'><label for='data-f2f6f61f-d7fa-4513-8d59-97697c51514e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-b67b615b-90de-4070-be8f-2ee33c497e77' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b67b615b-90de-4070-be8f-2ee33c497e77' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8b195861-711d-43e1-9dcd-f1e1780c1630' class='xr-var-data-in' type='checkbox'><label for='data-8b195861-711d-43e1-9dcd-f1e1780c1630' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-c3dd7394-151c-48d5-81a3-a036501e719d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c3dd7394-151c-48d5-81a3-a036501e719d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-222f0ce9-a72d-40ab-b7c9-8733a5f15f2e' class='xr-var-data-in' type='checkbox'><label for='data-222f0ce9-a72d-40ab-b7c9-8733a5f15f2e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-36c6cbc7-339b-4360-b9c5-b65fb079fca7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-36c6cbc7-339b-4360-b9c5-b65fb079fca7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e9d526a8-4a57-4529-8851-ac9b97a8d3d0' class='xr-var-data-in' type='checkbox'><label for='data-e9d526a8-4a57-4529-8851-ac9b97a8d3d0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-edfe85a6-30e8-497b-b1fb-440d4f4a57d9' class='xr-section-summary-in' type='checkbox'  ><label for='section-edfe85a6-30e8-497b-b1fb-440d4f4a57d9' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





## Subset  Data By Group or Variable

If you need to open the entire  dataset, you can 
follow the steps above. Alternatively you can 
specific subgroups or  even  layers / variables  
in the  data to open specifically using the 
`group=`  parameter. 

There are a few ways to get the group names.
One manual  way is to use the  HDF4  tool 
(or something like  panoply) to view  the  
groups. You  could also  use something like
`gdalinfo` or  rasterio to loop through groups
and subgroups.

The files with this pattern 
in the name:

`sur_refl_b01_1`  

are the bands which contain surface reflectance data. 

* **sur_refl_b01_1:** MODIS Band One
* **sur_refl_b02_1:** MODIS Band Two

etc.

Notice that there are some other layers in the file as well including the 
`state_1km` layer which contains the QA (cloud and quality assurance) information.


{:.input}
```python
# Use rasterio to print all of the subdataset names in the data
# Here you can see the group names: MODIS_Grid_500m_2D & MODIS_Grid_1km_2D
import rasterio as rio
with rio.open(modis_pre_path) as groups:
    for name in groups.subdatasets:
        print(name)
```

{:.output}
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:num_observations_1km
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:granule_pnt_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:num_observations_500m
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b01_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b02_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b03_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b04_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b05_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b06_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:sur_refl_b07_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:QC_500m_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:state_1km_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:obscov_500m_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:iobs_res_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_500m_2D:q_scan_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:SensorZenith_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:SensorAzimuth_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:Range_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:SolarZenith_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:SolarAzimuth_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:gflags_1
    HDF4_EOS:EOS_GRID:cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf:MODIS_Grid_1km_2D:orbit_pnt_1



Below you  actually open  the  data subsetting  first by  

1. group and then
2. by variable names

{:.input}
```python
# Subset by group only - Notice you have all bands in the returned object
rxr.open_rasterio(modis_pre_path,
                  masked=True,
                  group="MODIS_Grid_500m_2D").squeeze()
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:                (y: 2400, x: 2400)
Coordinates:
  * y                      (y) float64 4.448e+06 4.447e+06 ... 3.336e+06
  * x                      (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06
    band                   int64 1
    spatial_ref            int64 0
Data variables:
    num_observations_500m  (y, x) float32 ...
    sur_refl_b01_1         (y, x) float32 ...
    sur_refl_b02_1         (y, x) float32 ...
    sur_refl_b03_1         (y, x) float32 ...
    sur_refl_b04_1         (y, x) float32 ...
    sur_refl_b05_1         (y, x) float32 ...
    sur_refl_b06_1         (y, x) float32 ...
    sur_refl_b07_1         (y, x) float32 ...
    QC_500m_1              (y, x) float64 ...
    obscov_500m_1          (y, x) float32 ...
    iobs_res_1             (y, x) float32 ...
    q_scan_1               (y, x) float32 ...
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-5d2c56aa-a5ea-4740-8b6a-44fd2def4574' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-5d2c56aa-a5ea-4740-8b6a-44fd2def4574' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-726d36a9-740e-440b-9218-c93d32bb58a3' class='xr-section-summary-in' type='checkbox'  checked><label for='section-726d36a9-740e-440b-9218-c93d32bb58a3' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-8e82822f-5cee-4696-80d9-12f9066b691f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-8e82822f-5cee-4696-80d9-12f9066b691f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0bdd831a-23ed-4e27-8c05-a5980dee565f' class='xr-var-data-in' type='checkbox'><label for='data-0bdd831a-23ed-4e27-8c05-a5980dee565f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-4c457fc9-8d4d-41fc-8461-35ee42daf3e0' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-4c457fc9-8d4d-41fc-8461-35ee42daf3e0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-14aeb099-99b6-49ea-840c-f1d7542a9b7d' class='xr-var-data-in' type='checkbox'><label for='data-14aeb099-99b6-49ea-840c-f1d7542a9b7d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-3fcd7dce-8d95-4a21-83ac-b8d14d61740f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-3fcd7dce-8d95-4a21-83ac-b8d14d61740f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3c17b519-5cd5-44cf-aacd-858fca2ed4e5' class='xr-var-data-in' type='checkbox'><label for='data-3c17b519-5cd5-44cf-aacd-858fca2ed4e5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-fa2bf6eb-6125-4a42-80a8-a8635ee37cdc' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-fa2bf6eb-6125-4a42-80a8-a8635ee37cdc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d38b0e53-d906-4b5a-bbb9-67908581dcd3' class='xr-var-data-in' type='checkbox'><label for='data-d38b0e53-d906-4b5a-bbb9-67908581dcd3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-59013580-bd36-4639-a96e-6c19c4f72a12' class='xr-section-summary-in' type='checkbox'  checked><label for='section-59013580-bd36-4639-a96e-6c19c4f72a12' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-238663a2-ec1c-4b73-91e0-3dba3b7c87a8' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-238663a2-ec1c-4b73-91e0-3dba3b7c87a8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-83690196-bcab-4896-ba9d-2a3a704c95dd' class='xr-var-data-in' type='checkbox'><label for='data-83690196-bcab-4896-ba9d-2a3a704c95dd' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8c8b792a-6bf7-4438-9fc6-17d3e823aff8' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8c8b792a-6bf7-4438-9fc6-17d3e823aff8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-76c17064-2203-45d6-a150-252b3439ce53' class='xr-var-data-in' type='checkbox'><label for='data-76c17064-2203-45d6-a150-252b3439ce53' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-2df7218c-f14e-44a2-a1bf-aaafc69d20f2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2df7218c-f14e-44a2-a1bf-aaafc69d20f2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2af9e0d6-2d06-4288-b130-31c6c66c683a' class='xr-var-data-in' type='checkbox'><label for='data-2af9e0d6-2d06-4288-b130-31c6c66c683a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-51900ccd-e1f1-44c9-ad34-dc5c293dfc98' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-51900ccd-e1f1-44c9-ad34-dc5c293dfc98' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f9df780a-5452-4dca-b9b9-a7f3bdd61cf8' class='xr-var-data-in' type='checkbox'><label for='data-f9df780a-5452-4dca-b9b9-a7f3bdd61cf8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-a97d55db-6fb0-4825-aff4-cd5544e50f01' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a97d55db-6fb0-4825-aff4-cd5544e50f01' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-06419e7b-20f9-427e-a5b9-76ce7399ff20' class='xr-var-data-in' type='checkbox'><label for='data-06419e7b-20f9-427e-a5b9-76ce7399ff20' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-bbe69b32-2b94-465e-bcb3-261f249dfe89' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-bbe69b32-2b94-465e-bcb3-261f249dfe89' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-940e3623-98e1-4239-ace7-42c452092aad' class='xr-var-data-in' type='checkbox'><label for='data-940e3623-98e1-4239-ace7-42c452092aad' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-fd738475-d948-473e-9e1a-18e9a3ef2b63' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-fd738475-d948-473e-9e1a-18e9a3ef2b63' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ffb64878-88ee-4742-93f2-77ed257681a1' class='xr-var-data-in' type='checkbox'><label for='data-ffb64878-88ee-4742-93f2-77ed257681a1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-cc3f0eff-0dc5-4659-8dcd-76e2dc22e6e9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-cc3f0eff-0dc5-4659-8dcd-76e2dc22e6e9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d972a007-1407-492f-8960-cbd013ace339' class='xr-var-data-in' type='checkbox'><label for='data-d972a007-1407-492f-8960-cbd013ace339' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d63eefe3-5409-4139-a5e7-08a5e412b673' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d63eefe3-5409-4139-a5e7-08a5e412b673' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7ae44a47-2bf0-47ce-b364-cc2b32dd615f' class='xr-var-data-in' type='checkbox'><label for='data-7ae44a47-2bf0-47ce-b364-cc2b32dd615f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-09e56f15-51b2-4187-8019-c44019468630' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-09e56f15-51b2-4187-8019-c44019468630' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cb1da4b2-d69f-45e6-881b-3ec052d3ea66' class='xr-var-data-in' type='checkbox'><label for='data-cb1da4b2-d69f-45e6-881b-3ec052d3ea66' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-11015bab-23fb-4ae6-abf0-225ca691d593' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-11015bab-23fb-4ae6-abf0-225ca691d593' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-02725e8f-db6c-49bb-a72d-ccc42a9f683a' class='xr-var-data-in' type='checkbox'><label for='data-02725e8f-db6c-49bb-a72d-ccc42a9f683a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-a41fd313-ce93-4f20-956d-85c874fda1de' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a41fd313-ce93-4f20-956d-85c874fda1de' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-727f16ec-ef52-4792-88ae-9126f5afc644' class='xr-var-data-in' type='checkbox'><label for='data-727f16ec-ef52-4792-88ae-9126f5afc644' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-b1f61cad-7368-40e0-85aa-f15b82b21a84' class='xr-section-summary-in' type='checkbox'  ><label for='section-b1f61cad-7368-40e0-85aa-f15b82b21a84' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





Subset by a list of variable names.

{:.input}
```python
# Open just the bands that you want to process
desired_bands = ["sur_refl_b01_1",
                 "sur_refl_b02_1",
                 "sur_refl_b03_1",
                 "sur_refl_b04_1",
                 "sur_refl_b07_1"]
# Notice that here, you get a single xarray object with just the bands that
# you want to work with
modis_pre_bands = rxr.open_rasterio(modis_pre_path,
                                    variable=desired_bands).squeeze()
modis_pre_bands
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:         (y: 2400, x: 2400)
Coordinates:
  * y               (y) float64 4.448e+06 4.447e+06 ... 3.337e+06 3.336e+06
  * x               (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06 -8.896e+06
    band            int64 1
    spatial_ref     int64 0
Data variables:
    sur_refl_b01_1  (y, x) int16 ...
    sur_refl_b02_1  (y, x) int16 ...
    sur_refl_b03_1  (y, x) int16 ...
    sur_refl_b04_1  (y, x) int16 ...
    sur_refl_b07_1  (y, x) int16 ...
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-36737222-c78a-4df4-9dda-1d83dc6a7660' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-36737222-c78a-4df4-9dda-1d83dc6a7660' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-baf667e8-87ec-4fa3-a358-64d5396e80ee' class='xr-section-summary-in' type='checkbox'  checked><label for='section-baf667e8-87ec-4fa3-a358-64d5396e80ee' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-c5422567-5db4-404f-a89c-1a66c586d775' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-c5422567-5db4-404f-a89c-1a66c586d775' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3b59e53b-2831-4663-9d3f-c1346803683f' class='xr-var-data-in' type='checkbox'><label for='data-3b59e53b-2831-4663-9d3f-c1346803683f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-c59e150a-3944-4cd9-a8e8-69a6d2a99993' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-c59e150a-3944-4cd9-a8e8-69a6d2a99993' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cf6d8f9a-ee96-4183-95f4-67811bc1f2bb' class='xr-var-data-in' type='checkbox'><label for='data-cf6d8f9a-ee96-4183-95f4-67811bc1f2bb' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-764cccf2-7ea1-46d8-a031-13b5ea4657f8' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-764cccf2-7ea1-46d8-a031-13b5ea4657f8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c5e6fa24-cf60-48f1-9276-3dd33a4d0855' class='xr-var-data-in' type='checkbox'><label for='data-c5e6fa24-cf60-48f1-9276-3dd33a4d0855' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-922d345c-cc91-49ef-b2b7-91889fe32962' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-922d345c-cc91-49ef-b2b7-91889fe32962' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-51e0d60e-b77a-4c38-b8fa-2e446a6824fa' class='xr-var-data-in' type='checkbox'><label for='data-51e0d60e-b77a-4c38-b8fa-2e446a6824fa' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-9e1fbc93-9c4d-4042-8308-3376865d8f02' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9e1fbc93-9c4d-4042-8308-3376865d8f02' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-692f67f9-ba27-44af-a9a4-d72e1d08e9d9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-692f67f9-ba27-44af-a9a4-d72e1d08e9d9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f4403878-7515-4ae2-9afd-ab4b278c423b' class='xr-var-data-in' type='checkbox'><label for='data-f4403878-7515-4ae2-9afd-ab4b278c423b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-2750fcb5-9a99-42c7-9ddd-b312790949ea' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2750fcb5-9a99-42c7-9ddd-b312790949ea' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0598fa39-57a8-4cfe-a002-fb5417c0e9a2' class='xr-var-data-in' type='checkbox'><label for='data-0598fa39-57a8-4cfe-a002-fb5417c0e9a2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3a88bbe1-6944-4456-a9f8-3913e845387a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3a88bbe1-6944-4456-a9f8-3913e845387a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7b080276-f148-437c-aa84-46666588ad5e' class='xr-var-data-in' type='checkbox'><label for='data-7b080276-f148-437c-aa84-46666588ad5e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-387e5881-ac4b-4411-9eb4-5b8bf05e8fcf' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-387e5881-ac4b-4411-9eb4-5b8bf05e8fcf' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-178b5dca-642c-4bfc-825e-6a8333fe8a42' class='xr-var-data-in' type='checkbox'><label for='data-178b5dca-642c-4bfc-825e-6a8333fe8a42' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-0116d4dd-710f-4e90-a36d-f29de0c85bac' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0116d4dd-710f-4e90-a36d-f29de0c85bac' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4280b862-873d-45f6-a522-794b0248035c' class='xr-var-data-in' type='checkbox'><label for='data-4280b862-873d-45f6-a522-794b0248035c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-17f4b132-03ec-4379-bc13-1e2903df2f74' class='xr-section-summary-in' type='checkbox'  ><label for='section-17f4b132-03ec-4379-bc13-1e2903df2f74' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





{:.input}
```python
#  view nodata value
modis_pre_bands.sur_refl_b01_1.rio.nodata
```

{:.output}
{:.execute_result}



    -28672





##  Handle NoData Using Masked=True

If you look at the <a href="{{ site.url }}/courses/earth-analytics-python/multispectral-remote-sensing-modis/modis-remote-sensing-data-in-python/"> MODIS documentation table that is in the Introduction to MODIS chapter,</a> you will see that the
range of value values for MODIS spans from **-100 to 16000**. There is also a fill or no data value **-28672** to consider. By using the  `masked=True` parameter
when you  open the data, you mask all pixels that are `nodata`.

Below  you open the  data and mask no data values using
`masked=True`. Notice that once  you apply the  mask, the `nodata` value  
attribute is erased from the object.

{:.input}
```python
# Open just the bands that you want to process
desired_bands = ["sur_refl_b01_1",
                 "sur_refl_b02_1",
                 "sur_refl_b03_1",
                 "sur_refl_b04_1",
                 "sur_refl_b07_1"]
# Notice that here, you get a single xarray object with just the bands that
# you want to work with
modis_pre_bands = rxr.open_rasterio(modis_pre_path,
                                    masked=True,
                                    variable=desired_bands).squeeze()
modis_pre_bands
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:         (y: 2400, x: 2400)
Coordinates:
  * y               (y) float64 4.448e+06 4.447e+06 ... 3.337e+06 3.336e+06
  * x               (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06 -8.896e+06
    band            int64 1
    spatial_ref     int64 0
Data variables:
    sur_refl_b01_1  (y, x) float32 ...
    sur_refl_b02_1  (y, x) float32 ...
    sur_refl_b03_1  (y, x) float32 ...
    sur_refl_b04_1  (y, x) float32 ...
    sur_refl_b07_1  (y, x) float32 ...
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-20facde0-546f-41c1-8b0c-535379b26d4a' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-20facde0-546f-41c1-8b0c-535379b26d4a' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-c9dd5b82-9a04-40dd-a0da-34a49c7abc1b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-c9dd5b82-9a04-40dd-a0da-34a49c7abc1b' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-3b92324c-f451-4a66-85c5-96c38795f6dc' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-3b92324c-f451-4a66-85c5-96c38795f6dc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7bbcccb5-2b56-49dd-a461-08742410361a' class='xr-var-data-in' type='checkbox'><label for='data-7bbcccb5-2b56-49dd-a461-08742410361a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-8826da81-da09-404d-ad77-1e6af3aded4a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-8826da81-da09-404d-ad77-1e6af3aded4a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d19f80f8-4448-40b0-8221-019f666b0c59' class='xr-var-data-in' type='checkbox'><label for='data-d19f80f8-4448-40b0-8221-019f666b0c59' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-22c64758-e543-414d-9711-700aecbbb2ae' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-22c64758-e543-414d-9711-700aecbbb2ae' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-900190a0-bb0d-44a3-bcba-2577a9d99ed8' class='xr-var-data-in' type='checkbox'><label for='data-900190a0-bb0d-44a3-bcba-2577a9d99ed8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-81960970-ed3e-40b2-ab23-a25b943b8ddb' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-81960970-ed3e-40b2-ab23-a25b943b8ddb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-02314459-a2ee-44f2-b035-38da62447a1a' class='xr-var-data-in' type='checkbox'><label for='data-02314459-a2ee-44f2-b035-38da62447a1a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-d702995a-5e6d-4161-b6c5-b621b1b8b1d9' class='xr-section-summary-in' type='checkbox'  checked><label for='section-d702995a-5e6d-4161-b6c5-b621b1b8b1d9' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-0cf1e040-fa39-4ddd-b8c0-fa98b7e71f9e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0cf1e040-fa39-4ddd-b8c0-fa98b7e71f9e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b252aa53-5439-455b-ab29-6c0c7de8859b' class='xr-var-data-in' type='checkbox'><label for='data-b252aa53-5439-455b-ab29-6c0c7de8859b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-1cf1264f-fa9a-4ae7-a8ef-3dab42da790c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1cf1264f-fa9a-4ae7-a8ef-3dab42da790c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d7b7f266-fee0-4a1c-ae56-a539185315f1' class='xr-var-data-in' type='checkbox'><label for='data-d7b7f266-fee0-4a1c-ae56-a539185315f1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-f3b328a5-9955-4490-a3e4-53b53d7ed735' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f3b328a5-9955-4490-a3e4-53b53d7ed735' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-52fa42bd-1b5d-48d7-9d29-87aa6c08f175' class='xr-var-data-in' type='checkbox'><label for='data-52fa42bd-1b5d-48d7-9d29-87aa6c08f175' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-40667f51-3d79-4080-a803-6eba2ef14eaf' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-40667f51-3d79-4080-a803-6eba2ef14eaf' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-10930567-97b5-4a94-bd4f-9783c645167a' class='xr-var-data-in' type='checkbox'><label for='data-10930567-97b5-4a94-bd4f-9783c645167a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-a7fda9c7-966c-475c-be42-d53d2b02b9ad' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a7fda9c7-966c-475c-be42-d53d2b02b9ad' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-22bb9b39-ca98-471d-af4d-4369db7f60ad' class='xr-var-data-in' type='checkbox'><label for='data-22bb9b39-ca98-471d-af4d-4369db7f60ad' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-73120184-df74-48de-9842-ab88edd967c3' class='xr-section-summary-in' type='checkbox'  ><label for='section-73120184-df74-48de-9842-ab88edd967c3' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





{:.input}
```python
# Now your nodata value returns a NAN as it has been masked
# and accounted for
modis_pre_bands.sur_refl_b01_1.rio.nodata
```

{:.output}
{:.execute_result}



    nan





## Process MODIS Bands Stored in a HDF4 File

Xarray has several built in plot methods making it easy to explore your
data. Below you plot the first band.


{:.input}
```python
# Plot band one of the data
ep.plot_bands(modis_pre_bands.sur_refl_b01_1)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_25_0.png">

</figure>




{:.input}
```python
# Note that you can also call the data variable by name
ep.plot_bands(modis_pre_bands["sur_refl_b01_1"])
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_26_0.png">

</figure>




### Plot All MODIS Bands with EarthPy

Now that you have the needed reflectance  data, you can plot your data
using **earthpy.plot_bands**. 

To plot all bands in the data, you will need to first create an Xarray
DataArray object.

{:.input}
```python
print(type(modis_pre_bands))
print(type(modis_pre_bands.to_array()))

# You can plot each band easily using a data array object
modis_pre_bands.to_array()
```

{:.output}
    <class 'xarray.core.dataset.Dataset'>
    <class 'xarray.core.dataarray.DataArray'>



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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (variable: 5, y: 2400, x: 2400)&gt;
array([[[1902., 1949., 1947., ..., 1327., 1327., 1181.],
        [1949., 2160., 2095., ..., 1327., 1273., 1273.],
        [2054., 2156., 2187., ..., 1139., 1101., 1206.],
        ...,
        [1387., 1469., 1469., ...,  343.,  499., 1006.],
        [1298., 1316., 1469., ...,  905.,  499.,  436.],
        [1316., 1316., 1454., ...,  905.,  578.,  351.]],

       [[2714., 2859., 3041., ..., 3046., 3046., 4421.],
        [2968., 3362., 3253., ..., 3046., 4550., 4550.],
        [3198., 3315., 3246., ..., 4178., 4017., 3992.],
        ...,
        [2911., 2947., 2947., ..., 4059., 4907., 3799.],
        [2954., 2890., 2947., ..., 4517., 4907., 3459.],
        [2890., 2890., 2935., ..., 4517., 3728., 4021.]],

       [[1056., 1072., 1012., ...,  745.,  745.,  581.],
        [1051., 1150., 1039., ...,  745.,  595.,  595.],
        [1073., 1220., 1152., ...,  588.,  564.,  563.],
        ...,
        [ 759.,  813.,  813., ...,  150.,  218.,  852.],
        [ 703.,  735.,  813., ...,  585.,  218.,  199.],
        [ 735.,  735.,  798., ...,  585.,  338.,  109.]],

       [[1534., 1567., 1527., ..., 1107., 1107., 1069.],
        [1548., 1776., 1665., ..., 1107., 1121., 1121.],
        [1696., 1813., 1820., ..., 1029., 1018., 1077.],
        ...,
        [1209., 1267., 1267., ...,  597.,  788., 1153.],
        [1165., 1154., 1267., ..., 1089.,  788.,  603.],
        [1154., 1154., 1231., ..., 1089.,  759.,  516.]],

       [[2781., 2692., 2801., ..., 2260., 2260., 1534.],
        [2792., 2705., 2684., ..., 2260., 1449., 1449.],
        [2747., 2754., 2733., ..., 1713., 1802., 1548.],
        ...,
        [2457., 2446., 2446., ...,  444.,  832., 1379.],
        [2289., 2296., 2446., ..., 1161.,  832.,  762.],
        [2296., 2296., 2511., ..., 1161.,  913.,  703.]]], dtype=float32)
Coordinates:
  * y            (y) float64 4.448e+06 4.447e+06 ... 3.337e+06 3.336e+06
  * x            (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06 -8.896e+06
    band         int64 1
    spatial_ref  int64 0
  * variable     (variable) &lt;U14 &#x27;sur_refl_b01_1&#x27; ... &#x27;sur_refl_b07_1&#x27;
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>variable</span>: 5</li><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-480bd885-6f53-45ce-a2b4-513a4f6c1f49' class='xr-array-in' type='checkbox' checked><label for='section-480bd885-6f53-45ce-a2b4-513a4f6c1f49' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>1.902e+03 1.949e+03 1.947e+03 2.095e+03 ... 1.161e+03 913.0 703.0</span></div><div class='xr-array-data'><pre>array([[[1902., 1949., 1947., ..., 1327., 1327., 1181.],
        [1949., 2160., 2095., ..., 1327., 1273., 1273.],
        [2054., 2156., 2187., ..., 1139., 1101., 1206.],
        ...,
        [1387., 1469., 1469., ...,  343.,  499., 1006.],
        [1298., 1316., 1469., ...,  905.,  499.,  436.],
        [1316., 1316., 1454., ...,  905.,  578.,  351.]],

       [[2714., 2859., 3041., ..., 3046., 3046., 4421.],
        [2968., 3362., 3253., ..., 3046., 4550., 4550.],
        [3198., 3315., 3246., ..., 4178., 4017., 3992.],
        ...,
        [2911., 2947., 2947., ..., 4059., 4907., 3799.],
        [2954., 2890., 2947., ..., 4517., 4907., 3459.],
        [2890., 2890., 2935., ..., 4517., 3728., 4021.]],

       [[1056., 1072., 1012., ...,  745.,  745.,  581.],
        [1051., 1150., 1039., ...,  745.,  595.,  595.],
        [1073., 1220., 1152., ...,  588.,  564.,  563.],
        ...,
        [ 759.,  813.,  813., ...,  150.,  218.,  852.],
        [ 703.,  735.,  813., ...,  585.,  218.,  199.],
        [ 735.,  735.,  798., ...,  585.,  338.,  109.]],

       [[1534., 1567., 1527., ..., 1107., 1107., 1069.],
        [1548., 1776., 1665., ..., 1107., 1121., 1121.],
        [1696., 1813., 1820., ..., 1029., 1018., 1077.],
        ...,
        [1209., 1267., 1267., ...,  597.,  788., 1153.],
        [1165., 1154., 1267., ..., 1089.,  788.,  603.],
        [1154., 1154., 1231., ..., 1089.,  759.,  516.]],

       [[2781., 2692., 2801., ..., 2260., 2260., 1534.],
        [2792., 2705., 2684., ..., 2260., 1449., 1449.],
        [2747., 2754., 2733., ..., 1713., 1802., 1548.],
        ...,
        [2457., 2446., 2446., ...,  444.,  832., 1379.],
        [2289., 2296., 2446., ..., 1161.,  832.,  762.],
        [2296., 2296., 2511., ..., 1161.,  913.,  703.]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-67fb92cc-4deb-4224-9e05-e08444ffdd3d' class='xr-section-summary-in' type='checkbox'  checked><label for='section-67fb92cc-4deb-4224-9e05-e08444ffdd3d' class='xr-section-summary' >Coordinates: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-967baabf-4c70-4a1c-a993-f4c620e34a1a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-967baabf-4c70-4a1c-a993-f4c620e34a1a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e3756b12-c249-4a25-89ae-0b3e011b30be' class='xr-var-data-in' type='checkbox'><label for='data-e3756b12-c249-4a25-89ae-0b3e011b30be' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-8109e62a-35ca-47f3-99e3-1c3cf07b490e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-8109e62a-35ca-47f3-99e3-1c3cf07b490e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-67415d20-486f-4f69-a887-2c4050c60177' class='xr-var-data-in' type='checkbox'><label for='data-67415d20-486f-4f69-a887-2c4050c60177' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-ad565589-8332-426d-a1ca-5382db6d6efe' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-ad565589-8332-426d-a1ca-5382db6d6efe' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7a9bcc4a-d882-4113-8c41-0cbc8e0e6760' class='xr-var-data-in' type='checkbox'><label for='data-7a9bcc4a-d882-4113-8c41-0cbc8e0e6760' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-bf917244-b8b4-48ab-b185-3db005610e4c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-bf917244-b8b4-48ab-b185-3db005610e4c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6c87eb32-230f-4d0d-8789-3253442c128f' class='xr-var-data-in' type='checkbox'><label for='data-6c87eb32-230f-4d0d-8789-3253442c128f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>variable</span></div><div class='xr-var-dims'>(variable)</div><div class='xr-var-dtype'>&lt;U14</div><div class='xr-var-preview xr-preview'>&#x27;sur_refl_b01_1&#x27; ... &#x27;sur_refl_b...</div><input id='attrs-aa02cbc3-905e-4505-b6c3-28faf106894a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-aa02cbc3-905e-4505-b6c3-28faf106894a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ddf5f2f5-2198-4c75-b781-26f9848c1382' class='xr-var-data-in' type='checkbox'><label for='data-ddf5f2f5-2198-4c75-b781-26f9848c1382' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;sur_refl_b01_1&#x27;, &#x27;sur_refl_b02_1&#x27;, &#x27;sur_refl_b03_1&#x27;, &#x27;sur_refl_b04_1&#x27;,
       &#x27;sur_refl_b07_1&#x27;], dtype=&#x27;&lt;U14&#x27;)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-d1a3ec87-4cb9-4987-86b8-b3307ff865a3' class='xr-section-summary-in' type='checkbox'  ><label for='section-d1a3ec87-4cb9-4987-86b8-b3307ff865a3' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





{:.input}
```python
# Plot the data as a DataArray
# This is only a data exploration step
ep.plot_bands(modis_pre_bands.to_array().values,
              figsize=(10, 6))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_29_0.png">

</figure>




### RGB Image of MODIS Data Using EarthPy

Once you have cleaned your data cleaned, you can plot an RGB image
using earthpy.

{:.input}
```python
# Select the rgb bands only
rgb_bands = ['sur_refl_b01_1',
             'sur_refl_b03_1',
             'sur_refl_b04_1']
# Turn the data into a DataArray
modis_rgb_xr = modis_pre_bands[rgb_bands].to_array()
modis_rgb_xr
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (variable: 3, y: 2400, x: 2400)&gt;
array([[[1902., 1949., 1947., ..., 1327., 1327., 1181.],
        [1949., 2160., 2095., ..., 1327., 1273., 1273.],
        [2054., 2156., 2187., ..., 1139., 1101., 1206.],
        ...,
        [1387., 1469., 1469., ...,  343.,  499., 1006.],
        [1298., 1316., 1469., ...,  905.,  499.,  436.],
        [1316., 1316., 1454., ...,  905.,  578.,  351.]],

       [[1056., 1072., 1012., ...,  745.,  745.,  581.],
        [1051., 1150., 1039., ...,  745.,  595.,  595.],
        [1073., 1220., 1152., ...,  588.,  564.,  563.],
        ...,
        [ 759.,  813.,  813., ...,  150.,  218.,  852.],
        [ 703.,  735.,  813., ...,  585.,  218.,  199.],
        [ 735.,  735.,  798., ...,  585.,  338.,  109.]],

       [[1534., 1567., 1527., ..., 1107., 1107., 1069.],
        [1548., 1776., 1665., ..., 1107., 1121., 1121.],
        [1696., 1813., 1820., ..., 1029., 1018., 1077.],
        ...,
        [1209., 1267., 1267., ...,  597.,  788., 1153.],
        [1165., 1154., 1267., ..., 1089.,  788.,  603.],
        [1154., 1154., 1231., ..., 1089.,  759.,  516.]]], dtype=float32)
Coordinates:
  * y            (y) float64 4.448e+06 4.447e+06 ... 3.337e+06 3.336e+06
  * x            (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06 -8.896e+06
    band         int64 1
    spatial_ref  int64 0
  * variable     (variable) &lt;U14 &#x27;sur_refl_b01_1&#x27; ... &#x27;sur_refl_b04_1&#x27;
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>variable</span>: 3</li><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-3311f1aa-024c-4efc-b2d9-e221106aac54' class='xr-array-in' type='checkbox' checked><label for='section-3311f1aa-024c-4efc-b2d9-e221106aac54' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>1.902e+03 1.949e+03 1.947e+03 2.095e+03 ... 1.089e+03 759.0 516.0</span></div><div class='xr-array-data'><pre>array([[[1902., 1949., 1947., ..., 1327., 1327., 1181.],
        [1949., 2160., 2095., ..., 1327., 1273., 1273.],
        [2054., 2156., 2187., ..., 1139., 1101., 1206.],
        ...,
        [1387., 1469., 1469., ...,  343.,  499., 1006.],
        [1298., 1316., 1469., ...,  905.,  499.,  436.],
        [1316., 1316., 1454., ...,  905.,  578.,  351.]],

       [[1056., 1072., 1012., ...,  745.,  745.,  581.],
        [1051., 1150., 1039., ...,  745.,  595.,  595.],
        [1073., 1220., 1152., ...,  588.,  564.,  563.],
        ...,
        [ 759.,  813.,  813., ...,  150.,  218.,  852.],
        [ 703.,  735.,  813., ...,  585.,  218.,  199.],
        [ 735.,  735.,  798., ...,  585.,  338.,  109.]],

       [[1534., 1567., 1527., ..., 1107., 1107., 1069.],
        [1548., 1776., 1665., ..., 1107., 1121., 1121.],
        [1696., 1813., 1820., ..., 1029., 1018., 1077.],
        ...,
        [1209., 1267., 1267., ...,  597.,  788., 1153.],
        [1165., 1154., 1267., ..., 1089.,  788.,  603.],
        [1154., 1154., 1231., ..., 1089.,  759.,  516.]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-570856ec-d530-4610-81c0-049d71c5efd3' class='xr-section-summary-in' type='checkbox'  checked><label for='section-570856ec-d530-4610-81c0-049d71c5efd3' class='xr-section-summary' >Coordinates: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-a8b2c70b-b653-41b0-90eb-b75f7bbfed8c' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a8b2c70b-b653-41b0-90eb-b75f7bbfed8c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c33907d3-229e-4e96-88e3-9bb5ade67f1c' class='xr-var-data-in' type='checkbox'><label for='data-c33907d3-229e-4e96-88e3-9bb5ade67f1c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-45beeee8-0c49-4850-96e5-4896f6c72e6e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-45beeee8-0c49-4850-96e5-4896f6c72e6e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3e73d634-cb14-4acd-aa51-ab590f50f7f5' class='xr-var-data-in' type='checkbox'><label for='data-3e73d634-cb14-4acd-aa51-ab590f50f7f5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-5193be20-7efc-4f93-bc6f-dbb5b7a13635' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5193be20-7efc-4f93-bc6f-dbb5b7a13635' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-73de0a19-b180-4166-92a6-3eac79d5bfb2' class='xr-var-data-in' type='checkbox'><label for='data-73de0a19-b180-4166-92a6-3eac79d5bfb2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-2ed8891e-4487-4916-9bd4-167392f0d81b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2ed8891e-4487-4916-9bd4-167392f0d81b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bd2ffc31-b054-4e9a-85a4-63b679ca452d' class='xr-var-data-in' type='checkbox'><label for='data-bd2ffc31-b054-4e9a-85a4-63b679ca452d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>variable</span></div><div class='xr-var-dims'>(variable)</div><div class='xr-var-dtype'>&lt;U14</div><div class='xr-var-preview xr-preview'>&#x27;sur_refl_b01_1&#x27; ... &#x27;sur_refl_b...</div><input id='attrs-8a827b7e-1f75-4021-87a1-e69dc12741a9' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-8a827b7e-1f75-4021-87a1-e69dc12741a9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e3fb0794-93b0-487c-852a-53c96e41ac19' class='xr-var-data-in' type='checkbox'><label for='data-e3fb0794-93b0-487c-852a-53c96e41ac19' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;sur_refl_b01_1&#x27;, &#x27;sur_refl_b03_1&#x27;, &#x27;sur_refl_b04_1&#x27;], dtype=&#x27;&lt;U14&#x27;)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-e6b11af2-0852-40b2-a58d-2d3f4bb6de5c' class='xr-section-summary-in' type='checkbox'  ><label for='section-e6b11af2-0852-40b2-a58d-2d3f4bb6de5c' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





{:.input}
```python
def clean_array_plot(xr_obj):
    # This function takes a single xarray object as an input and produces a
    # cleaned numpy array output for plotting
    # BEGIN SOLUTION
    """
    Take an  xarray object and replace null  values with a mask for plotting

    Parameters
    ----------
    xr_obj : xarray object

    Returns
    -------
    A masked numpy array 

    """
    # END SOLUTION

    return ma.masked_array(xr_obj.values,  xr_obj.isnull())
```

{:.input}
```python
# For plotting you will want to clean up masked values
# Note that this is not a numpy array
modis_arr = clean_array_plot(modis_rgb_xr)
modis_arr
```

{:.output}
{:.execute_result}



    masked_array(
      data=[[[1902.0, 1949.0, 1947.0, ..., 1327.0, 1327.0, 1181.0],
             [1949.0, 2160.0, 2095.0, ..., 1327.0, 1273.0, 1273.0],
             [2054.0, 2156.0, 2187.0, ..., 1139.0, 1101.0, 1206.0],
             ...,
             [1387.0, 1469.0, 1469.0, ..., 343.0, 499.0, 1006.0],
             [1298.0, 1316.0, 1469.0, ..., 905.0, 499.0, 436.0],
             [1316.0, 1316.0, 1454.0, ..., 905.0, 578.0, 351.0]],
    
            [[1056.0, 1072.0, 1012.0, ..., 745.0, 745.0, 581.0],
             [1051.0, 1150.0, 1039.0, ..., 745.0, 595.0, 595.0],
             [1073.0, 1220.0, 1152.0, ..., 588.0, 564.0, 563.0],
             ...,
             [759.0, 813.0, 813.0, ..., 150.0, 218.0, 852.0],
             [703.0, 735.0, 813.0, ..., 585.0, 218.0, 199.0],
             [735.0, 735.0, 798.0, ..., 585.0, 338.0, 109.0]],
    
            [[1534.0, 1567.0, 1527.0, ..., 1107.0, 1107.0, 1069.0],
             [1548.0, 1776.0, 1665.0, ..., 1107.0, 1121.0, 1121.0],
             [1696.0, 1813.0, 1820.0, ..., 1029.0, 1018.0, 1077.0],
             ...,
             [1209.0, 1267.0, 1267.0, ..., 597.0, 788.0, 1153.0],
             [1165.0, 1154.0, 1267.0, ..., 1089.0, 788.0, 603.0],
             [1154.0, 1154.0, 1231.0, ..., 1089.0, 759.0, 516.0]]],
      mask=[[[False, False, False, ..., False, False, False],
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
             [False, False, False, ..., False, False, False]]],
      fill_value=1e+20,
      dtype=float32)





{:.input}
```python
# Plot MODIS RGB numpy image array
ep.plot_rgb(modis_arr,
            rgb=[0, 2, 1],
            title='RGB Image of MODIS Data')

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_34_0.png">

</figure>




## Crop (Clip) MODIS Data Using Rioxarray

Above you opened and plotted MODIS reflectance data. However, the data 
cover a larger study area than you need. It is a good idea to crop your
the data to maximize processing efficiency. Less  pixels  means  less  
processing time and power needed.

There are a few approaches here to consider

1. Do you want to clip the data to a box (a rectangular extent) vs to the specific  geometry of  your  shapefile
2. If your data are large and you have limited memory, you  may only want to open  the data needed for processing.

Below you have a few different options for clipping your data.
To demonstrate the full workflow, we will s tart over and open the data.

To begin, open up the fire boundary which contains your study area
extent that you wish to  crop your MODIS data to `co_cold_springs_20160711_2200_dd83.shp`). 

{:.input}
```python
# Open fire boundary
fire_boundary_path = os.path.join("cold-springs-fire",
                                  "vector_layers",
                                  "fire-boundary-geomac",
                                  "co_cold_springs_20160711_2200_dd83.shp")

fire_boundary = gpd.read_file(fire_boundary_path)

# Check the CRS of your study area extent
fire_boundary.crs
```

{:.output}
{:.execute_result}



    <Geographic 2D CRS: EPSG:4269>
    Name: NAD83
    Axis Info [ellipsoidal]:
    - Lat[north]: Geodetic latitude (degree)
    - Lon[east]: Geodetic longitude (degree)
    Area of Use:
    - name: North America - onshore and offshore: Canada - Alberta; British Columbia; Manitoba; New Brunswick; Newfoundland and Labrador; Northwest Territories; Nova Scotia; Nunavut; Ontario; Prince Edward Island; Quebec; Saskatchewan; Yukon. Puerto Rico. United States (USA) - Alabama; Alaska; Arizona; Arkansas; California; Colorado; Connecticut; Delaware; Florida; Georgia; Hawaii; Idaho; Illinois; Indiana; Iowa; Kansas; Kentucky; Louisiana; Maine; Maryland; Massachusetts; Michigan; Minnesota; Mississippi; Missouri; Montana; Nebraska; Nevada; New Hampshire; New Jersey; New Mexico; New York; North Carolina; North Dakota; Ohio; Oklahoma; Oregon; Pennsylvania; Rhode Island; South Carolina; South Dakota; Tennessee; Texas; Utah; Vermont; Virginia; Washington; West Virginia; Wisconsin; Wyoming. US Virgin Islands. British Virgin Islands.
    - bounds: (167.65, 14.92, -47.74, 86.46)
    Datum: North American Datum 1983
    - Ellipsoid: GRS 1980
    - Prime Meridian: Greenwich





### Reproject the Clip Extent (Fire Boundary)

To check the CRS of MODIS data, you can:

1. Open the MODIS data in `rioxarray`
2. Grab the CRS of the band accessing `rio.crs` from the `rioxarray` object.

You can also use rasterio to "view" and  access the CRS 

You can then use the CRS of the band to check and reproject the fire boundary if it 
is not in the same CRS.

In the code below, you use these steps to reproject the fire boundary to match the HDF4 data. 

Note that you do not need all of the 
print statments included below. They are included to help you see what is 
happening in the code!

{:.input}
```python
# Check CRS
if not fire_boundary.crs == modis_rgb_xr.rio.crs:
    # If the crs is not equal reproject the data
    fire_bound_sin = fire_boundary.to_crs(modis_rgb_xr.rio.crs)

fire_bound_sin.crs
```

{:.output}
{:.execute_result}



    <Projected CRS: PROJCS["unnamed",GEOGCS["Unknown datum based upon  ...>
    Name: unnamed
    Axis Info [cartesian]:
    - [east]: Easting (Meter)
    - [north]: Northing (Meter)
    Area of Use:
    - undefined
    Coordinate Operation:
    - name: unnamed
    - method: Sinusoidal
    Datum: Not specified (based on custom spheroid)
    - Ellipsoid: Custom spheroid
    - Prime Meridian: Greenwich





###  Scenario 1:  Open and Clip the  Data Using the CRS=Parameter

In  the first scenario obelow, you open and clip your data.
By using the `crs=` parameter, you can skip needing to reproject the 
clip extent as rioxarray does it for you.

The caveat too this approach is that it is generally slower than 
the other approaches. The benefit is it avoids the additional 
reprojection step.

{:.input}
```python
# Notice this is a box - representing the spatial extent
# of your study area
crop_bound_box = [box(*fire_boundary.total_bounds)]
crop_bound_box[0]
```

{:.output}
{:.execute_result}



![svg]({{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_40_0.svg)





{:.input}
```python
# Notice that this is the actual shape of the fire boundary
# First you need to decide whether you want to clip to the
# Box /  extent (above) or the shape that you see here.
fire_boundary.geometry[0]
```

{:.output}
{:.execute_result}



![svg]({{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_41_0.svg)





Below you clip the data to the box extent.

A few notes on each  parameter included  below

`open_rasterio` parameters:

* `masked=True` : This masks out no data  values for you
* `variable=` : Allows you to select data variables to open effectively subsetting or slicing out only the parts of the data that you need.

`rio.clip` parameters

* `crs=`  : Use this if your crop extent is in a different CRS than your raster xarray data. NOTE that this can slow your processing down significantly.
* `all_touched=` :  Set to True if you want to include all pixels touched by your crop boundary. Sometimes the edge of a shapefile will cross over a pixel making it a "partial"  pixel. Do you want to include all pixels even if only some of that pixel is in your study area? IF so set to True. If you only with to  include  pixels that are FULLY WITHIN your study area set to `False`.
* `from_disk` : Include this to only OPEN the data that you wish to work with. Thus instead of opening up the entire raster and then clipping, the data within the clip boundary are "sliced" out. this saves memory and sometimes processing time!

{:.input}
```python
# Open just the bands that you want to process
desired_bands = ["sur_refl_b01_1",
                 "sur_refl_b02_1",
                 "sur_refl_b03_1",
                 "sur_refl_b04_1",
                 "sur_refl_b07_1"]

#  Create a box representing the spatial extent of your data
crop_bound_box = [box(*fire_boundary.total_bounds)]
# Clip the data by  chaining together rio.clip with rio.open_rasterio
# from_disk=True allows you to only open the data that you wish to work with
modis_pre_clip = rxr.open_rasterio(modis_pre_path,
                                   masked=True,
                                   variable=desired_bands).rio.clip(crop_bound_box,
                                                                    crs=fire_boundary.crs,
                                                                    # Include all pixels even partial pixels
                                                                    all_touched=True,
                                                                    from_disk=True).squeeze()
# The final clipped data
modis_pre_clip
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:         (y: 3, x: 12)
Coordinates:
  * y               (y) float64 4.446e+06 4.446e+06 4.445e+06
  * x               (x) float64 -8.989e+06 -8.989e+06 ... -8.985e+06 -8.984e+06
    band            int64 1
    spatial_ref     int64 0
Data variables:
    sur_refl_b01_1  (y, x) float32 nan nan 428.0 450.0 ... 458.0 nan nan nan
    sur_refl_b02_1  (y, x) float32 nan nan 3.013e+03 2.809e+03 ... nan nan nan
    sur_refl_b03_1  (y, x) float32 nan nan 259.0 235.0 ... 265.0 nan nan nan
    sur_refl_b04_1  (y, x) float32 nan nan 563.0 541.0 ... 518.0 nan nan nan
    sur_refl_b07_1  (y, x) float32 nan nan 832.0 820.0 ... 804.0 nan nan nan
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-d32e3e69-0201-4ec9-aa97-8465025c8010' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-d32e3e69-0201-4ec9-aa97-8465025c8010' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 12</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-61d88ed1-4da9-4a16-80ba-0abb2638ffa9' class='xr-section-summary-in' type='checkbox'  checked><label for='section-61d88ed1-4da9-4a16-80ba-0abb2638ffa9' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-71caf207-b02f-414d-b5ab-704295dce741' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-71caf207-b02f-414d-b5ab-704295dce741' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-750ff339-c926-40c1-9c52-35e1a95ec7fc' class='xr-var-data-in' type='checkbox'><label for='data-750ff339-c926-40c1-9c52-35e1a95ec7fc' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.989e+06 ... -8.984e+06</div><input id='attrs-93c352fe-9a02-4a12-9c0e-a0970327e64d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-93c352fe-9a02-4a12-9c0e-a0970327e64d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a06e8d35-d35e-492c-8f3c-fc1c3a88f5ea' class='xr-var-data-in' type='checkbox'><label for='data-a06e8d35-d35e-492c-8f3c-fc1c3a88f5ea' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8989424.98243 , -8988961.669713, -8988498.356997, -8988035.04428 ,
       -8987571.731564, -8987108.418847, -8986645.106131, -8986181.793414,
       -8985718.480698, -8985255.167981, -8984791.855265, -8984328.542548])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-83c1ea06-b5f3-426c-b786-9b87208cd44a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-83c1ea06-b5f3-426c-b786-9b87208cd44a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2901dc62-5643-4f7f-8fdf-b02ee0abe1ac' class='xr-var-data-in' type='checkbox'><label for='data-2901dc62-5643-4f7f-8fdf-b02ee0abe1ac' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-ddb3d0cf-9c1c-43ca-a048-2cbdf8c87399' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ddb3d0cf-9c1c-43ca-a048-2cbdf8c87399' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-81a8f0d6-453f-448d-9395-a0f2021b03d6' class='xr-var-data-in' type='checkbox'><label for='data-81a8f0d6-453f-448d-9395-a0f2021b03d6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8989656.638788167 463.3127165279266 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-97aff1ac-79e6-4a35-be9b-2c3ef42df365' class='xr-section-summary-in' type='checkbox'  checked><label for='section-97aff1ac-79e6-4a35-be9b-2c3ef42df365' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 428.0 450.0 ... nan nan nan</div><input id='attrs-b432d414-9fc2-4d65-b41a-0f087a30b4e4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b432d414-9fc2-4d65-b41a-0f087a30b4e4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-146bc56a-ebf4-4824-8461-089d6d8217e2' class='xr-var-data-in' type='checkbox'><label for='data-146bc56a-ebf4-4824-8461-089d6d8217e2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 428., 450., 450., 438., 438., 421., 421., 409., 409.,
        483.],
       [ nan, 402., 402., 402., 402., 442., 442., 442., 442., 458., 458.,
         nan],
       [402., 402., 402., 402., 442., 442., 442., 442., 458.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 3.013e+03 ... nan nan nan</div><input id='attrs-28665834-02bf-4c2a-84e6-ac4360aa4aab' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-28665834-02bf-4c2a-84e6-ac4360aa4aab' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-70c23cdf-a2ae-4c73-b046-531a4df433a3' class='xr-var-data-in' type='checkbox'><label for='data-70c23cdf-a2ae-4c73-b046-531a4df433a3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[  nan,   nan, 3013., 2809., 2809., 2730., 2730., 2628., 2628.,
        2641., 2641., 2576.],
       [  nan, 2565., 2565., 2565., 2565., 2522., 2522., 2522., 2522.,
        2496., 2496.,   nan],
       [2565., 2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.,
          nan,   nan,   nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 259.0 235.0 ... nan nan nan</div><input id='attrs-f012c3a8-a201-4efa-ac1d-cb754c8b64f4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f012c3a8-a201-4efa-ac1d-cb754c8b64f4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-dedde027-8704-45de-96dd-09da49a01b08' class='xr-var-data-in' type='checkbox'><label for='data-dedde027-8704-45de-96dd-09da49a01b08' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 259., 235., 235., 231., 231., 211., 211., 203., 203.,
        245.],
       [ nan, 217., 217., 217., 217., 230., 230., 230., 230., 265., 265.,
         nan],
       [217., 217., 217., 217., 230., 230., 230., 230., 265.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 563.0 541.0 ... nan nan nan</div><input id='attrs-38993509-f44f-49e4-bd3e-8578b4b50d44' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-38993509-f44f-49e4-bd3e-8578b4b50d44' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e630f98d-1a97-48a1-99fd-bcca65cb6648' class='xr-var-data-in' type='checkbox'><label for='data-e630f98d-1a97-48a1-99fd-bcca65cb6648' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 563., 541., 541., 528., 528., 494., 494., 486., 486.,
        530.],
       [ nan, 476., 476., 476., 476., 476., 476., 476., 476., 518., 518.,
         nan],
       [476., 476., 476., 476., 476., 476., 476., 476., 518.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 832.0 820.0 ... nan nan nan</div><input id='attrs-f31dff1b-9b8e-45a4-8de3-03a9dae65ba0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f31dff1b-9b8e-45a4-8de3-03a9dae65ba0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8e1583d6-fba9-40ba-b2e0-176d0bf47f71' class='xr-var-data-in' type='checkbox'><label for='data-8e1583d6-fba9-40ba-b2e0-176d0bf47f71' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 832., 820., 820., 820., 820., 749., 749., 715., 715.,
        820.],
       [ nan, 715., 715., 715., 715., 789., 789., 789., 789., 804., 804.,
         nan],
       [715., 715., 715., 715., 789., 789., 789., 789., 804.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-547a86ea-39d9-4909-b384-376e4bb22ef8' class='xr-section-summary-in' type='checkbox'  ><label for='section-547a86ea-39d9-4909-b384-376e4bb22ef8' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





{:.input}
```python
# For demonstration purpposes  i'm creating a plotting extent
from rasterio.plot import plotting_extent

modis_ext = plotting_extent(modis_pre_clip.to_array().values[0],
                            modis_pre_clip.rio.transform())
```

{:.input}
```python
# View cropped data
f, ax = plt.subplots()
ep.plot_bands(modis_pre_clip.to_array().values[0],
              ax=ax,
              extent=modis_ext,
              title="Plot of data clipped to the crop box (extent)")
fire_bound_sin.plot(ax=ax,
                    color="green")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_45_0.png">

</figure>




### Scenario  2:  Crop Using the  GEOMETRY 

In the scenario below you crop /  mask the data to the 
actual geometry shape of the fire boundary. Because the MODIS
pixels are larger and the study area is relative small,
you can't visually see a difference however you will 
see a difference with landsat and other higher resolution data.

{:.input}
```python
# Open just the bands that you want to process
desired_bands = ["sur_refl_b01_1",
                 "sur_refl_b02_1",
                 "sur_refl_b03_1",
                 "sur_refl_b04_1",
                 "sur_refl_b07_1"]

#  Create a box representing the spatial extent of your data
crop_bound_box = [box(*fire_boundary.total_bounds)]
# Clip the data by  chaining together rio.clip with rio.open_rasterio
# from_disk=True allows you to only open the data that you wish to work with
modis_pre_clip_geom = rxr.open_rasterio(modis_pre_path,
                                   masked=True,
                                   variable=desired_bands).rio.clip(fire_boundary.geometry.apply(mapping),
                                                                    crs=fire_boundary.crs,
                                                                    # Include all pixels even partial pixels
                                                                    all_touched=True,
                                                                    from_disk=True).squeeze()
# The final clipped data  -  Notice there are fewer pixels
# In the output object
modis_pre_clip_geom
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:         (y: 3, x: 8)
Coordinates:
  * y               (y) float64 4.446e+06 4.446e+06 4.445e+06
  * x               (x) float64 -8.988e+06 -8.988e+06 ... -8.986e+06 -8.985e+06
    band            int64 1
    spatial_ref     int64 0
Data variables:
    sur_refl_b01_1  (y, x) float32 428.0 450.0 450.0 438.0 ... 442.0 458.0 nan
    sur_refl_b02_1  (y, x) float32 3.013e+03 2.809e+03 ... 2.496e+03 nan
    sur_refl_b03_1  (y, x) float32 259.0 235.0 235.0 231.0 ... 230.0 265.0 nan
    sur_refl_b04_1  (y, x) float32 563.0 541.0 541.0 528.0 ... 476.0 518.0 nan
    sur_refl_b07_1  (y, x) float32 832.0 820.0 820.0 820.0 ... 789.0 804.0 nan
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-ed9df515-f2b4-4659-b2e2-86e2d6f3a1ba' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-ed9df515-f2b4-4659-b2e2-86e2d6f3a1ba' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 8</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-1ff134db-d89d-41f6-9d3f-ca4ae848203b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-1ff134db-d89d-41f6-9d3f-ca4ae848203b' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-570ed0a6-d1f0-4914-9309-c9d05ddc96d9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-570ed0a6-d1f0-4914-9309-c9d05ddc96d9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8314ec73-1355-4b7b-b03e-44b92fb865c3' class='xr-var-data-in' type='checkbox'><label for='data-8314ec73-1355-4b7b-b03e-44b92fb865c3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.988e+06 ... -8.985e+06</div><input id='attrs-5b12b912-8ec9-4a9c-9c5b-d19eb72ffe99' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5b12b912-8ec9-4a9c-9c5b-d19eb72ffe99' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-21862b35-87d8-4a24-9b4b-604c8361b600' class='xr-var-data-in' type='checkbox'><label for='data-21862b35-87d8-4a24-9b4b-604c8361b600' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8988498.356997, -8988035.04428 , -8987571.731564, -8987108.418847,
       -8986645.106131, -8986181.793414, -8985718.480698, -8985255.167981])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-97c9c60b-0738-4e3b-8cc1-c3b7163fe349' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-97c9c60b-0738-4e3b-8cc1-c3b7163fe349' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-82d20870-4a15-46a8-ba3c-845509dd3407' class='xr-var-data-in' type='checkbox'><label for='data-82d20870-4a15-46a8-ba3c-845509dd3407' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-115b44b8-1c5c-458d-a9d4-94b906feb849' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-115b44b8-1c5c-458d-a9d4-94b906feb849' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b54ac275-6b82-4a4e-9d7b-45e1a1d81e44' class='xr-var-data-in' type='checkbox'><label for='data-b54ac275-6b82-4a4e-9d7b-45e1a1d81e44' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8988730.01335511 463.3127165277089 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-ff32bd28-1876-4508-83a1-f2f101e00521' class='xr-section-summary-in' type='checkbox'  checked><label for='section-ff32bd28-1876-4508-83a1-f2f101e00521' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>428.0 450.0 450.0 ... 458.0 nan</div><input id='attrs-90f17885-03a1-4292-ac97-54e7d3e740e4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-90f17885-03a1-4292-ac97-54e7d3e740e4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1c159e02-df61-4a30-a4e4-52d421eb6c39' class='xr-var-data-in' type='checkbox'><label for='data-1c159e02-df61-4a30-a4e4-52d421eb6c39' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[428., 450., 450., 438., 438.,  nan,  nan,  nan],
       [402., 402., 402., 442., 442., 442., 442., 458.],
       [402., 402., 442., 442., 442., 442., 458.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>3.013e+03 2.809e+03 ... nan</div><input id='attrs-81cbeb81-b749-424d-a371-39b7e8f0eff9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-81cbeb81-b749-424d-a371-39b7e8f0eff9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f443ab5e-b441-410b-a750-f9bf6b9c4783' class='xr-var-data-in' type='checkbox'><label for='data-f443ab5e-b441-410b-a750-f9bf6b9c4783' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[3013., 2809., 2809., 2730., 2730.,   nan,   nan,   nan],
       [2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.],
       [2565., 2565., 2522., 2522., 2522., 2522., 2496.,   nan]],
      dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>259.0 235.0 235.0 ... 265.0 nan</div><input id='attrs-eeb12121-a859-4c9d-ab24-6440a5c3ed65' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-eeb12121-a859-4c9d-ab24-6440a5c3ed65' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-182c0b06-0263-4d79-8e1d-a2dd39c02112' class='xr-var-data-in' type='checkbox'><label for='data-182c0b06-0263-4d79-8e1d-a2dd39c02112' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[259., 235., 235., 231., 231.,  nan,  nan,  nan],
       [217., 217., 217., 230., 230., 230., 230., 265.],
       [217., 217., 230., 230., 230., 230., 265.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>563.0 541.0 541.0 ... 518.0 nan</div><input id='attrs-29d1d7ce-e73f-404e-a238-79c259f4b6f4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-29d1d7ce-e73f-404e-a238-79c259f4b6f4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5f8fc08d-f220-435a-b95c-32d3a09e9899' class='xr-var-data-in' type='checkbox'><label for='data-5f8fc08d-f220-435a-b95c-32d3a09e9899' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[563., 541., 541., 528., 528.,  nan,  nan,  nan],
       [476., 476., 476., 476., 476., 476., 476., 518.],
       [476., 476., 476., 476., 476., 476., 518.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>832.0 820.0 820.0 ... 804.0 nan</div><input id='attrs-90d29a26-e81b-4e96-aa14-68bb719e84f0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-90d29a26-e81b-4e96-aa14-68bb719e84f0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3829750d-39e1-43f3-ae44-c85dddb75f6a' class='xr-var-data-in' type='checkbox'><label for='data-3829750d-39e1-43f3-ae44-c85dddb75f6a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[832., 820., 820., 820., 820.,  nan,  nan,  nan],
       [715., 715., 715., 789., 789., 789., 789., 804.],
       [715., 715., 789., 789., 789., 789., 804.,  nan]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-63e52e7c-a988-45c2-9b02-81df4ce3468d' class='xr-section-summary-in' type='checkbox'  ><label for='section-63e52e7c-a988-45c2-9b02-81df4ce3468d' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





Note that the difference between the two plots will be more visible
when using data like landsat with smaller pixels.

{:.input}
```python
# View cropped data  - note the  different b etew
f, ax = plt.subplots()
ep.plot_bands(modis_pre_clip_geom.to_array().values[0],
              ax=ax,
              extent=modis_ext,
              title="Plot of the data clipped to the geometry")
fire_bound_sin.plot(ax=ax,
                    color="green")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_49_0.png">

</figure>




### Scenario  3:  Crop MODIS Data Using Reprojected Fire Boundary

In the  example below, you skip  the `crs=` argument.  
This has  assumed that yoou  have already  reprojected your  
vector  crop  extent. 

In this example the clip function is not chained to the 
`open_rasterio` function making the proccessing a bit less efficient.
More data will be stored in memory in this example.

Once you have opened and reprojected your crop extent, you can 
crop your MODIS raster data. You can do this by calling `xarray_name.rio.clip([box(*boundary_name.total_bounds)])`. Keep in mind, for this to work you have to import `box` from `shapely.geometry`!


{:.input}
```python
# Open the data but don't clip just yet
modis_bands = rxr.open_rasterio(modis_pre_path,
                                masked=True,
                                variable=desired_bands)

# Reproject the fire boundary
fire_boundary_sin = fire_boundary.to_crs(modis_bands.rio.crs)

modis_bands_clip = modis_bands.rio.clip([box(*fire_bound_sin.total_bounds)],
                                        all_touched=True,
                                        from_disk=True).squeeze()
modis_bands_clip
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.Dataset&gt;
Dimensions:         (y: 3, x: 8)
Coordinates:
  * y               (y) float64 4.446e+06 4.446e+06 4.445e+06
  * x               (x) float64 -8.988e+06 -8.988e+06 ... -8.986e+06 -8.985e+06
    band            int64 1
    spatial_ref     int64 0
Data variables:
    sur_refl_b01_1  (y, x) float32 428.0 450.0 450.0 438.0 ... 442.0 458.0 458.0
    sur_refl_b02_1  (y, x) float32 3.013e+03 2.809e+03 ... 2.496e+03 2.496e+03
    sur_refl_b03_1  (y, x) float32 259.0 235.0 235.0 231.0 ... 230.0 265.0 265.0
    sur_refl_b04_1  (y, x) float32 563.0 541.0 541.0 528.0 ... 476.0 518.0 518.0
    sur_refl_b07_1  (y, x) float32 832.0 820.0 820.0 820.0 ... 789.0 804.0 804.0
Attributes: (12/136)
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    ...                                  ...
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-b561f619-cc4e-4011-9d14-c66b0670dc69' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-b561f619-cc4e-4011-9d14-c66b0670dc69' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 8</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-9e10b061-03fa-436c-8619-cd40e76d6027' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9e10b061-03fa-436c-8619-cd40e76d6027' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-717ffdf5-9531-4a05-bec5-d61394b176ba' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-717ffdf5-9531-4a05-bec5-d61394b176ba' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f569a7a4-2ac0-4211-9e5b-0381f360cf84' class='xr-var-data-in' type='checkbox'><label for='data-f569a7a4-2ac0-4211-9e5b-0381f360cf84' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.988e+06 ... -8.985e+06</div><input id='attrs-fc91dea1-d0c8-4776-8ad6-ee32f243065c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-fc91dea1-d0c8-4776-8ad6-ee32f243065c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fabd7134-346e-4bce-b716-f090051d43fd' class='xr-var-data-in' type='checkbox'><label for='data-fabd7134-346e-4bce-b716-f090051d43fd' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8988498.356997, -8988035.04428 , -8987571.731564, -8987108.418847,
       -8986645.106131, -8986181.793414, -8985718.480698, -8985255.167981])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-8feb937c-4952-4881-9df8-3c13491b2aaf' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-8feb937c-4952-4881-9df8-3c13491b2aaf' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ee6a9b7c-8dc7-4edb-abaf-bf8df3612ed5' class='xr-var-data-in' type='checkbox'><label for='data-ee6a9b7c-8dc7-4edb-abaf-bf8df3612ed5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-15daeb31-0be5-43f3-9970-8e1d6a2c7501' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-15daeb31-0be5-43f3-9970-8e1d6a2c7501' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-45590fa4-e433-4011-b1c7-651d4a4aad6d' class='xr-var-data-in' type='checkbox'><label for='data-45590fa4-e433-4011-b1c7-651d4a4aad6d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8988730.01335511 463.3127165277089 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-64565231-52fa-4bb9-a5ff-76e6c29dd4bd' class='xr-section-summary-in' type='checkbox'  checked><label for='section-64565231-52fa-4bb9-a5ff-76e6c29dd4bd' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>428.0 450.0 450.0 ... 458.0 458.0</div><input id='attrs-25e52dfd-8158-4df6-93ad-218b92811934' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-25e52dfd-8158-4df6-93ad-218b92811934' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a42b0da8-1646-4eaa-bf5a-edc7dc3d4802' class='xr-var-data-in' type='checkbox'><label for='data-a42b0da8-1646-4eaa-bf5a-edc7dc3d4802' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[428., 450., 450., 438., 438., 421., 421., 409.],
       [402., 402., 402., 442., 442., 442., 442., 458.],
       [402., 402., 442., 442., 442., 442., 458., 458.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>3.013e+03 2.809e+03 ... 2.496e+03</div><input id='attrs-eb55b1c6-8cdb-4c9f-b4fb-e2e543821c75' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-eb55b1c6-8cdb-4c9f-b4fb-e2e543821c75' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-34ddfcda-af72-46aa-8787-ff3cc5f3c281' class='xr-var-data-in' type='checkbox'><label for='data-34ddfcda-af72-46aa-8787-ff3cc5f3c281' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[3013., 2809., 2809., 2730., 2730., 2628., 2628., 2641.],
       [2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.],
       [2565., 2565., 2522., 2522., 2522., 2522., 2496., 2496.]],
      dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>259.0 235.0 235.0 ... 265.0 265.0</div><input id='attrs-589e09eb-1305-4619-a434-95e8b7c4e59d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-589e09eb-1305-4619-a434-95e8b7c4e59d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d844fbde-0aa2-4f2e-be9f-4c796e8ff722' class='xr-var-data-in' type='checkbox'><label for='data-d844fbde-0aa2-4f2e-be9f-4c796e8ff722' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[259., 235., 235., 231., 231., 211., 211., 203.],
       [217., 217., 217., 230., 230., 230., 230., 265.],
       [217., 217., 230., 230., 230., 230., 265., 265.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>563.0 541.0 541.0 ... 518.0 518.0</div><input id='attrs-42ff6cba-2185-452d-929a-7f40e372d892' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-42ff6cba-2185-452d-929a-7f40e372d892' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-92c58bfe-c426-4406-9f18-3a2c8932325e' class='xr-var-data-in' type='checkbox'><label for='data-92c58bfe-c426-4406-9f18-3a2c8932325e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[563., 541., 541., 528., 528., 494., 494., 486.],
       [476., 476., 476., 476., 476., 476., 476., 518.],
       [476., 476., 476., 476., 476., 476., 518., 518.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>832.0 820.0 820.0 ... 804.0 804.0</div><input id='attrs-f568b712-71e7-4a58-a0ce-efa7c7bc9751' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f568b712-71e7-4a58-a0ce-efa7c7bc9751' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8dedbf76-2a65-4e5c-9eb0-8ab6224408c8' class='xr-var-data-in' type='checkbox'><label for='data-8dedbf76-2a65-4e5c-9eb0-8ab6224408c8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[832., 820., 820., 820., 820., 749., 749., 715.],
       [715., 715., 715., 789., 789., 789., 789., 804.],
       [715., 715., 789., 789., 789., 789., 804., 804.]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-bac38ac2-ffcd-4072-a69b-8a64bd722c9d' class='xr-section-summary-in' type='checkbox'  ><label for='section-bac38ac2-ffcd-4072-a69b-8a64bd722c9d' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





The output  plot looks similar, yet the processing approach is  
different

{:.input}
```python
# View cropped data
f, ax = plt.subplots()
ep.plot_bands(modis_bands_clip.to_array().values[0],
              ax=ax,
              extent=modis_ext,
              title="Plot of the  data  clipped  to the geometry")
fire_bound_sin.plot(ax=ax,
                    color="purple")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_53_0.png">

</figure>




## Which  Approach  To  Use?

you may be wondering which of the  above  scenarios  is  best.
The answer is - it depends. We know  that  using the `crs=`
parameter will likely slow down your processing, however it
requires less code to implement.

For small workflows it could be find to use the approach that 
uses the least amount of code. For other workflows, you 
may want to  reproject your fire boundary first and use 
either `.clip` <a href="https://corteva.github.io/rioxarray/stable/examples/clip_box.html"  target=_blank>(or clip_box)</a> to clip your data.

Hopefully the examples above get your started in the right direction
and you can customize your workflow to your science goals and processing
needs!


## Putting it Together Efficiently

This entire workflow above can be consolidated into an efficient  
function. Below is a function that combines many of the items
discussed above. Note that this function does incorporate the  
`crs=` parameter which *could* slow processing down a bit.

{:.input}
```python
def open_clean_bands(band_path,
                     crop_bound,
                     valid_range=None,
                     variable=None):
    """Open, subset and crop a MODIS h4 file.

    Parameters
    -----------
    band_path : string 
        A path to the array to be opened.
    crop_bound : geopandas GeoDataFrame
        A geopandas dataframe to be used to crop the raster data using rioxarray clip().
    valid_range:tuple (optional)
        A tuple of min and max range of values for the data. Default = None.
    variable : List
        A list of variables to be opened from the raster.

    Returns
    -----------
    band : xarray DataArray
        Cropped xarray DataArray
    """

    crop_bound_box = [box(*crop_bound.total_bounds)]

    try:
        band = rxr.open_rasterio(band_path,
                                 masked=True,
                                 variable=variable).rio.clip(crop_bound_box,
                                                             crs=crop_bound.crs,
                                                             all_touched=True,
                                                             from_disk=True).squeeze()
    except:
        raise ValueError(
            "Oops - I couldn't clip your data. This may be due to a crs error.")

    # Only mask the data to the valid range if a valid range tuple is provided
    if valid_range is not None:
        mask = ((band < valid_range[0]) | (band > valid_range[1]))
        band = band.where(~xr.where(mask, True, False))

    return band
```

{:.input}
```python
# Open bands with function
clean_bands = open_clean_bands(band_path=modis_pre_path,
                               crop_bound=fire_boundary,
                               valid_range=(0, 10000),
                               variable=desired_bands)

# Plot bands opened with function
ep.plot_bands(clean_bands.to_array().values,
              title=desired_bands,
              figsize=(10, 4))

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_56_0.png">

</figure>




## Export MODIS Data as a GeoTIFF

You can quickly export a **.tif**  file using  `rioxarray`. To  
do this you  need a path to the new file that  includes the 
new file name. **Rioxarray** will create a `.tif` file with all the 
correct data and metadata.

{:.input}
```python
# Define path and file name for new tif file
stacked_file_path = os.path.join(os.path.dirname(modis_pre_path),
                                 "final_output",
                                 "modis_band_1.tif")

# Get the directory needed for the defined path
modis_dir_path = os.path.dirname(stacked_file_path)
print("Directory to save path:", modis_dir_path)

# Create the directory if it does not exist
if not os.path.exists(modis_dir_path):
    os.mkdir(modis_dir_path)
    print("The directory", modis_dir_path, "does not exist - creating it now.")
```

{:.output}
    Directory to save path: cold-springs-modis-h4/07_july_2016/final_output
    The directory cold-springs-modis-h4/07_july_2016/final_output does not exist - creating it now.



You can now export or write out a new GeoTIFF file. 

{:.input}
```python
# Here you decide how much of the data you want to export.
# A single layer vs a stacked / array
# Export a single band to a geotiff
clean_bands.rio.to_raster(stacked_file_path)
```

Open and view your stacked GeoTIFF.

{:.input}
```python
# Open the file to make sure it looks ok
modis_b1_xr = rxr.open_rasterio(stacked_file_path,
                                masked=True)

modis_b1_xr.rio.crs, modis_b1_xr.rio.nodata
```

{:.output}
{:.execute_result}



    (CRS.from_wkt('PROJCS["unnamed",GEOGCS["Unknown datum based upon the custom spheroid",DATUM["Not_specified_based_on_custom_spheroid",SPHEROID["Custom spheroid",6371007.181,0]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]]],PROJECTION["Sinusoidal"],PARAMETER["longitude_of_center",0],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["metre",1,AUTHORITY["EPSG","9001"]],AXIS["Easting",EAST],AXIS["Northing",NORTH]]'),
     None)





{:.input}
```python
# Plot the data
ep.plot_bands(modis_b1_xr,
              figsize=(10, 4))

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_63_0.png" alt = "Plot of each MODIS band in the numpy stack cropped to the cold springs fire extent, identical to the last plot showing this same thing.">
<figcaption>Plot of each MODIS band in the numpy stack cropped to the cold springs fire extent, identical to the last plot showing this same thing.</figcaption>

</figure>






