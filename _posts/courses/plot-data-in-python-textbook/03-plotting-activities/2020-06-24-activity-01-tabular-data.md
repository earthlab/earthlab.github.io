---
layout: single
title: "Activity: Practise Plotting Tabular Data Using Matplotlib and Pandas in Open Source Python"
excerpt: "Practice your skills plotting time series data stored in Pandas Data Frames in Python."
authors: ['Leah Wasser']
dateCreated: 2020-02-26
modified: 2020-09-15
category: [courses]
class-lesson: ['plot-activities']
permalink: /courses/scientists-guide-to-plotting-data-in-python/plot-activities/plot-tabular-pandas-data-python/
nav-title: 'Plot Pandas Dataframes'
module-title: 'Practice Your Python Plotting Skills'
module-description: 'This chapter provides a series of activities that allow you to practice your Python plotting skills using differen types of data.'
module-nav-title: 'Practice Plotting'
module-type: 'class'
chapter: 5
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 1
class-order: 1
course: 'scientists-guide-to-plotting-data-in-python-textbook'
topics:
  reproducible-science-and-programming:
  data-exploration-and-analysis: ['data-visualization']
---

{% include toc title="Section Three" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Five - Practice Your Plotting Skills

In this chapter, you will practice your skills creating different types of plots in **Python** using **earthpy**, **matplotlib**, and **folium**. 

</div>


<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Apply your skills in plotting time series data using matplotlib and pandas in open source Python. 

</div>


## Plot Tabular Data in Python Using Matplotlib and Pandas

There are several ways to plot tabular data in a `pandas dataframe` format. In this lesson you will practice you skills associated with plotting tabular data in `Python`. To review how to work with pandas, <a href="{{ site.baseurl }}/courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/">check out the chapter of time series data in the intermediate earth data science textbook.</a>

Below is you will find a challenge activity that you can use to practice your 
plotting skills for plot time series data using **matplotlib** and **pandas**. 
The packages that you will need to complete this activity are listed below. 


{:.input}
```python
# Import Packages
import os

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import seaborn as sns
import pandas as pd
import earthpy as et

# Add seaborn general plot specifications
sns.set(font_scale=1.5, style="whitegrid")
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Plot Precipitation Data

Use the code below to open up a precipitation dataset that contains average monthly rainfall 
in inches. Practice your plotting skills. To begin, do the following: 

1. Read in the `.csv` file called `avg-precip-months-seasons.csv`.
2. Create a basic plot using `.plot()`
3. Set an appropriate xlabel, ylabel, and plot title. 
4. Use the linestyle parameter to modify the line style to something other than solid.
5. Change the **color** to something other than the default blue. 
6. Add a **marker** parameter to the `ax.plot`. What happens when you change the marker in a line plot? 

</div>

****
<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** <a href="https://matplotlib.org/3.1.0/gallery/lines_bars_and_markers/linestyles.html" target="_blank">Check out the matplotlib documentation for various line style options.</a>

</div>



The plot below is an example of what your final plot should look like after 
completing this challenge. 


{:.input}
```python
# URL for .csv with avg monthly precip data
avg_monthly_precip_url = "https://ndownloader.figshare.com/files/12710618"

# Download file from URL
# NOTE - this csv file should download to your home directory: `~/earth-analytics/earthpy-downloads`
et.data.get_data(url=avg_monthly_precip_url)

# Set your working directory
os.chdir(os.path.join(et.io.HOME,
                      "earth-analytics",
                      "data"))
```

{:.input}
```python
precip_path = os.path.join("earthpy-downloads",
                           "avg-precip-months-seasons.csv")

precip_data = pd.read_csv(precip_path)
```


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-01-tabular-data/2020-06-24-activity-01-tabular-data_7_0.png" alt = "Line graph showing the average monthly precipitation in inches. Your final plot should look something like this.">
<figcaption>Line graph showing the average monthly precipitation in inches. Your final plot should look something like this.</figcaption>

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Bar Plot of Precipitation Data

Using the same data you used above, create a bar plot of precipitation data. 
Once again do the following: 

1. Read in the `.csv` file called `avg-precip-months-seasons.csv`.
2. Create a bar plot using `ax.bar()`
3. Set an appropriate **xlabel**, **ylabel**, and plot **title**. 
4. Use the **edgecolor** and **color** parameters to modify the colors of your plot to something other than blue.
</div>

The plot below is an example of what your final plot should look like after 
completing this challenge. 



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-01-tabular-data/2020-06-24-activity-01-tabular-data_9_0.png">

</figure>




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 3: Figure with Two Subplots of Precipitation Data

Above you created two plots:

1. a line plot of precipitation data with each point highlighted using a marker.
2. a bar plot of precipitation data.


Here, create a single figure that contains two subplots stacked on top of each other.

1. The first should be your line plot. 
2. The second should be your scatter plot. 

For the figure do the following:

1. Add an overal title to your figure using `plt.suptitle()`
2. Use `plt.tight_layout()` to make space between the two plots so that the titles and labels do nor overlap

</div>

The plot below is an example of what your final plot should look like after 
completing this challenge. 


{:.input}
```python
# Plot the data
fig, (ax1, ax2) = plt.subplots(2,1, figsize=(8, 10))
plt.suptitle("Overall Figure Title Using the Suptitle Method")
ax1.plot(precip_data.months,
        precip_data.precip,
        color="purple",
        linestyle='dashed', marker="o")

ax1.set(ylabel="Mean Precipitation (inches)",
       xlabel="Month",
       title="Plot Challenge 1\nAverage Precipitation Practice Plot")
ax2.bar(precip_data.months,
       precip_data.precip,
       color="purple",
       edgecolor="black")

ax2.set(ylabel="Mean Precipitation (inches)",
       xlabel="Month",
       title="Bar Plot Challenge 1\nAverage Precipitation Practice Plot")

plt.tight_layout()
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-01-tabular-data/2020-06-24-activity-01-tabular-data_11_0.png" alt = "Figure containing two precipitation plots created using matplotlib. The first is a typical line plot with points highlighted with circular markers. The second subplot is a bar plot of the same data. Using plt.tight_layout() ensures that the spacing between the plots makes the titles and labels readable. ">
<figcaption>Figure containing two precipitation plots created using matplotlib. The first is a typical line plot with points highlighted with circular markers. The second subplot is a bar plot of the same data. Using plt.tight_layout() ensures that the spacing between the plots makes the titles and labels readable. </figcaption>

</figure>





