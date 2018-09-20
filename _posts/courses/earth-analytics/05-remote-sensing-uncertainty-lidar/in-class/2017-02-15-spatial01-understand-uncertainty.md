---
layout: single
title: "Sources of Error in Lidar and Human Measured Estimates of Tree Height"
excerpt: "There are difference sources of error when you measure tree height using Lidar. Learn about accuracy, precision and the sources of error associated with lidar remote sensing data."
authors: ['Leah Wasser']
modified: '2018-01-10'
category: [courses]
class-lesson: ['remote-sensing-uncertainty-r']
permalink: /courses/earth-analytics/remote-sensing-uncertainty/about-uncertainty-lidar/
nav-title: 'Remote Sensing Uncertainty'
module-title: 'Uncertainty and Metadata'
module-description: 'In this module, you will learn the concept of uncertainty as it relates to both remote sensing and other data. You will also explore some metadata to learn how to understand more about your data. '
module-nav-title: 'Uncertainty in Scientific Data & Metadata '
module-type: 'class'
course: "earth-analytics"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  remote-sensing: ['lidar']
  earth-science: ['vegetation', 'uncertainty']
  reproducible-science-and-programming:
redirect_from:
   - "/course-materials/earth-analytics/week-5/understand-uncertainty-lidar/"
   - "/courses/earth-analytics/week-5/understand-uncertainty-lidar/"
---


{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List atleast 3 sources of uncertainty / error associated with remote
sensing data.
* Interpret a scatter plot that compares remote sensing values with field
measured values to determine how "well" the two metrics compare.
* Describe 1-3 ways to better understand sources of error associated
with a comparison between remote sensing values with field measured values.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }


</div>

## Understanding Uncertainty and Error.

It is important to consider error and uncertainty when presenting scientific
results. Most measurements that you make - be they from instruments or humans -
have uncertainty associated with them. You will learn what
that means below.

## Uncertainty

**Uncertainty:** Uncertainty quantifies the range of values within which the
value of the measure falls within - within a specified level of confidence. The
uncertainty quantitatively indicates the "quality" of your measurement. It
answers the question: "how well does the result represent the value of the
quantity being measured?"

### Tree Height Measurement Example

So for example let's pretend that you measured the height of a tree 10 times. Each
time your tree height measurement may be slightly different? Why? Because maybe
each time you visually determined the top of the tree to be in a slightly different
place. Or maybe there was wind that day during measurements that
caused the tree to shift as you measured it yielding a slightly different height
each time. or... what other reasons can you think of that might impact tree height
measurements?

<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/measuring-tree-height.jpg">
   <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/measuring-tree-height.jpg" alt="national geographic scaling trees graphic"></a>
   <figcaption>When you measure tree height by hand, many different variables may impact the accuracy and precision of your results. Source:  http://www.haddenham.net/newsroom/guess-tree-height.html
   </figcaption>
</figure>

## What is the True Value?

So you may be wondering, what is the true height of your tree?
In the case of a tree in a forest, it's very difficult to determine the
true height. So you accept that there will be some variation in your measurements
and you measure the tree over and over again until you understand the range of
heights that you are likely to get when you measure the tree.





```r
library(raster)
library(rgdal)
# create data frame containing made up tree heights
tree_heights <- data.frame(heights = c(10, 10.1, 9.9, 9.5, 9.7, 9.8,
                                     9.6, 10.5, 10.7, 10.3, 10.6))
# what is the average tree height
mean(tree_heights$heights)
## [1] 10.06364
# what is the standard deviation of measurements?
sd(tree_heights$heights)
## [1] 0.4129715
boxplot(tree_heights$heights,
        main = "Distribution of tree height measurements (m)",
        ylab = "Height (m)",
        col = "springgreen")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial01-understand-uncertainty/standard-error-1.png" title="Distribution of tree heights." alt="Distribution of tree heights." width="90%" />

In the example above, your mean tree height value is towards the center of
your distribution of measured heights. You might expect that the sample mean of
your observations provides a reasonable estimate of the true value. The
variation among your measured values may also provide some information about the
precision (or lack thereof) of the measurement process.

<a href="http://www.physics.csbsju.edu/stats/box2.html" target="_blank">Read more about  the basics of a box plot</a>


```r
# view distribution of tree height values
hist(tree_heights$heights, breaks = c(9,9.6,10.4,11),
     main = "Distribution of measured tree height values",
     xlab = "Height (m)", col = "purple")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial01-understand-uncertainty/hist-tree-height-1.png" title="Tree height distribution" alt="Tree height distribution" width="90%" />

## Measurement Accuracy

Measurement **accuracy** is a concept that relates to whether there is bias in
measurements, i.e. whether the expected value of your observations is close to
the true value. For low accuracy measurements, you may collect many observations,
and the mean of those observations may not provide a good measure of the truth
(e.g., the height of the tree). For high accuracy measurements, the mean of
many observations would provide a good measure of the true value. This is
different from **precision**, which typically refers to the variation among
observations. Accuracy and precision are not always tightly coupled. It is
possible to have measurements that are very precise but inaccurate, very
imprecise but accurate, etc.

## Systematic vs Random Error

**Systematic Error:** a systematic error is one that tends to shift all measurements
in a systematic way. This means that the mean value of a set of measurements is
consistently displaced or varied in a predictable way, leading to inaccurate observations.
Causes of systematic errors may be known or unknown but should always be corrected
for when present. For instance, no instrument can ever be calibrated perfectly,
so when a group of measurements systematically differ from the value of a standard
reference specimen, an adjustment in the values should be made. Systematic error
can be corrected for only when the "true value" (such as the value assigned to a
calibration or reference specimen) is known.

*Example:* Remote sensing instruments need to be calibrated. For example a laser in
a lidar system may be tested in a lab to ensure that the distribution of output light
energy is consistent every time the laser "fires".

**Random Error:** is a component of the total error which, in the course of a number
of measurements, varies in an unpredictable way. It is not possible to correct for
random error.  Random errors can occur for a variety of reasons such as:

* Lack of equipment sensitivity. An instrument may not be able to respond to or
indicate a change in some quantity that is too small or the observer may not be
able to discern the change.
* Noise in the measurement. Noise is extraneous disturbances that are unpredictable
or random and cannot be completely accounted for.
* Imprecise definition. It is difficult to exactly define the dimensions of a object.
For example, it is difficult to determine the ends of a crack with measuring its
length.  Two people may likely pick two different starting and ending points.

*Example:* Random error may be introduced when you measure tree heights as discussed above.

- <a href="https://www.nde-ed.org/GeneralResources/ErrorAnalysis/UncertaintyTerms.htm">Source: nde-ed.org</a>


<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/remote-sensing/accuracy_precision.png">
   <img src="{{ site.url }}/images/courses/earth-analytics/remote-sensing/accuracy_precision.png" alt="national geographic scaling trees graphic"></a>
   <figcaption>Accuracy vs precision. Accuracy quantifies how close a measured value is to the true value. Precision quantifies how close two or more measurements agree with each other (how quantitatively repeatable are the results) Source: http://www.ece.rochester.edu/courses/ECE111/error_uncertainty.pdf
   </figcaption>
</figure>

## Using Lidar to Estimate Tree Height

You use lidar data to estimate tree height because it is an efficient way to measure
large areas of trees (forests) quantitatively. However, you can process the lidar
data in many different ways to estimate height. Which method most closely represents
the actual heights of the trees on the ground?

<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/scaling-trees-nat-geo.jpg">
   <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/scaling-trees-nat-geo.jpg" alt="national geographic scaling trees graphic"></a>
   <figcaption>It can be difficult to measure the true height of trees! Often times "seeing" the very top of the tree where it is tallest is not possible from the ground - especially in dense, tall forests. One can imagine the amount of uncertainty that is thus introduced when you try to estimate the true height of trees! Image Source:
   National Geographic
   </figcaption>
</figure>

<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example LiDAR waveform. Source: NEON, Boulder, CO.
   </figcaption>
</figure>


<figure>
   <a href="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/treeline-scanned-lidar-points.png">
   <img src="{{ site.url }}/images/courses/earth-analytics/lidar-raster-data-r/treeline-scanned-lidar-points.png" alt="example of a tree profile after a lidar scan."></a>
   <figcaption>Cross section showing LiDAR point cloud data (above) and the
   corresponding landscape profile (below). Graphic: Leah A. Wasser
   </figcaption>
</figure>





## Study Site Location

To answer the question above, let's look at some data from a study site location
in California - the San Joaquin Experimental range field site. You can see the field
site location on the map below.



<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial01-understand-uncertainty/ggmap-plot-1.png" title="ggmap of study area." alt="ggmap of study area." width="90%" />

## Study Area Plots

At this study site, you have both lidar data - specifically a canopy height model
that was processed by NEON (National Ecological Observatory Network). You also
have some "ground truth" data. That is you have measured tree height values collected
at a set of field site plots by technicians at NEON. You call these measured
values *in situ* measurements.

A map of your study plots is below overlaid on top of the canopy height mode.

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial01-understand-uncertainty/plot-plots-1.png" title="plots" alt="plots" width="90%" />

### Compare Lidar Derived Height to In Situ Measurements

You can compare maximum tree height values at each plot to the maximum pixel value
in your `CHM` for each plot. To do this, you define the geographic boundary of your plot
using a polygon - in the case below you use a circle as the boundary. You then extract
the raster cell values for each circle and calculate the max value for all of the
pixels that fall within the plot area.

Then, you calculate the max height of your measured plot tree height data.

Finally you compare the two using a scatter plot to see how closely the data relate.
Do they follow a 1:1 line? Do the data diverge from a 1:1 relationship?

<figure>
    <img src="{{ site.url }}/images/courses/earth-analytics/spatial-data/buffer-circular.png" alt="buffer circular">
    <figcaption>The extract function in R allows you to specify a circular buffer
    radius around an x,y point location. Values for all pixels in the specified
    raster that fall within the circular buffer are extracted. In this case, you
    will tell R to extract the maximum value of all pixels using the fun=max
    command. Source: Colin Williams, NEON
    </figcaption>
</figure>

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial01-understand-uncertainty/plot-data-1.png" title="final plot" alt="final plot" width="90%" />

### How Different are the Data?

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/05-remote-sensing-uncertainty-lidar/in-class/2017-02-15-spatial01-understand-uncertainty/view-diff-1.png" title="box plot showing differences between chm and measured heights." alt="box plot showing differences between chm and measured heights." width="90%" />

## View Interactive Scatterplot

<a href="https://plot.ly/~leahawasser/170/" target="_blank">View scatterplot plotly</a>


## View Interactive Difference Barplot

<a href="https://plot.ly/~leahawasser/158/chm-minus-insitu-differences/
" target="_blank">View scatterplot differences</a>



<div class="notice--info" markdown="1">
## Additional Resources

The materials on this page were compiled using many internet resources including:

* <a href="http://www.ece.rochester.edu/courses/ECE111/error_uncertainty.pdf" target="_blank">Pdf presentation on uncertainty in remote sensing</a>
* <a href="https://www.nde-ed.org/GeneralResources/ErrorAnalysis/UncertaintyTerms.htm" target="_blank">An overview of key uncertainty terms</a>


##  QGIS Imagery Layer

* Code to add imagery to qgis via the python console:
 `qgis.utils.iface.addRasterLayer("http://server.arcgisonline.com/arcgis/rest/services/ESRI_Imagery_World_2D/MapServer?f=json&pretty=true", "raster")`

`<qgis._core.QgsRasterLayer object at 0x12739ee90>`
</div>
