---
layout: single
title: 'Write Code That Will Work On Any Computer: Introduce to Using the OS Python Package to Setup Working Directories and to Construct File Paths'
excerpt: "Manually constructed files paths will often not run on computers with different operating systems. Learn how to construct file paths in Python that will work on MAC, Linux and Windows in support of open reproducible science."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['work-with-files-directories-in-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-in-python/set-working-directory-os-package/
nav-title: "Set Working Directory"
dateCreated: 2019-09-18
modified: 2019-09-26
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Use the earthpy attribute: `et.io.HOME` to find the home directory on any computer.
* Use `os.path.join()` to create paths that will work on Windows, MAC and Linux.
* Use `os.path.exists()` to ensure a file path exists.
* Set your working directory in **Python**.

</div>

You will need the `os` and the `earthpy` packages to complete this lesson.

In this lesson your goal is to create and set the **earth-analytics** directory
as your working directory using code that will work on any computer.
This directory should exist in your **HOME** directory. The path will look
something like this: **user-name/earth-analytics** following the example that
you used in the previous lesson.

To create and construct this working directory, you will use several functions
located in the **os** Python package. You will also use **earthpy**.

{:.input}
```python
import os
import earthpy as et
```

## Paths in Python
It is important to consider paths and working directories when setting up
projects in python. The ideal scenario is that your code can run on any machine.
Ensuring that your code can run on multiple machines makes it easier to:

1. set things up in the rare case that your machine dies.
2. move your workflow to a cloud environment or high performance computing infrastructure
2. share your project and collaborate with others.

There are a few things to consider when creating paths that can make reproducibility
challenging

Paths are constructed differently on different operating systems: For example the
path to **earth-analytics/data** that we examined in the previous lesson looks like:

* **earth-analytics/data** on mac and linux and
* **earth-analytics\\data** on Windows

The difference above is the direction and number of slashes. This
path: **earth-analytics/data**
will NOT work on Windows. And this path: **earth-analytics\\data** won't work on
a MAC or Linux. Lucky for you, there are a suite of tools that you can use to
construct paths that will ensure that your code works across platforms. This
will make it easier for you to collaborate with multiple people and to share your
code.

## Build Directory Paths that Work Across Operating Systems: os.path.join

The **path** module within the **os** package contains a `join()` function that
will create a path from a list of strings. When this function is run, it will
adapt to the operating system that is calling python.

`os.path.join` takes as many strings as you provide it. It reads each string as a
directory name and then creates an output path.

`os.path.join("dir1", "dir2", "dir3")`

Note the example below.


{:.input}
```python
# If you run the command on your computer, it will create a path that works on your computer.
os.path.join("earth-analytics", "data")
```

{:.output}
{:.execute_result}



    'earth-analytics/data'





The `join()` function from the `os.path` module creates a path in the format
that the operating system upon which the code is being run (i.e. whatever your
computer is running) requires. Constructing a path using the join function
will save you time when you move your code to another computer. You will not
have to manually create or fix paths.

<i class="fa fa-exclamation-circle"></i> **IMPORTANT** You can create paths that do not exist on
your computer using this approach. Be careful about ensuring that you have
spelled directories correctly and that they are in the correct order. `os.path.join`
does does not actually test to ensure that the path exists!
{: .notice--success}

Because you can potentially create a path that doesn't exist on your computer,
you can use the path exists using the `exists()` function to test that your
directory is correct. Like this:

{:.input}
```python
# Check that a directory that you constructure exists on your computer
my_path = os.path.join("earth-analytics", "data")
my_path
os.path.exists(my_path)
```

{:.output}
{:.execute_result}



    False





In the example above, you have created a path. However, that path may not
already exist on your computer. If python can't find the directory, there are several
issues to consider.  

1. Your working directory may not be set properly so that it can find the relative path.
2. You have a misspelling in you path. Or the case is incorrect.

## Check and Set Your Working Directory Using OS

You can use the **os** package to check and set your working directory. This is
another good check to implement when you get file not found errors in your code.
Below you see the use of two functions:

* `getcwd()`: CWD stands for Current Working Directory. This allows you to see what your current working directory is and
* `setchdir("path-to-wd-here/path-dir2/path-dir3")`: Short for *CH*ange *DIR*ectory, this  functions allows you to set the current working directory to a path of your choice.  

## Check Your Current Working Directory

Check your current working directory using `os.getcwd()`. What does the output look like?

In the example below you can see some example output from the computer that is
being used to write this lesson that you are reading (which is in a Jupyter
Notebook!). Do you notice any characteristics of this path that might make it
difficult to run on another computer?

`os.getcwd()`

Output
`/Users/username/Documents/github/1-courses/earth-analytics-lessons`

1. The path above use a username in it.
2. It also has directories including **Documents** and **github** that may or may not be on another computer.
3. Finally there are slashes that create that path. Notice that these slashes could work on a MAC but they might not work on Windows.

This working directory could be problematic for both your future self and it
may not run on other machines.

You can set the working directory using `os.chdir()`. This could solve some of your
problems, IF the **earth-analytics** directory that you want to use exists within your
home directory. (Remember that all computers have a HOME directory.)

`os.chdir("~/")`

The above syntax mimics what you might use in shell to navigate to your HOME
directory, however it unfortunately doesn't work in Python.

For the rest of this textbook, you will use the **earth-analytics** directory
which should be located in your HOME directory on your computer. The **earthpy**
package, within the **io** module, contains a HOME attribute that will locate your
home directory. Following this path, you can then create the **earth-analytics**
directory (if it doesn't already exist) and set that as your working directory
in each notebook.


## User earthpy .HOME Attribute to Locate Your Home Directory
To address this challenge `earthpy` has a `HOME` attribute that will help you
locate your home directory on your computer. You can call it using:

{:.input}
```python
et.io.HOME
```

{:.output}
{:.execute_result}



    '/root'





When you call `et.io.HOME`, it provides you with a path that is the home
directory path on your computer. This path will account for whatever operating
system it is run on, so it should work on any computer.


{:.input}
```python
# Find your home directory
et.io.HOME
```

{:.output}
{:.execute_result}



    '/root'





You can check to ensure that the directory above exists using `os.path.exists()`.
Note that the **earthpy** attribute is nested within os.path.exists below. It
returns a **boolean** value of True which means that the path does in fact exist
on your computer.

{:.input}
```python
# Does your home directory exist (of course it does!)
os.path.exists(et.io.HOME)
```

{:.output}
{:.execute_result}



    True





## Create a Directory Using the os Module in Python

You can use the `os.mkdir("path/to/dir/here")` function to create a directory in
Python. This function is helpful if you need to create a new directory that
doesn't already exist. However, as you have learned above, this function will
only work on multiple computers and across operating systems if you construct
the path with `os.path.join()`.

## Construct a Path to home/earth-analytics

Now you will implement some tricky business. Construct the path to the
**earth-analytics** directory home directory using `et.io.HOME` and `os.path.join`.
You will use `os.path.join` to create the path to the **earth-analytics**
directory which is located within your home directory on your computer. This
path should work on any machine regardless of the operating system given it is
constructed on the fly by Python.

{:.input}
```python
# Automagically create a path to the home/earth-analytics directory on your computer
os.path.join(et.io.HOME, "earth-analytics")
```

{:.output}
{:.execute_result}



    '/root/earth-analytics'





You can check that the path does, in fact exist. If it doesn't, you will get a
return of `False`. This means that you may need to create the directory.

```python
my_ea_path = os.path.join(et.io.HOME, "earth-analytics")
# Does the path exist?
os.path.exists(my_ea_path)
```
Returns:

`False`

The path doesn't exist, but you can create the **earth-analytics** directory
using the **os** module! Note that the code below will FAIL if that directory
already exists. In a later chapter of this textbook, you will learn how to use
conditional statements (if) to write code that accounts for this issue.

```python
my_ea_path = os.path.join(et.io.HOME, "earth-analytics")
os.mkdir(my_ea_path)
```


## Set the Your Project Directory to home/earth-analytics

Now that you have the basics of good project structure out of the way, let's get
your project set up. You have above already created the `earth-analytics` directory
(or folder) where you will store data and files used in the textbook. You will then
set that **project directory** as your **working directory** in `python` using
the syntax.

`os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))`

Breaking the above commands down, you are doing the following.

1. `os.chdir()`: remember from above that this command changes the working directory. However you need to tell python what the path is of the working directory that you want to use
2. `os.path.join()`: this command combines strings or path variables into a full path that will work on any operating system.
3. `et.io.HOME`: this command finds and creates the path for the home directory on your (or any) computer.

Combing the three commands above in a nested structure will
1. create the path for the home/earth-analytics working directory and
2. change the working directory to that path.

If the nested nature of the above command seems confusing, you can break it
down by running each step individually.


{:.input}
```python
# hidden cell - creating the directory
```

{:.input}
```python
# Check the current set working directory
os.getcwd()
```

{:.output}
{:.execute_result}



    '/root/earth-analytics-lessons'





{:.input}
```python
# Find the path to your home directory
et.io.HOME
```

{:.output}
{:.execute_result}



    '/root'





{:.input}
```python
# Create a path to earth-analytics that will work on any computer
os.path.join(et.io.HOME, 'earth-analytics')
```

{:.output}
{:.execute_result}



    '/root/earth-analytics'





{:.input}
```python
# Change the directory to that path - note that this will NOTE WORK if the path doesn't exist
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.input}
```python
# Check the current set working directory
os.getcwd()
```

{:.output}
{:.execute_result}



    '/root/earth-analytics'






Follow the steps below to create an `earth-analytics` project directory on your
computer and then a data directory located within that project directory. The
steps below use `bash` to create your directory. You could also create this manually using
`File Explorer` on a `Mac` or `windows explorer` on `Windows`.

* Navigate to the `home` directory on your computer. This is likely a directory that ends with our username like:

On a MAC: `/Users/yourUserName`
On a PC: `/c/Users/yourUserName


<div class="notice--success">
#### <i class="fa fa-star"></i>  **Data Tip**
Note that you can check to see if the path exists and then create it if it doesn't exist using the conditional if statement below. You will learn more about conditional statements in a future chapter of this textbook.

```python
my_ea_path = os.path.join(et.io.HOME, "earth-analytics")
if not os.path.exists(my_ea_path):
    os.mkdir(my_ea_path)
```
</div>
