---
layout: single
title: 'Introduction to Working With JSON Data in Open Source Python'
excerpt: 'This lesson introduces how to work with the JSON data structure using Python using the JSON and Pandas libraries to create and convert JSON objects. '
authors: ['Leah Wasser', 'Max Joseph', 'Martha Morrissey', 'Jenny Palomino']
modified: 2020-04-02
category: [courses]
class-lesson: ['intro-APIs-python']
permalink: /courses/use-data-open-source-python/intro-to-apis/use-JSON-in-python/
nav-title: 'JSON Data in Python'
week: 7
sidebar:
    nav:
author_profile: false
comments: true
order: 3
course: "intermediate-earth-data-science-textbook"
topics:
    find-and-manage-data: ['apis']
redirect_from:
  - "/courses/earth-analytics-python/using-apis-natural-language-processing-twitter/work-with-JSON-intro/"
---
{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Create and convert `JSON` objects using `Python`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>

In this lesson, you will explore the **machine readable** JSON data structure. Machine readable data structures are more efficient - particularly for larger data that contain hierarchical structures.

## Review JSON

Recall from the previous lesson that the structure of a `JSON` object is as follows:

* The data are in name/value pairs using colons `:`.
* Data **objects** are separated by commas.
* Curly braces `{}` hold the objects.
* Square brackets `[]` can be used to indicate an **array** that contains a group of objects.
* Each **data element** is enclosed with quotes `""` if it is a character, or without quotes if it is a numeric value.

Example:
```json
{ "name":"Chaya", "age":12, "city":"Boulder", "type":"Canine" }
```

You also learned that the `Python` library `json` is helpful to convert data from lists or dictonaries into `JSON` strings and `JSON` strings into lists or dictonaries. `Pandas` can also be used to convert `JSON` data (via a `Python` dictionary) into a `Pandas` `DataFrame`. 

In this lesson, you will use the `json` and `Pandas` libraries to create and convert `JSON` objects. 

## Work with JSON Data in Python

### Python Dictionary to JSON

Using the `Python` `json` library, you can convert a `Python` dictionary to a `JSON` string using the `json.dumps()` function.

Begin by creating the `Python` dictionary that will be converted to `JSON`. 

{:.input}
```python
import json
import pandas as pd
```

{:.input}
```python
# Create and populate the dictionary
dict = {}
dict["name"] = "Chaya"
dict["age"] = 12
dict["city"] = "Boulder"
dict["type"] = "Canine"

dict
```

{:.output}
{:.execute_result}



    {'name': 'Chaya', 'age': 12, 'city': 'Boulder', 'type': 'Canine'}





Notice below that the `Python` dictionary and the `JSON` string look very similiar, but that the `JSON` string is enclosed with quotes `''`. 

{:.input}
```python
json_example = json.dumps(dict, ensure_ascii=False)

json_example
```

{:.output}
{:.execute_result}



    '{"name": "Chaya", "age": 12, "city": "Boulder", "type": "Canine"}'





Recall that you use `type()` to check the object type, and notice that the `JSON` is of type `str`. 

{:.input}
```python
type(json_example)
```

{:.output}
{:.execute_result}



    str





###  JSON to Python Dictionary

You can also manually define `JSON` by enclosing the `JSON` with quotes `''`. 

{:.input}
```python
json_sample =  '{ "name":"Chaya", "age":12, "city":"Boulder", "type":"Canine" }'

type(json_sample)
```

{:.output}
{:.execute_result}



    str





Using the `json.loads()` function, a `JSON` string can be converted to a `dictionary`. 

{:.input}
```python
# Load JSON into dictionary
data_sample = json.loads(json_sample)
data_sample
```

{:.output}
{:.execute_result}



    {'name': 'Chaya', 'age': 12, 'city': 'Boulder', 'type': 'Canine'}





You can check the type again to see that it has been converted to a `Python` dictionary. 

{:.input}
```python
type(data_sample)
```

{:.output}
{:.execute_result}



    dict





Recall that you can call any key of a `Python` dictionary and see the associated values. 

{:.input}
```python
data_sample["name"]
```

{:.output}
{:.execute_result}



    'Chaya'





{:.input}
```python
data_sample["city"]
```

{:.output}
{:.execute_result}



    'Boulder'





### Python Dictionary to Pandas Dataframe

If desired, you can use the `from_dict()` function from `Pandas` to read the dictionary into a `Pandas` `Dataframe`.

{:.input}
```python
df = pd.DataFrame.from_dict(data_sample, orient='index')
df
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>name</th>
      <td>Chaya</td>
    </tr>
    <tr>
      <th>age</th>
      <td>12</td>
    </tr>
    <tr>
      <th>city</th>
      <td>Boulder</td>
    </tr>
    <tr>
      <th>type</th>
      <td>Canine</td>
    </tr>
  </tbody>
</table>
</div>





### Pandas Dataframe to JSON

Conversely, you can also convert a `Pandas` `Dataframe` to `JSON` using the `Pandas` method `to_json()`.

{:.input}
```python
sample_json = df.to_json(orient='split')

type(sample_json)
```

{:.output}
{:.execute_result}



    str





You now know the basics of creating and converting `JSON` objects using `Python`. In the next lessons, you will work with hierarchical `JSON` data accessed via RESTful APIs. 
