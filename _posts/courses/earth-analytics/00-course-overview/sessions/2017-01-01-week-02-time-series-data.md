---
layout: single
category: courses
title: "Intro to R & work with time series data"
permalink: /courses/earth-analytics/time-series-data/
modified: '2017-09-06'
week-landing: 2
week: 2
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics"
module-type: 'session'
---

{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week 2!

Welcome to week {{ page.week }} of Earth Analytics! In week 02 we will learn how to work with
data in `R` and `RStudio`. We will also learn how to work with time series data.
To work with time series data you need to know how to deal with date and time fields and
missing data. It is also helpful to know how to subset the data by date.

The data that we use this week is collected by US Agency managed sensor networks.
We will use the USGS stream gage network data and
NOAA / National Weather Service precipitation data.
All of the data we work with were collected in Boulder, Colorado around the time
of the 2013 floods.

Read the assignment below carefully. Use the class and homework lessons to help
you complete the assignment.
</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class schedule

| time           | topic                                                     | speaker |  |  |
|:---------------|:----------------------------------------------------------|:--------|:-|:-|
| 9:30 - 9:45 AM | Review RStudio / R Markdown / questions                   | Leah    |  |  |
| 9:45 - 10:45   | R coding session - Intro to Scientific programming with R | Leah    |  |  |
| 10:45 - 11:00  | Break                                                     |         |  |  |
| 11:00 - 12:20  | R coding session continued                                | Leah    |  |  |


## <i class="fa fa-pencil"></i> Homework Week 2

### 1. Download data

[<i class="fa fa-download" aria-hidden="true"></i> Download week 02 data](https://ndownloader.figshare.com/files/7426738){:data-proofer-ignore='' .btn }

## Important - Data Organization
Before you begin this lesson, be sure that you've downloaded the dataset above.
You will need to **unzip** the zip file. When you do this, be sure that your directory
looks like the image below: note that all of the data are within the **week_02**
directory. The data are not nested within another directory. You may have to copy
and paste your files into the correct directory to make this look right.

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/week-02/week-02-data.png">
<img src="{{ site.url }}/images/courses/earth-analytics/week-02/week-02-data.png" alt="week 2 file organization">
</a>
<figcaption>Your `week_02` file directory should look like the one above. Note that
the data directly under the week_02 folder.</figcaption>
</figure>

### Why data organization matters

It is important that your data are organized the same as the rest of the classes
because:

1. When the instructors grade your assignments, we will be able to run your code if your directory looks like the instructors.
1. It will be easier for you to follow along in class if your directory is the same as the instructors.
1. It is good practice to learn how to organize your files in a way that makes it easier for your future self to find and work with your data!

### 2. Videos

Watch the following videos:

#### The Story of LiDAR Data video
<iframe width="560" height="315" src="//www.youtube.com/embed/m7SXoFv6Sdc?rel=0" frameborder="0" allowfullscreen></iframe>

#### How LiDAR Works
<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>


### 3. Install QGIS & review homework lessons

Install **QGIS**. Use the install QGIS homework lesson as a guide if needed.
Then review all of the homework lessons - they will help you complete the
submission below.

***


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework submission: due Friday Sept 15 @ 8pm)

#### 1. Create R Markdown document

Create a new `R Markdown` document. Name it: `youLastName-yourFirstName-week2.rmd`

#### 2. Add the text that you wrote last week about the flood events

Add the text that you wrote for the first homework assignment to the top of your report.
Then think about where in that text the plots below might fit best to better describe
the events that occurred during the 2013 floods.

#### 3. Add 4 plots to your R Markdown document

Add the plots described below to your R Markdown file. **IMPORTANT** Please add a
figure caption to each plot that describes the contents of the plot.

Add the code to produce the following 4 plots in your `R Markdown` document, [using the homework lessons
as a guide to walk you through]({{ site.url }}/courses/earth-analytics/week-2/hw-ggplot2-r).

Use the `data/week_02/precipitation/805325-precip-dailysum-2003-2013.csv` file to create:

* **PLOT 1:** a plot of precipitation from 2003 to 2013 using `ggplot()`.
* **PLOT 2:** a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013

Use the `data/week_02/discharge/06730200-discharge-daily-1986-2013.csv` file to create:

* **PLOT 3:** a plot of stream discharge from 1986 to 2016 using `ggplot()`.
* **PLOT 4:** a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013

Note: If you did the challenge activities, you have already created these plots.

#### For all your plots be sure to do the following

### Label plots appropriately

Be sure that each plot has:

1. A figure caption that describes the contents of the plot.
2. X and Y axis labels that include appropriate units
3. A carefully composed title that describes the contents of the plot.

Below each plot, describe and interpret what the plot shows. Describe how the
data demonstrate an impact and / or a driver of the 2013 flood event.

### Write clean code

Be sure that your code follows the style guidelines outlined in the
[write clean code lessons]({{ site.url }}/courses/earth-analytics/time-series-data/write-clean-code-with-r/)

Be sure to:

* Label each plot clearly. This includes a `title`, `x` and `y` axis labels
* Write [clean code]({{ site.url }}/courses/earth-analytics/week-2/write-clean-code-with-r/). This includes comments that document / describe the steps you take in your code and clean syntax following <a href="http://adv-r.had.co.nz/Style.html" target="_blank">Hadley Wickham's style guide.</a>
* Convert date fields as appropriate
* Clean no data values as appropriate
* Show all of your code in the output `.html` file.

#### 4. Graduate students: add a 5th plot to your `.Rmd` file

In addition to the plots above, add a plot of precipitation that spans
from 1948 - 2013 using the `805333-precip-daily-1948-2013.csv` file. For you plot
be sure to

1. Subset the data temporally: Jan 1 2013 - Oct 15 2013
2. Summarize the data: plot DAILY total (sum) precipitation


Use the [bonus lesson]({{ site.url }}/courses/earth-analytics/week-2/aggregate-time-series-data-r/) to guide
you through creating this plot.

#### Bonus points (for grads and undergrads)

**Bonus opportunity 1 (1 point)**
Generate and add to your report the plot of precipitation for 1948 - 2013
described above (required for all graduate students).

Then, receive a bonus point for:

1. identifying an anomaly or change in the data that you can clearly see when you plot it and
2. suggest how to address that anomaly in `R` to make a more uniform looking plot.

**Bonus opportunity 1 (1 point)**
* create an interactive plot with a slider (range selector) using `dygraphs`

***

## Final submission

When you are happy with your report, convert your `R Markdown` file into `.html`
format report using `knitr`.
**Submit your final report to the d2l drop box in both `.html` and `.Rmd`**

</div>

## Homework plots

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-02-time-series-data/homework-solution-plot-1-1.png" title="homework plot one" alt="homework plot one" width="90%" />

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-02-time-series-data/homework-plot-2-1.png" title="homework plot 2" alt="homework plot 2" width="90%" />

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-02-time-series-data/homework-plot3-1.png" title="homework plot 3" alt="homework plot 3" width="90%" />

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-02-time-series-data/homework-plot4-1.png" title="homework plot 4" alt="homework plot 4" width="90%" />


## Graduate plot

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-02-time-series-data/graduate-plot1-1.png" title="Grad only homework plot 1" alt="Grad only homework plot 1" width="90%" />

## Bonus plots

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-02-time-series-data/bonus-plot1-1.png" title="homework plot 4" alt="homework plot 4" width="90%" />



<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/00-course-overview/sessions/2017-01-01-week-02-time-series-data/bonus-plot-2-1.png" title="hourly precipitation" alt="hourly precipitation" width="90%" />

## Report grade rubric

### Report content - text writeup: 30%

| Element                                                                                                                                                           | 5 points                                                                                                                                                       | 3 Points                                             | 0 Points                                                      |  |
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------|:--------------------------------------------------------------|:-|
| PDF and RMD submitted                                                                                                                                             | Both files are submitted                                                                                                                                       | Only one of the 2 files are submitted                | NA                                                            |  |
| Summary text is provided for each plot                                                                                                                            | Summary text is provided for all of the plots in the report.                                                                                                   | Summary text is missing for 1-2 plots in the report. | Summary text is not included for 3 or more plots.             |  |
| Grammar & spelling are accurate throughout the report                                                                                                             | No visible grammar or spelling issues in the report                                                                                                            | 2-4 grammar and spelling issues in the report        | More than 4 spelling / grammar issues in the report           |  |
| File is named with last name-first initial week 3                                                                                                                 | File naming is as required                                                                                                                                     | NA                                                   | File is not named properly                                    |  |
| Report contains all 4 plots described in the assignment.                                                                                                          | All plots are included in the report                                                                                                                           | 1 plot is missing                                    | More than 1 plot is missing                                   |  |
| 2-3 paragraphs exist at the top of the report that summarize the conditions and the events that took place in 2013 to cause a flood that had significant impacts. | Summary text is included at the top of the report.                                                                                                             |                                                      | There is no introductory, summary text included in the report |  |
| Introductory text at the top of the document clearly describes the conditions and events that took place in 2013 that yielded the significant flood event.        | The summary text adequately describes the drivers including the weather system, rainfall and discharge as it relates to the erosion / deposition that occured. | NA                                                   | This information is not included in the report.               |  |
| Introductory text at the top of the document is thoughtful and well written.                                                                                      | It is well written.                                                                                                                                            | NA                                                   | Introductory text is not well written.                        |  |


### Report Content - Code Format: 20%

| Element                                                                               | 5 points                                                                                          | 3 Points                                                                                      | 0 Points                                                            |  |
|:--------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------|:--------------------------------------------------------------------|:-|
| Code is written using "clean" code practices following the Hadley Wickham style guide | Spaces are placed after all # comment tags, variable names do not use periods, or function names. | Clean coding is used in some of the code but spaces or variable names are incorrect 2-4 times | clean coding is not implemented consistently throughout the report. |  |
| YAML contains a title, author and date                                                | Author, title and date are in YAML                                                                | One element is missing from the YAML                                                          | 2 or more elements are missing from the YAML                        |  |
| Code chunk contains code and runs                                                     | All code runs in the document                                                                     | There are 1-2 errors in the code in the document that make it not run                         | The are more than 3 code errors in the document                     |  |


### Report plots: 50%

**PLOT 1: a plot of precipitation from 2003 to 2013 using ggplot().**

| 5 points                                                                                                                                            | 3 Points                       | 0 Points                                       |  |
|:----------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------|:-----------------------------------------------|:-|
| Plot is labeled with a title, x and y axis label.                                                                                                   | Plot is missing 1 or 2 labels. | No labels were added to the plot.              |  |
| Plot is coded using the ggplot() function.                                                                                                          | NA                             | Plot is not coded using the ggplot() function. |  |
| Date on the x axis is formatted as a date class.                                                                                                    | NA                             | Dates are not properly formatted.              |  |
| No data values have been removed                                                                                                                    | NA                             | No data values have not been removed           |  |
| Code to create the plot is clearly documented with comments in the html / pdf knitr output.                                                         | NA                             | Code is not documented with comments.          |  |
| Plot is described and interpreted in the text of the report with reference made to how the data demonstrate an impact or driver of the flood event. | NA                             | Plot is not interpreted in the text.           |  |

**PLOT 2: a plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013.**

| 5 points                                                                                                                                            | 3 Points                       | 0 Points                                       |  |
|:----------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------|:-----------------------------------------------|:-|
| Plot is labeled with a title, x and y axis label.                                                                                                   | Plot is missing 1 or 2 labels. | No labels were added to the plot.              |  |
| Plot is coded using the ggplot() function.                                                                                                          | NA                             | Plot is not coded using the ggplot() function. |  |
| Date on the x axis is formatted as a date class.                                                                                                    | NA                             | Dates are not properly formatted.              |  |
| No data values have been removed                                                                                                                    | NA                             | No data values have not been removed           |  |
| Code to create the plot is clearly documented with comments in the html / pdf knitr output.                                                         | NA                             | Code is not documented with comments.          |  |
| Plot is described and interpreted in the text of the report with reference made to how the data demonstrate an impact or driver of the flood event. | NA                             | Plot is not interpreted in the text.           |  |

**PLOT 3: a plot of stream discharge from 1986 to 2016 using ggplot().**

| 5 points                                                                                                                                            | 3 Points                       | 0 Points                                       |  |
|:----------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------|:-----------------------------------------------|:-|
| Plot is labeled with a title, x and y axis label.                                                                                                   | Plot is missing 1 or 2 labels. | No labels were added to the plot.              |  |
| Plot is coded using the ggplot() function.                                                                                                          | NA                             | Plot is not coded using the ggplot() function. |  |
| Date on the x axis is formatted as a date class.                                                                                                    | NA                             | Dates are not properly formatted.              |  |
| No data values have been removed                                                                                                                    | NA                             | No data values have not been removed           |  |
| Code to create the plot is clearly documented with comments in the html / pdf knitr output.                                                         | NA                             | Code is not documented with comments.          |  |
| Plot is described and interpreted in the text of the report with reference made to how the data demonstrate an impact or driver of the flood event. | NA                             | Plot is not interpreted in the text.           |  |

**PLOT 4: a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013**

| 5 points                                                                                                                                            | 3 Points                       | 0 Points                                       |  |
|:----------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------|:-----------------------------------------------|:-|
| Plot is labeled with a title, x and y axis label.                                                                                                   | Plot is missing 1 or 2 labels. | No labels were added to the plot.              |  |
| Plot is coded using the ggplot() function.                                                                                                          | NA                             | Plot is not coded using the ggplot() function. |  |
| Date on the x axis is formatted as a date class.                                                                                                    | NA                             | Dates are not properly formatted.              |  |
| No data values have been removed                                                                                                                    | NA                             | No data values have not been removed           |  |
| Code to create the plot is clearly documented with comments in the html / pdf knitr output.                                                         | NA                             | Code is not documented with comments.          |  |
| Plot is described and interpreted in the text of the report with reference made to how the data demonstrate an impact or driver of the flood event. | NA                             | Plot is not interpreted in the text.           |  |


**PLOT 5 (GRAD STUDENTS ONLY, bonus points for undergrads): a plot of precipitation that spans from 1948 - 2013**

| 5 points                                                                                                                                            | 3 Points                       | 0 Points                                       |  |
|:----------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------|:-----------------------------------------------|:-|
| Plot is labeled with a title, x and y axis label.                                                                                                   | Plot is missing 1 or 2 labels. | No labels were added to the plot.              |  |
| Plot is coded using the ggplot() function.                                                                                                          | NA                             | Plot is not coded using the ggplot() function. |  |
| Date on the x axis is formatted as a date class.                                                                                                    | NA                             | Dates are not properly formatted.              |  |
| No data values have been removed                                                                                                                    | NA                             | No data values have not been removed           |  |
| Code to create the plot is clearly documented with comments in the html / pdf knitr output.                                                         | NA                             | Code is not documented with comments.          |  |
| Plot is described and interpreted in the text of the report with reference made to how the data demonstrate an impact or driver of the flood event. | NA                             | Plot is not interpreted in the text.           |  |


#### Grading bonus points (2 points potential)
***

* 1 point: Identify and fix the anomaly in the precipitation `805333-precip-daily-1948-2013.csv`
* 1 point: Create an interactive plot using `dygraphs` in your output html file you
