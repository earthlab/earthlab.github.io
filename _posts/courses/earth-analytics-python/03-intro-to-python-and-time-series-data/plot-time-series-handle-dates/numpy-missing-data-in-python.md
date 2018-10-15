---
layout: single
title: "Missing data in Python"
excerpt: "Sometimes data are missing from a file due to errors in collection, inability to record a data point or other reasons. Learn how to handle missing data values in Python."
authors: ['Leah Wasser']
category: [courses]
class-lesson: ['time-series-python']
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/missing-data-in-python-na/
nav-title: 'Missing data'
dateCreated: 2018-08-07
modified: 2018-10-08
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 2
course: "earth-analytics-python"
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}

This lesson covers how to work with no data values in `Python`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Understand why it is important to make note of missing data values.
* Be able to define what a `NA` value is in `python` and how it is used.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [Setup Conda](/courses/earth-analytics-python/get-started-with-python-jupyter/setup-conda-earth-analytics-environment/)
* [Setup your working directory](/courses/earth-analytics-python/get-started-with-python-jupyter/introduction-to-bash-shell/)
* [Intro to Jupyter Notebooks](/courses/earth-analytics-python/python-open-science-tool-box/intro-to-jupyter-notebooks/)

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

## Missing Data - No Data Values

Sometimes, your data are missing values. Imagine a spreadsheet in Microsoft Excel with cells that are blank. If the cells are blank, you don't know for sure whether those data weren't collected, or something someone forgot to fill in. To account for data that are missing (not by mistake) you can put a value in those cells that represents `no data`.

The `Python` programming language uses the value `np.nan` to represent missing data values.

To get started let's be sure to load all of the required libraries and set your working directory.

{:.input}
```python
# work with numeric data
import numpy as np
# work with tabular data - dataframes
import pandas as pd
# download data from a url
import urllib
import os
# be sure to set your working directory using os.chdir() 
import earthpy as et
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

When the numpy library is loaded, the default setting for most base functions that read data into `python` is to
interpret `np.nan` as a missing value.

{:.input}
```python
planets = np.array(["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus",
                    "Neptune", np.nan])
planets
```

{:.output}
{:.execute_result}



    array(['Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus',
           'Neptune', 'nan'], dtype='<U7')






## Customize NoData Values

Often, you'll find a dataset that uses another value for missing data. In some
disciplines, for example `-999` is sometimes used. If there are multiple types of
missing values in your dataset, you can extend what `python` considers a missing value when it reads
the file in using  "`na_values`" argument. For instance, if you wanted to read
in a `.CSV` file named `temperature_example.csv` that had missing values represented as an empty
cell, a single blank space, and the value -999, you would use:

{:.input}
```python
# download file from Earth Lab figshare repository
urllib.request.urlretrieve(url='https://ndownloader.figshare.com/files/7275959', 
                           filename= 'data/temperature_example.csv')
```

{:.output}
{:.execute_result}



    ('data/temperature_example.csv', <http.client.HTTPMessage at 0x815b1a390>)





{:.input}
```python
# import data frame without specifying missing data values
temp_df = pd.read_csv('data/temperature_example.csv')
temp_df
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
      <th>avg_temp</th>
      <th>day</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>55.0</td>
      <td>thursday</td>
    </tr>
    <tr>
      <th>1</th>
      <td>25.0</td>
      <td>tuesday</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>wednesday</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-999.0</td>
      <td>saturday</td>
    </tr>
    <tr>
      <th>4</th>
      <td>15.0</td>
      <td>thursday</td>
    </tr>
    <tr>
      <th>5</th>
      <td>25.0</td>
      <td>tuesday</td>
    </tr>
    <tr>
      <th>6</th>
      <td>65.0</td>
      <td>thursday</td>
    </tr>
    <tr>
      <th>7</th>
      <td>NaN</td>
      <td>tuesday</td>
    </tr>
    <tr>
      <th>8</th>
      <td>95.0</td>
      <td>thursday</td>
    </tr>
    <tr>
      <th>9</th>
      <td>-999.0</td>
      <td>monday</td>
    </tr>
    <tr>
      <th>10</th>
      <td>85.0</td>
      <td>monday</td>
    </tr>
    <tr>
      <th>11</th>
      <td>-999.0</td>
      <td>monday</td>
    </tr>
    <tr>
      <th>12</th>
      <td>85.0</td>
      <td>monday</td>
    </tr>
  </tbody>
</table>
</div>





In the example above, you imported the data and the -999.0 values imported as numeric values. This will in turn impact any statistics or calculations run on that data column.

{:.input}
```python
temp_df.mean()
```

{:.output}
{:.execute_result}



    avg_temp   -231.545455
    dtype: float64





However, if you specify what the missing data values is when you import that data, then it will be assigned a `np.nan` value. Python will thus know to ignore those cells when it performs calculations on the data.

{:.input}
```python
temp_df2 = pd.read_csv('data/temperature_example.csv', 
                       na_values=['NA', ' ', '-999'])
temp_df2
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
      <th>avg_temp</th>
      <th>day</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>55.0</td>
      <td>thursday</td>
    </tr>
    <tr>
      <th>1</th>
      <td>25.0</td>
      <td>tuesday</td>
    </tr>
    <tr>
      <th>2</th>
      <td>NaN</td>
      <td>wednesday</td>
    </tr>
    <tr>
      <th>3</th>
      <td>NaN</td>
      <td>saturday</td>
    </tr>
    <tr>
      <th>4</th>
      <td>15.0</td>
      <td>thursday</td>
    </tr>
    <tr>
      <th>5</th>
      <td>25.0</td>
      <td>tuesday</td>
    </tr>
    <tr>
      <th>6</th>
      <td>65.0</td>
      <td>thursday</td>
    </tr>
    <tr>
      <th>7</th>
      <td>NaN</td>
      <td>tuesday</td>
    </tr>
    <tr>
      <th>8</th>
      <td>95.0</td>
      <td>thursday</td>
    </tr>
    <tr>
      <th>9</th>
      <td>NaN</td>
      <td>monday</td>
    </tr>
    <tr>
      <th>10</th>
      <td>85.0</td>
      <td>monday</td>
    </tr>
    <tr>
      <th>11</th>
      <td>NaN</td>
      <td>monday</td>
    </tr>
    <tr>
      <th>12</th>
      <td>85.0</td>
      <td>monday</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
temp_df2.mean()
```

{:.output}
{:.execute_result}



    avg_temp    56.25
    dtype: float64





In the example below, note how a mean value is calculated differently depending
upon on how `NA` values are treated when the data are imported.

{:.input}
```python
print(np.mean(temp_df['avg_temp']))
print(np.mean(temp_df2['avg_temp']))
```

{:.output}
    -231.54545454545453
    56.25



Notice a difference between `temp_df` and `temp_df2` 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge

* **Question**: Why, in the the example above did `mean(temp_df)` return
a negative value whereas `mean(temp_df2)` which is the same data returned a positive value?

<!-- * _Answer_: Because if there are `NA` values in a dataset that are numeric, python will calculate them as numeric values. In this case -999 was a `NA` value. By importing the data using `na_strings`= you can specify what values should be converted to `NA` by python. -->

</div>


## NAN Values Outside of Pandas

Above you learned how to handle nan values in pandas. However it is important to note that nan values are handled slightly different when using numpy arrays. Lucky for you we aren't using numpy arrays in this weeks' material. It's good to be aware of this for your future work.

When performing mathematical operations on numbers in `Python` using `numpy`, most functions will
return the value `NA` if the data you are working with include missing values.
This allows you to see that you have missing data in your dataset. You can add the
function `~np.isnan()` 

where 

`~` tells python to take the opposite of what the function returns. and
`np.isnan()` tells python to grab only the nan values.

Thus this: `~np.isnan()`  tells `python` to only grab non `nan` values from your data.

{:.input}
```python
heights = np.array([2, 4, 4, np.nan, 6])
print(np.mean(heights))
print(np.max(heights))
```

{:.output}
    nan
    nan



{:.input}
```python
print(np.nanmean(heights))
print(np.nanmax(heights))
```

{:.output}
    4.0
    6.0



{:.input}
```python
# print(np.mean(heights[~np.isnan(heights)]))
# print(np.max(heights[~np.isnan(heights)]))
```

The function, `np.isnan()` can be used to figure out if your data has assigned (`nan`) no-data values. 
If you use `np.isnan()` you can see just the objects that are missing data values. In this case, you have one `nan` object.

{:.input}
```python
# view objects that equal nan
heights[np.isnan(heights)]

```

{:.output}
{:.execute_result}



    array([nan])





{:.input}
```python
# how many nan values are in your array?
len(heights[np.isnan(heights)])

```

{:.output}
{:.execute_result}



    1





You can select all of the objects that are values (not equal to `nan`) by asking python to return the inverse of what you selected above. You use the `~` sign to request the inverse as follows:

`~np.isnan(object-name-here)`

{:.input}
```python
# select objects that are NON equal to NAN.
heights[~np.isnan(heights)]
```

{:.output}
{:.execute_result}



    array([2., 4., 4., 6.])




