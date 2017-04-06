---
layout: single
title: "Understand LiDAR Point Cloud Data"
excerpt: "This lesson covers what a lidar point cloud is. We will use the free
plas.io point cloud viewer to explore a point cloud."
authors: ['Leah Wasser']
modified: '2017-02-01'
category: [course-materials]
class-lesson: ['class-lidar-r']
permalink: /course-materials/earth-analytics/week-3/lidar-point-clouds/
nav-title: 'LiDAR Point Clouds'
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 2
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List 4 common attributes for each point in a lidar point cloud.
* Briefly describe how a lidar system collects lidar points.
* Be able to describe the difference how a discrete and full waveform lidar system collect data.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

If you have not already downloaded the week 3 data, please do so now.
[<i class="fa fa-download" aria-hidden="true"></i> Download Week 3 Data (~250 MB)](https://ndownloader.figshare.com/files/7446715){:data-proofer-ignore='' .btn }

</div>

In the last lesson, we learned the basics of how a lidar system works. In this
lesson, we will learn about lidar point clouds. The point cloud is one of the commonly
found lidar data products and it the "native" format for discrete return lidar data.
But first, let's discuss the concept of a data product.

## What is a data product?

A data product, is the data that are DERIVED from an instrument, or information
collected on the ground. For instance, you may go out in the field and measure
the heights of trees at 20 plots. Then calculate an average height per plot.
The average value is DERIVED from the individual measurements that you collected
in the field.

When dealing with sensor data, the sensors often collect data in a format that
needs to be processed in order to get usable values from it.


<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/lidar-cross-section.png">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/lidar-cross-section.png" alt="A cross section of 3-dimensional lidar data. Brown points represent ground,
   green represent vegetation (trees)."></a>
   <figcaption>A cross section of 3-dimensional lidar data. This point cloud data
   product is classified into the classes: vegetation and ground points. Brown points represent ground,
   green represent vegetation (trees).
   </figcaption>
</figure>


### How a lidar system records points

Remember that lidar is an active remote sensing system that records reflected
or returned light energy. A discrete return lidar system, records the strongest
reflections of light as discrete or individual points. Each point has an associated
X, Y and Z value associated with it.  It also has an intensity which represents
the amount of energy that returned to the sensor.

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/waveform.png" target="_blank">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/waveform.png" alt="Example of a lidar waveform"></a>
   <figcaption>An example LiDAR waveform. Source: NEON.
   </figcaption>
</figure>


## Discrete vs. Full Waveform LiDAR
Also remember the difference betweeen discrete return and full waveform lidar.
A waveform or distribution of light energy is what returns to the LiDAR sensor.
However, this return may be recorded in two different ways.

1. A **Discrete Return LiDAR System** records individual (discrete) points for
the peaks in the waveform curve. Discrete return LiDAR systems, identify peaks
and record a point at each peak location in the waveform curve. These discrete
or individual points are called returns. A discrete system may record 1-4 (and
sometimes more) returns from each laser pulse.
2. A **Full Waveform LiDAR System** records a distribution of returned light
energy. Full waveform LiDAR data are thus more complex to process however they
can often capture more information compared to discrete return LiDAR systems.

### LiDAR Data Attributes: X,Y, Z, Intensity and Classification
A collection of discrete return LiDAR points is known as a LiDAR point cloud.
LiDAR data attributes can vary, depending upon how the data were collected and
processed. You can determine what attributes are available for each lidar point
by looking at the metadata. All lidar data points will have an associated X,Y
location and Z (elevation values). Most lidar data points will also have an **intensity**
value, representing the amount of light energy recorded by the sensor.


### Classified Lidar Points

Some LiDAR data will also be "classified". Classification refers
to tagging each point with the object that it reflected off of. So if a pulse reflects
off of a tree branch, we would assign it to the class "vegetation". If the pulse
reflects off of the ground, we would assign it to the class "ground".
Classification of LiDAR point clouds is an additional
processing step. Classification simply represents the type of object that the
laser return reflected off of. So if the light energy reflected off of a tree,
it might be classified as "vegetation". And if it reflected off of the ground,
it might be classified as "ground".

Some LiDAR products will be classified as "ground/non-ground". Some datasets
will be further processed to determine which points reflected off of buildings
and other infrastructure. Some LiDAR data will be classified according to the
vegetation type.

<figure>
   <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/Treeline_ScannedPoints.png">
   <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/Treeline_ScannedPoints.png" alt="example of a tree profile after a lidar scan."></a>
   <figcaption>Cross section showing LiDAR point cloud data (above) and the
   corresponding landscape profile (below). Graphic: Leah A. Wasser
   </figcaption>
</figure>


## Las - A Common LiDAR File Format
The commonly used file format to store LIDAR point cloud data is called **.las**
which is a format supported by the Americal Society of Photogrammetry and Remote
Sensing (ASPRS). Recently, the [.laz](http://www.laszip.org/) format has been
developed by Martin Isenberg of LasTools. The differences is that .laz is a
highly compressed version of .las.

".las" is the commonly used file format to store LIDAR point cloud data. This format is supported by the <a href="http://www.asprs.org/" target="_blank"> American Society of Photogrammetry and Remote sensing (ASPRS)</a>. Recently, the <a href="http://www.laszip.org/" target="_blank">.laz</a> format has been  developed by Martin Isenberg of LasTools. Laz is a highly compressed version of .las.


## Explore Lidar Points in Plas.io


<figure>
 <img src="https://farm4.staticflickr.com/3932/15408420007_3176835b51.jpg" alt="LiDAR data collected over Grand Mesa, Colorado as a part of instrument testing and calibration by the National Ecological Observatory Network Airborne Observation Platform (NEON AOP).">
 <figcaption>LiDAR data collected over Grand Mesa, Colorado. Source: NEON Airborne
 Observation Platform (AOP)
 </figcaption>
 </figure>


In this activity, you will open a .las file, in the <a href="http://plas.io" target="_blank"> plas.io free online lidar data viewer.</a> You will then explore some of the attributes associated with a lidar data point cloud.

### LiDAR Attribute Data
Remember that not all lidar data are created equally. Different lidar data may have different attributes. In this activity, we will look at data that contain both intensity values and a ground vs non ground classification.

## About Plas.io
> Plasio is a project by Uday Verma and Howard Butler that implements point cloud rendering capability in a browser. Specifically, it provides a functional implementation of the ASPRS LAS format, and it can consume LASzip-compressed data using LASzip NaCl module. Plasio is Chrome-only at this time, but it is hoped that other contributors can step forward to bring it to other browsers.
>
> It is expected that most WebGL-capable browers should be able to support plasio, and it contains nothing that is explicitly Chrome-specific beyond the optional NaCL LASzip module.
> src: https://github.com/verma/plasio

## 1. Open a .las file in plas.io ###

1. If you haven't already, download the week 3 dataset - linked at the top of this page. It contains several .laz format point cloud datasets that we will use in this lesson.
2. When the download is complete, drag one of the .laz files into the <a href="http://plas.io" target="_blank"> plas.io website.</a> window.
3. Zoom and pan around the data
4. Use the particle size slider to adjust the size of each individual lidar point. NOTE: the particle size slider is located a little more than half way down the plas.io toolbar in the "Data" section.

If the data imported into the plas.io viewer correctly, you should see something similar to the screenshot below:

<figure>
<img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/plasio-data-import.png" alt="Lidar data in the plas.io online tool.">
<figcaption>You can drag a .las or .laz dataset into the plas.io viewer to view the data in your browser! </figcaption>
</figure>

### Navigate Around Your Data in Plas.io
You might prefer to use a mouse to explore your data in plas.io. Let's test the navigation out.

1. Left click on the screen and drag the data on the screen. Notice that this tilts the data up and down.
2. Right click on the screen and drag noticing that this moves the entire dataset around
3. Use the scroll bar on your mouse to zoom in and out.

### How The Points are Colored - Why is everything grey when the data are loaded?
Notice that the data, upon initial view, are colored in a black - white color scheme. These colors represent the data's intensity values. Remember that the intensity value, for each LiDAR point, represents the amount of light energy that reflected off of an object and returned to the sensor. In this case, darker colors represent LESS light energy returned. Lighter colors represent MORE light returned.

<figure>
<a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/lidar-intensity.png" alt="Lidar intensity values represent the amount of light energy that reflected off of an object and returned to the sensor.">
<img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/lidar-intensity.png" alt="Lidar data in the plas.io online tool.">
</a>
<figcaption>Lidar intensity values represent the amount of light energy that reflected off of an object and returned to the sensor.</figcaption>
</figure>


## 2. Adjust the intensity threshold

Next, scroll down through the tools in plas.io. Look for the Intensity Scaling slider. The intensity scaling slider allows you to define the thresholds of light to dark intensity values displayed in the image (similar to stretching values in an image processing software or even in photoshop).

Drag the slider back and forth. Notice that you can brighten up the data using the slider.

<figure>
  <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/intensity-slider.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/intensity-slider.png" alt="The intensity scaling slider is located below the color map tool so it's easy to miss. Drag the slider back and forth to adjust the range of intensity values and to brighten up the lidar point clouds.">
  </a>
  <figcaption>The intensity scaling slider is located below the color map tool so it's easy to miss. Drag the slider back and forth to adjust the range of intensity values and to brighten up the lidar point clouds.
  </figcaption>
</figure>

## 3. Change the lidar point cloud color options to Classification

In addition to intensity values, these lidar data also have a classification value. Lidar data classification values are numeric, ranging from 0-20 or higher. Some common classes include:

- 0 Not classified
- 1 Unassigned
- 2 Ground
- 3 Low vegetation
- 4 Medium vegetation
- 5 High Vegetation
- 6 Building

<figure>
  <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/plasio-colors-kendra.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/plasio-colors-kendra.png" alt="Blue and Orange gradient color scheme submitted by Kendra Sand. Which color scheme is your favorite?">
  </a>
  <figcaption>Blue and Orange gradient color scheme submitted by Kendra Sand. Which color scheme is your favorite?
  </figcaption>
</figure>

In this case, these data are classified as either ground, or non-ground. To view the points, colored by class:

- Change the "colorization" setting to "Classification
- Change the intensity blending slider to "All Color"
- For kicks - play with the various colormap options to change the colors of the points.

<figure>
  <a href="{{ site.url }}/images/course-materials/earth-analytics/week-3/classification-colorization2.png">
    <img src="{{ site.url }}/images/course-materials/earth-analytics/week-3/classification-colorization2.png" alt="Set the colorization to 'classified' and then adjust the intensity blending to view the points, colored by ground and non-ground classification.">
  </a>
  <figcaption>Set the colorization to 'classified' and then adjust the intensity blending to view the points, colored by ground and non-ground classification.
  </figcaption>
</figure>

## 4. Spend Some Time Exploring - Do you See Any Trees?
Finally, spend some time exploring the data. what features do you see in this dataset? What does the topography look like? Is the site flat? Hilly? Mountainous? What do the lidar data tell you, just upon initial inspection?

## Summary
*	The plas.io online point cloud viewer allows you to quickly view and explore lidar data point clouds.
*	Each lidar data point will have an associated set of attributes. You can check the metadata to determine which attributes the dataset contains. NEON data, provided above, contain both classification and intensity values.
*	Classification values represent the type of object that the light energy reflected off of. Classification values are often ground vs non ground. Some lidar data files might have buildings, water bodies and other natural and man made elements classified.
*	LiDAR data often has an intensity value associated with it. This represents the amount of light energy that reflected off an object and returned to the sensor.

***

<div class="notice--info" markdown="1">

## Additional Resources

*	<a href="https://www.asprs.org/committee-general/laser-las-file-format-exchange-activities.html" target="_blank"> About the .las file format.</a>
*	<a href="http://laspy.readthedocs.org/en/latest/tut_background.html" target="_blank"> Las: python ingest</a>
*	<a href="http://www.asprs.org/a/society/committees/standards/asprs_las_spec_v13.pdf" target="_blank"> las v1.3 specifications</a>

</div>
