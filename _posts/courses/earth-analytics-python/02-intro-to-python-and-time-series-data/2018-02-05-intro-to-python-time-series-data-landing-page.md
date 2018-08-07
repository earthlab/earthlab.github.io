---
layout: single
category: courses
title: "Intro to Python and Work with Time Series Data"
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/
week-landing: 1
week: 2
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Earth Analytics Python - Week 2!

Welcome to week {{ page.week }} of Earth Analytics! This week you will learn how to work with and plot time series data using `Python` and `Jupyter Notebooks`. You will learn how to 

1. handle different date and time fields and formats 
2. how to handle missing data and finally
3. how to subset time series data by date


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
|  | Review Jupyter Notebooks / Markdown / questions                   | Leah    |  
|    | Python coding session - Intro to Scientific programming with Python | Leah   |
|   | Break                                                     |         | 
|===
|   | Python coding session continued                                | Leah  |


## <i class="fa fa-pencil"></i> Homework Week 2


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

If you are working in the Jupyter Hub or have the earth-analytics-python environment installed on yoru computer, you can use the `earthpy` download function to access the data. Like this:

```python
import earthpy as et
et.data.get_data("colorado-flood")
```

### Why Data Organization Matters

It is important that your data are organized as specified in the lessons because:

1. When the instructors grade your assignments, we will be able to run your code if your directory looks like the instructors'.
1. It will be easier for you to follow along in class if your directory is the same as the instructors.
1. It is good practice to learn how to organize your files in a way that makes it easier for your future self to find and work with your data!

### 2. Videos

Please watch the following short videos before the start of class next week. They will help you prepare for class! 

#### The Story of Lidar Data Video
<iframe width="560" height="315" src="//www.youtube.com/embed/m7SXoFv6Sdc?rel=0" frameborder="0" allowfullscreen></iframe>

#### How Lidar Works
<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework 2 (5 points): Due  TBD

1. Create a new Jupyter Notebook document named **youLastName-yourFirstName-time-series.ipynb**

2. Add Plots to Your Jupyter Notebook Document

Write code to create the plots described below to your Jupyter Notebook Document. Add 2-3 sentences of text below each plot in a new markdown cell that describes the contents of each plot. Use the course lessons posted on this website and the in class lectures to help. 

Please note that you will complete some of the plots assigned in the homework during class. 


### Homework Plots


#### PLOT 1:  

Use the `data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv` file to plot precipitation from 2003 to 2013 in colorado using `matplotlib`.

#### PLOT 2: 

Use the `data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv` file  to create a precipitation plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`. Make sure that `x axis` for this plot has large ticks for each new week day and small ticks for each day. Label the plot using the format `Month Date`. Each label should look like:

* `Aug 20`
* `Aug 27`

#### PLOT 3: 

Use the `data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.csv` file to create a plot of stream discharge from 1986 to 2013 using  `matplotlib`


#### PLOT 4: 

Use the `data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.csv` file to create a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013 using the `matplotlib`. Make sure that x axis for this plot has large ticks for each new week day and small ticks for each day similar to plot 2 above.

* `Aug 20`
* `Aug 27`

#### PLOT 5:

Use the `data/colorado-flood/precipitation/805333-precip-daily-1948-2013.csv` file to create a plot of precipitation, summarized by daily total (sum) precipitation subsetting to Jan 1 - Oct 15 2013.
Be sure to do the following:

1. Subset the data temporally: Jan 1 2013 - Oct 15 2013.
2. Summarize the data: plot DAILY total (sum) precipitation.
3. Format the x axis with a major tick and label for every 10 years starting at 1950.

Use the [bonus lesson]({{ site.url }}/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/aggregate-time-series-data-python/) to guide you through creating this plot.

#### PLOTS 6-7

Use the `805333-precip-daily-1948-2013.csv` file to create a plot of precipitation that spans from 1948 - 2013 file.
For your plot be sure to:

* Subset the data temporally: Jan 1 2013 - Oct 15 2013.
* Make sure that x axis for this plot has large ticks for each new week day and small ticks for each day.
* Summarize the data: plot DAILY total (sum) precipitation.
* Important: be sure to set the time zone as you are dealing with dates and times which are impacted by daylight saving time. Add: tz = "America/Denver" to any statements involving time - but specifically to the line of code where you convert date / time to just a date!
* Identify an anomaly or change in the data that you can clearly see when you plot it. Then fix that anomly to make the plot more uniform. See example below for guidance!


###  Do The Following For All Plots

Make sure you have the following for each of the plots listed above:

* Label Plot axes and add titles as appropriate
* Be sure that each plot has:

    * A figure caption that describes the contents of the plot.
    * X and Y axis labels that include appropriate units.
    * A carefully composed title that describes the contents of the plot.
    * Below each plot, describe and interpret what the plot shows. Describe how the data demonstrate an impact and / or a driver of the 2013 flood event.
    * Label each plot clearly. This includes a title, x and y axis labels.

* Write Clean Code
    * Be sure that your code follows the style guidelines outlined in the [write clean code lessons]({{ site.url }}/courses/earth-analytics/time-series-data/write-clean-code-with-python/)This includes comments that document / describe the steps you take in your code and clean syntax following Hadley Wickham's style guide.

* Convert date fields as appropriate.
* Clean no data values as appropriate.
* Show all of your code in the output `.html` file.

#### HINT - Set Uniform Plot Styles 

You can specify the fonts and title sizes of all plots in a notebook using the following syntax:
```python
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 18
plt.rcParams['axes.labelsize'] = 14
```
Above you set the figure size, title size, x and y axes labels for all plots. Give it a try!
</div>

## Report Grade Rubric

### Report Content - Text Writeup: 30%

| Full credit |   | No credit |
|:-----|:--------|:----------|
| .ipynb and html submitted  |     |   |
| Summary text is provided for each plot |   | |
| Grammar & spelling are accurate throughout the report |  |  |
| File is named with last name-first initial week 2  |   |  |
| Report contains all 4 plots described in the assignment |  |  |
| 2-3 paragraphs exist at the top of the report that summarize the conditions and the events that took place in 2013 to cause a flood that had significant impacts |  |     |
| Introductory text at the top of the document clearly describes the drivers and impacts associated with the 2013 flood event  |  |  |
|===
| Introductory text at the top of the document is organized, clear and thoughtful.  |  | |


### Report Content - Code Format: 20%

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Code is written using "clean" code practices following the Hadley Wickham style guide. This includes (but is not limited to) spaces after # tags, avoidances of `.` in variable / object names and sound object naming practices |  | |
| First markdown cell contains a title, author and date |  | |

| Code chunk contains code and runs and produces the correct output |   |  |  |


### Report Plots: 50%


#### Plot Aesthetics

All plots listed above will be reviewed for aesthetics as follows:

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Plot is labeled with a title, x and y axis label  | | |
| Plot is coded using the matplotlib library.) |  | |
| Date on the x axis is formatted as a date class for all plots  |  | |
| Missing data values have been cleaned / replaced with `NA` |   |  |
| Code to create the plot is clearly documented with comments in the html  |  | |
|===
| Plot is described and interpreted in the text of the report with reference made to how the data demonstrate an impact or driver of the flood event |  |   |
| For plots 2, 4, and 5 correctly format x axis with ticks | |

#### Plot Subsetting

Plots 2 and 4 should be temporally subsetted to the dates listed above.

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Plot 2 is temporally subsetted using to Aug 15 - Oct 15 2013 |  |  |
|===
| Plot 4 is temporally subsetted using  to Aug 15 - Oct 15 2013 |  |  |

#### Plots 6-7

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Plot 6 shows a plot with the data anomoly identified and fixed |  |  |
|===
|  |  |  |

***



## Homework Plots


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_5_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_6_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_7_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_8_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_9_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_10_0.png">

</figure>



