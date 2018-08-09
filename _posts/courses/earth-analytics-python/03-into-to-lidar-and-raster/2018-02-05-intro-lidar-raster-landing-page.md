---
layout: single
category: courses
title: "Lidar Raster Data in Python"
permalink: /courses/earth-analytics-python/intro-lidar-raster-data/
week-landing: 3
week: 3
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! In week 3 you will learn about
Light Detection and Ranging (LiDAR) data. You will learn to use point cloud data and
lidar rasters in `Python` and explore using QGIS - a free, open-source GIS tool.

Your final 2013 Colorado flood report assignment is below. Read the assignment
carefully and make sure you've completed all of the steps and followed all of the
guidelines. Use all of the class and homework lessons that you've learned in the
first few weeks to help you complete the assignment.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class Schedule

| time          | topic                                                     | speaker           |  |  |
|:--------------|:----------------------------------------------------------|:------------------|:-|:-|
| 9:30 am       | Review Jupyter Notebook / questions                  | Leah              |  |  |
| 9:50 - 10:30  | Using data and models to understand the boulder floods    | Dr. Matthew Rossi |  |  |
| 10:45 - 12:20 | Python coding session - Intro to Lidar data & raster data in Python | Leah              |  |  |

### 1. Readings

First - review ALL of the lessons for this week. We did not cover them all in class. This
includes the in class and homework lessons.

Read the following articles. They will help you write your report.

* Wehr, A., and U. Lohr (1999). Airborne Laser Scanning - An Introduction and Overview. ISPRS Journal of Photogrammetry and Remote Sensing 54:68–92. doi: 10.1016/S0924-2716(99)00011-8 : <a href="http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.516&rep=rep1&type=pdf" target="_blank" data-proofer-ignore=''><i class="fa fa-download" aria-hidden="true"></i>
PDF</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/node/1888" target="_blank">Intro to Lidar</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/node/1890" target="_blank">Active remote sensing</a>

<!--
These no longer work - access denied
* <a href="https://www.e-education.psu.edu/geog481/l1_p3.html" target="_blank">Introduction to Lasers</a>
* <a href="https://www.e-education.psu.edu/geog481/l1_p4.html" target="_blank">History of Lidar Development</a>
-->


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework (10 points): Due Monday Sept 25 @ 8AM

#### Produce a Final Report on the 2013 Floods

Create a new `Jupyter Notebook` document. Name it: **lastName-firstInitial-floodreport.ipynb**
Within your `.ipynb` document, carefully compose a report that summarizes what you have
learned about the 2013 Colorado flood event. Use all of the plots that you have created
in the first 3 weeks of the class in your report as listed below.

When you are done with your report, convert it to `html` format. You will submit both
the `.ipynb` file and the `.html` file. Be sure to name your files as instructed above!

Include the following parts in your report:

####  Background / Overview of the Flood

Include the following background in your report:

1. Description of where and when the disturbance event occurred.
2. Discussion of the drivers that yielded the flooding in Boulder and discussion of the impacts of the flood.

#### Your Report Should Include 9 Plots
Your report should include the following plots (in whatever order you think best
describes the events of the flood):

### Basemap Plot:

* **PLOT 1:** An interactive basemap showing the location of the stream gage / study area created using
`folium`

### Precip & Discharge Plots from Week 2:

Use the `data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv`file to create:

* **PLOT 2:** a plot of precipitation from 2003 to 2013 using `matplotlib`.
* **PLOT 3:** a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`.

Use the `data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.csv` file to create:

* **PLOT 4:** a plot of stream discharge from 1986 to 2016 using `matplotlib`.
* **PLOT 5:** a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`.

### Raster & Histogram Plots from Week 3:

* **PLOT 6: pre/post CHM difference raster histogram** Create a **cropped** raster map that shows positive and negative change in the canopy height model before and after the flood. To do this:
   * Subtract the post-flood CHM from the pre-flood CHM (**pre_flood_CHM - post_flood_CHM**).
   * Crop the data using the `data/week-03/boulder-leehill-rd/clip-extent.shp` crop_extent shapefile.
   * Plot a histogram of the cropped data.

* **PLOT 7: Classified pre/post CHM difference raster** Use the difference raster that you created above and the histogram as a guide to classify your difference canopy height model. Use values that make sense after reviewing the histogram.

* **PLOT 8: pre/post DTM difference raster histogram** Create a **cropped** raster map that shows positive and negative change in the digital terrain model before and after the flood. To do this:
   * Subtract the post-flood DTM from the pre-flood DTM (**pre_flood_DTM - post_flood_DTM**).
   * Crop the data using the `data/week-03/boulder-leehill-rd/clip-extent.shp` crop_extent shapefile.
   * Plot a histogram of the cropped data.
* **PLOT 9: Classified pre/post DTM difference raster** Use the difference raster that you created above and the histogram as a guide to classify your difference digital terrain model. Use values that make sense after reviewing the histogram.


###  Citations

* Remember to add citations in an appropriate format such as APA ect.

For all plots use the readings from the last 3 weeks to discuss:

* Where the data came from and what the data shows.
* Discuss patterns that are evident in the data and potential relationships between what you see in the lidar data compared to precipitation and discharge.


#### Summary / Discussion
End your report with a summary discussion of the flood events. Be sure to discuss
how the data help you better understand the 2013 Colorado floods as they
impacted Boulder, Colorado.


#### Important:

* Clearly state the source of each dataset that you use to create the plot in your report text.
* Make sure each plot has a clear **TITLE** and, where appropriate, **label the x and y axes**. Be sure to include **UNITS** in your labels!
* Analyze / interpret each plot that you produce in your report. State what the source of the data are and what the plot shows as a driver or impact of the 2013 flood events.
* Clearly document that steps that you took to process the data by commenting your code or in the text of your report itself as it makes sense.
* All students must cite **at least 3** articles that you read or other sources of information that you used to write your report. (grad students will use  to do this, undergrads can choose how they want to include citations).
* Use clean coding practices - this includes comments, variable names that are informative, clean code spacing, following PEP 8 `Python` code style guide.
* Make sure all of the libraries that you use in the report are listed in a code chunk at the TOP of your document.
* Spell check your report and check grammar.
* All plots should be clearly labeled with titles, and x and y axis labels are it makes sense. (Your map of lidar data doesn't need x and y labels).
* Be sure to discuss how you selected the classification values used in the raster plots referencing
the histograms of the data that you create.
* OPTIONAL BONUS: Include images as they make sense. Be sure to cite any graphics that you use that are not yours.


## Submissions
Submit your report in **both** `.ipynb` and `.html` format to the D2L dropbox.
NOTE: if you want to create `.pdf` formatted reports that is fine as well!
You may need to google formatting associated with pdfs!
</div>

## Homework Plots

The plots below are examples of what your plots might look like. Your plots do not need to look exactly like these! You may use different classes for your different maps for example which will change your rasters! Feel free to customize colors, labels, layers, etc as you like to create nice plots.


{:.output}

    ---------------------------------------------------------------------------

    ModuleNotFoundError                       Traceback (most recent call last)

    <ipython-input-2-1941069c482c> in <module>()
         14 from matplotlib.colors import ListedColormap, BoundaryNorm
         15 from matplotlib.patches import Patch
    ---> 16 import folium
         17 
         18 #if using method 2 for plot 1


    ModuleNotFoundError: No module named 'folium'



## Homework Grades & Rubric

This homework is worth 10 points as it
represents a culmination of the things you have learned during the first 3 weeks
of class. The grading rubric that you will use to grade the assignment is below.

### Report Content - Text Writeup: 30%

| Full Credit                                                                                                                                                                                                                                                          | No Credit |  |
|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------|:-|
| `.html` and `.ipynb` files submitted                                                                                                                                                                                                                                   |           |  |
| Summary text is provided for each plot                                                                                                                                                                                                                               |           |  |
| Grammar & spelling are accurate throughout the report                                                                                                                                                                                                                |           |  |
| File is named with last name-first initial week 3                                                                                                                                                                                                                    |           |  |
| Report contains all 9 plots described in the assignment                                                                                                                                                                                                              |           |  |
| References are made to the assigned class readings in the text of your report in the form of **properly formatted** citations. References are listed using proper format guidelines at the bottom of the report. (Graduate students should add these using bookdown) |           |  |
| ===                                                                                                                                                                                                                                                                  |           |  |
| There is a thoughtful discussion of the relationship between precipitation, discharge and patterns seen in the lidar pre-post flood data.                                                                                                                            |           |  |

### Report Code Structure - Code Format: 30%

| Full Credit                                                                           | No Credit |
|:--------------------------------------------------------------------------------------|:----------|
| Code is written using "clean" code practices following the PEP 8 `Python` style guide |           |
| first markdown cell contains a title, author and date                                                |           |
| Code chunk contains code and runs                                                     |           |
| ===                                                                                   |           |
| All required `python` packages are listed at the **top** of the document in a code chunk    |           |


### Plots - Previously Produced Plots and Basemap (New plot but code is provided) - 10%

    Plot 1 - `contextily` basemap study area base map

| Full Credit                                                                                                       | No Credit |
|:------------------------------------------------------------------------------------------------------------------|:----------|
    | PLOT 1 - Study area map using `folium` is included and the study area location is clearly identified |      


#### Plots 2-5

* **PLOT 2:** a plot of precipitation from 2003 to 2013 using `matplotlib`.
* **PLOT 3:** a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`.
* **PLOT 4:** a plot of stream discharge from 1986 to 2013 using `matplotlib`.
* **PLOT 5:** a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`.

| Full Credit                                                                                                                                                                     | No Credit |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------|
| PLOT 2: contains appropriate titles, axis labels and colors. Plot data source is clearly described in the text.  & the plot data are interpreted relative to the boulder flood. |           |
| PLOT 3: contains appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood.   |           |
| PLOT 4: contains appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood.   |           |
| ===                                                                                                                                                                             |           |
| PLOT 5: contains appropriate titles, axis labels and colors. Plot data source is clearly described in the text & the plot data are interpreted relative to the boulder flood.   |           |

## Raster Plots - 30%

* **Plot 6:** A classified raster map that shows positive and negative change in the canopy height model before vs after the flood.
* **Plot 8:** A classified raster map that shows positive and negative change in the digital terrain model before vs after the flood.

| Full Credit                                                                                                             | No Credit |
|:------------------------------------------------------------------------------------------------------------------------|:----------|
| Plot is customized with appropriate titles, axis labels and colors                                                      |           |
| Data are CROPPED using the crop_extent shapefile                                                                        |           |
| Plot data source is described in the text caption. Plot data are interpreted / discussed relative to the boulder flood  |           |
| Raster data are classified into discrete values                                                                         |           |
| The colors and classes selected to process the data and display the plot, clearly show changes in terrain               |           |
| ===                                                                                                                     |           |
| There is discussion of how the classification values used in the raster plots were selected referencing the histograms  |           |


### Plots 7 & 9 - Histograms

* **Plot 7:** A histogram raster map that shows positive and negative change in CHM derived from the pre and post flood Canopy Height Models.
* **Plot 9:** A histogram raster map that shows positive and negative change in terrain derived from the pre and post flood Digital Terrain Models.

A histogram of the classified raster layer that shows positive and negative change in canopy height derived from the pre and post flood Digital Terrain Models before and after the flood

| Full Credit                                                                        | No Credit |  |  |  |
|:-----------------------------------------------------------------------------------|:----------|:-|:-|:-|
| Plot is customized with appropriate titles, axis labels and colors                 |           |  |  |  |
| Histogram breaks were selected to clearly show positive and negative changes       |           |  |  |  |
| ===                                                                                |           |  |  |  |
| There is discussion of how the histogram was used to select classification ranges  |           |  |  |  |
