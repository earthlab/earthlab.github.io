---
layout: single
title: "Work with Precipitation Data in R - 2013 Colorado Floods"
excerpt: "This lesson walks through the steps need to download and visualize
precipitation data in R to better understand the drivers and impacts of the 2013
Colorado floods."
authors: ['Leah Wasser', 'NEON Data Skills', 'Mariela Perignon']
category: [course-materials]
class-lesson: ['co-floods-2-data-r']
permalink: /course-materials/co-floods-precip-r
nav-title: 'Precip Data R'
sidebar:
  nav:
author_profile: false
comments: false
order: 3
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

# Work with Precipitation Data

## R Libraries

We will use `ggplot2` to efficiently plot our data and `plotly` to create
interactive plots.


```r
# set your working directory
#setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots
library(plotly) # create cool interactive plots

# set strings as factors to false for everything!
options(stringsAsFactors = FALSE)
```



## Import Precipitation Data

We will use the `805325-Preciptation_Daily_2003-2013.csv` file
in this analysis. This dataset is the daily precipitation date from the COOP
station 050843 in Boulder, CO for 1 January 2003 through 31 December 2013.

Since the data format is a .csv, we can use `read.csv` to import the data. After
we import the data, we can take a look at the first few lines using `head()`,
which defaults to the first 6 rows, of the `data.frame`. Finally, we can explore
the R object structure.


```r

# import precip data into R data.frame
precip.boulder <- read.csv("disturb-events-co13/precip/805325-precip_daily_2003-2013.csv",
                           header = TRUE)

# view first 6 lines of the data
head(precip.boulder)
##       STATION    STATION_NAME ELEVATION LATITUDE LONGITUDE           DATE
## 1 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 20030101 01:00
## 2 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 20030201 01:00
## 3 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 20030202 19:00
## 4 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 20030202 22:00
## 5 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 20030203 02:00
## 6 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 20030205 02:00
##   HPCP Measurement.Flag Quality.Flag
## 1  0.0                g
## 2  0.0                g
## 3  0.2
## 4  0.1
## 5  0.1
## 6  0.1

# view structure of data
str(precip.boulder)
## 'data.frame':	1840 obs. of  9 variables:
##  $ STATION         : chr  "COOP:050843" "COOP:050843" "COOP:050843" "COOP:050843" ...
##  $ STATION_NAME    : chr  "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" "BOULDER 2 CO US" ...
##  $ ELEVATION       : num  1650 1650 1650 1650 1650 ...
##  $ LATITUDE        : num  40 40 40 40 40 ...
##  $ LONGITUDE       : num  -105 -105 -105 -105 -105 ...
##  $ DATE            : chr  "20030101 01:00" "20030201 01:00" "20030202 19:00" "20030202 22:00" ...
##  $ HPCP            : num  0 0 0.2 0.1 0.1 ...
##  $ Measurement.Flag: chr  "g" "g" " " " " ...
##  $ Quality.Flag    : chr  " " " " " " " " ...
```

## About the Data

Viewing the structure of these data, we can see that different types of data are included in
this file.

* **STATION** and **STATION_NAME**: Identification of the COOP station.
* **ELEVATION, LATITUDE** and **LONGITUDE**: The spatial location of the station.
* **DATE**: Gives the date in the format: YYYYMMDD HH:MM. Notice that DATE is
currently class `chr`, meaning the data is interpreted as a character class and
not as a date.
* **HPCP**: The total precipitation given in inches
(since we selected `Standard` for the units), recorded
for the hour ending at the time specified by DATE. Importantly, the metadata
(see below) notes that the value 999.99 indicates missing data. Also important,
hours with no precipitation are not recorded.
* **Measurement Flag**: Indicates if there are any abnormalities with the
measurement of the data. Definitions of each flag can be found in Table 2 of the
documentation.
* **Quality Flag**: Indicates if there are any potential quality problems with
the data. Definitions of each flag can be found in Table 3 of the documentation.

Additional information about the data, known as metadata, is available in the
`PRECIP_HLY_documentation.pdf` file that can be downloaded along with the data.
(Note, as of Sept. 2016, there is a mismatch in the data downloaded and the
documentation. The differences are in the units and missing data value:
inches/999.99 (standard) or millimeters/25399.75 (metric)).

## Clean the Data
Before we can start plotting and working with the data we always need to check
several important factors:

* data class: is R interpreting the data the way we expect it. The function
`str()` is an important tools for this.
* NoData Values: We need to know if our data contains a specific value that
means "data are missing" and if this value has been assigned to NA in R.


### Convert Date-Time
As we've noted, the date field is in a character class. We can convert it to a date/time
class that will allow R to correctly interpret the data and allow us to easily
plot the data. We can convert it to a date/time class using `as.POSIXct()`.


```r

# convert to date/time and retain as a new field
precip.boulder$DateTime <- as.POSIXct(precip.boulder$DATE,
                                  format="%Y%m%d %H:%M")
                                  # date in the format: YearMonthDay Hour:Minute

# double check structure
str(precip.boulder$DateTime)
##  POSIXct[1:1840], format: "2003-01-01 01:00:00" "2003-02-01 01:00:00" ...
```

* For more information on date/time classes, see the NEON tutorial
<a href="{{ site.baseurl }}/R/time-series-convert-date-time-class-POSIX/" target="_blank"> *Dealing With Dates & Times in R - as.Date, POSIXct, POSIXlt*</a>.

### NoData Values
We've also learned that missing values, also known as NoData
values, are labelled with the placeholder `999.99`. Do we have any NoData values in our data?


```r

# histogram - would allow us to see 999.99 NA values
# or other "weird" values that might be NA if we didn't know the NA value
hist(precip.boulder$HPCP)
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/geog-4100-5100/intro-co-floodsCOOP-NEIS-Precipitation-In-R/no-data-values-hist-1.png)

Looking at the histogram, it looks like we have mostly low values (which makes sense) but a few values
up near 1000 -- likely 999.99. We can assign these entries to be `NA`, the value that
R interprets as no data.


```r
# assing NoData values to NA
precip.boulder$HPCP[precip.boulder$HPCP==999.99] <- NA

# check that NA values were added;
# we can do this by finding the sum of how many NA values there are
sum(is.na(precip.boulder))
## [1] 94
```

There are 94 NA values in our dataset. This is missing data.

#### Questions:

1. Do we need to worry about the missing data?
1. Could they affect our analyses?

This depends on what questions we are asking.  Here we are looking at
general patterns in the data across 10 years. Since we have just over 3650
days in our entire data set, missing 94 probably won't affect the general trends
we are looking at.

Can you think of a research question where we would need to be concerned about
the missing data?

## Plot Precipitation Data
Now that we've cleaned up the data, we can view it. To do this we will plot using
`ggplot()` from the `ggplot2` package.


```r

#plot the data
precPlot_hourly <- ggplot(data=precip.boulder,  # the data frame
      aes(DateTime, HPCP)) +   # the variables of interest
      geom_bar(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 2003-2013")  # add a title

precPlot_hourly
## Warning: Removed 94 rows containing missing values (position_stack).
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/geog-4100-5100/intro-co-floodsCOOP-NEIS-Precipitation-In-R/plot-precip-hourly-1.png)

As we can see, plots of hourly date lead to very small numbers and is difficult
to represent all information on a figure. Hint: If you can't see any bars on your
plot you might need to zoom in on it.

Plots and comparison of daily precipitation would be easier to view.

## Plot Daily Precipitation

There are several ways to aggregate the data.

#### Daily Plots
If you only want to view the data plotted by date you need to create a column
with only dates (no time) and then re-plot.


```r

# convert DATE to a Date class
# (this will strip the time, but that is saved in DateTime)
precip.boulder$DATE <- as.Date(precip.boulder$DateTime, # convert to Date class
                                  format="%Y%m%d %H:%M")
                                  #DATE in the format: YearMonthDay Hour:Minute

# double check conversion
str(precip.boulder$DATE)
##  Date[1:1840], format: "2003-01-01" "2003-02-01" "2003-02-03" "2003-02-03" ...

precPlot_daily1 <- ggplot(data=precip.boulder,  # the data frame
      aes(DATE, HPCP)) +   # the variables of interest
      geom_bar(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Daily Precipitation - Boulder Station\n 2003-2013")  # add a title

precPlot_daily1
## Warning: Removed 94 rows containing missing values (position_stack).
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/geog-4100-5100/intro-co-floodsCOOP-NEIS-Precipitation-In-R/daily-summaries-1.png)

R will automatically combine all data from the same day and plot it as one entry.

#### Daily Plots & Data

If you want to record the combined hourly data for each day, you need to create a new data frame to store the daily data. We can
use the `aggregate()` function to combine all the hourly data into daily data.
We will use the date class DATE field we created in the previous code for this.


```r

# aggregate the Precipitation (PRECIP) data by DATE
precip.boulder_daily <-aggregate(precip.boulder$HPCP,   # data to aggregate
	by=list(precip.boulder$DATE),  # variable to aggregate by
	FUN=sum,   # take the sum (total) of the precip
	na.rm=TRUE)  # if the are NA values ignore them
	# if this is FALSE any NA value will prevent a value be totalled

# view the results
head(precip.boulder_daily)
##      Group.1   x
## 1 2003-01-01 0.0
## 2 2003-02-01 0.0
## 3 2003-02-03 0.4
## 4 2003-02-05 0.2
## 5 2003-02-06 0.1
## 6 2003-02-07 0.1
```

So we now have daily data but the column names don't mean anything. We can
give them meaningful names by using the `names()` function. Instead of naming the column of
precipitation values with the original `HPCP`, let's call it `PRECIP`.


```r

# rename the columns
names(precip.boulder_daily)[names(precip.boulder_daily)=="Group.1"] <- "DATE"
names(precip.boulder_daily)[names(precip.boulder_daily)=="x"] <- "PRECIP"

# double check rename
head(precip.boulder_daily)
##         DATE PRECIP
## 1 2003-01-01    0.0
## 2 2003-02-01    0.0
## 3 2003-02-03    0.4
## 4 2003-02-05    0.2
## 5 2003-02-06    0.1
## 6 2003-02-07    0.1
```

Now we can plot the daily data.


```r

# plot daily data
precPlot_daily <- ggplot(data=precip.boulder_daily,  # the data frame
      aes(DATE, PRECIP)) +   # the variables of interest
      geom_bar(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Daily Precipitation - Boulder Station\n 2003-2013")  # add a title

precPlot_daily
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/geog-4100-5100/intro-co-floodsCOOP-NEIS-Precipitation-In-R/daily-prec-plot-1.png)

Compare this plot to the plot we created using the first method. Are they the same?

<i class="fa fa-star"></i> **R Tip:** This manipulation, or aggregation, of data
can also be done with the package `plyr` using the `summarize()` function.
{: .notice}

## Subset the Data

Instead of looking at the data for the full decade, let's now focus on just the
2 months surrounding the flood on 11-15 September. We'll focus on the window from 15
August to 15 October.

Just like aggregating, we can accomplish this by interacting with the larger plot through the graphical interface or
by creating a subset of the data and protting it separately.

#### Subset Within Plot
To see only a subset of the larger plot, we can simply set limits for the
scale on the x-axis with `scale_x_date()`.


```r

# First, define the limits -- 2 months around the floods
limits <- as.Date(c("2013-08-15", "2013-10-15"))

# Second, plot the data - Flood Time Period
precPlot_flood <- ggplot(data=precip.boulder_daily,
      aes(DATE, PRECIP)) +
      geom_bar(stat="identity") +
      scale_x_date(limits=limits) +
      xlab("Date") + ylab("Precipitation (Inches)") +
      ggtitle("Precipitation - Boulder Station\n August 15 - October 15, 2013")

precPlot_flood
## Warning: Removed 770 rows containing missing values (position_stack).
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/geog-4100-5100/intro-co-floodsCOOP-NEIS-Precipitation-In-R/plot-Aug-Oct-2013-1.png)

Now we can easily see the dramatic rainfall event in mid-September!

<i class="fa fa-star"></i> **R Tip:** If you are using a date-time class, instead
of just a date class, you need to use `scale_x_datetime()`.
{: .notice}

#### Subset The Data

Now let's create a subset of the data and plot it.


```r

# subset 2 months around flood
precip.boulder_AugOct <- subset(precip.boulder_daily,
                        DATE >= as.Date('2013-08-15') &
												DATE <= as.Date('2013-10-15'))

# check the first & last dates
min(precip.boulder_AugOct$DATE)
## [1] "2013-08-21"
max(precip.boulder_AugOct$DATE)
## [1] "2013-10-11"

# create new plot
precPlot_flood2 <- ggplot(data=precip.boulder_AugOct, aes(DATE,PRECIP)) +
  geom_bar(stat="identity") +
  xlab("Time") + ylab("Precipitation (inches)") +
  ggtitle("Daily Total Precipitation \n Boulder Creek 2013")

precPlot_flood2
```

![ ]({{ site.baseurl }}/images/rfigs/course-materials/geog-4100-5100/intro-co-floodsCOOP-NEIS-Precipitation-In-R/subset-data-1.png)


## Interactive Plots - Plotly

Let's turn our plot into an interactive Plotly plot.


```r

# setup your plot.ly credentials; if not already set up
Sys.setenv("plotly_username"="your.user.name.here")
Sys.setenv("plotly_api_key"="your.key.here")

```


```r

#view plotly plot in R
ggplotly(precPlot_flood2)

#publish plotly plot to your plot.ly online account when you are happy with it
plotly_POST(precPlot_flood2)

```

<iframe width="100%" height="500" frameborder="0" scrolling="no" src="//plot.ly/~leahawasser/159.embed"></iframe>

<div id="challenge" markdown="1">

## Challenge: Plot Precip for Boulder Station Since 1948

The Boulder precipitation station has been recording data since 1948. Use the
steps above to create a plot of the full record of precipitation at this station (1948 - 2013).
The full dataset takes considerable time to download, so we recommend you use the dataset provided in the compressed file ("805333-precip_daily_1948-2013.csv").

As an added challenge, aggregate the data by month instead of by day.



</div>


## Additional Resources

### Units & Scale
If you are using a dataset downloaded before 2016, the units were in
**hundredths of an inch**, this isn't the most useful measure. You might want to
create a new column `PRECIP` that contains the data from `HPCP` converted to
inches.


```r

# convert from 100th inch by dividing by 100
precip.boulder$PRECIP<-precip.boulder$HPCP/100

# view & check to make sure conversion occured
head(precip.boulder)
##       STATION    STATION_NAME ELEVATION LATITUDE LONGITUDE       DATE HPCP
## 1 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 2003-01-01  0.0
## 2 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 2003-02-01  0.0
## 3 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 2003-02-03  0.2
## 4 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 2003-02-03  0.1
## 5 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 2003-02-03  0.1
## 6 COOP:050843 BOULDER 2 CO US    1650.5 40.03389 -105.2811 2003-02-05  0.1
##   Measurement.Flag Quality.Flag            DateTime PRECIP
## 1                g              2003-01-01 01:00:00  0.000
## 2                g              2003-02-01 01:00:00  0.000
## 3                               2003-02-02 19:00:00  0.002
## 4                               2003-02-02 22:00:00  0.001
## 5                               2003-02-03 02:00:00  0.001
## 6                               2003-02-05 02:00:00  0.001
```

#### Question
Compare `HPCP` and `PRECIP`. Did we do the conversion correctly?

***
Return to the
<a href="{{ site.basurl }}/teaching-modules/disturb-events-co13/detailed-lesson"> *Ecological Disturbance Teaching Module* by clicking here</a>.
