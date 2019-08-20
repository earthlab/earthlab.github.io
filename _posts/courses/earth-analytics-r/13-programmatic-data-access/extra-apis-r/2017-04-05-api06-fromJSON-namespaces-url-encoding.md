---
layout: single
title: "Understand Namespaces in R - What Package Does Your fromJSON() Function Come From?"
excerpt: "This lesson covers namespaces in R and how we can tell R where to get a function from (what code to use) in R."
authors: ['Leah Wasser']
modified: '2019-08-20'
category: [courses]
class-lesson: ['intro-APIs-r']
permalink: /courses/earth-analytics/get-data-using-apis/namespaces-in-r/
nav-title: 'Namespaces in R'
week: 13
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 6
topics:
  find-and-manage-data: ['apis']
redirect_from:
   - "/courses/earth-analytics/week-10/namespaces-in-r/"
---


{% include toc title = "In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Define what a namespace is relative to using `R`.
* Explicetly call a function from a particular namespace in `R`.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>




In this lesson, you will learn about namespaces and how they can impact function
calls in `R`.


```r
# load packages
library(ggmap)
library(ggplot2)
library(dplyr)
library(RCurl)
```



Let's start by creating a restful API call to the colorado information warehouse
website. You used this call in the previous lesson. You know it works!



```r
# Base URL path
base_url <- "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url <- paste0(base_url, "county=Boulder",
             "&$where=age between 20 and 40",
             "&$select=year,age,femalepopulation")
# view full url
full_url
## [1] "https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age between 20 and 40&$select=year,age,femalepopulation"
```

Next, let's import that data using `fromJSON()`. Notice that you called the
rjson library to use `fromJSON()`. What happens?


```r
library(rjson)
# Convert JSON to data frame
pop_proj_data_df <- fromJSON(full_url)

```

The code above returns an error: `Error in open.connection(con, "rb"): HTTP error 400`.  Notice that the URL that you have passed has space
in it. As you did in the previous lesson, you can use the URLencode function to
replace those spaces with ascii values (`%20`). Let's give that a try.


```r
# view url - notice spaces
full_url
# encode spaces with ascii value %20
full_url <- URLencode(full_url)
full_url
# Convert JSON api returned value to data frame
pop_proj_data_df <- fromJSON(full_url)
head(pop_proj_data_df)
```



```r
library(rjson)
# Convert JSON to data frame
# Base URL path
base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url = paste0(base_url, "county=Boulder",
             "&$where=age between 20 and 40",
             "&$select=year,age,femalepopulation")
# view full url
full_url
pop_proj_data_df <- fromJSON(full_url)
```

What happened in the code above? Above, you used the same code but got a different
error! Notice one small change - you called a new library - rjson.

Let's look at the above examples in more detail to understand why you are getting
different error messages from the SAME function `fromJSON()`. Because different people
and groups create different R packages, AND you also may create functions in your
code, the same function can exist in different packages.

You can explicitly tell `R` to use a function from a particular package using the
syntax `packageName::function()`. In this case, there are (atleast) three `R` packages that have
the same fromJSON() function:

1. RJSONIO
1. rjson
1. jsonlite

Let's see what happens when you call the same function from each package.



```r
# notice the url has spaces
full_url

pop_proj_data_df <- jsonlite::fromJSON(full_url)
pop_proj_data_df <- rjson::fromJSON(full_url)
pop_proj_data_df <- RJSONIO::fromJSON(full_url)
```

Above, notice that you get three unique errors from the same function call. 
`Error in open.connection(con, "rb"): HTTP error 400.`
`Error in rjson::fromJSON(full_url): unexpected character 'h'`
`Error in file(con, "r"): cannot open the connection to 'https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age between 20 and 40&$select=year,age,femalepopulation'`

However, each time you called the function from a different package!

Next, let's see which of these functions plays nicely if you encode the URL first,
and then try to open the data!



```r
# notice the url has spaces
full_url
## [1] "https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age between 20 and 40&$select=year,age,femalepopulation"
# encode the url
full_url_encoded <- URLencode(full_url)
full_url_encoded
## [1] "https://data.colorado.gov/resource/tv8u-hswn.json?county=Boulder&$where=age%20between%2020%20and%2040&$select=year,age,femalepopulation"


pop_proj_data_df <- jsonlite::fromJSON(full_url_encoded)
head(pop_proj_data_df)
##   year age femalepopulation
## 1 1990  20             2751
## 2 1990  21             2615
## 3 1990  22             2167
## 4 1990  23             1798
## 5 1990  24             1692
## 6 1990  25             1813
```

Looks like it works when you use fromJSON from the jsonlite package. How about the
rjson package?



```r
pop_proj_data_df1 <- rjson::fromJSON(full_url_encoded)
```

The above example still doesn't work, even when you encode your url string: `Error in rjson::fromJSON(full_url_encoded): unexpected character 'h'`. What happens if you use getURL to grab the URL?


```r
pop_proj_geturl <- getURL(full_url_encoded)
pop_proj_data_df1 <- rjson::fromJSON(pop_proj_geturl)
head(pop_proj_data_df1, n = 2)
## [[1]]
## [[1]]$year
## [1] "1990"
## 
## [[1]]$age
## [1] "20"
## 
## [[1]]$femalepopulation
## [1] "2751"
## 
## 
## [[2]]
## [[2]]$year
## [1] "1990"
## 
## [[2]]$age
## [1] "21"
## 
## [[2]]$femalepopulation
## [1] "2615"
```

Well the above works WHEN you first use the getURL() function from the RCurl package!
However, it returns a list rather than a data.frame with columns and rows. In this
case, you have to change your workflow. You need to convert the list to a data.frame.

You can do that using do.call on the rbind.data.frame() function as follows:


```r
pop_proj_df_convert <- do.call(rbind.data.frame, pop_proj_data_df1)
head(pop_proj_df_convert)
##      year age femalepopulation
## 2    1990  20             2751
## 2100 1990  21             2615
## 3    1990  22             2167
## 4    1990  23             1798
## 5    1990  24             1692
## 6    1990  25             1813
```

That works - but it made us use additional code. Seems like the jsonlite example
is your best path forward! This is especially true given you will have nested
data.frames in the lessons to follow and it's easy to deal with those in a data.frame
format!


```r
pop_proj_data_df2 <- RJSONIO::fromJSON(full_url_encoded)
head(pop_proj_data_df2, n = 2)
## [[1]]
##             year              age femalepopulation 
##           "1990"             "20"           "2751" 
## 
## [[2]]
##             year              age femalepopulation 
##           "1990"             "21"           "2615"
```

Here you see different results jet from the RJSONIO package. You would need to once
again convert a list to a data.frame. You get the idea...

The takeaway from all of this is that you need to be aware of what packages
you have loaded in your environment and the potential for several functions to
'conflict'. The best work around in this case is to be explicit about what
package you want to call your function from. Example:

`jsonlite::fromJSON()` rather than simply using fromJSON().


<div class="notice--info" markdown="1">

## Additional Resources

* <a href="http://blog.obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff/" target="_blank">More on namespaces and environments in R</a>
</div>
