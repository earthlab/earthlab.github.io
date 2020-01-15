---
layout: single
title: "Why A Hundred Year Flood Can Occur Every Year. Calculate Exceedance Probability and Return Periods in Python"
excerpt: "Learn how to calculate exceedance probability and return periods associated with a flood in Python."
authors: ['Matt Rossi', 'Leah Wasser']
modified: 2018-10-08
category: [courses]
class-lesson: ['time-series-python']
course: 'earth-analytics-python'
week: 3
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/floods-return-period-and-probability/
nav-title: 'Return Period'
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
---

## Introduction to Flood Frequency Analysis

One way to analyze time series data - particularly related to events like floods - is to calculate the frequency of likelyhood that a particular event will occur. You have have heard the term *"100 year flood"*. This term is misleading because while you may think it means that a particular size of flood will occur every 100 years. It actually means that every year, that size of a flood event has a 1/100 change or 1% change of occuring. 

This is why a hundred year flood event could, by chance, occur in the same place, two years in a row.

In this lesson you will learn how the "100 year" (and other frequencies) flood is calculated using some basic statistics. To begin, let's define two terms:

1. **Exceedance probability:** the probability of a given magnitude event or greater to occur
	There is a 1% chance (P=0.01) that the maximum annual flood will exceed 100 m3/s at this site.
2. **Return period:** the inverse of the exceedance probability expressed in units of time
	The 100-yr flood is 100 m3/s at this site.
    
### Important Caveats to Consider

* The above definitions assume that events in the time series are independent (i.e., that event magnitudes are not correlated with each other in time) and that the process is stationary (i.e., the distribution of events is not changing through time).

> How valid do you think these assumptions are for maximum annual floods?

* Even though the phrase ‘return period’ evokes the idea of regularity in the time between events, this is an important misconception. The 100-year flood is just as likely to occur after a year that already experienced a 100-yr flood as any other year.

> Are the processes that drive floods periodic? Over what timescales?


The content below comes from <a href="https://water.usgs.gov/edu/100yearflood.html" target= "_blank">this USGS waterscience page</a>. It provides an excellent overview of recurrence intervals and return periods.

****

## What is a Recurrence Interval?

> *100-year floods can happen 2 years in a row*

Statistical techniques, through a process called frequency analysis, are used to estimate the probability of the occurrence of a given precipitation event. The recurrence interval is based on the probability that the given event will be equalled or exceeded in any given year. For example, assume there is a 1 in 50 chance that 6.60 inches of rain will fall in a certain area in a 24-hour period during any given year. Thus, a rainfall total of 6.60 inches in a consecutive 24-hour period is said to have a 50-year recurrence interval. Likewise, using a frequency analysis (Interagency Advisory Committee on Water Data, 1982) there is a 1 in 100 chance that a streamflow of 15,000 cubic feet per second (ft3/s) will occur during any year at a certain streamflow-measurement site. Thus, a peak flow of 15,000 ft3/s at the site is said to have a 100-year recurrence interval. Rainfall recurrence intervals are based on both the magnitude and the duration of a rainfall event, whereas streamflow recurrence intervals are based solely on the magnitude of the annual peak flow.

Ten or more years of data are required to perform a frequency analysis for the determination of recurrence intervals. Of course, the more years of historical data the better—a hydrologist will have more confidence on an analysis of a river with 30 years of record than one based on 10 years of record.

Recurrence intervals for the annual peak streamflow at a given location change if there are significant changes in the flow patterns at that location, possibly caused by an impoundment or diversion of flow. The effects of development (conversion of land from forested or agricultural uses to commercial, residential, or industrial uses) on peak flows is generally much greater for low-recurrence interval floods than for high-recurrence interval floods, such as 25- 50- or 100-year floods. During these larger floods, the soil is saturated and does not have the capacity to absorb additional rainfall. Under these conditions, essentially all of the rain that falls, whether on paved surfaces or on saturated soil, runs off and becomes streamflow.

## How Can We Have two "100-year floods" in less than two years?

This question points out the importance of proper terminology. The term "100-year flood" is used in an attempt to simplify the definition of a flood that statistically has a 1-percent chance of occurring in any given year. Likewise, the term "100-year storm" is used to define a rainfall event that statistically has this same 1-percent chance of occurring. In other words, over the course of 1 million years, these events would be expected to occur 10,000 times. But, just because it rained 10 inches in one day last year doesn't mean it can't rain 10 inches in one day again this year.

Recurrence intervals and probabilities of occurrences Recurrence interval, in years	Probability of occurrence in any given year	Percent chance of occurrence in any given year

|Recurrance interval, in years | Probability of occurrence in any given year| Percent change of occurrence in any given year | 
|100|	1 in 100 |	1 |
|50	|1 in 50	|2|
|25|	1 in 25|	4|
|10|	1 in 10|	10|
|5|	1 in 5	|20|
|==
|2|	1 in 2|	50|

## What is an Annual Exceedance Probability?

The USGS and other agencies often refer to the percent chance of occurrence as an Annual Exceedance Probability or AEP. An AEP is always a fraction of one. So a 0.2 AEP flood has a 20% chance of occurring in any given year, and this corresponds to a 5-year recurrence-interval flood. Recurrence-interval terminology tends to be more understandable for flood intensity comparisons. However, AEP terminology reminds the observer that a rare flood does not reduce the chances of another rare flood within a short time period.

****
## Calculate Probability in Python
In this lesson you will use stream flow data to explore the probability of a particular magnitude or amount of discharge occuring in any given year. To do this you will need atleast 10 years of data. 

You will use the `hydrofunctions` python package to access streamflow data via an API from the USGS NWIS website. 

To begin, load all of your libraries.

{:.input}
```python
import hydrofunctions as hf
import urllib
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
import math
plt.ion()
# set standard plot parameters for uniform plotting
plt.rcParams['figure.figsize'] = (11, 6)
# prettier plotting with seaborn
import seaborn as sns; 
sns.set(font_scale=1.5)
sns.set_style("whitegrid")
# set working dir and import earthpy
import earthpy as et
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

## Find A Station of Interest

The `hf.draw_map()` function allows you to explore the station visually in a particular area. Explore the map below. Notice the gage locations in the Boulder, Colorado area. 

For the purposes of this lesson, you will use gage `dv06730500` This gage is one of the few that was left standing during the 2013 flood event in Colorado. It also has a very nice time series of data that spans over 60 years. 

The map below also allows you to explore hydrographs for several stream gages at once if you click on the buttons at the very bottom center of the map. 

```python
# create map of stations
hf.draw_map()
```

<iframe src="http://hydrocloud.org/" width="700" height="400"></iframe>


You can get a list of all stations located in Colorado using the `hf.NWIS().get_data()` method. 

{:.input}
```python
# Request data for all stations in Colorado
PR = hf.NWIS(stateCd='CO').get_data()

# List the names for the first 5 sites in Colorado, USA
PR.siteName[0:5]
```

{:.output}
{:.execute_result}



    ['COLORADO CREEK NEAR SPICER, CO.',
     'GRIZZLY CREEK NEAR SPICER, CO.',
     'BUFFALO CREEK NEAR HEBRON, CO.',
     'GRIZZLY CREEK NEAR HEBRON, CO.',
     'GRIZZLY CREEK NEAR WALDEN, CO']





## Download Stream Gage Data
You are now ready to grab some data from the NWIS API. 

### Mean Daily vs Instantaneous Stream Flow Data

There are two kinds of streamflow time-series data that the USGS provides online: 

1. **mean daily streamflow:** Mean daily streamflow is useful because it retains all events over the period of record.
1. **annual maximum instantaneous streamflow:** Instantaneous data are useful because it retains the maximum flood peak in a given year. There is no averaging of the data that might reduce or smooth out the maximum values. 

> How do you think flood frequencies characterized by these two different data types will compare?

For this part of the lesson, you will download the mean daily discharge data. The code for this data in `dv` when using the `hydrofunctions` python package. 

### Get Data Using Hydrofunctions API Interface for Python

To begin define a start and end date that you'd like to download. Also define the `site ID`.
Use `USGS 06730500` as your selected site. This site remained in tact during the 2013 flood event in Colorado. It also has a long time series of data that will be helpful when calculating recurrence intervals and exceedance probability values below.  

{:.input}
```python
# define the site number and start and end dates that you are interested in
site = "06730500"
start = '1946-05-10'
end = '2018-08-29'

# then request data for that site and time period 
longmont_resp = hf.get_nwis(site, 'dv', start, end)
```

### View Site and Metadata Information
You can explore the metadata for the site using the `get_nwis()` function. Below we request the metadata for the site and the "dv" or Daily Value data. Recall from above that dv is the daily mean value. `iv` provides the instantaneous data.

You can also visit the <a href="https://waterdata.usgs.gov/nwis/inventory/?site_no=06730500" target = "_blank">USGS Site page</a> to learn more about the site. 

{:.input}
```python
hf.get_nwis_property(longmont_resp)
# get metadata about the data
hf.get_nwis(site, 'dv').json()
```

{:.output}
{:.execute_result}



    {'name': 'ns1:timeSeriesResponseType',
     'declaredType': 'org.cuahsi.waterml.TimeSeriesResponseType',
     'scope': 'javax.xml.bind.JAXBElement$GlobalScope',
     'value': {'queryInfo': {'queryURL': 'http://waterservices.usgs.gov/nwis/dv/format=json%2C1.1&sites=06730500&parameterCd=00060',
       'criteria': {'locationParam': '[ALL:06730500]',
        'variableParam': '[00060]',
        'parameter': []},
       'note': [{'value': '[ALL:06730500]', 'title': 'filter:sites'},
        {'value': '[mode=LATEST, modifiedSince=null]',
         'title': 'filter:timeRange'},
        {'value': 'methodIds=[ALL]', 'title': 'filter:methodId'},
        {'value': '2018-09-07T20:28:26.208Z', 'title': 'requestDT'},
        {'value': '92e8a6f0-b2dc-11e8-87eb-6cae8b663fb6', 'title': 'requestId'},
        {'value': 'Provisional data are subject to revision. Go to http://waterdata.usgs.gov/nwis/help/?provisional for more information.',
         'title': 'disclaimer'},
        {'value': 'vaas01', 'title': 'server'}]},
      'timeSeries': [{'sourceInfo': {'siteName': 'BOULDER CREEK AT MOUTH NEAR LONGMONT, CO',
         'siteCode': [{'value': '06730500',
           'network': 'NWIS',
           'agencyCode': 'USGS'}],
         'timeZoneInfo': {'defaultTimeZone': {'zoneOffset': '-07:00',
           'zoneAbbreviation': 'MST'},
          'daylightSavingsTimeZone': {'zoneOffset': '-06:00',
           'zoneAbbreviation': 'MDT'},
          'siteUsesDaylightSavingsTime': True},
         'geoLocation': {'geogLocation': {'srs': 'EPSG:4326',
           'latitude': 40.13877778,
           'longitude': -105.0202222},
          'localSiteXY': []},
         'note': [],
         'siteType': [],
         'siteProperty': [{'value': 'ST', 'name': 'siteTypeCd'},
          {'value': '10190005', 'name': 'hucCd'},
          {'value': '08', 'name': 'stateCd'},
          {'value': '08123', 'name': 'countyCd'}]},
        'variable': {'variableCode': [{'value': '00060',
           'network': 'NWIS',
           'vocabulary': 'NWIS:UnitValues',
           'variableID': 45807197,
           'default': True}],
         'variableName': 'Streamflow, ft&#179;/s',
         'variableDescription': 'Discharge, cubic feet per second',
         'valueType': 'Derived Value',
         'unit': {'unitCode': 'ft3/s'},
         'options': {'option': [{'value': 'Mean',
            'name': 'Statistic',
            'optionCode': '00003'}]},
         'note': [],
         'noDataValue': -999999.0,
         'variableProperty': [],
         'oid': '45807197'},
        'values': [{'value': [{'value': '69.0',
            'qualifiers': ['P'],
            'dateTime': '2018-09-06T00:00:00.000'}],
          'qualifier': [{'qualifierCode': 'P',
            'qualifierDescription': 'Provisional data subject to revision.',
            'qualifierID': 0,
            'network': 'NWIS',
            'vocabulary': 'uv_rmk_cd'}],
          'qualityControlLevel': [],
          'method': [{'methodDescription': '', 'methodID': 17666}],
          'source': [],
          'offset': [],
          'sample': [],
          'censorCode': []}],
        'name': 'USGS:06730500:00060:00003'}]},
     'nil': False,
     'globalScope': True,
     'typeSubstituted': False}





Now, request the data. The data will be returned as a `pandas` dataframe.

{:.input}
```python
# get the data in a pandas dataframe format
longmont_discharge = hf.extract_nwis_df(longmont_resp)
longmont_discharge.head()
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
      <th>USGS:06730500:00060:00003</th>
      <th>USGS:06730500:00060:00003_qualifiers</th>
    </tr>
    <tr>
      <th>datetime</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1946-05-10</th>
      <td>16.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1946-05-11</th>
      <td>19.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1946-05-12</th>
      <td>9.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1946-05-13</th>
      <td>3.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1946-05-14</th>
      <td>7.8</td>
      <td>A</td>
    </tr>
  </tbody>
</table>
</div>





`Hydrofunctions` imports your data into a `pandas` dataframe with a datetime index. However you may find the column headings to be too long. Below you will rename them to keep the code in this lesson simpler.
NOTE: if you are working with many different sites, you'd likely want to keep the column names as they are - with the site ID included.

{:.input}
```python
# rename columns
longmont_discharge.columns = ["discharge", "flag"]
# view first 5 rows
longmont_discharge.head()
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
      <th>discharge</th>
      <th>flag</th>
    </tr>
    <tr>
      <th>datetime</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1946-05-10</th>
      <td>16.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1946-05-11</th>
      <td>19.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1946-05-12</th>
      <td>9.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1946-05-13</th>
      <td>3.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1946-05-14</th>
      <td>7.8</td>
      <td>A</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# view last 5 rows of the data
longmont_discharge.tail()
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
      <th>discharge</th>
      <th>flag</th>
    </tr>
    <tr>
      <th>datetime</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2018-08-25</th>
      <td>12.20</td>
      <td>P</td>
    </tr>
    <tr>
      <th>2018-08-26</th>
      <td>8.99</td>
      <td>P</td>
    </tr>
    <tr>
      <th>2018-08-27</th>
      <td>5.52</td>
      <td>P</td>
    </tr>
    <tr>
      <th>2018-08-28</th>
      <td>3.90</td>
      <td>P</td>
    </tr>
    <tr>
      <th>2018-08-29</th>
      <td>4.83</td>
      <td>P</td>
    </tr>
  </tbody>
</table>
</div>





### Plot Your Data
Next, plot the time series using `matplotlib`. What do you notice?
There is an unfortunate gap in the data. The good news that while this gap may not work for some analyses, it is acceptable when you calculate a recurrence interval. 

Note that below I grab the site variable and add it to my plot title using the syntax:

`ax.set_title("Stream Discharge - Station {} \n 1946-2017".format(site))`

where `{}` is a placeholder for the variable that you want to insert into the title and `.format(site)` tells `Python` to grab and format the `site` variable that was defined above.

{:.input}
```python
# plot using matplotlib
fig, ax = plt.subplots(figsize = (11,6))
ax.scatter(x=longmont_discharge.index, 
        y=longmont_discharge["discharge"], 
        marker="o",
        s=4, 
        color ="purple")
ax.set_xlabel("Date")
ax.set_ylabel("Discharge Value (CFS)")
ax.set_title("Stream Discharge - Station {} \n {} to {}".format(site, start, end))
plt.show()

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/OLD-ts06-exceedance-probability-and-return-periods_16_0.png" alt = "Stream Discharge for the longmont USGS stream gage from 1946-2017">
<figcaption>Stream Discharge for the longmont USGS stream gage from 1946-2017</figcaption>

</figure>




## Calculate Annual Maxima

Next you will look at the annual maxima. Annual maxima refers to the biggest value that occured within each year. In the case of stream discharge - this is the largest discharge value that was recorded in CFS per year.

There are two ways to get this data.

1. You can take the daily mean values and calculate the annual max value. This is done using `pandas resample` - you learned how to do this in a previous lesson!
2. You can download a annual maximum value dataset from <a href="https://nwis.waterdata.usgs.gov/nwis" target = "_blank">USGS  here</a>.

Note that you will compare the data that you download to the data that you calculate below. 
The USGS dataset is created using instantaneous data. This is data collected every 5-30 minutes with no averaging. 

The data that you calculate will be derived using the daily mean value data that you downloaded above. Do you think you will get the same annual max each year?
Let's find out. 

### Add a Year Column to Your Data

Note that below you add a year column to the longmont discharge data. While this step is not necessary for resampling. It will make your life easier when you plot the data together below. 

{:.input}
```python
# add a year column to your longmont discharge data
longmont_discharge["year"]=longmont_discharge.index.year

# Calculate annual max by resampling
longmont_discharge_annual_max = longmont_discharge.resample('AS').max()
longmont_discharge_annual_max.head()
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
      <th>discharge</th>
      <th>flag</th>
      <th>year</th>
    </tr>
    <tr>
      <th>datetime</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1946-01-01</th>
      <td>99.0</td>
      <td>A</td>
      <td>1946.0</td>
    </tr>
    <tr>
      <th>1947-01-01</th>
      <td>1930.0</td>
      <td>A</td>
      <td>1947.0</td>
    </tr>
    <tr>
      <th>1948-01-01</th>
      <td>339.0</td>
      <td>A</td>
      <td>1948.0</td>
    </tr>
    <tr>
      <th>1949-01-01</th>
      <td>2010.0</td>
      <td>A</td>
      <td>1949.0</td>
    </tr>
    <tr>
      <th>1950-01-01</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>





### Import USGS Annual Peak Max Data
Next import the USGS annual maxima data. 



{:.output}
{:.execute_result}



    ('data/colorado-flood/downloads/annual-peak-flow.txt',
     <http.client.HTTPMessage at 0x11a6c0e48>)





{:.input}
```python
# download usgs annual max data from figshare
url = "https://nwis.waterdata.usgs.gov/nwis/peak?site_no=06730500&agency_cd=USGS&format=rdb"
download_path = "data/colorado-flood/downloads/annual-peak-flow.txt"
urllib.request.urlretrieve(url, download_path)
```

{:.output}
{:.execute_result}



    ('data/colorado-flood/downloads/annual-peak-flow.txt',
     <http.client.HTTPMessage at 0x11a6ce080>)





The data that you are downloading are `tab-delimited`. When you import, be sure to specify 

`sep='\t'`

to ensure that the data download properly. Notice that below the `index_col` for the data is not specified when the data are opened in pandas. This is because you will need to bring in 2 lines of data headers. In pandas, two header rows import as a `multi-index` element. In this particular case it is easier to specify the index after you have removed one line of this `multi-index`.

Your pandas read_csv function will include 4 arguments as follows:


* `download_path`: this is the path where you file is saved
* `header=[1,2]`: this tells pandas to import two header lines - lines 1 and 2 after the skipped rows 
* `sep='\t'`: import the data as a tab delimited file
* `skiprows = 63`: skip the first 63 rows of the data. IF you open the data in a text editor you will notice the entire top of the file is all metadata.
* `parse_dates = [2]`: convert the second column in the data to a datetime format

{:.input}
```python
# open the data using pandas
usgs_annual_max = pd.read_csv(download_path,
                              skiprows = 63,
                              header=[1,2], 
                              sep='\t', 
                              parse_dates = [2])
# notice that the data now have 2 header rows. We only need one - the first row
usgs_annual_max.head()
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
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th>agency_cd</th>
      <th>site_no</th>
      <th>peak_dt</th>
      <th>peak_tm</th>
      <th>peak_va</th>
      <th>peak_cd</th>
      <th>gage_ht</th>
      <th>gage_ht_cd</th>
      <th>year_last_pk</th>
      <th>ag_dt</th>
      <th>ag_tm</th>
      <th>ag_gage_ht</th>
      <th>ag_gage_ht_cd</th>
    </tr>
    <tr>
      <th></th>
      <th>5s</th>
      <th>15s</th>
      <th>10d</th>
      <th>6s</th>
      <th>8s</th>
      <th>27s</th>
      <th>8s</th>
      <th>13s</th>
      <th>4s</th>
      <th>10d</th>
      <th>6s</th>
      <th>8s</th>
      <th>11s</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>1927-07-29</td>
      <td>06:00</td>
      <td>407.0</td>
      <td>5</td>
      <td>3.00</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>1928-06-04</td>
      <td>09:00</td>
      <td>694.0</td>
      <td>5</td>
      <td>3.84</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>1929-07-23</td>
      <td>15:00</td>
      <td>530.0</td>
      <td>5</td>
      <td>3.40</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>1930-08-18</td>
      <td>05:00</td>
      <td>353.0</td>
      <td>5</td>
      <td>2.94</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>1931-05-29</td>
      <td>09:00</td>
      <td>369.0</td>
      <td>5</td>
      <td>2.88</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# drop one level of index
usgs_annual_max.columns = usgs_annual_max.columns.droplevel(1)
# finally set the date column as the index
usgs_annual_max = usgs_annual_max.set_index(['peak_dt'])

# optional - remove columns we don't need - this is just to make the lesson easier to read
# you can skip this step if you want
usgs_annual_max = usgs_annual_max.drop(["gage_ht_cd", "year_last_pk","ag_dt", "ag_gage_ht", "ag_tm", "ag_gage_ht_cd"], axis=1)

# view cleaned dataframe
usgs_annual_max.head()
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
      <th>agency_cd</th>
      <th>site_no</th>
      <th>peak_tm</th>
      <th>peak_va</th>
      <th>peak_cd</th>
      <th>gage_ht</th>
    </tr>
    <tr>
      <th>peak_dt</th>
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
      <th>1927-07-29</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>06:00</td>
      <td>407.0</td>
      <td>5</td>
      <td>3.00</td>
    </tr>
    <tr>
      <th>1928-06-04</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>09:00</td>
      <td>694.0</td>
      <td>5</td>
      <td>3.84</td>
    </tr>
    <tr>
      <th>1929-07-23</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>15:00</td>
      <td>530.0</td>
      <td>5</td>
      <td>3.40</td>
    </tr>
    <tr>
      <th>1930-08-18</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>05:00</td>
      <td>353.0</td>
      <td>5</td>
      <td>2.94</td>
    </tr>
    <tr>
      <th>1931-05-29</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>09:00</td>
      <td>369.0</td>
      <td>5</td>
      <td>2.88</td>
    </tr>
  </tbody>
</table>
</div>





Next, add a year column to your data for easy plotting and make sure that you have only one value per year as expected.

{:.input}
```python
# add a year column to the data for easier plotting
usgs_annual_max["year"] = usgs_annual_max.index.year

# are there any years that have two entries?
usgs_annual_max[usgs_annual_max.duplicated(subset="year")==True]
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
      <th>agency_cd</th>
      <th>site_no</th>
      <th>peak_tm</th>
      <th>peak_va</th>
      <th>peak_cd</th>
      <th>gage_ht</th>
      <th>year</th>
    </tr>
    <tr>
      <th>peak_dt</th>
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
      <th>1947-10-15</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>NaN</td>
      <td>721.0</td>
      <td>5</td>
      <td>3.55</td>
      <td>1947</td>
    </tr>
    <tr>
      <th>1993-10-18</th>
      <td>USGS</td>
      <td>6730500</td>
      <td>NaN</td>
      <td>497.0</td>
      <td>5</td>
      <td>2.76</td>
      <td>1993</td>
    </tr>
  </tbody>
</table>
</div>





It looks like you have two years that have more than one data value - 1947 and 1993. For the purpose of this exercise let's only take the largest discharge value from each year. 

{:.input}
```python
# remove duplicate years - keep the max discharge value
usgs_annual_max = usgs_annual_max.sort_values('peak_va', ascending=False).drop_duplicates('year').sort_index()
# if this returns no results you have remove duplicated successfully!
usgs_annual_max[usgs_annual_max.duplicated(subset="year")==True]
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
      <th>agency_cd</th>
      <th>site_no</th>
      <th>peak_tm</th>
      <th>peak_va</th>
      <th>peak_cd</th>
      <th>gage_ht</th>
      <th>year</th>
    </tr>
    <tr>
      <th>peak_dt</th>
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
  </tbody>
</table>
</div>





Finally, you are ready to plot the USGS annual max with the calculated annual max derived from your daily mean data. Are they the same? Or Different?

What could cause differences in these two different approaches to getting annual max values?

{:.input}
```python
# plot calculated vs USGS annual max flow values
fig, ax = plt.subplots(figsize = (11,9))
ax.plot(usgs_annual_max["year"], 
        usgs_annual_max["peak_va"],
        color = "purple",
        linestyle=':', 
        marker='o', 
        label = "USGS Annual Max")
ax.plot(longmont_discharge_annual_max["year"], 
        longmont_discharge_annual_max["discharge"],
        color = "lightgrey",
        linestyle=':', 
        marker='o', label = "Calculated Annual Max")
ax.legend()
ax.set_title("Annual Maxima - USGS Peak Flow vs Daily Calculated");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/OLD-ts06-exceedance-probability-and-return-periods_30_0.png">

</figure>




## Optional - Different Bar Plot

To further explore your data, you could calculate a difference value between the USGS max value and your annual max calculated from daily mean data. 

{:.input}
```python
# merge the two pandas dataframes on the year column
usgs_calculated = pd.merge(longmont_discharge_annual_max, 
                           usgs_annual_max, 
                           left_on="year", 
                           right_on = "year")
# subtract usgs values from your calculated values
usgs_calculated["diff"] = usgs_calculated["peak_va"] - usgs_calculated["discharge"]
```

Once you have calculated a difference column, create a barplot. 

{:.input}
```python
# plot difference
fig, ax = plt.subplots(figsize = (11,6))
ax.bar(usgs_calculated["year"], 
       usgs_calculated["diff"])
ax.set_title("Difference Plot \nUSGS Peak Max Annual Minus Calculated Max Annual Stream Flow");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/OLD-ts06-exceedance-probability-and-return-periods_34_0.png">

</figure>




## Calculate Return Period

Now that you have both datasets, you are ready to calculate the return period from each. You will calculate this value and the associated probability of each event size for both the USGS max annual flow data and for the max flow value that you derived from the daily mean data.  To calculate return period you will do the following:

1.	Sort your data from smallest to largest.
2.	Calculate exceedance probabilities using the equation below where `n` is length of the record and `i` is the rank.
3.	Calculate the inverse of the exceedance probabilities to determine return period in years.
4.	Plot flood magnitudes against return time. It is common to plot these kinds of data on log-linear or log-log axes. 

****

Exceedance probability equation: 

$$Probablity = \frac{n-i+1}{n+1}$$


where i is the rank order (smallest to largest) from 1 to n. Note that the limits of this equation vary from n/(n+1) ~ 1 for the smallest events and 1/(n+1) for the largest events (i.e., the largest events have a very small exceedance probability). 

****

OPTIONAL: If you want to extrapolate beyond the observations that you have - for instance to predict what a 1000 year flood would be given only 100 years of data - then you would need to fit a model to the data.

The steps that you will need to implement are below. 

{:.input}
```python
# sort data smallest to largest
sorted_data = longmont_discharge.sort_values(by = "discharge")
# count total obervations
n = sorted_data.shape[0]
# add a numbered column 1 -> n to use in return calculation for rank
sorted_data.insert(0, 'rank', range(1, 1 + n))
# calculate probability - note you may need to adjust this value based upon the time period of your data
# for daily data you'd multiply by 365

sorted_data["probability"] = ((n - sorted_data["rank"] + 1) / (n + 1))
# calculate return - data are daily to then divide by 365?
sorted_data["return-years"] = (1 / sorted_data["probability"]) 
```

You will ultimately perform the steps above several times for both the discharge data and the precipitation data as a part of your homework. Turning these steps into a function will help you more efficiently process your data. 
An example of what this function could look like is below. For your homework, you will add documentation to this function. 

{:.input}
```python
# Create a function from the workflow below

## add an argument for annual vs daily... 
def calculate_return(df, colname):
    '''
    Add Documentation Here
    
    
    '''
    # sort data smallest to largest
    sorted_data = df.sort_values(by = colname)
    # count total obervations
    n = sorted_data.shape[0]
    # add a numbered column 1 -> n to use in return calculation for rank
    sorted_data.insert(0, 'rank', range(1, 1 + n))
    # calculate probability
    sorted_data["probability"] = (n - sorted_data["rank"] + 1) / (n + 1)
    # calculate return - data are daily to then divide by 365?
    sorted_data["return-years"] = (1 / sorted_data["probability"])
    
    return(sorted_data)

```

Once you have a function, you can calculate return period and probability on both datasets.

{:.input}
```python
longmont_prob = calculate_return(longmont_discharge, "discharge")
# Because these data are daily, divide return period in years by 365
longmont_prob["return-years"] = longmont_prob["return-years"] / 365
longmont_prob.tail()
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
      <th>rank</th>
      <th>discharge</th>
      <th>flag</th>
      <th>year</th>
      <th>probability</th>
      <th>return-years</th>
    </tr>
    <tr>
      <th>datetime</th>
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
      <th>2013-09-16</th>
      <td>17078</td>
      <td>3270.0</td>
      <td>A e</td>
      <td>2013</td>
      <td>0.000293</td>
      <td>9.360548</td>
    </tr>
    <tr>
      <th>2013-09-12</th>
      <td>17079</td>
      <td>3680.0</td>
      <td>A</td>
      <td>2013</td>
      <td>0.000234</td>
      <td>11.700685</td>
    </tr>
    <tr>
      <th>2013-09-15</th>
      <td>17080</td>
      <td>3970.0</td>
      <td>A e</td>
      <td>2013</td>
      <td>0.000176</td>
      <td>15.600913</td>
    </tr>
    <tr>
      <th>2013-09-14</th>
      <td>17081</td>
      <td>4970.0</td>
      <td>A e</td>
      <td>2013</td>
      <td>0.000117</td>
      <td>23.401370</td>
    </tr>
    <tr>
      <th>2013-09-13</th>
      <td>17082</td>
      <td>8910.0</td>
      <td>A e</td>
      <td>2013</td>
      <td>0.000059</td>
      <td>46.802740</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# calculate the same thing using the USGS annual max data
usgs_annual_prob = calculate_return(usgs_annual_max, "peak_va")
usgs_annual_prob.head()
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
      <th>rank</th>
      <th>agency_cd</th>
      <th>site_no</th>
      <th>peak_tm</th>
      <th>peak_va</th>
      <th>peak_cd</th>
      <th>gage_ht</th>
      <th>year</th>
      <th>probability</th>
      <th>return-years</th>
    </tr>
    <tr>
      <th>peak_dt</th>
      <th></th>
      <th></th>
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
      <th>1954-01-14</th>
      <td>1</td>
      <td>USGS</td>
      <td>6730500</td>
      <td>12:30</td>
      <td>26.0</td>
      <td>2,5</td>
      <td>NaN</td>
      <td>1954</td>
      <td>0.984615</td>
      <td>1.015625</td>
    </tr>
    <tr>
      <th>1932-07-13</th>
      <td>2</td>
      <td>USGS</td>
      <td>6730500</td>
      <td>10:00</td>
      <td>128.0</td>
      <td>5</td>
      <td>1.86</td>
      <td>1932</td>
      <td>0.969231</td>
      <td>1.031746</td>
    </tr>
    <tr>
      <th>1940-07-03</th>
      <td>3</td>
      <td>USGS</td>
      <td>6730500</td>
      <td>NaN</td>
      <td>174.0</td>
      <td>5</td>
      <td>2.34</td>
      <td>1940</td>
      <td>0.953846</td>
      <td>1.048387</td>
    </tr>
    <tr>
      <th>1946-07-19</th>
      <td>4</td>
      <td>USGS</td>
      <td>6730500</td>
      <td>NaN</td>
      <td>178.0</td>
      <td>5</td>
      <td>2.39</td>
      <td>1946</td>
      <td>0.938462</td>
      <td>1.065574</td>
    </tr>
    <tr>
      <th>2002-05-24</th>
      <td>5</td>
      <td>USGS</td>
      <td>6730500</td>
      <td>09:15</td>
      <td>238.0</td>
      <td>5</td>
      <td>2.60</td>
      <td>2002</td>
      <td>0.923077</td>
      <td>1.083333</td>
    </tr>
  </tbody>
</table>
</div>





# make this plot interactive so they can see the dates!

### Plot Event Probability

Below, you plot Discharge on the x axis and the probability that an event of that size will occur on the y-axis. 

{:.input}
```python
# Compare both datasets
fig, ax = plt.subplots(figsize = (11,6) )
usgs_annual_prob.plot.scatter(x="peak_va", 
                              y="probability",  
                              title="Probability ", 
                              ax=ax,
                              color='purple', 
                              fontsize=16,
                              logy= True,
                              label="USGS Annual Max Calculated")
longmont_prob.plot.scatter(y="probability", 
                           x="discharge", 
                           title="Probability ", 
                           ax=ax,
                           color='grey', 
                           fontsize=16,
                           logy= True,
                           label="Daily Mean Calculated")
ax.legend(frameon = True,
          framealpha = 1)
ax.set_ylabel("Probability")
ax.set_xlabel("Discharge Value (CFS)")
ax.set_title("Probability of Discharge Events \n USGS Annual Max Data Compared to Daily Mean Calculated Annual Max")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/OLD-ts06-exceedance-probability-and-return-periods_43_0.png">

</figure>




## Return Period

{:.input}
```python
fig, ax = plt.subplots(figsize = (11,6) )
longmont_prob.plot.scatter(y ="discharge", 
                         x="return-years", 
                         title="Return Period (Years)", 
                         ax=ax,
                         color='purple',
                         fontsize=16,
                         label="Daily Mean Calculated")
usgs_annual_prob.plot.scatter(y ="peak_va",
                              x="return-years", 
                              title = "Return Period (Years)",
                              ax=ax,
                              color='grey',
                              fontsize=16,
                              label="USGS Annual Max")
ax.legend(frameon = True,
          framealpha = 1)
ax.set_xlabel("Return Period (Years)")
ax.set_ylabel("Discharge Value (CFS)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/OLD-ts06-exceedance-probability-and-return-periods_45_0.png">

</figure>



