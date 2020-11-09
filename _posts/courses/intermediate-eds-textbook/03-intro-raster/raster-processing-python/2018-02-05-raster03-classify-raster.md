---
layout: single
title: "Classify and Plot Raster Data in Python"
excerpt: "Reclassifying raster data allows you to use a set of defined values to organize pixel values into new bins or categories. Learn how to classify a raster dataset and export it as a new raster in Python."
authors: ['Leah Wasser', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2018-02-05
modified: 2020-11-09
category: [courses]
class-lesson: ['raster-processing-python']
permalink: /courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/classify-plot-raster-data-in-python/
nav-title: 'Classify and Plot Raster'
week: 3
course: 'intermediate-earth-data-science-textbook'
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-raster-data/classify-plot-raster-data-in-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Explore a raster and produce histograms to help define appropriate raster break points for classification.
* Reclassify a raster dataset in **Python** using a set of defined values and `np.digitize`. 

</div>

### Manually Reclassify Raster Data 

In this lesson, you will learn how to reclassify a raster dataset in **Python**. When you reclassify
a raster, you create a **new** raster object / file that can be exported and shared with colleagues and / or open in other tools such as QGIS. 

In that raster, each pixel is mapped to a new value based on some approach. This approach can vary depending upon your science question.


<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/reclass-raster-esri.gif">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/reclass-raster-esri.gif" alt="Example of reclassification process from ESRI."></a>
    <figcaption> When you reclassify a raster, you create a new raster. In that raster, each cell from the old raster is mapped to the new raster. The values in the new raster are applied using a defined range of values or a raster map. For example above you can see that all cells that
contains the values 1-3 are assigned the new value of 5. <a href="http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/geoprocessing_with_3d_analyst/Reclass_Reclass2.gif">Source: ESRI</a>
    </figcaption>
</figure>

## Raster Classification Steps

You can break your raster processing workflow into several steps as follows:

* **Data import / cleanup:** load and "clean" the data. This includes cropping, removing with `nodata` values
* **Data Exploration:** understand the range and distribution of values in your data. This may involve plotting histograms and scatter plots to determine what classes are appropriate for our data
* **Reclassify the Data:** Once you understand the distribution of your data, you are ready to reclassify. There are statistical and non-statistical approaches to reclassification. Here you will learn how to manually reclassify a raster using bins that you define in your data exploration step. 

Please note - working with data is not a linear process. Above you see a potential workflow. You will develop your own workflow and approach.  

To get started, first load the required libraries and then open up your raster. In this case, you are using the lidar canopy height model (CHM) that you calculated in the previous lesson.


{:.input}
```python
import os

import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, BoundaryNorm
import numpy as np
import xarray as xr
import rioxarray as rxr
import earthpy as et
import earthpy.plot as ep

# Prettier plotting with seaborn
import seaborn as sns
sns.set(font_scale=1.5, style="whitegrid")

# Get data and set working directory
et.data.get_data("colorado-flood")
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



To begin, open the `lidar_chm.tif` file that you created in the previous lesson, or recreate it using the code below.


{:.input}
```python
# Define relative paths to DTM and DSM files
dtm_path = os.path.join("colorado-flood",
                        "spatial",
                        "boulder-leehill-rd",
                        "pre-flood",
                        "lidar",
                        "pre_DTM.tif")

dsm_path = os.path.join("colorado-flood",
                        "spatial",
                        "boulder-leehill-rd",
                        "pre-flood",
                        "lidar",
                        "pre_DSM.tif")

# Open DTM and DSM files
pre_lidar_dtm = rxr.open_rasterio(dtm_path, masked=True).squeeze()
pre_lidar_dsm = rxr.open_rasterio(dsm_path, masked=True).squeeze()

# Create canopy height model (CHM)
pre_lidar_chm = pre_lidar_dsm - pre_lidar_dtm
pre_lidar_chm
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (y: 2000, x: 4000)&gt;
array([[       nan,        nan,        nan, ..., 0.        , 0.17004395,
        0.96008301],
       [       nan,        nan,        nan, ..., 0.        , 0.09008789,
        1.64001465],
       [       nan,        nan,        nan, ..., 0.        , 0.        ,
        0.07995605],
       ...,
       [       nan,        nan,        nan, ..., 0.        , 0.        ,
        0.        ],
       [       nan,        nan,        nan, ..., 0.        , 0.        ,
        0.        ],
       [       nan,        nan,        nan, ..., 0.        , 0.        ,
        0.        ]])
Coordinates:
    band         int64 1
  * y            (y) float64 4.436e+06 4.436e+06 ... 4.434e+06 4.434e+06
  * x            (x) float64 4.72e+05 4.72e+05 4.72e+05 ... 4.76e+05 4.76e+05
    spatial_ref  int64 0</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2000</li><li><span class='xr-has-index'>x</span>: 4000</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-8d641739-777d-455c-ab60-a15fb2bba80f' class='xr-array-in' type='checkbox' checked><label for='section-8d641739-777d-455c-ab60-a15fb2bba80f' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0</span></div><div class='xr-array-data'><pre>array([[       nan,        nan,        nan, ..., 0.        , 0.17004395,
        0.96008301],
       [       nan,        nan,        nan, ..., 0.        , 0.09008789,
        1.64001465],
       [       nan,        nan,        nan, ..., 0.        , 0.        ,
        0.07995605],
       ...,
       [       nan,        nan,        nan, ..., 0.        , 0.        ,
        0.        ],
       [       nan,        nan,        nan, ..., 0.        , 0.        ,
        0.        ],
       [       nan,        nan,        nan, ..., 0.        , 0.        ,
        0.        ]])</pre></div></div></li><li class='xr-section-item'><input id='section-85e90a76-e485-49b5-a9ee-d195357372aa' class='xr-section-summary-in' type='checkbox'  checked><label for='section-85e90a76-e485-49b5-a9ee-d195357372aa' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-6080786b-bde7-42c9-a86d-1b0204f4a710' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6080786b-bde7-42c9-a86d-1b0204f4a710' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b50cd26d-de75-4f7b-b8d0-0bc52bdf59a9' class='xr-var-data-in' type='checkbox'><label for='data-b50cd26d-de75-4f7b-b8d0-0bc52bdf59a9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.436e+06 4.436e+06 ... 4.434e+06</div><input id='attrs-5a62a0f2-a934-4f0a-8aac-8c6ed9233fed' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-5a62a0f2-a934-4f0a-8aac-8c6ed9233fed' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8ce6bd97-8eb2-4454-8ad0-ad9c38f396f8' class='xr-var-data-in' type='checkbox'><label for='data-8ce6bd97-8eb2-4454-8ad0-ad9c38f396f8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4435999.5, 4435998.5, 4435997.5, ..., 4434002.5, 4434001.5, 4434000.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.72e+05 4.72e+05 ... 4.76e+05</div><input id='attrs-9b989e0b-2a02-4fa3-b0e2-a4d533b176c7' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-9b989e0b-2a02-4fa3-b0e2-a4d533b176c7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0cfa3f34-eefc-467f-83ba-3d019d28aa68' class='xr-var-data-in' type='checkbox'><label for='data-0cfa3f34-eefc-467f-83ba-3d019d28aa68' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([472000.5, 472001.5, 472002.5, ..., 475997.5, 475998.5, 475999.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-958f75cb-e662-4449-8936-6a2841a5061a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-958f75cb-e662-4449-8936-6a2841a5061a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ee8a4c35-ae35-4753-928a-b81c9390e2fe' class='xr-var-data-in' type='checkbox'><label for='data-ee8a4c35-ae35-4753-928a-b81c9390e2fe' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>GeoTransform :</span></dt><dd>472000.0 1.0 0.0 4436000.0 0.0 -1.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-1f965a08-307c-4f0f-9503-7eb7980a11aa' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-1f965a08-307c-4f0f-9503-7eb7980a11aa' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>






### What Classification Values to Use?

There are many different approaches to classification. Some use highly sophisticated spatial algorithms that identify patterns in the data that can in turn be used to classify particular pixels into particular "classes". 

In this case, you are simply going to create the classes manually using the range of quantitative values found in our data.

Assuming that our data represent trees (though you know there are likely some buildings in the data), classify your raster into 3 classes:

* Short trees
* Medium trees
* Tall trees

To perform this classification, you need to understand which values represent short trees vs medium trees vs tall trees in your raster. This is where histograms can be extremely useful.

Start by looking at the min and max values in your CHM.

{:.input}
```python
# View min and max values in the data
print('CHM min value:', np.nanmin(pre_lidar_chm))
print('CHM max value:', np.nanmax(pre_lidar_chm))
```

{:.output}
    CHM min value: 0.0
    CHM max value: 26.9300537109375



### Get to Know Raster Summary Statistics 

Get to know your data by looking at a histogram. A histogram quantifies
the distribution of values found in your data.

{:.input}
```python
f, ax = plt.subplots()
pre_lidar_chm.plot.hist(color="purple")
ax.set(title="Distribution of Raster Cell Values in the CHM Data",
       xlabel="Height (m)",
       ylabel="Number of Pixels")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_12_0.png" alt = "Histogram of Canopy Height Model values.">
<figcaption>Histogram of Canopy Height Model values.</figcaption>

</figure>






### Explore Raster Histograms

Further explore your histogram, by constraining the x axis limits using the `xlim` and `ylim` parameters. 

These lim parameters visually zooms in on the data in the plot. It does not modify the data.

You might also chose to adjust the number of bins in your plot. Below you plot a bin for each increment on the x axis calculated using:

`hist_range(*xlim)`

You could also set `bins = 100` or some other value if you wish.


You can look at the values that **Python** used to draw your histogram, too. 

To do this, you can collect the outputs that are returned when you call `np.histogram`. This consists of two things:

* `counts`, which represents the number of items in each bin
* `bins`, which represents the edges of the bins (there will be one extra item in bins compared to counts)

Each bin represents a bar on your histogram plot. Each bar represents the frequency or number of pixels that have a value within that bin. 

Notice that you have adjusted the `xlim` and `ylim` to zoom into the region of the histogram that you are interested in exploring; however, the values did not actually change.



### Histogram with Custom Breaks

Customize your histogram with breaks that you think might make sense 
as breaks to use for your raster map. 

In the example below, breaks are added in 5 meter increments using the `bins =` argument. 

`bins=[0, 5, 10, 15, 20, 30]`

{:.input}
```python
# Histogram with custom breaks
f, ax = plt.subplots()
pre_lidar_chm.plot.hist(color="purple",
                        bins=[0, 5, 10, 15, 20, 30])
ax.set(title="Histogram with Custom Breaks",
       xlabel="Height (m)",
       ylabel="Number of Pixels")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_20_0.png" alt = "Histogram with custom breaks applied.">
<figcaption>Histogram with custom breaks applied.</figcaption>

</figure>




You may want to play with the distribution of breaks. Below it appears as if there are many values close to 0. 

In the case of this lidar instrument, you know that values between 0 and 2 meters are not reliable (you know this if you read the documentation about the NEON sensor and how these data were processed). 

Below you create a bin between 0-2.

You also know you want to create bins for short, medium and tall trees, so experiment with those bins as well.

Below following breaks are used:
* 0 - 2 = no trees
* 2 - 7 = short trees
* 7 - 12 = medium trees
* `>` 12 = tall trees

{:.input}
```python
# Histogram with custom breaks
f, ax = plt.subplots()

pre_lidar_chm.plot.hist(
    color='purple',
    bins=[0, 2, 7, 12, 30])
ax.set(title="Histogram with Custom Breaks",
       xlabel="Height (m)",
       ylabel="Number of Pixels")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_22_0.png" alt = "Histogram with custom breaks applied.">
<figcaption>Histogram with custom breaks applied.</figcaption>

</figure>




You may want to play around with the setting specific bins associated with your science question and the study area. To begin, use the classes above to reclassify your CHM raster.


## Map Raster Values to New Values

To reclassify your raster, first you need to create a reclassification matrix. 

This matrix **MAPS** a range of values to a new defined value. You will use this matrix to create a classified
canopy height model where you designate short, medium and tall trees.

The newly defined values will be as follows:

* No trees: (0m - 2m tall) = NA
* Short trees: (2m - 7m tall) = 1
* Medium trees: (7m - 12m tall) = 2
* Tall trees:  (> 12m tall) = 3

Notice in the list above that you set cells with a value between 0 and 2 meters to
NA or `nodata` value. This means you are assuming that there are no trees in those
locations!

Notice in the matrix below that you use `Inf` to represent the largest or max value
found in the raster. So our assignment is as follows:

* 0 - 2 meters -> 1
* 2 - 7 meters -> 2 (short trees)
* 7 - 12 meters -> 3 (medium trees)
* `>` 12 or 12 - Inf -> 4 (tall trees)

Below you create the matrix.

<!-- https://github.com/EarthScientist/AK_LandCarbon/blob/master/new_rasterio_stuff.py this is an examiple of how to reclassify...-->


### `np.digitize`

**Numpy** has a function called `digitize` that is useful for classifying the values in an array. It is similar to how `histogram` works, because it categorizes datapoints into bins. However, unlike `histogram`, it doesn't aggregate/count the number of values within each bin.

Instead, `digitize` will replace each datapoint with an integer corresponding to which bin it belongs to. You can use this to determine which datapoints fall within certain ranges. 

When you use `np.digitize`, the bins that you create work as follows:
* The starting value by default is included in each bin. The ending value of the bin is not and will be the beginning of the next bin. You can add the argument `right = True` if you want the second value in the bin to be included but not the first. 
* Any values BELOW the bins as defined will be assigned a `0`. Any values ABOVE the highest value in your bins will be assigned the next value available. Thus, if you have:

`class_bins = [0, 2, 7, 12, 30]`

Any values that are equal to 30 or larger will be assigned a value of `5`. Any values that are `< 0` will be assigned a value of `0`.

Oftentimes, you can use `np.inf` in your array to include all values greater than the last value, and you can use `-np.inf` in your array to include all values less than the first value.

However, if you are using the class bins for a `BoundaryNorm` object for a plot,`np.inf` will throw an error in **matplotlib**. The `BoundaryNorm` object cannot handle an infinity value, so you must supply it with an actual integer. 

A good stand in for `np.inf` is the maximum value numpy can store as an integer, which can be accessed by using `np.iinfo(np.int32).max`. This will have the same effect as `np.inf` without breaking the `BoundaryNorm` object.

Likewise, you can use the minimum value of the array (`arr.min()`) instead of `-np.inf`.

{:.input}
```python
# Check nodata value for your array
pre_lidar_chm.rio.nodata
```

Below you define 4 bins. However, you end up with a `fifth class == 0` which represents values smaller than `0` which is the minimum value in your chm. 

These values < 0 come from the **numpy** mask fill value which you can see identified above this text.

{:.input}
```python
data_min_value = np.nanmin(pre_lidar_chm)
data_max_value = np.nanmax(pre_lidar_chm)
print(data_min_value, data_max_value)
```

{:.output}
    0.0 26.9300537109375



{:.input}
```python
class_bins = [-np.inf, 2, 7, 12, np.inf]
class_bins
```

{:.output}
{:.execute_result}



    [-inf, 2, 7, 12, inf]






{:.input}
```python
pre_lidar_chm_class = xr.apply_ufunc(np.digitize,
                                     pre_lidar_chm,
                                     class_bins)
```


{:.input}
```python
# Values of 5 represent missing data
im = pre_lidar_chm_class.plot.imshow()
ax.set_axis_off()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_32_0.png" alt = "Raster plot of your classified CHM. Notice the yellow on the left side of the plot. Those pixels do not contain data and have been automatically classified as value = 5. You can mask those pixels for a nicer final plot.">
<figcaption>Raster plot of your classified CHM. Notice the yellow on the left side of the plot. Those pixels do not contain data and have been automatically classified as value = 5. You can mask those pixels for a nicer final plot.</figcaption>

</figure>




After running the classification, you have one extra class. This class - the first class - is your missing data value. Your classified array output is also a regular (not a masked) array. 

You can reassign the first class in your data to a mask using `xarray .where()`.

{:.input}
```python
# Mask out values not equalt to 5
pre_lidar_chm_class_ma = pre_lidar_chm_class.where(pre_lidar_chm_class != 5)
pre_lidar_chm_class_ma
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (y: 2000, x: 4000)&gt;
array([[nan, nan, nan, ...,  1.,  1.,  1.],
       [nan, nan, nan, ...,  1.,  1.,  1.],
       [nan, nan, nan, ...,  1.,  1.,  1.],
       ...,
       [nan, nan, nan, ...,  1.,  1.,  1.],
       [nan, nan, nan, ...,  1.,  1.,  1.],
       [nan, nan, nan, ...,  1.,  1.,  1.]])
Coordinates:
    band         int64 1
  * y            (y) float64 4.436e+06 4.436e+06 ... 4.434e+06 4.434e+06
  * x            (x) float64 4.72e+05 4.72e+05 4.72e+05 ... 4.76e+05 4.76e+05
    spatial_ref  int64 0</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>y</span>: 2000</li><li><span class='xr-has-index'>x</span>: 4000</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-66e40f49-2591-4d7a-ad13-42ff88915188' class='xr-array-in' type='checkbox' checked><label for='section-66e40f49-2591-4d7a-ad13-42ff88915188' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>nan nan nan nan nan nan nan nan ... 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0</span></div><div class='xr-array-data'><pre>array([[nan, nan, nan, ...,  1.,  1.,  1.],
       [nan, nan, nan, ...,  1.,  1.,  1.],
       [nan, nan, nan, ...,  1.,  1.,  1.],
       ...,
       [nan, nan, nan, ...,  1.,  1.,  1.],
       [nan, nan, nan, ...,  1.,  1.,  1.],
       [nan, nan, nan, ...,  1.,  1.,  1.]])</pre></div></div></li><li class='xr-section-item'><input id='section-3b46ccdc-7117-483a-9bff-32bb0796c57d' class='xr-section-summary-in' type='checkbox'  checked><label for='section-3b46ccdc-7117-483a-9bff-32bb0796c57d' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>band</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-9dc4fe62-e994-4882-9a76-caf085e107f2' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-9dc4fe62-e994-4882-9a76-caf085e107f2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fc82325e-9f56-4f20-b9ca-b627bdfcb219' class='xr-var-data-in' type='checkbox'><label for='data-fc82325e-9f56-4f20-b9ca-b627bdfcb219' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array(1)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.436e+06 4.436e+06 ... 4.434e+06</div><input id='attrs-4b99dd8a-210e-4201-bf13-c4bfa07d566f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-4b99dd8a-210e-4201-bf13-c4bfa07d566f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2be6f3bd-4862-406c-836b-22041fe552ec' class='xr-var-data-in' type='checkbox'><label for='data-2be6f3bd-4862-406c-836b-22041fe552ec' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4435999.5, 4435998.5, 4435997.5, ..., 4434002.5, 4434001.5, 4434000.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.72e+05 4.72e+05 ... 4.76e+05</div><input id='attrs-777bbabd-9f6b-4b4d-b8b2-7064e44b8f61' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-777bbabd-9f6b-4b4d-b8b2-7064e44b8f61' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a9188974-0220-4098-a748-3b8fe555c8a5' class='xr-var-data-in' type='checkbox'><label for='data-a9188974-0220-4098-a748-3b8fe555c8a5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([472000.5, 472001.5, 472002.5, ..., 475997.5, 475998.5, 475999.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-76cd0f51-1f9d-4f08-b119-2c99ee3ae75c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-76cd0f51-1f9d-4f08-b119-2c99ee3ae75c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-17de0ed1-a047-432f-8579-084857ef4bc7' class='xr-var-data-in' type='checkbox'><label for='data-17de0ed1-a047-432f-8579-084857ef4bc7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;WGS 84 / UTM zone 13N&quot;,BASEGEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1]],ID[&quot;EPSG&quot;,32613]]</dd><dt><span>GeoTransform :</span></dt><dd>472000.0 1.0 0.0 4436000.0 0.0 -1.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-4e8b3d82-67dd-4cc8-84ae-b2fad549292d' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-4e8b3d82-67dd-4cc8-84ae-b2fad549292d' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>






{:.input}
```python
# Plot newly classified and masked raster
f, ax = plt.subplots(figsize=(10,5))
pre_lidar_chm_class_ma.plot.imshow()
ax.set(title="Classified Plot With a Colorbar")

ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_36_0.png" alt = "CHM plot with NA values applied to the data.">
<figcaption>CHM plot with NA values applied to the data.</figcaption>

</figure>




Below the raster is plotted with slightly improved colors

{:.input}
```python
# Plot data using nicer colors
colors = ['linen', 'lightgreen', 'darkgreen', 'maroon']
class_bins = [.5, 1.5, 2.5, 3.5, 4.5]
cmap = ListedColormap(colors)
norm = BoundaryNorm(class_bins, 
                    len(colors))

# Plot newly classified and masked raster
f, ax = plt.subplots(figsize=(10, 5))
pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,
                                   norm=norm)
ax.set(title="Classified Plot With a Colorbar and Custom Colormap (cmap)")
ax.set_axis_off()
plt.show()

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_38_0.png" alt = "Canopy height model plot with a better colormap applied.">
<figcaption>Canopy height model plot with a better colormap applied.</figcaption>

</figure>




## Add a Custom Legend to Your Plot with EarthPy

The plot looks OK but the legend does not represent the data well. The legend is continuous - with a range between 1.0 and 4.0 However, you want to plot the data using discrete bins.

Given you have discrete values, you can create a custom legend with the four categories that you created in your classification matrix.

There are a few tricky pieces to creating a custom legend.

1. Notice below that you first create a list of legend items (or labels):

`height_class_labels = ["Short trees", "Less short trees", "Medium trees", "Tall trees"]`

This represents the text that will appear in your legend. 

2. Next you create the colormap from a list of colors. 

This code: `colors = ['linen', 'lightgreen', 'darkgreen', 'maroon']` creates the color list.

And this code: `cmap = ListedColormap(colors)` creates the colormap to be used in the plot code.  

{:.input}
```python
# Create a list of labels to use for your legend
height_class_labels = ["Short trees",
                       "Medium trees",
                       "Tall trees",
                       "Really tall trees"]

# Create a colormap from a list of colors
colors = ['linen',
          'lightgreen',
          'darkgreen',
          'maroon']

cmap = ListedColormap(colors)

class_bins = [.5, 1.5, 2.5, 3.5, 4.5]
norm = BoundaryNorm(class_bins,
                    len(colors))

# Plot newly classified and masked raster
f, ax = plt.subplots(figsize=(10, 5))
im = pre_lidar_chm_class_ma.plot.imshow(cmap=cmap,
                                        norm=norm,
                                        # Turn off colorbar
                                        add_colorbar=False)
# Add legend using earthpy
ep.draw_legend(im,
               titles=height_class_labels)
ax.set(title="Classified Lidar Canopy Height Model \n Derived from NEON AOP Data")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/03-intro-raster/raster-processing-python/2018-02-05-raster03-classify-raster/2018-02-05-raster03-classify-raster_40_0.png" alt = "Canopy height model with a better colormap and a legend.">
<figcaption>Canopy height model with a better colormap and a legend.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Plot Change Over Time

1. Create a classified raster map that shows **positive and negative change**
in the canopy height model before and after the flood. To do this you will need
to calculate the difference between two canopy height models.
2. Create a classified raster map that shows **positive and negative change**
in terrain extracted from the pre and post flood Digital Terrain Models before
and after the flood.

For each plot, be sure to:

* Add a legend that clearly shows what each color in your classified raster represents.
* Use better colors than I used in my example above!
* Add a title to your plot.

You will include these plots in your final report due next week.

Check out <a href="https://matplotlib.org/users/colormaps.html" target="_blank">this cheatsheet for more on colors in `matplotlib`. </a>


</div>
