---
layout: single
title: "How to Process Many Files in Python - Manipulate Directories, Filenames and Strings"
excerpt: "When automating workflows, it is helpful to be able to programmatically check for and create directories and to parse directory and file names to extract information. Learn how to manipulate directories and strings using Python."
authors: ['Leah Wasser', 'Jenny Palomino']
modified: 2018-10-31
category: [courses]
class-lesson: ['create-data-workflows']
permalink: /courses/earth-analytics-python/create-efficient-data-workflows/manipulate-files-directories-and-strings/
nav-title: 'Manipulate Directories & Strings'
week: 10
course: "earth-analytics-python"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---

{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Programmatically check for and create directories.
* Parse directory and file names to extract strings of information.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson and the data for week 10 of the course.

{% include/data_subsets/course_earth_analytics/_data-landsat-automation.md %}

</div>

{:.input}
```python
import os
from glob import glob
import matplotlib.pyplot as plt
import pandas as pd

import earthpy as et
import warnings
warnings.filterwarnings("ignore")

os.chdir(os.path.join(et.io.HOME, "earth-analytics"))
```

## Create Directories that Work Across Operating Systems - os.path.join

When you are working across different computers and platforms, it is useful to create paths that can be recognized by the Windows, Mac and Linux operating systems. The `join()` function from the `os.path` module creates a path in the format that the operating system upon which the code is being run (i.e. whatever your computer is running) requires.

This saves you the time of creating and fixing paths as you work on different machines. This approach becomes very useful when you need to move your workflow from say your laptop to a cloud or HPC environment. 

`os.path.join` takes as many strings are you provide in. It reads each string as a directory name and then creates an output path.

`os.path.join("dir1", "dir2", "dir3")`

IMPORTANT: you can create bad paths this way! This function does not actually test to ensure the path exists!

{:.input}
```python
# Create a path
path = os.path.join("data", "ndvi-automation", "sites")
path
```

{:.output}
{:.execute_result}



    'data/ndvi-automation/sites'





{:.input}
```python
# Does the path exist?
os.path.exists(path)
```

{:.output}
{:.execute_result}



    True





{:.input}
```python
# This path doesn't exist on this machine but you can still create it!
path2 = os.path.join("data2", "ndvi-automation", "sites")
os.path.exists(path2)
```

{:.output}
{:.execute_result}



    False





## Get Lists of Files Using glob and path.join

In a workflow where you are processing many files and directories, you can use `glob` with `path.join` to create a path and get a list of files in that path. 

By default, `glob()` returns only the files within that directory. 

{:.input}
```python
# There are no individual files within the sites directory on this machine
path = os.path.join("data", "ndvi-automation", "sites")
glob(path)
```

{:.output}
{:.execute_result}



    ['data/ndvi-automation/sites']





You can add the syntax `/*/` to tell glob to provide a list of directories rather than files. 

{:.input}
```python
# Add a trailing slash to force listing of directories
another_path = os.path.join("data", "ndvi-automation", "sites")
all_sites = glob(another_path + "/*/")
all_sites
```

{:.output}
{:.execute_result}



    ['data/ndvi-automation/sites/HARV/', 'data/ndvi-automation/sites/SJER/']





You can nest the above steps into one step as well.

{:.input}
```python
# This single line of code is the same as the line of code above
glob(os.path.join("data", "ndvi-automation", "sites") + "/*/")
```

{:.output}
{:.execute_result}



    ['data/ndvi-automation/sites/HARV/', 'data/ndvi-automation/sites/SJER/']





Once you have a list of directories, you could loop through each directory and do something with data within that directory.

{:.input}
```python
# Print out all site directories
for site_files in all_sites:
    print(site_files)
```

{:.output}
    data/ndvi-automation/sites/HARV/
    data/ndvi-automation/sites/SJER/



If you want to create a list of all directories within the landsat_crop dir of each site subdirectory, you could use the following workflow.


{:.input}
```python
# Define the directory name
landsat_dir = "landsat-crop"

# Loop through each site directory
for site_files in all_sites:
    
    # Get a list of subdirectories for that site
    new_path = os.path.join(site_files, landsat_dir)
    all_dirs = glob(new_path + "/*/")
    
    # Loop and print the path for each subdirectory
    for adir in all_dirs:
        print(adir) 
```

{:.output}
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017041801T1-SC20181023152618/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017080801T1-SC20181023151955/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017062101T1-SC20181023151938/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017090901T1-SC20181023151921/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017021301T1-SC20181023152047/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017012801T1-SC20181023151918/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017052001T1-SC20181023151947/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017082401T1-SC20181023152023/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017101101T1-SC20181023151948/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017030101T2-SC20181023151931/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017111201T1-SC20181023151927/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017123001T1-SC20181023151857/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017102701T1-SC20181023151948/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017072301T1-SC20181023152048/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017070701T1-SC20181023152155/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017040201T1-SC20181023152038/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017112801T1-SC20181023151921/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017031701T1-SC20181023151837/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017060501T2-SC20181023151903/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017092501T1-SC20181023152702/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017050401T1-SC20181023152417/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017121401T1-SC20181023152050/
    data/ndvi-automation/sites/HARV/landsat-crop/LC080130302017011201T1-SC20181023151858/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017081901T1-SC20181023153141/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017010701T2-SC20181023153321/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017092001T1-SC20181023170143/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017102201T1-SC20181023153638/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017120901T1-SC20181023152438/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017070201T1-SC20181023153031/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017042901T1-SC20181023153144/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017032801T1-SC20181023162825/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017061601T1-SC20181023152417/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017100601T1-SC20181023152121/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017112301T1-SC20181023170128/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017020801T1-SC20181023162521/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017080301T1-SC20181023185645/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017110701T1-SC20181023170129/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017031201T1-SC20181023152108/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017051501T1-SC20181023151959/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017012301T1-SC20181023170015/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017122501T1-SC20181023152106/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017090401T1-SC20181023162756/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017053101T1-SC20181023151941/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017071801T1-SC20181023153104/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017022401T1-SC20181023152103/
    data/ndvi-automation/sites/SJER/landsat-crop/LC080420342017041301T1-SC20181023170020/



## Grab Parts of a Directory Path

There are several ways that you can grab just a part of a path. Sometimes a file path has metadata in it that can be useful for creating useful variable names in your script. In your NDVI workflow, you may want to grab the site name from the directory path to use for your workflow. 

You can use a combination of `normpath()` and `basename()` functions from `os.path` to access the last directory in a path. In your case, this path contains your site name!


{:.input}
```python
os.path.normpath(site_files)
```

{:.output}
{:.execute_result}



    'data/ndvi-automation/sites/SJER'





{:.input}
```python
# Use normpath and basename together to get the last directory
sitename = os.path.basename(os.path.normpath(site_files)) 
sitename
```

{:.output}
{:.execute_result}



    'SJER'





There are endless ways to use the sitename as a variable in an automated workflow.

{:.input}
```python
# Create a file name needed to open a file
print(os.path.join(site_files, "vector", sitename + "-crop.shp"))

# Create an output path to an output csv file
print(os.path.join('data', "ndvi-automation","outputs","final.csv"))
```

{:.output}
    data/ndvi-automation/sites/SJER/vector/SJER-crop.shp
    data/ndvi-automation/outputs/final.csv



If you want to grab both the last directory name and the path prior to that directory, you can use `os.path.split` with `normpath()`.

{:.input}
```python
os.path.split(os.path.normpath(site_files))
```

{:.output}
{:.execute_result}



    ('data/ndvi-automation/sites', 'SJER')





## Parse Text From Directory Names

There are numerous options to parse text from a file path. In your homework, you need to grab the date when each Landsat scene was collected. To grab just the date from the directory, you will need to:

1. get the full directory path
2. find the date embedded within the path name

If you refer back to the Landsat metadata, you will see that every scene has the same naming convention. 

This means that you can count the characters (i.e. indices) in the directory name to find the collection date (which is the first date in the string) and use the same indices for every scene!

In this case, you can find the date using a string index like this:

`astring[startindex:endindex]`

{:.input}
```python
# View directory name 
dir_name = os.path.basename(os.path.normpath(adir))
```

{:.input}
```python
# Get landsat date from directory name
date = dir_name[10:18]
date
```

{:.output}
{:.execute_result}



    '20170413'





You can also break the entire path apart, if you need to do so, using `string_name.split`.

{:.input}
```python
# Break paths into components
path = os.path.normpath(adir)
path.split(os.sep)
```

{:.output}
{:.execute_result}



    ['data',
     'ndvi-automation',
     'sites',
     'SJER',
     'landsat-crop',
     'LC080420342017041301T1-SC20181023170020']





As you see, `string_name.split` produces a list that you can query to get a specific component.

{:.input}
```python
# Get the site name from the path
path_components = path.split(os.sep)
path_components[3]
```

{:.output}
{:.execute_result}



    'SJER'




