---
layout: single
title: 'Activity Data Structures'
excerpt: "This activity provides an opportunity to practice working with commonly used Python data structures for scientific data: lists, numpy arrays, and pandas dataframes." 
authors: ['Jenny Palomino']
category: [courses]
class-lesson: ['practice-data-structures']
permalink: /courses/earth-analytics-bootcamp/practice-data-structures/activity-data-structures/
nav-title: "Activity on Data Structures"
dateCreated: 2018-07-23
modified: 2021-01-28
module-title: 'Practice Working With Data Structures in Python'
module-nav-title: 'Practice Working With Data Structures'
module-description: 'This tutorial provides an opportunity to practice working with commonly used Python data structures for scientific data: lists, numpy arrays, and pandas dataframes.'
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 6
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


## <i class="fa fa-ship" aria-hidden="true"></i> Hands-on Practice With Data Structures

This hands-on activity provides you an opportunity to practice working with the data structures used in this course: lists, `numpy arrays` and `pandas dataframes`. You will also practice submitting pull requests to `Github` repositories.

While this activity will not be formally graded, you can **earn participation points** for submitting your completed `Jupyter Notebook` for this activity.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed all of the lessons from Days 1-5 for the Earth Analytics Bootcamp. Completing the challenges at the end of the lessons will also help you with this assignment. 

You will need to **`fork` and `clone` a Github repository for this activity**: 

`https://github.com/earthlab-education/ea-bootcamp-practice-data-structures`

</div>


## Part I: Create and Modify a Jupyter Notebook

Begin by creating a new `Jupyter Notebook` in your forked repository (`ea-bootcamp-practice-data-structures`). 

Rename the file to `firstinitial-lastname-practice-data-structures.ipynb` (e.g. `jpalomino-practice-data-structures.ipynb`). 

Note that `Git` will recognize this new `Jupyter Notebook` as a new file that can be added, committed, and pushed back to your forked repository on `Github.com`. 


### Practice Documentation 

**Add a `Markdown` cell before each code cell** you create to describe the purpose of your code (e.g. what are you accomplishing by executing this code?).

Within code cells, **be sure to also add `Python` comments to document each code block** and use appropriate variable names that are short and concise but also clearly indicate the kind of data contained in the variable. Review the variable names that you have seen throughout the lessons. 


### Question 1: Markdown Titles

Use `Markdown` to add a title and author for your new `Jupyter Notebook` using `Markdown` (e.g. `Earth Analytics Bootcamp - Practice Activity on Data Structures` and `Author: Jenny Palomino`). Bold the word `Author`.


### Question 2: Import Python Packages

You will be creating `lists`, `numpy arrays`, and `pandas dataframes`. You will also be creating plots and downloading data from `Figshare.com`

Import the necessary `Python` packages to accomplish these tasks. Review the lessons as needed to figure out which packages you need to import.   


### Question 3: Create List of Data Values

Create and print a `Python` list of the average monthly temperature (Celsius) in Boulder, CO:

Month  | Temperature (Celsius) |
--- | --- |
Jan | 0.0 |
Feb | 2.00 |
Mar | 5.0 |
Apr | 9.56 |
May | 14.39 |
Aug | 21.72 |
Sept | 16.72 |
Oct | 11.61 |
Nov | 4.89 |
Dec | 0.99 |

**Notice anything unusual about this table?**



{:.output}
    [0.0, 2.0, 5.0, 9.56, 14.39, 21.72, 16.72, 11.61, 4.89, 0.99]



### Question 4: Insert Values Into a Python List

Month  | Temperature (Celsius) |
--- | --- |
June | 19.56 |
July | 22.78 |

Insert missing values for June and July into your `Python` list with the following syntax: 

`listname.insert(index, value)`

This means that you need to determine the index location at which you want to insert the value. For example, if you want to add a new value at the second place in a list, then you would use an index of `[1]`. 

It can also be helpful to identify the index of the existing value in front of which you want to add a new value. 

Remember that Python indexing begins at `[0]` and that when you add a new item to the list, the index of the original items will update as well. 

Print your `Python` list after each addition. 


{:.output}
    [0.0, 2.0, 5.0, 9.56, 14.39, 19.56, 21.72, 16.72, 11.61, 4.89, 0.99]
    [0.0, 2.0, 5.0, 9.56, 14.39, 19.56, 22.78, 21.72, 16.72, 11.61, 4.89, 0.99]



### Question 5: Manually Create Numpy Arrays

Using the average monthly temperature values, manually create and print a one-dimensional `numpy array` using the following syntax: 

`arrayname = np.array([value, value, value, etc])`


{:.output}
    [ 0.    2.    5.    9.56 14.39 19.56 22.78 21.72 16.72 11.61  4.89  0.99]



Using the completed `Python` list from the previous question, create and print another `numpy array` using the following syntax: 

`arrayname = np.array(listname)`


{:.output}
    [ 0.    2.    5.    9.56 14.39 19.56 22.78 21.72 16.72 11.61  4.89  0.99]



### Quesion 6: Download Text File and Import Into Numpy Arrays

Use `earthpy` to download the following file of average monthly temperature (Celsius) for Boulder, Colorado, to your `data` directory:

`avg-monthly-temp.txt` from `https://ndownloader.figshare.com/files/12732467`

Recall that you need to set your working directory before running the commands to download data. 

Use the appropriate function to import `avg-monthly-temp.txt` into a `numpy array`. 



{:.output}
    Downloading from https://ndownloader.figshare.com/files/12732467
    datasets downloaded successfully




{:.output}
    [ 0.    2.    5.    9.56 14.39 19.56 22.78 21.72 16.72 11.61  4.89  0.99]



### Quesion 7: Select and Summarize Data From Numpy Arrays

Using selections, create two new `numpy arrays` containing the data values for:

1. Mar, Apr, May
2. Sept, Oct, Nov

Run the appropriate function to calculate and print the mean of each new `numpy array`.


{:.output}
    Mean of Spring Average Monthly Temperatures: 9.65
    Mean of Fall Average Monthly Temperatures: 11.073333333333332



### Question 8: Manually Create Pandas Dataframes

Manually create and print a `pandas dataframe` of average monthly temperature (Celsius) for Boulder, Colorado, with the following syntax:

`dataframe_name = pd.DataFrame(
                              columns=["column_name_textstring", "column_name_numeric"], 
                              data=[ 
                              ["Text", value], ["Text", value], 
                                  ["Text", value], ["Text", value] 
                              ]
                              )`   
                              
Note that you do not need to include the line spaces displayed above. They are simply there to help you see the appropriate syntax. 



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
      <th>Month</th>
      <th>Temp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>January</td>
      <td>0.00</td>
    </tr>
    <tr>
      <th>1</th>
      <td>February</td>
      <td>2.00</td>
    </tr>
    <tr>
      <th>2</th>
      <td>March</td>
      <td>5.00</td>
    </tr>
    <tr>
      <th>3</th>
      <td>April</td>
      <td>9.56</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>14.39</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>19.56</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>22.78</td>
    </tr>
    <tr>
      <th>7</th>
      <td>August</td>
      <td>21.72</td>
    </tr>
    <tr>
      <th>8</th>
      <td>September</td>
      <td>16.72</td>
    </tr>
    <tr>
      <th>9</th>
      <td>October</td>
      <td>11.61</td>
    </tr>
    <tr>
      <th>10</th>
      <td>November</td>
      <td>4.89</td>
    </tr>
    <tr>
      <th>11</th>
      <td>December</td>
      <td>0.99</td>
    </tr>
  </tbody>
</table>
</div>





### Question 9: Download CSV File and Import Into Pandas Dataframes

Use `.urllib.request` to download the following file of average monthly temperature (Celsius) for Boulder, Colorado, to your `data` directory:

`avg-temp-months-seasons.csv` from `https://ndownloader.figshare.com/files/12739457`

Recall that you need to set your working directory (e.g. `/home/jpalomino/earth-analytics-bootcamp/`) before running the commands to download data. 

Use the appropriate function to import `avg-temp-months-seasons.csv` into a `pandas dataframe`. 


{:.output}
    Downloading from https://ndownloader.figshare.com/files/12739457
    datasets downloaded successfully




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
      <th>temp</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>0.00</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>2.00</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>5.00</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>9.56</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>14.39</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>19.56</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>22.78</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>21.72</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>16.72</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>11.61</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>4.89</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.99</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





### Question 10: Select and Summarize Data From Pandas Dataframes

Select the data for each season (e.g. `Winter`) and assign the results to a new `pandas dataframe` for each season. 

Run the appropriate function to summarize each new `pandas dataframe` (e.g. `Winter`).


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
      <th>temp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>3.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.996667</td>
    </tr>
    <tr>
      <th>std</th>
      <td>1.000017</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.495000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>0.990000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>1.495000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>2.000000</td>
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
      <th>temp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>3.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>9.650000</td>
    </tr>
    <tr>
      <th>std</th>
      <td>4.695647</td>
    </tr>
    <tr>
      <th>min</th>
      <td>5.000000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>7.280000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>9.560000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>11.975000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>14.390000</td>
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
      <th>temp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>3.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>21.353333</td>
    </tr>
    <tr>
      <th>std</th>
      <td>1.641016</td>
    </tr>
    <tr>
      <th>min</th>
      <td>19.560000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>20.640000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>21.720000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>22.250000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>22.780000</td>
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
      <th>temp</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>3.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>11.073333</td>
    </tr>
    <tr>
      <th>std</th>
      <td>5.933231</td>
    </tr>
    <tr>
      <th>min</th>
      <td>4.890000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>8.250000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>11.610000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>14.165000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>16.720000</td>
    </tr>
  </tbody>
</table>
</div>





### Question 11: Plot Data From Pandas Dataframes

Manually create a new `pandas dataframe` containing the calculated mean value for each season and the name of the season.

Plot this new `pandas dataframe` using the plot type and colors of your choosing. 

## Part 2: Submit Your Jupyter Notebook to GitHub

To submit your `Jupyter Notebook` for this activity, follow the `Git`/`Github` workflow from:

1. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-version-control/">Guided Activity on Version Control with Git/GitHub</a> to add, commit, and push your `Jupyter Notebook` for this activity to your forked repository (`https://github.com/yourusername/ea-bootcamp-practice-data-structures`).


2. <a href="{{ site.url }}/courses/earth-analytics-bootcamp/git-github-version-control/guided-activity-pull-request">Guided Activity to Submit Pull Request</a> to submit a pull request of your `Jupyter Notebook` for this activity to the Earth Lab repository (`https://github.com/earthlab-education/ea-bootcamp-practice-data-structures`). 

