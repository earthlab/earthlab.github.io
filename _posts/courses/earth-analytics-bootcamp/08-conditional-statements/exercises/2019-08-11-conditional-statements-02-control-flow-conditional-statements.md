---
layout: single
title: 'Control Flow Using Conditional Statements'
excerpt: "This lesson teaches you how to control the flow of your code using conditional statements."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['conditional-statements']
permalink: /courses/earth-analytics-bootcamp/conditional-statements/control-flow/
nav-title: "Control Flow Using Conditional Statements"
dateCreated: 2019-08-11
modified: 2018-08-16
module-type: 'class'
class-order: 2
course: "earth-analytics-bootcamp"
week: 8
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn about controlling the flow of your code using conditional statements, in combination with logical operators that check for multiple conditions and with the `glob` package that helps you to easily list the names of files and directories on your computer.  

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this lesson, you will be able to:

* Explain how conditional statements can be used to control the flow of code
* Write conditional statements that include multiple conditions or multiple lines of code, in order to control the flow of code


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the lessons on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/loops/intro-dry-code/">Intro to DRY Code</a> and <a href="{{ site.url }}/courses/earth-analytics-bootcamp/conditional-statements/intro-conditional-statements/">Intro to Conditional Statements</a>. 

</div>
 

## Logical Operators

In previous lessons, you used comparison operators, which allow you to compare values such as checking whether one value is greater than another (e.g. `<`, `>`). You also used assignment operators (e.g. `+=`), which allow you to set a variable to a new value based on an arithmetic operation or some other calculation.

In this lesson, you will learn about another type of operator: logical. In conditional statements, logical operators are very useful for checking for multiple conditions as well as creating combinations of conditions to control the flow of code. 

For example, you can use:

* `and` to provide multiple conditions that all have to be met before executing code
* `or` to provide multiple conditions, of which only one has to be met before executing code
* `not` to execute code only if the stated condition is not met (note: you can use `not` in combination with `and` or `or` to check whether multiple conditions are not met)

In this lesson, you will use these logical operators to write conditional statements that determine whether a specific combination of conditions is met before executing code. 


## Glob Package

The `glob` package in `Python` is very useful for creating lists of directory and file names on your computer. It contains a module also called `glob` that provides this functionality. 

For example, you can use `glob.glob("path/*")` to get a list of all items in a directory, and assign this list to a variable called `filelist`:

{:.input}
```python
# import necessary package
import glob

# create a list of all items in the data directory identified by the full path to the directory
filelist = glob.glob('/home/jpalomino/earth-analytics-bootcamp/data/*')

# print the new list
print(filelist)
```

{:.output}
    ['/home/jpalomino/earth-analytics-bootcamp/data/avg-monthly-precip.txt', '/home/jpalomino/earth-analytics-bootcamp/data/snow-2007-to-2017.csv', '/home/jpalomino/earth-analytics-bootcamp/data/avg-monthly-temp.txt', '/home/jpalomino/earth-analytics-bootcamp/data/monthly-precip-2002-2013.csv', '/home/jpalomino/earth-analytics-bootcamp/data/avg-precip-months-seasons.csv', '/home/jpalomino/earth-analytics-bootcamp/data/snow-2007-to-2017-months-seasons.csv', '/home/jpalomino/earth-analytics-bootcamp/data/avg-temp-months-seasons.csv', '/home/jpalomino/earth-analytics-bootcamp/data/precip-2002-2013-months-seasons.csv', '/home/jpalomino/earth-analytics-bootcamp/data/months.txt']



Note that the `*` indicates that you want to list all items in the directory provided, which in this case is the `data` directory. Later in this lesson, you will learn how to expand on this syntax to search by keywords. 

You can also use `glob.glob` in conjunction with `os.chdir` to set relative paths. Again, you are specifying that you want to include all items in the subdirectory `data`. 

{:.input}
```python
# import necessary packages
import glob
import os

# set the working directory to the `earth-analytics-bootcamp` directory
# replaced code below as needed with the path to your working directory
os.chdir("/home/jpalomino/earth-analytics-bootcamp/")

# create a list of all items in the data directory identified by a relative path to the directory
filelist = glob.glob('data/*')

# print the new list
print(filelist)
```

{:.output}
    ['data/avg-monthly-precip.txt', 'data/snow-2007-to-2017.csv', 'data/avg-monthly-temp.txt', 'data/monthly-precip-2002-2013.csv', 'data/avg-precip-months-seasons.csv', 'data/snow-2007-to-2017-months-seasons.csv', 'data/avg-temp-months-seasons.csv', 'data/precip-2002-2013-months-seasons.csv', 'data/months.txt']



## Control Flow With Conditional Statements

Using `glob.glob` to query directory and file names can be very useful to check that a certain file or directory exists before you execute code.

For example, you have seen that in this course, you frequently use the `data` directory to download from `Figshare.com`. 

If you were working toward automating this task, it would be a great idea to check that the `data` directory exists before you attempted to download files to it, right?

You can do this easily by using a conditional statement and `glob.glob()`. 

Rather than specifying a subdirectory name, as in the example above, you will simply ask for everything in the working directory by removing the subdirectory name for `data` and replacing it with an asterisk `*`.

{:.input}
```python
# import necessary packages
import glob
import os

# set the working directory to the `earth-analytics-bootcamp` directory
# replaced code below as needed with the path to your working directory
os.chdir("/home/jpalomino/earth-analytics-bootcamp/")

# create a list of all items in the earth-analytics-bootcamp directory 
directorylist = glob.glob('*')

# print the new list
print(directorylist)            
```

{:.output}
    ['ea-bootcamp-hw-2-jlpalomino', 'other_data', 'ea-bootcamp-day-1', 'ea-bootcamp-day-5', 'data', 'ea-bootcamp-day-8', 'ea-bootcamp-day-2', 'ea-bootcamp-hw-1', 'ea-bootcamp-hw-2', 'ea-bootcamp-day-4', 'ea-bootcamp-day-7']



Now that you have a list of the items in the directory, you can use this list to check for the `data` directory and print a certain message if it is in `directorylist`.

{:.input}
```python
# check whether the data directory name exists in the list and print message accordingly
if "data" in directorylist:
    print("The data directory exists. Proceed!")

else:
    print("The data directory does NOT exist. Create the data directory before continuing!")
```

{:.output}
    The data directory exists. Proceed!



### Multiple Conditions

You can also use multiple conditions to check for more than directory, such as checking for both the `data` directory and the `ea-bootcamp-day-5` directory. 

Recall that you can combine multiple conditions using `and`, and that both conditions have to be true, in order to execute the code under `if`. 

This means that only one condition has to fail, in order for the conditional statement to execute code under `else`. 

{:.input}
```python
# check whether the data directory exists and print message accordingly
if "data" in directorylist and "ea-bootcamp-day-5" in directorylist:
    print("Both directories exist. Proceed!")

else:
    print("One of these directories does NOT exist. Create the necessary directories before continuing!")    
```

{:.output}
    Both directories exist. Proceed!



You could also add `not` to check that items are not in a list before continuing. For example, you can check for some directories that should have been replaced or deleted. 

{:.input}
```python
# check whether old directories that should be removed still exist and print message accordingly
if "old-data" not in directorylist and "old_ea-bootcamp-day-5" not in directorylist:
    print("Both directories do NOT exist. Proceed!")

else:
    print("One of these directories exists. Delete these directories before continuing!")  
```

{:.output}
    Both directories do NOT exist. Proceed!



### Search Keywords Using Glob

Next, imagine that you want to create a list of filenames in the `data` directory but you only want the files that include `precip` in the filename. 

You also know that you should have a certain number of files that include `precip` in the filename and you want to check that you have that number before additional code is executed. 

For example, at this point in the course, you should have four files in the data directory with `precip` in the filename.  

Begin by adding a wild card search in your `glob.glob()` code line. This easily done by adding the keyword enclosed in asterisks `*` to the path (e.g. `/data/*precip*`). 

{:.input}
```python
# import necessary packages
import glob
import os

# set the working directory to the `earth-analytics-bootcamp` directory
# replaced code below as needed with the path to your working directory
os.chdir("/home/jpalomino/earth-analytics-bootcamp/")

# create a list of all items in the data directory identified by a relative path to the directory
filelist = glob.glob('data/*precip*')

# print the new list
print(filelist)            
```

{:.output}
    ['data/avg-monthly-precip.txt', 'data/monthly-precip-2002-2013.csv', 'data/avg-precip-months-seasons.csv', 'data/precip-2002-2013-months-seasons.csv']



You can see that `filelist` has been created as a `Python` list, which means that you can query the length of the list using `len(listname)`.

{:.input}
```python
# print the lenght of filelist
len(filelist)
```

{:.output}
{:.execute_result}



    4





Now you can set up a conditional statement to check whether the length of the created list meets a certain criteria before executing additional code.

This can be very useful to check that all of the files that your code will need are in the directory. 

{:.input}
```python
# check if filelist contains four filenames
if len(filelist) == 4:
    print("The data directory contains the correct number of files with precip in the name. Code can continue to execute.")
    
else:
    print("The data directory does NOT contain the correct number of files with precip in the name. Check list of files.")
    print(filelist)    
```

{:.output}
    The data directory contains the correct number of files with precip in the name. Code can continue to execute.



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 1

Test your `Python` skills to:

1. Use `glob.glob` to make a list of all **.csv** files in the `data` directory. 
    * Note that rather than specifying a wildcard for the name, you will specify a specific file type using `glob.glob('directoryname/*.csv').

</div>


{:.output}
    ['data/snow-2007-to-2017.csv', 'data/monthly-precip-2002-2013.csv', 'data/avg-precip-months-seasons.csv', 'data/snow-2007-to-2017-months-seasons.csv', 'data/avg-temp-months-seasons.csv', 'data/precip-2002-2013-months-seasons.csv']



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 2

Test your `Python` skills to:

1. Modify your code from the previous challenge to find only **.csv** files that include **snow** in the filename in the `data` directory. 

</div>


{:.output}
    ['data/snow-2007-to-2017.csv', 'data/snow-2007-to-2017-months-seasons.csv']



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 3

Test your `Python` skills to:

1. Write a conditional statement to check that the list created in the previous challenge (.csv files with snow in the filename) only includes two files.

</div>


{:.output}
    The data directory contains the correct number of .csv files with snow in the name. Code can continue to execute.


