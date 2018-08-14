---
layout: single
title: 'Automate Tasks With Loops'
excerpt: "This lesson describes how to automate tasks with loops in Python."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['loops']
permalink: /courses/earth-analytics-bootcamp/loops/automate-tasks-loops/
nav-title: "Automate Tasks With Loops"
dateCreated: 2019-08-11
modified: 2018-08-13
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to write `Python` code to automate tasks using loops.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Start automating your tasks with loops in `Python`


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/loops/intro-dry-code/">Intro to DRY Code</a> and <a href="{{ site.url }}/courses/earth-analytics-bootcamp/loops/intro-loops/">Intro to Loops</a>. 

 </div>


## Example: Create New List of Calculated Values

Recall that in the lessons on variables and lists, you learned how to run calculations on individual variables to convert the units, and then you created a list that contained the recalculated values. 

Average monthly precipitation for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Boulder, Colorado, provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).</a> 

Month  | Precipitation (inches) |
--- | --- |
Jan | 0.70 |
Feb | 0.75 |
Mar | 1.85 |
Apr | 2.93 |
May | 3.05 |
June | 2.02 |
July | 1.93 |
Aug | 1.62 |
Sept | 1.84 |
Oct | 1.31 |
Nov | 1.39 |
Dec | 0.84 |

In this lesson, you will build a loop to automate these tasks, so that you recalculate each value in a list, and then add the new value to a new list. 

### Create Variable For Loop

Begin by creating a variable upon which your loop will execute. In this case, you will run the calculation `* 25.4` on each item in a list containing the average monthly precipitation values.

{:.input}
```python
# create a list of average monthly precipitation in inches
avg_monthly_precip_in = [0.70, 0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84]

# print list
print(avg_monthly_precip_in)
```

{:.output}
    [0.7, 0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84]



### Select Type of Loop

Next, select and compose a structure for your loop. Think about whether a `while` or `for` loop would work better for your task. You have a fixed list of values upon which you want to iterate a calculation.

Which type of loop structure is used in the code below?

{:.input}
```python
# use loop to convert values in `avg_monthly_precip_in`
for month in avg_monthly_precip_in:
    
    # multiply each item in the list by 25.4 to convert from inches to mm
    month = month * 25.4
    
    # print the new value of each item within the loop, so you see results after each iteration
    print(month)    
```

{:.output}
    17.779999999999998
    19.049999999999997
    46.99
    74.422
    77.46999999999998
    51.308
    49.022
    41.148
    46.736
    33.274
    35.306
    21.336



### Expand Loop To Include More Tasks

In previous lessons, you learned how to append items to the end of an existing list using `listname += [value]`, which employs an assignment operator to add the new values to an existing list. 

You can add do this with your loop with only two new lines of code. 

First, create an empty `Python` list that will receive new values using `listname = []`. 

Then, you can add a new line of code to your loop that will use `listname += [value]` to append each value after it is calculated. 

{:.input}
```python
# create a new list that is empty, so that you can add the values calculated in the loop
avg_monthly_precip_mm = []

# use loop to convert values in `avg_monthly_precip_in` and add values to new list
for month in avg_monthly_precip_in:
    
    # multiply each item in the list by 25.4 to convert from inches to mm
    month = month * 25.4
    
    # add each item to the new list 
    avg_monthly_precip_mm += [month]
    
# print the new list after the loop has completed
print(avg_monthly_precip_mm) 
```

{:.output}
    [17.779999999999998, 19.049999999999997, 46.99, 74.422, 77.46999999999998, 51.308, 49.022, 41.148, 46.736, 33.274, 35.306, 21.336]



Look carefully at how the variables `avg_monthly_precip_mm` and `month` are created. 

The list variable `avg_monthly_precip_mm` was explicitly created, meaning that you initalized and assigned the value to the variable manually. In this case, you manually created the variable `avg_monthly_precip_mm` as an empty list.

The variable `month` is an implicit variable, meaning that it was not explicitly created by you, by rather it is created as part of the loop and serves as a placeholder to receive data in each iteration of the loop. At the end of the loop, an implicit variable is equal to the last value that it was assigned.  

Be mindful of the differences between implicit and explicit variables, as sometimes you may have to employ a slightly different syntax when trying to use implicit variables to access data within data structures. 

In this course, syntax differences will be noted in the lessons and in the assignments.  


## Example: Run a Summary Statistic on Multiple Numpy Arrays

By now, you may be excited that you can automate these kinds of tasks, but you may also be thinking that you would prefer to iterate on `numpy arrays` or `pandas dataframes`, instead of working with data values in lists.

You can do that, too! For example, you can build a loop that will calculate summary statistics (such as the sum or median values) of multiple data structures. 

Note that these two summary statistics (i.e. sum and median) are not provided by the `describe()` method of `pandas dataframes`, so this is a good time to use `numpy arrays`.  

You can use the functions `np.sum()` and `np.median()` to calculate sum and median values of a `numpy array`. 


### Create Variables For Loop

Just like before, create the variables containing the values you want to iterate upon. 

Begin with two new `numpy array` containing the monthly precipitation values in 2002 and 2013 for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Boulder, Colorado, provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).</a> 

Month  | Precipitation (inches) in 2002 | Precipitation (inches) in 2013 |
--- | --- | --- |
Jan | 1.07 |0.27 |
Feb | 0.44 |1.13 |
Mar | 1.50 |1.72 |
Apr | 0.20 |4.14 |
May | 3.20 |2.66 |
June | 1.18 |0.61 |
July | 0.09 |1.03 |
Aug | 1.44 |1.40 |
Sept |1.52  |18.16 |
Oct | 2.44 |2.24 |
Nov | 0.78 |0.29 |
Dec | 0.02 |0.50 |

{:.input}
```python
# import necessary packages
import numpy as np

# manually create a new numpy array for 2002
avg_monthly_precip_2002 = np.array([1.07, 0.44, 1.50, 0.20, 3.20, 1.18, 0.09, 1.44, 1.52, 2.44, 0.78, 0.02])

# manually create a new numpy array for 2013
avg_monthly_precip_2013 = np.array([0.27, 1.13, 1.72, 4.14, 2.66, 0.61, 1.03, 1.40, 18.16, 2.24, 0.29, 0.50])

# create list of numpy arrays for iteration
arraylist = [avg_monthly_precip_2002, avg_monthly_precip_2013]
```

### Select Type of Loop

Again, think about what type of loop would work best for this data. 

This time you have two objects upon which you want to iterate a calculation: the `numpy array` for 2002 and the the `numpy array` for 2013. 

Use the `np.sum()` and `np.median()` functions to calculate these statistics on the `numpy arrays`.

{:.input}
```python
# use loop to calculate sum and median values for each array in arraylist
for array in arraylist:
    
    array_sum = np.sum(array)
    array_median = np.median(array)
    
    # print the calculated sum and median values within the loop, so you see result for each array
    print("sum:", array_sum)
    print("median:", array_median)
    print("")
    
```

{:.output}
    sum: 13.879999999999999
    median: 1.125
    
    sum: 34.15
    median: 1.265
    



## Example: Run a Calculation on Multiple Columns in Pandas Dataframe

Another example would include a loop that runs not on multiple data structures, but for example, on multiple columns in a pandas dataframe. 

### Create Variables For Loop

Just like before, create the variable containing the values you want to iterate upon. 

Begin by creating a new `pandas dataframe`. Download and import `precip-2002-2013-months-seasons.csv`)from `https://ndownloader.figshare.com/files/12710621`.

{:.input}
```python
# import necessary Python packages
import os
import urllib.request
import pandas as pd

# replace `jpalomino` with your username here and all paths in this lesson
os.chdir("/home/jpalomino/earth-analytics-bootcamp/")

# download .csv containing monthly precipitation for Boulder, CO in 2002 and 2013
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12710621", 
                           filename = "data/precip-2002-2013-months-seasons.csv")

# import the monthly precipitation values in 2002 and 2013 as a pandas dataframe
precip_2002_2013 = pd.read_csv("/home/jpalomino/earth-analytics-bootcamp/data/precip-2002-2013-months-seasons.csv")

# print data
precip_2002_2013

# create a list of columns for iteration
columnlist = ["precip_2002", "precip_2013"]
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
      <th>precip_2002</th>
      <th>precip_2013</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>1.07</td>
      <td>0.27</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>0.44</td>
      <td>1.13</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>1.50</td>
      <td>1.72</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>0.20</td>
      <td>4.14</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>3.20</td>
      <td>2.66</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>1.18</td>
      <td>0.61</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>0.09</td>
      <td>1.03</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>1.44</td>
      <td>1.40</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>1.52</td>
      <td>18.16</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>2.44</td>
      <td>2.24</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>0.78</td>
      <td>0.29</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.02</td>
      <td>0.50</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





### Select Type of Loop

Again, think about what type of loop would work best for this data. 

This time you have two columns in one `pandas dataframe` upon which you want to iterate a calculation: one for 2002 and one for 2013. Recall how to recalculate columns in pandas dataframes (e.g. `dataframe.column = dataframe.column + 4`). 

Is that the syntax used below?

{:.input}
```python
# use loop to recalculate each column in `columnlist`
for column in columnlist:
    
    precip_2002_2013[[column]] = precip_2002_2013[[column]] * 25.4
        
precip_2002_2013
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
      <th>precip_2002</th>
      <th>precip_2013</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>27.178</td>
      <td>6.858</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>11.176</td>
      <td>28.702</td>
      <td>Winter</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>38.100</td>
      <td>43.688</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>5.080</td>
      <td>105.156</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>81.280</td>
      <td>67.564</td>
      <td>Spring</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>29.972</td>
      <td>15.494</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>2.286</td>
      <td>26.162</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>36.576</td>
      <td>35.560</td>
      <td>Summer</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>38.608</td>
      <td>461.264</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>61.976</td>
      <td>56.896</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>19.812</td>
      <td>7.366</td>
      <td>Fall</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.508</td>
      <td>12.700</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





Note that this is an instance of when you need a slighly different syntax to use implicit variables to access data within data structures (e.g. `dataframe[[column]] = dataframe[[column]] * 25.4`). 

You know you are using an implicit variable because the column name will change with each iteration.

In the first iteration, `column` would contain the values for `precip_2002`, while in the second iteration, `column` would contain the values for `precip_2013`.

Also, notice the placement of the dataframe name (e.g. `precip_2002_2013`) after the loop to display the results. It is not contained with the loop, so you do not see the dataframe each time that the loop iterates. You only see the dataframe when the loop is completed. 

Congratulations - you have automated your first tasks in this course using `Python`!

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge

Test your `Python` skills to:

1. Expand the loop for the `numpy array` example above to convert the values in each `numpy array` from inches to millimeters (1 inch = 25.4 millimeters), before calculating the summary statistics (hint: you only need to add one line!). 

It can also help to think about how these types of calculations are completed on `numpy arrays`. Recall how you previously converted the values in a `numpy array` in the `numpy array` lessons.  

</div>


{:.output}
    sum: 352.55199999999996
    median: 28.575
    
    sum: 867.4099999999999
    median: 32.13099999999999
    


