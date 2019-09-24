---
layout: single
title: 'Python Packages for Earth Data Science'
excerpt: "The Python programming language provides many packages and libraries for working with scientific data. Learn about key Python packages for earth data science."
authors: ['Leah Wasser', 'Jenny Palomino']
category: [courses]
class-lesson: ['python-packages-for-eds']
permalink: /courses/intro-to-earth-data-science/python-code-fundamentals/use-python-packages/
nav-title: "Python Packages"
dateCreated: 2019-09-17
modified: 2019-09-24
module-title: 'Import and Install Python Packages for Earth Data Science'
module-nav-title: 'Use Python Packages'
module-description: 'The Python programming language provides many packages and libraries for working with scientific data. Learn how to import and install Python packages for earth data science.'
module-type: 'class'
class-order: 2
chapter: 11
course: "intro-to-earth-data-science-textbook"
week: 4
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Chapter" icon="file-text" %}


<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Eleven - Import and Install Python Packages for Earth Data Science

In this chapter, you will learn more about using the **Python** programming language to work with scientific data.  

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Explain what a package is in `Python`.
* Import a package into `Python`.
* List 3-5 important `Python` packages for science.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have Git, Bash and Conda setup on your computer and the Earth Analytics Python Conda environment. Follow the <a href="{{ site.url }}/workshops/setup-earth-analytics-python/">Setup Git, Bash, and Conda on your computer</a> to install these tools.

Be sure that you have completed the chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>.

</div>


## What is a Python Package

In `Python`, a package is a bundle of pre-built functionality that adds to the functionality available in base `Python`. Base Python can do many things. It can perform math and other operations. However packages extend this functionality. You can think of a package as a toolbox filled with tools. The tools in the toolbox can be used to do things that you would have to otherwise hand code in base `Python`. These tasks are things that many people might want to do in Python thus warranting the creation of a package. After all, it doesn't make sense for everyone to hand code everything!

For example, the `matplotlib` package allows you to create plots of data. Most of us create plots routinely. Having a package to create plots makes programming more efficient for everyone who needs to create plots.

## Open Source Python Packages for Earth Data Science

There are many different packages available for `Python`. Some of these are optimized for scientific tasks such as:

* Statistics
* Machine learning
* Using geospatial data
* Plotting & visualizing data
* Access data programmatically

and more! The list below contains the core packages that you will use in the upcoming chapters of this textbook to work with scientific data.

* `os`: handle files and directories
* `glob`: create lists of files and directories for batch processing
* `matplotlib`: plot data
* `numpy`: work with data in array formats (often related to imagery and raster format data)
* `pandas`: work with tabular data in a data.frame format.
* `rasterio`: work with raster (image and arrays) data
* `geopandas`: Work with vector format (shapefiles, geojson - points, lines and polygons) using a geodataframe format.
* `earthpy`: plot and manipulate spatial data.


## Where Do Packages Live On Your Computer?

When you install a package, you may be wondering, where does it go? Packages are organized directories of code that can be imported and used in your work. If you haven't changed any of your default installation settings, the packages that you will use for this textbook are located in your miniconda directory under `envs`. When you install a package with the environment of your choice, for example `earth-analytics-python` which is the environment that you installed for this textbook and the associated earth-analytics courses, it ends up in the `miniconda/envs/earth-analytcs-python` folder.

<figure>
    <a href="{{ site.url }}/images/earth-analytics/python/conda-environment-python-packages.png">
    <img src="{{ site.url }}/images/earth-analytics/python/conda-environment-python-packages.png" alt="When you install Python packages in an conda environment, they will be located within the environment directory."></a>
    <figcaption>When you install Python packages in an conda environment, they will be located within the miniconda/envs/environment-name directory.
    </figcaption>
</figure>


### Python Packages Can Contain Modules
Packages can contain many modules (i.e. units of code) that each provide different functions and can build on each other. For example, the `matplotlib` package provides functionality to plot data using modules, one of which is the commonly used module called `pyplot`.

Every `Python` package should have a unique name. This allows you to import the package using the name with the `import` command. For example, the command below imports the `matplotlib` package.

```python
import matplotlib
```

### What is a Module in a Python Package?

Packages often have modules. A module is a set of related functionality that lives within the package. For example, `pyplot` is a module within the matplotlib package that makes it easier to quickly setup plots. You can import a specific module like `pyplot` by first calling the package name and then the module name - using `.` to separate the names like this:

```python
import matplotlib.pyplot

```

You can also import the module using an alias or short name.

```python
import matplotlib.pyplot as plt

```

When using earthpy, you can import the earthpy plotting module like this:

```python
import earthpy.plot as ep
```



## What is a Python Package Alias?

An alias as it refers to a Python package is a short version of the package name. The syntax to create an library alias is:

``` import package_name_here as alias_here```


So for example, you could call pyplot functions to plot something like this:

```python
matplotlib.pyplot.title("Title Here")

```

The code above is long or more verbose than it needs to be. It's nicer to have shortcuts setup for packages and modules that reduce the amount of text that you have to write to call a function within a module. To create an alias for pyplot, you'd use:

```python
import matplotlib.pyplot as plt

plt.title("Title Here")

```
Notice that in the above example, you imported the pyplot module from the matplotlib package using the alias `plt`. Now, every time you call that package, you can use `plt` rather than `matplotlib.pyplot.title("Title Here")`. Aliases shorten the names of packages making your code more concise. For example: `plt.title("Title Here")`.


<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/import-package.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/import-package.png" alt= "Jupyter Notebook with code cell to import the Python packages called numpy and pandas using the alias np and pd."></a>
 <figcaption> Jupyter Notebook with code cell to import the Python packages called numpy and pandas using the alias np and pd.
 </figcaption>
</figure>


## Commonly Used Aliases for Python Packages

There are many packages and modules that have standard alias names. A few commo aliases are listed below:

| package.module | alias  |
|---|---|
| matplotlib.pyplot  | plt  |
| matplotlib  | mpl  |
| numpy  | np  |
| pandas  | pd|


<i class=\"fa fa-star\"></i> **Data Tip:** The `os` package has a short name and is not given an alias
{: .notice--success}

## Best Practices for Importing Python Packages In Scientific Code

There are a set of best practices that you should follow when importing Python packages in your code. These best practices are outlines in the <a href="https://www.python.org/dev/peps/pep-0008/#imports" target="_blank">PEP 8 guidelines </a> and apply to both Python scripts and to working in Jupyter Notebooks.

### 1. Import Python Libraries at the Top of Your Script or Notebook

It is good practice to import all of the packages that you will need in the first code cell of a `Jupyter Notebook` file or a script. This allows anyone looking at your code to immediately know what packages they need to have installed in order to successfully run the code. This rule also follows the PEP 8 conventions for Python code.

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/import_packages-first-cell.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/import_packages-first-cell.png" alt= "Jupyter Notebook with the first code cell importing the numpy package (and many others) to be used with abbreviations or aliases (e.g. np)."></a>
 <figcaption> Jupyter Notebook with the first code cell importing the numpy package (and many others) to be used with abbreviations or aliases (e.g. np).
 </figcaption>
</figure>

Once you have imported all of the packages that you need in your code (and run the code), you have access to all of the functions contained within each package. If you import a package after running some code that requires that package, your code will not run.

<i class=\"fa fa-star\"></i> **Data Tip:** You can use tab complete to get a list of all available functions in a package. For example, using the alias `np` for `numpy`, you can get a list of the functions available using `np.()` and hitting the tab key. A list of callable functions will appear.
{: .notice--success}

<figure>
 <a href="{{ site.url }}/images/courses/earth-analytics/python-interface/tab-complete.png">
 <img src="{{ site.url }}/images/courses/earth-analytics/python-interface/tab-complete.png" alt= "Jupyter Notebook with a code cell to get a list of the functions available in numpy, which was imported as np."></a>
 <figcaption> Jupyter Notebook with a code cell to get a list of the functions available in numpy, which was imported as np.
 </figcaption>
</figure>


Once you have installed the packages that you require, you can call them in `Python` at the command line, in a script or in a `Jupyter Notebook` file. You have to explicitly call and load each package that you need in your notebook or script in order for the functions (or tools) in the package to be available in your code.

<i class=\"fa fa-star\"></i> **Data Tip:**  You can import `Python` packages using `import package-name`. Once a package has been imported, you can call functions from that package
{: .notice--success}


### 2. List Packages In the Correct Order Following PEP 8 Standards: Most Common First, Followed By Third Party

PEP 8 also specifies the order in which you should list your imports as follows:

> Imports should be grouped in the following order:
>    Standard library imports.
>    Related third party imports.
>    Local application/library specific imports.
> You should put a blank line between each group of imports.

You may be wondering, what is a standard library import? The standard imports are commonly used tools that are general in purpose. These including things like

* os
* numpy
* matplotlib

Third party imports might include geospatial tools and others that are less commonly used.
These might include:

* geopandas
* rasterio
* hydrofunctions
* tweepy



