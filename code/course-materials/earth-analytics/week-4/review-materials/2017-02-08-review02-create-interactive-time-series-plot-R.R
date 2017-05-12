## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ----load-libraries------------------------------------------------------
# install plotly from git - ropensci
#devtools::install_github('ropensci/plotly')

# load libraries
library(ggplot2)
library(xts)
library(dygraphs)
library(plotly)

options(stringsAsFactors = FALSE)

## ----import-data---------------------------------------------------------
discharge_time <- read.csv("data/week2/discharge/06730200-discharge-daily-1986-2013.csv")

discharge_time$datetime <- as.Date(discharge_time$datetime, format="%m/%d/%y")


## ----annual-precip, fig.cap="annual precipation patterns"----------------
annual_precip <- ggplot(discharge_time, aes(x=datetime, y=disValue)) +
  geom_point() +
  labs(x = "Time", 
       y = "discharge value",
       title = "my title")

annual_precip

## ----interactive-plot, warning=FALSE, message=FALSE, eval=FALSE----------
## # create interactive plotly plot
## ggplotly(annual_precip)
## 

## ----echo=FALSE, eval=FALSE----------------------------------------------
## library(htmlwidgets)
## plotly_annual_precip <- ggplotly(annual_precip)
## # save widget
## saveWidget(widget=plotly_annual_precip, file="plotly_precip.html", selfcontained=FALSE)

## ----pressure------------------------------------------------------------
# interactive time series
library(dygraphs)
# create time series objects (class xs)
library(xts)

# create time series object
discharge_timeSeries <- xts(x = discharge_time$disValue,
                            order.by = discharge_time$datetime)



## ----eval=FALSE----------------------------------------------------------
## # create a basic interactive element
## interact_time <- dygraph(discharge_timeSeries)
## interact_time

## ----echo=FALSE, eval=FALSE----------------------------------------------
## # save widget
## saveWidget(widget=interact_time, file="basic_time_interactive.html", selfcontained=FALSE)

## ----interactive-plot-2, eval=F------------------------------------------
## # create a basic interactive element
## interact_time2 <- dygraph(discharge_timeSeries) %>% dyRangeSelector()
## interact_time2

## ----echo=FALSE, eval=FALSE----------------------------------------------
## # save widget
## saveWidget(widget=interact_time2, file="time_interactive2.html", selfcontained=FALSE)

