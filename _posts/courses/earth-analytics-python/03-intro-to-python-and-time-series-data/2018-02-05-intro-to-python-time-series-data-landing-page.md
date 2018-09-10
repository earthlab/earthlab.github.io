---
layout: single
category: courses
title: "Time Series Data in Python"
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/
week-landing: 1
week: 3
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-python"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Earth Analytics Python - Week 3!

Welcome to week {{ page.week }} of Earth Analytics! This week you will learn how to work with and plot time series data using `Python` and `Jupyter Notebooks`. You will learn how to 

1. handle different date and time fields and formats 
2. how to handle missing data and finally
3. how to subset time series data by date


## What You Need

You will need the Colorado Flood Teaching data subset and a computer with Anaconda Python 3.x and the `earth-analytics-python` environment installed to complete this lesson

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

The data that you use this week was collected by US Agency managed sensor networks and includes:

* USGS stream gage network data and
* NOAA / National Weather Service precipitation data. 

All of the data you work with were collected in Boulder, Colorado around the time of the 2013 floods.

Read the assignment below carefully. Use the class and homework lessons to help you complete the assignment.
</div>

## <i class="fa fa-calendar-check-o" aria-hidden="true"></i> Class Schedule

| time           | topic                 | speaker |  |  |
|:---------------|:----------------------------------------------------------|:--------|
|  | Review Jupyter Notebooks / Markdown / questions                   | Leah    |  
|    | Python coding session - Intro to Scientific programming with Python | Leah   |
|   | Break                                                     |         | 
|===
|   | Python coding session continued                                | Leah  |


## <i class="fa fa-pencil"></i> Homework Week 2


## Important - Data Organization

After you have downloaded the data for this week, be sure that your directory is setup as specified below.

If you are working on your computer, locally, you will need to **unzip** the zip file. 
When you do this, be sure that your directory
looks like the image below: note that all of the data are within the `colorado-flood`
directory. The data are not nested within another directory. You may have to copy
and paste your files into the correct directory to make this look right.

<figure>
<a href="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/week-02-data.jpg">
<img src="{{ site.url }}/images/courses/earth-analytics/co-flood-lessons/week-02-data.jpg" alt="Your `week_02` file directory should look like the one above. Note that
the data directly under the colorado-flood folder.">
</a>
<figcaption>Your `colorado-flood` file directory should look like the one above. Note that
the data directly under the colorado-flood folder.</figcaption>
</figure>

If you are working in the Jupyter Hub or have the earth-analytics-python environment installed on yoru computer, you can use the `earthpy` download function to access the data. Like this:

```python
import earthpy as et
et.data.get_data("colorado-flood")
```

### Why Data Organization Matters

It is important that your data are organized as specified in the lessons because:

1. When the instructors grade your assignments, we will be able to run your code if your directory looks like the instructors'.
1. It will be easier for you to follow along in class if your directory is the same as the instructors.
1. It is good practice to learn how to organize your files in a way that makes it easier for your future self to find and work with your data!

### 2. Videos

Please watch the following short videos before the start of class next week. They will help you prepare for class! 

#### The Story of Lidar Data Video
<iframe width="560" height="315" src="//www.youtube.com/embed/m7SXoFv6Sdc?rel=0" frameborder="0" allowfullscreen></iframe>

#### How Lidar Works
<iframe width="560" height="315" src="//www.youtube.com/embed/EYbhNSUnIdU?rel=0" frameborder="0" allowfullscreen></iframe>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework 2 (5 points): Due  TBD

1. Create a new Jupyter Notebook document named **youLastName-yourFirstName-time-series.ipynb**

2. Add Plots to Your Jupyter Notebook Document

Write code to create the plots described below to your Jupyter Notebook Document. Add 2-3 sentences of text below each plot in a new markdown cell that describes the contents of each plot. Use the course lessons posted on this website and the in class lectures to help. 

Please note that you will complete some of the plots assigned in the homework during class. 


### Homework Plots


#### PLOT 1:  

Use the `data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv` file to plot precipitation from 2003 to 2013 in colorado using `matplotlib`.

#### PLOT 2: 

Use the `data/colorado-flood/precipitation/805325-precip-dailysum-2003-2013.csv` file  to create a precipitation plot that shows precipitation SUBSETTED from Aug 15 - Oct 15 2013 using `matplotlib`. Make sure that `x axis` for this plot has large ticks for each new week day and small ticks for each day. Label the plot using the format `Month Date`. Each label should look like:

* `Aug 20`
* `Aug 27`

#### PLOT 3: 

Use the `data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.csv` file to create a plot of stream discharge from 1986 to 2013 using  `matplotlib`


#### PLOT 4: 

Use the `data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.csv` file to create a plot that shows stream discharge SUBSETTED from Aug 15 - Oct 15 2013 using the `matplotlib`. Make sure that x axis for this plot has large ticks for each new week day and small ticks for each day similar to plot 2 above.

* `Aug 20`
* `Aug 27`

#### PLOT 5:

Use the `data/colorado-flood/precipitation/805333-precip-daily-1948-2013.csv` file to create a plot of precipitation, summarized by daily total (sum) precipitation subsetting to Jan 1 - Oct 15 2013.
Be sure to do the following:

1. Subset the data temporally: Jan 1 2013 - Oct 15 2013.
2. Summarize the data: plot DAILY total (sum) precipitation.
3. Format the x axis with a major tick and label for every 10 years starting at 1950.

Use the [bonus lesson]({{ site.url }}/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/aggregate-time-series-data-python/) to guide you through creating this plot.

#### PLOTS 6-7

Use the `805333-precip-daily-1948-2013.csv` file to create a plot of precipitation that spans from 1948 - 2013 file.
For your plot be sure to:

* Subset the data temporally: Jan 1 2013 - Oct 15 2013.
* Make sure that x axis for this plot has large ticks for each new week day and small ticks for each day.
* Summarize the data: plot DAILY total (sum) precipitation.
* Important: be sure to set the time zone as you are dealing with dates and times which are impacted by daylight saving time. Add: tz = "America/Denver" to any statements involving time - but specifically to the line of code where you convert date / time to just a date!
* Identify an anomaly or change in the data that you can clearly see when you plot it. Then fix that anomly to make the plot more uniform. See example below for guidance!


###  Do The Following For All Plots

Make sure you have the following for each of the plots listed above:

* Label Plot axes and add titles as appropriate
* Be sure that each plot has:

    * A figure caption that describes the contents of the plot.
    * X and Y axis labels that include appropriate units.
    * A carefully composed title that describes the contents of the plot.
    * Below each plot, describe and interpret what the plot shows. Describe how the data demonstrate an impact and / or a driver of the 2013 flood event.
    * Label each plot clearly. This includes a title, x and y axis labels.

* Write Clean Code
    * Be sure that your code follows the style guidelines outlined in the [write clean code lessons]({{ site.url }}/courses/earth-analytics/time-series-data/write-clean-code-with-python/)This includes comments that document / describe the steps you take in your code and clean syntax following Hadley Wickham's style guide.

* Convert date fields as appropriate.
* Clean no data values as appropriate.
* Show all of your code in the output `.html` file.

#### HINT - Set Uniform Plot Styles 

You can specify the fonts and title sizes of all plots in a notebook using the following syntax:
```python
plt.rcParams['figure.figsize'] = (8, 8)
plt.rcParams['axes.titlesize'] = 18
plt.rcParams['axes.labelsize'] = 14
```
Above you set the figure size, title size, x and y axes labels for all plots. Give it a try!
</div>

## Report Grade Rubric

### Report Content - Text Writeup: 30%

| Full credit |   | No credit |
|:-----|:--------|:----------|
| .ipynb and html submitted  |     |   |
| Summary text is provided for each plot |   | |
| Grammar & spelling are accurate throughout the report |  |  |
| File is named with last name-first initial week 2  |   |  |
| Report contains all 4 plots described in the assignment |  |  |
| 2-3 paragraphs exist at the top of the report that summarize the conditions and the events that took place in 2013 to cause a flood that had significant impacts |  |     |
| Introductory text at the top of the document clearly describes the drivers and impacts associated with the 2013 flood event  |  |  |
|===
| Introductory text at the top of the document is organized, clear and thoughtful.  |  | |


### Report Content - Code Format: 20%

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Code is written using "clean" code practices following the Hadley Wickham style guide. This includes (but is not limited to) spaces after # tags, avoidances of `.` in variable / object names and sound object naming practices |  | |
| First markdown cell contains a title, author and date |  | |

| Code chunk contains code and runs and produces the correct output |   |  |  |


### Report Plots: 50%


#### Plot Aesthetics

All plots listed above will be reviewed for aesthetics as follows:

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Plot is labeled with a title, x and y axis label  | | |
| Plot is coded using the matplotlib library.) |  | |
| Date on the x axis is formatted as a date class for all plots  |  | |
| Missing data values have been cleaned / replaced with `NA` |   |  |
| Code to create the plot is clearly documented with comments in the html  |  | |
|===
| Plot is described and interpreted in the text of the report with reference made to how the data demonstrate an impact or driver of the flood event |  |   |
| For plots 2, 4, and 5 correctly format x axis with ticks | |

#### Plot Subsetting

Plots 2 and 4 should be temporally subsetted to the dates listed above.

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Plot 2 is temporally subsetted using to Aug 15 - Oct 15 2013 |  |  |
|===
| Plot 4 is temporally subsetted using  to Aug 15 - Oct 15 2013 |  |  |

#### Plots 6-7

| Full credit |   | No credit |
|:-----|:--------|:----------|
| Plot 6 shows a plot with the data anomoly identified and fixed |  |  |
|===
|  |  |  |

***



## Homework Plots

{:.input}
```python
monthly_max.head()
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
      <th>17663_00060_00003</th>
      <th>17663_00060_00003_cd</th>
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
      <th>1990-01-31</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>56.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1990-02-28</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>53.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1990-03-31</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>99.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1990-04-30</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>263.0</td>
      <td>A</td>
    </tr>
    <tr>
      <th>1990-05-31</th>
      <td>USGS</td>
      <td>6730200</td>
      <td>253.0</td>
      <td>A</td>
    </tr>
  </tbody>
</table>
</div>






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_6_0.png">

</figure>




{:.input}
```python
precip.head()
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
      <th>STATION</th>
      <th>STATION_NAME</th>
      <th>ELEVATION</th>
      <th>LATITUDE</th>
      <th>LONGITUDE</th>
      <th>HPCP</th>
      <th>Measurement Flag</th>
      <th>Quality Flag</th>
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
      <th>1948-08-01 01:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>0.00</td>
      <td>g</td>
      <td></td>
    </tr>
    <tr>
      <th>1948-08-02 15:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>0.05</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>1948-08-03 09:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>0.01</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>1948-08-03 14:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>0.03</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th>1948-08-03 15:00:00</th>
      <td>COOP:050843</td>
      <td>BOULDER 2 CO US</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>unknown</td>
      <td>0.03</td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
</div>






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_8_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_9_0.png">

</figure>




{:.input}
```python
# define the site number and start and end dates that you are interested in
site = "06730500"
start = '1946-05-10'
end = '2018-08-29'

# then request data for that site and time period 
longmont_resp = hf.get_nwis(site, 'dv', start, end)
# get the data in a pandas dataframe format
longmont_discharge = hf.extract_nwis_df(longmont_resp)
# rename columns
longmont_discharge.columns = ["discharge", "flag"]
# view first 5 rows
# add a year column to your longmont discharge data
longmont_discharge["year"]=longmont_discharge.index.year

# Calculate annual max by resampling
longmont_discharge_annual_max = longmont_discharge.resample('AS').max()

# download usgs annual max data from figshare
url = "https://nwis.waterdata.usgs.gov/nwis/peak?site_no=06730500&agency_cd=USGS&format=rdb"
download_path = "data/colorado-flood/downloads/annual-peak-flow.txt"
urllib.request.urlretrieve(url, download_path)
# open the data using pandas
usgs_annual_max = pd.read_csv(download_path,
                              skiprows = 63,
                              header=[1,2], 
                              sep='\t', 
                              parse_dates = [2])
# drop one level of index
usgs_annual_max.columns = usgs_annual_max.columns.droplevel(1)
# finally set the date column as the index
usgs_annual_max = usgs_annual_max.set_index(['peak_dt'])

# optional - remove columns we don't need - this is just to make the lesson easier to read
# you can skip this step if you want
usgs_annual_max = usgs_annual_max.drop(["gage_ht_cd", "year_last_pk","ag_dt", "ag_gage_ht", "ag_tm", "ag_gage_ht_cd"], axis=1)

# add a year column to the data for easier plotting
usgs_annual_max["year"] = usgs_annual_max.index.year
# remove duplicate years - keep the max discharge value
usgs_annual_max = usgs_annual_max.sort_values('peak_va', ascending=False).drop_duplicates('year').sort_index()


# calculate probability and return
longmont_prob = calculate_return(longmont_discharge, "discharge")
# Because these data are daily, divide return period in years by 365
longmont_prob["return-years"] = longmont_prob["return-years"] / 365
# calculate the same thing using the USGS annual max data
usgs_annual_prob = calculate_return(usgs_annual_max, "peak_va")


```

{:.input}
```python
## Plot of Probability - discharge 

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

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_11_0.png">

</figure>




{:.input}
```python
## Plot of Return period - discharge
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

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_12_0.png">

</figure>




{:.input}
```python
# resample to daily
boulder_daily_precip = precip.resample("D").sum()

# remove all days where rainfall == 0
#boulder_daily_precip = boulder_daily_precip[boulder_daily_precip["HPCP"] != 0]

# add a year column to your longmont discharge data
boulder_daily_precip["year"]=boulder_daily_precip.index.year

# Calculate annual max by resampling
boulder_precip_max_annual = boulder_daily_precip.resample('AS').max()


# currently this isn't working as i'd like it to 
boulder_prob_annual_max_daily = calculate_return(boulder_precip_max_annual, "HPCP")
boulder_prob_daily_total = calculate_return(boulder_daily_precip, "HPCP")
boulder_prob_daily_total["return-years"] = boulder_prob_daily_total["return-years"] / 365
```

{:.input}
```python
## Prob for precip

# this doesn't look quite right
fig, ax = plt.subplots(figsize = (11,6) )
boulder_prob_annual_max_daily.plot.scatter(x="HPCP", 
                                           y ="probability",
                                           ax=ax,
                                           color = 'purple', 
                                           fontsize = 16,
                                           label ="Annual Max Precip")
boulder_prob_daily_total.plot.scatter(x="HPCP", 
                                      y ="probability",
                                      ax=ax,
                                      color = 'grey',
                                      fontsize = 16,
                                      label = "Daily Total Precip")
ax.set_title("HW Plot xx: Probability - precipitation")
ax.legend()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_14_0.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/2018-02-05-intro-to-python-time-series-data-landing-page_15_0.png">

</figure>



