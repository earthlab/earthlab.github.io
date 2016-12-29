## ----load-libraries------------------------------------------------------
# set your working directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots
library(plotly) # create cool interactive plots

# set strings as factors to false
options(stringsAsFactors = FALSE)

## ----import-discharge-2--------------------------------------------------

discharge <- read.csv("data/flood-co-2013/discharge/06730200-Discharge_Daily_1986-2013.csv",
                      header=TRUE)

# view first 6 lines of data
head(discharge)


## ----view-data-structure-------------------------------------------------
# view structure of data
str(discharge)

# view class of the disValue column
class(discharge$disValue)

# view class of the datetime column
class(discharge$datetime)

## ----convert-time--------------------------------------------------------

# convert to date class -
discharge$datetime <- as.Date(discharge$datetime, format="%m/%d/%y")

# recheck data structure
str(discharge)


## ----no-data-values------------------------------------------------------
# check total number of NA values
sum(is.na(discharge$datetime))

# view distribution of values
hist(discharge$disValue)
summary(discharge$disValue)


## ----plot-flood-data-----------------------------------------------------
# check out our date range
min(discharge$datetime)
max(discharge$datetime)

stream_discharge_30yrs  <- ggplot(discharge, aes(datetime, disValue)) +
              geom_point() +
              ggtitle("Stream Discharge (CFS) - Boulder Creek, 1986-2016") +
              xlab("Year") + ylab("Discharge (CFS)")

stream_discharge_30yrs


## ----define-time-subset--------------------------------------------------

# Define Start and end times for the subset as R objects that are the time class
startTime <- as.Date("2013-08-15")
endTime <- as.Date("2013-10-15")

# create a start and end time R object
start_end <- c(startTime,endTime)
start_end

# plot the data - Aug 15-October 15
stream.discharge_3mo <- ggplot(discharge,
          aes(datetime,disValue)) +
          geom_point() +
          scale_x_date(limits=start_end) +
          xlab("Month / Day") + ylab("Discharge (Cubic Feet per Second)") +
          ggtitle("Daily Stream Discharge (CFS) for Boulder Creek 8/15 - 10/15 2013")

stream.discharge_3mo


