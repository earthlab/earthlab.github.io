---
layout: single
title: "Introduction to the JSON data structure"
excerpt: "This lesson covers the JSON data structure. JSON is a powerful text based format that supports hierarchical data structures. It is the core structure used to create geoJSON which is a spatial version of json that can be used to create maps. JSON is preferred for use over .csv files for data structures as it has been proven to be more efficient - particulary as data size becomes large."
authors: ['Leah Wasser', 'Max Joseph']
modified: '2018-01-10'
category: [courses]
class-lesson: ['intro-APIs-r']
permalink: /courses/earth-analytics/get-data-using-apis/intro-to-JSON/
nav-title: 'Into to JSON'
week: 13
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  find-and-manage-data: ['apis']
redirect_from:
   - "/courses/earth-analytics/week-10/intro-to-JSON/"
---

{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe the key structure elements of a `json` file: object names and values.
* List some of the core data types that `json` files can store including: boolean, numeric and string.
* Identify the components of the hierarchical `json` structures including: objects, arrays and data elements.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>



In the previous lesson, you learned how to access human readable text files data
programmatically using:

1. `download.file()` to download a file to your computer and work with it (ideal if you want to save a copy of the data to your computer)
1. `read.csv()` ideal for reading in a tabular file stored on the web but may sometimes fail when there are secure connections involved (e.g. https).

You also learned how to use `getURL()` for urls that are both secure (https) and
less secure (http).

In this lesson, you will learn about API interfaces. An API allows us to access
data stored on a computer or server using a specific query. API's are powerful
ways to access data and more specifically the specific type and subset of data
that you need for your analysis, programmatically.

You will also explore the **machine readable** JSON data structure. Machine readable
data structures are more efficient - particularly for larger data that contain
hierarchical structures. In this lesson, the `getURL()`
function will become more valuable to us as you parse data accessed from an API.


```r
#NOTE: if you have problems with ggmap, try to install both ggplot and ggmap from github
#devtools::install_github("dkahle/ggmap")
#devtools::install_github("hadley/ggplot2")
library(ggmap)
library(ggplot2)
library(dplyr)
library(rjson)
```



## Review

Remember that in the first lesson in this module, you learned about **REST**ful APIs.
You explored the concept of a **request** and then a subsequent
**response**. The **request** to an **REST**ful API is composed of a URL and the
associated parameters required to access a particular subset of the data that you
wish to access.

When you send the request, the web API returns one of the following:

 1. The data that you requested or
 2. A *failed to return* message which tells us that something was wrong with your request.


## About JSON
Before we go any further, let's take a moment to revisit the **J**ava**S**cript
**O**bject **N**otation or **JSON** data structure that reviewed in the introductory
lesson in this module. JSON is an ideal format for larger data that
 have a hierarchical structured relationship.

The structure of a JSON object is as follows:

* The data are in name/value pairs
* Data objects are separated by commas
* Curly braces `{}` hold objects
* Square brackets `[]` hold arrays
* Each data element is enclosed with quotes `""` if it is a character, or without quotes if it is a numeric value

```json
 { "name":"Chaya" }
```

```json
{ "name":"Chaya", "age":55, "city":"Boulder", "type":"Canine" }
```

Notice that the data above are structured. Thus, each element contains a particular
object name. (name, age, city, etc). This is similar to column headings in a .csv.
However, the JSON structure can also be nested. Like this:

```json
{"students":[
    { "firstName":"Serena", "lastName":"Williams" },
    { "firstName":"Boe", "lastName":"Diddly" },
    { "firstName":"Al", "lastName":"Gore" }
]}
```

The ability to store nested or hierarchical data within a text file structure makes
JSON a powerful format to use as you are working with larger datasets.

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** The GEOJSON
data structure is a powerful data structure that supports spatial data. GEOJSON
can be used to create maps just like shapefiles can. This format is often used
for web mapping applications like leaflet (which you will learn about later in
this module).
{: .notice--success}


### JSON Data Structures

JSON can store any of the following data types:

* strings
* numbers
* objects (JSON object)
* arrays
* booleans (TRUE / FALSE)
* null

Note that in the example below - the word "Chaya" which is the value associated with
name is in quotes `""`. This specifies that chaya is a string (characters rather
than numeric).

```json
 { "name":"Chaya" }
```

In this example the value 55 associated with age, is not in quotes. This specifies
that this value is a number or of type `numeric`.

```json
{ "name":"Chaya", "age":55, "city":"Boulder", "type":"Canine" }
```

In the next lesson, you will work with JSON structued data, accessed via an RESTful
API. A snippet of the data that you will work with is below.

```json
[{"age":"0","county":"Adams","datatype":"Estimate","femalepopulation":"2404","fipscode":"1","malepopulation":"2354","totalpopulation":"4758","year":"1990"}
,{"age":"1","county":"Adams","datatype":"Estimate","femalepopulation":"2375","fipscode":"1","malepopulation":"2345","totalpopulation":"4720","year":"1990"}
,{"age":"2","county":"Adams","datatype":"Estimate","femalepopulation":"2219","fipscode":"1","malepopulation":"2413","totalpopulation":"4632","year":"1990"}
```
