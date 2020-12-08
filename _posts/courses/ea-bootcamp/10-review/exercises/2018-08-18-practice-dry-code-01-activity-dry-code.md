---
layout: single
title: 'Activity on Dry Code'
excerpt: "This activity provides an opportunity to practice writing DRY code using loops, conditional statements, and functions." 
authors: ['Jenny Palomino']
category: [courses]
class-lesson: ['practice-dry-code']
permalink: /courses/earth-analytics-bootcamp/practice-dry-code/activity-dry-code/
nav-title: "Activity on Dry Code"
dateCreated: 2018-08-18
modified: 2020-12-08
module-title: 'Practice Writing DRY (i.e. Do Not Repeat Yourself) Code in Python'
module-nav-title: 'Practice Writing DRY Code'
module-description: 'This tutorial provides an opportunity to practice writing DRY code using loops, conditional statements, and functions.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 11
estimated-time: "2-3 hours"
difficulty: "beginner"
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

<div class="notice--info" markdown="1">


## <i class="fa fa-ship" aria-hidden="true"></i> Hands-on Practice Writing DRY Code

This hands-on activity provides you an opportunity to practice working with the DRY code strategies introduced in this course: loops, conditional statements, and functions.

While this activity will not be formally graded, you can **earn participation points** for submitting your completed `Jupyter Notebook` for this activity.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed all of the lessons from Days 4-10 for the Earth Analytics Bootcamp. Completing the challenges at the end of the lessons will also help you with this assignment. 

You will need to **`fork` and `clone` a Github repository for this activity**: 

`https://github.com/earthlab-education/ea-bootcamp-practice-dry-code`

</div>


## Part I: Create and Modify a Jupyter Notebook

Begin by creating a new `Jupyter Notebook` in your forked repository (`ea-bootcamp-practice-dry-code`). 

Rename the file to `firstinitial-lastname-practice-dry-code.ipynb` (e.g. `jpalomino-practice-dry-code.ipynb`). 

Note that `Git` will recognize this new `Jupyter Notebook` as a new file that can be added, committed, and pushed back to your forked repository on `Github.com`. 


### Practice Documentation of Code and Functions

Start with `Markdown` cell containing a `Markdown` title for this assignment, plus an author name and date in list form. Bold the words for author and date, but do not bold your name and today's date. 

Add a `Markdown` cell before each code cell you create to describe the purpose of your code (e.g. what are you accomplishing by executing this code?). 

**Be sure to add documentation within your functions** using `Python` comments to tell the user what the function is doing and and what inputs it can take. 

Also, be sure to use clear function names that tell the user what the function does. If you find it useful, you can review the <a href="{{ site.url }}/courses/earth-analytics-bootcamp/pep-8-style-guide/">Earth Analytics Bootcamp reference page on PEP8 Style Guide</a>.


### Import Python Packages

In the questions below, you will be working with `numpy arrays` and `pandas dataframes`. 

You will also be downloading files using `urllib.request` and accessing directories and files on your computer using `os`. Last, you will also be creating plots of your data.

Import all of the necessary `Python` packages to accomplish these tasks.


### Get Data

#### Numpy Arrays

Use `earthpy` to download the following .csv files of monthly precipitation (inches) and  import the data to `numpy arrays`:

1. `monthly-precip-1988-to-1992.csv` from `https://ndownloader.figshare.com/files/12807380`

2. `monthly-precip-1993-to-1997.csv` from `https://ndownloader.figshare.com/files/12807383`

Each dataset contains a row for each year specified in the dataset name and contains a column for each month (starting with January through December). 

#### Pandas Dataframes

Use earhpy to download the following .csv files of monthly temperature (Fahrenheit) and import the data to `pandas dataframes`:

1. `temp-1991-to-1995-months.csv` from `https://ndownloader.figshare.com/files/12807389`

2. `temp-1996-to-2000-months.csv` from `https://ndownloader.figshare.com/files/12807386`

Each dataset contains a row for each year specified in the dataset name and a column for each month (starting with January through December). 

**Note:** you are not required to write a loop to accomplish these tasks. You can follow the same process that you have before to download and import files.


{:.output}
    Downloading from https://ndownloader.figshare.com/files/12807380
    Downloading from https://ndownloader.figshare.com/files/12807383
    Downloading from https://ndownloader.figshare.com/files/12807389
    Downloading from https://ndownloader.figshare.com/files/12807386




{:.output}
{:.execute_result}



    array([[0.4 , 1.14, 2.53, 1.48, 3.7 , 0.7 , 0.71, 1.33, 2.02, 0.03, 0.75,
            2.16],
           [1.19, 1.27, 0.97, 1.95, 2.68, 2.93, 1.43, 1.63, 3.54, 1.4 , 0.09,
            1.54],
           [1.04, 1.32, 4.55, 2.16, 1.73, 0.39, 4.23, 1.13, 1.84, 0.96, 1.6 ,
            0.75],
           [1.05, 0.15, 0.43, 2.41, 2.9 , 3.59, 3.11, 2.08, 1.21, 0.93, 3.3 ,
            0.01],
           [0.67, 0.  , 5.17, 0.46, 1.7 , 0.96, 1.13, 3.08, 0.02, 0.79, 2.56,
            0.84]])






{:.output}
{:.execute_result}



    array([[0.25, 0.9 , 2.15, 2.56, 1.73, 3.38, 1.4 , 1.04, 3.32, 2.42, 2.17,
            0.55],
           [0.86, 1.37, 1.61, 3.46, 1.35, 0.93, 0.35, 2.56, 0.54, 1.02, 2.25,
            0.49],
           [0.64, 1.53, 1.21, 5.45, 9.59, 4.03, 0.72, 1.45, 2.96, 0.59, 1.51,
            0.25],
           [1.89, 0.29, 2.16, 1.49, 4.63, 2.77, 1.96, 0.63, 3.48, 0.28, 1.43,
            0.37],
           [0.87, 1.83, 0.91, 5.77, 2.19, 3.69, 1.14, 5.27, 1.92, 2.7 , 1.52,
            0.68]])






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
      <td>1991</td>
      <td>29.9</td>
      <td>40.9</td>
      <td>42.8</td>
      <td>47.8</td>
      <td>58.2</td>
      <td>66.6</td>
      <td>70.5</td>
      <td>69.2</td>
      <td>61.7</td>
      <td>52.1</td>
      <td>36.8</td>
      <td>35.3</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1992</td>
      <td>35.9</td>
      <td>40.6</td>
      <td>43.3</td>
      <td>54.3</td>
      <td>59.1</td>
      <td>62.9</td>
      <td>68.3</td>
      <td>66.3</td>
      <td>64.4</td>
      <td>54.1</td>
      <td>34.1</td>
      <td>29.2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1993</td>
      <td>28.3</td>
      <td>30.6</td>
      <td>42.4</td>
      <td>47.6</td>
      <td>57.5</td>
      <td>64.5</td>
      <td>69.5</td>
      <td>67.3</td>
      <td>58.8</td>
      <td>48.7</td>
      <td>35.6</td>
      <td>35.4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1994</td>
      <td>35.5</td>
      <td>31.9</td>
      <td>43.9</td>
      <td>47.6</td>
      <td>60.8</td>
      <td>70.0</td>
      <td>71.2</td>
      <td>70.9</td>
      <td>65.0</td>
      <td>50.6</td>
      <td>36.6</td>
      <td>36.1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1995</td>
      <td>34.5</td>
      <td>38.3</td>
      <td>42.1</td>
      <td>45.1</td>
      <td>50.9</td>
      <td>62.4</td>
      <td>70.5</td>
      <td>74.0</td>
      <td>60.4</td>
      <td>50.5</td>
      <td>45.0</td>
      <td>36.3</td>
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
      <td>29.7</td>
      <td>37.7</td>
      <td>37.9</td>
      <td>50.4</td>
      <td>58.9</td>
      <td>66.9</td>
      <td>71.5</td>
      <td>69.5</td>
      <td>60.8</td>
      <td>53.1</td>
      <td>40.6</td>
      <td>36.5</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1997</td>
      <td>31.3</td>
      <td>32.8</td>
      <td>45.5</td>
      <td>42.8</td>
      <td>57.4</td>
      <td>66.5</td>
      <td>71.4</td>
      <td>68.7</td>
      <td>64.0</td>
      <td>52.7</td>
      <td>37.9</td>
      <td>33.9</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1998</td>
      <td>36.5</td>
      <td>36.4</td>
      <td>38.7</td>
      <td>46.5</td>
      <td>58.8</td>
      <td>62.1</td>
      <td>72.8</td>
      <td>70.7</td>
      <td>67.1</td>
      <td>50.4</td>
      <td>44.0</td>
      <td>32.2</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1999</td>
      <td>36.4</td>
      <td>42.1</td>
      <td>46.0</td>
      <td>44.5</td>
      <td>55.6</td>
      <td>64.8</td>
      <td>73.5</td>
      <td>69.3</td>
      <td>58.5</td>
      <td>51.9</td>
      <td>48.0</td>
      <td>36.9</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2000</td>
      <td>36.4</td>
      <td>41.0</td>
      <td>42.9</td>
      <td>51.2</td>
      <td>61.0</td>
      <td>67.4</td>
      <td>74.7</td>
      <td>73.0</td>
      <td>63.1</td>
      <td>49.6</td>
      <td>31.4</td>
      <td>31.2</td>
    </tr>
  </tbody>
</table>
</div>





### Question 1: Use Indexing to Select from Numpy Array

Select the second row of data (including all columns) from the `numpy array` containing the data for 1988 to 1992, and save to a new `numpy array`.

Note that using an index series (e.g. `[row_index:row_index, column_index:column_index]`) to select the rows and columns will result in a two-dimensional array. 

Name your new array appropriately to indicate the year of data that it represents. 


{:.output}
{:.execute_result}



    array([[1.19, 1.27, 0.97, 1.95, 2.68, 2.93, 1.43, 1.63, 3.54, 1.4 , 0.09,
            1.54]])





### Question 2: Write a Conditional Statement to Check Dimensions of Numpy Array

Write a conditional statement that checks whether the `numpy array` created in the previous question (i.e. the selection) is a one-dimensional `numpy array`. 

Print a message stating whether or not the array is one-dimensional.

Hints:
* It is easier to write this conditional statement using the attribute of `numpy arrays` that provides a single value for the dimension (i.e. `.ndim`), rather than the shape.
* Recall how to use the comparison operator to check for equality between values (`==`). 


{:.output}
    This is NOT a one-dimensional array.



### Question 3: Expand Conditional Statement to Execute Different Code 

Modify your conditional statement from the previous question, so that your `if` and `else` statements execute different code, not just printing messages.

For the `if` statement, rather than printing a message, print the shape of the `numpy array` from the previous question (i.e. the selection). 

For the `else` statement, rather than printing a message, include the following code lines to be executed (i.e. if the array is not one-dimensional):  
* `arrayname_1d = arrayname.flatten()`
* `print(arrayname_1d.shape)` 

These code lines will flatten a `numpy array` (in this case named `arrayname`) to a one-dimensional array, save it to a new array called `arrayname_1d`, and print the shape of the new array.

**Note the result of this conditional statement.** 


{:.output}
    (12,)



### Question 4: Write a Conditional Statement to Check Dimensions of Two Numpy Arrays

Manually create a one-dimensional `numpy array` that contains the month names (i.e. January to December).

Write a conditional statement to check that this new array for month names has the **same shape** as the `numpy array` from the previous question (i.e. the selection). 

Print a message stating whether are not these arrays have the same shape and can be plotted together.

Hints:
* Review the Activity on Data Structures from Day 6 if you need to recall how to manually create a `numpy array` using `np.array([])`.  
* Note that you are creating this new array using text strings, not numeric values. 
* Recall how to use the comparison operator to check for equality between values (`==`).


{:.output}
    These arrays have the same shape and can be plotted together.



### Question 5: Practice Pseudo Coding

Reflect on your conditional statement from the previous question. 

Write a sentence or two on how you could expand on your conditional statement from the previous question to create a plot from the two `numpy arrays` if they do indeed have the same shape. 

Hint: what did you do in Question 3 to expand on your conditional statement?

### Question 6: Loop on Pandas Dataframes

Write a loop to run the `info()` method on the two `pandas dataframes` that you imported in this activity, and print the results. 

Hint:
* Recall that creating a list of items to iterate upon is a good first step to writing a loop. 
* Think about what you are iterating upon in this question - do your list values need `""` to indicate text strings, or are you iterating on existing variables?


{:.output}
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 5 entries, 0 to 4
    Data columns (total 13 columns):
     #   Column     Non-Null Count  Dtype  
    ---  ------     --------------  -----  
     0   Year       5 non-null      int64  
     1   January    5 non-null      float64
     2   February   5 non-null      float64
     3   March      5 non-null      float64
     4   April      5 non-null      float64
     5   May        5 non-null      float64
     6   June       5 non-null      float64
     7   July       5 non-null      float64
     8   August     5 non-null      float64
     9   September  5 non-null      float64
     10  October    5 non-null      float64
     11  November   5 non-null      float64
     12  December   5 non-null      float64
    dtypes: float64(12), int64(1)
    memory usage: 648.0 bytes
    None
    
    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 5 entries, 0 to 4
    Data columns (total 13 columns):
     #   Column     Non-Null Count  Dtype  
    ---  ------     --------------  -----  
     0   Year       5 non-null      int64  
     1   January    5 non-null      float64
     2   February   5 non-null      float64
     3   March      5 non-null      float64
     4   April      5 non-null      float64
     5   May        5 non-null      float64
     6   June       5 non-null      float64
     7   July       5 non-null      float64
     8   August     5 non-null      float64
     9   September  5 non-null      float64
     10  October    5 non-null      float64
     11  November   5 non-null      float64
     12  December   5 non-null      float64
    dtypes: float64(12), int64(1)
    memory usage: 648.0 bytes
    None
    



### Question 7: Loop on Columns in Pandas Dataframes

Write a loop to run the `.describe()` method on each column in the pandas dataframe containing the data for 1996 to 2000).

Hint: 
* Recall that creating a list of items to iterate upon is a good first step to writing a loop. 
* Think about what you are iterating upon in this question - do your list values need `""` to indicate text strings, or are you iterating on existing variables?
* Recall that to select columns in `pandas dataframes` using implicit variables (i.e. not explicitly created by you), change the syntax from `dataframe.column_name` to `dataframe[[column_name]]`.


{:.output}
             January
    count   5.000000
    mean   34.060000
    std     3.298939
    min    29.700000
    25%    31.300000
    50%    36.400000
    75%    36.400000
    max    36.500000
    
            February
    count   5.000000
    mean   38.000000
    std     3.724916
    min    32.800000
    25%    36.400000
    50%    37.700000
    75%    41.000000
    max    42.100000
    
               March
    count   5.000000
    mean   42.200000
    std     3.760319
    min    37.900000
    25%    38.700000
    50%    42.900000
    75%    45.500000
    max    46.000000
    
               April
    count   5.000000
    mean   47.080000
    std     3.650616
    min    42.800000
    25%    44.500000
    50%    46.500000
    75%    50.400000
    max    51.200000
    
               May
    count   5.0000
    mean   58.3400
    std     1.9995
    min    55.6000
    25%    57.4000
    50%    58.8000
    75%    58.9000
    max    61.0000
    
                June
    count   5.000000
    mean   65.540000
    std     2.157081
    min    62.100000
    25%    64.800000
    50%    66.500000
    75%    66.900000
    max    67.400000
    
                July
    count   5.000000
    mean   72.780000
    std     1.391761
    min    71.400000
    25%    71.500000
    50%    72.800000
    75%    73.500000
    max    74.700000
    
              August
    count   5.000000
    mean   70.240000
    std     1.705286
    min    68.700000
    25%    69.300000
    50%    69.500000
    75%    70.700000
    max    73.000000
    
           September
    count   5.000000
    mean   62.700000
    std     3.258067
    min    58.500000
    25%    60.800000
    50%    63.100000
    75%    64.000000
    max    67.100000
    
             October
    count   5.000000
    mean   51.540000
    std     1.497665
    min    49.600000
    25%    50.400000
    50%    51.900000
    75%    52.700000
    max    53.100000
    
            November
    count   5.000000
    mean   40.380000
    std     6.285062
    min    31.400000
    25%    37.900000
    50%    40.600000
    75%    44.000000
    max    48.000000
    
           December
    count   5.00000
    mean   34.14000
    std     2.53239
    min    31.20000
    25%    32.20000
    50%    33.90000
    75%    36.50000
    max    36.90000
    



### Question 8: Write Function to Summarize Numpy Array Using Axes

Write a function that calculates the mean across columns of a `numpy array`.

Hints: 
* Recall which existing `numpy` function you can use to calculate a mean. You will include this function within the function you write to answer this question.  
* Review the lessons on functions to see the use of axes to calculate a statistic across the rows or columns of a `numpy array`.


### Question 9: Execute Function and Save Output to New Numpy Array

Run the function created in the previous question (i.e. to calculate mean of columns in a `numpy array`) on the `numpy array` containing data for 1993 to 1997. Save the output to a new `numpy array`.


{:.output}
{:.execute_result}



    array([0.902, 1.184, 1.608, 3.746, 3.898, 2.96 , 1.114, 2.19 , 2.444,
           1.402, 1.776, 0.468])





### Question 10: Practice Pseudo Coding

You have already learned how to save the output from one run of a function (see Question 9). What if you wanted to run the function on multiple `numpy arrays`?

**Write a sentence or two on what you would need to know how to do, in order to save the output from a function that is running on multiple arrays in a loop.**

Hint: think about how you can append values to a list using a loop (i.e. create an empty list that gets values appended to it in the loop).

## Part 2: Submit Your Jupyter Notebook to GitHub

To submit your `Jupyter Notebook` for this activity, follow the `Git`/`Github` workflow from:

1. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/">Guided Activity on Version Control with Git/GitHub</a> to add, commit, and push your `Jupyter Notebook` for this activity to your forked repository (`https://github.com/yourusername/ea-bootcamp-practice-dry-code`).


2. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request">Guided Activity to Submit Pull Request</a> to submit a pull request of your `Jupyter Notebook` for this activity to the Earth Lab repository (`https://github.com/earthlab-education/ea-bootcamp-practice-dry-code`). 

