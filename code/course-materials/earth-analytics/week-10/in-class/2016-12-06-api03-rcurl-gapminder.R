## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(RCurl)

## ----message=FALSE-------------------------------------------------------
# Store base url (note the secure -- https:// -- url)
file_url = "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/gapminder.tsv"
# grab the data!
gapminder_data_url = getURL(file_url)

## ------------------------------------------------------------------------
# read.csv works too
head(read.csv(file_url, sep="\t"))


## ------------------------------------------------------------------------
# Use textConnection to read content of temp as tsv
gap_data = read.csv(textConnection(gapminder_data_url))
head(gap_data)

## ------------------------------------------------------------------------
# Use textConnection to read content of temp as tsv
gap_data <- read.csv(textConnection(gapminder_data_url),
                     sep="\t")
head(gap_data)

## ----life-by-continent, fig.cap="GGPLOT of gapminder data - life expectance by continent"----
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


## ----box-plot-by-continent, fig.cap="GGPLOT of gapminder data - life expectance by continent boxplot"----
# create box plot
ggplot(summary_life_exp,
       aes(continent, median_life)) +
      geom_boxplot()+
      labs(x="Continent",
           y="Life Expentancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")


## ----box-plot-point-outliers, fig.cap="GGPLOT of gapminder data - life expectance by continent with jitter and outliers."----
ggplot(gap_data, aes(x=continent, y=lifeExp)) +
  geom_boxplot(outlier.colour="hotpink") +
      labs(x = "Continent",
           y = "Life Expectancy (years)",
           title = "Gapminder Data - Life Expectancy",
           subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")

## ----box-plot-point-jitter, fig.cap="GGPLOT of gapminder data - life expectance by continent with jitter and outliers."----
ggplot(gap_data, aes(x=continent, y=lifeExp)) +
  geom_boxplot() +
  geom_jitter(position=position_jitter(width=0.1, height=0), alpha=0.25)+
      labs(x = "Continent",
           y = "Life Expectancy (years)",
           title = "Gapminder Data - Life Expectancy",
           subtitle = "Data points overlaid on top of the box plot.")

## ------------------------------------------------------------------------
read_secure_csv_file = function(url) {
  url = getURL(url)
  return(read.csv(textConnection(url)))
}

