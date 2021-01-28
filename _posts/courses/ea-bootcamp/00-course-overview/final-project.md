---
layout: single
title: 'GEOG 4463 & 5463 - Earth Analytics Bootcamp: Final Project'
authors: ['Jenny Palomino']
category: courses
excerpt:
nav-title: Final Project
modified: 2021-01-28
comments: no
permalink: /courses/earth-analytics-bootcamp/earth-analytics-bootcamp-final-project/
author_profile: no
overview-order: 11
module-type: 'overview'
course: "earth-analytics-bootcamp"
sidebar:
  nav:
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Final Project

For this assignment, you will create a `Jupyter Notebook` with your answers to the questions below, and submit this `Jupyter Notebook` to a `Github` repository for the Final Project following the instructions below **Part II: Submit Your Jupyter Notebook to GitHub**. 

### Structure of Final Project

In your `Jupyter Notebook`, provide your answers for **Sections 1 AND 2** and then choose **one option for Section 3: either option A or B**. Indicate in your `Markdown` documentation which option you have chosen for Section 3.

For all sections, you will be asked to use data on fire occurrence in California from 1992 to 2015 provided by <a href="https://www.fs.usda.gov/rds/archive/catalog/RDS-2013-0009.4/" target="_blank">the United States Forest Service</a>.

### Due Date 

You need to **complete this assignment (Final Project) by Sunday, August 26th at 8:00 AM (U.S. Mountain Daylight Time)**. See <a href="https://www.timeanddate.com/worldclock/fixedtime.html?iso=20180826T08&p1=1243" target="_blank">this link</a> to convert the due date/time to your local time.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed all of the lessons from the Earth Analytics Bootcamp. Completing the challenges at the end of the lessons will also help you with this assignment. Review the lessons as needed to answer the questions.   

You will need to **`fork` and `clone` a Github repository for the Final Project** from `https://github.com/earthlab-education/ea-bootcamp-final-project-yourusername`. You will receive an invitation to the Github repository for the Final Project via CANVAS. 

Note: the repository will be empty, as you will add a new `Jupyter Notebook` containing your answers to the questions below. 

</div>

### Be Sure to Add Documentation to Your Notebook

### Use Markdown Titles to Document Workflow (5 pts)

Start with `Markdown` cell containing a `Markdown` title for this assignment, plus an author name and date in list form. Bold the words for author and date, but do not bold your name and today's date. 

**Add a `Markdown` title** (`## Title`) and some text before each code cell to identify each question. 

Describe the purpose of your code (e.g. what are you accomplishing by executing this code?). Think carefully about how many cells you should have to best organize your data (hint: review lessons for examples of how code can be grouped into cells).

### Use Python Comments to Document Code and Functions (5 pts)

Within code cells, **be sure to also add `Python` comments to document each code block** and **use the PEP 8 guidelines to assign appropriate variable names** that are short and concise but also clearly indicate the kind of data contained in the variable. 

Be sure to add documentation within your functions using `Python` comments to tell the user what the function is doing and and what inputs it can take. 

Also, be sure to use clear function names that tell the user what the function does. If you find it useful, you can review the <a href="{{ site.url }}/courses/earth-analytics-bootcamp/pep-8-style-guide/">Earth Analytics Bootcamp reference page on PEP8 Style Guide</a>. 

### Import Python Packages (1 pt)

In the questions below, you will be working with `numpy arrays` and `pandas dataframes`. 

You will also be downloading files using `earthpy` and accessing directories and files on your computer using `os`. Last, you will also be creating plots of your data.

Import all of the necessary `Python` packages to accomplish these tasks.


## Section 1: Questions 1-10 Using Pandas Dataframes

### Get Data

Use `earthpy` to download the following .csv file of fires in California and import the data to a `pandas dataframe`:

1. `CA_fires_1992_2015_gt_100_acres.csv` from `https://ndownloader.figshare.com/files/12835340`

The data contains one record for every fire greater than 100 acres that occurred between 1992 and 2015. The dataset has columns for the size of the fire (acres) and for the year and month of the fire, along with other details about the cause, reporting agency, county name, etc. 


{:.output}
    Downloading from https://ndownloader.figshare.com/files/12835340



### Question 1: Explore Structure of the Pandas Dataframe (2 pts)

Use the appropriate functions to print the first few rows of the pandas dataframe and the last few rows of the dataframe. 

Note: as this dataframe contains many records, it is not helpful to print the whole dataframe.


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
      <th>fd_unq_id</th>
      <th>source_reporting_unit_name</th>
      <th>fire_name</th>
      <th>year</th>
      <th>month</th>
      <th>month_num</th>
      <th>cause</th>
      <th>fire_size</th>
      <th>fire_size_class</th>
      <th>state</th>
      <th>county</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1338131</td>
      <td>Mendocino Unit</td>
      <td>VANN</td>
      <td>1992</td>
      <td>February</td>
      <td>2</td>
      <td>Equipment Use</td>
      <td>120.0</td>
      <td>D</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>216388</td>
      <td>Yuma Field Office</td>
      <td>WALTERS</td>
      <td>1992</td>
      <td>March</td>
      <td>3</td>
      <td>Debris Burning</td>
      <td>1800.0</td>
      <td>F</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>218766</td>
      <td>California Desert District</td>
      <td>MESA</td>
      <td>1992</td>
      <td>April</td>
      <td>4</td>
      <td>Equipment Use</td>
      <td>4200.0</td>
      <td>F</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1373316</td>
      <td>CDF - San Bernardino Unit</td>
      <td>COLLINS</td>
      <td>1992</td>
      <td>April</td>
      <td>4</td>
      <td>Arson</td>
      <td>125.0</td>
      <td>D</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1373321</td>
      <td>CDF - San Bernardino Unit</td>
      <td>COVINGTON</td>
      <td>1992</td>
      <td>April</td>
      <td>4</td>
      <td>Arson</td>
      <td>104.0</td>
      <td>D</td>
      <td>CA</td>
      <td>NaN</td>
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
      <th>fd_unq_id</th>
      <th>source_reporting_unit_name</th>
      <th>fire_name</th>
      <th>year</th>
      <th>month</th>
      <th>month_num</th>
      <th>cause</th>
      <th>fire_size</th>
      <th>fire_size_class</th>
      <th>state</th>
      <th>county</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>4096</th>
      <td>300308392</td>
      <td>Butte Unit</td>
      <td>RICHVALE</td>
      <td>2015</td>
      <td>October</td>
      <td>10</td>
      <td>Equipment Use</td>
      <td>250.0</td>
      <td>D</td>
      <td>CA</td>
      <td>Butte</td>
    </tr>
    <tr>
      <th>4097</th>
      <td>300308084</td>
      <td>CDF - San Benito-Monterey Unit</td>
      <td>CIENEGA</td>
      <td>2015</td>
      <td>October</td>
      <td>10</td>
      <td>Miscellaneous</td>
      <td>690.0</td>
      <td>E</td>
      <td>CA</td>
      <td>San Benito</td>
    </tr>
    <tr>
      <th>4098</th>
      <td>300209443</td>
      <td>Sequoia And Kings Canyon National Parks</td>
      <td>BURNT</td>
      <td>2015</td>
      <td>October</td>
      <td>10</td>
      <td>Lightning</td>
      <td>161.0</td>
      <td>D</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4099</th>
      <td>300293910</td>
      <td>Colorado River Agency</td>
      <td>HIGHWAY</td>
      <td>2015</td>
      <td>November</td>
      <td>11</td>
      <td>Missing/Undefined</td>
      <td>323.0</td>
      <td>E</td>
      <td>CA</td>
      <td>Riverside</td>
    </tr>
    <tr>
      <th>4100</th>
      <td>300293894</td>
      <td>Ventura County Fire Department</td>
      <td>SOLIMAR</td>
      <td>2015</td>
      <td>December</td>
      <td>12</td>
      <td>Missing/Undefined</td>
      <td>1288.0</td>
      <td>F</td>
      <td>CA</td>
      <td>Ventura</td>
    </tr>
  </tbody>
</table>
</div>





### Question 2: Summarize Fire Size (4 pts)

Use the appropriate function to calculate summary statistics of **only** the fire size (acres). 

In your `Markdown` documentation for this question, write a sentence or two stating: 
* the mean, minimum, and maximum fire size (acres) in this dataset. 
* the total number of fires in this dataset.

Hints:
* It can helpful to determine how to select the data you need first before summarizing it.
* You can also review how to run summary statistics on a specific column in a `pandas dataframe`.


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
      <th>fire_size</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>4101.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>2995.314133</td>
    </tr>
    <tr>
      <th>std</th>
      <td>13481.045403</td>
    </tr>
    <tr>
      <th>min</th>
      <td>100.100000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>180.000000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>354.000000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1155.000000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>315578.800000</td>
    </tr>
  </tbody>
</table>
</div>





### Question 3: Calculate Total Number of Fires For Each Year (4 pts)

Use the appropriate function to calculate the total number of fires per year, and save as a new dataframe. 

Note: the displayed data below only shows the first few rows in the dataset. 

Hints:
* Review the use of `groupby` to run statistics on `pandas dataframes`.
* Think about what value you want to use to group the data and what value you want to use to determine the total number of fires.


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
      <th>fd_unq_id</th>
    </tr>
    <tr>
      <th>year</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1992</th>
      <td>237</td>
    </tr>
    <tr>
      <th>1993</th>
      <td>187</td>
    </tr>
    <tr>
      <th>1994</th>
      <td>201</td>
    </tr>
    <tr>
      <th>1995</th>
      <td>189</td>
    </tr>
    <tr>
      <th>1996</th>
      <td>333</td>
    </tr>
  </tbody>
</table>
</div>





### Question 4: Reset Index (2 pts)

Use the appropriate function to reset the index of the dataframe created in the previous question, so that the year returns to being a column. Save the reset dataframe as a new dataframe.

Note: the displayed data below only shows the first few rows in the dataset.


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
      <th>fd_unq_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1992</td>
      <td>237</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1993</td>
      <td>187</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1994</td>
      <td>201</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1995</td>
      <td>189</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1996</td>
      <td>333</td>
    </tr>
  </tbody>
</table>
</div>





### Question 5: Plot Total Number of Fires For Each Year (2 pts)

Create a plot of your choice (i.e. type, color) that displays the total number of fires for each year of data.

Be sure to label your x- and y-axes appropriately and give your plot an appropriate title. 

Hint:
* Think about which dataframe you want to use for the plot and what data you need to plot. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/00-course-overview/final-project/final-project_15_0.png" alt = "This plot displays an example plot of total number of fires each year in California for 1992-2015.">
<figcaption>This plot displays an example plot of total number of fires each year in California for 1992-2015.</figcaption>

</figure>




### Question 6: Convert Units For Fire Size (4 pts)

Write a **function** to convert the units of fire size from acres to hectares (i.e. a standard unit that represents 10,000 square meters). One hectare is equal to 2.47105 acres. 


### Question 7: Apply Function to Column (4 pts)

Run the function you created in the previous question to convert the units of the fire size in your `pandas dataframe` from acres to hectares. 

Use the appropriate function to print only the first few rows to display the converted data. 

Hint: 
* Review how to apply a function to a column in a pandas dataframe.


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
      <th>fd_unq_id</th>
      <th>source_reporting_unit_name</th>
      <th>fire_name</th>
      <th>year</th>
      <th>month</th>
      <th>month_num</th>
      <th>cause</th>
      <th>fire_size</th>
      <th>fire_size_class</th>
      <th>state</th>
      <th>county</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1338131</td>
      <td>Mendocino Unit</td>
      <td>VANN</td>
      <td>1992</td>
      <td>February</td>
      <td>2</td>
      <td>Equipment Use</td>
      <td>48.562352</td>
      <td>D</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>216388</td>
      <td>Yuma Field Office</td>
      <td>WALTERS</td>
      <td>1992</td>
      <td>March</td>
      <td>3</td>
      <td>Debris Burning</td>
      <td>728.435281</td>
      <td>F</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>218766</td>
      <td>California Desert District</td>
      <td>MESA</td>
      <td>1992</td>
      <td>April</td>
      <td>4</td>
      <td>Equipment Use</td>
      <td>1699.682321</td>
      <td>F</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1373316</td>
      <td>CDF - San Bernardino Unit</td>
      <td>COLLINS</td>
      <td>1992</td>
      <td>April</td>
      <td>4</td>
      <td>Arson</td>
      <td>50.585783</td>
      <td>D</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1373321</td>
      <td>CDF - San Bernardino Unit</td>
      <td>COVINGTON</td>
      <td>1992</td>
      <td>April</td>
      <td>4</td>
      <td>Arson</td>
      <td>42.087372</td>
      <td>D</td>
      <td>CA</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>





### Question 8: Calculate Mean Fire Size For Each Year (4 pts)

Use the appropriate function to calculate the mean fire size (in hectares) per year and save as a new dataframe. 

Note: the displayed data below only shows the first few rows in the dataset. 

Hints:
* Review the use of `groupby` to run statistics on `pandas dataframes`.
* Think about what value you want to use to group the data and what value you want to use to determine the mean size of fires.


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
      <th>fire_size</th>
    </tr>
    <tr>
      <th>year</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1992</th>
      <td>461.297265</td>
    </tr>
    <tr>
      <th>1993</th>
      <td>642.637897</td>
    </tr>
    <tr>
      <th>1994</th>
      <td>771.721812</td>
    </tr>
    <tr>
      <th>1995</th>
      <td>417.441164</td>
    </tr>
    <tr>
      <th>1996</th>
      <td>825.744342</td>
    </tr>
  </tbody>
</table>
</div>





### Question 9: Plot Mean Fire Size For Each Year (2 pts)

Create a plot of your choice (i.e. type, color) that displays the mean size of fires for each year of data.

Be sure to label your x- and y-axes appropriately and give your plot an appropriate title. 

Hint:
* Recall the step you completed in Question 4 to reset the index after the groupby.
* Think about which dataframe you want to use for the plot and what data you need to plot. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/00-course-overview/final-project/final-project_23_0.png" alt = "This plot displays an example plot of mean fire size (hectares) in California for 1992-2015.">
<figcaption>This plot displays an example plot of mean fire size (hectares) in California for 1992-2015.</figcaption>

</figure>




### Question 10: Discuss Results (4 pts)

Write a few sentences (2-3) on each of the following:

1. Do the number of fires appear to be increasing over time in California? Explain and support your answer using your plot of total number of fires per year.

2. Does the average size of fires appear to be increasing over time in California? Explain and support your answer using your plot of mean size of fires per year.

3. Which result (i.e. total number of fires or mean fire size per year) do you think provides a more appropriate measure of fire danger in California?

## Section 2: Questions 11-19 Using Numpy Arrays

### Get Data

Use `earthpy` to download the following .csv file of the number of fires by month and year in California and import the data to `numpy arrays`:

1. `CA-fires-month-count-1992-to-2015.csv` from `https://ndownloader.figshare.com/files/12835346`

The dataset contains a row for each year specified in the dataset name and contains a column for each month (starting with January through December). The values represent the number of fires that occurred in that month and year, based on fires greater than 100 acres that occurred between 1992 and 2015.


{:.output}
    Downloading from https://ndownloader.figshare.com/files/12835346



{:.output}
{:.execute_result}



    array([[  0.,   1.,   1.,   5.,  23.,  55.,  42.,  66.,  34.,   6.,   4.,
              0.],
           [  0.,   0.,   0.,   2.,  27.,  44.,  33.,  30.,  23.,  17.,   9.,
              2.],
           [  2.,   0.,   0.,   6.,   8.,  50.,  48.,  55.,  23.,   8.,   0.,
              1.],
           [  0.,   1.,   0.,   0.,  11.,  25.,  53.,  35.,  25.,  25.,  11.,
              3.],
           [  2.,   0.,   1.,  15.,  39.,  64.,  64.,  93.,  25.,  26.,   3.,
              1.],
           [  0.,   0.,   5.,   7.,  28.,  13.,  29.,  28.,  25.,   7.,   1.,
              0.],
           [  0.,   0.,   0.,   2.,   2.,  12.,  33.,  47.,  16.,  14.,   5.,
              4.],
           [  0.,   2.,   2.,   3.,   7.,  19.,  33.,  89.,  37.,  22.,   3.,
              2.],
           [  0.,   0.,   3.,   3.,   5.,  19.,  31.,  22.,  17.,  10.,   0.,
              3.],
           [  2.,   1.,   1.,   0.,  13.,  37.,  30.,  40.,  14.,   7.,   3.,
              1.],
           [  0.,   4.,   7.,   3.,  19.,  42.,  34.,  21.,  20.,   6.,  11.,
              0.],
           [  3.,   1.,   0.,   2.,   5.,  33.,  63.,  32.,  47.,  22.,   2.,
              0.],
           [  0.,   1.,   1.,   7.,  16.,  21.,  39.,  27.,  27.,   7.,   1.,
              0.],
           [  0.,   0.,   0.,   2.,   5.,  28.,  47.,  27.,  43.,  15.,   4.,
              0.],
           [  1.,   2.,   0.,   0.,  17.,  50.,  96.,  29.,  21.,  11.,   5.,
              3.],
           [  3.,   1.,   8.,   4.,  21.,  23.,  31.,  30.,  11.,  25.,   3.,
              0.],
           [  0.,   1.,   1.,   4.,  13., 159.,  39.,  31.,  13.,  17.,   3.,
              0.],
           [  0.,   1.,   0.,   5.,  12.,  15.,  24.,  39.,  17.,   6.,   1.,
              0.],
           [  1.,   0.,   1.,   0.,   9.,  16.,  31.,  22.,   7.,   4.,   3.,
              0.],
           [  0.,   0.,   2.,   2.,  15.,  23.,  26.,  30.,  33.,   2.,   3.,
              3.],
           [  0.,   1.,   0.,   1.,   7.,  25.,  31.,  43.,  15.,   3.,   1.,
              0.],
           [  1.,   2.,   0.,   5.,  26.,  14.,  25.,  29.,   9.,   7.,   4.,
              0.],
           [  6.,   0.,   3.,   3.,   8.,  12.,  29.,  15.,  10.,   3.,   1.,
              0.],
           [  0.,   3.,   0.,   8.,   2.,  17.,  57.,  29.,   9.,   5.,   1.,
              1.]])





### Question 11: Write Function to Calculate Sum Across Columns (4 pts)

Write a **function** that calculates the sum across columns of a `numpy array`.

Hints: 
* Recall which existing `numpy` function you can use to calculate a sum. You will include this function within the function you write to answer this question.  
* Review the lessons on functions to review the use of axes to calculate a statistic across the rows or columns of a `numpy array`.


### Question 12: Execute Function to Calculate Sum Across Columns (2 pts)

Run the function created in the previous question (i.e. to calculate sum across columns in a `numpy array`) on the `numpy array` you created for `CA-fires-month-count-1992-to-2015.csv`. Save the output to a new `numpy array`.


{:.output}
{:.execute_result}



    array([ 21.,  22.,  36.,  89., 338., 816., 968., 909., 521., 275.,  82.,
            24.])





### Question 13: Write Function to Calculate Sum Across Rows (4 pts)

Write a **function** that calculates the sum across rows of a `numpy array`.

Hints: 
* Recall which existing `numpy` function you can use to calculate a sum. You will include this function within the function you write to answer this question.  
* Review the lessons on functions to review the use of axes to calculate a statistic across the rows or columns of a `numpy array`.


### Question 14: Execute Function to Calculate Sum Across Rows (2 pts)

Run the function created in the previous question (i.e. to calculate sum across rows in a `numpy array`) on the `numpy array` you created for `CA-fires-month-count-1992-to-2015.csv`. Save the output to a new `numpy array`.


{:.output}
{:.execute_result}



    array([237., 187., 201., 189., 333., 143., 135., 219., 113., 149., 167.,
           210., 147., 171., 235., 160., 281., 120.,  94., 139., 127., 122.,
            90., 132.])





### Question 15: Create Manual Numpy Array (2 pts)

Manually create a `numpy array` that contains the month names for January to December and print the values in this new `numpy array`.

Hints:
* Review the practice activity on data structures to review how to create a `numpy array` manually.
* Think about the values that are going into this array: are the values text strings or numeric values?


{:.output}
    ['January' 'February' 'March' 'April' 'May' 'June' 'July' 'August'
     'September' 'October' 'November' 'December']



### Question 16: Check Dimensions of Numpy Arrays (4 pts)

Write **one conditional statement** that checks that the dimensions (i.e. shape) are the same between:

1. the `numpy array` for the sum across columns and the `numpy array` containing the month names 
**AND** 
2. the `numpy array` for the sum across rows and the `numpy array` containing the month names 

Within your conditional statement, print a message stating whether or not **both of these conditions are true**. 

Hint:
* Compare the shape of the arrays, rather than the single value for the dimension. 
* Recall the operator to check equality between two values. 
* Review how to write a conditional statement that checks for two conditions. 

### Question 17: Plot Numpy Array (6 pts)

Imagine that you have been asked to write a short article for the public on the fire season (i.e. the range of time within a year in which fire is most likely to occur) in California. 

Review the data in your summarized `numpy arrays` (i.e. sum of columns and sum of rows), and choose the one of these arrays to create to represent the fire season in California. 

For your chosen array, create a plot of your choice (i.e. type, color). Be sure to label your x- and y-axes appropriately and to give your plots the approriate titles. 

In your `Markdown` documentation, write a few sentences (1-2) to answer each of the following:

1. What do the values in each of these `numpy arrays` (i.e. the one for sum of columns and the one for sum of rows) represent? 

2. Why did you choose the array that you plotted to represent the fire season in California? 

### Question 18: Discuss Results (6 pts)

Write a few sentences (1-2) on each of the following:

1. Based on the data you have analyzed, how would you define the fire season (i.e. the range of time within a year in which fire is most likely to occur) in California?

2. How could you modify your workflow to examine whether the fire season was expanding over time? Think about how the data is organized and how you could split it up to look at how the fire season was changing over time.

### Question 19: Discuss Pandas Dataframes vs Numpy Arrays (6 pts)

In the `numpy array` section, you calculate the sum across columns. Write a short paragraph (3-4 sentences and include a list if desired) on the following:

1. How could you have analyzed the `pandas dataframe` to get the same values? Outline a `pandas dataframe` workflow to arrive at the same values.

Hint: think about the data provided in the original `numpy array` - do you have similar information in the `pandas dataframe`?

## Section 3 - Option A: Questions 20-24 Using Pandas Dataframes

To answer these questions, use the same `pandas dataframe` that you previously imported from `CA_fires_1992_2015_gt_100_acres.csv`.

### Question 20: Calculate Number of Fires By County (4 pts)

Use the appropriate function to calculate the total number of fires per county and save as a new dataframe. 

Note: the displayed data below only shows the first few rows in the dataset. 

Hints:
* Review the use of `groupby` to run statistics on `pandas dataframes`.
* Think about what value you want to use to group the data and what value you want to use to determine the total number of fires.


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
      <th>fd_unq_id</th>
    </tr>
    <tr>
      <th>county</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Alameda</th>
      <td>7</td>
    </tr>
    <tr>
      <th>Alpine</th>
      <td>5</td>
    </tr>
    <tr>
      <th>Amador</th>
      <td>3</td>
    </tr>
    <tr>
      <th>Butte</th>
      <td>35</td>
    </tr>
    <tr>
      <th>Calaveras</th>
      <td>13</td>
    </tr>
  </tbody>
</table>
</div>





### Question 21: Determine Top 5 Counties for Number of Fires (4 pts)

Sort your `pandas dataframe` from the previous question, so that you can determine the top five counties that have experienced the most fires. 

Note: the displayed data below only shows the first few rows in the sorted dataset. 

In your `Markdown` documentation, answer the following question:

1. In what part of California are these counties? It can help to look at a <a href="https://geology.com/county-map/california.shtml" target="_blank">map of the counties in California</a>. 


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
      <th>fd_unq_id</th>
    </tr>
    <tr>
      <th>county</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Kern</th>
      <td>91</td>
    </tr>
    <tr>
      <th>San Diego</th>
      <td>85</td>
    </tr>
    <tr>
      <th>Riverside</th>
      <td>80</td>
    </tr>
    <tr>
      <th>San Bernardino</th>
      <td>65</td>
    </tr>
    <tr>
      <th>Los Angeles</th>
      <td>63</td>
    </tr>
  </tbody>
</table>
</div>





### Question 22: Calculate Mean Size of Fire By County (4 pts)

Use the appropriate function to calculate the mean size of fires (in hectares) per county and save as a new dataframe. 

Note: the displayed data below only shows the first few rows in the dataset. 

Hints:
* Review the use of `groupby` to run statistics on `pandas dataframes`.
* Think about what value you want to use to group the data and what value you want to use to determine the mean size of fires.


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
      <th>fire_size</th>
    </tr>
    <tr>
      <th>county</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Alameda</th>
      <td>130.308978</td>
    </tr>
    <tr>
      <th>Alpine</th>
      <td>1645.292487</td>
    </tr>
    <tr>
      <th>Amador</th>
      <td>2342.189218</td>
    </tr>
    <tr>
      <th>Butte</th>
      <td>495.625052</td>
    </tr>
    <tr>
      <th>Calaveras</th>
      <td>102.914831</td>
    </tr>
  </tbody>
</table>
</div>





### Question 23: Select Data for Top 3 Counties for Mean Size of Fire and Create New Dataframes (4 pts)

Sort your `pandas dataframe` from the previous question, so that you can determine the top three counties ranked in terms of largest mean fire size.

Note: the displayed data below only shows the first few rows in the sorted dataset. 

For each of these counties, select all of its data from the original `pandas dataframe` from `CA_fires_1992_2015_gt_100_acres.csv`, and save each county to a new dataframe. 


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
      <th>fire_size</th>
    </tr>
    <tr>
      <th>county</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Ventura</th>
      <td>12521.038065</td>
    </tr>
    <tr>
      <th>Santa Clara</th>
      <td>8244.673317</td>
    </tr>
    <tr>
      <th>Santa Barbara</th>
      <td>6758.735725</td>
    </tr>
    <tr>
      <th>Monterey</th>
      <td>5522.676402</td>
    </tr>
    <tr>
      <th>Tuolumne</th>
      <td>4448.036260</td>
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
      <th>fd_unq_id</th>
      <th>source_reporting_unit_name</th>
      <th>fire_name</th>
      <th>year</th>
      <th>month</th>
      <th>month_num</th>
      <th>cause</th>
      <th>fire_size</th>
      <th>fire_size_class</th>
      <th>state</th>
      <th>county</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2265</th>
      <td>1301190</td>
      <td>Ventura County Fire Department</td>
      <td>SIMI INCIDENT</td>
      <td>2003</td>
      <td>October</td>
      <td>10</td>
      <td>Missing/Undefined</td>
      <td>43788.672831</td>
      <td>G</td>
      <td>CA</td>
      <td>Ventura</td>
    </tr>
    <tr>
      <th>2597</th>
      <td>15001173</td>
      <td>Cal state responsibility area (SRA) in Ventura...</td>
      <td>SCHOOL</td>
      <td>2005</td>
      <td>November</td>
      <td>11</td>
      <td>Missing/Undefined</td>
      <td>1574.634265</td>
      <td>F</td>
      <td>CA</td>
      <td>Ventura</td>
    </tr>
    <tr>
      <th>2807</th>
      <td>14907</td>
      <td>Los Padres National Forest</td>
      <td>DAY</td>
      <td>2006</td>
      <td>September</td>
      <td>9</td>
      <td>Debris Burning</td>
      <td>65843.265009</td>
      <td>G</td>
      <td>CA</td>
      <td>Ventura</td>
    </tr>
    <tr>
      <th>3328</th>
      <td>38069</td>
      <td>Los Padres National Forest</td>
      <td>SULPHUR</td>
      <td>2009</td>
      <td>July</td>
      <td>7</td>
      <td>Miscellaneous</td>
      <td>138.807390</td>
      <td>E</td>
      <td>CA</td>
      <td>Ventura</td>
    </tr>
    <tr>
      <th>3355</th>
      <td>39373</td>
      <td>Los Padres National Forest</td>
      <td>VINTAGE</td>
      <td>2009</td>
      <td>August</td>
      <td>8</td>
      <td>Miscellaneous</td>
      <td>60.702940</td>
      <td>D</td>
      <td>CA</td>
      <td>Ventura</td>
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
      <th>fd_unq_id</th>
      <th>source_reporting_unit_name</th>
      <th>fire_name</th>
      <th>year</th>
      <th>month</th>
      <th>month_num</th>
      <th>cause</th>
      <th>fire_size</th>
      <th>fire_size_class</th>
      <th>state</th>
      <th>county</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2040</th>
      <td>316842</td>
      <td>Bakersfield District</td>
      <td>CROY</td>
      <td>2002</td>
      <td>September</td>
      <td>9</td>
      <td>Equipment Use</td>
      <td>1265.453957</td>
      <td>F</td>
      <td>CA</td>
      <td>Santa Clara</td>
    </tr>
    <tr>
      <th>2185</th>
      <td>1301084</td>
      <td>Santa Clara Unit</td>
      <td>SANTA CLARA COMPLEX</td>
      <td>2003</td>
      <td>August</td>
      <td>8</td>
      <td>Lightning</td>
      <td>12209.384675</td>
      <td>G</td>
      <td>CA</td>
      <td>Santa Clara</td>
    </tr>
    <tr>
      <th>2337</th>
      <td>15000800</td>
      <td>Santa Clara Unit</td>
      <td>SILVER</td>
      <td>2004</td>
      <td>July</td>
      <td>7</td>
      <td>Missing/Undefined</td>
      <td>176.038526</td>
      <td>E</td>
      <td>CA</td>
      <td>Santa Clara</td>
    </tr>
    <tr>
      <th>2965</th>
      <td>319992</td>
      <td>Bakersfield District</td>
      <td>LICK</td>
      <td>2007</td>
      <td>September</td>
      <td>9</td>
      <td>Campfire</td>
      <td>19327.816111</td>
      <td>G</td>
      <td>CA</td>
      <td>Santa Clara</td>
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
      <th>fd_unq_id</th>
      <th>source_reporting_unit_name</th>
      <th>fire_name</th>
      <th>year</th>
      <th>month</th>
      <th>month_num</th>
      <th>cause</th>
      <th>fire_size</th>
      <th>fire_size_class</th>
      <th>state</th>
      <th>county</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1942</th>
      <td>1301196</td>
      <td>Los Padres National Forest</td>
      <td>SUDDEN RANCH</td>
      <td>2002</td>
      <td>June</td>
      <td>6</td>
      <td>Missing/Undefined</td>
      <td>3149.268530</td>
      <td>G</td>
      <td>CA</td>
      <td>Santa Barbara</td>
    </tr>
    <tr>
      <th>2336</th>
      <td>15000799</td>
      <td>Santa Barbara County Fire Department</td>
      <td>JALAMA</td>
      <td>2004</td>
      <td>July</td>
      <td>7</td>
      <td>Missing/Undefined</td>
      <td>124.238684</td>
      <td>E</td>
      <td>CA</td>
      <td>Santa Barbara</td>
    </tr>
    <tr>
      <th>2642</th>
      <td>15173</td>
      <td>Los Padres National Forest</td>
      <td>PERKINS</td>
      <td>2006</td>
      <td>June</td>
      <td>6</td>
      <td>Miscellaneous</td>
      <td>6065.437769</td>
      <td>G</td>
      <td>CA</td>
      <td>Santa Barbara</td>
    </tr>
    <tr>
      <th>2706</th>
      <td>13918</td>
      <td>Los Padres National Forest</td>
      <td>BALD</td>
      <td>2006</td>
      <td>July</td>
      <td>7</td>
      <td>Lightning</td>
      <td>505.857834</td>
      <td>F</td>
      <td>CA</td>
      <td>Santa Barbara</td>
    </tr>
    <tr>
      <th>2778</th>
      <td>14425</td>
      <td>Los Padres National Forest</td>
      <td>RANCHO 2</td>
      <td>2006</td>
      <td>August</td>
      <td>8</td>
      <td>Equipment Use</td>
      <td>73.652901</td>
      <td>D</td>
      <td>CA</td>
      <td>Santa Barbara</td>
    </tr>
  </tbody>
</table>
</div>





### Question 24: Loop to Describe Fire Size in Selected Counties (4 pts)

Write a **loop** that executes the appropriate function to calculate summary statistics of **only** the fire size (acres) for each of the three counties identified in the previous question.  

In your `Markdown` documentation for this question, write a sentence or two stating: 
* the total number of fires for each county. 

Hints:
* Review your code from Question 2. 
* Recall that creating a list of items to iterate upon is a good first step to writing a loop. 
* Think about what you are iterating upon in this question - do your list values need `""` to indicate text strings, or are you iterating on existing variables?


{:.output}
    count        9.000000
    mean     12521.038065
    std      24608.933755
    min         60.702940
    25%        138.807390
    50%        369.073875
    75%       1574.634265
    max      65843.265009
    Name: fire_size, dtype: float64
    
    count        4.000000
    mean      8244.673317
    std       9171.829345
    min        176.038526
    25%        993.100099
    50%       6737.419316
    75%      13988.992534
    max      19327.816111
    Name: fire_size, dtype: float64
    
    count       23.000000
    mean      6758.735725
    std      21159.110420
    min         62.726371
    25%        132.939439
    50%        255.761721
    75%       1976.083042
    max      97208.474130
    Name: fire_size, dtype: float64
    



## Section 3 - Option B: Questions 25-30 Using Numpy Arrays

### Get Data

Use `earthpy` to download the following .csv file of the mean size of fires in California by month and import the data to `numpy arrays`:

1. `CA-fires-month-mean-size-1992-to-2015.csv` from `https://ndownloader.figshare.com/files/12835349`

The dataset contains a row for each year specified in the dataset name and contains a column for each month (starting with January through December). The values represent the mean size of fires that occurred in that month and year, based on fires greater than 100 acres that occurred between 1992 and 2015.


{:.output}
    Downloading from https://ndownloader.figshare.com/files/12835349



{:.output}
{:.execute_result}



    array([[    0.  ,   120.  ,  1800.  ,  1390.8 ,   402.94,   444.69,
              436.17,  2255.88,  1684.85,   321.67,   283.  ,     0.  ],
           [    0.  ,     0.  ,     0.  ,   250.5 ,   923.37,  1003.02,
              444.08,   804.4 ,  2159.65,  7375.48,  1451.91,   240.  ],
           [  280.  ,     0.  ,     0.  ,   936.33,  1255.88,  1364.48,
             1889.24,  2549.96,  2755.83,   535.63,     0.  ,   250.  ],
           [    0.  ,   160.  ,     0.  ,     0.  ,   400.82,  1307.8 ,
              885.64,  1798.83,   480.62,  1250.06,   362.73,   179.33],
           [ 1940.  ,     0.  ,  1000.  ,  3892.93,   798.95,  1044.02,
              827.98,  4020.1 ,   438.6 ,  3070.85,   134.67,   150.  ],
           [    0.  ,     0.  ,   406.  ,   423.  ,  2277.  ,   896.69,
              580.17,  4648.29,  1050.31,  7302.14,   375.  ,     0.  ],
           [    0.  ,     0.  ,     0.  ,   134.  ,   198.  ,   254.75,
              780.62,  1216.66,   293.57,  3556.57,   229.2 ,   246.5 ],
           [    0.  ,   600.  ,  1325.  ,   537.67,  2221.71,   486.18,
             1138.27,  4971.5 ,  4813.05,  4060.64,   437.33,  2560.5 ],
           [    0.  ,     0.  ,   465.  ,   785.  ,   277.2 ,   709.89,
             3826.2 ,  3547.16,   863.35,   767.6 ,     0.  ,   337.67],
           [ 5254.  ,  2400.  ,   200.  ,     0.  ,   755.77,   873.04,
             1144.33,  4941.7 ,  2349.5 ,  1369.  ,   194.  ,  1200.  ],
           [    0.  ,  2133.  ,   626.14,   403.  ,   699.53,  2661.5 ,
             7624.18,   522.97,  3745.  ,   493.33,   750.  ,     0.  ],
           [  389.33, 12000.  ,     0.  ,   444.9 ,   515.  ,   593.12,
             1474.28,  2116.08,  1302.91, 34215.91,   301.  ,     0.  ],
           [    0.  ,   122.  ,   350.  ,   485.77,  2134.06,   999.71,
             2090.05,  1764.45,   975.22,  9506.43,   131.  ,     0.  ],
           [    0.  ,     0.  ,     0.  ,   181.  ,   404.4 ,  3348.07,
             1114.08,   867.02,  1160.56,   922.67,  1147.  ,     0.  ],
           [  485.  ,  6699.5 ,     0.  ,     0.  ,   577.7 ,   892.61,
             4143.58,   605.97, 10769.  ,  4122.91,   313.2 , 11442.17],
           [  404.  ,   169.  ,  1116.25,   882.5 ,   613.1 ,  1033.74,
            10025.75,   565.37, 12097.59, 20224.88,  2041.  ,     0.  ],
           [    0.  ,   400.  ,   680.  ,   489.  ,  1949.62,  6863.29,
             3264.13,  2171.58,  1681.31,  1736.82, 14489.  ,     0.  ],
           [    0.  ,   945.  ,     0.  ,   778.6 ,  1226.25,   707.14,
             1224.74,  8838.82,  1347.76,  2158.75,   145.  ,     0.  ],
           [  107.  ,     0.  ,   130.  ,     0.  ,   657.63,   410.69,
             2247.46,   496.75,  1625.  ,   438.25,   145.33,     0.  ],
           [    0.  ,     0.  ,   622.5 ,   206.25,   333.71,   719.35,
             1765.94,   745.3 ,  2400.79,  1162.1 ,   178.33,   411.  ],
           [    0.  ,   200.  ,     0.  ,   143.  ,  1469.87,   544.75,
             4999.86, 12179.76,  3011.24,   214.17,   350.  ,     0.  ],
           [  335.  ,   353.5 ,     0.  ,   183.94,  3434.6 ,   630.86,
             4021.  , 11833.15,  1432.44,   228.29,  1023.25,     0.  ],
           [  806.5 ,     0.  ,   203.33,   826.67,  3141.88,   851.58,
             8337.06,  9679.51, 10195.63,  1209.67,   105.  ,     0.  ],
           [    0.  ,  2417.  ,     0.  ,  1081.  ,   270.5 ,  4577.18,
             8862.38,  2815.68, 16728.  ,   413.  ,   323.  ,  1288.  ]])





### Question 25: Write Function to Convert Units (4 pts)

Write a **function** to convert the units of fire size (acres) to square kilometers. One square kilometer is equal to 247.105 acres. 


### Question 26: Write Function to Calculate Mean Across Columns (4 pts)

Write a **function** that calculates the mean across columns of a `numpy array`.

Hints: 
* Recall which existing `numpy` function you can use to calculate a mean. You will include this function within the function you write to answer this question.  
* Review the lessons on functions to see the use of axes to calculate a statistic across the rows or columns of a `numpy array`.


### Question 27: Write Function to Execute Multiple Tasks (4 pts)

Write a **function** that executes both of the functions you wrote in Questions 25 and 26, in the appropriate order: the conversion from acres to square kilometers and then, the calculation of the mean of the columns on an input `numpy array`.

Hint:
* Review how to pass an implicit variable from one function to another (i.e. the output of the first function becomes the input of the second function). 


### Question 28: Execute Function and Save Output (2 pts)

Execute the function created in the previous question to determine the mean across columns on values that have been converted from acres to square kilometers.


{:.output}
{:.execute_result}



    array([ 1.68633273,  4.84257704,  1.50479553,  2.43753667,  4.54251735,
            5.60122047, 12.33402636, 14.49398872, 14.3936417 , 17.98439597,
            4.20029778,  3.08660455])





### Question 29: Create Manual Array and Check Dimensions (2 pts)

Manually create a `numpy array` that contains the month names for January to December. 

Write a **conditional statement** that checks that the dimensions (i.e. shape) are the same between:

1. the `numpy array` for the mean across columns
2. the `numpy array` containing the month names 

Within your conditional statement, print a message stating whether or not the shapes are the same. 

Hint:
* Compare the shape of the arrays, rather than the single value for the dimension. 
* Recall the operator to check equality between two values. 


{:.output}
    These arrays have the same dimensions (i.e. shape).



### Question 30: Plot Numpy Array (4 pts)

Expand the **conditional statement** from the previous question **to plot the numpy arrays if their shapes are the same.** 

Create a plot of your choice (i.e. type, color), and be sure to label your x- and y-axes appropriately and to give your plot an appropriate title. 

Hints:
* Recall that you can replace the print message with other code to execute tasks such as plotting. 


{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/00-course-overview/final-project/final-project_68_0.png" alt = "This plot displays an example plot of mean fire size (sq. km.) for California in 1992-2015.">
<figcaption>This plot displays an example plot of mean fire size (sq. km.) for California in 1992-2015.</figcaption>

</figure>




### Tag the Instructor in Your Pull Request (1 pt)

In your pull request message to submit this homework, include `@jlpalomino` in your message for the Pull Request to notify the instructor of your submission. 

Remember that you can edit a message for the pull request, if you forget to include it the first time. The message will be updated when you save the changes.

## Part II: Submit Your Jupyter Notebook to GitHub

To submit your `Jupyter Notebook` for the Final Project, follow the `Git`/`Github` workflow from:

1. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/">Guided Activity on Version Control with Git/GitHub</a> to add, commit, and push your `Jupyter Notebook` for the Final Project to your forked repository for the Final Project (`https://github.com/yourusername/ea-bootcamp-final-project-yourusername`).

2. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request">Guided Activity to Submit Pull Request</a> to submit a pull request of your `Jupyter Notebook` for the Final Project to the Earth Lab repository for the Final Project (`https://github.com/earthlab-education/ea-bootcamp-final-project-yourusername`). 

3. Include `@jlpalomino` in your message for the Pull Request to notify the instructor of your submission. 
