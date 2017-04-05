---
layout: single
title: "Access secure data connections using the RCurl R package."
excerpt: "This lesson reviews how to use functions within the RCurl package to access data on a secure (https) server in R. "
authors: ['Carson Farmer', 'Leah Wasser', 'Max Joseph']
modified: '2017-04-04'
category: [course-materials]
class-lesson: ['intro-APIs-r']
permalink: /course-materials/earth-analytics/week-10/access-gapminder-data-rcurl-r/
nav-title: 'Using RCurl functions'
week: 10
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

* Access data from a secure website using getURL() and textConnection() functions in the RCurl package.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson and the
data that we already downloaded for week 6 of the course.

</div>




```r
library(dplyr)
library(ggplot2)
library(RCurl)
```

## Download gapminder data with RCurl

Next, we will use functions in the RCurl package to download data from GitHub.
Note that this may work without RCurl but we will practice using RCurl in the examples
below. GitHub has secure (https) url's.

#### Gapminder Data

Let's grab a gapminder data subset from a secure URL located on
a GitHub website. The
<a href=" http://www.gapminder.org/about-gapminder/" target="_blank">Gapminder data</a>,
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
# grab the data!
gapminder_data_url = getURL(file_url)
```

### .tsv file format

Note that the data format that we are using here is `.tsv` - which stands for
Tab Separate Values. The difference between .tsv and .csv is the separator:

* `.csv` uses a COMMA (`,`) to separate individual values in each column and row of the data
* `.tsv` uses a TAB to separate individual values in each column / row of the data.

We can use the read.csv() function to read in the tsv format.
In this case, using `read.csv()` may also work for you. But we will use `RCurl` to
ensure data are transferred properly from the secure url.


```r
# read.csv works too
head(read.csv(file_url, sep="\t"))
##       country continent year lifeExp      pop gdpPercap
## 1 Afghanistan      Asia 1952  28.801  8425333  779.4453
## 2 Afghanistan      Asia 1957  30.332  9240934  820.8530
## 3 Afghanistan      Asia 1962  31.997 10267083  853.1007
## 4 Afghanistan      Asia 1967  34.020 11537966  836.1971
## 5 Afghanistan      Asia 1972  36.088 13079460  739.9811
## 6 Afghanistan      Asia 1977  38.438 14880372  786.1134
```

## Get Data with getURL()

Now that we have a connection to the Github `url`, we can treat it like a text
file, and read in the file using `read.csv()` via a `textConnection()` function:


```r
# Use textConnection to read content of temp as tsv
gap_data = read.csv(textConnection(gapminder_data_url))
head(gap_data)
##             country.continent.year.lifeExp.pop.gdpPercap
## 1  Afghanistan\tAsia\t1952\t28.801\t8425333\t779.4453145
## 2  Afghanistan\tAsia\t1957\t30.332\t9240934\t820.8530296
## 3   Afghanistan\tAsia\t1962\t31.997\t10267083\t853.10071
## 4  Afghanistan\tAsia\t1967\t34.02\t11537966\t836.1971382
## 5 Afghanistan\tAsia\t1972\t36.088\t13079460\t739.9811058
## 6   Afghanistan\tAsia\t1977\t38.438\t14880372\t786.11336
```

Looking at our data, we have a separator. In this case it's `\t`. We can account
for this separator with the `sep=` argument.


```r
# Use textConnection to read content of temp as tsv
gap_data <- read.csv(textConnection(gapminder_data_url),
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

Next, we can summarize and plot the data!
<!-- #tidylife -->


```r
# summarize the data - median value by content and year
summary_life_exp <-  gap_data %>%
   group_by(continent, year) %>%
   summarise(median_life = median(lifeExp))

ggplot(summary_life_exp, aes(x=year, y=median_life, colour = continent)) +
  geom_point() +
      labs(x="Continent",
           y="Life Expectancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")
## Error in eval(expr, envir, enclos): object 'year' not found
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2016-12-06-api03-rcurl-gapminder/life-by-continent-1.png" title="GGPLOT of gapminder data - life expectance by continent" alt="GGPLOT of gapminder data - life expectance by continent" width="100%" />

<!-- Should this be moved up before you plot with ggplot? -->
Notice that when we import the data from github, using `read.csv()`, it imports into
a `data.frame` format. Given it's a data.frame, we can plot the data using `ggplot()`
like we are used to.

Below, we make a boxplot of `lifeExp` by `continent`:


```r
# create box plot
ggplot(summary_life_exp,
       aes(continent, median_life)) +
      geom_boxplot()+
      labs(x="Continent",
           y="Life Expentancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")
## Error in eval(expr, envir, enclos): object 'continent' not found
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2016-12-06-api03-rcurl-gapminder/box-plot-by-continent-1.png" title="GGPLOT of gapminder data - life expectance by continent boxplot" alt="GGPLOT of gapminder data - life expectance by continent boxplot" width="100%" />

We can also create a more advanced plot - overlaying the data points on top of
our box plot. See the <a href="http://docs.ggplot2.org" target="_blank"> ggplot documentation</a> to learn more advanced `ggplot()` plotting approaches.


<!-- Looks like the outliers are plotted twice here -->

```r
ggplot(gap_data, aes(x=continent, y=lifeExp)) +
  geom_boxplot(outlier.colour="hotpink") +
  geom_jitter(position=position_jitter(width=0.1, height=0), alpha=0.25)+
      labs(x="Continent",
           y="Life Expectancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")
```

<img src="{{ site.url }}/images/rfigs/course-materials/earth-analytics/week-10/in-class/2016-12-06-api03-rcurl-gapminder/box-plot-point-jitter-1.png" title="GGPLOT of gapminder data - life expectance by continent with jitter and outliers." alt="GGPLOT of gapminder data - life expectance by continent with jitter and outliers." width="100%" />

If you are going to be grabbing a lot of `csv` files from secure `urls`, you
might want to turn the previous code into a function:


```r
read_secure_csv_file = function(url) {
  url = getURL(url)
  return(read.csv(textConnection(url)))
}
```

<i class="fa fa-lightbulb-o" aria-hidden="true"></i> **Data Tip:** The web
changes constantly! Data available via a *particular* API at a *particular* point
in time may not be available indefinitely. Considering documenting workflows carefully.
{: .notice--success}
