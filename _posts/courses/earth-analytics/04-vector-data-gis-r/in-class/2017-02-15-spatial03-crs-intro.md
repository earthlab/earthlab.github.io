---
layout: single
title: "Coordinate Reference System and Spatial Projection"
excerpt: "Coordinate reference systems are used to convert locations on the earth which is round, to a two dimensional (flat) map. Learn about the differences between coordinate reference systems."
authors: ['Leah Wasser']
modified: '2018-07-30'
category: [courses]
class-lesson: ['class-intro-spatial-r']
permalink: /courses/earth-analytics/spatial-data-r/intro-to-coordinate-reference-systems/
nav-title: 'Coordinate Reference Systems'
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 3
course: "earth-analytics"
topics:
  spatial-data-and-gis: ['vector-data', 'coordinate-reference-systems']
  reproducible-science-and-programming:
redirect_from:
   - "/course-materials/earth-analytics/week-4/intro-to-coordinate-reference-systems/"
---

{% include toc title="In This Lesson" icon="file-text" %}



This lesson covers the key spatial attributes that are needed to work with
spatial data including: Coordinate Reference Systems (`CRS`), extent and spatial resolution.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe what a Coordinate Reference System (`CRS`) is
* List the steps associated with plotting 2 datasets stored using different coordinate reference systems

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

## Intro to Coordinate Reference Systems

In summary - a coordinate reference system (`CRS`) refers to the way in which
spatial data that represent the earth's surface (which is round / 3 dimensional)
are flattened so that you can "Draw" them on a 2-dimensional surface. However each
using a different (sometimes) mathematical approach to performing the flattening
resulting in different coordinate system grids (discussed below). These approaches
to flattening the data are specifically designed to optimize the accuracy of the
data in terms of length and area (more on that later too).

In this lesson you will explore what a `CRS` is. And how it can impact your data
when you are working with it in a tool like `R` (or any other tool).

***

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/compare-mercator-utm-wgs-projections.jpg" alt="Maps of the United States in different CRS including Mercator
    (upper left), Albers equal area (lower left), UTM (Upper RIGHT) and
    WGS84 Geographic (Lower RIGHT).">
    </a>

    <figcaption>Maps of the United States in different CRS including Mercator
    (upper left), Albers equal area (lower left), UTM (Upper RIGHT) and
    WGS84 Geographic (Lower RIGHT).
    Notice the differences in shape and orientation associated with each
    CRS. These differences are a direct result of the
    calculations used to "flatten" the data onto a two dimensional map.
    Source: opennews.org</figcaption>
</figure>


<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/human-head-projections.jpg">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/human-head-projections.jpg" alt="The human head projected using different coordinate reference systems. SOURCE: Scientific American.">
    </a>

    <figcaption>The human head projected using different coordinate reference systems. SOURCE: Scientific American. Do any of these happen to bare a striking resemblance to Jay Leno? </figcaption>
</figure>

The short video below highlights how map projections can make continents
look proportionally larger or smaller than they actually are.

<iframe width="560" height="315" src="https://www.youtube.com/embed/KUF_Ckv8HbE" frameborder="0" allowfullscreen></iframe>

## What is a Coordinate Reference System

To define the location of something you often use a coordinate system. This system
consists of an X and a Y value located within a 2 (or more) -dimensional space.

<figure>
	<a href="{{ site.url}}/images/courses/earth-analytics/spatial-data/coordinate-system.png">
	<img src="{{ site.url}}/images/courses/earth-analytics/spatial-data/coordinate-system.png" alt="You use coordinate systems with X, Y (and sometimes Z axes) to	define the location of objects in space."></a>
	<figcaption> You use coordinate systems with X, Y (and sometimes Z axes) to
	define the location of objects in space.
	Source: http://open.senecac.on.ca
	</figcaption>
</figure>

While the above coordinate system is 2-dimensional, we live on a 3-dimensional
earth that happens to be "round". To define the location of objects on the Earth,
which is round, you need a coordinate system that adapts to the Earth's shape.
When you make maps on paper or on a flat computer screen, you move from a 3-Dimensional
space (the globe) to a 2-Dimensional space (your computer screens or a piece of paper).
The components of the `CRS` define how the "flattening" of data that exists in a 3-D
globe space. The `CRS` also defines the the coordinate system itself.

<figure>
	<a href="{{ site.url}}/images/courses/earth-analytics/spatial-data/geographic-origin.png">
	<img src="{{ site.url}}/images/courses/earth-analytics/spatial-data/geographic-origin.png" alt="A CRS defines the translation between a location on the round earth	and that same location, on a flattened, 2 dimensional coordinate system."></a>
	<figcaption>A CRS defines the translation between a location on the round earth
	and that same location, on a flattened, 2 dimensional coordinate system.
	Source: http://ayresriverblog.com
	</figcaption>
</figure>

> A coordinate reference system (CRS) is a
coordinate-based local, regional or global system used to locate geographical
entities. -- Wikipedia

## The Components of a CRS

The coordinate reference system is made up of several key components:

* **Coordinate system:** The X, Y grid upon which your data is overlayed and how
you define where a point is located in space.
* **Horizontal and vertical units:** The units used to define the grid along the
x, y (and z) axis.
* **Datum:** A modeled version of the shape of the Earth which defines the origin
used to place the coordinate system in space. You will learn this further below.
* **Projection Information:** The mathematical equation used to flatten objects
that are on a round surface (e.g. the Earth) so you can view them on a flat surface
(e.g. your computer screens or a paper map).

## Why CRS is Important

It is important to understand the coordinate system that your data uses -
particularly if you are working with different data stored in different coordinate
systems. If you have data from the same location that are stored in different
coordinate reference systems, **they will not line up in any GIS or other program**
unless you have a program like `ArcGIS` or `QGIS` that supports **projection on the
fly**. Even if you work in a tool that supports projection on the fly, you will
want to all of your data in the same projection for performing analysis and processing
tasks.

<i class="fa fa-star"></i> **Data Tip:** <a href="http://spatialreference.org/ref/epsg/" target="_blank"> spatialreference.org </a>provides an excellent online library of CRS information.
{: .notice--success}

### Coordinate System & Units

You can define a spatial location, such as a plot location, using an x- and a
y-value - similar to your cartesian coordinate system displayed in the figure,
above.

For example, the map below, generated in `R` with `ggplot2` shows all of the
continents in the world, in a `Geographic` Coordinate Reference System. The
units are degrees and the coordinate system itself is **latitude** and
**longitude** with the `origin` being the location where the equator meets
the central meridian on the globe (0,0).



```r

# devtools::install_github("tidyverse/ggplot2")
# load libraries
library(rgdal)
library(ggplot2)
library(rgeos)
library(raster)

#install.packages('sf')
# testing the sf package out for these lessons!
library(sf)
# set your working directory
# setwd("~/Documents/earth-analytics/")
```

In the plot below, you will be using the following theme. You can copy and paste
this code if you'd like to use the same theme!


```r
# turn off axis elements in ggplot for better visual comparison
newTheme <- list(theme(line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(), # turn off ticks
      axis.title.x = element_blank(), # turn off titles
      axis.title.y = element_blank(),
      legend.position = "none")) # turn off legend
```





```r
# read shapefile
worldBound <- readOGR(dsn = "data/week-04/global/ne_110m_land/ne_110m_land.shp")
# convert to dataframe
worldBound_df <- fortify(worldBound)
```


```r
# plot map using ggplot
worldMap <- ggplot(worldBound_df, aes(long,lat, group = group)) +
  geom_polygon() +
  coord_equal() +
  labs(x = "Longitude (Degrees)",
       y = "Latitude (Degrees)",
      title = "Global Map - Geographic Coordinate System ",
      subtitle = "WGS84 Datum, Units: Degrees - Latitude / Longitude")

worldMap
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial03-crs-intro/load-plot-data-1.png" title="world map plot" alt="world map plot" width="90%" />

You can add three coordinate locations to your map. Note that the UNITS are
in **decimal degrees** (latitude, longitude):

* **Boulder, Colorado:** 40.0274, -105.2519
* **Oslo, Norway:** 59.9500, 10.7500
* **Mallorca, Spain:** 39.6167, 2.9833

Let's create a second map with the locations overlayed on top of the continental
boundary layer.


```r
# define locations of Boulder, CO, Mallorca, Spain and  Oslo, Norway
# store coordinates in a data.frame
loc_df <- data.frame(lon = c(-105.2519, 10.7500, 2.9833),
                lat = c(40.0274, 59.9500, 39.6167))

# add a point to the map
mapLocations <- worldMap +
                geom_point(data = loc_df,
                aes(x = lon, y = lat, group = NULL), colour = "springgreen",
                      size = 5)

mapLocations
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial03-crs-intro/add-lat-long-locations-1.png" title="Map plotted using geographic projection with location points added." alt="Map plotted using geographic projection with location points added." width="90%" />

## Geographic CRS - The Good & The Less Good

Geographic coordinate systems in decimal degrees are helpful when you need to
locate places on the Earth. However, latitude and longitude locations are not
located using uniform measurement units. Thus, geographic `CRS`'s are not ideal for
measuring distance. This is why other projected `CRS` have been developed.


<figure>
	<a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/latitude-longitude-globe-ESRI.gif">
	<img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/latitude-longitude-globe-ESRI.gif" alt="Graphic showing lat long as it's placed over the globe by ESRI."></a>
	<figcaption>A geographic coordinate system locates latitude and longitude
	location using angles. Thus the spacing of each line of latitude moving north
	and south is not uniform.
	Source: ESRI
	</figcaption>
</figure>

## Projected CRS - Robinson

You can view the same data above, in another `CRS` - `Robinson`. `Robinson` is a
**projected** `CRS`. Notice that the country boundaries on the map - have a
different shape compared to the map that you created above in the `CRS`:
**Geographic lat/long WGS84**.


```r
# reproject data from longlat to robinson CRS
worldBound_robin <- spTransform(worldBound,
                                CRS("+proj=robin"))

worldBound_df_robin <- fortify(worldBound_robin)

# force R to plot x and y values without rounding digits
# options(scipen=100)

robMap <- ggplot(worldBound_df_robin, aes(long,lat, group = group)) +
  geom_polygon() +
  labs(title = "World map (robinson)",
       x = "X Coordinates (meters)",
       y = "Y Coordinates (meters)") +
  coord_equal()

robMap
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial03-crs-intro/global-map-robinson-1.png" title="Map reprojected to robinson projection." alt="Map reprojected to robinson projection." width="90%" />

Now what happens if you try to add the same Lat / Long coordinate locations that
you used above, to your map, that is using the `Robinson` `CRS` as it's coordinate
reference system?


```r
# add a point to the map
newMap <- robMap + geom_point(data = loc_df,
                      aes(x = lon, y = lat, group = NULL),
                      colour = "springgreen",
                      size = 5)

newMap
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial03-crs-intro/add-locations-robinson-1.png" title="map with point locations added - robinson projection." alt="map with point locations added - robinson projection." width="90%" />

Notice above that when you try to add lat/long coordinates in degrees to a map
in a different `CRS` the points are not in the correct location. You need
to first convert the points to the new projection - a process called
**reprojection**. You can reproject your data using the `spTransform()` function
in `R`.

Your points are stored in a data.frame which is not a spatial object. Thus, you will
need to convert that `data.frame` to a spatial `data.frame` to use `spTransform()`.


```r
# data.frame containing locations of Boulder, CO and Oslo, Norway
loc_df
##         lon     lat
## 1 -105.2519 40.0274
## 2   10.7500 59.9500
## 3    2.9833 39.6167

# convert dataframe to spatial points data frame
loc_spdf <- SpatialPointsDataFrame(coords = loc_df, data = loc_df,
                            proj4string = crs(worldBound))

loc_spdf
## class       : SpatialPointsDataFrame 
## features    : 3 
## extent      : -105.2519, 10.75, 39.6167, 59.95  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
## variables   : 2
## names       :       lon,     lat 
## min values  : -105.2519, 39.6167 
## max values  :     10.75,   59.95
```

Once you have converted your data frame into a spatial data frame, you can then
reproject your data.


```r
# reproject data to Robinson
loc_spdf_rob <- spTransform(loc_spdf, CRSobj = CRS("+proj=robin"))
```

To make your data plot nicely with `ggplot`, you need to once again convert to a
dataframe. You can do that by extracting the `coordinates()` and turning that into
a `data.frame` using `as.data.frame()`.


```r
# convert the spatial object into a data frame
loc_rob_df <- as.data.frame(coordinates(loc_spdf_rob))

# turn off scientific notation
options(scipen = 10000)
# add a point to the map
newMap <- robMap + geom_point(data = loc_rob_df,
                      aes(x = lon, y = lat, group = NULL),
                      colour = "springgreen",
                      size = 5)

newMap
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial03-crs-intro/plot-new-map-1.png" title="Map of the globe in robinson projection." alt="Map of the globe in robinson projection." width="90%" />

## Compare Maps

Both of the plots above look visually different and also use a different
coordinate system. Let's look at both, side by side, with the actual **graticules**
or latitude and longitude lines rendered on the map.

To visually see the difference in these projections as they impact parts of the
world, you will use a graticules layer which contains the meridian and parallel
lines.


```r
## import graticule shapefile data
graticule <- readOGR("data/week-04/global/ne_110m_graticules_all",
                     layer = "ne_110m_graticules_15")
# convert spatial sp object into a ggplot ready, data.frame
graticule_df <- fortify(graticule)
```

Let's check out your graticules. Notice they are just parallels and meridians.


```r
# plot graticules
ggplot() +
  geom_path(data = graticule_df, aes(long, lat, group = group), linetype = "dashed", color = "grey70")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial03-crs-intro/plot-grat-1.png" title="graticules plot" alt="graticules plot" width="90%" />

Also you will import a bounding box to make your plot look nicer!


```r
bbox <- readOGR("data/week-04/global/ne_110m_graticules_all/ne_110m_wgs84_bounding_box.shp")
bbox_df <- fortify(bbox)

latLongMap <- ggplot(bbox_df, aes(long,lat, group = group)) +
              geom_polygon(fill = "white") +
              geom_polygon(data = worldBound_df, aes(long,lat, group = group, fill = hole)) +
              geom_path(data = graticule_df, aes(long, lat, group = group), linetype = "dashed", color = "grey70") +
  coord_equal() +  labs(title = "World Map - Geographic (long/lat degrees)")  +
  newTheme +

  scale_fill_manual(values = c("black", "white"), guide = "none") # change colors & remove legend

# add your location points to the map
latLongMap <- latLongMap +
              geom_point(data = loc_df,
                      aes(x = lon, y = lat, group = NULL),
                      colour = "springgreen",
                      size = 5)
```

Below, you reproject your graticules and the bounding box to the Robinson projection.


```r
# reproject grat into robinson
graticule_robin <- spTransform(graticule, CRS("+proj=robin"))  # reproject graticule
grat_df_robin <- fortify(graticule_robin)
bbox_robin <- spTransform(bbox, CRS("+proj=robin"))  # reproject bounding box
bbox_robin_df <- fortify(bbox_robin)

# plot using robinson

finalRobMap <- ggplot(bbox_robin_df, aes(long, lat, group = group)) +
  geom_polygon(fill = "white") +
  geom_polygon(data = worldBound_df_robin, aes(long, lat, group = group, fill = hole)) +
  geom_path(data = grat_df_robin, aes(long, lat, group = group), linetype = "dashed", color = "grey70") +
  labs(title = "World Map Projected - Robinson (Meters)") +
  coord_equal() + newTheme +
  scale_fill_manual(values = c("black", "white"), guide = "none") # change colors & remove legend

# add a location layer in robinson as points to the map
finalRobMap <- finalRobMap + geom_point(data = loc_rob_df,
                      aes(x = lon, y = lat, group = NULL),
                      colour = "springgreen",
                      size = 5)
```

Below you plot the two maps on top of each other to make them easier to compare.
To do this, you use the `grid.arrange()` function from the `gridExtra` package.


```r
require(gridExtra)
# display side by side
grid.arrange(latLongMap, finalRobMap)
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/04-vector-data-gis-r/in-class/2017-02-15-spatial03-crs-intro/render-maps-1.png" title="plots in different projections, side by side." alt="plots in different projections, side by side." width="90%" />


## Why Multiple CRS?

You may be wondering, why bother with different `CRS`s if it makes your
analysis more complicated? Well, each `CRS` is optimized to best represent the:

* shape and/or
* scale / distance and/or
* area

of features in the data. And no one `CRS` is great at optimizing all three elements: shape, distance AND
area. Some `CRS`s are optimized for shape, some are optimized for distance and
some are optimized for area. Some `CRS`s are also optimized for particular regions -
for instance the United States, or Europe. Discussing `CRS` as it optimizes shape,
distance and area is beyond the scope of this tutorial, but it's important to
understand that the `CRS` that you chose for your data will impact working with
the data.

You will learn some of the differences between the projected `UTM` `CRS` and geographic
`WGS84` in the next lesson.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge

1. Compare the maps of the globe above. What do you notice about the shape of the
various countries. Are there any signs of distortion in certain areas on either
map? Which one is better?

2. Look at the image below which depicts maps of the United States in 4 different
`CRS`'s. What visual differences do you notice in each map? Look up each projection
online, what elements (shape,area or distance) does each projection used in
the graphic below optimize?

</div>





## Geographic vs. Projected CRS

The above maps provide examples of the two main types of coordinate systems:

1. **Geographic coordinate systems:** coordinate systems that span the entire
globe (e.g. latitude / longitude).
2. **Projected coordinate systems:** coordinate systems that are localized to
minimize visual distortion in a particular region (e.g. Robinson, UTM, State Plane)

You will learn these two coordinate reference systems types in more detail
in the next lesson.

<div class="notice--info" markdown="1">

## Additional Resources

* Read more on coordinate systems in the
<a href="http://docs.qgis.org/2.0/en/docs/gentle_gis_introduction/coordinate_reference_systems.html" target="_blank" data-proofer-ignore=''>
QGIS documentation</a>
* For more on types of projections, visit
<a href="http://help.arcgis.com/en/arcgisdesktop/10.0/help/index.html#/Datums/003r00000008000000/" target="_blank"> ESRI's ArcGIS reference on projection types</a>.
* Read more about <a href="https://source.opennews.org/en-US/learning/choosing-right-map-projection/" target="_blank"> choosing a projection/datum</a>
</div>
