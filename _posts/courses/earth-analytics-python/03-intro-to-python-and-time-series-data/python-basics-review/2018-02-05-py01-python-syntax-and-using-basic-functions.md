---
layout: single
title: "Get to Know Python & Jupyter Notebooks"
excerpt: "This tutorial introduces the Python scientific programming language. It is
designed for someone who has not used Python before. You will work with precipitation and
stream discharge data for Boulder County in Python but also learn the basics of working with python."
authors: ['Chris Holdgraf', 'Leah Wasser', 'Martha Morrissey','Data Carpentry']
category: [courses]
class-lesson: ['get-to-know-python']
permalink: /courses/earth-analytics-python/use-time-series-data-in-python/python-syntax-and-using-functions/
nav-title: 'Review: Get to Know Python'
dateCreated: 2018-02-05
modified: 2019-09-04
module-title: 'Get to Know the Python programming language'
module-nav-title: 'Review: Get to Know Python'
module-description: 'This module introduces the Python scientific programming language.
You will work with precipitation and stream discharge data for Boulder County to better understand the Python syntax, various data types and data import and plotting.'
module-type: 'class'
class-order: 2
course: "earth-analytics-python"
week: 3
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this tutorial, you will explore the basic syntax (structure) of the `Python` programming
language. You will be introduced to assignment operators (`=`), comments (`#`) and functions in `Python`. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

1. Import and work with `python` libraries and associated functions
2. Work with vector objects in `python` and
3. Import data into a pandas `data frame` which is the `python` equivalent of a spreadsheet.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

{% include/data_subsets/course_earth_analytics/_data-colorado-flood.md %}

</div>

This lesson set is a review of some of the  basic python concepts that you need to know to get through this week's material. These concepts and more were taught in the pre-requisite to this course - [Earth-Analytics-bootcamp course.]({{ site.url }}/courses/earth-analytics-bootcamp/) In this module, you will review the basic syntax of the `Python` programming language. 

Look closely at the code below:


{:.input}
```python
# Load all packages you will need in the first cell of code
import os
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import datetime
import matplotlib.dates as mdates
import earthpy as et

# Get the data
data = et.data.get_data('colorado-flood')

# Set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# Import precip data into a pandas dataframe
boulder_precip = pd.read_csv(
    'data/colorado-flood/downloads/boulder-precip.csv')
# Plot the data
fig, ax = plt.subplots(figsize=(12, 8))
boulder_precip.plot('DATE', 'PRECIP',
                    color='purple',
                    ax=ax)
ax.set(xlabel="Date", ylabel="Precipitation (inches)",
       title="Daily Precipitation - Boulder Station\n 2003-2013")
plt.show()
```

{:.output}
{:.display_data}

    <Figure size 1200x800 with 1 Axes>




This codes above does the following:

First it calls required python packages including: 

* `pandas`
* `os` 
* `matplotlib`
and others

Next, it:

* Opens a .csv file called `boulder-precip` using pandas -  `pd.read_csv` function
* Plots the data using the `.plot()` function (which is a part of the `pandas` library and utilizes matplotlib plotting)

In this lesson you will also use `numpy` - a library that is commonly used in python to support mathametical operations. 

Notice that at the top of your script you also set the working directory. You use the `.chdir()` function from the `os` library to set the working directory in python. Set your working directory to the `earth-analytics` directory that you created last week. Your path should look something like this:

`/Users/your-user-name/Documents/earth-analytics/`

`os.getcwd()` can be used to check your current working directory to ensure that you are working where you think you are!  


In the example above, this code:

`os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))`

uses the `earthpy` python package created by Earth Lab to set your home directory in the home directory of your computer. 

### Set Your Working Sirectory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`






{:.input}
```python
# Open data
data = pd.read_csv('data/colorado-flood/downloads/boulder-precip.csv')
```

Once you have opened the data, you can begin to explore it. In python / pandas you can access 'columns' in your data using the syntax:

`dataFrameName['column-name-here']`

By adding `.head()` to the command you tell python to only return the first 6 rows of the DATE column. 

{:.input}
```python
# View the entire column (all rows)
data['DATE']
```

{:.output}
{:.execute_result}



    0     2013-08-21
    1     2013-08-26
    2     2013-08-27
    3     2013-09-01
    4     2013-09-09
    5     2013-09-10
    6     2013-09-11
    7     2013-09-12
    8     2013-09-13
    9     2013-09-15
    10    2013-09-16
    11    2013-09-22
    12    2013-09-23
    13    2013-09-27
    14    2013-09-28
    15    2013-10-01
    16    2013-10-04
    17    2013-10-11
    Name: DATE, dtype: object





{:.input}
```python
# View the first 6 rows of data in the DATE column
data['DATE'].head()
```

{:.output}
{:.execute_result}



    0    2013-08-21
    1    2013-08-26
    2    2013-08-27
    3    2013-09-01
    4    2013-09-09
    Name: DATE, dtype: object





{:.input}
```python
# View first 6 lines of the entire data frame
data.head()
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
      <th>Unnamed: 0</th>
      <th>DATE</th>
      <th>PRECIP</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>756</td>
      <td>2013-08-21</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>1</td>
      <td>757</td>
      <td>2013-08-26</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>2</td>
      <td>758</td>
      <td>2013-08-27</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>3</td>
      <td>759</td>
      <td>2013-09-01</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>4</td>
      <td>760</td>
      <td>2013-09-09</td>
      <td>0.1</td>
    </tr>
  </tbody>
</table>
</div>





You can view the structure or type of data in each column using the `dtypes` attribute. 
Notice below that your data have 2 columns. One is of type object and the other is a numeric type - float64. 


{:.input}
```python
# View the structure of the data
data.dtypes
```

{:.output}
{:.execute_result}



    Unnamed: 0      int64
    DATE           object
    PRECIP        float64
    dtype: object





Finally, you can create a quick plot of the data using the `.plot` function. 

{:.input}
```python
# Plot the data
data.plot(x='DATE',
          y='PRECIP',
          color='purple')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py01-python-syntax-and-using-basic-functions/2018-02-05-py01-python-syntax-and-using-basic-functions_16_0.png" alt = "Basic plot of precipitation data in Boulder, Colorado 2003-2013">
<figcaption>Basic plot of precipitation data in Boulder, Colorado 2003-2013</figcaption>

</figure>




Notice that the plot above doesn't look exactly the way you may want it to look. You'll learn how to further customize plots in a later lesson. 

## About code syntax

The code above, uses syntax that is unique the `Python` programming language.

Syntax represents the characters or commands that `Python` understands and associated
organization / format of the code including spacing and comments. So, for example if you've used the `R` programming language before then you know that assignment operators in R use `<-` rather than the equals `=` sign. 

Let's break down the syntax of the python code above, to better understand what it's doing.

## Intro to the Python Syntax

### Assignment operator =

First, notice the use of `=`. `=` is the assignment operator. It is similar to
the `<-` sign in `R`. The equals sign assigns values on the right to objects on the left. So, after executing `x = 3`, the
value of `x` is `3` (`x=3`). The arrow can be read as 3 **goes into** `x`.

In the example below, you assigned the data file that you read into Python named `boulder-precip.csv`
to the variable name `boulder_precip`. After you run the line of code below,
what happens in Python?

{:.input}
```python
data = pd.read_csv('data/colorado-flood/downloads/boulder-precip.csv')
data
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
      <th>Unnamed: 0</th>
      <th>DATE</th>
      <th>PRECIP</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>756</td>
      <td>2013-08-21</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>1</td>
      <td>757</td>
      <td>2013-08-26</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>2</td>
      <td>758</td>
      <td>2013-08-27</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>3</td>
      <td>759</td>
      <td>2013-09-01</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>4</td>
      <td>760</td>
      <td>2013-09-09</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>5</td>
      <td>761</td>
      <td>2013-09-10</td>
      <td>1.0</td>
    </tr>
    <tr>
      <td>6</td>
      <td>762</td>
      <td>2013-09-11</td>
      <td>2.3</td>
    </tr>
    <tr>
      <td>7</td>
      <td>763</td>
      <td>2013-09-12</td>
      <td>9.8</td>
    </tr>
    <tr>
      <td>8</td>
      <td>764</td>
      <td>2013-09-13</td>
      <td>1.9</td>
    </tr>
    <tr>
      <td>9</td>
      <td>765</td>
      <td>2013-09-15</td>
      <td>1.4</td>
    </tr>
    <tr>
      <td>10</td>
      <td>766</td>
      <td>2013-09-16</td>
      <td>0.4</td>
    </tr>
    <tr>
      <td>11</td>
      <td>767</td>
      <td>2013-09-22</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>12</td>
      <td>768</td>
      <td>2013-09-23</td>
      <td>0.3</td>
    </tr>
    <tr>
      <td>13</td>
      <td>769</td>
      <td>2013-09-27</td>
      <td>0.3</td>
    </tr>
    <tr>
      <td>14</td>
      <td>770</td>
      <td>2013-09-28</td>
      <td>0.1</td>
    </tr>
    <tr>
      <td>15</td>
      <td>771</td>
      <td>2013-10-01</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>16</td>
      <td>772</td>
      <td>2013-10-04</td>
      <td>0.9</td>
    </tr>
    <tr>
      <td>17</td>
      <td>773</td>
      <td>2013-10-11</td>
      <td>0.1</td>
    </tr>
  </tbody>
</table>
</div>





<i class="fa fa-star"></i> **Data Tip:**  In Jupyter notebooks, typing <kbd>Esc</kbd> + <kbd>A</kbd> at the
same time will add a new cell AFTER the cell that you're currently working in.  Similarly, typing <kbd>Esc</kbd> + <kbd>B</kbd> at the
same time will add a new cell AFTER the cell that you're currently working in. Hint: B is for BEFORE and A is for AFTER.
{: .notice--success}


### Comments in Python (`#`)

Next, notice the use of the `#` sign in your code example above.
Use `#` sign is used to add comments to your code. A comment is a line of information
in your code that is not executed by `python`. Anything to the right of a `#` is ignored
by `Python`. Comments are a way for you
to DOCUMENT the steps of your code - both for yourself and for others who may
use your script.

{:.input}
```python
# This is a comment. Python will not try to run this line
# Comments are useful when you want to document the steps in you code
```

### Functions and Function Arguments

Finally you have functions. Functions are "canned scripts" that automate a task
that may other take several lines of code that you have to type in.

For example:

{:.input}
```python
# Calculate the square root of 16
np.sqrt(16)
```

{:.output}
{:.execute_result}



    4.0





{:.input}
```python
np.round(16.345)
```

{:.output}
{:.execute_result}



    16.0





In the example above, the `sqrt` function is built into `python` and takes the square
root of any number that you provide to it. Similarly the `round()` function can be used to round numbers.

### Functions That Return Values
The  `sqrt()` function is a numpy function. The input (the
argument) is a number, and the return value (the output)
is the square root of that number. Executing a function ('running it') is called
*calling* the function. An example of a function call is:

`b <- np.sqrt(a)`

Here, the value of `a` is given to the `np.sqrt()` function, the `np.sqrt()` function
calculates the square root, and returns the value which is then assigned to
variable `b`. This function is very simple, because it takes just one argument.

Let's run a function that can take multiple arguments: `np.round()`.

### Function Arguments

An argument is a specified input to a function. This input needs to be in a particular format for the function to run properly. For instance, the round function requires a NUMERIC input. For example you can't round the letter A.


{:.input}
```python
np.round(a=3.14159)
```

{:.output}
{:.execute_result}



    3.0





Here, you've called `round()` with just one argument, `3.14159`, and it has
returned the value `3`.  That's because the default is to round to the nearest
whole number. If you want more digits you can see how to do that by getting
information about the `round` function.  You can use `help(round)` to look at the
help for this function using `?round`.

{:.input}
```python
# View documentation for the round() function in python
help(np.round)
```

{:.output}
    Help on function round_ in module numpy:
    
    round_(a, decimals=0, out=None)
        Round an array to the given number of decimals.
        
        See Also
        --------
        around : equivalent function; see for details.
    



### Hello Tab Complete!

You can also use tab complete to discover arguments. For instance type
np.round(<tab-here> so see the arguments that are available for the round function in numpy. 

Note above that you see there is a **decimals** argument that you can add to your round function that will specify the number of decimal places that the function returns. If you specify `decimals=3` then python will round the data to 3 decimal points. 

{:.input}
```python
# What does this argument value return?
np.round(3.23457457,
         decimals=3)
```

{:.output}
{:.execute_result}



    3.235





{:.input}
```python
np.round(3.14159,
         decimals=1)
```

{:.output}
{:.execute_result}



    3.1





If you provide the arguments in the exact same order as they are defined in the function documentation, then you don't have to explicetly call the argument name: 




{:.input}
```python
np.round(3.14159, 2)
```

{:.output}
{:.execute_result}



    3.14





```python
# But what happens here?
np.round(2, 3.14159)
```

Output:
```python
---------------------------------------------------------------------------
AttributeError                            Traceback (most recent call last)
/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapfunc(obj, method, *args, **kwds)
     55     try:
---> 56         return getattr(obj, method)(*args, **kwds)
     57 

AttributeError: 'int' object has no attribute 'round'

During handling of the above exception, another exception occurred:

TypeError                                 Traceback (most recent call last)
<ipython-input-21-36528c700706> in <module>()
      1 # But what happens here?
----> 2 np.round(2, 3.14159)

/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in round_(a, decimals, out)
   3380     around : equivalent function; see for details.
   3381     """
-> 3382     return around(a, decimals=decimals, out=out)
   3383 
   3384 

/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in around(a, decimals, out)
   3005 
   3006     """
-> 3007     return _wrapfunc(a, 'round', decimals=decimals, out=out)
   3008 
   3009 

/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapfunc(obj, method, *args, **kwds)
     64     # a downstream library like 'pandas'.
     65     except (AttributeError, TypeError):
---> 66         return _wrapit(obj, method, *args, **kwds)
     67 
     68 

/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapit(obj, method, *args, **kwds)
     44     except AttributeError:
     45         wrap = None
---> 46     result = getattr(asarray(obj), method)(*args, **kwds)
     47     if wrap:
     48         if not isinstance(result, mu.ndarray):

TypeError: integer argument expected, got float
```

Notice above python returned an error. At the very bottom of the error notice:
`TypeError: integer argument expected, got float`. Why do you think this happened?

Notice that you provided the arguments as follows:

`np.round(2, 3.14159)`

Python tried to round the value 2 to 3.14159 which is a decimal rather than an integer value. However, if you explicetly name each argument and assign it it's appropriate value, then you can switch the order:

{:.input}
```python
np.round(decimals=2, a=3.14159)
```

{:.output}
{:.execute_result}



    3.14





### The .plot Function

Below, you use the `.plot()` function which is a part of the `pandas` library to plot your data.
`.plot()` needs two arguments to execute properly:

1. The value that you want to plot on the `x=` axis and
2. The value that you want to plot on the `y=` axis

Note below that if you don't tell python what to plot on the x and y axis it tries to 
guess which variables to plot on which axis. This isn't quite what you want

{:.input}
```python
# What happens if you plot with the x and y arguments?
data.plot(x='DATE',
          y='PRECIP', color='purple')
plt.show()
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py01-python-syntax-and-using-basic-functions/2018-02-05-py01-python-syntax-and-using-basic-functions_38_0.png">

</figure>




### Base Functions vs. Packages
There are a
set of functions that come with `Python 3.x` when you download it. These are called `base Python`
functions. Other functions are add-ons to base `Python`. These functions can be loaded by

1. Installing a particular library (using conda install library-name at the command line
2. Loading the library in your script using `import library as nickname` eg: import pandas as pd 

You can also write your own functions. You will learn how to write functions later in this course. 

### Function Outputs
Functions return an output. Sometimes that output is a *figure* like the example
above. Sometimes it is a *value* or a set of values or even something else.

It's good practice to put the non-optional arguments (like the number you're
rounding) first in your function call, and to specify the names of all optional
arguments.  If you don't, someone reading your code might have to look up
definition of a function with unfamiliar arguments to understand what you're
doing.

## Get Information About a Function

If you need help with a specific function, let's say `plt.plot`, you can type:

{:.input}
```python
help(plt.plot)
```

{:.output}
    Help on function plot in module matplotlib.pyplot:
    
    plot(*args, scalex=True, scaley=True, data=None, **kwargs)
        Plot y versus x as lines and/or markers.
        
        Call signatures::
        
            plot([x], y, [fmt], *, data=None, **kwargs)
            plot([x], y, [fmt], [x2], y2, [fmt2], ..., **kwargs)
        
        The coordinates of the points or line nodes are given by *x*, *y*.
        
        The optional parameter *fmt* is a convenient way for defining basic
        formatting like color, marker and linestyle. It's a shortcut string
        notation described in the *Notes* section below.
        
        >>> plot(x, y)        # plot x and y using default line style and color
        >>> plot(x, y, 'bo')  # plot x and y using blue circle markers
        >>> plot(y)           # plot y using x as index array 0..N-1
        >>> plot(y, 'r+')     # ditto, but with red plusses
        
        You can use `.Line2D` properties as keyword arguments for more
        control on the appearance. Line properties and *fmt* can be mixed.
        The following two calls yield identical results:
        
        >>> plot(x, y, 'go--', linewidth=2, markersize=12)
        >>> plot(x, y, color='green', marker='o', linestyle='dashed',
        ...      linewidth=2, markersize=12)
        
        When conflicting with *fmt*, keyword arguments take precedence.
        
        
        **Plotting labelled data**
        
        There's a convenient way for plotting objects with labelled data (i.e.
        data that can be accessed by index ``obj['y']``). Instead of giving
        the data in *x* and *y*, you can provide the object in the *data*
        parameter and just give the labels for *x* and *y*::
        
        >>> plot('xlabel', 'ylabel', data=obj)
        
        All indexable objects are supported. This could e.g. be a `dict`, a
        `pandas.DataFame` or a structured numpy array.
        
        
        **Plotting multiple sets of data**
        
        There are various ways to plot multiple sets of data.
        
        - The most straight forward way is just to call `plot` multiple times.
          Example:
        
          >>> plot(x1, y1, 'bo')
          >>> plot(x2, y2, 'go')
        
        - Alternatively, if your data is already a 2d array, you can pass it
          directly to *x*, *y*. A separate data set will be drawn for every
          column.
        
          Example: an array ``a`` where the first column represents the *x*
          values and the other columns are the *y* columns::
        
          >>> plot(a[0], a[1:])
        
        - The third way is to specify multiple sets of *[x]*, *y*, *[fmt]*
          groups::
        
          >>> plot(x1, y1, 'g^', x2, y2, 'g-')
        
          In this case, any additional keyword argument applies to all
          datasets. Also this syntax cannot be combined with the *data*
          parameter.
        
        By default, each line is assigned a different style specified by a
        'style cycle'. The *fmt* and line property parameters are only
        necessary if you want explicit deviations from these defaults.
        Alternatively, you can also change the style cycle using the
        'axes.prop_cycle' rcParam.
        
        
        Parameters
        ----------
        x, y : array-like or scalar
            The horizontal / vertical coordinates of the data points.
            *x* values are optional and default to `range(len(y))`.
        
            Commonly, these parameters are 1D arrays.
        
            They can also be scalars, or two-dimensional (in that case, the
            columns represent separate data sets).
        
            These arguments cannot be passed as keywords.
        
        fmt : str, optional
            A format string, e.g. 'ro' for red circles. See the *Notes*
            section for a full description of the format strings.
        
            Format strings are just an abbreviation for quickly setting
            basic line properties. All of these and more can also be
            controlled by keyword arguments.
        
            This argument cannot be passed as keyword.
        
        data : indexable object, optional
            An object with labelled data. If given, provide the label names to
            plot in *x* and *y*.
        
            .. note::
                Technically there's a slight ambiguity in calls where the
                second label is a valid *fmt*. `plot('n', 'o', data=obj)`
                could be `plt(x, y)` or `plt(y, fmt)`. In such cases,
                the former interpretation is chosen, but a warning is issued.
                You may suppress the warning by adding an empty format string
                `plot('n', 'o', '', data=obj)`.
        
        Other Parameters
        ----------------
        scalex, scaley : bool, optional, default: True
            These parameters determined if the view limits are adapted to
            the data limits. The values are passed on to `autoscale_view`.
        
        **kwargs : `.Line2D` properties, optional
            *kwargs* are used to specify properties like a line label (for
            auto legends), linewidth, antialiasing, marker face color.
            Example::
        
            >>> plot([1,2,3], [1,2,3], 'go-', label='line 1', linewidth=2)
            >>> plot([1,2,3], [1,4,9], 'rs',  label='line 2')
        
            If you make multiple lines with one plot command, the kwargs
            apply to all those lines.
        
            Here is a list of available `.Line2D` properties:
        
          agg_filter: a filter function, which takes a (m, n, 3) float array and a dpi value, and returns a (m, n, 3) array
          alpha: float
          animated: bool
          antialiased or aa: bool
          clip_box: `.Bbox`
          clip_on: bool
          clip_path: [(`~matplotlib.path.Path`, `.Transform`) | `.Patch` | None]
          color or c: color
          contains: callable
          dash_capstyle: {'butt', 'round', 'projecting'}
          dash_joinstyle: {'miter', 'round', 'bevel'}
          dashes: sequence of floats (on/off ink in points) or (None, None)
          drawstyle or ds: {'default', 'steps', 'steps-pre', 'steps-mid', 'steps-post'}, default: 'default'
          figure: `.Figure`
          fillstyle: {'full', 'left', 'right', 'bottom', 'top', 'none'}
          gid: str
          in_layout: bool
          label: object
          linestyle or ls: {'-', '--', '-.', ':', '', (offset, on-off-seq), ...}
          linewidth or lw: float
          marker: marker style
          markeredgecolor or mec: color
          markeredgewidth or mew: float
          markerfacecolor or mfc: color
          markerfacecoloralt or mfcalt: color
          markersize or ms: float
          markevery: None or int or (int, int) or slice or List[int] or float or (float, float)
          path_effects: `.AbstractPathEffect`
          picker: float or callable[[Artist, Event], Tuple[bool, dict]]
          pickradius: float
          rasterized: bool or None
          sketch_params: (scale: float, length: float, randomness: float)
          snap: bool or None
          solid_capstyle: {'butt', 'round', 'projecting'}
          solid_joinstyle: {'miter', 'round', 'bevel'}
          transform: `matplotlib.transforms.Transform`
          url: str
          visible: bool
          xdata: 1D array
          ydata: 1D array
          zorder: float
        
        Returns
        -------
        lines
            A list of `.Line2D` objects representing the plotted data.
        
        See Also
        --------
        scatter : XY scatter plot with markers of varying size and/or color (
            sometimes also called bubble chart).
        
        Notes
        -----
        **Format Strings**
        
        A format string consists of a part for color, marker and line::
        
            fmt = '[marker][line][color]'
        
        Each of them is optional. If not provided, the value from the style
        cycle is used. Exception: If ``line`` is given, but no ``marker``,
        the data will be a line without markers.
        
        Other combinations such as ``[color][marker][line]`` are also
        supported, but note that their parsing may be ambiguous.
        
        **Markers**
        
        =============    ===============================
        character        description
        =============    ===============================
        ``'.'``          point marker
        ``','``          pixel marker
        ``'o'``          circle marker
        ``'v'``          triangle_down marker
        ``'^'``          triangle_up marker
        ``'<'``          triangle_left marker
        ``'>'``          triangle_right marker
        ``'1'``          tri_down marker
        ``'2'``          tri_up marker
        ``'3'``          tri_left marker
        ``'4'``          tri_right marker
        ``'s'``          square marker
        ``'p'``          pentagon marker
        ``'*'``          star marker
        ``'h'``          hexagon1 marker
        ``'H'``          hexagon2 marker
        ``'+'``          plus marker
        ``'x'``          x marker
        ``'D'``          diamond marker
        ``'d'``          thin_diamond marker
        ``'|'``          vline marker
        ``'_'``          hline marker
        =============    ===============================
        
        **Line Styles**
        
        =============    ===============================
        character        description
        =============    ===============================
        ``'-'``          solid line style
        ``'--'``         dashed line style
        ``'-.'``         dash-dot line style
        ``':'``          dotted line style
        =============    ===============================
        
        Example format strings::
        
            'b'    # blue markers with default shape
            'or'   # red circles
            '-g'   # green solid line
            '--'   # dashed line with default color
            '^k:'  # black triangle_up markers connected by a dotted line
        
        **Colors**
        
        The supported color abbreviations are the single letter codes
        
        =============    ===============================
        character        color
        =============    ===============================
        ``'b'``          blue
        ``'g'``          green
        ``'r'``          red
        ``'c'``          cyan
        ``'m'``          magenta
        ``'y'``          yellow
        ``'k'``          black
        ``'w'``          white
        =============    ===============================
        
        and the ``'CN'`` colors that index into the default property cycle.
        
        If the color is the only part of the format string, you can
        additionally use any  `matplotlib.colors` spec, e.g. full names
        (``'green'``) or hex strings (``'#008000'``).
    








