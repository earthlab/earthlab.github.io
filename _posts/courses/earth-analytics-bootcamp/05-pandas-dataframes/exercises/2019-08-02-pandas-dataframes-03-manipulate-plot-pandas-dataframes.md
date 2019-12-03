---
layout: single
title: 'Manipulate and Plot Pandas Dataframes'
excerpt: "This lesson walks you through describing, manipulating, and plotting pandas dataframes."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['pandas-dataframes']
permalink: /courses/earth-analytics-bootcamp/pandas-dataframes/manipulate-plot-pandas-dataframes/
nav-title: "Manipulate and Plot Pandas Dataframes"
dateCreated: 2019-07-24
modified: 2018-08-10
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 5
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will write `Python` code in `Jupyter Notebook` to describe, manipulate and plot data in `pandas dataframes`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Run functions that are inherent to `pandas dataframes` (i.e. methods)
* Query automatically generated characteristics about `pandas dataframes` (i.e. attributes)
* Create a plot using data in `pandas dataframes` 


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure you have completed the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/pandas-dataframes/import-csv-files-pandas-dataframes/">Importing CSV Files Into Pandas Dataframes</a>.

The code below is available in the **ea-bootcamp-day-5** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 

 </div>
 

## Methods and Attributes

### Methods
Previous lessons have introduced the concept of functions as commands that can take inputs that are used to produce output. For example, you have used many functions, including the `print()` function to display the results of your code and to write messages about the results. 

```python
print("Message as text string goes here")
```
You have also used functions provided by `Python` packages such as `numpy` to run calculations on `numpy arrays`. 

For example, you used `np.mean()` to calculate the average value of specified `numpy array`. In these `numpy` functions, you explicitly provided the name of the variable as an input parameter.    

```python
print("Mean Value: ", np.mean(arrayname))
```

In `Python`, data structures, such as `pandas dataframes`, can provide built-in functions that are referred to as methods. Each data structure has its own set of methods, based on how the data is organized and the types of operations supported by the data structure . 

A method can be called by adding the `.function()` after the name of the data structure (e.g. `structurename.function()`), rather than providing the name as an input parameter (e.g. `function(structurename)`). 

In this lesson, you will explore some methods that are provided with the `pandas dataframe` data structure. 

### Attributes

In addition to functions, you have also unknowingly worked with attributes, which are automatically created characteristics (i.e. metadata) about the data structure or object that you are working with. 

For example, you used `.shape` to get the dimensions of a specific `numpy array` (e.g. `arrayname.shape`), which is an attribute that is automatically generated about the `numpy array` when it is created.

In this lesson, you will use attributes to get more information about `pandas dataframes` and run functions (i.e. methods) inherent to the `pandas dataframes` data structure to learn about the benefits of working with `pandas dataframes`.


## Begin Writing Your Code

From previous lessons, you know how to import the necessary `Python` packages to set your working directory and download the needed datasets using the `os` and `urllib` packages. 

To work with `pandas dataframes`, you will also need to import the `pandas` package with the alias `pd`, and you will need to import the `matplotlib.pyplot` module with the alias `plt` to plot data. Begin by reviewing these tasks.

### Import Packages

{:.input}
```python
# import necessary Python packages
import os
import urllib.request
import pandas as pd
import matplotlib.pyplot as plt

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

For this lesson, you will download a .csv file containing the average monthly precipitation data for Boulder, CO, and another .csv file containing monthly precipitation for Boulder, CO in 2002 and 2013.

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

You also learned how to import CSV files into `pandas dataframes`.

{:.input}
```python
# import the monthly average precipitation values as a pandas dataframe
avg_precip = pd.read_csv("/home/jpalomino/earth-analytics-bootcamp/data/avg-precip-months-seasons.csv")

# import the monthly precipitation values in 2002 and 2013 as a pandas dataframe
precip_2002_2013 = pd.read_csv("/home/jpalomino/earth-analytics-bootcamp/data/precip-2002-2013-months-seasons.csv")
```

## View Contents of Pandas Dataframes

Rather than seeing all of the data at once, you can choose to see the first few rows or the last few rows using the `pandas dataframe` methods `.head()` or `.tail()` (e.g. `dataframe.tail()`). 

This capability can be very useful for large datasets which cannot easily be displayed within `Jupyter Notebook`. 

{:.input}
```python
# check the first few rows in `avg_precip`
avg_precip.head()
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
  </tbody>
</table>
</div>





## Describe Contents of Pandas Dataframes

You can use the method `.info()` to get more details, or metadata, about a `pandas dataframe` (e.g. `dataframe.info()`) such as the number of rows and columns and the column names. 

{:.input}
```python
# check the metadata about `avg_precip`
avg_precip.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 12 entries, 0 to 11
    Data columns (total 3 columns):
    months     12 non-null object
    precip     12 non-null float64
    seasons    12 non-null object
    dtypes: float64(1), object(2)
    memory usage: 368.0+ bytes



The output of the `.info()` method shows you the number of rows (or entries) and the number of columns, as well as the columns names and the types of data they contain (e.g. float64 which is the default decimal type in `Python`).

You can use other methods to produce summarized results about data values contained within the `pandas dataframes`.

For example, you can use the method `.describe()` to run summary statistics about the numeric columns in `pandas dataframe` (e.g. `dataframe.describe()`), such as the count, mean, minimum and maximum values. 

{:.input}
```python
# run summary statistics on `avg_precip`
avg_precip.describe()
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
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>12.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>1.685833</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.764383</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.700000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>1.192500</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>1.730000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1.952500</td>
    </tr>
    <tr>
      <th>max</th>
      <td>3.050000</td>
    </tr>
  </tbody>
</table>
</div>





Recall that in the lessons on `numpy arrays`, you ran multiple functions to get the mean, minimum and maximum values of `numpy arrays`. This fast calculation of summary statistics is a clear benefit of using `pandas dataframes` over `numpy arrays`.

The `.describe()` method also provides the standard deviation (i.e. a measure of the amount of variation across the data) as well as the quantiles of the `pandas dataframe`, which tell us how the data are distributed between the minimum and maximum values (e.g. the 25% quantile indicates the cut-off for the lowest 25% values in the data).

## Sort Data Values in Pandas Dataframes

Recall that in the lessons on `numpy arrays`, you can only identify the value that is the minimum or maximum, but not the month in which the value occurred. This is because `precip` and `months` are not connected in an easy way that would allow you to determine the month that matches the values. 

Using `pandas dataframes`, you can sort the values with the method `.sort_values()`, providing the column name and a parameter for `ascending` (e.g. `dataframe.sort_values(by="columname", ascending = True)`). 

Sort by the values in the `precip` column in descending order (`ascending = False`) to find the maximum value and its corresponding month. 

{:.input}
```python
# sort values in descending order to identify the month with maximum value for `precip` within `precip_df`
avg_precip.sort_values(by="precip", ascending = False)
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
      <th>4</th>
      <td>May</td>
      <td>3.05</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>2.93</td>
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
      <th>2</th>
      <td>Mar</td>
      <td>1.85</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>1.84</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>1.62</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>1.39</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>1.31</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.84</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>0.75</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>0.70</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





## Run Calculations on Columns Within Pandas Dataframes

You can easily recalculate the values of a column within a `pandas dataframe` setting the column equal to the result of the desired calculation (e.g. `dataframe.column = dataframe.column + 4`, which would add the number 4 to each value in the column).

You can use this capability to easily convert the values in the `precip` column from inches to millimeters (where one inch is equal to 25.4 millimeters). 

{:.input}
```python
# multiply the values in `precip` column to convert from inches to millimeters
avg_precip.precip = avg_precip.precip * 25.4

# print the values in `avg_precip`
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
      <td>17.780</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>19.050</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>46.990</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>74.422</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>77.470</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>51.308</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>49.022</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>41.148</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>46.736</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>33.274</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>35.306</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>21.336</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





## Plot Pandas Dataframes

In the previous lessons, you saw that it is easy to use multiple `numpy arrays` within the same plot but you have to make sure that the dimensions of the `numpy arrays` are compatible. 

`Pandas dataframes` make it even easier to plot the data because the tabular structure is already built-in. 

In fact, you do not have to create any new variables to plot data from `pandas dataframes`.

You can simply reuse your `matplotlib.pyplot` code from the `numpy arrays` lesson, using the dataframe and column names to plot data (e.g. `dataframe.column`) along each axis. 

{:.input}
```python
# set plot size for all plots that follow
plt.rcParams["figure.figsize"] = (8, 8)

# create the plot space upon which to plot the data
fig, ax = plt.subplots()

# add the x-axis and the y-axis to the plot
ax.bar(avg_precip.months, avg_precip.precip, color="grey")

# set plot title
ax.set(title="Average Monthly Precipitation in Boulder, CO")

# add labels to the axes
ax.set(xlabel="Month", ylabel="Precipitation (mm)");
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-bootcamp/05-pandas-dataframes/exercises/2019-08-02-pandas-dataframes-03-manipulate-plot-pandas-dataframes_20_0.png)




Congratulations! You have now learned how to run methods and query attributes of `pandas dataframes`. You also recalculated values and created plots from `pandas dataframes`.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Test your `Python` skills to:

1. Convert the `precip_2002` column in `precip_2002_2013` to millimeters (one inch = 25.4 millimeters).

2. Create a **blue line plot** of monthly precipitation for Boulder, CO in 2002. Be sure to include a title and labels for the axes. If needed, refer to the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/plot-data-matplotlib/">Plot Data in Python with Matplotlib.</a>.

</div>


{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-bootcamp/05-pandas-dataframes/exercises/2019-08-02-pandas-dataframes-03-manipulate-plot-pandas-dataframes_23_0.png)




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

Test your `Python` skills to:

1. Convert the `precip_2013` column in `precip_2002_2013` to millimeters (one inch = 25.4 millimeters).

2. Create a **blue scatter plot** of monthly precipitation for Boulder, CO in 2013. Be sure to include a title and labels for the axes. If needed, refer to the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/plot-data-matplotlib/">Plot Data in Python with Matplotlib.</a>.

3. Compare your plot for 2013 to the one for 2002. 
    * Does the maximum precipitation occur in the same month? 
    * What do you notice about the y-axis of the 2013, as compared to the 2002 plot?
    
</div>


{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-bootcamp/05-pandas-dataframes/exercises/2019-08-02-pandas-dataframes-03-manipulate-plot-pandas-dataframes_25_0.png)



