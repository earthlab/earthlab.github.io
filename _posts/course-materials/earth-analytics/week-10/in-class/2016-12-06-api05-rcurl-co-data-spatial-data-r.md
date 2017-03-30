---
layout: single
title: "An example of creating modular code in R - Efficient scientific programming"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-03-30'
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

*

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
## 'data.frame':	53 obs. of  16 variables:
##  $ station_name   : chr  "BOULDER CREEK SUPPLY CANAL TO BOULDER CREEK NEAR BOULDER" "FOUR MILE CREEK AT LOGAN MILL ROAD NEAR CRISMAN, CO" "FOURMILE CREEK AT ORODELL, CO." "GOODING A AND D PLUMB DITCH" ...
##  $ amount         : chr  "33.05" "17.00" "0.79" "7.20" ...
##  $ station_status : chr  "Active" "Active" "Active" "Active" ...
##  $ county         : chr  "BOULDER" "BOULDER" "BOULDER" "BOULDER" ...
##  $ wd             : chr  "6" "6" "6" "6" ...
##  $ dwr_abbrev     : chr  "BCSCBCCO" "FRMLMRCO" "FOUOROCO" "GOOPLMCO" ...
##  $ data_source    : chr  "Northern Colorado Water Conservancy District (Data Provider)" "U.S. Geological Survey (Data Provider)" "U.S. Geological Survey (Data Provider)" "Cooperative Program of CDWR, NCWCD & LSPWCD" ...
##  $ http_linkage   :'data.frame':	53 obs. of  1 variable:
##   ..$ url: chr  "http://www.northernwater.org/WaterProjects/EastSlopeWaterData.aspx" "http://waterdata.usgs.gov/nwis/uv?06727410" "http://waterdata.usgs.gov/nwis/uv?06727500" "http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=GOOPLMCO&MTYPE=DISCHRG" ...
##  $ div            : chr  "1" "1" "1" "1" ...
##  $ date_time      : chr  "2017-03-14T08:45:00" "2013-09-20T08:10:00" "2016-10-03T07:10:00" "2016-11-16T15:00:00" ...
##  $ usgs_station_id: chr  "ES1917" "06727410" "06727500" NA ...
##  $ variable       : chr  "DISCHRG" "DISCHRG" "DISCHRG" "DISCHRG" ...
##  $ location       :'data.frame':	53 obs. of  3 variables:
##   ..$ latitude      : chr  "40.053036" "40.042028" "40.018667" "40.09404" ...
##   ..$ needs_recoding: logi  FALSE FALSE FALSE FALSE FALSE NA ...
##   ..$ longitude     : chr  "-105.193048" "-105.364917" "-105.32625" "-105.05447" ...
##  $ station_type   : chr  "Diversion" "Stream" "Stream" "Diversion" ...
##  $ stage          : chr  NA NA NA "0.47" ...
##  $ flag           : chr  NA NA NA NA ...
```

In this case, we have a data.frame nested within a data.frame.


```r
water_data_df$location
##     latitude needs_recoding   longitude
## 1  40.053036          FALSE -105.193048
## 2  40.042028          FALSE -105.364917
## 3  40.018667          FALSE  -105.32625
## 4   40.09404          FALSE  -105.05447
## 5  40.173949          FALSE -105.169374
## 6       <NA>             NA        <NA>
## 7    40.2172          FALSE -105.259161
## 8  40.216093          FALSE -105.258323
## 9  40.214984          FALSE -105.256647
## 10 39.931096          FALSE -105.295838
## 11      <NA>             NA        <NA>
## 12      <NA>             NA        <NA>
## 13 40.160347          FALSE -105.007828
## 14      <NA>             NA        <NA>
## 15 40.125542          FALSE -105.303879
## 16  40.21804          FALSE -105.259987
## 17 40.006374          FALSE -105.330826
## 18 39.961655          FALSE  -105.50444
## 19 39.938598          FALSE -105.349161
## 20 39.931099          FALSE -105.295822
## 21 40.256031          FALSE -105.209549
## 22 40.255581          FALSE -105.209595
## 23  40.15336          FALSE  -105.08869
## 24 40.193757          FALSE  -105.21039
## 25  40.18188          FALSE  -105.19677
## 26 40.187577          FALSE  -105.18919
## 27  40.19932          FALSE  -105.22264
## 28 40.174844          FALSE -105.167873
## 29  40.18858          FALSE  -105.20928
## 30 40.134278          FALSE -105.130819
## 31  40.20419          FALSE  -105.21878
## 32 40.172925          FALSE -105.167621
## 33  40.19642          FALSE  -105.20659
## 34   40.2125          FALSE  -105.25183
## 35  40.21266          FALSE  -105.25183
## 36 40.187524          FALSE -105.189132
## 37 40.153341          FALSE -105.075695
## 38  40.21139          FALSE  -105.25095
## 39   40.1946          FALSE   -105.2298
## 40 40.170997          FALSE -105.160875
## 41  40.21905          FALSE  -105.25979
## 42  40.21108          FALSE  -105.25093
## 43 40.193018          FALSE -105.210388
## 44 40.172677          FALSE  -105.04463
## 45 40.172677          FALSE  -105.04463
## 46  40.19328          FALSE -105.210424
## 47  40.18503          FALSE  -105.18579
## 48 40.051652          FALSE -105.178875
## 49 40.733879          FALSE -105.212237
## 50 40.849982          FALSE -105.218036
## 51  39.98617          FALSE  -105.21868
## 52  40.05366          FALSE  -105.15114
## 53      <NA>             NA        <NA>
water_data_df$location$latitude
##  [1] "40.053036" "40.042028" "40.018667" "40.09404"  "40.173949"
##  [6] NA          "40.2172"   "40.216093" "40.214984" "39.931096"
## [11] NA          NA          "40.160347" NA          "40.125542"
## [16] "40.21804"  "40.006374" "39.961655" "39.938598" "39.931099"
## [21] "40.256031" "40.255581" "40.15336"  "40.193757" "40.18188" 
## [26] "40.187577" "40.19932"  "40.174844" "40.18858"  "40.134278"
## [31] "40.20419"  "40.172925" "40.19642"  "40.2125"   "40.21266" 
## [36] "40.187524" "40.153341" "40.21139"  "40.1946"   "40.170997"
## [41] "40.21905"  "40.21108"  "40.193018" "40.172677" "40.172677"
## [46] "40.19328"  "40.18503"  "40.051652" "40.733879" "40.849982"
## [51] "39.98617"  "40.05366"  NA
```

We can remove the nesting using the `flatten()` function in `R`. When we flatten
our json data, R creates new columns for each nested data.frame column. In this
case it creates a unique column for latitute and longitude. Notice that the name
of each new column contains the name of the previously nested data.frame followed
by a period, and then the column name. For example

`location.latitude`



```r
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)
water_data_df$location.latitude
##  [1] "40.053036" "40.042028" "40.018667" "40.09404"  "40.173949"
##  [6] NA          "40.2172"   "40.216093" "40.214984" "39.931096"
## [11] NA          NA          "40.160347" NA          "40.125542"
## [16] "40.21804"  "40.006374" "39.961655" "39.938598" "39.931099"
## [21] "40.256031" "40.255581" "40.15336"  "40.193757" "40.18188" 
## [26] "40.187577" "40.19932"  "40.174844" "40.18858"  "40.134278"
## [31] "40.20419"  "40.172925" "40.19642"  "40.2125"   "40.21266" 
## [36] "40.187524" "40.153341" "40.21139"  "40.1946"   "40.170997"
## [41] "40.21905"  "40.21108"  "40.193018" "40.172677" "40.172677"
## [46] "40.19328"  "40.18503"  "40.051652" "40.733879" "40.849982"
## [51] "39.98617"  "40.05366"  NA
```
Now we can clean up the data. Notice that our longitude and latitude values
are in quotes. What does this mean about the structure of the data?



```r
str(water_data_df$location.latitude)
##  chr [1:53] "40.053036" "40.042028" "40.018667" "40.09404" ...
```

In order to map or work with latitude and longitude data, we need numeric values.
We can use the same dplyr function - `mutate_each_()` - that we used in the
previous lessons, to convert columns that are numbers to `numeric` rather than
`char` data types:

Notice in the code below that there is an addition pipe that removes NA values
(missing latitude values) from the dataset. We know we want to create a map of these
data. We will not be able to map points with missing X,Y coordinate locations
so it is best to remove them.

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
          subtitle = "Boulder, Colorado")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2016-12-06-api05-rcurl-co-data-spatial-data-r/water_data_plot1-1.png" title=" " alt=" " width="100%" />

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
ggmap(boulder) +
  geom_point(data=water_data_df, aes(location.longitude, location.latitude, size=amount,
  color=factor(station_type)))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2016-12-06-api05-rcurl-co-data-spatial-data-r/create_ggmap-1.png" title=" " alt=" " width="100%" />

In the next lesson, we will learn how to create interactive maps using the leaflet
package for `R`.

<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">Why you should use JSON instead of csv.</a>
* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>
