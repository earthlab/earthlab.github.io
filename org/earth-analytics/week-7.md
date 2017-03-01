---
layout: single
category: course-materials
title: "Week 7"
permalink: /course-materials/earth-analytics/week-7/
week-landing: 7
week: 7
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics!

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 6/7 Data (~500 MB)](https://ndownloader.figshare.com/files/7636975){:data-proofer-ignore='' .btn }

</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 3:00 - 3:15  | Questions |   |
| 3:15 - 3:40  | Addititive light models - interactive experiment |   |
| 3:45 - 4:15  | Dealing with clouds & cloud masks  |    |
|===
| 4:30 - 5:50  | Coding Session: Spectral RS data in R |  Leah  |


### 1a. Remote sensing readings

There are no new readings for this week.


### 2. Complete the assignment below (10 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a .pdf report

Create a new `R markdown `document. Name it: **lastName-firstInitial-week6.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `PDF` format. Submit both the
`.Rmd` file and the `.pdf` file. Be sure to name your files as instructed above!

#### Use knitr code chunk arguments
In your final report, use the following knitr code chunk arguments to hide messages
and warnings and code as you see fit.

* `message=F`, `warning=F` Hide warnings and messages in a code chunk
* `echo=F` Hide code and just show code output
* `results='hide'` Hide the verbose output from some functions like `readOGR()`.

#### Answer the following questions below in your report

1. What is the spatial resolution between NAIP, Landsat & MODIS data in meters? Are these data types different in terms of resolution? How might this impact analysis using these data? Use plot 1 BELOW to visually show the difference.
2. Calculate the area of "high severity" burn in meters using the post-fire data for both Landsat and MODIS. Are the values different? Why / why not? Use plots 3 and 4 to discuss
any differences that you notice between the two data sets.
3. Describe 3 potential impacts of cloud cover on remote sensing imagery analysis. What are 2 ways that we can deal with clouds when we encounter them in our work? Refer to plot 2 in your homework to

#### Include the plots below.
For all plots
1. Be sure to describe what each plot shows in your final report using a figure
caption argument in your code chunks: `fig.cap="caption here".
2. Add appropriate titles that tells someone reading your report what the map shows


#### Plot 1 - Grid of NAIP, Landsat and MODIS
Use the `plotRGB()` function to plot a color infrared (also called false color)
images of NAIP, Landsat and MODIS in one figure. For each map be sure to

* Overlay the fire boundary layer (`vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`)
* use the band combination r = infrared band, g= green band, b=blue band. You can use `mfrow=c(rows, columns)`
* Render the map to the extent of the fire boundary layer using the `ext=extent()` plot argument.
* Be sure to label each plot with the data type (NAIP vs. Landsat vs. MODIS) and spatial resolution.

Use this figure to help answer question 1 above.
An example of what this plot should look like (without all of the labels that you need to add, [is here at the bottom of the page.]({{ site.url }}/course-materials/earth-analytics/week-7/grid-of-plots-report/)

#### Plot 2 - Pre-fire NBR using landsat data
Create a MAP of the classified pre-burn NBR using a newly downloaded **Landsat** file.
Overlay the fire extent layer `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp` on top of the NBR map. Add a legend.
This file should not have a cloud in the middle of the burn area! You can use Earth Explorer to download the data. Use the classes that you used in your homework from week 6 to
classify the data.

#### Plot 3 - Pre-fire NBR using landsat data
Create a MAP of the classified pre-burn NBR using the **Landsat** data file that
was provided to you in your data download `data/week6/landsat/LC80340322016189-SC20170128091153/crop`. Be sure to mask the
clouds from your analysis. Overlay the fire extent layer `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp` on top of the NBR map. Add a legend that clearly
explains what each class represents (ie high severity, moderate etc.).

#### Plot 4 - Post-fire NBR using landsat data
Create a MAP of post fire classified NBR using **Landsat** data. Note: you did
this for your homework last
week, re-use the code. However this time, use a cloud mask to remove any clouds
in your data. Then, overlay the fire extent layer (`vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`) on
top of the NBR map. Add a legend that shows each NBR class and that clearly
explains what each class represents (ie high severity, moderate etc.).


#### Plot 5 - Post-fire NBR MODIS
Create a classified map of **post fire NBR** using MODIS data. Be sure to mask
the data using a cloud mask. Ideally you'll do this BEFORE you calculate NBR and
classify it. Add a legend that shows each NBR class and that clearly
explains what each class represents (i.e. high severity, moderate etc.).


| SEVERITY LEVEL  | dNBR RANGE |
|------------------------------|
| Enhanced Regrowth | <= -100  |
| Unburned       |  -100 to +100  |
| Low Severity     | +100 to +270  |
| Moderate Severity  | +270 to +660  |
| High Severity     |  >= 660|

****

## Homework due: Thursday March 10 2017 @ NOON.
Submit your report in both `.Rmd` and `.PDF` format to the D2l dropbox.

</div>

## Grading

NOTE: this will be updated after class today!

#### .Pdf Report structure & code: 10%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| PDF and RMD submitted |  | Only one of the 2 files are submitted  | | No files submitted |
| Code is written using "clean" code practices following the Hadley Wickham style guide| Spaces are placed after all # comment tags, variable names do not use periods, or function names. | Clean coding is used in some of the code but spaces or variable names are incorrect 2-4 times| | Clean coding is not implemented consistently throughout the report. |
| Code chunk contains code and runs  | All code runs in the document  | There are 1-2 errors in the code in the document that make it not run | | The are more than 3 code errors in the document |
| All required R packages are listed at the top of the document in a code chunk.  | | Some packages are listed at the top of the document and some are lower down. | | |
| Lines of code are broken up at commas to make the code more readable  | |  | | |


####  Knitr pdf output: 20%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Code chunk arguments are used to hide warnings |  |  | | |
| Code chunk arguments are used to hide code and just show output |  | | |  |
| PDf report emphasizes the write up and the code outputs rather than showing each step of the code |  | | |  |

####  Report questions: 20%

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| What is the key difference between active and passive remote sensing system is answered correctly. |  |  | | |
| Describe atleast 3 differences between how lidar vs landsat remote sensing data is answered correctly.|  |  | | |
| Explain what a vegetation index is is answered correctly. |||||


### Plots are worth 50% of the assignment grade

#### Create a MAP of the difference between NDVI pre vs post fire (Post fire - pre-fire NDVI).

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Pre and post fire NDVI are created |  |  | | |
| Plot renders on the pdf. |  |  | | |
| Plot contains a meaningful title. |  |  | | |
| Plot has a 2-3 figure caption that clearly describes plot contents. |  |  | | |

#### Plot 2 Create a MAP of the difference between NBR pre vs post fire (Post fire - pre-fire NDVI).

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Pre and post fire NDVI are created |  |  | | |
| Plot renders on the pdf. |  |  | | |
| Plot contains a meaningful title. |  |  | | |
| Plot has a 2-3 figure caption that clearly describes plot contents. |  |  | | |
| Plot includes a clear legend with each "level" of burn severity labeled clearly. |  |  | | |

#### Plots 3 - Create a classified map of post fire NDVI using classification values that you think make sense based upon exploring the data.

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| A classified map has been created and renders in the report. |  |  | | |
| The values chosen to create the classified plot clearly show differences in NDVI values. |  |  | | |
| The colors chosen to create the classified plot clearly show differences in NDVI values. |  |  | | |
| Plot has a clear title that describes the data being shown. |  |  | | |
| Plot has a clear legend that shows the classes chosen and associated colors rendered on the map. |  |  | | |
| Plots have a 2-3 sentence caption that clearly describes plot contents. |  |  | | |

#### Plots 4 Create a classified map of post fire NBR using the classification thresholds.

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Plot renders on the pdf. |  |  | | |
| Plot contains a meaningful title. |  |  | | |
| Plot has a 2-3 figure caption that clearly describes plot contents. |  |  | | |
| Plot data are classified using the thresholds specified. |  |  | | |
| Plot data colors clearly show areas of most intense burn compared to areas of no or less burn severity. |  |  | | |
| Plot has a clear legend that shows the classes chosen and associated colors rendered on the map. |  |  | | |
