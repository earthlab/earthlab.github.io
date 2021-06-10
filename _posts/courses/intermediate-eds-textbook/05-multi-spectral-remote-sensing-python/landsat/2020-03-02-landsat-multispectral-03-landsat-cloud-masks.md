---
layout: single
title: "Clean Remote Sensing Data in Python - Clouds, Shadows & Cloud Masks"
excerpt: "Landsat remote sensing data often has pixels that are covered by clouds and cloud shadows. Learn how to remove cloud covered landsat pixels using open source Python."
authors: ['Leah Wasser']
dateCreated: 2017-03-01
modified: 2021-06-10
category: [courses]
class-lesson: ['multispectral-remote-sensing-data-python-landsat']
permalink: /courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/remove-clouds-from-landsat-data/
nav-title: 'Clouds, Shadows & Masks'
course: "intermediate-earth-data-science-textbook"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  remote-sensing: ['landsat', 'modis']
  earth-science: ['fire']
  reproducible-science-and-programming: ['python']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/multispectral-remote-sensing-modis/cloud-masks-with-spectral-data-python/"
  - "/courses/use-data-open-source-python/multispectral-remote-sensing/landsat-in-Python/cloud-masks-with-spectral-data-python/" 
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Describe the impacts of cloud cover on analysis of remote sensing data.
* Use a mask to remove portions of an spectral dataset (image) that is covered by clouds / shadows.
* Define mask / describe how a mask can be useful when working with remote sensing data.

</div>


## About Landsat Scenes

Landsat satellites orbit the earth continuously collecting images of the Earth's
surface. These images, are divided into smaller regions - known as scenes.

> Landsat images are usually divided into scenes for easy downloading. Each
> Landsat scene is about 115 miles long and 115 miles wide (or 100 nautical
> miles long and 100 nautical miles wide, or 185 kilometers long and 185 kilometers wide). -*wikipedia*


### Challenges Working with Landsat Remote Sensing Data

In the previous lessons, you learned how to import a set of geotiffs that made
up the bands of a Landsat raster. Each geotiff file was a part of a Landsat scene,
that had been downloaded for this class by your instructor. The scene was further
cropped to reduce the file size for the class.

You ran into some challenges when you began to work with the data. The biggest
problem was a large cloud and associated shadow that covered your study
area of interest - the Cold Springs fire burn scar.

### Work with Clouds, Shadows and Bad Pixels in Remote Sensing Data

Clouds and atmospheric conditions present a significant challenge when working
with multispectral remote sensing data. Extreme cloud cover and shadows can make
the data in those areas, un-usable given reflectance values are either washed out
(too bright - as the clouds scatter all light back to the sensor) or are too
dark (shadows which represent blocked or absorbed light).

In this lesson you will learn how to deal with clouds in your remote sensing data.
There is no perfect solution of course. You will just learn one approach.



{:.input}
```python
import os
from glob import glob

import matplotlib.pyplot as plt
from matplotlib import patches as mpatches, colors
import seaborn as sns
import numpy as np
from numpy import ma
import xarray as xr
import rioxarray as rxr
import earthpy as et
import earthpy.plot as ep
import earthpy.mask as em

# Prettier plotting with seaborn
sns.set_style('white')
sns.set(font_scale=1.5)

# Download data and set working directory
data = et.data.get_data('cold-springs-fire')
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960109
    Extracted output to /root/earth-analytics/data/cold-springs-fire/.



## Functions To Process Landsat  Data

To begin, you can use the functions created in the previous lesson to process
your Landsat data. 

{:.input}
```python
def check_crs(raster_path):
    """
    Returns the CRS of a raster file.

    Parameters
    ----------
    raster_path : string
        A path to a raster file that you wish to check the crs of. Assuming
        this is a tif file.

    Returns
    -------
    A crs object

    """

    with rio.open(all_landsat_post_bands[0]) as src:
        return src.crs


def open_clean_band(band_path, crop_layer=None, valid_range=None):
    """A function that opens a Landsat band as an (rio)xarray object

    Parameters
    ----------
    band_path : list
        A list of paths to the tif files that you wish to combine.

    clip_extent : geopandas geodataframe
        A geodataframe containing the clip extent of interest. NOTE: this will 
        fail if the clip extent is in a different CRS than the raster data.

    valid_range : tuple (optional)
        The min and max valid range for the data. All pixels with values outside
        of this range will be masked.

    Returns
    -------
    An single xarray object with the Landsat band data.

    """

    if crop_layer is not None:
        try:
            clip_bound = crop_layer.geometry
            cleaned_band = rxr.open_rasterio(band_path,
                                             masked=True).rio.clip(clip_bound,
                                                                   from_disk=True).squeeze()
        except Exception as err:
            print("Oops, I need a geodataframe object for this to work.")
            print(err)

    cleaned_band = rxr.open_rasterio(band_path,
                                     masked=True).squeeze()

    # Only mask the data if a valid range tuple is provided
    if valid_range:
        mask = ((landsat_post_xr_clip < valid_range[0]) | (
            landsat_post_xr_clip > valid_range[1]))
        cleaned_band = landsat_post_xr_clip.where(
            ~xr.where(mask, True, False))

    return cleaned_band


def process_bands(paths, crop_layer=None, stack=False):
    """
    Open, clean and crop a list of raster files using rioxarray.

    Parameters
    ----------
    paths : list
        A list of paths to raster files that could be stacked (of the same 
        resolution, crs and spatial extent).

    crop_layer : geodataframe
        A geodataframe containing the crop geometry that you wish to crop your
        data to.

    stack : boolean
        If True, return a stacked xarray object. If false will return a list
        of xarray objects.

    Returns
    -------
        Either a list of xarray objects or a stacked xarray object
    """

    all_bands = []
    for i, aband in enumerate(paths):
        cleaned = open_clean_band(aband, crop_layer)
        cleaned["band"] = i+1
        all_bands.append(cleaned)

    if stack:
        print("I'm stacking your data now.")
        return xr.concat(all_bands, dim="band")
    else:
        print("Returning a list of xarray objects.")
        return all_bands
```

Next, you will load and plot landsat data. If you are completing the earth analytics course, you have worked with these data already in your homework. 

HINT: Since we are only using the RGB and the NIR bands for this exercise, you can use `*band[2-5]*.tif` inside `glob` to filter just the needed bands. This will save a lot of time in processing since you will only be using the data you need. 

Note that one thing was added to the functions below - a conditional that allows
you to chose to either crop or not crop your data.


{:.input}
```python
landsat_dirpath_pre = os.path.join("cold-springs-fire",
                                   "landsat_collect",
                                   "LC080340322016070701T1-SC20180214145604",
                                   "crop",
                                   "*band[2-5]*.tif")

landsat_paths_pre = sorted(glob(landsat_dirpath_pre))

landsat_pre = process_bands(landsat_paths_pre, stack=True)
landsat_pre
```

{:.output}
    I'm stacking your data now.



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
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (band: 4, y: 177, x: 246)&gt;
array([[[ 443.,  456.,  446., ...,  213.,  251.,  293.],
        [ 408.,  420.,  436., ...,  226.,  272.,  332.],
        [ 356.,  375.,  373., ...,  261.,  329.,  383.],
        ...,
        [ 407.,  427.,  428., ...,  306.,  273.,  216.],
        [ 545.,  552.,  580., ...,  307.,  315.,  252.],
        [ 350.,  221.,  233., ...,  320.,  348.,  315.]],

       [[ 635.,  641.,  629., ...,  360.,  397.,  454.],
        [ 601.,  617.,  620., ...,  380.,  418.,  509.],
        [ 587.,  600.,  573., ...,  431.,  513.,  603.],
        ...,
        [ 679.,  742.,  729., ...,  493.,  482.,  459.],
        [ 816.,  827.,  824., ...,  461.,  502.,  485.],
        [ 526.,  388.,  364., ...,  463.,  501.,  512.]],

       [[ 625.,  671.,  651., ...,  265.,  307.,  340.],
        [ 568.,  620.,  627., ...,  309.,  354.,  431.],
        [ 513.,  510.,  515., ...,  362.,  464.,  565.],
        ...,
        [ 725.,  834.,  864., ...,  485.,  467.,  457.],
        [1031.,  864.,  844., ...,  438.,  457.,  429.],
        [ 525.,  432.,  411., ...,  465.,  472.,  451.]],

       [[2080., 1942., 1950., ..., 1748., 1802., 2135.],
        [2300., 2045., 1939., ..., 1716., 1783., 2131.],
        [2582., 2443., 2347., ..., 1836., 2002., 2241.],
        ...,
        [2076., 1993., 2145., ..., 1914., 2066., 2166.],
        [1910., 1899., 1962., ..., 1787., 2038., 2300.],
        [1633., 1611., 1738., ..., 1714., 1848., 2194.]]])
Coordinates:
  * band         (band) int64 1 2 3 4
  * y            (y) float64 4.428e+06 4.428e+06 ... 4.423e+06 4.423e+06
  * x            (x) float64 4.557e+05 4.557e+05 4.557e+05 ... 4.63e+05 4.63e+05
    spatial_ref  int64 0
Attributes:
    STATISTICS_MAXIMUM:  8481
    STATISTICS_MEAN:     664.90340361031
    STATISTICS_MINIMUM:  -767
    STATISTICS_STDDEV:   1197.873301452
    scale_factor:        1.0
    add_offset:          0.0
    grid_mapping:        spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 4</li><li><span class='xr-has-index'>y</span>: 177</li><li><span class='xr-has-index'>x</span>: 246</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-ca92d1dd-a500-4a5a-9a6f-59a51e722a4f' class='xr-array-in' type='checkbox' checked><label for='section-ca92d1dd-a500-4a5a-9a6f-59a51e722a4f' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>443.0 456.0 446.0 475.0 ... 1.706e+03 1.714e+03 1.848e+03 2.194e+03</span></div><div class='xr-array-data'><pre>array([[[ 443.,  456.,  446., ...,  213.,  251.,  293.],
        [ 408.,  420.,  436., ...,  226.,  272.,  332.],
        [ 356.,  375.,  373., ...,  261.,  329.,  383.],
        ...,
        [ 407.,  427.,  428., ...,  306.,  273.,  216.],
        [ 545.,  552.,  580., ...,  307.,  315.,  252.],
        [ 350.,  221.,  233., ...,  320.,  348.,  315.]],

       [[ 635.,  641.,  629., ...,  360.,  397.,  454.],
        [ 601.,  617.,  620., ...,  380.,  418.,  509.],
        [ 587.,  600.,  573., ...,  431.,  513.,  603.],
        ...,
        [ 679.,  742.,  729., ...,  493.,  482.,  459.],
        [ 816.,  827.,  824., ...,  461.,  502.,  485.],
        [ 526.,  388.,  364., ...,  463.,  501.,  512.]],

       [[ 625.,  671.,  651., ...,  265.,  307.,  340.],
        [ 568.,  620.,  627., ...,  309.,  354.,  431.],
        [ 513.,  510.,  515., ...,  362.,  464.,  565.],
        ...,
        [ 725.,  834.,  864., ...,  485.,  467.,  457.],
        [1031.,  864.,  844., ...,  438.,  457.,  429.],
        [ 525.,  432.,  411., ...,  465.,  472.,  451.]],

       [[2080., 1942., 1950., ..., 1748., 1802., 2135.],
        [2300., 2045., 1939., ..., 1716., 1783., 2131.],
        [2582., 2443., 2347., ..., 1836., 2002., 2241.],
        ...,
        [2076., 1993., 2145., ..., 1914., 2066., 2166.],
        [1910., 1899., 1962., ..., 1787., 2038., 2300.],
        [1633., 1611., 1738., ..., 1714., 1848., 2194.]]])</pre></div></div></li><li class='xr-section-item'><input id='section-d9c068af-030a-4f98-a4d1-c47df8a17da3' class='xr-section-summary-in' type='checkbox'  checked><label for='section-d9c068af-030a-4f98-a4d1-c47df8a17da3' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1 2 3 4</div><input id='attrs-76ddcf7c-2e60-4dd5-aa01-07285663c5e0' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-76ddcf7c-2e60-4dd5-aa01-07285663c5e0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-075ffd73-23d0-4487-8600-92ab73cb9833' class='xr-var-data-in' type='checkbox'><label for='data-075ffd73-23d0-4487-8600-92ab73cb9833' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1, 2, 3, 4])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.428e+06 4.428e+06 ... 4.423e+06</div><input id='attrs-6d1d48df-71d4-4f72-b12a-651ebf4d6b26' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6d1d48df-71d4-4f72-b12a-651ebf4d6b26' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ca6b186a-64c5-4906-82e4-15ede39e6525' class='xr-var-data-in' type='checkbox'><label for='data-ca6b186a-64c5-4906-82e4-15ede39e6525' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4428450., 4428420., 4428390., 4428360., 4428330., 4428300., 4428270.,
       4428240., 4428210., 4428180., 4428150., 4428120., 4428090., 4428060.,
       4428030., 4428000., 4427970., 4427940., 4427910., 4427880., 4427850.,
       4427820., 4427790., 4427760., 4427730., 4427700., 4427670., 4427640.,
       4427610., 4427580., 4427550., 4427520., 4427490., 4427460., 4427430.,
       4427400., 4427370., 4427340., 4427310., 4427280., 4427250., 4427220.,
       4427190., 4427160., 4427130., 4427100., 4427070., 4427040., 4427010.,
       4426980., 4426950., 4426920., 4426890., 4426860., 4426830., 4426800.,
       4426770., 4426740., 4426710., 4426680., 4426650., 4426620., 4426590.,
       4426560., 4426530., 4426500., 4426470., 4426440., 4426410., 4426380.,
       4426350., 4426320., 4426290., 4426260., 4426230., 4426200., 4426170.,
       4426140., 4426110., 4426080., 4426050., 4426020., 4425990., 4425960.,
       4425930., 4425900., 4425870., 4425840., 4425810., 4425780., 4425750.,
       4425720., 4425690., 4425660., 4425630., 4425600., 4425570., 4425540.,
       4425510., 4425480., 4425450., 4425420., 4425390., 4425360., 4425330.,
       4425300., 4425270., 4425240., 4425210., 4425180., 4425150., 4425120.,
       4425090., 4425060., 4425030., 4425000., 4424970., 4424940., 4424910.,
       4424880., 4424850., 4424820., 4424790., 4424760., 4424730., 4424700.,
       4424670., 4424640., 4424610., 4424580., 4424550., 4424520., 4424490.,
       4424460., 4424430., 4424400., 4424370., 4424340., 4424310., 4424280.,
       4424250., 4424220., 4424190., 4424160., 4424130., 4424100., 4424070.,
       4424040., 4424010., 4423980., 4423950., 4423920., 4423890., 4423860.,
       4423830., 4423800., 4423770., 4423740., 4423710., 4423680., 4423650.,
       4423620., 4423590., 4423560., 4423530., 4423500., 4423470., 4423440.,
       4423410., 4423380., 4423350., 4423320., 4423290., 4423260., 4423230.,
       4423200., 4423170.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.557e+05 4.557e+05 ... 4.63e+05</div><input id='attrs-e17e03d2-395c-4a0c-8ec4-9b225817dc24' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e17e03d2-395c-4a0c-8ec4-9b225817dc24' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-93500f68-4dce-4d6b-9ffe-81c6ceb7e288' class='xr-var-data-in' type='checkbox'><label for='data-93500f68-4dce-4d6b-9ffe-81c6ceb7e288' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([455670., 455700., 455730., ..., 462960., 462990., 463020.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-f97feb37-a2b2-4820-bd06-c3b048d7c4be' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f97feb37-a2b2-4820-bd06-c3b048d7c4be' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-714246f1-33b8-4e7b-8030-85160416b508' class='xr-var-data-in' type='checkbox'><label for='data-714246f1-33b8-4e7b-8030-85160416b508' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;WGS 84 / UTM zone 13N&quot;,GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;WGS_1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;,0,AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;32613&quot;]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>WGS 84</dd><dt><span>horizontal_datum_name :</span></dt><dd>World Geodetic System 1984</dd><dt><span>projected_crs_name :</span></dt><dd>WGS 84 / UTM zone 13N</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;WGS 84 / UTM zone 13N&quot;,GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;WGS_1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;,0,AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;32613&quot;]]</dd><dt><span>GeoTransform :</span></dt><dd>455655.0 30.0 0.0 4428465.0 0.0 -30.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-67766c6a-6d45-443f-9b3a-a289ce1e186f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-67766c6a-6d45-443f-9b3a-a289ce1e186f' class='xr-section-summary' >Attributes: <span>(7)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>STATISTICS_MAXIMUM :</span></dt><dd>8481</dd><dt><span>STATISTICS_MEAN :</span></dt><dd>664.90340361031</dd><dt><span>STATISTICS_MINIMUM :</span></dt><dd>-767</dd><dt><span>STATISTICS_STDDEV :</span></dt><dd>1197.873301452</dd><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





{:.input}
```python
# Plot the data
ep.plot_rgb(landsat_pre.values,
            rgb=[2, 1, 0],
            title="Landsat True Color Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-03-landsat-cloud-masks/2020-03-02-landsat-multispectral-03-landsat-cloud-masks_7_0.png" alt = "RGB Landsat image for the Cold Springs fire area with a cloud blocking part of the image.">
<figcaption>RGB Landsat image for the Cold Springs fire area with a cloud blocking part of the image.</figcaption>

</figure>




Notice in the data above there is a large cloud in your scene. This cloud will impact any quantitative analysis that you perform on the data. You can remove cloudy pixels using a mask. Masking "bad" pixels:

1. Allows you to remove them from any quantitative analysis that you may perform such as calculating NDVI. 
2. Allows you to replace them (if you want) with better pixels from another scene. This replacement if often performed when performing time series analysis of data. The following lesson will teach you have to replace pixels in a scene. 

## Cloud Masks in Python

You can use the cloud mask layer to identify pixels that are likely to be clouds
or shadows. You can then set those pixel values to `masked` so they are not included in
your quantitative analysis in Python.

When you say "mask", you are talking about a layer that "turns off" or sets to `nan`,
the values of pixels in a raster that you don't want to include in an analysis.
It's very similar to setting data points that equal -9999 to `nan` in a time series
data set. You are just doing it with spatial raster data instead.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/raster-data/raster_masks.jpg">
    <img src="{{ site.url }}/images/earth-analytics/raster-data/raster_masks.jpg" alt="Raster masks">
    </a>

    <figcaption>When you use a raster mask, you are defining what pixels you want to exclude from a quantitative analysis. Notice in this image, the raster max is simply a layer that contains values of 1 (use these pixels) and values of NA (exclude these pixels). If the raster is the same extent and spatial resolution as your remote sensing data (in this case your landsat raster stack) you can then mask ALL PIXELS that occur at the spatial location of clouds and shadows (represented by an NA in the image above). Source: Colin Williams (NEON)
    </figcaption>
</figure>




The code below demonstrated how to mask a landsat scene using the pixel_qa layer. 

## Raster Masks for Remote Sensing Data

Many remote sensing data sets come with quality layers that you can use as a mask 
to remove "bad" pixels from your analysis. In the case of Landsat, the mask layers
identify pixels that are likely representative of cloud cover, shadow and even water. 
When you download Landsat 8 data from Earth Explorer, the data came with a processed 
cloud shadow / mask raster layer called `landsat_file_name_pixel_qa.tif`.
Just replace the name of your Landsat scene with the text landsat_file_name above. 
For this class the layer is:

`LC80340322016189-SC20170128091153/crop/LC08_L1TP_034032_20160707_20170221_01_T1_pixel_qa_crop.tif`

You will explore using this pixel quality assurance (QA) layer, next. To begin, open
the `pixel_qa` layer using rioxarray and plot it with matplotlib.


{:.input}
```python
# Open the landsat qa layer
landsat_pre_cl_path = os.path.join("cold-springs-fire",
                                   "landsat_collect",
                                   "LC080340322016070701T1-SC20180214145604",
                                   "crop",
                                   "LC08_L1TP_034032_20160707_20170221_01_T1_pixel_qa_crop.tif")

landsat_qa = rxr.open_rasterio(landsat_pre_cl_path).squeeze()

high_cloud_confidence = em.pixel_flags["pixel_qa"]["L8"]["High Cloud Confidence"]
cloud = em.pixel_flags["pixel_qa"]["L8"]["Cloud"]
cloud_shadow = em.pixel_flags["pixel_qa"]["L8"]["Cloud Shadow"]

all_masked_values = cloud_shadow + cloud + high_cloud_confidence

# Mask the data using the pixel QA layer
landsat_pre_cl_free = landsat_pre.where(~landsat_qa.isin(all_masked_values))
```



First, plot the pixel_qa layer in matplotlib.



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-03-landsat-cloud-masks/2020-03-02-landsat-multispectral-03-landsat-cloud-masks_17_0.png" alt = "Landsat Collection Pixel QA layer for the Cold Springs fire area.">
<figcaption>Landsat Collection Pixel QA layer for the Cold Springs fire area.</figcaption>

</figure>







In the image above, you can see the cloud and the shadow that is obstructing our landsat image.
Unfortunately for you, this cloud covers a part of your analysis area in the Cold Springs
Fire location. There are a few ways to handle this issue. We will look at one:
simply masking out or removing the cloud for your analysis, first. 

To remove all pixels that are cloud and cloud shadow covered we need to first
determine what each value in our qa raster represents. The table below is from the USGS landsat website.
It describes what all of the values in the pixel_qa layer represent.

We are interested in 

1. cloud shadow
2. cloud and 
3. high confidence cloud

Note that your specific analysis may require a different set of masked pixels. For instance, your analysis may 
require you identify pixels that are low confidence clouds too. We are just using these classes
for the purpose of this class. 


| Attribute                | Pixel Value                                                     | 
|--------------------------|-----------------------------------------------------------------| 
| Fill                     | 1                                                               | 
| Clear                    | 322, 386, 834, 898, 1346                                        | 
| Water                    | 324, 388, 836, 900, 1348                                        | 
| Cloud Shadow             | 328, 392, 840, 904, 1350                                        | 
| Snow/Ice                 | 336, 368, 400, 432, 848, 880, 912, 944, 1352                    | 
| Cloud                    | 352, 368, 416, 432, 480, 864, 880, 928, 944, 992                | 
| Low confidence cloud     | 322, 324, 328, 336, 352, 368, 834, 836, 840, 848, 864, 880      | 
| Medium confidence cloud  | 386, 388, 392, 400, 416, 432, 900, 904, 928, 944                | 
| High confidence cloud    | 480, 992                                                        | 
| Low confidence cirrus    | 322, 324, 328, 336, 352, 368, 386, 388, 392, 400, 416, 432, 480 | 
| High confidence cirrus   | 834, 836, 840, 848, 864, 880, 898, 900, 904, 912, 928, 944, 992 | 
| Terrain occlusion        | 1346, 1348, 1350, 1352                                          | 
==|

To better understand the values above, create a better map of the data. To do that you will:

1. classify the data into x classes where x represents the total number of unique values in the `pixel_qa` raster.
2. plot the data using these classes.

We are reclassifying the data because matplotlib colormaps will assign colors to values along a continuous gradient.
Reclassifying the data allows us to enforce one color for each unique value in our data. 




This next section shows you how to create a mask using the xarray function `isin()` to create a binary cloud mask layer. In this mask all pixels that you wish to remove from your analysis or mask will be set to `1`. All other pixels which represent pixels you want to use in your analysis will be set to `0`.

{:.input}
```python
vals
```

{:.output}
{:.execute_result}



    [322, 324, 328, 352, 386, 416, 480, 834, 864, 928, 992]





{:.input}
```python
# You can grab the cloud pixel values from earthpy
high_cloud_confidence = em.pixel_flags["pixel_qa"]["L8"]["High Cloud Confidence"]
cloud = em.pixel_flags["pixel_qa"]["L8"]["Cloud"]
cloud_shadow = em.pixel_flags["pixel_qa"]["L8"]["Cloud Shadow"]

all_masked_values = cloud_shadow + cloud + high_cloud_confidence
all_masked_values
```

{:.output}
{:.execute_result}



    [328,
     392,
     840,
     904,
     1350,
     352,
     368,
     416,
     432,
     480,
     864,
     880,
     928,
     944,
     992,
     480,
     992]






{:.input}
```python
# Create the cloud mask
cl_mask = landsat_qa.isin(all_masked_values)
np.unique(cl_mask)
```

{:.output}
{:.execute_result}



    array([False,  True])






Below is the plot of the reclassified raster mask.

{:.input}
```python
fig, ax = plt.subplots(figsize=(12, 8))

im = ax.imshow(cl_mask,
               cmap=plt.cm.get_cmap('tab20b', 2))

cbar = ep.colorbar(im)
cbar.set_ticks((0.25, .75))
cbar.ax.set_yticklabels(["Clear Pixels", "Cloud / Shadow Pixels"])

ax.set_title("Landsat Cloud Mask | Light Purple Pixels will be Masked")
ax.set_axis_off()

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-03-landsat-cloud-masks/2020-03-02-landsat-multispectral-03-landsat-cloud-masks_30_0.png" alt = "Landsat image in which the masked pixels (cloud) are rendered in light purple.">
<figcaption>Landsat image in which the masked pixels (cloud) are rendered in light purple.</figcaption>

</figure>




## What Does the Metadata Tell You?

You just explored two layers that potentially have information about cloud cover.
However what do the values stored in those rasters mean? You can refer to the
metadata provided by USGS to learn more about how
each layer in your landsat dataset are both stored and calculated.

When you download remote sensing data, often (but not always), you will find layers
that tell us more about the error and uncertainty in the data. Often whomever
created the data will do some of the work for us to detect where clouds and
shadows are - given they are common challenges that you need to work around when
using remote sensing data.


### Create Mask Layer in Python

To create the mask this you do the following:

1. Make sure you use a raster layer for the mask that is the SAME EXTENT and the same pixel resolution as your landsat scene. In this case you have a mask layer that is already the same spatial resolution and extent as your landsat scene.
2. Set all of the values in that layer that are clouds and / or shadows to `True`
3. Finally you use the `where` function to apply the mask layer to the xarray DataArray (or the landsat scene that you are working with in Python).  all pixel locations that were flagged as clouds or shadows in your mask to `NA` in your `raster` or in this case `rasterstack`.

## Mask A Landsat Scene Using Xarray
Below you mask your data in one single step. This function `.where()` applies the mask you created above to your xarray DataArray. To apply the mask, ensure you put a `~` in front of your mask inside the `where()` function. This must be done because `isin()` creates the mask with `True` values where we want `False`, values, and vice versa. The `~` flips all of the values inside the array.

{:.input}
```python
# Mask your data using .where()
landsat_pre_cl_free = landsat_pre.where(~cl_mask)
```

Alternatively, you can directly input your mask values and the pixel QA layer into the `mask_pixels` function. This is the easiest way to mask your data! Again, this function only takes numpy arrays, so make sure to call `.values` on all of your xarray DataArrays that you are using as inputs into that function.

{:.input}
```python
# Mask your data and create the mask using one single line of code
landsat_pre_cl_free = landsat_pre.where(~landsat_qa.isin(all_masked_values))
```



{:.input}
```python
# Plot the data
ep.plot_bands(landsat_pre_cl_free[3],
              cmap="Greys",
              title="Landsat Infrared Band | 30 meters \n Post Cold Springs Fire \n July 8, 2016",
              cbar=False)
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-03-landsat-cloud-masks/2020-03-02-landsat-multispectral-03-landsat-cloud-masks_37_0.png" alt = "CIR Composite image in grey scale with mask applied, covering the post-Cold Springs fire area on July 8, 2016.">
<figcaption>CIR Composite image in grey scale with mask applied, covering the post-Cold Springs fire area on July 8, 2016.</figcaption>

</figure>




{:.input}
```python
# Plot data
# Masking out NA values with numpy in order to plot with ep.plot_rgb
landsat_pre_cl_free_plot = ma.masked_array(landsat_pre_cl_free.values,
                                           landsat_pre_cl_free.isnull())

# Plot
ep.plot_rgb(landsat_pre_cl_free_plot,
            rgb=[3, 2, 1],
            title="Landsat CIR Composite Image | 30 meters \n Post Cold Springs Fire \n July 8, 2016")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/05-multi-spectral-remote-sensing-python/landsat/2020-03-02-landsat-multispectral-03-landsat-cloud-masks/2020-03-02-landsat-multispectral-03-landsat-cloud-masks_38_0.png" alt = "CIR Composite image with cloud mask applied, covering the post-Cold Springs fire area on July 8, 2016.">
<figcaption>CIR Composite image with cloud mask applied, covering the post-Cold Springs fire area on July 8, 2016.</figcaption>

</figure>




















