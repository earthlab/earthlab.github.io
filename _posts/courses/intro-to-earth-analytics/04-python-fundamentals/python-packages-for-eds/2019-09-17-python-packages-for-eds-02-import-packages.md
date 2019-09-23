---
layout: single
title: 'Import Packages in Python'
excerpt: "Packages in Python provide . Learn how to import packages in Python."
authors: ['Jenny Palomino', 'Leah Wasser', 'Martha Morrissey']
category: [courses]
class-lesson: ['python-packages-for-eds']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/python-packages/import-packages/
nav-title: "Import Packages"
dateCreated: 2019-07-01
modified: 2019-09-23
module-type: 'class'
course: "intro-to-earth-data-science"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/python-variables-lists/import-python-packages/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

*  

</div>
 



## Import a Package in Python 

### Import Libraries at the Top of Your Script

It is good practice to import all of the packages that you will need in the first code cell of a `Jupyter Notebook` file. This allows anyone looking at your code to immediately know what packages they need to run the code.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/import_packages-first-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/import_packages-first-cell.png" alt= "Jupyter Notebook with the first code cell importing the numpy package (and many others) to be used with abbreviations or aliases (e.g. np)."></a>
 <figcaption> Jupyter Notebook with the first code cell importing the numpy package (and many others) to be used with abbreviations or aliases (e.g. np).
 </figcaption>
</figure>

Once you have imported all of the packages that you need in your code, you have access to all of the functions contained within each package and you can query for a list of available functions. 

For example, using the alias `np` for `numpy`, you can get a list of the functions available using `np.()` and hitting the tab key. A list of callable functions will appear. 

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/tab-complete.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/tab-complete.png" alt= "Jupyter Notebook with a code cell to get a list of the functions available in numpy, which was imported as np."></a>
 <figcaption> Jupyter Notebook with a code cell to get a list of the functions available in numpy, which was imported as np.
 </figcaption>
</figure>




Once you have installed the packages that you require, you can call them in `Python` at the command line, in a script or in a `Jupyter Notebook` file. You have to explicitly call and load each package that you need in your notebook or script in order for the functions (or tools) in the package to be available in your code. 
 
You can import `Python` packages using `import package-name`. Once a package has been imported, you can call functions from that package as follows:

```
import numpy
numpy.sin(0)
0
```




## Import Packages Using Aliases


When you import packages and modules, you can assign an alias to that package or module which you can use to call it in your code without having to type out the full name. Thus, aliases can be helpful to shorten the names of packages or modules and can help to distinguish modules that have the same name.

You can expand your import statement to assign an alias to a package or module by adding the command as followed by the alias name (e.g. import matplotlib.pyplot as plt).

Now every time you want to use matplotlib.pyplot, you can type plt instead. You will explore the use of aliases in this lesson.



In the example above, the sin function was called using the full `Python` name: `numpy.sin`. Doing this over and over will make your code more verbose. Thus, you will often see abbreviations or aliases used to call functions within a specific package. The syntax to create an library abbreviation is:

``` import _____ (name of package) as ____```

Using the example above, you can create an abbreviation for the `numpy` package. It is common to use `np` for numpy:

```
import numpy as np
numpy.sin(0)
0
```

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/import-package.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/import-package.png" alt= "Jupyter Notebook with code cell to import the Python packages called numpy and pandas using the alias np and pd."></a>
 <figcaption> Jupyter Notebook with code cell to import the Python packages called numpy and pandas using the alias np and pd. 
 </figcaption>
</figure>



## Commonly Used Aliases for Python Packages

Under Aliases, you learned that you can import packages and modules using aliases that you assign with your code.

The os package has a short name and is not commonly given an alias, but other packages are often given specific aliases that are used by most Python users.

You saw earlier that matplotlib.pyplot can be given the alias of plt, which is common among Python users. Similarly, numpy is often given the alias of np, while pandas is often given the alias of pd.

Expand your code to import the numpy package with its commonly used alias of np.
