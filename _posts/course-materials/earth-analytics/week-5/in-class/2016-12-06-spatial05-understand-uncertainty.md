---
layout: single
title: "Understand uncertainty"
excerpt: ". "
authors: ['Leah Wasser']
modified: '2017-02-15'
category: [course-materials]
class-lesson: ['class-intro-spatial-r']
permalink: /course-materials/earth-analytics/week-5/understand-uncertainty-lidar/
nav-title: 'Remote sensing uncertainty'
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 5
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Be able to list atleast 3 sources of uncertainty / error associated with remote sensing data.
* Be able to interpret a scatter plot that compares remote sensing values with field measured values to determine how "well" the two metrics compare.
* Be able to describe 1-3 ways to better understand sources of error associated with a comparison between remote sensing values with field measured values.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 5 of the course.

</div>

## Understanding uncertainty and error.

In science, it is important to think about error and uncertainty. 

## Uncertainty 

**Uncertainty:** the range of values within which the value of the measurand can be said to lie within a specified level of confidence. The uncertainty  quantitatively indicates the "quality" of your measurement.It answers the question: "how well does the result represent the value of the quantity being measured?" 

### Tree height measurement example

So for example let's pretend that we measured the height of a tree 10 times. Each
time our tree height measurement may be slightly different? Why? Because maybe
each time we visually determined the top fo the tree to be in a slightly different place. Or maybe there was wind that day during measurements that 
caused the tree to shift as we measured it yielding a slightly different height each time. or... what other reasons can you think of that might impact tree height 
measurements? 

## What is the true value?

So you may be wondering, what is the true height of our tree? The true value?
In the cause of a tree in a forest, it's very difficult to determine the 
true height. So we accept that there will be some variation in our measurements
and we measure the tree over and over again until we understand the range of 
heights that we are likely to get when we measure the tree


```r

tree_heights <- data.frame(heights=c(10, 10.1, 9.9, 9.5, 9.7, 9.8, 
                                     9.6, 10.5, 10.7, 10.3, 10.6))
# what is the average tree height
mean(tree_heights$heights)
## [1] 10.06364
# what is the standard deviation of measurements?
sd(tree_heights$heights)
## [1] 0.4129715
boxplot(tree_heights$heights,
        main="Distribution of tree height measurements (m)",
        ylab="Height (m)")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-5/in-class/2016-12-06-spatial05-understand-uncertainty/standard-error-1.png" title="Distribution of tree heights." alt="Distribution of tree heights." width="100%" />

In the case above of our tree heights, our mean value is towards the center of 
our distribution of measured heights. Thus we might assume that our mean represents
the average measured value well. And that our range of expected values or uncertainty can be seen in the box plot.


```r

hist(tree_heights$heights, breaks=c(9,9.5,10.5,11),
     main="Distribution of tree height values",
     xlab="height (m)", col="purple")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-5/in-class/2016-12-06-spatial05-understand-uncertainty/hist-tree-height-1.png" title="Tree height distribution" alt="Tree height distribution" width="100%" />

* http://www.ece.rochester.edu/courses/ECE111/error_uncertainty.pdf
* https://www.nde-ed.org/GeneralResources/ErrorAnalysis/UncertaintyTerms.htm

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/scaling-trees-nat-geo.jpg">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/scaling-trees-nat-geo.jpg" alt="national geographic scaling trees graphic"></a>
   <figcaption>Conventional on the ground methods to measure trees are resource
   intensive and limit the amount of vegetation that can be characterized. Source:
   National Geographic
   </figcaption>
</figure>

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example LiDAR waveform. Source: NEON, Boulder, CO.
   </figcaption>
</figure>


<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/Treeline_ScannedPoints.png">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/Treeline_ScannedPoints.png" alt="example of a tree profile after a lidar scan."></a>
   <figcaption>Cross section showing LiDAR point cloud data (above) and the
   corresponding landscape profile (below). Graphic: Leah A. Wasser
   </figcaption>
</figure>





## Study site location



<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-5/in-class/2016-12-06-spatial05-understand-uncertainty/ggmap-plot-1.png" title="ggmap of study area." alt="ggmap of study area." width="100%" />

## Study area plots

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-5/in-class/2016-12-06-spatial05-understand-uncertainty/plot-plots-1.png" title="plots" alt="plots" width="100%" />

##  QGIS imagery layer

qgis.utils.iface.addRasterLayer("http://server.arcgisonline.com/arcgis/rest/services/ESRI_Imagery_World_2D/MapServer?f=json&pretty=true","raster")
<qgis._core.QgsRasterLayer object at 0x12739ee90>


<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-5/in-class/2016-12-06-spatial05-understand-uncertainty/plot-data-1.png" title="final plot" alt="final plot" width="100%" />

## View interactive scatterplot

<a href="https://plot.ly/~leahawasser/168/lidar-derived-mean-tree-height-vs-insitu-measured-mean-tree-he/" target="_blank">View scatterplot plotly</a>


## View interactive difference barplot

<a href="https://plot.ly/~leahawasser/158/chm-minus-insitu-differences/
" target="_blank">View scatterplot differences</a>


