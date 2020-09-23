---
layout: single
title: 'Use Tabular Data for Earth Data Science'
excerpt: "Tabular data is common in all analytical work, most commonly seen as .txt and .csv files. Learn to work with tabular data for earth data science in this lesson."
authors: ['Leah Wasser', 'Nathan Korinek']
category: [courses]
class-lesson: ['text-file-formats']
permalink: /courses/intro-to-earth-data-science/file-formats/use-text-files/use-tabular-data/
nav-title: "Use Tabular Data"
dateCreated: 2020-06-20
modified: 2020-09-23
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  file-formats: ['csv']
---

{% include toc title="On This Page" icon="file-text" %}

<div class="notice--success alert alert-info" markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

At the end of this activity, you will be able to:

* Define the structure of tabular data.
* Describe the difference between the two common types of tabular text file formats: `txt` and `csv` files.
* Be able to list some commonly used scientific data types that often are downloaded in a tabular format. 

</div>


## What is Tabular Data?

Tabular data are data that are stored in a row / column format. Columns (and 
sometimes rows) are often identified by headers, which if named correctly, explain
what is in that row or column. You may already be 
familiar with spreadsheet tools such as Excel and Google Sheets that can be 
used to open tabular data. 


## Tabular Data Structure
In the example below, you see a table of values 
that represent precipitation for 3 days. The headers in the data include 

* `day` and
* `precipitation-mm`


| day   | precipitation-mm    |  
|:----------|:-------------|
| monday | 0 | 
| tuesday | 1   | 
| wednesday | 5 | 

The tabular data above contains 4 rows - the first of which (row 1) is a header row and subsequent rows contain data. The table also has 2 columns. 


## Common Tabular Data File Types: .csv and .txt

Tabular data can be downloaded in many different file formats. Spreadsheet formats 
include `.xls` and `xlsx` which can be directly opened in Microsoft 
Excel. When you are downloading Earth and Environmental data, you will often 
see tablular data stored in file formats including: 

* `.csv`: Comma Separated Values - This file has each column separated (delimited) by a comma. 
* `.txt`: A basic text file. In a `txt` file, often the delimiter (the thing that separates out each column) can vary. Delimiters are discussed below in more detail. 

These formats are text based and often can be opened in a text editor like Atom or Notepad. 
They can be then imported into **Python** using **Pandas** for further exploration 
and processing. 


<div class="notice--success alert alert-info" markdown="1">

<i class="fa fa-star"></i> **Data Tip:** The challenge with graphical user 
interface (GUI) based tools like Excel
is that they often have limitations when it comes to working with larger files. 
Further, it becomes difficult to recreate workflows implemented in Excel because
you are often pressing buttons rather than scripting workflows. You can use 
Open Source Python to implement any workflow you might implement in Excel 
and that workflow can become fully sharable and reproducible! 
</div>

## Text Files & Delimiters

A delimiter refers to the character that defines the boundary for different sets of information. 
In a text file, the delimiter defines the boundary between columns. A line break (a return) defines 
each row. 

Below you will find an example of a comma delimited text file. In the example below, each column of data 
is separated by a comma `,`. The data also include a header row which is also separated by commas.

```
site_code, year, month, day, hour, minute, second, time_decimal, value, value_std_dev  
BRW,1973,1,1,0,0,0,1973.0,-999.99,-99.99
BRW,1973,2,1,0,0,0,1973.0849315068492,-999.99,-99.99 
BRW,1973,3,1,0,0,0,1973.1616438356164,-999.99,-99.99 
```

Here is an example of a space delimited text file. In the example below, each column of data 
are separated by a single space. 

```
site_code year month day hour minute second time_decimal value value_std_dev  
BRW 1973 1 1 0 0 0 1973.0 -999.99 -99.99
BRW 1973 2 1 0 0 0 1973.0849315068492 -999.99 -99.99 
BRW 1973 3 1 0 0 0 1973.1616438356164 -999.99 -99.99 
```

There are many different types of delimiters including:

* tabs
* commas
* 1 (or more) spaces

Sometimes you will find other characters used as delimiters but the above-listed options are the most common. 

<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** The `.csv` file format is most often delimited by a comma. Hence the name: 
</div>



## Earth and Environmental Data That Are Stored In Text File Format

There are many different types of data that are stored in text and tabular file formats.
Below you will see a few different examples of data that are provided in this format. You
will also explore some of the cleanup steps that you need to import and begin to work with 
the data. 


<div class="notice--success alert alert-info" markdown="1">

<i class="fa fa-star"></i> **Data Tip:** Not all text files store tabular text (character) based data. The `.asc` file format is a text based format that stores spatial raster data.  
</div>



{:.input}
```python
# Import packages
import os

import matplotlib.pyplot as plt
import pandas as pd
```

If you have a url that links directly to a file online, you can 
open it using pandas `.read_csv()`. Have a look at the data below - 
and notice that is has:

* 3 columns: months, precip and seasons
* 12 rows: notice that the first row is numered as `0`. This is because indexing 
in Python always starts at 0 rather than 1. 


<div class="notice--success alert alert-info" markdown="1">

<i class="fa fa-star"></i> **Data Tip:** You can learn more about zero-based indexing in the <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/python-code-fundamentals/get-started-using-python/lists/#list-index-in-python" target = "_link" >chapter on lists in this textbook </a>  

</div>


{:.input}
```python
# Download and open the .csv file using Pandas
avg_monthly_precip = pd.read_csv(
    "https://ndownloader.figshare.com/files/12710618")

# View the data that you just downloaded and opened
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





In **Pandas**, this table format is referred to as a `dataframe`. 
You can view some stats about the `dataframe` including the number of columns 
and rows in the data using `.info()`.

{:.input}
```python
avg_monthly_precip.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 12 entries, 0 to 11
    Data columns (total 3 columns):
     #   Column   Non-Null Count  Dtype  
    ---  ------   --------------  -----  
     0   months   12 non-null     object 
     1   precip   12 non-null     float64
     2   seasons  12 non-null     object 
    dtypes: float64(1), object(2)
    memory usage: 416.0+ bytes



Finally, you can easily plot the data using `.plot()`.

{:.input}
```python
# Plot the data
f, ax = plt.subplots()
avg_monthly_precip.plot(x="months",
                        y="precip",
                        title="Precipitation (mm) for One Year",
                        ax=ax)
ax.set(xlabel='Month',
       ylabel='Precipitation (mm)')
plt.show()
```

{:.output}
    /opt/conda/lib/python3.8/site-packages/pandas/plotting/_matplotlib/core.py:1235: UserWarning: FixedFormatter should only be used together with FixedLocator
      ax.set_xticklabels(xticklabels)



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/04-text-file-formats-eds/2019-08-29-text-file-formats-03-tabular-data/2019-08-29-text-file-formats-03-tabular-data_9_1.png" alt = "Line plot of precipitation (mm) for one year.">
<figcaption>Line plot of precipitation (mm) for one year.</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">


## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1

* Use Python to determine the `type` of data stored in `avg_monthly_precip`

HINT: you learned how to determine the type of an object in the variables lessons last week. 

</div>



{:.output}
{:.execute_result}



    pandas.core.frame.DataFrame





<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2

In most programming languages, you can customize the options for how a function 
runs by using parameters. Examples of parameters in the plot above include: 

* `x="months"` - tell python which data to place on the x-axis
* `y="precip"` - tell python which data to place on the y-axis

Above you created a line plot. You can use the `kind=""` parameter to 
modify the type of plot that pandas created. You can use the `color=""` 
parameter to specify a color that you wish to use for each bar in the plot. 

Do the following:

1. copy the code below.
2. Add `kind="bar"` to the `.plot()` method. 
3. Specify the color of each bar using the `color=""` parameter. 

Run your code and see what the final plot looks like. You can select 
any color that you wish to complete your plot. 

Use this link to find a list of colors (open it in a new browser tab!) https://het.as.utexas.edu/HET/Software/Matplotlib/api/colors_api.html


```python
f, ax = plt.subplots()
avg_monthly_precip.plot(x="months",
                        y="precip",
                        title="Precipitation (mm) for One Year",
                        ax=ax)
ax.set(xlabel='Month',
       ylabel='Precipitation (mm)')
plt.show()
```

The plot below is an example of what your final plot should look like. 
</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/04-text-file-formats-eds/2019-08-29-text-file-formats-03-tabular-data/2019-08-29-text-file-formats-03-tabular-data_13_0.png" alt = "Bar plot of precipitation (mm) for one year.">
<figcaption>Bar plot of precipitation (mm) for one year.</figcaption>

</figure>




## Cleaning Tabular Text Files So You Can Open Them in Python

### Missing Data Values & Headers in Text Files

Not all text files are as simple as the example above. Many text files have 
several lines of header text above the data that provide you with useful information
about the data itself. This data is referred to as metadata. 

Also, often times, there are data missing from the data that were collected. 
These missing values will be identified using a specific value that is hopefully
documented in the metadata for that file. 

Next you will explore some temperature data that need to be cleaned up. 


<div class="notice--success alert alert-info" markdown="1">

<i class="fa fa-star"></i> **Data Tip:** You can visit <a href="https://www.ncdc.noaa.gov/cag/city/time-series/" target = "_link" >the NOAA NCDC website to learn more about the data you are 
using below.</a>  
    
* Miami, Florida CSV: https://www.ncdc.noaa.gov/cag/city/time-series/USW00012839-tmax-12-12-1895-2020.csv 
* Seattle, Washington CSV: https://www.ncdc.noaa.gov/cag/city/time-series/USW00013895-tmax-1-5-1895-2020.csv 

</div>

{:.input}
```python
# Open temperature data for Miami, Florida
miami_temp_url = "https://www.ncdc.noaa.gov/cag/city/time-series/USW00012839-tmax-12-12-1895-2020.csv"

miami_temp = pd.read_csv(miami_temp_url)
miami_temp
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
      <th>Miami</th>
      <th>Florida</th>
      <th>Maximum Temperature</th>
      <th>January-December</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Units: Degrees Fahrenheit</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Missing: -99</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Date</td>
      <td>Value</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>194812</td>
      <td>83.7</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>194912</td>
      <td>83.1</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>70</th>
      <td>201512</td>
      <td>85.6</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>71</th>
      <td>201612</td>
      <td>84.6</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>72</th>
      <td>201712</td>
      <td>85.9</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>73</th>
      <td>201812</td>
      <td>85.1</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>74</th>
      <td>201912</td>
      <td>85.5</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
<p>75 rows × 4 columns</p>
</div>





Notice that the data above contain a few extra rows of information. This 
information however is important for you to understand. 

* `Missing: -99` -- this is the value that represents the "no data" value. Misisng data might occur if a sensor stops working or a measurement isn't recorded. You will want to remove any missing data values.
* `Units: Degrees Fahrenheit` -- it's always important to first understand the units of the data before you try to interpret what the data are showing!  

Below you will use all of the information stored in the header to import your data.
You will also remove the first few rows of data because they don't actually contain any
data values. These rows contain metadata. 

### Function Parameters in Python

A parameter refers to an option that you can specify when running a function 
in **Python**. You can adjust the parameters associated with importing your data 
in the same way that you adjusted the plot type and colors above. 

Below you use: 

* `skiprows=`: to tell **Python** to skip the first 3 rows of your data
* `na_values=`: to tell **Python** to reassign any missing data values to "NA" 

NA refers to missing data. When you specify a value as NA (NaN or Not a Number 
in **Python**), it will not be included in plots or any mathematical operations.

<div class='notice--success' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** You can learn more about no data values 
in Pandas in the <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/" target = "_blank" >intermediate earth data science textbook</a>  
    
</div>


{:.input}
```python
# Open the Miami data skipping the first 3 rows and setting no data values
miami_temp = pd.read_csv(miami_temp_url,
                         skiprows=3,
                         na_values=-99)

# View the first 5 rows of the data
miami_temp.head()
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
      <th>Date</th>
      <th>Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>194812</td>
      <td>83.7</td>
    </tr>
    <tr>
      <th>1</th>
      <td>194912</td>
      <td>83.1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>195012</td>
      <td>82.3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>195112</td>
      <td>82.7</td>
    </tr>
    <tr>
      <th>4</th>
      <td>195212</td>
      <td>83.4</td>
    </tr>
  </tbody>
</table>
</div>





<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 3

Now that you have imported temperature data for Miami, plot the 
data using the code example above!! In your plot code, set `Date` as your 
`x-axis` value and `Value` column as your `y-axis` value.

The plot below is an example of what your final plot should look like. 
</div>


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/04-text-file-formats-eds/2019-08-29-text-file-formats-03-tabular-data/2019-08-29-text-file-formats-03-tabular-data_19_0.png" alt = "Line plot of temperature (F) for Miami, Florida.">
<figcaption>Line plot of temperature (F) for Miami, Florida.</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 4

Use the link below to open and plot temperature data for Seattle, Washington. 

<a href="https://www.ncdc.noaa.gov/cag/city/time-series/USW00013895-tmax-1-5-1895-2020.csv" target="_blank">https://www.ncdc.noaa.gov/cag/city/time-series/USW00013895-tmax-1-5-1895-2020.csv</a>

</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/04-text-file-formats-eds/2019-08-29-text-file-formats-03-tabular-data/2019-08-29-text-file-formats-03-tabular-data_21_0.png" alt = "Line plot of temperature (F) for Montgomery, Alabama.">
<figcaption>Line plot of temperature (F) for Montgomery, Alabama.</figcaption>

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 5 -- OPTIONAL

Copy the code below into your code. Run the code. 
It should download and open a new dataset that has CO2 emissions for a field site
in Barrow, Alaska (brw). 

The code below will download your data into your working directory. You should 
be able to open it using the filename `co2-emissions-barrow.csv`.

```python
# Download greenhouse gas CO2 data
import urllib.request

greenhouse_gas_url = "ftp://aftp.cmdl.noaa.gov/data/trace_gases/co2/in-situ/surface/brw/co2_brw_surface-insitu_1_ccgg_MonthlyData.txt"

urllib.request.urlretrieve(url=greenhouse_gas_url,
                           filename="co2-emissions-barrow.csv")

```

Once you have downloaded the data
1. Read the data in using pandas `read_csv()`
2. The data has some additional rows of information stored as metadata. You will
need to use the `skiprows=` parameter to skip those metadata rows and properly 
import the data. HINT: remember when you use `skiprows` to consider 0-based indexing.
3. Finally plot the data using pandas. plot the `"time_decimal"` column on the 
x-axis and `"value"` on the y-axis.

</div>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-eds-textbook/02-file-formats-eds/04-text-file-formats-eds/2019-08-29-text-file-formats-03-tabular-data/2019-08-29-text-file-formats-03-tabular-data_24_0.png" alt = "Line plot of temperature (F) for Barrow, Alaska.">
<figcaption>Line plot of temperature (F) for Barrow, Alaska.</figcaption>

</figure>




<div class="notice--info alert alert-info" markdown="1">

## Additional Resources

* <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/" target = "_link" >Chapter on Pandas in the Intro to Earth Data Science textbook </a> 
* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/" target = "_link" >Chapter on Time Series with Pandas </a>  
* <a href="https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/#work-with-no-data-values-in-pandas-dataframe" target = "_link" > Textbook Section on Dealing with No Data Values in Pandas </a> 
</div>

