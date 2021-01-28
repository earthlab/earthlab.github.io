---
layout: single
title: 'GEOG 4463 & 5463 - Earth Analytics Bootcamp: Homework 3'
authors: ['Jenny Palomino']
category: courses
excerpt:
nav-title: Homework 3
modified: 2021-01-28
comments: no
permalink: /courses/earth-analytics-bootcamp/earth-analytics-bootcamp-homework-3/
author_profile: no
overview-order: 9
module-type: 'overview'
course: "earth-analytics-bootcamp"
sidebar:
  nav:
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Homework 3

For this assignment, you will create a `Jupyter Notebook` with your answers to the questions below, and submit this `Jupyter Notebook` to a Github repository for Homework 3 following the instructions below **Part 3: Submit Your Jupyter Notebook to GitHub**. 

You need to **complete this assignment (Homework 3) by Friday, August 17th at 8:00 AM (U.S. Mountain Daylight Time)**. See <a href="https://www.timeanddate.com/worldclock/fixedtime.html?iso=20180817T08&p1=1243" target="_blank">this link</a> to convert the due date/time to your local time.

This assignment will test your skills with data structures, loops, and conditional statements from Days 6, 7, and 8. 

You will be asked to work with familiar data: <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.html" target="_blank">temperature</a> and <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">precipitation</a> for various months and years of data for  Boulder, Colorado, provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed all of the lessons from Days 6, 7, and 8 for the Earth Analytics Bootcamp. Completing the challenges at the end of the lessons will also help you with this assignment. Review the lessons as needed to answer the questions.   

You will need to **`fork` and `clone` a Github repository for Homework 3** from `https://github.com/earthlab-education/ea-bootcamp-hw-3-yourusername`. You will receive an invitation to the Github repository for Homework 3 via CANVAS. 

Note: the repository will be empty, as you will add a new `Jupyter Notebook` containing your answers to the questions below. 

</div>


## Part I: Create and Modify a Jupyter Notebook

Begin by creating a new `Jupyter Notebook` in your forked repository from `https://github.com/yourusername/ea-bootcamp-hw-3-yourusername`. 

Rename the file to `firstinitial-lastname-ea-bootcamp-hw-3.ipynb` (e.g. `jpalomino-ea-bootcamp-hw-3.ipynb`). 

Note that `Git` will recognize this new `Jupyter Notebook` as a new file that can be added, committed, and pushed back to your forked repository on `Github.com`. 


### Be Sure to Add Documentation to Your Notebook (8 pts)

Start with `Markdown` cell containing a `Markdown` title for this assignment, plus an author name and date in list form. Bold the words for author and date, but do not bold your name and today's date. 

**Add a `Markdown` cell before each code cell** you create to describe the purpose of your code (e.g. what are you accomplishing by executing this code?). Think carefully about how many cells you should have to best organize your data (hint: review lessons for examples of how code can be grouped into cells).

Within code cells, **be sure to also add `Python` comments to document each code block** and **use the PEP 8 guidelines to assign appropriate variable names** that are short and concise but also clearly indicate the kind of data contained in the variable. 


### Question 1: Import Python Packages (2 pts)

In the questions below, you will be working with `numpy arrays`, and `pandas dataframes`. 

You will also be downloading files using `earthpy`, accessing directories and files on your computer using `os`, and retrieving filenames using `glob`. Last, you will also be creating plots of your data.

Import all of the necessary `Python` packages to accomplish these tasks.



{:.output}
    Downloading from https://ndownloader.figshare.com/files/12767930
    Downloading from https://ndownloader.figshare.com/files/12767933



### Question 2: Use Glob and Conditional Statements to Check for Directories (3 pts)

Use `glob` to get a list of all items in your `earth-analytics` directory.

Write and execute a conditional statement that prints a message to proceed if both of the following directories exist:

1. the `data` directory
2. the directory for your `git` repository for Homework 3 (e.g. `ea-bootcamp-hw-3-yourusername`). 


### Question 3: Download Text Files and Import Into Numpy Arrays (5 pts)

Use `earthpy` to download the following .txt and .csv files of monthly temperature (Fahrenheit) between 2005 and 2017 for Boulder, Colorado, to your `data` directory:

1. `boulder-temp-2004-to-2009.csv` from `https://ndownloader.figshare.com/files/12767972`

2. `boulder-temp-2010-to-2014.csv` from `https://ndownloader.figshare.com/files/12767960`

3. `boulder-temp-2015.txt` from `https://ndownloader.figshare.com/files/12767963`

4. `boulder-temp-2016.txt` from `https://ndownloader.figshare.com/files/12767969`

5. `boulder-temp-2017.txt` from `https://ndownloader.figshare.com/files/12767966`

Each dataset contains a row for each year specified in the dataset name and contains a column for each month (starting with January through December). 

Use the appropriate function to import each file into a new `numpy array`. 

Print your `numpy arrays`. 

**Note:** you are not required to write a loop to accomplish this task. You can follow the same process that you have before to download and import files. 


{:.output}
    Downloading from https://ndownloader.figshare.com/files/12767972
    [[35.4 33.6 48.2 49.2 59.9 62.7 69.2 66.4 62.9 51.9 39.7 36.5]
     [35.5 37.9 42.  48.4 57.6 65.4 75.1 69.7 66.2 52.6 45.  33.3]
     [40.7 33.7 39.4 53.9 61.  71.6 74.4 71.6 58.4 51.  43.4 35.3]
     [27.2 34.6 47.6 47.9 58.  67.7 74.8 73.7 64.5 55.2 44.9 30.2]
     [31.6 36.1 40.8 47.8 57.1 66.1 75.  69.6 60.9 46.  46.  31.1]
     [38.2 39.7 44.3 47.3 59.3 63.  69.6 69.6 63.1 44.5 43.8 26.7]] 
    
    Downloading from https://ndownloader.figshare.com/files/12767963
    
     [36.5 36.6 46.1 50.1 52.4 68.3 70.3 70.5 69.4 56.2 40.8 33.1]
    Downloading from https://ndownloader.figshare.com/files/12767969
    
     [34.1 40.9 43.  49.  54.1 70.5 74.  70.4 64.9 58.8 47.5 32. ]
    Downloading from https://ndownloader.figshare.com/files/12767966
    
     [32.2 42.3 50.3 48.9 55.7 68.7 73.9 69.  63.5 51.5 47.5 36.4]



### Question 4: Write Loop to Recalculate Numpy Arrays (10 pts)

Manually create a list of the `numpy arrays` imported from the **.txt** files only. 

Write and execute a loop to recalculate the values in these `numpy arrays` from Fahrenheit to Celsius. 

Recall that `Celsius = (Fahrenheit - 32) / 1.8`, and that you can print an empty line using `print("")` within your loop to create spaces between the results.

Be sure to print each `numpy array` as part of the loop. 


{:.output}
    [ 2.5         2.55555556  7.83333333 10.05555556 11.33333333 20.16666667
     21.27777778 21.38888889 20.77777778 13.44444444  4.88888889  0.61111111]
    
    [ 1.16666667  4.94444444  6.11111111  9.44444444 12.27777778 21.38888889
     23.33333333 21.33333333 18.27777778 14.88888889  8.61111111  0.        ]
    
    [ 0.11111111  5.72222222 10.16666667  9.38888889 13.16666667 20.38888889
     23.27777778 20.55555556 17.5        10.83333333  8.61111111  2.44444444]
    



### Question 5: Write Loop to Summarize Numpy Array (10 pts)

Write and execute a loop to calculate and print the **median** values of each `numpy array` from the previous question.

Hints:
1. Notice what your first step was in the previous question, before you were asked to write the loop.
2. Review how to calculate summary statistics of `numpy arrays`. 


{:.output}
    median: 51.25
    
    median: 51.55
    
    median: 50.9
    



### Question 6: Expand Your Loop to Capture Summary Statistics (10 pts)

Expand on your loop from the previous question to add each `numpy array` median value to a new list. 

Print your final list of median values. 

Hints:
1. Create an empty list to receive the median values.
2. Review how to add values to an existing list. 
3. Recall that the location of the `print()` function matters (i.e. what you receive will depend on where `print()` is placed in relationship to the loop). 


{:.output}
    [51.25, 51.55, 50.9]



### Question 7: Use Glob To Create Lists of Filenames (10 pts)

Use `glob.glob` to create a list that contains the names of .csv files you downloaded for temperature and to create a second list that contains the names of the .txt. files you downloaded for temperature.

Think about how you can distinguish these files from the others in your data directory. If you find it helpful, feel free to include conditional statements. 

Print these lists of filenames.

Hint:
1. Review how to use `glob.glob` to search by keywords and by file types.
2. Using either a relative or absolute path option will work for this question. Note that the example output below displays the absolute path option.


{:.output}
    ['boulder-temp-2015.txt', 'boulder-temp-2016.txt', 'boulder-temp-2017.txt']
    ['boulder-temp-2004-to-2009.csv']



### Question 8: Download CSV Files and Import Into Pandas Dataframes (2 pts)

Use `earthpy` to download the following .csv files of monthly precipitation (already in millimeters) between 1996 and 2017 for Boulder, Colorado, to your `data` directory:

1. `boulder-precip-1996-to-2006-months.csv` from `https://ndownloader.figshare.com/files/12767930`
    * This dataset contains a row for each year (1996 to 2006) and contains a column for each month (starting with January through December). 

2. `boulder-precip-2007-to-2017-months-seasons.csv` from `https://ndownloader.figshare.com/files/12767933`
    * This dataset contains a row for each month (starting with January through December) and contains a column for each year (2007 to 2017). 

Use the appropriate function to import each file into a new `pandas dataframe`. 

Print your `pandas dataframes`. Notice the structures of your `pandas dataframes`.

**Note:** you are not required to write a loop to accomplish this task. You can follow the same process that you have before to download and import files. 


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
      <th>Year</th>
      <th>January</th>
      <th>February</th>
      <th>March</th>
      <th>April</th>
      <th>May</th>
      <th>June</th>
      <th>July</th>
      <th>August</th>
      <th>September</th>
      <th>October</th>
      <th>November</th>
      <th>December</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1996</td>
      <td>48.006</td>
      <td>7.366</td>
      <td>54.864</td>
      <td>37.846</td>
      <td>117.602</td>
      <td>70.358</td>
      <td>49.784</td>
      <td>16.002</td>
      <td>88.392</td>
      <td>7.112</td>
      <td>36.322</td>
      <td>9.398</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1997</td>
      <td>22.098</td>
      <td>46.482</td>
      <td>23.114</td>
      <td>146.558</td>
      <td>55.626</td>
      <td>93.726</td>
      <td>28.956</td>
      <td>133.858</td>
      <td>48.768</td>
      <td>68.580</td>
      <td>38.608</td>
      <td>17.272</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1998</td>
      <td>27.178</td>
      <td>5.842</td>
      <td>86.614</td>
      <td>115.824</td>
      <td>46.228</td>
      <td>46.990</td>
      <td>102.108</td>
      <td>24.638</td>
      <td>16.764</td>
      <td>28.448</td>
      <td>38.862</td>
      <td>26.670</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1999</td>
      <td>16.510</td>
      <td>2.032</td>
      <td>27.686</td>
      <td>191.770</td>
      <td>46.736</td>
      <td>20.828</td>
      <td>64.516</td>
      <td>140.716</td>
      <td>66.548</td>
      <td>33.782</td>
      <td>20.574</td>
      <td>25.654</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2000</td>
      <td>7.366</td>
      <td>13.970</td>
      <td>65.024</td>
      <td>38.100</td>
      <td>40.640</td>
      <td>38.862</td>
      <td>53.086</td>
      <td>18.288</td>
      <td>63.754</td>
      <td>32.512</td>
      <td>22.606</td>
      <td>11.176</td>
    </tr>
    <tr>
      <th>5</th>
      <td>2001</td>
      <td>18.542</td>
      <td>21.844</td>
      <td>51.054</td>
      <td>76.708</td>
      <td>91.948</td>
      <td>27.686</td>
      <td>44.704</td>
      <td>41.656</td>
      <td>44.958</td>
      <td>10.160</td>
      <td>25.908</td>
      <td>9.144</td>
    </tr>
    <tr>
      <th>6</th>
      <td>2002</td>
      <td>27.178</td>
      <td>11.176</td>
      <td>38.100</td>
      <td>5.080</td>
      <td>81.280</td>
      <td>29.972</td>
      <td>2.286</td>
      <td>36.576</td>
      <td>38.608</td>
      <td>61.976</td>
      <td>19.812</td>
      <td>0.508</td>
    </tr>
    <tr>
      <th>7</th>
      <td>2003</td>
      <td>2.286</td>
      <td>38.608</td>
      <td>138.176</td>
      <td>75.946</td>
      <td>66.548</td>
      <td>68.326</td>
      <td>18.034</td>
      <td>89.408</td>
      <td>8.890</td>
      <td>11.430</td>
      <td>20.320</td>
      <td>21.336</td>
    </tr>
    <tr>
      <th>8</th>
      <td>2004</td>
      <td>20.828</td>
      <td>33.274</td>
      <td>27.686</td>
      <td>143.764</td>
      <td>32.512</td>
      <td>100.584</td>
      <td>87.376</td>
      <td>73.152</td>
      <td>52.578</td>
      <td>58.928</td>
      <td>50.546</td>
      <td>8.890</td>
    </tr>
    <tr>
      <th>9</th>
      <td>2005</td>
      <td>35.560</td>
      <td>7.874</td>
      <td>30.988</td>
      <td>98.044</td>
      <td>48.514</td>
      <td>68.072</td>
      <td>10.668</td>
      <td>41.402</td>
      <td>13.208</td>
      <td>71.120</td>
      <td>8.636</td>
      <td>10.922</td>
    </tr>
    <tr>
      <th>10</th>
      <td>2006</td>
      <td>11.176</td>
      <td>17.272</td>
      <td>52.832</td>
      <td>26.416</td>
      <td>28.956</td>
      <td>33.528</td>
      <td>66.802</td>
      <td>31.242</td>
      <td>31.750</td>
      <td>94.234</td>
      <td>18.796</td>
      <td>77.470</td>
    </tr>
  </tbody>
</table>
</div>






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
      <th>y2007</th>
      <th>y2008</th>
      <th>y2009</th>
      <th>y2010</th>
      <th>y2011</th>
      <th>y2012</th>
      <th>y2013</th>
      <th>y2014</th>
      <th>y2015</th>
      <th>y2016</th>
      <th>y2017</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>42.672</td>
      <td>11.684</td>
      <td>15.748</td>
      <td>7.112</td>
      <td>24.384</td>
      <td>9.652</td>
      <td>6.858</td>
      <td>42.418</td>
      <td>9.652</td>
      <td>9.398</td>
      <td>35.814</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>21.844</td>
      <td>16.002</td>
      <td>6.858</td>
      <td>34.798</td>
      <td>25.908</td>
      <td>49.276</td>
      <td>28.702</td>
      <td>17.272</td>
      <td>93.726</td>
      <td>36.576</td>
      <td>18.542</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>42.926</td>
      <td>37.338</td>
      <td>48.006</td>
      <td>83.820</td>
      <td>8.382</td>
      <td>0.254</td>
      <td>43.688</td>
      <td>41.148</td>
      <td>9.652</td>
      <td>97.536</td>
      <td>36.830</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>56.896</td>
      <td>28.702</td>
      <td>149.352</td>
      <td>92.202</td>
      <td>61.214</td>
      <td>33.274</td>
      <td>105.156</td>
      <td>47.498</td>
      <td>114.300</td>
      <td>84.836</td>
      <td>80.010</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>45.466</td>
      <td>106.934</td>
      <td>78.232</td>
      <td>68.834</td>
      <td>131.064</td>
      <td>45.212</td>
      <td>67.564</td>
      <td>112.522</td>
      <td>198.628</td>
      <td>51.054</td>
      <td>159.766</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>9.652</td>
      <td>40.132</td>
      <td>68.580</td>
      <td>85.344</td>
      <td>34.290</td>
      <td>9.652</td>
      <td>15.494</td>
      <td>21.336</td>
      <td>44.704</td>
      <td>60.198</td>
      <td>11.430</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>20.320</td>
      <td>2.286</td>
      <td>36.068</td>
      <td>58.674</td>
      <td>72.898</td>
      <td>126.746</td>
      <td>26.162</td>
      <td>116.078</td>
      <td>75.692</td>
      <td>15.494</td>
      <td>33.020</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>46.228</td>
      <td>75.438</td>
      <td>8.382</td>
      <td>27.178</td>
      <td>27.432</td>
      <td>9.144</td>
      <td>35.560</td>
      <td>40.640</td>
      <td>7.874</td>
      <td>26.924</td>
      <td>41.148</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>8</th>
      <td>September</td>
      <td>48.768</td>
      <td>46.736</td>
      <td>10.668</td>
      <td>6.350</td>
      <td>65.024</td>
      <td>57.658</td>
      <td>461.264</td>
      <td>73.152</td>
      <td>3.556</td>
      <td>11.430</td>
      <td>48.768</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>October</td>
      <td>35.052</td>
      <td>29.972</td>
      <td>82.804</td>
      <td>24.130</td>
      <td>41.910</td>
      <td>36.576</td>
      <td>56.896</td>
      <td>29.464</td>
      <td>51.308</td>
      <td>9.652</td>
      <td>61.468</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>10</th>
      <td>November</td>
      <td>11.938</td>
      <td>3.302</td>
      <td>23.622</td>
      <td>15.494</td>
      <td>24.892</td>
      <td>7.112</td>
      <td>7.366</td>
      <td>22.352</td>
      <td>46.482</td>
      <td>11.938</td>
      <td>14.478</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>December</td>
      <td>53.340</td>
      <td>33.782</td>
      <td>35.306</td>
      <td>12.192</td>
      <td>48.768</td>
      <td>12.954</td>
      <td>12.700</td>
      <td>34.798</td>
      <td>28.194</td>
      <td>23.114</td>
      <td>17.272</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





### Question 9: Create Index in Pandas Dataframe (5 pts)

Using your `pandas dataframe` for `precip-1996-to-2006-months.csv`, create a new label index based on `Year`. 


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
      <th>January</th>
      <th>February</th>
      <th>March</th>
      <th>April</th>
      <th>May</th>
      <th>June</th>
      <th>July</th>
      <th>August</th>
      <th>September</th>
      <th>October</th>
      <th>November</th>
      <th>December</th>
    </tr>
    <tr>
      <th>Year</th>
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
      <th>1996</th>
      <td>48.006</td>
      <td>7.366</td>
      <td>54.864</td>
      <td>37.846</td>
      <td>117.602</td>
      <td>70.358</td>
      <td>49.784</td>
      <td>16.002</td>
      <td>88.392</td>
      <td>7.112</td>
      <td>36.322</td>
      <td>9.398</td>
    </tr>
    <tr>
      <th>1997</th>
      <td>22.098</td>
      <td>46.482</td>
      <td>23.114</td>
      <td>146.558</td>
      <td>55.626</td>
      <td>93.726</td>
      <td>28.956</td>
      <td>133.858</td>
      <td>48.768</td>
      <td>68.580</td>
      <td>38.608</td>
      <td>17.272</td>
    </tr>
    <tr>
      <th>1998</th>
      <td>27.178</td>
      <td>5.842</td>
      <td>86.614</td>
      <td>115.824</td>
      <td>46.228</td>
      <td>46.990</td>
      <td>102.108</td>
      <td>24.638</td>
      <td>16.764</td>
      <td>28.448</td>
      <td>38.862</td>
      <td>26.670</td>
    </tr>
    <tr>
      <th>1999</th>
      <td>16.510</td>
      <td>2.032</td>
      <td>27.686</td>
      <td>191.770</td>
      <td>46.736</td>
      <td>20.828</td>
      <td>64.516</td>
      <td>140.716</td>
      <td>66.548</td>
      <td>33.782</td>
      <td>20.574</td>
      <td>25.654</td>
    </tr>
    <tr>
      <th>2000</th>
      <td>7.366</td>
      <td>13.970</td>
      <td>65.024</td>
      <td>38.100</td>
      <td>40.640</td>
      <td>38.862</td>
      <td>53.086</td>
      <td>18.288</td>
      <td>63.754</td>
      <td>32.512</td>
      <td>22.606</td>
      <td>11.176</td>
    </tr>
    <tr>
      <th>2001</th>
      <td>18.542</td>
      <td>21.844</td>
      <td>51.054</td>
      <td>76.708</td>
      <td>91.948</td>
      <td>27.686</td>
      <td>44.704</td>
      <td>41.656</td>
      <td>44.958</td>
      <td>10.160</td>
      <td>25.908</td>
      <td>9.144</td>
    </tr>
    <tr>
      <th>2002</th>
      <td>27.178</td>
      <td>11.176</td>
      <td>38.100</td>
      <td>5.080</td>
      <td>81.280</td>
      <td>29.972</td>
      <td>2.286</td>
      <td>36.576</td>
      <td>38.608</td>
      <td>61.976</td>
      <td>19.812</td>
      <td>0.508</td>
    </tr>
    <tr>
      <th>2003</th>
      <td>2.286</td>
      <td>38.608</td>
      <td>138.176</td>
      <td>75.946</td>
      <td>66.548</td>
      <td>68.326</td>
      <td>18.034</td>
      <td>89.408</td>
      <td>8.890</td>
      <td>11.430</td>
      <td>20.320</td>
      <td>21.336</td>
    </tr>
    <tr>
      <th>2004</th>
      <td>20.828</td>
      <td>33.274</td>
      <td>27.686</td>
      <td>143.764</td>
      <td>32.512</td>
      <td>100.584</td>
      <td>87.376</td>
      <td>73.152</td>
      <td>52.578</td>
      <td>58.928</td>
      <td>50.546</td>
      <td>8.890</td>
    </tr>
    <tr>
      <th>2005</th>
      <td>35.560</td>
      <td>7.874</td>
      <td>30.988</td>
      <td>98.044</td>
      <td>48.514</td>
      <td>68.072</td>
      <td>10.668</td>
      <td>41.402</td>
      <td>13.208</td>
      <td>71.120</td>
      <td>8.636</td>
      <td>10.922</td>
    </tr>
    <tr>
      <th>2006</th>
      <td>11.176</td>
      <td>17.272</td>
      <td>52.832</td>
      <td>26.416</td>
      <td>28.956</td>
      <td>33.528</td>
      <td>66.802</td>
      <td>31.242</td>
      <td>31.750</td>
      <td>94.234</td>
      <td>18.796</td>
      <td>77.470</td>
    </tr>
  </tbody>
</table>
</div>





### Question 10: Write Loop to Summarize Pandas Dataframe (10 pts)

Write and execute a loop to summarize and print each month's data in the `pandas dataframe` for `precip-1996-to-2006-months.csv`. 

Hints: 
1. It can help to create a list of month names to iterate upon. 
2. Recall the appropriate function to calculate summary statistics of `pandas dataframes`.
3. To select columns in `pandas dataframes` using implicit variables (i.e. not explicitly created by you), change the syntax from `dataframe.column_name` to `dataframe[[column_name]]`.
4. Think about the placement of `print()` in order to see the results of each iteration of your loop. 


{:.output}
             January
    count  11.000000
    mean   21.520727
    std    12.941090
    min     2.286000
    25%    13.843000
    50%    20.828000
    75%    27.178000
    max    48.006000
    
            February
    count  11.000000
    mean   18.703636
    std    14.697921
    min     2.032000
    25%     7.620000
    50%    13.970000
    75%    27.559000
    max    46.482000
    
                March
    count   11.000000
    mean    54.194364
    std     33.767344
    min     23.114000
    25%     29.337000
    50%     51.054000
    75%     59.944000
    max    138.176000
    
                April
    count   11.000000
    mean    86.914182
    std     58.408494
    min      5.080000
    25%     37.973000
    50%     76.708000
    75%    129.794000
    max    191.770000
    
                  May
    count   11.000000
    mean    59.690000
    std     27.283904
    min     28.956000
    25%     43.434000
    50%     48.514000
    75%     73.914000
    max    117.602000
    
                 June
    count   11.000000
    mean    54.448364
    std     27.357645
    min     20.828000
    25%     31.750000
    50%     46.990000
    75%     69.342000
    max    100.584000
    
                 July
    count   11.000000
    mean    48.029091
    std     31.445868
    min      2.286000
    25%     23.495000
    50%     49.784000
    75%     65.659000
    max    102.108000
    
               August
    count   11.000000
    mean    58.812545
    std     44.695248
    min     16.002000
    25%     27.940000
    50%     41.402000
    75%     81.280000
    max    140.716000
    
           September
    count  11.000000
    mean   43.110727
    std    24.616280
    min     8.890000
    25%    24.257000
    50%    44.958000
    75%    58.166000
    max    88.392000
    
             October
    count  11.000000
    mean   43.480182
    std    29.070701
    min     7.112000
    25%    19.939000
    50%    33.782000
    75%    65.278000
    max    94.234000
    
            November
    count  11.000000
    mean   27.362727
    std    12.157073
    min     8.636000
    25%    20.066000
    50%    22.606000
    75%    37.465000
    max    50.546000
    
            December
    count  11.000000
    mean   19.858182
    std    20.693384
    min     0.508000
    25%     9.271000
    50%    11.176000
    75%    23.495000
    max    77.470000
    



### Question 11: Create Plots for Specific Years  (15 pts)

Write and execute a **loop or conditional statement** that will produce two plots from your `pandas dataframe` for `precip-2007-to-2017-months-seasons.csv`: one for 2007 and one for 2013.  

Choose plot type and colors to help you tell the story of these two years, and be sure to label each plot with the appropriate title including the year.

Hints: 
1. To select columns in `pandas dataframes` using implicit variables (i.e. not explicitly created by you), change the syntax from `dataframe.column_name` to `dataframe[[column_name]]` for line and scatter plots. Note if making a bar plot, use `dataframe[column_name]`.
2. Recall that you can build a text string using the syntax `"text here" + variable + "more text here"`. 

{:.input}
```python
yearlist = ["y2007", "y2013"]

for year in yearlist:
    # set plot size for all plots that follow
    plt.rcParams["figure.figsize"] = (8, 8)

    # create the plot space upon which to plot the data
    fig, ax = plt.subplots()

    # add the x-axis and the y-axis to the plot
    ax.scatter(precip_2007_to_2017_months_seasons.months,
               precip_2007_to_2017_months_seasons[[year]], color="grey")

    # set plot title
    ax.set(title="Monthly Precipitation in " + year + " for Boulder, CO")

    # add labels to the axes
    ax.set(xlabel="Month", ylabel="Precipitation (mm)")

    # rotate tick marks on x-axis
    plt.setp(ax.get_xticklabels(), rotation=45)
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/00-course-overview/08-homework-3/08-homework-3_24_0.png">

</figure>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/00-course-overview/08-homework-3/08-homework-3_24_1.png">

</figure>




### Question 12: Discuss Plots (10 pts)

1. Why did you choose the method you used to create the plots (i.e. loops or conditional statement)?

2. Compare your plots. What do you notice about their y-axes and their precipitation values? Which year experienced the highest peak and when did it occur? 

3. Instead of creating two separate plots, what else could you do to plot these data and highlight the differences between the years as well as highlight the peak of the data? 

## Part II: Submit Your Jupyter Notebook to GitHub

To submit your `Jupyter Notebook` for Homework 3, follow the `Git`/`Github` workflow from:

1. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/">Guided Activity on Version Control with Git/GitHub</a> to add, commit, and push your `Jupyter Notebook` for Homework 3 to your forked repository for Homework 3 (`https://github.com/yourusername/ea-bootcamp-hw-3-yourusername`).

2. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request">Guided Activity to Submit Pull Request</a> to submit a pull request of your `Jupyter Notebook` for Homework 3 to the Earth Lab repository for Homework 3 (`https://github.com/earthlab-education/ea-bootcamp-hw-3-yourusername`). 
