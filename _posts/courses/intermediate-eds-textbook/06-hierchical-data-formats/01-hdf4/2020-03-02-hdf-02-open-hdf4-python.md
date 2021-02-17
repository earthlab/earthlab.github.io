---
layout: single
title: "Open and Use MODIS Data in HDF4 format in Open Source Python"
excerpt: "MODIS is remote sensing data that is stored in the HDF4 file format. Learn how to open and use MODIS data in HDF4 form in Open Source Python."
authors: ['Leah Wasser', 'Jenny Palomino']
dateCreated: 2020-03-01
modified: 2021-02-17
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
    Downloading from https://ndownloader.figshare.com/files/10960109
    Extracted output to /root/earth-analytics/data/cold-springs-fire/.






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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-d7389114-7b0e-4aad-80e1-fb4bee572225' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-d7389114-7b0e-4aad-80e1-fb4bee572225' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>x</span>: 1200</li><li><span class='xr-has-index'>y</span>: 1200</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-a19f7fc5-6037-48bc-bb67-8111d014a1b6' class='xr-section-summary-in' type='checkbox'  checked><label for='section-a19f7fc5-6037-48bc-bb67-8111d014a1b6' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-b8aaa47e-8550-4200-adea-6a8e677e9574' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-b8aaa47e-8550-4200-adea-6a8e677e9574' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-88008126-d840-4370-9c22-4b17e649d3cf' class='xr-var-data-in' type='checkbox'><label for='data-88008126-d840-4370-9c22-4b17e649d3cf' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-b6a972d8-a52b-468b-8025-c9eba79f9a83' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-b6a972d8-a52b-468b-8025-c9eba79f9a83' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-b1462bc2-3f99-48b9-a42b-fa40038897e3' class='xr-var-data-in' type='checkbox'><label for='data-b1462bc2-3f99-48b9-a42b-fa40038897e3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-eba5e7cc-34cd-4a37-a165-28ff3cb0e051' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-eba5e7cc-34cd-4a37-a165-28ff3cb0e051' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7c13d520-8a8f-47a8-8991-f5237bcc922f' class='xr-var-data-in' type='checkbox'><label for='data-7c13d520-8a8f-47a8-8991-f5237bcc922f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-bc64d53c-84a8-4d8d-b1b6-03910a1c3fb3' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-bc64d53c-84a8-4d8d-b1b6-03910a1c3fb3' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bf875c34-d096-4dce-ae13-666cde9ee732' class='xr-var-data-in' type='checkbox'><label for='data-bf875c34-d096-4dce-ae13-666cde9ee732' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-2d91ec38-450c-4e57-838a-5ea09383c279' class='xr-section-summary-in' type='checkbox'  checked><label for='section-2d91ec38-450c-4e57-838a-5ea09383c279' class='xr-section-summary' >Data variables: <span>(10)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_1km</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-13344842-d4a9-464e-ab11-9b41d243842c' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-13344842-d4a9-464e-ab11-9b41d243842c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f78e2f9f-95ae-4cd6-a0a5-7766b3cff279' class='xr-var-data-in' type='checkbox'><label for='data-f78e2f9f-95ae-4cd6-a0a5-7766b3cff279' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>granule_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-aae6f576-d4dc-43c5-a393-129d560f58ba' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aae6f576-d4dc-43c5-a393-129d560f58ba' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fa240f19-38a5-4fa8-84dc-03979e3f6368' class='xr-var-data-in' type='checkbox'><label for='data-fa240f19-38a5-4fa8-84dc-03979e3f6368' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Granule Pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>state_1km_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4e1318c6-c1aa-4c61-977d-841f46ac7e14' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4e1318c6-c1aa-4c61-977d-841f46ac7e14' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-038475bc-cd86-417b-829b-d0cc0fc99a2a' class='xr-var-data-in' type='checkbox'><label for='data-038475bc-cd86-417b-829b-d0cc0fc99a2a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>1km Reflectance Data State QA - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-1a51e69a-d522-4124-94f5-20f844cbc6fc' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1a51e69a-d522-4124-94f5-20f844cbc6fc' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-dcdbb7c4-077f-4428-aa4d-7ffef7757bba' class='xr-var-data-in' type='checkbox'><label for='data-dcdbb7c4-077f-4428-aa4d-7ffef7757bba' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SensorAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-730f99dd-b91d-44a8-8bdd-a99b1879abae' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-730f99dd-b91d-44a8-8bdd-a99b1879abae' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1725ec41-7cd6-4998-b06d-d735a1dc286d' class='xr-var-data-in' type='checkbox'><label for='data-1725ec41-7cd6-4998-b06d-d735a1dc286d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Sensor azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>Range_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-0b22ec52-e383-416a-94c7-a82ad1c4c9ff' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0b22ec52-e383-416a-94c7-a82ad1c4c9ff' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1a4dd45f-f0ec-42b5-9a05-18447d265957' class='xr-var-data-in' type='checkbox'><label for='data-1a4dd45f-f0ec-42b5-9a05-18447d265957' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>25.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Range (pixel to sensor) - first layer</dd><dt><span>units :</span></dt><dd>meters</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarZenith_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-60534f65-59d7-41f8-8f15-abdb0dfdddf9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-60534f65-59d7-41f8-8f15-abdb0dfdddf9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-537fc385-5f5b-4eb5-b585-2edad212fc22' class='xr-var-data-in' type='checkbox'><label for='data-537fc385-5f5b-4eb5-b585-2edad212fc22' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar zenith - first layer</dd><dt><span>units :</span></dt><dd>degree</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>SolarAzimuth_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-cc21f40b-82d5-40d1-9e14-37e6bedf0fe4' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-cc21f40b-82d5-40d1-9e14-37e6bedf0fe4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-78155b6f-3d3a-4717-b497-1b8c54f40883' class='xr-var-data-in' type='checkbox'><label for='data-78155b6f-3d3a-4717-b497-1b8c54f40883' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.01</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Solar azimuth - first layer</dd><dt><span>units :</span></dt><dd>degree</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>gflags_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-5802de23-6cfa-4c09-800b-43ddb3eb46c9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5802de23-6cfa-4c09-800b-43ddb3eb46c9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6296f2cc-d8e6-4579-864e-d09a1d828da7' class='xr-var-data-in' type='checkbox'><label for='data-6296f2cc-d8e6-4579-864e-d09a1d828da7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Geolocation flags - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>orbit_pnt_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-97a20272-552e-40fe-8a7c-695b831bd148' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-97a20272-552e-40fe-8a7c-695b831bd148' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8b935ec4-f882-4dca-bf97-6a059aa3f019' class='xr-var-data-in' type='checkbox'><label for='data-8b935ec4-f882-4dca-bf97-6a059aa3f019' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Orbit pointer - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[1440000 values with dtype=float64]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-366dbf79-201f-4e9e-96b2-931452f35122' class='xr-section-summary-in' type='checkbox'  ><label for='section-366dbf79-201f-4e9e-96b2-931452f35122' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    grid_mapping:  spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'>'num_observations_1km'</div><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>y</span>: 1200</li><li><span class='xr-has-index'>x</span>: 1200</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-1a075eba-9e19-4d02-be05-07d0ce18ebe1' class='xr-array-in' type='checkbox' checked><label for='section-1a075eba-9e19-4d02-be05-07d0ce18ebe1' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>...</span></div><div class='xr-array-data'><pre>[1440000 values with dtype=float64]</pre></div></div></li><li class='xr-section-item'><input id='section-c3d18e7b-f4b4-46f3-b6ea-dd72316a4e7c' class='xr-section-summary-in' type='checkbox'  checked><label for='section-c3d18e7b-f4b4-46f3-b6ea-dd72316a4e7c' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.447e+06 4.446e+06 ... 3.336e+06</div><input id='attrs-8722f08a-9ec4-4818-9c84-3313b60dfd5d' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-8722f08a-9ec4-4818-9c84-3313b60dfd5d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5487f5f8-56e3-4707-aeed-9a3dd62934d6' class='xr-var-data-in' type='checkbox'><label for='data-5487f5f8-56e3-4707-aeed-9a3dd62934d6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447338.76595 , 4446412.140517, 4445485.515084, ..., 3338168.122583,
       3337241.49715 , 3336314.871717])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-842e4760-5cdd-468f-96c3-1f869b57070a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-842e4760-5cdd-468f-96c3-1f869b57070a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6e6dacea-4fb4-43c4-ba61-fe86d01e8275' class='xr-var-data-in' type='checkbox'><label for='data-6e6dacea-4fb4-43c4-ba61-fe86d01e8275' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007091.364283, -10006164.73885 , -10005238.113417, ...,
        -8897920.720916,  -8896994.095483,  -8896067.47005 ])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-1c14cfac-d744-4998-a2fd-c9c9b81d8d18' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-1c14cfac-d744-4998-a2fd-c9c9b81d8d18' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fe786375-61a2-4146-8863-97f363b334da' class='xr-var-data-in' type='checkbox'><label for='data-fe786375-61a2-4146-8863-97f363b334da' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-747e1a18-260a-4d7d-80a6-dc6af7fc9947' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-747e1a18-260a-4d7d-80a6-dc6af7fc9947' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bcab888b-0470-46d1-918e-8b715b9ff4ca' class='xr-var-data-in' type='checkbox'><label for='data-bcab888b-0470-46d1-918e-8b715b9ff4ca' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 926.625433055833 0.0 4447802.078667 0.0 -926.6254330558334</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-60db2e5b-e6b3-4b26-a502-c0009d8e12d6' class='xr-section-summary-in' type='checkbox'  checked><label for='section-60db2e5b-e6b3-4b26-a502-c0009d8e12d6' class='xr-section-summary' >Attributes: <span>(5)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-276d3553-e312-4e93-9350-b1a1c43c45eb' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-276d3553-e312-4e93-9350-b1a1c43c45eb' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>x</span>: 2400</li><li><span class='xr-has-index'>y</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-a83d2c9d-d8a2-434d-b247-a93b11ac08b6' class='xr-section-summary-in' type='checkbox'  checked><label for='section-a83d2c9d-d8a2-434d-b247-a93b11ac08b6' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-444c0b0b-2fa0-4dd1-b853-49fad77d5647' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-444c0b0b-2fa0-4dd1-b853-49fad77d5647' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-63b429dd-396d-487d-8cf6-979d57533675' class='xr-var-data-in' type='checkbox'><label for='data-63b429dd-396d-487d-8cf6-979d57533675' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-952bb42d-9beb-49e9-a086-ac38bbc40a44' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-952bb42d-9beb-49e9-a086-ac38bbc40a44' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2944f279-f300-4fa6-aee8-995d408a29e6' class='xr-var-data-in' type='checkbox'><label for='data-2944f279-f300-4fa6-aee8-995d408a29e6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-ec80081c-6082-4f58-b4cf-78a3704177fa' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-ec80081c-6082-4f58-b4cf-78a3704177fa' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-191f744a-2c82-49e1-bc7c-d9c3c353a113' class='xr-var-data-in' type='checkbox'><label for='data-191f744a-2c82-49e1-bc7c-d9c3c353a113' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-8965a06a-a88b-4484-9645-aaa036feb7b7' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8965a06a-a88b-4484-9645-aaa036feb7b7' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-98aaf83e-abdd-4f45-9756-1646420c60c7' class='xr-var-data-in' type='checkbox'><label for='data-98aaf83e-abdd-4f45-9756-1646420c60c7' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-06d8115e-5fb0-47b9-a409-0d6ca900d280' class='xr-section-summary-in' type='checkbox'  checked><label for='section-06d8115e-5fb0-47b9-a409-0d6ca900d280' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-14129953-3d82-40a6-952a-4583696de296' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-14129953-3d82-40a6-952a-4583696de296' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4eb640be-4e2e-4076-aa85-343c25161f2c' class='xr-var-data-in' type='checkbox'><label for='data-4eb640be-4e2e-4076-aa85-343c25161f2c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4e8e800c-a3f5-4206-8eac-73e3621cd6f9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4e8e800c-a3f5-4206-8eac-73e3621cd6f9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-33f2279e-0825-448b-bdee-ccf64d9c9eeb' class='xr-var-data-in' type='checkbox'><label for='data-33f2279e-0825-448b-bdee-ccf64d9c9eeb' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d32ea60f-a8d7-4a2c-9f8b-65f1364872d5' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d32ea60f-a8d7-4a2c-9f8b-65f1364872d5' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6ca0196e-48ef-4a76-bcab-9724a0ee2367' class='xr-var-data-in' type='checkbox'><label for='data-6ca0196e-48ef-4a76-bcab-9724a0ee2367' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-2d6a290a-83a4-42a3-bc1f-ac87703b3da0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-2d6a290a-83a4-42a3-bc1f-ac87703b3da0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c4341afa-8cd1-480f-9300-ab966d6b78d2' class='xr-var-data-in' type='checkbox'><label for='data-c4341afa-8cd1-480f-9300-ab966d6b78d2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9cd82f34-ccf8-495d-a1d3-c36253350920' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9cd82f34-ccf8-495d-a1d3-c36253350920' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cf3d9b0a-2734-4bbd-befc-433abdd02b7d' class='xr-var-data-in' type='checkbox'><label for='data-cf3d9b0a-2734-4bbd-befc-433abdd02b7d' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3f4b3e91-c95f-429f-a1e0-2ac12e75b8c5' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3f4b3e91-c95f-429f-a1e0-2ac12e75b8c5' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-d7281e47-31ef-4a58-9b26-999fb26588a3' class='xr-var-data-in' type='checkbox'><label for='data-d7281e47-31ef-4a58-9b26-999fb26588a3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-8a3c2107-0b72-42a4-b2b0-19bfdf48d1d9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8a3c2107-0b72-42a4-b2b0-19bfdf48d1d9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-feeec8ca-560e-4a6d-bd5d-1de23365c823' class='xr-var-data-in' type='checkbox'><label for='data-feeec8ca-560e-4a6d-bd5d-1de23365c823' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-08757838-19e9-4611-a002-a218ae2cdc7a' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-08757838-19e9-4611-a002-a218ae2cdc7a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-66b4b2d6-ac6a-4284-ad07-bfe2f845f645' class='xr-var-data-in' type='checkbox'><label for='data-66b4b2d6-ac6a-4284-ad07-bfe2f845f645' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-3663eca4-16aa-4fe5-82e4-5468a7ca401d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3663eca4-16aa-4fe5-82e4-5468a7ca401d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-cbfcdb23-8be3-49b4-8bb0-72f0e3900b10' class='xr-var-data-in' type='checkbox'><label for='data-cbfcdb23-8be3-49b4-8bb0-72f0e3900b10' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-63e27ff7-5cd4-44e3-94b2-72f4e068a9d1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-63e27ff7-5cd4-44e3-94b2-72f4e068a9d1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c4e37d22-eede-4aef-9c0f-c4c18f00a350' class='xr-var-data-in' type='checkbox'><label for='data-c4e37d22-eede-4aef-9c0f-c4c18f00a350' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-f71cc433-a8b9-40f4-adcc-a92159047713' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f71cc433-a8b9-40f4-adcc-a92159047713' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-65744b96-290e-43dc-aaf1-643b31968c15' class='xr-var-data-in' type='checkbox'><label for='data-65744b96-290e-43dc-aaf1-643b31968c15' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-dae03558-4d66-4222-aa77-49a5b89ab057' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-dae03558-4d66-4222-aa77-49a5b89ab057' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-92340d72-6377-4ba0-a80b-e423fa9848e5' class='xr-var-data-in' type='checkbox'><label for='data-92340d72-6377-4ba0-a80b-e423fa9848e5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-e262a4ac-8076-47f8-a237-6137a80fcf3d' class='xr-section-summary-in' type='checkbox'  ><label for='section-e262a4ac-8076-47f8-a237-6137a80fcf3d' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>






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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-15c449a4-120b-464d-ab7e-db59f04cbfc1' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-15c449a4-120b-464d-ab7e-db59f04cbfc1' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>x</span>: 2400</li><li><span class='xr-has-index'>y</span>: 2400</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-e46407b5-6f4b-4266-b800-9527b8a5bdf9' class='xr-section-summary-in' type='checkbox'  checked><label for='section-e46407b5-6f4b-4266-b800-9527b8a5bdf9' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.448e+06 4.447e+06 ... 3.336e+06</div><input id='attrs-87d775b3-1009-4051-b662-1dc2d7e6f755' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-87d775b3-1009-4051-b662-1dc2d7e6f755' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-001b4df4-7435-4926-b961-b71c28279749' class='xr-var-data-in' type='checkbox'><label for='data-001b4df4-7435-4926-b961-b71c28279749' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4447570.422309, 4447107.109592, 4446643.796876, ..., 3337009.840791,
       3336546.528075, 3336083.215358])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-1.001e+07 ... -8.896e+06</div><input id='attrs-f9579a67-8aab-4b4f-bb8c-ce9d9d6833c5' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-f9579a67-8aab-4b4f-bb8c-ce9d9d6833c5' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-8b9ccdf0-176d-47b8-94ab-98523896d073' class='xr-var-data-in' type='checkbox'><label for='data-8b9ccdf0-176d-47b8-94ab-98523896d073' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([-10007323.020642, -10006859.707925, -10006396.395209, ...,
        -8896762.439124,  -8896299.126408,  -8895835.813691])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-e6d730ef-7193-41c9-a3d7-67d2fdd75492' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-e6d730ef-7193-41c9-a3d7-67d2fdd75492' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-6cbaf7de-2f7f-493e-9842-17517decae31' class='xr-var-data-in' type='checkbox'><label for='data-6cbaf7de-2f7f-493e-9842-17517decae31' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-b9a08f87-ddb2-4db1-aa88-6e84d948e744' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b9a08f87-ddb2-4db1-aa88-6e84d948e744' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-17f15010-12fb-423a-bb26-c1f22ee7b215' class='xr-var-data-in' type='checkbox'><label for='data-17f15010-12fb-423a-bb26-c1f22ee7b215' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-10007554.677 463.3127165279165 0.0 4447802.078667 0.0 -463.3127165279167</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-7e9329df-c544-42ed-92ef-3fdce5275ab8' class='xr-section-summary-in' type='checkbox'  checked><label for='section-7e9329df-c544-42ed-92ef-3fdce5275ab8' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d387cd30-8638-4815-b81b-1c6cb3928949' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d387cd30-8638-4815-b81b-1c6cb3928949' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7ba1d127-83a8-45b0-906e-ca61758a50f6' class='xr-var-data-in' type='checkbox'><label for='data-7ba1d127-83a8-45b0-906e-ca61758a50f6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9cde09e0-ee22-4c51-9083-b02561808d92' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9cde09e0-ee22-4c51-9083-b02561808d92' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0791f5f3-40cb-4c8e-b336-dd502385858a' class='xr-var-data-in' type='checkbox'><label for='data-0791f5f3-40cb-4c8e-b336-dd502385858a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-df2b6d23-8b58-4dd2-9214-9d09ee534c32' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-df2b6d23-8b58-4dd2-9214-9d09ee534c32' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7a26fe00-6e8a-4592-b27f-06a3a7be3606' class='xr-var-data-in' type='checkbox'><label for='data-7a26fe00-6e8a-4592-b27f-06a3a7be3606' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-9afda075-f2fc-4d67-89c9-53226b2fb174' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9afda075-f2fc-4d67-89c9-53226b2fb174' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-fc9f3853-8322-421a-b995-a34a9759fdab' class='xr-var-data-in' type='checkbox'><label for='data-fc9f3853-8322-421a-b995-a34a9759fdab' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-eea6c08f-bf8a-40cf-8680-460b81552c59' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-eea6c08f-bf8a-40cf-8680-460b81552c59' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-376ce313-16b6-4db9-899d-19dea4ab668b' class='xr-var-data-in' type='checkbox'><label for='data-376ce313-16b6-4db9-899d-19dea4ab668b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-4f59d359-0299-4d05-ba27-66499a07f915' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-4f59d359-0299-4d05-ba27-66499a07f915' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-535b08e5-6965-49ca-b5d5-68cc8ec2d925' class='xr-var-data-in' type='checkbox'><label for='data-535b08e5-6965-49ca-b5d5-68cc8ec2d925' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-c03b3d2a-d814-4041-9e39-bd3c1bc51dcd' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c03b3d2a-d814-4041-9e39-bd3c1bc51dcd' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-2581aa27-03ce-4eb4-b9b4-cb6e8de86f8a' class='xr-var-data-in' type='checkbox'><label for='data-2581aa27-03ce-4eb4-b9b4-cb6e8de86f8a' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-e183d985-b17d-4ba5-b9e7-de955ec704c1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e183d985-b17d-4ba5-b9e7-de955ec704c1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-61f952f7-3547-47d4-906d-4978412a85ba' class='xr-var-data-in' type='checkbox'><label for='data-61f952f7-3547-47d4-906d-4978412a85ba' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-80ab57cd-023b-4740-8ff3-15c19a21cc09' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-80ab57cd-023b-4740-8ff3-15c19a21cc09' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9f5003a2-9434-4f1b-8d16-b15dc4e639fe' class='xr-var-data-in' type='checkbox'><label for='data-9f5003a2-9434-4f1b-8d16-b15dc4e639fe' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-d4ec4f77-6d80-45ce-b9e6-10f133291fab' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-d4ec4f77-6d80-45ce-b9e6-10f133291fab' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a4b1a056-2b40-4f4e-bf8b-68388b6dbf69' class='xr-var-data-in' type='checkbox'><label for='data-a4b1a056-2b40-4f4e-bf8b-68388b6dbf69' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-afdc4e3c-0419-4b7d-b833-dbf3ea146c12' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-afdc4e3c-0419-4b7d-b833-dbf3ea146c12' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5081f742-8ff5-4b2e-ae0e-e48c5e44b7e2' class='xr-var-data-in' type='checkbox'><label for='data-5081f742-8ff5-4b2e-ae0e-e48c5e44b7e2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>...</div><input id='attrs-c8653e15-22ef-4f45-a9fc-7a06d36131a1' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c8653e15-22ef-4f45-a9fc-7a06d36131a1' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-70d72b76-7efc-4793-9c7a-1b13a396d2e2' class='xr-var-data-in' type='checkbox'><label for='data-70d72b76-7efc-4793-9c7a-1b13a396d2e2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>[5760000 values with dtype=float64]</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-771f171a-bbc0-484d-bba2-63745e6b8a9b' class='xr-section-summary-in' type='checkbox'  ><label for='section-771f171a-bbc0-484d-bba2-63745e6b8a9b' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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
    ZONEIDENTIFIER:                      Universal Transverse Mercator UTM</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.Dataset</div></div><ul class='xr-sections'><li class='xr-section-item'><input id='section-3a7b7ec3-1fa5-4135-82d7-1252b4005dc1' class='xr-section-summary-in' type='checkbox' disabled ><label for='section-3a7b7ec3-1fa5-4135-82d7-1252b4005dc1' class='xr-section-summary'  title='Expand/collapse section'>Dimensions:</label><div class='xr-section-inline-details'><ul class='xr-dim-list'><li><span class='xr-has-index'>band</span>: 1</li><li><span class='xr-has-index'>x</span>: 8</li><li><span class='xr-has-index'>y</span>: 3</li></ul></div><div class='xr-section-details'></div></li><li class='xr-section-item'><input id='section-c46a6a48-44fd-45ff-8026-a9bf1d0143c7' class='xr-section-summary-in' type='checkbox'  checked><label for='section-c46a6a48-44fd-45ff-8026-a9bf1d0143c7' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.446e+06 4.446e+06 4.445e+06</div><input id='attrs-1bd41d9e-c3e2-4cf5-9b00-3c11df3a0465' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-1bd41d9e-c3e2-4cf5-9b00-3c11df3a0465' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-021c51b9-215d-4d2e-8530-f0b02b3ea1a2' class='xr-var-data-in' type='checkbox'><label for='data-021c51b9-215d-4d2e-8530-f0b02b3ea1a2' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4446180.484159, 4445717.171443, 4445253.858726])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>-8.988e+06 ... -8.985e+06</div><input id='attrs-54fd7da3-04a3-4871-9646-c10733ad7323' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-54fd7da3-04a3-4871-9646-c10733ad7323' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-92345fd1-06af-4424-a8cc-133a41d12183' class='xr-var-data-in' type='checkbox'><label for='data-92345fd1-06af-4424-a8cc-133a41d12183' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([-8988498.356997, -8988035.04428 , -8987571.731564, -8987108.418847,
       -8986645.106131, -8986181.793414, -8985718.480698, -8985255.167981])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>band</span></div><div class='xr-var-dims'>(band)</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>1</div><input id='attrs-bf8fb1f0-d3c1-4dab-9c1f-ccd04e5954ef' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-bf8fb1f0-d3c1-4dab-9c1f-ccd04e5954ef' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4e0e415c-cf08-4d19-951d-fee859bdba1c' class='xr-var-data-in' type='checkbox'><label for='data-4e0e415c-cf08-4d19-951d-fee859bdba1c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([1])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-f9b9f8e7-cf00-4dea-9106-247c8f98dfb0' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-f9b9f8e7-cf00-4dea-9106-247c8f98dfb0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-284e3583-50d4-4a26-8d85-9bf23a2e72e4' class='xr-var-data-in' type='checkbox'><label for='data-284e3583-50d4-4a26-8d85-9bf23a2e72e4' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>semi_major_axis :</span></dt><dd>6371007.181</dd><dt><span>semi_minor_axis :</span></dt><dd>6371007.181</dd><dt><span>inverse_flattening :</span></dt><dd>0.0</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>Custom spheroid</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the custom spheroid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not specified (based on custom spheroid)</dd><dt><span>projected_crs_name :</span></dt><dd>unnamed</dd><dt><span>grid_mapping_name :</span></dt><dd>sinusoidal</dd><dt><span>longitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>false_easting :</span></dt><dd>0.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>spatial_ref :</span></dt><dd>PROJCRS[&quot;unnamed&quot;,BASEGEOGCRS[&quot;Unknown datum based upon the custom spheroid&quot;,DATUM[&quot;Not specified (based on custom spheroid)&quot;,ELLIPSOID[&quot;Custom spheroid&quot;,6371007.181,0,LENGTHUNIT[&quot;metre&quot;,1,ID[&quot;EPSG&quot;,9001]]]],PRIMEM[&quot;Greenwich&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433,ID[&quot;EPSG&quot;,9122]]]],CONVERSION[&quot;unnamed&quot;,METHOD[&quot;Sinusoidal&quot;],PARAMETER[&quot;Longitude of natural origin&quot;,0,ANGLEUNIT[&quot;degree&quot;,0.0174532925199433],ID[&quot;EPSG&quot;,8802]],PARAMETER[&quot;False easting&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8806]],PARAMETER[&quot;False northing&quot;,0,LENGTHUNIT[&quot;Meter&quot;,1],ID[&quot;EPSG&quot;,8807]]],CS[Cartesian,2],AXIS[&quot;easting&quot;,east,ORDER[1],LENGTHUNIT[&quot;Meter&quot;,1]],AXIS[&quot;northing&quot;,north,ORDER[2],LENGTHUNIT[&quot;Meter&quot;,1]]]</dd><dt><span>GeoTransform :</span></dt><dd>-8988730.013355112 463.31271652797506 0.0 4446412.1405174155 0.0 -463.312716527842</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-9349b75f-7e20-4b55-aa0f-e34ee20f1057' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9349b75f-7e20-4b55-aa0f-e34ee20f1057' class='xr-section-summary' >Data variables: <span>(12)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span>num_observations_500m</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>2.0 2.0 2.0 2.0 ... 2.0 2.0 2.0 nan</div><input id='attrs-0f5b647f-2040-4467-a7b1-48698b9e742e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0f5b647f-2040-4467-a7b1-48698b9e742e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-3f0dbc7b-80b3-4975-b600-ca2ad1ab8ca3' class='xr-var-data-in' type='checkbox'><label for='data-3f0dbc7b-80b3-4975-b600-ca2ad1ab8ca3' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Number of Observations</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[ 2.,  2.,  2.,  2.,  2., nan, nan, nan],
        [ 2.,  2.,  2.,  2.,  2.,  2.,  2.,  2.],
        [ 2.,  2.,  2.,  2.,  2.,  2.,  2., nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b01_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>428.0 450.0 450.0 ... 458.0 nan</div><input id='attrs-8d4d8e70-37ac-420a-af16-77cca714c298' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8d4d8e70-37ac-420a-af16-77cca714c298' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c7b83a92-baaa-468f-ad51-a5d13e95937c' class='xr-var-data-in' type='checkbox'><label for='data-c7b83a92-baaa-468f-ad51-a5d13e95937c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 1 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[428., 450., 450., 438., 438.,  nan,  nan,  nan],
        [402., 402., 402., 442., 442., 442., 442., 458.],
        [402., 402., 442., 442., 442., 442., 458.,  nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b02_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>3.013e+03 2.809e+03 ... nan</div><input id='attrs-0258858a-ba9c-46f5-a634-624b5c6825ae' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-0258858a-ba9c-46f5-a634-624b5c6825ae' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-643e8577-5bae-4fb5-92c5-9cce6eab8295' class='xr-var-data-in' type='checkbox'><label for='data-643e8577-5bae-4fb5-92c5-9cce6eab8295' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 2 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[3013., 2809., 2809., 2730., 2730.,   nan,   nan,   nan],
        [2565., 2565., 2565., 2522., 2522., 2522., 2522., 2496.],
        [2565., 2565., 2522., 2522., 2522., 2522., 2496.,   nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b03_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>259.0 235.0 235.0 ... 265.0 nan</div><input id='attrs-b5cc1482-6fa2-4753-9595-92c6f0dfa5f2' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-b5cc1482-6fa2-4753-9595-92c6f0dfa5f2' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-45a46aad-b084-49e5-b624-f8a144f0522f' class='xr-var-data-in' type='checkbox'><label for='data-45a46aad-b084-49e5-b624-f8a144f0522f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 3 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[259., 235., 235., 231., 231.,  nan,  nan,  nan],
        [217., 217., 217., 230., 230., 230., 230., 265.],
        [217., 217., 230., 230., 230., 230., 265.,  nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b04_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>563.0 541.0 541.0 ... 518.0 nan</div><input id='attrs-a7b7e717-5b20-41f0-8c7b-cecb531ae9c6' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a7b7e717-5b20-41f0-8c7b-cecb531ae9c6' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-387ad8d6-59c6-4330-8b9d-526eccffb116' class='xr-var-data-in' type='checkbox'><label for='data-387ad8d6-59c6-4330-8b9d-526eccffb116' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 4 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[563., 541., 541., 528., 528.,  nan,  nan,  nan],
        [476., 476., 476., 476., 476., 476., 476., 518.],
        [476., 476., 476., 476., 476., 476., 518.,  nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b05_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>3.04e+03 2.587e+03 ... nan</div><input id='attrs-e016691e-d344-4746-98d3-1be285d45905' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e016691e-d344-4746-98d3-1be285d45905' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-977cc6e3-bed1-4338-80fb-486033bb81ed' class='xr-var-data-in' type='checkbox'><label for='data-977cc6e3-bed1-4338-80fb-486033bb81ed' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 5 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[3040., 2587., 2587., 2554., 2554.,   nan,   nan,   nan],
        [2293., 2293., 2293., 2559., 2559., 2559., 2559., 2315.],
        [2293., 2293., 2559., 2559., 2559., 2559., 2315.,   nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b06_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>1.841e+03 1.738e+03 ... 1.6e+03 nan</div><input id='attrs-8d2856e3-85c2-4b4b-a288-baef9d79ac2e' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-8d2856e3-85c2-4b4b-a288-baef9d79ac2e' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a675949c-2867-4fba-a910-a832eb2b6212' class='xr-var-data-in' type='checkbox'><label for='data-a675949c-2867-4fba-a910-a832eb2b6212' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 6 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[1841., 1738., 1738., 1683., 1683.,   nan,   nan,   nan],
        [1514., 1514., 1514., 1583., 1583., 1583., 1583., 1600.],
        [1514., 1514., 1583., 1583., 1583., 1583., 1600.,   nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>sur_refl_b07_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>832.0 820.0 820.0 ... 804.0 nan</div><input id='attrs-7c8a0acb-61c3-48f0-b2b8-9f6b75f82184' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-7c8a0acb-61c3-48f0-b2b8-9f6b75f82184' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-422e088a-a633-42e1-a3d5-c898bfb9d3e5' class='xr-var-data-in' type='checkbox'><label for='data-422e088a-a633-42e1-a3d5-c898bfb9d3e5' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>10000.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Surface Reflectance Band 7 - first layer</dd><dt><span>units :</span></dt><dd>reflectance</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[832., 820., 820., 820., 820.,  nan,  nan,  nan],
        [715., 715., 715., 789., 789., 789., 789., 804.],
        [715., 715., 789., 789., 789., 789., 804.,  nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>QC_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>1.074e+09 1.074e+09 ... nan</div><input id='attrs-5cc8cc60-e0af-4a62-802a-588d5170f458' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-5cc8cc60-e0af-4a62-802a-588d5170f458' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-9f33d3c2-c3e1-411c-ae52-aa55fd7a06b6' class='xr-var-data-in' type='checkbox'><label for='data-9f33d3c2-c3e1-411c-ae52-aa55fd7a06b6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>500m Reflectance Band Quality - first layer</dd><dt><span>units :</span></dt><dd>bit field</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[1.07374182e+09, 1.07374182e+09, 1.07374182e+09, 1.07374182e+09,
         1.07374182e+09,            nan,            nan,            nan],
        [1.07374182e+09, 1.07374182e+09, 1.07374182e+09, 1.07374182e+09,
         1.07374182e+09, 1.07374182e+09, 1.07374182e+09, 1.07374182e+09],
        [1.07374182e+09, 1.07374182e+09, 1.07374182e+09, 1.07374182e+09,
         1.07374182e+09, 1.07374182e+09, 1.07374182e+09,            nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>obscov_500m_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>6.0 7.0 10.0 9.0 ... 8.0 9.0 nan</div><input id='attrs-3f2cfa11-85b3-40ae-af7b-b885d6b4bf64' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-3f2cfa11-85b3-40ae-af7b-b885d6b4bf64' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-7976e53d-f1d1-4738-b0dd-55136d9bc00e' class='xr-var-data-in' type='checkbox'><label for='data-7976e53d-f1d1-4738-b0dd-55136d9bc00e' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.00999999977648258</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>Observation coverage - first layer</dd><dt><span>units :</span></dt><dd>percent</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[ 6.,  7., 10.,  9.,  8., nan, nan, nan],
        [11., 12.,  9.,  8., 11., 11.,  8.,  8.],
        [ 9.,  7.,  7., 11., 11.,  8.,  9., nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>iobs_res_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>0.0 0.0 0.0 0.0 ... 0.0 0.0 1.0 nan</div><input id='attrs-9551ce43-0261-4a6e-a1dd-26aa00dc3e2f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-9551ce43-0261-4a6e-a1dd-26aa00dc3e2f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a3ff3b39-d95b-49d1-b6c4-498bd29992c6' class='xr-var-data-in' type='checkbox'><label for='data-a3ff3b39-d95b-49d1-b6c4-498bd29992c6' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>observation number in coarser grid - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[ 0.,  0.,  0.,  0.,  0., nan, nan, nan],
        [ 0.,  0.,  0.,  0.,  0.,  0.,  0.,  0.],
        [ 0.,  0.,  0.,  0.,  0.,  0.,  1., nan]]])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>q_scan_1</span></div><div class='xr-var-dims'>(band, y, x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>1.0 12.0 15.0 7.0 ... 15.0 15.0 nan</div><input id='attrs-c5b16b1e-618c-4c64-8bb1-0efd5c44e21b' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c5b16b1e-618c-4c64-8bb1-0efd5c44e21b' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-c9e91a5b-42a0-4541-bf22-761f32e4d9a0' class='xr-var-data-in' type='checkbox'><label for='data-c9e91a5b-42a0-4541-bf22-761f32e4d9a0' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>1.0</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>long_name :</span></dt><dd>250m scan value information - first layer</dd><dt><span>units :</span></dt><dd>none</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div><div class='xr-var-data'><pre>array([[[ 1., 12., 15.,  7.,  8., nan, nan, nan],
        [15., 15., 15., 15., 15., 15., 15., 15.],
        [15., 15., 15., 15., 15., 15., 15., nan]]])</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-5e1e04dd-b453-450d-aba7-2f41f71b0809' class='xr-section-summary-in' type='checkbox'  ><label for='section-5e1e04dd-b453-450d-aba7-2f41f71b0809' class='xr-section-summary' >Attributes: <span>(136)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>ADDITIONALLAYERS1KM :</span></dt><dd>11</dd><dt><span>ADDITIONALLAYERS500M :</span></dt><dd>1</dd><dt><span>ASSOCIATEDINSTRUMENTSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>ASSOCIATEDPLATFORMSHORTNAME.1 :</span></dt><dd>Terra</dd><dt><span>ASSOCIATEDSENSORSHORTNAME.1 :</span></dt><dd>MODIS</dd><dt><span>AUTOMATICQUALITYFLAG.1 :</span></dt><dd>Passed</dd><dt><span>AUTOMATICQUALITYFLAGEXPLANATION.1 :</span></dt><dd>No automatic quality assessment is performed in the PGE</dd><dt><span>CHARACTERISTICBINANGULARSIZE1KM :</span></dt><dd>30.0</dd><dt><span>CHARACTERISTICBINANGULARSIZE500M :</span></dt><dd>15.0</dd><dt><span>CHARACTERISTICBINSIZE1KM :</span></dt><dd>926.625433055556</dd><dt><span>CHARACTERISTICBINSIZE500M :</span></dt><dd>463.312716527778</dd><dt><span>CLOUDOPTION :</span></dt><dd>MOD09 internally-derived</dd><dt><span>COVERAGECALCULATIONMETHOD :</span></dt><dd>volume</dd><dt><span>COVERAGEMINIMUM :</span></dt><dd>0.00999999977648258</dd><dt><span>DATACOLUMNS1KM :</span></dt><dd>1200</dd><dt><span>DATACOLUMNS500M :</span></dt><dd>2400</dd><dt><span>DATAROWS1KM :</span></dt><dd>1200</dd><dt><span>DATAROWS500M :</span></dt><dd>2400</dd><dt><span>DAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>DEEPOCEANFLAG :</span></dt><dd>Yes</dd><dt><span>DESCRREVISION :</span></dt><dd>6.1</dd><dt><span>EASTBOUNDINGCOORDINATE :</span></dt><dd>-92.3664205550513</dd><dt><span>EQUATORCROSSINGDATE.1 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGDATE.2 :</span></dt><dd>2016-07-07</dd><dt><span>EQUATORCROSSINGLONGITUDE.1 :</span></dt><dd>-103.273195919522</dd><dt><span>EQUATORCROSSINGLONGITUDE.2 :</span></dt><dd>-127.994803619317</dd><dt><span>EQUATORCROSSINGTIME.1 :</span></dt><dd>17:23:36.891214</dd><dt><span>EQUATORCROSSINGTIME.2 :</span></dt><dd>19:02:29.990629</dd><dt><span>EXCLUSIONGRINGFLAG.1 :</span></dt><dd>N</dd><dt><span>FIRSTLAYERSELECTIONCRITERIA :</span></dt><dd>order of input pointer</dd><dt><span>GEOANYABNORMAL :</span></dt><dd>False</dd><dt><span>GEOESTMAXRMSERROR :</span></dt><dd>50.0</dd><dt><span>GLOBALGRIDCOLUMNS1KM :</span></dt><dd>43200</dd><dt><span>GLOBALGRIDCOLUMNS500M :</span></dt><dd>86400</dd><dt><span>GLOBALGRIDROWS1KM :</span></dt><dd>21600</dd><dt><span>GLOBALGRIDROWS500M :</span></dt><dd>43200</dd><dt><span>GRANULEBEGINNINGDATETIME :</span></dt><dd>2016-07-07T17:10:00.000000Z</dd><dt><span>GRANULEBEGINNINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:10:00.000000Z, 2016-07-07T17:15:00.000000Z, 2016-07-07T18:50:00.000000Z, 2016-07-07T20:25:00.000000Z</dd><dt><span>GRANULEDAYNIGHTFLAG :</span></dt><dd>Day</dd><dt><span>GRANULEDAYNIGHTFLAGARRAY :</span></dt><dd>Day, Day, Day, Day</dd><dt><span>GRANULEDAYOFYEAR :</span></dt><dd>189</dd><dt><span>GRANULEENDINGDATETIME :</span></dt><dd>2016-07-07T18:55:00.000000Z</dd><dt><span>GRANULEENDINGDATETIMEARRAY :</span></dt><dd>2016-07-07T17:15:00.000000Z, 2016-07-07T17:20:00.000000Z, 2016-07-07T18:55:00.000000Z, 2016-07-07T20:30:00.000000Z</dd><dt><span>GRANULENUMBERARRAY :</span></dt><dd>208, 209, 228, 247, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRANULEPOINTERARRAY :</span></dt><dd>0, 1, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>GRINGPOINTLATITUDE.1 :</span></dt><dd>29.8360532722546, 39.9999999964079, 40.0742066197196, 29.9009502428382</dd><dt><span>GRINGPOINTLONGITUDE.1 :</span></dt><dd>-103.835851753394, -117.486656023174, -104.256722414513, -92.131858571552</dd><dt><span>GRINGPOINTSEQUENCENO.1 :</span></dt><dd>1, 2, 3, 4</dd><dt><span>HDFEOSVersion :</span></dt><dd>HDFEOS_V2.17</dd><dt><span>HORIZONTALTILENUMBER :</span></dt><dd>9</dd><dt><span>identifier_product_doi :</span></dt><dd>10.5067/MODIS/MOD09GA.006</dd><dt><span>identifier_product_doi_authority :</span></dt><dd>http://dx.doi.org</dd><dt><span>INPUTPOINTER :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf, DEM_SN_H.h09v05.006_0.hdf, MCDLCHKM.A2010001.h09v05.051.2014287174141.hdf</dd><dt><span>KEEPALL :</span></dt><dd>No</dd><dt><span>L2GSTORAGEFORMAT1KM :</span></dt><dd>compact</dd><dt><span>L2GSTORAGEFORMAT500M :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_1km :</span></dt><dd>compact</dd><dt><span>l2g_storage_format_500m :</span></dt><dd>compact</dd><dt><span>LOCALGRANULEID :</span></dt><dd>MOD09GA.A2016189.h09v05.006.2016191073856.hdf</dd><dt><span>LOCALVERSIONID :</span></dt><dd>6.0.9</dd><dt><span>LONGNAME :</span></dt><dd>MODIS/Terra Surface Reflectance Daily L2G Global 1km and 500m SIN Grid</dd><dt><span>MAXIMUMOBSERVATIONS1KM :</span></dt><dd>12</dd><dt><span>MAXIMUMOBSERVATIONS500M :</span></dt><dd>2</dd><dt><span>maximum_observations_1km :</span></dt><dd>12</dd><dt><span>maximum_observations_500m :</span></dt><dd>2</dd><dt><span>MAXOUTPUTRES :</span></dt><dd>QKM</dd><dt><span>NADIRDATARESOLUTION1KM :</span></dt><dd>1km</dd><dt><span>NADIRDATARESOLUTION500M :</span></dt><dd>500m</dd><dt><span>NORTHBOUNDINGCOORDINATE :</span></dt><dd>39.9999999964079</dd><dt><span>NumberLandWater1km :</span></dt><dd>0, 1418266, 15655, 6079, 0, 0, 0, 0, 0</dd><dt><span>NumberLandWater500m :</span></dt><dd>0, 2836532, 31310, 12158, 0, 0, 0, 0, 0</dd><dt><span>NUMBEROFGRANULES :</span></dt><dd>1</dd><dt><span>NUMBEROFINPUTGRANULES :</span></dt><dd>4</dd><dt><span>NUMBEROFORBITS :</span></dt><dd>2</dd><dt><span>NUMBEROFOVERLAPGRANULES :</span></dt><dd>3</dd><dt><span>ORBITNUMBER.1 :</span></dt><dd>88050</dd><dt><span>ORBITNUMBER.2 :</span></dt><dd>88051</dd><dt><span>ORBITNUMBERARRAY :</span></dt><dd>88050, 88050, 88051, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1</dd><dt><span>PARAMETERNAME.1 :</span></dt><dd>MOD09G</dd><dt><span>PERCENTCLOUDY :</span></dt><dd>13</dd><dt><span>PERCENTLAND :</span></dt><dd>97</dd><dt><span>PERCENTLANDSEAMASKCLASS :</span></dt><dd>0, 97, 3, 0, 0, 0, 0, 0</dd><dt><span>PERCENTLOWSUN :</span></dt><dd>0</dd><dt><span>PERCENTPROCESSED :</span></dt><dd>100</dd><dt><span>PERCENTSHADOW :</span></dt><dd>2</dd><dt><span>PGEVERSION :</span></dt><dd>6.0.32</dd><dt><span>PROCESSINGCENTER :</span></dt><dd>MODAPS</dd><dt><span>PROCESSINGENVIRONMENT :</span></dt><dd>Linux minion6007 2.6.32-642.1.1.el6.x86_64 #1 SMP Tue May 31 21:57:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux</dd><dt><span>PROCESSVERSION :</span></dt><dd>6.0.9</dd><dt><span>PRODUCTIONDATETIME :</span></dt><dd>2016-07-09T07:38:56.000Z</dd><dt><span>QAPERCENTGOODQUALITY :</span></dt><dd>100</dd><dt><span>QAPERCENTINTERPOLATEDDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTMISSINGDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDCLOUD :</span></dt><dd>0</dd><dt><span>QAPERCENTNOTPRODUCEDOTHER :</span></dt><dd>0</dd><dt><span>QAPERCENTOTHERQUALITY :</span></dt><dd>0</dd><dt><span>QAPERCENTOUTOFBOUNDSDATA.1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND1 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND2 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND3 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND4 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND5 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND6 :</span></dt><dd>0</dd><dt><span>QAPERCENTPOOROUTPUT500MBAND7 :</span></dt><dd>0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND1 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND2 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND3 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND4 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND5 :</span></dt><dd>96, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND6 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>QUALITYCLASSPERCENTAGE500MBAND7 :</span></dt><dd>100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0</dd><dt><span>RANGEBEGINNINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEBEGINNINGTIME :</span></dt><dd>17:10:00.000000</dd><dt><span>RANGEENDINGDATE :</span></dt><dd>2016-07-07</dd><dt><span>RANGEENDINGTIME :</span></dt><dd>18:55:00.000000</dd><dt><span>RANKING :</span></dt><dd>No</dd><dt><span>REPROCESSINGACTUAL :</span></dt><dd>processed once</dd><dt><span>REPROCESSINGPLANNED :</span></dt><dd>further update is anticipated</dd><dt><span>RESOLUTIONBANDS1AND2 :</span></dt><dd>500</dd><dt><span>SCIENCEQUALITYFLAG.1 :</span></dt><dd>Not Investigated</dd><dt><span>SCIENCEQUALITYFLAGEXPLANATION.1 :</span></dt><dd>See http://landweb.nascom.nasa.gov/cgi-bin/QA_WWW/qaFlagPage.cgi?sat=terra for the product Science Quality status.</dd><dt><span>SHORTNAME :</span></dt><dd>MOD09GA</dd><dt><span>SOUTHBOUNDINGCOORDINATE :</span></dt><dd>29.9999999973059</dd><dt><span>SPSOPARAMETERS :</span></dt><dd>2015</dd><dt><span>SYSTEMFILENAME :</span></dt><dd>MOD09GST.A2016189.h09v05.006.2016191073429.hdf, MOD09GHK.A2016189.h09v05.006.2016191073552.hdf, MOD09GQK.A2016189.h09v05.006.2016191073522.hdf, MODPT1KD.A2016189.h09v05.006.2016191073353.hdf, MODPTHKM.A2016189.h09v05.006.2016191073353.hdf, MODPTQKM.A2016189.h09v05.006.2016191073353.hdf, MODMGGAD.A2016189.h09v05.006.2016191073357.hdf, MODTBGD.A2016189.h09v05.006.2016191073601.hdf, MODOCGD.A2016189.h09v05.006.2016191073613.hdf, MOD10L2G.A2016189.h09v05.006.2016191073417.hdf</dd><dt><span>TileID :</span></dt><dd>51009005</dd><dt><span>TOTALADDITIONALOBSERVATIONS1KM :</span></dt><dd>2705510</dd><dt><span>TOTALADDITIONALOBSERVATIONS500M :</span></dt><dd>660129</dd><dt><span>TOTALOBSERVATIONS1KM :</span></dt><dd>4145510</dd><dt><span>TOTALOBSERVATIONS500M :</span></dt><dd>6420120</dd><dt><span>total_additional_observations_1km :</span></dt><dd>2705510</dd><dt><span>total_additional_observations_500m :</span></dt><dd>660129</dd><dt><span>VERSIONID :</span></dt><dd>6</dd><dt><span>VERTICALTILENUMBER :</span></dt><dd>5</dd><dt><span>WESTBOUNDINGCOORDINATE :</span></dt><dd>-117.486656023174</dd><dt><span>ZONEIDENTIFIER :</span></dt><dd>Universal Transverse Mercator UTM</dd></dl></div></li></ul></div></div>





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









{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/06-hierchical-data-formats/01-hdf4/2020-03-02-hdf-02-open-hdf4-python/2020-03-02-hdf-02-open-hdf4-python_71_0.png">

</figure>




{:.output}
{:.execute_result}



    array([[<AxesSubplot:title={'center':'Band 1'}>,
            <AxesSubplot:title={'center':'Band 2'}>,
            <AxesSubplot:title={'center':'Band 3'}>],
           [<AxesSubplot:title={'center':'Band 4'}>,
            <AxesSubplot:title={'center':'Band 5'}>,
            <AxesSubplot:title={'center':'Band 6'}>],
           [<AxesSubplot:title={'center':'Band 7'}>, <AxesSubplot:>,
            <AxesSubplot:>]], dtype=object)






