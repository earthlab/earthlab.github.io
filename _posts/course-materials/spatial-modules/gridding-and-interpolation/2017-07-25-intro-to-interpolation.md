---
layout: single
authors: [Leah A. Wasser, Tristan Goulden]
category: [course-materials]
title: 'Getting started with converting points to rasters - The difference between IDW, Spline, Kriging and other probabilistic vs deterministic interpolators '
excerpt: 'Interpolation overview.'
dateCreated: 2017-07-25
modified: 2017-07-25
module-title: 'Intro to gridding & interpolation in R - Raster and gstat'
module-description: 'An interpolation overview.'
permalink: /course-materials/intro-to-spatial-interpolation-concepts/
nav-title: 'Intro to gridding'
sidebar:
  nav:
module: ['intro-interpolation']
topics:
  spatial-data-and-gis: ['raster-data', 'gridding-and-spatial-interpolation']
author_profile: false
comments: false
order: 1
---

## Overview

<div class='notice--success' markdown="1">

# Learning Outcomes

* Define the characteristics of deterministic vs probabilistic interpolation approaches.
* Describe the difference between gridding data vs interpolation vs Teaching
* Describe how the Inverse Distance Weighted (IDW) interpolation calculates values and define power and search radius as it applies to IDW
****

**Estimated Time:** >1 hour

[Download Lesson Data](https://ndownloader.figshare.com/files/6463767
){: .btn .btn--large}
</div>

## Creating Surfaces From Points

<figure>
    <a href="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/gridding_approaches.png">
	<img src="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/gridding_approaches.png"></a>

    <figcaption>When converting a set of sample points to a grid, there are many
	different approaches that should be considered.</figcaption>
</figure>


<figure>
    <a href="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/gridMethod_FeaturesTbl.png">
	<img src="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/gridMethod_FeaturesTbl.png"></a>

    <figcaption>A gridding cheatsheet.</figcaption>
</figure>

## Triangulated Irregular Network (TIN)

The Triangulated Irregular Network (TIN) is a vector based surface where sample
points (nodes) are connected by a series of edges creating a triangulated surface.
The TIN format remains the most true to the point distribution, density and spacing of a
dataset. It also may yield the largest file size!

<figure>
    <a href="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/tin.png"><img src="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/tin.png"></a>

    <figcaption>A TIN creating from LiDAR data collected by the NEON AOP over
	the NEON San Joachiun (SJER) field site.</figcaption>
</figure>

**More on the TIN Format**

* <a href="http://resources.arcgis.com/en/help/main/10.1/index.html#//006000000001000000" target="_blank">ESRI overview of TINs</a>



## About Rasters

<figure>
    <a href="{{ site.url }}/images/hyperspectral/pixelDetail.png">
    <img src="{{ site.url }}/images/hyperspectral/pixelDetail.png"></a>
    <figcaption>The spatial resolution of a raster refers the size of each cell
    in meters. This size in turn relates to the area on the ground that the pixel
    represents.</figcaption>
</figure>

A raster is a dataset made up of cells or pixels. Each pixel represents a value
associated with a region on the earth’s surface. We can create a raster from points
through a process sometimes called gridding. Gridding is the process of taking a
set of points and using them to create a surface composed of a regular grid.


![Animation Showing the general process of taking lidar point clouds and converting them to a Raster Format. Credits: Tristan Goulden, National Ecological Observatory Network](http://neondataskills.org/images/gridding.gif)
                       |

## Gridding Points

<figure>
    <a href="{{ site.url }}/images/course-materials/spatial/spatial-modules/interpolation-101/gridded.png">
    <img src="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/gridded.png"></a>
    <figcaption>When you directly grid a dataset, values will only be calculated
	for cells that overlap with data points. Thus, data gaps will not be filled.
	</figcaption>
</figure>

When creating a raster, you may chose to perform a direct **gridding** of the data.
This means that you calculate one value for every cell in the raster where there
are sample points. This value may be a mean of all points, a max, min or some other
mathematical function. All other cells will then have `no data` values associated with
them. This means you may have gaps in your data if the point spacing is not well
distributed with atleast one data point within the spatial coverage of each raster
cell.

## Spatial Interpolation

Spatial **interpolation** involves calculating the value for a  query point (or
a raster cell) with an unknown value from a set of known sample point values that
are distributed across an area. There is a general assumption that points closer
to the query point, are more strongly related to that cell than those further away.
 However this general assumption is applied differently across different
interpolation functions.

<figure>
    <a href="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/grid.png">
    <img src="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/grid.png"></a>
    <figcaption>Interpolation methods will estimate values for cells where no known values exist.
	</figcaption>
</figure>

## Deterministic vs. Probabilistic Interpolators

There are two main types of interpolation approaches:

* **Deterministic**: create surfaces from measured points using a weighted distance
 or area function.
* **Probabilistic (Geostatistical)**: utilize the statistical properties of the
 measured points. Probabilistic techniques quantify the spatial auto-correlation
 among measured points and account for the spatial configuration of the sample
 points around the prediction location.

We will focus on deterministic methods in this workshop.

## Deterministic Interpolation Methods

Let's look at a few different deterministic interpolation methods to understand
how different methods can affect an output raster.

### Inverse Distance Weighted (IDW)

Inverse distance weighted interpolation (IDW) calculates the values of a query point
(a cell with an unknown value)  using a linearly weighted combination of values
from nearby points.

<figure>
    <a href="https://docs.qgis.org/2.2/en/_images/idw_interpolation.png">
	<img src="https://docs.qgis.org/2.2/en/_images/idw_interpolation.png"></a>

    <figcaption>
	IDW interpolation calculates the value of an unknown cell center value (a
	query point) using 	surrounding points with the assumption that closest points
	will be the most similar to the value of interest.
</figcaption>

</figure>


**Key Attributes of IDW Interpolation:**

* Raster is derived based upon an assumed linear relationship between the
location of interest and the distance to surrounding sample points.
* Sample points closest to the cell of interest are assumed to be more related
to its value than those further away.
* Exact - Can not interpolate beyond the min/max range of data point values.
* Can only estimate within the range of EXISTING sample point values - this can
yield "flattened" peaks and valleys" especially if the data didn't capture those
high and low points.
* Point average values
* Good for data that are equally distributed and  dense. Assumes a consistent
trend / relationship between points and does not accommodate trends within the data
(e.g. east to west, etc).


<figure>
    <a href="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted_files/image001.gif">
	<img src="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted_files/image001.gif">
	</a>

    <figcaption>
	IDW interpolation looks at the linear distance between the unknown value
	and surrounding points.
</figcaption>

</figure>


#### Power

There power setting in IDW interpolation specifies how strongly points further
away from the cell value of interest impact the calculated value for that call.
Power values range from 0-3+ with a default settings generally being 2. A larger
power value produces a more localized result - values further away from the cell
have less impact on it's calculated value, values closer to the cell impact it's
value more. A smaller power value produces a more averaged result where sample points
further away from the cell have a greater impact on the cell's calculated value.

<figure>
    <a href="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted_files/image003.gif
"><img src="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted_files/image003.gif
"></a>

    <figcaption>
	The solid line represents more power and the dashed line represents less power.
	The higher the power, the more localized an affect a sample point's value has on
	the resulting surface. A smaller power value yields are smoothed or more averaged
	surface. IMAGE SOURCE: http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Inverse%20Distance%20Weighted.htm

</figcaption>
</figure>

The impacts of power

**Lower Power Values** more averaged result, potential for a smoother surface.
As Power decreases, the influence of sample points is larger. This yields a smoother
surface that is more averaged.

**Higher Power Values**: more localized result, potential for more peaks and
around sample point locations.
As Power increases, the influence of sample points falls off more rapidly with
distance. The output cell values become more localized and less averaged.


### IDW Summary Take Home Points

**GOOD FOR: **

* Data whose distribution is strongly (and linearly) correlated with
distance. For example, noise falls off very predictably with distance.
* Provides explicit control over the influence of distance; (compared to Spline
or Kriging).

**NOT AS GOOD FOR:**

* Not as good for data whose distribution depends on more complex sets of variables
 because it can account only for the effects of distance.

**OTHER FEATURES:**

* You can create a smoother surface by decreasing the power, increasing the
number of sample points used, or increasing the search radius.
* Create a surface that more closely represents the peaks and dips of your sample
points by decreasing the number of sample points used / decreasing the search
radius, increasing the power.
* Increase IDW surface accuracy by adding breaklines to the interpolation process
that serve as barriers. Breaklines represent abrupt changes in elevation, such
as cliffs.

### Spline

Spline interpolation fits a curved surface through the sample points of your
dataset. Imagine stretching a rubber sheet across your points and glueing it to
each sample point along the way. Unlike IDW, spline can estimate values above and
below the min and max values of your sample points. Thus it is good for estimating
high and low values not already represented in your data.

<figure>
    <a href="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Spline_files/image001.gif">
	<img src="http://www.geography.hunter.cuny.edu/~jochen/GTECH361/lectures/lecture10/3Dconcepts/Spline_files/image001.gif">
	</a>

    <figcaption>
	Spline interpolation fits a surface between the sample points of known values
	to estimate a value for the unknown cell.
</figcaption>

</figure>

### Regularized vs Tension Spline

There are two types of curved surfaces that can be fit when using spline interpolation:

<figure>
    <a href="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/reg_ten_Spline.png">
	<img src="{{ site.url }}/images/course-materials/spatial-modules/interpolation-101/reg_ten_Spline.png">
	</a>

    <figcaption>
	Regular vs tension spline.
	</figcaption>
</figure>

1. **Tension spline:** a flatter surface that forces estimated values to stay closer
to the known sample points.

2. **Regularized spline:** a more elastic surface that is more likely to estimate above
and below the known sample points.


SPLINE IS GOOD FOR:

* Estimating values outside of the range of sample input data.
* Creating a smooth continuous surface.

NOT AS GOOD FOR:

* Points that are close together and have large value differences. Slope calculations
can yield over and underestimation.
* Data with large, sudden changes in values that need to be represented (eg fault
lines, extreme vertical topographic changes, etc). IDW allows for breaklines. NOTE:
some tools like ARCGIS have introduces a spline with barriers function in recent
years.


#### More on Spline

* <a href="http://help.arcgis.com/EN/arcgisdesktop/10.0/help/index.html#//009z00000078000000.htm" target="_blank">ESRI background on spline
interpolation.</a>


### Natural Neighbor Interpolation

Natural neighbor interpolation  finds the closest subset of data points, to the
query point of interest. It then applies weights to those points, to calculate an
average estimated value based upon their proportionate areas derived from their
corresponding voronoi polygons. The natural neighbor interpolator adapts locally
to the input data, using points surrounding the query point of interest. Thus there
are no radius, number of points or other settings needed when using this approach.

This interpolation method works equally well on regular vs irregularly spaced data.

<figure>
    <a href="https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Euclidean_Voronoi_diagram.svg/2000px-Euclidean_Voronoi_diagram.svg.png">
	<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Euclidean_Voronoi_diagram.svg/2000px-Euclidean_Voronoi_diagram.svg.png">
	</a>

    <figcaption>
	A Voronoi diagram is created by taking pairs of points that are close together
	and drawing a line that is equidistant between them and perpendicular to the
	line connecting them. Natural Neighbor interpolation uses the area of each
	polygon associated with the surrounding points to derive a weight that is then
	used to calculate an estimated value for the query point of interest.
	Source: Wikipedia
	</figcaption>
</figure>


<figure>
    <a href="http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/spatial_analyst_tools/sa_interp_natneigh_hiw_voroni.png">
	<img src="http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/spatial_analyst_tools/sa_interp_natneigh_hiw_voroni.png">
	</a>

    <figcaption>
	To calculate the weighted area around a query point, a secondary Voronoi diagram is created using the immediately neighboring points and mapped on top of the original Voronoi diagram created using the known sample points.
	Image Source: ESRI
	</figcaption>
</figure>

FROM THE ESRI HELP:
> By comparison, a distance-based interpolator tool such as IDW (inverse distance weighted) would assign similar weights to the northernmost point and to the northeastern point based on their similar distance from the interpolation point. Natural neighbor interpolation, however, assigns weights of 19.12 percent and 0.38 percent, respectively, which is based on the percentage of overlap.
>

Notes about Natural Neighbor

* Local Interpolator
* Interpolated values fall within the range of values of the sample data
* Surface passes through input samples
* Supports breaklines


**Natural Neighbor is good for:**

* Data who's spatial distribution is variable (AND data that are equally distributed).
* Categorical data
* Providing a smoother output raster.

**Natural Neighbor is not as good for:**

* Data where the interpolation needs to be spatially constrained (to a particular
number of points of distance).
* Data where sample points further away from or beyond the immediate "neighbor points"
need to be considered in the estimation.


# Additional Resources

Please find some additional resources associated with gridding in `R`, `GRASS GIS` and
`QGIS`.

### QGIS tools

* Interpolation plugin
* Rasterize (Vector to Raster)

The QGIS processing toolbox provides easy access to Grass commands.

### Grass commands

* `v.surf.idw` - Surface interpolation from vector point data by Inverse Distance Squared Weighting
* `v.surf.bspline` - Bicubic or bilinear spline interpolation with Tykhonov regularization
* `v.surf.rst` - Spatial approximation and topographic analysis using regularized spline with tension
* `v.to.rast.value `- Converts (rasterize) a vector layer into a raster layer
* `v.delaunay` - Creates a Delaunay triangulation from an input vector map containing points or centroids
* `v.voronoi` - Creates a Voronoi diagram from an input vector layer containing points

The above commands are just a few that support grinding in GRASS. You can also access GRASS
via command line.

### R commands

The commands below can be used to create grids in R.

* `gstat::idw()`
* `stats::loess()`
* `akima::interp()`
* `fields::Tps()`
* `fields::splint()`
* `spatial::surf.ls()`
* `geospt::rbf()`
