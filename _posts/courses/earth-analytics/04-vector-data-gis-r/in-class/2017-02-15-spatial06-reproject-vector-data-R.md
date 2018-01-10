---
layout: single
title: "GIS in R: How to Reproject Vector Data in Different Coordinate Reference Systems (crs) in R"
excerpt: "In this lesson you learn how to reproject a vector dataset using the spTransform() function in R. "
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['class-intro-spatial-r']
permalink: /courses/earth-analytics/spatial-data-r/reproject-vector-data/
nav-title: 'Reproject Vector Data'
week: 4
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  spatial-data-and-gis: ['vector-data', 'coordinate-reference-systems']
  reproducible-science-and-programming:
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe atleast 2 reasons that a data provider may chose to store a dataset in a particular `CRS`.
* Reproject a vector dataset to another `CRS` in `R`.
* Identify the `CRS` of a spatial dataset in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

## Working with Spatial Data from Different Sources

You often need to gather spatial datasets for from different sources and/or data
that cover different spatial `extents`. Spatial data from different sources and
that cover different extents are often in different Coordinate Reference Systems (`CRS`).

Some reasons for data being in different `CRS`s include:

1. The data are stored in a particular `CRS` convention used by the data
provider which might be a federal agency, or a state planning office.
2. The data are stored in a particular `CRS` that is customized to a region.
For instance, many states prefer to use a **State Plane** projection customized
for that state.

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg" alt="Maps of the United States using data in different projections.">
    </a>

    <figcaption>Maps of the United States using data in different projections.
    Notice the differences in shape associated with each different projection.
    These differences are a direct result of the calculations used to "flatten"
    the data onto a 2-dimensional map. Often data are stored purposefully in a
    particular projection that optimizes the relative shape and size of
    surrounding geographic boundaries (states, counties, countries, etc).
    Source: opennews.org</figcaption>
</figure>


In this tutorial you will learn how to identify and manage spatial data
in different projections. You will learn how to `reproject` the data so that they
are in the same projection to support plotting / mapping. Note that these skills
are also required for any geoprocessing / spatial analysis. Data need to be in
the same `CRS` to ensure accurate results.

You will use the `rgdal` and `raster` libraries in this tutorial.


```r
# load spatial data packages
library(rgdal)
library(raster)
library(rgeos)
options(stringsAsFactors = FALSE)
# set working directory to data folder
# setwd("pathToDirHere")
```

## Import US Boundaries - Census Data

There are many good sources of boundary base layers that you can use to create a
basemap. Some `R` packages even have these base layers built in to support quick
and efficient mapping. In this tutorial, you will use boundary layers for the
United States, provided by the
<a href="https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html" target="_blank" data-proofer-ignore=''> United States Census Bureau.</a>

It is useful to have shapefiles to work with because you can add additional
attributes to them if need be - for project specific mapping.

## Read US Boundary File

You will use the `readOGR()` function to import the
`/usa-boundary-layers/US-State-Boundaries-Census-2014` layer into `R`. This layer
contains the boundaries of all continental states in the U.S. Please note that
these data have been modified and reprojected from the original data downloaded
from the Census website to support the learning goals of this tutorial.


```r
# Import the shapefile data into R
state_boundary_us <- readOGR("data/week-04/usa-boundary-layers",
          "US-State-Boundaries-Census-2014")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week-04/usa-boundary-layers", layer: "US-State-Boundaries-Census-2014"
## with 58 features
## It has 10 fields
## Integer64 fields read as strings:  ALAND AWATER
## Warning in readOGR("data/week-04/usa-boundary-layers", "US-State-
## Boundaries-Census-2014"): Z-dimension discarded

# view data structure
class(state_boundary_us)
## [1] "SpatialPolygonsDataFrame"
## attr(,"package")
## [1] "sp"
```

Note: The Z-dimension warning is normal. The `readOGR()` function doesn't import
z (vertical dimension or height) data by default. This is because not all
shapefiles contain z dimension data.
<a href="https://www.rdocumentation.org/packages/gdalUtils/versions/2.0.1.7/topics/ogrinfo" target="_blank">More on readOGR</a>

Next, let's plot the U.S. states data.


```r
# view column names
plot(state_boundary_us,
     main = "Map of Continental US State Boundaries\n US Census Bureau Data")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial06-reproject-vector-data-R/find-coordinates-1.png" title="Plot of the continental united states." alt="Plot of the continental united states." width="90%" />

## U.S. Boundary Layer

You can add a boundary layer of the United States to your map - to make it look
nicer. You will import
`data/week-04/usa-boundary-layers/US-Boundary-Dissolved-States`.
If you specify a thicker line width using `lwd = 4` for the border layer, it will
make your map pop!


```r
# Read the .csv file
country_boundary_us <- readOGR("data/week-04/usa-boundary-layers",
          "US-Boundary-Dissolved-States")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week-04/usa-boundary-layers", layer: "US-Boundary-Dissolved-States"
## with 1 features
## It has 9 fields
## Integer64 fields read as strings:  ALAND AWATER
## Warning in readOGR("data/week-04/usa-boundary-layers", "US-Boundary-
## Dissolved-States"): Z-dimension discarded

# look at the data structure
class(country_boundary_us)
## [1] "SpatialPolygonsDataFrame"
## attr(,"package")
## [1] "sp"

# view column names
plot(state_boundary_us,
     main = "Map of Continental US State Boundaries\n US Census Bureau Data",
     border = "gray40")

# view column names
plot(country_boundary_us,
     lwd = 4,
     border = "gray18",
     add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial06-reproject-vector-data-R/check-out-coordinates-1.png" title="Plot of the US overlayed with states and a boundary." alt="Plot of the US overlayed with states and a boundary." width="90%" />

Next, let's add the location of your study area sites.
As you are adding these layers, take note of the class of each object. You will use
`AOI` to represent "Area of Interest" in your data.


```r
# Import a polygon shapefile
sjer_aoi <- readOGR("data/week-04/california/SJER/vector_data",
                      "SJER_crop")
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week-04/california/SJER/vector_data", layer: "SJER_crop"
## with 1 features
## It has 1 fields
class(sjer_aoi)
## [1] "SpatialPolygonsDataFrame"
## attr(,"package")
## [1] "sp"

# plot point - looks ok?
plot(sjer_aoi,
     pch = 19,
     col = "purple",
     main = "San Joachin Experimental Range AOI")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial06-reproject-vector-data-R/explore-units-1.png" title="plot aoi" alt="plot aoi" width="90%" />

Your SJER `AOI` layer plots nicely. Let's next add it as a layer on top of the U.S.
states and boundary layers in your basemap plot.


```r
# plot state boundaries
plot(state_boundary_us,
     main = "Map of Continental US State Boundaries \n with SJER AOI",
     border = "gray40")

# add US border outline
plot(country_boundary_us,
     lwd = 4,
     border = "gray18",
     add = TRUE)

# add AOI boundary
plot(sjer_aoi,
     pch = 19,
     col = "purple",
     add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial06-reproject-vector-data-R/layer-point-on-states-1.png" title="plot states" alt="plot states" width="90%" />

What do you notice about the resultant plot? Do you see the AOI boundary in the
California area? Is something wrong?

Let's check out the `CRS` (`crs()`) of both datasets to see if you can identify any
issues that might cause the point location to not plot properly on top of your
U.S. boundary layers.


```r
# view CRS of your site data
crs(sjer_aoi)
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

# view crs of census data
crs(state_boundary_us)
## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
crs(country_boundary_us)
## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
```

It looks like your data are in different `CRS`. You can tell this by looking at
the `CRS` strings in `proj4` format.

## Understanding CRS in proj4 Format
The `CRS` for your data are given to us by `R` in `proj4` format. Let's break
down the pieces of `proj4` string. The string contains all of the individual
`CRS` elements that `R` or another GIS might need. Each element is specified
with a `+` sign, similar to how a `.csv` file is delimited or broken up by
a `,`. After each `+` you see the `CRS` element being defined. For example
projection (`proj=`) and datum (`datum=`).

### UTM proj4 String
Your project string for `sjer_aoi` specifies the UTM projection as follows:

`+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0`

* **proj=utm:** the projection is UTM, UTM has several zones
* **zone=18:** the zone is 18
* **datum=WGS84:** the datum WGS84 (the datum refers to the  0,0 reference for
the coordinate system used in the projection)
* **units=m:** the units for the coordinates are in METERS
* **ellps=WGS84:** the ellipsoid (how the Earth's  roundness is calculated) for
the data is WGS84

Note that the `zone` is unique to the UTM projection. Not all `CRS` will have a
zone.

### Geographic (lat / long) proj4 String

Your project string for `state_boundary_us` and `country_boundary_us` specifies
the lat/long projection as follows:

`+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0`

* **proj=longlat:** the data are in a geographic (latitude and longitude)
coordinate system
* **datum=WGS84:** the datum WGS84 (the datum refers to the  0,0 reference for
the coordinate system used in the projection)
* **ellps=WGS84:** the ellipsoid (how the earth's roundness is calculated)
is WGS84

Note that there are no specified units above. This is because this geographic
coordinate reference system is in latitude and longitude which is most
often recorded in *Decimal Degrees*.

<i class="fa fa-star"></i> **Data tip:** the last portion of each `proj4` string
is `+towgs84=0,0,0 `. This is a conversion factor that is used if a datum
conversion is required. You will not deal with datums in this tutorial series.
{: .notice--success}

## CRS units - View Object Extent

Next, let's view the extent or spatial coverage for the `sjer_aoi` spatial
object compared to the `state_boundary_us` object.


```r
# extent & crs for AOI
extent(sjer_aoi)
## class       : Extent 
## xmin        : 254570.6 
## xmax        : 258867.4 
## ymin        : 4107303 
## ymax        : 4112362
crs(sjer_aoi)
## CRS arguments:
##  +proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +ellps=WGS84
## +towgs84=0,0,0

# extent & crs for object in geographic
extent(state_boundary_us)
## class       : Extent 
## xmin        : -124.7258 
## xmax        : -66.94989 
## ymin        : 24.49813 
## ymax        : 49.38436
crs(state_boundary_us)
## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
```

Note the difference in the units for each object. The extent for
`state_boundary_us` is in latitude and longitude which yields smaller numbers
representing decimal degree units. Your `AOI` boundary point is in UTM,
represented in meters.

***

## Proj4 & CRS Resources

* <a href="http://proj.maptools.org/faq.html" target="_blank">More information on the proj4 format</a>
* <a href="http://spatialreference.org" target="_blank">A fairly comprehensive list of CRS by format</a>
* To view a list of datum conversion factors type: `projInfo(type = "datum")`
into the `R` console.

***

## Reproject Vector Data

Now you know your data are in different `CRS`. To address this, you have to modify
or **reproject** the data so they are all in the **same** `CRS`. You can use
`spTransform()` function to reproject your data. When you reproject the data, you
specify the `CRS` that you wish to transform your data to. This `CRS` contains
the datum, units and other information that `R` needs to **reproject** your data.

The `spTransform()` function requires two inputs:

1. the name of the object that you wish to transform
2. the `CRS` that you wish to transform that object too. In this case you can
use the `crs()` of the `state_boundary_us` object as follows:
`crs(state_boundary_us)`

<i class="fa fa-star"></i> **Data Tip:** `spTransform()` will only work if your
original spatial object has a CRS assigned to it AND if that CRS is the
correct CRS!
{: .notice--success}

Next, let's reproject your point layer into the geographic - latitude and
longitude `WGS84` coordinate reference system (`CRS`).


```r
# reproject data
sjer_aoi_WGS84 <- spTransform(sjer_aoi,
                                crs(state_boundary_us))

# what is the CRS of the new object
crs(sjer_aoi_WGS84)
## CRS arguments:
##  +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
# does the extent look like decimal degrees?
extent(sjer_aoi_WGS84)
## class       : Extent 
## xmin        : -119.7626 
## xmax        : -119.7127 
## ymin        : 37.0799 
## ymax        : 37.12657
```

Once your data are reprojected, you can try to plot again.


```r
# plot state boundaries
plot(state_boundary_us,
     main = "Map of Continental US State Boundaries\n With SJER AOI",
     border = "gray40")

# add US border outline
plot(country_boundary_us,
     lwd = 4,
     border = "gray18",
     add = TRUE)

# add AOI
plot(sjer_aoi_WGS84,
     pch = 19,
     col = "purple",
     add = TRUE)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial06-reproject-vector-data-R/plot-again-1.png" title="US Map with SJER AOI Location" alt="US Map with SJER AOI Location" width="90%" />

But now, the AOI is a polygon and it's too small to see on the map. Let's convert
the polygon to a polygon CENTROID and plot yet again.


```r
# get coordinate center of the polygon
aoi_centroid <- coordinates(sjer_aoi_WGS84)

# plot state boundaries
plot(state_boundary_us,
     main = "Map of Continental US State Boundaries\n With SJER AOI",
     border = "gray40")

# add US border outline
plot(country_boundary_us,
     lwd = 4,
     border = "gray18",
     add = TRUE)

# add point location of the centroid to the plot
points(aoi_centroid, pch = 8, col = "magenta", cex = 1.5)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial06-reproject-vector-data-R/plot-centroid-1.png" title="figure out AOI polygon centroid." alt="figure out AOI polygon centroid." width="90%" />

Reprojecting your data ensured that things lined up on your map! It will also
allow us to perform any required geoprocessing (spatial calculations /
transformations) on your data.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Test Your Skills: Crop, Peproject, Plot Data

Create a map of your SJER study area as follows:

1. Import the `madera-county-roads/tl_2013_06039_roads.shp` layer located in your week4 data download.
2. Create a map that shows the roads layer, study site locations and the `sjer_aoi` boundary.
3. Add a **title** to your plot.
4. Add a **legend** to your plot that shows both the roads and the plot locations.
5. Plot the roads by road type and add each type to the legend. HINT: use the metadata included in your data download to figure out what each type of road represents ("C", "S", etc.). [Use the homework lesson on custom legends]({{ site.url }}/courses/earth-analytics/spatial-data-r/r-create-custom-legend-with-base-plot/) to help build the legend.
6. BONUS: Plot the plots by type - adjust the symbology of the plot locations (choose a symbol using pch for each type and adjust the color of the points).
7. Do your best to make the map look nice!

IMPORTANT: be sure that all of the data are within the same EXTENT and crs of the sjer_aoi
layer. This means that you may have to CROP and reproject your data prior to plotting it!

Your map should look something like the map below. You should of course use the
actual roads types that you find in the metadata rather than "Road type 1, etc"

NOTE: this is also a plot you will submit as a part of your homework this week!

</div>

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial06-reproject-vector-data-R/challenge-code-MASS-Map-1.png" title="challenge plot" alt="challenge plot" width="90%" />



```
## null device 
##           1
```
