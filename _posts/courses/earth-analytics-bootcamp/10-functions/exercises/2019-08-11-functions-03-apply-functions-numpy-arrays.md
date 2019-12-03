---
layout: single
title: 'Apply Functions to Numpy Arrays'
excerpt: "This lesson teaches you how to apply functions to numpy arrays in Python."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['functions']
permalink: /courses/earth-analytics-bootcamp/functions/apply-functions-numpy-arrays/
nav-title: "Apply Functions to Numpy Arrays"
dateCreated: 2019-08-11
modified: 2018-08-22
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 10
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to apply custom functions to `numpy arrays` in `Python` and assign the output of functions to new `numpy arrays`.

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Apply custom functions to `numpy arrays`
* Assign the output of functions to new `numpy arrays`
* Use the axes of `numpy arrays` to access values across rows or columns

</div>

## Example: Recalculate Numpy Array

In the previous lesson, you learned how to write custom functions to calculate results. However, you noticed that your function did not actually update the values of the original data. 

To do that, you need to assign the results of the function to a new variable. Luckily, the syntax will look familiar. 

For example, take the custom function that converts inches to millimeters (e.g. `in_to_mm`). You can provide a `numpy array` as the input, and you receive an output that displays the recalculated values.

{:.input}
```python
# import necessary package
import numpy as np

# input parameter: numpy array for average monthly precip (inches) in 2002 for Boulder, CO
avg_monthly_precip_2002_in = np.array([1.07, 0.44, 1.50, 0.20, 3.20, 1.18, 0.09, 1.44, 1.52, 2.44, 0.78, 0.02])

# print data in `arrayname_in`
avg_monthly_precip_2002_in

# define function to convert inches to millimeters
def in_to_mm(x):
    
    # multiply an input parameter by 25.4
    # function can take a single value, single value variable, or numpy array as input
    # function can not take list or pandas dataframe as input
    
    return (x * 25.4)

# call the function to run on numpy array for 2002
in_to_mm(avg_monthly_precip_2002_in)
```

{:.output}
{:.execute_result}



    array([27.178, 11.176, 38.1  ,  5.08 , 81.28 , 29.972,  2.286, 36.576,
           38.608, 61.976, 19.812,  0.508])





If you print the data in `avg_monthly_precip_2002_in`, you will see that original data was not modified, and only acted as the input parameter for the function. 

Also recall that `x` is still not an explicit variable. It is simply a placeholder for the input parameter.

{:.input}
```python
# print data in arrayname
avg_monthly_precip_2002_in

# uncomment line to run, as it will result in an error
#print(x)
```

{:.output}
{:.execute_result}



    array([1.07, 0.44, 1.5 , 0.2 , 3.2 , 1.18, 0.09, 1.44, 1.52, 2.44, 0.78,
           0.02])





You can actually assign the results of the function to a new `numpy array` by creating a new variable and setting it equal to the results of the function. 

To store these values, you need to create a new `numpy array` and set it equal to a `numpy array` created from function output. 

You can do this using the syntax `arrayname = np.array(function(parameter))`.

This code line does multiple things at once: it runs the function on the input parameter, and then creates a `numpy array` from the output.

{:.input}
```python
# assign the output of the function to a new array 
avg_monthly_precip_2002_mm = np.array(in_to_mm(avg_monthly_precip_2002_in))

# print data in new array
avg_monthly_precip_2002_mm
```

{:.output}
{:.execute_result}



    array([27.178, 11.176, 38.1  ,  5.08 , 81.28 , 29.972,  2.286, 36.576,
           38.608, 61.976, 19.812,  0.508])





In this example, the input `numpy array` is one-dimensional, as is the `numpy array` created from the output. 

**How can you check that both `avg_monthly_precip_2002_in` and `avg_monthly_precip_2002_mm` are one-dimensional arrays?**


## Example: Calculate Multiple Statistics of Numpy Array

In the lesson on loops, you learned how to loop through a list to calculate multiple summary statistics such as mean, sum, and median on `numpy arrays`. 

You can also write a custom function that will run multiple summary functions on an input `numpy array` and store the output of the function as a new `numpy array`.

As you know that `x` was just a placeholder for the input array, you can start to use more specific placeholder names for the input parameter, such as `array`. 

{:.input}
```python
# define function to calculate mean of numpy array

def min_max_stats(array):
    
    # calculate min and max of numpy array
    # function can take a numpy array as input
    # function can not take list or pandas dataframe as input
    
    stat_min = np.min(array)
    stat_max = np.max(array)
    
    return(stat_min, stat_max)
```

Note that you can include multiple lines of code before the return statement, and you can return multiple outputs.

In this example, the function is returning the minimum and maximum values of the input `numpy array`, which is an one-dimensional array. 

Run the function to see the output.

{:.input}
```python
# call function with input parameter `avg_monthly_precip_2002_mm`
min_max_stats(avg_monthly_precip_2002_mm)
```

{:.output}
{:.execute_result}



    (0.508, 81.28)





You can that the summary values are not returned a `numpy array`. 

This is because the output is simply displaying the summary result of the first statistics (i.e. `min`) and then displaying the summary result of the second statistics (i.e. `max`). 

Once more, to store these values, you need to create a new `numpy array` and set it equal to a `numpy array` created from function output. 

{:.input}
```python
# call the function with input parameter and create new array from output using the np.array() function
min_max_precip_2002 = np.array(min_max_stats(avg_monthly_precip_2002_mm))

#print data
min_max_precip_2002
```

{:.output}
{:.execute_result}



    array([ 0.508, 81.28 ])





You can see that the two values returned from the function are now stored as a new one-dimensional array, with the values in the same order that they are provided in the return statement. 

You can check the number of dimensions of this new `numpy array` using the `.ndim` attribute of `numpy arrays`, in addition to checking the number of rows and columns with the attribute `.shape`.

{:.input}
```python
# print number of rows/columns using the .shape attribute of numpy arrays
min_max_precip_2002.shape
```

{:.output}
{:.execute_result}



    (2,)





{:.input}
```python
# print number of dimensions using the .ndim attribute of numpy arrays
min_max_precip_2002.ndim
```

{:.output}
{:.execute_result}



    1





### Two-dimensional Arrays

You can also run the previously created function on a two-dimensional `numpy array` to find the minimum and maximum values across the array.

First, begin by applying your first function `in_to_mm` to convert the values and save the output to a new `numpy array`. 

{:.input}
```python
# manually create a new numpy array for average monthly precip in 2002 for Boulder, CO
avg_monthly_precip_2002_2013_in = np.array([[1.07, 0.44, 1.50, 0.20, 3.20, 1.18, 0.09, 1.44, 1.52, 2.44, 0.78, 0.02], 
                                         [0.27, 1.13, 1.72, 4.14, 2.66, 0.61, 1.03, 1.40, 18.16, 2.24, 0.29, 0.50] ])

# call in_to_mm function with input parameter and create new array from output
avg_monthly_precip_2002_2013_mm = np.array(in_to_mm(avg_monthly_precip_2002_2013_in))

#print data
avg_monthly_precip_2002_2013_mm
```

{:.output}
{:.execute_result}



    array([[ 27.178,  11.176,  38.1  ,   5.08 ,  81.28 ,  29.972,   2.286,
             36.576,  38.608,  61.976,  19.812,   0.508],
           [  6.858,  28.702,  43.688, 105.156,  67.564,  15.494,  26.162,
             35.56 , 461.264,  56.896,   7.366,  12.7  ]])





Then, apply the function `min_max_stats` to your new `numpy array`. 

{:.input}
```python
# call the min_max_stats function with input parameter
min_max_stats(avg_monthly_precip_2002_2013_mm)
```

{:.output}
{:.execute_result}



    (0.508, 461.26399999999995)





Notice that the minimum value was identified in the first row of the two-dimensional array, while the maximum value was identified in the second row of the two-dimensional array.

**In this example, did you save the output results to a new `numpy array`?** 


## Example: Calculate Statistics Across Numpy Array Axes

You can also expand your function to calculate the statistics separately for each row or each column in the two-dimensional `numpy array`, using the axes of `numpy arrays`. 

This means that you would receive one summary value for each row or each column in the two-dimensional `numpy array`.

### Calculate Across Rows

To run a summary statistic for each row of a two-dimensional array, you can add a parameter `axis = 1` to the `numpy` function that you are using to run the summary statistic.

In the example below, the maximum value for each row is identified using `axis = 1` as a parameter in the `np.max()` function. 

As there were only two rows in the `numpy array`, the function will only return two values (i.e. one maximum value for each row in the array). Recall that the data only contained two years of data.

{:.input}
```python
# define function to calculate max across rows of two-dimensional numpy array

def max_stats_rows(array):
    
    # calculate max of two-dimensional numpy array for each row
    # function can take a numpy array as input
    # function can not take list or pandas dataframe as input
    
    stat_max_row = np.max(array, axis = 1)
    return(stat_max_row)

# call the function with input parameter
max_stats_rows(avg_monthly_precip_2002_2013_mm)
```

{:.output}
{:.execute_result}



    array([ 81.28 , 461.264])





### Calculate Across Columns

Similarly, you can use `axis = 0` to run a summary statistic separately for each column of a two-dimensional array.

In the example below, the maximum value for each column of the two-dimensional array is identified using `axis = 0` as a parameter in the `np.max()` function. 

As there were twelve columns in the `numpy array`, the function will return twelve values (i.e. one maximum value for each column in the array). Recall that the data contained values for each month of the year.

{:.input}
```python
# define function to calculate max across columns of two-dimensional numpy array

def max_stats_columns(array):

    # calculate max of two-dimensional numpy array for each row
    # function can take a numpy array as input
    # function can not take list or pandas dataframe as input
    
    stat_max_column = np.max(array, axis = 0)
    return(stat_max_column)

# call the function with input parameter
max_stats_columns(avg_monthly_precip_2002_2013_mm)
```

{:.output}
{:.execute_result}



    array([ 27.178,  28.702,  43.688, 105.156,  81.28 ,  29.972,  26.162,
            36.576, 461.264,  61.976,  19.812,  12.7  ])





### Assign Output of Function to New Numpy Array

Again, notice that when you try to print `stat_max_row` or `stat_max_column`, you get an error. 

{:.input}
```python
# uncomment line to run, as it will result in an error
#print(stat_max_row)

# uncomment line to run, as it will result in an error
#print(stat_max_column)
```

Although the output of these functions look like one-dimensional arrays, the results have not explicitly been saved as one-dimensional arrays. 

Just like in the example earlier, you can assign the results of the function to a new `numpy array` by creating a new variable and setting it equal to the results of the function. 

{:.input}
```python
# call the function with input parameter and create new array from output
year_max_precip_2002_2013 = np.array(max_stats_rows(avg_monthly_precip_2002_2013_mm))

# print data in yearmax_avg_monthly_precip_2002_2013
year_max_precip_2002_2013
```

{:.output}
{:.execute_result}



    array([ 81.28 , 461.264])





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Test your `Python` skills to:

1. Write a function that identifies the **minimum** value of each **column** in a two-dimensional `numpy array` (e.g. `avg_monthly_precip_2002_2013_mm`).

2. Run the function on `avg_monthly_precip_2002_2013_mm` and assign the output to a new `numpy array`. Print your new `numpy array` to see the minimum values for each columm (i.e. each month of data).

</div>


{:.output}
{:.execute_result}



    array([ 6.858, 11.176, 38.1  ,  5.08 , 67.564, 15.494,  2.286, 35.56 ,
           38.608, 56.896,  7.366,  0.508])





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

Test your `Python` skills to:

1. Check that the `numpy array` that created from the output in the previous challenge is a one-dimensional array. 
    * Hint: in addition to the attribute `arrayname.shape`, you can also run `arrayname.ndim` to get an exact number of dimensions. 

</div>


{:.output}
    Shape of year_min_precip_2002_2013:  (12,)
    Number of dimensions of year_min_precip_2002_2013:  1


