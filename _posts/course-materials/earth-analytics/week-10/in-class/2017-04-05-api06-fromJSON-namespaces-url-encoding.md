---
layout: single
title: "Understand namespaces in R - what package does your fromJSON() function come from?"
excerpt: "This lesson covers namespaces in R and how we can tell R where to get a function from (what code to use) in R."
authors: ['Leah Wasser']
modified: '2017-04-12'
category: [course-materials]
class-lesson: ['intro-APIs-r']
permalink: /course-materials/earth-analytics/week-10/namespaces-in-r/
nav-title: 'Namespaces in R'
week: 10
sidebar:
  nav:
author_profile: false
comments: true
order: 6
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Define what a namespace is relative to using R.
* Explicetly call a function from a particular namespace in R.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>




In this lesson, we will learn about namespaces and how they can impact function 
calls in R. 


```r
# load packages
library(ggmap)
library(ggplot2)
library(dplyr)
```



Let's start by creating an API rest call to the colorado information warehouse 
website. We used this call in the previous lesson. We know it works!



```r
# Base URL path
base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url = paste0(base_url, "county=Boulder",
             "&$where=age between 20 and 40",
             "&$select=year,age,femalepopulation")
# view full url
full_url
## [1] "https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age between 20 and 40&$select=year,age,femalepopulation"
```

Next, let's import that data using `fromJSON()`. Notice that we called the 
rjson library to use `fromJSON()`. What happens?


```r
library(rjson)
# Convert JSON to data frame
pop_proj_data_df <- fromJSON(full_url)
## Error in open.connection(con, "rb"): HTTP error 400.
```

The code above returns an error.  Notice that the URL that we have passed has space 
in it. As we did in the previous lesson, we can use the URLencode function to 
replace those spaces with ascii values (`%20`). Let's give that a try.


```r
full_url <- URLencode(full_url)
full_url
## [1] "https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age%20between%2020%20and%2040&$select=year,age,femalepopulation"
# Convert JSON to data frame
pop_proj_data_df <- fromJSON(full_url)
head(pop_proj_data_df)
##   age femalepopulation year
## 1  20             2751 1990
## 2  21             2615 1990
## 3  22             2167 1990
## 4  23             1798 1990
## 5  24             1692 1990
## 6  25             1813 1990
```



```r
library(jsonlite)
# Convert JSON to data frame
pop_proj_data_df <- fromJSON(full_url)
```



```r
# encode the URL with characters for each space.
full_url <- URLencode(full_url)
full_url
## [1] "https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age%20between%2020%20and%2040&$select=year,age,femalepopulation"
pop_proj_data_df <- fromJSON(full_url)
head(pop_proj_data_df)
##   age femalepopulation year
## 1  20             2751 1990
## 2  21             2615 1990
## 3  22             2167 1990
## 4  23             1798 1990
## 5  24             1692 1990
## 6  25             1813 1990
```
phew. what happened there?


<div class="notice--info" markdown="1">

## Additional Resources

</div>
