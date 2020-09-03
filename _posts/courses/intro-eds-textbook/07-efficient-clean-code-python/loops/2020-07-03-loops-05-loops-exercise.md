---
layout: single
title: 'Loops in Python Exercise'
excerpt: "Loops can be used to automate data tasks in Python by iteratively executing the same code on multiple data structures. Practice using loops to automate certain functionality in Python."
authors: ['Nathan Korinek', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-loops-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/loops/loops-exercise/
nav-title: "Loops Exercise"
dateCreated: 2020-07-08
modified: 2020-09-03
module-type: 'class'
chapter: 18
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 5
topics:
  reproducible-science-and-programming: ['python']
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

This page of exercises will test the skills that you learned in the previous lessons 
in this chapter. You will practice using loops to help with common coding tasks, using 
for and while loops, and looping over different types of data. 

</div>

<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 1: Print Numbers in a list 

The list below contains temperature values for a location in Boulder, Colorado.
Create a for loop that loops through each value in the list and prints the 
value like this: `

`temp: 47`

HINT: you can print a string and a variable together using the syntax:

`print("temp:", variable_name_here)`

</div>

{:.input}
```python
# Data to convert to celsius

boulder_avg_high_temp_f = [
    47,
    49,
    57,
    64,
    72,
    83,
    89,
    87,
    79,
    67,
    55,
    47
]

boulder_avg_high_temp_f
```

{:.output}
{:.execute_result}



    [47, 49, 57, 64, 72, 83, 89, 87, 79, 67, 55, 47]





{:.input}
```python
# Add your code here 

```


{:.output}
    temp: 47
    temp: 49
    temp: 57
    temp: 64
    temp: 72
    temp: 83
    temp: 89
    temp: 87
    temp: 79
    temp: 67
    temp: 55
    temp: 47



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 2: Modify Numeric Values in a List

Below is a list of values that represents the average monthly high temperature 
in Boulder, CO., collected by NOAA. They are currently in Fahrenheit, but can be 
converted to Celsius by subtracting 32, and multiplying by 5/9. 

```
celcius = (fahrenheit - 32) * 5/9
```

Create a **new list** with these same temperatures converted to Celsius using a for loop.
Call your new list: `boulder_avg_high_temp_c`

HINT: to complete this challenge you may want to create a new empty list first. 
Then you can use `list_name.append()` in each loop iteration to add a new 
value to your list. 

</div>

{:.input}
```python
# Add your code here 

```


{:.output}
{:.execute_result}



    [8.333333333333334,
     9.444444444444445,
     13.88888888888889,
     17.77777777777778,
     22.22222222222222,
     28.333333333333336,
     31.666666666666668,
     30.555555555555557,
     26.11111111111111,
     19.444444444444446,
     12.777777777777779,
     8.333333333333334]





<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 3: Round Values In a List  

Create a loop that rounds the values in the list that you created above: 
`boulder_avg_high_temp_c` to only two decimal places. 

To round your data, you can use the **Python** function `round()`. The 
first argument in the `round()` function is the number to round, and the 
second argument is the number of decimals you want after it's been rounded. 
See how this works below.

```
c = 7.3848234
round(c, 2)

# 7.38
```

Create a new list called `boulder_avg_high_temp_c_round` that contains temperature
data that has been rounded. 

</div>

{:.input}
```python
# Add your code here 

```


{:.output}
{:.execute_result}



    [8.33,
     9.44,
     13.89,
     17.78,
     22.22,
     28.33,
     31.67,
     30.56,
     26.11,
     19.44,
     12.78,
     8.33]







<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 4: Print A List of Directories  

The code below creates a list of directories called `all_dirs`.
Create a **for loop** that prints each directory name.

</div>

{:.input}
```python
import os 
from glob import glob
import earthpy as et 

# Download data on average monthly temp for two California sites
file_url = "https://ndownloader.figshare.com/files/21894528"
out_path = et.data.get_data(url = file_url)


# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, 
                      "earth-analytics", 
                      "data",
                      "earthpy-downloads"))

# Creating all_dirs list of directories to loop through

data_dirs = os.path.join(out_path, "*")
all_dirs = glob(data_dirs)

```

{:.input}
```python
# Add your code here 

```


{:.output}
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Challenge 5: Print A List of All Files Within Each Directory  

Above, you printed the name of each directory stored in a list of directories. 
Use the same for loop that you created above to print a list of all files  in
each directory. 

HINT: you will want to use the glob function to create a list of files within each directory. 

* <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/os-glob-manipulate-file-paths/">More on using the glob function here</a>
</div>

{:.input}
```python
# Add your code here 

```


{:.output}
    ['/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv']
    ['/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv']



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge 1: Get Data from List of Files

Above, you created a list inside of a `for` loop to view all of the files 
stored in two separate folders. These files are `csv` files that can be opened 
with **pandas** as a `DataFrame`. The files contain the average monthly temperature 
for two different study locations, Sonoma and San Diego. Their are `csv` files for 
each location for the years between 1999 and 2003. 

For this challenge, use nested `for` loops to get data from the files and find the 
average temperature in January over the years for the two sites. The end result
should be two variables that represent the average January temperature for each site. 
Their are many ways to get this data, so don't be afraid to get creative!

</div>

{:.input}
```python
# You will need pandas for this challenge
import pandas as pd

# Add your code here 

```


{:.output}
    San Diego January Mean Temperature from 1999 to 2003: 65.52 ºF
    Sonoma January Mean Temperature from 1999 to 2003: 56.82 ºF



<div class="notice--warning" markdown="1">

## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Bonus Challenge 2: Collatz Conjecture

The Collatz Conjecture is a mathematic rule that says that if the following 
rules are performed on any positive interger, the number will eventually reach 
1. The rules are:

1. If the integer is even, the next integer is one half of the current integer.
2. If the integer is odd, the next term is 3 times the current integer plus 1. 

If these rules are followed, any integer will eventually reach one. Using a `while` 
loop, implement these rules so that a variable you enter into the while loop has these 
rules run on it until it equals one. Here are some helpful hints to help you implement 
these rules:

1. To check if a number is odd or even in **Python**, it is common practice to see if the remainder of the number divided by 2 equals zero. If you remember, `%` will get the remainder of a number divided by another number. So, to see if a number is even, the code `n%2 == 0` will return `True` if `n` is even, and `False` if `n` is odd.
2. The `while` loop will run until the input number equals one. But you also need to remember not to run the code on the number if it does equal one. So in the odd calculation, make sure that the number doesn't equal one before you run the calculation on it. 

Print out the number variable with each pass through of the while loop. Have your number 
variable equal `10000` before the `while` loop is run. Careful with this, it shouldn't 
take long to run. If it is taking a long time to run, there's probably a mistake in your 
code and your while loop will be running forever until you stop it! Once your code runs, 
change the number variable to see it run on any number you want!

For further explanation on the Collatz Conjecture, and what it looks like to implement it, [this YouTube video explains the basics of the math behind it](https://www.youtube.com/watch?v=5mFpVDpKX70) and [the Wikipedia page on the number has more in depth explanations of the math](https://en.wikipedia.org/wiki/Collatz_conjecture).
</div>

{:.input}
```python
# Add your code here 

```


{:.output}
    10000
    5000.0
    2500.0
    1250.0
    625.0
    1876.0
    938.0
    469.0
    1408.0
    704.0
    352.0
    176.0
    88.0
    44.0
    22.0
    11.0
    34.0
    17.0
    52.0
    26.0
    13.0
    40.0
    20.0
    10.0
    5.0
    16.0
    8.0
    4.0
    2.0
    1.0


