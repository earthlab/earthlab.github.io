---
layout: single
title: "Programmatically accessing geospatial data using API's - Working with and mapping JSON data from the Colorado Information Warehouse in R"
excerpt: "This lesson walks through the process of retrieving and manipulating surface water data housed in the Colorado Information Warehouse. These data are stored in JSON format with spatial x, y information that support mapping."
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-04-04'
category: [course-materials]
class-lesson: ['intro-APIs-r']
permalink: /course-materials/earth-analytics/week-10/co-water-data-spatial-r/
nav-title: 'Geospatial data from APIs'
week: 10
sidebar:
  nav:
author_profile: false
comments: true
order: 5
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Extract geospatial (x,y) coordinate information embedded within a JSON hierarchical data structure.
* Use the `flatten()` function to remove nested data.frames from data imported in JSON format.
* Create a map of geospatial data using `ggmap()`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>



In the previous lesson, we learned how to work with JSON data accessed
via the Colorado information warehouse. In this lesson, we will explore another
dataset however this time, the data will contain geospatial information nested
within it that will allow us to create a map of the data.


## Working with geospatial data

Check out the map <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions-Map-Statewide/j5pc-4t32" target="_blank"> Colorado DWR Current Surface Water Conditions map</a>. If you rememeber from the previous lesson, APIs can be used for
many different things. Web developers (people who program and create web sites and
cool applications) can use API's to create user friendly interfaces - like the
map in this link that allow us to look at and interact with data. These API's
are similar to - if not the same as the ones that we often use to access data in R.

In this lesson, we wil access the data used to create the map at the link above -
in R.

* The data that we will use are located here: <a href="https://data.colorado.gov/resource/j5pc-4t32.json" target="_blank">View JSON format data used to create surface water map.</a>
* And you can learn more about the data here: <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions/4yw9-a5y6" target="_blank">View CO Current water surface </a>.



```r

water_base_url = "https://data.colorado.gov/resource/j5pc-4t32.json?"
water_full_url = paste0(water_base_url, "station_status=Active",
            "&county=BOULDER")
water_data = getURL(URLencode(water_full_url))
water_data_df <- fromJSON(water_data)
```

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
object, is nested with 3 sub objects:

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

Next, let's look at the structure of the data.frame that R creates from the
.json data.


```r
# view data structure
str(water_data_df)
## 'data.frame':	53 obs. of  15 variables:
##  $ station_name   : chr  "FOUR MILE CREEK AT LOGAN MILL ROAD NEAR CRISMAN, CO" "GOODING A AND D PLUMB DITCH" "BOULDER RESERVOIR INLET" "SAINT VRAIN SUPPLY CANAL NEAR LYONS, CO" ...
##  $ amount         : chr  "17.00" "7.20" "0.00" "46.70" ...
##  $ station_status : chr  "Active" "Active" "Active" "Active" ...
##  $ county         : chr  "BOULDER" "BOULDER" "BOULDER" "BOULDER" ...
##  $ wd             : chr  "6" "6" "6" "5" ...
##  $ dwr_abbrev     : chr  "FRMLMRCO" "GOOPLMCO" "BFCINFCO" "SVSLYOCO" ...
##  $ data_source    : chr  "U.S. Geological Survey (Data Provider)" "Cooperative Program of CDWR, NCWCD & LSPWCD" "Northern Colorado Water Conservancy District (Data Provider)" "Northern Colorado Water Conservancy District (Station Cooperator)" ...
##  $ http_linkage   :'data.frame':	53 obs. of  1 variable:
##   ..$ url: chr  "http://waterdata.usgs.gov/nwis/uv?06727410" "http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=GOOPLMCO&MTYPE=DISCHRG" "http://www.northernwater.org/WaterProjects/EastSlopeWaterData.aspx" "http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=SVSLYOCO&MTYPE=DISCHRG" ...
##  $ div            : chr  "1" "1" "1" "1" ...
##  $ date_time      : chr  "2013-09-20T08:10:00" "2016-11-16T15:00:00" "2017-04-03T08:30:00" "2017-04-04T12:30:00" ...
##  $ usgs_station_id: chr  "06727410" NA "ES1916" NA ...
##  $ variable       : chr  "DISCHRG" "DISCHRG" "DISCHRG" "DISCHRG" ...
##  $ location       :'data.frame':	53 obs. of  3 variables:
##   ..$ latitude      : chr  "40.042028" "40.09404" "40.849982" "40.2172" ...
##   ..$ needs_recoding: logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
##   ..$ longitude     : chr  "-105.364917" "-105.05447" "-105.218036" "-105.259161" ...
##  $ station_type   : chr  "Stream" "Diversion" "Stream" "Diversion" ...
##  $ stage          : chr  NA "0.47" "0.00" "0.90" ...
```

In this case, we have a data.frame nested within a data.frame.


```r
# view first 6 lines of the location nested data.frame
head(water_data_df$location)
##    latitude needs_recoding   longitude
## 1 40.042028          FALSE -105.364917
## 2  40.09404          FALSE  -105.05447
## 3 40.849982          FALSE -105.218036
## 4   40.2172          FALSE -105.259161
## 5 40.216093          FALSE -105.258323
## 6 40.214984          FALSE -105.256647
# view for 6 lines of the location.latitude column
head(water_data_df$location$latitude)
## [1] "40.042028" "40.09404"  "40.849982" "40.2172"   "40.216093" "40.214984"
```

We can remove the nesting using the `flatten()` function in `R`. When we flatten
our `json` data, `R` creates new columns for each nested data.frame column. In this
case it creates a unique column for latitude and longitude. Notice that the name
of each new column contains the name of the previously nested `data.frame` followed
by a period, and then the column name. For example

`location.latitude`



```r
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)
water_data_df$location.latitude
##  [1] "40.042028" "40.09404"  "40.849982" "40.2172"   "40.216093"
##  [6] "40.214984" "39.931096" NA          NA          NA         
## [11] "40.125542" "40.21804"  "40.006374" "39.961655" "39.938598"
## [16] "39.931099" "40.256031" "40.255581" "40.15336"  "40.193757"
## [21] "40.18188"  "40.187577" "40.19932"  "40.174844" "40.18858" 
## [26] "40.134278" "40.20419"  "40.173949" "40.172925" "40.19642" 
## [31] "40.2125"   "40.21266"  "40.187524" NA          "40.153341"
## [36] "40.21139"  "40.1946"   "40.170997" "40.160347" "40.21905" 
## [41] "40.21108"  "40.193018" "40.172677" "40.172677" "40.19328" 
## [46] "40.18503"  "40.051652" "40.053036" "40.733879" "39.98617" 
## [51] "40.018667" "40.05366"  NA
```
Now we can clean up the data. Notice that our longitude and latitude values
are in quotes. What does this mean about the structure of the data?



```r
str(water_data_df$location.latitude)
##  chr [1:53] "40.042028" "40.09404" "40.849982" "40.2172" ...
```

In order to map or work with latitude and longitude data, we need numeric values.
We can use the same dplyr function - `mutate_each_()` - that we used in the
previous lessons, to convert columns that are numbers to `numeric` rather than
`char` data types:

Notice in the code below that there is an addition pipe that removes NA values
(missing latitude values) from the dataset. We want to create a map of these
data. We will not be able to map points with missing X,Y coordinate locations
so it is best to remove them.


```r
# where are the cells with NA values in our data?
is.na(water_data_df$location.latitude)
##  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE
## [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [34]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
```

Note, in the code above, we can identify each location where there is a NA value
in our data. If we add an `!` to our code, R returns the INVERSE of the above.


```r
# where are calls with values in our data?
!is.na(water_data_df$location.latitude)
##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE
## [12]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [23]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [34] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [45]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE
```

Thus in our dplyr pipe, the code below removes all ROWS cells with a NA value
in the latitude column.

Remove NA Values: `filter(!is.na(location.latitude))`


```r
# turn columns to numeric and remove NA values
water_data_df <- water_data_df %>%
  mutate_each_(funs(as.numeric), c( "amount", "location.longitude", "location.latitude")) %>%
  filter(!is.na(location.latitude))
```

Now we can plot the data


```r
ggplot(water_data_df, aes(location.longitude, location.latitude, size=amount,
  color=station_type)) +
  geom_point() + coord_equal() +
      labs(x="Longitude",
           y="Latitude",
          title="Surface Water Site Locations by Type",
          subtitle = "Boulder, Colorado") +
  labs(size="Amount", colour="Station Type")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2016-12-06-api05-rcurl-co-data-spatial-data-r/water_data_plot1-1.png" title="ggplot of water surface data." alt="ggplot of water surface data." width="100%" />

Plotting the data using `ggplot()` creates a scatterplot of longitude and latitude,
with some minor aesthetic tweaks. We really want to create a web
map like the <a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions-Map-Statewide/j5pc-4t32" target="_blank"> Colorado DWR Current Surface Water Conditions map</a>.


We can create a non-interactive version of this map using the `ggmap()`
package in `R`. We used `ggmap()` earlier in the semester. It provides an
efficient way to quickly draw a basemap on the fly. We can overlay our data
on top of that basemap to create a nice static map.


```r
boulder <- get_map(location="Boulder, CO, USA",
                  source="google", crop=FALSE, zoom=10)
## Error in eval(expr, envir, enclos): could not find function "get_map"
ggmap(boulder) +
  geom_point(data=water_data_df, aes(location.longitude, location.latitude, size=amount,
  color=factor(station_type)))
## Error in eval(expr, envir, enclos): could not find function "ggmap"
```

In the next lesson, we will learn how to create interactive maps using the leaflet
package for `R`.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>
* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>
