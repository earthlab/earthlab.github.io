---
layout: single
title: 'Multiple Conditional Statements'
excerpt: "Conditional statements can be used to control the flow of your code by executing code only when certain conditions are met. Learn how to write conditional statements in Python that combine conditions or to choose between alternative conditions."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['conditional-statements-tb']
permalink: /courses/intro-to-earth-data-science/dry-code-python/conditional-statements/multiple-conditions/
nav-title: "Multiple Conditional Statements"
dateCreated: 2019-10-22
modified: 2019-10-23
module-type: 'class'
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
  - "/courses/earth-analytics-bootcamp/conditional-statements/control-flow/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* 

</div>

## Structure of Conditional Statements With Multiple Conditions




### Review Logical Operators



For example, you can use:

* `and` to provide multiple conditions that all have to be met before executing code
* `or` to provide multiple conditions, of which only one has to be met before executing code
* `not` to execute code only if the stated condition is not met (note: you can use `not` in combination with `and` or `or` to check whether multiple conditions are not met)

In this lesson, you will use these logical operators to write conditional statements that determine whether a specific combination of conditions is met before executing code. 

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
# Download .txt with avg monthly precip (inches)
monthly_precip_url = 'https://ndownloader.figshare.com/files/12565616'
et.data.get_data(url=monthly_precip_url)

# Download .csv of precip data for 2002 and 2013 (inches)
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



## Combinations of Conditions

You can also use multiple conditions to check for more than directory, such as checking for both the `data` directory and the `ea-bootcamp-day-5` directory. 

Recall that you can combine multiple conditions using `and`, and that both conditions have to be true, in order to execute the code under `if`. 

This means that only one condition has to fail, in order for the conditional statement to execute code under `else`. 

{:.input}
```python
# Check if two files (or directories) exist
```

You could also add `not` to check that items are not in a list before continuing. For example, you can check for some directories that should have been replaced or deleted. 



## Alternative Conditions



{:.input}
```python
# Check if 
# elif: 
# else: 
```
