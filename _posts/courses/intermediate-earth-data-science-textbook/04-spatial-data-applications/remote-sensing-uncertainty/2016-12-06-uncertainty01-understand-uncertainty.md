---
layout: single
title: "Compare Lidar With Human Measured Tree Heights - Remote Sensing Uncertainty"
excerpt: "Uncertainty quantifies the range of values within which the value of the measurement falls - within a specified level of confidence. Learn about the types of uncertainty that you can expect when working with tree height data both derived from lidar remote sensing and human measurements and learn about sources of error including systematic vs. random error."
authors: ['Leah Wasser', 'Chris Holdgraf']
dateCreated: 2016-12-06
modified: 2020-03-06
category: [courses]
class-lesson: ['remote-sensing-uncertainty-python-tb']
permalink: /courses/use-data-open-source-python/spatial-data-applications/lidar-remote-sensing-uncertainty/
nav-title: 'Remote Sensing Uncertainty'
module-title: 'Lidar Compared to Human Measurements: Uncertainty and Remote Sensing Data'
module-description: 'Uncertainty quantifies the range of values within which the value of the measurement falls - within a specified level of confidence. Learn about the concept of uncertainty as it relates to both remote sensing and other spatial data.'
module-nav-title: 'Uncertainty in Remote Sensing Data'
module-type: 'class'
course: 'intermediate-earth-data-science-textbook'
chapter: 6
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
class-order: 1
topics:
  reproducible-science-and-programming: ['python']
  remote-sensing: ['lidar']
  spatial-data-and-gis: ['raster-data']
redirect_from:
  - "/courses/earth-analytics-python/lidar-remote-sensing-uncertainty/understand-uncertainty-lidar/"
---

{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Six - Uncertainty in Remote Sensing Data

In this chapter, you will integrate vector and raster data using **Python** to explore uncertainty in scientific analyses.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* List and describe at least 3 sources of uncertainty / error associated with remote sensing data.
* Interpret a scatter plot that compares remote sensing values with field measured values to determine how "well" the two metrics compare.
* Use the `rasterstats.zonal_stats()` function to extract raster pixel values using a vector extent or set of extents.
* Create a scatter plot with a one to one line in **Python** using **matplotlib**.
* Merge two dataframes in **Python**.
* Perform a basic least squares linear regression analysis on two variables of interest in **Python**.
* Analyze regression outputs to determine the strength of the relatonship between two variables.
* Define `R-squared` and `p-value` as it relates to regression.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson. You will also need the data you downloaded for last week of this class: `spatial-vector-lidar data` subset. 

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}

</div>


## Understand Uncertainty and Error

It is important to consider error and uncertainty when presenting scientific
results. Most measurements that we make - be they from instruments or humans -
have uncertainty associated with them. We will discuss what
that means, below.

## Uncertainty

**Uncertainty:** Uncertainty quantifies the range of values within which the
value of the measure falls within - within a specified level of confidence. The
uncertainty quantitatively indicates the "quality" of your measurement. It
answers the question: "how well does the result represent the value of the
quantity being measured?"

### Tree Height Measurement Example

So for example let's pretend that we measured the height of a tree 10 times. Each
time our tree height measurement may be slightly different? Why? Because maybe
each time we visually determined the top of the tree to be in a slightly different
place. Or maybe there was wind that day during measurements that
caused the tree to shift as we measured it yielding a slightly different height
each time. or... what other reasons can you think of that might impact tree height
measurements?

<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/measuring-tree-height.jpg">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/measuring-tree-height.jpg" alt="When we measure tree height by hand, many different variables may impact the accuracy and precision of our results."></a>
   <figcaption>When we measure tree height by hand, many different variables may impact the accuracy and precision of our results. Source:  http://www.haddenham.net/newsroom/guess-tree-height.html
   </figcaption>
</figure>

## What is the True Value?

So you may be wondering, what is the true height of our tree?
In the case of a tree in a forest, it's very difficult to determine the
true height. So we accept that there will be some variation in our measurements
and we measure the tree over and over again until we understand the range of
heights that we are likely to get when we measure the tree.




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty01-understand-uncertainty/2016-12-06-uncertainty01-understand-uncertainty_3_0.png" alt = "Boxplot showing an example distribution of a set of measurements. If 10 people measured the same tree to get height, they all might have slightly different answers.">
<figcaption>Boxplot showing an example distribution of a set of measurements. If 10 people measured the same tree to get height, they all might have slightly different answers.</figcaption>

</figure>




In the example above, the mean tree height value is towards the center of
the distribution of measured heights. You might expect that the sample mean of
our observations provides a reasonable estimate of the true value. The
variation among our measured values may also provide some information about the
precision (or lack thereof) of the measurement process.

<a href="http://www.physics.csbsju.edu/stats/box2.html" target="_blank">Read more about the what a box plots tells you about data.</a>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty01-understand-uncertainty/2016-12-06-uncertainty01-understand-uncertainty_5_0.png" alt = "Example histogram of tree height values.">
<figcaption>Example histogram of tree height values.</figcaption>

</figure>




## Measurement Accuracy

Measurement **accuracy** is a concept that relates to whether there is bias in
measurements, i.e. whether the expected value of our observations is close to
the true value. For low accuracy measurements, we may collect many observations,
and the mean of those observations may not provide a good measure of the truth
(e.g., the height of the tree). For high accuracy measurements, the mean of
many observations would provide a good measure of the true value. This is
different from **precision**, which typically refers to the variation among
observations. Accuracy and precision are not always tightly coupled. It is
possible to have measurements that are very precise but inaccurate, very
imprecise but accurate, etc.


<figure>
   <a href="{{ site.url }}/images/earth-analytics/remote-sensing/accuracy-precision.png">
   <img src="{{ site.url }}/images/earth-analytics/remote-sensing/accuracy-precision.png" alt="Accuracy vs precision. Accuracy quantifies how close a measured value is to the true value. Precision quantifies how close two or more measurements agree with each other (how quantitatively repeatable are the results)."></a>
   <figcaption>Accuracy vs precision. Accuracy quantifies how close a measured value is to the true value. Precision quantifies how close two or more measurements agree with each other (how quantitatively repeatable are the results). Source: http://www.ece.rochester.edu/courses/ECE111/error_uncertainty.pdf
   </figcaption>
</figure>

## Systematic vs random error

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

*Example:* Random error may be introduced when we measure tree heights as discussed above.

* <a href="https://www.nde-ed.org/GeneralResources/ErrorAnalysis/UncertaintyTerms.htm">Source: nde-ed.org</a>


## Use Lidar to Estimate Tree Height

Lidar data can be used estimate tree height because it is an efficient way to measure
large areas of trees (forests) quantitatively. However, you can process the lidar
data in many different ways to estimate height. Which method most closely represents
the actual heights of the trees on the ground?

<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/scaling-trees-nat-geo.jpg">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/scaling-trees-nat-geo.jpg" alt="National Geographic image of a team scaling trees."></a>
   <figcaption>It can be difficult to measure the true height of trees! Often times "seeing" the very top of the tree where it is tallest is not possible from the ground - especially in dense, tall forests. One can imagine the amount of uncertainty that is thus introduced when we try to estimate the true height of trees! Image Source:
   National Geographic
   </figcaption>
</figure>

<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example LiDAR waveform. Source: NEON, Boulder, CO.
   </figcaption>
</figure>


<figure>
   <a href="{{ site.url }}/images/earth-analytics/lidar-raster-data/treeline-scanned-lidar-points.png">
   <img src="{{ site.url }}/images/earth-analytics/lidar-raster-data/treeline-scanned-lidar-points.png" alt="Example of a tree profile after a Lidar scan. Cross section showing LiDAR point cloud data (above) and the
   corresponding landscape profile (below)"></a>
   <figcaption>Cross section showing LiDAR point cloud data (above) and the
   corresponding landscape profile (below). Graphic: Leah A. Wasser
   </figcaption>
</figure>











## Study Site Location

To answer the question above, let's look at some data from a study site location
in California - the San Joaquin Experimental range field site. You can see the field
site location on the map below.



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty01-understand-uncertainty/2016-12-06-uncertainty01-understand-uncertainty_19_0.png" alt = "Contextily map of California showing the location of the study site.">
<figcaption>Contextily map of California showing the location of the study site.</figcaption>

</figure>




## Study Area Plots

At this study site, we have both lidar data - specifically a canopy height model
that was processed by NEON (National Ecological Observatory Network). We also
have some "ground truth" data. That is we have measured tree height values collected
at a set of field site plots by technicians at NEON. We will call these measured
values *in situ* measurements.

A map of our study plots is below overlaid on top of the canopy height model.


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty01-understand-uncertainty/2016-12-06-uncertainty01-understand-uncertainty_21_0.png" alt = "SJER field site locations overlayed on top of a lidar canopy height model.">
<figcaption>SJER field site locations overlayed on top of a lidar canopy height model.</figcaption>

</figure>




### Compare Lidar Derived Height to In Situ Measurements

We can compare maximum tree height values at each plot to the maximum pixel value
in our `CHM` for each plot. To do this, we define the geographic boundary of our plot
using a polygon - in the case below we use a circle as the boundary. We then extract
the raster cell values for each circle and calculate the max value for all of the
pixels that fall within the plot area.

Then, we calculate the max height of our measured plot tree height data.

Finally we compare the two using a scatter plot to see how closely the data relate.
Do they follow a 1:1 line? Do the data diverge from a 1:1 relationship?

<figure>
    <a href="{{ site.url }}/images/earth-analytics/spatial-data/buffer-circular.png">
    <img src="{{ site.url }}/images/earth-analytics/spatial-data/buffer-circular.png" alt="Circular fuffer."></a>
    <figcaption>In Python, you can use the buffer function to specify a circular buffer radius around an x,y point location. Then, you can use the zonal_stats function to extract the values for all pixels in the specified raster that fall within that circular buffer. In this case, you can tell Python to extract the maximum value of all pixels in the circular buffer. Source: Colin Williams, NEON
    </figcaption>
</figure>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty01-understand-uncertainty/2016-12-06-uncertainty01-understand-uncertainty_23_0.png" alt = "Scatterplot showing the relationship between lidar and measured tree height.">
<figcaption>Scatterplot showing the relationship between lidar and measured tree height.</figcaption>

</figure>






### How different are the data?





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/04-spatial-data-applications/remote-sensing-uncertainty/2016-12-06-uncertainty01-understand-uncertainty/2016-12-06-uncertainty01-understand-uncertainty_25_0.png" alt = "Bar plot showing the difference between lidar and measured tree height by plot. ">
<figcaption>Bar plot showing the difference between lidar and measured tree height by plot. </figcaption>

</figure>




## View interactive scatterplot

<a href="https://plot.ly/~leahawasser/170/" target="_blank">View scatterplot plotly</a>



## View interactive difference barplot

<a href="https://plot.ly/~leahawasser/158/chm-minus-insitu-differences/" target="_blank">View scatterplot differences</a>




