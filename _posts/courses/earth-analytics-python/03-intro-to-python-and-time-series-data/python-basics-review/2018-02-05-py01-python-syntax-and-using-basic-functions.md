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
modified: 2018-10-08
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
# load all packages you will need in the first cell of code 
import numpy as np 
import pandas as pd
from matplotlib import pyplot as plt 
import datetime 
import matplotlib.dates as mdates
import earthpy as et
import os
plt.ion()
# set working directory
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))

# import precip data into a pandas dataframe
boulder_precip = pd.read_csv('data/colorado-flood/downloads/boulder-precip.csv')
# plot the data
fig, ax = plt.subplots(figsize = (12, 8))
boulder_precip.plot('DATE', 'PRECIP', 
                    color = 'purple', 
                    ax=ax)
ax.set_xlabel("Date")
ax.set_ylabel("Precipitation (inches)")
ax.set_title("Daily Precipitation - Boulder Station\n 2003-2013");
```

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

{:.input}
```python
import pandas as pd
import numpy as np
import urllib
import os
from matplotlib import pyplot as plt
import earthpy as et

# set working directory to your home dir/earth-analytics
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

Notice that at the top of your script you also set the working directory. You use the `.chdir()` function from the `os` library to set the working directory in python. Set your working directory to the `earth-analytics` directory that you created last week. Your path should look something like this:

`/Users/your-user-name/Documents/earth-analytics/`

`os.getcwd()` can be used to check your current working directory to ensure that you are working where you think you are!  


In the example above, this code:

`os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))`

uses the `earthpy` python package created by Earth Lab to set your home directory in the home directory of your computer. 

### Set Your Working Sirectory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

Finally you want to ensure that your plots are visible in jupyter notebooks. To force python to render them in the notebook, you can use 

`plt.ion()`

If you've used python before, you may be used to using `plt.show()`. `plt.ion()` is similar but can be called at the top of your code to ensure plots render throughout your notebook. Thus you only have to call it once.

{:.input}
```python
# Force notebooks to plot figures inline (in the notebook)
plt.ion()
```

{:.input}
```python
# open data
data = pd.read_csv('data/colorado-flood/downloads/boulder-precip.csv')
```

Once you have opened the data, you can begin to explore it. In python / pandas you can access 'columns' in your data using the syntax:

`dataFrameName['column-name-here']`

By adding `.head()` to the command you tell python to only return the first 6 rows of the DATE column. 

{:.input}
```python
# view the entire column (all rows) 
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
# view the first 6 rows of data in the DATE column
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
# view first 6 lines of the entire data frame
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
      <th>0</th>
      <td>756</td>
      <td>2013-08-21</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>757</td>
      <td>2013-08-26</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>758</td>
      <td>2013-08-27</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>759</td>
      <td>2013-09-01</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
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
# view the structure of the data 
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
# plot the data - note that the ; symbol at the end of the line turns off the matplotlib message
data.plot(x='DATE', 
          y='PRECIP', 
          color = 'purple');
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-python/03-intro-to-python-and-time-series-data/python-basics-review/2018-02-05-py01-python-syntax-and-using-basic-functions_16_0.png" alt = "Basic plot of precipitation data in Boulder, Colorado 2003-2013">
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
      <th>0</th>
      <td>756</td>
      <td>2013-08-21</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>757</td>
      <td>2013-08-26</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>758</td>
      <td>2013-08-27</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>759</td>
      <td>2013-09-01</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>760</td>
      <td>2013-09-09</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>761</td>
      <td>2013-09-10</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>762</td>
      <td>2013-09-11</td>
      <td>2.3</td>
    </tr>
    <tr>
      <th>7</th>
      <td>763</td>
      <td>2013-09-12</td>
      <td>9.8</td>
    </tr>
    <tr>
      <th>8</th>
      <td>764</td>
      <td>2013-09-13</td>
      <td>1.9</td>
    </tr>
    <tr>
      <th>9</th>
      <td>765</td>
      <td>2013-09-15</td>
      <td>1.4</td>
    </tr>
    <tr>
      <th>10</th>
      <td>766</td>
      <td>2013-09-16</td>
      <td>0.4</td>
    </tr>
    <tr>
      <th>11</th>
      <td>767</td>
      <td>2013-09-22</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>12</th>
      <td>768</td>
      <td>2013-09-23</td>
      <td>0.3</td>
    </tr>
    <tr>
      <th>13</th>
      <td>769</td>
      <td>2013-09-27</td>
      <td>0.3</td>
    </tr>
    <tr>
      <th>14</th>
      <td>770</td>
      <td>2013-09-28</td>
      <td>0.1</td>
    </tr>
    <tr>
      <th>15</th>
      <td>771</td>
      <td>2013-10-01</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>16</th>
      <td>772</td>
      <td>2013-10-04</td>
      <td>0.9</td>
    </tr>
    <tr>
      <th>17</th>
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
# this is a comment. Python will not try to run this line
# comments are useful when you want to document the steps in you code

```

### Functions and Function Arguments

Finally you have functions. Functions are "canned scripts" that automate a task
that may other take several lines of code that you have to type in.

For example:

{:.input}
```python
# calculate the square root of 16
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
# view documentation for the round() function in python
help(np.round)
```

{:.output}
    Help on function round_ in module numpy.core.fromnumeric:
    
    round_(a, decimals=0, out=None)
        Round an array to the given number of decimals.
        
        Refer to `around` for full documentation.
        
        See Also
        --------
        around : equivalent function
    



### Hello Tab Complete!

You can also use tab complete to discover arguments. For instance type
np.round(<tab-here> so see the arguments that are available for the round function in numpy. 

Note above that you see there is a **decimals** argument that you can add to your round function that will specify the number of decimal places that the function returns. If you specify `decimals=3` then python will round the data to 3 decimal points. 

{:.input}
```python
# what does this argument value return?
np.round(3.23457457, 
         decimals=3)
```

{:.output}
{:.execute_result}



    3.2349999999999999





{:.input}
```python
np.round(3.14159, 
         decimals=1)
```

{:.output}
{:.execute_result}



    3.1000000000000001





If you provide the arguments in the exact same order as they are defined in the function documentation, then you don't have to explicetly call the argument name: 




{:.input}
```python
np.round(3.14159, 2)
```

{:.output}
{:.execute_result}



    3.1400000000000001





{:.input}
```python
# but what happens here?
np.round(2, 3.14159)

```

{:.output}

    ---------------------------------------------------------------------------

    AttributeError                            Traceback (most recent call last)

    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapfunc(obj, method, *args, **kwds)
         56     try:
    ---> 57         return getattr(obj, method)(*args, **kwds)
         58 


    AttributeError: 'int' object has no attribute 'round'

    
    During handling of the above exception, another exception occurred:


    TypeError                                 Traceback (most recent call last)

    <ipython-input-23-aed5683d0561> in <module>()
          1 # but what happens here?
    ----> 2 np.round(2, 3.14159)
    

    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in round_(a, decimals, out)
       2801 
       2802     """
    -> 2803     return around(a, decimals=decimals, out=out)
       2804 
       2805 


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in around(a, decimals, out)
       2787 
       2788     """
    -> 2789     return _wrapfunc(a, 'round', decimals=decimals, out=out)
       2790 
       2791 


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapfunc(obj, method, *args, **kwds)
         65     # a downstream library like 'pandas'.
         66     except (AttributeError, TypeError):
    ---> 67         return _wrapit(obj, method, *args, **kwds)
         68 
         69 


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapit(obj, method, *args, **kwds)
         45     except AttributeError:
         46         wrap = None
    ---> 47     result = getattr(asarray(obj), method)(*args, **kwds)
         48     if wrap:
         49         if not isinstance(result, mu.ndarray):


    TypeError: integer argument expected, got float



Notice above python returned an error. At the very bottom of the error notice:
`TypeError: integer argument expected, got float`. Why do you think this happened?

Notice that you provided the arguments as follows:

`np.round(2, 3.14159)`

Python tried to round the value 2 to 3.14159 which is a decimal rather than an integer value. However, if you explicetly name each argument and assign it it's appropriate value, then you can switch the order:

{:.input}
```python
np.round(decimals=2, a=3.14159)
```

### The .plot Function

Below, you use the `.plot()` function which is a part of the `pandas` library to plot your data.
`.plot()` needs two arguments to execute properly:

1. The value that you want to plot on the `x=` axis and
2. The value that you want to plot on the `y=` axis

Note below that if you don't tell python what to plot on the x and y axis it tries to 
guess which variables to plot on which axis. This isn't quite what you want

{:.input}
```python
# what happens if you plot without any arguments?
data.plot();
```

{:.input}
```python
# what happens if you plot with the x and y arguments?
data.plot(x='DATE', 
         y='PRECIP', color = 'purple');
```

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
