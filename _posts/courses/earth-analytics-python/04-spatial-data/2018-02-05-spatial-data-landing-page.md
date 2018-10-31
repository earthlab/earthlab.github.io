---
layout: single
category: courses
title: "Introduction to Shapefiles and Vector Data in Open Source Python"
permalink: /courses/earth-analytics-python/spatial-data-vector-shapefiles/
week-landing: 4
week: 4
modified: 2018-10-23
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

Welcome to week {{ page.week }} of Earth Analytics! This week, you will dive deeper into working with spatial data in `Python`. You will learn how to handle data in different coordinate reference systems, how to create custom maps and legends and how to extract data from a raster file. You are on your way towards integrating many different
types of data into your analysis which involves knowing how to deal with things
like coordinate reference systems and varying data structures.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the
spatial-vector-lidar data subset created for the course. Note that the data  download below is large (172MB)
however it contains data that you will use for the next 2 weeks!

{% include/data_subsets/course_earth_analytics/_data-spatial-lidar.md %}


</div>

| Time  | Topic | Speaker |  |  |
|:--------------|:-------|:--------|:-|:-|
| 9:30 AM   | Questions / `Python`   | Leah |  |  |
| 9:45 - 10:15  | Coordinate reference systems & spatial metadata 101 |  |  |  |
| 10:25 - 12:20 | `Python` coding session - spatial data in `Python`  | Leah |  |  |

<!-- 
### 1. Complete the Assignment Below

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework (5 points): Due 

### Produce a Report

Create a new `Jupyter Notebook` document. Name it: **lastName-firstInitial-week4.ipynb**
Within your `.ipynb` document, include the plots listed below.

You will submit an `.ipynb` file. Be sure to name your file as instructed above!

In your report, include the plots below. The important part of this week is that you document each step of your workflow using comments. And that you break up the sections of your analysis into SEPARATE code chunks.
 




### Submit to D2L

Submit your report in both `.ipynb` and `.html` format to the D2l week 4 dropbox by 

</div>

## .html Report Structure & Code: 20%

| Full Credit | No Credit  |
|:----|----|
| .ipynb file submitted  |   |   |
| Code is written using "clean" code practices following the Python PEP 8 style guide |  |  |
| First markdown cell contains a title, author and date  | |
| All cells contain code that run   |  |
| All required `Python` packages are listed at the top of the document in a code chunk. |     |


## PLOT: Map of Madera County with Roads 40%

| Full Credit | No Credit  |
|:----|----|
| Roads, plot locations & AOI boundary are included on the map  |   |   |
| Road lines are symbolized by type |  |  |
| Plot location points are symbolized by type | |
| Plots has a title that clearly defines plot contents   |  |
| Plots have a 2-3 sentence caption that clearly describes plot contents |     |
| Plot legend is next to the map (on the side or below) and doesn't overlay the plot contents |     |
| Plot legend is formatted with the correctly symbology that matches the map and is easy to read |     |

## PLOT: Map of Madera County with Roads 30%

| Full Credit | No Credit  |
|:----|----|
| Road length for each county is correct  |   |   |
-->


## Plot 1 - Roads Map and Legend


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_4_0.png" alt = "Map showing the SJER field site roads and plot locations clipped to the site boundary.">
<figcaption>Map showing the SJER field site roads and plot locations clipped to the site boundary.</figcaption>

</figure>




## Plot 2 - Roads in Del Norte, Modoc & Siskiyou Counties in California



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_6_0.png" alt = "Map showing the roads layer clipped to the three counties and colored according to which county the road is in.">
<figcaption>Map showing the roads layer clipped to the three counties and colored according to which county the road is in.</figcaption>

</figure>




## Plot 3 - Quantile Map for The USA



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_8_0.png" alt = "Total land and total water aggregated by region in the United States.">
<figcaption>Total land and total water aggregated by region in the United States.</figcaption>

</figure>




## Plot 4

You can use the code below to download and unzip the data from the Natural Earth website.
Please note that the download function was written to take

1. a download path - this is the directory where you want to store your data
2. a url - this is the URL where the data are located. The URL below might look odd as it has two "http" strings in it but it is how the url's are organized on natural earth and should work. 

The `download()` function will unzip your data for you and place it in the directory that you specify. 

{:.input}
```python
# Add this line importing the download package to your top cell with the other packages!
from download import download

# Get the data from natural earth
url = "https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip"

# Please note that this is the directory name where your data will be unzipped
download_path = os.path.join("data", "spatial-vector-lidar", "global","ne_10m_admin_0_countries")
download(url, download_path, kind='zip', verbose=False)
country_path = os.path.join(download_path, "ne_10m_admin_0_countries.shp")
```


{:.output}
    /Users/leah-su/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/pandas/core/reshape/merge.py:544: UserWarning: merging between different levels can give an unintended result (1 levels on the left, 2 on the right)
      warnings.warn(msg, UserWarning)




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/04-spatial-data/2018-02-05-spatial-data-landing-page_12_0.png" alt = "Natural Earth Global Mean population rank and total estimated population">
<figcaption>Natural Earth Global Mean population rank and total estimated population</figcaption>

</figure>



