---
layout: single
title: 'Import Text Files Into Numpy Arrays'
excerpt: "Numpy arrays are an efficient data structure for working with scientific data in Python. Learn how to import text data from .txt and .csv files into numpy arrays."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-numpy-arrays']
permalink: /courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/import-txt-csv-files-numpy-arrays/
nav-title: "Import Data Into Numpy Arrays"
dateCreated: 2019-09-06
modified: 2021-01-28
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/numpy-arrays/import-text-files-numpy-arrays/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* List two common text file formats for importing data into **numpy** arrays. 
* Import data from text files (.txt, .csv) into **numpy** arrays. 

</div>


## Common Text File Formats For Importing Data into Numpy Arrays

Scientific data can come in a variety of file formats and types. In this textbook, you will import data into **numpy** arrays from two commonly used text file formats for scientific data: 
* Plain text files (.txt)
* Comma-separated values files (.csv)

### Plain Text Files

Plain text files simply list out the values on separate lines without any symbols or delimiters to indicate separate values. 

For example, average monthly precipitation (inches) for Boulder, CO, collected by the <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank"> U.S. National Oceanic and Atmospheric Administration (NOAA)</a>, can be stored as a plain text file (.txt), with a separate line for each month's value. 

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

Unlike plain-text files which simply list out the values on separate lines without any symbols or delimiters, files containing comma-separated values (.csv) use commas (or some other delimiter like tab spaces or semi-colons) to indicate separate values.

This means that .csv files can easily support multiple rows and columns of related data. 

For example, the monthly precipitation values for Boulder, CO for the years 2002 and 2013 can be stored together in a comma-separated values (.csv) file, with each year of data on a separate line and each month of data within a specific year separated by commas: 

```python
1.07, 0.44, 1.50, 0.20, 3.20, 1.18, 0.09, 1.44, 1.52, 2.44, 0.78, 0.02
0.27, 1.13, 1.72, 4.14, 2.66, 0.61, 1.03, 1.40, 18.16, 2.24, 0.29, 0.5
```

As you learned previously in this chapter, you can manually define **numpy** arrays as needed using the `numpy.array()` function. However, when working with larger datasets, you will want to import data directly into **numpy** arrays from data files (such as .txt and .csv). 


## Get Data To Import Into Numpy Arrays
  
### Import Python Packages and Set Working Directory

In previous chapters, you learned how to import **Python** packages.

To import data into **numpy** arrays, you will need to import the **numpy** package, and you will use the **earthpy** package to download the data files from the Earth Lab data repository on **Figshare.com**. 

{:.input}
```python
# Import necessary packages
import os

import numpy as np
import earthpy as et
```

### Download Data from URL Using EarthPy

You can use the function `data.get_data()` from the **earthpy** package (which you imported with the alias `et`) to download data from online sources such as the **Figshare.com** data repository. 

To use the function `et.data.get_data()`, you need to provide a parameter value for the `url`, which you define by providing a text string of the URL to the dataset.

Begin by downloading a .txt file for average monthly precipitation (inches) for Boulder, CO collected by the <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank"> U.S. National Oceanic and Atmospheric Administration (NOAA)</a> from the following URL: 

`https://ndownloader.figshare.com/files/12565616`

{:.input}
```python
# Define variable for URL to .txt with avg monthly precip data
monthly_precip_url = 'https://ndownloader.figshare.com/files/12565616'

# Provide variable as parameter value for `url`
et.data.get_data(url=monthly_precip_url)
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12565616



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/avg-monthly-precip.txt'





Take a close look at the path to this file. By default, the `data.get_data()` function downloads data from URLs to the following directory:

```bash
/home/your-username/earth-analytics/data/earthpy-downloads/
```

If the directory does not already exist, the function will create it for you.  

The month names are stored in a different .txt file, which you can download from the following URL:

`https://ndownloader.figshare.com/files/12565619`

{:.input}
```python
# Download data from URL to .txt with month names
month_names_url = 'https://ndownloader.figshare.com/files/12565619'
et.data.get_data(url=month_names_url)
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12565619



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/months.txt'





Next, download a .csv file that contains the monthly precipitation (inches) for Boulder, CO for the years 2002 and 2013, collected by the <a href="https://www.esrl.noaa.gov/psd/boulder/Boulder.mm.precip.html" target="_blank"> U.S. National Oceanic and Atmospheric Administration (NOAA)</a>.

{:.input}
```python
# Download data from URL to .csv of precip data for 2002 and 2013
precip_2002_2013_url = 'https://ndownloader.figshare.com/files/12707792'
et.data.get_data(url=precip_2002_2013_url)
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12707792



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/monthly-precip-2002-2013.csv'





Now that you have downloaded these files, you can take a look at them by opening the files from your file explorer. Recall that these files have been downloaded to: 

`/home/your-username/earth-analytics/data/earthpy-downloads/`

Notice the structure of each file. While `avg-monthly-precip.txt` contains numeric values and `months.txt` contains text string values, both files are plain text files with a separate line for each month's value.

On the other hand, `monthly-precip-2002-2013.csv` contains rows and columns of data, with each year of data on a separate line and each month of data within a specific year separated by commas.


## Import Numeric Data from Text Files Into Numpy Arrays

You can easily create new **numpy** arrays by importing numeric data from text files (.txt and .csv) using the `loadtxt()` function from **numpy** (which you imported with the alias `np`) .

Begin by setting the working directory to your `earth-analytics` directory using the **os** package and the **HOME** attribute of the **earthpy** package. 

As you learned in the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/">working with paths and directories</a>, this will provide you with the flexibility to specify files to import from various subdirectories that you might have within the `earth-analytics` directory. 

{:.input}
```python
# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

### Import Data From TXT File

To import data from a .txt file, you simply need to specify a value for the parameter called `fname` for the file name:

`np.loadtxt(fname)`

Recall from the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/">working with paths and directories</a> that you can use `os.path.join()` to create paths that will work on any operating system. 

In the example below, the `fname` is defined using `os.path.join()` with a relative path to the `avg-monthly-precip.txt` file because you previously set the working directory to `earth-analytics`. 

{:.input}
```python
# Define path to file using os.path.join
fname = os.path.join("data", "earthpy-downloads",
                     "avg-monthly-precip.txt")

# Import average monthly precip to numpy array
avg_monthly_precip = np.loadtxt(fname)

print(avg_monthly_precip)
```

{:.output}
    [0.7  0.75 1.85 2.93 3.05 2.02 1.93 1.62 1.84 1.31 1.39 0.84]



Notice that the data from the .txt file has been imported as a one-dimensional array (`avg_monthly_precip`), contained within a single set of brackets `[]`. 

Recall that you can use the `type()` function to check the type for variable.  In this case, you can check that `avg_monthly_precip` is indeed a `numpy array`. 

{:.input}
```python
# Check type
type(avg_monthly_precip)
```

{:.output}
{:.execute_result}



    numpy.ndarray





### Import Data From CSV File

You can also use `np.loadtxt(fname)` to import data from .csv files that contain rows and columns of data. 

You will need to specify both the `fname` parameter as well as the `delimiter` parameter to indicate the character that is being used to separate values in the file (e.g. commas, semi-colons):

`np.loadtxt(fname, delimiter = ",")`

{:.input}
```python
# Import monthly precip for 2002 and 2013 to numpy array
fname = os.path.join("data", "earthpy-downloads",
                     "monthly-precip-2002-2013.csv")
precip_2002_2013 = np.loadtxt(fname, delimiter=",")
```

{:.input}
```python
# Check type
type(precip_2002_2013)
```

{:.output}
{:.execute_result}



    numpy.ndarray





{:.input}
```python
print(precip_2002_2013)
```

{:.output}
    [[ 1.07  0.44  1.5   0.2   3.2   1.18  0.09  1.44  1.52  2.44  0.78  0.02]
     [ 0.27  1.13  1.72  4.14  2.66  0.61  1.03  1.4  18.16  2.24  0.29  0.5 ]]



Notice that the data from the .csv file has been imported as a two-dimensional array (`precip_2002_2013`), contained within two set of brackets `[]`.  

## Import Text String Data from Text Files Into Numpy Arrays

As needed, you can also import text files with text string values (such as month names) to **numpy** arrays using the `genfromtxt()` function from **numpy**. 

You need to specify a parameter value for `fname` as well as a parameter value for the data type as `dtype='str'`:

`np.genfromtxt(fname, dtype='str')`

{:.input}
```python
# Import month names
fname = os.path.join("data", "earthpy-downloads", "months.txt")
months = np.genfromtxt(fname, dtype='str')

type(months)
```

{:.output}
{:.execute_result}



    numpy.ndarray





{:.input}
```python
print(months)
```

{:.output}
    ['Jan' 'Feb' 'Mar' 'Apr' 'May' 'June' 'July' 'Aug' 'Sept' 'Oct' 'Nov'
     'Dec']



You now know how to import data from text files into **numpy** arrays, which will come in very handy as you begin to work with scientific data. 

On the next pages of this chapter, you will learn how to work with **numpy** arrays to run calculations, summarize data, and more. 
