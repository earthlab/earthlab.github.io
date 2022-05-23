---
layout: single
title: "Learn to Use NAIP Multiband Remote Sensing Images in Python"
excerpt: "Learn how to open up a multi-band raster layer or image stored in .tiff format in Python using Rasterio. Learn how to plot histograms of raster values and how to plot 3 band RGB and color infrared or false color images."
authors: ['Leah Wasser', 'Nathan Korinek']
dateCreated: 2018-04-14
modified: 2021-01-28
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-naip']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/intro-naip/
nav-title: 'Work with NAIP in Python'
module-title: 'Learn How to Work With NAIP Multispectral Remote Sensing Data in Python'
module-description: 'Learn how to work with NAIP multi-band raster data stored in .tif format in Python using Rasterio'
module-nav-title: 'NAIP'
module-type: 'class'
week: 5
chapter: 8
class-order: 2
estimated-time: "1 hour"
difficulty: "intermediate"
sidebar:
  nav:
author_profile: false
comments: true
course: "intermediate-earth-data-science-textbook"
order: 1
topics:
  remote-sensing: ['naip']
  earth-science: ['fire']
  reproducible-science-and-programming:
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-in-python/naip-imagery-raster-stacks-in-python/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Eight - NAIP Data In Python

In this chapter, you will learn how to work with NAIP multi-band raster data stored in `.tif` format in **Python** using **rasterio**.

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Open an RGB image with 3-4 bands in **Python** using **rioxarray**.
<!--* Export an RGB image as a Geotiff using `writeRaster()`.-->
* Identify the number of bands stored in a multi-band raster in **Python**.
* Plot various band composites in **Python** including True Color (RGB), and Color Infrared (CIR) color images.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this chapter and the Cold Springs Fire data.

{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>

## What is NAIP?

In this chapter, you will work with NAIP data.

>The National Agriculture Imagery Program (NAIP) acquires aerial imagery during the agricultural growing seasons in the continental U.S. A primary goal of the NAIP program is to make digital ortho photography available to governmental agencies and the public within a year of acquisition.

> NAIP is administered by the USDA's Farm Service Agency (FSA) through the Aerial Photography Field Office in Salt Lake City. This "leaf-on" imagery is used as a base layer for GIS programs in FSA's County Service Centers, and is used to maintain the Common Land Unit (CLU) boundaries. -- USDA NAIP Program

<a href="https://www.fsa.usda.gov/programs-and-services/aerial-photography/imagery-programs/naip-imagery/" target="_blank">Read more about NAIP</a>

NAIP is a great source of high resolution imagery across the United States.
NAIP imagery is often collected with just a red, green and Blue band. However,
some flights include a near infrared band which is very useful for quantifying
vegetation cover and health.

NAIP data access: The data used in this lesson were downloaded from the <a href="https://earthexplorer.usgs.gov/" target="_blank">USGS Earth explorer website. </a>

## Open NAIP Data in Python

Next, you will use NAIP imagery for the Coldsprings fire study area in
Colorado. To work with multi-band raster data you will use the `rioxarray` and `geopandas`
packages. You will also use the `plot` module from the `earthpy` package for raster plotting.

Before you get started, make sure that your working directory is set.

{:.input}
```python
import os

import matplotlib.pyplot as plt
import numpy as np
import rioxarray as rxr
import geopandas as gpd
import earthpy as et
import earthpy.plot as ep
import earthpy.spatial as es

# Get the data
data = et.data.get_data('cold-springs-fire')

# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics', 'data'))

plt.rcParams['figure.figsize'] = (10, 10)
plt.rcParams['axes.titlesize'] = 20
```

To begin, you will use the rioxarray open_rasterio function to open the multi-band NAIP image

`rxr.open_rasterio("path-to-tif-file-here")`

Don't forget that with rioxarray you can automatically mask out the fill values of a raster with the argument `masked=True` in `open_rasterio`. 

{:.input}
```python
naip_csf_path = os.path.join("cold-springs-fire", 
                             "naip", 
                             "m_3910505_nw_13_1_20150919", 
                             "crop", 
                             "m_3910505_nw_13_1_20150919_crop.tif")

naip_csf = rxr.open_rasterio(naip_csf_path, masked=True)
naip_csf
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (band: 4, y: 2312, x: 4377)&gt;
[40478496 values with dtype=float64]
Coordinates:
  * band         (band) int64 1 2 3 4
  * y            (y) float64 4.427e+06 4.427e+06 ... 4.425e+06 4.425e+06
  * x            (x) float64 4.572e+05 4.572e+05 ... 4.615e+05 4.615e+05
    spatial_ref  int64 0
Attributes:
    STATISTICS_MAXIMUM:  239
    STATISTICS_MEAN:     nan
    STATISTICS_MINIMUM:  32
    STATISTICS_STDDEV:   nan
    scale_factor:        1.0
    add_offset:          0.0
    grid_mapping:        spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 4</li><li><span class='xr-has-index'>y</span>: 2312</li><li><span class='xr-has-index'>x</span>: 4377</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-0781bbff-8309-4897-8cc4-e0604efa1194' class='xr-array-in' type='checkbox' checked><label for='section-0781bbff-8309-4897-8cc4-e0604efa1194' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[40478496 values with dtype=float64]</pre></div></div></li><li class='xr-section-item'><input id='section-9c4f5050-c9b0-41c1-b694-623330f8117c' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9c4f5050-c9b0-41c1-b694-623330f8117c' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1 2 3 4</div><input id='attrs-1ca5a622-90ad-4e31-81a0-f10fd199fd82' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-1ca5a622-90ad-4e31-81a0-f10fd199fd82' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9253ce77-dee6-405c-bef9-e410b3acaa7e' class='xr-var-data-in' type='checkbox'><label for='data-9253ce77-dee6-405c-bef9-e410b3acaa7e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1, 2, 3, 4])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.427e+06 4.427e+06 ... 4.425e+06</div><input id='attrs-2f1a1b5d-b517-485e-87e2-8963cadb8c44' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2f1a1b5d-b517-485e-87e2-8963cadb8c44' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6c1e4210-bb91-48b8-9150-2d18004bd7ba' class='xr-var-data-in' type='checkbox'><label for='data-6c1e4210-bb91-48b8-9150-2d18004bd7ba' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4426951.5, 4426950.5, 4426949.5, ..., 4424642.5, 4424641.5, 4424640.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.572e+05 4.572e+05 ... 4.615e+05</div><input id='attrs-81374908-aa55-47a0-aeb2-81f24d18da70' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-81374908-aa55-47a0-aeb2-81f24d18da70' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-dcab7e4e-3fa1-4b98-bb78-737f54102451' class='xr-var-data-in' type='checkbox'><label for='data-dcab7e4e-3fa1-4b98-bb78-737f54102451' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([457163.5, 457164.5, 457165.5, ..., 461537.5, 461538.5, 461539.5])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-3b0b0839-d365-46a3-baf0-24533b5e6a6f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3b0b0839-d365-46a3-baf0-24533b5e6a6f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3573390c-c4f4-4d08-ac44-fded4d5b441c' class='xr-var-data-in' type='checkbox'><label for='data-3573390c-c4f4-4d08-ac44-fded4d5b441c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>BOUNDCRS[SOURCECRS[PROJCRS[&quot;UTM Zone 13, Northern Hemisphere&quot;,BASEGEOGCRS[&quot;GRS 1980(IUGG, 1980)&quot;,DATUM[&quot;unknown&quot;,ELLIPSOID[&quot;GRS80&quot;,6378137,298.257222101,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]],ID[&quot;EPSG&quot;,16013]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]]],TARGETCRS[GEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],CS[ellipsoidal,2],AXIS[&quot;latitude&quot;,north,ORDER[1],ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],AXIS[&quot;longitude&quot;,east,ORDER[2],ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]]],ABRIDGEDTRANSFORMATION[&quot;Transformation from GRS 1980(IUGG, 1980) to WGS84&quot;,METHOD[&quot;Position Vector transformation (geog2D domain)&quot;,ID[&quot;EPSG&quot;,9606]],PARAMETER[&quot;X-axis translation&quot;,0,ID[&quot;EPSG&quot;,8605]],PARAMETER[&quot;Y-axis translation&quot;,0,ID[&quot;EPSG&quot;,8606]],PARAMETER[&quot;Z-axis translation&quot;,0,ID[&quot;EPSG&quot;,8607]],PARAMETER[&quot;X-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8608]],PARAMETER[&quot;Y-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8609]],PARAMETER[&quot;Z-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8610]],PARAMETER[&quot;Scale difference&quot;,1,ID[&quot;EPSG&quot;,8611]]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314140356</dd><dt><span>inverse_flattening :</span></dt><dd>298.257222101</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>GRS80</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>GRS 1980(IUGG, 1980)</dd><dt><span>horizontal_datum_name :</span></dt><dd>unknown</dd><dt><span>projected_crs_name :</span></dt><dd>UTM Zone 13, Northern Hemisphere</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>towgs84 :</span></dt><dd>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]</dd><dt><span>spatial_ref :</span></dt><dd>BOUNDCRS[SOURCECRS[PROJCRS[&quot;UTM Zone 13, Northern Hemisphere&quot;,BASEGEOGCRS[&quot;GRS 1980(IUGG, 1980)&quot;,DATUM[&quot;unknown&quot;,ELLIPSOID[&quot;GRS80&quot;,6378137,298.257222101,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]],ID[&quot;EPSG&quot;,16013]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]]],TARGETCRS[GEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],CS[ellipsoidal,2],AXIS[&quot;latitude&quot;,north,ORDER[1],ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],AXIS[&quot;longitude&quot;,east,ORDER[2],ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]]],ABRIDGEDTRANSFORMATION[&quot;Transformation from GRS 1980(IUGG, 1980) to WGS84&quot;,METHOD[&quot;Position Vector transformation (geog2D domain)&quot;,ID[&quot;EPSG&quot;,9606]],PARAMETER[&quot;X-axis translation&quot;,0,ID[&quot;EPSG&quot;,8605]],PARAMETER[&quot;Y-axis translation&quot;,0,ID[&quot;EPSG&quot;,8606]],PARAMETER[&quot;Z-axis translation&quot;,0,ID[&quot;EPSG&quot;,8607]],PARAMETER[&quot;X-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8608]],PARAMETER[&quot;Y-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8609]],PARAMETER[&quot;Z-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8610]],PARAMETER[&quot;Scale difference&quot;,1,ID[&quot;EPSG&quot;,8611]]]]</dd><dt><span>GeoTransform :</span></dt><dd>457163.0 1.0 0.0 4426952.0 0.0 -1.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-ece2e135-d61a-4001-871f-869bf8958e8d' class='xr-section-summary-in' type='checkbox'  checked><label for='section-ece2e135-d61a-4001-871f-869bf8958e8d' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>STATISTICS_MAXIMUM :</span></dt><dd>239</dd><dt><span>STATISTICS_MEAN :</span></dt><dd>nan</dd><dt><span>STATISTICS_MINIMUM :</span></dt><dd>32</dd><dt><span>STATISTICS_STDDEV :</span></dt><dd>nan</dd><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





Above you imported a geotiff like you've done before. But this file is different. Notice the shape of the resulting numpy array. How many layers (known as bands) does it have?

{:.input}
```python
naip_csf.shape
```

{:.output}
{:.execute_result}



    (4, 2312, 4377)





Just like you've done before, you can plot a single band in the NAIP raster using `imshow()`. However, now that you have multiple layers or bands, you need to tell `imshow()` what layer you wish to plot. Use `arrayname[0]` to plot the first band of the image.



{:.input}
```python
fig, ax = plt.subplots()

ax.imshow(naip_csf[0], 
          cmap="Greys_r")
ax.set_title("NAIP RGB Imagery Band 1 Red \nCold Springs Fire Scar")
ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_10_0.png" alt = "Plot showing band one (red) of the NAIP data from 2015.">
<figcaption>Plot showing band one (red) of the NAIP data from 2015.</figcaption>

</figure>




Or you can use the earthpy function `plot_bands()`. Note that in this lesson, you will first be shown how to use **earthpy** to plot multiband rasters. The **earthpy** package was developed to make it easier to work with spatial data in **Python**. 

{:.input}
```python
ep.plot_bands(naip_csf[0],
              title="NAIP RGB Imagery - Band 1-Red\nCold Springs Fire Scar",
              cbar=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_12_0.png" alt = "Plot showing band one (red) of the NAIP data from 2015 using the plot_bands() function.">
<figcaption>Plot showing band one (red) of the NAIP data from 2015 using the plot_bands() function.</figcaption>

</figure>




Look closely at the `.band` element of your raster. Note that now, there are four bands instead of one. This is because you have multiple bands in your raster, one for each 'color' or type of light collected by the camera. For NAIP data you have red, green, blue and near infrared bands. When you worked with the lidar rasters in week 2 your count was 1 as a DSM or DTM is only composed of one band. 


{:.input}
```python
naip_csf.band
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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray &#x27;band&#x27; (band: 4)&gt;
array([1, 2, 3, 4])
Coordinates:
  * band         (band) int64 1 2 3 4
    spatial_ref  int64 0</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'band'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 4</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-4798aad0-647f-41ee-bf47-868f935d5fea' class='xr-array-in' type='checkbox' checked><label for='section-4798aad0-647f-41ee-bf47-868f935d5fea' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>1 2 3 4</span></div><div class='xr-array-data'><pre>array([1, 2, 3, 4])</pre></div></div></li><li class='xr-section-item'><input id='section-2716d500-524c-446b-8704-ae500bc10f63' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2716d500-524c-446b-8704-ae500bc10f63' class='xr-section-summary' >Coordinates: <span>(2)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1 2 3 4</div><input id='attrs-26514832-0971-471c-9e67-0edf0f91337d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-26514832-0971-471c-9e67-0edf0f91337d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a6b768e5-be87-4135-a962-1133551037e8' class='xr-var-data-in' type='checkbox'><label for='data-a6b768e5-be87-4135-a962-1133551037e8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1, 2, 3, 4])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-05aec1e9-1a1d-4628-bc16-4d1e4514c326' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-05aec1e9-1a1d-4628-bc16-4d1e4514c326' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8d84105a-71f1-42ca-a853-820adc8c4cd3' class='xr-var-data-in' type='checkbox'><label for='data-8d84105a-71f1-42ca-a853-820adc8c4cd3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>BOUNDCRS[SOURCECRS[PROJCRS[&quot;UTM Zone 13, Northern Hemisphere&quot;,BASEGEOGCRS[&quot;GRS 1980(IUGG, 1980)&quot;,DATUM[&quot;unknown&quot;,ELLIPSOID[&quot;GRS80&quot;,6378137,298.257222101,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]],ID[&quot;EPSG&quot;,16013]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]]],TARGETCRS[GEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],CS[ellipsoidal,2],AXIS[&quot;latitude&quot;,north,ORDER[1],ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],AXIS[&quot;longitude&quot;,east,ORDER[2],ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]]],ABRIDGEDTRANSFORMATION[&quot;Transformation from GRS 1980(IUGG, 1980) to WGS84&quot;,METHOD[&quot;Position Vector transformation (geog2D domain)&quot;,ID[&quot;EPSG&quot;,9606]],PARAMETER[&quot;X-axis translation&quot;,0,ID[&quot;EPSG&quot;,8605]],PARAMETER[&quot;Y-axis translation&quot;,0,ID[&quot;EPSG&quot;,8606]],PARAMETER[&quot;Z-axis translation&quot;,0,ID[&quot;EPSG&quot;,8607]],PARAMETER[&quot;X-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8608]],PARAMETER[&quot;Y-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8609]],PARAMETER[&quot;Z-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8610]],PARAMETER[&quot;Scale difference&quot;,1,ID[&quot;EPSG&quot;,8611]]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314140356</dd><dt><span>inverse_flattening :</span></dt><dd>298.257222101</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>GRS80</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>GRS 1980(IUGG, 1980)</dd><dt><span>horizontal_datum_name :</span></dt><dd>unknown</dd><dt><span>projected_crs_name :</span></dt><dd>UTM Zone 13, Northern Hemisphere</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>towgs84 :</span></dt><dd>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]</dd><dt><span>spatial_ref :</span></dt><dd>BOUNDCRS[SOURCECRS[PROJCRS[&quot;UTM Zone 13, Northern Hemisphere&quot;,BASEGEOGCRS[&quot;GRS 1980(IUGG, 1980)&quot;,DATUM[&quot;unknown&quot;,ELLIPSOID[&quot;GRS80&quot;,6378137,298.257222101,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;UTM zone 13N&quot;,METHOD[&quot;Transverse Mercator&quot;,ID[&quot;EPSG&quot;,9807]],PARAMETER[&quot;Latitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8801]],PARAMETER[&quot;Longitude of natural origin&quot;,-105,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;Scale factor at natural origin&quot;,0.9996,SCALEUNIT[&quot;unity&quot;,1],ID[&quot;EPSG&quot;,8805]],PARAMETER[&quot;False easting&quot;,500000,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;metre&quot;,1],ID[&quot;EPSG&quot;,8807]],ID[&quot;EPSG&quot;,16013]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]]],TARGETCRS[GEOGCRS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,ELLIPSOID[&quot;WGS 84&quot;,6378137,298.257223563,LENGTHUNIT[&quot;metre&quot;,1]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],CS[ellipsoidal,2],AXIS[&quot;latitude&quot;,north,ORDER[1],ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],AXIS[&quot;longitude&quot;,east,ORDER[2],ANGLEUNIT[&quot;degree&quot;,0.0174532925199433]],ID[&quot;EPSG&quot;,4326]]],ABRIDGEDTRANSFORMATION[&quot;Transformation from GRS 1980(IUGG, 1980) to WGS84&quot;,METHOD[&quot;Position Vector transformation (geog2D domain)&quot;,ID[&quot;EPSG&quot;,9606]],PARAMETER[&quot;X-axis translation&quot;,0,ID[&quot;EPSG&quot;,8605]],PARAMETER[&quot;Y-axis translation&quot;,0,ID[&quot;EPSG&quot;,8606]],PARAMETER[&quot;Z-axis translation&quot;,0,ID[&quot;EPSG&quot;,8607]],PARAMETER[&quot;X-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8608]],PARAMETER[&quot;Y-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8609]],PARAMETER[&quot;Z-axis rotation&quot;,0,ID[&quot;EPSG&quot;,8610]],PARAMETER[&quot;Scale difference&quot;,1,ID[&quot;EPSG&quot;,8611]]]]</dd><dt><span>GeoTransform :</span></dt><dd>457163.0 1.0 0.0 4426952.0 0.0 -1.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-34adc7b4-265f-4bf2-b2d8-d77d33777445' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-34adc7b4-265f-4bf2-b2d8-d77d33777445' class='xr-section-summary'  title='Expand/collapse section'>Attributes: <span>(0)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'></dl></div></li></ul></div></div>






<i class="fa fa-star"></i> **Data Tip:** Remember that a tiff can store 1 or more bands. It's unusual to find tif files with more than 4 bands.
{: .notice--success}

### Image Raster Data Values
Next, examine the raster's min and max values. What is the value range?


{:.input}
```python
# View min and max value
print(naip_csf.min())
print(naip_csf.max())
```

{:.output}
    <xarray.DataArray ()>
    array(17.)
    Coordinates:
        spatial_ref  int64 0
    <xarray.DataArray ()>
    array(242.)
    Coordinates:
        spatial_ref  int64 0



This raster contains values between 0 and 255. These values represent degrees of brightness associated with the image band. In the case of a RGB image (red, green and blue), band 1 is the red band. When we plot the red band, larger numbers (towards 255) represent pixels with more red in them (a strong red reflection). Smaller numbers (towards 0) represent pixels with less red in them (less red was reflected). 

To plot an RGB image, we mix red + green + blue values, using the ratio of each. The ratio of each color is determined by how much light was recorded (the reflectance value) in each band. This mixture creates one single color that, in turn, makes up the full color image - similar to the color image that your camera phone creates.

## 8 vs 16 Bit Images

It's important to note that this image is an 8 bit image. This means that all values in the raster are stored within a range of 0:255. This differs from a 16-bit image, in which values can be stored within a range of 0:65,535. 

In these lessons, you will work with 8-bit images. For 8-bit images, the brightest whites will be at or close to 255. The darkest values in each band will be closer to 0.

### Plot A Specific Band

You can plot a single band of your choice using numpy indexing. `naip_csf[1]` will access just the second band - which is the green band when using NAIP data. 

{:.input}
```python
# Plot band 2 - green
ep.plot_bands(naip_csf[1],
              title="RGB Imagery - Band 2 - Green\nCold Springs Fire Scar",
              cbar=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_18_0.png" alt = "Plot showing band two (green) of the NAIP data from 2015.">
<figcaption>Plot showing band two (green) of the NAIP data from 2015.</figcaption>

</figure>




## Rasters and Numpy Arrays - A Review 

Remember that when you import a raster dataset into Python, the data are converted to an **xarray** object. 
A numpy array has no inherent spatial information attached to it, nor does an **xarray** object. The data 
are just a matrix of values. This makes processing the data fast.

The spatial information for the raster is stored in a `.rio` attribute which is available if you import 
rioxarray in your workflow. This rio attribute allows you to export the data as a geotiff or other spatial format. 



### Plot Raster Band Images

Next plot each band in the raster. This is another intermediate step (like plotting histograms) that you might want to do when you first explore and open your data. You will not need this for your homework but you might want to do it to explore other data that you use in your career. Earthpy contains a plot_bands() function that allows you to quickly plot each band individually. 

Similar to plotting a single band, in each band "color", the brightest pixels are lighter in color or white representing a stronger reflectance for that color on that pixel. The darkest pixels are darker to black in color representing less reflectance of that color in that pixel. 

#### Plot Bands Using Earthpy

You can use the earthpy package to plot a single or all bands in your array. 
To use earthpy call:

`ep.plot_bands()`

plot_bands() takes several key agruments including:

* `arr`: an n-dimensional numpy array to plot.
* `figsize`: a tuple of 2 values representing the x and y dimensions of the image.
* `cols`: if you are plotting more than one band you can specify the number of columns in the grid that you'd like to plot. 
* `title`: OPTIONAL - A single title for one band or a list of x titles for x bands in your array.
* `cbar`: OPTIONAL - `ep.plot_bands()` by default will add a colorbar to each plot it creates. You can turn the colobar off by setting this argument to false. 

{:.input}
```python
titles = ["Red Band", "Green Band", "Blue Band", "Near Infrared (NIR) Band"]

# Plot all bands using the earthpy function
ep.plot_bands(naip_csf, 
              figsize=(12, 5), 
              cols=2,
              title=titles,
              cbar=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_21_0.png" alt = "Plot showing all NAIP data bands from 2015.">
<figcaption>Plot showing all NAIP data bands from 2015.</figcaption>

</figure>






## Plot RGB Data in Python


Previously you have plotted individual bands using a greyscale color ramp in Python. Next, you will learn how to plot an RGB composite image. This type of image is similar in appearance to one you capture using a cell phone or digital camera. 

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/RGB-bands-raster-stack.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/RGB-bands-raster-stack.jpg" alt="A true color image consists of 3 bands - red, green and blue.
    When composited or rendered together in a GIS, or even a image-editor like
    Photoshop the bands create a color image."></a>
    <figcaption>A "true" color image consists of 3 bands - red, green and blue.
    When composited or rendered together in a GIS, or even a image-editor like
    Photoshop the bands create a color image.
	Source: Colin Williams, NEON.
    </figcaption>
</figure>

You can use the Earthpy function called `plot_rgb()` to quickly plot 3 band composite images.
This function has several key arguments including

* `arr`: a numpy array in rasterio band order (bands first)
* `rgb`: the three bands that you wish to plot on the red, green and blue channels respectively
* `title`: OPTIONAL - if you want to add a title to your plot.

Similar to plotting with geopandas, you can provide an `ax=` argument as well to plot your data on a particular matplotlib axis.

{:.input}
```python
ep.plot_rgb(naip_csf.values,
            rgb=[0, 1, 2],
            title="RGB Composite image - NAIP")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_25_0.png" alt = "RGB plot NAIP data from 2015.">
<figcaption>RGB plot NAIP data from 2015.</figcaption>

</figure>




Optionally, you can also provide the bands that you wish to plot, the title and the figure size.



{:.input}
```python
ep.plot_rgb(naip_csf.values, title="CIR NAIP image",
            rgb=[3, 0, 1],
            figsize=(10, 8))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_27_0.png" alt = "CIR (Color Infrared) plot of NAIP data from 2015.">
<figcaption>CIR (Color Infrared) plot of NAIP data from 2015.</figcaption>

</figure>






<div class="notice--warning" markdown="1">


## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge: Making Sense of Single Band Images

Plot all of the bands in the NAIP image using python, following the code examples above. Compare grayscale plots of band 1 (red), band 2 (green) and band 4 (near infrared). Is the forested area darker or lighter in band 2 (the green band) compared to band 1 (the red band)?

</div>

<!-- We'd expect a *brighter* value for the forest in band 2 (green) than in band 1 (red) because the leaves on trees of most often appear "green" -
healthy leaves reflect MORE green light compared to red light however the brightest values should be in the NIR band.-->



{:.input}
```python
titles = ['red', 'green', 'near\ninfrared']
ep.plot_bands(naip_csf[[0, 1, 3]],
              figsize=(10,  7),
              title=titles,
              cbar=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_30_0.png" alt = "Plot showing the red vs green vs near infrared bands of the NAIP data. Do you notice a difference in brightness between the 3 images?">
<figcaption>Plot showing the red vs green vs near infrared bands of the NAIP data. Do you notice a difference in brightness between the 3 images?</figcaption>

</figure>







## Image Stretch To Increase Contrast

The image above looks pretty good. You can explore whether applying a stretch to
the image improves clarity and contrast.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-dark.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-dark.jpg" alt="When the range of pixel brightness values is closer to 0, a
    darker image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.">
    </a>
    <figcaption>When the range of pixel brightness values is closer to 0, a
    darker image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.
    </figcaption>
</figure>

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-light.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/raster-image-stretch-light.jpg" alt="When the range of pixel brightness values is closer to 255, a
    lighter image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.">
    </a>
    <figcaption>When the range of pixel brightness values is closer to 255, a
    lighter image is rendered by default. You can stretch the values to extend to
    the full 0-255 range of potential values to increase the visual contrast of
    the image.
    </figcaption>
</figure>

Below you use the skimage package to contrast stretch each band in your data to make the whites more bright and the blacks more dark. 

In the example below you only stretch bands 0,1 and 2 which are the RGB bands. To begin,

1. preallocate an array of zeros that is the same shape as your numpy array.
2. then look through each band in the image and rescale it.

<i class="fa fa-star"></i> **Data Tip:** Read more about image stretch on the <a href="http://scikit-image.org/docs/dev/auto_examples/color_exposure/plot_equalize.html" target = "_blank">scikit-image website</a>.
{: .notice--success }

For convenience we have also built a stretch feature into **earthpy**. You can call it using the stretch argument.

{:.input}
```python
band_indices = [0, 1, 2]

# Apply stretch using the earthpy plot_rgb function
ep.plot_rgb(naip_csf.values,
            rgb=band_indices,
            title="RGB NAIP image\n Stretch Applied",
            figsize=(10, 8),
            stretch=True)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_35_0.png" alt = "Plot showing RGB image of NAIP data with a stretch applied to increase contrast.">
<figcaption>Plot showing RGB image of NAIP data with a stretch applied to increase contrast.</figcaption>

</figure>




What does the image look like using a different stretch? Any better? worse?

In this case, the stretch does increase the contrast in our image. 
However visually it may or may not be what you want to plot. 


## Multiband Raster Histograms

Just like you did with single band rasters, you can view a histogram of each band in your data using matplotlib. Below, you loop through each band or layer in the number array and plot the distribution of reflectance values. 



You can use the `ep.hist()` function in earthpy to plot histograms for all bands in your raster. hist() accepts several key arguments including

* `arr`: a numpy array in rasterio band order (bands first)
* `colors`: a list of colors to use for each histogram.
* `title`: plot titles to use for each histogram.
* `cols`: the number of columns for the plot grid.

{:.input}
```python
# Create a colors and titles list to use in the histogram, then plot
colors = ['r', 'g', 'b', 'k']
titles = ['red band', 'green band', 'blue band', 'near-infrared band']

ep.hist(naip_csf.values, 
        colors=colors, 
        title=titles, 
        cols=2)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/naip/2018-04-14-multispectral01-open-NAIP-imagery-in-python/2018-04-14-multispectral01-open-NAIP-imagery-in-python_40_0.png" alt = "Histogram for each band in the NAIP data from 2015.">
<figcaption>Histogram for each band in the NAIP data from 2015.</figcaption>

</figure>







