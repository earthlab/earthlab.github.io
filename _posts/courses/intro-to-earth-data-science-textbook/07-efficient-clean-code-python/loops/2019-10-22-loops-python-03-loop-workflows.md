---
layout: single
title: 'Automate Data Tasks With Loops in Python'
excerpt: "Loops can be used to automate data tasks in Python by iteratively executing the same code on multiple data structures. Learn how to automate data tasks in Python using data structures such as lists, numpy arrays, and pandas dataframes."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-loops-tb']
permalink: /courses/intro-to-earth-data-science/write-efficient-python-code/loops/automate-data-tasks-with-loops/
nav-title: "Automate Data Tasks With Loops"
dateCreated: 2019-10-23
modified: 2020-07-09
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

* Automate tasks using data structures such as lists, **numpy** arrays, and **pandas** dataframe.
* Add the results of a loop to a new list. 
* Automate data downloads with **earthpy**.
 
</div>



## Build a Data Workflow 

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

os.listdir(out_path)

# Create a loop for just the San-Diego data
# stuff about glob -- remmeber from chapter XX you can use glob to generate a list of files.
# loop through and print all of the files in the San-Diego directory


data_dirs = os.path.join(out_path, "*")
all_dirs = glob(data_dirs)

for a_dir in all_dirs:
    print(a_dir)
    

# Continue to build out your loop
for a_dir in all_dirs:
    all_files = os.path.join(a_dir, "*")
    print(glob(all_files))
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/21894528
    Extracted output to /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego
    ['/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv']
    ['/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv', '/root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv']



{:.input}
```python
# You can nest for loops too
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    # Create a nested loop which loops through each directory
    # Then list the files in that directory: Note that you are setting yourself up to open multiple files this way!
    for a_file_path in all_file_paths:
        print(a_file_path)
    
```

{:.output}
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv



{:.input}
```python
# You can nest for loops too
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    # Create a nested loop which loops through each directory
    # Then list the files in that directory: Note that you are setting yourself up to open multiple files this way!
    for a_file_path in all_file_paths:
        print(a_file_path)
        data = pd.read_csv(a_file_path)
data   
```

{:.output}
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2002-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-1999-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2001-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2000-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/Sonoma/Sonoma-2003-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2003-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2000-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2002-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-2001-temp.csv
    /root/earth-analytics/data/earthpy-downloads/avg-monthly-temp-fahr/San-Diego/San-Diego-1999-temp.csv



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
  </tbody>
</table>
</div>





{:.input}
```python
# You can nest for loops too
all_df = []
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    # Create a nested loop which loops through each directory
    # Then list the files in that directory: Note that you are setting yourself up to open multiple files this way!
    for a_file_path in all_file_paths:
        #print(a_file_path)
        data = pd.read_csv(a_file_path)
        all_df.append(data)
        
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
  </tbody>
</table>
</div>





{:.input}
```python
# You can nest for loops too
all_df = []
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    # Create a nested loop which loops through each directory
    # Then list the files in that directory: Note that you are setting yourself up to open multiple files this way!
    for a_file_path in all_file_paths:
        #print(a_file_path)
        data = pd.read_csv(a_file_path)
        data["location"] = a_dir
        all_df.append(data)
        
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
  </tbody>
</table>
</div>





{:.input}
```python
# You can nest for loops too
all_df = []
for a_dir in all_dirs:
    dir_path = os.path.join(a_dir, "*")
    all_file_paths = (glob(dir_path))
    # Create a nested loop which loops through each directory
    # Then list the files in that directory: Note that you are setting yourself up to open multiple files this way!
    for a_file_path in all_file_paths:
        #print(a_file_path)
        data = pd.read_csv(a_file_path)
        data["location"] = os.path.basename(a_dir)
        all_df.append(data)
        
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
  </tbody>
</table>
</div>





{:.input}
```python
all_data.groupby("location").plot(x="Year",
             y="January", kind="kde")
```

{:.output}
{:.execute_result}



    location
    San-Diego    AxesSubplot(0.125,0.125;0.775x0.755)
    Sonoma       AxesSubplot(0.125,0.125;0.775x0.755)
    dtype: object





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-to-earth-data-science-textbook/07-efficient-clean-code-python/loops/2019-10-22-loops-python-03-loop-workflows/2019-10-22-loops-python-03-loop-workflows_9_1.png">

</figure>




{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/intro-to-earth-data-science-textbook/07-efficient-clean-code-python/loops/2019-10-22-loops-python-03-loop-workflows/2019-10-22-loops-python-03-loop-workflows_9_2.png">

</figure>






