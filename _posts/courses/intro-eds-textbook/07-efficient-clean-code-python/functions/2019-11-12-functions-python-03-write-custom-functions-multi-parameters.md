---
layout: single
title: 'Write Functions with Multiple Parameters in Python'
excerpt: "A function is a reusable block of code that performs a specific task. Learn how to write functions that can take multiple as well as optional parameters in Python to eliminate repetition and improve efficiency in your code."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-functions-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/functions-modular-code/write-functions-with-multiple-and-optional-parameters-in-python/
nav-title: "Write Multi-Parameter Functions in Python"
dateCreated: 2019-11-12
modified: 2021-01-28
module-type: 'class'
chapter: 19
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/intro-to-earth-data-science/write-efficient-python-code/functions/write-functions-with-multiple-and-optional-parameters-in-python/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Write and execute custom functions with multiple input parameters in **Python**.
* Write and execute custom functions with optional input parameters in **Python**. 
 
</div>


## How to Define a Function with Multiple Parameters in Python

Previously in this textbook, you learned that an input parameter is the required information that you pass to the function for it to run successfully. The function will take the value or object provided as the input parameter and use it to perform some task.

You also learned that in **Python**, the required parameter can be defined using a placeholder variable, such as `data`, which represents the value or object that will be acted upon in the function. 


```python
def function_name(data):
```   

However, sometimes you may need additional information for the function to run successfully.

Luckily, you can write functions that take in more than one parameter by defining as many parameters as needed, for example: 

```python
def function_name(data_1, data_2):
``` 

When the function is called, a user can provide any value for `data_1` or `data_2` that the function can take as an input for that parameter (e.g. single value variable, list, **numpy** array, **pandas** dataframe column). 


## Write a Function with Multiple Parameters in Python

Imagine that you want to define a function that will take in two numeric values as inputs and return the product of these input values (i.e. multiply the values).  

Begin with the `def` keyword and the function name, just as you have before to define a function:

```python
def multiply_values
```

Next, provide two placeholder variable names for the input parameters, as shown below. 

```python
def multiply_values(x,y):
```

Add the code to multiply the values and the `return` statement to returns the product of the two values: 

```python
def multiply_values(x,y):
    z = x * y
    return z
```

Last, write a docstring to provide the details about this function, including a brief description of the function (i.e. how it works, purpose) as well as identify the input parameters (i.e. type, description) and the returned output (i.e. type, description).

{:.input}
```python
def multiply_values(x,y):
    """Calculate product of two inputs. 
    
    Parameters
    ----------
    x : int or float
    y : int or float

    Returns
    ------
    z : int or float
    """
    z = x * y
    return z
```

## Call Custom Functions with Multiple Parameters in Python

Now that you have defined the function `multiple_values()`, you can call it by providing values for the two input parameters.  

{:.input}
```python
# Call function with numeric values
multiply_values(x = 0.7, y = 25.4)
```

{:.output}
{:.execute_result}



    17.779999999999998





Recall that you can also provide pre-defined variables as inputs, for example, a value for precipitation and another value for a unit conversion value.  

{:.input}
```python
# Average monthly precip (inches) for Jan in Boulder, CO
precip_jan_in = 0.7

# Conversion factor from inches to millimeters
to_mm = 25.4
```

{:.input}
```python
# Call function with pre-defined variables
precip_jan_mm = multiply_values(
    x = precip_jan_in, 
    y = to_mm)

precip_jan_mm
```

{:.output}
{:.execute_result}



    17.779999999999998





Note that the function is not defined specifically for unit conversions, but as it completes a generalizable task, it can be used for simple unit conversions. 

## Combine Unit Conversion and Calculation of Statistics into One Function

Now imagine that you want to both convert the units of a **numpy** array from millimeters to inches and calculate the mean value along a specified axis for either columns or rows.

Recall the function definition that you previously wrote to convert values from millimeters to inches:

```python
def mm_to_in(mm):
    """Convert input from millimeters to inches. 
    
    Parameters
    ----------
    mm : int or float
        Numeric value with units in millimeters.

    Returns
    ------
    inches : int or float
        Numeric value with units in inches.
    """
    inches = mm / 25.4    
    return inches
```

You can expand this function to include running a mean along a specified axis for columns or rows, and then use this function over and over on many **numpy** arrays as needed.  

This new function can have descriptive names for the function and the input parameters that describe more clearly what the function accomplishes. 

Begin by defining the function with a descriptive name and the two necessary parameters: 
* the input array with values in millimeters
* the axis value for the mean calculation 

Use placeholder variable names that highlight the purpose of each parameter:


```python
def mean_mm_to_in_arr(arr_mm, axis_value):
```


Next, add the code to first calculate the mean of the input array along a specified axis, and then to convert the mean values from millimeters to inches. 

First, add the code line to calculate a mean along a specified axis. 


```python
def mean_mm_to_in_arr(arr_mm, axis_value):
    mean_arr_mm = np.mean(arr_mm, axis = axis_value)    
```


Next, add the code line to convert the mean array from millimeters to inches. In this case, the `return` statement should return the mean array in inches.


```python
def mean_mm_to_in_arr(arr_mm, axis_value):
    mean_arr_mm = np.mean(arr_mm, axis = axis_value)
    mean_arr_in = mean_arr_mm / 25.4 
        
    return mean_arr_in
    
```

Note that the function could be written to convert the values first and then calculate the mean. However, given that the function will complete both tasks and return the mean values in the desired units, it is more efficient to calculate the mean values first and then convert just those values, rather than converting all of the values in the input array. 


Last, include a docstring to provide the details about this function, including a brief description of the function (i.e. how it works, purpose) as well as identify the input parameters (i.e. type, description) and the returned output (i.e. type, description).

{:.input}
```python
def mean_mm_to_in_arr(arr_mm, axis_value):
    """Calculate mean values of input array along a specified
    axis and convert values from millimeters to inches.
    
    Parameters
    ----------
    arr_mm : numpy array
        Numeric values in millimeters.
    axis_value : int
        0 to calculate mean for each column.
        1 to calculate mean for each row.

    Returns
    ------
    mean_arr_in : numpy array
        Mean values of input array in inches.
    """    
    mean_arr_mm = np.mean(arr_mm, axis = axis_value)
    mean_arr_in = mean_arr_mm / 25.4 
        
    return mean_arr_in
```

Now that you have defined `mean_mm_to_in_arr()`, you can call the function with the appropriate input parameters.

Create some data and test your new function with different input values for the `axis_value` parameter.

{:.input}
```python
# Import necessary package to run function
import numpy as np
```

{:.input}
```python
# 2d array of average monthly precip (mm) for 2002 and 2013 in Boulder, CO
precip_2002_2013_mm = np.array([[27.178, 11.176, 38.1, 5.08, 81.28, 29.972, 
                                 2.286, 36.576, 38.608, 61.976, 19.812, 0.508],
                                [6.858, 28.702, 43.688, 105.156, 67.564, 15.494,  
                                 26.162, 35.56 , 461.264, 56.896, 7.366, 12.7]
                               ])
```

{:.input}
```python
# Calculate monthly mean (inches) for precip_2002_2013
monthly_mean_in = mean_mm_to_in_arr(arr_mm = precip_2002_2013_mm, 
                                    axis_value = 0)

monthly_mean_in
```

{:.output}
{:.execute_result}



    array([0.67 , 0.785, 1.61 , 2.17 , 2.93 , 0.895, 0.56 , 1.42 , 9.84 ,
           2.34 , 0.535, 0.26 ])





{:.input}
```python
# Calculate yearly mean (inches) for precip_2002_2013
yearly_mean_in = mean_mm_to_in_arr(arr_mm = precip_2002_2013_mm, 
                                   axis_value = 1)

yearly_mean_in
```

{:.output}
{:.execute_result}



    array([1.15666667, 2.84583333])





## Define Optional Input Parameters for a Function 

Your previously defined function works well if you want to use a specified axis for the mean.

However, notice what happens when you try to call the function without providing an axis value, such as for a one-dimensional array.

{:.input}
```python
# 1d array of average monthly precip (mm) for 2002 in Boulder, CO
precip_2002_mm = np.array([27.178, 11.176, 38.1,  5.08, 81.28, 29.972,  
                           2.286, 36.576, 38.608, 61.976, 19.812, 0.508])
```

```python
# Calculate mean (inches) for precip_2002
monthly_mean_in = mean_mm_to_in_arr(arr_mm = precip_2002_mm)
```

You get an error that the `axis_value` is missing:

```python
TypeError: mean_mm_to_in_arr() missing 1 required positional argument: 'axis_value'
```

What if you want to make the function more generalizable, so that the axis value is optional?

You can do that by specifying a default value for `axis_value` as `None` as shown below:

```python
def mean_mm_to_in_arr(arr_mm, axis_value=None):
```

The function will assume that the axis value is `None` (i.e. that an input value has not been provided by the user), unless specified otherwise in the function call.

However, as written, the original function code uses the axis value to calculate the mean, so you need to make a few more changes, so that the mean code runs with an axis value if a value is provided or runs without an axis value if one is not provided.

Luckily, you have already learned about conditional statements, which you can now add to your function to run the mean code with or without an axis value as needed. 

Using a conditional statement, you can check if `axis_value` is equal to `None`, in which case the mean code will run without an axis value. 

```python
def mean_mm_to_in_arr(arr_mm, axis_value=None):
    
    if axis_value is None:
        mean_arr_mm = np.mean(arr_mm) 
```

The `else` statement would mean that `axis_value` is not equal to `None` (i.e. a user has provided an input value) and thus would run the mean code with the specified axis value.

```python
def mean_mm_to_in_arr(arr_mm, axis_value=None):
    
    if axis_value is None:
        mean_arr_mm = np.mean(arr_mm)        
    else:
        mean_arr_mm = np.mean(arr_mm, axis = axis_value)
```

The code for the unit conversion and the `return` remain the same, just with updated names:

```python
def mean_mm_to_in_arr(arr_mm, axis_value=None):
    if axis_value is None:
        mean_arr_mm = np.mean(arr_mm)        
    else:
        mean_arr_mm = np.mean(arr_mm, axis = axis_value)
    
    mean_arr_in = mean_arr_mm / 25.4 
        
    return mean_arr_in
```

Last, include a docstring to provide the details about this revised function. Notice that the axis value has been labeled optional in the docstring. 

{:.input}
```python
def mean_mm_to_in_arr(arr_mm, axis_value=None):
    """Calculate mean values of input array and convert values 
    from millimeters to inches. If an axis is specified,
    the mean will be calculated along that axis. 

    
    Parameters
    ----------
    arr_mm : numpy array
        Numeric values in millimeters.
    axis_value : int (optional)
        0 to calculate mean for each column.
        1 to calculate mean for each row.

    Returns
    ------
    mean_arr_in : numpy array
        Mean values of input array in inches.
    """   
    if axis_value is None:
        mean_arr_mm = np.mean(arr_mm)        
    else:
        mean_arr_mm = np.mean(arr_mm, axis = axis_value)
    
    mean_arr_in = mean_arr_mm / 25.4 
        
    return mean_arr_in
```

Notice that the function will return the same output as before for the two-dimensional array `precip_2002_2013_mm`.

{:.input}
```python
# Calculate monthly mean (inches) for precip_2002_2013
monthly_mean_in = mean_mm_to_in_arr(arr_mm = precip_2002_2013_mm, 
                                    axis_value = 0)

monthly_mean_in
```

{:.output}
{:.execute_result}



    array([0.67 , 0.785, 1.61 , 2.17 , 2.93 , 0.895, 0.56 , 1.42 , 9.84 ,
           2.34 , 0.535, 0.26 ])





However, now you can also provide a one-dimensional array as an input without a specified axis and receive the appropriate output.

{:.input}
```python
# Calculate mean (inches) for precip_2002
monthly_mean_in = mean_mm_to_in_arr(arr_mm = precip_2002_mm)

monthly_mean_in
```

{:.output}
{:.execute_result}



    1.1566666666666667





## Combine Download and Import of Data Files into One Function

You can also write multi-parameter functions to combine other tasks into one function, such as downloading and importing data files into a **pandas** dataframe.

Think about the code that you need to include in the function:
1. download data file from URL: `et.data.get_data(url=file_url)`
2. import data file into **pandas** dataframe: `pd.read_csv(path)`

From this code, you can see that you will need two input parameters for the combined function:
1. the URL to the data file
2. the path to the downloaded file

Begin by specifying a function name and the placeholder variable names for the necessary input parameters. 

```python
def download_import_df(file_url, path):  
```

Next, add the code for download and the import. 

```python
def download_import_df(file_url, path):  
    et.data.get_data(url=file_url)  
    df = pd.read_csv(path)
```

However, what if the working directory has not been set before this function is called, and you do not want to use absolute paths? 

Since you know that the `get_data()` function creates the `earth-analytics` directory under the home directory if it does not already exist, you can safely assume that this combined function will also create that directory.

As such, you can include setting the working directory in the function, so that you do not have to worry about providing absolute paths to the function:

```python
def download_import_df(file_url, path):    
    
    et.data.get_data(url=file_url)      
    os.chdir(os.path.join(et.io.HOME, "earth-analytics"))    
    df = pd.read_csv(path)
    
    return df
```

Last, include a docstring to provide the details about this function, including a brief description of the function (i.e. how it works, purpose) as well as identify the input parameters (i.e. type, description) and the returned output (i.e. type, description).

{:.input}
```python
def download_import_df(file_url, path):   
    """Download file from specified URL and import file
    into a pandas dataframe from a specified path. 
    
    Working directory is set to earth-analytics directory 
    under home, which is automatically created by the
    download. 

    
    Parameters
    ----------
    file_url : str
        URL to CSV file (http or https).
    path : str
        Path to CSV file using relative path
        to earth-analytics directory under home.        

    Returns
    ------
    df : pandas dataframe
        Dataframe imported from downloaded CSV file.
    """ 
    
    et.data.get_data(url=file_url)      
    os.chdir(os.path.join(et.io.HOME, "earth-analytics"))    
    df = pd.read_csv(path)
    
    return df
```

Now that you have defined the function, you can import the packages needed to run the function and define the variables that you will use as input parameters.

{:.input}
```python
# Import necessary packages to run function
import os
import pandas as pd
import earthpy as et
```

{:.input}
```python
# URL for average monthly precip (inches) for 2002 and 2013 in Boulder, CO
precip_2002_2013_df_url = "https://ndownloader.figshare.com/files/12710621"

# Path to downloaded .csv file with headers
precip_2002_2013_df_path = os.path.join("data", "earthpy-downloads", 
                                        "precip-2002-2013-months-seasons.csv")
```

Using these variables, you can now call the function to download and import the file into a **pandas** dataframe. 

{:.input}
```python
# Create dataframe using download/import function
precip_2002_2013_df = download_import_df(
    file_url = precip_2002_2013_df_url, 
    path = precip_2002_2013_df_path)

precip_2002_2013_df
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12710621



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





###  Making Functions More Efficient Does Not Always Mean More Parameters

Note that you previously defined `download_import_df()` to take in two parameters, one for the URL and for the path, and the function works well to accomplish the task.

However, with a little investigation into the `et.data.get_data()` function, you can see that the output of that function is actually a path to the downloaded file!

```python
help(et.data.get_data)
```
In the docstring details provided, you can see that the full path to the downloaded data is returned by the function:

```
Returns
-------
path_data : str
    The path to the downloaded data.
```

This means that you can redefine `download_import_df()` to be more efficient by simply using the output of the `et.data.get_data()` function as the input to the `pd.read_csv()` function. 

Now, you actually only need one parameter for the URL and you do not have to define the working directory in the function, in order to find the appropriate file.

{:.input}
```python
def download_import_df(file_url):   
    """Download file from specified URL and import file
    into a pandas dataframe. 
    
    The path to the downloaded file is automatically 
    generated by the download and is passed to the 
    pandas function to create a new dataframe. 
    
    Parameters
    ----------
    file_url : str
        URL to CSV file (http or https).       

    Returns
    ------
    df : pandas dataframe
        Dataframe imported from downloaded CSV file.
    """ 

    df = pd.read_csv(et.data.get_data(url=file_url))
    
    return df
```

Your revised function now executes only one line, rather than three lines! Note that the docstring was also updated to reflect that there is only one input parameter for this function. 

Now you can call the function with just a single parameter for the URL. 

{:.input}
```python
# Create dataframe using download/import function
precip_2002_2013_df = download_import_df(
    file_url = precip_2002_2013_df_url)

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





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Writing Multi-Parameter Functions for Pandas Dataframes

You have a function that combines the mean calculation along a specified axis and the conversion from millimeters to inches for a **numpy** array. 

How might you need to change this function to create a similar function for **pandas** dataframe, but now converting from inches to millimeters?

For the mean, you can run summary statistics on pandas using a specified axis (just like a **numpy** array) with the following code:

```python
df.mean(axis = axis_value) 
```

With the axis value `0`, the code will calculate a mean for each numeric column in the dataframe.

With the axis value `1`, the code will calculate a mean for each row with numeric values in the dataframe.

Think about which code lines in the existing function `mean_mm_to_in_arr()` can be modified to run the equivalent code on a **pandas** dataframe.

Note that the `df.mean(axis = axis_value)` returns the mean values of a dataframe (along the specified axis) as a **pandas** series.

</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Practice Writing Multi-Parameter Functions for Numpy Arrays

You also have a function that combines the data download and import for a **pandas** dataframe, you can modify the function for other data structures such as a **numpy** array. 

How might you need to change this function to create an equivalent for **numpy** arrays?

Think about which code lines in the existing function `download_import_df()` can be modified to write a new function that downloads and imports data into a **numpy** array.

To begin, you may want to write one function for a 1-dimensional array and another function for a 2-dimensional array.

To advance in your practice, you can think about adding a conditional statement that would check for the file type (.txt for a 1-dimensional array .csv for a 2-dimensional array) before executing the appropriate import code. 

</div>
