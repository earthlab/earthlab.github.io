---
title: "Missing and Bad Data Values - Cleaning Spatial Data"
authors: [Leah Wasser]
contributors: [NEON Data Skills]
dateCreated: 2015-10-23
lastModified: 2016-11-29
packagesLibraries: [ ]
category: [course-materials]
excerpt: "This tutorial covers spatial data cleaning - specifically dealing with missing
(NA / NAN) values and bad values when working with spatial data in R."
permalink: course-materials/spatial-data/missing-bad-data
sidebar:
  nav:
class-lesson: ['intro-spatial-data-r']
author_profile: false
comments: false
nav-title: 'missing data'
comments: false
order: 11
---


## About
Add description.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

#Goals / Objectives

After completing this activity, you will:

*


## Things You’ll Need To Complete This Lesson
To complete this lesson you will need the most current version of R, and
preferably, RStudio loaded on your computer.

### Install R Packages

* **NAME:** `install.packages("NAME")`

* [More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

### Download Data
EDIT AS NEEDED
{% include/dataSubsets/_data_Airborne-Remote-Sensing.html %}

****

**Spatial-Temporal Data & Data Management Lesson Series:** This lesson is part
of a lesson series introducing
[spatial data and data management in `R` ]({{ site.baseurl }}tutorial/URL).
It is also part of a larger
[spatio-temporal Data Carpentry Workshop ]({{ site.baseurl }}workshops/spatio-temporal-workshop)
that includes working with
[raster data in `R` ]({{ site.baseurl }}tutorial/spatial-raster-series),
[vector data in `R` ]({{ site.baseurl }}tutorial/spatial-vector-series)
and
[tabular time series in `R` ]({{ site.baseurl }}tutorial/tabular-time-series).

****

### Additional Resources

* <a href="http://cran.r-project.org/web/packages/raster/raster.pdf" target="_blank">
Read more about the `raster` package in `R`.</a>
* <a href="http://neondataskills.org/R/Raster-Data-In-R/" target="_blank" >
NEON Data Skills: Raster Data in R - The Basics</a>
* <a href="http://neondataskills.org/R/Image-Raster-Data-In-R/" target="_blank" >
NEON Data Skills: Image Raster Data in R - An Intro</a>

</div>

### Clean Data
No dataset is perfect. It is common to encounter large files containing obviously
erroneous data (bad data).  It is also common to encounter `NoData`
values that we need to account for when analyzing our data.

## NoData Values (NA, NAN)
If we are lucky when working with external data, the `NoData` value is clearly
specified in the metadata. Sometimes this value is `NA` or `nan` (not a number). However,
`NA` isn't always used. Text values can make data storage difficult for some
programs and thus, sometimes you'll encounter a large negative value such as
`-9999` used as the `NoData` value. At other times, we might see blank values in
a data file which designate `NoData`. Blanks are particularly problematic
because we can't be certain if a data value is purposefully missing (not
measured that day or a bad measurement) or if someone unintentionally deleted
it.

<i class="fa fa-star"></i> **Data Tip:**`-9999` is a common value used in
both the remote sensing field and the atmospheric fields. It is also
the standard used by the <a href="http://www.neoninc.org" target="_blank">
National Ecological Observatory Network (NEON)</a>.
{: .notice}

Because the actual value used to designate missing data can vary depending upon
what data we are working with, it is important to always check the metadata for
the files associated `NoData` value. If the value is `NA`, we are in luck, `R`
will recognize and flag this value as `NoData`. If the value is numeric (e.g.,
`-9999`),then we might need to assign this value to `NA`.

<i class="fa fa-star"></i> **Data Tip:** `NA` values will be ignored when
performing calculations in `R`. However a `NoData` value of `-9999` will be
recognized as an integer and processed accordingly. If you encounter a numeric
`NoData` value be sure to assign it to `NA` in `R`:
`objectName[objectName==-9999] <- NA`
{: .notice}

### Check for NA values
We can quickly check for `NoData` values in our data using the`is.na()`
function. By asking for the `sum()` of `is.na()` we can see how many NA / missing
values we have.

REPLACE CODE TO BE FOR THE SAME SMALLISH DATA SET USED FOR BAD DATA VALUES BELOW

```r
# Check for NA values
sum(is.na(harMet15.09.11$datetime))
```

```
## Error in eval(expr, envir, enclos): object 'harMet15.09.11' not found
```

```r
sum(is.na(harMet15.09.11$airt))
```

```
## Error in eval(expr, envir, enclos): object 'harMet15.09.11' not found
```

```r
# view rows where the air temperature is NA
harMet15.09.11[is.na(harMet15.09.11$airt),]
```

```
## Error in eval(expr, envir, enclos): object 'harMet15.09.11' not found
```

The results above tell us there are `NoData` values in the `datetime` column.
However, there are `NoData` values in other variables.

### Deal with NoData Values
When we encounter `NoData` values (blank, NaN, -9999, etc.) in our data we
need to decide how to deal with them. By default `R` treats `NoData` values
designated
with a `NA` as a missing value rather than a zero. This is good, as a value of
zero (no rain today) is not the same as missing data (e.g. we didn't measure the
amount of rainfall today).

How we deal with `NoData` values will depend on:

* the data type we are working with
* the analysis we are conducting
* the significance of the gap or missing value

Sometimes we might need to "gap fill" our data. This means we will interpolate
or estimate missing values often using statistical methods. Gap filling can be
complex and is beyond the scope of this lesson. The take away from this lessons
is simply that it is important to acknowledge missing values in your data and to
carefully consider how you wish to account for them during analysis.

Other resources:

1. <a href="http://www.statmethods.net/input/missingdata.html" target="_blank"> Quick-R: Missing Data</a>
-- R code for dealing with missing data
2. The Institute for Digital Research and Education has an <a href="http://www.ats.ucla.edu/stat/r/faq/missing.htm" target="_blank"> R FAQ on Missing Values</a>.

## Bad Data Values
Bad data values are different from `NoDataValue`. Bad data values are values that
fall outside of the applicable range of a dataset.
Examples of Bad Data Values:

* The normalized difference vegetation index (NDVI), which is a measure of
greenness, has a valid range of -1 to 1. Any value outside of that range would
be considered a "bad" or miscalculated value.
* If we are using a Julian day (0-365/366) to represent the days of the year. A value
of 1110 is clearly not correct.

### Find Bad Data Values
Sometimes a dataset's metadata will tell us the range of expected values for a
variable or common sense dictates the expected value (as in the Julian day example above).
Values outside of this range are suspect and we need to consider than
when we analyze the data. Sometimes, we need to use some common sense and
scientific insight as we examine the data - just as we would for field data to
identify questionable values.

We can explore the distribution of values contained within our data using the
`hist` function which produces a histogram. Histograms are often useful in
identifying outliers and bad data values in our raster data.

HIST of SMALLISH DATA SET WITH SOME OUTLANDISH VALUE


### Deal with Bad Data Values
