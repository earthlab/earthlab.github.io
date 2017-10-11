---
layout: single
category: courses
title: "Landsat Data in R - Fire Ecology & Remote Sensing"
permalink: /courses/earth-analytics/spectral-remote-sensing-landsat/
modified: '2017-10-11'
week-landing: 7
week: 7
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics"
module-type: 'session'
redirect_from:
  - "/courses/earth-analytics/week-7/"
---

{% include toc title="This Week" icon="file-text" %}


<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics!

At the end of this week you will be able to

* Describe what a spectral band is related to remote sensing data.
* Create maps of spectral remote sensing data using different band combinations including CIR, and RGB.
* Calculate NDVI in `R` using efficient raster processing approaches including `rasterbricks` and the `overlay()` function.
* Use the Landsat file naming convention to determine correct band combinations for plotting and to  calculate NDVI.
* Define additive color model.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}


</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 9:30 - 9:45  | Review last week's assignment / questions |   |
| 9:45 - 10:00  | Introduction to multispectral remote sensing  |  |
| 10:00 - 11:00  | Coding Session: Multispectral data in R - rasterstacks and bricks & Band combinations |  Leah  |
|===
| 11:10 - 12:20  | Vegetation indices and NDVI in R |  Leah  |

### 1a. Remote Sensing Readings

* <a href="https://landsat.gsfc.nasa.gov/landsat-data-continuity-mission/" target="_blank">NASA overview of Landsat 8</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank">Penn State e-Education post on multi-spectral data. Note they discuss AVHRR at the top which we aren't using but be sure to read about Landsat.</a>


### 2. Complete the Assignment Below (5 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a Report

Create a new `R markdown `document. Name it: **lastName-firstInitial-week6.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `PDF` format. Submit both the
`.Rmd` file and the `.pdf` file. Be sure to name your files as instructed above!

#### Use knitr Code Chunk Arguments
In your final report, use the following knitr code chunk arguments to hide messages
and warnings and code as you see fit.

* `message = FALSE`, `warning = FALSE` Hide warnings and messages in a code chunk
* `echo = FALSE` Hide code and just show code output
* `results = 'hide'` Hide the verbose output from some functions like `readOGR()`.

#### Answer the Questions Below at the Top Of Your Report

1. What is the key difference between active and passive remote sensing system?
  * Provide one example of data derived from an active sensor that we have worked with in this class and one example of data derived from a passive sensor in your answer.
2. Compare lidar vs. landsat remote sensing data and answer the following questions
  * What does landsat vs lidar data inherently measure  / record?
  * What is the spatial resolution of landsat compared to the lidar data that we used in class?
  * How often is landsat data collected over a particular area? Are lidar data collected at the same frequency as landsat?
2. Explain what a vegetation index is and how it's used. HINT: NDVI is an example of a vegetation index however there are other indices too. Define vegetation index not just NDVI.
3. After you've created the plots - do you notice anything about the Landsat data that may be problematic if you needed to compare NDVI before and after a fire?

Then, create the plots and output data sets below:

#### Include the Plots and Outputs Below

For all plots:

1. Be sure to describe what each plot shows in your final report using a figure
caption argument in your code chunks: `fig.cap="caption here"`.
2. Add appropriate titles that tells someone reading your report what the map shows
3. Be sure to use the correct bands are you plot and process the data.
4. Apply image stretch as you see fit.
5. Be sure to specify the DATE that the imagery was collected in your plot title. (note I did not do that in the examples below as you need to figure it out)

#### Plots 1 & 2: RGB & CIR images
Create a 1) RGB and 2) Color Infrared (CIR) image of the study site using NAIP data: `naip/m_3910505_nw_13_1_20150919/crop/m_3910505_nw_13_1_20150919_crop.tif`

HINT: To create a CIR image:

* infrared band will appear red
* red band will appear green
* green band will appear blue

Make sure you get the bands right!

#### Plot 3: Create a plot of NDVI + output geotiff

Using the same NAIP image above, calculate NDVI and plot it. **IMPORTANT:** Use a function to
perform the NDVI math and the `overlay()` function to implement the
actual NDVI calculation. Your code should look something like this: `overlay(b1, b2, fun = normalized_diff)`. Be sure that your function is included in your code when you submit your assignment!

* Use the `writeRaster()` function to output your NAIP_ndvi file as a geotiff.
* Use the `check_create_dir()` function that you created last week to ensure that file goes into an "outputs/naip" directory.

#### Plots 4 & 5: NDVI plots + output geotiff

Create map of NDVI pre and post Cold Springs fire. As you did with the NAIP imagery
above, be sure to use the `overlay()` function with the `normalized_diff()` function
that you created.

* Use the `writeRaster()` function to output your landsat_ndvi files (one for pre fire and one for post) as a geotiff.
* Use the `check_create_dir()` function that you created last week to ensure that file goes into an "outputs/landsat" directory.

#### Plot 6 & 7: RGB & CIR images with Landsat

Plot a RGB and CIR image using Landsat data collected pre-fire.


HINTS:

If you see the error below when you plot your RGB images, try to apply a
stretch argument to your `plotRGB()` function.

```r
## Error in grDevices::rgb(RGB[, 1], RGB[, 2], RGB[, 3], alpha = alpha, max = scale) :
##  color intensity -0.00010005, not in [0,1]
```

Try to add the code chunk below after any plots where you change the columns
using the `par()` function. This will "clean" your plot parameters so the next
plot renders correctly.


```html
{r, echo = FALSE, results = 'hide'}
# the function below clears our your plot render space removing any margins or
# other changes to `par()` settings.
dev.off()

```

## Bonus Opportunity! (.5 point each)

* Rather than copying your function code at the top of your `.Rmd` file. Use the
`source()` function to import all of the functions that you created and need for your homework. These functions include (`normalized_diff()` and `check_create_dir()`)
* Look at your code and notice where there are repeated tasks (focus on importing and calculating NDVI using landsat data). Write a well-documented function that takes a directory path containing landsat geotiffs as the input and outputs either a `rasterbrick` that you can use to calculate NDVI OR the ndvi raster itself. Think carefully about making your function as general as possible. Name your function using an expressive name (a verb in the name preferred).

****

## Homework Due: Monday October 16 2017 @ 8AM.
Submit your report in both `.Rmd` and `.html` format to the D2L dropbox.

</div>

## Grading

#### R Markdown Report Structure & Code: 15%

| Full Credit | No Credit  |
|:----|----|
| `html` / `pdf` and `.Rmd` files submitted |  |
| Code is written using "clean" code practices following the Hadley Wickham style guide |  |
| Code chunk contains code and runs  |  |
| All required `R` packages are listed at the top of the document in a code chunk. | |
| Lines of code are broken up at commas to make the code more readable  |  |
| Code chunk arguments are used to hide warnings |  |
| Code chunk arguments are used to hide code and just show output |  |
|===
| Report emphasizes the write up and the code outputs rather than showing each step of the code | |

####  Report Questions: 30%

| Full Credit | No Credit  |
|:----|----|
| What is the key difference between active and passive remote sensing system. Provide one example of data derived from an active sensor that we have worked with in this class and one example of data derived from a passive sensor in your answer.... is answered correctly. |  |
| What does landsat vs lidar data inherently measure / record?|  |
| What is the spatial resolution of landsat compared to the lidar data that we used in class? ||
| How often is landsat data collected over a particular area? Are lidar data collected at the same frequency as landsat? ||
| Explain what a vegetation index is and how it’s used. HINT: NDVI is an example of a vegetation index however there are other indices too. Define vegetation index not just NDVI. ||
|===
| What about the Landat data may make pre-vs post file comparison difficult? ||


### Plots & Plot Outputs Are Worth 55% of the Assignment Grade

#### Plot Aesthetics

| Full Credit | No Credit  |
|:----|----|
| Plot renders on the report | |
| Plot has a 2-3 sentence figure caption that clearly and accurately describes plot contents. | |
| Plot contains a meaningful title. |  |
| Date of Imagery collection is clearly and correctly specified in the plot |  |
|===
| Data source is clearly listed either on the plot or in the plot caption |  |

### Plot construction

| Full Credit | No Credit  |
|:----|----|
| Correct data source (landsat vs NAIP) is used for each plot | |
| Correct bands are used to generate proper RGB plots  | |
| Correct bands are used to generate proper CIR plots  | |
|===
| Correct bands are used to generate proper NDVI plots (note the band # are DIFFERENT for NAIP vs Landsat 8 )  | |

#### Code & Functions

| Full Credit | No Credit  |
|:----|----|
| The `overlay()` function combined with a custom created normalized diff function is used to calculate NDVI  | |
| Functions are properly documented with overview, inputs and outputs and associated input and output formats | |
| The `check_create_dir()` function was created and used to ensure `writeRaster()` outputs write to the correct directory | |
|===
| Output rasters were created in the code | |


<!--
## stuff from last time that i'll use later
| Plot includes a clear legend with each "level" of burn severity labeled clearly. |  |

#### Plots 3 - Create a classified map of post fire NDVI using classification values that you think make sense based upon exploring the data.

| Full Credit | No Credit  |
|:----|----|
| A classified map has been created and renders in the report. |  |
| The values chosen to create the classified plot clearly show differences in NDVI values. |  |
| The colors chosen to create the classified plot clearly show differences in NDVI values. |  |
| Plot has a clear title that describes the data being shown. |  |
| Plot has a clear legend that shows the classes chosen and associated colors rendered on the map. |  |
| Plots have a 2-3 sentence caption that clearly describes plot contents. |  |




#### Plots 4 Create a classified map of post fire NBR using the classification thresholds.

| Full Credit | No Credit  |
|:----|----|
| Plot renders on the pdf. |  |
| Plot contains a meaningful title. |  |
| Plot has a 2-3 sentence figure caption that clearly describes plot contents. |  |
| Plot data are classified using the thresholds specified. |  |
| Plot data colors clearly show areas of most intense burn compared to areas of no or less burn severity. |  |
| Plot has a clear legend that shows the classes chosen and associated colors rendered on the map. | |
-->

### Example report plots



<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-07-multispectral-remote-sensing-landsat/load-packages-1.png" title="NAIP CIR" alt="NAIP CIR" width="90%" /><img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-07-multispectral-remote-sensing-landsat/load-packages-2.png" title="NAIP CIR" alt="NAIP CIR" width="90%" />






<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-07-multispectral-remote-sensing-landsat/landsat-pre-ndvi-1.png" title="Landsat NDVI pre fire" alt="Landsat NDVI pre fire" width="90%" />

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-07-multispectral-remote-sensing-landsat/landsat-post-ndvi-1.png" title="Landsat NDVI post fire" alt="Landsat NDVI post fire" width="90%" />



<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-07-multispectral-remote-sensing-landsat/landsat-pre-fire-rgb-1.png" title="Landsat Pre Fire RGB Image" alt="Landsat Pre Fire RGB Image" width="90%" />



<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-07-multispectral-remote-sensing-landsat/landsat-post-fire-rgb-1.png" title="Landsat Post Fire RGB Image" alt="Landsat Post Fire RGB Image" width="90%" />





<!--
#### Plot 2
Create a MAP of the **difference between NBR pre vs post fire** with Landsat data  (Pre fire - post-fire NBR). Classify that data using the classification thresholds below. Be sure to include a legend on your map that helps someone looking at it
understand differences.

| SEVERITY LEVEL  | NBR RANGE |
|------------------------------|
| Enhanced Regrowth | -700 to  -100  |
| Unburned       |  -100 to +100  |
| Low Severity     | +100 to +270  |
| Moderate Severity  | +270 to +660  |
| High Severity     |  +660 to +1300 |

Note: if your min and max NBR values are outside of the range above, you can adjust
-700 to be your smallest raster value and for high severity you can adjust 1300 to
be your largest NBR raster value.

#### Plot 3
Create a classified map of **post fire NDVI** with Landsat data using classification values that you
think make sense based upon exploring the data.

#### Plot 4
Create a map of **post fire NBR** with Landsat data.
-->
