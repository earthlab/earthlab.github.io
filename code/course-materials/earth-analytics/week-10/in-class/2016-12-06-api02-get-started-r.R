## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
library("dplyr")
library("ggplot2")

## ---- eval=FALSE---------------------------------------------------------
## # download text file to a specified location on our computer
## download.file(url = "https://ndownloader.figshare.com/files/7010681",
##               destfile = "data/week10/boulder-precip-aug-oct-2013.csv")

## ------------------------------------------------------------------------
# read data into R
boulder_precip <- read.csv("data/week10/boulder-precip-aug-oct-2013.csv")

# fix date
boulder_precip$DATE <- as.Date(boulder_precip$DATE)
# plot data with ggplot
ggplot(boulder_precip, aes(x = DATE, y=PRECIP)) +
  geom_point() +
      labs(x="Date (2013)",
           y="Precipitation (inches)",
          title="Precipitation - Boulder, CO ",
          subtitle = "August - October 2013")


## ----import-plot-data----------------------------------------------------
boulder_precip2 <- read.csv("https://ndownloader.figshare.com/files/7010681")
# fix date
boulder_precip2$DATE <- as.Date(boulder_precip2$DATE)
# plot data with ggplot
ggplot(boulder_precip2, aes(x = DATE, y=PRECIP)) +
  geom_point() +
      labs(x="Date (2013)",
           y="Precipitation (inches)",
          title="Precipitation Data Imported with read.csv()",
          subtitle = "August - October 2013")


## ----import-dat-file-----------------------------------------------------
base = "http://data.princeton.edu/wws509"  # Base url
file = "/datasets/effort.dat"  # File name
birth_rates = read.table(paste0(base, file))

## ------------------------------------------------------------------------
# paste the base url together with the file name
paste0(base, file)

## ------------------------------------------------------------------------
str(birth_rates)
head(birth_rates)

## ------------------------------------------------------------------------
ggplot(birth_rates, aes(x=effort, y=change)) +
  geom_point() +
  ggtitle("Decline in birth rate vs. planning effort")

## ----message=FALSE-------------------------------------------------------
# Load RCurl (note cases)
library(RCurl)
# Store base url (note the secure -- https:// -- url)
file = "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/gapminder.tsv"
# grab the data!
temp = getURL(file)

## ------------------------------------------------------------------------
# read.csv works too
head(read.csv(file, sep="\t"))


## ------------------------------------------------------------------------
# Use textConnection to read content of temp as tsv
gap_data = read.csv(textConnection(temp))
head(gap_data)

## ------------------------------------------------------------------------
# Use textConnection to read content of temp as tsv
gap_data <- read.csv(textConnection(temp),
                     sep="\t")
head(gap_data)

## ------------------------------------------------------------------------
# summarize the data - median value by content and year
summary_life_exp <-  gap_data %>%
   group_by(continent, year) %>%
   summarise(median_life = median(lifeExp))

ggplot(summary_life_exp, aes(x=year, y=median_life, colour = continent)) +
  geom_point() +
      labs(x="Continent",
           y="Life Expentancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")


## ------------------------------------------------------------------------
# create box plot
ggplot(summary_life_exp,
       aes(continent, median_life)) +
      geom_boxplot()+
      labs(x="Continent",
           y="Life Expentancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")


## ------------------------------------------------------------------------
ggplot(gap_data, aes(x=continent, y=lifeExp)) +
  geom_boxplot(outlier.colour="hotpink") +
  geom_jitter(position=position_jitter(width=0.1, height=0), alpha=0.25)+
      labs(x="Continent",
           y="Life Expentancy (years)",
          title="Gapminder Data - Life Expectancy",
          subtitle = "Downloaded from Jenny Bryan's Github Page using getURL")

## ------------------------------------------------------------------------
read_secure_csv_file = function(url) {
  url = getURL(url)
  return(read.csv(textConnection(url)))
}

