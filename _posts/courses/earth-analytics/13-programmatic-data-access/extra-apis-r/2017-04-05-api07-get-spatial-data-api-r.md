---
layout: single
title: "Programmatically Accessing Geospatial Data Using API's - Working with and Mapping JSON Data from the Colorado Information Warehouse in R"
excerpt: "This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping."
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-APIs-r']
permalink: /courses/earth-analytics/get-data-using-apis/co-water-data-spatial-r/
nav-title: 'Geospatial Data From APIs'
week: 13
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 7
topics:
  find-and-manage-data: ['apis', 'find-data']
redirect_from:
   - "/courses/earth-analytics/week-10/co-water-data-spatial-r/"
---

{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Extract geospatial (x,y) coordinate information embedded within a JSON hierarchical data structure.
* Use the `flatten()` function to remove nested data.frames from data imported in JSON format.
* Create a map of geospatial data using `ggmap()`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>



In the previous lesson, you learned how to work with JSON data accessed
via the Colorado information warehouse. In this lesson, you will explore another
dataset however this time, the data will contain geospatial information nested
within it that will allow us to create a map of the data.


## Working with Geospatial Data

Check out the map <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions-Map-Statewide/j5pc-4t32" target="_blank"> Colorado DWR Current Surface Water Conditions map</a>. If you remember from the previous lesson, APIs can be used for
many different things. Web developers (people who program and create web sites and
cool applications) can use API's to create user friendly interfaces - like the
map in this link that allow us to look at and interact with data. These API's
are similar to - if not the same as the ones that you often use to access data in `R`.

In this lesson, you will access the data used to create the map at the link above -
in `R`.

* The data that you will use are located here: <a href="https://data.colorado.gov/resource/j5pc-4t32.json" target="_blank">View JSON format data used to create surface water map.</a>
* And you can learn more about the data here: <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions/4yw9-a5y6" target="_blank">View CO Current water surface </a>.


```r
# load packages
library(dplyr)
library(ggplot2)
library(rjson)
library(jsonlite)
```


```r
# get URL
water_base_url <- "https://data.colorado.gov/resource/j5pc-4t32.json?"
water_full_url <- paste0(water_base_url, "station_status=Active",
            "&county=BOULDER")
water_data_url <- URLencode(water_full_url)

water_data_df <- fromJSON(water_data_url)
```

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **ATTENTION WINDOWS USERS:**
We have noticed a bug where on windows machines, sometimes the https URL doesn't work.
Instead try the same url as above but without the `s` - like this: `water_base_url <- "http://data.colorado.gov/resource/j5pc-4t32.json?"` This change has resolved many
issues on windows machines so give it a try if you are having problems with the API.
{: .notice--success }



Remember that the JSON structure supports hierarchical data and can be NESTED.

```json
[ {
  "station_name" : "SOUTH PLATTE RIVER AT COOPER BRIDGE NEAR BALZAC",
  "amount" : "262.00",
  "flag" : "na",
  "station_status" : "Gage temporarily anavailable",
  "county" : "MORGAN",
  "wd" : "1",
  "dwr_abbrev" : "PLABALCO",
  "data_source" : "Co. Division of Water Resources",
  "http_linkage" : {
    "url" : "http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=PLABALCO&MTYPE=DISCHRG"
  },
  "div" : "1",
  "date_time" : "2017-02-15T09:00:00",
  "stage" : "1.86",
  "usgs_station_id" : "06759910",
  "variable" : "DISCHRG",
  "location" : {
    "latitude" : "40.357498",
    "needs_recoding" : false,
    "longitude" : "-103.528053"
  },
  "station_type" : "Stream"
}
...
]
```


If you look at the structure of the .json file below, you can see that the location
object, is nested with three sub objects:

* latitude
* needs_recoding
* longitude


```json
[ {
"div" : "1",
"date_time" : "2017-02-15T09:00:00",
"stage" : "1.86",
"usgs_station_id" : "06759910",
"variable" : "DISCHRG",
"location" : {
  "latitude" : "40.357498",
  "needs_recoding" : false,
  "longitude" : "-103.528053"
},
"station_type" : "Stream"
}
...
]
```

Next, let's look at the structure of the data.frame that `R` creates from the
.json data.


```r
# view data structure
typeof(water_data_df)
## [1] "list"
```

In this case, you have a `data.frame` nested within a `data.frame`.


```r
# view first 6 lines of the location nested data.frame
head(water_data_df$location)
##    latitude needs_recoding   longitude
## 1 40.256031          FALSE -105.209549
## 2 40.255581          FALSE -105.209595
## 3  40.15336          FALSE  -105.08869
## 4 40.215772          FALSE -105.367197
## 5 40.193757          FALSE  -105.21039
## 6  40.18188          FALSE  -105.19677
# view for 6 lines of the location.latitude column
head(water_data_df$location$latitude)
## [1] "40.256031" "40.255581" "40.15336"  "40.215772" "40.193757" "40.18188"
```

You can remove the nesting using the `flatten()` function in `R`. When you flatten
your `json` data, `R` creates new columns for each nested data.frame column. In this
case it creates a unique column for latitude and longitude. Notice that the name
of each new column contains the name of the previously nested `data.frame` followed
by a period, and then the column name. For example

`location.latitude`



```r
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)
water_data_df$location.latitude
##  [1] "40.256031" "40.255581" "40.15336"  "40.215772" "40.193757"
##  [6] "40.18188"  "40.187577" "40.19932"  "40.174844" "40.214984"
## [11] "40.18858"  "40.134278" "40.20419"  "40.173949" "40.172925"
## [16] "40.19642"  "40.2125"   "40.21266"  "40.187524" NA         
## [21] "40.21804"  "40.153341" "40.21139"  "40.1946"   "40.170997"
## [26] "40.160347" "40.21905"  "40.21108"  "40.193018" "40.172677"
## [31] "40.172677" "40.19328"  "40.18503"  "40.051652" "40.006374"
## [36] "40.053036" "40.733879" "40.849982" "39.98617"  "40.042028"
## [41] "40.018667" "40.09404"  NA          "40.05366"  "39.961655"
## [46] NA          "39.938598" "39.931096" "39.931099"
```
Now you can clean up the data. Notice that your longitude and latitude values
are in quotes. What does this mean about the structure of the data?



```r
str(water_data_df$location.latitude)
##  chr [1:49] "40.256031" "40.255581" "40.15336" "40.215772" "40.193757" ...
```

In order to map or work with latitude and longitude data, you need numeric values.
You can use the same dplyr function - `mutate_at()` - that you used in the
previous lessons, to convert columns that are numbers to `numeric` rather than
`char` data types:

Notice in the code below that there is an addition pipe that removes NA values
(missing latitude values) from the dataset. You want to create a map of these
data. You will not be able to map points with missing X,Y coordinate locations
so it is best to remove them.


```r
# where are the cells with NA values in your data?
is.na(water_data_df$location.latitude)
##  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
## [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE
## [45] FALSE  TRUE FALSE FALSE FALSE
```

Note, in the code above, you can identify each location where there is a NA value
in your data. If you add an `!` to your code, `R` returns the INVERSE of the above.


```r
# where are calls with values in your data?
!is.na(water_data_df$location.latitude)
##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [12]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE
## [23]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [34]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
## [45]  TRUE FALSE  TRUE  TRUE  TRUE
```

Thus in your dplyr pipe, the code below removes all ROWS cells with a NA value
in the latitude column.

Remove NA Values: `filter(!is.na(location.latitude))`


```r
# turn columns to numeric and remove NA values
water_data_df <- water_data_df %>%
  mutate_at(c( "amount", "location.longitude", "location.latitude"),
            as.numeric) %>%
  filter(!is.na(location.latitude))
```

Now you can plot the data


```r
ggplot(water_data_df, aes(location.longitude, location.latitude, size = amount,
  color = station_type)) +
  geom_point() + coord_equal() +
      labs(x = "Longitude",
           y = "Latitude",
          title = "Surface Water Site Locations by Type",
          subtitle = "Boulder, Colorado") +
  labs(size = "Amount", colour = "Station Type")
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/extra-apis-r/2017-04-05-api07-get-spatial-data-api-r/water_data_plot1-1.png" title="ggplot of water surface data." alt="ggplot of water surface data." width="90%" />

Plotting the data using `ggplot()` creates a scatterplot of longitude and latitude,
with some minor aesthetic tweaks. You really want to create a web
map like the <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions-Map-Statewide/j5pc-4t32" target="_blank"> Colorado DWR Current Surface Water Conditions map</a>.


You can create a non-interactive version of this map using the `ggmap()`
package in `R`. You used `ggmap()` earlier in the semester. It provides an
efficient way to quickly draw a basemap on the fly. You can overlay your data
on top of that basemap to create a nice static map.


```r
boulder <- get_map(location = "Boulder, CO, USA",
                  source = "google", crop = FALSE, zoom = 10)
ggmap(boulder) +
  geom_point(data = water_data_df, aes(location.longitude, location.latitude, size = amount,
  color = factor(station_type)))
```

<img src="{{ site.url }}/images/rfigs/courses/earth-analytics/13-programmatic-data-access/extra-apis-r/2017-04-05-api07-get-spatial-data-api-r/create_ggmap-1.png" title="GGMAP of water surface data" alt="GGMAP of water surface data" width="90%" />

In the next lesson, you will learn how to create interactive maps using the leaflet
package for `R`.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>
* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>
