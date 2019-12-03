---
layout: single
title: 'Manipulate, Summarize and Plot Numpy Arrays'
excerpt: "This lesson walks you through manipulating, summarizing and plotting numpy arrays."
authors: ['Jenny Palomino', 'Software Carpentry']
category: [courses]
class-lesson: ['numpy-arrays']
permalink: /courses/earth-analytics-bootcamp/numpy-arrays/manipulate-summarize-plot-numpy-arrays/
nav-title: "Manipulate, Summarize and Plot Numpy Arrays"
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
order: 3
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="In This Lesson" icon="file-text" %}

In this lesson, you will write `Python` code in `Jupyter Notebook` to manipulate and summarize `numpy arrays` using the `numpy` package. You will also plot `numpy arrays` using `matplotlib.pyplot`.

<div class='notice--success' markdown="1">


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this hands-on exercise, you will be able to:

* Explain the difference between one-dimensional and two-dimensional `numpy arrays`
* Use indexing to select data from these `numpy arrays`
* Run arithmetic (e.g. addition, multiplication) operations on these `numpy arrays`
* Summarize one-dimensional `numpy arrays` (e.g. averages, maximum values)
* Create plots using one-dimensional `numpy arrays` 
 
 
## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

Be sure that you have completed the previous lesson on <a href="{{ site.url }}/courses/earth-analytics-bootcamp/numpy-arrays/import-text-files-numpy-arrays/">Import Text Data Into Numpy Arrays</a>.

The code below is available in the **ea-bootcamp-day-4** repository that you cloned to `earth-analytics-bootcamp` under your home directory. 

 </div>
 

##  Indexing For Numpy Arrays

In the lessons on lists, you learned that `Python` indexing begins with `[0]`, and that you can use indexing to query the value of items within `Python` lists.

You can also access elements (i.e. values) in `numpy arrays` using indexing. 


### One-dimensional Numpy Arrays

For one-dimensional `numpy arrays`, you only need to specific one index value to access the elements in the `numpy array` (e.g.  `arrayname[index,]`). 

The example below is an one-dimensional array that has 3 elements, or values. 

```python
avg_monthly_precip = numpy.array([0.70, 0.75, 1.85])
```

You can use `avg_monthly_precip[2,]` to get the third element in (`1.85`) from this one-dimensional `numpy array`. 

Recall that you are using use the index `[2]` for the third place because `Python` indexing begins with `[0]`, not with `[1]`.


### Two-dimensional Numpy Arrays

With two-dimensional arrays, you need to specify both a row index and a column index. 

The example below is a two-dimensional array with 2 rows and 3 columns. 

```python
precip_2002_2013 = numpy.array([[1.07, 0.44, 1.5],
                              [0.27, 1.13, 1.72]])
```

You can use `precip_2002_2013[1, 2]` to get the element in the second row, third column (`1.72`) of this two-dimensional `numpy array`. 

Just like you saw for the one-dimensional `numpy array`, you use the index `[1,2]` for the second row and third column because `Python` indexing begins with `[0]`, not with `[1]`

In this lesson, you will use indexing to select elements within one-dimensional and two-dimensional `numpy arrays`, and you will learn how to manipulate, summarize, and plot these `numpy arrays`.

You will use the same datasets from the previous lesson on importing text data:

* a .txt file containing the average monthly precipitation data for Boulder, CO
* a .csv file containing the monthly precipitation for Boulder, CO for the years 2002 and 2013


## Begin Writing Your Code

###  Import Packages

From the previous lesson, you have already learned how to import the necessary packages to set the working directory and download the needed datasets using the `os` and `urllib` packages.

To work with `numpy arrays`, you will also need to import the `numpy` package with the alias `np`, and you will need to import the `matplotlib.pyplot` module with the alias `plt` to plot data. Begin by reviewing these tasks.

{:.input}
```python
# import necessary Python packages
import os
import numpy as np
import urllib.request
import matplotlib.pyplot as plt

# print message after packages imported successfully
print("import of packages successful")
```

{:.output}
    import of packages successful



### Set Working Directory

Remember that you can check the current working directory using `os.getcwd()` and set the current working directory using `os.chdir()`.

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





### Download Data

In the previous lesson, you used the `urllib` package to download data from the Earth Lab `Figshare.com` repository. You will use these same datasets in this lesson.

{:.input}
```python
# use `urllib` download files from Earth Lab figshare repository

# download .txt containing monthly average precipitation for Boulder, CO
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12565616", 
                           filename = "data/avg-monthly-precip.txt")

# download .txt containing month names
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12565619", 
                           filename = "data/months.txt")

# download .csv containing monthly average precipitation for Boulder, CO
urllib.request.urlretrieve(url = "https://ndownloader.figshare.com/files/12707792", 
                           filename = "data/monthly-precip-2002-2013.csv")


# print message that data downloads were successful
print("datasets downloaded successfully")
```

{:.output}
    datasets downloaded successfully



### Import Data Into Numpy Arrays

You also already learned how to import data from text files into `numpy arrays`. Be sure to update the paths for the files to your home directory. 

{:.input}
```python
# import the monthly average values from `avg-monthly-precip.txt` as a numpy array
avg_monthly_precip = np.loadtxt(fname = "/home/jpalomino/earth-analytics-bootcamp/data/avg-monthly-precip.txt")

# import the names of the months from month.txt as a numpy array
months = np.genfromtxt("/home/jpalomino/earth-analytics-bootcamp/data/months.txt", dtype='str')

# import the monthly average values from `monthly-precip-2002-2013.csv` as a numpy array
precip_2002_2013 = np.loadtxt(fname= "/home/jpalomino/earth-analytics-bootcamp/data/monthly-precip-2002-2013.csv", delimiter = ",")

```

## Describe Contents of Numpy Arrays

To begin working with `numpy arrays`, it is helpful to get some more details about the contents of data, such as the number of rows and columns in the data. 

You can use `.shape` after the variable name of the `numpy array` (e.g. `variablename.shape`) to get its dimensions (i.e. number of rows and columns). 

{:.input}
```python
# print the dimensions of months
print(months.shape)
```

{:.output}
    (12,)



Use `.shape` to compare the dimensions of `avg_monthly_precip` versus `precip_2002_2013`. 

{:.input}
```python
# print the dimensions of avg_monthly_precip
print(avg_monthly_precip.shape)

# print the dimensions of precip_2002_2013
print(precip_2002_2013.shape)
```

{:.output}
    (12,)
    (2, 12)



The output for `avg_monthly_precip` indicates that it is composed of 12 elements along one-dimension. In fact, this `numpy arrays` is one-dimensional, meaning that all values exist within a single vector or list. 

The output for `precip_2002_2013` indicates that it is composed of 2 rows and 12 columns. This is two-dimensional `numpy array` that has two observations - one for the year 2002 and another for the year 2013 - and 12 measurements for each observation - one for each month of the year. 


## Use Indexing to Query Numpy Arrays

### One-dimensional Numpy Arrays

By listing the dimensions of `avg_monthly_precip` using `.shape`, you know that it contains 12 elements along one dimension (e.g. `[12,]`). 

As this `numpy array` is one-dimensional, you can leave the second parameter blank when use indexing to access elements in this `numpy array` (e.g. `precip[X,]`). 

For example, because indexing in `Python` begins with `[0]`, you can use the index `[11,]` to query the last element in `avg_monthly_precip`.

{:.input}
```python
# select the last element in `avg_monthly_precip` using the index [11,]
avg_monthly_precip[11,]
```

{:.output}
{:.execute_result}



    0.84





Check what happens when you query for an index location that does not exist in the array, say the index `[12,]`.

{:.input}
```python
# change the value below from 11 to 12 to check what happens when you query for an index location that does not exist
avg_monthly_precip[11,]
```

{:.output}
{:.execute_result}



    0.84





You can also select a series of values from one-dimensional `numpy arrays` such as the third, fourth and fifth values. 

Note that the index structure is inclusive of the first index value, but not the second index value. You are providing a start index value for the selection and an end index value that is not included in the selection.

{:.input}
```python
avg_monthly_precip[2:5]
```

{:.output}
{:.execute_result}



    array([1.85, 2.93, 3.05])





### Two-dimensional Numpy Arrays

Using `.shape`, you also saw that `precip_2002_2013` has row count of 2 with a column count of 12. 

Because `precip_2002_2013` is a two-dimensional `numpy array`, you need to specify both a row index and a column index to select elements in the `numpy array` 

For example, because indexing in `Python` begins with `[0]`, you can use the index `[0,0]` to query the first element in `precip_2002_2013` (i.e. first row, first column).

{:.input}
```python
# select the element in the first row, first column in the array
precip_2002_2013[0,0]
```

{:.output}
{:.execute_result}



    1.07





Or, use the index `[1,11]` to query the last element in `precip_2002_2013` (i.e. last row, last column).

{:.input}
```python
# select the element in the last row, last column
precip_2002_2013[1,11]
```

{:.output}
{:.execute_result}



    0.5





For two-dimensional `numpy arrays`, you can also use a series for the row index and/or column index to select multiple elements using the index structure `[rowindex : rowindex, columnindex : columnindex]`.

Like with the one-dimensional arrays, the index structure is inclusive of the first index, but not the second index. Again, you are providing a start index value for the selection and an end index value that is not included in the selection.

For example, you can use the index `[0:1, 0:3]` to select the first row and the first three columns (again because `Python` indexing begins with `[0]`). 

{:.input}
```python
# select the first row and the first three columns
precip_2002_2013[0:1, 0:3]
```

{:.output}
{:.execute_result}



    array([[1.07, 0.44, 1.5 ]])





If you wanted to include the second row and fourth column, you would need to use the index `[0:2, 0:4]`.

{:.input}
```python
# select the first two rows and the first four columns
precip_2002_2013[0:2, 0:4]
```

{:.output}
{:.execute_result}



    array([[1.07, 0.44, 1.5 , 0.2 ],
           [0.27, 1.13, 1.72, 4.14]])





You can also store selected data as a new `numpy array`. 

For example, you can create a new `numpy array` for the precipitation data in 2002 by selecting the first row of values from `precip_2002_2013`.

{:.input}
```python
# select the first row and all twelve columns of monthly values
precip_2002 = precip_2002_2013[0:1, 0:12]

# print data in `precip_2002`
precip_2002
```

{:.output}
{:.execute_result}



    array([[1.07, 0.44, 1.5 , 0.2 , 3.2 , 1.18, 0.09, 1.44, 1.52, 2.44, 0.78,
            0.02]])





You can check the `.shape` of the new array to see that it has remained a two-dimensional array, but it only has one row of data, not two like `precip_2002_2013`.

{:.input}
```python
# print dimensions of `precip_2002`
precip_2002.shape
```

{:.output}
{:.execute_result}



    (1, 12)





## Run Calculations on Numpy Arrays

`Numpy arrays` calculations highlight the major differences between `Python` lists and `numpy arrays`.

Recall that in lessons on variables and lists, you created separate variables for each monthly average precipitation value to convert it to millimeters (e.g. `jan = 0.70 * 25.4`), and then you created a new list containing all of these converted monthly values. 

`Numpy arrays` make it easy to run calculations on data as needed, while `Python` lists do not support these kinds of calculations. 

`Numpy arrays` support mathematical operations on an element-by-element basis, meaning that you can actually run one operation (e.g. `* 25.4`) on the entire array with a single line of code. 

Review this primary difference betweens lists and `numpy arrays` below. 

{:.input}
```python
# Uncomment the code below to run it. Note: this code will result in an error, as you cannot run this operation on a list
#preciplist = [0.70, 0.75, 1.85, 2.93, 3.05, 2.02, 1.93, 1.62, 1.84, 1.31, 1.39, 0.84]
#preciplist = preciplist * 25.4
```

{:.input}
```python
# print the values in the array `avg_monthly_precip`
print(avg_monthly_precip)

# multiply each element in the array `avg_monthly_precip` by 25.4
# assign the results to a new array also called `avg_monthly_precip`
avg_monthly_precip = avg_monthly_precip * 25.4

# print the values in the new array `avg_monthly_precip`
print(avg_monthly_precip)
```

{:.output}
    [0.7  0.75 1.85 2.93 3.05 2.02 1.93 1.62 1.84 1.31 1.39 0.84]
    [17.78  19.05  46.99  74.422 77.47  51.308 49.022 41.148 46.736 33.274
     35.306 21.336]



See how easy these calculations can be with `numpy arrays`! These arithmetic calculations will work on any `numpy array`, including multi-dimensional `numpy arrays`. 

Recall the previous lessons on variables and lists. Instead of creating separate variables for each month to run these calculations, you can now create a single `numpy array` imported from `avg-monthly-precip.txt` and run a single multiplication operation on the entire `numpy array` to the convert the values from inches to millimeters. 


## Summarize Data in Numpy Arrays

Another great feature of `numpy arrays` is the ability to run summary statistics (e.g. calculating averages, finding min or max values) across the entire array of values. `Lists` do not support this functionality either.

For example, you can use the `mean()` function in `numpy` to calculate the average value across an array (e.g. `np.mean(arrayname)`). You can also store results as a new variable.

{:.input}
```python
# calculate the mean and store the result as a new variable
mean_avg_precip = np.mean(avg_monthly_precip)

# you can expand the print statement to include a text string to label the data output
print("mean of average monthly precipitation:", mean_avg_precip)
```

{:.output}
    mean of average monthly precipitation: 42.820166666666665



Similarly, we can use `min()` and `max()` to find the minimum and maximum values in an array.  

{:.input}
```python
# find the min value and store the result as a new variable
min_avg_precip = np.min(avg_monthly_precip)

# find the max value and store the result as a new variable
max_avg_precip = np.max(avg_monthly_precip)

# print these values along with a message that labels each result
print("minimum of average monthly precipitation:", min_avg_precip)
print("maximum of average monthly precipitation:", max_avg_precip)
```

{:.output}
    minimum of average monthly precipitation: 17.779999999999998
    maximum of average monthly precipitation: 77.46999999999998



Notice that in this code, you can only identify the value that is the minimum or maximum but not the month in which the value occurred. This is because `precip` and `months` are not connected in an easy way that would allow you to determine the month that matches the values. 

You could use indexing to determine the index location of the maximum value in `precip` and then query that same index location in `months`, but rest assured, there is an easier way to do this! 

In future lessons on `pandas dataframes`, you will learn how to work with data in a tabular structure, so that precip values are linked with their corresponding month names.


## Plot Numpy Arrays

Since you have now completed an easy calculation to convert the precipitation values using `numpy array` calculations, you can use this `numpy array` to plot the precipitation data, rather than relying on `Python` lists.

In order to use multiple `numpy arrays` within the same plot, you need to make sure that the dimensions of the arrays are compatible. 

You have already done this by checking the `.shape` of `avg_monthly_precip` and `months`, which indicates that both have 12 elements along one dimension (`(12,)`). 

You can re-use your `matplotlib` code from the lesson on plotting with matplotlib to create the same plot of average monthly precipitation in Boulder, CO using `numpy arrays`. Recall that you can set the `color` in the plot (e.g. `grey`).

{:.input}
```python
# set plot size for all plots that follow
plt.rcParams["figure.figsize"] = (8, 8)

# create the plot space upon which to plot the data
fig, ax = plt.subplots()

# add the x-axis and the y-axis to the plot
ax.bar(months, avg_monthly_precip, color="grey")

# set plot title
ax.set(title="Average Monthly Precipitation in Boulder, CO")

# add labels to the axes
ax.set(xlabel="Month", ylabel="Precipitation (mm)");
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}//images/courses/earth-analytics-bootcamp/04-numpy-arrays/exercises/2018-08-01-numpy-arrays-03-manipulate-summarize-plot-numpy-arrays_39_0.png" alt = "This plot displays a bar plot created from numpy arrays for average monthly precipitation for Boulder, CO.">
<figcaption>This plot displays a bar plot created from numpy arrays for average monthly precipitation for Boulder, CO.</figcaption>

</figure>




Note that `precip_2002` is still two dimensional array, so you cannot use it to plot data against `months`, which is a one-dimensional array.

In future lessons, you will learn how to convert two-dimensional `numpy arrays` to one-dimensional `numpy arrays`. 

Congratulations! You have learned how to use indexing to select data from one-dimensional and two-dimensional `numpy arrays`, and how to run calculations and summary statistics on these `numpy arrays`. You also learned how to plot data from one-dimensional `numpy arrays`. 

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Optional Challenge 

Test your `Python` skills to:

1. Convert the data values in `precip_2002_2013` from inches to millimeters (one inch = 25.4 millimeters). 

2. Create a new `numpy array` for 2013 by selecting all data values in the last row in `precip_2002_2013` (i.e. data for the year 2013).

3. Calculate the minimum, mean, and maximum values for 2013. 

4. Print these values along with a message that labels each result (e.g. `mean precipitation in 2013:`). 

</div>


{:.output}
{:.execute_result}



    array([[  6.858,  28.702,  43.688, 105.156,  67.564,  15.494,  26.162,
             35.56 , 461.264,  56.896,   7.366,  12.7  ]])






{:.output}
    minimum precipitation in 2013: 6.858
    mean precipitation in 2013: 72.28416666666665
    maximum precipitation in 2013: 461.26399999999995


