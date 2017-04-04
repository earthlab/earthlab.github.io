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

Welcome to week {{ page.week }} of Earth Analytics!


</div>


|  Time | Topic   | Speaker   |
|---|---|---|---|---|
| 3:00 - 3:10  | Questions |   |
| 3:10 - 4:00  | Review |  |
| 4:00 - 4:30  | Present your science effectively |  Leah |
|===
| 4:40 - 5:50  | Group work  |    |


### Overview


#### Homework Plot 1


<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Using the tools that we learned above, import the Princeton salary data below
using the Rcurl functions `getURL()` & `textConnection()`, combined with `read.table()`.

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

HINT: these data have a header. You will have to look up the appropriate argument
to ensure that the data import properly using `read.table()`.

HINT2: You can add facets or individual plots for particular subsets of data (
in this case rank) using the facet_wrap() argument in a ggplot plot. For example
 `+ facet_wrap(~dg)` will create a ggplot plot with sub plots filtered by highest
 degree.)

Plot the following:

Experience (x axis) vs. salary (y axis). Color your points by SEX and use facets
to add a facet for each of the three ranks.

</div>



#### Homework Plot 2


{{ site.url }}/course-materials/earth-analytics/week-10/access-gapminder-data-rcurl-r/
Use the `read_secure_csv_file()` function  to import the gapminder data.
Then create a plot using the `ggplot()` of two variables of interest. You can
pick any variables that you want to plot together!

Be sure to:

* Add a title and label the x and y axes appropriately
* Adjust the colors of your plot to make it look nice


#### Homework Plot 3

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

Using the population projection data that we just used, create a plot of projected
MALE population numbers as follows:

* Time span: 1990-2040
* Column category: malepopulation
* Age range: 60-80 years old

Use `ggplot()` to create your plot and be sure to label x and y axes and give the
plot a descriptive title.
</div>


#### Bonus Plot - (1 point)
BONUS -- create a leaflet map
will need to test this using .Rmd knit to see if it works...
