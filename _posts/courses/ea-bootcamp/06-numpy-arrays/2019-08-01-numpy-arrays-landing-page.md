---
layout: single
category: courses
title: "Numpy Arrays"
permalink: /courses/earth-analytics-bootcamp/numpy-arrays/
modified: 2020-12-09
week-landing: 1
week: 6
sidebar:
  nav:
comments: false
author_profile: false
course: "earth-analytics-bootcamp"
module-type: 'session'
---
{% include toc title="This Week" icon="file-text" %}

<div class="notice--info" markdown="1">

## <i class="fa fa-ship" aria-hidden="true"></i> Welcome to Week {{ page.week }}!

Welcome to Week {{ page.week }} of the Earth Analytics Bootcamp course! This week, you will learn about a commonly used data structure in Python for scientific data: numpy arrays. You will write `Python` code to import text data (.txt and .csv) as `numpy arrays` and to manipulate, summarize, and plot data in `numpy arrays`.


## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing the lessons for {{ page.week }}, you will be able to:

* Define a data structure in `Python` (e.g. lists, `numpy arrays`)
* Explain the differences between `Python` lists and `numpy arrays` (e.g. dimensionality, indexing)
* Write `Python` code to import text data (.txt and .csv) into `numpy arrays`
* Write `Python` code to manipulate, summarize, and plot data in `numpy arrays`


## <i class="fa fa-pencil-square-o" aria-hidden="true"></i> Homework Assignment


## <i class="fa fa-book"></i> Earth Data Science Textbook Readings

Please read the following chapters to support completing this week's assignment:

* <a href="https://www.earthdatascience.org/courses/intro-to-earth-data-science/scientific-data-structures-python/numpy-arrays/">Numpy arrays in Python</a>.


## Example Homework Plots

The plots below are examples of what your plot could look like. Feel free to customize or modify plot settings as you see fit! 

</div>




{:.output}
    Downloading from https://ndownloader.figshare.com/files/12799931



{:.output}
{:.execute_result}



    [array([1.325, 1.21 , 1.39 , 1.365, 1.125, 1.18 , 2.03 , 1.31 , 1.24 ,
            1.685, 1.255, 1.405, 1.22 , 1.5  , 0.91 , 1.265, 1.61 , 1.795,
            0.985, 1.43 ]),
     array([1.8575    , 2.15666667, 1.33      , 1.52333333, 1.15666667,
            1.835     , 2.26416667, 1.46      , 1.60916667, 1.4275    ,
            1.41833333, 1.84916667, 1.69333333, 1.8575    , 1.30416667,
            2.84583333, 1.96416667, 2.24333333, 1.4375    , 1.8325    ])]






{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/06-numpy-arrays/2019-08-01-numpy-arrays-landing-page/2019-08-01-numpy-arrays-landing-page_5_0.png">

</figure>






{:.output}
    1998
    [ 27.178   5.842  86.614 115.824  46.228  46.99  102.108  24.638  16.764
      28.448  38.862  26.67 ]
    (0.09405308, 0.04985685, 0.08673591)
    1999
    [ 16.51    2.032  27.686 191.77   46.736  20.828  64.516 140.716  66.548
      33.782  20.574  25.654]
    (0.14079223, 0.08542126, 0.15659379)
    2000
    [ 7.366 13.97  65.024 38.1   40.64  38.862 53.086 18.288 63.754 32.512
     22.606 11.176]
    (0.18195582, 0.11955283, 0.23136943)
    2001
    [18.542 21.844 51.054 76.708 91.948 27.686 44.704 41.656 44.958 10.16
     25.908  9.144]
    (0.21458611, 0.15539445, 0.31023563)
    2002
    [27.178 11.176 38.1    5.08  81.28  29.972  2.286 36.576 38.608 61.976
     19.812  0.508]
    (0.23834119, 0.19356547, 0.39196711)
    2003
    [  2.286  38.608 138.176  75.946  66.548  68.326  18.034  89.408   8.89
      11.43   20.32   21.336]
    (0.25307401, 0.23772973, 0.48316271)
    2004
    [ 20.828  33.274  27.686 143.764  32.512 100.584  87.376  73.152  52.578
      58.928  50.546   8.89 ]
    (0.24958205, 0.28556371, 0.55701246)
    2005
    [35.56   7.874 30.988 98.044 48.514 68.072 10.668 41.402 13.208 71.12
      8.636 10.922]
    (0.2315855, 0.34122763, 0.60016456)
    2006
    [11.176 17.272 52.832 26.416 28.956 33.528 66.802 31.242 31.75  94.234
     18.796 77.47 ]
    (0.21607792, 0.39736958, 0.61948028)
    2007
    [42.672 21.844 42.926 56.896 45.466  9.652 20.32  46.228 48.768 35.052
     11.938 53.34 ]
    (0.20916709, 0.45122981, 0.63124483)
    2008
    [ 11.684  16.002  37.338  28.702 106.934  40.132   2.286  75.438  46.736
      29.972   3.302  33.782]
    (0.20527189, 0.50828072, 0.64429331)
    2009
    [ 15.748   6.858  48.006 149.352  78.232  68.58   36.068   8.382  10.668
      82.804  23.622  35.306]
    (0.20344718, 0.56074869, 0.65649508)
    2010
    [ 7.112 34.798 83.82  92.202 68.834 85.344 58.674 27.178  6.35  24.13
     15.494 12.192]
    (0.20654832, 0.61333521, 0.66715744)
    2011
    [ 24.384  25.908   8.382  61.214 131.064  34.29   72.898  27.432  65.024
      41.91   24.892  48.768]
    (0.220668, 0.66594665, 0.67485792)
    2012
    [  9.652  49.276   0.254  33.274  45.212   9.652 126.746   9.144  57.658
      36.576   7.112  12.954]
    (0.25187832, 0.71827158, 0.67872193)
    2013
    [  6.858  28.702  43.688 105.156  67.564  15.494  26.162  35.56  461.264
      56.896   7.366  12.7  ]
    (0.30835665, 0.77407636, 0.67833512)
    2014
    [ 42.418  17.272  41.148  47.498 112.522  21.336 116.078  40.64   73.152
      29.464  22.352  34.798]
    (0.40634556, 0.81991799, 0.67686215)
    2015
    [  9.652  93.726   9.652 114.3   198.628  44.704  75.692   7.874   3.556
      51.308  46.482  28.194]
    (0.54578602, 0.8544913, 0.69848331)
    2016
    [ 9.398 36.576 97.536 84.836 51.054 60.198 15.494 26.924 11.43   9.652
     11.938 23.114]
    (0.67097934, 0.88687758, 0.74631123)
    2017
    [ 35.814  18.542  36.83   80.01  159.766  11.43   33.02   41.148  48.768
      61.468  14.478  17.272]
    (0.77647029, 0.921603, 0.81855729)



{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/06-numpy-arrays/2019-08-01-numpy-arrays-landing-page/2019-08-01-numpy-arrays-landing-page_7_1.png">

</figure>





{:.output}
{:.display_data}

<figure>

<img src = "{{ site.url }}/images/courses/ea-bootcamp/06-numpy-arrays/2019-08-01-numpy-arrays-landing-page/2019-08-01-numpy-arrays-landing-page_8_0.png">

</figure>






