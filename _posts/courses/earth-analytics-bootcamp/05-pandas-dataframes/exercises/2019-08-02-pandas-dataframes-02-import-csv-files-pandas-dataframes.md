---
layout: single
title: 'Import CSV Files Into Pandas Dataframes'
excerpt: "This lesson walks you through importing tabular data from .csv files to pandas dataframes."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['pandas-dataframes']
permalink: /courses/earth-analytics-bootcamp/pandas-dataframes/import-csv-files-pandas-dataframes/
nav-title: "Import CSV Files Into Pandas Dataframes"
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
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will write `Python` code in `Jupyter Notebook` to import tabular data from text files (.csv) into `pandas dataframes`. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain how .csv files are used to store and organize tabular data
* Import tabular data from .csv files to `pandas dataframes`


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/numpy-arrays/import-text-files-numpy-arrays/">Importing Text Files Into Numpy Arrays</a> and on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/pandas-dataframes/intro-pandas-dataframes/">Intro to Pandas Dataframes.</a>

Be sure that you have a subdirectory called `data` under your `earth-analytics-bootcamp` directory. For help with this task, please see the challenge for the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/intro-shell/">Intro to Shell.</a>

The code below is available in the **ea-bootcamp-day-5** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 

 </div>
 

## Pandas Dataframes

In the lesson introducing `pandas dataframes`, you learned that these data structures are inherently tabular, meaning that all values (or cells) have a row index and a column index, even if the data only has one row and/or one column. 

You also learned that unlike `numpy arrays`, `pandas dataframes` are two-dimensional by default and are composed of rows and columns. Each column in a `pandas dataframe` can have a labeled name (i.e. header name) and can contain a different type of data from its neighboring columns. 

You also learned that due to its inherent tabular structure, you can query and run calculations on `pandas dataframes` across an entire row, an entire column, or a specific cell or series of cells based on either location and attribute values.

In this lesson, you will learn how to import tabular data from text files (.csv) into `pandas dataframes`, so you can take advantage of the benefits of working with `pandas dataframes`. 


## CSV Files For Tabular Data

In this lesson, you will work with tabular data that orignate from comma delimited (.csv), or CSV files. As you learned in the lessons on `numpy arrays`, CSV files are a very common file format used to collect and organize scientific data.   

You also learned that unlike plain-text files which simply list out the values on separate lines without any symbols or delimiters, CSV files use commas (or some other delimiter like tab spaces or semi-colons) to indicate separate values. 

CSV files also support labeled names for the columns, referred to as headers. This means that CSV files can easily support multiple columns of related data. 

Furthermore, these columns are data do not all have to be of the same type (i.e. all numeric or text strings).

For example, data for the average monthly precipitation data for Boulder, CO and the month names can actually be stored together in a comma delimited (.csv) file.

```python
months, precip
Jan, 0.70
Feb, 0.75
Mar, 1.85
Apr, 2.93
May, 3.05
June, 2.02
July, 1.93
Aug, 1.62
Sept, 1.84
Oct, 1.31
Nov, 1.39
Dec, 0.84
```

Due to its tabular structure with headers, CSV files are very useful for collecting and organizing datasets that contain related data of different types and across multiple locations and/or timeframes. 
 
In this lesson, you will import tabular data from:

* a csv file containing the average monthly precipitation data for Boulder, CO and the month and season names


## Begin Writing Your Code

From previous lessons, you know how to import the necessary `Python` packages to set your working directory and download the needed datasets using the `os` and `urllib` packages. 

To work with `pandas dataframes`, you will also need to import the `pandas` package with the alias `pd`. Begin by reviewing these tasks.

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

For this lesson, you will download a .csv file containing the average monthly precipitation data for Boulder, CO and the month and season names.

{:.input}
```python
# use `urllib` download files from Earth Lab figshare repository

# download .csv containing monthly average precipitation for Boulder, CO
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12710618", 
                           filename = "data/avg-precip-months-seasons.csv")

# print message that data downloads were successful
print("datasets downloaded successfully")
```

{:.output}
    datasets downloaded successfully



## Import Tabular Data Into Pandas Dataframes

Using the `read_csv()` function from the `pandas` package, you can import tabular data from CSV files into `pandas dataframe` by specifying a parameter value for the file name (e.g. `pd.read_csv("filename.csv")`). 

Remember that you gave `pandas` an alias (`pd`), so you will use `pd` to call `pandas` functions. Be sure to update the path to the CSV file to your home directory. 

{:.input}
```python
# import the monthly average precipitation values as a pandas dataframe
avg_precip = pd.read_csv("/home/jpalomino/earth-analytics-bootcamp/data/avg-precip-months-seasons.csv")
```

Recall from previous lessons that you can check the type of any data structure using `type(variablename)`.

For `pandas dataframes`, you can also easily see the data by simply calling the name of the `pandas dataframe`. No `print()` function needed.

{:.input}
```python
# print the type for the pandas dataframe
print(type(avg_precip))

# print the values in the pandas dataframe
avg_precip
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>



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





As you can see, the `months` and `precip` data can exist together in the same `pandas dataframe`, which differs from `numpy arrays`. You can see that there is also a column for `seasons` containing text strings. 

You can also see that the indexing still begins with `[0]`, as it does for `Python` lists and `numpy arrays`. 

Notice that you did not have to use the `print()` function to see the contents of the `pandas dataframe`, and that it is displayed with clear tabular formatting. 

Congratulations! You have now learned how to import tabular data from CSV files into `pandas dataframes`.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Download a .csv file containing the monthly precipitation for Boulder, CO for the years 2002 and 2013 and the month and season names (`precip-2002-2013-months-seasons.csv`)from `https://ndownloader.figshare.com/files/12710621`. 
    * Be sure to assign a useful variable name that is short but indicative of what it contains (e.g. `precip_2002_2013`).

2. Import the data from this .csv file into a `pandas dataframe`. 
    
3. Print the data type of your new `pandas dataframe` as well as its contents.

</div>


{:.output}
    <class 'pandas.core.frame.DataFrame'>



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
      <th>0</th>
      <td>Jan</td>
      <td>1.07</td>
      <td>0.27</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>0.44</td>
      <td>1.13</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>1.50</td>
      <td>1.72</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>0.20</td>
      <td>4.14</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>3.20</td>
      <td>2.66</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>1.18</td>
      <td>0.61</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>0.09</td>
      <td>1.03</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>1.44</td>
      <td>1.40</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>1.52</td>
      <td>18.16</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>2.44</td>
      <td>2.24</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>0.78</td>
      <td>0.29</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.02</td>
      <td>0.50</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>




