---
layout: single
title: "Open and Use MODIS Data in HDF4 format in Open Source Python"
excerpt: "MODIS is remote sensing data that is stored in the HDF4 file format. Learn how to open and use MODIS data in HDF4 form in Open Source Python."
authors: ['Leah Wasser', 'Nathan Korinek', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2021-10-15
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

# This download is for the fire boundary
et.data.get_data('cold-springs-fire')

# Set working directory
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))
```



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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-2f5364ea-4e34-401d-a728-512939d72178' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-2f5364ea-4e34-401d-a728-512939d72178' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 1200</li><li><span class='xr-has-index'>x</span>: 1200</li><li><span class='xr-has-index'>band</span>: 1</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-0b430c69-a619-447e-8426-cb14405a1de4' class='xr-section-summary-in' type='checkbox'  checked><label for='section-0b430c69-a619-447e-8426-cb14405a1de4' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-4db7d41b-71cd-40c1-ae28-fabf92848595' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-4db7d41b-71cd-40c1-ae28-fabf92848595' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0a2e3a09-b308-4e4c-b766-3fe6b507b78f' class='xr-var-data-in' type='checkbox'><label for='data-0a2e3a09-b308-4e4c-b766-3fe6b507b78f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-10166eb4-eda5-42ea-8441-8481912cffc2' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-10166eb4-eda5-42ea-8441-8481912cffc2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0d4feac4-aaa9-4344-8e73-8339b5c0e815' class='xr-var-data-in' type='checkbox'><label for='data-0d4feac4-aaa9-4344-8e73-8339b5c0e815' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-df890910-43ec-4b2a-be25-acfb2224fc7c' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-df890910-43ec-4b2a-be25-acfb2224fc7c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1d18b23c-1d15-4c45-a3d3-d466dbb62411' class='xr-var-data-in' type='checkbox'><label for='data-1d18b23c-1d15-4c45-a3d3-d466dbb62411' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-95b24aad-dfdb-4104-b449-09ad1f3e5ac2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-95b24aad-dfdb-4104-b449-09ad1f3e5ac2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9b18e9e9-4373-4868-9599-0474ac7bdab2' class='xr-var-data-in' type='checkbox'><label for='data-9b18e9e9-4373-4868-9599-0474ac7bdab2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-6337bd83-a862-4c4c-b1d5-cd5b2ea92ec6' class='xr-section-summary-in' type='checkbox'  checked><label for='section-6337bd83-a862-4c4c-b1d5-cd5b2ea92ec6' class='xr-section-summary' >Data variables: <span>(10)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_1km</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-2b783dc5-8c1f-4c9b-bae1-75d1be32542b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2b783dc5-8c1f-4c9b-bae1-75d1be32542b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-47ac8676-08a5-4af1-8274-641b3af6ac83' class='xr-var-data-in' type='checkbox'><label for='data-47ac8676-08a5-4af1-8274-641b3af6ac83' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>granule_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-c95b25ab-4819-4cfb-a24e-d59ef682df7b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c95b25ab-4819-4cfb-a24e-d59ef682df7b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-37c4f12d-1bfc-4283-83ca-37a3ecc0ad2a' class='xr-var-data-in' type='checkbox'><label for='data-37c4f12d-1bfc-4283-83ca-37a3ecc0ad2a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Granule Pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>state_1km_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-fc8256a9-988d-45a4-9e99-1915059ffeae' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-fc8256a9-988d-45a4-9e99-1915059ffeae' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9ee30923-da3b-4471-a300-2499bf88394a' class='xr-var-data-in' type='checkbox'><label for='data-9ee30923-da3b-4471-a300-2499bf88394a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>1km Reflectance Data State QA - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-af462196-9760-43c6-9150-5180ce0d6127' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-af462196-9760-43c6-9150-5180ce0d6127' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-64ff7eac-68dc-484b-9638-ca1f99cf8662' class='xr-var-data-in' type='checkbox'><label for='data-64ff7eac-68dc-484b-9638-ca1f99cf8662' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-dc25622d-9b63-4e28-9721-c5e7aeeb0002' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-dc25622d-9b63-4e28-9721-c5e7aeeb0002' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cf9dcb41-23ee-4e95-8ac0-2bb3778f913a' class='xr-var-data-in' type='checkbox'><label for='data-cf9dcb41-23ee-4e95-8ac0-2bb3778f913a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>Range_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4d492077-246f-4085-b01b-7278e7cb9fc9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4d492077-246f-4085-b01b-7278e7cb9fc9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4eb57a66-5f55-42d7-ab2a-cff5dbcb74e6' class='xr-var-data-in' type='checkbox'><label for='data-4eb57a66-5f55-42d7-ab2a-cff5dbcb74e6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>25.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Range (pixel to sensor) - first layer</dd><dt><span>units :</span></dt><dd>meters</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-c94debe5-59bb-4b3b-8250-5bdaedd3a8eb' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c94debe5-59bb-4b3b-8250-5bdaedd3a8eb' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4970e608-c0ba-42ff-9bc8-db392cc9e2fb' class='xr-var-data-in' type='checkbox'><label for='data-4970e608-c0ba-42ff-9bc8-db392cc9e2fb' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-1bbdc6a1-e269-4410-a88b-ac918afa2f3c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1bbdc6a1-e269-4410-a88b-ac918afa2f3c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6ae98f2d-840e-42b7-a8cb-62047a42d5a9' class='xr-var-data-in' type='checkbox'><label for='data-6ae98f2d-840e-42b7-a8cb-62047a42d5a9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>gflags_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-421f4601-b8ec-49a0-8c10-758f9874423e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-421f4601-b8ec-49a0-8c10-758f9874423e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-28874d82-892a-40c9-9ee0-cd6d13937dc3' class='xr-var-data-in' type='checkbox'><label for='data-28874d82-892a-40c9-9ee0-cd6d13937dc3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Geolocation flags - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>orbit_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-de127ac8-9bc5-4ecd-b2ee-65a324d48319' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-de127ac8-9bc5-4ecd-b2ee-65a324d48319' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2dda55df-2b6d-4643-a09e-603af8f50a8d' class='xr-var-data-in' type='checkbox'><label for='data-2dda55df-2b6d-4643-a09e-603af8f50a8d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Orbit pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-481d9145-c8b3-4e33-9b9f-212b9b9e5770' class='xr-section-summary-in' type='checkbox'  ><label for='section-481d9145-c8b3-4e33-9b9f-212b9b9e5770' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    units:         none</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'num_observations_1km'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>y</span>: 1200</li><li><span class='xr-has-index'>x</span>: 1200</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-1629f024-31cd-49c3-ae0b-e940818f161b' class='xr-array-in' type='checkbox' checked><label for='section-1629f024-31cd-49c3-ae0b-e940818f161b' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[1440000 values with dtype=float32]</pre></div></div></li><li class='xr-section-item'><input id='section-33f47cd8-385d-4995-bcac-7e9a0247b406' class='xr-section-summary-in' type='checkbox'  checked><label for='section-33f47cd8-385d-4995-bcac-7e9a0247b406' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-fd5b8094-8d8b-40a9-99fe-cabd85bcda63' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-fd5b8094-8d8b-40a9-99fe-cabd85bcda63' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2c12c943-f69d-43f6-9f5f-1ab39ec45059' class='xr-var-data-in' type='checkbox'><label for='data-2c12c943-f69d-43f6-9f5f-1ab39ec45059' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-1e4ff051-07f3-4100-9612-e93634ac9350' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-1e4ff051-07f3-4100-9612-e93634ac9350' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-02af4ec2-6eb3-4d23-b06d-284b118bd4e3' class='xr-var-data-in' type='checkbox'><label for='data-02af4ec2-6eb3-4d23-b06d-284b118bd4e3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-7789f2d6-7d3a-4418-83e3-cd4c999ce69b' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-7789f2d6-7d3a-4418-83e3-cd4c999ce69b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2eb4f141-1592-4b3b-ae8d-43c231310ee3' class='xr-var-data-in' type='checkbox'><label for='data-2eb4f141-1592-4b3b-ae8d-43c231310ee3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-dab2a5c3-9383-4a3f-98df-2372443b42bc' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-dab2a5c3-9383-4a3f-98df-2372443b42bc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f9b2312f-fc26-4f7f-b0db-f9ff1b329011' class='xr-var-data-in' type='checkbox'><label for='data-f9b2312f-fc26-4f7f-b0db-f9ff1b329011' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-2f2705c5-8ad7-4c8f-bd75-9cf575778c7e' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2f2705c5-8ad7-4c8f-bd75-9cf575778c7e' class='xr-section-summary' >Attributes: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-1febf878-99db-4104-88fd-17c8707741ee' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-1febf878-99db-4104-88fd-17c8707741ee' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li><li><span class='xr-has-index'>band</span>: 1</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-7261c521-0517-47e2-a6da-a3c6bf7c7f4c' class='xr-section-summary-in' type='checkbox'  checked><label for='section-7261c521-0517-47e2-a6da-a3c6bf7c7f4c' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-165e7738-efa5-46d5-9cf2-96e5b1c28c4d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-165e7738-efa5-46d5-9cf2-96e5b1c28c4d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4fa5b805-ec7a-4b22-aedc-d076e0bcb224' class='xr-var-data-in' type='checkbox'><label for='data-4fa5b805-ec7a-4b22-aedc-d076e0bcb224' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-066095e8-107a-48ed-8b5c-5875350dde9c' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-066095e8-107a-48ed-8b5c-5875350dde9c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6986711c-b24e-4833-87e3-071d02b19fa4' class='xr-var-data-in' type='checkbox'><label for='data-6986711c-b24e-4833-87e3-071d02b19fa4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-b045dc04-828a-4463-b22f-c5faf513c8ae' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-b045dc04-828a-4463-b22f-c5faf513c8ae' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8585709a-96a2-4c3e-99e3-685e9c4e8c5a' class='xr-var-data-in' type='checkbox'><label for='data-8585709a-96a2-4c3e-99e3-685e9c4e8c5a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-94e6d303-6214-4173-8a11-c150e355bfb2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-94e6d303-6214-4173-8a11-c150e355bfb2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9fd69d4f-710f-4820-9f9d-9dc50455f775' class='xr-var-data-in' type='checkbox'><label for='data-9fd69d4f-710f-4820-9f9d-9dc50455f775' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-f810a2b6-2e86-4fd6-a003-a808f76a0a64' class='xr-section-summary-in' type='checkbox'  checked><label for='section-f810a2b6-2e86-4fd6-a003-a808f76a0a64' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-802b499d-d8da-44d4-93c2-a081715f6513' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-802b499d-d8da-44d4-93c2-a081715f6513' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-72134df5-90f5-4764-984c-c134a1923a49' class='xr-var-data-in' type='checkbox'><label for='data-72134df5-90f5-4764-984c-c134a1923a49' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-e448e729-9ccc-49d1-bb44-2df9091c5edf' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e448e729-9ccc-49d1-bb44-2df9091c5edf' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d193c93a-9b11-4b0e-be3d-aa3261524dfe' class='xr-var-data-in' type='checkbox'><label for='data-d193c93a-9b11-4b0e-be3d-aa3261524dfe' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-e16a5ed1-1aa0-432a-aadb-d69c45313619' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e16a5ed1-1aa0-432a-aadb-d69c45313619' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b9fb44f6-2b2a-48f4-a611-7d182520d87c' class='xr-var-data-in' type='checkbox'><label for='data-b9fb44f6-2b2a-48f4-a611-7d182520d87c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-5c3cc2b2-6803-4673-b60f-7c9cd4a04273' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5c3cc2b2-6803-4673-b60f-7c9cd4a04273' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f69a48c5-64d5-4531-982a-a94f3e38e116' class='xr-var-data-in' type='checkbox'><label for='data-f69a48c5-64d5-4531-982a-a94f3e38e116' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-c8b3c529-3a27-4402-9b3a-ae5d58d59c20' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c8b3c529-3a27-4402-9b3a-ae5d58d59c20' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0e95576b-cfba-4a10-b6a3-aaddad9e10e3' class='xr-var-data-in' type='checkbox'><label for='data-0e95576b-cfba-4a10-b6a3-aaddad9e10e3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-b01ba58a-2055-47b8-b244-c86fb1da8477' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b01ba58a-2055-47b8-b244-c86fb1da8477' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-97ffde4d-dee2-4f08-a6d6-c97e97cb543e' class='xr-var-data-in' type='checkbox'><label for='data-97ffde4d-dee2-4f08-a6d6-c97e97cb543e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-7263fff7-457c-4055-8745-9fafe8c24a40' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7263fff7-457c-4055-8745-9fafe8c24a40' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f9af7e38-740e-47a3-8ac1-d9d60b9143c9' class='xr-var-data-in' type='checkbox'><label for='data-f9af7e38-740e-47a3-8ac1-d9d60b9143c9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d6136702-7794-42d6-8c7c-373a81c99e5c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d6136702-7794-42d6-8c7c-373a81c99e5c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-601ad3dc-5aff-450e-8951-cef6a9ce027f' class='xr-var-data-in' type='checkbox'><label for='data-601ad3dc-5aff-450e-8951-cef6a9ce027f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-676597cc-eba2-4511-a5ba-a957edf04b31' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-676597cc-eba2-4511-a5ba-a957edf04b31' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-234ba32f-bf9b-49a4-9da6-bbec47680beb' class='xr-var-data-in' type='checkbox'><label for='data-234ba32f-bf9b-49a4-9da6-bbec47680beb' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8fbe22f0-d940-4e48-a7b5-ddbd70f0c264' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8fbe22f0-d940-4e48-a7b5-ddbd70f0c264' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-aaeb61e1-8b0c-48e5-84c9-cd3741d79b24' class='xr-var-data-in' type='checkbox'><label for='data-aaeb61e1-8b0c-48e5-84c9-cd3741d79b24' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-a654a2b8-f2c4-4151-9672-d48ff2c6825a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a654a2b8-f2c4-4151-9672-d48ff2c6825a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bb4a0a5c-ce92-4407-af4e-309fc46b6e98' class='xr-var-data-in' type='checkbox'><label for='data-bb4a0a5c-ce92-4407-af4e-309fc46b6e98' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-f97eed5f-a579-49a4-8c6a-17703ecf075d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f97eed5f-a579-49a4-8c6a-17703ecf075d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b44cc62d-5b70-48c4-b7c4-5fcb4d7b299a' class='xr-var-data-in' type='checkbox'><label for='data-b44cc62d-5b70-48c4-b7c4-5fcb4d7b299a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-63e10ba0-bbd7-4a78-ac10-5a2a2a4b656a' class='xr-section-summary-in' type='checkbox'  ><label for='section-63e10ba0-bbd7-4a78-ac10-5a2a2a4b656a' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-7d951573-fc99-4d23-b710-1733782ccce5' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-7d951573-fc99-4d23-b710-1733782ccce5' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-75f4ade1-6a60-4d7f-934c-2be90f76d10b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-75f4ade1-6a60-4d7f-934c-2be90f76d10b' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-bce631cc-4f4b-49f6-a49a-773700bfa32f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-bce631cc-4f4b-49f6-a49a-773700bfa32f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9ce54f57-3071-420b-b7e2-8a356dc54019' class='xr-var-data-in' type='checkbox'><label for='data-9ce54f57-3071-420b-b7e2-8a356dc54019' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-3372e348-a99c-4b28-b532-33afa514c1fe' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-3372e348-a99c-4b28-b532-33afa514c1fe' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-377870e0-dbe4-459a-8bfa-6f137f78cd16' class='xr-var-data-in' type='checkbox'><label for='data-377870e0-dbe4-459a-8bfa-6f137f78cd16' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-34ba5cbe-fb63-4ddc-ace0-4e6bc2702047' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-34ba5cbe-fb63-4ddc-ace0-4e6bc2702047' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c6d340a9-44c9-402e-a952-d99c1e259e6a' class='xr-var-data-in' type='checkbox'><label for='data-c6d340a9-44c9-402e-a952-d99c1e259e6a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-70a25238-833b-42c2-9bfb-b19e1c66e31a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-70a25238-833b-42c2-9bfb-b19e1c66e31a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-126a82d2-df36-446b-a3e1-6f492073b536' class='xr-var-data-in' type='checkbox'><label for='data-126a82d2-df36-446b-a3e1-6f492073b536' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-2d438029-c9ac-49cf-af56-605cede85eba' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2d438029-c9ac-49cf-af56-605cede85eba' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-78b4abf3-c272-453d-b632-b25e00ef73ea' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-78b4abf3-c272-453d-b632-b25e00ef73ea' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fff4e514-66c9-460b-89d0-2195ec72167c' class='xr-var-data-in' type='checkbox'><label for='data-fff4e514-66c9-460b-89d0-2195ec72167c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-989ded19-962c-4bd3-8278-7251f1f13a6f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-989ded19-962c-4bd3-8278-7251f1f13a6f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3508c0d3-7622-47d5-bc4d-754bc47d13b7' class='xr-var-data-in' type='checkbox'><label for='data-3508c0d3-7622-47d5-bc4d-754bc47d13b7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-7af80fda-3a59-4d2c-bbb7-f3bebc5de4d6' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7af80fda-3a59-4d2c-bbb7-f3bebc5de4d6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e4a1985e-1fbd-4c07-8784-8f7e54695c6c' class='xr-var-data-in' type='checkbox'><label for='data-e4a1985e-1fbd-4c07-8784-8f7e54695c6c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-6425f7ab-5c30-478b-a7a0-88b9561023d1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6425f7ab-5c30-478b-a7a0-88b9561023d1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ab3b5f2e-f90b-43e9-bd47-c3450d4ef53c' class='xr-var-data-in' type='checkbox'><label for='data-ab3b5f2e-f90b-43e9-bd47-c3450d4ef53c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d9d47405-e7d6-4325-9577-1829ef650c39' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d9d47405-e7d6-4325-9577-1829ef650c39' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1a15bd4d-4dcd-4e45-925b-7b997c0bb3f3' class='xr-var-data-in' type='checkbox'><label for='data-1a15bd4d-4dcd-4e45-925b-7b997c0bb3f3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4520f926-c3d3-4e41-ae98-9faa7b0558b6' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4520f926-c3d3-4e41-ae98-9faa7b0558b6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fde56a11-c7b0-4cc2-94d6-4c021694100a' class='xr-var-data-in' type='checkbox'><label for='data-fde56a11-c7b0-4cc2-94d6-4c021694100a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-75401ba2-f5cb-4f12-a210-54c2cbe55606' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-75401ba2-f5cb-4f12-a210-54c2cbe55606' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3a0cff05-4bd3-4877-9ded-27da972c2ec2' class='xr-var-data-in' type='checkbox'><label for='data-3a0cff05-4bd3-4877-9ded-27da972c2ec2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-b699a1bf-81da-4294-a275-c6ceef4eec6f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b699a1bf-81da-4294-a275-c6ceef4eec6f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-989b4759-e465-4e68-8caf-0dd8d14bc642' class='xr-var-data-in' type='checkbox'><label for='data-989b4759-e465-4e68-8caf-0dd8d14bc642' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8d3ffa38-8f96-440f-8952-73c8df46e2e4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8d3ffa38-8f96-440f-8952-73c8df46e2e4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ffc21ff1-5184-4476-a84d-f43db56be67c' class='xr-var-data-in' type='checkbox'><label for='data-ffc21ff1-5184-4476-a84d-f43db56be67c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-6eeb6e5b-0819-499f-acc3-047c8ba32acc' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6eeb6e5b-0819-499f-acc3-047c8ba32acc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-028ab494-1cbb-4148-b37a-dec9b2c9ea3e' class='xr-var-data-in' type='checkbox'><label for='data-028ab494-1cbb-4148-b37a-dec9b2c9ea3e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-5b0e90b3-429e-4d06-a52c-4971699e2326' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5b0e90b3-429e-4d06-a52c-4971699e2326' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-37a81148-7e8c-4f59-bf8b-c1103ca07797' class='xr-var-data-in' type='checkbox'><label for='data-37a81148-7e8c-4f59-bf8b-c1103ca07797' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-82ca9d17-f77a-4596-8f89-57bc95015c7c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-82ca9d17-f77a-4596-8f89-57bc95015c7c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-79b6fb48-94c7-4ae4-909d-b713f05ea5a3' class='xr-var-data-in' type='checkbox'><label for='data-79b6fb48-94c7-4ae4-909d-b713f05ea5a3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-bf05de2f-167b-4f6d-ab31-9496c1f745db' class='xr-section-summary-in' type='checkbox'  ><label for='section-bf05de2f-167b-4f6d-ab31-9496c1f745db' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-71f166d3-9614-4774-9567-18af7066678f' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-71f166d3-9614-4774-9567-18af7066678f' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-d4e77011-62c0-4a60-8421-5fedaa5d3cd7' class='xr-section-summary-in' type='checkbox'  checked><label for='section-d4e77011-62c0-4a60-8421-5fedaa5d3cd7' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-cb518850-bd7e-4390-821a-3a7036f78bb4' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-cb518850-bd7e-4390-821a-3a7036f78bb4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f399a496-27b4-4435-938d-bb3ac3b41e88' class='xr-var-data-in' type='checkbox'><label for='data-f399a496-27b4-4435-938d-bb3ac3b41e88' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-2f6b1e96-445c-4afe-b733-905d2bcaf64a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2f6b1e96-445c-4afe-b733-905d2bcaf64a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5c94442e-c466-475a-b77d-a88cab431ac5' class='xr-var-data-in' type='checkbox'><label for='data-5c94442e-c466-475a-b77d-a88cab431ac5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-7e33eab0-c9b3-4df6-b9ea-530a7c3a8aa5' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-7e33eab0-c9b3-4df6-b9ea-530a7c3a8aa5' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-007b6522-5879-490e-adc4-e94d96bc893a' class='xr-var-data-in' type='checkbox'><label for='data-007b6522-5879-490e-adc4-e94d96bc893a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-a9d5e8a7-c800-4d9c-b322-f4df9d29b412' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a9d5e8a7-c800-4d9c-b322-f4df9d29b412' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-001f925e-1f91-4c76-ab93-3545099ee0cf' class='xr-var-data-in' type='checkbox'><label for='data-001f925e-1f91-4c76-ab93-3545099ee0cf' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-fcfe302a-0510-40d0-80e6-e6705a7e3315' class='xr-section-summary-in' type='checkbox'  checked><label for='section-fcfe302a-0510-40d0-80e6-e6705a7e3315' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-020044d9-2397-4070-bc48-01ff16cad9bf' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-020044d9-2397-4070-bc48-01ff16cad9bf' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-129b0e68-00be-4b0c-bd09-3e565b4eb1ff' class='xr-var-data-in' type='checkbox'><label for='data-129b0e68-00be-4b0c-bd09-3e565b4eb1ff' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-45285a87-72f2-431c-8143-92e04c33d69c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-45285a87-72f2-431c-8143-92e04c33d69c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1065ea50-457e-4052-bb5f-dafcd7ee263c' class='xr-var-data-in' type='checkbox'><label for='data-1065ea50-457e-4052-bb5f-dafcd7ee263c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-88474e0d-139d-437a-8f38-702d91a6c6fd' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-88474e0d-139d-437a-8f38-702d91a6c6fd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5cdf1767-3e25-4fce-a205-fb5c49952956' class='xr-var-data-in' type='checkbox'><label for='data-5cdf1767-3e25-4fce-a205-fb5c49952956' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-faba3118-811e-46a2-9bd4-5e0a79119ab3' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-faba3118-811e-46a2-9bd4-5e0a79119ab3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-87a1c197-0e6b-464d-b875-79434d608ab6' class='xr-var-data-in' type='checkbox'><label for='data-87a1c197-0e6b-464d-b875-79434d608ab6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>int16</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-abd1595c-7307-4e24-b82c-34303ca098f7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-abd1595c-7307-4e24-b82c-34303ca098f7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1d202980-e5d3-4819-a26f-90ea46d2c359' class='xr-var-data-in' type='checkbox'><label for='data-1d202980-e5d3-4819-a26f-90ea46d2c359' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-28672.0</dd><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=int16]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-b395bba8-768d-4cfb-b680-f8625810baa4' class='xr-section-summary-in' type='checkbox'  ><label for='section-b395bba8-768d-4cfb-b680-f8625810baa4' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-5bd0fe8e-8e35-47e6-8e7e-5a786601a0ec' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-5bd0fe8e-8e35-47e6-8e7e-5a786601a0ec' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-b877623e-f0b6-4ac7-943b-a43dfd30891e' class='xr-section-summary-in' type='checkbox'  checked><label for='section-b877623e-f0b6-4ac7-943b-a43dfd30891e' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-a388cf5b-ad09-45b6-bdf4-40a3a256f50a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a388cf5b-ad09-45b6-bdf4-40a3a256f50a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f3324812-e501-4110-a415-2f96740c1183' class='xr-var-data-in' type='checkbox'><label for='data-f3324812-e501-4110-a415-2f96740c1183' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-2b09f105-a4c0-4e51-88b2-dea194359e7f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2b09f105-a4c0-4e51-88b2-dea194359e7f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-92295412-6888-4953-8946-d578e504913a' class='xr-var-data-in' type='checkbox'><label for='data-92295412-6888-4953-8946-d578e504913a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-bbacabe9-6e75-4000-8cf9-ef0afaf9bb3d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-bbacabe9-6e75-4000-8cf9-ef0afaf9bb3d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b5dabd27-0d3a-491c-8965-5dee5b5a4d47' class='xr-var-data-in' type='checkbox'><label for='data-b5dabd27-0d3a-491c-8965-5dee5b5a4d47' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-966d1fbc-570b-406c-9fa7-7f80d35a1b13' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-966d1fbc-570b-406c-9fa7-7f80d35a1b13' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1ddfe092-f5b9-4fa7-b5dc-e469b1dfae57' class='xr-var-data-in' type='checkbox'><label for='data-1ddfe092-f5b9-4fa7-b5dc-e469b1dfae57' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-cbc661d1-b604-4441-a908-e0c692e097dd' class='xr-section-summary-in' type='checkbox'  checked><label for='section-cbc661d1-b604-4441-a908-e0c692e097dd' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-916661bb-b961-4dfb-8075-ed1c31386d95' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-916661bb-b961-4dfb-8075-ed1c31386d95' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b2c7b612-f567-4278-982c-04ad5339af67' class='xr-var-data-in' type='checkbox'><label for='data-b2c7b612-f567-4278-982c-04ad5339af67' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-db275b5e-421d-4b9f-a5f9-869f7aeb9af0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-db275b5e-421d-4b9f-a5f9-869f7aeb9af0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-952a989e-467e-4b13-ac61-b86fdbebadde' class='xr-var-data-in' type='checkbox'><label for='data-952a989e-467e-4b13-ac61-b86fdbebadde' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-74d741ae-6e86-4bb3-9d0f-f792c18ff5b2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-74d741ae-6e86-4bb3-9d0f-f792c18ff5b2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6b65c8ab-7fa8-40d8-b133-fdce1bf9288d' class='xr-var-data-in' type='checkbox'><label for='data-6b65c8ab-7fa8-40d8-b133-fdce1bf9288d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8972c9a0-4381-4165-80f5-678d5d4f1905' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8972c9a0-4381-4165-80f5-678d5d4f1905' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2c14341a-c6f8-4cfc-acb2-581677815925' class='xr-var-data-in' type='checkbox'><label for='data-2c14341a-c6f8-4cfc-acb2-581677815925' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-2bf33d2a-fcd9-4a3c-84b1-1651eca725c9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2bf33d2a-fcd9-4a3c-84b1-1651eca725c9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-efffee74-c558-436f-b05d-638e214f4876' class='xr-var-data-in' type='checkbox'><label for='data-efffee74-c558-436f-b05d-638e214f4876' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-26bc5ebb-2578-4e9b-9d59-2e51b4c06724' class='xr-section-summary-in' type='checkbox'  ><label for='section-26bc5ebb-2578-4e9b-9d59-2e51b4c06724' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>variable</span>: 5</li><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-9a4d1d58-cf1d-4f27-8f0f-1360d097af93' class='xr-array-in' type='checkbox' checked><label for='section-9a4d1d58-cf1d-4f27-8f0f-1360d097af93' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>1.902e+03 1.949e+03 1.947e+03 2.095e+03 ... 1.161e+03 913.0 703.0</span></div><div class='xr-array-data'><pre>array([[[1902., 1949., 1947., ..., 1327., 1327., 1181.],
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
        [2296., 2296., 2511., ..., 1161.,  913.,  703.]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-148afa9c-da4e-41c9-8a7f-87439638af02' class='xr-section-summary-in' type='checkbox'  checked><label for='section-148afa9c-da4e-41c9-8a7f-87439638af02' class='xr-section-summary' >Coordinates: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-f1f876d8-7cb2-4cd5-bf66-699d93e8f734' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-f1f876d8-7cb2-4cd5-bf66-699d93e8f734' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bd49c1aa-7623-4ab2-8fb7-f86e13aab08a' class='xr-var-data-in' type='checkbox'><label for='data-bd49c1aa-7623-4ab2-8fb7-f86e13aab08a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-30ddcea9-2e96-454a-b795-a380feb516d8' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-30ddcea9-2e96-454a-b795-a380feb516d8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-31be82c8-1251-48c7-be6e-f771391ea6f4' class='xr-var-data-in' type='checkbox'><label for='data-31be82c8-1251-48c7-be6e-f771391ea6f4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-4a2d5dd1-b1e5-46cb-8695-f1b4d0269434' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-4a2d5dd1-b1e5-46cb-8695-f1b4d0269434' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b9fed904-a4ba-40fb-ac63-7a86c70cfba5' class='xr-var-data-in' type='checkbox'><label for='data-b9fed904-a4ba-40fb-ac63-7a86c70cfba5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-925007e1-9531-48cc-a629-155c66464933' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-925007e1-9531-48cc-a629-155c66464933' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-22e376d1-38fb-4948-8cef-494f98472af8' class='xr-var-data-in' type='checkbox'><label for='data-22e376d1-38fb-4948-8cef-494f98472af8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>variable</span></div><div class='xr-var-dims'>(variable)</div><div class='xr-var-dtype'>&lt;U14</div><div class='xr-var-preview xr-preview'>&#x27;sur_refl_b01_1&#x27; ... &#x27;sur_refl_b...</div><input id='attrs-a1050fd9-d8e3-480d-9b6c-d587554f4e87' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-a1050fd9-d8e3-480d-9b6c-d587554f4e87' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a73a9f97-4fca-45fe-b9da-812538493f93' class='xr-var-data-in' type='checkbox'><label for='data-a73a9f97-4fca-45fe-b9da-812538493f93' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;sur_refl_b01_1&#x27;, &#x27;sur_refl_b02_1&#x27;, &#x27;sur_refl_b03_1&#x27;, &#x27;sur_refl_b04_1&#x27;,
       &#x27;sur_refl_b07_1&#x27;], dtype=&#x27;&lt;U14&#x27;)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-c783f042-6a1e-42a3-9e08-f9ba6df72956' class='xr-section-summary-in' type='checkbox'  ><label for='section-c783f042-6a1e-42a3-9e08-f9ba6df72956' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>variable</span>: 3</li><li><span class='xr-has-index'>y</span>: 2400</li><li><span class='xr-has-index'>x</span>: 2400</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-306470f3-7905-46f6-85f6-4a77efdb4bd0' class='xr-array-in' type='checkbox' checked><label for='section-306470f3-7905-46f6-85f6-4a77efdb4bd0' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>1.902e+03 1.949e+03 1.947e+03 2.095e+03 ... 1.089e+03 759.0 516.0</span></div><div class='xr-array-data'><pre>array([[[1902., 1949., 1947., ..., 1327., 1327., 1181.],
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
        [1154., 1154., 1231., ..., 1089.,  759.,  516.]]], dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-4464294c-56b9-4e5c-b5f5-a0db7d93abf0' class='xr-section-summary-in' type='checkbox'  checked><label for='section-4464294c-56b9-4e5c-b5f5-a0db7d93abf0' class='xr-section-summary' >Coordinates: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-39537160-d812-4be6-bb0c-c08cd8dcbd77' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-39537160-d812-4be6-bb0c-c08cd8dcbd77' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6c697d1a-27cf-42cc-b8da-42af9538e130' class='xr-var-data-in' type='checkbox'><label for='data-6c697d1a-27cf-42cc-b8da-42af9538e130' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-7d5687d9-9c2b-4995-a13d-b4faff07aeb6' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-7d5687d9-9c2b-4995-a13d-b4faff07aeb6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5fb4064e-5ca7-413b-942e-108698120bcd' class='xr-var-data-in' type='checkbox'><label for='data-5fb4064e-5ca7-413b-942e-108698120bcd' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-5a38d642-d0e3-4e48-8fc8-677cd7aa8f63' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5a38d642-d0e3-4e48-8fc8-677cd7aa8f63' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1286077b-f950-4402-bd87-9aa488a87678' class='xr-var-data-in' type='checkbox'><label for='data-1286077b-f950-4402-bd87-9aa488a87678' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-0fb61e59-679c-46e4-839e-b0767d6d15c1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0fb61e59-679c-46e4-839e-b0767d6d15c1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e51192f5-1191-4f2f-878e-3a8cc702f80b' class='xr-var-data-in' type='checkbox'><label for='data-e51192f5-1191-4f2f-878e-3a8cc702f80b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>variable</span></div><div class='xr-var-dims'>(variable)</div><div class='xr-var-dtype'>&lt;U14</div><div class='xr-var-preview xr-preview'>&#x27;sur_refl_b01_1&#x27; ... &#x27;sur_refl_b...</div><input id='attrs-bcdcbf00-5339-47d0-97b5-d647b61979ea' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-bcdcbf00-5339-47d0-97b5-d647b61979ea' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-80d31eb6-dd6a-416b-ba9f-c0543b4fc609' class='xr-var-data-in' type='checkbox'><label for='data-80d31eb6-dd6a-416b-ba9f-c0543b4fc609' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;sur_refl_b01_1&#x27;, &#x27;sur_refl_b03_1&#x27;, &#x27;sur_refl_b04_1&#x27;], dtype=&#x27;&lt;U14&#x27;)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-fe723438-4ff4-410b-89c3-4ca54a934523' class='xr-section-summary-in' type='checkbox'  ><label for='section-fe723438-4ff4-410b-89c3-4ca54a934523' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-a0b66191-2ca0-4274-b3e2-6757a99a6289' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-a0b66191-2ca0-4274-b3e2-6757a99a6289' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 12</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-5b8b1d14-4a98-428c-a0a8-5276ab70f575' class='xr-section-summary-in' type='checkbox'  checked><label for='section-5b8b1d14-4a98-428c-a0a8-5276ab70f575' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-39aa897b-f61e-4079-9461-123462806670' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-39aa897b-f61e-4079-9461-123462806670' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9589e641-66f0-4819-9b70-6356520662a6' class='xr-var-data-in' type='checkbox'><label for='data-9589e641-66f0-4819-9b70-6356520662a6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.989e+06 ... -8.984e+06</div><input id='attrs-9925d7c8-a15c-4c5d-afbf-15aab3ea11e0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9925d7c8-a15c-4c5d-afbf-15aab3ea11e0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f31435fb-244d-495b-8a42-6b3bd633cdf0' class='xr-var-data-in' type='checkbox'><label for='data-f31435fb-244d-495b-8a42-6b3bd633cdf0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8989424.98243 , -8988961.669713, -8988498.356997, -8988035.04428 ,
       -8987571.731564, -8987108.418847, -8986645.106131, -8986181.793414,
       -8985718.480698, -8985255.167981, -8984791.855265, -8984328.542548])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-5cb48601-638c-4ec2-9007-eee96ace8070' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5cb48601-638c-4ec2-9007-eee96ace8070' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-03bfd168-c4dc-47f5-98ef-e80b072077bf' class='xr-var-data-in' type='checkbox'><label for='data-03bfd168-c4dc-47f5-98ef-e80b072077bf' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-f27ced9e-142e-4f75-8fb5-3182a6f9ea60' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f27ced9e-142e-4f75-8fb5-3182a6f9ea60' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-027cc1f1-90e0-401b-b0ec-750abea08f30' class='xr-var-data-in' type='checkbox'><label for='data-027cc1f1-90e0-401b-b0ec-750abea08f30' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8989656.638788167 463.3127165279266 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-a06d4ef9-0db6-47d7-a20d-10e7ec79c58b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-a06d4ef9-0db6-47d7-a20d-10e7ec79c58b' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 428.0 450.0 ... nan nan nan</div><input id='attrs-188db012-6fdc-4625-8e98-2e21111d5e6f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-188db012-6fdc-4625-8e98-2e21111d5e6f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4153b0a3-d177-4c5e-931f-f3a9f52a5035' class='xr-var-data-in' type='checkbox'><label for='data-4153b0a3-d177-4c5e-931f-f3a9f52a5035' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 428., 450., 450., 438., 438., 421., 421., 409., 409.,
        483.],
       [ nan, 402., 402., 402., 402., 442., 442., 442., 442., 458., 458.,
         nan],
       [402., 402., 402., 402., 442., 442., 442., 442., 458.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 3.013e+03 ... nan nan nan</div><input id='attrs-a92573c9-3b1d-462d-8d92-4756cd3858e6' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a92573c9-3b1d-462d-8d92-4756cd3858e6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-90f1813c-8b6e-4049-943f-b3b4d03ceb73' class='xr-var-data-in' type='checkbox'><label for='data-90f1813c-8b6e-4049-943f-b3b4d03ceb73' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[  nan,   nan, 3013., 2809., 2809., 2730., 2730., 2628., 2628.,
        2641., 2641., 2576.],
       [  nan, 2565., 2565., 2565., 2565., 2522., 2522., 2522., 2522.,
        2496., 2496.,   nan],
       [2565., 2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.,
          nan,   nan,   nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 259.0 235.0 ... nan nan nan</div><input id='attrs-be59e843-f86f-451d-9874-b92e90a6ba2f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-be59e843-f86f-451d-9874-b92e90a6ba2f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ded71c60-82ad-43ca-b71a-14a1d6f00630' class='xr-var-data-in' type='checkbox'><label for='data-ded71c60-82ad-43ca-b71a-14a1d6f00630' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 259., 235., 235., 231., 231., 211., 211., 203., 203.,
        245.],
       [ nan, 217., 217., 217., 217., 230., 230., 230., 230., 265., 265.,
         nan],
       [217., 217., 217., 217., 230., 230., 230., 230., 265.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 563.0 541.0 ... nan nan nan</div><input id='attrs-eb264df0-5f7f-4e14-9a46-f45172ca9346' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-eb264df0-5f7f-4e14-9a46-f45172ca9346' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-28ad5ddc-93a3-4419-9414-88399414f6e9' class='xr-var-data-in' type='checkbox'><label for='data-28ad5ddc-93a3-4419-9414-88399414f6e9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 563., 541., 541., 528., 528., 494., 494., 486., 486.,
        530.],
       [ nan, 476., 476., 476., 476., 476., 476., 476., 476., 518., 518.,
         nan],
       [476., 476., 476., 476., 476., 476., 476., 476., 518.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>nan nan 832.0 820.0 ... nan nan nan</div><input id='attrs-a9493c67-34a9-4657-a847-ed3c1a45f249' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a9493c67-34a9-4657-a847-ed3c1a45f249' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bb5468fc-6a3c-42a2-bc1c-eb8d3773c9d6' class='xr-var-data-in' type='checkbox'><label for='data-bb5468fc-6a3c-42a2-bc1c-eb8d3773c9d6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[ nan,  nan, 832., 820., 820., 820., 820., 749., 749., 715., 715.,
        820.],
       [ nan, 715., 715., 715., 715., 789., 789., 789., 789., 804., 804.,
         nan],
       [715., 715., 715., 715., 789., 789., 789., 789., 804.,  nan,  nan,
         nan]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-18e285bf-eb3f-4ab9-b1a7-3c6acd2252d0' class='xr-section-summary-in' type='checkbox'  ><label for='section-18e285bf-eb3f-4ab9-b1a7-3c6acd2252d0' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-0242e0b0-081f-4e30-88e0-8310f6d8d0f3' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-0242e0b0-081f-4e30-88e0-8310f6d8d0f3' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 8</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-ea7c5201-d778-40d8-b577-f6e72fb99444' class='xr-section-summary-in' type='checkbox'  checked><label for='section-ea7c5201-d778-40d8-b577-f6e72fb99444' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-dc6dc3ac-763e-4dbe-b4d4-e224dd200425' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-dc6dc3ac-763e-4dbe-b4d4-e224dd200425' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-611a2c2b-f86d-4be1-a803-27f24f7bb408' class='xr-var-data-in' type='checkbox'><label for='data-611a2c2b-f86d-4be1-a803-27f24f7bb408' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.988e+06 ... -8.985e+06</div><input id='attrs-c6fc4328-be6d-427e-97e6-a6c74d1a6f8b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c6fc4328-be6d-427e-97e6-a6c74d1a6f8b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-23731ef6-77dd-422b-a018-ce6d93428a7c' class='xr-var-data-in' type='checkbox'><label for='data-23731ef6-77dd-422b-a018-ce6d93428a7c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8988498.356997, -8988035.04428 , -8987571.731564, -8987108.418847,
       -8986645.106131, -8986181.793414, -8985718.480698, -8985255.167981])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-5e9012bd-fbed-4b06-b60f-b24c0f0b891b' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5e9012bd-fbed-4b06-b60f-b24c0f0b891b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e0600af7-ee38-4320-9fff-31fc77180048' class='xr-var-data-in' type='checkbox'><label for='data-e0600af7-ee38-4320-9fff-31fc77180048' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-52cc05f9-6a2f-45c7-b0dd-c4b0384a4cdd' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-52cc05f9-6a2f-45c7-b0dd-c4b0384a4cdd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e6bae62b-54d7-40ff-98a3-0dea4527191d' class='xr-var-data-in' type='checkbox'><label for='data-e6bae62b-54d7-40ff-98a3-0dea4527191d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8988730.01335511 463.3127165277089 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-eeab316d-93d1-48c6-8212-5bbd153bfe30' class='xr-section-summary-in' type='checkbox'  checked><label for='section-eeab316d-93d1-48c6-8212-5bbd153bfe30' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>428.0 450.0 450.0 ... 458.0 nan</div><input id='attrs-bd4c49ba-ee8b-49aa-98e4-24a5b32c1b20' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-bd4c49ba-ee8b-49aa-98e4-24a5b32c1b20' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-46e77099-880f-4bb7-ab82-9d7085fdf1e1' class='xr-var-data-in' type='checkbox'><label for='data-46e77099-880f-4bb7-ab82-9d7085fdf1e1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[428., 450., 450., 438., 438.,  nan,  nan,  nan],
       [402., 402., 402., 442., 442., 442., 442., 458.],
       [402., 402., 442., 442., 442., 442., 458.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>3.013e+03 2.809e+03 ... nan</div><input id='attrs-9c8e6099-6c3e-49cb-a540-6cd15931a5f8' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9c8e6099-6c3e-49cb-a540-6cd15931a5f8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-acde7159-41b6-4235-919e-062c780e61ae' class='xr-var-data-in' type='checkbox'><label for='data-acde7159-41b6-4235-919e-062c780e61ae' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[3013., 2809., 2809., 2730., 2730.,   nan,   nan,   nan],
       [2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.],
       [2565., 2565., 2522., 2522., 2522., 2522., 2496.,   nan]],
      dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>259.0 235.0 235.0 ... 265.0 nan</div><input id='attrs-522a7c8b-d269-40e1-b5ff-a9d8f5a5f24e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-522a7c8b-d269-40e1-b5ff-a9d8f5a5f24e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cefe9f56-d345-4bbf-8e64-2247af394928' class='xr-var-data-in' type='checkbox'><label for='data-cefe9f56-d345-4bbf-8e64-2247af394928' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[259., 235., 235., 231., 231.,  nan,  nan,  nan],
       [217., 217., 217., 230., 230., 230., 230., 265.],
       [217., 217., 230., 230., 230., 230., 265.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>563.0 541.0 541.0 ... 518.0 nan</div><input id='attrs-6c3066c4-2ded-44f9-89d2-c2780ba50e86' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6c3066c4-2ded-44f9-89d2-c2780ba50e86' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-db5792ea-920a-407f-bc7f-d8b9b32f7e1d' class='xr-var-data-in' type='checkbox'><label for='data-db5792ea-920a-407f-bc7f-d8b9b32f7e1d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[563., 541., 541., 528., 528.,  nan,  nan,  nan],
       [476., 476., 476., 476., 476., 476., 476., 518.],
       [476., 476., 476., 476., 476., 476., 518.,  nan]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>832.0 820.0 820.0 ... 804.0 nan</div><input id='attrs-c6ffe432-f2f7-41b7-b338-6f47ff5e7fb1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c6ffe432-f2f7-41b7-b338-6f47ff5e7fb1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b5a3f2ba-a438-4d9d-aa2b-81cfa1881e19' class='xr-var-data-in' type='checkbox'><label for='data-b5a3f2ba-a438-4d9d-aa2b-81cfa1881e19' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[832., 820., 820., 820., 820.,  nan,  nan,  nan],
       [715., 715., 715., 789., 789., 789., 789., 804.],
       [715., 715., 789., 789., 789., 789., 804.,  nan]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-f4524b94-cdfb-4cd3-bc0c-9c04da8c2dde' class='xr-section-summary-in' type='checkbox'  ><label for='section-f4524b94-cdfb-4cd3-bc0c-9c04da8c2dde' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-bf65c178-2098-4e06-ae5a-cfdf68ce47f4' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-bf65c178-2098-4e06-ae5a-cfdf68ce47f4' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 3</li><li><span class='xr-has-index'>x</span>: 8</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-ed808f9d-00a6-45fa-9c27-aab16708b26e' class='xr-section-summary-in' type='checkbox'  checked><label for='section-ed808f9d-00a6-45fa-9c27-aab16708b26e' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-fb7d6fbe-c620-4dc7-9143-5d515f7967c1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-fb7d6fbe-c620-4dc7-9143-5d515f7967c1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cb9c1ae8-4465-42c1-98b2-4e58d53af119' class='xr-var-data-in' type='checkbox'><label for='data-cb9c1ae8-4465-42c1-98b2-4e58d53af119' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.988e+06 ... -8.985e+06</div><input id='attrs-7fcf0c7c-72e0-4220-a7ce-daeb281c7c5f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7fcf0c7c-72e0-4220-a7ce-daeb281c7c5f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0c5d2a22-2e16-41b5-8cc9-80256ab38196' class='xr-var-data-in' type='checkbox'><label for='data-0c5d2a22-2e16-41b5-8cc9-80256ab38196' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8988498.356997, -8988035.04428 , -8987571.731564, -8987108.418847,
       -8986645.106131, -8986181.793414, -8985718.480698, -8985255.167981])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-05ce65a0-e99c-4adf-9d41-c8b178a6408d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-05ce65a0-e99c-4adf-9d41-c8b178a6408d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-425a9b31-202e-4bf2-9ad4-5a53114cbe7c' class='xr-var-data-in' type='checkbox'><label for='data-425a9b31-202e-4bf2-9ad4-5a53114cbe7c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-b49a2b71-d44b-4c59-ac91-53d40b284fab' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b49a2b71-d44b-4c59-ac91-53d40b284fab' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cb9ec282-a521-4d31-b99c-4d4dc17236a0' class='xr-var-data-in' type='checkbox'><label for='data-cb9ec282-a521-4d31-b99c-4d4dc17236a0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;unnamed&quot;,GEOGCS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,SPHEROID[&quot;Custom spheroid&quot;,6371007.181,0]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Sinusoidal&quot;],PARAMETER[&quot;longitude_of_center&quot;,0],PARAMETER[&quot;false_easting&quot;,0],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;Meter&quot;,1],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>-8988730.01335511 463.3127165277089 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-c0d6bd2e-5537-4b8e-960a-dac99bcbd3ad' class='xr-section-summary-in' type='checkbox'  checked><label for='section-c0d6bd2e-5537-4b8e-960a-dac99bcbd3ad' class='xr-section-summary' >Data variables: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>428.0 450.0 450.0 ... 458.0 458.0</div><input id='attrs-f479544b-31f1-49e6-b4f9-43087492fcd9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f479544b-31f1-49e6-b4f9-43087492fcd9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d5eeccc1-7285-423f-818e-921eeff5e273' class='xr-var-data-in' type='checkbox'><label for='data-d5eeccc1-7285-423f-818e-921eeff5e273' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[428., 450., 450., 438., 438., 421., 421., 409.],
       [402., 402., 402., 442., 442., 442., 442., 458.],
       [402., 402., 442., 442., 442., 442., 458., 458.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>3.013e+03 2.809e+03 ... 2.496e+03</div><input id='attrs-aab08698-d29d-44b9-8ece-c699505f60b2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aab08698-d29d-44b9-8ece-c699505f60b2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-33490079-d8a7-4ad2-812c-1779dddb7e29' class='xr-var-data-in' type='checkbox'><label for='data-33490079-d8a7-4ad2-812c-1779dddb7e29' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[3013., 2809., 2809., 2730., 2730., 2628., 2628., 2641.],
       [2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.],
       [2565., 2565., 2522., 2522., 2522., 2522., 2496., 2496.]],
      dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>259.0 235.0 235.0 ... 265.0 265.0</div><input id='attrs-b20d337f-0bae-4875-955b-a836b26be415' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b20d337f-0bae-4875-955b-a836b26be415' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9ddebbc1-84d0-41c4-8b58-6f9bc758f813' class='xr-var-data-in' type='checkbox'><label for='data-9ddebbc1-84d0-41c4-8b58-6f9bc758f813' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[259., 235., 235., 231., 231., 211., 211., 203.],
       [217., 217., 217., 230., 230., 230., 230., 265.],
       [217., 217., 230., 230., 230., 230., 265., 265.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>563.0 541.0 541.0 ... 518.0 518.0</div><input id='attrs-aa0bdbf7-0a2d-4060-8da1-0ec5b2b65b98' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aa0bdbf7-0a2d-4060-8da1-0ec5b2b65b98' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-525316f4-81a5-481a-90e9-7147dbd03b9f' class='xr-var-data-in' type='checkbox'><label for='data-525316f4-81a5-481a-90e9-7147dbd03b9f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[563., 541., 541., 528., 528., 494., 494., 486.],
       [476., 476., 476., 476., 476., 476., 476., 518.],
       [476., 476., 476., 476., 476., 476., 518., 518.]], dtype=float32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(y, x)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>832.0 820.0 820.0 ... 804.0 804.0</div><input id='attrs-2cc490a5-21fb-4205-aefc-37ac21985f35' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2cc490a5-21fb-4205-aefc-37ac21985f35' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-040a079a-b1b3-4f61-9baf-45d90de2afc9' class='xr-var-data-in' type='checkbox'><label for='data-040a079a-b1b3-4f61-9baf-45d90de2afc9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd></dl></div><div class='xr-var-data'><pre>array([[832., 820., 820., 820., 820., 749., 749., 715.],
       [715., 715., 715., 789., 789., 789., 789., 804.],
       [715., 715., 789., 789., 789., 789., 804., 804.]], dtype=float32)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-a5898fca-3c8a-468d-a6b4-361b1bd6e691' class='xr-section-summary-in' type='checkbox'  ><label for='section-a5898fca-3c8a-468d-a6b4-361b1bd6e691' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_61_0.png" alt = "Plot of each MODIS band in the numpy stack cropped to the cold springs fire extent, identical to the last plot showing this same thing.">
<figcaption>Plot of each MODIS band in the numpy stack cropped to the cold springs fire extent, identical to the last plot showing this same thing.</figcaption>

</figure>






