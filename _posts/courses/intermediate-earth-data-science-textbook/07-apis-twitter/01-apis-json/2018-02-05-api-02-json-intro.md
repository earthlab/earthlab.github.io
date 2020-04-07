---
layout: single
title: 'Introduction to JSON Data in Python'
excerpt: 'JSON is a powerful text based data format that contains hierarchical data. JSON and GeoJSON are common data formats that are returned when accessing automatically data using an API. Learn more about JSON and GeoJSON data.'
authors: ['Leah Wasser', 'Max Joseph', 'Martha Morrissey']
modified: 2020-04-01
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/use-data-open-source-python/intro-to-apis/intro-to-json/
nav-title: 'Intro to JSON'
week: 7
sidebar:
    nav:
author_profile: false
comments: true
order: 2
course: "intermediate-earth-data-science-textbook"
topics:
    find-and-manage-data: ['apis']
redirect_from:
  - "/courses/earth-analytics-python/using-apis-natural-language-processing-twitter/intro-to-JSON/"
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe the key structure elements of a `JSON` data structure: name/value pairs.
* Identify the components of the hierarchical `JSON` data structures including: objects, arrays and data elements.
* List some of the core data types that a `JSON` data structure can store including: boolean, numeric and string.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>


In this lesson, you will explore the **machine readable** JSON data structure. Machine readable data structures are more efficient - particularly for larger data that contain hierarchical structures.

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

Before going any further, revisit the **J**ava**S**cript
**O**bject **N**otation or **JSON** data structure that you learned about in the introductory
lesson in this module. JSON is an ideal format for larger data that have a hierarchical structured relationship.

In `Python`, `JSON` data is similar to a dictonary because it has keys (i.e. names) and values, but it is encoded as a string. 

The `Python` library `json` is helpful to convert data from lists or dictonaries into `JSON` strings and `JSON` strings into lists or dictonaries. `Pandas` can also be used to convert `JSON` data (via a `Python` dictionary) into a `Pandas` `DataFrame`. 

The structure of a `JSON` object is as follows:

* The data are in name/value pairs using colons `:`.
* Data **objects** are separated by commas.
* Curly braces `{}` hold the objects.
* Square brackets `[]` can be used to indicate an **array** that contains a group of objects.
* Each **data element** is enclosed with quotes `""` if it is a character, or without quotes if it is a numeric value.

Example of a name/value pair using a colon:
```json
 { "name":"Chaya" }
```

Example of objects separated by commas:  
```json
{ "name":"Chaya", "age":12, "city":"Boulder", "type":"Canine" }
```

Notice that the data above are structured. Thus, each element contains a particular object name (name, age, city, etc) and values are associated with these names. This is similar to column headings in a CSV file.

However, the `JSON` structure can also be nested using square brackets to indicate an array that contains a group of objects, like this:

```json
{"students":[
    { "firstName":"Serena", "lastName":"Williams" },
    { "firstName":"Boe", "lastName":"Diddly" },
    { "firstName":"Al", "lastName":"Gore" }
]}
```

The ability to store nested or **hierarchical** data within a text file structure makes `JSON` a powerful format to use as you are working with larger datasets.

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** The GeoJSON
data structure is a powerful data structure that supports spatial data. GeoJSON
can be used to create maps just like shapefiles can. This format is often used
for web mapping applications like Leaflet (which you will learn about later in
this module).
{: .notice--success}


### JSON Data Structures

`JSON` can store any of the following data types:

* strings
* numbers
* objects (`JSON` object)
* arrays
* booleans (TRUE / FALSE)
* null

Note that in the example below, the word "Chaya", which is the value associated with "name", is in quotes `""`. This specifies that "Chaya" is a string (characters rather than numeric).

```json
 { "name":"Chaya" }
```

In this example, the value 12, associated with "age", is not in quotes. This specifies that this value is a number or of type `numeric`.

```json
{ "name":"Chaya", "age":12, "city":"Boulder", "type":"Canine" }
```
In the next lesson, you will work with JSON structured data, accessed via a RESTful API. A snippet of the data that you will work with is below. Notice that the `JSON` is enclosed in brackets `[]` to indicate an array containing a group of objects.

```json
[{"age":"0","county":"Adams","datatype":"Estimate","femalepopulation":"2404","fipscode":"1","malepopulation":"2354","totalpopulation":"4758","year":"1990"}
,{"age":"1","county":"Adams","datatype":"Estimate","femalepopulation":"2375","fipscode":"1","malepopulation":"2345","totalpopulation":"4720","year":"1990"}
,{"age":"2","county":"Adams","datatype":"Estimate","femalepopulation":"2219","fipscode":"1","malepopulation":"2413","totalpopulation":"4632","year":"1990"}]
```
