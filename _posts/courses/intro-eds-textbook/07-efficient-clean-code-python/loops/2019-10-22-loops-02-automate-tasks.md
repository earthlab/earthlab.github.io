---
layout: single
title: 'Automate Data Tasks With Loops in Python'
excerpt: "Loops can be used to automate data tasks in Python by iteratively executing the same code on multiple data structures. Learn how to automate data tasks in Python using data structures such as lists, numpy arrays, and pandas dataframes."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-loops-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/loops/automate-data-tasks-with-loops/
nav-title: "Automate Data Tasks With Loops"
dateCreated: 2019-10-23
modified: 2020-09-03
module-type: 'class'
chapter: 18
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/loops/automate-tasks-loops/"
  - "/courses/intro-to-earth-data-science/dry-code-python/loops/automate-data-tasks-with-loops/"
  - "/courses/intro-to-earth-data-science/write-efficient-python-code/automate-data-tasks-with-loops/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Automate tasks using data structures such as lists, **numpy** arrays, and **pandas** dataframe.
* Add the results of a loop to a new list. 
* Automate data downloads with **earthpy**.
 
</div>


As you have already learned, loops are very useful for removing repetition 
in your code. As such, they are great for automating tasks that you want to 
run on multiple values or data structures. Explore the examples below to see 
how you can automate tasks using data structures such as lists, **numpy** 
arrays, and **pandas** dataframe.


## Automate Calculations on Values in Lists

Recall that in the lessons on variables and lists, you learned how to run 
calculations on individual variables to convert the units, using average monthly 
precipitation values for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">
    Boulder, Colorado, provided by the U.S. National Oceanic and Atmospheric 
    Administration (NOAA)</a>.

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

After you converted each variable, you then manually created a list that 
contained the recalculated values. Using a loop, you can automate this task, 
so that you recalculate each value in an existing list. 

### Create List of Values For Loop

Begin by creating the list upon which your loop will execute. 

{:.input}
```python
# Create list of average monthly precip (inches) in Boulder, CO
avg_monthly_precip_in = [0.70,  0.75, 1.85, 2.93, 3.05, 2.02, 
                         1.93, 1.62, 1.84, 1.31, 1.39, 0.84]
```

### Write Loop

Next, decide on the type of loop that will work best for your goal of running 
a calculation on each item of a list. In this case, you want to convert each item 
in a list from inches to millimeters (recall than 1 inch = 25.4 mm). So you have a 
fixed list of values upon which you want to iterate a calculation. Think about 
whether a `while` or `for` loop would work better for your task. Which type of loop 
structure is used in the code below?

{:.input}
```python
# Convert each item in list from inches to mm
for month in avg_monthly_precip_in:
    month *= 25.4
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



### Expand Loop To Add Results to New List

In the loop above, each month's value is converted from inches to millimeters 
and the value is printed; however, the new value is not actually captured anywhere, 
as the original list is not updated. You can expand the loop with more code, so that 
each converted value is actually added to a new list. Previously in the textbook, 
you learned how to append items to the end of an existing list using 
`listname += [value]`, which employs an assignment operator to add the new values 
to the end of an existing list. 

You can add do this with your loop with only two new lines of code:
1. First, you create an empty list that will receive new values using `listname = []`. 
2. Then, you can add a new line of code to append each value after it is calculated using `listname.append(value)`. 

{:.input}
```python
# Create new empty to receive values
avg_monthly_precip_mm = []

# Convert each item from in to mm and add to new list
for month in avg_monthly_precip_in:
    month *= 25.4 
    avg_monthly_precip_mm.append(month)
```

You can print the values in both lists to see that the original list has 
not changed, and that the new list contains the converted values. 

{:.input}
```python
# Print original list in inches
print(avg_monthly_precip_in) 
    
# Print new list after loop is complete
print(avg_monthly_precip_mm) 
```

{:.output}
    [0.7, 0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84]
    [17.779999999999998, 19.049999999999997, 46.99, 74.422, 77.46999999999998, 51.308, 49.022, 41.148, 46.736, 33.274, 35.306, 21.336]



### Review the List Being Iterated Upon and the Placeholder in Loop

Look carefully at how the variables `avg_monthly_precip_mm` and `month` are created. 
The list variable `avg_monthly_precip_mm` was explicitly created; in this case, 
you manually created the variable `avg_monthly_precip_mm` as an empty list. The variable 
`month` is the placeholder variable, meaning that it was not explicitly created by you. 

Rather, it is created as part of the loop and serves as a placeholder to represent each 
item from the original list (`avg_monthly_precip_in`), as the loop iterates. At the end 
of the loop, the placeholder variable is equal to the last value that it was assigned 
(e.g. `month` is equal to 21.336 when the loop ends). 

{:.input}
```python
# Final value of month
month
```

{:.output}
{:.execute_result}



    21.336





## Automate Summary Statistics on Multiple Numpy Arrays

By now, you may be excited that you can automate these kinds of tasks, 
but you may also be thinking that you would prefer to iterate on **numpy** 
arrays or **pandas** dataframes, instead of working with data values in lists.

You can do that, too! For example, you can build a loop that will calculate 
summary statistics (such as the sum or median values) of multiple data structures, 
such as **numpy** arrays. Recall that you can use the functions `np.sum()` and `np.median()` to calculate sum and median values of a **numpy** array.

Begin by creating two **numpy** arrays containing the average monthly precipitation values in 2002 and 2013 for <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank">Boulder, Colorado, provided by the U.S. National Oceanic and Atmospheric Administration (NOAA).</a> 

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
# Import necessary packages
import numpy as np

# Array of average monthly precip (inches) for 2002 in Boulder, CO
precip_2002_arr = np.array([1.07, 0.44, 1.50, 0.20, 3.20, 1.18, 
                            0.09, 1.44, 1.52, 2.44, 0.78, 0.02])

# Array of average monthly precip (inches) for 2013 in Boulder, CO
precip_2013_arr = np.array([0.27, 1.13, 1.72, 4.14, 2.66, 0.61, 
                            1.03, 1.40, 18.16, 2.24, 0.29, 0.50])
```

### Create List of Numpy Arrays For Loop

Just like in the previous example, begin by creating the list upon which your 
loop will iterate. As you want to iterate on multiple **numpy** arrays, you can 
create a list that contains the object names for all of the **numpy** arrays that 
you want to work with in the loop. 

{:.input}
```python
# Create list of numpy arrays
arr_list = [precip_2002_arr, precip_2013_arr]
```

### Write Loop

Again, think about what type of loop would work best for this data. This time, 
you have a list of two object names, upon which you want to iterate a calculation: 
the **numpy** arrays for 2002 and 2013. Which type of loop structure is used in the 
code below?

{:.input}
```python
# Calculate sum and median for each numpy array in list
for arr in arr_list:    
    arr_sum = np.sum(arr)
    print("sum:", arr_sum)
    
    arr_median = np.median(arr)    
    print("median:", arr_median)    
```

{:.output}
    sum: 13.879999999999999
    median: 1.125
    sum: 34.15
    median: 1.265



Again, you can capture these values in new, separate lists by defining empty 
lists and using the assignment operator (`listname += [value]`) to add the results 
to each list.

{:.input}
```python
# Create new empty lists to receive values
monthly_precip_sum = []
monthly_precip_median = []

# Calculate sum and median for each numpy array and add to new lists
for arr in arr_list:    
    arr_sum = np.sum(arr)
    monthly_precip_sum.append(arr_sum)
    
    arr_median = np.median(arr)    
    monthly_precip_median.append(arr_median)
```

### Review the List Being Iterated Upon and the Placeholder in Loop

In the example above, you explicitly created both `monthly_precip_sum` and 
`monthly_precip_median` as empty lists to which the loop results could be appended. 
So at the end of the loop, they are no longer empty, as they have been populated with 
the results of each iteration of the loop.   

{:.input}
```python
# Lists contain the calculated values
print(monthly_precip_sum)
print(monthly_precip_median)
```

{:.output}
    [13.879999999999999, 34.15]
    [1.125, 1.265]



The variable `arr` is the placeholder variable that is created as part 
of the loop and serves as a placeholder to represent each item from the 
original list (`arr_list`), as the loop iterates. At the end of the loop, 
`arr` is equal to the last value that it was assigned (e.g. 
`precip_2013_arr`, the last array in the list).

Similarly, at the end of the loop, `arr_sum` and `arr_median` are also equal
to the last value that was calculated for each (e.g. the sum and median values 
for `precip_2013_arr`.

{:.input}
```python
# Final value of arr
print(arr)

# Final value of arr_sum
print(arr_sum)

# Final value of arr_median
print(arr_median)
```

{:.output}
    [ 0.27  1.13  1.72  4.14  2.66  0.61  1.03  1.4  18.16  2.24  0.29  0.5 ]
    34.15
    1.265



## Automate Calculation on Multiple Columns in Pandas Dataframe

In addition to running a loop on multiple data structures (e.g multiple 
**numpy** arrays like in the previous example), you can also run loops on 
multiple columns of a **pandas** dataframe. For example, you may need to 
convert the measurement units of multiple columns, such as converting the 
precipitation values from inches to millimeters (1 inch = 25.4 millimeters). 

Begin by creating a new **pandas** dataframe of the same average monthly 
precipitation values in 2002 and 2013 for Boulder, CO. 

{:.input}
```python
# Import necessary packages
import pandas as pd

# Average monthly precip (inches) in 2002 and 2013 for Boulder, CO
precip_2002_2013_df = pd.DataFrame(columns=["month", "precip_2002", "precip_2013"],
                                   data=[
                                        ["Jan", 1.07, 0.27],   ["Feb", 0.44, 1.13],
                                        ["Mar", 1.50, 1.72],   ["Apr", 0.20, 4.14],
                                        ["May", 3.20, 2.66],   ["June", 1.18, 0.61],
                                        ["July", 0.09, 1.03],  ["Aug", 1.44, 1.40],
                                        ["Sept", 1.52, 18.16], ["Oct", 2.44, 2.24],
                                        ["Nov", 0.78, 0.29],   ["Dec", 0.02, 0.50]
                                   ])

precip_2002_2013_df
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
      <th>month</th>
      <th>precip_2002</th>
      <th>precip_2013</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>1.07</td>
      <td>0.27</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>0.44</td>
      <td>1.13</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>1.50</td>
      <td>1.72</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>0.20</td>
      <td>4.14</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>3.20</td>
      <td>2.66</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>1.18</td>
      <td>0.61</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>0.09</td>
      <td>1.03</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>1.44</td>
      <td>1.40</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>1.52</td>
      <td>18.16</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>2.44</td>
      <td>2.24</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>0.78</td>
      <td>0.29</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.02</td>
      <td>0.50</td>
    </tr>
  </tbody>
</table>
</div>





### Create List of Column Names

Just like in the previous examples, begin by creating the list upon which your 
loop will iterate. As you want to iterate on multiple columns in a **pandas** 
dataframe, you can create a list that contains the column names that you want to 
work with in the loop. 

{:.input}
```python
# Create a list of column names
cols = ["precip_2002", "precip_2013"]
```

### Write Loop

Once again, think about what type of loop would work best for this data. 
You have two columns in one **pandas** dataframe upon which you want to iterate 
a calculation: 2002 and 2013. Recall from previous chapters that you can use assignment 
operators recalculate columns in **pandas** dataframe: 

`df["column_name"] *= 25.4` 

What do you notice about the syntax below that is a little different?

{:.input}
```python
# Convert values for each column in cols list
for column in cols:    
    precip_2002_2013_df[column] *= 25.4

# Print new values    
precip_2002_2013_df
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
      <th>month</th>
      <th>precip_2002</th>
      <th>precip_2013</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Jan</td>
      <td>27.178</td>
      <td>6.858</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Feb</td>
      <td>11.176</td>
      <td>28.702</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Mar</td>
      <td>38.100</td>
      <td>43.688</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Apr</td>
      <td>5.080</td>
      <td>105.156</td>
    </tr>
    <tr>
      <th>4</th>
      <td>May</td>
      <td>81.280</td>
      <td>67.564</td>
    </tr>
    <tr>
      <th>5</th>
      <td>June</td>
      <td>29.972</td>
      <td>15.494</td>
    </tr>
    <tr>
      <th>6</th>
      <td>July</td>
      <td>2.286</td>
      <td>26.162</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Aug</td>
      <td>36.576</td>
      <td>35.560</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Sept</td>
      <td>38.608</td>
      <td>461.264</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Oct</td>
      <td>61.976</td>
      <td>56.896</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Nov</td>
      <td>19.812</td>
      <td>7.366</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Dec</td>
      <td>0.508</td>
      <td>12.700</td>
    </tr>
  </tbody>
</table>
</div>





### Review the List Being Iterated Upon and the Placeholder in Loop

Note that because `column` is an implicit variable or placeholder for the 
columns in the list, you do not need to use quotations `""` to indicate a 
specific column name in the loop such as `"precip_2002"`. 

In the first iteration, `column` would contain the values in the `precip_2002` 
column, while in the last iteration, `column` would contain the values in the 
`precip_2013` column. You know you are using an implicit variable because the 
column name will change with each iteration. Also, notice the placement of code 
`precip_2002_2013` to display the dataframe *after* the loop is completed. 

This code is not contained with the loop, so you do not see the dataframe each time that the loop iterates. You only see the dataframe when the loop is completed. 

## Automate Data Downloads Using EarthPy

Imagine that you have multiple URLs from which you need to download data 
for a workflow. Rather than writing out the same code to download each 
file at time, you can use a loop to download all of these files using one set of code. 

Begin by importing the necessary package, **earthpy**, which is needed to access the 
`get_data()` function. You will also use **os** to print the contents of the default 
data directory.

{:.input}
```python
# Import necessary packages
import os
import earthpy as et
```

### Create List of URLs For Loop

Just like in the previous examples, begin by creating the list upon 
which your loop will iterate. As you want to iterate on multiple URLs, 
you can create a list that contains the URLs for all of the files that 
you want to download.

In this case, it is useful to create variables for the individual URLs first, 
so that you can easily manage them as well as make the code more readable.  

{:.input}
```python
# URL for avg monthly precip (inches) for Boulder, CO
avg_month_precip_url = 'https://ndownloader.figshare.com/files/12565616'

# URL for precip data for 2002 and 2013 (inches) for array
precip_2002_2013_url = 'https://ndownloader.figshare.com/files/12707792'

# Create list of URLs
urls = [avg_month_precip_url, precip_2002_2013_url]
```

### Write Loop

Once again, think about what type of loop would work best for this task. 
You have a list of URLs upon which you want to iterate some code, which 
in this case is `et.data.get_data()` to download each file.

{:.input}
```python
# Download each url in list
for file_url in urls:
    et.data.get_data(url=file_url)
```

### Review the List Being Iterated Upon and the Placeholder in Loop

Note that in order for `et.data.get_data()` to execute successfully, 
you must specify that the parameter `url` for the function is equal 
to the placeholder, which in this example is `file_url`. 

This is a specific requirement of this function, as `et.data.get_data(url)` 
will result in an error that `url` is not a valid key for a dataset in 
**earthpy** (see more details in the
<a href="https://earthpy.readthedocs.io/en/latest/gallery_vignettes/get_data.html#sphx-glr-gallery-vignettes-get-data-py" target="_blank">code examples for earthpy</a>).

```
KeyError: "Key not found in earthpy.io.DATA_URLS
```

With the correct syntax shown in the example above, the loop will execute 
`et.data.get_data(url=file_url)` successfully on the URLs provided in the 
list. In the first iteration, `file_url` is set to `avg_month_precip_url`, 
and then in the last iteration, `file_url` is set to `precip_2002_2013_url`.


### Check Files in Directory

You can see that when using `et.data.get_data()` in a loop, you no longer 
get the path printed for each downloaded file. However, you can use another 
function from the **os** package to list the contents (i.e. files and 
subdirectories) of a directory: `os.listdir()`. Recall that by default, 
**earthpy** downloads files to a subdirectory called `earthpy-downloads` 
under the `data` directory in the `earth-analytics` directory (e.g. 
`earth-analytics/data/earthpy-downloads/`).

With this knowledge, you can define a path to this directory and provide 
that path to the function `os.listdir()` to list out the contents of that 
directory. The files that you downloaded with the loop above will be listed 
in the contents of the directory.

{:.input}
```python
# Create path for data directory
data_dir = os.path.join(et.io.HOME, 
                        "earth-analytics", 
                        "data", 
                        "earthpy-downloads")

os.listdir(data_dir)
```

{:.output}
{:.execute_result}



    ['ne_50m_admin_0_boundary_lines_land',
     'avg-precip-months-seasons.csv',
     'OSMP_Climbing_Formations.csv',
     'ne_50m_populated_places_simple',
     'months.txt',
     'ne_50m_coastline',
     'naip-before-after',
     'ne_50m_admin_0_countries',
     'avg-monthly-temp-fahr',
     'monthly-precip-2002-2013.csv',
     'precip-2002-2013-months-seasons.csv',
     'avg-monthly-precip.txt',
     'City_Limits.geojson']





Congratulations - you have automated your first tasks in this textbook using **Python**!

