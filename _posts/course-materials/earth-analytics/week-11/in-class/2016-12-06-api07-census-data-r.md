---
layout: single
title: "An example of creating modular code in R - Efficient scientific programming"
excerpt: "This lesson provides an example of modularizing code in R. "
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-04-04'
category: [course-materials]
class-lesson: ['census-data-r']
permalink: /course-materials/earth-analytics/week-11/census-data-r/
nav-title: 'Census data '
week: 11
sidebar:
  nav:
author_profile: false
comments: true
order: 1
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





```r
library("knitr")
library("dplyr")
library("ggplot2")
library("RCurl")
library("rjson")
library("jsonlite")
```


## US Census Data - Background

The United States Census bureau provides an incredible wealth of data that we can
use in our science. These data have not always been easy to work with. In the past,
the steps associated with working with Census data included:

* Downloading tabular data from <a href="http://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml" target="_blank">FactFinder</a>
* Getting shapefile(s) from <a href="https://www.census.gov/geo/maps-data/" target="_blank">boundary files site</a>
* Joining the tabular data with the shapefile spatial data

These steps were time consuming and left room for error.

## Census bureau API

Now, the U.S. Census bureau provides an API for accessing Census data. The API
can be complex to navigate and [requires authentication](http://api.census.gov/data/key_signup.html).

However, there are some R packages that make woring with the census data easier in R. We can use the:

* `acs` package by [Ezra Glenn](http://dusp.mit.edu/faculty/ezra-glenn) to download tabular data, and the
* `tigris` package by [Kyle Walker](http://personal.tcu.edu/kylewalker/) and [Bob Rudis](https://www.linkedin.com/in/hrbrmstr) to get TIGER (geospatial) data

Using these packages, the process:

* becomes more automated / less manual
* can be better documented
* and smoother in general


## API Authentication

These days, most APIs are not *quite* public. Instead, most require some sort of *authentication*, often in the form of an API *key*---a long string of letters and numbers that functions like a *password*.

### US Census Authentication

To use the US Census API, we will first need to get an API key.

To get a key, first go to
<a href="http://api.census.gov/data/key_signup.html" target="_blank"> the census API key signup page</a> to request one (takes a minute or two).

[![Census Request API Key](images/request-key.png)](http://api.census.gov/data/key_signup.html)


Check Your Email!
========================================================

![Census Request API Key]({{ site.url }}/images/course-materials/earth-analytics/week-10/census-key-1.png)


![Census Request API Key]({{ site.url }}/images/course-materials/earth-analytics/week-10/census-key-2.png)



We'll start by looking at Census data for median income in and around Boulder
County. First, let's load the required `R` packages:


```r
library(tigris)  # To get TIGER (geospatial) data
library(acs)     # To get census data
library(stringr) # To pad fips codes
```

Next, specify your API Key... you'll need your own key to follow along in class.


```r
key = "l0ong_@lph@_num3r1C_k3y"
```



'Install' the API key so you can start querying the data


```r
api.key.install(key)
```

## Building a Query

# what data do we want

https://factfinder.census.gov/faces/nav/jsf/pages/searchresults.xhtml?refresh=t#none

# where do we want the data from?
https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_15_5YR_B19001&prodType=table

table : B19001

# where to get FIPS codes
# what is a FIPS code?
# etc...
========================================================


```r
# we can use the census API to look up terms
income_tables <- acs.lookup(keyword = "Household Income in the past 12 months", endyear = 2015, case.sensitive = F)

# Fips codes for counties _around_ Boulder
counties = c(5, 13, 35, 14, 59, 19,
             47, 49, 69, 123, 31, 1)
# Grab the spatial data (tigris)
tracts = tracts(state="CO", county=counties, cb=TRUE)
```

- Note that we *can* use county names in the `tigris` (`tracts()`) package, but *not* in the `acs.fetch()` function from the `acs` package, so we'll use 'fips' codes here.


```r
# Create a geographic set to grab tabular data (acs)
geo = geo.make(state=c("CO"), county=counties, tract="*")
```

Submitting a Query
========================================================

- Now we'll grab the 5-year 'Income' ACS table (`B19001`) for 2010-2014


```r
library(choroplethr)
## Error in library(choroplethr): there is no package called 'choroplethr'


new <- get_acs_data(tableId = "B19001",
             map = "county",
             endyear=2014,
             span=5,
             column_idx = 1)
## Error in eval(expr, envir, enclos): could not find function "get_acs_data"

# get get the values
new1 <- new[[1]]
## Error in new[[1]]: object of type 'closure' is not subsettable
library(choroplethrMaps)
## Error in library(choroplethrMaps): there is no package called 'choroplethrMaps'
county_choropleth(new1,
                  title = "2012 County Estimates:nNumber of Japanese per County")
## Error in eval(expr, envir, enclos): could not find function "county_choropleth"


income = acs.fetch(endyear=2014, span=5,
                   geography=geo,
                   table.number="B19001",
                   col.names="pretty")
```

- The above use of `col.names="pretty"` gives the full column definitions,, if you want Census variable IDs (ugly!) use `col.names="auto"`.
- The variables we care about are "Household Income: Total:" and "Household Income: $200,000 or more"

Exploring acs Census Data
========================================================

- The resulting `income` object is not a `data.frame` it's a 'list':


```r
names(attributes(income))
##  [1] "endyear"        "span"           "acs.units"      "currency.year" 
##  [5] "modified"       "geography"      "acs.colnames"   "estimate"      
##  [9] "standard.error" "class"
```

- The items of interest to us for now are `acs.colnames`, `estimate`, and `geography`.

Working with Census Data
========================================================

- This step is a bit complicated, but required to create a full `geoid` (alpha-numeric unique id for each county for joining to geo-data later):


```r
# Create a geoid object
geog = income@geography
geoid = paste0(str_pad(geog$state,2,"left",pad="0"),
               str_pad(geog$county,3,"left",pad="0"),
               str_pad(geog$tract,6,"left",pad="0"))

# We want the first and last columns
est = income@estimate
inc = data.frame(geoid, est[,c(1, 17)],
                 stringsAsFactors=FALSE)
```

Working with Census Data
========================================================

- Now we'll rename things and make the data more usable


```r
rownames(inc) = 1:nrow(inc)
# Rename columns so they're shorter and cleaner
colnames(inc)= c("GEOID", "total", "over_200")
# Create a percentage over $200k column
inc$percent = 100*(inc$over_200/inc$total)
```

- We'll also *merge* the tabular data with the geo-data using the (very handy) `geo_join` function from the `tigris` package:


```r
merged = geo_join(tracts, inc, "GEOID", "GEOID")
```

Plotting Census Data
========================================================
title: false


```r
# Quick look at distribution of `percent` variable
ggplot(data=merged@data, aes(x=percent)) +
  geom_histogram()
```

<center>

```
## Error in eval(expr, envir, enclos): object 'pres_theme' not found
```
</center>


Mapping Census Data
========================================================

- Using the tools (`leaflet`) we discovered earlier, it is relatively straight-forward to create an interactive web-map for this census data
    - First we specify some *eye-candy*:


```r
# Create a nice popup for display...
popup = paste0("GEOID: ", merged$GEOID, "<br>",
               "Households > $200k: ",
               round(merged$percent, 2), "%")

# We'll also create/use a colorbrewer pallette
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$percent)
```

Mapping Census Data
========================================================

- And then we create the map...


```r
map = leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data=merged, fillColor=~pal(percent),
              color="#b2aeae", # 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2, popup=popup) %>%
  addLegend(pal=pal, values=merged$percent,
            position="bottomright",
            title="% > $200k",
            labFormat=labelFormat(suffix="%"))
```


```
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```

## ok the census stuff is a bit complicated ... thinka bout whether it's worth trying to present this?

Interactive Map of Census Data
========================================================
title: false

<iframe  title="Income Map" width="1100" height="900"
  src="./income_map.html"
  frameborder="0" allowfullscreen></iframe>
