---
layout: single
title: 'Selections From Pandas Dataframes'
excerpt: "This lesson walks you through using indexing to select data from pandas dataframes."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['pandas-dataframes']
permalink: /courses/earth-analytics-bootcamp/pandas-dataframes/selections-pandas-dataframes/
nav-title: "Selections From Pandas Dataframes"
dateCreated: 2019-07-24
modified: 2018-09-10
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 4
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will write `Python` code in `Jupyter Notebook` to select data from `pandas dataframes` using specific values as well as indexing.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Describe the two types of indexing for `pandas dataframes`: location-based and label-based
* Select data from `pandas dataframes` using location-based indexing
* Select data from `pandas dataframes` using specific values
* Select data from `pandas dataframes` using label-based indexing


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure you have completed the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/pandas-dataframes/import-csv-files-pandas-dataframes/">Importing CSV Files Into Pandas Dataframes</a> and <a href="{{ site.url }}/courses/earth-analytics-bootcamp/pandas-dataframes/manipulate-plot-pandas-dataframes/">Manipulate and Plot Pandas Dataframes</a>.

The code below is available in the **ea-bootcamp-day-5** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 

 </div>
 

## Selections From Pandas Dataframes

In the lesson introducing `pandas dataframes`, you learned that these data structures have an inherent tabular structure (i.e. rows and columns with header names) that support selecting data with indexing, such as selecting individual cells identified by their location at the intersection of rows and columns. 

You can also select data from `pandas dataframes` without knowing the location of that data within the `pandas dataframe`, using specific values such as a column name or data value.

In this lesson, you will review how indexing works for `pandas dataframes` and you will learn how to select data from `pandas dataframes` using specific values as well as indexing.


## Indexing For Pandas Dataframes

There are two kinds of indexing in `pandas dataframes`: location-based and label-based. 

After working with indexing for `Python` lists and `numpy arrays`, you are familiar with location-based indexing. 

You already know that `Python` location-based indexing begins with `[0]`, and you have learned how to use location-based indexing to query data within `Python` lists or `numpy arrays`.

You can also use location-based indexing to query `pandas dataframes` using `.iloc` and providing the row and column selection as ranges (i.e. start and stop locations along the rows and columns). 

The range provided is inclusive of the first value, but not the second value. This means that you need to use the range `[0:1]` to select the first index, so your selection begins at `[0]` but does not include `[1]`. 

For example, you can select the first row and the first column of a `pandas dataframes` providing the range `[0:1]` for the row selection and then providing the range `[0:1]` for the column selection.

```python
dataframe.iloc[0:1, 0:1]
```
In addition to location-based indexing, `pandas dataframes` can also be queried using label-based indexing. This feature of `pandas dataframes` is very useful because you can create an index for `pandas dataframes` based on a list of values that you want to use for organizing and querying your data.

For example, you can create an index from a specific column of values, and then use `.loc` to select data from the `pandas dataframes` using a value that is found in that index. 

```python

dataframe.setindex("column")
dataframe.loc["value"]
```
In this lesson, you will use both location and label indexing to select data from `pandas dataframes`.

## Begin Writing Your Code

By now, you are familiar with importing the necessary `Python` packages to set your working directory and download the needed datasets using the `os` and `urllib` packages. You also need to import the `pandas` package with the alias `pd`.

Begin by reviewing these tasks.

### Import Packages

{:.input}
```python
# import necessary Python packages
import os
import urllib.request
import pandas as pd

# print message after packages imported successfully
print("import of packages successful")
```

{:.output}
    import of packages successful



### Set Working Directory

Remember that you can check the current working directory using `os.getcwd()` and set the current working directory using `os.chdir()`.

{:.input}
```python
# set the working directory to the `earth-analytics-bootcamp` directory
# replace `jpalomino` with your username here and all paths in this lesson
os.chdir("/home/jpalomino/earth-analytics-bootcamp/")

# print the current working directory
os.getcwd()
```

{:.output}
{:.execute_result}



    '/home/jpalomino/earth-analytics-bootcamp'





### Download Data

Recall that you can use the `urllib` package to download data from the Earth Lab `Figshare.com` repository.

For this lesson, you will use the files from the prevous lesson: a .csv file containing the average monthly precipitation data for Boulder, CO, and another .csv file containing monthly precipitation for Boulder, CO in 2002 and 2013.

{:.input}
```python
# use `urllib` download files from Earth Lab figshare repository

# download .csv containing monthly average precipitation for Boulder, CO
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12710618", 
                           filename = "data/avg-precip-months-seasons.csv")

# download .csv containing monthly precipitation for Boulder, CO in 2002 and 2013
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12710621", 
                           filename = "data/precip-2002-2013-months-seasons.csv")

# print message that data downloads were successful
print("datasets downloaded successfully")
```

{:.output}
    datasets downloaded successfully



### Import Tabular Data Into Pandas Dataframes

You also know how to import CSV files into `pandas dataframes`.

{:.input}
```python
# import the monthly average precipitation values as a pandas dataframe
avg_precip = pd.read_csv("/home/jpalomino/earth-analytics-bootcamp/data/avg-precip-months-seasons.csv")

# import the monthly precipitation values in 2002 and 2013 as a pandas dataframe
precip_2002_2013 = pd.read_csv("/home/jpalomino/earth-analytics-bootcamp/data/precip-2002-2013-months-seasons.csv")
```

## Selections Using Location Index (.iloc)

You can use `.iloc` to select individual rows and columns or a series of rows and columns by providing the range (i.e. start and stop locations along the rows and columns) that you want to select.

Recall that in `Python` indexing begins with `[0]` and that the range you provide is inclusive of the first value, but not the second value.

This means that you can use `dataframe.iloc[0:1, 0:1]` to select the cell value at the intersection of the first row and first column of the dataframe.

{:.input}
```python
# select first row and first column
avg_precip.iloc[0:1, 0:1]
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
# select first two rows and first column
avg_precip.iloc[0:2, 0:1]
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
# select first row and first two columns
avg_precip.iloc[0:1, 0:2]
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





You can also use `iloc` to select an entire row or an entire column by leaving the other range without values.

For example, you can use `dataframe.iloc[0:1, :]` to select the first row of a dataframe and all of the columns, or `dataframe.iloc[ :, 0:1]` to select the first column of a dataframe and all of the rows. 

{:.input}
```python
# select first row with all columns
avg_precip.iloc[0:1, :]
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
# select first column with all rows
avg_precip.iloc[:, 0:1]
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





## Selections Using Specific Criteria Values

In addition to location-based indexing, you can also select data from `pandas dataframes` using specific values. 

For example, you can select all data from a specific column in `pandas dataframes` using `dataframe.[["columnname"]]`. 

{:.input}
```python
# select the `months` column 
avg_precip[["months"]]
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





Notice that your results are also a `pandas dataframe`.

You can also select all data from multiple columns in `pandas dataframes` using `dataframe.[["columnname", "columnname"]]`.  As the results of your selection are also a `pandas dataframe`, you can assign the results to a new `pandas dataframe`.

For example, you can create a new `pandas dataframe` that only contains the `months` and `seasons` columns, effectively dropping the `precip` values. 

{:.input}
```python
# select the columns `months` and `seasons` and save to new dataframe
avg_precip_text = avg_precip[['months', 'seasons']]

# print new dataframe
avg_precip_text
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





If you call your original `pandas dataframe`, you will see it is unchanged.

{:.input}
```python
# print original dataframe
avg_precip
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





You can also select data based on specific values within a column using `dataframe[dataframe.columnname == "value"]`. This will return all rows containing that value within the specified column. 

If you are selecting data using a text string column, you need to provide the value within parentheses (e.g. `"textvalue"`). 

For example, you can select all rows that have a `seasons` value of `Summer`. 

{:.input}
```python
# select rows that has a value of `Summer` in `seasons` column
avg_precip[avg_precip.seasons == "Summer"]
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





You can also select data based on numeric values; these selections do not require the use of parentheses. 

For example, you can select all rows that have a specific value in `precip` such as `1.62`.

{:.input}
```python
# select rows that have value of 1.62 in `precip` column
avg_precip[avg_precip.precip == 1.62]
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





## Selections Using Label Index (.loc)

In addition to selecting data based on specific values, you can also create new index based on a list of values that you want to use for organizing and querying your data. 

For example, you can create an index from a specific column of values using `dataframe.set_index("column")`.

<i class="fa fa-star" aria-hidden="true"></i> **Data Tip:** Creating a new index will restructure the data by replacing the default location indexing (i.e. `[0]`) with the new index.  This also means the column used to create the index is no longer a functional column, but rather an index of the dataframe.   
{: .notice--success}

{:.input}
```python
# create index using the values in the column `months`
avg_precip = avg_precip.set_index("months")

# print the data to see the new structure
avg_precip
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





Test that `months` no longer functions as a column by atempting to select all data using that column name, as you did previously when `months` was still a column. 

{:.input}
```python
# Uncomment and run the line below to see the error message that appears
# avg_precip[["months"]]
```

Notice that the error message indicates that the value `months` is not in the index. This is because `months` is actually now the index!

After setting an index, you can use `.loc` to select data from the `pandas dataframes` using a value that is found in that index. 

{:.input}
```python
# select data for `Aug` using the new index `months` 
avg_precip.loc[["Aug"]]
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





Congratulations! You have now learned how to select data from `pandas dataframes` using specific values as well as location-based and label-based indexing. 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Use the `.describe()` method to summarize the precipitation values in `precip_2002_2013`. Note the maximum values in 2002 and 2013. 

2. Use indexing to create two new dataframes:
    * one containing the month with the maximum value in 2002
    * one containing the month with the maximum value in 2013

3. Compare these new dataframes. 
    * Do they occur in the same season?
    * What do you notice about the precipitation value for the maximum month in 2013 (`Sept`), as compared to that same month in 2002? 

</div>


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
      <th>precip_2002</th>
      <th>precip_2013</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>12.000000</td>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1.156667</td>
      <td>2.845833</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.961101</td>
      <td>4.953130</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.020000</td>
      <td>0.270000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.380000</td>
      <td>0.582500</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1.125000</td>
      <td>1.265000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1.505000</td>
      <td>2.345000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>3.200000</td>
      <td>18.160000</td>
    </tr>
  </tbody>
</table>
</div>






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
      <th>precip_2002</th>
      <th>precip_2013</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>3.2</td>
      <td>2.66</td>
      <td>Spring</td>
    </tr>
  </tbody>
</table>
</div>






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
      <th>precip_2002</th>
      <th>precip_2013</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>1.52</td>
      <td>18.16</td>
      <td>Fall</td>
    </tr>
  </tbody>
</table>
</div>




