---
layout: single
title: "Classify a raster in R."
excerpt: "This lesson presents how to classify a raster dataset and export it as a
new raster in R."
authors: ['Leah Wasser']
modified: '2017-08-19'
category: [courses]
class-lesson: ['intro-lidar-raster-r']
permalink: /courses/earth-analytics/week-3/classify-raster/
nav-title: 'Classify a raster'
week: 3
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming:
  remote-sensing: ['lidar']
  earth-science: ['vegetation']
  spatial-data-and-gis: ['raster-data']
---


{% include toc title="In this lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning objectives

After completing this tutorial, you will be able to:

* Reclassify a raster dataset in `R` using a set of defined values
* Describe the difference between using breaks to plot a raster compared to 
reclassifying a raster object

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You need `R` and `RStudio` to complete this tutorial. Also you should have
an `earth-analytics` directory set up on your computer with a `/data`
directory with it.

* [How to setup R / RStudio](/courses/earth-analytics/document-your-science/setup-r-rstudio/)
* [Setup your working directory](/courses/earth-analytics/document-your-science/setup-working-directory/)
* [Intro to the R & RStudio interface](/courses/earth-analytics/document-your-science/intro-to-r-and-rstudio)

### R libraries to install:

* **raster:** `install.packages("raster")`
* **rgdal:** `install.packages("rgdal")`

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download week 3 data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

### Reclassification vs. breaks

In this lesson, we will learn how to reclassify a raster dataset in `R`. Previously,
we plotted a raster value using break points - that is to say, we colored particular
ranges of raster pixels using a defined set of values that we call `breaks`.
In this lesson, we will learn how to reclassify a raster. When you reclassify
a raster you create a **new** raster object / file that can be exported and shared 
with colleagues and / or opened in other tools such as QGIS.


<figure>
<img src="http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/geoprocessing_with_3d_analyst/Reclass_Reclass2.gif" alt="reclassification process by ESRI">
<figcaption>When you reclassify a raster you create a new raster. In that raster, each cell from the old raster is mapped to the new raster. The values in the new raster are applied using a defined range of values or a raster map. For example above you can see that all cells that
contain the values 1-3 are assigned the new value of 5. Image source: ESRI.
</figcaption>
</figure>

## Load libraries




```r
# load the raster and rgdal libraries
library(raster)
library(rgdal)
```

## Raster classification steps

We can break our raster processing workflow into several steps as follows:

* **Data import / cleanup:** Load and "clean" the data. This may include cropping, dealing with NA values, etc.
* **Data exploration:** Understand the range and distribution of values in your data. This may involve plotting histograms scatter plots, etc.
* **More data processing & analysis:** This may include the final data processing steps that you determined based upon the data exploration phase.
* **Final data analysis:** The final steps of your analysis - often performed using information gathered in the early data processing / exploration stages of your workflow.
* **Presentation:** Refining your results into a final plot or set of plots that are cleaned up, labeled, etc.

Please note - working with data is not a linear process. There are no defined
steps. As you work with data more, you will develop your own workflow and approach.

To get started, let's first open up our raster. In this case we are using the lidar
canopy height model (CHM) that we calculated in the previous lesson.


```r
# open canopy height model
lidar_chm <- raster("data/week_03/BLDR_LeeHill/outputs/lidar_chm.tif")
## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)
```

### What classification values to use?

We want to classify our raster into 3 classes:

* Short
* Medium
* Tall

However, what value represents a tall vs a short tree? We need to better
understand our data before assigning classification values to it. Let's begin
by looking at the min and max values in our CHM.


```r
summary(lidar_chm)
## Error in summary(lidar_chm): object 'lidar_chm' not found
```

































