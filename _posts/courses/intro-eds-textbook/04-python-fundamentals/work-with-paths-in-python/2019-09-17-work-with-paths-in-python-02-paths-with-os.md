---
layout: single
title: 'Write Code That Will Work On Any Computer: Introduction to Using the OS Python Package to Set Up Working Directories and Construct File Paths'
excerpt: "Manually constructed files paths will often not run on computers with different operating systems. Learn how to construct file paths in Python that will work on Mac, Linux and Windows, in support of open reproducible science."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['work-with-files-directories-in-python']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/set-working-directory-os-package/
nav-title: "Set Working Directory"
dateCreated: 2019-09-18
modified: 2020-09-23
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
redirect_from:
  - "/courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-in-python/set-working-directory-os-package/"  
  - "/courses/earth-analytics-python/python-open-science-toolbox/setup-earth-analytics-working-directory/"  
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Use the earthpy attribute `et.io.HOME` to find the home directory on any computer.
* Use `os.path.join()` to create paths that will work on Windows, Mac and Linux.
* Use `os.path.exists()` to ensure a file path exists.
* Set your working directory in **Python** using `os.chdir()`.

</div>

You will need the **os** and the **earthpy** packages to run the code on this page.

On this page, your goal is to create and set the **earth-analytics** directory
as your working directory, using code that will work on any computer.

This **earth-analytics** directory should exist in your home directory. The path will look
something like this: `/home/user-name/earth-analytics` following the example on the previous page of this chapter.

To create and construct this working directory, you will use several functions
located in the **os** **Python** package. You will also use **earthpy** package.

{:.input}
```python
# Import necessary packages
import os

import earthpy as et
```

## Paths in Python

It is important to consider paths and working directories when setting up
projects in python. The ideal scenario is that your code can run on any machine.

Ensuring that your code can run on multiple machines makes it easier to:

1. set things up in the rare case that your machine dies.
2. move your workflow to a cloud environment or high performance computing infrastructure.
2. share your project and collaborate with others.

There are a few things to consider when creating paths that can make reproducibility
challenging.

Paths are constructed differently on different operating systems. For example, the
path to **earth-analytics/data** in the home directory that you examined in the previous lesson looks like this in **Python**:

* **/home/username/earth-analytics/data** on Mac and Linux and
* **C:\\\Users\\\username\\\earth-analytics\\\data** on Windows

The noticeable differences are the identification of the home directory (e.g. `/home/username` or `C:\\Users\\username`) and the direction and number of slashes. 

This path `/home/username/earth-analytics/data` will NOT work on Windows. 

And this path `C:\\Users\\username\\earth-analytics\\data` will not work on Mac or Linux. 

Lucky for you, there are a suite of functions that you can use to construct paths that will ensure that your code works across platforms. On this page, you will learn how these functions help you to handle differences in the identification of the home directory and the differences in slashes between operating systems. 

Using these functions will make it easier for you to collaborate and share your code with others (and even yourself!) regardless of the operating system that is used to run the code.  


## Build Directory Paths that Work Across Operating Systems Using os.path.join

The **path** module within the **os** package contains a `join()` function that
will create a path from a list of strings. When this function is run, it will
adapt to the operating system that is calling **Python**.

`os.path.join` takes as many strings as you provide it. It reads each string as a
directory name (or file name) and then creates an output path by concatenating the input strings.

`os.path.join("dir1", "dir2", "dir3", "file-name")`

The example below creates a relative path to the `data` subdirectory within the `earth-analytics` directory.

{:.input}
```python
# Direction and number of slashes are handled by the function
os.path.join("earth-analytics", "data")
```

{:.output}
{:.execute_result}



    'earth-analytics/data'





The `join()` function from the **os.path** module creates a path in the format required by the operating system upon which the code is being run (i.e. whatever operating system your
computer is running). 

Constructing a path using the `join()` function
will save you time when you (or others!) move your code to another computer, as you will not
have to manually create or fix paths.

<i class="fa fa-exclamation-circle"></i> **IMPORTANT** You can create paths that do not exist on
your computer using this approach. So be careful about ensuring that you have
created the necessary directories, spelled them correctly, and that they are in the correct order in the path (i.e. correct parent directories). `os.path.join` 
does does not actually test to ensure that the path exists!
{: .notice--success}

Because you can potentially create a path that doesn't exist on your computer,
you can check that a path exists using the `os.path.exists()` function. It
returns a **boolean** value of True or False, depending on whether the path does in fact exist
on your computer.

{:.input}
```python
# Check that a directory exists on your computer
my_path = os.path.join("earth-analytics", "data")

# Boolean output (True or False)
os.path.exists(my_path)
```

{:.output}
{:.execute_result}



    False





In the example above, you have created a path. However, that path may or may not already exist on your computer. 

If **Python** cannot find the directory, there are several issues to consider:  

1. Your working directory may not be set properly, so that it can find the relative path.
2. You have a misspelling in you path. Or, the case (e.g. upper, lower) is incorrect.
3. The directory has not been created on your computer.

Note that relative paths will only return True if a working directory has been set correctly. This is because relative paths are (as named) relative to some directory. Thus, you want to set the working directory to be the starting point for relative paths that you want to build in your code.  

In the example above, the relative path returns a False because the working directory has not yet been set. 

### Check and Set Your Working Directory Using OS

You can use the **os** package to check and set your working directory. This is another good check to implement when you get "a file not found error" in your code.

There are two functions in the **os** package that help you accomplish these tasks:

* `getcwd()`: CWD stands for Current Working Directory. This function allows you to see what your current working directory is.
* `chdir("path-to-dir")`: Short for *CH*ange *DIR*ectory, this function allows you to set the current working directory to a path of your choice.  


## Check Your Current Working Directory

Check your current working directory using `os.getcwd()`. What does the output look like?

In the example below, you can see some example output from the computer that is being used to write this lesson that you are reading (which is in a **Jupyter Notebook** file!). 

Do you notice any characteristics of this path that might make it difficult to run on another computer?

`os.getcwd()`

Output
`/home/username/Documents/github/earth-analytics-lessons`

1. The path above has a specific username in it.
2. It also has subdirectories including **Documents** and **github** that may or may not be on another computer.
3. Finally there are slashes that create that path. Notice that these slashes could work on a Mac but they might not work on Windows.

This working directory could be problematic for both your future self and others, as it
may not run on other machines.


## Use earthpy HOME Attribute to Locate Your Home Directory

You could set the working directory using `os.chdir()` to your home directory. 

This could solve some of your problems, if the `earth-analytics` directory that you want to use exists within your
home directory (remember that all computers have a home directory). 

So what about just using `os.chdir("~/")`?

The above syntax mimics what you might use in **Bash** to navigate to your home
directory; however, this syntax unfortunately does not work in **Python**.

Instead, you can use **io** module of the **earthpy** package, which contains a **HOME** attribute that will locate your home directory. 

{:.input}
```python
# Find your home directory
et.io.HOME
```

{:.output}
{:.execute_result}



    '/root'





When you call `et.io.HOME`, it provides you with a path that is the home
directory path on your computer. 

This path will account for whatever operating system it is run on, so it will work on any computer. 

You can check to ensure that the directory returned by `et.io.HOME` exists using `os.path.exists()`.

In the example below, the **HOME** attribute is provided as an input to the function `os.path.exists`. It
returns a **boolean** value of True which means that the path does in fact exist on your computer.

{:.input}
```python
# Check if the home directory exists (of course it does!)
os.path.exists(et.io.HOME)
```

{:.output}
{:.execute_result}



    True





For the rest of this textbook, you will use the **HOME** attribute of **earthpy** to set the working directory to your home directory. 

Then, you will be able to access files and subdirectories within the **earth-analytics** directory,
which should be located in your home directory on your computer.


## Construct a Path to the earth-analytics Directory in Your Home Directory

Now you will implement some useful tricks to construct the path to the
**earth-analytics** directory within your home directory using `et.io.HOME` and `os.path.join`.

This path should work on any machine regardless of the operating system, given it is
constructed on-the-fly by **Python**.

{:.input}
```python
# Create a path to the home/earth-analytics directory on your computer
os.path.join(et.io.HOME, "earth-analytics")
```

{:.output}
{:.execute_result}



    '/root/earth-analytics'





You can check that the path does in fact exist. If the path does not exist, you will get a return of `False`. 

For example, if you did not already have an `earth-analytics` directory in your home directory, then the output would be `False`, as shown below. 

```python
my_ea_path = os.path.join(et.io.HOME, "earth-analytics")

# Does the path exist?
os.path.exists(my_ea_path)
```
Returns:

`False`

In this example, an `earth-analytics` directory does not exist in your home directory, but you can create the this directory using the **os** module! 

## Create a Directory Using the os Package in Python

You can use the `os.mkdir("path/to/dir/here")` function to create a directory in
**Python**. This function is helpful if you need to create a new directory that
doesn't already exist. 

However, as you have learned above, this function will
only work across operating systems, if you construct
the path with `os.path.join()`.

```python
my_ea_path = os.path.join(et.io.HOME, "earth-analytics")
os.mkdir(my_ea_path)
```
Note that the code above to create a directory will *fail* if that directory
already exists. 

In a later chapter of this textbook, you will learn how to use 
conditional statements (referred to as `if` statements) to write code that accounts for this issue, so that your code does not attempt to make directories that already exist. 

## Set Your Working Directory to home/earth-analytics

Now that you have the basics of good project structure out of the way, you can get your project directory set up. 

By now, you have already created the `earth-analytics` directory (in your home directory) where you will store data and files used in the textbook. 

You will now set that **project directory** as your **working directory** in **Python** using
the following syntax, which provides the output of `os.path.join` as input into the the `os.chdir` function: 

`os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))`

Breaking the above commands down, you are doing the following.

1. `os.chdir()`: remember from above that this function changes the working directory. However, you need to tell **Python** the path of the working directory that you want to use.
2. `os.path.join()`: this function combines strings or path variables into a full path that will work on any operating system.
3. `et.io.HOME`: this attribute provides the path for the home directory on your (or any) computer.

Combing the three commands above in a nested structure will:
1. create the path for the `home/earth-analytics` directory and
2. change the working directory to that path.

If the nested nature of the above command seems confusing, you can break it
down by running each step individually.


{:.input}
```python
# Check the current working directory
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
# Change the directory to that path
os.chdir(os.path.join(et.io.HOME, 'earth-analytics'))
```

{:.input}
```python
# Check the current working directory again
os.getcwd()
```

{:.output}
{:.execute_result}



    '/root/earth-analytics'





Recall that if the directory does not already exist (e.g. `earth-analytics` in your home directory), then `os.chdir()` will fail when you try to change to that directory. 

If needed, you can review the section above on creating a directory using `os.mkdir()` to create an `earth-analytics` directory in your home directory. 
