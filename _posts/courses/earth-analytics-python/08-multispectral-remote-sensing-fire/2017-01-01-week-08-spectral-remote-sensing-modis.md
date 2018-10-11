---
layout: single
category: courses
title: "Quantify the Impacts of a Fire Using MODIS and Landsat Remote Sensing Data in Python"
permalink: /courses/earth-analytics-python/multispectral-remote-sensing-modis/
modified: 2018-10-10
week-landing: 8
week: 8
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

Welcome to week {{ page.week }} of Earth Analytics! This week you will dive deeper
into working with remote sensing data surrounding the Cold Springs fire. Specifically,
you will learn how to

* Download data from Earth Explorer.
* Deal with cloud shadows and cloud coverage.
* Deal with scale factors and no data values.

{% include/data_subsets/course_earth_analytics/_data-cold-springs-fire.md %}

</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 9:30 - 10:15  | Questions |   |
| 9:40 - 10:20  | ASD Fieldspec Demo - Mini Class Fieldtrip! | Bogdan Lita  |
| 10:30 - 11:00  | Handling clouds in Remote Sensing Data & Using Cloud Masks in `Python`  |    |
| 11:15 - 11:45  | Group activity: Get data from Earth Explorer |    |
|===
| 11:45 - 12:20  | MODIS data in Python - NA values & scale factors - Coding  Session |    |


### 1a. Midterm Groups

Between now and next class, be sure to figure out who you'd like to work with
for your midterm assignment. If you are looking for a group - please add your name
and the project that you have in mind to the Google document. If you know your
group members and project name please add this to the document!

<a class="btn .btn--x-large btn--success" href="https://docs.google.com/document/d/14LNBg_3d33Tkc4XZTKVvHvmyfaV1yGDGc39VwxaCe6g/edit#" target= "_blank"> <i class="fa fa-file-text" aria-hidden="true"></i>
Add your project & group to the class google doc by class next week. </a>

### 1b. Fire Readings

Please read the articles below to prepare for next week's class.

* <a href="http://www.denverpost.com/2016/07/13/cold-springs-fire-wednesday/" target="_blank">Denver Post article on the Cold Springs fire.</a>
* <a href="http://www.nature.com/nature/journal/v421/n6926/full/nature01437.html" target="_blank" data-proofer-ignore=''>Fire science for rainforests -  Cochrane 2003.</a>
* <a href="https://www.webpages.uidaho.edu/for570/Readings/2006_Lentile_et_al.pdf
" target="_blank">A review of ways to use remote sensing to assess fire and post-fire effects - Lentile et al 2006.</a>
* <a href="http://www.sciencedirect.com/science/article/pii/S0034425710001100" target="_blank"> Comparison of dNBR vs RdNBR accuracy / introduction to fire indices -  Soverel et al 2010.</a>


### 2. Complete the Assignment Below (10 points)
Please note that like the flood report, this assignment is worth more points than
a usual weekly assignment. You have 1 week to complete this assignment. Start
early!

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
  
REPORT TEXT??  
3. Write 1-3 paragraphs that describes the Cold Springs fire. Include:
  * 3b. Where and when the fire occurred.
  * 3c. What started the fire.
  * 3d. A brief discussion of how fire impacts the natural vegetation structure of a forest and also humans (i.e. are fires always bad?).
  
SEVERAL MC questions??  
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

##### dNBR burn classes

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
in NDVI using the following table:

| Legend Label| Value range|
|:----|----|
| Decrease NDVI | < -.1 |
| No Significant Change| -.1 to .1 |
|===
| Increase NDVI| >.1 |

dndvi_class = np.digitize(dndvi_landsat, [-np.inf, -.1, .1, np.inf])
ndvi_change_labs = ["Decrease NDVI","No Significant Change","Increase NDVI"]

as you see fit. Overlay the fire extent `vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`
on top of the difference NDVI map. Add a legend that clearly describes each
NDVI difference "class".

Be sure to use cloud free NDVI data.


## Homework Due: Monday November 6, 2017 @ 8AM.
Submit your report in both `.ipynb` and `.html` format to the Canvas dropbox.

</div>

## Grading


#### R Markdown Report Structure & Code: 15%

| Full Credit | No Credit  |
|:----|----|
| `html` / `pdf` and `.ipynb` files submitted |  |
| Code is written using "clean" code practices following the xxx??? |  |
| All code in the notebook runs when "run all cells" is called  |  |
| All required `Python` packages are listed at the top of the document in a code chunk | |
| Lines of code are broken up with commas to make the code more readable  |  |
|===
| Report only contains code pertaining to the assignment |  |

####  Report Questions: 40% <- this may turn into multiple choice for easier grading in CANVAS

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
| Plot has a 2-3 sentence  caption that clearly describes plot contents | |
| Landsat cloud free data (over the study area) are used to derive Landsat based plots | |
| Cloud masks are applied as appropriate to clean up data |  |
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
| Correct band numbers are used to calculate NBR / dnbr |  |
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


## Homework Plot Examples


{:.output}
    file_sizes: 100%|███████████████████████████▉| 446M/446M [48:55<00:00, 11.3kB/s]


{:.output}
{:.execute_result}



    '/Users/leah-su/earth-analytics/data/cs-test-landsat/.'





#### Plot 1 - Grid of Plots: NAIP, Landsat and MODIS

Create a single plot that contains a grid of 3, 3 band color infrared (also called false color) plots using:
images using:

* Post Fire NAIP data
* Post Fire Landsat data
* Post Fire MODIS data

 For each map be sure to:
<!-- In a CIR image, the NIR band is plotted on the “red” band, the red band is plotted using green and the green band is plotted using blue. -->
* Overlay the fire boundary layer (`vector_layers/fire-boundary-geomac/co_cold_springs_20160711_2200_dd83.shp`).
* Use the band combination **r = infrared band**, **g = red band**, **b = green** band.
* Crop each dataset to the fire boundary extent.
* Be sure to label each plot with the data type (NAIP vs. Landsat vs. MODIS) and spatial resolution.

Use this figure to help answer question 1 above.
An example of what this plot should look like (without all of the labels that
you need to add), is below.



{:.output}

    ---------------------------------------------------------------------------

    IndexError                                Traceback (most recent call last)

    <ipython-input-37-b4753654890e> in <module>()
          4 landsat_paths_pre = glob("data/cold-springs-landsat-hw/*band*.tif")
          5 path_landsat_pre_st = 'data/cold-springs-fire/outputs/landsat_pre_st_hw.tif'
    ----> 6 st, sd = es.stack_raster_tifs(landsat_paths_pre, path_landsat_pre_st)
          7 
          8 landsat_paths_post = glob("data/cold-springs-fire/landsat_collect/LC080340322016072301T1-SC20180214145802/crop/*band*.tif")


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/earthpy/spatial.py in stack_raster_tifs(band_paths, out_path)
         73         sources = [context.enter_context(rio.open(path, **kwds)) for path in band_paths]
         74 
    ---> 75         dest_kwargs = sources[0].meta
         76         dest_count = sum(src.count for src in sources)
         77         dest_kwargs['count'] = dest_count


    IndexError: list index out of range



## Homework Plot 1 - Grid of 3 - 3 band CIR plots post fire


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis_7_0.png">

</figure>




## Homework Plots 2: Landsat Difference dNBR



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis_9_0.png">

</figure>




I think what is missing in the plot analytics below is extracting just the pixels in the fire region??
OR potentially the R lessons may be calculating over a diff extent. i'm not sure currently 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis_11_0.png">

</figure>




# Homework Plot 3: MODIS Difference dNBR



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis_13_0.png">

</figure>




{:.input}
```python
# This is erroring because the data don't have all of the classes
fig, ax = plt.subplots(figsize =(11,9))
im = ax.imshow(modis_dnbr_class, 
               cmap=ch_colors_cmap,
               extent=extent_mod)

#ax.set(xlim=(extent_mod[[0,2]]), ylim=(extent_mod[[1,3]]))
ax.set_title('MODIS dNBR - Cold Spring Fire Site \n July 8, 2016 - July 18, 2016', fontsize = 16)

fire_bound_sin.plot(ax=ax, color = 'None', edgecolor = 'black', linewidth=2)

# add legend 
colors = [im.cmap(im.norm(value)) for value in values]
patches = [mpatches.Patch(color = nbr_colors[i], label = "{l}".format(l=dnbr_cat_names[i])) for i in range(len(values))]
plt.legend(handles = patches, bbox_to_anchor = (1.05,1) , loc = 2, borderaxespad = 0.)

ax.set_axis_off();
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis_14_0.png">

</figure>




# Homework Plot 4: Landsat Difference dNDVI



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis_16_0.png">

</figure>




# Homework Plot 5: MODIS Difference dNDVI



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis_18_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/08-multispectral-remote-sensing-fire/2017-01-01-week-08-spectral-remote-sensing-modis_19_0.png">

</figure>



