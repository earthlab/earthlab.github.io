---
layout: single
category: course-materials
title: "Week 5"
permalink: /course-materials/earth-analytics/week-5/
week-landing: 5
week: 5
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! This week, we will dive deeper
into working with spatial data in R. We will learn how to handle data in different
coordinate reference systems, how to create custom maps and legends and how to
extract data from a raster file. We are on our way towards integrating many different
types of data into our analysis which involves knowing how to deal with things
like coordinate reference systems and varying data structures.


</div>

|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 3:00 pm  |   | Leah  |
| 4:15 - 5:50  | R coding session - Use lidar to characterize vegetation / uncertainty | Leah  |

### 1. Readings


### 2. Complete the assignment below

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a .pdf report

Create a new `R markdown `document. Name it: **lastName-firstInitial-week5.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `PDF` format. Submit both the
`.Rmd` file and the `.pdf` file. Be sure to name your files as instructed above!

In your report, include the plots below. Be sure to describe what each plot shows and
to answer the questions below.

1. In your own words, describe what a Coordinate Reference System (CRS) is. If you are working with two datasets that are stored using difference CRSs, and want to process or plot them, what do you need to do to ensure they line up on a map and can be processed together?
2. In this class we learned about lidar and canopy height models. We then compared height values extracted from a canopy height model compared to height values measured by humans at each study site. Are the values the same? Why or why not? Use the plots to discuss why they values are similar / different. Then discuss what factors may result in the values being different.


### Plot 1

Create a map of our SJER study area as follows:

1. Import the `madera-county-roads/tl_2013_06039_roads.shp` layer located in your week4 data download. Adjust line width as necessary.
2. Create a map that shows the madera roads layer, sjer plot locations and the sjer_aoi boundary.
3. Plot the roads by road type and add each type to the legend. Place visual emphasis on the County and State roads by adjusting the line width and color. HINT: use the metadata included in your data download to figure out what each type of road represents ("C", "S", etc.). [Use the homework lesson on custom legends]({{ site.url }}/course-materials/earth-analytics/week-5/r-custom-legend/) to help build the legend.
4. Add a **title** to your plot.
45 Add a **legend** to your plot that shows both the road types and the plot locations.

IMPORTANT: be sure that all of the data are within the same EXTENT and crs of the sjer_aoi
layer. This means that you may have to CROP and reproject your data prior to plotting it!

# NOTE: be sure they know how to add points and lines to a legend. Re redit the homework lesson as some of the plots aren't labeled correctly.

### Plot 2
Create a plot of field site locations, SIZED according to maximum tree height.

### Plot 3
Create a scatter plot using `ggplot()` that compares MAXIMUM canopy height model
height in meters, extracted within a 20 meter radius, compared to maximum tree
height derived from the in situ field site data. Note: in the lessons we
compared MEAN tree height rather than

### Plot 4
Create a box plot using `ggplot()` that shows the DIFFERENCE between the extracted
Max canopy height model height compared to in situ height per plot.

## Homework due: Feb 22 2017 @ noon.
Submit your report in both `.Rmd` and `.PDF` format to the D2l dropbox by NOON
Wednesday 22 February 2017.

</div>
