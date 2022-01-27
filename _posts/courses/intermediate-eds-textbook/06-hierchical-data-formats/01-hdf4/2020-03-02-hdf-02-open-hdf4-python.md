---
layout: single
title: "Open and Use MODIS Data in HDF4 format in Open Source Python"
excerpt: "MODIS is remote sensing data that is stored in the HDF4 file format. Learn how to open and use MODIS data in HDF4 form in Open Source Python."
authors: ['Leah Wasser', 'Nathan Korinek', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2022-01-21
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
import earthpy.spatial as es
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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-9aa4f358-6fb4-45e8-b36e-7ce6f658fdf8' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-9aa4f358-6fb4-45e8-b36e-7ce6f658fdf8' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 1200</li><li><span class='xr-has-index'>x</span>: 1200</li><li><span class='xr-has-index'>band</span>: 1</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-531c5838-a6ae-4464-818c-3f7a74954b26' class='xr-section-summary-in' type='checkbox'  checked><label for='section-531c5838-a6ae-4464-818c-3f7a74954b26' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-914c1b74-70e3-4cb0-be7e-6b33b5b40b02' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-914c1b74-70e3-4cb0-be7e-6b33b5b40b02' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1f25203c-6192-4885-968f-078413d78ae0' class='xr-var-data-in' type='checkbox'><label for='data-1f25203c-6192-4885-968f-078413d78ae0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-da649b23-0062-4dde-8efe-1eac74ff3b19' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-da649b23-0062-4dde-8efe-1eac74ff3b19' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5942cce1-611e-4dcc-8b73-3c0606a92d30' class='xr-var-data-in' type='checkbox'><label for='data-5942cce1-611e-4dcc-8b73-3c0606a92d30' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-14691f10-3e05-4518-bc84-dbd8b65e1cd3' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-14691f10-3e05-4518-bc84-dbd8b65e1cd3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3c78f411-5888-4b30-8339-a532802861a7' class='xr-var-data-in' type='checkbox'><label for='data-3c78f411-5888-4b30-8339-a532802861a7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-3f992c9b-f646-406f-8f2b-5b6ff166be21' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3f992c9b-f646-406f-8f2b-5b6ff166be21' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0e57f887-3ec0-4ba3-ae4d-6ad9b5195980' class='xr-var-data-in' type='checkbox'><label for='data-0e57f887-3ec0-4ba3-ae4d-6ad9b5195980' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-469a3482-5898-4102-a475-e2f0c0c2697a' class='xr-section-summary-in' type='checkbox'  checked><label for='section-469a3482-5898-4102-a475-e2f0c0c2697a' class='xr-section-summary' >Data variables: <span>(10)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_1km</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-2da803dd-499c-4ec2-b1be-30b47970fa06' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2da803dd-499c-4ec2-b1be-30b47970fa06' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-82baf3f7-45f6-41f1-a653-d52e7f8c17c4' class='xr-var-data-in' type='checkbox'><label for='data-82baf3f7-45f6-41f1-a653-d52e7f8c17c4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>granule_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-74fc52ef-fcfc-405a-831d-5bc4f2720797' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-74fc52ef-fcfc-405a-831d-5bc4f2720797' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bc06c753-5c94-4a44-8b2b-779e66420e2c' class='xr-var-data-in' type='checkbox'><label for='data-bc06c753-5c94-4a44-8b2b-779e66420e2c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Granule Pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>state_1km_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8bc05d6b-ffb6-4522-9abe-4852164d0586' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8bc05d6b-ffb6-4522-9abe-4852164d0586' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d8b5e77a-37e7-48c8-9b93-e57adb6822e7' class='xr-var-data-in' type='checkbox'><label for='data-d8b5e77a-37e7-48c8-9b93-e57adb6822e7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>1km Reflectance Data State QA - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-73dbc9d7-a5b0-4508-bbf1-68d69a394dc7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-73dbc9d7-a5b0-4508-bbf1-68d69a394dc7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f447135f-f47d-45f0-a119-9e4dc1a90cee' class='xr-var-data-in' type='checkbox'><label for='data-f447135f-f47d-45f0-a119-9e4dc1a90cee' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-33f3eb8e-ede6-4033-b902-8f50f8bc3abb' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-33f3eb8e-ede6-4033-b902-8f50f8bc3abb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-55af1e0d-11f1-4441-b731-1a327d48bf02' class='xr-var-data-in' type='checkbox'><label for='data-55af1e0d-11f1-4441-b731-1a327d48bf02' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>Range_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-5d13df52-2fad-42b8-914f-3c3176b86fcb' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5d13df52-2fad-42b8-914f-3c3176b86fcb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d1042d67-b803-460f-9ab6-2c66e6125e9e' class='xr-var-data-in' type='checkbox'><label for='data-d1042d67-b803-460f-9ab6-2c66e6125e9e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>25.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Range (pixel to sensor) - first layer</dd><dt><span>units :</span></dt><dd>meters</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-200fe0e4-73f8-4944-b92e-09c219a2f80b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-200fe0e4-73f8-4944-b92e-09c219a2f80b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-99005fe8-5943-4e5c-9dd3-078bda1ab7af' class='xr-var-data-in' type='checkbox'><label for='data-99005fe8-5943-4e5c-9dd3-078bda1ab7af' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-72bcb9fc-bc7a-4aa7-b743-80633964f95c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-72bcb9fc-bc7a-4aa7-b743-80633964f95c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-200d1d18-536d-4281-8ab9-37df5701723c' class='xr-var-data-in' type='checkbox'><label for='data-200d1d18-536d-4281-8ab9-37df5701723c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>gflags_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-aeec7d83-8512-40b2-ae9c-32a0932bddad' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aeec7d83-8512-40b2-ae9c-32a0932bddad' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-70af559c-b47a-499d-8709-485686845236' class='xr-var-data-in' type='checkbox'><label for='data-70af559c-b47a-499d-8709-485686845236' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Geolocation flags - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>orbit_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-067e4f6f-8957-45a3-9d14-9cc6f15091ef' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-067e4f6f-8957-45a3-9d14-9cc6f15091ef' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d0930b90-ba79-44d6-a3dd-9a80a8cc39c7' class='xr-var-data-in' type='checkbox'><label for='data-d0930b90-ba79-44d6-a3dd-9a80a8cc39c7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Orbit pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-7f4230e6-8cee-4275-aa3d-9c9ba75a6188' class='xr-section-summary-in' type='checkbox'  ><label for='section-7f4230e6-8cee-4275-aa3d-9c9ba75a6188' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    units:         none</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'num_observations_1km'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>y</span>: 1200</li><li><span class='xr-has-index'>x</span>: 1200</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-9033d5ba-2397-46ca-9582-65a72f747722' class='xr-array-in' type='checkbox' checked><label for='section-9033d5ba-2397-46ca-9582-65a72f747722' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[1440000 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-483fa215-0fbd-495c-85f2-85c24df7a6d3' class='xr-section-summary-in' type='checkbox'  checked><label for='section-483fa215-0fbd-495c-85f2-85c24df7a6d3' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-a44deb4c-2abd-4339-b082-ad0d5669714d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a44deb4c-2abd-4339-b082-ad0d5669714d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fb741e9b-3ca9-404e-8520-139d68ca6e85' class='xr-var-data-in' type='checkbox'><label for='data-fb741e9b-3ca9-404e-8520-139d68ca6e85' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-146851d0-49c7-4508-a38a-e6ef578a769a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-146851d0-49c7-4508-a38a-e6ef578a769a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c62eb53f-03e9-44b1-904e-6f74363174ff' class='xr-var-data-in' type='checkbox'><label for='data-c62eb53f-03e9-44b1-904e-6f74363174ff' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-358bfee7-9cd7-4a8e-b85a-934b9d08ff7a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-358bfee7-9cd7-4a8e-b85a-934b9d08ff7a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ba66a470-ff6b-49a4-81b6-741b3156a060' class='xr-var-data-in' type='checkbox'><label for='data-ba66a470-ff6b-49a4-81b6-741b3156a060' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-1c556f3f-25e3-427a-a54c-16a6c2e4ce2c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1c556f3f-25e3-427a-a54c-16a6c2e4ce2c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d559dd37-b34c-4d55-8e82-25c953380e4c' class='xr-var-data-in' type='checkbox'><label for='data-d559dd37-b34c-4d55-8e82-25c953380e4c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-50cf6726-8d54-4a6b-8e18-466018cd831c' class='xr-section-summary-in' type='checkbox'  checked><label for='section-50cf6726-8d54-4a6b-8e18-466018cd831c' class='xr-section-summary' >Attributes: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-9acb1459-4094-4aa4-b13f-8ea9a8410ea5' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-9acb1459-4094-4aa4-b13f-8ea9a8410ea5' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li><li><span class='xr-has-index'>band</span>: 1</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-54ac2cf1-9c43-4422-82eb-a43272f29f8e' class='xr-section-summary-in' type='checkbox'  checked><label for='section-54ac2cf1-9c43-4422-82eb-a43272f29f8e' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-b92158ec-9a82-44cd-9c28-018c8b67d993' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-b92158ec-9a82-44cd-9c28-018c8b67d993' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-dd7080b6-d121-43f1-b153-dd9d087794d3' class='xr-var-data-in' type='checkbox'><label for='data-dd7080b6-d121-43f1-b153-dd9d087794d3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-a0f52782-10a1-4fef-9ccb-a1ea749bcebb' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a0f52782-10a1-4fef-9ccb-a1ea749bcebb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-38b08bca-0e40-4ab8-93f4-d8ff81b0b6c1' class='xr-var-data-in' type='checkbox'><label for='data-38b08bca-0e40-4ab8-93f4-d8ff81b0b6c1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-e7ce03ac-3bf0-43a8-96c2-3d3901abe47b' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e7ce03ac-3bf0-43a8-96c2-3d3901abe47b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0dbeff69-262e-4ce6-a3cd-4f76defaacba' class='xr-var-data-in' type='checkbox'><label for='data-0dbeff69-262e-4ce6-a3cd-4f76defaacba' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-cdc89f73-c2e2-4776-a051-1f9e9e616849' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-cdc89f73-c2e2-4776-a051-1f9e9e616849' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-27f3099b-f871-4187-aa86-6af1f24553c9' class='xr-var-data-in' type='checkbox'><label for='data-27f3099b-f871-4187-aa86-6af1f24553c9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-00338be0-dbaf-47fb-ac8c-142eb5ce598b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-00338be0-dbaf-47fb-ac8c-142eb5ce598b' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-96253ab2-2e06-4ead-88f4-b70f340b5905' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-96253ab2-2e06-4ead-88f4-b70f340b5905' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f6665e29-174d-491b-9e5b-64b1581bc61e' class='xr-var-data-in' type='checkbox'><label for='data-f6665e29-174d-491b-9e5b-64b1581bc61e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-84320111-c8d6-42b5-a8eb-cba364ce55f9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-84320111-c8d6-42b5-a8eb-cba364ce55f9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fedeebd3-4892-476d-95dd-0585dcb2b6f0' class='xr-var-data-in' type='checkbox'><label for='data-fedeebd3-4892-476d-95dd-0585dcb2b6f0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d9764849-b61d-4d05-824d-175b2b40f840' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d9764849-b61d-4d05-824d-175b2b40f840' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-889ef522-3026-4f63-8cd4-0c9987658e5d' class='xr-var-data-in' type='checkbox'><label for='data-889ef522-3026-4f63-8cd4-0c9987658e5d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-c98309e7-6190-4258-82f5-eeed40d5d5fd' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c98309e7-6190-4258-82f5-eeed40d5d5fd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-33fea8d1-e805-4cdf-962c-d72e3287e0a3' class='xr-var-data-in' type='checkbox'><label for='data-33fea8d1-e805-4cdf-962c-d72e3287e0a3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d2915155-f82b-4a20-b160-1d9ceed796bc' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d2915155-f82b-4a20-b160-1d9ceed796bc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-44932212-104f-4978-953a-094f1c454638' class='xr-var-data-in' type='checkbox'><label for='data-44932212-104f-4978-953a-094f1c454638' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-72a820a3-183c-4205-93a1-69e036ce0a0b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-72a820a3-183c-4205-93a1-69e036ce0a0b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-48b1dc58-d77f-4e83-b8c0-1a69f4832a78' class='xr-var-data-in' type='checkbox'><label for='data-48b1dc58-d77f-4e83-b8c0-1a69f4832a78' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4c99ca28-9a37-4cda-8ade-ca61021e7f34' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4c99ca28-9a37-4cda-8ade-ca61021e7f34' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0737198b-1696-4aed-a970-43e2f7e96f3c' class='xr-var-data-in' type='checkbox'><label for='data-0737198b-1696-4aed-a970-43e2f7e96f3c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-420cb394-7d32-4bcb-b933-213d8562c312' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-420cb394-7d32-4bcb-b933-213d8562c312' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3775d3be-19ca-4112-ada8-387e4f1303fd' class='xr-var-data-in' type='checkbox'><label for='data-3775d3be-19ca-4112-ada8-387e4f1303fd' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9af31b7d-6219-4135-b1cc-a810aaadf262' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9af31b7d-6219-4135-b1cc-a810aaadf262' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-83f61029-93a8-4309-a2ce-a7255ba26980' class='xr-var-data-in' type='checkbox'><label for='data-83f61029-93a8-4309-a2ce-a7255ba26980' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-b04a767e-4663-43a9-842c-4def76ea04db' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b04a767e-4663-43a9-842c-4def76ea04db' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-37dfe305-d79c-4464-b5a0-041e4338e9f3' class='xr-var-data-in' type='checkbox'><label for='data-37dfe305-d79c-4464-b5a0-041e4338e9f3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-7ab1cdb0-290c-43b9-966c-32e34f58097d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7ab1cdb0-290c-43b9-966c-32e34f58097d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-823db1da-1f53-4a57-be30-5e3dfa12e099' class='xr-var-data-in' type='checkbox'><label for='data-823db1da-1f53-4a57-be30-5e3dfa12e099' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3608a75b-ba23-4451-9154-5686ff3784be' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3608a75b-ba23-4451-9154-5686ff3784be' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-211ed648-bc96-4d98-8910-5d96fb6dc0e2' class='xr-var-data-in' type='checkbox'><label for='data-211ed648-bc96-4d98-8910-5d96fb6dc0e2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-cb441c4a-803c-4348-a8f3-58e8c6cc63ad' class='xr-section-summary-in' type='checkbox'  ><label for='section-cb441c4a-803c-4348-a8f3-58e8c6cc63ad' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-83c1ada2-86bb-4de5-a87b-e4756dccfb63' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-83c1ada2-86bb-4de5-a87b-e4756dccfb63' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-52e3b4ba-3f6e-40fa-8189-3f877e57d5a6' class='xr-section-summary-in' type='checkbox'  checked><label for='section-52e3b4ba-3f6e-40fa-8189-3f877e57d5a6' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-31af9810-1738-459c-8a31-82196b0e771f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-31af9810-1738-459c-8a31-82196b0e771f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6fbf6efa-5042-41c7-8409-e86b39218562' class='xr-var-data-in' type='checkbox'><label for='data-6fbf6efa-5042-41c7-8409-e86b39218562' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-05c6d4c6-4198-4fa0-a03b-301c74fc8f5e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-05c6d4c6-4198-4fa0-a03b-301c74fc8f5e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-187c1154-e09a-4d68-b8fb-cca5e308f1ae' class='xr-var-data-in' type='checkbox'><label for='data-187c1154-e09a-4d68-b8fb-cca5e308f1ae' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-5063a4d9-0906-43ce-974c-34dd1df92b10' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5063a4d9-0906-43ce-974c-34dd1df92b10' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-47b13bd3-cad8-40e7-bf12-416bf14bfc66' class='xr-var-data-in' type='checkbox'><label for='data-47b13bd3-cad8-40e7-bf12-416bf14bfc66' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-6b2b5c51-4d15-43de-ac6f-877f576b99bf' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6b2b5c51-4d15-43de-ac6f-877f576b99bf' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f820ed84-bcbf-4fc9-8d26-c5e7e1a1c08b' class='xr-var-data-in' type='checkbox'><label for='data-f820ed84-bcbf-4fc9-8d26-c5e7e1a1c08b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-de3ede98-2349-4bef-9cda-4926e021340f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-de3ede98-2349-4bef-9cda-4926e021340f' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-171845f7-07bd-496f-810e-708efc5faf6d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-171845f7-07bd-496f-810e-708efc5faf6d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6a5f8795-f946-412b-901d-4b6825be87ad' class='xr-var-data-in' type='checkbox'><label for='data-6a5f8795-f946-412b-901d-4b6825be87ad' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-83ba1e9b-b739-47b3-ae75-235a5350a70f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-83ba1e9b-b739-47b3-ae75-235a5350a70f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a0323df5-4f6b-4eb4-9500-2833914a39ab' class='xr-var-data-in' type='checkbox'><label for='data-a0323df5-4f6b-4eb4-9500-2833914a39ab' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-e99f6764-c767-4d38-b691-188ad8cee649' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e99f6764-c767-4d38-b691-188ad8cee649' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-aaf7a5d0-bcdd-42b3-a939-ad4040fb8334' class='xr-var-data-in' type='checkbox'><label for='data-aaf7a5d0-bcdd-42b3-a939-ad4040fb8334' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-991306fa-8e94-4a24-b98f-2e25e1f76977' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-991306fa-8e94-4a24-b98f-2e25e1f76977' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-193c43bd-364b-46b5-811d-813cbd7e4410' class='xr-var-data-in' type='checkbox'><label for='data-193c43bd-364b-46b5-811d-813cbd7e4410' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-876459d7-5790-4c67-9497-d884ad4f349f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-876459d7-5790-4c67-9497-d884ad4f349f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-edd08e43-50a3-4121-9b67-3fdfbb7d50c6' class='xr-var-data-in' type='checkbox'><label for='data-edd08e43-50a3-4121-9b67-3fdfbb7d50c6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-30346196-c4ba-400e-b9d0-90b7cff746ba' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-30346196-c4ba-400e-b9d0-90b7cff746ba' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b661a22d-0033-43f3-84c6-89935885b30f' class='xr-var-data-in' type='checkbox'><label for='data-b661a22d-0033-43f3-84c6-89935885b30f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-45fbe978-2995-4ba5-a346-c605a14ce230' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-45fbe978-2995-4ba5-a346-c605a14ce230' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b9ddf67d-7490-49fa-92d0-de19c5d8f266' class='xr-var-data-in' type='checkbox'><label for='data-b9ddf67d-7490-49fa-92d0-de19c5d8f266' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d6d8d13d-a859-483d-99ba-62483373ef54' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d6d8d13d-a859-483d-99ba-62483373ef54' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4e9d03bb-9530-4f5b-8148-2c1ce7f18d42' class='xr-var-data-in' type='checkbox'><label for='data-4e9d03bb-9530-4f5b-8148-2c1ce7f18d42' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d8425428-5c06-4df7-8807-92089cc6acc7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d8425428-5c06-4df7-8807-92089cc6acc7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4d55f885-6e47-4580-a0a9-88eebcc36256' class='xr-var-data-in' type='checkbox'><label for='data-4d55f885-6e47-4580-a0a9-88eebcc36256' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-5f6f3587-47c9-4b82-a3cc-fb344a1220dd' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5f6f3587-47c9-4b82-a3cc-fb344a1220dd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ad991a79-b0ae-4340-b348-82db686e8771' class='xr-var-data-in' type='checkbox'><label for='data-ad991a79-b0ae-4340-b348-82db686e8771' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-495c0cba-65ee-4537-bdd5-e14ff811fb98' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-495c0cba-65ee-4537-bdd5-e14ff811fb98' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b8eabd38-506b-4e61-874b-7de1a382112e' class='xr-var-data-in' type='checkbox'><label for='data-b8eabd38-506b-4e61-874b-7de1a382112e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-01ca10c7-4db8-4f85-a944-c9e62e59d1da' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-01ca10c7-4db8-4f85-a944-c9e62e59d1da' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-19bfdf80-65ad-4f42-a06a-86cf8eb37afb' class='xr-var-data-in' type='checkbox'><label for='data-19bfdf80-65ad-4f42-a06a-86cf8eb37afb' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-936af314-0b8f-422a-b9cd-1c77fcabb60c' class='xr-section-summary-in' type='checkbox'  ><label for='section-936af314-0b8f-422a-b9cd-1c77fcabb60c' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-be1d66f4-d7f3-4ebc-889c-00a8b0471f11' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-be1d66f4-d7f3-4ebc-889c-00a8b0471f11' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-9d5511a3-633a-425b-810a-072ed4bf2213' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9d5511a3-633a-425b-810a-072ed4bf2213' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-9c5e0ed0-fdea-475f-a04f-65f08597af89' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-9c5e0ed0-fdea-475f-a04f-65f08597af89' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cdfd3642-bbbe-4768-92d4-00f5dbbafee6' class='xr-var-data-in' type='checkbox'><label for='data-cdfd3642-bbbe-4768-92d4-00f5dbbafee6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-6a92ec74-2356-4b6a-bbb3-02607709a74e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6a92ec74-2356-4b6a-bbb3-02607709a74e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cf739df3-3d80-4a9e-8302-6f891776346b' class='xr-var-data-in' type='checkbox'><label for='data-cf739df3-3d80-4a9e-8302-6f891776346b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-fa82d0fc-6dd9-42f2-afcb-f15976248ac7' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-fa82d0fc-6dd9-42f2-afcb-f15976248ac7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-017f76df-8cd2-40fb-8347-6a20a9418902' class='xr-var-data-in' type='checkbox'><label for='data-017f76df-8cd2-40fb-8347-6a20a9418902' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-d260b5a9-869c-4c57-a650-827b49870c35' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d260b5a9-869c-4c57-a650-827b49870c35' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4eb5a026-1b6c-4356-a776-9931be9662a2' class='xr-var-data-in' type='checkbox'><label for='data-4eb5a026-1b6c-4356-a776-9931be9662a2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-e6227f54-e00a-4109-85dc-5078922e956b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-e6227f54-e00a-4109-85dc-5078922e956b' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-2f55aa96-5fa6-4d04-9adb-85c53116d8e8' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2f55aa96-5fa6-4d04-9adb-85c53116d8e8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a51e8229-89c8-4fd5-a371-279c29631f18' class='xr-var-data-in' type='checkbox'><label for='data-a51e8229-89c8-4fd5-a371-279c29631f18' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-225e7fea-2533-478c-905a-a47e877818e2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-225e7fea-2533-478c-905a-a47e877818e2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7f733ee2-20ea-40dd-8722-fdabc856a895' class='xr-var-data-in' type='checkbox'><label for='data-7f733ee2-20ea-40dd-8722-fdabc856a895' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8713ac4a-3098-4cca-8ecb-6c393a4d0b9d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8713ac4a-3098-4cca-8ecb-6c393a4d0b9d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c9e13874-632a-4ed8-af58-f06228f4d957' class='xr-var-data-in' type='checkbox'><label for='data-c9e13874-632a-4ed8-af58-f06228f4d957' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-94d1998a-2ab6-4d85-a7e1-bedad2c2ef39' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-94d1998a-2ab6-4d85-a7e1-bedad2c2ef39' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-253db88e-2ef0-4c0b-87ea-5c4903b273d0' class='xr-var-data-in' type='checkbox'><label for='data-253db88e-2ef0-4c0b-87ea-5c4903b273d0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-952c7e1c-6c8c-47f6-a696-75969848428f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-952c7e1c-6c8c-47f6-a696-75969848428f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6ebc57b8-8faa-4ef2-98c1-0140aa7b0d17' class='xr-var-data-in' type='checkbox'><label for='data-6ebc57b8-8faa-4ef2-98c1-0140aa7b0d17' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-1c3cc4d7-637d-436f-856a-bfef5b34bd0c' class='xr-section-summary-in' type='checkbox'  ><label for='section-1c3cc4d7-637d-436f-856a-bfef5b34bd0c' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-39e73c9a-13d9-40e1-bc29-46adc6a4ef46' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-39e73c9a-13d9-40e1-bc29-46adc6a4ef46' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-09d715d2-b521-4661-a2e0-fc1761c472f2' class='xr-section-summary-in' type='checkbox'  checked><label for='section-09d715d2-b521-4661-a2e0-fc1761c472f2' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-cbbd6a50-07e5-48d3-8f1c-2f65ff44e467' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-cbbd6a50-07e5-48d3-8f1c-2f65ff44e467' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c6ebf1a7-1dc5-4aa5-8a92-770c0981b376' class='xr-var-data-in' type='checkbox'><label for='data-c6ebf1a7-1dc5-4aa5-8a92-770c0981b376' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-2d7f8bb6-7066-4c01-beba-8e168cb59146' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2d7f8bb6-7066-4c01-beba-8e168cb59146' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b8237e10-dac6-4a58-879d-d4913b32908d' class='xr-var-data-in' type='checkbox'><label for='data-b8237e10-dac6-4a58-879d-d4913b32908d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-89e1f525-ade3-4405-bfe7-1f94d2653387' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-89e1f525-ade3-4405-bfe7-1f94d2653387' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-05187681-e3b7-4173-967d-1372bae32f44' class='xr-var-data-in' type='checkbox'><label for='data-05187681-e3b7-4173-967d-1372bae32f44' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-be548fcc-3a4a-4022-a236-e1b30941142c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-be548fcc-3a4a-4022-a236-e1b30941142c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-50c23711-042b-418a-800f-e2f4e07ec3be' class='xr-var-data-in' type='checkbox'><label for='data-50c23711-042b-418a-800f-e2f4e07ec3be' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-8ab943c6-6e09-4db8-91ea-ddcce28b5082' class='xr-section-summary-in' type='checkbox'  checked><label for='section-8ab943c6-6e09-4db8-91ea-ddcce28b5082' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-51dcec5c-ba7f-440e-9c24-3aef22c0e6aa' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-51dcec5c-ba7f-440e-9c24-3aef22c0e6aa' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fc05b832-2278-419d-9d80-156d0f178373' class='xr-var-data-in' type='checkbox'><label for='data-fc05b832-2278-419d-9d80-156d0f178373' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d18ef3f2-d141-4bc4-ad6c-795a9acc9720' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d18ef3f2-d141-4bc4-ad6c-795a9acc9720' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-af49f690-d9ea-46c4-a371-c38d45edf607' class='xr-var-data-in' type='checkbox'><label for='data-af49f690-d9ea-46c4-a371-c38d45edf607' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-ded79405-dd06-4d17-b261-a684271775dc' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ded79405-dd06-4d17-b261-a684271775dc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2a3ad14c-316a-41b0-a613-157c36bd8d4f' class='xr-var-data-in' type='checkbox'><label for='data-2a3ad14c-316a-41b0-a613-157c36bd8d4f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8fd00b6b-0d27-432f-8326-db0c2bca150e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8fd00b6b-0d27-432f-8326-db0c2bca150e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e735aae5-8c2d-4918-a981-662fbbb65cf0' class='xr-var-data-in' type='checkbox'><label for='data-e735aae5-8c2d-4918-a981-662fbbb65cf0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-ca3af468-acc4-4b70-98c5-fdf13b170b02' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ca3af468-acc4-4b70-98c5-fdf13b170b02' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4ee07104-c256-4780-8a60-1b014d99b059' class='xr-var-data-in' type='checkbox'><label for='data-4ee07104-c256-4780-8a60-1b014d99b059' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-6e661b87-aa09-46c8-9528-3f75ce9ced78' class='xr-section-summary-in' type='checkbox'  ><label for='section-6e661b87-aa09-46c8-9528-3f75ce9ced78' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>variable</span>: 5</li><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-84c79aa1-175f-449d-a93c-40ff50e3a2f6' class='xr-array-in' type='checkbox' checked><label for='section-84c79aa1-175f-449d-a93c-40ff50e3a2f6' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>1.902e+03 1.949e+03 1.947e+03 2.095e+03 ... 1.161e+03 913.0 703.0</span></div><div class='xr-array-data'><pre>array([[[1902., 1949., 1947., ..., 1327., 1327., 1181.],
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
        [2296., 2296., 2511., ..., 1161.,  913.,  703.]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-e5cc94fe-6891-4f73-bf78-e0d872026ed8' class='xr-section-summary-in' type='checkbox'  checked><label for='section-e5cc94fe-6891-4f73-bf78-e0d872026ed8' class='xr-section-summary' >Coordinates: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-7b47f8cd-7893-4393-bcfc-ca3c13252524' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-7b47f8cd-7893-4393-bcfc-ca3c13252524' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5d48adf0-dd54-4961-81c7-493457ad2061' class='xr-var-data-in' type='checkbox'><label for='data-5d48adf0-dd54-4961-81c7-493457ad2061' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-6dcdcff2-e284-4268-abff-0bfc4b74a5dc' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6dcdcff2-e284-4268-abff-0bfc4b74a5dc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3c2c3168-ac18-405f-b0fd-7fcb6d4e12fb' class='xr-var-data-in' type='checkbox'><label for='data-3c2c3168-ac18-405f-b0fd-7fcb6d4e12fb' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-69dd8349-f7b7-43d7-b75b-d39ddaad6b1e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-69dd8349-f7b7-43d7-b75b-d39ddaad6b1e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f87e49f7-cb53-40ff-9b7f-4b98804ba416' class='xr-var-data-in' type='checkbox'><label for='data-f87e49f7-cb53-40ff-9b7f-4b98804ba416' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-368ae58e-7cd5-4a25-a79d-61a974710e6b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-368ae58e-7cd5-4a25-a79d-61a974710e6b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6d3d9bc9-5f86-475c-82e8-cf2aae477337' class='xr-var-data-in' type='checkbox'><label for='data-6d3d9bc9-5f86-475c-82e8-cf2aae477337' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>variable</span></div><div class='xr-var-dims'>(variable)</div><div class='xr-var-dtype'>&lt;U14</div><div class='xr-var-preview xr-preview'>&#x27;sur_refl_b01_1&#x27; ... &#x27;sur_refl_b...</div><input id='attrs-5a7f60aa-8274-426b-a6ae-625f48abc253' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5a7f60aa-8274-426b-a6ae-625f48abc253' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7a335c49-5385-46e6-bad3-887ec923ab68' class='xr-var-data-in' type='checkbox'><label for='data-7a335c49-5385-46e6-bad3-887ec923ab68' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;sur_refl_b01_1&#x27;, &#x27;sur_refl_b02_1&#x27;, &#x27;sur_refl_b03_1&#x27;, &#x27;sur_refl_b04_1&#x27;,
       &#x27;sur_refl_b07_1&#x27;], dtype=&#x27;&lt;U14&#x27;)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-a3e652a5-6595-4996-a8fe-e16ac2bcb03d' class='xr-section-summary-in' type='checkbox'  ><label for='section-a3e652a5-6595-4996-a8fe-e16ac2bcb03d' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>variable</span>: 3</li><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-c4dfa1fe-a3c1-4b6b-a0e2-cc6bd140812f' class='xr-array-in' type='checkbox' checked><label for='section-c4dfa1fe-a3c1-4b6b-a0e2-cc6bd140812f' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>1.902e+03 1.949e+03 1.947e+03 2.095e+03 ... 1.089e+03 759.0 516.0</span></div><div class='xr-array-data'><pre>array([[[1902., 1949., 1947., ..., 1327., 1327., 1181.],
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
        [1154., 1154., 1231., ..., 1089.,  759.,  516.]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-3aa93b3c-7292-4979-844d-08e2adb480b9' class='xr-section-summary-in' type='checkbox'  checked><label for='section-3aa93b3c-7292-4979-844d-08e2adb480b9' class='xr-section-summary' >Coordinates: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-fe6c1ce1-51c1-496f-8b9d-fdbc9515c3d4' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-fe6c1ce1-51c1-496f-8b9d-fdbc9515c3d4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-837d66b4-fc4f-41fd-af80-214a490599e3' class='xr-var-data-in' type='checkbox'><label for='data-837d66b4-fc4f-41fd-af80-214a490599e3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-5cd85f05-2392-41fa-8a2f-6b658d8a50fd' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5cd85f05-2392-41fa-8a2f-6b658d8a50fd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1ae3d48c-e936-4720-ba78-90035f6ef749' class='xr-var-data-in' type='checkbox'><label for='data-1ae3d48c-e936-4720-ba78-90035f6ef749' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-5eae20f2-d844-47b7-8b74-e4283eb68520' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5eae20f2-d844-47b7-8b74-e4283eb68520' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e7dd99dc-a045-445c-8b04-c06bd02461fe' class='xr-var-data-in' type='checkbox'><label for='data-e7dd99dc-a045-445c-8b04-c06bd02461fe' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-0f02300f-4f1e-4be1-b5df-5f2030473044' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0f02300f-4f1e-4be1-b5df-5f2030473044' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f8f0a8f0-a89e-4516-a5cb-a3835e558a97' class='xr-var-data-in' type='checkbox'><label for='data-f8f0a8f0-a89e-4516-a5cb-a3835e558a97' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>variable</span></div><div class='xr-var-dims'>(variable)</div><div class='xr-var-dtype'>&lt;U14</div><div class='xr-var-preview xr-preview'>&#x27;sur_refl_b01_1&#x27; ... &#x27;sur_refl_b...</div><input id='attrs-f3724f6f-1146-4ce4-9a35-e1f7f6db3826' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-f3724f6f-1146-4ce4-9a35-e1f7f6db3826' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-af2b9e1f-f239-4ef0-9bcc-c01ac6260c31' class='xr-var-data-in' type='checkbox'><label for='data-af2b9e1f-f239-4ef0-9bcc-c01ac6260c31' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;sur_refl_b01_1&#x27;, &#x27;sur_refl_b03_1&#x27;, &#x27;sur_refl_b04_1&#x27;], dtype=&#x27;&lt;U14&#x27;)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-86e8a9c0-8f29-496f-a360-a1c7f8171e14' class='xr-section-summary-in' type='checkbox'  ><label for='section-86e8a9c0-8f29-496f-a360-a1c7f8171e14' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





{:.input}
```python
# Plot MODIS RGB numpy image array
ep.plot_rgb(modis_rgb_xr.values,
            rgb=[0, 2, 1],
            title='RGB Image of MODIS Data')

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_32_0.png">

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



![svg]({{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_38_0.svg)





{:.input}
```python
# Notice that this is the actual shape of the fire boundary
# First you need to decide whether you want to clip to the
# Box /  extent (above) or the shape that you see here.
fire_boundary.geometry[0]
```

{:.output}
{:.execute_result}



![svg]({{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_39_0.svg)





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-a54732f9-22a1-4576-8c88-1e6adf3ec42c' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-a54732f9-22a1-4576-8c88-1e6adf3ec42c' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 12</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-6e3ec199-852d-4d30-85fa-0f3d77049a92' class='xr-section-summary-in' type='checkbox'  checked><label for='section-6e3ec199-852d-4d30-85fa-0f3d77049a92' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-1ea33c82-abde-4f63-b501-25cccb7e2de2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1ea33c82-abde-4f63-b501-25cccb7e2de2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3585c083-6c17-498b-a1bd-42a8319590be' class='xr-var-data-in' type='checkbox'><label for='data-3585c083-6c17-498b-a1bd-42a8319590be' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.989e+06 ... -8.984e+06</div><input id='attrs-f9b01475-e510-42f3-8a94-ac0429510fae' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f9b01475-e510-42f3-8a94-ac0429510fae' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e2e708df-c3a1-4ed4-aef2-5fd5b89dcc36' class='xr-var-data-in' type='checkbox'><label for='data-e2e708df-c3a1-4ed4-aef2-5fd5b89dcc36' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8989424.98243 , -8988961.669713, -8988498.356997, -8988035.04428 ,
       -8987571.731564, -8987108.418847, -8986645.106131, -8986181.793414,
       -8985718.480698, -8985255.167981, -8984791.855265, -8984328.542548])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-e60ce6c2-9361-4bc5-8ecd-4a192aa33a40' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e60ce6c2-9361-4bc5-8ecd-4a192aa33a40' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b79f38ca-075f-46de-a1af-a307130bddb3' class='xr-var-data-in' type='checkbox'><label for='data-b79f38ca-075f-46de-a1af-a307130bddb3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-290a5354-a1a8-4d3e-a3ac-7c5e45f9bf8a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-290a5354-a1a8-4d3e-a3ac-7c5e45f9bf8a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0931fb3a-2bd3-4175-bc12-044319d058e7' class='xr-var-data-in' type='checkbox'><label for='data-0931fb3a-2bd3-4175-bc12-044319d058e7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8989656.638788167 463.3127165279266 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-71d88a14-cc46-4a9b-94ac-898914e4f8e8' class='xr-section-summary-in' type='checkbox'  checked><label for='section-71d88a14-cc46-4a9b-94ac-898914e4f8e8' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 428.0 450.0 ... nan nan nan</div><input id='attrs-3ab17cbe-6018-4b3d-9248-3385ffd9479d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3ab17cbe-6018-4b3d-9248-3385ffd9479d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2831b587-5295-4b44-b6f2-411d9095c27a' class='xr-var-data-in' type='checkbox'><label for='data-2831b587-5295-4b44-b6f2-411d9095c27a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 428., 450., 450., 438., 438., 421., 421., 409., 409.,
        483.],
       [ nan, 402., 402., 402., 402., 442., 442., 442., 442., 458., 458.,
         nan],
       [402., 402., 402., 402., 442., 442., 442., 442., 458.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 3.013e+03 ... nan nan nan</div><input id='attrs-9511e205-c49b-4a18-86b6-adf758598f1d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9511e205-c49b-4a18-86b6-adf758598f1d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5c7844db-0347-4578-ab6a-1b55bd440804' class='xr-var-data-in' type='checkbox'><label for='data-5c7844db-0347-4578-ab6a-1b55bd440804' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[  nan,   nan, 3013., 2809., 2809., 2730., 2730., 2628., 2628.,
        2641., 2641., 2576.],
       [  nan, 2565., 2565., 2565., 2565., 2522., 2522., 2522., 2522.,
        2496., 2496.,   nan],
       [2565., 2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.,
          nan,   nan,   nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 259.0 235.0 ... nan nan nan</div><input id='attrs-92444efd-4158-4df8-9cdb-b55bac50f68e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-92444efd-4158-4df8-9cdb-b55bac50f68e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e93656ad-b83c-4d87-b770-2a555cd568b7' class='xr-var-data-in' type='checkbox'><label for='data-e93656ad-b83c-4d87-b770-2a555cd568b7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 259., 235., 235., 231., 231., 211., 211., 203., 203.,
        245.],
       [ nan, 217., 217., 217., 217., 230., 230., 230., 230., 265., 265.,
         nan],
       [217., 217., 217., 217., 230., 230., 230., 230., 265.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 563.0 541.0 ... nan nan nan</div><input id='attrs-46a58ec2-c384-4297-84d2-c0d787e15632' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-46a58ec2-c384-4297-84d2-c0d787e15632' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-873da2bd-9736-4c20-91f3-f37dc56d73df' class='xr-var-data-in' type='checkbox'><label for='data-873da2bd-9736-4c20-91f3-f37dc56d73df' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 563., 541., 541., 528., 528., 494., 494., 486., 486.,
        530.],
       [ nan, 476., 476., 476., 476., 476., 476., 476., 476., 518., 518.,
         nan],
       [476., 476., 476., 476., 476., 476., 476., 476., 518.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 832.0 820.0 ... nan nan nan</div><input id='attrs-aec887dd-1b5f-4b98-a576-6a6a7246d942' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aec887dd-1b5f-4b98-a576-6a6a7246d942' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-eb42a01f-3208-4385-9c3c-d7a44e658ce2' class='xr-var-data-in' type='checkbox'><label for='data-eb42a01f-3208-4385-9c3c-d7a44e658ce2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 832., 820., 820., 820., 820., 749., 749., 715., 715.,
        820.],
       [ nan, 715., 715., 715., 715., 789., 789., 789., 789., 804., 804.,
         nan],
       [715., 715., 715., 715., 789., 789., 789., 789., 804.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-ef66fcb0-9253-4b26-a732-eafed56ccd09' class='xr-section-summary-in' type='checkbox'  ><label for='section-ef66fcb0-9253-4b26-a732-eafed56ccd09' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_43_0.png">

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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-12c5861b-5b3f-445a-9326-fc6066e1a764' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-12c5861b-5b3f-445a-9326-fc6066e1a764' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 8</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-20883ff0-9949-4121-9325-0e28b4c13e99' class='xr-section-summary-in' type='checkbox'  checked><label for='section-20883ff0-9949-4121-9325-0e28b4c13e99' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-57db9ef0-803a-4980-9d37-62c6dcb6f860' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-57db9ef0-803a-4980-9d37-62c6dcb6f860' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-860417c8-b197-451c-8526-fb14a7d06135' class='xr-var-data-in' type='checkbox'><label for='data-860417c8-b197-451c-8526-fb14a7d06135' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.988e+06 ... -8.985e+06</div><input id='attrs-50854688-87a9-43b7-9c95-e2d36f6574a4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-50854688-87a9-43b7-9c95-e2d36f6574a4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-37a73c5a-d2f2-4c32-84c9-e4db19a59e74' class='xr-var-data-in' type='checkbox'><label for='data-37a73c5a-d2f2-4c32-84c9-e4db19a59e74' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8988498.356997, -8988035.04428 , -8987571.731564, -8987108.418847,
       -8986645.106131, -8986181.793414, -8985718.480698, -8985255.167981])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-fa41d33d-e1e9-4816-8f1a-52ea8ba799fc' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-fa41d33d-e1e9-4816-8f1a-52ea8ba799fc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d8c30852-7b89-42a7-8265-533e09f85447' class='xr-var-data-in' type='checkbox'><label for='data-d8c30852-7b89-42a7-8265-533e09f85447' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-459eef8f-e9e6-4235-949f-12f4262a86ad' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-459eef8f-e9e6-4235-949f-12f4262a86ad' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8f77cb61-13f9-4fa8-bb28-79a3f45e6f3a' class='xr-var-data-in' type='checkbox'><label for='data-8f77cb61-13f9-4fa8-bb28-79a3f45e6f3a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8988730.01335511 463.3127165277089 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-97f077ff-0f54-46e4-a10f-28bfcaccda8c' class='xr-section-summary-in' type='checkbox'  checked><label for='section-97f077ff-0f54-46e4-a10f-28bfcaccda8c' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>428.0 450.0 450.0 ... 458.0 nan</div><input id='attrs-992a7c29-5b56-4fcd-b034-bafc67a5a231' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-992a7c29-5b56-4fcd-b034-bafc67a5a231' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-da927c36-252a-40c2-84c7-18f8d97427ed' class='xr-var-data-in' type='checkbox'><label for='data-da927c36-252a-40c2-84c7-18f8d97427ed' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[428., 450., 450., 438., 438.,  nan,  nan,  nan],
       [402., 402., 402., 442., 442., 442., 442., 458.],
       [402., 402., 442., 442., 442., 442., 458.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>3.013e+03 2.809e+03 ... nan</div><input id='attrs-773224ee-eece-4efb-b634-adadb112e5f4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-773224ee-eece-4efb-b634-adadb112e5f4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-da073ffa-5161-47cf-879a-9aeec2c0fa10' class='xr-var-data-in' type='checkbox'><label for='data-da073ffa-5161-47cf-879a-9aeec2c0fa10' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[3013., 2809., 2809., 2730., 2730.,   nan,   nan,   nan],
       [2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.],
       [2565., 2565., 2522., 2522., 2522., 2522., 2496.,   nan]],
      dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>259.0 235.0 235.0 ... 265.0 nan</div><input id='attrs-cc583ebf-4b9a-4118-815d-3f8f28b6e2c8' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-cc583ebf-4b9a-4118-815d-3f8f28b6e2c8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c13d8692-7e6e-429d-8b17-b8e5117ced31' class='xr-var-data-in' type='checkbox'><label for='data-c13d8692-7e6e-429d-8b17-b8e5117ced31' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[259., 235., 235., 231., 231.,  nan,  nan,  nan],
       [217., 217., 217., 230., 230., 230., 230., 265.],
       [217., 217., 230., 230., 230., 230., 265.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>563.0 541.0 541.0 ... 518.0 nan</div><input id='attrs-a7dda33f-1ba5-41ec-816f-24ef2ca5ceca' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a7dda33f-1ba5-41ec-816f-24ef2ca5ceca' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3fb8edd0-8f70-4cf5-9a70-a598657f26bd' class='xr-var-data-in' type='checkbox'><label for='data-3fb8edd0-8f70-4cf5-9a70-a598657f26bd' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[563., 541., 541., 528., 528.,  nan,  nan,  nan],
       [476., 476., 476., 476., 476., 476., 476., 518.],
       [476., 476., 476., 476., 476., 476., 518.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>832.0 820.0 820.0 ... 804.0 nan</div><input id='attrs-b99bc457-a04a-40a5-8af7-457992857323' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b99bc457-a04a-40a5-8af7-457992857323' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1468a69b-03bf-4384-9cae-1f898dec794b' class='xr-var-data-in' type='checkbox'><label for='data-1468a69b-03bf-4384-9cae-1f898dec794b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[832., 820., 820., 820., 820.,  nan,  nan,  nan],
       [715., 715., 715., 789., 789., 789., 789., 804.],
       [715., 715., 789., 789., 789., 789., 804.,  nan]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-e51f8258-c3ec-4a4d-89b5-b1c7c89e9bcd' class='xr-section-summary-in' type='checkbox'  ><label for='section-e51f8258-c3ec-4a4d-89b5-b1c7c89e9bcd' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_47_0.png">

</figure>




### Scenario  3:  Crop MODIS Data Using Reprojected Fire Boundary

In the  example below, you skip  the `crs=` argument.  
This has  assumed that you  have already  reprojected your  
vector  crop  extent. 

You can get the crs without opening up the whole dataset using the function `es.crs_check` from the EarthPy package. If you were to open the dataset wihout clipping it, it's less effecient. More data would be stored in memory in such a case. Which is why we use `es.crs_check` to get the crs without opening up the data fully.

Once you have opened and reprojected your crop extent, you can 
open and crop your MODIS raster data. You can do this like you did above, just be sure to leave out the `crs=` argument, since the data has already been reprojected! To clip to the box, call `.clip([box(*boundary_name.total_bounds)])`. Keep in mind, for this to work you have to import `box` from `shapely.geometry`!


{:.input}
```python
# Get the crs from the dataset with es.crs_check
modis_bands_crs = es.crs_check(modis_pre_path)

# Reproject the fire boundary
fire_boundary_sin = fire_boundary.to_crs(modis_bands_crs)

# Open and crop the data with the box made from the reprojected fire boundary
modis_bands_clip = rxr.open_rasterio(modis_pre_path,
                                     masked=True,
                                     variable=desired_bands).rio.clip(
                                                                     [box(*fire_bound_sin.total_bounds)],
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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-ec8149e9-b949-425f-8fc6-043fdbdb5923' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-ec8149e9-b949-425f-8fc6-043fdbdb5923' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 8</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-4d591ce9-bf69-492f-9e14-3a92acacdd51' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4d591ce9-bf69-492f-9e14-3a92acacdd51' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-a062469a-0645-4b83-8233-609db2fab281' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a062469a-0645-4b83-8233-609db2fab281' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fc749341-d27e-4b79-8294-3d938cbf78d1' class='xr-var-data-in' type='checkbox'><label for='data-fc749341-d27e-4b79-8294-3d938cbf78d1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.988e+06 ... -8.985e+06</div><input id='attrs-e131f55a-786d-41f4-ab05-55ae526ed1af' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e131f55a-786d-41f4-ab05-55ae526ed1af' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-17ca1041-73ac-4e9d-a7a0-7b96a846febc' class='xr-var-data-in' type='checkbox'><label for='data-17ca1041-73ac-4e9d-a7a0-7b96a846febc' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8988498.356997, -8988035.04428 , -8987571.731564, -8987108.418847,
       -8986645.106131, -8986181.793414, -8985718.480698, -8985255.167981])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-e65a6db1-a53f-472c-9067-bdf12cf32a71' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e65a6db1-a53f-472c-9067-bdf12cf32a71' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-aea7250c-bb2e-4f8b-ad1c-8bd9a86e86c0' class='xr-var-data-in' type='checkbox'><label for='data-aea7250c-bb2e-4f8b-ad1c-8bd9a86e86c0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-b0cb0d09-ec2a-4278-8b5d-89ae5cca8996' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b0cb0d09-ec2a-4278-8b5d-89ae5cca8996' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-72a98c5d-7978-4f9f-b217-38abeba9bb93' class='xr-var-data-in' type='checkbox'><label for='data-72a98c5d-7978-4f9f-b217-38abeba9bb93' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8988730.01335511 463.3127165277089 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-fe1d9899-6cf2-4af9-867b-f69df1ab5189' class='xr-section-summary-in' type='checkbox'  checked><label for='section-fe1d9899-6cf2-4af9-867b-f69df1ab5189' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>428.0 450.0 450.0 ... 458.0 458.0</div><input id='attrs-5b25ec81-c708-4c29-bf29-807b38886f7b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5b25ec81-c708-4c29-bf29-807b38886f7b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-963530f2-2c03-4186-986c-249a4140e19b' class='xr-var-data-in' type='checkbox'><label for='data-963530f2-2c03-4186-986c-249a4140e19b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[428., 450., 450., 438., 438., 421., 421., 409.],
       [402., 402., 402., 442., 442., 442., 442., 458.],
       [402., 402., 442., 442., 442., 442., 458., 458.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>3.013e+03 2.809e+03 ... 2.496e+03</div><input id='attrs-4419b5ea-cd79-460e-adab-ce5dc2604fb0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4419b5ea-cd79-460e-adab-ce5dc2604fb0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-14500f01-1f77-4144-a720-f246706f334c' class='xr-var-data-in' type='checkbox'><label for='data-14500f01-1f77-4144-a720-f246706f334c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[3013., 2809., 2809., 2730., 2730., 2628., 2628., 2641.],
       [2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.],
       [2565., 2565., 2522., 2522., 2522., 2522., 2496., 2496.]],
      dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>259.0 235.0 235.0 ... 265.0 265.0</div><input id='attrs-73aa14f9-94ab-4653-8d00-0d07e2552b5a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-73aa14f9-94ab-4653-8d00-0d07e2552b5a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-73778514-85b1-4bdb-aefb-749ef2470036' class='xr-var-data-in' type='checkbox'><label for='data-73778514-85b1-4bdb-aefb-749ef2470036' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[259., 235., 235., 231., 231., 211., 211., 203.],
       [217., 217., 217., 230., 230., 230., 230., 265.],
       [217., 217., 230., 230., 230., 230., 265., 265.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>563.0 541.0 541.0 ... 518.0 518.0</div><input id='attrs-0b18945b-4f96-4c06-be77-4a24c200d148' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0b18945b-4f96-4c06-be77-4a24c200d148' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1bcde7f1-0e67-46a1-9582-b9d93fc0af11' class='xr-var-data-in' type='checkbox'><label for='data-1bcde7f1-0e67-46a1-9582-b9d93fc0af11' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[563., 541., 541., 528., 528., 494., 494., 486.],
       [476., 476., 476., 476., 476., 476., 476., 518.],
       [476., 476., 476., 476., 476., 476., 518., 518.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>832.0 820.0 820.0 ... 804.0 804.0</div><input id='attrs-fd2c8c8a-cf34-421e-ac7b-53bcd5fa80a7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-fd2c8c8a-cf34-421e-ac7b-53bcd5fa80a7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7c9e141d-3b54-4e00-8b7f-98e41d80b71d' class='xr-var-data-in' type='checkbox'><label for='data-7c9e141d-3b54-4e00-8b7f-98e41d80b71d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[832., 820., 820., 820., 820., 749., 749., 715.],
       [715., 715., 715., 789., 789., 789., 789., 804.],
       [715., 715., 789., 789., 789., 789., 804., 804.]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-0add62d9-9b05-4f57-84b9-66d400fa8f89' class='xr-section-summary-in' type='checkbox'  ><label for='section-0add62d9-9b05-4f57-84b9-66d400fa8f89' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_51_0.png">

</figure>




## Which  Approach  To  Use?

You may be wondering which of the  above  scenarios  is  best.
The answer is - it depends. We know  that  using the `crs=`
parameter will likely slow down your processing, as well as provide 
a slightly tilted version of your geometry, however it
requires less code to implement.

For small workflows it could be fine to use the approach that 
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
                     crop_layer,
                     variable=None):
    """Open, subset and crop a MODIS h4 file.

    Parameters
    -----------
    band_path : string 
        A path to the array to be opened.
    crop_layer : geopandas GeoDataFrame
        A geopandas dataframe to be used to crop the raster data using rioxarray clip().
    variable : List
        A list of variables to be opened from the raster.

    Returns
    -----------
    band : xarray DataArray
        Cropped xarray DataArray
    """

    crop_bound_box = [box(*crop_layer.total_bounds)]

    band = rxr.open_rasterio(band_path,
                             masked=True,
                             variable=variable).rio.clip(crop_bound_box,
                                                         crs=crop_layer.crs,
                                                         all_touched=True,
                                                         from_disk=True).squeeze()

    return band
```

{:.input}
```python
# Open bands with function
clean_bands = open_clean_bands(band_path=modis_pre_path,
                               crop_layer=fire_boundary,
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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_54_0.png">

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
     nan)





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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_61_0.png" alt = "Plot of each MODIS band in the numpy stack cropped to the cold springs fire extent, identical to the last plot showing this same thing.">
<figcaption>Plot of each MODIS band in the numpy stack cropped to the cold springs fire extent, identical to the last plot showing this same thing.</figcaption>

</figure>






