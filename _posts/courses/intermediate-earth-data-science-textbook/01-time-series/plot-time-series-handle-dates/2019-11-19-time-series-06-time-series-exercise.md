---
layout: single
title: "Summary Activity for Time Series Data"
excerpt: "An activity to practice all of the skills you just learned in ."
authors: ['Leah Wasser', 'Nathan Korinek']
modified: 2020-06-16
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

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Read a CSV file

Before we open a file in **python**, it can be good to look at the data contained in the file. Open up the folder that was downloaded above (should be in your home directory under `earth-analytics/data/colorado-flood/discharge`. In that folder you'll see three files, `README_dischargeMetadata.rtf`, `06730200-discharge-daily-1986-2013.csv`, and `06730200-discharge-daily-1986-2013.txt`. Between these files, you should be able to find out a lot of information. Open these files in any text editor and read the data in them, and use the data to answer the following questions:


1. What is the delimiter used in `06730200-discharge-daily-1986-2013.csv`?
2. What are the units for stream discharge in the data?
3. Where was this data collected?
4. What is the frequency of the data collection (day, week, month)?
5. What does each number represent in the data (a single observation, minimum value, max value or mean value)?

Write down your answers in the cell below as a comment.


<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Open a CSV with Time Series Data and Plot the Data

The code above creates a path (`stream_discharge_path`) to open daily stream 
discharge measurements taken by U.S. Geological Survey from 1986 to 2013 at 
Boulder Creek in Boulder, Colorado. Using **pandas**, do the following with the data:

1. Read the data into **Python** as a **pandas** `DataFrame`. 
2. Parse the dates in the `datetime` column of the **pandas** `DataFrame`.
3. Set the `datetime` as the index for your `DataFrame`.
4. Plot the newly opened data with **matplotlib**. Make sure your x-axis is the dates, and your y-axis is the `disValue` column from the **pandas** `DataFrame`.
5. Give your plot a title and label the axes.

If you need a refresher on how to plot time series data, check out [this lesson on working with time series data in Pandas.](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/).

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

Since we are mostly interested in the flood data in 2013, we can focus in more closely on that data. Let's focus on the months around the event. Do the following: 
1. Subset the data to be just the discharge data from August 1st, 2013 until October 10th, 2013
2. Plot the newly subset data with **matplotlib**. Make sure your x-axis is the dates, and your y-axis is the `disValue` column from the **pandas** `DataFrame`.
3. Give your plot a title and label the axes.
4. Format the dates on the x-axis so they only show the month and the day. Additionally, you can angle the dates using the line of code `fig.autofmt_xdate()`. 
5. Make the x-axis week ticks only show up for every other week. 

If you need help, see [this lesson](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/subset-time-series-data-python/) for more information regarding sub-setting **pandas** `DataFrames`, and [this lesson](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/customize-dates-matplotlib-plots-python/) for more information about customizing your date ticks in **matplotlib**. 
</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_12_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 4: Resample the Data

Daily data might be to much information for this chart. Let's summarize the data by week and see if there's more clarity. Additionally, let's clean up the dates formatting on the x-axis. Do the following: 

1. Resample your dataframe that you made for the 3 months of data to be the maximum value by week. 
2. Plot the newly resampled data with `matplotlib`. Give your plot a title and label the axes.
3. Make your plot a scatter plot to better demonstrate the data.
4. Format the dates on the x-axis so they only show the month and the day. Additionally, you can angle the dates using the line of code `fig.autofmt_xdate()`. 
5. Make the x-axis week ticks only show up for every other week. 

If you need help, see [this lesson](https://www.earthdatascience.org/courses/use-data-open-source-python/use-time-series-data-in-python/date-time-types-in-pandas-python/resample-time-series-data-pandas-python/) for more information regarding resampling your data.
</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_15_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 5: Compare Two Months Side by Side

The weekly data didn't seem to be very informative, so let's use the daily data once again. In order to see how significant these discharge levels are, create a plot comparing these levels to the levels seen 10 years ago during the same months. Do the following: 

1. Create another subset of data to be the discharge data from August 1st, 2003 until October 10th, 2003 
2. Plot the data from 2003 on a plot next to the data from 2013 using `matplotlib`. Give your plots titles and label the axes.
3. Modify the y limits of the 2003 plot to match the y limits of the 2013 plot. (Hint: you can use `ax.get_ylim()` and `ax.set_ylim()` to accomplish this). 
4. You may have noticed empty space on either side of the data in your previous plot. Use `ax.set_xlim()` to set the x limits of your plot to the minimum and maximum date values in each of your subset datasets. 
5. Format the dates on the x-axis so they only show the month and the day. Angle the dates to increase legibility as well. 
6. Make the x-axis week ticks only show up for every other week. 
7. Use `plt.tight_layout()` to ensure your plots don't overlap each other. 

</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_18_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge: Get Data from Hydrofunctions

There are many ways to get data into **python**. So far we've been using `et.data.get_data()` to download our data. There is another open source repository called **hydrofunctions** that can be used to download hydrologic data from the U.S. Geological Survey. For the bonus challenge, you'll be using **hydrofunctions** to download discharge data and plot it much like you did above. To get the data using **hydrofunctions**, run the code below.

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

Once you have the data into a **pandas** `DataFrame` using the code above, perform the following tasks: 

1. Rename the columns to be called `discharge` and `flags`.
2. Subset the data to be only data from `1970` and onwards.
3. Resample the data to be the annual maximum for each year. 
4. Plot the data using `matplotlib`. 

</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_21_0.png">

</figure>




<div class="notice--warning alert alert-info" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge 2: Plotting Precipitation and Discharge Side by Side 

For this challenge, you will open up the precipitation dataset also found in the `colorado-flood` download, and plot it side by side with discharge to see how they interact. For this challenge, you need to:

1. Open the precipitation data in Pandas (the path is provided for you).
2. Parse the date column ("DATE") and set it as the index.
3. Set the `na_values` to `999.99`. 
4. Subset the data to just be for the year 2013. 
5. Subset the stream discharge data to be for the year 2013.
6. Resample the discharge datset to be the weekly maximum values instead of daily. 
7. Resample the precipitation datset to be the weekly sum of all values instead of hourly. 
8. Plot the precipitation data and the discharge data side by side so we can see how the two compare. Use scatter plots. 
9. Format your plots are we were doing before so they look good. Date formatting is up to you!
</div>



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intermediate-earth-data-science-textbook/01-time-series/plot-time-series-handle-dates/2019-11-19-time-series-06-time-series-exercise/2019-11-19-time-series-06-time-series-exercise_24_0.png">

</figure>



