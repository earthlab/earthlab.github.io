---
layout: single
category: courses
title: "Lidar Remote Sensing Uncertainty - Comparing Ground to Lidar Measurements of Tree Height in Python"
permalink: /courses/earth-analytics-python/lidar-remote-sensing-uncertainty/
week-landing: 5
week: 5
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

Welcome to week {{ page.week }} of Earth Analytics! This week, you will explore
the concept of uncertainty surrounding lidar raster data (and remote sensing
data in general). You will use the same data that you downloaded last week for class.
You will also use pipes again this week to work with tabular data.

For your homework you'll also need to download the data below.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 05 Homework Data (~40 MB)](https://ndownloader.figshare.com/files/9435709){:data-proofer-ignore='' .btn }

</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 9:30 - 9:40  | Review |   |
| 9:40 - 10:30  | Guest speaker - Chris Crosby, UNAVCO / Open Topography |   |
| 10:30 - 12:20  | Coding: Use lidar to characterize vegetation / uncertainty |   |

### 1. Readings
* <a href="http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0054776" target="_blank">Influence of Vegetation Structure on Lidar-derived Canopy Height and Fractional Cover in Forested Riparian Buffers During Leaf-Off and Leaf-On Conditions</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0303243403000047" target="_blank">The characterization and measurement of land cover change through remote sensing: problems in operational applications?</a>
*  <a href="https://www.nde-ed.org/GeneralResources/ErrorAnalysis/UncertaintyTerms.htm" target="_blank">Learn more about the various uncertainty terms.</a>


### 2. Complete the Assignment Below (5 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a Report

Create a new `Jupyter notebook`. Name it: **lastName-firstInitial-week5.ipynb**
Within your `notebook` document, write the code needed to create the plots listed below. 
Be sure to name your files as instructed!


#### Answer Questions Below in Your Report -- turning this into multiple choice questions...

2. **Write *at least* 2 paragraphs:** In this class you learned the relationship between lidar derived canopy height models and measured tree height. Use that plots that you create below, the readings and the course lessons to answer the following questions
  * Which lidar tree height metric, (max vs. mean height) more closely relates to human measured tree height?
  * What sources of uncertainty (as discussed in class and the readings) may impact relationship between lidar vs human measured tree height?
  * Do you notice any differences in the relationship between the lidar vs human measured tree height between SJER vs SOAP field sites? Explain.
3. **Write *at least* 1 paragraph:** List a minimum of 3 sources of uncertainty associated with the lidar derived tree heights and 3 sources of uncertainty associated with *in situ* measurements of tree height. For each source of uncertainty, specify whether it is a random or systematic error. Be sure to reference the plots and readings as necessary.


#### Include the Plots Below
Be sure to describe what each plot shows in your final report.
Your plots do not need to be in the order below. I just listed them this way
to make it easier to keep track of and grade!

#### Plots 1 & 2

Overlay the field site point locations on top of the canopy height model for
both the NEON SJER and the SOAP field sites.

* Be sure to adjust the marker plot size based upon the average tree height using the insitu (human measured) data for each plot.
* IMPORTANT: Your basemap should ONLY show plots that have an average tree height value for them.  


#### Plots 3 - 6: Scatterplots With Regression lines

For both the SJER and SOAP field sites, create scatter plots that compare:

* **MAXIMUM** canopy height model height in meters, extracted within a 20 meter radius, compared to **MAXIMUM** tree
height derived from the in situ field site data.
* **AVERAGE** canopy height model height in meters, extracted within a 20 meter radius, compared to **AVERAGE** tree height derived from the in situ field site data.

For each of these plots be sure to:

1. Place lidar data values on the X axis and human measured tree height on the Y axis
2. Include a calculated **regression line** to the plot that describes the relationship of lidar of the data
3. Include a separate **1:1 line** that can be used to compare the regression fit to a perfect 1:1 fit. 
4. Set the x and y limits to be the SAME for each individual plot. This means that for plot 3 the x and y limits are the same. For plot 4 the x and y limits are the same. NOTE: You may have different limits for each plot depending on the data being rendered. Thus plot 3 x and plot 3 y axis may be the same. But plot 3 x axis does NOT need to be the same as plot 4 x axis. 


#### Questions To Answer

Answer the following questions:

1. When comparing lidar vs measured tree height, which metric, mean or max height has a strong relationship? Why do you think one height measurement might be closer to measured then the other?
2. For SJER, provide the plot numbers, of the two plots that have the largest difference between lidar vs measured maximum tree height.
3. For SOAP, provide the plot numbers, of the two plots that have the largest difference between lidar vs measured maximum tree height.



### IMPORTANT: For All Plots
* Label x and y axes appropriately - include units
* Add a title to your plot that describes what the plot shows
* Add a brief, 1-3 sentence caption below each plot that describes what it shows.


## Homework Due: Monday October 9th 2017 @ 8am.
Submit your report in both `.Rmd` and `.html` format to the D2l dropbox. Once again
you are welcome to submit a `.pdf` instead of `.html` if you wish!

</div>

## Report Structure, Code Syntax & Knitr Output: 10%

| Full Credit | No Credit  |
|:----|----|
| `.ipynb` file submitted | |
| Code is written using "clean" code practices following the PEP-8 Python style guide |  |
| All cells contain code that runs  |  |
| All required `Python` packages are listed at the top of the document in a code chunk.  | |
| Lines of code are broken up at commas to reduce the line width and make the code more readable  | |
|==
| Code chunk arguments are used to hide warnings and code and just show output |  |


## Report Questions: 40%

| Full Credit | No Credit  |
|:----|----|
| Student compared the scatter plots of average and max height and determined which relationship is "better" (more comparable 1:1 ) for both field sites |  |
| Student discusses 2-3 potential sources of uncertainty that may have impacted these relationships |  |
| Student discusses differences in the relationships observed between the two field sites (SJER vs SOAP) |  |
| 1-2 readings from the homework are referenced in the report. (You can chose whether you'd like to use bookdown or create manual references)|  |
| 3 sources of uncertainty associated with 1) the lidar derived tree heights and 2) *insitu* tree height measurements are correctly identified as discussed in class and the readings | |
| Student identifies uncertainty sources listed above as systematic vs random | |


## Plots are Worth 50% of the Assignment Grade

### Plots 1 - 2 - Basemap - plot locations overlayed on top of the CHM for each field site.

| Full Credit | No Credit  |
|:----|----|
| Plots have a title that describes plot contents. |  |
| Plots have a 2-3 sentence caption that clearly describes plot contents. |  |

### Plots 3 - 6 - Scatterplots Insitu vs Lidar for San Joachin (SJER) & Soaproot (SOAP) Saddle sites

| Full Credit | No Credit  |
|:----|----|
| Scatter plot of maximum measured vs lidar tree height is included |  |
| Scatter plot of average measured vs lidar tree height is included |  |
| Plots have a title that describes plot contents. |  |
| X & Y axes are labeled appropriately. |  |
| Plots have a 2-3 sentence caption that clearly describes plot contents. |  |



**90% of the regression plot grade**

| Full Credit | No Credit  |
|:----|----|
| 1-2 Paragraphs are included that describe what these plots show in terms of the relationship between lidar and measured tree height and which metrics may or may not be better (average vs maximum height) |  |


## Example Homework Plots

The plots below are examples of what your plot could look like. Feel free to
customize or modify plot settings as you see fit! Note that I did not number
the plots this week to allow you to place plots where you'd like in your report.


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_2_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_3_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_4_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_5_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_6_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_7_0.png">

</figure>




{:.input}
```python
# read in insitu data and gather max and mean for each site location
path = 'data/spatial-vector-lidar/california/neon-soap-site/2013/insitu/veg-structure/D17_2013_SOAP_vegStr.csv'
soap_insitu_cl = pd.read_csv(path)
soap_insitu_cl.describe()

soap_clean = soap_insitu_cl.loc[(soap_insitu_cl['stemheight'] > 2) & (soap_insitu_cl['stemheight'] < 60)]

soap_clean.describe()
soap_insitu_cl = soap_clean.groupby(
     'plotid', as_index=False).stemheight.agg(['max', 'mean'])
soap_insitu_cl = soap_insitu_cl.rename(
     columns={'max': 'insitu_max', 'mean': 'insitu_mean'})
soap_insitu_cl.reset_index(inplace=True)
soap_insitu_cl['insitu_id'] = [pid[4:] for pid in soap_insitu_cl['plotid']]


# join data
soap_joined_cl = soap_lidar.merge(
    soap_insitu_cl, left_on='lidar_id', right_on='insitu_id')
```

{:.input}
```python
# Plot 5: Scatterplot of MAXIMUM canopy height model height in meters, extracted within a
# 20 meter radius, compared to MAXIMUM tree height derived from the insitu field site data at the SOAP site.

# plot data
fig, ax = plt.subplots(1, figsize=(10, 5))
ax = sns.regplot('lidar_max',
                 'insitu_max',
                 data=soap_joined_cl, color='purple')

# add 1/1 line and titles
ax.plot((0, 1), (0, 1), 'k-', transform=ax.transAxes)
ax.set(xlabel='Max Lidar Height(m)',
       ylabel='Max InSitu Height(m)',
       title='Homework Plot 5:\nLidar Derived Max Tree Height v. InSitu Derived Max Tree Height\nSoaproot Saddle Field Site',
       xlim=(0, 60),
       ylim=(0, 60));
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_9_0.png">

</figure>




{:.input}
```python
from scipy import stats

slope, intercept, r_value, p_value, std_err = stats.linregress(soap_joined_cl.lidar_mean,soap_joined_cl.insitu_mean)
slope, intercept, r_value, p_value

slope, intercept, r_value, p_value, std_err = stats.linregress(soap_joined_cl.lidar_max,soap_joined_cl.insitu_max)
slope, intercept, r_value, p_value
```

{:.output}
{:.execute_result}



    (1.180371421880446,
     -12.009274169530396,
     0.924289842960738,
     1.7235218749038855e-05)





{:.input}
```python
# Plot 5: Scatterplot of MAXIMUM canopy height model height in meters, extracted within a
# 20 meter radius, compared to MAXIMUM tree height derived from the insitu field site data at the SOAP site.

# plot data
fig, ax = plt.subplots(1, figsize=(10, 5))
ax = sns.regplot('lidar_mean',
                 'insitu_mean',
                 data=soap_joined_cl, color='purple')

# add 1/1 line and titles
ax.plot((0, 1), (0, 1), 'k-', transform=ax.transAxes)
ax.set(xlabel='Max Lidar Height(m)',
       ylabel='Max InSitu Height(m)',
       title='Homework Plot 5:\nLidar Derived Max Tree Height v. InSitu Derived Max Tree Height\nSoaproot Saddle Field Site',
       xlim=(0, 30),
       ylim=(0, 30));
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/05-raster-vector-extract-data/2018-06-15-lidar-remote-sensing-uncertainty-landing-page_11_0.png">

</figure>



