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


## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week 2!

Welcome to week {{ page.week }} of Earth Analytics! In week 02 you will learn how to work with data using `Python` and `Jupyter Notebooks`. You will also learn how to work with time series data. To work with time series data you need to know how to deal with date and time fields and missing data. It is also helpful to know how to subset the data by date.

The data that you use this week is collected by US Agency managed sensor networks. You will use the USGS stream gage network data and NOAA / National Weather Service precipitation data. All of the data you work with were collected in Boulder, Colorado around the time of the 2013 floods.

Read the assignment below carefully. Use the class and homework lessons to help you complete the assignment.
</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class Schedule

| time           | topic                 | speaker |  |  |
|:---------------|:----------------------------------------------------------|:--------|:-|:-|
|  | Review Jupyter Notebooks / Markdown / questions                   | Leah    |  |  |
|    | Python coding session - Intro to Scientific programming with Python | Leah    |  |  |
|   | Break                                                     |         |  |  |
|===
|   | Python coding session continued                                | Leah    |  |  |


## <i class="fa fa-pencil"></i> Homework Week 2

### 1. Download Data

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

## Important - Data Organization
Before you begin this lesson, be sure that you've downloaded the dataset above.
You will need to **unzip** the zip file. When you do this, be sure that your directory
looks like the image below: note that all of the data are within the `week_02`
directory. The data are not nested within another directory. You may have to copy
and paste your files into the correct directory to make this look right.

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/week-02/week-02-data.png">
<img src="{{ site.url }}/images/courses/earth-analytics/week-02/week-02-data.png" alt="week 2 file organization">
</a>
<figcaption>Your `week_02` file directory should look like the one above. Note that
the data directly under the week_02 folder.</figcaption>
</figure>



### Why Data Organization Matters

It is important that your data are organized as specified in the lessons because:

1. When the instructors grade your assignments, we will be able to run your code if your directory looks like the instructors'.
1. It will be easier for you to follow along in class if your directory is the same as the instructors.
1. It is good practice to learn how to organize your files in a way that makes it easier for your future self to find and work with your data!

### 2. Videos

Watch the following videos:

#### The Story of Lidar Data Video
<iframe width="560" height="315" src="//www.youtube.com/embed/m7SXoFv6Sdc?rel=0" frameborder="0" allowfullscreen></iframe>

#### How lidar works
<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework (5 points): Due  @ 8pm


1. Create a Jupyter Notebook Document
Create a new Jupyter Notebook Document. Name it: youLastName-yourFirstName-week02.ipynb

2. Add the Text That You Wrote Last Week About the Flood Events
Add the text that you wrote for the first homework assignment to the top of your report. Then think about where in that text the plots below might fit best to better describe the events that occurred during the 2013 floods.

3. Add 4 Plots to Your Jupyter Notebook Document
Add the plots described below to your Jupyter Notebook Document. IMPORTANT Please add a figure caption to each plot that describes the contents of the plot.

Add the code to produce the following 4 plots in your Jupyter Notebook Document, using the homework lessons as a guide to walk you through. Use the pipes syntax that you learned in class to subset and summarize the data as required.

** Use the data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv file to create:**

#### PLOT 1:  

Precipitation from 2003 to 2013 using `matplotlib` function.


#### PLOT 2: 

A plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`. Make sure that `x axis` for this plot has large ticks for each new week day and small ticks for each day. Label the plot using the format `Month Date`. Each label should look like:

* `Aug 20`
* `Aug 27`

**Use the `data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.csv` file to create:**

#### PLOT 3: 

A plot of stream discharge from 1986 to 2013 using  `matplotlib`


#### PLOT 4: 

A plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013 using the `matplotlib`. Make sure that x axis for this plot has large ticks for each new week day and small ticks for each day similar to plot 2 above.

* `Aug 20`
* `Aug 27`

#### PLOT 5: 

**Use the `data/colorado-flood/precipitation/805333-precip-daily-1948-2013.csv` file.** 

Create a plot of precipitation, summarized by daily total (sum) precipitation subsetting to Jan 1 - Oct 15 2013.
Be sure to do the following:

1. Subset the data temporally: Jan 1 2013 - Oct 15 2013.
2. Summarize the data: plot DAILY total (sum) precipitation.
3. Format the x axis with a major tick and label for every 10 years starting at 1950.

Use the [bonus lesson]({{ site.url }}/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/aggregate-time-series-data-python/) to guide you through creating this plot.

#### Grad Students Only: PLOTS 6-7

In addition to the plots above, add a plot of precipitation that spans from 1948 - 2013 using the 805333-precip-daily-1948-2013.csv file. For your plot be sure to:

* Subset the data temporally: Jan 1 2013 - Oct 15 2013.
* Make sure that x axis for this plot has large ticks for each new week day and small ticks for each day.
* Summarize the data: plot DAILY total (sum) precipitation.
* Important: be sure to set the time zone as you are dealing with dates and times which are impacted by daylight saving time. Add: tz = "America/Denver" to any statements involving time - but specifically to the line of code where you convert date / time to just a date!
* Identify an anomaly or change in the data that you can clearly see when you plot it. Then fix that anomly to make the plot more uniform. See example below for guidance!


###  For all your plots be sure to do the following
* Label Plots Appropriately
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
* Show all of your code in the output .html file.
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

* **PLOT 1:** a plot of precipitation from 2003 to 2013 using `matplotlib`.
* **PLOT 2:** a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`.
* **PLOT 3:** a plot of stream discharge from 1986 to 2013 using `matplotlib`.
* **PLOT 4:** a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`.
***
* **PLOT 5 & 6:** (GRAD STUDENTS ONLY): a plot of precipitation that spans from 1948 - 2013

The plots listed above will be reviewed for various aesthetics as follows:

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Plot is labeled with a title, x and y axis label  | | |
| Plot is coded using the matplotlib library.) |  | |
| Date on the x axis is formatted as a date class for all plots  |  | Dates are not properly formatted |
| Missing data values have been cleaned / replaced with `NA` |   | Missing values have not been cleaned  |
| Code to create the plot is clearly documented with comments in the html  |  | Code isn't commented |
|===
| Plot is described and interpreted in the text of the report with reference made to how the data demonstrate an impact or driver of the flood event |  | Plot is not discussed and interpreted in the text   |
| For plots 2, 4, and 5 correctly format x axis with ticks | x axis not correctly formatted

#### Plot Subsetting

Plots 2 and 4 should be temporally subsetted to the dates listed above.

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Plot 2 is temporally subsetted using to Aug 15 - Oct 15 2013 |  |  |
|===
| Plot 4 is temporally subsetted using  to Aug 15 - Oct 15 2013 |  |  |

#### Grad Plot Only

Plots 2 and 4 should be temporally subsetted to the dates listed above.

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



