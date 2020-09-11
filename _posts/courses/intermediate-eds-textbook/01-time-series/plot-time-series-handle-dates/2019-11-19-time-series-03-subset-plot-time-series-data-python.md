---
layout: single
title: "Subset Time Series By Dates Python Using Pandas"
excerpt: "Sometimes you have data over a longer time span than you need for your analysis or plot. Learn how to subset your data using a begin and end date in Python."
authors: ['Leah Wasser', 'Jenny Palomino', 'Chris Holdgraf', 'Martha Morrissey']
dateCreated: 2019-11-19
modified: 2020-09-11
category: [courses]
class-lesson: ['time-series-python-tb']
course: 'intermediate-earth-data-science-textbook'
permalink: /courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/subset-time-series-data-python/
nav-title: 'Subset Time Series Data in Python'
week: 1
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
redirect_from:
  - "/courses/earth-analytics-python/use-time-series-data-in-python/subset-time-series-data-python/"
  - "/courses/use-data-open-source-python/use-time-series-data-in-python/subset-time-series-data-python/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Subset time series data using different options for time frames, including by year, month, and with a specified begin and end date. 

</div>


## Temporally Subset Data Using Pandas Dataframes

Sometimes a dataset contains a much larger timeframe than you need for your analysis or plot, and it can helpful to select, or subset, the data to the needed timeframe. 

There are many ways to subset the data temporally in **Python**; one easy way to do this is to use **pandas**.

**Pandas** natively understands time operations if:
1. you tell it what column contains your time stamps (using the parameter `parse_dates`) and 
2. you set the date column to be the index of the dataframe (using the parameter `index_col`).

On the previous page of this chapter, you already learned how to complete these steps during the `read_csv()` import into the **pandas** dataframe. On this page, you will learn how to use the `datetime` index to subset data from a **pandas dataframe**. 

### Import Packages and Get Data

You will use a slightly modified version of precipitation data (inches) downloaded from the <a href="https://www.ncdc.noaa.gov/cdo-web/search" target ="_blank">National Centers for Environmental Information (formerly National Climate Data Center) Cooperative Observer Network (COOP)</a> station 050843 in Boulder, CO. The data were collected from January 1, 2003 through December 31, 2013.

Your instructor has modified these data as follows:
* aggregated the data to represent daily sum values.
* added some no data values to allow you to practice handling missing data.
* added new columns to this data that would not usually be there if you downloaded it directly:
    * Year
    * Julian day (i.e. the calendar day number)

To begin, import the necessary packages to work with **pandas** dataframe and download data. 

You will continue to work with modules from **pandas** and **matplotlib** to plot dates more efficiently and with <a href="https://seaborn.pydata.org/introduction.html" target="_blank">**seaborn**</a> to make more attractive plots.  

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import earthpy as et

# Handle date time conversions between pandas and matplotlib
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()

# Use white grid plot background from seaborn
sns.set(font_scale=1.5, style="whitegrid")
```

### Download Curated Dataset From EarthPy

You will also download data from **earthpy** by specifiying a data key for the dataset called `colorado-flood`. <a href="https://earthpy.readthedocs.io/en/latest/earthpy-data-subsets.html#colorado-flood" target="_blank">This dataset</a> has been curated by the **earthpy** team to include the precipitation data collected for 2003-2013 for Boulder, CO.  

{:.input}
```python
# Download the data
data = et.data.get_data('colorado-flood')
```

Note that when you download data using a data key in **earthpy**, the data are automatically downloaded to a new directory in the `data` directory under `earth-analytics`.  The name of the directory will be the same as the name of the dataset, for example, `colorado-flood`. 

For this dataset, there is a `precipitation` subdirectory within `colorado-flood` for the precipitation data.  

{:.input}
```python
# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# Define relative path to file with daily precip total
file_path = os.path.join("data", "colorado-flood",
                         "precipitation",
                         "805325-precip-dailysum-2003-2013.csv")
```

Now that you have downloaded the dataset, you can import the file for the measurement station for Boulder, CO, and specify the:
1. no data values using the parameter `na_values`
2. date column using the parameter `parse_dates`
3. datetime index using the parameter `index_col`

{:.input}
```python
# Import data using datetime and no data value
boulder_precip_2003_2013 = pd.read_csv(file_path,
                                       parse_dates=['DATE'],
                                       index_col= ['DATE'],
                                       na_values=['999.99'])

# View first few rows
boulder_precip_2003_2013.head()
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>2003-01-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2003-01-05</th>
      <td>NaN</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>5</td>
    </tr>
    <tr>
      <th>2003-02-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>32</td>
    </tr>
    <tr>
      <th>2003-02-02</th>
      <td>NaN</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>33</td>
    </tr>
    <tr>
      <th>2003-02-03</th>
      <td>0.4</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>34</td>
    </tr>
  </tbody>
</table>
</div>







### About the Precipitation Data

Viewing the structure of these data, you can see that different types of data are included in
this file.

* **STATION** and **STATION_NAME**: Identification of the COOP station.
* **ELEVATION, LATITUDE** and **LONGITUDE**: The spatial location of the station.
* **DAILY_PRECIP**: The total precipitation in inches. The metadata for this dataset notes that the value `999.99` indicates missing data. Also important, days with no precipitation are not included in the data.
* **YEAR**: the year the data were collected
* **JULIAN**: the JULIAN DAY the data were collected.

`DATE` is the date when the data were collected in the format: YYYY-MM-DD. 

Notice that `DATE` is now the index value because you used the `parse_date` and `index_col` parameters when you imported the CSV file into a **pandas** dataframe. 

Additional information about the data, known as metadata, is available in the
<a href="https://ndownloader.figshare.com/files/7283453">PRECIP_HLY_documentation.pdf</a>.

The metadata tell us that the no data value for these data is 999.99. IMPORTANT:
your instructor has modified these data a bit for ease of teaching and learning. Specifically,
data have been aggregated to represent daily sum values and some no data values have been added.

<i class="fa fa-star"></i> **Data Tip** You can download the original complete data subset with additional documentation
<a href="https://figshare.com/articles/NEON_Remote_Sensing_Boulder_Flood_2013_Teaching_Data_Subset_Lee_Hill_Road/3146284">here. </a>
{: .notice--success }

Even after reading documentation, it is always a good idea to explore data before working with them such as:
1. checking out the data types
2. calculating the summary statistics to get a sense of the data values (and make sure that "no data" values have been identified)
3. checking out the values in the `datetime` index. 

{:.input}
```python
# View dataframe info
boulder_precip_2003_2013.info()
```

{:.output}
    <class 'pandas.core.frame.DataFrame'>
    DatetimeIndex: 792 entries, 2003-01-01 to 2013-12-31
    Data columns (total 8 columns):
     #   Column        Non-Null Count  Dtype  
    ---  ------        --------------  -----  
     0   DAILY_PRECIP  788 non-null    float64
     1   STATION       792 non-null    object 
     2   STATION_NAME  792 non-null    object 
     3   ELEVATION     792 non-null    float64
     4   LATITUDE      792 non-null    float64
     5   LONGITUDE     792 non-null    float64
     6   YEAR          792 non-null    int64  
     7   JULIAN        792 non-null    int64  
    dtypes: float64(4), int64(2), object(2)
    memory usage: 55.7+ KB



{:.input}
```python
# View summary statistics
boulder_precip_2003_2013.describe()
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
      <th>DAILY_PRECIP</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>788.000000</td>
      <td>792.0</td>
      <td>792.000000</td>
      <td>792.000000</td>
      <td>792.000000</td>
      <td>792.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.247843</td>
      <td>1650.5</td>
      <td>40.033850</td>
      <td>-105.281106</td>
      <td>2007.967172</td>
      <td>175.541667</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.462558</td>
      <td>0.0</td>
      <td>0.000045</td>
      <td>0.000005</td>
      <td>3.149287</td>
      <td>98.536373</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
      <td>1650.5</td>
      <td>40.033800</td>
      <td>-105.281110</td>
      <td>2003.000000</td>
      <td>1.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.100000</td>
      <td>1650.5</td>
      <td>40.033800</td>
      <td>-105.281110</td>
      <td>2005.000000</td>
      <td>96.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>0.100000</td>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281110</td>
      <td>2008.000000</td>
      <td>167.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>0.300000</td>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281100</td>
      <td>2011.000000</td>
      <td>255.250000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>9.800000</td>
      <td>1650.5</td>
      <td>40.033890</td>
      <td>-105.281100</td>
      <td>2013.000000</td>
      <td>365.000000</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# View index values of dataframe
boulder_precip_2003_2013.index
```

{:.output}
{:.execute_result}



    DatetimeIndex(['2003-01-01', '2003-01-05', '2003-02-01', '2003-02-02',
                   '2003-02-03', '2003-02-05', '2003-02-06', '2003-02-07',
                   '2003-02-10', '2003-02-18',
                   ...
                   '2013-11-01', '2013-11-09', '2013-11-21', '2013-11-27',
                   '2013-12-01', '2013-12-04', '2013-12-22', '2013-12-23',
                   '2013-12-29', '2013-12-31'],
                  dtype='datetime64[ns]', name='DATE', length=792, freq=None)





## Subset Pandas Dataframe By Year

Because you have a dataframe set up with an index, you can start to easily subset your data using the syntax:

`df["index_date"]`

Note that the `datetime` index value is accessed using quotation marks `""` similar to how you query for text strings. 

Using this syntax, you can select all of the data for the year 2013 by specifying the value that you want to select from the `datetime` index:

{:.input}
```python
# Select 2013 data - view first few records
boulder_precip_2003_2013['2013'].head()
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>2013-01-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2013-01-28</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>28</td>
    </tr>
    <tr>
      <th>2013-01-29</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>29</td>
    </tr>
    <tr>
      <th>2013-02-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>32</td>
    </tr>
    <tr>
      <th>2013-02-14</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>45</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Select 2013 data - view last few records
boulder_precip_2003_2013['2013'].tail()
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>2013-12-04</th>
      <td>0.4</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>338</td>
    </tr>
    <tr>
      <th>2013-12-22</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>356</td>
    </tr>
    <tr>
      <th>2013-12-23</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>357</td>
    </tr>
    <tr>
      <th>2013-12-29</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>363</td>
    </tr>
    <tr>
      <th>2013-12-31</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>365</td>
    </tr>
  </tbody>
</table>
</div>





Note that in the previous example, you are querying the `datetime` index directly, not querying the values from the `Year` column.


## Subset Pandas Dataframe By Month

Using a `datetime` index with **pandas** makes it really easy to continue to select data using additional attributes of the index such as `month`.

This attribute of the `datetime` index can be accessed as:

`df.index.month == value`

where the month values are numeric values ranging from 1 to 12, representing January through December.

With this attribute, you can now employ the **pandas** syntax to <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/indexing-filtering-data-pandas-dataframes/#filter-data-using-specific-values">filter values in a pandas dataframe</a> using the syntax:

`df[df.index.month == value]`

{:.input}
```python
# Select all December data - view first few rows
boulder_precip_2003_2013[boulder_precip_2003_2013.index.month == 12].head()
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>2003-12-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>335</td>
    </tr>
    <tr>
      <th>2004-12-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2004</td>
      <td>336</td>
    </tr>
    <tr>
      <th>2004-12-22</th>
      <td>0.2</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2004</td>
      <td>357</td>
    </tr>
    <tr>
      <th>2004-12-24</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2004</td>
      <td>359</td>
    </tr>
    <tr>
      <th>2005-12-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>335</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Select all December data - view last few rows
boulder_precip_2003_2013[boulder_precip_2003_2013.index.month == 12].tail()
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>2013-12-04</th>
      <td>0.4</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>338</td>
    </tr>
    <tr>
      <th>2013-12-22</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>356</td>
    </tr>
    <tr>
      <th>2013-12-23</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>357</td>
    </tr>
    <tr>
      <th>2013-12-29</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>363</td>
    </tr>
    <tr>
      <th>2013-12-31</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.0338</td>
      <td>-105.2811</td>
      <td>2013</td>
      <td>365</td>
    </tr>
  </tbody>
</table>
</div>





Notice that `head()` displays December records in 2003, while `tail()` displays December records in 2013. 

## Subset Pandas Dataframe By Day of Month

Similarly, you can the attribute `day` of the index to select all records for a specific day of the month as follows: 

`df.index.month == value`

where the month values are numeric values ranging from 1 to 31, representing possible days of the month.

{:.input}
```python
# Select data for 1st of month - view first rows
boulder_precip_2003_2013[boulder_precip_2003_2013.index.day == 1]
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>2003-01-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2003-02-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>32</td>
    </tr>
    <tr>
      <th>2003-03-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>60</td>
    </tr>
    <tr>
      <th>2003-04-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>91</td>
    </tr>
    <tr>
      <th>2003-05-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2003</td>
      <td>121</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>2013-08-01</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03380</td>
      <td>-105.28110</td>
      <td>2013</td>
      <td>213</td>
    </tr>
    <tr>
      <th>2013-09-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03380</td>
      <td>-105.28110</td>
      <td>2013</td>
      <td>244</td>
    </tr>
    <tr>
      <th>2013-10-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03380</td>
      <td>-105.28110</td>
      <td>2013</td>
      <td>274</td>
    </tr>
    <tr>
      <th>2013-11-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03380</td>
      <td>-105.28110</td>
      <td>2013</td>
      <td>305</td>
    </tr>
    <tr>
      <th>2013-12-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03380</td>
      <td>-105.28110</td>
      <td>2013</td>
      <td>335</td>
    </tr>
  </tbody>
</table>
<p>132 rows × 8 columns</p>
</div>





## Subset Pandas Dataframe Using Range of Dates

You can also subset the data using a specific date range using the syntax:

`df["begin_index_date" : "end_index_date]`

For example, you can subset the data to a desired time period such as May 1, 2005 - August 31 2005, and then save it to a new dataframe. 

{:.input}
```python
# Subset data to May-Aug 2005
precip_may_aug_2005 = boulder_precip_2003_2013['2005-05-01':'2005-08-31']

precip_may_aug_2005.head()
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
      <th>DAILY_PRECIP</th>
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>YEAR</th>
      <th>JULIAN</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>2005-05-01</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>121</td>
    </tr>
    <tr>
      <th>2005-05-11</th>
      <td>1.2</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>131</td>
    </tr>
    <tr>
      <th>2005-05-30</th>
      <td>0.5</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>150</td>
    </tr>
    <tr>
      <th>2005-05-31</th>
      <td>0.1</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>151</td>
    </tr>
    <tr>
      <th>2005-06-01</th>
      <td>0.0</td>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>1650.5</td>
      <td>40.03389</td>
      <td>-105.28111</td>
      <td>2005</td>
      <td>152</td>
    </tr>
  </tbody>
</table>
</div>





### Check Minimum and Maximum Values of Index

Rather than just checking the results of `head()` and `tail()`, you can actually query the `min` and `max` values of the index as follows:

{:.input}
```python
# Check min value of index 
print(precip_may_aug_2005.index.min())

# Check max value of index 
print(precip_may_aug_2005.index.max())
```

{:.output}
    2005-05-01 00:00:00
    2005-08-23 00:00:00



## Plot Temporal Subsets From Pandas Dataframe

Once you have subsetted the data and saved it, you can plot the data from the new dataframe to focus in on the desired time period. 

Once again, you will use `.index.values` to access the `datetime` index values for the plot. 


{:.input}
```python
# Create figure and plot space
fig, ax = plt.subplots(figsize=(10, 10))

# Add x-axis and y-axis
ax.bar(precip_may_aug_2005.index.values,
       precip_may_aug_2005['DAILY_PRECIP'],
       color='purple')

# Set title and labels for axes
ax.set(xlabel="Date",
       ylabel="Precipitation (inches)",
       title="Daily Total Precipitation\nMay - Aug 2005 for Boulder Creek")

# Rotate tick marks on x-axis
plt.setp(ax.get_xticklabels(), rotation=45)

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-eds-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-03-subset-plot-time-series-data-python/2019-11-19-time-series-03-subset-plot-time-series-data-python_31_0.png" alt = "Bar plot showing daily total precipitation for Boulder Creek between May and Aug 2005.">
<figcaption>Bar plot showing daily total precipitation for Boulder Creek between May and Aug 2005.</figcaption>

</figure>




### Think of New Applications and Uses of Subsetting

Given what you have learned about using `df.index.month` and `df.index.day` to select data by the month or day of the month value:
* What would you replace `month` or `day` with, in order to select data by year or even a specific week of the year?
