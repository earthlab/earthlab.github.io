---
layout: single
title: "Access secure data connections using the RCurl R package."
excerpt: "This lesson reviews how to use functions within the RCurl package to access data on a secure (https) server in R. "
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph']
modified: '2017-06-15'
category: [course-materials]
class-lesson: ['intro-APIs-r']
permalink: /course-materials/earth-analytics/week-10/access-gapminder-data-rcurl-r/
nav-title: "Get Data From Github"
week: 10
course: "earth-analytics"
sidebar:
  nav:
author_profile: false
comments: true
order: 3
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Access data from a secure website using `read.csv()`
* Be able to describe the key difference between a `.tsv` and a `.csv` file.
* Use pipes ( `%>%` ) to send data directly to ggplot to plot!

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data that we already downloaded for week 6 of the course.

</div>




```r
# load libraries
library(dplyr)
library(ggplot2)
# optional
library(RCurl)
## Error in library(RCurl): there is no package called 'RCurl'
```

## Download gapminder data with RCurl

Next, we will download data from a secure URL. It is important to note that in
older versions of R, particularly on windows machine, you would need to use
functions in the RCUrl package that support secure url connections. Below
you can read more about using RCurl to access secure URL's. However for this lessons,
we will continue to use `read.csv()` to directly access the data given it works
for secure connections now.

<div class="notice--warning" markdown="1">

## Secure url's in R

### Use RCurl to download data from secure URLs

When you run into errors downloading data using `read.csv()`, you may need to instead
use functions in the RCurl package. RCurl is a powerful package that:

* Provides a set of tools to allow `R` to act like a *web client*
* Provides a number of helper functions to grab data files from the web

The `getURL()` function works for most secure web download protocols (e.g.,
`http(s)`, `ftp(s)`). It also helps with web scraping, direct access to web
resources, and even API data access.

### Using getURL and textConnection()

Older versions
of R, particularly running windows used to have issues with dealing with
secure (https and ftps) connetion URLs. If you encounter issues importing the
above data using `read.table()` directly, consider the following approach which
uses `getURL()` to access the URL and the `textConnection()` function to read
in text formatted data.

The RCurl `R` package, allows you to consistently access secure servers and also
has additional authentication support. To use `getURL()` to open text files we
do the following:

1. We *grab* the URL using getURL()
2. We read in the data using `read.csv()` (or `read.table()` ) via the `textConnection()` function.


```r
library(RCurl)
## Error in library(RCurl): there is no package called 'RCurl'
# Store base url (note the secure -- https:// -- url)
file_url <- "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/gapminder.tsv"
# import the url
gap_data_url <- getURL(file_url)
## Error in getURL(file_url): could not find function "getURL"
# grab the data vis textConnection
gap_data <- read.csv(textConnection(gap_data_url), sep="\t")
## Error in textConnection(gap_data_url): object 'gap_data_url' not found
head(gap_data)
## Error in head(gap_data): object 'gap_data' not found
```


Note that the `textConnection()` function tells `R` that the data that we are
accessing should be read as a text file. We are not going to use these
functions in this example given the data import just fine using `read.csv()`.

</div>

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** The syntax
`package::functionName()` is a common way to tell R to use a function from a particular
package. In the example above: we specify that we are using getURL() from the
RCurl package using the syntax: `RCurl::getURL()`. This syntax is not necessary to call
getURL UNLESS there is another `getURL()` function available in your `R` session.
{: .notice--success }

#### Gapminder Data

Let's grab a gapminder data subset from a secure URL located on
a GitHub website. The
<a href="http://www.gapminder.org/about-gapminder/" target="_blank">Gapminder data</a>,
contain a suite of census-like metrics that describe global development. The data
are ideal to experiment with when learning about plotting and working with data
in a tool like `R`.

<a href="https://twitter.com/JennyBryan" target="_blank">@jennybryan</a>
provides an `R` package to access the
<a href="http://www.gapminder.org/data/" target="_blank">Gapminder data</a> for
teaching. However, we will instead use `RCurl` to get it from
<a href="https://github.com/jennybc/gapminder" target="_blank">Jenny Bryan's Github Page</a>
to practice using RCurl functions.


```r
# Store base url (note the secure -- https:// -- url)
file_url = "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/gapminder.tsv"
# import the data!
gap_data = read.csv(file_url)
head(gap_data)
##             country.continent.year.lifeExp.pop.gdpPercap
## 1  Afghanistan\tAsia\t1952\t28.801\t8425333\t779.4453145
## 2  Afghanistan\tAsia\t1957\t30.332\t9240934\t820.8530296
## 3   Afghanistan\tAsia\t1962\t31.997\t10267083\t853.10071
## 4  Afghanistan\tAsia\t1967\t34.02\t11537966\t836.1971382
## 5 Afghanistan\tAsia\t1972\t36.088\t13079460\t739.9811058
## 6   Afghanistan\tAsia\t1977\t38.438\t14880372\t786.11336
```

Looking at our results, we notice there is a `\t` between each data element.
This is not what we would expect when we import file into R. What is going on?

### .tsv file format

Note that the data format that we are using here is `.tsv` - which stands for
Tab Separate Values. The difference between .tsv and .csv is the separator:

* `.csv` uses a COMMA (`,`) to separate individual values in each column and row of the data
* `.tsv` uses a TAB (`\t`) to separate individual values in each column / row of the data.

We can use the `read.csv()` function to read in the tsv format. However, we need
to tell R what the separator is. In this case it's `\t`. We can account
for this separator with the `sep=` argument.


```r
# Use textConnection to read content of temp as tsv
gap_data <- read.csv(file_url,
                     sep="\t")
head(gap_data)
##       country continent year lifeExp      pop gdpPercap
## 1 Afghanistan      Asia 1952  28.801  8425333  779.4453
## 2 Afghanistan      Asia 1957  30.332  9240934  820.8530
## 3 Afghanistan      Asia 1962  31.997 10267083  853.1007
## 4 Afghanistan      Asia 1967  34.020 11537966  836.1971
## 5 Afghanistan      Asia 1972  36.088 13079460  739.9811
## 6 Afghanistan      Asia 1977  38.438 14880372  786.1134
```

That looks better.

## Get Data with getURL()

IF you have issues using read.csv(), you can try the code below which uses the
RCurl library. In past versions of R, Windows users often had issues with
secure URL's in R.


```r
# Use textConnection to read content of temp as tsv
# NOTE: you may not need to use this code if read.csv works above!
gap_data = read.csv(textConnection(gapminder_data_url),
                     sep="\t")
head(gap_data)
```


Next, we can summarize and plot the data! Notice that when we import the data
from github, using `read.csv()`, it imports into a `data.frame` format. Given
it's a `data.frame`, we can plot the data using `ggplot()` like we are used to.

Below, we first summarize the data by median life expectancy per year per continent.
Then we create box plots - one for each continent.

<!-- #tidylife -->


```r
# summarize the data - median value by content and year
summary_life_exp <-  gap_data %>%
   group_by(continent, year) %>%
   summarise(median_life = median(lifeExp))

ggplot(summary_life_exp, aes(x=year, y=median_life, colour = continent)) +
  geom_point() +
      labs(x="Year",
           y="Median Life Expectancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2017-04-05-api03-get-gapminder-data-github/life-by-continent-1.png" title="GGPLOT of gapminder data - life expectance by continent" alt="GGPLOT of gapminder data - life expectance by continent" width="100%" />

### Piping data to ggplot()

Above, we used dplyr pipes to summarize the data that we wanted to plot.
A cool trick that we can use is to send our data directly to ggplot from the pipe.
This is useful if we don't need to create a new data.frame object to use in
another part of our analysis.


```r
# summarize the data - median value by content and year
gap_data %>%
   group_by(continent, year) %>%
   summarise(median_life = median(lifeExp)) %>%
   ggplot(aes(x=year, y=median_life, colour = continent)) +
      geom_point() +
      labs(x="Year",
           y="Median Life Expectancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Data piped directly into GGPLOT! Plot looks the same!")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2017-04-05-api03-get-gapminder-data-github/life-by-continent-pipes-1.png" title="GGPLOT of gapminder data - life expectance by continent piped" alt="GGPLOT of gapminder data - life expectance by continent piped" width="100%" />


Below, we make a boxplot of `lifeExp` by `continent` too. Notice in this case
we are using the dplyr output above, again. Thus it made sense above to
save our dplyr output as a new data.frame.


```r
# create box plot
ggplot(summary_life_exp,
       aes(continent, median_life)) +
      geom_boxplot()+
      labs(x="Continent",
           y="Median Life Expectancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2017-04-05-api03-get-gapminder-data-github/box-plot-by-continent-1.png" title="GGPLOT of gapminder data - life expectance by continent boxplot" alt="GGPLOT of gapminder data - life expectance by continent boxplot" width="100%" />

We can also create a more advanced plot - overlaying the data points on top of
our box plot. See the <a href="http://docs.ggplot2.org" target="_blank"> ggplot documentation</a> to learn more advanced `ggplot()` plotting approaches.


```r
ggplot(gap_data, aes(x=continent, y=lifeExp)) +
  geom_boxplot(outlier.colour="hotpink") +
      labs(x = "Continent",
           y = "Life Expectancy (years)",
           title = "Gapminder Data - Life Expectancy",
           subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2017-04-05-api03-get-gapminder-data-github/box-plot-point-outliers-1.png" title="GGPLOT of gapminder data - life expectance by continent with jitter and outliers." alt="GGPLOT of gapminder data - life expectance by continent with jitter and outliers." width="100%" />

Or create a box plot with the data points overlaid on top.


```r
ggplot(gap_data, aes(x=continent, y=lifeExp)) +
  geom_boxplot() +
  geom_jitter(position=position_jitter(width=0.1, height=0), alpha=0.25)+
      labs(x = "Continent",
           y = "Life Expectancy (years)",
           title = "Gapminder Data - Life Expectancy",
           subtitle = "Data points overlaid on top of the box plot.")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2017-04-05-api03-get-gapminder-data-github/box-plot-point-jitter-1.png" title="GGPLOT of gapminder data - life expectance by continent with jitter and outliers." alt="GGPLOT of gapminder data - life expectance by continent with jitter and outliers." width="100%" />

If you are going to grab many `.csv` files from secure `urls`, you
might need to use functions from the RCurl package. Below you will find a function
that uses `getURL()` and `textConnection()` to access data from a secure URL. The function
takes a URL as in the INPUT and returns a `data.frame` object in `R`.


```r
read_secure_csv_file <- function(url, the_sep=",") {
  url <- getURL(url)
  the_data <- read.csv(textConnection(url), sep=the_sep)
  return(the_data)
}
```

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** The web
changes constantly! Data available via a *particular* API at a *particular* point
in time may not be available indefinitely. Consider documenting workflows carefully.
{: .notice--success}
