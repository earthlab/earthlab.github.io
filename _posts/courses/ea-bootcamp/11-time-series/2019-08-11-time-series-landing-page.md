---
layout: single
category: courses
title: "Learn to Work With Time Series Data in Python"
permalink: /courses/earth-analytics-bootcamp/time-series-data-python/
modified: 2021-01-28
week-landing: 1
week: 11
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-bootcamp"
module-type: 'session'
redirect_from:
  - "/courses/earth-analytics-bootcamp/data-wrangling/"
---


{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to Week {{ page.week }} of the Earth Analytics Bootcamp course! This week, you will write `Python` code in `Jupyter Notebook` to implement another strategy for DRY (i.e. Do Not Repeat Yourself) code: functions. 

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing the lessons for Week {{ page.week }}, you will be able to:

* Open time series data using Pandas in Python
* Subset data by date and time
* Resample time series data.

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework & Readings

<a href="https://github.com/earthlab-education/bootcamp-2020-10-time-series-template" target="_blank"> <i class="fa fa-link" aria-hidden="true"></i> Click here to view the GitHub Repo with the assignment template. </a>{: .btn .btn--info .btn--x-large}


## <i class="fa fa-book"></i> Earth Data Science Textbook Readings

Please read the following chapters of the <a href="https://www.earthdatascience.org/courses/use-data-open-source-python"> Intermediate to Earth Data Science online textbook</a> to support completing this week's assignment:

* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/introduction-to-time-series-in-pandas-python/">Chapter on Time Series Data Using pandas in Python</a>.


</div>

## Example Homework Plots

Below are example versions of the plots you will create for your homework.





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/11-time-series/2019-08-11-time-series-landing-page/2019-08-11-time-series-landing-page_6_0.png" alt = "Three line plots. The top line plot is of daily precipitation from August to October 2013 in Boulder, CO. The middle line plot is of the monthly maximums of hourly precipitation for 2013 near Boulder Creek. The bottom plot is of the monthly total precipitation from 1948-2013 near Boulder Creek.">
<figcaption>Three line plots. The top line plot is of daily precipitation from August to October 2013 in Boulder, CO. The middle line plot is of the monthly maximums of hourly precipitation for 2013 near Boulder Creek. The bottom plot is of the monthly total precipitation from 1948-2013 near Boulder Creek.</figcaption>

</figure>






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/11-time-series/2019-08-11-time-series-landing-page/2019-08-11-time-series-landing-page_8_0.png" alt = "Three line plots. The top line plot is of daily mean stream discharge from August to October 2013 for Boulder Creek. The middle line plot is of the monthly maximums of daily mean stream discharge for 2013 for Boulder Creek. The bottom plot is of the monthly total of mean stream discharge from 1986-2013 for Boulder Creek.">
<figcaption>Three line plots. The top line plot is of daily mean stream discharge from August to October 2013 for Boulder Creek. The middle line plot is of the monthly maximums of daily mean stream discharge for 2013 for Boulder Creek. The bottom plot is of the monthly total of mean stream discharge from 1986-2013 for Boulder Creek.</figcaption>

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/11-time-series/2019-08-11-time-series-landing-page/2019-08-11-time-series-landing-page_9_0.png" alt = "Two line plots. Top plot is daily total precipitation for August through October of 2013 near Boulder Creek. The bottom plot is the daily mean stream discharge for August through October for Boulder Creek.">
<figcaption>Two line plots. Top plot is daily total precipitation for August through October of 2013 near Boulder Creek. The bottom plot is the daily mean stream discharge for August through October for Boulder Creek.</figcaption>

</figure>





