---
layout: single
title: "How to Download MACA2 Climate Data Using Python"
excerpt: "MACA V2 climate data provides but historica and future predictions of climate variables using different models. Learn how to download netcdf 4 format programatically using open source Python and open the data with xarray."
authors: ['Leah Wasser']
dateCreated: 2021-11-17
modified: 2021-11-18
category: [courses]
class-lesson: ['netcdf4']
permalink: /courses/use-data-open-source-python/hierarchical-data-formats-hdf/get-maca-2-climate-data-netcdf-python/
nav-title: 'Get MACA2 Data'
week: 6
course: "intermediate-earth-data-science-textbook"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['climate']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Open MACA v2 Climate data Programmatically using Open Source Python and Xarray

In this lesson, you will learn how to work with Climate Data Sets (MACA v2 for the Continental United States - CONUS) stored in netcdf 4 format using open source **Python**.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Download different types of MACA v2 climate data in `netcdf 4` format
* Open and process netcdf4 data using `xarray` 

</div>


## Get Started Downloading MACA v2 Climate Data in Python

To begin, load the libraries below.

{:.input}
```python
# Import packages
import numpy as np
import netCDF4
import matplotlib.pyplot as plt
import xarray as xr
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import seaborn as sns

# Plotting options
sns.set(font_scale=1.3)
sns.set_style("white")
```

## Get Started With Downloading Data

The data you are using is described as a "Monthly aggregation of downscaled daily meteorological data of Monthly Precipitation Amount from College of Global Change and Earth System Science, Beijing Normal University". In short, the data is monthly summary of lots of meteorological data, such as precipitation, air temperature, and more. The data are derived from a climate model that predicts future trendsin these variables over time. 

Below, you will assign three variables to choose which data you want to work with in this notebook. 

`model = ` can be set to any number between 0 and 19. You can see the list of models you are choosing from in the cell two below this one. The models are listed after `model_name = ` All of the models are different models for how the climate will change going into the future. There are 20 options for models, and to pick one you can assign `model = ` to any number between 0 and 19, where 0 is the first option in the list, and 19 is the last. 

<a href="https://climate.northwestknowledge.net/MACA/GCMs.php" target="_blank">You can learn more about the various model options by clicking here</a>

`var = ` is the variable in the dataset you want to be analyzed. You can see the variables in the cell two below this one. The variables are listed after `var_long_name = `. The variables are as described by the variable name, so `air_temperature` is the aggregate air temperature for each month, for example. There are 9 options for variables, and to pick one you can assign `var = ` to any number between 0 and 8, where 0 is the first option in the list, and 8 is the last. 

Lastly, `scenario = ` can be chosen to pick which climate scenario you want to pull your data from. `0` is the historical data and doesn't include any modeling. `1` is the `rcp45` scenario, which is described as an intermediate climate scenario. `2` is the `rcp85` scenario, which is a worst case climate scenario. 

<i class="fa fa-star"></i> **Data Tip:** <a href="https://climate.northwestknowledge.net/NWTOOLBOX/mapping.php" target="_blank">You can learn more about the various variables  and scenario options by going to the toolbox and clicking on the small yellow question mark next to "variable" or "scenario"</a>. Note that the scenario options are only available when you try to download future predicted data. 
{: .notice--success }

## Select Data Download Options

Below you select the options that you wish to use to download your data. 


{:.input}
```python
# Model options between 0-19
model = 2
# Options 0-8 will work for var. Var maps to the variable name below
var = 0
# Options range from 0-2
scenario = 2
```

{:.input}
```python
# This is the base url required to download data from the thredds server.
dir_path = 'http://thredds.northwestknowledge.net:8080/thredds/dodsC/'

# These are the variable options for the met data
variable_name = ('tasmax',
                 'tasmin',
                 'rhsmax',
                 'rhsmin',
                 'pr',
                 'rsds',
                 'uas',
                 'vas',
                 'huss')

# These are var options in long form
var_long_name = ('air_temperature',
                 'air_temperature',
                 'relative_humidity',
                 'relative_humidity',
                 'precipitation',
                 'surface_downwelling_shortwave_flux_in_air',
                 'eastward_wind',
                 'northward_wind',
                 'specific_humidity')

# Models to chose from
model_name = ('bcc-csm1-1',
              'bcc-csm1-1-m',
              'BNU-ESM',
              'CanESM2',
              'CCSM4',
              'CNRM-CM5',
              'CSIRO-Mk3-6-0',
              'GFDL-ESM2G',
              'GFDL-ESM2M',
              'HadGEM2-CC365',
              'HadGEM2-ES365',
              'inmcm4',
              'IPSL-CM5A-MR',
              'IPSL-CM5A-LR',
              'IPSL-CM5B-LR',
              'MIROC5',
              'MIROC-ESM',
              'MIROC-ESM-CHEM',
              'MRI-CGCM3',
              'NorESM1-M')

# Scenarios
scenario_type = ('historical', 'rcp45', 'rcp85')

# Year start and ends (historical vs projected)
year_start = ('1950', '2006', '2006')
year_end = ('2005', '2099', '2099')
run_num = [1] * 20
run_num[4] = 6  # setting CCSM4 with run 6
domain = 'CONUS'
```

{:.input}
```python

try:
    time = year_start[scenario]+'_' + year_end[scenario]
    print("\u2705 Your selected time period is:", time)
except IndexError as e:
    raise IndexError("Oops, it looks like you selected a scenario value that is \
                     not within the range of values which is 0-2")
    

```

{:.output}
    ✅ Your selected time period is: 2006_2099



Below you use the options selected above to create a path to the correct MACA 
data. The file name `agg_macav2metdata_` represents monthly data. You will
use that data for this lesson because it will be a smaller file size to 
download. 

# TODO: add a list of options for various downloads including daily??

{:.input}
```python
# This is only going to provide monthly data
file_name = ('agg_macav2metdata_' +
             str(variable_name[var]) +
             '_' +
             str(model_name[model]) +
             '_r' +
             str(run_num[model])+'i1p1_' +
             str(scenario_type[scenario]) +
             '_' +
             time + '_' +
             domain + '_monthly.nc')

print("\u2705 You are accessing:\n", file_name, "\n data in netcdf format")
```

{:.output}
    ✅ You are accessing:
     agg_macav2metdata_tasmax_BNU-ESM_r1i1p1_rcp85_2006_2099_CONUS_monthly.nc 
     data in netcdf format



{:.input}
```python
full_file_path = dir_path + file_name
print("The full path to your data is: \n", full_file_path)
```

{:.output}
    The full path to your data is: 
     http://thredds.northwestknowledge.net:8080/thredds/dodsC/agg_macav2metdata_tasmax_BNU-ESM_r1i1p1_rcp85_2006_2099_CONUS_monthly.nc



## Open Your Data

Below you open your data with xarray. We have wrapped the open statement in a 
try/except block to ensure that it fails gracefully. 


{:.input}
```python
# Open the data from the thredds server
try:
    with xr.open_dataset(full_file_path) as file_nc:
        max_temp_xr = file_nc

except OSError as oe:
    print("Oops, it looks like the file that you are trying to connect to, {}, doesn't exist. Try to revisit your model options to ensure the data exist on the server.  ".format(full_file_path))
```

{:.input}
```python
max_temp_xr
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
Dimensions:          (lat: 585, crs: 1, lon: 1386, time: 1128)
Coordinates:
  * lat              (lat) float64 25.06 25.1 25.15 25.19 ... 49.31 49.35 49.4
  * crs              (crs) int32 1
  * lon              (lon) float64 235.2 235.3 235.3 235.4 ... 292.9 292.9 292.9
  * time             (time) object 2006-01-15 00:00:00 ... 2099-12-15 00:00:00
Data variables:
    air_temperature  (time, lat, lon) float32 ...
Attributes: (12/46)
    description:                     Multivariate Adaptive Constructed Analog...
    id:                              MACAv2-METDATA
    naming_authority:                edu.uidaho.reacch
    Metadata_Conventions:            Unidata Dataset Discovery v1.0
    Metadata_Link:                   
    cdm_data_type:                   FLOAT
    ...                              ...
    contributor_role:                Postdoctoral Fellow
    publisher_name:                  REACCH
    publisher_email:                 reacch@uidaho.edu
    publisher_url:                   http://www.reacchpna.org/
    license:                         Creative Commons CC0 1.0 Universal Dedic...
    coordinate_system:               WGS84,EPSG:4326</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-dcf9a297-274e-4d4e-bd31-d24afbde9633' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-dcf9a297-274e-4d4e-bd31-d24afbde9633' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>lat</span>: 585</li><li><span class='xr-has-index'>crs</span>: 1</li><li><span class='xr-has-index'>lon</span>: 1386</li><li><span class='xr-has-index'>time</span>: 1128</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-dfa73bc1-4fbe-4a18-9d69-dbc48738a4ca' class='xr-section-summary-in' type='checkbox'  checked><label for='section-dfa73bc1-4fbe-4a18-9d69-dbc48738a4ca' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lat</span></div><div class='xr-var-dims'>(lat)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>25.06 25.1 25.15 ... 49.35 49.4</div><input id='attrs-cbb40227-b256-4bd6-82bd-fe7b552eca5b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-cbb40227-b256-4bd6-82bd-fe7b552eca5b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0dbf9f94-f87b-4954-8f69-daa391d4f9f4' class='xr-var-data-in' type='checkbox'><label for='data-0dbf9f94-f87b-4954-8f69-daa391d4f9f4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array([25.063078, 25.104744, 25.14641 , ..., 49.312691, 49.354359, 49.396023])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>crs</span></div><div class='xr-var-dims'>(crs)</div><div class='xr-var-dtype'>int32</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-09da2e08-f108-45f5-a119-1fecb2386bce' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-09da2e08-f108-45f5-a119-1fecb2386bce' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0544f1c9-1a84-493c-b2bc-4a3a7e13153e' class='xr-var-data-in' type='checkbox'><label for='data-0544f1c9-1a84-493c-b2bc-4a3a7e13153e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>grid_mapping_name :</span></dt><dd>latitude_longitude</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd></dl></div><div class='xr-var-data'><pre>array([1], dtype=int32)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>lon</span></div><div class='xr-var-dims'>(lon)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>235.2 235.3 235.3 ... 292.9 292.9</div><input id='attrs-c671994e-d066-40c9-8e3d-49e9881fb884' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c671994e-d066-40c9-8e3d-49e9881fb884' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d5558b98-4bbc-44e5-8605-e9b4c29c30cf' class='xr-var-data-in' type='checkbox'><label for='data-d5558b98-4bbc-44e5-8605-e9b4c29c30cf' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array([235.227844, 235.269501, 235.311157, ..., 292.851929, 292.893585,
       292.935242])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2006-01-15 00:00:00 ... 2099-12-...</div><input id='attrs-4c3721c9-6df5-4a3d-b4b7-ad96860c7775' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4c3721c9-6df5-4a3d-b4b7-ad96860c7775' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3c8eb12f-d8d8-4110-81b1-baf215103fff' class='xr-var-data-in' type='checkbox'><label for='data-3c8eb12f-d8d8-4110-81b1-baf215103fff' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2006, 1, 15, 0, 0, 0, 0, has_year_zero=True),
       cftime.DatetimeNoLeap(2006, 2, 15, 0, 0, 0, 0, has_year_zero=True),
       cftime.DatetimeNoLeap(2006, 3, 15, 0, 0, 0, 0, has_year_zero=True), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0, has_year_zero=True),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0, has_year_zero=True),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0, has_year_zero=True)],
      dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-fc73d88a-b3d2-49f1-b083-93f325dc9bf3' class='xr-section-summary-in' type='checkbox'  checked><label for='section-fc73d88a-b3d2-49f1-b083-93f325dc9bf3' class='xr-section-summary' >Data variables: <span>(1)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>air_temperature</span></div><div class='xr-var-dims'>(time, lat, lon)</div><div class='xr-var-dtype'>float32</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-5721520f-4513-497a-b037-9d15d4611bf8' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5721520f-4513-497a-b037-9d15d4611bf8' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0c074420-678a-4599-87c5-dde270a2cf79' class='xr-var-data-in' type='checkbox'><label for='data-0c074420-678a-4599-87c5-dde270a2cf79' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div><div class='xr-var-data'><pre>[914593680 values with dtype=float32]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-b04415bf-ce0f-4801-9cfc-68a58028a382' class='xr-section-summary-in' type='checkbox'  ><label for='section-b04415bf-ce0f-4801-9cfc-68a58028a382' class='xr-section-summary' >Attributes: <span>(46)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>Multivariate Adaptive Constructed Analogs (MACA) method, version 2.3,Dec 2013.</dd><dt><span>id :</span></dt><dd>MACAv2-METDATA</dd><dt><span>naming_authority :</span></dt><dd>edu.uidaho.reacch</dd><dt><span>Metadata_Conventions :</span></dt><dd>Unidata Dataset Discovery v1.0</dd><dt><span>Metadata_Link :</span></dt><dd></dd><dt><span>cdm_data_type :</span></dt><dd>FLOAT</dd><dt><span>title :</span></dt><dd>Monthly aggregation of downscaled daily meteorological data of Monthly Average of Daily Maximum Near-Surface Air Temperature from College of Global Change and Earth System Science, Beijing Normal University (BNU-ESM) using the run r1i1p1 of the rcp85 scenario.</dd><dt><span>summary :</span></dt><dd>This archive contains monthly downscaled meteorological and hydrological projections for the Conterminous United States at 1/24-deg resolution. These monthly values are obtained by aggregating the daily values obtained from the downscaling using the Multivariate Adaptive Constructed Analogs (MACA, Abatzoglou, 2012) statistical downscaling method with the METDATA (Abatzoglou,2013) training dataset. The downscaled meteorological variables are maximum/minimum temperature(tasmax/tasmin), maximum/minimum relative humidity (rhsmax/rhsmin),precipitation amount(pr), downward shortwave solar radiation(rsds), eastward wind(uas), northward wind(vas), and specific humidity(huss). The downscaling is based on the 365-day model outputs from different global climate models (GCMs) from Phase 5 of the Coupled Model Inter-comparison Project (CMIP3) utlizing the historical (1950-2005) and future RCP4.5/8.5(2006-2099) scenarios. </dd><dt><span>keywords :</span></dt><dd>monthly, precipitation, maximum temperature, minimum temperature, downward shortwave solar radiation, specific humidity, wind velocity, CMIP5, Gridded Meteorological Data</dd><dt><span>keywords_vocabulary :</span></dt><dd></dd><dt><span>standard_name_vocabulary :</span></dt><dd>CF-1.0</dd><dt><span>history :</span></dt><dd>No revisions.</dd><dt><span>comment :</span></dt><dd></dd><dt><span>geospatial_bounds :</span></dt><dd>POLYGON((-124.7722 25.0631,-124.7722 49.3960, -67.0648 49.3960,-67.0648, 25.0631, -124.7722,25.0631))</dd><dt><span>geospatial_lat_min :</span></dt><dd>25.0631</dd><dt><span>geospatial_lat_max :</span></dt><dd>49.3960</dd><dt><span>geospatial_lon_min :</span></dt><dd>-124.7722</dd><dt><span>geospatial_lon_max :</span></dt><dd>-67.0648</dd><dt><span>geospatial_lat_units :</span></dt><dd>decimal degrees north</dd><dt><span>geospatial_lon_units :</span></dt><dd>decimal degrees east</dd><dt><span>geospatial_lat_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_lon_resolution :</span></dt><dd>0.0417</dd><dt><span>geospatial_vertical_min :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_max :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_resolution :</span></dt><dd>0.0</dd><dt><span>geospatial_vertical_positive :</span></dt><dd>up</dd><dt><span>time_coverage_start :</span></dt><dd>2091-01-01T00:0</dd><dt><span>time_coverage_end :</span></dt><dd>2095-12-31T00:00</dd><dt><span>time_coverage_duration :</span></dt><dd>P5Y</dd><dt><span>time_coverage_resolution :</span></dt><dd>P1M</dd><dt><span>date_created :</span></dt><dd>2014-05-15</dd><dt><span>date_modified :</span></dt><dd>2014-05-15</dd><dt><span>date_issued :</span></dt><dd>2014-05-15</dd><dt><span>creator_name :</span></dt><dd>John Abatzoglou</dd><dt><span>creator_url :</span></dt><dd>http://maca.northwestknowledge.net</dd><dt><span>creator_email :</span></dt><dd>jabatzoglou@uidaho.edu</dd><dt><span>institution :</span></dt><dd>University of Idaho</dd><dt><span>processing_level :</span></dt><dd>GRID</dd><dt><span>project :</span></dt><dd></dd><dt><span>contributor_name :</span></dt><dd>Katherine C. Hegewisch</dd><dt><span>contributor_role :</span></dt><dd>Postdoctoral Fellow</dd><dt><span>publisher_name :</span></dt><dd>REACCH</dd><dt><span>publisher_email :</span></dt><dd>reacch@uidaho.edu</dd><dt><span>publisher_url :</span></dt><dd>http://www.reacchpna.org/</dd><dt><span>license :</span></dt><dd>Creative Commons CC0 1.0 Universal Dedication(http://creativecommons.org/publicdomain/zero/1.0/legalcode)</dd><dt><span>coordinate_system :</span></dt><dd>WGS84,EPSG:4326</dd></dl></div></li></ul></div></div>





## Challenge 3 - Subset Your Data

Currently, the dataset you have is too big to work with. You can fix this by subsetting the data! There are two ways you can subset the data: spatially, and temporally. 

To spatially subset the data, you will only look at data from one point in the xarray Dataset. Below, assign a new number for `latitude` and `longitude` to pick a new point. The data's latitude values range from about 25 to 50, and the data's longitude values range from 235 to 292. So try and pick new values within those ranges.

To temporally subset the data, you can pick a start date and end date to trim the data to. Below, assign new values for the data to start and end at. Make sure the values you assign stay in the quotes provided. The format should be `'yyyy-mm'`. Keep in mind that depending on which scenario you chose above, the years of your data will be different. So pick dates that are within the scenario you chose!

|Scenario Number|Date Range|
|-------|-----------|
|0|1950-2005|
|1|2006-2099|
|2|2006-2099|

{:.input}
```python
# Select the latitude, longitude, and timeframe to subset the data to

# Ensure your latitude value is between 25 and 50, and your longitude value is between 235 and 292
# latitude = 35
# longitude = 270
start_date = '2008-01'
end_date = '2012-09'
```

{:.input}
```python
# Select a lat / lon location that you wish to use to extract the data
latitude = max_temp_xr.lat.values[300]
longitude = max_temp_xr.lon.values[150]
print("You selected the following x,y location:", longitude, latitude)
```

{:.output}
    You selected the following x,y location: 241.4777374267578 37.5628776550293



{:.input}
```python
# Slice one lat/lon data point
temp_single_point = max_temp_xr["air_temperature"].sel(
    lat=latitude,
    lon=longitude)

temp_single_point
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;air_temperature&#x27; (time: 1128)&gt;
array([282.93192, 285.54318, 291.04315, ..., 301.6674 , 290.809  , 288.78992],
      dtype=float32)
Coordinates:
    lat      float64 37.56
    lon      float64 241.5
  * time     (time) object 2006-01-15 00:00:00 ... 2099-12-15 00:00:00
Attributes:
    long_name:      Monthly Average of Daily Maximum Near-Surface Air Tempera...
    units:          K
    grid_mapping:   crs
    standard_name:  air_temperature
    height:         2 m
    cell_methods:   time: maximum(interval: 24 hours);mean over days
    _ChunkSizes:    [ 10  44 107]</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'air_temperature'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 1128</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-1ec9edc6-7990-470f-9793-166f7a22a63f' class='xr-array-in' type='checkbox' checked><label for='section-1ec9edc6-7990-470f-9793-166f7a22a63f' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>282.9 285.5 291.0 290.9 292.2 298.0 ... 308.8 306.6 301.7 290.8 288.8</span></div><div class='xr-array-data'><pre>array([282.93192, 285.54318, 291.04315, ..., 301.6674 , 290.809  , 288.78992],
      dtype=float32)</pre></div></div></li><li class='xr-section-item'><input id='section-6ad267e4-38ce-4212-921e-53aa1c67321e' class='xr-section-summary-in' type='checkbox'  checked><label for='section-6ad267e4-38ce-4212-921e-53aa1c67321e' class='xr-section-summary' >Coordinates: <span>(3)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>lat</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>37.56</div><input id='attrs-792a1f97-ffb7-48c3-8a79-0ae0540a7f6e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-792a1f97-ffb7-48c3-8a79-0ae0540a7f6e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-100a049c-7e8a-44b5-bf47-c39d5ededf81' class='xr-var-data-in' type='checkbox'><label for='data-100a049c-7e8a-44b5-bf47-c39d5ededf81' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>latitude</dd><dt><span>standard_name :</span></dt><dd>latitude</dd><dt><span>units :</span></dt><dd>degrees_north</dd><dt><span>axis :</span></dt><dd>Y</dd><dt><span>description :</span></dt><dd>Latitude of the center of the grid cell</dd></dl></div><div class='xr-var-data'><pre>array(37.56287766)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>lon</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>241.5</div><input id='attrs-e74809c0-53b5-4d6a-9245-25927c385f92' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e74809c0-53b5-4d6a-9245-25927c385f92' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3635bfea-57ef-4486-8c8c-faf8142912b1' class='xr-var-data-in' type='checkbox'><label for='data-3635bfea-57ef-4486-8c8c-faf8142912b1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>units :</span></dt><dd>degrees_east</dd><dt><span>axis :</span></dt><dd>X</dd><dt><span>description :</span></dt><dd>Longitude of the center of the grid cell</dd><dt><span>long_name :</span></dt><dd>longitude</dd><dt><span>standard_name :</span></dt><dd>longitude</dd></dl></div><div class='xr-var-data'><pre>array(241.47773743)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>object</div><div class='xr-var-preview xr-preview'>2006-01-15 00:00:00 ... 2099-12-...</div><input id='attrs-4f1629e2-db18-486e-9114-8295015f6511' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4f1629e2-db18-486e-9114-8295015f6511' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-33a3c178-a63f-4044-a8d0-af501fb389da' class='xr-var-data-in' type='checkbox'><label for='data-33a3c178-a63f-4044-a8d0-af501fb389da' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>description :</span></dt><dd>days since 1900-01-01</dd></dl></div><div class='xr-var-data'><pre>array([cftime.DatetimeNoLeap(2006, 1, 15, 0, 0, 0, 0, has_year_zero=True),
       cftime.DatetimeNoLeap(2006, 2, 15, 0, 0, 0, 0, has_year_zero=True),
       cftime.DatetimeNoLeap(2006, 3, 15, 0, 0, 0, 0, has_year_zero=True), ...,
       cftime.DatetimeNoLeap(2099, 10, 15, 0, 0, 0, 0, has_year_zero=True),
       cftime.DatetimeNoLeap(2099, 11, 15, 0, 0, 0, 0, has_year_zero=True),
       cftime.DatetimeNoLeap(2099, 12, 15, 0, 0, 0, 0, has_year_zero=True)],
      dtype=object)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-39baae91-1846-47bb-9e0c-d4f8e9d2f74c' class='xr-section-summary-in' type='checkbox'  checked><label for='section-39baae91-1846-47bb-9e0c-d4f8e9d2f74c' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>long_name :</span></dt><dd>Monthly Average of Daily Maximum Near-Surface Air Temperature</dd><dt><span>units :</span></dt><dd>K</dd><dt><span>grid_mapping :</span></dt><dd>crs</dd><dt><span>standard_name :</span></dt><dd>air_temperature</dd><dt><span>height :</span></dt><dd>2 m</dd><dt><span>cell_methods :</span></dt><dd>time: maximum(interval: 24 hours);mean over days</dd><dt><span>_ChunkSizes :</span></dt><dd>[ 10  44 107]</dd></dl></div></li></ul></div></div>





{:.input}
```python
temp_single_point.plot.line()
```

{:.output}
{:.execute_result}



    [<matplotlib.lines.Line2D at 0x7fce8a2dc820>]





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-get-climate-data/2020-10-16-netcdf-03-get-climate-data_17_1.png">

</figure>




{:.input}
```python
# THIS ISN"T WORKING - WHY?
# Slice the data to the specific time period
max_var_point = temp_single_point.sel(time=slice(start_date, end_date))
```

{:.input}
```python
# Notice the x axis represents a shorter time period
max_var_point.plot.line()
```

{:.output}
{:.execute_result}



    [<matplotlib.lines.Line2D at 0x7fce8a185f10>]





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-get-climate-data/2020-10-16-netcdf-03-get-climate-data_19_1.png">

</figure>




Below is a plot that shows where the latitude and longitude you selected are, and where the data in the rest notebook will be pulled from!

{:.input}
```python
extent = [-120, -70, 24, 50.5]
central_lon = np.mean(extent[:2])
central_lat = np.mean(extent[2:])

f, ax = plt.subplots(figsize=(12, 6),
                     subplot_kw={'projection': ccrs.AlbersEqualArea(central_lon, central_lat)})
ax.coastlines()
ax.set_extent(extent)
ax.plot(longitude, latitude,
        markersize=12,
        marker='*',
        color='purple')
ax.set(title="Location of the lat / lon Being Used To to Slice Your netcdf Climate Data File")

# Adds a bunch of elements to the map
ax.add_feature(cfeature.LAND, edgecolor='black')

ax.gridlines()
plt.show()
```

{:.output}
    /opt/conda/envs/EDS/lib/python3.8/site-packages/cartopy/io/__init__.py:241: DownloadWarning: Downloading: https://naturalearth.s3.amazonaws.com/50m_physical/ne_50m_land.zip
      warnings.warn(f'Downloading: {url}', DownloadWarning)
    /opt/conda/envs/EDS/lib/python3.8/site-packages/cartopy/io/__init__.py:241: DownloadWarning: Downloading: https://naturalearth.s3.amazonaws.com/50m_physical/ne_50m_coastline.zip
      warnings.warn(f'Downloading: {url}', DownloadWarning)



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-get-climate-data/2020-10-16-netcdf-03-get-climate-data_21_1.png">

</figure>




## Challenge 4 - Modify your plot

With the newly subset data being more reasonable in size, you can now plot the data! Below is the code you use to plot a line showing the change in the variable you selected at the top over time. 

There are a few aspects of the plot that you can modify to make the plot even better. First, you can change the title, xlabel, and ylabel by modifying the code seen here: 

```
ax.set(title="Modify this text to change the title!", 

       xlabel="Modify this text to change the x axis label!",
       
       ylabel="Modify this text to change the y axis label!")
```

Make sure when you change the names of those variables, that you keep the new title or axis label within the quotes already there.

You can also change the color of the plot by changing these variables colors listed after `color=`, `markerfacecolor=`, and `markeredgecolor=`. Change those to colors you think fit the plot better and see what changes! When you change them to a new color, make sure the new color is still within the quotes provided. 

{:.input}
```python
# Plotting the subset data
fig, ax = plt.subplots(figsize=(12, 6))
max_var_point.plot.line(ax=ax,
                        marker="o",
                        # Change the line color
                        color="orange",
                        # Change both variables below to change the color of the markers
                        markerfacecolor="black",
                        markeredgecolor="black")

# Change the values below to match the data you selected
ax.set(title="Modify this text to change the title!",
       xlabel="Modify this text to change the x axis label!",
       ylabel="Modify this text to change the y axis label!")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/03-netcdf/2020-10-16-netcdf-03-get-climate-data/2020-10-16-netcdf-03-get-climate-data_23_0.png">

</figure>




## Challenge 5  - Export your data to a csv file

This subset data is worth sharing! Below you will export the data to a `.csv` file. 

{:.input}
```python
# Changing your data to a numpy dataframe to make it exportable
max_var_point_df = max_var_point.to_dataframe()
max_var_point_df.head()
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
      <th>lat</th>
      <th>lon</th>
      <th>air_temperature</th>
    </tr>
    <tr>
      <th>time</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2008-01-15 00:00:00</th>
      <td>37.562878</td>
      <td>241.477737</td>
      <td>281.641693</td>
    </tr>
    <tr>
      <th>2008-02-15 00:00:00</th>
      <td>37.562878</td>
      <td>241.477737</td>
      <td>287.855652</td>
    </tr>
    <tr>
      <th>2008-03-15 00:00:00</th>
      <td>37.562878</td>
      <td>241.477737</td>
      <td>285.143585</td>
    </tr>
    <tr>
      <th>2008-04-15 00:00:00</th>
      <td>37.562878</td>
      <td>241.477737</td>
      <td>288.578522</td>
    </tr>
    <tr>
      <th>2008-05-15 00:00:00</th>
      <td>37.562878</td>
      <td>241.477737</td>
      <td>297.690033</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Creating a file name based on the variables you chose earlier!
# The name should be the variable you chose, and then the start and end date of the subset
file_name = var_long_name[var] + "-" + start_date + "-" + end_date + ".csv"
file_name
```

{:.output}
{:.execute_result}



    'air_temperature-2008-01-2012-09.csv'





{:.input}
```python
# Export to a csv file to share with your friends!
max_var_point_df.to_csv(file_name)
```
