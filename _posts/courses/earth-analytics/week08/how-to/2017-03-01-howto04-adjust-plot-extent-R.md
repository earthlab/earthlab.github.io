---
layout: single
title: "Adjust plot extent in R."
excerpt: "In this lesson we will review how to adjust the extent of a spatial plot in R using the ext() or extent argument and the extent of another layer. "
authors: ['Leah Wasser']
modified: '2017-10-11'
category: [courses]
class-lesson: ['how-to-hints-week8']
permalink: /courses/earth-analytics/spectral-remote-sensing-modis/adjust-plot-extent-R/
nav-title: 'Adjust plot extent'
week: 8
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
  spatial-data-and-gis: ['raster-data']
lang-lib:
  r: []
redirect_from:
  - "/courses/earth-analytics/week-7/adjust-plot-extent-R/"
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Adjust the spatial extent of a plot using the `ext=` argument in R.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data for week 6 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6 Data (~500 MB)](https://ndownloader.figshare.com/files/7677208){:data-proofer-ignore='' .btn }
</div>



## Review: What is an extent?

<figure>
    <a href="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png">
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/spatial-extent.png" alt="Spatial extent ">
    </a>
    <figcaption>Spatial extent.
    </figcaption>
</figure>






<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/how-to/2017-03-01-howto04-adjust-plot-extent-R/plot-landsat-1.png" title="landsat plot" alt="landsat plot" width="90%" />

## Adjust plot extent

We can adjust the extent of a plot using `ext` argument.
We can give the argument the spatial extent of the fire boundary
layer that we want to plot.

If our object is called fire_boundary_utm, then we'd code: `ext=extent(fire_boundary_utm)`



```
## OGR data source with driver: ESRI Shapefile 
## Source: "data/week_07/vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp", layer: "co_cold_springs_20160711_2200_dd83"
## with 1 features
## It has 21 fields
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/week08/how-to/2017-03-01-howto04-adjust-plot-extent-R/plot-with-boundary-1.png" title="Plot with the fire boundary" alt="Plot with the fire boundary" width="90%" />
