---
layout: single
category: course-materials
title: "Week 10"
permalink: /course-materials/earth-analytics/week-10/
week-landing: 10
week: 10
sidebar:
  nav:
comments: false
author_profile: false
---

{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to week {{ page.week }} of Earth Analytics! In this week we will learn
how to access data programmatically in your code. We will do this using `download.file()`,
`read.csv()` and `getURL()` to access data files and data via API calls.

</div>

|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 3:00 - 3:15  | Review - Final Project |   |
| 3:15 - 4:15  | Introduction to programmatic data access | Leah |
| 4:30 - 5:15  | Using APIs and creative maps with JSON data  |  Leah |
|===
| 4:15 - 5:50  | Group work / Work on your homework |    |


### 2. Complete the assignment below (10 points)

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Submission


### Complete the assignment below:

This week you will create an html formatted report! We will use html in case
you'd like to embed interactive leaflet maps in your final report. Do the following:

Create a new `R markdown `document. Name it: **lastName-firstInitial-week8.Rmd**
Within your `.Rmd` document, include the plots listed below. When you are done
with your report, use `knitr` to convert it to `html` format. Submit both the
`.Rmd` file and the `.html` file to D2L. Be sure to name your files
as instructed above!

#### Use knitr code chunk arguments

For this week's assignment, you can turn off warnings but please do not hide
your code. We want to see how your code up your plots and how you access the
data.

Include the following plots in your homework:

IMPORTANT!! for all plots be sure to:

* Add a title and label the x and y axes appropriately
* Adjust the colors of your plot to make it look nice

### Plot 1

Using the tools that we learned above, import the Princeton salary data below
using the RCurl functions `getURL()` & `textConnection()`, combined with `read.table()`.

<a href="http://data.princeton.edu/wws509/datasets/#salary" target="_blank">Learn more about the Princeton salary data</a>

As described on the website:

> These are the salary data used in Weisberg's book, consisting of observations on six variables for 52 tenure-track professors in a small college. The variables are:

* **sx** Sex, coded 1 for female and 0 for male
* **rk** Rank, coded
  * **1** for assistant professor,
  * **2** for associate professor, and
  * **3** for full professor
* **yr** Number of years in current rank
* **dg** Highest degree, coded 1 if doctorate, 0 if masters
* **yd** Number of years since highest degree was earned
* **sl** Academic year salary, in dollars.

**HINT:** these data have a header. You will have to look up the appropriate argument
to ensure that the data import properly using `read.table()`.

**HINT2:** You can add facets or individual plots for particular subsets of data (
in this case rank) using the `facet_wrap()` argument in a ggplot plot. For example
 `+ facet_wrap(~dg)` will create a ggplot plot with sub plots filtered by highest
 degree.)

Plot the following:

Experience (x axis) vs. salary (y axis). Color your points by SEX and use facets
to add a facet for each of the three ranks. Your plot should look like the
one on the bottom of [this page]( {{ site.url }}/course-materials/earth-analytics/week-10/get-data-with-rcurl-r/#example-homework).

### Plot 2

Use the `read_secure_csv_file()` function to import the gapminder data following
 [this lesson]({{ site.url }}/course-materials/earth-analytics/week-10/access-gapminder-data-rcurl-r/)
Then create a plot using the `ggplot()` of two variables of interest. You can
pick any variables that you want to plot together!


### Plot 3

Using the population projection data that we used in [this lesson]({{ site.url }}/course-materials/earth-analytics/week-10/apis2-r/#example-homework-plot),
 create a plot of projected
MALE population numbers as follows:

* Time span: 1990--2040
* Column category: malepopulation
* Age range: 60--80 years old

Use `ggplot()` to create your plot and be sure to label x and y axes and give the
plot a descriptive title.


#### Bonus plot - (1 point)

Following the class lessons, create an interactive map showing surface water
site locations using leaflet. The map popup should include the discharge value
for each site and the station type.

#### Additional bonus - (1 point)

You will get a second bonus point if you can make each marker unique based on
station type!

</div>
