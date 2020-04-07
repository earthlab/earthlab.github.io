---
layout: single
title: "Why A Hundred Year Flood Can Occur Every Year. Calculate Exceedance Probability and Return Periods in Python"
excerpt: "Learn how to calculate exceedance probability and return periods associated with a flood in Python."
authors: ['Matthew Rossi', 'Leah Wasser']
dateCreated: 2018-02-05
modified: 2020-03-30
category: [courses]
class-lesson: ['time-series-python-tb']
course: 'intermediate-earth-data-science-textbook'
week: 1
permalink: /courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/floods-return-period-and-probability/
nav-title: 'Calculate Flood Return Period'
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['python']
  data-exploration-and-analysis: ['data-visualization']
redirect_from:
  - "/courses/earth-analytics-python/use-time-series-data-in-python/floods-return-period-and-probability/"
  - "/courses/use-data-open-source-python/use-time-series-data-in-python/floods-return-period-and-probability/"
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Calculate exceedance probability and return periods associated with a flood in **Python**.

</div>


## Introduction to Flood Frequency Analysis

One way to analyze time series data - particularly related to events like floods - is to calculate the frequency of different magnitude events. You have have likey heard the term **"100-year flood"**. While you may think it means that it is the size of flood that occurs every 100 years, it actually refers to the flood magnitude that has a probability of exceedance of 1/100 in any given year (i.e., a 1% chance). This is why the hundred year flood event can occur two years in a row.

In this lesson you will learn how "100-year floods" (and other flood frequencies) are calculated using some basic statistics. To begin, let's define two terms:

1. **Exceedance probability:** the probability of a given magnitude event or greater to occur.
    
2. **Recurrence interval:** the average time of exceedance is the inverse of the exceedance probability.
    
### Important Considerations

* The above definitions assume that flood events in the time series are independent (i.e., that event magnitudes are not correlated with each other in time) and that the process is stationary (i.e., that the probability distribution of events is not changing through time).

> In this project, we will be interpreting maximum annual floods. How valid do you think the above assumptions are for annual maxima?

* Even though the phrase "recurrence interval" evokes the idea of regularity in the time between events, this is an important misconception (recall our assumption of independence). The 100-year flood is just as likely to occur after a year that already experienced a 100-yr flood as any other year.

> In this project, we will be asking you to construct and interpret plots of recurrence intervals. Do you think the processes that drive floods are periodic? If so, over what timescales?


The content below comes from <a href="https://water.usgs.gov/edu/100yearflood.html" target= "_blank">this USGS waterscience page</a>. It provides an excellent overview of recurrence intervals and return periods.

****

## What is a Recurrence Interval?

> *100-year floods can happen 2 years in a row*

Statistical techniques, through a process called frequency analysis, are used to estimate the probability of the occurrence of a given precipitation event. The recurrence interval is based on the probability that the given event will be equalled or exceeded in any given year. For example, assume there is a 1 in 50 chance that 6.60 inches of rain will fall in a certain area in a 24-hour period during any given year. Thus, a rainfall total of 6.60 inches in a consecutive 24-hour period is said to have a 50-year recurrence interval. Likewise, using a frequency analysis (Interagency Advisory Committee on Water Data, 1982) there is a 1 in 100 chance that a streamflow of 15,000 cubic feet per second (ft3/s) will occur during any year at a certain streamflow-measurement site. Thus, a peak flow of 15,000 ft3/s at the site is said to have a 100-year recurrence interval. Rainfall recurrence intervals are based on both the magnitude and the duration of a rainfall event, whereas streamflow recurrence intervals are based solely on the magnitude of the annual peak flow.

Ten or more years of data are required to perform a frequency analysis for the determination of recurrence intervals. Of course, the more years of historical data the better—a hydrologist will have more confidence on an analysis of a river with 30 years of record than one based on 10 years of record.

Recurrence intervals for the annual peak streamflow at a given location change if there are significant changes in the flow patterns at that location, possibly caused by an impoundment or diversion of flow. The effects of development (conversion of land from forested or agricultural uses to commercial, residential, or industrial uses) on peak flows is generally much greater for low-recurrence interval floods than for high-recurrence interval floods, such as 25- 50- or 100-year floods. During these larger floods, the soil is saturated and does not have the capacity to absorb additional rainfall. Under these conditions, essentially all of the rain that falls, whether on paved surfaces or on saturated soil, runs off and becomes streamflow.

## How Can We Have two "100-year floods" in less than two years?

This question points out the importance of proper terminology. The term "100-year flood" is used in an attempt to simplify the definition of a flood that statistically has a 1-percent chance of occurring in any given year. Likewise, the term "100-year storm" is used to define a rainfall event that statistically has this same 1-percent chance of occurring. In other words, over the course of 1 million years, these events would be expected to occur 10,000 times. But, just because it rained 10 inches in one day last year doesn't mean it can't rain 10 inches in one day again this year.

### Recurrence intervals and probabilities of occurrences 

|Recurrance interval, in years | Probability of occurrence in any given year| Percent chance of occurrence in any given year | 
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
In this lesson, you will use streamflow data to explore the probabilities of a different magnitude events (e.g., discharge is measured in cubic feet per second). To do this, you will want long historic records to make your statistical inferences more robust. 

You will use the `hydrofunctions` python package to access streamflow data via an API from the United States Geological Survey (USGS) National Water Information System (NWIS) website. 

To begin, load all of your libraries.



{:.input}
```python
# Import packages
import os
import urllib
import requests
import math
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import earthpy as et
import hydrofunctions as hf

# Date time conversion registration
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()

# Get the data & set working director
data = et.data.get_data('colorado-flood')
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# Prettier plotting with seaborn
sns.set(font_scale=1.5, style="whitegrid")
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.




## Find A Station of Interest

The `hf.draw_map()` function allows you to explore the station visually in a particular area. Explore the map below. Notice the gage locations in the Boulder, Colorado area. 

For the purposes of this lesson, you will use gage `dv06730500` This gage along Boulder Creek survived the 2013 flood event and is one of the longest time series datasets along Boulder Creek. 

The map below also allows you to explore hydrographs for several stream gages at once if you click on the buttons at the bottom center of the map. 

```python
# Create map of stations
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

1. **Mean daily streamflow:** Mean daily streamflow is useful because it is a complete time series (except for days when the gage fails) and thus retains all recorded streamflow events over the period of record.
1. **Annual maximum instantaneous streamflow:** Instantaneous data is not averaged over the entire day, but instead reflects continuous variations in the flood hydrograph recorded by the stream gage. As such, annual maximum instantaneous streamflow data are useful because they retain the maximum values of discharge recorded in a given year. 

> How do you think flood frequencies characterized by these two different data types will compare?

For this part of the lesson, you will download the mean daily discharge data. The code for this data in `dv` when using the `hydrofunctions` python package. 

### Get Data Using Hydrofunctions API Interface for Python

To begin define a start and end date that you'd like to download. Also define the `site ID`.
Use `USGS 06730500` as your selected site. This stream gage survived the 2013 flood event in Colorado. It also has a long record of measurement that will be helpful when calculating recurrence intervals and exceedance probability values below.  

## Station Selection
In general, to select stream gages for flood frequency analysis you will want to carefully examine the metadata for candidate stations to check for the time period of operation, record completeness, and other comments on gage operation that might impact your interpretation of statistical results (e.g., Is there a dam upstream? When was it built? Other flow diversions? Did the gage malfunction during some events?) 

There are two subsets of USGS gages that have been specially identified for hydo-climatic analyses because station records are of high quality, cover a long time period, and human modification of the watershed is minimal (e.g., due to flow regulation or urban development): (1) Hydro-Climatic Data Network - 2009 (Lins, 2012) and (2) Geospatial attributes of gages for evaluating streamflow (Falcone, 2011).

For this project, we followed the lead of scientists assessing the significance of the 2013 Colorado floods using methods similar to the ones introduced in this project (Yochum, 2015). For more context of data availability along rivers draining the Colorado Front Range, check out Table 2 of this regional flood frequency analysis. 



{:.input}
```python
# Define the site number and start and end dates that you are interested in
site = "06730500"
start = '1946-05-10'
end = '2018-08-29'

# Request data for that site and time period
longmont_resp = hf.get_nwis(site, 'dv', start, end)
```

### View Site and Metadata Information
You can explore the metadata for the site using the `get_nwis()` function. Below we request the metadata for the site and the "dv" or Daily Value data. Recall from above that dv is the mean daily value. `iv` provides the instantaneous values.

You can also visit the <a href="https://waterdata.usgs.gov/nwis/inventory/?site_no=06730500" target = "_blank">USGS Site page</a> to learn more about this USGS station. 

{:.input}
```python
# Request data for the site and time period
longmont_resp = hf.get_nwis(site, 'dv', start, end)

# Convert the response to a json in order to use the extract_nwis_df function
longmont_resp = longmont_resp.json()

# Get metadata about the data
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
        {'value': '2020-03-30T22:46:25.321Z', 'title': 'requestDT'},
        {'value': '491a8a80-72d8-11ea-a38e-6cae8b663fb6', 'title': 'requestId'},
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
        'values': [{'value': [{'value': '85.0',
            'qualifiers': ['P'],
            'dateTime': '2020-03-29T00:00:00.000'}],
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
# Get the data in a pandas dataframe format
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
# Rename columns
longmont_discharge.columns = ["discharge", "flag"]

# View first 5 rows
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
# View last 5 rows of the data
# Note that the 'P' flag indicates that the data is provisional
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
      <td>9.86</td>
      <td>A</td>
    </tr>
    <tr>
      <th>2018-08-26</th>
      <td>7.02</td>
      <td>A</td>
    </tr>
    <tr>
      <th>2018-08-27</th>
      <td>4.05</td>
      <td>A</td>
    </tr>
    <tr>
      <th>2018-08-28</th>
      <td>2.67</td>
      <td>A</td>
    </tr>
    <tr>
      <th>2018-08-29</th>
      <td>3.36</td>
      <td>A</td>
    </tr>
  </tbody>
</table>
</div>






## Plot Your Data
Next, plot the time series using `matplotlib`. What do you notice?
There is an unfortunate gap in the data. The good news that while this gap may not work for some analyses, it is acceptable when you calculate a recurrence interval (based on our assumptions of independence and stationarity). 

Note that below I grab the site variable and add it to my plot title using the syntax:

`ax.set_title("Stream Discharge - Station {} \n 1946-2017".format(site))`

where `{}` is a placeholder for the variable that you want to insert into the title and `.format(site)` tells `Python` to grab and format the `site` variable that was defined above.

{:.input}
```python
# Plot using matplotlib
fig, ax = plt.subplots(figsize=(11, 6))

ax.scatter(x=longmont_discharge.index,
           y=longmont_discharge["discharge"],
           marker="o",
           s=4,
           color="purple")

ax.set(xlabel="Date", ylabel="Discharge Value (CFS)",
       title="Stream Discharge - Station {} \n {} to {}".format(site, start, end))

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-exceedance-probability-and-return-periods/2019-11-19-time-series-05-exceedance-probability-and-return-periods_19_0.png" alt = "Stream Discharge for the longmont USGS stream gage from 1946-2017">
<figcaption>Stream Discharge for the longmont USGS stream gage from 1946-2017</figcaption>

</figure>







## Annual Maxima

Next you will look at the annual maxima of both instantanoeus and mean daily streamflow. Annual maxima refers to the biggest value that occured within each year. In the case of stream discharge - this is the largest discharge value that was recorded in cubic feet per second (CFS) during each year.

There are two ways we can identify annual maxima for USGS stream gages.

1. You can take the daily mean values to construct a series of the annual maximum value. This is done using `pandas resample` - you learned how to do this in a previous lesson!
2. You can download the instantaneous annual maximum value dataset from <a href="https://nwis.waterdata.usgs.gov/nwis" target = "_blank">USGS  here</a>.

Note that you will compare the data that you download to the analysis of mean dailydata you do below. 
The instantaneous annual maxima data from the USGS is data collected every 5-30 minutes. 

The annual maxima that you derive below uses the mean daily value data that you downloaded above. Do you think you will get the same annual maxima each year?

Let's find out. 

### Add a Year Column to Your Data

Note that below you will add a 'year' column to the longmont discharge data. While this step is not necessary for resampling. It will make your life easier when you plot the data later. 

{:.input}
```python
# add a year column to your longmont discharge data
longmont_discharge["year"] = longmont_discharge.index.year

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



{:.input}
```python
# download usgs annual max data from figshare
url = "https://nwis.waterdata.usgs.gov/nwis/peak?site_no=06730500&agency_cd=USGS&format=rdb"
download_path = os.path.join("data", "colorado-flood", 
                             "downloads", "annual-peak-flow.txt")

urllib.request.urlretrieve(url, download_path)
```

{:.output}
{:.execute_result}



    ('data/colorado-flood/downloads/annual-peak-flow.txt',
     <http.client.HTTPMessage at 0x7f294ad1f250>)





{:.input}
```python
# A function that counts the number of lines with a comment 
def count_the(file_url):
    r = requests.get(file_url, stream=True)
    file = r.text
    count = 0
    for line in file:
        if line.startswith('#'):
            count += 1
    return count

# Lines to skip
line_to_skip = count_the(url)+1
```

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
# Open the data using pandas
usgs_annual_max = pd.read_csv(download_path,
                              skiprows=[line_to_skip],
                              comment="#",
                              sep='\t',
                              usecols=["peak_dt","peak_va"],
                              parse_dates=["peak_dt"],
                              index_col="peak_dt")

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
      <th>peak_va</th>
    </tr>
    <tr>
      <th>peak_dt</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1927-07-29</th>
      <td>407.0</td>
    </tr>
    <tr>
      <th>1928-06-04</th>
      <td>694.0</td>
    </tr>
    <tr>
      <th>1929-07-23</th>
      <td>530.0</td>
    </tr>
    <tr>
      <th>1930-08-18</th>
      <td>353.0</td>
    </tr>
    <tr>
      <th>1931-05-29</th>
      <td>369.0</td>
    </tr>
  </tbody>
</table>
</div>





Next, add a year column to your data for easy plotting and make sure that you have only one value per year as expected.

{:.input}
```python
# Add a year column to the data for easier plotting
usgs_annual_max["year"] = usgs_annual_max.index.year

# Are there any years that have two entries?
usgs_annual_max[usgs_annual_max.duplicated(subset="year") == True]
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
      <th>peak_va</th>
      <th>year</th>
    </tr>
    <tr>
      <th>peak_dt</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1947-10-15</th>
      <td>721.0</td>
      <td>1947</td>
    </tr>
    <tr>
      <th>1993-10-18</th>
      <td>497.0</td>
      <td>1993</td>
    </tr>
  </tbody>
</table>
</div>





It looks like you have two years that have more than one data value - 1947 and 1993. For the purpose of this exercise let's only take the largest discharge value from each year. 

{:.input}
```python
# Remove duplicate years - keep the max discharge value
usgs_annual_max = usgs_annual_max.sort_values(
    'peak_va', ascending=False).drop_duplicates('year').sort_index()

# If this returns no results you have successfully removed duplicates!
usgs_annual_max[usgs_annual_max.duplicated(subset="year") == True]
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
      <th>peak_va</th>
      <th>year</th>
    </tr>
    <tr>
      <th>peak_dt</th>
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
# Plot calculated vs USGS annual max flow values
fig, ax = plt.subplots(figsize=(11, 9))

ax.plot(usgs_annual_max["year"],
        usgs_annual_max["peak_va"],
        color="purple",
        linestyle=':',
        marker='o',
        label="Instantaneous Value")

ax.plot(longmont_discharge_annual_max["year"],
        longmont_discharge_annual_max["discharge"],
        color="lightgrey",
        linestyle=':',
        marker='o', label="Mean Daily Value")
ax.legend()
ax.set_title(
    "Annual Maxima - Downloaded Instantaneous vs. Derived Daily Peak Flows")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-exceedance-probability-and-return-periods/2019-11-19-time-series-05-exceedance-probability-and-return-periods_35_0.png" alt = "Annual maxima data compared - USGS product vs daily value calculated.">
<figcaption>Annual maxima data compared - USGS product vs daily value calculated.</figcaption>

</figure>






## Optional - Difference Bar Plot

To further more quickly explore differences between the USGS annual max data set and the annual max that you calculated using the mean daily value data, you can calculate a difference value between the USGS max value and your annual max calculated from daily mean data. You don't need to do this for your homework however! It's just setup for you to see what the differences look like. 

{:.input}
```python
# Merge the two pandas dataframes on the year column
usgs_calculated = pd.merge(longmont_discharge_annual_max,
                           usgs_annual_max,
                           left_on="year",
                           right_on="year")

# Subtract usgs values from your calculated values
usgs_calculated["diff"] = usgs_calculated["peak_va"] - \
    usgs_calculated["discharge"]
```

Once you have calculated a difference column, create a barplot. 


{:.input}
```python
# Plot difference
fig, ax = plt.subplots(figsize=(11, 6))

ax.bar(usgs_calculated["year"],
       usgs_calculated["diff"],
      color="purple")

ax.set_title(
    "Difference Plot of Annual Maxima \nInstantaneous Minus Mean Daily")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-exceedance-probability-and-return-periods/2019-11-19-time-series-05-exceedance-probability-and-return-periods_41_0.png" alt = "Bar plot showing the difference between the USGS max product and the calculated annual max.">
<figcaption>Bar plot showing the difference between the USGS max product and the calculated annual max.</figcaption>

</figure>




## Calculate Return Period

Now that you have both datasets, you are ready to calculate the return period from each. You will calculate this value and the associated probability of each event size for both the USGS max annual flow data and for the max flow value that you derived from the mean daily data.  To calculate return period you will do the following:

1.	Sort your data from smallest to largest.
2.	Calculate exceedance probabilities using the equation below where `n` is length of the record and `i` is the rank.
3.	Calculate the inverse of the exceedance probabilities to determine return period in years.
4.	Plot flood magnitudes against return time. It is common to plot these kinds of data on log-linear or log-log axes. 

****

Exceedance probability equation: 

$$Probablity = \frac{n-i+1}{n+1}$$


where i is the rank order (smallest to largest) from 1 to n. Note that the limits of this equation vary from n/(n+1) ~ 1 for the smallest events and 1/(n+1) for the largest events (i.e., the largest events have a very small exceedance probability). 

****

<i class="fa fa-star"></i> **Data Tip:** If you want to extrapolate beyond the observations that you have - for instance to predict what a 1000 year flood would be given only 100 years of data - then you would need to fit a model to the data.
{: .notice--success}

The steps that you will need to implement are below. 

{:.input}
```python
# Sort data smallest to largest
longmont_discharge_sorted = longmont_discharge.sort_values(by="discharge")

# Count total obervations
n = longmont_discharge_sorted.shape[0]

# Add a numbered column 1 -> n to use in return calculation for rank
longmont_discharge_sorted.insert(0, 'rank', range(1, 1 + n))

# Calculate probability - note you may need to adjust this value based upon the time period of your data
longmont_discharge_sorted["probability"] = (
    (n - longmont_discharge_sorted["rank"] + 1) / (n + 1))
longmont_discharge_sorted["return-years"] = (
    1 / longmont_discharge_sorted["probability"])
```

You will ultimately perform the steps above several times for both the discharge data and the precipitation data as a part of your homework. Turning these steps into a function will help you more efficiently process your data. 
An example of what this function could look like is below. For your homework, you will add documentation to this function. 

{:.input}
```python
# Create a function from the workflow below

# Add an argument for annual vs daily...


def calculate_return(df, colname):
    '''
    Add Documentation Here


    '''
    # Sort data smallest to largest
    sorted_data = df.sort_values(by=colname)
    
    # Count total obervations
    n = sorted_data.shape[0]
    
    # Add a numbered column 1 -> n to use in return calculation for rank
    sorted_data.insert(0, 'rank', range(1, 1 + n))
    
    # Calculate probability
    sorted_data["probability"] = (n - sorted_data["rank"] + 1) / (n + 1)
    
    # Calculate return - data are daily to then divide by 365?
    sorted_data["return-years"] = (1 / sorted_data["probability"])

    return(sorted_data)
```

Once you have a function, you can calculate return period and probability on both datasets.

{:.input}
```python
longmont_prob = calculate_return(longmont_discharge, "discharge")

# Because these data are daily,
# divide return period in days by 365 to get a return period in years
longmont_prob["return-years"] = longmont_prob["return-years"] / 365
longmont_prob["probability"] = longmont_prob["probability"] * 365
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
      <td>0.106831</td>
      <td>9.360548</td>
    </tr>
    <tr>
      <th>2013-09-12</th>
      <td>17079</td>
      <td>3680.0</td>
      <td>A</td>
      <td>2013</td>
      <td>0.085465</td>
      <td>11.700685</td>
    </tr>
    <tr>
      <th>2013-09-15</th>
      <td>17080</td>
      <td>3970.0</td>
      <td>A e</td>
      <td>2013</td>
      <td>0.064099</td>
      <td>15.600913</td>
    </tr>
    <tr>
      <th>2013-09-14</th>
      <td>17081</td>
      <td>4970.0</td>
      <td>A e</td>
      <td>2013</td>
      <td>0.042733</td>
      <td>23.401370</td>
    </tr>
    <tr>
      <th>2013-09-13</th>
      <td>17082</td>
      <td>8910.0</td>
      <td>A e</td>
      <td>2013</td>
      <td>0.021366</td>
      <td>46.802740</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Calculate the same thing using the USGS annual max data
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
      <th>peak_va</th>
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
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1954-01-14</th>
      <td>1</td>
      <td>26.0</td>
      <td>1954</td>
      <td>0.985075</td>
      <td>1.015152</td>
    </tr>
    <tr>
      <th>1932-07-13</th>
      <td>2</td>
      <td>128.0</td>
      <td>1932</td>
      <td>0.970149</td>
      <td>1.030769</td>
    </tr>
    <tr>
      <th>1940-07-03</th>
      <td>3</td>
      <td>174.0</td>
      <td>1940</td>
      <td>0.955224</td>
      <td>1.046875</td>
    </tr>
    <tr>
      <th>1946-07-19</th>
      <td>4</td>
      <td>178.0</td>
      <td>1946</td>
      <td>0.940299</td>
      <td>1.063492</td>
    </tr>
    <tr>
      <th>2002-05-24</th>
      <td>5</td>
      <td>238.0</td>
      <td>2002</td>
      <td>0.925373</td>
      <td>1.080645</td>
    </tr>
  </tbody>
</table>
</div>










### Plot Event Probability

Below, you plot Discharge on the x-axis and the probability that an event of that size will occur on the y-axis. 


{:.input}
```python
# Compare both datasets
fig, ax = plt.subplots(figsize=(11, 6))

usgs_annual_prob.plot.scatter(x="peak_va",
                              y="probability",
                              title="Probability ",
                              ax=ax,
                              color='purple',
                              fontsize=16,
                              logy=True,
                              label="USGS Annual Max Calculated")

longmont_prob.plot.scatter(y="probability",
                           x="discharge",
                           title="Probability ",
                           ax=ax,
                           color='grey',
                           fontsize=16,
                           logy=True,
                           label="Daily Mean Calculated")
ax.legend(frameon=True,
          framealpha=1)

ax.set_ylabel("Probability")
ax.set_xlabel("Discharge Value (CFS)")
ax.set_title(
    "Probability of Discharge Events \n USGS Annual Max Data Compared to Daily Mean Calculated Annual Max")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-exceedance-probability-and-return-periods/2019-11-19-time-series-05-exceedance-probability-and-return-periods_54_0.png" alt = "Plot showing the probability of a discharge event using both datasets. Note that the y-axis is log scaled in this plot.">
<figcaption>Plot showing the probability of a discharge event using both datasets. Note that the y-axis is log scaled in this plot.</figcaption>

</figure>




## Plot Stream Discharge Return Period

And then you plot steram dicharge vs return period. This plot shows you the frequency in years that you can expect an event of any magnitude to occur upon. But remember that this doesn't mean that this size of an event will occur every x years! The probability plot above tells you what the probability is that any event of any size might occur in any particular year. 


{:.input}
```python
fig, ax = plt.subplots(figsize=(11, 6))

longmont_prob.plot.scatter(y="discharge",
                           x="return-years",
                           title="Return Period (Years)",
                           ax=ax,
                           color='purple',
                           fontsize=16,
                           label="Daily Mean Calculated")

usgs_annual_prob.plot.scatter(y="peak_va",
                              x="return-years",
                              title="Return Period (Years)",
                              ax=ax,
                              color='grey',
                              fontsize=16,
                              label="USGS Annual Max")
ax.legend(frameon=True,
          framealpha=1)

ax.set_xlabel("Return Period (Years)")
ax.set_ylabel("Discharge Value (CFS)")

plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-05-exceedance-probability-and-return-periods/2019-11-19-time-series-05-exceedance-probability-and-return-periods_56_0.png" alt = "Plot showing the return period of a discharge event using both datasets. Note that the y-axis is log scaled in this plot.">
<figcaption>Plot showing the return period of a discharge event using both datasets. Note that the y-axis is log scaled in this plot.</figcaption>

</figure>




### References
Falcone, J. A. (2011). GAGES-II: Geospatial attributes of gages for evaluating streamflow. US Geological Survey.

Lins, H. F. (2012). USGS hydro-climatic data network 2009 (HCDN-2009). US Geological Survey Fact Sheet, 3047(4).

Yochum, S. E. (2015, April). Colorado Front Range Flood of 2013: Peak flows and flood frequencies. In Proceedings of the 3rd Joint Federal Interagency Conference on Sedimentation and Hydrologic Modeling, Reno, NV, USA (pp. 19-23).



