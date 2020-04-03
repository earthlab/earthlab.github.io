---
layout: single
title: "Understand EPSG, WKT and Other CRS Definition Styles"
excerpt: "Coordinate Reference System (CRS) information is often stored in three key formats, including proj.4, EPSG and WKT. Learn more about the ways that coordinate reference system data are stored including proj4, well known text (wkt) and EPSG codes."
authors: ['Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-03-13
category: [courses]
class-lesson: ['intro-vector-python-tb']
permalink: /courses/use-data-open-source-python/intro-vector-data-python/spatial-data-vector-shapefiles/epsg-proj4-coordinate-reference-system-formats-python/
nav-title: 'CRS: epsg vs proj.4'
course: 'intermediate-earth-data-science-textbook'
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  spatial-data-and-gis: ['coordinate-reference-systems']
redirect_from:
  - "/courses/earth-analytics-python/spatial-data-vector-shapefiles/epsg-proj4-coordinate-reference-system-formats-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Identify the `proj4` vs `EPSG` vs `WKT` crs format when presented with all three formats.
* Look up a `CRS` definition in `proj4`, `EPSG` or `WKT` formats using spatialreference.org.

</div>

On the previous pages, you learned what a coordinate reference system (CRS) is, the
components of a coordinate reference system and the general differences between
projected and geographic coordinate reference systems. On this page, you will
cover the different ways that `CRS` information is stored.

### Coordinate Reference System Formats

There are numerous formats that are used to document a `CRS`. Three common
formats include:

* **proj.4**
* **EPSG**
* Well-known Text (**WKT**)
formats.

Often you have CRS information in one format and you need to translate that CRS into a different format to use in a tool like `Python`. Thus it is good to be familiar with some of the key formats that you are likely to encounter. 

One of the most powerful websites to look up CRS strings is <a href="http://spatialreference.org/" target="_blank">Spatialreference.org</a>. You can use the search on the site to find an EPSG code. Once you find the page associated with your CRS of interest you can then look at all of the various formats associated with that CRS:
<a href="http://spatialreference.org/ref/epsg/4326/" target="_blank">EPSG 4326 - WGS84 geographic</a>

#### PROJ or PROJ.4 strings

`PROJ.4` strings are a compact way to identify a spatial or coordinate reference
system. `PROJ.4` strings are one of the formats that Geopandas can accept. However, note that many libraries 
are moving towards the more concise EPSG format.

Using the `PROJ.4` syntax, you specify the complete set of parameters including
the ellipse, datum, projection units and projection definition that define a particular `CRS`.

#### Break down the proj.4 format

Below is an example of a `proj.4` string:

`+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
+towgs84=0,0,0`

Notice that the `crs` information is structured using a string of
characters and numbers that are combined using `+` signs. The `CRS` for your data are in the `proj4` format. The string contains all of the individual
`CRS` elements that `Python` or another `GIS` might need. Each element is specified
with a `+` sign, similar to how a `.csv` file is delimited or broken up by
a `,`. After each `+` we see the `CRS` element being defined. For example
`+proj=` and `+datum=`.

You can break down the `proj4` string into its individual components (again, separated by + signs) as follows:

* **+proj=utm:** the projection is UTM, UTM has several zones.
* **+zone=11:** the zone is 11 which is a zone on the west coast, USA.
* **datum=WGS84:** the datum WGS84 (the datum refers to the 0,0 reference for
the coordinate system used in the projection)
* **+units=m:** the units for the coordinates are in METERS.
* **+ellps=WGS84:** the ellipsoid (how the earth's roundness is calculated) for
the data is `WGS84`

Note that the `zone` is unique to the UTM projection. Not all `CRS` will have a
zone.

Also note that while California is above the equator - in the northern hemisphere - there is no N (specifying north) following the zone (i.e. 11N)
South is explicitly specified in the UTM proj4 specification however
if there is no S, then you can assume it's a northern projection.


### Geographic (lat / long) Proj.4 String

Next, look at another CRS definition.

`+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0`

This is a lat/long or geographic projection. The components of the
`proj4` string are broken down below.

* **+proj=longlat:** the data are in a geographic (latitude and longitude)
coordinate system
* **datum=WGS84:** the datum WGS84 (the datum refers to the  0,0 reference for
the coordinate system used in the projection)
* **+ellps=WGS84:** the ellipsoid (how the earth's roundness is calculated)
is WGS84

Note that there are no specified units above. This is because this geographic
coordinate reference system is in latitude and longitude which is most
often recorded in *Decimal Degrees*.

<i class="fa fa-star"></i> **Data Tip:** the last portion of each `proj4` string
is `+towgs84=0,0,0 `. This is a conversion factor that is used if a `datum`
conversion is required.
{: .notice--warning }

### EPSG codes
The `EPSG` codes are 4-5 digit numbers that represent CRSs definitions. The
acronym `EPSG`, comes from the, now defunct, European Petroleum Survey Group. Each
code is a four-five digit number which represents a particular `CRS` definition.

<a href="http://spatialreference.org/ref/epsg/" target="_blank" class="btn">Explore ESPG codes on spatialreference.org
.</a>

Import the worldBoundary layer that you've been working with in this module to 
explore the `CRS`.

{:.input}
```python
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import geopandas as gpd
from shapely.geometry import Point
import earthpy as et

# Set working dir & get data
data = et.data.get_data('spatial-vector-lidar')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.input}
```python
# Import world boundary shapefile
worldBound_path = os.path.join("data", "spatial-vector-lidar", "global", 
                               "ne_110m_land", "ne_110m_land.shp")
worldBound = gpd.read_file(worldBound_path)

worldBound.crs
```

{:.output}
{:.execute_result}



    {'init': 'epsg:4326'}





Notice that the CRS returned above, consists of two parts:

1. 'init' which tells python that a CRS definition (ie EPSG code) will be provided and
2. the epsg code itself epsg: 4326

###  How to Create a CRS Object in Python  

You often need to define the CRS for a spatial object. For example in the previous lessons, you created new spatial point layers, and had to define the CRS that the point x,y locations were in.

To do this you completed the following steps:

1. You manually created an array for a single point (x,y).
2. You turned that x,y point into a shapely points object
3. Finally convert that point object to a pandas GeoDataFrame 


{:.input}
```python
# Create a numpy array with x,y location of Boulder
boulder_xy = np.array([[476911.31, 4429455.35]])

# Create shapely point object
boulder_xy_pt = [Point(xy) for xy in boulder_xy]

# Convert to spatial dataframe - geodataframe -- assign the CRS using epsg code
boulder_loc = gpd.GeoDataFrame(boulder_xy_pt,
                               columns=['geometry'],
                               crs={'init': 'epsg:2957'})

# View crs of new spatial points object
boulder_loc.crs
```

{:.output}
{:.execute_result}



    {'init': 'epsg:2957'}





#### `WKT` or Well-known Text

It's useful to recognize this format given many tools - including ESRI's ArcMap and ENVI use this format. Well-known Text (`WKT`) is a for compact machine- and human-readable representation of geometric objects. It defines elements of coordinate reference system (`CRS`) definitions using a combination of brackets `[]` and elements separated by
commas (`,`).

Here is an example of `WKT` for `WGS84` geographic:

`GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]]
`

Notice here that the elements are described explicitly using all caps - for example:

* UNIT
* DATUM

Sometimes WKT structured CRS information are embedded in a metadata file - similar to the structure seen below:

```xml

GEOGCS["WGS 84",
    DATUM["WGS_1984",
        SPHEROID["WGS 84",6378137,298.257223563,
            AUTHORITY["EPSG","7030"]],
        AUTHORITY["EPSG","6326"]],
    PRIMEM["Greenwich",0,
        AUTHORITY["EPSG","8901"]],
    UNIT["degree",0.01745329251994328,
        AUTHORITY["EPSG","9122"]],
    AUTHORITY["EPSG","4326"]]

```


## How to Look Up a `CRS`

The most powerful website to look-up `CRS` information is the
<a href="http://spatialreference.org" target="_blank">spatial reference.org website</a>.
This website has a useful search function that allows you to search
for strings such as:

* `UTM 11N` or
* `WGS84`

Once you find the `CRS` that you are looking for, you can explore definitions of
the `CRS` using various formats including `proj4`, `epsg`, `WKT` and others.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://docs.opengeospatial.org/is/12-063r5/12-063r5.html#43" target="_blank">Explore the WKT standard: Open Geospatial Consortium WKT document. </a>

* Read more about <a href="https://web.archive.org/web/20130211101051/https://www.nceas.ucsb.edu/scicomp/recipes/projections" target="_blank">all three formats from the National Center for Ecological Analysis and Synthesis.</a>
* A handy four page overview of CRS <a href="https://web.archive.org/web/20200225021219/https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf" target="_blank">including file formats on page 1.</a>

* <a href="https://www.epsg-registry.org/" target="_blank">The EPSG Registry. </a>
* <a href="http://spatialreference.org/" target="_blank">Spatialreference.org</a>
* <a href="http://spatialreference.org/ref/epsg/" target="_blank">List of ESPG Codes.</a>

</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Your GeoPandas Dataframes Skills: Import Line & Polygon Shapefiles

Import the `data/week5/california/madera-county-roads/tl_2013_06039_roads`
and `data/week5/california/SJER/vector_data/SJER_crop.shp` shapefiles into `Python`. 

Call the roads object `sjer_roads` and the crop layer `sjer_crop_extent`.

Answer the following questions:

1. What type of `Python` spatial object is created when you import each layer?
2. What is the `CRS` and `extent` for each object?
3. Do the files contain, points, lines or polygons?
4. How many spatial objects are in each file?

</div>

