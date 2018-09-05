---
layout: single
title: "A Hundred Year Flood Can Occur Every Year? Calculate Exceedance Probability and Return Periods in Python"
excerpt: "Learn how to calculate exceedance probability and return periods associated with a flood in Python."
authors: ['Matt Rossi', 'Leah Wasser']
modified: 2018-09-04
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
order: 7
topics:
---

## Introduction to Flood Frequency Analysis

One way to analyze time series data - particular related to events like floods is to calculate the frequency of likelyhood that a particular event will occur. You have have heard the term "100 year flood". This term is misleading because while you may think it means that a particular size of flood will occur every 100 years. It actually means that every year, that size of a flood event has a 1/100 change or 1% change of occuring. 

This is why a hundred year flood event could, by chance, occur in the same place, two years in a row.

In this lesson you will learn how the "100 year" flood is calculated using some basic statistics. To begin, let's define two terms:


1. **Exceedance probability:** the probability of a given magnitude event or greater to occur
	There is a 1% chance (P=0.01) that the maximum annual flood will exceed 100 m3/s at this site.
2. **Return period:** the inverse of the exceedance probability expressed in units of time
	The 100-yr flood is 100 m3/s at this site.

The content below comes from <a href="https://water.usgs.gov/edu/100yearflood.html" target= "_blank">this USGS waterscience page</a>. It provides an excellent overview of recurrence intervals and return periods.

****

## What is a Recurrence Interval?

> *100-year floods can happen 2 years in a row*

Statistical techniques, through a process called frequency analysis, are used to estimate the probability of the occurrence of a given precipitation event. The recurrence interval is based on the probability that the given event will be equalled or exceeded in any given year. For example, assume there is a 1 in 50 chance that 6.60 inches of rain will fall in a certain area in a 24-hour period during any given year. Thus, a rainfall total of 6.60 inches in a consecutive 24-hour period is said to have a 50-year recurrence interval. Likewise, using a frequency analysis (Interagency Advisory Committee on Water Data, 1982) there is a 1 in 100 chance that a streamflow of 15,000 cubic feet per second (ft3/s) will occur during any year at a certain streamflow-measurement site. Thus, a peak flow of 15,000 ft3/s at the site is said to have a 100-year recurrence interval. Rainfall recurrence intervals are based on both the magnitude and the duration of a rainfall event, whereas streamflow recurrence intervals are based solely on the magnitude of the annual peak flow.

Ten or more years of data are required to perform a frequency analysis for the determination of recurrence intervals. Of course, the more years of historical data the better—a hydrologist will have more confidence on an analysis of a river with 30 years of record than one based on 10 years of record.

Recurrence intervals for the annual peak streamflow at a given location change if there are significant changes in the flow patterns at that location, possibly caused by an impoundment or diversion of flow. The effects of development (conversion of land from forested or agricultural uses to commercial, residential, or industrial uses) on peak flows is generally much greater for low-recurrence interval floods than for high-recurrence interval floods, such as 25- 50- or 100-year floods. During these larger floods, the soil is saturated and does not have the capacity to absorb additional rainfall. Under these conditions, essentially all of the rain that falls, whether on paved surfaces or on saturated soil, runs off and becomes streamflow.

## How Can we have two "100-year floods" in less than two years?

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
In this lesson you will use  stream flow data to explore the probability of a particular magnitude or amount of discharge occuring in any given year. To do this you will need atleast 10 years of data. 

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

{:.output}
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)
    /Users/lewa8222/anaconda3/envs/earth-analytics-python/lib/python3.6/importlib/_bootstrap.py:219: RuntimeWarning: numpy.dtype size changed, may indicate binary incompatibility. Expected 96, got 88
      return f(*args, **kwds)



## Find A Station of Interest

The `hf.draw_map()` function allows you to explore the station visually in a particular area. Explore the map below. Notice the gage locations in the Boulder, Colorado area. 

For the purposes of this lesson, you will use gage `dv06730500` This gage is one of the few that was left standing during the 2013 flood event in Colorado. It also has a very nice time series of data that spans over 60 years. 

The map below also allows you to explore hydrographs for several stream gages at once if you click on the buttons at the very bottom center of the map. 

{:.input}
```python
# create map of stations
hf.draw_map()
```

{:.output}
{:.execute_result}



<p>Use <a href="http://hydrocloud.org" target="_blank">HydroCloud.org</a> to find a stream gauge. Click on the dots to learn more about a site.</p><iframe src=http://hydrocloud.org/ width=700 height=400></iframe>





If you want, you can also get a list of all stations located in Colorado using this package. 

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

a. **mean daily streamflow:** Mean daily streamflow is useful because it retains all events over the period of record.
b. **annual maximum instantaneous streamflow:** Instantaneous data are useful because it retains the maximum flood peak in a given year. There is no averaging of the data that might reduce or smooth out the max values. 

> How do you think flood frequencies characterized by these two different data types will compare?

For this part of the lesson, you will download the mean daily discharge data. The code for this data in `dv` wwhen using the `hydrofunctions` python package. 

To begin define a start and end date that you'd like to download. Also define the `site ID`.
Use `USGS 06730500` as your selected site. This site remained in tact during the 2013 flood event in Colorado. It also has a long time series of data that will be helpful when calculating recurrence intervals and exceedance probability values below.  

{:.input}
```python
site = "06730500"
start = '1946-05-10'
end = '2018-08-29'
longmont_resp = hf.get_nwis(site, 'dv', start, end)
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





Hydrofunctions imports your data into a `pandas` dataframe with a datetime index. However you may find the column headings to be too long. Below you will rename them to keep the code in this lesson simpler.
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
# view last 5 rows
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





### View Site and Metadata Information
You can explore the metadata for the site using the `get_nwis()` function. Below we request the metadata for the site and the "dv" or Daily Value data. Recall from above that dv is the daily mean value. `iv` provides the instantaneous data.

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
        {'value': '2018-09-01T02:14:28.878Z', 'title': 'requestDT'},
        {'value': 'c1886bd0-ad8c-11e8-8a21-6cae8b6642f6', 'title': 'requestId'},
        {'value': 'Provisional data are subject to revision. Go to http://waterdata.usgs.gov/nwis/help/?provisional for more information.',
         'title': 'disclaimer'},
        {'value': 'caas01', 'title': 'server'}]},
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
        'values': [{'value': [{'value': '7.60',
            'qualifiers': ['P'],
            'dateTime': '2018-08-30T00:00:00.000'}],
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





## ask matt how he looks up record length - show them this in this lesson...
** show them how to look up records
matt could you add text on where you go to look up record length here with perhaps a link? i can turn the link into html. 

### Plot Your Data
Next, plot the time series using `matplotlib`. What do you notice?
There is an unfortunate gap in the data. The good news that while this gap may not work for some analyses, it is acceptable when you calculate a recurrence interval. 

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
ax.set_ylabel("Discharge Value (CFS)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts07-exceedance-probability-and-return-periods_15_0.png">

</figure>




## multiple by "day" 

60*60*24* CFS to get volume -- cubic feet - of water...  

might be interesting to overlay mean annual data to see potentail change??
palmer might also be interesting

{:.input}
```python
longmont_discharge["cum-sum-vol"] = longmont_discharge['discharge'].cumsum()*(60*60*24)
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
      <th>cum-sum-vol</th>
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
      <th>1946-05-10</th>
      <td>16.0</td>
      <td>A</td>
      <td>1382400.0</td>
    </tr>
    <tr>
      <th>1946-05-11</th>
      <td>19.0</td>
      <td>A</td>
      <td>3024000.0</td>
    </tr>
    <tr>
      <th>1946-05-12</th>
      <td>9.0</td>
      <td>A</td>
      <td>3801600.0</td>
    </tr>
    <tr>
      <th>1946-05-13</th>
      <td>3.0</td>
      <td>A</td>
      <td>4060800.0</td>
    </tr>
    <tr>
      <th>1946-05-14</th>
      <td>7.8</td>
      <td>A</td>
      <td>4734720.0</td>
    </tr>
  </tbody>
</table>
</div>





## Note sure about this plot
it seems like a cogniative leap to go from CFS to  cumulative area for a student? Wondering what Matt's thoughts are on this. i'm struggling with it. it's much easier to compare apples to apples i think?? 

{:.input}
```python
fig, ax = plt.subplots(figsize=(11,7))
longmont_discharge["cum-sum-vol"].plot(ax=ax, label = "Cumulative Volume")
# Make the y-axis label, ticks and tick labels match the line color.
ax.set_ylabel('Stream Discharge (Cumulative Cubic Feet per Day)', color='b')
ax.tick_params('y', colors='b')

ax2 = ax.twinx()
ax2.scatter(x=longmont_discharge.index, 
        y=longmont_discharge["discharge"], 
        marker="o",
        s=4, 
        color ="purple", label="Daily Mean")
ax2.set_ylabel('Stream Discharge (CFS)', color='purple')
ax2.tick_params('y', colors='purple')
ax2.set_ylim(0,10000)
ax.set_title("Cumulative Sum & Daily Mean Discharge")
ax.legend()
ax2.legend(loc = "upper left", bbox_to_anchor=(0.0, 0.9))
fig.tight_layout()
plt.show()

```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts07-exceedance-probability-and-return-periods_19_0.png">

</figure>




## Calculate Annual Maxima

Next you will look at the annual maxima. There are two ways to get this data.

1. You can take the daily mean values and calculate the annual max value. This is done using `pandas resample` - you learned how to do this in a previous lesson!
2. You can download a annual maximum value dataset rom <a href="https://nwis.waterdata.usgs.gov/nwis" target = "_blank">USGS  here</a>.

Note that you will compare the data that you download to the data that you calculate below. 
The USGS dataset is created using instantaneous data. This is data collected every 5-30 minutes with no averaging. 

The data that you calculate will be derived using the daily mean value data that you downloaded above. 

Do you think you will get the same annual max each year?
Let's find out. 

### Add a year column to your data

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
      <th>cum-sum-vol</th>
      <th>year</th>
    </tr>
    <tr>
      <th>datetime</th>
      <th></th>
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
      <td>3.043008e+08</td>
      <td>1946.0</td>
    </tr>
    <tr>
      <th>1947-01-01</th>
      <td>1930.0</td>
      <td>A</td>
      <td>4.688574e+09</td>
      <td>1947.0</td>
    </tr>
    <tr>
      <th>1948-01-01</th>
      <td>339.0</td>
      <td>A</td>
      <td>6.405705e+09</td>
      <td>1948.0</td>
    </tr>
    <tr>
      <th>1949-01-01</th>
      <td>2010.0</td>
      <td>A</td>
      <td>8.968139e+09</td>
      <td>1949.0</td>
    </tr>
    <tr>
      <th>1950-01-01</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>





### Import USGS Annual Peak Max Data
Next you can import the USGS annual max data. Note that these data are messy. To allow you to focus on this lesson, your instructure has cleaned up the data for easier plotting. 


{:.input}
```python
#Note that i have had to do some significant cleaning on this data. it seems to be missing time stamps and data in spots which messes up the import.
# usgs_annual_max = pd.read_csv("data/annual-peak-flow.txt",
#                              header=65, delim_whitespace = True,
#                              parse_dates = ["10d"])
usgs_annual_max = pd.read_csv("data/annual-peak-flow-clean.txt",
                             header=64, delim_whitespace = True,
                             parse_dates = ["peak_dt"], index_col = ["peak_dt"])
# add a year column to the data for easier plotting
usgs_annual_max["year"] = usgs_annual_max.index.year
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
      <th>gage_ht_cd</th>
      <th>year_last_pk</th>
      <th>ag_dt</th>
      <th>ag_tm</th>
      <th>ag_gage_ht</th>
      <th>ag_gage_ht_cd</th>
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
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>1927</td>
    </tr>
    <tr>
      <th>1928-06-04</th>
      <td>USGS</td>
      <td>6730500</td>
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
      <td>1928</td>
    </tr>
    <tr>
      <th>1929-07-23</th>
      <td>USGS</td>
      <td>6730500</td>
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
      <td>1929</td>
    </tr>
    <tr>
      <th>1930-08-18</th>
      <td>USGS</td>
      <td>6730500</td>
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
      <td>1930</td>
    </tr>
    <tr>
      <th>1931-05-29</th>
      <td>USGS</td>
      <td>6730500</td>
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
      <td>1931</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# plot data
fig, ax = plt.subplots()
ax.scatter(x=usgs_annual_max["year"], 
           y=usgs_annual_max["peak_va"], 
                     color="purple")
ax.set_title("Annual Maximum Peak Discharge - USGS Longmont Station");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts07-exceedance-probability-and-return-periods_24_0.png">

</figure>




{:.input}
```python
# longmont_discharge["year"]=longmont_discharge.index.year
# longmont_discharge.head()
```

{:.input}
```python
# remove this cell!!
#import datetime as dt
# usgs_annual_max.dtypes
# #usgs_annual_max.set_index((usgs_annual_max['peak_dt']), inplace=True)
# #usgs_annual_max["year"] = usgs_annual_max.index.year
# usgs_annual_max.head()
```

You are now ready to plot the annual max data that you calculated with the annual max that you downloaded. 
Are they the same? Or different?

{:.input}
```python
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
      <th>gage_ht_cd</th>
      <th>year_last_pk</th>
      <th>ag_dt</th>
      <th>ag_tm</th>
      <th>ag_gage_ht</th>
      <th>ag_gage_ht_cd</th>
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
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>1927</td>
    </tr>
    <tr>
      <th>1928-06-04</th>
      <td>USGS</td>
      <td>6730500</td>
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
      <td>1928</td>
    </tr>
    <tr>
      <th>1929-07-23</th>
      <td>USGS</td>
      <td>6730500</td>
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
      <td>1929</td>
    </tr>
    <tr>
      <th>1930-08-18</th>
      <td>USGS</td>
      <td>6730500</td>
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
      <td>1930</td>
    </tr>
    <tr>
      <th>1931-05-29</th>
      <td>USGS</td>
      <td>6730500</td>
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
      <td>1931</td>
    </tr>
  </tbody>
</table>
</div>





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

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts07-exceedance-probability-and-return-periods_29_0.png">

</figure>




{:.input}
```python
#longmont_discharge_annual_max
new = pd.merge(longmont_discharge_annual_max, usgs_annual_max, left_on="year", right_on = "year")
new["diff"] = new["peak_va"] - new["discharge"]
```

{:.input}
```python
new[["year","diff"]]
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
      <th>year</th>
      <th>diff</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1946.0</td>
      <td>79.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1947.0</td>
      <td>110.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1947.0</td>
      <td>-1209.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1949.0</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1951.0</td>
      <td>510.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>1952.0</td>
      <td>530.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>1953.0</td>
      <td>56.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>1954.0</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>1955.0</td>
      <td>128.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>1979.0</td>
      <td>114.0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>1980.0</td>
      <td>250.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>1981.0</td>
      <td>89.0</td>
    </tr>
    <tr>
      <th>12</th>
      <td>1982.0</td>
      <td>338.0</td>
    </tr>
    <tr>
      <th>13</th>
      <td>1983.0</td>
      <td>490.0</td>
    </tr>
    <tr>
      <th>14</th>
      <td>1984.0</td>
      <td>136.0</td>
    </tr>
    <tr>
      <th>15</th>
      <td>1985.0</td>
      <td>46.0</td>
    </tr>
    <tr>
      <th>16</th>
      <td>1986.0</td>
      <td>52.0</td>
    </tr>
    <tr>
      <th>17</th>
      <td>1987.0</td>
      <td>413.0</td>
    </tr>
    <tr>
      <th>18</th>
      <td>1988.0</td>
      <td>97.0</td>
    </tr>
    <tr>
      <th>19</th>
      <td>1989.0</td>
      <td>199.0</td>
    </tr>
    <tr>
      <th>20</th>
      <td>1990.0</td>
      <td>103.0</td>
    </tr>
    <tr>
      <th>21</th>
      <td>1992.0</td>
      <td>333.0</td>
    </tr>
    <tr>
      <th>22</th>
      <td>1993.0</td>
      <td>437.0</td>
    </tr>
    <tr>
      <th>23</th>
      <td>1993.0</td>
      <td>-486.0</td>
    </tr>
    <tr>
      <th>24</th>
      <td>1995.0</td>
      <td>800.0</td>
    </tr>
    <tr>
      <th>25</th>
      <td>1996.0</td>
      <td>558.0</td>
    </tr>
    <tr>
      <th>26</th>
      <td>1997.0</td>
      <td>340.0</td>
    </tr>
    <tr>
      <th>27</th>
      <td>1998.0</td>
      <td>69.0</td>
    </tr>
    <tr>
      <th>28</th>
      <td>1999.0</td>
      <td>400.0</td>
    </tr>
    <tr>
      <th>29</th>
      <td>2000.0</td>
      <td>673.0</td>
    </tr>
    <tr>
      <th>30</th>
      <td>2001.0</td>
      <td>111.0</td>
    </tr>
    <tr>
      <th>31</th>
      <td>2002.0</td>
      <td>132.0</td>
    </tr>
    <tr>
      <th>32</th>
      <td>2003.0</td>
      <td>70.0</td>
    </tr>
    <tr>
      <th>33</th>
      <td>2004.0</td>
      <td>172.0</td>
    </tr>
    <tr>
      <th>34</th>
      <td>2005.0</td>
      <td>61.0</td>
    </tr>
    <tr>
      <th>35</th>
      <td>2006.0</td>
      <td>386.0</td>
    </tr>
    <tr>
      <th>36</th>
      <td>2007.0</td>
      <td>164.0</td>
    </tr>
    <tr>
      <th>37</th>
      <td>2008.0</td>
      <td>230.0</td>
    </tr>
    <tr>
      <th>38</th>
      <td>2009.0</td>
      <td>152.0</td>
    </tr>
    <tr>
      <th>39</th>
      <td>2010.0</td>
      <td>60.0</td>
    </tr>
    <tr>
      <th>40</th>
      <td>2011.0</td>
      <td>70.0</td>
    </tr>
    <tr>
      <th>41</th>
      <td>2012.0</td>
      <td>279.0</td>
    </tr>
    <tr>
      <th>42</th>
      <td>2013.0</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>43</th>
      <td>2014.0</td>
      <td>80.0</td>
    </tr>
    <tr>
      <th>44</th>
      <td>2015.0</td>
      <td>220.0</td>
    </tr>
    <tr>
      <th>45</th>
      <td>2016.0</td>
      <td>52.0</td>
    </tr>
    <tr>
      <th>46</th>
      <td>2017.0</td>
      <td>280.0</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
#import plotly.plotly as py
# plot different
fig, ax = plt.subplots(figsize = (11,6))
ax.bar(new["year"], 
       new["diff"])
ax.set_title("Difference Plot \nUSGS Peak Max Annual Minus Calculated Max Annual Stream Flow");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/2018-02-05-ts07-exceedance-probability-and-return-periods_32_0.png">

</figure>




1.	Sort our series of data from smallest to largest.
2.	Calculate exceedance probabilities using eq. 1, where n is length of the record and i is the rank.
3.	Calculate the inverse of the exceedance probabilities to determine return period in years.
4.	Plot flood magnitudes against return time. Depending on what kind of distribution we think best describes these data, we often plot these kinds of data on log-linear or log-log axes. 
5.	If we want to extrapolate beyond observations, then we will need to fit a parametric model to the data (see section III).

(n-i+1)/(n+1)

where i is the rank order (smallest to largest) from 1 to n. Note that the limits of this equation vary from n/(n+1) ~ 1 for the smallest events and 1/(n+1) for the largest events (i.e., the largest events have a very small exceedance probability). 

{:.input}
```python
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
      <th>cum-sum-vol</th>
      <th>year</th>
    </tr>
    <tr>
      <th>datetime</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1946-05-10</th>
      <td>16.0</td>
      <td>A</td>
      <td>1382400.0</td>
      <td>1946</td>
    </tr>
    <tr>
      <th>1946-05-11</th>
      <td>19.0</td>
      <td>A</td>
      <td>3024000.0</td>
      <td>1946</td>
    </tr>
    <tr>
      <th>1946-05-12</th>
      <td>9.0</td>
      <td>A</td>
      <td>3801600.0</td>
      <td>1946</td>
    </tr>
    <tr>
      <th>1946-05-13</th>
      <td>3.0</td>
      <td>A</td>
      <td>4060800.0</td>
      <td>1946</td>
    </tr>
    <tr>
      <th>1946-05-14</th>
      <td>7.8</td>
      <td>A</td>
      <td>4734720.0</td>
      <td>1946</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# sort data smallest to largest
sorted_data = longmont_discharge.sort_values(by = "USGS:06730500:00060:00003")
# count total obervations
n = sorted_data.shape[0]
# add a numbered column 1 -> n to use in return calculation for rank
sorted_data.insert(0, 'rank', range(1, 1 + n))
# calculate probability
sorted_data["probability"] = (n - sorted_data["rank"] + 1) / (n + 1)
# calculate return - data are daily to then divide by 365?
import math
sorted_data["return-years"] = (1 / sorted_data["probability"]) / 365
sorted_data["return-log"] = np.log(sorted_data["return-years"] )
sorted_data["discharge-log"] = np.log(sorted_data["USGS:06730500:00060:00003"] )
sorted_data.head()
```

{:.output}

    ---------------------------------------------------------------------------

    KeyError                                  Traceback (most recent call last)

    <ipython-input-24-bd683a673a56> in <module>()
          1 # sort data smallest to largest
    ----> 2 sorted_data = longmont_discharge.sort_values(by = "USGS:06730500:00060:00003")
          3 # count total obervations
          4 n = sorted_data.shape[0]
          5 # add a numbered column 1 -> n to use in return calculation for rank


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/pandas/core/frame.py in sort_values(self, by, axis, ascending, inplace, kind, na_position)
       4419             by = by[0]
       4420             k = self._get_label_or_level_values(by, axis=axis,
    -> 4421                                                 stacklevel=stacklevel)
       4422 
       4423             if isinstance(ascending, (tuple, list)):


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/pandas/core/generic.py in _get_label_or_level_values(self, key, axis, stacklevel)
       1380             values = self.axes[axis].get_level_values(key)._values
       1381         else:
    -> 1382             raise KeyError(key)
       1383 
       1384         # Check for duplicates


    KeyError: 'USGS:06730500:00060:00003'



##

on this plot it owuld be intersting to add the annual data to this plot
log the x axis

# maybe trim the x axis to remove anything under one year... 
annual max should plot ...
use the one i downloaded -- because this grabs max from the instantaneous data rather than dv data

exceedance probability - the prob that event or LARGER will occur ...matts drawing is pretty good..

to add the prbabiltiy of a 10 year flood --> 1/(10 * 365)

so i could add a few of these for 10, 100??, ..

Add annual maxima here! it may fall above
nice discussion... here

Matt can help me code up a few models that we can change parameters for to see what the fit might look like using different models...and what the preducitions would be (and how they would be different ) for say a 100 year flood

## To do -- add the annuam max calculated from IV to this plot below. this means i have to calculate it!

{:.input}
```python
fig, ax = plt.subplots(figsize = (11,6) )
sorted_data.plot.scatter(y ="probability", x="USGS:06730500:00060:00003", 
                 title = "Probability ", ax=ax,
                        color = 'purple', fontsize = 16, 
                         #logx=True, 
                         logy=True)
ax.set_ylabel("Probability")
ax.set_xlabel("Discharge Value (CFS)");
```

{:.input}
```python
fig, ax = plt.subplots(figsize = (11,6) )
sorted_data.plot.scatter(y ="USGS:06730500:00060:00003", x="return-years", 
                 title = "Return Period (Years)", ax=ax,
                        color = 'purple', fontsize = 16, logx=True)
ax.set_xlabel("Return Period (Years)")
ax.set_ylabel("Discharge Value (CFS)");
```

This is where i got the precip data from... it's only available through 2013... can i get up to date data?
# https://www.ncdc.noaa.gov/cdo-web/datasets/PRECIP_HLY/locations/CITY:US080001/detail

https://www.ncdc.noaa.gov/homr/#ncdcstnid=20003803&tab=PHR
i may have to be ok with not having data for the entire period... that is ok..
