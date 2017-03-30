---
layout: single
title: "An example of creating modular code in R - Efficient scientific programming"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-03-30'
category: [course-materials]
class-lesson: ['intro-APIs-r']
permalink: /course-materials/earth-analytics/week-10/co-water-data-spatial-r/
nav-title: 'geospatial API'
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

You will need a computer with internet access to complete this lesson and the
data that we already downloaded for week 6 of the course.

{% include/data_subsets/course_earth_analytics/_data-week6-7.md %}
</div>




## Working with geospatial data

<a href="https://data.colorado.gov/Water/DWR-Current-Surface-Water-Conditions-Map-Statewide/j5pc-4t32" target="_blank"> Colorado DWR Current Surface Water Conditions</a> via `SODA`



```r

water_base_url = "https://data.colorado.gov/resource/j5pc-4t32.json?"
water_full_url = paste0(water_base_url, "station_status=Active",
            "&county=BOULDER")
water_data = getURL(URLencode(water_full_url))
water_data_df <- fromJSON(water_data)
head(water_data_df)
##                                               station_name amount
## 1 BOULDER CREEK SUPPLY CANAL TO BOULDER CREEK NEAR BOULDER  33.05
## 2      FOUR MILE CREEK AT LOGAN MILL ROAD NEAR CRISMAN, CO  17.00
## 3                           FOURMILE CREEK AT ORODELL, CO.   0.79
## 4                              GOODING A AND D PLUMB DITCH   7.20
## 5                                              NIWOT DITCH   0.71
## 6               RURAL DITCH TAIL RETURN TO ST. VRAIN CREEK   1.55
##   station_status  county wd dwr_abbrev
## 1         Active BOULDER  6   BCSCBCCO
## 2         Active BOULDER  6   FRMLMRCO
## 3         Active BOULDER  6   FOUOROCO
## 4         Active BOULDER  6   GOOPLMCO
## 5         Active BOULDER  5   NIWDITCO
## 6         Active BOULDER  5   RUTAILCO
##                                                    data_source
## 1 Northern Colorado Water Conservancy District (Data Provider)
## 2                       U.S. Geological Survey (Data Provider)
## 3                       U.S. Geological Survey (Data Provider)
## 4                  Cooperative Program of CDWR, NCWCD & LSPWCD
## 5                 Cooperative Program of CDWR, NCWCD & SVLHWCD
## 6                      Cooperative SDR Program of CDWR & NCWCD
##                                                                                        url
## 1                       http://www.northernwater.org/WaterProjects/EastSlopeWaterData.aspx
## 2                                               http://waterdata.usgs.gov/nwis/uv?06727410
## 3                                               http://waterdata.usgs.gov/nwis/uv?06727500
## 4 http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=GOOPLMCO&MTYPE=DISCHRG
## 5 http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=NIWDITCO&MTYPE=DISCHRG
## 6 http://www.dwr.state.co.us/SurfaceWater/data/detail_graph.aspx?ID=RUTAILCO&MTYPE=DISCHRG
##   div           date_time usgs_station_id variable location.latitude
## 1   1 2017-03-14T08:45:00          ES1917  DISCHRG         40.053036
## 2   1 2013-09-20T08:10:00        06727410  DISCHRG         40.042028
## 3   1 2016-10-03T07:10:00        06727500  DISCHRG         40.018667
## 4   1 2016-11-16T15:00:00            <NA>  DISCHRG          40.09404
## 5   1 2017-03-20T13:45:00        NIWDITCO  DISCHRG         40.173949
## 6   1 2017-03-23T21:45:00        RUTAILCO  DISCHRG              <NA>
##   location.needs_recoding location.longitude station_type stage flag
## 1                   FALSE        -105.193048    Diversion  <NA> <NA>
## 2                   FALSE        -105.364917       Stream  <NA> <NA>
## 3                   FALSE         -105.32625       Stream  <NA> <NA>
## 4                   FALSE         -105.05447    Diversion  0.47 <NA>
## 5                   FALSE        -105.169374    Diversion  0.21 <NA>
## 6                      NA               <NA>    Diversion  0.18 <NA>
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

Remember that the JSON structure is hierarchical and often NESTED. In this case,
we have a nested data.frame within a data frame.

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
## 8   40.21905          FALSE  -105.25979
## 9  40.125542          FALSE -105.303879
## 10 40.160347          FALSE -105.007828
## 11      <NA>             NA        <NA>
## 12 40.256031          FALSE -105.209549
## 13 40.255581          FALSE -105.209595
## 14  40.15336          FALSE  -105.08869
## 15 40.193757          FALSE  -105.21039
## 16  40.18188          FALSE  -105.19677
## 17 40.187577          FALSE  -105.18919
## 18  40.19932          FALSE  -105.22264
## 19 40.174844          FALSE -105.167873
## 20  40.18858          FALSE  -105.20928
## 21 40.134278          FALSE -105.130819
## 22  40.20419          FALSE  -105.21878
## 23 40.172925          FALSE -105.167621
## 24  40.19642          FALSE  -105.20659
## 25   40.2125          FALSE  -105.25183
## 26  40.21266          FALSE  -105.25183
## 27 40.187524          FALSE -105.189132
## 28  40.21804          FALSE -105.259987
## 29  40.21139          FALSE  -105.25095
## 30   40.1946          FALSE   -105.2298
## 31 40.170997          FALSE -105.160875
## 32  40.21108          FALSE  -105.25093
## 33 40.193018          FALSE -105.210388
## 34 40.172677          FALSE  -105.04463
## 35 40.172677          FALSE  -105.04463
## 36  40.19328          FALSE -105.210424
## 37  40.18503          FALSE  -105.18579
## 38 40.051652          FALSE -105.178875
## 39 40.006374          FALSE -105.330826
## 40 40.849982          FALSE -105.218036
## 41  39.98617          FALSE  -105.21868
## 42  40.05366          FALSE  -105.15114
## 43 39.961655          FALSE  -105.50444
## 44      <NA>             NA        <NA>
## 45 39.938598          FALSE -105.349161
## 46 39.931099          FALSE -105.295822
## 47 40.153341          FALSE -105.075695
## 48 40.216093          FALSE -105.258323
## 49 40.214984          FALSE -105.256647
## 50 40.733879          FALSE -105.212237
## 51 39.931096          FALSE -105.295838
## 52      <NA>             NA        <NA>
## 53      <NA>             NA        <NA>
water_data_df$location$latitude
##  [1] "40.053036" "40.042028" "40.018667" "40.09404"  "40.173949"
##  [6] NA          "40.2172"   "40.21905"  "40.125542" "40.160347"
## [11] NA          "40.256031" "40.255581" "40.15336"  "40.193757"
## [16] "40.18188"  "40.187577" "40.19932"  "40.174844" "40.18858" 
## [21] "40.134278" "40.20419"  "40.172925" "40.19642"  "40.2125"  
## [26] "40.21266"  "40.187524" "40.21804"  "40.21139"  "40.1946"  
## [31] "40.170997" "40.21108"  "40.193018" "40.172677" "40.172677"
## [36] "40.19328"  "40.18503"  "40.051652" "40.006374" "40.849982"
## [41] "39.98617"  "40.05366"  "39.961655" NA          "39.938598"
## [46] "39.931099" "40.153341" "40.216093" "40.214984" "40.733879"
## [51] "39.931096" NA          NA
```

We can remove the nesting using the flatten() function in R! Creates 2 new columns
in our data.frame. One for latitute and one for longitude. Notice that the name
of each new column contains the name of the previously nested data.frame followed
by a period, and then the column name. For example

`location.latitude`



```r
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)
water_data_df$location.latitude
##  [1] "40.053036" "40.042028" "40.018667" "40.09404"  "40.173949"
##  [6] NA          "40.2172"   "40.21905"  "40.125542" "40.160347"
## [11] NA          "40.256031" "40.255581" "40.15336"  "40.193757"
## [16] "40.18188"  "40.187577" "40.19932"  "40.174844" "40.18858" 
## [21] "40.134278" "40.20419"  "40.172925" "40.19642"  "40.2125"  
## [26] "40.21266"  "40.187524" "40.21804"  "40.21139"  "40.1946"  
## [31] "40.170997" "40.21108"  "40.193018" "40.172677" "40.172677"
## [36] "40.19328"  "40.18503"  "40.051652" "40.006374" "40.849982"
## [41] "39.98617"  "40.05366"  "39.961655" NA          "39.938598"
## [46] "39.931099" "40.153341" "40.216093" "40.214984" "40.733879"
## [51] "39.931096" NA          NA
```
Now we can clean up the data. Notice that our longitude and latitude are in quotes.
What does this mean about the structure of the data?


```r
str(water_data_df$location.latitude)
##  chr [1:53] "40.053036" "40.042028" "40.018667" "40.09404" ...
```



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
      labs(x="Year",
           y="Female Population",
          title="Projected Female Population",
          subtitle = "Boulder, CO: 1990 - 2040")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2016-12-06-api05-rcurl-co-data-spatial-data-r/water_data_plot1-1.png" title=" " alt=" " width="100%" />


It is often useful to explore you geospatial data in context (that's why `GIS` is so useful!). But instead of exporting your data to a shapefile and working in `QGIS` or similar, we can create maps directly in `R`...

Basic Mapping in R

- That last 'map' was really just a scatterplot of long/lat, with some minor aesthetic tweaks
- The `ggmap` package provides an interface to Google maps and others
    - So we can download 'basemaps' on the fly and plot them:


```r
boulder <- get_map(location="Boulder, CO, USA",
                  source="google", crop=FALSE, zoom=10)
ggmap(boulder) +
  geom_point(data=water_data_df, aes(location.longitude, location.latitude, size=amount,
  color=factor(station_type)))
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2016-12-06-api05-rcurl-co-data-spatial-data-r/create_ggmap-1.png" title=" " alt=" " width="100%" />


<div class="notice--info" markdown="1">

## Additional Resources

* <a href="https://blog.datafiniti.co/4-reasons-you-should-use-json-instead-of-csv-2cac362f1943" target="_blank">why you should use JSON instead of csv.</a>
* <a href="https://www.w3schools.com/js/js_json_intro.asp" target="_blank">W3schools JSON intro </a>

</div>
