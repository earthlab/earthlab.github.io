---
layout: single
title: "How a Hundred Year Flood Can Occur Every Year. Calculate Exceedance Probability and Return Periods in Python"
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
order: 8
topics:
---

{:.input}
```python
# import libraries
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

{:.input}
```python
boulder_precip = pd.read_csv("data/colorado-flood/precipitation/805333-precip-daily-1948-2013.csv", 
                             parse_dates = ["DATE"],
                             index_col = ["DATE"], 
                             na_values = ['999.99'])
# resample to daily
boulder_precip_daily = boulder_precip.resample("D").sum()
boulder_precip_daily.head()

# remove all days where rainfall == 0
# if you do this - then you end up with a shorter return-period span given some of the data are missing.
# this makes me wonder about dividig by 365 ... is there some way to ensure the data return span the time period even if there is no daily value for some days?
# boulder_precip_daily = boulder_precip_daily[boulder_precip_daily["HPCP"] != 0]
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
      <th>HPCP</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1948-08-01</th>
      <td>0.00</td>
    </tr>
    <tr>
      <th>1948-08-02</th>
      <td>0.05</td>
    </tr>
    <tr>
      <th>1948-08-03</th>
      <td>0.07</td>
    </tr>
    <tr>
      <th>1948-08-04</th>
      <td>0.14</td>
    </tr>
    <tr>
      <th>1948-08-05</th>
      <td>0.02</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# plot using matplotlib
fig, ax = plt.subplots(figsize = (11,6))
ax.scatter(x=boulder_precip_daily.index, 
        y=boulder_precip_daily["HPCP"], 
        marker="o",
        s=4, 
        color ="purple")
ax.set_xlabel("Date")
ax.set_ylabel("Precipitation (mm?)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/precip-exceedance-probability-and-return-periods_3_0.png">

</figure>




{:.input}
```python
#
# MAR - Mean Annual Runoff
boulder_precip_daily["cum-sum-rain"] = boulder_precip_daily['HPCP'].cumsum()
boulder_precip_daily.head()
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
      <th>HPCP</th>
      <th>cum-sum-rain</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1948-08-01</th>
      <td>0.00</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>1948-08-02</th>
      <td>0.05</td>
      <td>0.05</td>
    </tr>
    <tr>
      <th>1948-08-03</th>
      <td>0.07</td>
      <td>0.12</td>
    </tr>
    <tr>
      <th>1948-08-04</th>
      <td>0.14</td>
      <td>0.26</td>
    </tr>
    <tr>
      <th>1948-08-05</th>
      <td>0.02</td>
      <td>0.28</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
boulder_precip.head()
fig, ax = plt.subplots(figsize=(11,7))
ax.scatter(x=boulder_precip_daily.index, 
        y=boulder_precip_daily["HPCP"], 
        marker="o",
        s=4, 
        color ="purple", label="Daily Total")
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/precip-exceedance-probability-and-return-periods_5_0.png">

</figure>




{:.input}
```python
fig, ax = plt.subplots(figsize=(11,7))
ax.plot(boulder_precip_daily.index, 
        boulder_precip_daily["cum-sum-rain"], 'b-',
        label = "Cumulative Rainfall")
# boulder_precip["cum-sum-rain"].plot(ax=ax, 
#                                     label = "Cumulative Rainfall")
ax.set_ylabel('Cumulative Precipitation (mm)', color='b')
ax.tick_params('y', colors='b')

ax2 = ax.twinx()
ax2.scatter(x=boulder_precip_daily.index, 
        y=boulder_precip_daily["HPCP"], 
        marker="o",
        s=4, 
        color ="purple", label="Daily Total")
ax2.set_ylabel('Precipitation (mm)', color='purple')
ax2.tick_params('y', colors='purple')
#ax2.set_ylim(0,10000)
ax.set_title("Cumulative Sum & Daily Mean Rainfall")
ax.legend()
ax2.legend(loc = "upper left", bbox_to_anchor=(0.0, 0.9))
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/precip-exceedance-probability-and-return-periods_6_0.png">

</figure>




{:.input}
```python
# add a year column to your longmont discharge data
boulder_precip_daily["year"]=boulder_precip_daily.index.year

# Calculate annual max by resampling
boulder_precip_max_annual = boulder_precip_daily.resample('AS').max()
boulder_precip_max_annual.head()
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
      <th>HPCP</th>
      <th>cum-sum-rain</th>
      <th>year</th>
    </tr>
    <tr>
      <th>DATE</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1948-01-01</th>
      <td>0.55</td>
      <td>2.93</td>
      <td>1948</td>
    </tr>
    <tr>
      <th>1949-01-01</th>
      <td>2.16</td>
      <td>21.57</td>
      <td>1949</td>
    </tr>
    <tr>
      <th>1950-01-01</th>
      <td>2.00</td>
      <td>35.00</td>
      <td>1950</td>
    </tr>
    <tr>
      <th>1951-01-01</th>
      <td>4.90</td>
      <td>60.67</td>
      <td>1951</td>
    </tr>
    <tr>
      <th>1952-01-01</th>
      <td>1.84</td>
      <td>76.23</td>
      <td>1952</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# plot data
fig, ax = plt.subplots(figsize = (10,6))
ax.scatter(x=boulder_precip_max_annual["year"], 
           y=boulder_precip_max_annual["HPCP"], 
                     color="purple")
ax.set_title("Annual Maximum Daily Total Precipitation - Boulder, Colorado");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/precip-exceedance-probability-and-return-periods_8_0.png">

</figure>





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
      <th>HPCP</th>
      <th>cum-sum-rain</th>
      <th>year</th>
      <th>probability</th>
      <th>return-years</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>1967-08-30</th>
      <td>23890</td>
      <td>3.09</td>
      <td>328.14</td>
      <td>1967</td>
      <td>0.000209</td>
      <td>13.093151</td>
    </tr>
    <tr>
      <th>1969-05-06</th>
      <td>23891</td>
      <td>3.33</td>
      <td>359.40</td>
      <td>1969</td>
      <td>0.000167</td>
      <td>16.366438</td>
    </tr>
    <tr>
      <th>1951-08-03</th>
      <td>23892</td>
      <td>4.90</td>
      <td>51.13</td>
      <td>1951</td>
      <td>0.000126</td>
      <td>21.821918</td>
    </tr>
    <tr>
      <th>2013-09-11</th>
      <td>23893</td>
      <td>6.40</td>
      <td>1151.13</td>
      <td>2013</td>
      <td>0.000084</td>
      <td>32.732877</td>
    </tr>
    <tr>
      <th>2013-09-12</th>
      <td>23894</td>
      <td>7.30</td>
      <td>1158.43</td>
      <td>2013</td>
      <td>0.000042</td>
      <td>65.465753</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
fig, ax = plt.subplots(figsize = (11,6) )
boulder_prob_annual_max_daily.plot.scatter(y ="probability", x="HPCP", 
                          title = "Probability ", ax=ax,
                          color = 'purple', fontsize = 16, 
                          logy=True)
boulder_prob_daily_total.plot.scatter(y ="probability", x="HPCP", 
                                title = "Probability ", 
                                ax=ax, logy=True)
ax.set_ylabel("Probability")
ax.set_xlabel("Precipitation (in?)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/precip-exceedance-probability-and-return-periods_10_0.png">

</figure>




# make this plot interactive so they can see the dates!

{:.input}
```python
boulder_prob_annual_max_daily.tail()
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
      <th>HPCP</th>
      <th>cum-sum-rain</th>
      <th>year</th>
      <th>probability</th>
      <th>return-years</th>
    </tr>
    <tr>
      <th>DATE</th>
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
      <th>1997-01-01</th>
      <td>62</td>
      <td>3.00</td>
      <td>892.23</td>
      <td>1997</td>
      <td>0.074627</td>
      <td>13.400000</td>
    </tr>
    <tr>
      <th>1967-01-01</th>
      <td>63</td>
      <td>3.09</td>
      <td>333.94</td>
      <td>1967</td>
      <td>0.059701</td>
      <td>16.750000</td>
    </tr>
    <tr>
      <th>1969-01-01</th>
      <td>64</td>
      <td>3.33</td>
      <td>379.49</td>
      <td>1969</td>
      <td>0.044776</td>
      <td>22.333333</td>
    </tr>
    <tr>
      <th>1951-01-01</th>
      <td>65</td>
      <td>4.90</td>
      <td>60.67</td>
      <td>1951</td>
      <td>0.029851</td>
      <td>33.500000</td>
    </tr>
    <tr>
      <th>2013-01-01</th>
      <td>66</td>
      <td>7.30</td>
      <td>1164.23</td>
      <td>2013</td>
      <td>0.014925</td>
      <td>67.000000</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# this doesn't look quite right
fig, ax1 = plt.subplots(figsize = (11,6) )
boulder_prob_annual_max_daily.plot.scatter(x="return-years", 
                          y ="HPCP",  
                          title = "Probability ", ax=ax1,
                          color = 'purple', fontsize = 16)
boulder_prob_daily_total.plot.scatter(x= "return-years", 
                                y ="HPCP",
                                title = "Probability ", ax=ax1,
                                color = 'grey', fontsize = 16)

ax.set_ylabel("Probability")
ax.set_xlabel("Discharge Value (CFS)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/plot-time-series-handle-dates/precip-exceedance-probability-and-return-periods_13_0.png">

</figure>




This is where i got the precip data from... it's only available through 2013... can i get up to date data?
# https://www.ncdc.noaa.gov/cdo-web/datasets/PRECIP_HLY/locations/CITY:US080001/detail

https://www.ncdc.noaa.gov/homr/#ncdcstnid=20003803&tab=PHR
i may have to be ok with not having data for the entire period... that is ok..
