---
layout: single
title: 'Data Wrangling With Numpy Arrays'
excerpt: "This lesson teaches you how to wrangle data (e.g. run multi-task functions, combine) with numpy arrays."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['data-wrangling']
permalink: /courses/earth-analytics-bootcamp/data-wrangling/data-wrangling-numpy-arrays/
nav-title: "Data Wrangling With Numpy Arrays"
dateCreated: 2019-08-11
modified: 2018-08-22
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to run functions that execute multiple tasks on a `numpy array` and combine multiple `numpy arrays` into a new `numpy array`. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Write functions that execute multiple tasks on `numpy array` and save the final output
* Append `numpy arrays` to create a new `numpy array`

</div>


## Write Function That Executes Multiple Tasks on Numpy Array and Save Output

In previous lessons, you have written multiple functions, including a function that converts the units of a `numpy array` from inches to millimeters and another that calculates the mean across each column of a `numpy array`.

### Definitions of Existing Functions 

{:.input}
```python
# define function to convert inches to millimeters
def in_to_mm(x):
    
    # multiply an input parameter by 25.4 to convert from inches to millimeters
    # function can take a single value, single value variable, or numpy array as input
    # function can not take list or pandas dataframe as input
    # returns values multiplied by 25.4
    
    return (x * 25.4)


# define function to calculate mean across columns of two-dimensional numpy array
def mean_stats_columns(array):

    # calculate mean of two-dimensional numpy array for each column
    # function can take a numpy array as input
    # function can not take list or pandas dataframe as input
    # returns the mean of each column (axis = 0)
    
    stat_mean_column = np.mean(array, axis = 0)
    return(stat_mean_column)
```

### Review Running Functions on Numpy Array

You already know that you can run each function separately and save the output to a new `numpy array` using `new_array = np.array(function(input_array))`.  

Begin by reviewing how to run functions and save the output. 

First, create some data that has a familiar structure for precipitation data: one row for each year of data and columns for each month of year.

{:.input}
```python
# import necessary package
import numpy as np

# manually create a new numpy array for monthly precip in 2002 and 2003 for Boulder, CO
monthly_precip_2002_2003_in = np.array([[1.07, 0.44, 1.50, 0.20, 3.20, 1.18, 0.09, 1.44, 1.521, 2.44, 0.78, 0.02], 
                                         [0.09, 1.52, 5.44, 2.99, 2.62, 2.69, 0.71, 3.52, 0.35, 0.45, 0.80, 0.84]])
```

Then, run the first function to convert the values from inches to millimeters and save the output.

{:.input}
```python
# call in_to_mm function with input parameter and create new array from output
monthly_precip_2002_2003_mm = np.array(in_to_mm(monthly_precip_2002_2003_in))

#print data
monthly_precip_2002_2003_mm
```

{:.output}
{:.execute_result}



    array([[ 27.178 ,  11.176 ,  38.1   ,   5.08  ,  81.28  ,  29.972 ,
              2.286 ,  36.576 ,  38.6334,  61.976 ,  19.812 ,   0.508 ],
           [  2.286 ,  38.608 , 138.176 ,  75.946 ,  66.548 ,  68.326 ,
             18.034 ,  89.408 ,   8.89  ,  11.43  ,  20.32  ,  21.336 ]])





Last, run the second function on the output from the first function to calculate the mean of the columns.

{:.input}
```python
# call the function mean_stats_columns with input parameter
mean_monthly_precip_2002_2003_mm = np.array(mean_stats_columns(monthly_precip_2002_2003_mm))

# print data in new array
mean_monthly_precip_2002_2003_mm
```

{:.output}
{:.execute_result}



    array([14.732 , 24.892 , 88.138 , 40.513 , 73.914 , 49.149 , 10.16  ,
           62.992 , 23.7617, 36.703 , 20.066 , 10.922 ])





### Combine Existing Functions into One Function

Instead of calling two functions separately on the same `numpy array`, you can write a new function that will execute both of these functions at one time.

This is useful in cases when you only want to save the output of the last function (i.e. the mean of each column already converting to millimeters).

Begin by defining your function, as you have before, using the keyword def. 

In your code before the return statement, include the function `in_to_mm`. Pass the implicit output of this function to the next function `mean_stats_columns`.

{:.input}
```python
# define function to convert values in a numpy array and then calculate mean across columns
def mean_columns_mm(array_in):

    # function can take a numpy array as input
    # function can not take list or pandas dataframe as input
    # returns the max of each column, already converted to millimeters
    
    # use function to convert from inches to millimeters
    array_mm = in_to_mm(array_in)
    
    # use function to calculate mean of two-dimensional numpy array for each column
    stat_mean_column = mean_stats_columns(array_mm)
    
    return(stat_mean_column)
```

Note that within a function, you do not have save an output in order for the next function to use it. Once again, the implicit variables (`array_in` and `array_mm`) are acting as placeholders for the input data as it moves through the workflow.

### Run the New Function and Save Output

Now that you have one function that completes multiple tasks, you can simply run that new function and save the output, just as you have done before.

{:.input}
```python
# call mean_columns_mm function with input parameter and create new array from output
mean_monthly_precip_2002_2003_mm = np.array(mean_columns_mm(monthly_precip_2002_2003_in))

#print data
mean_monthly_precip_2002_2003_mm
```

{:.output}
{:.execute_result}



    array([14.732 , 24.892 , 88.138 , 40.513 , 73.914 , 49.149 , 10.16  ,
           62.992 , 23.7617, 36.703 , 20.066 , 10.922 ])





How simple was that! Functions make it very easy to run multiple tasks on the same `numpy array`, and you can include as many operations and functions as needed to complete an entire workflow on a single `numpy array`. 

What are the dimensions of your final output `mean_monthly_precip_2002_2003_mm`? How do you know?

**What does each element in this final array represent?** 

## Combine Numpy Arrays Using Append

Another useful operation is being able to combine `numpy arrays`, so that you can run calculations and statistics across them. 

You can use the `np.append()` method to combine `numpy arrays` by appending one array after another. 

For example, you have two one-dimensional arrays that have the same structure but contain data for different years (e.g. one array for 2004 data and another array for 2005 data). 

{:.input}
```python
# manually create a new numpy array for monthly precip in 2004 for Boulder, CO
monthly_precip_2004_in = np.array([0.82, 1.31, 1.09, 5.66, 1.28, 3.96, 3.44, 2.88, 2.07, 2.32, 1.99, 0.35])

# manually create a new numpy array for monthly precip in 2005 for Boulder, CO
monthly_precip_2005_in = np.array([1.40, 0.31, 1.22, 3.86, 1.91, 2.68, 0.42, 1.63, 0.52, 2.80, 0.34, 0.43])
```

To calculate a summary statistic across the years, you can append the array for 2005 to the array for 2004, using the following syntax: 

`new_array = np.append([first_array], [second_array], axis = 0)`.

The `axis = 0` indicates that you want to use the column structure to append the data, so that the elements in the one-dimensional arrays become columns in the new two-dimensional array.

{:.input}
```python
# append 2005 array to 2004 array and save to new array
monthly_precip_2004_2005_in = np.append([monthly_precip_2004_in], [monthly_precip_2005_in], axis = 0)

monthly_precip_2004_2005_in
```

{:.output}
{:.execute_result}



    array([[0.82, 1.31, 1.09, 5.66, 1.28, 3.96, 3.44, 2.88, 2.07, 2.32, 1.99,
            0.35],
           [1.4 , 0.31, 1.22, 3.86, 1.91, 2.68, 0.42, 1.63, 0.52, 2.8 , 0.34,
            0.43]])





Now you can run calculations and statistics on this new combined two-dimensional array!

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Test your `Python` skills to:

1. Write a new function that calculates the sum of an input array (e.g. `sum_stats`). 

2. Write another function that combines the sum function with  `in_to_mm`, to calculate the sum of an array that has units in millimeters (e.g. `sum_mm`). 
    * Hint: define a new function that executes both `in_to_mm` and `sum_stats` in the correct order.

3. Execute your new function on `monthly_precip_2004_in` and print the output. 

4. Why do you only get a single value returned from this function?  

</div>


{:.output}
{:.execute_result}



    690.1179999999999





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

Test your `Python` skills to:

1. Write a new function that calculates the **sum across columns** of a two-dimensional array (e.g. `sum_stats_columns`). 
    
2. Write another function that combines the sum function with  `in_to_mm`, to calculate the sum across the columns of an array that has units in millimeters. 
    * Hint: define a new function that executes both `in_to_mm` and `sum_stats_columns` in the correct order.

3. Execute your new function on `monthly_precip_2004_2005_in` and save and print the output.

4. How many values are in the output array? What does each value represent?

</div>


{:.output}
{:.execute_result}



    array([ 56.388,  41.148,  58.674, 241.808,  81.026, 168.656,  98.044,
           114.554,  65.786, 130.048,  59.182,  19.812])




