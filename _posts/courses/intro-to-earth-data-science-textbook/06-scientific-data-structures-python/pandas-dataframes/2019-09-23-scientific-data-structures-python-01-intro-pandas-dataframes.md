---
layout: single
title: 'Intro to Pandas Dataframes'
excerpt: "Pandas dataframes are a commonly used scientific data structure in Python that store tabular data using rows and columns with headers. Learn about the key characteristics of pandas dataframes that make them a useful data structure for storing and working with labeled scientific datasets."
authors: ['Jenny Palomino', 'Leah Wasser']
category: [courses]
class-lesson: ['intro-pandas-dataframes']
permalink: /courses/intro-to-earth-data-science/scientific-data-structures-python/pandas-dataframes/
nav-title: "Intro to Pandas Dataframes"
dateCreated: 2019-09-06
modified: 2019-10-10
module-title: 'Work with Scientific Data Using Pandas Dataframes'
module-nav-title: 'Pandas Dataframes'
module-description: 'Pandas dataframes are a commonly used scientific data structure in Python that store tabular data using rows and columns with headers. Learn how to import data into pandas dataframes and how to run calculations, summarize, and select data from pandas dataframes.'
module-type: 'class'
chapter: 15
class-order: 2
course: "intro-to-earth-data-science-textbook"
week: 6
sidebar:
  nav:
author_profile: false
comments: true
order: 1
topics:
  reproducible-science-and-programming: ['python']
redirect_from:
  - "/courses/earth-analytics-bootcamp/pandas-dataframes/intro-pandas-dataframes/"
---
{% include toc title="In This Chapter" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Chapter Fifteen - Pandas Dataframes

In this chapter, you will learn about another commonly used data structure in Python for scientific data: **pandas** dataframes. You will write **Python** code to import text data (.csv) as **pandas** dataframes and to run calculations and summarize data in **pandas** dataframes.

After completing this chapter, you will be able to:

* Describe the key characteristics of **pandas** dataframes.
* Import data from CSV files (.csv) into **pandas** dataframes.
* Run calculations and summarize data in **pandas** dataframes.
* Use indexing to select data from **pandas** dataframes.


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You should have Conda setup on your computer and the Earth Analytics Python Conda environment. Follow the <a href="{{ site.url }}/workshops/setup-earth-analytics-python/setup-git-bash-conda/">Set up Git, Bash, and Conda on your computer</a> to install these tools.

Be sure that you have completed the chapters on <a href="{{ site.url }}/courses/intro-to-earth-data-science/open-reproducible-science/jupyter-python/">Jupyter Notebook</a>, <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/use-python-packages/">working with packages in Python</a>, and <a href="{{ site.url }}/courses/intro-to-earth-data-science/python-code-fundamentals/work-with-files-directories-paths-in-python/">working with paths and directories in Python</a>.

</div>


## Pandas Dataframes

In the chapters introducing **Python** lists and **numpy** arrays, you learn that both of these data structures can store collections of values, instead of just single values. 

You also learned that while **Python** lists are flexible and can store data items of various types (e.g. integers, floats, text strings), **numpy** arrays require all data elements to be of the same type. Because of this requirement, **numpy** arrays can provide more functionality for running calculations such as element-by-element arithmetic operations (e.g. multiplication of each element in the `numpy array` by the same value) that **Python** lists do not support.  

In this chapter, you will learn about **Pandas** dataframes, which provide the ability to work with tabular data. 

**Pandas** dataframes are data structures that are composed of rows and columns that can have header names, and the columns in **pandas** dataframes can be different types (e.g. the first column containing integers and the second column containing text strings). 


| months          |  precip |
|:----------------|:--------|
| January         | 0.70    |
| February        | 0.75    |
| March           | 1.85    |  

Each value in **pandas** dataframe is referred to as a cell that has a specific row index and column index within the tabular structure. 


## Distinguishing Characteristics of Pandas Dataframes

These characteristics (i.e. tabular format with rows and columns that can have headers) make **pandas** dataframes very versatile for not only storing different types, but for maintaining the relationships between cells across the same row and/or column. 

Recall that in the chapter on **numpy** arrays, you could not easily connect the values across two numpy arrays, such as those for `precip` and `months`. 

Within **pandas** dataframes (such as the example above), the relationship between the value `January` in the `months` column and the value `0.70` in the `precip` column is maintained. 

These two values (`January` and `0.70`) are considered the same record, representing the same observation in the **pandas** dataframe.

In addition, **pandas** dataframes have other unique characteristics that differentiate them from **numpy** arrays:

1. Each column in a **pandas** dataframe can have a labeled name (i.e. header name such as `months`) and can contain a different type of data from its neighboring columns. 
2. Cells within the **pandas** dataframe are always identified by its combined row and column index (e.g. `[row index, column index]`). All cells have both a row index and a column index, even if there is only one row and/or one column in the **pandas** dataframe.
3. In addition to querying values through location indexing (i.e. row index, column index), you can also query for data within **pandas** dataframes based on specific values or attributes (i.e. filtering values). 
4. Because of the tabular indexing, you can query and run calculations on **pandas** dataframes across an entire row, an entire column, or a specific cell or series of cells based on either location and attribute values. 
5. Due to its inherent tabular structure, **pandas** dataframes also allow for cells to have `null` or blank values.


## Structure of Pandas Dataframes

The structure of a **pandas** dataframe includes the column names and the rows that represent individual observations (i.e. records).  

The function `DataFrame` from **pandas** (e.g. `pd.DataFrame`) can be used to manually define a **pandas** dataframe by providing a list of column names (`columns`) and a list of data values (`data`) for each column (one value for each column). 

**Pandas** dataframes can have many columns that each contain a different type of data (e.g. strings, floats). 

In the example below, the **pandas** dataframe stores daily precipitation values in inches for Boulder, CO for one week in September 2013, during which there was a major flooding event. 

The **pandas** dataframe contains one column with the dates as text strings and one column for the precipitation (inches) as numeric values.

{:.input}
```python
# Import pandas with alias pd
import pandas as pd
```

{:.input}
```python
# Precipitation for Sept flood event in Boulder, CO
boulder_precip = pd.DataFrame(columns=["date", "precip_in"],
                              data=[
                                  ["2013-09-09", 0.1], ["2013-09-10", 1.0],
                                  ["2013-09-11", 2.3], ["2013-09-12", 9.8],
                                  ["2013-09-13", 1.9], ["2013-09-14", 0.01],
                                  ["2013-09-15", 1.4], ["2013-09-16", 0.4]])

# Notice the nicely formatted output without use of print
boulder_precip
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
      <th>date</th>
      <th>precip_in</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>0</td>
      <td>2013-09-09</td>
      <td>0.10</td>
    </tr>
    <tr>
      <td>1</td>
      <td>2013-09-10</td>
      <td>1.00</td>
    </tr>
    <tr>
      <td>2</td>
      <td>2013-09-11</td>
      <td>2.30</td>
    </tr>
    <tr>
      <td>3</td>
      <td>2013-09-12</td>
      <td>9.80</td>
    </tr>
    <tr>
      <td>4</td>
      <td>2013-09-13</td>
      <td>1.90</td>
    </tr>
    <tr>
      <td>5</td>
      <td>2013-09-14</td>
      <td>0.01</td>
    </tr>
    <tr>
      <td>6</td>
      <td>2013-09-15</td>
      <td>1.40</td>
    </tr>
    <tr>
      <td>7</td>
      <td>2013-09-16</td>
      <td>0.40</td>
    </tr>
  </tbody>
</table>
</div>





You can see from the **pandas** dataframe that each row has an index value, and that the indexing still begins with `[0]`, as it does for `Python` lists and `numpy arrays`. 

In the pages that follow, you will learn how to import data from .csv files into **pandas** dataframes, run calculations and summary statistics on **pandas** dataframes, and select data from **pandas** dataframes.
