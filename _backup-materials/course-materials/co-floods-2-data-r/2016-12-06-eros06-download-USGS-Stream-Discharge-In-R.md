---
layout: single
title: "Visualize Stream Discharge Data in R - 2013 Colorado Floods"
excerpt: "This lesson walks through the steps need to download and visualize
USGS Stream Discharge data in R to better understand the drivers and impacts of
the 2013 Colorado floods."
authors: ['Leah Wasser', 'NEON Data Skills', 'Mariela Perignon']
lastModified: 2016-12-14
category: [course-materials]
class-lesson: ['co-floods-2-data-r']
permalink: /course-materials/co-floods-USGS-stream-discharge-r
nav-title: 'Get Stream Discharge Data'
sidebar:
  nav:
author_profile: false
comments: false
order: 6
---

Several factors contributed to the extreme flooding that occurred in Boulder,
Colorado in 2013. In this data activity, we explore and visualize the data for
stream discharge data collected by the United States Geological Survey (USGS).


<div id="objectives" markdown="1">

### Learning Objectives
After completing this tutorial, you will be able to:

* Download stream gauge data from <a href="http://waterdata.usgs.gov/nwis" target="_blank"> USGS's National Water Information System</a>.
* Plot precipitation data in R.
* Publish & share an interactive plot of the data using Plotly.

### Things You'll Need To Complete This Lesson
Please be sure you have the most current version of R and, preferably,
RStudio to write your code.

 **R Skill Level:** Intermediate - To succeed in this tutorial, you will need to
have basic knowledge for use of the R software program.

### R Libraries to Install:

* **ggplot2:** `install.packages("ggplot2")`
* **plotly:** `install.packages("plotly")`

### Data to Download
We include directions on how to directly find and access the data from USGS's
National National Water Information System Database. However, depending on your
learning objectives you may prefer to use the
provided teaching data subset that can be downloaded from the <a href="https://ndownloader.figshare.com/files/6780978"> NEON Data Skills account
on FigShare</a>.

To more easily follow along with this lesson, use the same organization for your files and folders as we did. First, create a `data` directory (folder) within your `Documents` directory. If you downloaded the compressed data file above, unzip this file and place the `distub-events-co13` folder within the `data` directory you created. If you are planning to access the data directly as described in the lesson, create a new directory called `distub-events-co13` wihin your `data` folder and then within it create another directory called `discharge`. If you choose to save your files
elsewhere in your file structure, you will need to modify the directions in the lesson to set your working
directory accordingly.

</div>

## Research Question
What were the patterns of stream discharge prior to and during the 2013 flooding
events in Colorado?

## About the Data - USGS Stream Discharge Data

The USGS has a distributed network of aquatic sensors located in streams across
the United States. This network monitors a suit of variables that are important
to stream morphology and health. One of the metrics that this sensor network
monitors is **Stream Discharge**, a metric which quantifies the volume of water
moving down a stream. Discharge is an ideal metric to quantify flow, which
increases significantly during a flood event.

> As defined by USGS: Discharge is the volume of water moving down a stream or
> river per unit of time, commonly expressed in cubic feet per second or gallons
> per day. In general, river discharge is computed by multiplying the area of
> water in a channel cross section by the average velocity of the water in that
> cross section.
>
> <a href="http://water.usgs.gov/edu/streamflow2.html" target="_blank">
For more on stream discharge by USGS.</a>

<figure>
<a href="{{ site.baseurl }}/images/disturb-events-co13/USGS-Peak-discharge.gif">
<img src="{{ site.baseurl }}/images/disturb-events-co13/USGS-Peak-discharge.gif"></a>
<figcaption>
The USGS tracks stream discharge through time at locations across the United
States. Note the pattern observed in the plot above. The peak recorded discharge
value in 2013 was significantly larger than what was observed in other years.
Source: <a href="http://nwis.waterdata.usgs.gov/usa/nwis/peak/?site_no=06730200" target="_blank"> USGS, National Water Information System. </a>
</figcaption>
</figure>


## Obtain USGS Stream Gauge Data

This next section explains how to find and locate data through the USGS's
<a href="http://waterdata.usgs.gov/nwis" target="_blank"> National Water Information System portal</a>.
If you want to use the pre-compiled dataset downloaded above, you can skip this
section and start again at the
<a href="{{ site.baseurl }}/R/USGS-Stream-Discharge-Data-R/#work-with-stream-gauge-data" target="_blank"> Work With Stream Gauge Data header</a>.

#### Step 1: Search for the data

To search for stream gauge data in a particular area, we can use the
<a href="http://maps.waterdata.usgs.gov/mapper/index.html" target="_blank"> interactive map of all USGS stations</a>.
By searching for locations around "Boulder, CO", we can find 3 gauges in the area.

For this lesson, we want data collected by USGS stream gauge 06730200 located on
Boulder Creek at North 75th St. This gauge is one of the few the was able to continuously
collect data throughout the 2013 Boulder floods.

You can directly access the data for this station through the "Access Data" link
on the map icon or searching for this site on the
<a href="http://waterdata.usgs.gov/nwis" target="_blank"> National Water Information System portal </a>.

On the <a href="http://waterdata.usgs.gov/nwis/inventory?agency_code=USGS&site_no=06730200
" target="_blank"> Boulder Creek stream gauge 06730200 page</a>, we can now see
summary information about the types of data available for this station.  We want
to select **Daily Data** and then the following parameters:

* Available Parameters = **00060 Discharge (Mean)**
* Output format = **Tab-separated**
* Begin Date = **1 October 1986**
* End Date = **31 December 2013**

Now click "Go".

#### Step 2: Save data to .txt
The output is a plain text page that you must copy into a spreadsheet of
choice and save as a .csv. Note, you can also download the teaching data set
(above) or access the data through an API (see Additional Resources, below).
