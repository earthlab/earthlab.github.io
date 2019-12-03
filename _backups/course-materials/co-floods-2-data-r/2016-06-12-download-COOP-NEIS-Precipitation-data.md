---
layout: single
title: "Download with Precipitation Data - 2013 Colorado Floods"
excerpt: "This tutorial overviews downloading precipitation data from the NOAA website."
authors: ['NEON Data Skills', 'Mariela Perignon']
category: [course-materials]
class-lesson: ['co-floods-2-data-r']
permalink: /course-materials/co-floods-download-precip
nav-title: 'Download Precip Data'
sidebar:
  nav:
author_profile: false
comments: false
order: 2
---

Several factors contributed to extreme flooding that occurred in Boulder,
Colorado in 2013. In this data activity, we explore and visualize the data for
precipitation (rainfall) data collected by the National Weather Service's
Cooperative Observer Program. The tutorial is part of the Data Activities that
can be used with the
<a href="{{ site.basurl }}/teaching-modules/disturb-events-co13/" target="_blank"> *Ecological Disturbance Teaching Module*</a>.

<div id="objectives" markdown="1">

### Learning Objectives
After completing this tutorial, you will be able to:

* Download precipitation data from
<a href="http://www.ncdc.noaa.gov/" target="_blank">NOAA's National Centers for Environmental Information</a>.
* Plot precipitation data in R.
* Publish & share an interactive plot of the data using Plotly.
* Subset data by date (if completing Additional Resources code).
* Set a NoData Value to NA in R (if completing Additional Resources code).

### Things You'll Need To Complete This Lesson
Please be sure you have the most current version of R and, preferably,
RStudio to write your code.

 **R Skill Level:** Intermediate - To succeed in this tutorial, you will need to
have basic knowledge for use of the R software program.

### R Libraries to Install:

* **ggplot2:** `install.packages("ggplot2")`
* **plotly:** `install.packages("plotly")`

#### Data Download & Directory Preparation

Part of this lesson is to access and download the data directly from NOAA's
National Climate Divisional Database. If instead you would prefer to download
the data as a single compressed file, it can be downloaded from the
<a href="https://ndownloader.figshare.com/files/6780978"> NEON Data Skills account on FigShare</a>.

To more easily follow along with this lesson, use the same organization for your
files and folders as we did. First, create a `data` directory (folder) within
your `Documents` directory. If you downloaded the compressed data file above,
unzip this file and place the `distub-events-co13` folder within the `data`
directory you created. If you are planning to access the data directly as
described in the lesson, create a new directory called `distub-events-co13`
wihin your `data` folder and then within it create another directory called
`precip`. If you choose to save your files elsewhere in your file structure, you
will need to modify the directions in the lesson to set your working directory
accordingly.

</div>

## Research Question
What were the patterns of precipitation leading up to the 2013 flooding events
in Colorado?

## Precipitation Data
The heavy **precipitation (rain)** that occurred in September 2013 caused much
damage during the 2013 flood by, among other things, increasing
**stream discharge (flow)**. In this lesson we will download, explore, and
visualize the precipitation data collected during this time to better understand
this important flood driver.

## Where can we get precipitation data?

The precipitation data are obtained through
 <a href="http://www.ncdc.noaa.gov/" target="_blank">NOAA's National Centers for Environmental Information</a>
(formerly the National Climatic Data Center). There are numerous climatic
datasets that can be found and downloaded via the
<a href="http://www.ncdc.noaa.gov/cdo-web/search" target="_blank">Climate Data Online Search portal</a>.

The precipitation data that we will use is from the
<a href="https://www.ncdc.noaa.gov/data-access/land-based-station-data/land-based-datasets/cooperative-observer-network-coop" target="_blank">Cooperative Observer Network (COOP)</a>.

> "Through the National Weather Service (NWS) Cooperative Observer Program
(COOP), more than 10,000 volunteers take daily weather observations at National
Parks, seashores, mountaintops, and farms as well as in urban and suburban
areas. COOP data usually consist of daily maximum and minimum temperatures,
snowfall, and 24-hour precipitation totals."
> Quoted from NOAA's National Centers for Environmental Information

Data is collected at different stations, often on paper data sheets like the one
below, and then entered into a central database where we can access that data and
download it in the .csv (Comma Separated Values) format.

 <figure>
   <a href="{{ site.baseurl }}/images/disturb-events-co13/COOP_SampleDataSheet.png">
   <img src="{{ site.baseurl }}/images/disturb-events-co13/COOP_SampleDataSheet.png"></a>
   <figcaption> An example of the data sheets used to collect the precipitation
   data for the Cooperative Observer Network. Source: Cooperative Observer
   Network, NOAA
   </figcaption>
</figure>

## Obtain the Data

If you have not already opened the
<a href="http://www.ncdc.noaa.gov/cdo-web/search" target="_blank">Climate Data
Online Search portal</a>, do so now.

Note: If you are using the pre-compiled data subset that can be downloaded as a
compressed file above, you should still read through this section to know where
the data comes from before proceeding with the lesson.

#### Step 1: Search for the data
To obtain data we must first choose a location of interest.
The COOP site Boulder 2 (Station ID:050843) is centrally located in Boulder, CO.

 <figure>
   <a href="{{ site.baseurl }}/images/disturb-events-co13/LocationOfPrecipStation.png">
   <img src="{{ site.baseurl }}/images/disturb-events-co13/LocationOfPrecipStation.png"></a>
   <figcaption> Cooperative Observer Network station 050843 is located in
   central Boulder, CO. Source: National Centers for Environmental Information
   </figcaption>
</figure>

Then we must decide what type of data we want to download for that station. As
shown in the image below, we selected:

* the desired date range (1 January 2003 to 31 December 2013),
* the type of dataset ("Precipitation Hourly"),
* the search type ("Stations") and
* the search term (e.g. the # for the station located in central Boulder, CO: 050843).

 <figure>
   <a href="{{ site.baseurl }}/images/disturb-events-co13/NCEI_DownloadData_ScreenShot.png">
   <img src="{{ site.baseurl }}/images/disturb-events-co13/NCEI_DownloadData_ScreenShot.png"></a>
   <figcaption> An example of the data sheets used to collect the precipitation
   data for the Cooperative Observer Network. Source: National Ecological
   Observatory Network (NEON)
   </figcaption>
</figure>

Once the data is entered and you select `Search`, you will be directed to a
new page with a map. You can find out more information about the data by selecting
`View Full Details`.
Notice that this dataset goes all the way back to 1 August 1948! However, we've
selected only a portion of this time frame.

#### Step 2: Request the data
Once you are sure this is the data that you want, you need to request it by
selecting `Add to Cart`. The data can then be downloaded as a **.csv** file
which we will use to conduct our analyses. Be sure to double check the date
range before downloading.

On the options page, we want to make sure we select:

* Station Name
* Geographic Location (this gives us longitude & latitude; optional)
* Include Data Flags (this gives us information if the data are problematic)
* Units (Standard)
* Precipitation (w/ HPCP automatically checked)

On the next page you must enter an email address for the data set to be sent
to.

#### Step 3: Get the data
As this is a small dataset, it won't take long for you to get an email telling
you the dataset is ready. Follow the link in the email to download your dataset.
You can also view documentation (metadata) for the data.
Each data subset is downloaded with a unique order number.  The order number in
our example data set is 805325.  If you are using a data set you've downloaded
yourself, make sure to substitute in your own order number in the code below.

To ensure that we remember what our data file is, we've added a descriptor to
the order number: `805325-precip_daily_2003-2013`. You may wish to do the same.
