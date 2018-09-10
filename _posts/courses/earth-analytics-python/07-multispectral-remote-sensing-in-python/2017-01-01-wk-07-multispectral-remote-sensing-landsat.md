---
layout: single
category: courses
title: "Multispectral Imagery Python - NAIP, Landsat, Fire & Remote Sensing"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-in-python/
modified: 2018-09-07
week-landing: 7
week: 7
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

Welcome to week {{ page.week }} of Earth Analytics!

At the end of this week you will be able to:

* Describe what a spectral band is in remote sensing data.
* Create maps of spectral remote sensing data using different band combinations including CIR and RGB.
* Calculate NDVI in `Python` using.
* Get NAIP remote sensing data from Earth Explorer.
* Use the Landsat file naming convention to determine correct band combinations for plotting and calculating NDVI.
* Define additive color model.

{% include /data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}


</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 9:30 - 9:45  | Review last week's assignment / questions |   |
| 9:45 - 10:00  | Introduction to multispectral remote sensing  |  |
| 10:00 - 11:00  | Coding Session: Multispectral data in Python using Rasterio |  Leah  |
|===
| 11:10 - 12:20  | Vegetation indices and NDVI in Python |  Leah  |

### 1a. Remote Sensing Readings

* <a href="https://landsat.gsfc.nasa.gov/landsat-data-continuity-mission/" target="_blank">NASA Overview of Landsat 8</a>
* <a href="https://www.e-education.psu.edu/natureofgeoinfo/c8_p12.html" target="_blank">Penn State e-Education post on multi-spectral data. Note they discuss AVHRR at the top which you won't use in this lesson but be sure to read about Landsat.</a>


### 2. Complete the Assignment Below (5 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a Report

Create a new `Jupyter Notebook`. Name it: **lastName-firstInitial-weeknumber.ipynb**
Within your `.ipynb` document, include the plots listed below. When you are done
with your report, convert it to `html` or `pdf` format. Submit both the
`.ipynb` file and the `.html or pdf` file.

#### Answer the Questions Below at the Top of Your Report

TURN these into multiple choice / quiz to reduce grading

https://docs.google.com/document/d/1ZeYlXSeuy6Op1xRY8mItFwVl5WgDVP6kGdEdSzK6Fog/edit#

1. What is the key difference between active and passive remote sensing system?
  * Provide one example of data derived from an active sensor that you have worked with in this class and one example of data derived from a passive sensor in your answer.
2. Compare Lidar vs. Landsat remote sensing data and answer the following questions:
  * What does Landsat vs Lidar data inherently measure  / record?
  * What is the spatial resolution of Landsat compared to the Lidar data that you used in class?
  * How often is Landsat data collected over a particular area? Are Lidar data collected at the same frequency as Landsat?
2. Explain what a vegetation index is and how it's used. HINT: NDVI is an example of a vegetation index however there are other indices too. Define vegetation index not just NDVI.
3. After you've created the plots - do you notice anything about the Landsat data that may be problematic if you needed to compare NDVI before and after a fire?

Then create the plots and output data sets below.

#### Include the Plots and Outputs Below

For all plots:

1. Be sure to describe what each plot shows using text below your plot in your Jupyter notebook. 
2. Add appropriate titles to your plot that clearly and concisely describe what the plot shows.
3. Be sure to use the correct bands as you plot and process the data.
4. Apply image stretch to your plots as you see fit.
5. If it is relevant, be sure to specify the DATE that the imagery was collected in your plot title or caption.

#### Plots 1 & 2: RGB & CIR Images Using NAIP Data
Using Earth Explorer, download NAIP data from 2017 (post fire).
Create a 1) RGB and 2) Color Infrared (CIR) image of the study site using the post fire NAIP data.

Add the Cold Springs fire boundary to each map. 

HINT: In a CIR image the:

* Infrared band will appear red.
* Red band will appear green.
* Green band will appear blue.

Make sure that you use the correct bands.

#### Plot 3: Create a Plot of the Difference NDVI (2017 - 2015)

Calculate and plot the DIFFERENCE between NDVI in 2017 and 2015. To calculate difference **subtract the pre-fire data from the post fire data (post - pre)** to ensure that negative values represent a decrease in NDVI between the two years. 

Add the Cold Springs fire boundary to your plot. 

** can we test them outputting a geotiff from the above calculations??

#### Plot 4 & 5: RGB & CIR Images Using Pre-Fire Landsat Data

Plot a RGB and CIR image using Landsat data collected pre-fire.

Add the Cold Springs fire boundary to each map. 

#### Plots 6: Calculate NDVI Using Pre-Fire Landsat Data

Create map of NDVI pre and post Cold Springs fire using the Landsat data provided
in the week_07 data set. 

Add the Cold Springs fire boundary to your plot. 

IMPORTANT: don't forget to label each map appropriately with the date that the
data were collected and pre or post fire!


##### HINTS:

* You will need to reproject the fire boundary to get it to overlay properly on top of each remote sensing dataset above. 
* Don't forget to set the spatial `extent` for each plot so the data plot correctly!


### IMPORTANT: For All Plots

* Add a title to your plot that describes what the plot shows.
* Add a brief, 1-3 sentence caption below each plot that describes what it shows.
* Be sure to mention the data source and the date that the data were collected in a caption at the bottom of each plot.


****

*NOTE: we can likely remove due dates from the website and add them in CANVAS if we want??**

## Homework Due: Monday October 23 2017 @ 8AM
Submit your report in both `.ipynb` and `.html` format to the Canvas dropbox.

</div>

## Grading

Please note if you skip / do not attempt to complete a segment of the assignment
(2 or more plots, the report, answering questions, etc.), you will not be able to
achieve a grade higher than a C on the assignment.

#### R Markdown Report Structure & Code: 15%

| Full Credit | No Credit  |
|:----|----|
| `html` and `.ipynb` files submitted |  |
| Code is written using "clean" code practices|  |
| Code chunk contains code and runs  |  |
| All required `Python` packages are listed at the top of the document in a code chunk | |
| Lines of code are broken up with commas to make the code more readable  |  |
| Code chunk arguments are used to hide warnings and other unnecessary output |  |
| Code chunk arguments are used to hide code and just show output |  |
|===
| Report only contains code pertaining to the assignment |  |


####  Report Questions: 30% <- this will be turned into a quiz!

| Full Credit | No Credit  |
|:----|----|
| What is the key difference between active and passive remote sensing system? Provide one example of data derived from an active sensor that you have worked with in this class and one example of data derived from a passive sensor in your answer. |  |
| What do Landsat vs Lidar data inherently measure / record?|  |
| What is the spatial resolution of Landsat compared to the Lidar data that you used in class? ||
| How often is Landsat data collected over a particular area? Are Lidar data collected at the same frequency as Landsat? ||
| Explain what a vegetation index is and how it's used. HINT: NDVI is an example of a vegetation index however there are other indices too. Define vegetation index not just NDVI. ||
|===
| What about the Landat data may make pre vs post file comparison difficult? ||


### Plots & Plot Outputs Are Worth 55% of the Assignment Grade

#### Plot Aesthetics

| Full Credit | No Credit  |
|:----|----|
| Plot renders on the report | |
| Plot has a 2-3 sentence figure caption that clearly and accurately describes plot contents | |
| Plot contains a meaningful title. |  |
| Date of imagery collection is clearly and correctly specified in the plot |  |
|===
| Data source is clearly listed either on the plot or in the plot caption |  |

### Plot Construction

| Full Credit | No Credit  |
|:----|----|
| Correct data source (Landsat vs NAIP) is used for each plot | |
| Correct bands are used to generate proper RGB plots  | |
| Correct bands are used to generate proper CIR plots  | |
|===
| Correct bands are used to generate proper NDVI plots (note the band numbers are DIFFERENT for NAIP vs Landsat 8 )  | |

#### Code & Functions

| Full Credit | No Credit  |
|:----|----|
| | |
|===
| Output rasters were created in the code | |   


{:.input}
```python
# plot 2017 cropped data
fig, ax = plt.subplots(figsize=(10,10))
es.plot_rgb(naip_2017_crop,
           rgb = [0,1,2],
           extent = extent_naip,
           title = "Homework PLOT 1: NAIP 2017 Post Fire RGB Image\n Cropped",
           ax=ax)
fire_bound_utmz13.plot(ax=ax, color='None', edgecolor='white', linewidth=2);

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_2_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_3_0.png">

</figure>




## NAIP NDVI Difference


The intermediate NDVI plots below are not required for your homework. They are here so you can compare intermediate outputs if you want to! You will need to create these datasets to process the final NDVI difference plot that is a homework item!


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_6_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_7_0.png">

</figure>




## Landsat RGB / CIR 

    


{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/rasterio/__init__.py:160: FutureWarning: GDAL-style transforms are deprecated and will not be supported in Rasterio 1.0.
      transform = guard_transform(transform)



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_9_1.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_10_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/07-multispectral-remote-sensing-in-python/2017-01-01-wk-07-multispectral-remote-sensing-landsat_11_0.png">

</figure>



