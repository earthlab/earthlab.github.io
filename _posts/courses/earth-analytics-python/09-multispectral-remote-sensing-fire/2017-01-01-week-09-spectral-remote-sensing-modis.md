---
layout: single
category: courses
title: "Quantify the Impacts of a Fire Using MODIS and Landsat Remote Sensing Data in Python"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/
modified: 2020-03-11
week-landing: 9
week: 9
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

Welcome to week {{ page.week }} of Earth Analytics! This week you will work with MODIS and 
Landsat data to calculate burn indices.  

{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>

### 2. Complete the Assignment Using the Template for this week. 
(10 points)
Please note that like the flood report, this assignment is worth more points than
a usual weekly assignment. 

### 1. Suggested Fire Readings

Please read the articles below to prepare for next week's class.

* <a href="http://www.denverpost.com/2016/07/13/cold-springs-fire-wednesday/" target="_blank">Denver Post article on the Cold Springs fire.</a>
* <a href="http://www.nature.com/nature/journal/v421/n6926/full/nature01437.html" target="_blank" data-proofer-ignore=''>Fire science for rainforests -  Cochrane 2003.</a>
* <a href="https://www.webpages.uidaho.edu/for570/Readings/2006_Lentile_et_al.pdf
" target="_blank">A review of ways to use remote sensing to assess fire and post-fire effects - Lentile et al 2006.</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0034425710001100" target="_blank"> Comparison of dNBR vs RdNBR accuracy / introduction to fire indices -  Soverel et al 2010.</a>



## Bonus Opportunity (1 point)

Find & download a cloud-free Landsat scene from the summer 2016 using Earth Explorer:

* Calculate dNDVI using that scene compared to the pre-fire scene that you downloaded from Earth Explorer.
* Plot the data
* Calculate the average value for NDVI in the fire scar region in 2016 and the average NDVI value for the fire scar region from right after the fire (using the data provided to the class). 

Answer the question: Has greenness changed since the fire happened?




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a Report

Create a new `Jupyter Notebook` document. Name it: **lastName-firstInitial-weeknumber.ipynb**
Within your `.ipynb` document, include the plots listed below. Submit both the
`Jupyter Notebook`. Be sure to name your files as instructed above.


#### Answer the Questions Below in Your Report

MULTIPLE CHOICE:
1. What is the spatial resolution of NAIP, Landsat & MODIS data in meters?
  * 1b. How can differences in spatial resolution in the data that you are using impact analysis results?
AUTOGRADE CELL:
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

* Be sure to describe what each plot shows in your final report using a 
caption below the plot.
* Add appropriate titles that tell someone reading your report what the map shows.
* Use clear legends as appropriate - especially for the classified data plots!
* Only include code in your notebook that is directly related to creating your plot. You can create intermediate plots to check your answers, but do not include intermediate plot outputs in your report - only the final plot (unless it helps you directly answer a question asked above).

#### Plot 1 - Grid of Plots: NAIP, Landsat and MODIS

Create a single plot that contains a grid of 3, 3 band color infrared (also called false color) plots using:
images using:

* Post Fire NAIP data
* Post Fire Landsat data
* Post Fire MODIS data

#### Plot 2 -  Difference NBR (dNBR) Using Landsat Data

Create a map of the classified dNBR using Landsat data collected before and
after the Cold Springs fire. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the NBR map. Add a legend that clearly describes each burn "class"
that you applied using the table provided in the lessons.


#### Plot 3 - Difference NBR (dNBR) Using MODIS Data

Create a map of the classified dNBR using MODIS data collected before and
after the Cold Springs fire. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the NBR map. Add a legend that clearly describes each burn "class"
that you applied using the table provided in the lessons.

##### dNBR burn classes

Note that depending on how you scaled your data, you may need to scale the
values below by a factor of 10.

| SEVERITY LEVEL  | dNBR RANGE |
|:-----------------|-----------|
| Enhanced Regrowth | < -.1 |
| Unburned       | -.1 to +.1 |
| Low Severity     | +.1 to +.27 |
| Moderate Severity  | +.27 to +.66 |
| High Severity     | > .66 |

****

#### Plot 4 - Difference NDVI Landsat Data

Create a map of the the difference in NDVI - pre vs post fire. Classify the change
in NDVI as you see fit. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the difference NDVI map. Add a legend that clearly describes each
NDVI difference "class".

Be sure to use cloud free NDVI data.

#### Plot 5 - Difference NDVI MODIS Data

Create a map of the the difference in NDVI - pre vs post fire. Classify the change
in NDVI using the following table:

| Legend Label| Value range|
|:----|----|
| Decrease NDVI | < -.1 |
| No Significant Change| -.1 to .1 |
| Increase NDVI| >.1 |

``
dndvi_class = np.digitize(dndvi_landsat, [-np.inf, -.1, .1, np.inf])
ndvi_change_labs = ["Decrease NDVI","No Significant Change","Increase NDVI"]
``

as you see fit. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the difference NDVI map. Add a legend that clearly describes each
NDVI difference "class".

## Homework Plot Examples





## Plot 1 - Grid of Plots: NAIP, Landsat and MODIS

Create a single plot that contains a grid of 3, 3 band color infrared (also called false color) plots using:
images using:

* Post Fire NAIP data
* Post Fire Landsat data
* Post Fire MODIS data

 For each map be sure to:
<!-- In a CIR image, the NIR band is plotted on the “red” band, the red band is plotted using green and the green band is plotted using blue. -->
* Crop the data to the fire boundary extent
* Overlay the fire boundary layer (`vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`).
* Use the band combination **r = infrared band**, **g = red band**, **b = green** band.
* Be sure to label each plot with the data type (NAIP vs. Landsat vs. MODIS) and spatial resolution.

Use this figure to help answer question 1 above.
An example of what this plot should look like (without all of the labels that
you need to add), is below.











## Homework Plot 1 - Grid of 3 - 3 band CIR plots post fire


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_19_0.png">

</figure>





## Plot 2 - Difference NBR (dNBR) Using Landsat Data

Create a map of the classified dNBR using Landsat data collected before and
after the Cold Springs fire. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the NBR map. Add a legend that clearly describes each burn "class"
that you applied using the table provided in the lessons.

Be sure to use cloud free data.




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_24_0.png">

</figure>










{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_30_0.png">

</figure>







## Homework Plot 2 & 3 : Landsat & MODIS Difference Normalized Burn Ration  dNBR



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_35_0.png">

</figure>






# Landsat vs MODIS  Burned Area



{:.output}
    Burned Landsat class 1:
    Burned Landsat class 2:
    Burned MODIS class 1:
    Burned MODIS class 2:
    Burned Landsat class 4:
    Burned Landsat class 5:
    Burned MODIS class 4:
    Burned MODIS class 5:




# Homework Plot 4: Landsat Difference dNDVI





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_44_0.png">

</figure>




# Homework Plot 5: MODIS Difference dNDVI




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/09-multispectral-remote-sensing-fire/2017-01-01-week-09-spectral-remote-sensing-modis/2017-01-01-week-09-spectral-remote-sensing-modis_47_0.png">

</figure>



