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
`read.csv()` and `fromJSON()` to access data files and data via API calls.

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

Create a new `R markdown `document. Name it: **lastName-firstInitial-week10.Rmd**
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

## Homework Part 1. Answer the following questions (33%)

1. What does API stand for and what is an API?
2. Why is programmatic access to data within our code useful?
3. List 2 characteristics of the `JSON` file format.

## Homework Part 2. Create the 2 plots below (66%)

#### Plot 1

Using the tools that we learned above, import the Princeton salary data below.

Plot the following:

Experience (x axis) vs. salary (y axis). Color your points by SEX and use facets
to add a facet for each of the three ranks. Your plot should look like the
one on the bottom of [this page]( {{ site.url }}/course-materials/earth-analytics/week-10/get-data-with-rcurl-r/#example-homework-plot).

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

#### Plot 2

Use the `read_secure_csv_file()` function to import the gapminder data following
 [this lesson]({{ site.url }}/course-materials/earth-analytics/week-10/access-gapminder-data-rcurl-r/)
Then create a plot using the `ggplot()` of two variables of interest. You can
pick any variables that you want to plot together but do not use variables that
we demonstrate in the online lessons!


#### Bonus plot - (1 point)

Following the class lessons, create an interactive map showing surface water
site locations using leaflet. The map popup should include the discharge value
for each site and the station type. IMPORTANT: there is a bug where leaflet
maps don't always render properly unless you specify the tile background that
it should use! If you get a map with a grey background, this may be why!

#### Additional bonus - (1 point)

You will get a second bonus point if you can make each marker unique based on
station type!

****

## Homework due: Wednesday April 12 2017 @ NOON.
Submit your report in both `.Rmd` and `.html` format to the D2l dropbox.

NOTE: ALL future assignments will be due BEFORE CLASS on Wednesday at NOON. Following
course policy we will not accept late assignments. Start early and submit your
assignment BEFORE NOON.
</div>


## Grade rubric

#### Questions (33.3%)

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| What does API stand for and what is an API? |  |  | | |
| Why is programmatic access to data within our code useful? |  |  | | |
|===
| List 2 characteristics of the JSON file format. |  |  | | |

#### Plot 1 - Princeton data plot (33.3%)

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Data are plotted using the ggplot() function (not qplot!). |  |  | | |
| Data are read in using read.table() directly from the website (if you don't need to use getURL, that is ok. |  |  | | |
| Data are plotted: Experience (x axis) vs. salary (y axis).  |  |  | | |
| Data points are colored by sex.  |  |  | | |
| Ggplot facets are used to plot each subset by RANK.  |  |  | | |
| X and Y axis are labelled appropriately and the plot has a clear title.  |  |  | | |
|===
| Code is well documented and printed on the output html or pdf document.|  |  | | |

#### Plot 2 - Gapminder data plot using function (33.3%)

|  Full Credit | Partial Credit ~B | Partial Credit ~C | Partial Credit ~D | No Credit|
|---|---|---|---|---|
| Gapminder data are imported directly into R using the read_secure_csv_file() function. |  |  | | |
| Two variables are plotted (and they are not the variables used in the lessons). |  |  | | |
| X and Y axis are labelled appropriately  and the plot has a clear title.  |  |  | | |
|===
| Code is well documented and printed on the output html or pdf document.|  |  | | |
