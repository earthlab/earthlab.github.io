---
layout: single
title: 'Data Wrangling With Pandas'
excerpt: "This lesson teaches you how to wrangle data (e.g. subselect, update, and combine) with pandas dataframes."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['data-wrangling']
permalink: /courses/earth-analytics-bootcamp/data-wrangling/data-wrangling-pandas/
nav-title: "Data Wrangling With Pandas"
dateCreated: 2019-08-11
modified: 2018-09-10
module-type: 'class'
module-title: 'Data Wrangling With Pandas Dataframes and Numpy Arrays in Python'
module-nav-title: 'Data Wrangling'
module-description: 'This tutorial walks you through wrangling data (e.g. subselect, combine and update) using pandas dataframes and numpy arrays.'
class-order: 2
course: "earth-analytics-bootcamp"
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how update, filter and group values in `pandas dataframes` and how to append new data to `pandas dataframes`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Run a function on a column within a `pandas dataframe`
* Filter values in a `pandas dataframe`
* Group values in a `pandas dataframe`
* Append new data to a `pandas dataframe`

</div>

## Data Wrangling With Pandas

`Pandas dataframes` offer many ways to update and select data. In this lesson, you will learn about some common data tasks that can be very useful to:
1. update the values in specific columns using functions
2. create new dataframes from selections and from grouping data
3. create new dataframes by combining existing dataframes.

Begin by downloading and importing two `pandas dataframes` that contain temperature (Fahrenheit) for each month in 2010 to 2013 and 2014 to 2017. 

{:.input}
```python
# import necessary packages
import os
import pandas as pd
import urllib.request

# set the working directory to the `earth-analytics-bootcamp` directory
# replace `jpalomino` with your username here and all paths in this lesson
os.chdir("/home/jpalomino/earth-analytics-bootcamp/")

# download .csv containing monthly temperature in 2010 to 2013 for Boulder, CO
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12815417", 
                           filename = "data/monthly-temp-2010-to-2013.csv")

# download .csv containing monthly temperature in 2010 to 2013 for Boulder, CO
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12815420", 
                           filename = "data/monthly-temp-2014-to-2017.csv")

# import monthly temperature values for 2010 to 2013 as a pandas dataframe
monthly_temp_2010_to_2013 = pd.read_csv("/home/jpalomino/earth-analytics-bootcamp/data/monthly-temp-2010-to-2013.csv")

# import monthly temperature values for 2014 to 2017 as a pandas dataframe
monthly_temp_2014_to_2017 = pd.read_csv("/home/jpalomino/earth-analytics-bootcamp/data/monthly-temp-2014-to-2017.csv")
```

### Review Structure of Dataframe

Recall that with the `.head()` method, you can see the structure of the data without having to print the entire dataframe.

Print `.head()` for each dataframe, and note their structures (i.e. how the data are organized).

{:.input}
```python
# print .head() for 2010 to 2013
monthly_temp_2010_to_2013.head()
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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>2010</td>
      <td>33.0</td>
      <td>Winter</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>2010</td>
      <td>30.1</td>
      <td>Winter</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>2010</td>
      <td>42.7</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>2010</td>
      <td>48.8</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>2010</td>
      <td>53.9</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# print .head() for 2014 to 2017
monthly_temp_2014_to_2017.head()
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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>2014</td>
      <td>34.6</td>
      <td>Winter</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>2014</td>
      <td>32.0</td>
      <td>Winter</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>2014</td>
      <td>43.6</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>2014</td>
      <td>49.8</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>2014</td>
      <td>56.6</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





## Apply Function to Column in Dataframe

Just like you can apply a function to a `numpy array`, you can apply a function to a specific column in a `pandas dataframe` using `dataframe["column_name"].apply(function_name)`. 

You specify a specific column in a `pandas dataframe` because you may have some columns for which the function cannot produce output. 

For example, review this function to convert input values from Fahrenheit to Celsius.

{:.input}
```python
# define function to convert value(s) from Fahrenheit to Celsius
def fah_to_cel(x):
    
    # convert values from Fahrenheit to Celsius using Celsius = ((Fahrenheit - 32) / 1.8)
    # can take single value, single value variable, or numpy array as input
    x = (x - 32) / 1.8
    
    # returns value(s) converted from Fahrenheit to Celsius
    return(x)    
```

As this function runs on numeric values, you cannot apply this function to a column with text strings. 

For the `monthly_temp_2010_to_2013` dataframe, you can run `fah_to_cel` on the column with temperature values by specifying the column name that contains these values: `"Temp"`.

You can also replace the existing values in `Temp` column by setting the column equal to the output of the applied function.

{:.input}
```python
# Replace values in `Temp` with the calculated values from the applied function `fah_to_cel`
monthly_temp_2010_to_2013["Temp"] = monthly_temp_2010_to_2013["Temp"].apply(fah_to_cel)

# print .head() for 2010 to 2013 to see updated values
monthly_temp_2010_to_2013.head()
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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>2010</td>
      <td>0.555556</td>
      <td>Winter</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>2010</td>
      <td>-1.055556</td>
      <td>Winter</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>2010</td>
      <td>5.944444</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>2010</td>
      <td>9.333333</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>2010</td>
      <td>12.166667</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





## Filter Values in Pandas Dataframe 

Another useful data wrangling option is the ability to filter data from an existing `pandas dataframe`. 

Filtering data is easily done using `dataframe.column_name == "value"`. Your output will contain all rows that meet the criteria. 

Again, you can also save the output to a new dataframe by creating a new variable and setting it equal to the output of the filter. 

For example, you can filter for the values in the `Month` column that are equal to `January` in `monthly_temp_2010_to_2013` and save the output to a new dataframe.

{:.input}
```python
# # create new dataframe from filter on values in the `Month` column that are equal to `January`
jan_temp_2010_to_2013 = monthly_temp_2010_to_2013[monthly_temp_2010_to_2013.Month == "January"]

# print new dataframe
jan_temp_2010_to_2013 
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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>2010</td>
      <td>0.555556</td>
      <td>Winter</td>
      <td>51.5750</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>12</th>
      <td>January</td>
      <td>2011</td>
      <td>0.611111</td>
      <td>Winter</td>
      <td>51.6583</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>24</th>
      <td>January</td>
      <td>2012</td>
      <td>3.833333</td>
      <td>Winter</td>
      <td>54.6083</td>
      <td>warm</td>
    </tr>
    <tr>
      <th>36</th>
      <td>January</td>
      <td>2013</td>
      <td>0.555556</td>
      <td>Winter</td>
      <td>51.6583</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





You can also filter using a comparison operator on numeric values. For example, you can select all rows from the dataframe that have temperature greater than 20 degrees Celsius by filtering on the `Temp` column. 

{:.input}
```python
# create new dataframe from filter on values in the `Temp` column greater than 20 degrees Celsius
gt60_temp_2010_to_2013 = monthly_temp_2010_to_2013[monthly_temp_2010_to_2013.Temp > 20]

# print new dataframe
gt60_temp_2010_to_2013
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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>2010</td>
      <td>22.500000</td>
      <td>Summer</td>
      <td>51.5750</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>7</th>
      <td>August</td>
      <td>2010</td>
      <td>22.444444</td>
      <td>Summer</td>
      <td>51.5750</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>18</th>
      <td>July</td>
      <td>2011</td>
      <td>23.055556</td>
      <td>Summer</td>
      <td>51.6583</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>19</th>
      <td>August</td>
      <td>2011</td>
      <td>23.944444</td>
      <td>Summer</td>
      <td>51.6583</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>29</th>
      <td>June</td>
      <td>2012</td>
      <td>23.444444</td>
      <td>Summer</td>
      <td>54.6083</td>
      <td>warm</td>
    </tr>
    <tr>
      <th>30</th>
      <td>July</td>
      <td>2012</td>
      <td>23.777778</td>
      <td>Summer</td>
      <td>54.6083</td>
      <td>warm</td>
    </tr>
    <tr>
      <th>31</th>
      <td>August</td>
      <td>2012</td>
      <td>22.888889</td>
      <td>Summer</td>
      <td>54.6083</td>
      <td>warm</td>
    </tr>
    <tr>
      <th>41</th>
      <td>June</td>
      <td>2013</td>
      <td>21.055556</td>
      <td>Summer</td>
      <td>51.6583</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>42</th>
      <td>July</td>
      <td>2013</td>
      <td>22.333333</td>
      <td>Summer</td>
      <td>51.6583</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>43</th>
      <td>August</td>
      <td>2013</td>
      <td>22.333333</td>
      <td>Summer</td>
      <td>51.6583</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





## Group Values in Pandas Dataframe

In addition to filtering data by specific values, you can also group data that share a common value, in order to summarize the grouped data by another column. 

For example, in the example dataframes, you could group the data by the `Month` and then run the `describe()` method on `Temp`. This would run `.describe()` on the temperature values for each month of data as a separate group.

To do this, you can use the following syntax: `dataframe.groupby(['label_column'])[["value_column"]].describe()`. 

In this example, the `label_column` on which you want to group data is `Month` and the `value_column` that you want to summarize is `Temp`.  

{:.input}
```python
# create new dataframe from the .describe() output of `Temp` based on the groupby on `Month` column
month_temp_2014_2017_summary = monthly_temp_2014_to_2017.groupby(["Month"])[["Temp"]].describe()

# print new dataframe
month_temp_2014_2017_summary
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

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="8" halign="left">Temp</th>
    </tr>
    <tr>
      <th></th>
      <th>count</th>
      <th>mean</th>
      <th>std</th>
      <th>min</th>
      <th>25%</th>
      <th>50%</th>
      <th>75%</th>
      <th>max</th>
    </tr>
    <tr>
      <th>Month</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>April</th>
      <td>4.0</td>
      <td>49.450</td>
      <td>0.591608</td>
      <td>48.9</td>
      <td>48.975</td>
      <td>49.40</td>
      <td>49.875</td>
      <td>50.1</td>
    </tr>
    <tr>
      <th>August</th>
      <td>4.0</td>
      <td>69.775</td>
      <td>0.784750</td>
      <td>69.0</td>
      <td>69.150</td>
      <td>69.80</td>
      <td>70.425</td>
      <td>70.5</td>
    </tr>
    <tr>
      <th>December</th>
      <td>4.0</td>
      <td>33.850</td>
      <td>1.869938</td>
      <td>32.0</td>
      <td>32.825</td>
      <td>33.50</td>
      <td>34.525</td>
      <td>36.4</td>
    </tr>
    <tr>
      <th>February</th>
      <td>4.0</td>
      <td>37.950</td>
      <td>4.649373</td>
      <td>32.0</td>
      <td>35.450</td>
      <td>38.75</td>
      <td>41.250</td>
      <td>42.3</td>
    </tr>
    <tr>
      <th>January</th>
      <td>4.0</td>
      <td>34.350</td>
      <td>1.767295</td>
      <td>32.2</td>
      <td>33.625</td>
      <td>34.35</td>
      <td>35.075</td>
      <td>36.5</td>
    </tr>
    <tr>
      <th>July</th>
      <td>4.0</td>
      <td>72.600</td>
      <td>1.741647</td>
      <td>70.3</td>
      <td>71.725</td>
      <td>73.05</td>
      <td>73.925</td>
      <td>74.0</td>
    </tr>
    <tr>
      <th>June</th>
      <td>4.0</td>
      <td>68.425</td>
      <td>1.765172</td>
      <td>66.2</td>
      <td>67.775</td>
      <td>68.50</td>
      <td>69.150</td>
      <td>70.5</td>
    </tr>
    <tr>
      <th>March</th>
      <td>4.0</td>
      <td>45.750</td>
      <td>3.317127</td>
      <td>43.0</td>
      <td>43.450</td>
      <td>44.85</td>
      <td>47.150</td>
      <td>50.3</td>
    </tr>
    <tr>
      <th>May</th>
      <td>4.0</td>
      <td>54.700</td>
      <td>1.849324</td>
      <td>52.4</td>
      <td>53.675</td>
      <td>54.90</td>
      <td>55.925</td>
      <td>56.6</td>
    </tr>
    <tr>
      <th>November</th>
      <td>4.0</td>
      <td>43.525</td>
      <td>4.702039</td>
      <td>38.3</td>
      <td>40.175</td>
      <td>44.15</td>
      <td>47.500</td>
      <td>47.5</td>
    </tr>
    <tr>
      <th>October</th>
      <td>4.0</td>
      <td>55.450</td>
      <td>3.022692</td>
      <td>51.5</td>
      <td>54.350</td>
      <td>55.75</td>
      <td>56.850</td>
      <td>58.8</td>
    </tr>
    <tr>
      <th>September</th>
      <td>4.0</td>
      <td>65.400</td>
      <td>2.733740</td>
      <td>63.5</td>
      <td>63.725</td>
      <td>64.35</td>
      <td>66.025</td>
      <td>69.4</td>
    </tr>
  </tbody>
</table>
</div>





In addition to running `.describe()` using a groupby, you can also run individual statistics such as `.count()` to get the number of rows belonging to a specific group (i.e. month) and other summary statistics such as `.median()`, `.sum()`, `.mean()`, etc, to calculate these summary statistics by a chosen group.

In the example below, `.median()` is being executed on `Temp` using a groupby on `Month`. 

{:.input}
```python
# create new dataframe from groupby calculation of .median() on `Temp`
month_temp_2014_2017_median = monthly_temp_2014_to_2017.groupby(["Month"])[["Temp"]].median()

# print new dataframe
month_temp_2014_2017_median
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
      <th>Temp</th>
    </tr>
    <tr>
      <th>Month</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>April</th>
      <td>49.40</td>
    </tr>
    <tr>
      <th>August</th>
      <td>69.80</td>
    </tr>
    <tr>
      <th>December</th>
      <td>33.50</td>
    </tr>
    <tr>
      <th>February</th>
      <td>38.75</td>
    </tr>
    <tr>
      <th>January</th>
      <td>34.35</td>
    </tr>
    <tr>
      <th>July</th>
      <td>73.05</td>
    </tr>
    <tr>
      <th>June</th>
      <td>68.50</td>
    </tr>
    <tr>
      <th>March</th>
      <td>44.85</td>
    </tr>
    <tr>
      <th>May</th>
      <td>54.90</td>
    </tr>
    <tr>
      <th>November</th>
      <td>44.15</td>
    </tr>
    <tr>
      <th>October</th>
      <td>55.75</td>
    </tr>
    <tr>
      <th>September</th>
      <td>64.35</td>
    </tr>
  </tbody>
</table>
</div>





Note the structure of the new dataframe. Does it look different than other dataframes you have seen?

Run the `.info()` to see that the index is now the month names, which you recall means that `Month` is no longer a column.

{:.input}
```python
# print .info() on new dataframe
month_temp_2014_2017_median.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    Index: 12 entries, April to September
    Data columns (total 1 columns):
    Temp    12 non-null float64
    dtypes: float64(1)
    memory usage: 192.0+ bytes



### Reset Index After Group-by

You can easily reset the index after running a `groupby` using the syntax: `dataframe.reset_index()`. 

For example, running this syntax on `month_temp_2014_2017_median` will remove the month names as the index and recreate the column called `Month`.

Now the data is back to a familiar format but retains the values calculated with the `groupby`.

{:.input}
```python
# create new dataframe with reset of index
month_temp_2014_2017_median_reset = month_temp_2014_2017_median.reset_index()

# print new dataframe
month_temp_2014_2017_median_reset
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
      <th>Month</th>
      <th>Temp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>April</td>
      <td>49.40</td>
    </tr>
    <tr>
      <th>1</th>
      <td>August</td>
      <td>69.80</td>
    </tr>
    <tr>
      <th>2</th>
      <td>December</td>
      <td>33.50</td>
    </tr>
    <tr>
      <th>3</th>
      <td>February</td>
      <td>38.75</td>
    </tr>
    <tr>
      <th>4</th>
      <td>January</td>
      <td>34.35</td>
    </tr>
    <tr>
      <th>5</th>
      <td>July</td>
      <td>73.05</td>
    </tr>
    <tr>
      <th>6</th>
      <td>June</td>
      <td>68.50</td>
    </tr>
    <tr>
      <th>7</th>
      <td>March</td>
      <td>44.85</td>
    </tr>
    <tr>
      <th>8</th>
      <td>May</td>
      <td>54.90</td>
    </tr>
    <tr>
      <th>9</th>
      <td>November</td>
      <td>44.15</td>
    </tr>
    <tr>
      <th>10</th>
      <td>October</td>
      <td>55.75</td>
    </tr>
    <tr>
      <th>11</th>
      <td>September</td>
      <td>64.35</td>
    </tr>
  </tbody>
</table>
</div>





## Append More Data to Pandas Dataframe

You may also want to combine multiple `pandas dataframes` into one `pandas dataframe`, which is easily accomplished using `.append()`.

To combine dataframes, you first want to make sure that your dataframes are compatible. You want to make sure that the column and row structures match and that the values are in the same units, etc.

### Check Compatibility of Dataframes

Two easy ways to check compatibility are to review the output of `.info()` and `.head()` for each dataframe. 

For example, check `monthly_temp_2010_to_2013` and `monthly_temp_2014_to_2017` to see if you can combine them into one dataframe for 2010 to 2017.

{:.input}
```python
# print .info()
monthly_temp_2010_to_2013.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 48 entries, 0 to 47
    Data columns (total 6 columns):
    Month             48 non-null object
    Year              48 non-null int64
    Temp              48 non-null float64
    Season            48 non-null object
    Year_Avg          48 non-null float64
    Year_Avg_Label    48 non-null object
    dtypes: float64(2), int64(1), object(3)
    memory usage: 2.3+ KB



{:.input}
```python
# print .info()
monthly_temp_2014_to_2017.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 48 entries, 0 to 47
    Data columns (total 6 columns):
    Month             48 non-null object
    Year              48 non-null int64
    Temp              48 non-null float64
    Season            48 non-null object
    Year_Avg          48 non-null float64
    Year_Avg_Label    48 non-null object
    dtypes: float64(2), int64(1), object(3)
    memory usage: 2.3+ KB



{:.input}
```python
# print .head()
monthly_temp_2010_to_2013.head()
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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>2010</td>
      <td>0.555556</td>
      <td>Winter</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>2010</td>
      <td>-1.055556</td>
      <td>Winter</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>2010</td>
      <td>5.944444</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>2010</td>
      <td>9.333333</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>2010</td>
      <td>12.166667</td>
      <td>Spring</td>
      <td>51.575</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# print .head()
monthly_temp_2014_to_2017.head()
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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>2014</td>
      <td>34.6</td>
      <td>Winter</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>2014</td>
      <td>32.0</td>
      <td>Winter</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>2014</td>
      <td>43.6</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>2014</td>
      <td>49.8</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>2014</td>
      <td>56.6</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





Notice that while the row and column structures match, the units of `monthly_temp_2014_to_2017` have not yet been converted to Celsius. 

Run the the function `fah_to_cel` on the `Temp` column of `monthly_temp_2014_to_2017` to convert the units.

{:.input}
```python
# Replace values in `Temp` with the calculated values from the applied function `fah_to_cel`
monthly_temp_2014_to_2017["Temp"] = monthly_temp_2014_to_2017["Temp"].apply(fah_to_cel)

# print .head() to see updated values
monthly_temp_2014_to_2017.head()
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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>2014</td>
      <td>1.444444</td>
      <td>Winter</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>2014</td>
      <td>0.000000</td>
      <td>Winter</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>2014</td>
      <td>6.444444</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>2014</td>
      <td>9.888889</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>2014</td>
      <td>13.666667</td>
      <td>Spring</td>
      <td>51.2917</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





### Append Dataframe

Now, that the dataframes have compatible units, you can to append `monthly_temp_2014_to_2017` to the bottom of `monthly_temp_2010_to_2013`, so that the data is in order. 

To do this, use the following syntax: `combined_dataframe = dataframe_1.append(dataframe_2, ignore_index=True)`.

You are adding the parameter `ignore_index=True` to automatically assign the index of the new values to match the dataframe to which they are appended. 

In this example, the index of `monthly_temp_2010_to_2013` is the row index, starting at `0` and ending with `47`. Thus, each row appended from  `monthly_temp_2014_to_2017` will be assigned a new row index, starting at `48` to `95`. 

{:.input}
```python
# append monthly_temp_2014_to_2017 to the bottom of monthly_temp_2010_to_2013
monthly_temp_2010_to_2017 = monthly_temp_2010_to_2013.append(monthly_temp_2014_to_2017, ignore_index=True)

# print .info() to see new number of rows
monthly_temp_2010_to_2017.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 96 entries, 0 to 95
    Data columns (total 6 columns):
    Month             96 non-null object
    Year              96 non-null int64
    Temp              96 non-null float64
    Season            96 non-null object
    Year_Avg          96 non-null float64
    Year_Avg_Label    96 non-null object
    dtypes: float64(2), int64(1), object(3)
    memory usage: 4.6+ KB



The new combined dataframe now contains 96 entries (i.e. rows), as each input dataframe contained 48 entries.

Again, you can check that the original `monthly_temp_2010_to_2013` dataframe was not changed.

{:.input}
```python
# print .info() to see number of rows
monthly_temp_2010_to_2013.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 48 entries, 0 to 47
    Data columns (total 6 columns):
    Month             48 non-null object
    Year              48 non-null int64
    Temp              48 non-null float64
    Season            48 non-null object
    Year_Avg          48 non-null float64
    Year_Avg_Label    48 non-null object
    dtypes: float64(2), int64(1), object(3)
    memory usage: 2.3+ KB



You have now learned the basics of data wrangling with `pandas dataframes` to update, filter and group values in `pandas dataframes` and to combine multiple `pandas dataframes`.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Test your `Python` skills to:

1. Run the function `fah_to_cel` to recalculate the values in the column `Year_Avg` within `monthly_temp_2010_to_2017`. 

2. Print the first few rows of the dataframe using the `.head()` method.

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
      <th>Month</th>
      <th>Year</th>
      <th>Temp</th>
      <th>Season</th>
      <th>Year_Avg</th>
      <th>Year_Avg_Label</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>2010</td>
      <td>0.555556</td>
      <td>Winter</td>
      <td>10.875</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>2010</td>
      <td>-1.055556</td>
      <td>Winter</td>
      <td>10.875</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>2010</td>
      <td>5.944444</td>
      <td>Spring</td>
      <td>10.875</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>2010</td>
      <td>9.333333</td>
      <td>Spring</td>
      <td>10.875</td>
      <td>avg</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>2010</td>
      <td>12.166667</td>
      <td>Spring</td>
      <td>10.875</td>
      <td>avg</td>
    </tr>
  </tbody>
</table>
</div>





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

Test your `Python` skills to:

1. Group the values in `monthly_temp_2010_to_2017` by `Month` and calculate the **mean** of the tempertature values (`Temp`). Save to a new dataframe and print the new dataframe.

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
      <th>Temp</th>
    </tr>
    <tr>
      <th>Month</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>April</th>
      <td>9.555556</td>
    </tr>
    <tr>
      <th>August</th>
      <td>21.944444</td>
    </tr>
    <tr>
      <th>December</th>
      <td>0.972222</td>
    </tr>
    <tr>
      <th>February</th>
      <td>1.548611</td>
    </tr>
    <tr>
      <th>January</th>
      <td>1.347222</td>
    </tr>
    <tr>
      <th>July</th>
      <td>22.736111</td>
    </tr>
    <tr>
      <th>June</th>
      <td>20.576389</td>
    </tr>
    <tr>
      <th>March</th>
      <td>7.375000</td>
    </tr>
    <tr>
      <th>May</th>
      <td>13.076389</td>
    </tr>
    <tr>
      <th>November</th>
      <td>6.215278</td>
    </tr>
    <tr>
      <th>October</th>
      <td>11.965278</td>
    </tr>
    <tr>
      <th>September</th>
      <td>18.520833</td>
    </tr>
  </tbody>
</table>
</div>





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 3

Test your `Python` skills to:

1. Group the values in `monthly_temp_2010_to_2017` by `Year_Avg_Label` and calculate the **count** of the temperature values (`Temp`) (i.e. how many rows have each value of `Year_Avg_Label`). Save to a new dataframe.

2. Reset the index of the new dataframe, so that `Year_Avg_Label` returns to being a column. Save to a new dataframe and print the new dataframe.

3. What does this count actually mean?

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
      <th>Year_Avg_Label</th>
      <th>Temp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>avg</td>
      <td>48</td>
    </tr>
    <tr>
      <th>1</th>
      <td>warm</td>
      <td>48</td>
    </tr>
  </tbody>
</table>
</div>




