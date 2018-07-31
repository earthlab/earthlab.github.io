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
nav-title: 'Get to Know Python'
dateCreated: 2018-02-05
modified: 2018-07-27
module-title: 'Get to Know the Python programming language'
module-nav-title: 'Get to Know Python'
module-description: 'This module introduces the Python scientific programming language.
You will work with precipitation and stream discharge data for Boulder County to better understand the Python syntax, various data types and data import and plotting.'
module-type: 'class'
class-order: 1
course: "earth-analytics-python"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['Jupyter-notebooks']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this tutorial, you will explore the basic syntax (structure) of the `Python` programming
language. You will be introduced to assignment operators (`=`), comments (`#`) and functions in `Python`. 

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives
At the end of this activity, you will be able to:

* Understand the basic concept of a function and be able to use a function in your code.
* Use the assignment operator in Python (`=`) to create a new variable or object.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You need `Python 3.x` and `Jupyter notebooks` to complete this tutorial. Also you should have
an `earth-analytics` directory setup on your computer with a `/data`
directory with it.

* [Setup Conda](/courses/earth-analytics-python/get-started-with-python-jupyter/setup-conda-earth-analytics-environment/)
* [Setup your working directory](/courses/earth-analytics-python/get-started-with-python-jupyter/introduction-to-bash-shell/)
* [Intro to Jupyter Notebooks](/courses/earth-analytics-python/python-open-science-tool-box/intro-to-jupyter-notebooks/)

</div>

[Last week](/courses/earth-analytics-python/get-started-with-python-jupyter/setup-conda-earth-analytics-environment/), you setup `Jupyter notebook` and `python` by installing the Anaconda distribution. You also got to know the 
`Jupyter notebook` interface. Finally, you created a basic `Jupyter notebook` report by exporting the contents of a notebook to `html`. In this  module, you will explore the basic syntax of the `Python` programming language. You will learn how to:

1. Import and work with `python` libraries and associated functions
2. Work with vector objects in `python` and
3. Import data into a pandas `data frame` which is the `python` equivalent of a spreadsheet.

Let's start by looking at the code you used last week. Here, you:

1. Downloaded some data from figshare using the `urllib.request.urlretrieve` function which is a part of the `urllib` library that comes with `python 3.x `.
2. Imported the data into r using the `pd.read_csv` function
3. Plotted the data using the `.plot()` function (which is a part of the `pandas` library and utilizes matplotlib plotting)

You used the following libraries to perform these tasks:

* `pandas`
* `urllib`
* `os` (used to ensure your working directory was correct).

In this lesson you will also use `numpy` - a library that is commonly used in python to support mathametical operations. 

{:.input}
```python
import pandas as pd
import numpy as np
import urllib
import os
from matplotlib import pyplot as plt
import earthlabpy as et
```

Notice that at the top of your script you also set the working directory. You use the `.chdir()` function from the `os` library to set the working directory in python. Set your working directory to the earth-analytics directory that you created last week. Your path should look something like this:

`/Users/your-user-name/Documents/earth-analytics/`

`os.getcwd()` can be used to check your current working directory to ensure that you are working where you think you are!  


### Be sure to set your working directory

`os.chdir("path-to-you-dir-here/earth-analytics/data")`

Finally you want to ensure that your plots are visible in jupyter notebooks. To force python to render them in the notebook, you can use 

`plt.ion()`

{:.input}
```python
# Force notebooks to plot figures inline (in the notebook)
plt.ion()
```

Let's next break your script down. 
After you imported all of the required libraries, you used the `urllib.request.urlretrieve` function to download a data file from figshare, into the data/ directory within your earth-analytics working directory. 

Notice that the `urllib.request.urlretrieve` **function** has two arguments

1. **url=** the url where your data is located online
2. **filename=** the location and name of the file that you are downloading. Here you downloaded the data to the directory path/filename: data/boulder-precip.csv. Thus the file will be called boulder-precip.csv and it will be located in the data directory of your working directory.

NOTE: downloading the file using this function won't work if the `data/` directory that you tell it to save the file in doesn't already exist! 

{:.input}
```python
# download file from Earth Lab figshare repository
urllib.request.urlretrieve(url='https://ndownloader.figshare.com/files/7010681', 
                           filename= 'data/boulder-precip.csv')
```

{:.output}
{:.execute_result}



    ('data/boulder-precip.csv', <http.client.HTTPMessage at 0x11e5e6390>)





If the data downloaded correctly, you will recieve a message from python 

`('data/boulder-precip.csv', <http.client.HTTPMessage at 0x1186c06d8>)` confirming that the data were downloaded.

Next, you opened the data in python using the `read_csv` function from the pandas library. 

{:.input}
```python
# open data
data = pd.read_csv('data/colorado-flood/boulder-precip.csv')
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
data.plot(x='DATE', y='PRECIP', color = 'purple');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/get-to-know-python/2018-02-05-py01-python-syntax-and-using-basic-functions_17_0.png)




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
data = pd.read_csv('data/boulder-precip.csv')
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

### Functions and their arguments

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

### Functions that return values
The  `sqrt()` function is a numpy function. The input (the
argument) is a number, and the return value (the output)
is the square root of that number. Executing a function ('running it') is called
*calling* the function. An example of a function call is:

`b <- np.sqrt(a)`

Here, the value of `a` is given to the `np.sqrt()` function, the `np.sqrt()` function
calculates the square root, and returns the value which is then assigned to
variable `b`. This function is very simple, because it takes just one argument.

Let's run a function that can take multiple arguments: `np.round()`.

### Function arguments

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
    



### hello tab complete!

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





{:.input}
```python
# but what happens here?
np.round(2, 3.14159)

```

{:.output}

    ---------------------------------------------------------------------------

    AttributeError                            Traceback (most recent call last)

    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapfunc(obj, method, *args, **kwds)
         51     try:
    ---> 52         return getattr(obj, method)(*args, **kwds)
         53 


    AttributeError: 'int' object has no attribute 'round'

    
    During handling of the above exception, another exception occurred:


    TypeError                                 Traceback (most recent call last)

    <ipython-input-41-aed5683d0561> in <module>()
          1 # but what happens here?
    ----> 2 np.round(2, 3.14159)
    

    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in round_(a, decimals, out)
       2849 
       2850     """
    -> 2851     return around(a, decimals=decimals, out=out)
       2852 
       2853 


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in around(a, decimals, out)
       2835 
       2836     """
    -> 2837     return _wrapfunc(a, 'round', decimals=decimals, out=out)
       2838 
       2839 


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapfunc(obj, method, *args, **kwds)
         60     # a downstream library like 'pandas'.
         61     except (AttributeError, TypeError):
    ---> 62         return _wrapit(obj, method, *args, **kwds)
         63 
         64 


    ~/anaconda3/envs/earth-analytics-python/lib/python3.6/site-packages/numpy/core/fromnumeric.py in _wrapit(obj, method, *args, **kwds)
         40     except AttributeError:
         41         wrap = None
    ---> 42     result = getattr(asarray(obj), method)(*args, **kwds)
         43     if wrap:
         44         if not isinstance(result, mu.ndarray):


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

{:.output}
{:.execute_result}



    3.14





### The plot function

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

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/get-to-know-python/2018-02-05-py01-python-syntax-and-using-basic-functions_39_0.png)




{:.input}
```python
# what happens if you plot with the x and y arguments?
data.plot(x='DATE', 
         y='PRECIP', color = 'purple');
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/get-to-know-python/2018-02-05-py01-python-syntax-and-using-basic-functions_40_0.png)




### Base functions vs. packages
There are a
set of functions that come with `Python 3.x` when you download it. These are called `base Python`
functions. Other functions are add-ons to base `Python`. These functions can be loaded by

1. Installing a particular library (using conda install library-name at the command line
2. Loading the library in your script using `import library as nickname` eg: import pandas as pd 

You can also write your own functions. You will learn how to write functions later in this course. 

### Function outputs
Functions return an output. Sometimes that output is a *figure* like the example
above. Sometimes it is a *value* or a set of values or even something else.

It's good practice to put the non-optional arguments (like the number you're
rounding) first in your function call, and to specify the names of all optional
arguments.  If you don't, someone reading your code might have to look up
definition of a function with unfamiliar arguments to understand what you're
doing.

## Get Information About A Function

If you need help with a specific function, let's say `plt.plot`, you can type:

{:.input}
```python
plt.plot?
```

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional challenge activity

Use the `Jupyter Notebook` document that you created as homework for today's class. If
you don't have a document already, create a new one, naming it: "lastname-firstname-wk2.ipynb".
Add the code below in a code chunk. Edit the code that you just pasted into
your `.ipynb` document as follows

1. The plot isn't pretty. Let's fix the x and y labels.
Look up the arguments for the `plt.plot` function using either `plt.plot?` or looking at the [matplotlib documentation](https://matplotlib.org/contents.html). Then fix the labels of your plot in your script.

HINT: google is your friend. Feel free to use it to help edit the code.

2. What other things can you modify to make the plot look prettier. Explore. Are
there things that you'd like to do that you can't?
</div>

### Challenge Answer Code

{:.input}
```python
# convert to date/time and retain as a new field, so matplotlib will work

data['DateTime'] = pd.to_datetime(data['DATE'])
```

{:.input}
```python

plt.plot(data['DateTime'], data['PRECIP'] ,color = 'purple')
plt.xlabel("Date")
plt.ylabel("Precipitation (inches)")
plt.title("Daily Precipitation - Boulder Station\n 2003-2013")
plt.show()
```

{:.output}
{:.display_data}

![png]({{ site.url }}//images/courses/earth-analytics-python/02-intro-to-python-and-time-series-data/get-to-know-python/2018-02-05-py01-python-syntax-and-using-basic-functions_47_0.png)



