---
layout: single
title: "Open and Use MODIS Data in HDF4 format in Open Source Python"
excerpt: "MODIS is remote sensing data that is stored in the HDF4 file format. Learn how to open and use MODIS data in HDF4 form in Open Source Python."
authors: ['Leah Wasser', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2021-02-16
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
from shapely.geometry import mapping
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

{:.output}
    Downloading from https://ndownloader.figshare.com/files/10960112
    Extracted output to /root/earth-analytics/data/cold-springs-modis-h4/.






## Hierarchical Data Formats - HDF4 - EOS in Python

In the previous lesson, you learned about the HDF4 file format, which is 
a common format used to store MODIS remote sensing data. In this lesson, 
you will learn how to open and process remote sensing data stored in HDF4 
format.

You can use **xarray** and the wrapper for **raster** to open HDF4 data.
Note that both tools wrap around **gdal** and will make the code needed
to open your HDF4 data, simpler.  

To begin, create a path to your HDF4 file.

{:.input}
```python
# Create a path to the pre-fire MODIS h4 data
pre_fire_path = os.path.join("cold-springs-modis-h4",
                             "07_july_2016",
                             "MOD09GA.A2016189.h09v05.006.2016191073856.hdf")
pre_fire_path
```

{:.output}
{:.execute_result}



    'cold-springs-modis-h4/07_july_2016/MOD09GA.A2016189.h09v05.006.2016191073856.hdf'





## Open HDF4 Files Using Open Source Python and Xarray

HDF files are hierarchical and self describing (the metadata is contained 
within the data). Because the data are hierarchical, you will have to loop
through the main dataset and the subdatasets nested within the main dataset 
to access the reflectance data (the bands) and the **qa** layers. 

The first context manager below opens the main HDF4 file. 

Notice that this layer has 
some metatadata associated with it. However, there is not CRS or proper affine 
information for the spatial layers contained within the file. 

To access that information, you will need to access the bands which are stored as subdatasets within the 
HDF4 file. 

{:.input}
```python
# Open  data  with rioxarray
modis_pre = rxr.open_rasterio(pre_fire_path,
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
Dimensions:               (band: 1, x: 1200, y: 1200)
Coordinates:
  * y                     (y) float64 4.447e+06 4.446e+06 ... 3.336e+06
  * x                     (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06
  * band                  (band) int64 1
    spatial_ref           int64 0
Data variables:
    num_observations_1km  (band, y, x) float64 ...
    granule_pnt_1         (band, y, x) float64 ...
    state_1km_1           (band, y, x) float64 ...
    SensorZenith_1        (band, y, x) float64 ...
    SensorAzimuth_1       (band, y, x) float64 ...
    Range_1               (band, y, x) float64 ...
    SolarZenith_1         (band, y, x) float64 ...
    SolarAzimuth_1        (band, y, x) float64 ...
    gflags_1              (band, y, x) float64 ...
    orbit_pnt_1           (band, y, x) float64 ...
Attributes:
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    AUTOMATICQUALITYFLAGEXPLANATION.1:   No automatic quality assessment is p...
    CHARACTERISTICBINANGULARSIZE1KM:     30.0
    CHARACTERISTICBINANGULARSIZE500M:    15.0
    CHARACTERISTICBINSIZE1KM:            926.625433055556
    CHARACTERISTICBINSIZE500M:           463.312716527778
    CLOUDOPTION:                         MOD09 internally-derived
    COVERAGECALCULATIONMETHOD:           volume
    COVERAGEMINIMUM:                     0.00999999977648258
    DATACOLUMNS1KM:                      1200
    DATACOLUMNS500M:                     2400
    DATAROWS1KM:                         1200
    DATAROWS500M:                        2400
    DAYNIGHTFLAG:                        Day
    DEEPOCEANFLAG:                       Yes
    DESCRREVISION:                       6.1
    EASTBOUNDINGCOORDINATE:              -92.3664205550513
    EQUATORCROSSINGDATE.1:               2016-07-07
    EQUATORCROSSINGDATE.2:               2016-07-07
    EQUATORCROSSINGLONGITUDE.1:          -103.273195919522
    EQUATORCROSSINGLONGITUDE.2:          -127.994803619317
    EQUATORCROSSINGTIME.1:               17:23:36.891214
    EQUATORCROSSINGTIME.2:               19:02:29.990629
    EXCLUSIONGRINGFLAG.1:                N
    FIRSTLAYERSELECTIONCRITERIA:         order of input pointer
    GEOANYABNORMAL:                      False
    GEOESTMAXRMSERROR:                   50.0
    GLOBALGRIDCOLUMNS1KM:                43200
    GLOBALGRIDCOLUMNS500M:               86400
    GLOBALGRIDROWS1KM:                   21600
    GLOBALGRIDROWS500M:                  43200
    GRANULEBEGINNINGDATETIME:            2016-07-07T17:10:00.000000Z
    GRANULEBEGINNINGDATETIMEARRAY:       2016-07-07T17:10:00.000000Z, 2016-07...
    GRANULEDAYNIGHTFLAG:                 Day
    GRANULEDAYNIGHTFLAGARRAY:            Day, Day, Day, Day
    GRANULEDAYOFYEAR:                    189
    GRANULEENDINGDATETIME:               2016-07-07T18:55:00.000000Z
    GRANULEENDINGDATETIMEARRAY:          2016-07-07T17:15:00.000000Z, 2016-07...
    GRANULENUMBERARRAY:                  208, 209, 228, 247, -1, -1, -1, -1, ...
    GRANULEPOINTERARRAY:                 0, 1, 2, -1, -1, -1, -1, -1, -1, -1,...
    GRINGPOINTLATITUDE.1:                29.8360532722546, 39.9999999964079, ...
    GRINGPOINTLONGITUDE.1:               -103.835851753394, -117.486656023174...
    GRINGPOINTSEQUENCENO.1:              1, 2, 3, 4
    HDFEOSVersion:                       HDFEOS_V2.17
    HORIZONTALTILENUMBER:                9
    identifier_product_doi:              10.5067/MODIS/MOD09GA.006
    identifier_product_doi_authority:    http://dx.doi.org
    INPUTPOINTER:                        MOD09GST.A2016189.h09v05.006.2016191...
    KEEPALL:                             No
    L2GSTORAGEFORMAT1KM:                 compact
    L2GSTORAGEFORMAT500M:                compact
    l2g_storage_format_1km:              compact
    l2g_storage_format_500m:             compact
    LOCALGRANULEID:                      MOD09GA.A2016189.h09v05.006.20161910...
    LOCALVERSIONID:                      6.0.9
    LONGNAME:                            MODIS/Terra Surface Reflectance Dail...
    MAXIMUMOBSERVATIONS1KM:              12
    MAXIMUMOBSERVATIONS500M:             2
    maximum_observations_1km:            12
    maximum_observations_500m:           2
    MAXOUTPUTRES:                        QKM
    NADIRDATARESOLUTION1KM:              1km
    NADIRDATARESOLUTION500M:             500m
    NORTHBOUNDINGCOORDINATE:             39.9999999964079
    NumberLandWater1km:                  0, 1418266, 15655, 6079, 0, 0, 0, 0, 0
    NumberLandWater500m:                 0, 2836532, 31310, 12158, 0, 0, 0, 0, 0
    NUMBEROFGRANULES:                    1
    NUMBEROFINPUTGRANULES:               4
    NUMBEROFORBITS:                      2
    NUMBEROFOVERLAPGRANULES:             3
    ORBITNUMBER.1:                       88050
    ORBITNUMBER.2:                       88051
    ORBITNUMBERARRAY:                    88050, 88050, 88051, -1, -1, -1, -1,...
    PARAMETERNAME.1:                     MOD09G
    PERCENTCLOUDY:                       13
    PERCENTLAND:                         97
    PERCENTLANDSEAMASKCLASS:             0, 97, 3, 0, 0, 0, 0, 0
    PERCENTLOWSUN:                       0
    PERCENTPROCESSED:                    100
    PERCENTSHADOW:                       2
    PGEVERSION:                          6.0.32
    PROCESSINGCENTER:                    MODAPS
    PROCESSINGENVIRONMENT:               Linux minion6007 2.6.32-642.1.1.el6....
    PROCESSVERSION:                      6.0.9
    PRODUCTIONDATETIME:                  2016-07-09T07:38:56.000Z
    QAPERCENTGOODQUALITY:                100
    QAPERCENTINTERPOLATEDDATA.1:         0
    QAPERCENTMISSINGDATA.1:              0
    QAPERCENTNOTPRODUCEDCLOUD:           0
    QAPERCENTNOTPRODUCEDOTHER:           0
    QAPERCENTOTHERQUALITY:               0
    QAPERCENTOUTOFBOUNDSDATA.1:          0
    QAPERCENTPOOROUTPUT500MBAND1:        0
    QAPERCENTPOOROUTPUT500MBAND2:        0
    QAPERCENTPOOROUTPUT500MBAND3:        0
    QAPERCENTPOOROUTPUT500MBAND4:        0
    QAPERCENTPOOROUTPUT500MBAND5:        0
    QAPERCENTPOOROUTPUT500MBAND6:        0
    QAPERCENTPOOROUTPUT500MBAND7:        0
    QUALITYCLASSPERCENTAGE500MBAND1:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND2:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND3:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND4:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND5:     96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0,...
    QUALITYCLASSPERCENTAGE500MBAND6:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND7:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    RANGEBEGINNINGDATE:                  2016-07-07
    RANGEBEGINNINGTIME:                  17:10:00.000000
    RANGEENDINGDATE:                     2016-07-07
    RANGEENDINGTIME:                     18:55:00.000000
    RANKING:                             No
    REPROCESSINGACTUAL:                  processed once
    REPROCESSINGPLANNED:                 further update is anticipated
    RESOLUTIONBANDS1AND2:                500
    SCIENCEQUALITYFLAG.1:                Not Investigated
    SCIENCEQUALITYFLAGEXPLANATION.1:     See http://landweb.nascom.nasa.gov/c...
    SHORTNAME:                           MOD09GA
    SOUTHBOUNDINGCOORDINATE:             29.9999999973059
    SPSOPARAMETERS:                      2015
    SYSTEMFILENAME:                      MOD09GST.A2016189.h09v05.006.2016191...
    TileID:                              51009005
    TOTALADDITIONALOBSERVATIONS1KM:      2705510
    TOTALADDITIONALOBSERVATIONS500M:     660129
    TOTALOBSERVATIONS1KM:                4145510
    TOTALOBSERVATIONS500M:               6420120
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-0e882e97-111f-4ff7-af07-d9a168cabb0b' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-0e882e97-111f-4ff7-af07-d9a168cabb0b' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>x</span>: 1200</li><li><span class='xr-has-index'>y</span>: 1200</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-8d8a7538-28b8-4052-9c28-99c793fc1809' class='xr-section-summary-in' type='checkbox'  checked><label for='section-8d8a7538-28b8-4052-9c28-99c793fc1809' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-86720ec6-21b7-40ec-8edd-091b95f47a1f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-86720ec6-21b7-40ec-8edd-091b95f47a1f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-415d1fd7-127d-489b-864e-4b3c0921c12e' class='xr-var-data-in' type='checkbox'><label for='data-415d1fd7-127d-489b-864e-4b3c0921c12e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-d01aba51-3560-4b8d-84ab-a3819c07691a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-d01aba51-3560-4b8d-84ab-a3819c07691a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cd00e4d9-8c99-4bc2-bb4f-1ad93f59304c' class='xr-var-data-in' type='checkbox'><label for='data-cd00e4d9-8c99-4bc2-bb4f-1ad93f59304c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-2182c2ec-d6f7-40c8-9f81-ef4018341d9c' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2182c2ec-d6f7-40c8-9f81-ef4018341d9c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9f973540-f327-489a-8493-eeef613f8458' class='xr-var-data-in' type='checkbox'><label for='data-9f973540-f327-489a-8493-eeef613f8458' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-e27406b6-0b2c-41c8-b799-b7f9af6727d1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e27406b6-0b2c-41c8-b799-b7f9af6727d1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bf1bacbb-ea58-46a9-8696-8bee615c5c90' class='xr-var-data-in' type='checkbox'><label for='data-bf1bacbb-ea58-46a9-8696-8bee615c5c90' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-69d58421-fec0-48e1-ac71-b46c2e76c9ef' class='xr-section-summary-in' type='checkbox'  checked><label for='section-69d58421-fec0-48e1-ac71-b46c2e76c9ef' class='xr-section-summary' >Data variables: <span>(10)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_1km</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-1f196112-f055-4446-a8e6-50a92ddc2419' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1f196112-f055-4446-a8e6-50a92ddc2419' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-19dcb9af-da49-4803-bd7d-7bb6a72aa9a7' class='xr-var-data-in' type='checkbox'><label for='data-19dcb9af-da49-4803-bd7d-7bb6a72aa9a7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>granule_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-cac051e5-f9b4-4cf4-b524-6669fa52a879' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-cac051e5-f9b4-4cf4-b524-6669fa52a879' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-57b2cf63-62a7-4426-a28e-8d37f27969c4' class='xr-var-data-in' type='checkbox'><label for='data-57b2cf63-62a7-4426-a28e-8d37f27969c4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Granule Pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>state_1km_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-ba4e1ed2-db67-430a-9dee-57554cb837cd' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ba4e1ed2-db67-430a-9dee-57554cb837cd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c55ad533-3284-43d9-8887-4f52f9a9328f' class='xr-var-data-in' type='checkbox'><label for='data-c55ad533-3284-43d9-8887-4f52f9a9328f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>1km Reflectance Data State QA - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-6b4d8fec-7b4e-4fc3-9d9d-ecf3c40dc591' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-6b4d8fec-7b4e-4fc3-9d9d-ecf3c40dc591' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bd553c27-d2c4-464d-bd23-81054a31e56b' class='xr-var-data-in' type='checkbox'><label for='data-bd553c27-d2c4-464d-bd23-81054a31e56b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-a44547a0-4b97-4ea8-b20d-9137d7ddcce0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a44547a0-4b97-4ea8-b20d-9137d7ddcce0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ec6c16c9-ab51-4db4-bd90-a3fcbd4f81d5' class='xr-var-data-in' type='checkbox'><label for='data-ec6c16c9-ab51-4db4-bd90-a3fcbd4f81d5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>Range_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-0099c9fb-e7d8-464b-bff1-7af6bce040a4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0099c9fb-e7d8-464b-bff1-7af6bce040a4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8dd5b9ec-6567-44ae-85d4-d5a99549f708' class='xr-var-data-in' type='checkbox'><label for='data-8dd5b9ec-6567-44ae-85d4-d5a99549f708' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>25.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Range (pixel to sensor) - first layer</dd><dt><span>units :</span></dt><dd>meters</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-e040de23-7d73-4a60-80b5-fb51deab8223' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e040de23-7d73-4a60-80b5-fb51deab8223' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3a770d48-65e3-4846-91fb-b1a30764f3fd' class='xr-var-data-in' type='checkbox'><label for='data-3a770d48-65e3-4846-91fb-b1a30764f3fd' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-7302911a-b2fa-4757-a0c7-fe528043883f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7302911a-b2fa-4757-a0c7-fe528043883f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-01101c00-7c19-4345-8c09-d08f1e0cd85f' class='xr-var-data-in' type='checkbox'><label for='data-01101c00-7c19-4345-8c09-d08f1e0cd85f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>gflags_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-bb45940f-f5eb-46aa-bbd9-a7fb1f1db210' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-bb45940f-f5eb-46aa-bbd9-a7fb1f1db210' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f2aaeb50-9593-487d-a1dc-181602d89fa0' class='xr-var-data-in' type='checkbox'><label for='data-f2aaeb50-9593-487d-a1dc-181602d89fa0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Geolocation flags - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>orbit_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3a4b3eef-95cc-46d5-ad80-5879dd59b740' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3a4b3eef-95cc-46d5-ad80-5879dd59b740' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-19ec1390-568e-4791-9782-7b9c742fcb33' class='xr-var-data-in' type='checkbox'><label for='data-19ec1390-568e-4791-9782-7b9c742fcb33' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Orbit pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-07e60dfb-920c-48a5-8a02-7ea5bc64400e' class='xr-section-summary-in' type='checkbox'  ><label for='section-07e60dfb-920c-48a5-8a02-7ea5bc64400e' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
[1440000 values with dtype=float64]
Coordinates:
  * y            (y) float64 4.447e+06 4.446e+06 ... 3.337e+06 3.336e+06
  * x            (x) float64 -1.001e+07 -1.001e+07 ... -8.897e+06 -8.896e+06
  * band         (band) int64 1
    spatial_ref  int64 0
Attributes:
    scale_factor:  1.0
    add_offset:    0.0
    long_name:     Number of Observations
    units:         none
    grid_mapping:  spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'num_observations_1km'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>y</span>: 1200</li><li><span class='xr-has-index'>x</span>: 1200</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-22ff9097-c5c6-4cbe-911d-a2965dbc8df6' class='xr-array-in' type='checkbox' checked><label for='section-22ff9097-c5c6-4cbe-911d-a2965dbc8df6' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[1440000 values with dtype=float64]</pre></div></div></li><li class='xr-section-item'><input id='section-eee195f6-c130-4d29-a1f3-ab18daa5a116' class='xr-section-summary-in' type='checkbox'  checked><label for='section-eee195f6-c130-4d29-a1f3-ab18daa5a116' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-764dd8bd-e447-49c1-afda-22365258b51c' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-764dd8bd-e447-49c1-afda-22365258b51c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a33a09dd-54c6-47f9-bfe5-a513043e6c89' class='xr-var-data-in' type='checkbox'><label for='data-a33a09dd-54c6-47f9-bfe5-a513043e6c89' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-cbf3f50f-4aef-4567-8e01-8d999fc2a904' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-cbf3f50f-4aef-4567-8e01-8d999fc2a904' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-885c8db7-ff93-4862-a0f9-88e5356f66ca' class='xr-var-data-in' type='checkbox'><label for='data-885c8db7-ff93-4862-a0f9-88e5356f66ca' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-121cbcc4-694d-45ef-8111-2bb413a17a1e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-121cbcc4-694d-45ef-8111-2bb413a17a1e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-076350ac-628c-49a7-b72e-2952c01a2650' class='xr-var-data-in' type='checkbox'><label for='data-076350ac-628c-49a7-b72e-2952c01a2650' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-aeecd23c-983e-4c5d-9c04-d58a6d82c628' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aeecd23c-983e-4c5d-9c04-d58a6d82c628' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-96827b19-d5ba-4a89-983d-8fb775041b9f' class='xr-var-data-in' type='checkbox'><label for='data-96827b19-d5ba-4a89-983d-8fb775041b9f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-5fbe2b07-086f-4f79-951e-60fde5bff12f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-5fbe2b07-086f-4f79-951e-60fde5bff12f' class='xr-section-summary' >Attributes: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





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
Dimensions:                (band: 1, x: 2400, y: 2400)
Coordinates:
  * y                      (y) float64 4.448e+06 4.447e+06 ... 3.336e+06
  * x                      (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06
  * band                   (band) int64 1
    spatial_ref            int64 0
Data variables:
    num_observations_500m  (band, y, x) float64 ...
    sur_refl_b01_1         (band, y, x) float64 ...
    sur_refl_b02_1         (band, y, x) float64 ...
    sur_refl_b03_1         (band, y, x) float64 ...
    sur_refl_b04_1         (band, y, x) float64 ...
    sur_refl_b05_1         (band, y, x) float64 ...
    sur_refl_b06_1         (band, y, x) float64 ...
    sur_refl_b07_1         (band, y, x) float64 ...
    QC_500m_1              (band, y, x) float64 ...
    obscov_500m_1          (band, y, x) float64 ...
    iobs_res_1             (band, y, x) float64 ...
    q_scan_1               (band, y, x) float64 ...
Attributes:
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    AUTOMATICQUALITYFLAGEXPLANATION.1:   No automatic quality assessment is p...
    CHARACTERISTICBINANGULARSIZE1KM:     30.0
    CHARACTERISTICBINANGULARSIZE500M:    15.0
    CHARACTERISTICBINSIZE1KM:            926.625433055556
    CHARACTERISTICBINSIZE500M:           463.312716527778
    CLOUDOPTION:                         MOD09 internally-derived
    COVERAGECALCULATIONMETHOD:           volume
    COVERAGEMINIMUM:                     0.00999999977648258
    DATACOLUMNS1KM:                      1200
    DATACOLUMNS500M:                     2400
    DATAROWS1KM:                         1200
    DATAROWS500M:                        2400
    DAYNIGHTFLAG:                        Day
    DEEPOCEANFLAG:                       Yes
    DESCRREVISION:                       6.1
    EASTBOUNDINGCOORDINATE:              -92.3664205550513
    EQUATORCROSSINGDATE.1:               2016-07-07
    EQUATORCROSSINGDATE.2:               2016-07-07
    EQUATORCROSSINGLONGITUDE.1:          -103.273195919522
    EQUATORCROSSINGLONGITUDE.2:          -127.994803619317
    EQUATORCROSSINGTIME.1:               17:23:36.891214
    EQUATORCROSSINGTIME.2:               19:02:29.990629
    EXCLUSIONGRINGFLAG.1:                N
    FIRSTLAYERSELECTIONCRITERIA:         order of input pointer
    GEOANYABNORMAL:                      False
    GEOESTMAXRMSERROR:                   50.0
    GLOBALGRIDCOLUMNS1KM:                43200
    GLOBALGRIDCOLUMNS500M:               86400
    GLOBALGRIDROWS1KM:                   21600
    GLOBALGRIDROWS500M:                  43200
    GRANULEBEGINNINGDATETIME:            2016-07-07T17:10:00.000000Z
    GRANULEBEGINNINGDATETIMEARRAY:       2016-07-07T17:10:00.000000Z, 2016-07...
    GRANULEDAYNIGHTFLAG:                 Day
    GRANULEDAYNIGHTFLAGARRAY:            Day, Day, Day, Day
    GRANULEDAYOFYEAR:                    189
    GRANULEENDINGDATETIME:               2016-07-07T18:55:00.000000Z
    GRANULEENDINGDATETIMEARRAY:          2016-07-07T17:15:00.000000Z, 2016-07...
    GRANULENUMBERARRAY:                  208, 209, 228, 247, -1, -1, -1, -1, ...
    GRANULEPOINTERARRAY:                 0, 1, 2, -1, -1, -1, -1, -1, -1, -1,...
    GRINGPOINTLATITUDE.1:                29.8360532722546, 39.9999999964079, ...
    GRINGPOINTLONGITUDE.1:               -103.835851753394, -117.486656023174...
    GRINGPOINTSEQUENCENO.1:              1, 2, 3, 4
    HDFEOSVersion:                       HDFEOS_V2.17
    HORIZONTALTILENUMBER:                9
    identifier_product_doi:              10.5067/MODIS/MOD09GA.006
    identifier_product_doi_authority:    http://dx.doi.org
    INPUTPOINTER:                        MOD09GST.A2016189.h09v05.006.2016191...
    KEEPALL:                             No
    L2GSTORAGEFORMAT1KM:                 compact
    L2GSTORAGEFORMAT500M:                compact
    l2g_storage_format_1km:              compact
    l2g_storage_format_500m:             compact
    LOCALGRANULEID:                      MOD09GA.A2016189.h09v05.006.20161910...
    LOCALVERSIONID:                      6.0.9
    LONGNAME:                            MODIS/Terra Surface Reflectance Dail...
    MAXIMUMOBSERVATIONS1KM:              12
    MAXIMUMOBSERVATIONS500M:             2
    maximum_observations_1km:            12
    maximum_observations_500m:           2
    MAXOUTPUTRES:                        QKM
    NADIRDATARESOLUTION1KM:              1km
    NADIRDATARESOLUTION500M:             500m
    NORTHBOUNDINGCOORDINATE:             39.9999999964079
    NumberLandWater1km:                  0, 1418266, 15655, 6079, 0, 0, 0, 0, 0
    NumberLandWater500m:                 0, 2836532, 31310, 12158, 0, 0, 0, 0, 0
    NUMBEROFGRANULES:                    1
    NUMBEROFINPUTGRANULES:               4
    NUMBEROFORBITS:                      2
    NUMBEROFOVERLAPGRANULES:             3
    ORBITNUMBER.1:                       88050
    ORBITNUMBER.2:                       88051
    ORBITNUMBERARRAY:                    88050, 88050, 88051, -1, -1, -1, -1,...
    PARAMETERNAME.1:                     MOD09G
    PERCENTCLOUDY:                       13
    PERCENTLAND:                         97
    PERCENTLANDSEAMASKCLASS:             0, 97, 3, 0, 0, 0, 0, 0
    PERCENTLOWSUN:                       0
    PERCENTPROCESSED:                    100
    PERCENTSHADOW:                       2
    PGEVERSION:                          6.0.32
    PROCESSINGCENTER:                    MODAPS
    PROCESSINGENVIRONMENT:               Linux minion6007 2.6.32-642.1.1.el6....
    PROCESSVERSION:                      6.0.9
    PRODUCTIONDATETIME:                  2016-07-09T07:38:56.000Z
    QAPERCENTGOODQUALITY:                100
    QAPERCENTINTERPOLATEDDATA.1:         0
    QAPERCENTMISSINGDATA.1:              0
    QAPERCENTNOTPRODUCEDCLOUD:           0
    QAPERCENTNOTPRODUCEDOTHER:           0
    QAPERCENTOTHERQUALITY:               0
    QAPERCENTOUTOFBOUNDSDATA.1:          0
    QAPERCENTPOOROUTPUT500MBAND1:        0
    QAPERCENTPOOROUTPUT500MBAND2:        0
    QAPERCENTPOOROUTPUT500MBAND3:        0
    QAPERCENTPOOROUTPUT500MBAND4:        0
    QAPERCENTPOOROUTPUT500MBAND5:        0
    QAPERCENTPOOROUTPUT500MBAND6:        0
    QAPERCENTPOOROUTPUT500MBAND7:        0
    QUALITYCLASSPERCENTAGE500MBAND1:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND2:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND3:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND4:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND5:     96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0,...
    QUALITYCLASSPERCENTAGE500MBAND6:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND7:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    RANGEBEGINNINGDATE:                  2016-07-07
    RANGEBEGINNINGTIME:                  17:10:00.000000
    RANGEENDINGDATE:                     2016-07-07
    RANGEENDINGTIME:                     18:55:00.000000
    RANKING:                             No
    REPROCESSINGACTUAL:                  processed once
    REPROCESSINGPLANNED:                 further update is anticipated
    RESOLUTIONBANDS1AND2:                500
    SCIENCEQUALITYFLAG.1:                Not Investigated
    SCIENCEQUALITYFLAGEXPLANATION.1:     See http://landweb.nascom.nasa.gov/c...
    SHORTNAME:                           MOD09GA
    SOUTHBOUNDINGCOORDINATE:             29.9999999973059
    SPSOPARAMETERS:                      2015
    SYSTEMFILENAME:                      MOD09GST.A2016189.h09v05.006.2016191...
    TileID:                              51009005
    TOTALADDITIONALOBSERVATIONS1KM:      2705510
    TOTALADDITIONALOBSERVATIONS500M:     660129
    TOTALOBSERVATIONS1KM:                4145510
    TOTALOBSERVATIONS500M:               6420120
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-a775c89e-4629-4061-8b57-9f8c4f0e7098' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-a775c89e-4629-4061-8b57-9f8c4f0e7098' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>x</span>: 2400</li><li><span class='xr-has-index'>y</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-08f72051-4545-4e24-b0e1-d22dcfad984f' class='xr-section-summary-in' type='checkbox'  checked><label for='section-08f72051-4545-4e24-b0e1-d22dcfad984f' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-60ed1abb-bacb-4945-83cb-a60a443b5b4c' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-60ed1abb-bacb-4945-83cb-a60a443b5b4c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-17ab1562-fab4-4d37-af38-401ffe76e70f' class='xr-var-data-in' type='checkbox'><label for='data-17ab1562-fab4-4d37-af38-401ffe76e70f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-0dd3b239-33bd-49c4-8931-f9900e90f47e' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-0dd3b239-33bd-49c4-8931-f9900e90f47e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-430c7ed9-e191-42f3-af32-2f730902104d' class='xr-var-data-in' type='checkbox'><label for='data-430c7ed9-e191-42f3-af32-2f730902104d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-2247759e-0b0a-414b-b67d-ff3f0345b719' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2247759e-0b0a-414b-b67d-ff3f0345b719' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6fd75ee1-0a23-4316-b3bb-072fe6266cba' class='xr-var-data-in' type='checkbox'><label for='data-6fd75ee1-0a23-4316-b3bb-072fe6266cba' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-f4d96cde-4c43-4cda-8e4f-9c6cf703b368' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f4d96cde-4c43-4cda-8e4f-9c6cf703b368' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e4ff43f5-3053-4548-b9c4-24b009233ee7' class='xr-var-data-in' type='checkbox'><label for='data-e4ff43f5-3053-4548-b9c4-24b009233ee7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-bd41600e-51bf-4b01-b7e2-9d0fd4b78cb8' class='xr-section-summary-in' type='checkbox'  checked><label for='section-bd41600e-51bf-4b01-b7e2-9d0fd4b78cb8' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-f4de1062-5c96-477f-b591-7a46ac2fce65' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f4de1062-5c96-477f-b591-7a46ac2fce65' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d468718a-4f81-4dc7-bc09-1c9b6b9d8b6e' class='xr-var-data-in' type='checkbox'><label for='data-d468718a-4f81-4dc7-bc09-1c9b6b9d8b6e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-dc89240a-1924-4e67-8b86-59f5e16aa53d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-dc89240a-1924-4e67-8b86-59f5e16aa53d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fb7d7f7c-ed2e-4bfd-8ccf-0aac55078361' class='xr-var-data-in' type='checkbox'><label for='data-fb7d7f7c-ed2e-4bfd-8ccf-0aac55078361' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3265f3b4-3c7e-4162-ad2d-222c57822ed4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3265f3b4-3c7e-4162-ad2d-222c57822ed4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8179dc3f-0487-414d-80db-a3ce0a706cd7' class='xr-var-data-in' type='checkbox'><label for='data-8179dc3f-0487-414d-80db-a3ce0a706cd7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-045abe04-0641-4dbb-8d41-722b7e10b958' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-045abe04-0641-4dbb-8d41-722b7e10b958' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-88986cee-c1fc-4d6f-9ee2-c1485b53be71' class='xr-var-data-in' type='checkbox'><label for='data-88986cee-c1fc-4d6f-9ee2-c1485b53be71' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9ce94c3f-3e71-48ea-96e1-56c8a7feec38' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9ce94c3f-3e71-48ea-96e1-56c8a7feec38' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c07dcf81-f8b2-46af-b86a-a08059304c15' class='xr-var-data-in' type='checkbox'><label for='data-c07dcf81-f8b2-46af-b86a-a08059304c15' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-0c7d42bc-1967-476e-89e6-7ad1a7ae562b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0c7d42bc-1967-476e-89e6-7ad1a7ae562b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3c3b383a-1908-4445-8ef4-4eda2942ee9e' class='xr-var-data-in' type='checkbox'><label for='data-3c3b383a-1908-4445-8ef4-4eda2942ee9e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3fc800aa-c5dc-4897-a952-ce2cfd5743e3' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3fc800aa-c5dc-4897-a952-ce2cfd5743e3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0a9eecf2-7d1e-42d3-b761-acfd79953c91' class='xr-var-data-in' type='checkbox'><label for='data-0a9eecf2-7d1e-42d3-b761-acfd79953c91' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d7792083-f418-4f01-8a5f-8c91d33f800e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d7792083-f418-4f01-8a5f-8c91d33f800e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fbbc9fea-2241-4b99-a69d-91f987effb4a' class='xr-var-data-in' type='checkbox'><label for='data-fbbc9fea-2241-4b99-a69d-91f987effb4a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-e5e077f3-855b-407d-b39f-b8f25433609d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e5e077f3-855b-407d-b39f-b8f25433609d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4679c599-11aa-425d-ab46-90389a5c6f13' class='xr-var-data-in' type='checkbox'><label for='data-4679c599-11aa-425d-ab46-90389a5c6f13' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-7b5e0f3a-130b-4a64-877e-4bd67e9d7963' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7b5e0f3a-130b-4a64-877e-4bd67e9d7963' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2736c7f2-b3f4-416a-9e1e-bfdb3bb8b415' class='xr-var-data-in' type='checkbox'><label for='data-2736c7f2-b3f4-416a-9e1e-bfdb3bb8b415' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-aaff41a0-96c2-495e-8eeb-a8aff5145909' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aaff41a0-96c2-495e-8eeb-a8aff5145909' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-37e9eee7-0acf-4529-aa88-e432aee9f70b' class='xr-var-data-in' type='checkbox'><label for='data-37e9eee7-0acf-4529-aa88-e432aee9f70b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-755f9ba9-db64-41b6-8451-a7812bd81712' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-755f9ba9-db64-41b6-8451-a7812bd81712' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-95031c9d-3b9f-48fc-9382-514137bb9105' class='xr-var-data-in' type='checkbox'><label for='data-95031c9d-3b9f-48fc-9382-514137bb9105' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-d9774e17-5036-41e3-a390-513223d08dd3' class='xr-section-summary-in' type='checkbox'  ><label for='section-d9774e17-5036-41e3-a390-513223d08dd3' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>






{:.input}
```python
# View dataset metadata
# with rio.open(pre_fire_path) as dataset:
#     print(dataset)
#     hdf4_meta = dataset.meta

# # Notice that there are metadata at the highest level of the file
# hdf4_meta
```

To access the spatial information stored within your HDF4 file, you will need 
to loop through the subdatasets. 

Below you open a connection to the main HDF4 file, 
then you loop through each subdataset in the file. 

The files with this pattern 
in the name:

`sur_refl_b01_1`  

are the bands which contain surface reflectance data. 

* **sur_refl_b01_1:** MODIS Band One
* **sur_refl_b02_1:** MODIS Band Two

etc.

Below you loop through and print the name of each subdataset in the file.

Notice that there are some other layers in the file as well including the 
`state_1km` layer which contains the QA (cloud and quality assurance) information.

{:.input}
```python
# # Print all of the subdatasets in the data
# with rio.open(pre_fire_path) as dataset:
#     crs = dataset.read_crs()
#     for name in dataset.subdatasets:
#         print(name)
```

## Process MODIS Bands Stored in a HDF4 File

Xarray has several built in plot methods making it easy to explore your
data. Below you plot t he first band.



{:.input}
```python
# Plot  band one of the data
#  TODO - - this is  odd  because th e smallest  value is actually -100 -
#  why is -10000  on  this  cmap bar?
ep.plot_bands(modis_pre_bands.sur_refl_b01_1)
# modis_pre_bands.sur_refl_b01_1.plot(cmap="Greys")
# plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_20_0.png">

</figure>




{:.output}
{:.execute_result}



    <AxesSubplot:>





{:.input}
```python
# Note that you can also call the data variable by name
ep.plot_bands(modis_pre_bands["sur_refl_b01_1"])
# modis_pre_bands["sur_refl_b01_1"].plot(cmap="Greys")
# plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_21_0.png">

</figure>




{:.output}
{:.execute_result}



    <AxesSubplot:>







###  Create an RGB plot



{:.input}
```python
# This works to get a list of variables
# for var_name, values in modis_pre_bands.items():
#     print(var_name)
```

{:.input}
```python
# This also works (and is cleaner)
all_vars = list(modis_pre_bands.data_vars)
all_vars
```

{:.output}
{:.execute_result}



    ['num_observations_500m',
     'sur_refl_b01_1',
     'sur_refl_b02_1',
     'sur_refl_b03_1',
     'sur_refl_b04_1',
     'sur_refl_b05_1',
     'sur_refl_b06_1',
     'sur_refl_b07_1',
     'QC_500m_1',
     'obscov_500m_1',
     'iobs_res_1',
     'q_scan_1']





{:.input}
```python
# Select just the data variable names with b0 in the name (bands)
    
all_bands_l = [item for item in all_vars if "b0" in item]
all_bands_l
```

{:.output}
{:.execute_result}



    ['sur_refl_b01_1',
     'sur_refl_b02_1',
     'sur_refl_b03_1',
     'sur_refl_b04_1',
     'sur_refl_b05_1',
     'sur_refl_b06_1',
     'sur_refl_b07_1']








{:.input}
```python
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
Dimensions:                (band: 1, x: 2400, y: 2400)
Coordinates:
  * y                      (y) float64 4.448e+06 4.447e+06 ... 3.336e+06
  * x                      (x) float64 -1.001e+07 -1.001e+07 ... -8.896e+06
  * band                   (band) int64 1
    spatial_ref            int64 0
Data variables:
    num_observations_500m  (band, y, x) float64 ...
    sur_refl_b01_1         (band, y, x) float64 ...
    sur_refl_b02_1         (band, y, x) float64 ...
    sur_refl_b03_1         (band, y, x) float64 ...
    sur_refl_b04_1         (band, y, x) float64 ...
    sur_refl_b05_1         (band, y, x) float64 ...
    sur_refl_b06_1         (band, y, x) float64 ...
    sur_refl_b07_1         (band, y, x) float64 ...
    QC_500m_1              (band, y, x) float64 ...
    obscov_500m_1          (band, y, x) float64 ...
    iobs_res_1             (band, y, x) float64 ...
    q_scan_1               (band, y, x) float64 ...
Attributes:
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    AUTOMATICQUALITYFLAGEXPLANATION.1:   No automatic quality assessment is p...
    CHARACTERISTICBINANGULARSIZE1KM:     30.0
    CHARACTERISTICBINANGULARSIZE500M:    15.0
    CHARACTERISTICBINSIZE1KM:            926.625433055556
    CHARACTERISTICBINSIZE500M:           463.312716527778
    CLOUDOPTION:                         MOD09 internally-derived
    COVERAGECALCULATIONMETHOD:           volume
    COVERAGEMINIMUM:                     0.00999999977648258
    DATACOLUMNS1KM:                      1200
    DATACOLUMNS500M:                     2400
    DATAROWS1KM:                         1200
    DATAROWS500M:                        2400
    DAYNIGHTFLAG:                        Day
    DEEPOCEANFLAG:                       Yes
    DESCRREVISION:                       6.1
    EASTBOUNDINGCOORDINATE:              -92.3664205550513
    EQUATORCROSSINGDATE.1:               2016-07-07
    EQUATORCROSSINGDATE.2:               2016-07-07
    EQUATORCROSSINGLONGITUDE.1:          -103.273195919522
    EQUATORCROSSINGLONGITUDE.2:          -127.994803619317
    EQUATORCROSSINGTIME.1:               17:23:36.891214
    EQUATORCROSSINGTIME.2:               19:02:29.990629
    EXCLUSIONGRINGFLAG.1:                N
    FIRSTLAYERSELECTIONCRITERIA:         order of input pointer
    GEOANYABNORMAL:                      False
    GEOESTMAXRMSERROR:                   50.0
    GLOBALGRIDCOLUMNS1KM:                43200
    GLOBALGRIDCOLUMNS500M:               86400
    GLOBALGRIDROWS1KM:                   21600
    GLOBALGRIDROWS500M:                  43200
    GRANULEBEGINNINGDATETIME:            2016-07-07T17:10:00.000000Z
    GRANULEBEGINNINGDATETIMEARRAY:       2016-07-07T17:10:00.000000Z, 2016-07...
    GRANULEDAYNIGHTFLAG:                 Day
    GRANULEDAYNIGHTFLAGARRAY:            Day, Day, Day, Day
    GRANULEDAYOFYEAR:                    189
    GRANULEENDINGDATETIME:               2016-07-07T18:55:00.000000Z
    GRANULEENDINGDATETIMEARRAY:          2016-07-07T17:15:00.000000Z, 2016-07...
    GRANULENUMBERARRAY:                  208, 209, 228, 247, -1, -1, -1, -1, ...
    GRANULEPOINTERARRAY:                 0, 1, 2, -1, -1, -1, -1, -1, -1, -1,...
    GRINGPOINTLATITUDE.1:                29.8360532722546, 39.9999999964079, ...
    GRINGPOINTLONGITUDE.1:               -103.835851753394, -117.486656023174...
    GRINGPOINTSEQUENCENO.1:              1, 2, 3, 4
    HDFEOSVersion:                       HDFEOS_V2.17
    HORIZONTALTILENUMBER:                9
    identifier_product_doi:              10.5067/MODIS/MOD09GA.006
    identifier_product_doi_authority:    http://dx.doi.org
    INPUTPOINTER:                        MOD09GST.A2016189.h09v05.006.2016191...
    KEEPALL:                             No
    L2GSTORAGEFORMAT1KM:                 compact
    L2GSTORAGEFORMAT500M:                compact
    l2g_storage_format_1km:              compact
    l2g_storage_format_500m:             compact
    LOCALGRANULEID:                      MOD09GA.A2016189.h09v05.006.20161910...
    LOCALVERSIONID:                      6.0.9
    LONGNAME:                            MODIS/Terra Surface Reflectance Dail...
    MAXIMUMOBSERVATIONS1KM:              12
    MAXIMUMOBSERVATIONS500M:             2
    maximum_observations_1km:            12
    maximum_observations_500m:           2
    MAXOUTPUTRES:                        QKM
    NADIRDATARESOLUTION1KM:              1km
    NADIRDATARESOLUTION500M:             500m
    NORTHBOUNDINGCOORDINATE:             39.9999999964079
    NumberLandWater1km:                  0, 1418266, 15655, 6079, 0, 0, 0, 0, 0
    NumberLandWater500m:                 0, 2836532, 31310, 12158, 0, 0, 0, 0, 0
    NUMBEROFGRANULES:                    1
    NUMBEROFINPUTGRANULES:               4
    NUMBEROFORBITS:                      2
    NUMBEROFOVERLAPGRANULES:             3
    ORBITNUMBER.1:                       88050
    ORBITNUMBER.2:                       88051
    ORBITNUMBERARRAY:                    88050, 88050, 88051, -1, -1, -1, -1,...
    PARAMETERNAME.1:                     MOD09G
    PERCENTCLOUDY:                       13
    PERCENTLAND:                         97
    PERCENTLANDSEAMASKCLASS:             0, 97, 3, 0, 0, 0, 0, 0
    PERCENTLOWSUN:                       0
    PERCENTPROCESSED:                    100
    PERCENTSHADOW:                       2
    PGEVERSION:                          6.0.32
    PROCESSINGCENTER:                    MODAPS
    PROCESSINGENVIRONMENT:               Linux minion6007 2.6.32-642.1.1.el6....
    PROCESSVERSION:                      6.0.9
    PRODUCTIONDATETIME:                  2016-07-09T07:38:56.000Z
    QAPERCENTGOODQUALITY:                100
    QAPERCENTINTERPOLATEDDATA.1:         0
    QAPERCENTMISSINGDATA.1:              0
    QAPERCENTNOTPRODUCEDCLOUD:           0
    QAPERCENTNOTPRODUCEDOTHER:           0
    QAPERCENTOTHERQUALITY:               0
    QAPERCENTOUTOFBOUNDSDATA.1:          0
    QAPERCENTPOOROUTPUT500MBAND1:        0
    QAPERCENTPOOROUTPUT500MBAND2:        0
    QAPERCENTPOOROUTPUT500MBAND3:        0
    QAPERCENTPOOROUTPUT500MBAND4:        0
    QAPERCENTPOOROUTPUT500MBAND5:        0
    QAPERCENTPOOROUTPUT500MBAND6:        0
    QAPERCENTPOOROUTPUT500MBAND7:        0
    QUALITYCLASSPERCENTAGE500MBAND1:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND2:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND3:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND4:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND5:     96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0,...
    QUALITYCLASSPERCENTAGE500MBAND6:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND7:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    RANGEBEGINNINGDATE:                  2016-07-07
    RANGEBEGINNINGTIME:                  17:10:00.000000
    RANGEENDINGDATE:                     2016-07-07
    RANGEENDINGTIME:                     18:55:00.000000
    RANKING:                             No
    REPROCESSINGACTUAL:                  processed once
    REPROCESSINGPLANNED:                 further update is anticipated
    RESOLUTIONBANDS1AND2:                500
    SCIENCEQUALITYFLAG.1:                Not Investigated
    SCIENCEQUALITYFLAGEXPLANATION.1:     See http://landweb.nascom.nasa.gov/c...
    SHORTNAME:                           MOD09GA
    SOUTHBOUNDINGCOORDINATE:             29.9999999973059
    SPSOPARAMETERS:                      2015
    SYSTEMFILENAME:                      MOD09GST.A2016189.h09v05.006.2016191...
    TileID:                              51009005
    TOTALADDITIONALOBSERVATIONS1KM:      2705510
    TOTALADDITIONALOBSERVATIONS500M:     660129
    TOTALOBSERVATIONS1KM:                4145510
    TOTALOBSERVATIONS500M:               6420120
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-4aedc14c-c3d4-4abf-81c7-9b05ce6d461a' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-4aedc14c-c3d4-4abf-81c7-9b05ce6d461a' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>x</span>: 2400</li><li><span class='xr-has-index'>y</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-e5b5507b-2258-4b9a-ad10-a691deb713ce' class='xr-section-summary-in' type='checkbox'  checked><label for='section-e5b5507b-2258-4b9a-ad10-a691deb713ce' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-e9f83aa1-6e2c-4a1c-9aec-9310e450d70d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e9f83aa1-6e2c-4a1c-9aec-9310e450d70d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c0f0cc73-3b7b-4e61-a3b5-c2b9b7c8b4e1' class='xr-var-data-in' type='checkbox'><label for='data-c0f0cc73-3b7b-4e61-a3b5-c2b9b7c8b4e1' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-d2a55eca-7dfe-448f-8e0c-26989d25f3bc' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-d2a55eca-7dfe-448f-8e0c-26989d25f3bc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-67adec7d-a31d-4a91-82f6-b9f0804d4d21' class='xr-var-data-in' type='checkbox'><label for='data-67adec7d-a31d-4a91-82f6-b9f0804d4d21' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-de675967-08d9-4722-a321-56e4e96fca25' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-de675967-08d9-4722-a321-56e4e96fca25' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f965a258-cc67-42ba-a190-cd099ea51289' class='xr-var-data-in' type='checkbox'><label for='data-f965a258-cc67-42ba-a190-cd099ea51289' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-aa5e50b1-d2a5-40c2-b90d-3a33075ab229' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aa5e50b1-d2a5-40c2-b90d-3a33075ab229' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f58d6800-d480-4ea1-b1c9-e47d2826aa95' class='xr-var-data-in' type='checkbox'><label for='data-f58d6800-d480-4ea1-b1c9-e47d2826aa95' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-cf978909-9f93-4950-ab19-7f87391994fe' class='xr-section-summary-in' type='checkbox'  checked><label for='section-cf978909-9f93-4950-ab19-7f87391994fe' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8238eb76-d305-46d7-982a-0ca4506d4cbe' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8238eb76-d305-46d7-982a-0ca4506d4cbe' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5c41b963-e855-4d64-8591-b60a49e1bdc8' class='xr-var-data-in' type='checkbox'><label for='data-5c41b963-e855-4d64-8591-b60a49e1bdc8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-194c64a9-1a55-4655-8c97-96058e5462f6' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-194c64a9-1a55-4655-8c97-96058e5462f6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a0be2bba-6c0e-49a2-aadd-6c2bbc6c6eb2' class='xr-var-data-in' type='checkbox'><label for='data-a0be2bba-6c0e-49a2-aadd-6c2bbc6c6eb2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-f16cac26-bed7-44a5-b119-1868ce1116ad' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f16cac26-bed7-44a5-b119-1868ce1116ad' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c68bf6a3-b6ad-405d-936d-b2c81b6f0ca4' class='xr-var-data-in' type='checkbox'><label for='data-c68bf6a3-b6ad-405d-936d-b2c81b6f0ca4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-1b122687-0cfe-4374-a3cd-b5a1cb9dd067' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1b122687-0cfe-4374-a3cd-b5a1cb9dd067' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3f8cfb81-4f86-443f-933b-34671657cca0' class='xr-var-data-in' type='checkbox'><label for='data-3f8cfb81-4f86-443f-933b-34671657cca0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4dbe26ad-819d-40a5-bacf-6dbb12ca6341' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4dbe26ad-819d-40a5-bacf-6dbb12ca6341' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-beb16f23-9c6c-43ea-b1cc-ddb45f67d451' class='xr-var-data-in' type='checkbox'><label for='data-beb16f23-9c6c-43ea-b1cc-ddb45f67d451' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-cf175cfc-6cce-442b-b826-eaafa2212b2f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-cf175cfc-6cce-442b-b826-eaafa2212b2f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9be0aa78-fda1-4df0-9e47-19b9c0d4207d' class='xr-var-data-in' type='checkbox'><label for='data-9be0aa78-fda1-4df0-9e47-19b9c0d4207d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-0c6fe444-2eab-4dfa-bda8-3250a3e7011a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0c6fe444-2eab-4dfa-bda8-3250a3e7011a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-e844ebe5-9b9f-4c78-94a4-4bdf8fe534d3' class='xr-var-data-in' type='checkbox'><label for='data-e844ebe5-9b9f-4c78-94a4-4bdf8fe534d3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9300e061-7f12-4c56-9e71-35ca70e6cc55' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9300e061-7f12-4c56-9e71-35ca70e6cc55' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ad0ef1bb-9435-4202-9529-d5a01c613a30' class='xr-var-data-in' type='checkbox'><label for='data-ad0ef1bb-9435-4202-9529-d5a01c613a30' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4b6fbd30-3472-4f51-96dd-2f6d43ff76b6' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4b6fbd30-3472-4f51-96dd-2f6d43ff76b6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2d47d27e-09b4-4a6f-af62-d0705118cfe5' class='xr-var-data-in' type='checkbox'><label for='data-2d47d27e-09b4-4a6f-af62-d0705118cfe5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-7e972a76-ec9a-4ff1-a888-aec585c327e7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7e972a76-ec9a-4ff1-a888-aec585c327e7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-34f1345c-137b-46d4-bae1-43d6c9e0d44c' class='xr-var-data-in' type='checkbox'><label for='data-34f1345c-137b-46d4-bae1-43d6c9e0d44c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d3fbcc9c-9b15-4934-bfbe-872b4124b194' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d3fbcc9c-9b15-4934-bfbe-872b4124b194' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f3e2a91d-8fb6-4059-990a-0f53af197543' class='xr-var-data-in' type='checkbox'><label for='data-f3e2a91d-8fb6-4059-990a-0f53af197543' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-32e6deb6-fa9b-4920-b112-9183c1936d09' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-32e6deb6-fa9b-4920-b112-9183c1936d09' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9bec2a27-daf2-4264-b900-f85366cdc9f0' class='xr-var-data-in' type='checkbox'><label for='data-9bec2a27-daf2-4264-b900-f85366cdc9f0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-795bf551-55bc-419a-b701-d830be4bc0c3' class='xr-section-summary-in' type='checkbox'  ><label for='section-795bf551-55bc-419a-b701-d830be4bc0c3' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





{:.input}
```python
modis_pre_bands.sur_refl_b01_1.shape
```

{:.output}
{:.execute_result}



    (1, 2400, 2400)





### Plot All MODIS Bands with EarthPy

Now that you have a stack of all of the arrays for surface reflectance, you are now ready to plot your data using **earthpy**. 

Notice below that the 
images look washed out and there are large negative values in the data. 

This might be a good time to consider cleaning up your data by addressing 
`nodata` values.


{:.input}
```python
# Explore the data by plotting
# Is this cheating? Kind of takes it out of the hierarchical format to plot. But also makes plotting WAY easier.
# Interested to hear thoughts here.

ep.plot_bands(reflectance_bands_xr)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_35_0.png">

</figure>




{:.input}
```python
# Explore the data by plotting each band
# f, axes = plt.subplots(3, 3, figsize=(10, 10))

# axes_flat = axes.ravel()
# f.suptitle("Plot of All Bands")

# for i, a_var in enumerate(all_bands_l):
#     band_data = modis_pre_bands[a_var].squeeze()
#     band_data.plot.imshow(cmap="Greys_r",
#                           ax=axes_flat[i],
#                           vmin=-100,
#                           vmax=10000,
#                           cbar_kwargs=dict(label=""))
#     axes_flat[i].set(title=a_var)
#     axes_flat[i].set_axis_off()
```

If you look at the <a href="{{ site.url }}/courses/earth-analytics-python/multispectral-remote-sensing-modis/modis-remote-sensing-data-in-python/"> MODIS documentation table that is in the Introduction to MODIS chapter,</a> you will see that the
range of value values for MODIS spans from **-100 to 16000**. 

There is also a fill or no data value **-28672** to consider. You can access this nodata
value using the rasterio metadata object.

{:.input}
```python
# View entire metadata object
# for the last MODIS band processed in loop
modis_pre_bands["sur_refl_b07_1"].rio.nodata
```

{:.output}
{:.execute_result}



    nan










### RGB Image of MODIS Data Using EarthPy

Once you have your data cleaned up, you can also plot an RGB image of your data 
to ensure that it looks correct!


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_44_0.png">

</figure>




{:.input}
```python
# Create an RGB stack for plotting
# rgb_bands = xr.concat([modis_pre_bands.sur_refl_b01_1,
#                        modis_pre_bands.sur_refl_b04_1,
#                        modis_pre_bands.sur_refl_b03_1],
#                       dim="band")

# # Plot the data. By specifying vmin and max you can control the colormap
# f, ax = plt.subplots(figsize=(10, 6))
# rgb_bands.plot.imshow(rgb='band',
#                       vmin=-100,
#                       vmax=10000)
# ax.set(title="RGB Image of MODIS Pre Fire Data")
# ax.set_axis_off()
# plt.show()
```


## Crop MODIS Data Using Rioxarray

Above you opened and plotted MODIS reflectance data. However, the data 
cover a larger study area than you need. It is a good idea to crop it
the data to maximize processing efficiency.  

To begin, you will want to check that the CRS of your crop layer (in this 
case, the fire boundary layer that you have used in other lessons - 
`co_cold_springs_20160711_2200_dd83.shp`) is the same as your MODIS data. 

{:.input}
```python
# Open fire boundary
fire_boundary_path = os.path.join("cold-springs-fire",
                                  "vector_layers",
                                  "fire-boundary-geomac",
                                  "co_cold_springs_20160711_2200_dd83.shp")

fire_boundary = gpd.read_file(fire_boundary_path)

# Check the CRS
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
    - name: North America - onshore and offshore: Canada - Alberta; British Columbia; Manitoba; New Brunswick; Newfoundland and Labrador; Northwest Territories; Nova Scotia; Nunavut; Ontario; Prince Edward Island; Quebec; Saskatchewan; Yukon. Puerto Rico. United States (USA) - Alabama; Alaska; Arizona; Arkansas; California; Colorado; Connecticut; Delaware; Florida; Georgia; Hawaii; Idaho; Illinois; Indiana; Iowa; Kansas; Kentucky; Louisiana; Maine; Maryland; Massachusetts; Michigan; Minnesota; Mississippi; Missouri; Montana; Nebraska; Nevada; New Hampshire; New Jersey; New Mexico; New York; North Carolina; North Dakota; Ohio; Oklahoma; Oregon; Pennsylvania; Rhode Island; South Carolina; South Dakota; Tennessee; Texas; Utah; Vermont; Virginia; Washington; West Virginia; Wisconsin; Wyoming. US Virgin Islands.  British Virgin Islands.
    - bounds: (167.65, 14.92, -47.74, 86.46)
    Datum: North American Datum 1983
    - Ellipsoid: GRS 1980
    - Prime Meridian: Greenwich





### Reproject the Clip Extent (Fire Boundary)

To check the CRS of MODIS data, you can:

1. Create a connection to the HDF4 file.
2. Open a connection to one single band.
3. Grab the CRS of the band using the `src` object.

You can then use the CRS of the band to check and reproject the fire boundary if it 
is not in the same CRS.

In the code below, you use these steps to reproject the fire boundary to match the HDF4 data. 

Note that you do not need all of the 
print statments included below. They are included to help you see what is 
happening in the code!

{:.input}
```python
# Check CRS
if not fire_boundary.crs == modis_pre_bands.rio.crs:
    # If the crs is not equal reproject the data
    fire_bound_sin = fire_boundary.to_crs(modis_pre_bands.rio.crs)

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





{:.input}
```python
#  Ive tried  this both projected and not projected.

#  This may be failing - band (band) int64 1 1 1  - because if you look at th e
#  Object i t has a value of 1 for each   band  which is   odd
#  GOAL here is to again plot each  band for exploration purposes
modis_clip = modis_pre_bands.rio.clip(fire_bound_sin.geometry,
                                      all_touched=True)
modis_clip
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
Dimensions:                (band: 1, x: 8, y: 3)
Coordinates:
  * y                      (y) float64 4.446e+06 4.446e+06 4.445e+06
  * x                      (x) float64 -8.988e+06 -8.988e+06 ... -8.985e+06
  * band                   (band) int64 1
    spatial_ref            int64 0
Data variables:
    num_observations_500m  (band, y, x) float64 2.0 2.0 2.0 2.0 ... 2.0 2.0 nan
    sur_refl_b01_1         (band, y, x) float64 428.0 450.0 450.0 ... 458.0 nan
    sur_refl_b02_1         (band, y, x) float64 3.013e+03 2.809e+03 ... nan
    sur_refl_b03_1         (band, y, x) float64 259.0 235.0 235.0 ... 265.0 nan
    sur_refl_b04_1         (band, y, x) float64 563.0 541.0 541.0 ... 518.0 nan
    sur_refl_b05_1         (band, y, x) float64 3.04e+03 2.587e+03 ... nan
    sur_refl_b06_1         (band, y, x) float64 1.841e+03 1.738e+03 ... nan
    sur_refl_b07_1         (band, y, x) float64 832.0 820.0 820.0 ... 804.0 nan
    QC_500m_1              (band, y, x) float64 1.074e+09 1.074e+09 ... nan
    obscov_500m_1          (band, y, x) float64 6.0 7.0 10.0 9.0 ... 8.0 9.0 nan
    iobs_res_1             (band, y, x) float64 0.0 0.0 0.0 0.0 ... 0.0 1.0 nan
    q_scan_1               (band, y, x) float64 1.0 12.0 15.0 ... 15.0 15.0 nan
Attributes:
    ADDITIONALLAYERS1KM:                 11
    ADDITIONALLAYERS500M:                1
    ASSOCIATEDINSTRUMENTSHORTNAME.1:     MODIS
    ASSOCIATEDPLATFORMSHORTNAME.1:       Terra
    ASSOCIATEDSENSORSHORTNAME.1:         MODIS
    AUTOMATICQUALITYFLAG.1:              Passed
    AUTOMATICQUALITYFLAGEXPLANATION.1:   No automatic quality assessment is p...
    CHARACTERISTICBINANGULARSIZE1KM:     30.0
    CHARACTERISTICBINANGULARSIZE500M:    15.0
    CHARACTERISTICBINSIZE1KM:            926.625433055556
    CHARACTERISTICBINSIZE500M:           463.312716527778
    CLOUDOPTION:                         MOD09 internally-derived
    COVERAGECALCULATIONMETHOD:           volume
    COVERAGEMINIMUM:                     0.00999999977648258
    DATACOLUMNS1KM:                      1200
    DATACOLUMNS500M:                     2400
    DATAROWS1KM:                         1200
    DATAROWS500M:                        2400
    DAYNIGHTFLAG:                        Day
    DEEPOCEANFLAG:                       Yes
    DESCRREVISION:                       6.1
    EASTBOUNDINGCOORDINATE:              -92.3664205550513
    EQUATORCROSSINGDATE.1:               2016-07-07
    EQUATORCROSSINGDATE.2:               2016-07-07
    EQUATORCROSSINGLONGITUDE.1:          -103.273195919522
    EQUATORCROSSINGLONGITUDE.2:          -127.994803619317
    EQUATORCROSSINGTIME.1:               17:23:36.891214
    EQUATORCROSSINGTIME.2:               19:02:29.990629
    EXCLUSIONGRINGFLAG.1:                N
    FIRSTLAYERSELECTIONCRITERIA:         order of input pointer
    GEOANYABNORMAL:                      False
    GEOESTMAXRMSERROR:                   50.0
    GLOBALGRIDCOLUMNS1KM:                43200
    GLOBALGRIDCOLUMNS500M:               86400
    GLOBALGRIDROWS1KM:                   21600
    GLOBALGRIDROWS500M:                  43200
    GRANULEBEGINNINGDATETIME:            2016-07-07T17:10:00.000000Z
    GRANULEBEGINNINGDATETIMEARRAY:       2016-07-07T17:10:00.000000Z, 2016-07...
    GRANULEDAYNIGHTFLAG:                 Day
    GRANULEDAYNIGHTFLAGARRAY:            Day, Day, Day, Day
    GRANULEDAYOFYEAR:                    189
    GRANULEENDINGDATETIME:               2016-07-07T18:55:00.000000Z
    GRANULEENDINGDATETIMEARRAY:          2016-07-07T17:15:00.000000Z, 2016-07...
    GRANULENUMBERARRAY:                  208, 209, 228, 247, -1, -1, -1, -1, ...
    GRANULEPOINTERARRAY:                 0, 1, 2, -1, -1, -1, -1, -1, -1, -1,...
    GRINGPOINTLATITUDE.1:                29.8360532722546, 39.9999999964079, ...
    GRINGPOINTLONGITUDE.1:               -103.835851753394, -117.486656023174...
    GRINGPOINTSEQUENCENO.1:              1, 2, 3, 4
    HDFEOSVersion:                       HDFEOS_V2.17
    HORIZONTALTILENUMBER:                9
    identifier_product_doi:              10.5067/MODIS/MOD09GA.006
    identifier_product_doi_authority:    http://dx.doi.org
    INPUTPOINTER:                        MOD09GST.A2016189.h09v05.006.2016191...
    KEEPALL:                             No
    L2GSTORAGEFORMAT1KM:                 compact
    L2GSTORAGEFORMAT500M:                compact
    l2g_storage_format_1km:              compact
    l2g_storage_format_500m:             compact
    LOCALGRANULEID:                      MOD09GA.A2016189.h09v05.006.20161910...
    LOCALVERSIONID:                      6.0.9
    LONGNAME:                            MODIS/Terra Surface Reflectance Dail...
    MAXIMUMOBSERVATIONS1KM:              12
    MAXIMUMOBSERVATIONS500M:             2
    maximum_observations_1km:            12
    maximum_observations_500m:           2
    MAXOUTPUTRES:                        QKM
    NADIRDATARESOLUTION1KM:              1km
    NADIRDATARESOLUTION500M:             500m
    NORTHBOUNDINGCOORDINATE:             39.9999999964079
    NumberLandWater1km:                  0, 1418266, 15655, 6079, 0, 0, 0, 0, 0
    NumberLandWater500m:                 0, 2836532, 31310, 12158, 0, 0, 0, 0, 0
    NUMBEROFGRANULES:                    1
    NUMBEROFINPUTGRANULES:               4
    NUMBEROFORBITS:                      2
    NUMBEROFOVERLAPGRANULES:             3
    ORBITNUMBER.1:                       88050
    ORBITNUMBER.2:                       88051
    ORBITNUMBERARRAY:                    88050, 88050, 88051, -1, -1, -1, -1,...
    PARAMETERNAME.1:                     MOD09G
    PERCENTCLOUDY:                       13
    PERCENTLAND:                         97
    PERCENTLANDSEAMASKCLASS:             0, 97, 3, 0, 0, 0, 0, 0
    PERCENTLOWSUN:                       0
    PERCENTPROCESSED:                    100
    PERCENTSHADOW:                       2
    PGEVERSION:                          6.0.32
    PROCESSINGCENTER:                    MODAPS
    PROCESSINGENVIRONMENT:               Linux minion6007 2.6.32-642.1.1.el6....
    PROCESSVERSION:                      6.0.9
    PRODUCTIONDATETIME:                  2016-07-09T07:38:56.000Z
    QAPERCENTGOODQUALITY:                100
    QAPERCENTINTERPOLATEDDATA.1:         0
    QAPERCENTMISSINGDATA.1:              0
    QAPERCENTNOTPRODUCEDCLOUD:           0
    QAPERCENTNOTPRODUCEDOTHER:           0
    QAPERCENTOTHERQUALITY:               0
    QAPERCENTOUTOFBOUNDSDATA.1:          0
    QAPERCENTPOOROUTPUT500MBAND1:        0
    QAPERCENTPOOROUTPUT500MBAND2:        0
    QAPERCENTPOOROUTPUT500MBAND3:        0
    QAPERCENTPOOROUTPUT500MBAND4:        0
    QAPERCENTPOOROUTPUT500MBAND5:        0
    QAPERCENTPOOROUTPUT500MBAND6:        0
    QAPERCENTPOOROUTPUT500MBAND7:        0
    QUALITYCLASSPERCENTAGE500MBAND1:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND2:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND3:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND4:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND5:     96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0,...
    QUALITYCLASSPERCENTAGE500MBAND6:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    QUALITYCLASSPERCENTAGE500MBAND7:     100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
    RANGEBEGINNINGDATE:                  2016-07-07
    RANGEBEGINNINGTIME:                  17:10:00.000000
    RANGEENDINGDATE:                     2016-07-07
    RANGEENDINGTIME:                     18:55:00.000000
    RANKING:                             No
    REPROCESSINGACTUAL:                  processed once
    REPROCESSINGPLANNED:                 further update is anticipated
    RESOLUTIONBANDS1AND2:                500
    SCIENCEQUALITYFLAG.1:                Not Investigated
    SCIENCEQUALITYFLAGEXPLANATION.1:     See http://landweb.nascom.nasa.gov/c...
    SHORTNAME:                           MOD09GA
    SOUTHBOUNDINGCOORDINATE:             29.9999999973059
    SPSOPARAMETERS:                      2015
    SYSTEMFILENAME:                      MOD09GST.A2016189.h09v05.006.2016191...
    TileID:                              51009005
    TOTALADDITIONALOBSERVATIONS1KM:      2705510
    TOTALADDITIONALOBSERVATIONS500M:     660129
    TOTALOBSERVATIONS1KM:                4145510
    TOTALOBSERVATIONS500M:               6420120
    total_additional_observations_1km:   2705510
    total_additional_observations_500m:  660129
    VERSIONID:                           6
    VERTICALTILENUMBER:                  5
    WESTBOUNDINGCOORDINATE:              -117.486656023174
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-75c585a6-1f48-4e03-a489-cc019da0bf04' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-75c585a6-1f48-4e03-a489-cc019da0bf04' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>x</span>: 8</li><li><span class='xr-has-index'>y</span>: 3</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-d37c4eca-1847-4334-8691-561ad7d5d884' class='xr-section-summary-in' type='checkbox'  checked><label for='section-d37c4eca-1847-4334-8691-561ad7d5d884' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-0c11961b-b461-42ec-9699-35c1e02709b9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0c11961b-b461-42ec-9699-35c1e02709b9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d61a6862-1b80-4d9f-b6ec-c694807c6c74' class='xr-var-data-in' type='checkbox'><label for='data-d61a6862-1b80-4d9f-b6ec-c694807c6c74' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.988e+06 ... -8.985e+06</div><input id='attrs-7227da84-7049-4751-9d0c-fc27cd0b2230' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7227da84-7049-4751-9d0c-fc27cd0b2230' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b0d2d47c-2639-446a-b5f6-5a2fa4a39210' class='xr-var-data-in' type='checkbox'><label for='data-b0d2d47c-2639-446a-b5f6-5a2fa4a39210' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8988498.356997, -8988035.04428 , -8987571.731564, -8987108.418847,
       -8986645.106131, -8986181.793414, -8985718.480698, -8985255.167981])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-e65aa80b-5bff-4e99-9976-9cbee878577f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e65aa80b-5bff-4e99-9976-9cbee878577f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-395758b7-b512-452e-a8d3-20135e75e5de' class='xr-var-data-in' type='checkbox'><label for='data-395758b7-b512-452e-a8d3-20135e75e5de' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-f90755c5-1ed2-4371-a2a3-abee05a6ceef' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f90755c5-1ed2-4371-a2a3-abee05a6ceef' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-94395c1b-dc2a-4663-abe1-869f98f102be' class='xr-var-data-in' type='checkbox'><label for='data-94395c1b-dc2a-4663-abe1-869f98f102be' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-8988730.013355112 463.31271652797506 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-2814cd9f-c547-4c4e-a973-399df84655a1' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2814cd9f-c547-4c4e-a973-399df84655a1' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>2.0 2.0 2.0 2.0 ... 2.0 2.0 2.0 nan</div><input id='attrs-646fa4aa-a88b-434c-8559-e84110cb389b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-646fa4aa-a88b-434c-8559-e84110cb389b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5e4dfecb-2cbc-4fb4-8006-9527079365ab' class='xr-var-data-in' type='checkbox'><label for='data-5e4dfecb-2cbc-4fb4-8006-9527079365ab' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[ 2.,  2.,  2.,  2.,  2., nan, nan, nan],
        [ 2.,  2.,  2.,  2.,  2.,  2.,  2.,  2.],
        [ 2.,  2.,  2.,  2.,  2.,  2.,  2., nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>428.0 450.0 450.0 ... 458.0 nan</div><input id='attrs-a210eae8-a384-4fca-b0a7-4a4553a45ecc' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a210eae8-a384-4fca-b0a7-4a4553a45ecc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-03e78a88-4e59-4abf-8bef-25ffcd751a0e' class='xr-var-data-in' type='checkbox'><label for='data-03e78a88-4e59-4abf-8bef-25ffcd751a0e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[428., 450., 450., 438., 438.,  nan,  nan,  nan],
        [402., 402., 402., 442., 442., 442., 442., 458.],
        [402., 402., 442., 442., 442., 442., 458.,  nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>3.013e+03 2.809e+03 ... nan</div><input id='attrs-0bafc909-c3e3-4abe-8dd4-c5c193da67c2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0bafc909-c3e3-4abe-8dd4-c5c193da67c2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c2b1c5b4-459a-4b6b-9cb4-feb75582f69d' class='xr-var-data-in' type='checkbox'><label for='data-c2b1c5b4-459a-4b6b-9cb4-feb75582f69d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[3013., 2809., 2809., 2730., 2730.,   nan,   nan,   nan],
        [2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.],
        [2565., 2565., 2522., 2522., 2522., 2522., 2496.,   nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>259.0 235.0 235.0 ... 265.0 nan</div><input id='attrs-eaec2519-f973-4fdd-baae-bd34dea18a81' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-eaec2519-f973-4fdd-baae-bd34dea18a81' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cb11902c-ef01-4224-8a4c-b89a01235702' class='xr-var-data-in' type='checkbox'><label for='data-cb11902c-ef01-4224-8a4c-b89a01235702' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[259., 235., 235., 231., 231.,  nan,  nan,  nan],
        [217., 217., 217., 230., 230., 230., 230., 265.],
        [217., 217., 230., 230., 230., 230., 265.,  nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>563.0 541.0 541.0 ... 518.0 nan</div><input id='attrs-02469598-cab6-4051-86d2-a700965f0770' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-02469598-cab6-4051-86d2-a700965f0770' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b5d98b7b-d703-498c-b9a7-9f6e66f86ba4' class='xr-var-data-in' type='checkbox'><label for='data-b5d98b7b-d703-498c-b9a7-9f6e66f86ba4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[563., 541., 541., 528., 528.,  nan,  nan,  nan],
        [476., 476., 476., 476., 476., 476., 476., 518.],
        [476., 476., 476., 476., 476., 476., 518.,  nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>3.04e+03 2.587e+03 ... nan</div><input id='attrs-f4fe65df-7211-406a-b39d-465fee8c5f13' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f4fe65df-7211-406a-b39d-465fee8c5f13' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-92ea3eb9-9908-4ee1-8124-86e74c8f7a65' class='xr-var-data-in' type='checkbox'><label for='data-92ea3eb9-9908-4ee1-8124-86e74c8f7a65' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[3040., 2587., 2587., 2554., 2554.,   nan,   nan,   nan],
        [2293., 2293., 2293., 2559., 2559., 2559., 2559., 2315.],
        [2293., 2293., 2559., 2559., 2559., 2559., 2315.,   nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>1.841e+03 1.738e+03 ... 1.6e+03 nan</div><input id='attrs-da8f3f00-9f40-4464-b984-ed5abfac4fb0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-da8f3f00-9f40-4464-b984-ed5abfac4fb0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7037b0be-f696-40ed-b16e-01e3c11e0db4' class='xr-var-data-in' type='checkbox'><label for='data-7037b0be-f696-40ed-b16e-01e3c11e0db4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[1841., 1738., 1738., 1683., 1683.,   nan,   nan,   nan],
        [1514., 1514., 1514., 1583., 1583., 1583., 1583., 1600.],
        [1514., 1514., 1583., 1583., 1583., 1583., 1600.,   nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>832.0 820.0 820.0 ... 804.0 nan</div><input id='attrs-1f5c387f-8bc7-4aa3-adea-1b022c2c09d1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1f5c387f-8bc7-4aa3-adea-1b022c2c09d1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-37c568f2-ca38-4498-9e85-f034bc654745' class='xr-var-data-in' type='checkbox'><label for='data-37c568f2-ca38-4498-9e85-f034bc654745' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[832., 820., 820., 820., 820.,  nan,  nan,  nan],
        [715., 715., 715., 789., 789., 789., 789., 804.],
        [715., 715., 789., 789., 789., 789., 804.,  nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>1.074e+09 1.074e+09 ... nan</div><input id='attrs-7573a90a-6357-44aa-b344-bd20844e6098' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7573a90a-6357-44aa-b344-bd20844e6098' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1222f2b1-86a7-4ed4-89d0-f0584b43a4a5' class='xr-var-data-in' type='checkbox'><label for='data-1222f2b1-86a7-4ed4-89d0-f0584b43a4a5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[1.07374182e+09, 1.07374182e+09, 1.07374182e+09, 1.07374182e+09,
         1.07374182e+09,            nan,            nan,            nan],
        [1.07374182e+09, 1.07374182e+09, 1.07374182e+09, 1.07374182e+09,
         1.07374182e+09, 1.07374182e+09, 1.07374182e+09, 1.07374182e+09],
        [1.07374182e+09, 1.07374182e+09, 1.07374182e+09, 1.07374182e+09,
         1.07374182e+09, 1.07374182e+09, 1.07374182e+09,            nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>6.0 7.0 10.0 9.0 ... 8.0 9.0 nan</div><input id='attrs-c573b877-4092-4592-a56d-bf6d79d5aad0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c573b877-4092-4592-a56d-bf6d79d5aad0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7540ed56-7ad4-4f1f-84ca-f3dc81215616' class='xr-var-data-in' type='checkbox'><label for='data-7540ed56-7ad4-4f1f-84ca-f3dc81215616' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[ 6.,  7., 10.,  9.,  8., nan, nan, nan],
        [11., 12.,  9.,  8., 11., 11.,  8.,  8.],
        [ 9.,  7.,  7., 11., 11.,  8.,  9., nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>0.0 0.0 0.0 0.0 ... 0.0 0.0 1.0 nan</div><input id='attrs-ec037c85-d385-4b3b-8e47-b8e477e22f1b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-ec037c85-d385-4b3b-8e47-b8e477e22f1b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-665e85ef-908f-4b70-8535-711997a09917' class='xr-var-data-in' type='checkbox'><label for='data-665e85ef-908f-4b70-8535-711997a09917' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[ 0.,  0.,  0.,  0.,  0., nan, nan, nan],
        [ 0.,  0.,  0.,  0.,  0.,  0.,  0.,  0.],
        [ 0.,  0.,  0.,  0.,  0.,  0.,  1., nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>1.0 12.0 15.0 7.0 ... 15.0 15.0 nan</div><input id='attrs-a4a5b98b-c9b7-468f-bd8a-ff8dc37a16ce' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a4a5b98b-c9b7-468f-bd8a-ff8dc37a16ce' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-138fec40-5d61-44ee-9ac6-082ddf947e56' class='xr-var-data-in' type='checkbox'><label for='data-138fec40-5d61-44ee-9ac6-082ddf947e56' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[ 1., 12., 15.,  7.,  8., nan, nan, nan],
        [15., 15., 15., 15., 15., 15., 15., 15.],
        [15., 15., 15., 15., 15., 15., 15., nan]]])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-026d3d60-c7d7-4353-9d66-abf8532ffabd' class='xr-section-summary-in' type='checkbox'  ><label for='section-026d3d60-c7d7-4353-9d66-abf8532ffabd' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





{:.input}
```python
# View cropped data
ep.plot_bands(modis_clip.sur_refl_b01_1)
# modis_clip["sur_refl_b01_1"].plot()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_52_0.png">

</figure>








### Plot Your Cropped MODIS Data

Once you have a stacked numpy array, you can use the data for analysis or plotting.

The code belows plots each band in the stacked numpy array of the cropped data.

{:.input}
```python
# Plot the data
# Again, this might be cheating, just lemme know

modis_refl = get_reflectance_bands(modis_clip)

ep.plot_bands(modis_refl)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_57_0.png">

</figure>




{:.input}
```python
# Plot the data
# ep.plot_bands(pre_fire_modis_crop,
#               figsize=(10, 5))
# plt.show()

# Explore the data by plotting each band
# f, axes = plt.subplots(3, 3, figsize=(10, 4))

# axes_flat = axes.ravel()
# f.suptitle("Plot of All Clipped Bands")

# for i, a_var in enumerate(all_bands_l):
#     band_data = modis_clip[a_var].squeeze()
#     band_data.plot.imshow(cmap="Greys_r",
#                           ax=axes_flat[i],
#                           vmin=0,
#                           vmax=3000,
#                           cbar_kwargs=dict(label=""))
#     axes_flat[i].set(title=a_var)
#     axes_flat[i].set_axis_off()

# plt.tight_layout()
# plt.show()
```

## Export MODIS Data in a Numpy Array as a GeoTIFF

This last section is optional. If you want to export your newly stacked MODIS 
data as a GeoTIFF, you need to fix the metadata object. 

The metadata for each 
band represents a single array, so the `count` element is **1**. However, you are now 
writing out a stacked array. You will need to adjust the `count` 
element in the metadata dictionary to account for this.

`es.crop_image()` returns the correct height, width and no-data value so you 
do not need to account for those values!

To get started, have a look at the metadata object for a single band. This 
has most of the information that you need to export a new GeoTIFF file. Pay
close attention to the **count** value.


Finally, create an output directory to save your exported geotiff. 

Below, you 
create a directory called **stacked** within the MODIS directory that you've 
been working with.

{:.input}
```python
# Define path for exported file
stacked_file_path = os.path.join(os.path.dirname(pre_fire_path),
                                 "stacked",
                                 "modis_band_1.tif")

# Get the directory needed for the defined path
modis_dir_path = os.path.dirname(stacked_file_path)
print("Required directory:", modis_dir_path)

# Create the needed directory if it does not exist
if not os.path.exists(modis_dir_path):
    os.mkdir(modis_dir_path)
    print("The directory", modis_dir_path, "did not exist - creating it now!")
```

{:.output}
    Required directory: cold-springs-modis-h4/07_july_2016/stacked
    The directory cold-springs-modis-h4/07_july_2016/stacked did not exist - creating it now!



You can now export or write out a new GeoTIFF. To do this, you will create a 
context manager with a connection to a new file in write (`"w"`) mode. You 
will then use `.write(numpy_arr_here)` to export the file.

The `crop_meta` object has two stars (`**`) next to it as that tells rasterio 
to "unpack" the meta object into the various pieces that are required to 
save a spatially referenced GeoTIFF file.


Open and view your stacked GeoTIFF.

{:.input}
```python
# Open the file to make sure it's correct!
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
# f, ax = plt.subplots()
ep.plot_bands(modis_b1_xr)
# modis_b1_xr.plot(cmap="Greys_r",
#                  vmin=-100,
#                  vmax=10000,
#                  ax=ax)
# ax.set_axis_off()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_67_0.png" alt = "Plot of each MODIS band in the numpy stack cropped to the cold springs fire extent, identical to the last plot showing this same thing.">
<figcaption>Plot of each MODIS band in the numpy stack cropped to the cold springs fire extent, identical to the last plot showing this same thing.</figcaption>

</figure>










