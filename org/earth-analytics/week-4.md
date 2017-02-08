---
layout: single
category: course-materials
title: "Week 4: Spatial Data in R"
permalink: /course-materials/earth-analytics/week-4/
week-landing: 4
week: 4
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

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the data for week 4 of the course.

[<i class="fa fa-download" aria-hidden="true"></i> Download Week 4 Data (~500 MB)](https://ndownloader.figshare.com/files/7525363){:data-proofer-ignore='' .btn }

</div>

|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 3:00 pm  | Review r studio / r markdown / questions  | Leah  |
| 3:20 - 4:00  | Open Topography / lidar data | Chris Crosby, UNAVCO / Open Topography  |
| 4:15 - 5:50  | R coding session - Use lidar to characterize vegetation / uncertainty | Leah  |

### 1. Complete the assignment below

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission

### Produce a .pdf report

Create a new `R markdown `document. Name it: **lastName-firstInitial-week4.Rmd**
Within your `.Rmd` document, include the plots listed below.

When you are done with your report, use `knitr` to convert it to `PDF` format (note:
if you did not get `knitr` working it is ok if you create an html document and
export it to pdf as we demonstrated in class). You will submit both
the `.Rmd` file and the `.pdf` file. Be sure to name your files as instructed above!

In your report, include the plots below. Be sure to describe what each plot shows. Also include a section where you answer the questions below.

### Answer the following questions

1. In your own words, describe what a Coordinate Reference System (CRS) is and what the key components of a crs are. If you are working with two datasets that are stored using difference CRSs, and want to process or plot them, what do you need to do to ensure they line up on a map and can be processed together?
2. In this class we learned about lidar and canopy height models. We then compared height values extracted from a canopy height model compared to height values measured by humans at each study site. Are the values the same? Why or why not? Use the plots to discuss why they values are similar / different. Then discuss what factors may result in the values being different.
3. What are metadata? How was metadata useful or not useful for this assignment?


### Plot 1: Study area map

Create a map of our SJER study area as follows:

1. Import the `madera-county-roads/tl_2013_06039_roads.shp` layer located in your week4 data download. Adjust line width as necessary.
2. Create a map that shows the madera roads layer, sjer plot locations and the sjer_aoi boundary. All data should be CROPPED to the sjer_aoi boundary.
3. Plot the roads by road type and add each type to the legend. Place visual emphasize on the County and State roads by adjusting the line width and color. HINT: use the metadata included in your data download to figure out what each type of road represents ("C", "S", etc.). [Use the homework lesson on custom legends]({{ site.url }}/course-materials/earth-analytics/week-4/r-custom-legend/) to help build the legend.
5. Be sure to adjust the LABELS on your legend to be meaningful. Road labels in the legend should specify the type of road as a readable form rather than the representative letter found in the data (e.g. "C", "S", etc.).
6. Add a **title** to your plot.
7. Add a **legend** to your plot that shows both the road types and the plot locations.

IMPORTANT: be sure that all of the data are within the same `EXTENT` and `crs` of the `sjer_aoi`
layer. This means that you may have to CROP and reproject your data prior to plotting it!

**BONUS!!!:** Plot the vegetation plots by type - adjust the symbology of the plot locations (choose a symbol using `pch` for each type and adjust the color of the points). Make sure your legend matches the colors and symbols in your plot! Also make sure your plot renders OUTSIDE of the plot extent (not on top of the map itself). Finally - see if you can figure out how to add a space in between the symbols for road types and plots types to your legend - similar
to the plot on the bottom of the (custom legend lesson)[https://earthlab.github.io/course-materials/earth-analytics/week-4/r-custom-legend/].

### Plot 2: Field site locations

Create a plot of field site locations layered on top of the canopy height model
for the SJER field site.

* Each plot symbol should be SIZED relatively according
to **maximum** tree height for that site location. NOTE: you may want to normalize the size
to make this plot look nice. You could normalize by average tree height across
all sites or simply divide by 10 or some number that makes the symbols look good
in the map.
* Select a coloramp for the canopy height model that looks nice. NOTE:
you may have to use google to figure out how to change the colors.
* Be sure to use a descriptive title that tells someone what the point sizing represents.

### Plot 3: Scatterplot CHM vs In situ
Create a scatter plot using `ggplot()` that compares MAXIMUM canopy height model height in meters,
extracted within a 20 meter radius, compared to **maximum** tree height derived from the
*in situ* field site data. Note: in the lessons we compared MEAN tree height, you should calculate MAX for this homework.

Be sure to
* Label x and y axes (including units)
* Give the plot a descriptive title - this title should include the location of the study area.
* Add some text that describes what the plot shows. NOTE: this relates to the question asked above about the differences between lidar tree height compared to human measured tree height.

### Plot 4: CHM vs In situ difference
Create a bar plot using `ggplot()` that shows the DIFFERENCE between the extracted Max canopy height
model height compared to in situ height per plot. Be sure to give the plot a title and label axes with units as necessary.

## Homework due: Feb 15 @ noon.
Submit your report in both `.Rmd` and `.PDF` format to the D2l dropbox by NOON Wednesday 8
February 2017.

</div>


## Grading Rubric

### Report content - text writeup - 10%

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| PDF and RMD submitted | Both files are submitted  | Only one of the 2 files are submitted  | NA |
| Summary text is provided for each plot | Summary text is provided for all of the plots in the report. | Summary text is missing for 1-2 plots in the report. | Summary text is not included for 3 or more plots.  |
| Grammar & spelling are accurate throughout the report| No visible grammar or spelling issues in the report| 2-4 grammar and spelling issues in the report| More than 4 spelling / grammar issues in the report |
| File is named with last name-first initial week 3| File name contains last name_firstinitial and the assignment name / number. (some variation is ok if it's consistent) | File name contains name but not assignment name / number or vice versa | File is not named properly|
| Report contains all plots described in the assignment| All plots are included in the report| 1 plot is missing| More than 1 plot is missing |

### Report content - questions are answered - 20%

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Describe what a Coordinate Reference System (CRS) is - answered correctly | Question is partially answered correctly. | Question is mostly incorrect but parts are correct. | Question is not answered |
| Discussion of canopy height model values compared to measured. Are the values the same. Discussion is thoughtful and addresses whether the data are similar or different. | Question is partially answered correctly. | Question is mostly incorrect but parts are correct. | Question is not answered |
| What are metadata? How was metadata useful or not useful for this assignment? - question is answered thoughtfully and thoroughly | Question is partially answered correctly. | Question is mostly incorrect but parts are correct. | Question is not answered |


### Report content - code format - 10%

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Code is written using "clean" code practices following the Hadley Wickham style guide| Spaces are placed after all # comment tags, variable names do not use periods, or function names. | Clean coding is used in some of the code but spaces or variable names are incorrect 2-4 times| clean coding is not implemented consistently throughout the report. |
| YAML contains a title, author and date | Author, title and date are in YAML | One element is missing from the YAML | 2 or more elements are missing from the YAML |
| Code chunk contains code and runs  | All code runs in the document  | There are 1-2 errors in the code in the document that make it not run | The are more than 3 code errors in the document |
| All required R packages are listed at the top of the document in a code chunk.  | All libraries are listed at the top of the .Rmd in a code chunk. | Some libraries are at the top and some are lower down. | NA |


### Report content - plot code & interpretation - 60%

#### PLOT 1 - Study area map

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Study area map is included in the report | NA | NA | Plot is missing|
| Map contains an appropriate  title | Map contains a title but the title doesn't represent the content of the map. | NA | Map is missing a title |
| Roads layer is correctly plotted by type. | Roads are plotted by type but the type is incorrect. | Roads are plotted but not by type | Roads are missing from the map |
| Legend is included in the plot. Legend shows the various road types using correct symbology. | Legend is on the map, some of the labels / colors are incorrect. | Legend is on the map, many to most of the labels on it are incorrect. | There is no legend on the map. |
| Data in the study area map are cropped to the study area crop extent layer. | NA | NA | Data are not cropped |
| All layers are included in the map: Crop extent polygon, study site plot locations (points) and roads) | Map is missing one of the required data layers. | NA | More than 1 layer is missing from the map. |

#### PLOT 2 - Field site locations sized by tree height

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Plot is included in the report. | NA | NA | Plot is missing|
| Map contains an appropriate  title | Map contains a title but the title doesn't represent the content of the map. | NA | Map is missing a title |
| Plot locations are correctly sized by maximum tree height. | Plot locations are sized differently, but not correctly by maximum tree height. | NA | Plot locations are not sized relatively according to the site tree height. |
| A descriptive title exists on the plot that tells someone what the point sizing represents. | A title is added to the plot but it does not describe the plot well. | NA | The plot title is not descriptive / useful in identifying what the plot shows. |
| A color gradient has been added to the canopy height model. | NA | NA | No changes have been made to the color representation of the canopy height model. |


#### PLOT 3 - Scatterplot max tree height lidar vs in situ

*Create a scatter plot using ggplot() that compares MAXIMUM canopy height model height in meters, extracted within a 20 meter radius, compared to maximum tree height derived from the in situ field site data.*

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Plot is included in the report. | NA | NA | Plot is missing|
| Plot contains an appropriate title | Map contains a title but the title doesn't represent the content of the map. | NA | Map is missing a title |
| Plot x and y axes are labeled appropriately and include units.  |NA | NA | Axes are not labeled |
| A descriptive title exists on the plot that tells someone what the plot represents. | A title is added to the plot but it does not describe the plot well. | NA | The plot title is not descriptive / useful in identifying what the plot shows. |
| There is text that describes what the plot shows and answers the question addressed above relating to lidar vs measured tree heights. | NA | NA | There is no text describing the plot. |
| Plot compares maximum lidar derived tree height vs max in situ measured tree height. | NA | NA | Another variable is plotted rather than max height (eg average). |


#### PLOT 4 - Scatterplot max tree height lidar vs in situ

*Create a bar plot using ggplot() that shows the DIFFERENCE between the extracted maximum canopy height model height compared to in situ height per plot.*

|  Full Credit | Partial Credit | Partial Credit | No Credit|
|---|---|---|---|---|
| Plot is included in the report. | NA | NA | Plot is missing |
| Plot is created using ggplot(). | NA | NA | Plot is not created using ggplot() |
| Plot x and y axes are labeled appropriately and include units.  |NA | NA | Axes are not labeled |
| A descriptive title exists on the plot that tells someone what the plot represents. | A title is added to the plot but it does not describe the plot well. | NA | The plot title is not descriptive / useful in identifying what the plot shows. |
| There is text that describes what the plot shows and answers the question addressed above relating to lidar vs measured tree heights. | NA | NA | There is no text describing the plot. |
| Plot is created using the correct variables (maximum lidar derived tree height vs max in situ measured tree height). | NA | NA | Another variable is plotted rather than max height (eg average). |

### Bonus - 1 point
1 pt BONUS: study area plot is customized with vegetation plots by type and a legend outside of the plot axes.
