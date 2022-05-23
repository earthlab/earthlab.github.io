---
layout: single
title: 'Use the OS and Glob Python Packages to Manipulate File Paths'
excerpt: "The os and glob packages are very useful tools in Python for accessing files and directories and for creating lists of paths to files and directories, respectively. Learn how to manipulate and parse file and directory paths using os and glob."
authors: ['Nathan Korinek', 'Jenny Palomino', 'Leah Wasser']
dateCreated: 2020-02-24
modified: 2020-11-12
category: [courses]
class-lesson: ['work-with-files-directories-in-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/os-glob-manipulate-file-paths/
nav-title: "Manipulate File and Directory Paths"
course: "intro-to-earth-data-science-textbook"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-python/create-efficient-data-workflows/manipulate-files-directories-and-strings/"  
---

{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Use **earthpy** to download files from a URL (internet address).
* Use **glob** to get customized lists of files or directories.
* Use various functions in the **os** package to manipulate file paths. 

</div>

For many data projects, it can be helpful to manipulate and parse file and directory paths, especially when you want to programmatically access data files and automate workflows. 

To start working with file and directory paths in **Python**, you first need some files! On this page, you will first learn how to use the **earthpy** package to download files from a URL (internet address). 

Then, you will use the **os** and **glob** packages to access files and directories and to create lists of paths that you can parse to extract useful information from the file and directory names.


## Download Files Using EarthPy

You can use the function `data.get_data()` from the **earthpy** package to download data from online sources such as the **Figshare.com** data repository. 

Begin by importing the necessary packages: **os**, **glob**, and **earthpy** (using the alias `et`).  

{:.input}
```python
# Import necessary packages
import os
from glob import glob

import earthpy as et
```

To use the function `et.data.get_data()`, you can provide a parameter value for the `url`, which you define by providing a text string of the URL (internet address) for the dataset.

{:.input}
```python
# Download data on average monthly temp for two California sites
file_url = "https://ndownloader.figshare.com/files/21894528"
et.data.get_data(url = file_url)
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/21894528
    Extracted output to /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr'





By default, `et.data.get_data()` will download files to `earth-analytics/data/earthpy-downloads` under your home directory, and it will create the necessary directories if they do not already exist. 

With this information, you can set the working directory to your `earth-analytics` directory and then create a relative path to the downloaded data directory. 

{:.input}
```python
# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, "earth-analytics"))

# Create a path to the data folder
data_folder = os.path.join("data", "earthpy-downloads", 
                           "avg-monthly-temp-fahr")
```

## Glob in Python

**glob** is a powerful tool in Python to help with file management and filtering. While **os** helps manage and create specific paths that are friendly to whatever machine they are used on, **glob** helps to filter through large datasets and pull out only files that are of interest. 

The `glob()` function uses the rules of Unix shell to help users organize their files. Unix shell follows fairly straight-forward rules to search for items, which you will explore below.

### Search for a Specific Folder or File

The `glob` function can be used to find just one folder or file. This can be done by just giving `glob` the path of the item you are trying to find. 

{:.input}
```python
# Get a specific directory
file_list = glob(data_folder)

file_list
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr']





This is not very useful, as you already have the data path if you are using it to search for something. 

Notice, however, that `glob` returns a list of all items that match your search, not as individual strings.

{:.input}
```python
type(file_list)
```

{:.output}
{:.execute_result}



    list





You can also use the `glob()` function in combination with the `os.path.join()` function to create lists of paths that are built programmatically. 

{:.input}
```python
# Create a list containing a specific file name
glob(os.path.join(data_folder, 'San-Diego', 'San-Diego-1999-temp.csv'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv']





### `*` Operator

`glob` uses different operators to broaden its searching abilities. The primary operator is `*`. 

The `*` is a sort of wildcard that can be used to search for items that have differences in their names. Whatever text doesn't match can be replaced by a `*`. 

For example, if you want every file in a directory to be returned to you, you can put a `*` at the end of a directory path.  

`glob` will return a list of all of the files in that directory.  

{:.input}
```python
# Get list of all files/dirs in data folder
glob(os.path.join(data_folder, '*'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego']





{:.input}
```python
# Get list of all files/dirs in San-Diego folder
glob(os.path.join(data_folder, 'San-Diego', '*'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv']





If you only want `.csv` files, than `*.csv` will return every file that ends with `.csv`. 

{:.input}
```python
# Get only csv files
glob(os.path.join(data_folder, 'San-Diego', '*.csv'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv']





If you only want `.csv` files with the number `2` somewhere in the file name, than `*2*.csv` will return that list. 

{:.input}
```python
# Use multiple wildcards
glob(os.path.join(data_folder, 'San-Diego', '*2*.csv'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv']





Note that `2*.csv` would only return files that **start** with the number `2`. 

{:.input}
```python
# Create empty list (no file names begin with 2)
glob(os.path.join(data_folder, 'San-Diego', '2*.csv'))
```

{:.output}
{:.execute_result}



    []





The additional asterix in front of `2` (e.g. `*2*.csv`) allows the `2` to be anywhere in the path. 

The `*` is meant to replace all text that does not matter to your search. 

### Recursive Searches

If you are trying to operate on files across multiple directories, you can use multiple `*` in a file path to indicate that you want every file in all folders in a directory. 

The first `*` is to access all directories in the starting directory (e.g. `data_folder`). 

This followed by the second `*` operator, which loops through all subdirectories to make a list of all their contents.

{:.input}
```python
# Search recursively through both site folders
glob(os.path.join(data_folder, '*', '*'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv']





### Sorting `glob` Lists

Notice that the lists provided by `glob` are not sorted. 

{:.input}
```python
# Get list of CSVs in Sonoma directory
sonoma_files = glob(os.path.join(data_folder, 'Sonoma', '*.csv'))
sonoma_files
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv']





If it's important for a list to be in a certain order, then always make sure to sort the list returned by `glob` using the `.sort()` method for lists.

{:.input}
```python
# Sort glob list
sonoma_files.sort()
```

{:.input}
```python
# Another option for sorting lists
sonoma_files = sorted(glob(os.path.join(data_folder, 'Sonoma', '*.csv')))
sonoma_files
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv']





Note that sorting can sometimes work differently than you may think, so check your sorted list before you move on with your project.  

For example, if two items have identical path names, but one ends in `10` and the other ends in `1`, sometimes the file ending in `10` will be put above the file ending in `1`. Always double check!

### Why Sort `glob` Lists?

The order in which `glob` returns files from a folder can vary drastically.  Depending on the operating system being used, or the way the files are stored, different people may get results from a `glob` list in different orders. 

This can lead to data errors when running projects across computers. 

For example, consider how sorting a `glob` list changes what files you access when getting an index from the list, such as index `[4]` to access the 5th item in the list.  

{:.input}
```python
unsorted_sonoma = glob(os.path.join(data_folder, 'Sonoma', '*'))
print(unsorted_sonoma[4])
```

{:.output}
    data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv



{:.input}
```python
# Indexes change once a list is sorted!
sorted_sonoma = glob(os.path.join(data_folder, 'Sonoma', '*'))
sorted_sonoma.sort() 

print(sorted_sonoma[4])
```

{:.output}
    data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv



### Using Ranges

In addition to using `*` to specify which parts of a file name are important to you, you can use `[]` to specify a range of characters to search for. 

For example, you can create a search for all files with 2001 to 2003 in the name by using `*200` and adding `[1-3]*` to it. 

{:.input}
```python
# Get files for 2001-2003
glob(os.path.join(data_folder, '*', '*200[1-3]*'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv']





This is not just limited to numbers. `[d-q]` would also filter results for characters between the letters `d` and `q`. 

Note, however, that this search range is for characters only, not strings. 

For example, you can search for numbers 2-7 with `[2-7]` but you would not be able to search for numbers `[2-14]` because `14` is more than one character.  

Notice below that the search does not work correctly because `[2001-2003]` are more than one character.

{:.input}
```python
# Get incorrect range for 2002-2003
glob(os.path.join(data_folder, '*', '*[2001-2003]*'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv']





### `?` Operator

The `?` operator functions similarly to the `*` operator but is used for a single character. 

If one character in the file name can be variable, but everything else must stay the same, than `?` is a good way to just replace that one character. 

{:.input}
```python
# ? operator used for last value in year
glob(os.path.join(data_folder, 'Sonoma', '*200?-temp.csv'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv']





`?` is not limited to one use per search and can be used to replace more than one character in a query. 

{:.input}
```python
# Multiple ? operators
glob(os.path.join(data_folder, 'Sonoma', '*19??-temp.csv'))
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv']





### Saving a `glob` Output to a Variable

In order to use the output of `glob` later in a script, be sure to save it to a variable! It can be done easily by just assigning the `glob` function output a variable name.

{:.input}
```python
sd_data = glob(os.path.join(data_folder, 'San-Diego', '*'))
sd_data.sort()

sd_data
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv']





## `os` Advanced Functionality

`os` is another very powerful tool and has additional functionality that can be useful when dealing with file paths, such as advanced parsing abilities. 

For example, `os.path.normpath()` is a great way to clean up file paths. It takes out any unnecessary characters to make the path more easily read. 

It is a good way to make sure your path is properly formatted before using other `os` functions on the path. 

{:.input}
```python
# Example of normpath cleaning up path
example_path = "home//user//example_dir"
os.path.normpath(example_path)
```

{:.output}
{:.execute_result}



    'home/user/example_dir'





`os.path.commonpath()` is a very useful when combined with `glob`. This function will take a list of file paths and find the lowest directory that all the files have in common. 

So if there were two files, one stored in `home/user/dir/dir2/example.txt` and one stored in `home/user/dir/example.txt`, then `os.path.commonpath()` would return `home/user/dir` as it's the lowest common directory the two folders share. 

{:.input}
```python
# Print list of files
sd_data
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv']





{:.input}
```python
# Get a shared directory from a list of files
os.path.commonpath(sd_data)
```

{:.output}
{:.execute_result}



    'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego'





`os.path.basename()` finds the last section of a path and returns that. If a file path is passed in, the file name will be parsed out and returned. 

{:.input}
```python
# Print normalized path
os.path.normpath(data_folder)
```

{:.output}
{:.execute_result}



    'data/earthpy-downloads/avg-monthly-temp-fahr'





{:.input}
```python
# Get the last part of a file path with basename
os.path.basename(os.path.normpath(data_folder))
```

{:.output}
{:.execute_result}



    'avg-monthly-temp-fahr'





`os.path.split()` will split a path into two parts:

1. the last part of the path.
2. the rest of the path. 

It returns the same output as `os.path.basename()` with the addition of the rest of the path that was left out as another .

{:.input}
```python
# Get the last part of a file path and the rest of the path
os.path.split(os.path.normpath(data_folder))
```

{:.output}
{:.execute_result}



    ('data/earthpy-downloads', 'avg-monthly-temp-fahr')





You can then use indexing on the result to get each piece of the split path.

{:.input}
```python
os.path.split(os.path.normpath(data_folder))[0]
```

{:.output}
{:.execute_result}



    'data/earthpy-downloads'





{:.input}
```python
os.path.split(os.path.normpath(data_folder))[1]
```

{:.output}
{:.execute_result}



    'avg-monthly-temp-fahr'





## String Manipulation 

Recall that when you create a file path using `os.path.join()`, it will properly format a string of the file path, so it can be used on any operating systems.

Note, however, that the file path is still just a string. Thus, you can parse file paths, just like you would strings, and extract information from them that you may need for a project. 

`.split()` is a built-in **Python** function that splits a string into a list of strings based on a separator 
character, and can be used in combination with `os.sep` to separate directories in file paths into their base parts. `os.sep`is a data value stored in `os` that will return the character used to separate pathname components, such as directory or file names. This is `\\` for Windows and `/` for POSIX systems, such as Mac or Linux.

{:.input}
```python
# Separate a path into parts
file_path_list = data_folder.split(os.sep)
file_path_list
```

{:.output}
{:.execute_result}



    ['data', 'earthpy-downloads', 'avg-monthly-temp-fahr']





{:.input}
```python
file_path_list[2]
```

{:.output}
{:.execute_result}



    'avg-monthly-temp-fahr'





In addition to built-in functions, file paths can be parsed with `string[start_index:end_index]` like a normal string. This can help get important infromation from a file path, such as a date.

{:.input}
```python
# Print list of files
sd_data
```

{:.output}
{:.execute_result}



    ['data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv',
     'data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv']





{:.input}
```python
# Get file name
year_path = sd_data[0]
file_name = os.path.basename(year_path)
print(file_name)
```

{:.output}
    San-Diego-1999-temp.csv



{:.input}
```python
# Parse a date from file name
year = file_name[10:14]
print(year)
```

{:.output}
    1999



Notice that the range includes the first index value but not the second index value (e.g. `1999` are index values 10 through 13). 

Think about how you can use the same string parsing syntax to get the site name!

You have now learned the essentials of **glob** and **os** to create custom lists of files and directories to manipulate and parse file names and directories, which can come in handy for future projects. 
