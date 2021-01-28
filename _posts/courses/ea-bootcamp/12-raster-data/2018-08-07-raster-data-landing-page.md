---
layout: single
category: courses
title: "Introduction to Spatial Raster Data in Open Source Python"
permalink: /courses/earth-analytics-bootcamp/spatial-raster-data-python/
modified: 2021-01-28
week-landing: 1
week: 12
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-bootcamp"
module-type: 'session'
redirect_from:
  - "/courses/earth-analytics-bootcamp/practice-data-structures/"
---


{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to Week {{ page.week }} of the Earth Analytics Bootcamp course! This week, you will write `Python` code in `Jupyter Notebook` to work with spatial raster data. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing the lessons for Week {{ page.week }}, you will be able to:

* Open and plot raster data using xarray in Python 
* Crop raster data using rioxarray
* Manually classify raster data
* Perform basic raster math

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework & Readings

<a href="https://github.com/earthlab-education/bootcamp-2020-11-raster-template" target="_blank"> <i class="fa fa-link" aria-hidden="true"></i> Click here to view the GitHub Repo with the assignment template. </a>{: .btn .btn--info .btn--x-large}


## <i class="fa fa-book"></i> Earth Data Science Textbook Readings

Please read the following chapters of the <a href="https://www.earthdatascience.org/courses/use-data-open-source-python"> Intermediate to Earth Data Science online textbook</a> to support completing this week's assignment:

Please read and watch the following chapters in the of the Intermediate Earth Data Science online textbook to support completing this week's assignment:

* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/fundamentals-raster-data/">Chapters 4 and 5 covering raster data in python</a> 
* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/colorado-floods-2013/">Chapter 20 - a data story about the 2013 Colorado Floods</a>.
* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/data-stories/what-is-lidar-data/">Chapter 21 a data story on lidar remote sensing data</a>.

</div>

## Example Homework Plots

Below are example versions of the plots you will create for your homework.






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/12-raster-data/2018-08-07-raster-data-landing-page/2018-08-07-raster-data-landing-page_7_0.png" alt = "Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.">
<figcaption>Plots of lidar min and max vs insitu min and max with a 1:1 line a regression fit for the NEON SJER field site.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/12-raster-data/2018-08-07-raster-data-landing-page/2018-08-07-raster-data-landing-page_8_0.png" alt = "Histogram of values from the raster plot of the difference in the canopy height model.">
<figcaption>Histogram of values from the raster plot of the difference in the canopy height model.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/12-raster-data/2018-08-07-raster-data-landing-page/2018-08-07-raster-data-landing-page_9_0.png" alt = "Categorized raster of areas that gained or lost elevation after the flood.">
<figcaption>Categorized raster of areas that gained or lost elevation after the flood.</figcaption>

</figure>




{:.input}
```python
# HW plot 6
# PLOT 3: pre/post DTM difference raster histogram

bins = [-15, -5, -2, 0, 2, 5, 15]

diff_dtm = post_dtm_xr_cl - pre_dtm_xr_cl
diff_dsm = post_dsm_xr_cl - pre_dsm_xr_cl

f, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 10), sharey=True)
diff_dtm.plot.hist(bins=bins,
                   ax=ax1)
ax1.set(title="DTM Difference Histogram")

diff_dsm.plot.hist(bins=bins,
                   ax=ax2)
ax2.set(title="DSM Difference Histogram")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/12-raster-data/2018-08-07-raster-data-landing-page/2018-08-07-raster-data-landing-page_10_0.png" alt = "Two histogram plots. The top plot shows the values found in the difference raster of the digital terrain model. The bottom plot shows the values found in the difference raster of the digital surface model.">
<figcaption>Two histogram plots. The top plot shows the values found in the difference raster of the digital terrain model. The bottom plot shows the values found in the difference raster of the digital surface model.</figcaption>

</figure>




