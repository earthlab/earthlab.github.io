---
layout: single
title: 'Run Calculations and Summarize Numpy Arrays'
excerpt: "Numpy arrays are an efficient data structure for working with scientific data in Python. Learn how to run calculations on numpy arrays and summarize data in numpy arrays."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-numpy-arrays']
permalink: /courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/run-calculations-summarize-numpy-arrays/
nav-title: "Recalculate and Summarize Numpy Arrays"
dateCreated: 2019-09-06
modified: 2019-10-02
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this page, you will be able to:

* Check the dimensions and shape of **numpy** arrays.
* Run calculations and summarize data in one-dimensional and two-dimensional **numpy** arrays.

</div>

  
### Import Python Packages and Get Data

Begin by importing the necessary **Python** packages and downloading and importing the data into **numpy** arrays. 

As you learned previously in this chapter, you will use the **earthpy** package to download the data files, **os** to set the working directory, and **numpy** to import the data files into **numpy** arrays. 

{:.input}
```python
# Import necessary packages
import os
import numpy as np
import earthpy as et
```

{:.input}
```python
# Download data from URL to .txt with avg monthly precip data
monthly_precip_url = 'https://ndownloader.figshare.com/files/12565616'
et.data.get_data(url=monthly_precip_url)

# Download data from URL to .csv of precip data for 2002 and 2013
precip_2002_2013_url = 'https://ndownloader.figshare.com/files/12707792'
et.data.get_data(url=precip_2002_2013_url)
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12565616
    Downloading from https://ndownloader.figshare.com/files/12707792



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/monthly-precip-2002-2013.csv'





{:.input}
```python
# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.input}
```python
# Import average monthly precip to numpy array
fname = "data/earthpy-downloads/avg-monthly-precip.txt"
avg_monthly_precip = np.loadtxt(fname)

print(avg_monthly_precip)
```

{:.output}
    [0.7  0.75 1.85 2.93 3.05 2.02 1.93 1.62 1.84 1.31 1.39 0.84]



{:.input}
```python
# Import monthly precip for 2002 and 2013 to numpy array
fname = "data/earthpy-downloads/monthly-precip-2002-2013.csv"
precip_2002_2013 = np.loadtxt(fname, delimiter = ",")

print(precip_2002_2013)
```

{:.output}
    [[ 1.07  0.44  1.5   0.2   3.2   1.18  0.09  1.44  1.52  2.44  0.78  0.02]
     [ 0.27  1.13  1.72  4.14  2.66  0.61  1.03  1.4  18.16  2.24  0.29  0.5 ]]



## Check Dimensions and Shape of Numpy Arrays

It can be helpful to check the dimensions and shape of **numpy** arrays (e.g. the number of rows and columns of a two-dimensional array) before you begin to use the data. 

**Numpy** arrays have two attributes (i.e. built-in characteristics automatically assigned to objects) that provide useful information on their dimensions and shape: `ndim` and `.shape`.  

You can use `.ndim` attribute of **numpy** arrays (e.g. `array.ndim`) to get the number dimensions of the **numpy** array. 

For example, you can check the dimensions of `avg_monthly_precip` and `precip_2002_2013` to check that they are one-dimensional and two-dimensional, respectively. 

{:.input}
```python
# Check dimensions of avg_monthly_precip
avg_monthly_precip.ndim
```

{:.output}
{:.execute_result}



    1





{:.input}
```python
# Check dimensions of precip_2002_2013
precip_2002_2013.ndim
```

{:.output}
{:.execute_result}



    2





Another useful attribute of **numpy** arrays is the `.shape` attribute, which provides specific information on how the data is stored within the **numpy** array. 

For an one-dimensional **numpy** array, the `.shape` attribute returns the number of elements, while for a two-dimensional **numpy** array, the `.shape` attribute returns the number of rows and columns.

For example, the `.shape` attribute of `precip_2002_2013` tells us that it has two dimensions because there are two values returned. The first value is the number of rows, while the second value is the number of columns. 

{:.input}
```python
# Check shape of precip_2002_2013
precip_2002_2013.shape
```

{:.output}
{:.execute_result}



    (2, 12)





This result is expected given what you know about the data. Recall that `precip_2002_2013` contains 2 years of data (one in each row) with 12 values for average monthly precipitation in each year (one month in each column).  

Next, check the `.shape` for `avg_monthly_precip`. 

{:.input}
```python
# Check shape of avg_monthly_precip
avg_monthly_precip.shape
```

{:.output}
{:.execute_result}



    (12,)





The `.shape` attribute of `avg_monthly_precip` tells us that it is an one-dimensional **numpy** array, as only one value was returned: the number of elements, or values.  

In the case of `avg_monthly_precip`, there are only 12 elements, one value of average monthly precipitation for each month (an average value across all years of data).

## Run Calculations on Numpy Arrays

A key benefit of **numpy** arrays is that they support mathematical operations on an element-by-element basis, meaning that you can actually run one operation (e.g. `array *= 25.4`) on the entire array with a single line of code. 

For example, you can run a calculation to convert the values `avg_monthly_precip` from inches to millimeters (1 inch = 25.4 millimeters) and save it to a new **numpy** array as follows:

`avg_monthly_precip_mm = avg_monthly_precip * 25.4`

Or, if you do not need to retain the original **numpy** array, you can use an assignment operator as shown below to assign the new values to the original variable. 

{:.input}
```python
# Check the original values
print(avg_monthly_precip)

# Use assignment operator to convert values from in to mm
avg_monthly_precip *= 25.4

# Print new values
print(avg_monthly_precip)
```

{:.output}
    [0.7  0.75 1.85 2.93 3.05 2.02 1.93 1.62 1.84 1.31 1.39 0.84]
    [17.78  19.05  46.99  74.422 77.47  51.308 49.022 41.148 46.736 33.274
     35.306 21.336]



These arithmetic calculations will work on any **numpy** array, including two-dimensional and multi-dimensional **numpy** arrays. 

{:.input}
```python
# Check the original values
print(precip_2002_2013)

# Use assignment operator to convert values from in to mm
precip_2002_2013 *= 25.4

# Print new values
print(precip_2002_2013)
```

{:.output}
    [[ 1.07  0.44  1.5   0.2   3.2   1.18  0.09  1.44  1.52  2.44  0.78  0.02]
     [ 0.27  1.13  1.72  4.14  2.66  0.61  1.03  1.4  18.16  2.24  0.29  0.5 ]]
    [[ 27.178  11.176  38.1     5.08   81.28   29.972   2.286  36.576  38.608
       61.976  19.812   0.508]
     [  6.858  28.702  43.688 105.156  67.564  15.494  26.162  35.56  461.264
       56.896   7.366  12.7  ]]



### Revisit Python Lists Versus Numpy Arrays 

Running these types of calculations on **numpy** arrays highlight one key difference between **Python** lists and **numpy** arrays.

Recall that when working with variables and lists, you created separate variables for each monthly average precipitation value to convert values (e.g. `jan *= 25.4`), and then you created a new list containing all of these converted monthly values. 

You had to complete that longer workflow because you cannot complete the same mathematical operations on **Python** lists. 

For example, try to run the code below:

```python
precip_list = [0.70, 0.75, 1.85, 2.93, 3.05, 2.02, 
              1.93, 1.62, 1.84, 1.31, 1.39, 0.84]

precip_list *=  25.4
```

You will receive an error that this type of operation is allowed on lists:

```python
TypeError: can't multiply sequence by non-int of type 'float'
```

As you can see, using **numpy** arrays makes it very easy to run calculations on scientific data.  Next, you will learn how **numpy** arrays can be used to calculate summary statistics of data such as identifying mean, maximum, and minimum values. 

## Summarize Data in One-dimensional Numpy Arrays

Another useful feature of **numpy** arrays is the ability to run summary statistics (e.g. calculating averages, finding minimum or maximum values) across the entire array of values. 

For example, you can use the `np.mean()` function in to calculate the average value across an array (e.g. `np.mean(array)`). 

{:.input}
```python
# Calculate mean
mean_avg_precip = np.mean(avg_monthly_precip)

print("mean average monthly precipitation:", mean_avg_precip)
```

{:.output}
    mean average monthly precipitation: 42.820166666666665



To identify other functions that you can within **numpy**




For example, we can use `min()` and `max()` to find the minimum and maximum values in an array.  

{:.input}
```python
# Calculate and pront minimum and maximum values
print("minimum average monthly precipitation:", np.min(avg_monthly_precip))
print("maximum average monthly precipitation:", np.max(avg_monthly_precip))
```

{:.output}
    minimum average monthly precipitation: 17.779999999999998
    maximum average monthly precipitation: 77.46999999999998



Notice that in this code, you can only identify the value that is the minimum or maximum but not the month in which the value occurred. This is because `precip` and `months` are not connected in an easy way that would allow you to determine the month that matches the values. 

You could use indexing to determine the index location of the maximum value in `precip` and then query that same index location in `months`, but rest assured, there is an easier way to do this! 

In future lessons on `pandas dataframes`, you will learn how to work with data in a tabular structure, so that precip values are linked with their corresponding month names.



## Summarize Data Across Axes of Two-dimensional Numpy Arrays

You can also expand your function to calculate the statistics separately for each row or each column in the two-dimensional numpy array, using the axes of numpy arrays.

This means that you would receive one summary value for each row or each column in the two-dimensional numpy array.

### Calculate Across Rows

To run a summary statistic for each row of a two-dimensional array, you can add a parameter axis = 1 to the numpy function that you are using to run the summary statistic.

In the example below, the maximum value for each row is identified using axis = 1 as a parameter in the np.max() function.

As there were only two rows in the numpy array, the function will only return two values (i.e. one maximum value for each row in the array). Recall that the data only contained two years of data.

{:.input}
```python
np.max(precip_2002_2013, axis = 1)
```

{:.output}
{:.execute_result}



    array([ 81.28 , 461.264])





### Calculate Across Columns

Similarly, you can use axis = 0 to run a summary statistic separately for each column of a two-dimensional array.

In the example below, the maximum value for each column of the two-dimensional array is identified using axis = 0 as a parameter in the np.max() function.

As there were twelve columns in the numpy array, the function will return twelve values (i.e. one maximum value for each column in the array). Recall that the data contained values for each month of the year.


{:.input}
```python

np.max(precip_2002_2013, axis = 0)
```

{:.output}
{:.execute_result}



    array([ 27.178,  28.702,  43.688, 105.156,  81.28 ,  29.972,  26.162,
            36.576, 461.264,  61.976,  19.812,  12.7  ])





