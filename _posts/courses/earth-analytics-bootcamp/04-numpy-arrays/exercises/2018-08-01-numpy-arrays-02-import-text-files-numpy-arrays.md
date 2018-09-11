---
layout: single
title: 'Import Text Data Into Numpy Arrays'
excerpt: "This lesson walks you through importing text data from .txt and .csv files into numpy arrays."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['numpy-arrays']
permalink: /courses/earth-analytics-bootcamp/numpy-arrays/import-text-files-numpy-arrays/
nav-title: "Import Text Data Into Numpy Arrays"
dateCreated: 2019-07-23
modified: 2018-09-10
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will write `Python` code in `Jupyter Notebook` to import text data (.txt. and .csv files) into `numpy arrays`. You will also write `Python` to download the datasets (.txt. and .csv files) needed for the `numpy array` lessons. 

<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this hands-on exercise, you will be able to:

* Explain the differences between plain text and comma delimited files
* Write `Python` code to download data using URLs
* Write `Python` code to import data from text files (.txt) into `numpy arrays`
 
 
## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the previous lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/variables/">Python Variables</a> and <a href="{{ site.url }}/courses/earth-analytics-bootcamp/python-variables-lists/lists/">Python Lists</a>.

Be sure that you have a subdirectory called `data` under your `earth-analytics-bootcamp` directory. For help with this task, please see the challenge for the lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/intro-shell/">Intro to Shell.</a>

The code below is available in the **ea-bootcamp-day-4** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 

 </div>
 

## Text Files

Scientific data can come in a variety of file formats and types. In this course, you will work with data stored in plain text files (.txt) and comma-delimited text files (.csv).

### Plain Text Files

Plain text files simply list out the values on separate lines without any symbols or delimiters to indicate separate values. For example, data for the average monthly precipitation data for Boulder, CO can be stored as a plain text file (.txt), with a separate line for each month's value. 

```python
0.70
0.75
1.85
2.93
3.05
2.02
1.93
1.62
1.84
1.31
1.39
0.84
```

Due to their simplicity, text files (.txt) can be very useful for collecting very large datasets that are all the same type of observation or data type. 


### CSV Files

Unlike plain-text files which simply list out the values on separate lines without any symbols or delimiters, comma delimited (CSV) files use commas (or some other delimiter like tab spaces or semi-colons) to indicate separate values.

This means that CSV files can easily support multiple rows and columns of related data. For example, data for the monthly precipitation for Boulder, CO for the years 2002 and 2013 can be stored together in a comma delimited (.csv) file.

```python
1.07, 0.44, 1.50, 0.20, 3.20, 1.18, 0.09, 1.44, 1.52, 2.44, 0.78, 0.02
0.27, 1.13, 1.72, 4.14, 2.66, 0.61, 1.03, 1.40, 18.16, 2.24, 0.29, 0.5
```

In this lesson and the next lesson, you will use data from:

* a .txt file containing the average monthly precipitation data for Boulder, CO
* a .csv file containing the monthly precipitation for Boulder, CO for the years 2002 and 2013

  
## Begin Writing Your Code

From previous lessons, you know that you always begin your `Python` code by importing the necessary packages and checking the working directory. 

### Import Packages

In this lesson, you will use the `os` package along with some new packages:

1. `numpy` with the alias `np`: to create and work with data as `numpy arrays`
2. `urllib`: to download the datasets for this lesson

{:.input}
```python
# import necessary Python packages
import os
import numpy as np
import urllib.request

# print message after packages imported successfully
print("import of packages successful")
```

{:.output}
    import of packages successful



### Set Working Directory

Remember that you can check the current working directory using `os.getcwd()`. You can also set the current working directory using another useful function `os.chdir()`.

{:.input}
```python
# set the working directory to the `earth-analytics-bootcamp` directory
# replace `jpalomino` with your username here and all paths in this lesson
os.chdir("/home/jpalomino/earth-analytics-bootcamp/")

# print the current working directory
os.getcwd()
```

{:.output}
{:.execute_result}



    '/home/jpalomino/earth-analytics-bootcamp'





## Download Data Using URLs

You can use the `urllib` package to download data from online sources such as `Figshare.com`, where the datasets for this lesson are published. 

To use `urllib`, you provide parameter values for `url` as well as `filename` for the downloaded file. 

For this lesson, you will download the .txt files for average monthly precipitation for Boulder, CO as well as the month names from the Earth Lab `Figshare.com` repository.

{:.input}
```python
# use `urllib` download files from Earth Lab figshare repository

# download .txt containing monthly average precipitation for Boulder, CO
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12565616", 
                           filename = "data/avg-monthly-precip.txt")

# download .txt containing month names
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12565619", 
                           filename = "data/months.txt")

# print message that data downloads were successful
print("datasets downloaded successfully")
```

{:.output}
    datasets downloaded successfully



Note that you do not have to provide the full path for filename because it is relative to the current working directory that you set using `os.chdir()`.

**Into which directory were your files downloaded?** Open the directory on your computer to see your downloaded files.  

## Import Text Data Into Numpy Arrays

### Numeric Data

You can create new `numpy arrays` by importing data from files, such as text files. You can import these data using the `loadtxt()` function from `numpy`, which you imported as `np`. 

For both .txt and .csv files, you need to specify a value for the parameter called `fname` for the file name (e.g. `np.loadtxt(fname = "filename.txt")`). Be sure to update the path for the file to your home directory. 

{:.input}
```python
# import the monthly average values from `avg-monthly-precip.txt` as a numpy array
avg_monthly_precip = np.loadtxt(fname = "/home/jpalomino/earth-analytics-bootcamp/data/avg-monthly-precip.txt")
```

Recall that that you can use the `print()` function to see the values stored in a variable (e.g. `print(variablename)`).

{:.input}
```python
# print the data in `avg_monthly_precip`
print(avg_monthly_precip)
```

{:.output}
    [0.7  0.75 1.85 2.93 3.05 2.02 1.93 1.62 1.84 1.31 1.39 0.84]



You can also use the `type()` function to check the type of data structure (e.g. `type(variablename)`) and see that `avg_monthly_precip` is a `numpy array`. 

{:.input}
```python
# print the type for the `avg_monthly_precip` variable
print(type(avg_monthly_precip))
```

{:.output}
    <class 'numpy.ndarray'>



### Text String Data

In addition to numeric data, you can also import text strings to `numpy arrays` using the `genfromtxt()` function from `numpy`. You need to specify a parameter value for `filename` as well as for the data type as `dtype='str'`. 

{:.input}
```python
# import the names of the months from month.txt as a numpy array
months = np.genfromtxt("/home/jpalomino/earth-analytics-bootcamp/data/months.txt", dtype='str')
```

Again, you can check the type and the data in your new `numpy array`.

{:.input}
```python
# print the type for the `months` variable
print(type(months))

# print the values in `months`
print(months)
```

{:.output}
    <class 'numpy.ndarray'>
    ['Jan' 'Feb' 'Mar' 'Apr' 'May' 'June' 'July' 'Aug' 'Sept' 'Oct' 'Nov'
     'Dec']



Congratulations! You have now learned how to create `numpy arrays` by importing numeric and text string data from text files.

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Download a .csv file containing the monthly precipitation for Boulder, CO for the years 2002 and 2013 (`monthly-precip-2002-2013.csv`)from `https://ndownloader.figshare.com/files/12707792`. 
    * Be sure to assign a useful variable name that is short but indicative of what it contains (e.g. `precip_2002_2013`).

2. Import the data from this .csv file into a `numpy array`. 
    * Note that for .csv files, you need to specify another parameter in addition to `filename`.  You need to provide a value for `delimiter`, which indicates the symbol that is used to separate the values (e.g. `delimiter = ","`). 
    
3. Print the data type of your new `numpy array` as well as its contents.
    * Note that you can add a line of code **before print(variablename)** to display the values in the `numpy array` as floats, rather than scientific notation (`np.set_printoptions(suppress=True)`).
    
4. Print the data contained in `avg_monthly_precip`, and compare it to your new `numpy array`. **Do you notice any differences in the structure of the data between these two `numpy arrays`?**

</div>


{:.output}
    <class 'numpy.ndarray'>
    [[ 1.07  0.44  1.5   0.2   3.2   1.18  0.09  1.44  1.52  2.44  0.78  0.02]
     [ 0.27  1.13  1.72  4.14  2.66  0.61  1.03  1.4  18.16  2.24  0.29  0.5 ]]
    [0.7  0.75 1.85 2.93 3.05 2.02 1.93 1.62 1.84 1.31 1.39 0.84]


