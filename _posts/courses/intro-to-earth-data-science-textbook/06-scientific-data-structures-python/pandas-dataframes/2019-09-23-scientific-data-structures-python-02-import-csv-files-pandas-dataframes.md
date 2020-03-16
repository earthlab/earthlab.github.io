---
layout: single
title: 'Import CSV Files Into Pandas Dataframes'
excerpt: "Pandas dataframes are a commonly used scientific data structure in Python that store tabular data using rows and columns with headers. Learn how to import text data from .csv files into numpy arrays."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-pandas-dataframes']
permalink: /courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/import-csv-files-pandas-dataframes/
nav-title: "Import Data Into Pandas Dataframes"
dateCreated: 2019-09-06
modified: 2020-01-14
module-type: 'class'
course: "intro-to-earth-data-science-textbook"
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 2
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/pandas-dataframes/import-csv-files-pandas-dataframes/"
  - "/courses/earth-analytics-python/use-time-series-data-in-python/spreadsheet-data-in-python/"
---
{% include toc title="On This Page" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

* Import tabular data from .csv files into **pandas** dataframes. 

</div>


## CSV Files of Tabular Data as Inputs to Pandas Dataframes 

Recall that scientific data can come in a variety of file formats and types, including comma-separated values files (.csv), which use delimiters such as commas (or some other delimiter like tab spaces or semi-colons) to indicate separate values. 

CSV files also support labeled names for the columns, referred to as headers. This means that CSV files can easily support multiple columns of related data, and thus, are very useful for collecting and organizing datasets across multiple locations and/or timeframes. 

As you learned previously in this chapter, you can manually define **pandas** dataframes as needed using the `pandas.DataFrame()` function. However, when working with larger datasets, you will want to import data directly into **pandas** dataframes from .csv files. 


## Get Data to Import Into Pandas Dataframes
  
To import data into **pandas** dataframes, you will need to import the **pandas** package, and you will use the **earthpy** package to download the data files from the Earth Lab data repository on **Figshare.com**. 

{:.input}
```python
# Import necessary packages
import os
import pandas as pd
import earthpy as et
```

Recall from the previous chapter on <a href="{{ site.url }}/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">**numpy** arrays</a> that you can use the function `data.get_data()` from the **earthpy** package (which you imported with the alias `et`) to download data from online sources such as the **Figshare.com** data repository. 

To use the function `et.data.get_data()`, you need to provide a parameter value for the `url`, which you define by providing a text string of the URL to the dataset.

Begin by downloading a .csv file for average monthly precipitation for Boulder, CO from the following URL: 

`https://ndownloader.figshare.com/files/12710618`

{:.input}
```python
# URL for .csv with avg monthly precip data
avg_monthly_precip_url = "https://ndownloader.figshare.com/files/12710618"

# Download file from URL
et.data.get_data(url=avg_monthly_precip_url)
```

{:.output}
    Downloading from https://ndownloader.figshare.com/files/12710618



{:.output}
{:.execute_result}



    '/root/earth-analytics/data/earthpy-downloads/avg-precip-months-seasons.csv'





{:.input}
```python
# Set working directory to earth-analytics
os.chdir(os.path.join(et.io.HOME, "earth-analytics"))
```

## Import Tabular Data from CSV Files into Pandas Dataframes

Using the `read_csv()` function from the `pandas` package, you can import tabular data from CSV files into `pandas dataframe` by specifying a parameter value for the file name (e.g. `pd.read_csv("filename.csv")`). 

Remember that you gave `pandas` an alias (`pd`), so you will use `pd` to call `pandas` functions. 

{:.input}
```python
# Import data from .csv file
fname = os.path.join("data", "earthpy-downloads", 
                     "avg-precip-months-seasons.csv")

avg_monthly_precip = pd.read_csv(fname)

avg_monthly_precip
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
      <th>months</th>
      <th>precip</th>
      <th>seasons</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>Jan</td>
      <td>0.70</td>
      <td>Winter</td>
    </tr>
    <tr>
      <td>1</td>
      <td>Feb</td>
      <td>0.75</td>
      <td>Winter</td>
    </tr>
    <tr>
      <td>2</td>
      <td>Mar</td>
      <td>1.85</td>
      <td>Spring</td>
    </tr>
    <tr>
      <td>3</td>
      <td>Apr</td>
      <td>2.93</td>
      <td>Spring</td>
    </tr>
    <tr>
      <td>4</td>
      <td>May</td>
      <td>3.05</td>
      <td>Spring</td>
    </tr>
    <tr>
      <td>5</td>
      <td>June</td>
      <td>2.02</td>
      <td>Summer</td>
    </tr>
    <tr>
      <td>6</td>
      <td>July</td>
      <td>1.93</td>
      <td>Summer</td>
    </tr>
    <tr>
      <td>7</td>
      <td>Aug</td>
      <td>1.62</td>
      <td>Summer</td>
    </tr>
    <tr>
      <td>8</td>
      <td>Sept</td>
      <td>1.84</td>
      <td>Fall</td>
    </tr>
    <tr>
      <td>9</td>
      <td>Oct</td>
      <td>1.31</td>
      <td>Fall</td>
    </tr>
    <tr>
      <td>10</td>
      <td>Nov</td>
      <td>1.39</td>
      <td>Fall</td>
    </tr>
    <tr>
      <td>11</td>
      <td>Dec</td>
      <td>0.84</td>
      <td>Winter</td>
    </tr>
  </tbody>
</table>
</div>





As you can see, the `months` and `precip` data can exist together in the same **pandas** dataframe, which differs from **numpy** arrays. You can see that there is also a column for `seasons` containing text strings. 

Once again, you can also see that the indexing still begins with `[0]`, as it does for **Python** lists and **numpy** arrays, and that you did not have to use the `print()` function to see a nicely formatted version of the **pandas** dataframe. 

You now know how to import data from .csv files into **pandas** dataframes, which will come in very handy as you begin to work with scientific data. 

On the next pages of this chapter, you will learn how to work with **pandas** dataframes to run calculations, summarize data, and more. 
