---
layout: single
title: "Programmatically Access Data Using an API in R - The Colorado Information Warehouse"
excerpt: "This lesson covers accessing data via the Colorado Information Warehouse SODA API in R. "
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-APIs-r']
permalink: /courses/earth-analytics/get-data-using-apis/API-data-access-r/
nav-title: 'Get JSON Data via RESTful API'
week: 13
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  find-and-manage-data: ['apis', 'find-data']
redirect_from:
   - "/courses/earth-analytics/week-10/API-data-access-r/"
---

{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Access data from the Colorado information warehouse RESTful API.
* Describe and recognize query parameters in a RESTful call.
* Define: response and request relative to data API data access.
* Define API endpoint in the context of the SODA API.
* Be able to list the 2 potential responses that you may get when querying a RESTful API.
* Use the `mutate_at()` function with dplyr pipes to adjust the format / data type of multiple columns.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>



In the previous lessons, you learned how to access human readable text files data
programmatically using:

1. `download.file()` to download a file to your computer and work with it (ideal if you want to save a copy of the data to your computer)
1. `read.csv()` ideal for reading in a tabular file stored on the web but may sometimes fail when there are secure connections involved (e.g. https).
1. `fromJSON()` ideal for data accessed in JSON format.

In this lesson, you will learn about API interfaces. An API allows us to access
data stored on a computer or server using a specific query. API's are powerful
ways to access data and more specifically the specific type and subset of data
that you need for your analysis, programmatically.

You will also explore the **machine readable** JSON data structure. Machine readable
data structures are more efficient - particularly for larger data that contain
hierarchical structures. In this lesson, you will use the `getJSON()` function
from the `rjson` package to import data from an API, provided in `.json` format into
a data.frame.


```r
#NOTE: if you have problems with ggmap, try to install both ggplot and ggmap from github
#devtools::install_github("dkahle/ggmap")
#devtools::install_github("hadley/ggplot2")
library(ggmap)
library(ggplot2)
library(dplyr)
library(rjson)
library(jsonlite)
library(RCurl)
```



## REST API Review

Remember that in the first lesson in this module, you learned about **REST**ful APIs.
You explored the concept of a **request** and then a subsequent
**response**. The **request** to an **REST**ful API is composed of a URL and the
associated parameters required to access a particular subset of the data that you
wish to access.

When you send the request, the web API returns one of the following:

 1. The data that you requested or
 2. A *failed to return* message which tells us that something was wrong with your request.

In this lesson you will access data stored in JSON format from a RESTful API.

## Colorado Population Projection data

The <a href="https://data.colorado.gov" target="_blank">Colorado Information Marketplace</a>
is a comprehensive data warehouse that contains a wide range of Colorado-specific
open datasets available via a **REST**ful API called the Socrata Open Data API (SODA).


### API Endpoints

There are lots of API *endpoints* or data sets available via this API. An endpoint
refers to a dataset that you can access and query against.

> The “endpoint” of a (SODA) API is simply a unique URL that represents an object or collection of objects. Every Socrata dataset, and even every individual data record, has its own endpoint. The endpoint is what you'll point your HTTP client at to interact with data resources. <a href="https://dev.socrata.com/docs/endpoints.html" target="_blank">Read more about endpoints</a>

One endpoint on the CO information warehouse website contains
<a href="https://dev.socrata.com/foundry/data.colorado.gov/tv8u-hswn" target="_blank">Colorado Population Projections</a>.
If you click on the <a href="https://data.colorado.gov/resource/tv8u-hswn.json" target="_blank">Colorado Population Projections data link (JSON format)</a>
you will see data returned in a `JSON` format. These data include population
estimates for *males* and *females* for every *county* in Colorado for every *year* from 1990 to 2040 for multiple *age* groups.

### URL Parameters

Using `URL` parameters, you can define a more specific **request** to limit what data
you get back in **response** to your API **request**. For example, if you only want
data for Boulder, Colorado, you can query just that subset of the data using the
RESTful call. In the link below, note that the **?&county=Boulder** part of the
url makes the request to the API to only return data that are for Boulder
County, Colorado.

<a href="https://data.colorado.gov/resource/tv8u-hswn.json?&county=Boulder" target="_blank">Like this:  https://data.colorado.gov/resource/tv8u-hswn.json?&county=Boulder</a>.

Parameters associated with accessing data using this API are <a href="https://dev.socrata.com/foundry/data.colorado.gov/tv8u-hswn" target="_blank">documented here</a>.

## Using the Colorado SODA API

The Colorado `SODA` API allows us to write 'queries' that filter out the exact
subset of the data that you want. Here's the API `URL`
for population projections for females who live in Boulder that are age 20--40
for the years 2016--2025:

```html
https://data.colorado.gov/resource/tv8u-hswn.json?$where=age between 20 and 40 and year between 2016 and 2025&county=Boulder&$select=year,age,femalepopulation
```

<a href="https://data.colorado.gov/resource/tv8u-hswn.json?$where=age between 20 and 40 and year between 2016 and 2025&county=Boulder&$select=year,age,femalepopulation" target="_blank">Click here to view data. (JSON format)</a>.

### API Response

The data that are returned from an API **request** are called the **response**.
The format of the returned data or the **response** is most often in the form of
plain text 'file' such as `JSON` or `.csv`.

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** Many API's allow
us to specify the format of the data that you want returned in the response. <a href="https://dev.socrata.com/docs/formats/index.html" target="_blank">The Colorado SODA API is no exception - check out the documentation. </a>
{: .notice--success}

## Accessing API Data

The first thing that you need to do is create your API request string. Remember that
this is a `URL` with parameters parameters that specify which subset of the data
that you want to access.

Note that you are using a new function - `paste0()` - to paste together a complex
URL string. This is useful because you may want to iterate over different subsets
of the same data (ie reuse the base url or the endpoint but request different
subsets using different URL parameters).


```r
# Base URL path
base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url = paste0(base_url, "county=Boulder",
             "&$where=age between 20 and 40",
             "&$select=year,age,femalepopulation")

# view full url
full_url
## [1] "https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age between 20 and 40&$select=year,age,femalepopulation"
```

After you've created the URL, you can get the data. There are a few ways to access
the data however the most direct way is to

1. Use `encodeURL()` to replace spaces in your url with the asii value for space `%20`
1. Use the `fromJSON()` function in the rjson package to import that data into a data.frame object.

Let's give it a try. First, you encode the URL to replace all spaces with the ascii
value for a space which is `%20`.


```r
# encode the URL with characters for each space.
full_url <- URLencode(full_url)
full_url
## [1] "https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age%20between%2020%20and%2040&$select=year,age,femalepopulation"
```

Then, you import the data directly into a data.frame using the `fromJSON()` function
that is in the rjson package.


```r
library(rjson)

# Convert JSON to data frame
pop_proj_data_df <- fromJSON(getURL(full_url))
head(pop_proj_data_df, n = 2)
##   age femalepopulation year
## 1  20             2751 1990
## 2  21             2615 1990
typeof(pop_proj_data_df)
## [1] "list"
```







<div class="notice--success" markdown="1">
<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** The `getForm()`
is another way to access API driven data. You are not going to learn this in
this class however it is a good option that results in code that is a bit cleaner
given the various parameters are passed to the function via argument like
syntax.


```r
base_url_example <- "https://data.colorado.gov/resource/tv8u-hswn.json?"
getForm(base_url, county = "Boulder",
             age="BOULDER")
```

Also note that if you wanted to use `getURL()`, you could do so as follows:


```r
# get the data from the specified url using RCurl
pop_proj_data_example <- getURL(URLencode(full_url))
```

</div>

Now that your data are in a data.frame format, you can clean them up. Let's have a
close look at the data structure. Are the values in the correct format to work
with them quantitatively?


```r
# view data structure
str(pop_proj_data_df)
## 'data.frame':	1000 obs. of  3 variables:
##  $ age             : chr  "20" "21" "22" "23" ...
##  $ femalepopulation: chr  "2751" "2615" "2167" "1798" ...
##  $ year            : chr  "1990" "1990" "1990" "1990" ...
```


When you import the data from JSON, by default they import in string format. However,
if you want to plot the data and manipulate the data quantitatively, you need
your data to be in a numeric format. Let's fix that next.

### `mutate_at` from dplyr

You can uset the `mutate_at()` function in a dplyr pipe to change the format of
(or apply any function on) any columns within your data.frame. In this case you
want to convert all of the columns to a numeric format.

To use `mutate_at()` you specify the column names that you want to convert in a vector
followed by the function that you wish to apply to each column. THe function in this
case is `as.numeric()`.

Because you are using this function in a pipe, your code looks like this:



```r
# turn columns to numeric and remove NA values
pop_proj_data_df <- pop_proj_data_df %>%
 mutate_at(c( "age", "year", "femalepopulation"), as.numeric)

str(pop_proj_data_df)
## 'data.frame':	1000 obs. of  3 variables:
##  $ age             : num  20 21 22 23 24 25 26 27 28 29 ...
##  $ femalepopulation: num  2751 2615 2167 1798 1692 ...
##  $ year            : num  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
```

<div class="notice--success" markdown="1">
<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** Note that the
code below, is much more VERBOSE version of what you did above, in a clean way
using `mutate_at()`. dplyr is a much more efficient way to convert the format of several
columns of information!


```r
# convert EACH row to a numeric format
# note this is the clunky way to do what you did above with dplyr!
pop_proj_data_df$age <- as.numeric(pop_proj_data_df$age)
pop_proj_data_df$year <- as.numeric(pop_proj_data_df$year)
pop_proj_data_df$femalepopulation <- as.numeric(pop_proj_data_df$femalepopulation)

# OR use the apply function to convert all rows in the data.frame to numbers
#pops <- as.data.frame(lapply(pop_proj_data_df, as.numeric))
```

</div>


Once you have converted your data to a numeric format, you can plot it using `ggplot()`.



```r
# plot the data
ggplot(pop_proj_data_df, aes(x = year, y = femalepopulation,
 group = factor(age), color = age)) + geom_line() +
     labs(x = "Year",
          y = "Female Population - Age 20-40",
          title = "Projected Female Population",
          subtitle = "Boulder, CO: 1990 - 2040")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/extra-apis-r/2017-04-05-api05-get-data-api-r/plot_pop_proj-1.png" title="Female population age 20-40." alt="Female population age 20-40." width="90%" />



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge

Using the population projection data that you just used, create a plot of projected
MALE population numbers as follows:

* Time span: 1990-2040
* Column category: malepopulation
* Age range: 60-80 years old

Use `ggplot()` to create your plot and be sure to label x and y axes and give the
plot a descriptive title.
</div>

## Example Homework Plot

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/extra-apis-r/2017-04-05-api05-get-data-api-r/male-population-1.png" title="Male population ages 60-80." alt="Male population ages 60-80." width="90%" />



<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>
* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>
