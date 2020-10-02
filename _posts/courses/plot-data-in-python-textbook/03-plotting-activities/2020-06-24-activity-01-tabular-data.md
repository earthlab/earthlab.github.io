---
layout: single
title: "Activity: Practice Plotting Tabular Data Using Matplotlib and Pandas in Open Source Python"
excerpt: "Practice your skills plotting time series data stored in Pandas Data Frames in Python."
authors: ['Leah Wasser']
dateCreated: 2020-09-15
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

* Apply your skills in plotting tabular (shreadsheet format) data using matplotlib and pandas in open source Python. 

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

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12710618



{:.input}
```python
precip_path = os.path.join("earthpy-downloads",
                           "avg-precip-months-seasons.csv")

precip_data = pd.read_csv(precip_path)
precip_data
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

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-01-tabular-data/2020-06-24-activity-01-tabular-data_9_0.png" alt = "Challenge two plot. Bar plot of average monthly precipitation using matplotlib.">
<figcaption>Challenge two plot. Bar plot of average monthly precipitation using matplotlib.</figcaption>

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




<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge 4: Plot Grouped Data

There are differents ways to go about plotting grouped data with a legend
using pandas. Below you will walk through an approach to plot your precip
data by season using: 

1. **matplotlib**
2. and a grouped **pandas dataframe**

To achieve this plot, you will do the following:

1. Create a for loop which groups for your pandas dataframe
2. Create a figure as you would normally do using `fig, ax = plt.subplots()`
3. Add a legend to your plot using `plt.legend()`

In each iteration of the for loop, you will specify the label (which is the group by object - 
in this case the **seasons** column). Your code will look something likee the code below:

```
for label, df in precip_data.groupby("seasons"):
    ax.plot(df.months,
            df.precip,
            "o",
            # The label is the season or the group by object in this case
            label=label)
            
```

</div>

HINT:

You can create a dictionary that maps categories (seasons in this case) to 
colors - like this:

```python
colors = {"Winter": "lightgrey",
          "Spring": "green",
          "Summer": "darkgreen",
          "Fall": "brown"}
```

you can then call each color using `colors[label]` where the label is season
in this example and the `colors` object is the dictionary that you created above:


```
for label, df in precip_data.groupby("seasons"):
    ax.plot(df.months,
            df.precip,
            "o",
            # The label is the season or the group by object in this case
            label=label,
            color=colors[label])
            
```

### Understanding For Loops

To break down the for loop it can be helpful to print the two variables
being created in each iteration. Below you create a label object which
contains the label or word that is being used to group the data. 
In this case the label is "season". 

{:.input}
```python
# Print each label object which is the group by category - season
for label, df in precip_data.groupby("seasons"):
    print(label)
```

{:.output}
    Fall
    Spring
    Summer
    Winter



Next you can print each group by object - the `df` object. This 
object represents the dataframe subsetted by the specific season.

{:.input}
```python
# Print each grouped data
for label, df in precip_data.groupby("seasons"):
    print(df)
```

{:.output}
       months  precip seasons
    8    Sept    1.84    Fall
    9     Oct    1.31    Fall
    10    Nov    1.39    Fall
      months  precip seasons
    2    Mar    1.85  Spring
    3    Apr    2.93  Spring
    4    May    3.05  Spring
      months  precip seasons
    5   June    2.02  Summer
    6   July    1.93  Summer
    7    Aug    1.62  Summer
       months  precip seasons
    0     Jan    0.70  Winter
    1     Feb    0.75  Winter
    11    Dec    0.84  Winter



Create your final challenge plot of the precipitation data colored by season.
Modify the **colors** used to plot each season. The plot below is an example of what your final plot should look like after 
completing this challenge. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/plot-data-in-python-textbook/03-plotting-activities/2020-06-24-activity-01-tabular-data/2020-06-24-activity-01-tabular-data_17_0.png" alt = "Plot of precipitation data grouped and colored by season with a legend.">
<figcaption>Plot of precipitation data grouped and colored by season with a legend.</figcaption>

</figure>



