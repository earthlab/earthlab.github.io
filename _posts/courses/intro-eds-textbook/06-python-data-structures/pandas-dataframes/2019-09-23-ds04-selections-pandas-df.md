---
layout: single
title: 'Select Data From Pandas Dataframes'
excerpt: "Pandas dataframes are a commonly used scientific data structure in Python that store tabular data using rows and columns with headers. Learn how to use indexing and filtering to select data from pandas dataframes."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-pandas-dataframes']
permalink: /courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/indexing-filtering-data-pandas-dataframes/
nav-title: "Select Data From Pandas Dataframes"
dateCreated: 2019-09-06
modified: 2020-11-12
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/pandas-dataframes/selections-pandas-dataframes/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* Explain indexing for **pandas** dataframes.
* Use indexing and filtering to select data from **pandas** dataframes.

</div>


## Indexing and Selections From Pandas Dataframes

There are two kinds of indexing in **pandas** dataframes: 

* location-based and 
* label-based. 

In the lesson introducing **pandas** dataframes, you learned that these data structures have an inherent tabular structure (i.e. rows and columns with header names) that support selecting data with indexing, such as selecting individual cells identified by their location at the intersection of rows and columns. You can also select data from **pandas** dataframes without knowing the location of that data within the **pandas** dataframe, using specific labels such as a column name.


### Location-based Indexing

After working with indexing for **Python** lists and **numpy** arrays, you are familiar with location-based indexing. You already know that **Python** location-based indexing begins with `[0]`, and you have learned how to use location-based indexing to query data within **Python** lists or **numpy** arrays.

You can use location-based indexing to query **pandas** dataframes using the attribute `.iloc` and providing the row and column selection as ranges (i.e. start and stop locations along the rows and columns). Just like with **numpy** arrays, the range provided is inclusive of the first value, but not the second value. 

This means that you need to use the range `[0:1]` to select the first index, so your selection begins at `[0]` but does not include `[1]` (the second index). For example, you can select the first row and the first column of a **pandas** dataframes providing the range `[0:1]` for the row selection and then providing the range `[0:1]` for the column selection.

```python
dataframe.iloc[0:1, 0:1]
```

### Label-based Indexing

**Pandas** dataframes can also be queried using label-based indexing. 

This feature of **pandas** dataframes is very useful because you can create an index for **pandas** dataframes using a specific column (i.e. label) that you want to use for organizing and querying your data.

For example, you can create an index from a specific column of values, and then use the attribute `.loc` to select data from the **pandas** dataframes using a value that is found in that index. 

```python

dataframe.set_index("column")
dataframe.loc[[value]]
```

### Filtering Data Values

In addition to using indexing, you can also select or filter data from **pandas** dataframes by querying for values that met a certain criteria. 

For example, you can select data in a **pandas** dataframe based on specific values within a column using:
    
```python
dataframe[dataframe["column"] == value]
```

This will return all rows containing that value within the specified column. 

On this page, you will review how indexing works for **pandas** dataframes and you will learn how to select data from **pandas** dataframes using both indexing and filtering of data values.


### Import Python Packages and Get Data

Begin by importing the necessary **Python** packages and then downloading and importing data into **pandas** dataframes.

You can use the **earthpy** package to download the data files, **os** to set the working directory, and **pandas** to import data files into **pandas** dataframes.

{:.input}
```python
# Import packages
import os

import pandas as pd
import earthpy as et
```

{:.input}
```python
# URL for .csv with avg monthly precip data
avg_monthly_precip_url = "https://ndownloader.figshare.com/files/12710618"

# Download file
et.data.get_data(url=avg_monthly_precip_url)
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12710618



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/avg-precip-months-seasons.csv'





{:.input}
```python
# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, "earth-analytics"))
```

{:.input}
```python
# Import data from .csv file
fname = os.path.join("data", "earthpy-downloads", 
                     "avg-precip-months-seasons.csv")

avg_monthly_precip = pd.read_csv(fname)

avg_monthly_precip
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
      <th>months</th>
      <th>precip</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>0.70</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>0.75</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>1.85</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>2.93</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>3.05</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>2.02</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>1.93</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>1.62</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>1.84</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>1.31</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>1.39</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.84</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





## Select Data Using Location Index (.iloc)

You can use `.iloc` to select individual rows and columns or a series of rows and columns by providing the range (i.e. start and stop locations along the rows and columns) that you want to select.

Recall that in `Python` indexing begins with `[0]` and that the range you provide is inclusive of the first value, but not the second value.

This means that you can use `dataframe.iloc[0:1, 0:1]` to select the cell value at the intersection of the first row and first column of the dataframe.

{:.input}
```python
# Select first row and first column
avg_monthly_precip.iloc[0:1, 0:1]
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
      <th>months</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
    </tr>
  </tbody>
</table>
</div>





You can expand the range for either the row index or column index to select more data.

For example, you can select the first two rows of the first column using `dataframe.iloc[0:2, 0:1]` or the first columns of the first row using `dataframe.iloc[0:1, 0:2]`.

{:.input}
```python
# Select first two rows and first column
avg_monthly_precip.iloc[0:2, 0:1]
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
      <th>months</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Select first row and first two columns
avg_monthly_precip.iloc[0:1, 0:2]
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
      <th>months</th>
      <th>precip</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>0.7</td>
    </tr>
  </tbody>
</table>
</div>





You can also use `.iloc` to select an entire row or an entire column by leaving the other range without values.

For example, you can use `dataframe.iloc[0:1, :]` to select the first row of a dataframe and all of the columns, or `dataframe.iloc[ :, 0:1]` to select the first column of a dataframe and all of the rows. 

{:.input}
```python
# Select first row with all columns
avg_monthly_precip.iloc[0:1, :]
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
      <th>months</th>
      <th>precip</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>0.7</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Select first column with all rows
avg_monthly_precip.iloc[:, 0:1]
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
      <th>months</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
    </tr>
  </tbody>
</table>
</div>





## Select Data Using Label Index (.loc)

In addition to selecting data based on location, you can also select data based on labels. 

To do this, you first create a new index using a column of values that you want to use for organizing and querying your data. 

For example, you can create an index from a specific column of values using: 

`dataframe.set_index("column")`

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip:** Creating a new index will restructure the data by replacing the default location indexing (i.e. `[0]`) with the new index.  This also means the column used to create the index is no longer a functional column, but rather an index of the dataframe.   
{: .notice--success}

{:.input}
```python
# Create new dataframe with `months` as index
avg_monthly_precip_index = avg_monthly_precip.set_index("months")

avg_monthly_precip_index
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
      <th>precip</th>
      <th>seasons</th>
    </tr>
    <tr>
      <th>months</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Jan</th>
      <td>0.70</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>Feb</th>
      <td>0.75</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>Mar</th>
      <td>1.85</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>Apr</th>
      <td>2.93</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>May</th>
      <td>3.05</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>June</th>
      <td>2.02</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>July</th>
      <td>1.93</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>Aug</th>
      <td>1.62</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>Sept</th>
      <td>1.84</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>Oct</th>
      <td>1.31</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>Nov</th>
      <td>1.39</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>Dec</th>
      <td>0.84</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





Test that `months` no longer functions as a column by attempting to select that column name:

```python
avg_monthly_precip_index[["months"]]

```

The following error is returned:

`KeyError: "None of [Index(['months'], dtype='object')] are in the [columns]"`

Notice that the error message indicates that the value `months` is not in the index. This is because `months` is actually now the index!

After setting an index, you can use `.loc` to select data from the **pandas** dataframe using a value that is found in that index. 

When selecting text string values, you need to specify the text string with quotations `""`, as shown below for the text string `"Aug"`. 

{:.input}
```python
# Select Aug using months index 
avg_monthly_precip_index.loc[["Aug"]]
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
      <th>precip</th>
      <th>seasons</th>
    </tr>
    <tr>
      <th>months</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Aug</th>
      <td>1.62</td>
      <td>Summer</td>
    </tr>
  </tbody>
</table>
</div>





## Select Data Using Columns

In addition to location-based and label-based indexing, you can also select data from **pandas** dataframes by selecting entire columns using the column names. 

For example, you can select all data from a specific column in a **pandas** dataframe using: 

`dataframe["column"]`

which provides the data from the column as a **pandas** series, which is a one-dimensional array. A **pandas** series is useful for selecting columns for plotting using **matplotlib**. 

{:.input}
```python
# Select the `months` column as series
avg_monthly_precip["months"]
```

{:.output}
{:.execute_result}



    0      Jan
    1      Feb
    2      Mar
    3      Apr
    4      May
    5     June
    6     July
    7      Aug
    8     Sept
    9      Oct
    10     Nov
    11     Dec
    Name: months, dtype: object





You can also specify that you want an output that is also a **pandas** dataframe using: 
    
`dataframe[["column"]]`    

which includes a second set of brackets `[]` to indicate that the output should be a **pandas** dataframe. 

{:.input}
```python
# Select the `months` column as dataframe
avg_monthly_precip[["months"]]
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
      <th>months</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
    </tr>
  </tbody>
</table>
</div>





Notice that your results are now a **pandas** dataframe.

You can also select all data from multiple columns in a **pandas** dataframe using:

`dataframe[["column", "column"]]` 

Since the results of your selection are also a **pandas** dataframe, you can assign the results to a new **pandas** dataframe. 

For example, you can create a new **pandas** dataframe that only contains the `months` and `seasons` columns, effectively dropping the `precip` values. 

{:.input}
```python
# Save months and seasons to new dataframe
avg_monthly_precip_text = avg_monthly_precip[['months', 'seasons']]

avg_monthly_precip_text
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
      <th>months</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





## Filter Data Using Specific Values

In addition to location-based and label-based indexing, you can select or filter data based on specific values within a column using:
    
`dataframe[dataframe["column"] == value]`

This will return all rows containing that value within the specified column. 

If you are selecting data using a text string column, you need to provide the value within quotations (e.g. `"text"`). 

For example, you can select all rows that have a `seasons` value of `Summer`. 

{:.input}
```python
# Select rows with Summer in seasons
avg_monthly_precip[avg_monthly_precip["seasons"] == "Summer"]
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
      <th>months</th>
      <th>precip</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>2.02</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>1.93</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>1.62</td>
      <td>Summer</td>
    </tr>
  </tbody>
</table>
</div>





Again, you can also save the output to a new dataframe by setting it equal to the output of the filter. 

For example, you can filter for the values in the `months` column that are equal to `Jan` and save the output to a new dataframe.

{:.input}
```python
# Select rows with Jan in months
jan_avg_precip = avg_monthly_precip[avg_monthly_precip["months"] == "Jan"]

jan_avg_precip
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
      <th>months</th>
      <th>precip</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>0.7</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





You can also select data based on numeric values. Note that these selections on numeric values do not require the use of quotations `""` because they are not text strings. 

For example, you can select all rows that have a specific value in `precip` such as `1.62`.

{:.input}
```python
# Select rows equal to 1.62 in precip
avg_monthly_precip[avg_monthly_precip["precip"] == 1.62]
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
      <th>months</th>
      <th>precip</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>1.62</td>
      <td>Summer</td>
    </tr>
  </tbody>
</table>
</div>





You can also filter using a comparison operator on numeric values. 

For example, you can select all rows from the dataframe that have precipitation value greater than 2.0 inches by filtering on the `precip` column using the greater than `>` operator. 

{:.input}
```python
# Save rows with values greater than 2.0 to new dataframe
gt2_avg_monthly_precip = avg_monthly_precip[avg_monthly_precip["precip"] > 2.0]

gt2_avg_monthly_precip
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
      <th>months</th>
      <th>precip</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>2.93</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>3.05</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>2.02</td>
      <td>Summer</td>
    </tr>
  </tbody>
</table>
</div>





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Your Pandas Dataframes Skills 

Test your **Python** skills to:

1. Review how to download and import data files into **pandas** dataframe, using `precip-2002-2013-months-seasons.csv` which is available for download at "https://ndownloader.figshare.com/files/12710621".
    * This file contains two columns of average monthly precipitation values: one for 2002 and one for 2013.
2. Use the `.describe()` method to summarize the precipitation values in the dataframe (e.g. `precip_2002_2013`). Note the maximum values in 2002 and 2013. 
2. Use indexing to create two new dataframes:
    * one containing the month with the maximum value in 2002
    * one containing the month with the maximum value in 2013
3. Compare these new dataframes. 
    * Do they occur in the same season?
    * What do you notice about the precipitation value for the maximum month in 2013, as compared to that same month in 2002? 
4. Using the columns for months and the precipitation for 2013, create plot of Average Monthly Precipitation in 2013 for Boulder, CO.  
    * Recall that you can select a column as a **pandas** series using `dataframe["column"]`. 
    * If needed, review how to <a href="{{ site.url }}/courses/scientists-guide-to-plotting-data-in-python/plot-with-matplotlib/customize-plot-colors-labels-matplotlib/">create **matplotlib** plots with lists</a>, and then substitute the list names with series selected from the **pandas** dataframe.    

</div>


