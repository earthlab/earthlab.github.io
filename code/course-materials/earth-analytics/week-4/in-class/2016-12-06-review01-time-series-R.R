## ----setup---------------------------------------------------------------
library(ggplot2)
# bonus lesson
precip_file <- "data/week2/precipitation/805333-precip-daily-1948-2013.csv"

# import precip data into R data.frame
precip.boulder <- read.csv(precip_file,
                           header = TRUE,
                           na.strings = 999.99)

# convert to date/time and retain as a new field
precip.boulder$DATE <- as.POSIXct(precip.boulder$DATE,
                                  format="%Y%m%d %H:%M")
                                  # date in the format: YearMonthDay Hour:Minute

# double check structure
str(precip.boulder$DATE)

# plot the data using ggplot2
precPlot_hourly <- ggplot(precip.boulder, aes(DATE, HPCP)) +   # the variables of interest
      geom_point(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 1948-2013")  # add a title

precPlot_hourly

## ----interactive-plot, warning=F, message=F, eval=F----------------------
## library(plotly)
## 
## ggplotly(precPlot_hourly)
## 

## ----plot-ggplot---------------------------------------------------------
precip.boulder$HPCP_round <- round(precip.boulder$HPCP, digits = 1)

# plot the data using ggplot2
precPlot_hourly_round <- ggplot(precip.boulder, aes(DATE, HPCP_round)) +   # the variables of interest
      geom_point(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 1948-2013")  # add a title

precPlot_hourly_round


## ----pressure, echo=FALSE, eval=F----------------------------------------
## # interactive time series
## library(dygraphs)
## # create time series objects (class xs)
## library(xts)
## options(stringsAsFactors = F)
## 
## 
## discharge_time <- read.csv("data/week2/discharge/06730200-discharge-daily-1986-2013.csv")
## 
## discharge_time$datetime <- as.Date(discharge_time$datetime, format="%m/%d/%y")
## # create time series object
## discharge_timeSeries <- xts(x = discharge_time$disValue,
##                             order.by = discharge_time$datetime)
## 
## # create a basic interactive element
## dygraph(discharge_timeSeries)

## ----interactive-plot-2, eval=F------------------------------------------
## # create a basic interactive element
## dygraph(discharge_timeSeries) %>% dyRangeSelector()
## 

## ----factors-------------------------------------------------------------

new_vector <- c("dog", "cat", "mouse","cat", "mouse", "cat", "mouse")
str(new_vector)

new_vector <- factor(new_vector)
str(new_vector)

# set the order
fa_levels <- c("dog", "cat", "mouse")
# reorder factors
new_vector_reordered = factor(new_vector,
           levels = fa_levels)
new_vector_reordered

