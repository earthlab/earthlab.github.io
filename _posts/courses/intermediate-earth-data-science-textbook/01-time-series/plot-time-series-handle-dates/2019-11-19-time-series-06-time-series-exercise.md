---
layout: single
title: "Summary Activity for Time Series Data"
excerpt: "An activity to practice all of the skills you just learned in ."
authors: ['Leah Wasser', 'Nathan Korinek']
modified: 2020-07-15
category: [courses]
class-lesson: ['time-series-python-tb']
course: 'intermediate-earth-data-science-textbook'
week: 1
permalink: /courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/time-series-exercise/
nav-title: 'Time Series Challenges'
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  reproducible-science-and-programming: ['python']
  time-series:
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## Test Your Skills - Time Series Data In Python Using Pandas 

Now that you have learned how to open and manipulate time series data in **Python**, it's time to test your skills. Complete the activities below.
</div>

{:.input}
```python
# Import necessary packages
import os
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import DateFormatter
import seaborn as sns
import pandas as pd
import earthpy as et

# Handle date time conversions between pandas and matplotlib
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()

# Use white grid plot background from seaborn
sns.set(font_scale=1.5, style="whitegrid")
```

{:.input}
```python
# Download the data
data = et.data.get_data('colorado-flood')
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/16371473
    Extracted output to /root/earth-analytics/data/colorado-flood/.



{:.input}
```python
# Set working directory
os.chdir(os.path.join(et.io.HOME,
                      'earth-analytics',
                      'data'))

# Define relative path to file with daily discharge data
stream_discharge_path = os.path.join("colorado-flood",
                                     "discharge",
                                     "06730200-discharge-daily-1986-2013.csv")
```

<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Explore Your Data & Metadata

Before you begin working with files using **python**, it can be helpful 
to look at the structure of the file itself. In some cases, text files 
have metadata at the top of the file that tell you more about the data within 
the file itself. This information at the top of the text file can help 
you make decisions about how you plan to import the data, and what cleanup 
steps you may need to take.

Open the files `earth-analytics/data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.csv` and `earth-analytics/data/colorado-flood/discharge/06730200-discharge-daily-1986-2013.txt` by clicking on them and review their contents. Use these files to answer the questions below:

1. What is the delimiter used in `06730200-discharge-daily-1986-2013.csv`?
2. What are the units for stream discharge in the data?
3. Where was this data collected?
4. What is the frequency of the data collection (day, week, month)?
5. What does each number represent in the data (a single observation, minimum value, max value or mean value)?

Write down your answers in the cell below as a comment.

****
HINT: You may also want to explore the `README_dischargeMetadata.rtf` file located in the same directory. This file contains metadata that describes in more detail the data that you are using

</div>


<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Open and Plot a CSV File with Time Series Data

The code above creates a path (`stream_discharge_path`) to open daily stream 
discharge measurements taken by U.S. Geological Survey from 1986 to 2013 at 
Boulder Creek in Boulder, Colorado. Using **pandas**, do the following with the data:

1. Read the data into **Python** as a **pandas** `DataFrame`. 
2. Parse the dates in the `datetime` column of the **pandas** `DataFrame`.
3. Set the `datetime` as the index for your `DataFrame`.
4. Plot the newly opened data with **matplotlib**. Make sure your x-axis is the dates, and your y-axis is the `disValue` column from the **pandas** `DataFrame`.
5. Give your plot a title and label the axes.

If you need a refresher on how to plot time series data, check out [this lesson on working with time series data in Pandas.](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/)

Once you have created your plot, answer the following questions.

1. What is the max value for stream charge in the data? One what date did that value occur?
2. Consider the entire dataset. Do you see any patterns of stream discharge values in the data?
</div>

Your final plot should look like the plot below. 



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_9_0.png">

</figure>





<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 3: Subset the Data

The 2013 Colorado Flood occurred in 2013 (as the name implies). The plot above shows all of the stream discharge data over several decades. In this challenge you will subset the data to just the year and months during which the flood event occurred. 

Do the following: 
1. Subset the data to include only discharge data from August 1st, 2013 through October 31, 2013
2. Plot the newly subset data with **matplotlib**. Make sure your x-axis contains dates,  and your y-axis is contains the `disValue` column from your **pandas** `DataFrame`.
3. Give your plot a title and label the axes.
4. Format the dates on the x-axis so they only show the month and the day. Additionally, you can angle the dates using the line of code `fig.autofmt_xdate()`. 
5. Make the x-axis week ticks only show up for every other week. 

The lessons below should help you complete this challenge:

* [More on subsetting time series data using **Pandas**](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/subset-time-series-data-python/) 
* [More on customizing date labels on time series plots in **matplotlib**](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/customize-dates-matplotlib-plots-python/). 

</div>

****



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_13_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 4: Resample the Data

Next, summarize the stream discharge data by week. Additionally, you will 
clean up the format of the date labels on the x-axis. Do the following: 

1. Resample the `DataFrame` that you made above for August - October, 2013 to represent the maximum stream discharge value for each week. 
2. Plot the newly resampled data as a scatterplot (`ax.scatter()`)using `matplotlib`. Give your plot a title and label the x and y axes.
3. Format the dates on the x-axis so they only show the month and the day. Additionally, you can angle the dates using the line of code `fig.autofmt_xdate()`. 
4. Adjust the x-axis ticks and labels so you have one label and tick for **every other week**. 

****
HINT: The lessons below might help you complete this challenge:

* [Check out the Pandas time series data resampling lesson to help you resample your data.](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/resample-time-series-data-pandas-python/)
* [Check out the customize time series plots lesson to help with adjusting the x axis ticks.](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/customize-dates-matplotlib-plots-python/)
</div>

*****



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_16_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 5: Compare Two Months Side by Side

In this next challenge, you will compare daily max stream discharge for two time periods. Create a plot comparing stream discharge in  levels to the levels seen 10 years ago during the same months. Do the following: 

1. Create a data subset for the time periods:
    * August 1st, 2003 - October 31st, 2003 
    * August 1st, 2013 - October 31st, 2013 
2. Plot the data from 2003 on a plot above of the data from 2013 using `matplotlib`. 
3. Add titles to each plot and and label the x and y axes.
4. Use `fig.suptitle("title-here")` to add a title to your figure.
5. Modify the y limits of both plots to range from 0 to the max value found in the 2013 data subset. 
    * Hint: you can use `round(data-frame-name["disValue"].max(), -3)` to get the max value from your 2013 data. 
    * use `ax.set_ylim(min-value, max-value)` to set the limits
6. Format the dates on the x-axis as follows:
    * Make sure date ticks only show the month and the day - example: `Aug-06`.
    * Make the x-axis week ticks only display for every other week. 
7. Use `plt.tight_layout()` to ensure your plots don't overlap each other. 

OPTIONAL: You may have noticed empty space on either side of the x-axis in your previous plot. Use `ax.set_xlim()` to set the x limits of your plot to the minimum and maximum date values in each of your subset datasets. 
</div>


****



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_19_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge: Get Data from Hydrofunctions

There are many ways to get data into **python**. So far you have used 
`et.data.get_data()` to download your data. However you can also access 
data directly using open source tools that access API's (automated tools 
that directly access and downoad data from the data servers). 

**hydrofunctions** is an open source Python package that allows you to 
download hydrologic data from the U.S. Geological Survey. For the bonus 
challenge, you'll use **hydrofunctions** to download stream discharge data 
and plot it much like you did above. To get the data using **hydrofunctions**, 
run the code below.

```
import hydrofunctions as hf

# Define the site number and start and end dates that you are interested in
site = "06730500"
start = '1946-05-10'
end = '2018-08-29'

# Request data for that site and time period
longmont_resp = hf.get_nwis(site, 'dv', start, end)

# Convert the response to a json in order to use the extract_nwis_df function
longmont_resp = longmont_resp.json()

longmont_discharge = hf.extract_nwis_df(longmont_resp)

```

Once you have imported the  data into a **pandas** `DataFrame` using the code 
above, perform the following tasks: 

1. Rename the columns (USGS:06730500:00060:00003, USGS:06730500:00060:00003_qualifiers)) `discharge` and `flags`. This will make the data a bit easier to work with. 
2. Subset the data to the time period: `1970` through the present.
3. Resample the data to calculate the annual maximum stream discharge value for each year. 
4. Plot the data using `matplotlib`. Format the x and y axis so the labels are easy to read. Add a title to your plot.

****
HINT: if you don't know how to rename a dataframe column, try looking it up 
using a Google search!
</div>


****



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_22_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge 2: Plot Precipitation and Stream Discharge In One Figure 

For this challenge, you will open up the precipitation dataset also 
found in the `colorado-flood` download, and plot it side by side with 
discharge to see how they interact. For this challenge, you need to:

### Precipitation Data Processing

1. Open the precipitation data that you used previously (`colorado-flood/precipitation/805325-precip-daily-2003-2013.csv`) using **Pandas**.
  * Make sure the date column ("DATE") is set as the index.
  * Set the `na_values` to `999.99`. 
2. Subset the precipitation data to the time period 2013. 
3. Resample the precipitation data to provide a weekly `sum()` of all values instead of hourly. 

### Stream Discharge Data Processing

1. Subset the stream discharge data to the time period 2013.
2. Resample the discharge data provide a the weekly maximum values instead of daily. 

*******
### Plot Your Data In One Figure

* Plot the precipitation data and the discharge data as **scatter plots** stacked one on top of each other so you can compare the two visually. 
*  Format your plots  with titles, x and y axis labels. Make sure the dates are easy to read.
</div>

*****



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_25_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge 2b: Explore the Data 

Look at the two plots above. Do you notice any patterns between the max precipitation
values and the max stream discharge values?

</div>


