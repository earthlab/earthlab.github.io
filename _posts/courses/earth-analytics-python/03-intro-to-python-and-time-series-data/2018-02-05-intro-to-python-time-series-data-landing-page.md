---
layout: single
category: courses
title: "Time Series Data in Python"
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/
modified: 2018-11-27
week-landing: 1
week: 3
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Earth Analytics Python - Week 3!

Welcome to week {{ page.week }} of Earth Analytics! This week you will learn how to work with and plot time series data using `Python` and `Jupyter Notebooks`. You will learn how to:

* Import text files that are tab delimted and comma separated into pandas.
* Handle different date and time fields and formats in `Pandas` 
* Set a `datetime` field as an index when importing your data
* Calulate the return time for a flood event.
* Subset time series data by date
* Handle missing data values in `pandas`.


## What You Need

You will need the Colorado Flood Teaching data subset and a computer with Anaconda Python 3.x and the `earth-analytics-python` environment installed to complete this lesson

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

The data that you use this week was collected by US Agency managed sensor networks and includes:

* USGS stream gage network data and
* NOAA / National Weather Service precipitation data. 

All of the data you work with were collected in Boulder, Colorado around the time of the 2013 floods.

Read the assignment below carefully. Use the class and homework lessons to help you complete the assignment.
</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class Schedule

| time           | topic                 | speaker |  |  |
|:---------------|:----------------------------------------------------------|:--------|
|  | Review Jupyter Notebooks / Raster data in Python / questions                   | Leah    |  
|    | Python coding session - Time Series Data in Pandas - Python | Leah   |
|   | Break                                                     |         | 
|   | Speaker - Matt Rossi - Understanding Floods   |   Matt Rossi      | 
|===
|   | Return Time Activity                               | Leah & Matt  |


## <i class="fa fa-pencil"></i> Week 3


## Important - Data Organization

After you have downloaded the data for this week, be sure that your directory is setup as specified below.

If you are working on your computer, locally, you will need to **unzip** the zip file. 
When you do this, be sure that your directory
looks like the image below: note that all of the data are within the `colorado-flood`
directory. The data are not nested within another directory. You may have to copy
and paste your files into the correct directory to make this look right.

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/week-02-data.jpg">
<img src="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/week-02-data.jpg" alt="Your `week_02` file directory should look like the one above. Note that
the data directly under the colorado-flood folder.">
</a>
<figcaption>Your `colorado-flood` file directory should look like the one above. Note that
the data directly under the colorado-flood folder.</figcaption>
</figure>

If you are working in the Jupyter Hub or have the earth-analytics-python environment installed on your computer, you can use the `earthpy` download function to access the data. Like this:

```python
import earthpy as et
et.data.get_data("colorado-flood")
```

### Why Data Organization Matters

It is important that your data are organized as specified in the lessons because:

1. When the instructors grade your assignments, we will be able to run your code if your directory looks like the instructors'.
1. It will be easier for you to follow along in class if your directory is the same as the instructors.
1. Your notebook becomes more reproducible if you use a standard working directory. Most computing environments have a default `home` directory. It is good practice to learn how to organize your files in a way that makes it easier for your future self to find and work with your data!

<!-- 
### 2. Videos

Please watch the following short videos before the start of class next week. They will help you prepare for class! 

#### The Story of Lidar Data Video
<iframe width="560" height="315" src="//www.youtube.com/embed/m7SXoFv6Sdc?rel=0" frameborder="0" allowfullscreen></iframe>

#### How Lidar Works
<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>
-->


## Homework Plots

Please visit CANVAS for the assignment and grading rubric. Below are examples of what your plots should look like.
Note that you can modify the colors, style, etc of your plots as you'd like. These plots are just examples to help you visually check your homework. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_3_0.png" alt = "Homework plot of Monthly max discharge data.">
<figcaption>Homework plot of Monthly max discharge data.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_4_0.png" alt = "Homework plot of Daily max discharge data.">
<figcaption>Homework plot of Daily max discharge data.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_5_0.png" alt = "Homework plot of Monthly total precipitation data.">
<figcaption>Homework plot of Monthly total precipitation data.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_6_0.png" alt = "Homework plot of Daily total discharge data.">
<figcaption>Homework plot of Daily total discharge data.</figcaption>

</figure>




Note: to plot the y axis on a log scale use the argument: `logy= True` in your pandas `.plot()` call. If you use matplotlib to plot the data then you will want to calculate the log value in a new column and plot that.


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_8_0.png" alt = "Probabilty of Stream discharge events plot.">
<figcaption>Probabilty of Stream discharge events plot.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_9_0.png" alt = "Return period for stream discharge events plot.">
<figcaption>Return period for stream discharge events plot.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_10_0.png" alt = "Probabiltiy for precipitation events plot.">
<figcaption>Probabiltiy for precipitation events plot.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_11_0.png" alt = "Return period for precipitation events plot.">
<figcaption>Return period for precipitation events plot.</figcaption>

</figure>



