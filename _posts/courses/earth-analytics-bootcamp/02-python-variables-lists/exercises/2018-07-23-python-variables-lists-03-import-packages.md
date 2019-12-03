---
layout: single
title: 'Import Python Packages'
excerpt: "Python packages are organized directories of code that provide functionality such as plotting data. Learn how to write Python Code to import packages."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey',  'Software Carpentry']
category: [courses]
class-lesson: ['python-variables-lists']
permalink: /courses/earth-analytics-bootcamp/python-variables-lists/import-python-packages/
nav-title: "Import Python Packages"
dateCreated: 2018-06-27
modified: 2018-08-08
module-type: 'class'
course: "earth-analytics-bootcamp"
week: 2
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will learn how to write `Python` code to import packages, which provide functionality to work with data.  

<div class='notice--success' markdown="1">

# <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this hands-on activity, you will be able to:

* Explain how `Python` uses packages to provide functionality
* Write `Python` code to import useful `Python` packages (such as `os` to access directories on your computer)
* Write `Python` code to print your current working directory

 
# <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have followed the instructions on <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-anaconda/">Setting up Git, Bash, and Anaconda on your computer</a> to install the tools for your operating system (Windows, Mac, Linux). 

Be sure that you have completed the previous lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/get-started-with-open-science/jupyter-notebook-interface/">The Jupyter Notebook Interface</a>.

The code below is available in the **ea-bootcamp-day-2** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 
 
 </div>


## Python Packages and Modules

You can think of a package in Python as a tool box of organized code (i.e. functions) that can be used to perform different operations - like produce a plot. In `Python`, packages are organized directories of code that can be imported and used in your work.

Throughout this Bootcamp course, you will use the following packages:
1. `os` - to access files and directories on the computer
2. `numpy` - to store and access data in arrays (i.e. ordered series)
3. `pandas` - to store and access data as dataframes (i.e. tabular data with rows and columns)
4. `matplotlib` - to plot data

Packages can contain many modules (i.e. units of code) that each provide different functions and can build on each other. For example, the `matplotlib` package provides functionality to plot data using modules, one of which is the commonly used module called `pyplot`. 

Every `Python` package should have a unique name. This allows you to import the package using the name with the `import` command. For example, the command below imports the `matplotlib` package. 

```python
import matplotlib
```

Modules in different packages may have the same name. Thus, you call a specific module by first calling the package name and then the module name - using `.` to separate the names like this:

```python
import matplotlib.pyplot

```

## Aliases

When you import packages and modules, you can assign an alias to that package or module which you can use to call  it in your code without having to type out the full name. Thus, aliases can be helpful to shorten the names of packages or modules and can help to distinguish modules that have the same name. 

You can expand your `import` statement to assign an alias to a package or module by adding the command `as` followed by the alias name (e.g. `import matplotlib.pyplot as plt`). 

Now every time you want to use `matplotlib.pyplot`, you can type `plt` instead. You will explore the use of aliases in this lesson. 


## Import Python Packages

Moving forward in this course, you will now always begin your `Python` code by importing the necessary packages, so that you can begin with all the functionality you need for your workflow. 

Begin by importing the `os` package which provides functionality to access files and directories on the computer.

{:.input}
```python
# import necessary Python packages
import os
```

### Use Print() to Display Messages

Notice that you do not receive any output, unless the `import` is not successful.

Remember that you can you can use `print()` to display a message that the package was successfully imported using the following syntax: `print("Some Message Here")`.

{:.input}
```python
# import necessary Python packages
import os

# print a message after the package has been successfully imported
print("import of package successful")
```

{:.output}
    import of package successful



## Import Python Packages Using Aliases

Under **Aliases**, you learned that you can import packages and modules using aliases that you assign with your code.

The `os` package has a short name and is not commonly given an alias, but other packages are often given specific aliases that are used by most `Python` users.

You saw earlier that `matplotlib.pyplot` can be given the alias of `plt`, which is common among `Python` users. Similarly, `numpy` is often given the alias of `np`, while `pandas` is often given the alias of `pd`. 

Expand your code to import the `numpy` package with its commonly used alias of `np`.

{:.input}
```python
# import necessary Python packages
import os
import numpy as np

# print a message after the packages have been successfully imported
print("import of packages successful")
```

{:.output}
    import of packages successful



Then, add code to import the `matplotlib.pyplot` module with its commonly used alias of `plt`.

{:.input}
```python
# import necessary Python packages
import os
import numpy as np

import matplotlib.pyplot as plt

# print a message after the packages have been successfully imported
print("import of packages successful")
```

{:.output}
    import of packages successful



## Print the Current Working Directory

Recall from the previous lessons that knowing the current working directory is important for accessing files and directories on your computer. 

Just like in `Bash`, you can check your current working directory in `Python` using a function provided by the `os` package (e.g.`os.getcwd()`). 

This code calls the function `getcwd()` from the `os` package, and the output will show your current working directory. 

{:.input}
```python
os.getcwd()
```

{:.output}
{:.execute_result}



    '/home/jpalomino/Documents/Earth_Lab/earth-analytics-python/notebooks/final-notebooks/courses/earth-analytics-bootcamp/02-python-variables-lists/exercises'





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Add a `Python` comment to describe what `os.getcwd()` is doing. Suggestion: `print the current working directory`.

2. Expand your code to import the `pandas` package as `pd`. 

3. Print message to tell you that `pandas` has been successfully imported. 

</div>


{:.output}
    import of pandas package successful


