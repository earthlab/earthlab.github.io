## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(RCurl)

## ---- eval=FALSE---------------------------------------------------------
## # download text file to a specified location on our computer
## download.file(url = "https://ndownloader.figshare.com/files/7010681",
##               destfile = "data/week10/boulder-precip-aug-oct-2013.csv")

## ----boulder-precip, fig.cap="Boulder precip data plot."-----------------
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


## ----import-plot-data, fig.cap="boulder precip from figshare plot. "-----
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
the_url <- "http://data.princeton.edu/wws509/datasets/effort.dat"
the_data <- read.table(the_url)
head(the_data)

## ----import-dat-file-rcurl-----------------------------------------------
the_url <- "http://data.princeton.edu/wws509/datasets/effort.dat"
the_data <- getURL(the_url)
# read in the data
birth_rates <- read.table(textConnection(the_data))


## ------------------------------------------------------------------------
str(birth_rates)
head(birth_rates)

## ----birth-rates, fig.cap="Birth rates example"--------------------------
ggplot(birth_rates, aes(x=effort, y=change)) +
  geom_point() +
      labs(x="Effort",
           y="Percent Change",
           title="Decline in birth rate vs. planning effort",
           subtitle = "For 20 Latin America Countries")


## ----all-data, echo=FALSE, fig.cap="Prof salary data by sex"-------------
#http://data.princeton.edu/wws509/datasets/#salary
salary_data <- read.table("http://data.princeton.edu/wws509/datasets/salary.dat",
                          header = TRUE)

ggplot(salary_data, aes(x=yr, y=sl, col=sx)) +
  geom_point() +
      labs(x="Experience (years)",
           y="Salary (US dollars)",
           title="Annual Salary by Experience",
           subtitle = "For 52 Small college tenure track professors")

## ----facet-by-rank, echo=FALSE, fig.cap="GGPLOT of salary by experience"----

ggplot(salary_data, aes(x=yr, y=sl, col=sx)) +
  geom_point() +
      labs(x="Experience (years)",
           y="Salary (US dollars)",
           title="Annual Salary by Experience",
           subtitle = "For 52 Small college tenure track professors") +
    facet_wrap(~rk)

## ----all-data-lm, echo=FALSE, fig.cap="GGPLOT of gapminder data - life expectance by continent by sex"----
ggplot(salary_data, aes(x=yr, y=sl, col=sx)) +
  geom_point() +
      labs(x="Experience (years)",
           y="Salary (US dollars)",
           title="Annual Salary by Experience",
           subtitle = "For 52 Small college tenure track professors") +
  geom_smooth(method=lm,   # Add linear regression lines
                se=FALSE)

