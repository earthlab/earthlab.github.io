---
layout: single
title: 'Automate Data Tasks With Loops in Python'
excerpt: "Loops can be used to automate data tasks in Python by iteratively executing the same code on multiple data structures. Learn how to automate data tasks in Python using data structures such as lists, numpy arrays, and pandas dataframes."
authors: ['Nathan Korinek', 'Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-loops-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/loops/automate-data-tasks-with-loops/
nav-title: "Automate Data Tasks With Loops"
dateCreated: 2019-10-23
modified: 2020-07-13
module-type: 'class'
chapter: 18
course: "intro-to-earth-data-science-textbook"
week: 7
sidebar:
  nav:
author_profile: false
comments: true
order: 3
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/loops/automate-tasks-loops/"
  - "/courses/intro-to-earth-data-science/dry-code-python/loops/automate-data-tasks-with-loops/"
  - "/courses/intro-to-earth-data-science/write-efficient-python-code/automate-data-tasks-with-loops/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this chapter, you will be able to:

* Iterate through multiple directories to access data within.
* Nest loops in each other to run more complicated loops.
* Use for loops to combine multiple datasets into one **Pandas** `DataFrame`.

 
</div>

## Build a Data Workflow 

Often, data you encounter can be messy and hard to access. It will be spread out over multiple files in many directories. This is not something you would want to manually code for every file in every folder, so it can be much easier to automate the process in **Python** with `for` loops! This lesson will cover utilizing loops to create workflows for analyzing data in a clean and reproducible way. 

{:.input}
```python
import os
from glob import glob
import pandas as pd
import earthpy as et

# Download data on average monthly temp for two California sites
file_url = "https://ndownloader.figshare.com/files/21894528"
out_path = et.data.get_data(url = file_url)
out_path

# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, 
                      "earth-analytics", 
                      "data",
                      "earthpy-downloads"))

# List of directories the data you just downloaded are stored in.
os.listdir(out_path)
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/21894528
    Extracted output to /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr



{:.output}
{:.execute_result}



    ['Sonoma', 'San-Diego']





### Print All Files in a Directory

In order to work on all files in a directory, you first have to make a list of all the files. There are a few ways to do this, but here we will do it with the `glob` package. If you remember from chapter 4 of this textbook, `glob` is an easy way to create a list of files that match certain criteria. We can use `glob` to get every file in a list of directories into one list, and then iterate through those lists with `for` loops to perform an operation on each file.

Here, you create a list using `glob` of all of the folders in the data you downloaded, and then iterate through that list with a `for` loop to print out the name of each folder within the main directory.

{:.input}
```python
# Create a to print all folders found by glob
data_dirs = os.path.join(out_path, "*")
all_dirs = glob(data_dirs)

for a_dir in all_dirs:
    print(a_dir)
```

{:.output}
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego



### Use `glob` Inside a `for` Loop

The folders printed out above are interesting, but they are not the files you want to work on. The files are another directory down, stored within the folders printed above. To access these files, you can use `glob` once again. Inside the `for` loop, you can use `glob` to create a list of all of the files within each folder in the original list. 

Below you can see two different lists printed, one with all of the files stored in the `San-Diego` folder, and one with all of the files stored in the `Sonoma` folder. 

{:.input}
```python
# Create lists inside a for loop
for a_dir in all_dirs:
    all_files = os.path.join(a_dir, "*")
    print(glob(all_files))
```

{:.output}
    ['/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv']
    ['/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv']



### Nesting `for` Loops

Now that you've created another list inside of a `for` loop, you can loop through that list too! Below, you create the list of files inside each directory with `glob`, and then you loop through that list to print out each individual file. 

Nesting `for` loops is a powerful tool, but can also be computationally expensive. Each time the outer loop executes one cycle, the `for` loop that's nested inside must complete it's entire loop before the outer loop executes it's next cycle. You can nest as many `for` loops as you want, but it's good to keep this in mind. The more `for` loops that are nested, the longer each cycle of the outer `for` loop will take. 

{:.input}
```python
# Nesting for loops
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    # Create a nested loop which loops through each directory
    for a_file_path in all_file_paths:
        print(a_file_path)
    
```

{:.output}
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv



<div class='notice--success alert alert-info' markdown="1">

<i class="fa fa-star"></i> **Data Tip:** Assigning Variables in `for` Loops

When assigning variables in **Python**, overwriting a variable with new data can be useful to update values and make your code more legible. This can be useful in `for` loops too, but can easily be done by accident as well. Below, you see that for every file in the two folders that contain your data, the line `pd.read_csv()` is run, and assigned to the variable `data`. However, with each new cycle of the for loop, that variable is getting reassigned to a new file's data. 

You can see that even though you opened up and read every single file into **pandas**, the only data stored in the `data` variable is from the last file that was read, which happens to be the 2003 data from the Sonoma folder. 

To avoid this data being overwritten every cycle, a common work around is to create a list outside of the for loop, and append all of the values into that list. That way the `data` variable from each cycle will be stored in the list with the data from that cycle stored in it, preventing it from being overwritten. 

</div>

{:.input}
```python
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    # Create a nested loop which loops through each directory
    for a_file_path in all_file_paths:
        print(a_file_path)
        # Read the file into a pandas dataframe and assign it to a variable
        temp_data_df = pd.read_csv(a_file_path)
temp_data_df   
```

{:.output}
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv



{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Year</th>
      <th>January</th>
      <th>February</th>
      <th>March</th>
      <th>April</th>
      <th>May</th>
      <th>June</th>
      <th>July</th>
      <th>August</th>
      <th>September</th>
      <th>October</th>
      <th>November</th>
      <th>December</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>65.8</td>
      <td>65.3</td>
      <td>63.7</td>
      <td>67.7</td>
      <td>69.1</td>
      <td>72.4</td>
      <td>73.5</td>
      <td>76.3</td>
      <td>75.5</td>
      <td>69.5</td>
      <td>66</td>
      <td>66.9</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
# Create a list outside of the for loop to store data 
all_df = []

for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    for a_file_path in all_file_paths:
        temp_data_df = pd.read_csv(a_file_path)
        # Append the data to the list you made to prevent it from being overwritten
        all_df.append(temp_data_df)

# Combine all the dataframes stored in the all_df list into one pandas dataframe
pd.concat(all_df) 
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Year</th>
      <th>January</th>
      <th>February</th>
      <th>March</th>
      <th>April</th>
      <th>May</th>
      <th>June</th>
      <th>July</th>
      <th>August</th>
      <th>September</th>
      <th>October</th>
      <th>November</th>
      <th>December</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>56.8</td>
      <td>58.0</td>
      <td>64.8</td>
      <td>69.5</td>
      <td>75.0</td>
      <td>79.5</td>
      <td>81.4</td>
      <td>83.7</td>
      <td>83.4</td>
      <td>71.8</td>
      <td>60.7</td>
      <td>58.5</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2001</td>
      <td>56.5</td>
      <td>58.4</td>
      <td>68.0</td>
      <td>66.7</td>
      <td>83.1</td>
      <td>86.1</td>
      <td>81.2</td>
      <td>85.3</td>
      <td>81.0</td>
      <td>78.4</td>
      <td>64.0</td>
      <td>55.6</td>
    </tr>
    <tr>
      <th>0</th>
      <td>1999</td>
      <td>56.1</td>
      <td>56.6</td>
      <td>58.7</td>
      <td>68.3</td>
      <td>72.7</td>
      <td>80.6</td>
      <td>80.9</td>
      <td>82.9</td>
      <td>81.3</td>
      <td>79.1</td>
      <td>64.2</td>
      <td>61.5</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2003</td>
      <td>58.9</td>
      <td>61.8</td>
      <td>66.4</td>
      <td>61.5</td>
      <td>74.2</td>
      <td>81.1</td>
      <td>87.0</td>
      <td>83.5</td>
      <td>85.0</td>
      <td>82.7</td>
      <td>61.0</td>
      <td>56.4</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2002</td>
      <td>55.8</td>
      <td>62.9</td>
      <td>63.5</td>
      <td>66.9</td>
      <td>74.5</td>
      <td>84.2</td>
      <td>82.8</td>
      <td>82.1</td>
      <td>84.5</td>
      <td>75.7</td>
      <td>67.6</td>
      <td>57.4</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2003</td>
      <td>71.4</td>
      <td>64.6</td>
      <td>66.5</td>
      <td>65.2</td>
      <td>66.9</td>
      <td>67.4</td>
      <td>74.3</td>
      <td>77.5</td>
      <td>74.0</td>
      <td>73.1</td>
      <td>67.4</td>
      <td>64.6</td>
    </tr>
    <tr>
      <th>0</th>
      <td>1999</td>
      <td>65.2</td>
      <td>64.9</td>
      <td>63.6</td>
      <td>64.6</td>
      <td>64.4</td>
      <td>66.9</td>
      <td>72.7</td>
      <td>72.7</td>
      <td>71.4</td>
      <td>77.7</td>
      <td>67.4</td>
      <td>67.6</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2002</td>
      <td>63.0</td>
      <td>66.2</td>
      <td>63.6</td>
      <td>63.7</td>
      <td>66.1</td>
      <td>68.7</td>
      <td>71.8</td>
      <td>73.4</td>
      <td>75.5</td>
      <td>68.4</td>
      <td>71.4</td>
      <td>63.7</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2001</td>
      <td>62.2</td>
      <td>61.7</td>
      <td>63.7</td>
      <td>63.6</td>
      <td>67.5</td>
      <td>72.0</td>
      <td>73.0</td>
      <td>73.5</td>
      <td>73.2</td>
      <td>71.1</td>
      <td>66.9</td>
      <td>63.3</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>65.8</td>
      <td>65.3</td>
      <td>63.7</td>
      <td>67.7</td>
      <td>69.1</td>
      <td>72.4</td>
      <td>73.5</td>
      <td>76.3</td>
      <td>75.5</td>
      <td>69.5</td>
      <td>66.0</td>
      <td>66.9</td>
    </tr>
  </tbody>
</table>
</div>





### Extracting Data from Pathnames

Often times when data is stored in many directories, the name of the folder that the data is stored in can have useful information. This could be the date the data is from, or the location where it was collected, or any number of types of metadata. Because of this, it can be useful to add data from a pathname to your data. For example, if you are reading your data into a **pandas** `DataFrame`, it might be useful to add information from the pathname into a new data column. 

In this example, the two folders that store all of the files contain useful information in the folder names. Specifically, the names, `San-Diego` and `Sonoma`, are indicative of where the data was collected. We can add this information to a new column in the **pandas** `DataFrames` we are creating. You can extract the information from the path name in many ways. 

One way would be to use string indexing, counting all the characters in the path string to see which index the information you want is stored at. While maybe the simplest way to perform this operation, this makes the code much less reproducible. Since paths vary greatly between machines, and even operating systems, where the data is stored in the path string on your computer is most likely different from where it is stored on other's computers.

You could also use the `.split()` function in **Python** to split the path into a list of strings, and get the data you want to store from that. However, it has a similar problem to indexing the string, in that the data may be stored at a different directory level on your computer than others. This can lead to completely nonsensical information getting added to your workflow. 

The most reproducible way to extract this information would be to use the `os` package to dissect the path. `os` functions are great since they work consistently on file paths and work between operating systems. 

In this example, you can extract the last folder name in your pathname by using `os.path.basename()`. This function will grab the last folder in a pathname and return it as a string. 

{:.input}
```python
all_df = []
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    for a_file_path in all_file_paths:
        temp_data_df = pd.read_csv(a_file_path)
        # Reading the pathname from each directory into the dataframe. 
        # Notice how it reads in the entire pathname.
        temp_data_df["location"] = a_dir
        all_df.append(temp_data_df)
        
pd.concat(all_df) 
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Year</th>
      <th>January</th>
      <th>February</th>
      <th>March</th>
      <th>April</th>
      <th>May</th>
      <th>June</th>
      <th>July</th>
      <th>August</th>
      <th>September</th>
      <th>October</th>
      <th>November</th>
      <th>December</th>
      <th>location</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>56.8</td>
      <td>58.0</td>
      <td>64.8</td>
      <td>69.5</td>
      <td>75.0</td>
      <td>79.5</td>
      <td>81.4</td>
      <td>83.7</td>
      <td>83.4</td>
      <td>71.8</td>
      <td>60.7</td>
      <td>58.5</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2001</td>
      <td>56.5</td>
      <td>58.4</td>
      <td>68.0</td>
      <td>66.7</td>
      <td>83.1</td>
      <td>86.1</td>
      <td>81.2</td>
      <td>85.3</td>
      <td>81.0</td>
      <td>78.4</td>
      <td>64.0</td>
      <td>55.6</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>1999</td>
      <td>56.1</td>
      <td>56.6</td>
      <td>58.7</td>
      <td>68.3</td>
      <td>72.7</td>
      <td>80.6</td>
      <td>80.9</td>
      <td>82.9</td>
      <td>81.3</td>
      <td>79.1</td>
      <td>64.2</td>
      <td>61.5</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2003</td>
      <td>58.9</td>
      <td>61.8</td>
      <td>66.4</td>
      <td>61.5</td>
      <td>74.2</td>
      <td>81.1</td>
      <td>87.0</td>
      <td>83.5</td>
      <td>85.0</td>
      <td>82.7</td>
      <td>61.0</td>
      <td>56.4</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2002</td>
      <td>55.8</td>
      <td>62.9</td>
      <td>63.5</td>
      <td>66.9</td>
      <td>74.5</td>
      <td>84.2</td>
      <td>82.8</td>
      <td>82.1</td>
      <td>84.5</td>
      <td>75.7</td>
      <td>67.6</td>
      <td>57.4</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2003</td>
      <td>71.4</td>
      <td>64.6</td>
      <td>66.5</td>
      <td>65.2</td>
      <td>66.9</td>
      <td>67.4</td>
      <td>74.3</td>
      <td>77.5</td>
      <td>74.0</td>
      <td>73.1</td>
      <td>67.4</td>
      <td>64.6</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>1999</td>
      <td>65.2</td>
      <td>64.9</td>
      <td>63.6</td>
      <td>64.6</td>
      <td>64.4</td>
      <td>66.9</td>
      <td>72.7</td>
      <td>72.7</td>
      <td>71.4</td>
      <td>77.7</td>
      <td>67.4</td>
      <td>67.6</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2002</td>
      <td>63.0</td>
      <td>66.2</td>
      <td>63.6</td>
      <td>63.7</td>
      <td>66.1</td>
      <td>68.7</td>
      <td>71.8</td>
      <td>73.4</td>
      <td>75.5</td>
      <td>68.4</td>
      <td>71.4</td>
      <td>63.7</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2001</td>
      <td>62.2</td>
      <td>61.7</td>
      <td>63.7</td>
      <td>63.6</td>
      <td>67.5</td>
      <td>72.0</td>
      <td>73.0</td>
      <td>73.5</td>
      <td>73.2</td>
      <td>71.1</td>
      <td>66.9</td>
      <td>63.3</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>65.8</td>
      <td>65.3</td>
      <td>63.7</td>
      <td>67.7</td>
      <td>69.1</td>
      <td>72.4</td>
      <td>73.5</td>
      <td>76.3</td>
      <td>75.5</td>
      <td>69.5</td>
      <td>66.0</td>
      <td>66.9</td>
      <td>/root/earth-analytics/data/earthpy-downloads/a...</td>
    </tr>
  </tbody>
</table>
</div>





{:.input}
```python
all_df = []
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    for a_file_path in all_file_paths:
        temp_data_df = pd.read_csv(a_file_path)
        # Reading the pathname from each directory into the dataframe. 
        # Notice how it reads just the last folder name into the column now.
        temp_data_df["location"] = os.path.basename(a_dir)
        all_df.append(temp_data_df)
        
all_data = pd.concat(all_df) 
all_data
```

{:.output}
{:.execute_result}



<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Year</th>
      <th>January</th>
      <th>February</th>
      <th>March</th>
      <th>April</th>
      <th>May</th>
      <th>June</th>
      <th>July</th>
      <th>August</th>
      <th>September</th>
      <th>October</th>
      <th>November</th>
      <th>December</th>
      <th>location</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>56.8</td>
      <td>58.0</td>
      <td>64.8</td>
      <td>69.5</td>
      <td>75.0</td>
      <td>79.5</td>
      <td>81.4</td>
      <td>83.7</td>
      <td>83.4</td>
      <td>71.8</td>
      <td>60.7</td>
      <td>58.5</td>
      <td>Sonoma</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2001</td>
      <td>56.5</td>
      <td>58.4</td>
      <td>68.0</td>
      <td>66.7</td>
      <td>83.1</td>
      <td>86.1</td>
      <td>81.2</td>
      <td>85.3</td>
      <td>81.0</td>
      <td>78.4</td>
      <td>64.0</td>
      <td>55.6</td>
      <td>Sonoma</td>
    </tr>
    <tr>
      <th>0</th>
      <td>1999</td>
      <td>56.1</td>
      <td>56.6</td>
      <td>58.7</td>
      <td>68.3</td>
      <td>72.7</td>
      <td>80.6</td>
      <td>80.9</td>
      <td>82.9</td>
      <td>81.3</td>
      <td>79.1</td>
      <td>64.2</td>
      <td>61.5</td>
      <td>Sonoma</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2003</td>
      <td>58.9</td>
      <td>61.8</td>
      <td>66.4</td>
      <td>61.5</td>
      <td>74.2</td>
      <td>81.1</td>
      <td>87.0</td>
      <td>83.5</td>
      <td>85.0</td>
      <td>82.7</td>
      <td>61.0</td>
      <td>56.4</td>
      <td>Sonoma</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2002</td>
      <td>55.8</td>
      <td>62.9</td>
      <td>63.5</td>
      <td>66.9</td>
      <td>74.5</td>
      <td>84.2</td>
      <td>82.8</td>
      <td>82.1</td>
      <td>84.5</td>
      <td>75.7</td>
      <td>67.6</td>
      <td>57.4</td>
      <td>Sonoma</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2003</td>
      <td>71.4</td>
      <td>64.6</td>
      <td>66.5</td>
      <td>65.2</td>
      <td>66.9</td>
      <td>67.4</td>
      <td>74.3</td>
      <td>77.5</td>
      <td>74.0</td>
      <td>73.1</td>
      <td>67.4</td>
      <td>64.6</td>
      <td>San-Diego</td>
    </tr>
    <tr>
      <th>0</th>
      <td>1999</td>
      <td>65.2</td>
      <td>64.9</td>
      <td>63.6</td>
      <td>64.6</td>
      <td>64.4</td>
      <td>66.9</td>
      <td>72.7</td>
      <td>72.7</td>
      <td>71.4</td>
      <td>77.7</td>
      <td>67.4</td>
      <td>67.6</td>
      <td>San-Diego</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2002</td>
      <td>63.0</td>
      <td>66.2</td>
      <td>63.6</td>
      <td>63.7</td>
      <td>66.1</td>
      <td>68.7</td>
      <td>71.8</td>
      <td>73.4</td>
      <td>75.5</td>
      <td>68.4</td>
      <td>71.4</td>
      <td>63.7</td>
      <td>San-Diego</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2001</td>
      <td>62.2</td>
      <td>61.7</td>
      <td>63.7</td>
      <td>63.6</td>
      <td>67.5</td>
      <td>72.0</td>
      <td>73.0</td>
      <td>73.5</td>
      <td>73.2</td>
      <td>71.1</td>
      <td>66.9</td>
      <td>63.3</td>
      <td>San-Diego</td>
    </tr>
    <tr>
      <th>0</th>
      <td>2000</td>
      <td>65.8</td>
      <td>65.3</td>
      <td>63.7</td>
      <td>67.7</td>
      <td>69.1</td>
      <td>72.4</td>
      <td>73.5</td>
      <td>76.3</td>
      <td>75.5</td>
      <td>69.5</td>
      <td>66.0</td>
      <td>66.9</td>
      <td>San-Diego</td>
    </tr>
  </tbody>
</table>
</div>





### Plotting the Data

With the new column that specifies where the data was collected, you can use the **pandas** `groupby` function to plot a chart for each location! The `groupby` function will create a new plot for each unique entry in a column. Since there are two locations in the `location` column, we can produce two graphs, one for each location. 

{:.input}
```python
# Plotting the data by location for comparison.
for title, group in all_data.groupby('location'):
    group.plot(x='Year', y='January', legend=False, kind="barh", title=title + " January Average Temperature ºF")
```

{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-to-earth-data-science-textbook/07-efficient-clean-code-python/loops/2019-10-22-loops-python-03-loop-workflows/2019-10-22-loops-python-03-loop-workflows_17_0.png">

</figure>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-to-earth-data-science-textbook/07-efficient-clean-code-python/loops/2019-10-22-loops-python-03-loop-workflows/2019-10-22-loops-python-03-loop-workflows_17_1.png">

</figure>



