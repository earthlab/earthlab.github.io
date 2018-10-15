---
layout: single
title: 'Introduction to the JSON data structure'
excerpt: 'This lesson covers the JSON data structure. JSON is a powerful text based format that supports hierarchical data structures. It is the core structure used to create geoJSON which is a spatial version of json that can be used to create maps. JSON is preferred for use over .csv files for data structures as it has been proven to be more efficient - particulary as data size becomes large.'
authors: ['Leah Wasser', 'Max Joseph', 'Martha Morrissey']
modified: 2018-10-08
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/earth-analytics-python/get-data-using-apis/intro-to-JSON/
nav-title: 'Intro to JSON'
week: 12
sidebar:
    nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics-python"
topics:
    find-and-manage-data: ['apis']
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Describe the key structure elements of a `json` file: object names and values.
* List some of the core data types that `json` files can store including: boolean, numeric and string.
* Identify the components of the hierarchical `json` structures including: objects, arrays and data elements.
* Work with JSON files in `Python`

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>


In this lesson, you will explore the **machine readable** JSON data structure. Machine readable
data structures are more efficient - particularly for larger data that contain
hierarchical structures.

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
**O**bject **N**otation or **JSON** data structure that reviewed in the introductory
lesson in this module. JSON is an ideal format for larger data that have a hierarchical structured relationship.

In `Python` JSON data is similar to a dictonary because it has keys and values, but it is encoded as a string. The `Python` library `json` is helpful to convert data from lists/dictonaries into json strings and json strings into lists/dictonaries. `pandas` can sometimes be used to convert `json` data into a `DataFrame`. 

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
,{"age":"2","county":"Adams","datatype":"Estimate","femalepopulation":"2219","fipscode":"1","malepopulation":"2413","totalpopulation":"4632","year":"1990"}]
```

### Work with JSON Data in Python

From the `Python` `json` library `json` data can be converted to a `dictonary` using the `json.loads` function.

{:.input}
```python
import json
import pandas as pd
```

{:.input}
```python
json_sample =  '{ "name":"Chaya", "age":55, "city":"Boulder", "type":"Canine" }'
```

{:.input}
```python
data_sample = json.loads(json_sample)
type(data_sample)
```

{:.output}
{:.execute_result}



    dict





You can also convert `json` objects into `pandas` `DataFrames`

{:.input}
```python
pd.read_json(json_sample, orient='records')
```

{:.output}

    ---------------------------------------------------------------------------

    ValueError                                Traceback (most recent call last)

    <ipython-input-25-90b8a2d453b6> in <module>()
    ----> 1 pd.read_json(json_sample, orient='records')
    

    //anaconda/envs/earth-analytics-python/lib/python3.6/site-packages/pandas/io/json/json.py in read_json(path_or_buf, orient, typ, dtype, convert_axes, convert_dates, keep_default_dates, numpy, precise_float, date_unit, encoding, lines, chunksize, compression)
        350     compression = _infer_compression(path_or_buf, compression)
        351     filepath_or_buffer, _, compression = get_filepath_or_buffer(
    --> 352         path_or_buf, encoding=encoding, compression=compression,
        353     )
        354 


    //anaconda/envs/earth-analytics-python/lib/python3.6/site-packages/pandas/io/common.py in get_filepath_or_buffer(filepath_or_buffer, encoding, compression)
        209     if not is_file_like(filepath_or_buffer):
        210         msg = "Invalid file path or buffer object type: {_type}"
    --> 211         raise ValueError(msg.format(_type=type(filepath_or_buffer)))
        212 
        213     return filepath_or_buffer, None, compression


    ValueError: Invalid file path or buffer object type: <class 'dict'>


