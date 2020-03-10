---
layout: single
title: 'Create Data Driven Reports using Jupyter Notebooks | 2013 Colorado Flood Data'
excerpt: "Connecting data to analysis and outputs is an important part of open reproducible science. In this lesson you will explore that value of a well documented workflow."
authors: ['Leah Wasser', 'Martha Morrissey']
modified: 2020-03-06
category: [courses]
class-lesson: ['data-for-science-floods']
permalink: /courses/earth-analytics-python/python-open-science-toolbox/data-driven-reports-jupyter-notebook/
nav-title: 'Data Driven Report'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 2
course: 'earth-analytics-python' 
topics: 
    time-series:    
---

{% include toc title="In This Lesson" icon="file-text" %}

A well documented scientific workflow is valuable because it makes it easier
for us all to build off of each other's work. Below you will consider the elements
of a well-documented workflow using Jupyter Notebooks.

<div class='notice--success' markdown='1'>

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* List some of the components of a project that make it more easily re-usable (reproducible) to you when working with other people

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this activity.

</div>

## A Data Report

Your colleague put together the very informative data report below. The topic of the report is the 2013 Colorado floods. Examine the report. Then answer the questions below.

1. What sources of data were used to create the plots?

2. How were the data processed?

3. How did your colleague generate this report? When was it last updated?

4. Who contributed to this report?

5. You'd like to make some changes to the report - can you do that easily? If you wanted to make changes, what process and tools would you use to make those changes?

6. What units are the precipitation data in?

7. Create a list of the things that would make editing this report easier.

***


## My Report - 2013 Colorado Flood Data

Precipitation Data

A lot of rain impacted Colorado. See below.



{:.output}
    Downloading from https://ndownloader.figshare.com/files/7010681
    Downloading from https://ndownloader.figshare.com/files/7010681





{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>DATE</th>
      <th>HPCP</th>
      <th>Measurement Flag</th>
      <th>Quality Flag</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>20030101 01:00</td>
      <td>0.0</td>
      <td>g</td>
      <td></td>
    </tr>
    <tr>
      <th>1</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>20030201 01:00</td>
      <td>0.0</td>
      <td>g</td>
      <td></td>
    </tr>
    <tr>
      <th>2</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>20030202 19:00</td>
      <td>0.2</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>3</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>20030202 22:00</td>
      <td>0.1</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>4</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>20030203 02:00</td>
      <td>0.1</td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
</div>







{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/01-science-toolbox/use-data-for-science/2018-02-05-flood-02-precip-discharge-python-example/2018-02-05-flood-02-precip-discharge-python-example_6_0.png" alt = "Plot of daily precipitation for Boulder, Colorado from 2003-2013.">
<figcaption>Plot of daily precipitation for Boulder, Colorado from 2003-2013.</figcaption>

</figure>






## Fall 2013 Precipitation



Let's check out the data for a few months.








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/01-science-toolbox/use-data-for-science/2018-02-05-flood-02-precip-discharge-python-example/2018-02-05-flood-02-precip-discharge-python-example_9_0.png" alt = "Plot of Daily Total Precipitation from Aug to Oct 2013 for Boulder Creek.">
<figcaption>Plot of Daily Total Precipitation from Aug to Oct 2013 for Boulder Creek.</figcaption>

</figure>








{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/01-science-toolbox/use-data-for-science/2018-02-05-flood-02-precip-discharge-python-example/2018-02-05-flood-02-precip-discharge-python-example_13_0.png" alt = "Plot of Total Monthly Precipitation for Boulder, CO.">
<figcaption>Plot of Total Monthly Precipitation for Boulder, CO.</figcaption>

</figure>



