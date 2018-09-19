---
layout: single
category: courses
title: "Quantify Fire Impacts - Remote Sensing"
permalink: /courses/earth-analytics/multispectral-remote-sensing-modis/
modified: '2018-01-10'
week-landing: 8
week: 8
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics"
module-type: 'session'
---



{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! This week you will dive deeper
into working with remote sensing data surrounding the Cold Springs fire. Specifically,
you will learn how to

* Download data from Earth Explorer.
* Deal with cloud shadows and cloud coverage.
* Deal with scale factors and no data values.

{% include /data_subsets/course_earth_analytics/_data-week6-7.md %}

</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 9:30 - 10:15  | Questions |   |
| 9:40 - 10:20  | ASD Fieldspec Demo - Mini Class Fieldtrip! | Bogdan Lita  |
| 10:30 - 11:00  | Handling clouds in Remote Sensing Data & Using Cloud Masks in `R`  |    |
| 11:15 - 11:45  | Group activity: Get data from Earth Explorer |    |
|===
| 11:45 - 12:20  | MODIS data in R - NA values & scale factors - Coding  Session |    |


### 1a. Midterm Groups

Between now and next class, be sure to figure out who you'd like to work with
for your midterm assignment. If you are looking for a group - please add your name
and the project that you have in mind to the Google document. If you know your
group members and project name please add this to the document!

<a class="btn .btn--x-large btn-info" href="https://docs.google.com/document/d/14LNBg_3d33Tkc4XZTKVvHvmyfaV1yGDGc39VwxaCe6g/edit#" target= "_blank"> <i class="fa fa-file-text" aria-hidden="true"></i>
Add your project & group to the class google doc by class next week. </a>

### 1b. Fire Readings

Please read the articles below to prepare for next week's class.

* <a href="http://www.denverpost.com/2016/07/13/cold-springs-fire-wednesday/" target="_blank">Denver Post article on the Cold Springs fire.</a>
* <a href="http://www.nature.com/nature/journal/v421/n6926/full/nature01437.html" target="_blank" data-proofer-ignore=''>Fire science for rainforests -  Cochrane 2003.</a>
* <a href="https://www.webpages.uidaho.edu/for570/Readings/2006_Lentile_et_al.pdf
" target="_blank">A review of ways to use remote sensing to assess fire and post-fire effects - Lentile et al 2006.</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0034425710001100" target="_blank"> Comparison of dNBR vs RdNBR accuracy / introduction to fire indices -  Soverel et al 2010.</a>

### 2. Complete the Assignment Below (20 points)
Please note that like the flood report, this assignment is worth more points than
a usual weekly assignment. You have 2 weeks to complete this assignment. Start
early!

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a Report

Create a new `R markdown `document. Name it: **lastName-firstInitial-weeknumber.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `html` format. Submit both the
`.Rmd` file and the `.html` file. Be sure to name your files as instructed above.

#### Use knitr Code Chunk Arguments
In your final report, use the following knitr code chunk arguments to hide messages
and warnings and code as you see fit.

* `message = FALSE`, `warning = FALSE` Hide warnings and messages in a code chunk
* `echo = FALSE` Hide code and just show code output
* `results = 'hide'` Hide the verbose output from some functions like `readOGR()`.

#### Answer the Questions Below in Your Report

1. What is the spatial resolution of NAIP, Landsat & MODIS data in meters?
  * 1b. How can differences in spatial resolution in the data that you are using impact analysis results?
2. Calculate the area of "high severity" and the area of "moderate severity" burn in meters using the dNBR for Landsat and MODIS respectively. State what the area in meters is for each data type (Landsat and MODIS) and each level of fire severity (high and moderate) in your answer.
  * 2b. Is the total area as derived from MODIS different from the area derived from Landsat? Why / why not? Use plots 4 and 5 to discuss any differences that you notice.
3. Write 1-3 paragraphs that describes the Cold Springs fire. Include:
  * 3b. Where and when the fire occurred.
  * 3c. What started the fire.
  * 3d. A brief discussion of how fire impacts the natural vegetation structure of a forest and also humans (i.e. are fires always bad?).
4. Describe how dNBR and NDVI can be used to study the impacts of a fire. In your answer, be sure to discuss which parts of the spectrum each index uses and why those wavelength values are used. (i.e. what about NIR light makes it useful for NDVI and what about SWIR light make it useful for a burn index).

Refer to your plots in your answer.

For all of your answers:

* Be sure to **carefully proofread** your report before handing it in.
* Be sure to cite atleast 2 of the assigned articles in your answers.
* Be sure to use proper citation format.

#### Include the Plots Below.

For all plots:

* Be sure to describe what each plot shows in your final report using a figure
caption argument in your code chunks: `fig.cap = "caption here`.
* Add appropriate titles that tell someone reading your report what the map shows.
* Use clear legends as appropriate - especially for the classified data plots!
* Only include code that is directly related to creating your plot. Do not include intermediate plot outputs in your report - only the final plot (unless it helps you directly answer a question asked above).
* Use the `overlay()` function and your `normalized_diff()` function to computer both NDVI and NBR.


#### Plot 1 - Grid of Plots: NAIP, Landsat and MODIS

Use the `plotRGB()` function to create color infrared (also called false color)
images using:

* NAIP data
* Landsat data
* MODIS data

 **in one figure** collected **pre-fire**.


 For each map be sure to:
<!-- In a CIR image, the NIR band is plotted on the “red” band, the red band is plotted using green and the green band is plotted using blue. -->
* Overlay the fire boundary layer (`vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`).
* Use the band combination **r = infrared band**, **g = red band**, **b = green** band. You can use `mfrow=c(rows, columns)`.

* Render the map to the extent of the fire boundary layer using either the `ext = extent()` plot argument. Or crop the data to the fire boundary extent.
* Be sure to label each plot with the data type (NAIP vs. Landsat vs. MODIS) and spatial resolution.

Use this figure to help answer question 1 above.
An example of what this plot should look like (without all of the labels that
you need to add), [is here at the bottom of the page.]({{ site.url }}/courses/earth-analytics/multispectral-remote-sensing-modis/grid-of-plots-report/)

#### Plot 2 - Difference NBR (dNBR) Using Landsat Data

Create a map of the classified dNBR using Landsat data collected before and
after the Cold Springs fire. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the NBR map. Add a legend that clearly describes each burn "class"
that you applied using the table provided in the lessons.

Be sure to use cloud free data.

#### Plot 3 - Difference NBR (dNBR) Using MODIS Data

Create a map of the classified dNBR using MODIS data collected before and
after the Cold Springs fire. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the NBR map. Add a legend that clearly describes each burn "class"
that you applied using the table provided in the lessons.

Be sure to use cloud free data.

dNBR burn classes

Note that depending on how you scaled your data, you may need to scale the
values below by a factor of 10.

| SEVERITY LEVEL  | | dNBR RANGE |
|------------------------------|
| Enhanced Regrowth | | < -.1 |
| Unburned       |  | -.1 to +.1 |
| Low Severity     | | +.1 to +.27 |
| Moderate Severity  | | +.27 to +.66 |
|===
| High Severity     |  | > .66 |

****

#### Plot 4 - Difference NDVI Landsat Data

Create a map of the the difference in NDVI - pre vs post fire. Classify the change
in NDVI as you see fit. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the difference NDVI map. Add a legend that clearly describes each
NDVI difference "class".

Be sure to use cloud free NDVI data.

#### Plot 5 - Difference NDVI MODIS Data

Create a map of the the difference in NDVI - pre vs post fire. Classify the change
in NDVI as you see fit. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the difference NDVI map. Add a legend that clearly describes each
NDVI difference "class".

Be sure to use cloud free NDVI data.

## Bonus Opportunity (2 points)

Find & download a cloud-free Landsat scene from the summer 2017 using Earth Explorer:

* Calculate dNBR using that scene compared to the pre-fire scene that you downloaded from Earth Explorer.
* Plot the data using the dNBR classification table.
* Calculate the total area of high vs. moderate severity burn for the fire scar.

Address the question: Has the fire scar area regenerated at all?

## Homework Due: Monday November 6, 2017 @ 8AM.
Submit your report in both `.Rmd` and `.html` format to the D2l dropbox.

</div>

## Grading


#### R Markdown Report Structure & Code: 15%

| Full Credit | No Credit  |
|:----|----|
| `html` / `pdf` and `.Rmd` files submitted |  |
| Code is written using "clean" code practices following the Hadley Wickham Style Guide |  |
| Code chunk contains code and runs  |  |
| All required `R` packages are listed at the top of the document in a code chunk | |
| Lines of code are broken up with commas to make the code more readable  |  |
| Code chunk arguments are used to hide warnings and other unnecessary output |  |
| Code chunk arguments are used to hide code and just show **required** or important output |  |
| Report only contains code pertaining to the assignment |  |
|===
| Report emphasizes the write-up and the code outputs rather than showing each step of the code | |

####  Report Questions: 40%

| Full Credit | No Credit  |
|:----|----|
| 1a. What is the spatial resolution for NAIP, Landsat & MODIS data in meters? |  |
| 1b. How can differences in spatial resolution in the data that you are using impact analysis results? | |
| 2a. Calculate the area of “high severity” and the area of “moderate severity” burn in meters using the post-fire data for both Landsat and MODIS. State what the area in meters is for each data type (Landsat and MODIS) in your answer. (is the area correctly calculated using `R`?) |  |
| 2b. Is the total area as derived from MODIS different from the area derived from Landsat? | |
| 3a. Write 1-3 paragraphs that describes the Cold Springs fire ||
| 3b. Where and when the fire occurred is discussed in the writeup||
| 3c. What started the fire is included in the write-up ||
| 4a. Describe how dNBR and NDVI can be used to study the impacts of a fire| |
| 4b. Which parts of the spectrum are used to calculate dNBR and NDVI and why| |

**Writing, Grammar & Spelling (5%)**

| Full Credit | No Credit  |
|:----|----|
| All writing is thoughtfully composed |  |
| All writing is proofread with correct grammar and spelling  | |
| All writing is the student's own and not directly copied from the course website or another source without proper citation |  |
|===
| Proper citation format is used.  | |


### Plots are Worth 40% of the Assignment Grade

#### All Plots

| Plot renders on the report. |  |
| Plot contain a descriptive title that represents the data | |
| Plot data source is clearly defined on the plot and / or in the plot caption | |
| Plot has a 2-3 sentence figure caption that clearly describes plot contents | |
| Landsat cloud free data (over the study area) are used to derive Landsat based plots | |
| Cloud masks are applied as appropriate to clean up data |  |
| The `overlay()` function is used to calculate vegetation indices ||
| A `normalized_diff()` function created in the previous classes is used to calculate vegetation indices ||
|===
| Data scale factors are applied as appropriate to data |  |


#### Plot 1 - Grid of NAIP, Landsat and MODIS

| Full Credit | No Credit  |
|:----|----|
| All three plots use the correct bands (NIR band rendered on the red band.) | |
|===
| Plots are stacked vertically (or horizontally) for comparison and render properly on the report |  |

#### Plots 2/3 - dNBR Landsat & MODIS

| Full Credit | No Credit  |
|:----|----|
| Correct band numbers are used to calculate NBR |  |
| Difference NBR is calculated properly |  |
| Plot has been classified according to burn severity classes specified in the assignment |  |
| Plot includes a legend with each "level" of burn severity labeled clearly |  |
|===
| Fire boundary extent has been layered on top of the plot |  |


#### Plots 4/5 - Difference NDVI Landsat & MODIS

| Full Credit | No Credit  |
|:----|----|
| Correct band numbers are used to calculate NDVI |  |
| Difference NDVI is calculated properly |  |
| Plot has been classified according to suggested NDVI classes |  |
| Plot includes a legend with each "level" of NDVI change labeled |  |
|===
| Fire boundary extent has been layered on top of the plot |  |


## Plot Examples










<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis/plot-grid-naip-modis-landsat-1.png" title="grid of plots" alt="grid of plots" width="90%" />







<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis/plot-landsat-nbr-1.png" title="Landsat derived dNBR for Cold Springs Fire 
 Nederland, CO" alt="Landsat derived dNBR for Cold Springs Fire 
 Nederland, CO" width="90%" />








<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis/diff-nbr-modis-1.png" title="dnbr plotted using MODIS data for the Cold Springs fire." alt="dnbr plotted using MODIS data for the Cold Springs fire." width="90%" />





<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis/ndvi-difference-1.png" title="Difference in NDVI pre vs post Cold Springs fire." alt="Difference in NDVI pre vs post Cold Springs fire." width="90%" />


<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis/modis-ndvi-1.png" title="MODIS NDVI difference Cold Springs Fire" alt="MODIS NDVI difference Cold Springs Fire" width="90%" />
