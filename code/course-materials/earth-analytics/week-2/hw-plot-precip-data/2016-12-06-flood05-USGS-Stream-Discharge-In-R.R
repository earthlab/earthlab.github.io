## ----load-libraries------------------------------------------------------
# set your working directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots
library(dplyr) # data manipulation

# set strings as factors to false
options(stringsAsFactors = FALSE)

## ----import-discharge-2--------------------------------------------------

discharge <- read.csv("data/flood-co-2013/discharge/06730200-Discharge_Daily_1986-2013.csv",
                      header=TRUE)

# view first 6 lines of data
head(discharge)


## ----convert-time, echo=F------------------------------------------------

# convert to date class -
discharge$datetime <- as.Date(discharge$datetime, format="%m/%d/%y")

# looks like there aren't any no data values to deal with.

## ----plot-flood-data, echo=F, fig.cap="plot of discharge vs time"--------
# check out our date range
stream_discharge_30yrs  <- ggplot(discharge, aes(datetime, disValue)) +
              geom_point() +
              ggtitle("Stream Discharge (CFS) - Boulder Creek, 1986-2016") +
              xlab("Year") + ylab("Discharge (CFS)")

stream_discharge_30yrs


## ----define-time-subset, echo=F------------------------------------------

discharge_augSept_2013 <- discharge %>%
                  filter((datetime >= as.Date('2013-08-15') & datetime <= as.Date('2013-10-15')))


## ----plot-challenge, echo=F, fig.cap="ggplot subsetted discharge data"----

# plot the data - Aug 15-October 15
stream.discharge_3mo <- ggplot(discharge_augSept_2013,
          aes(datetime, disValue)) +
          geom_point() +
          xlab("Month / Day") + ylab("Discharge (Cubic Feet per Second)") +
          ggtitle("Daily Stream Discharge (CFS) for Boulder Creek 8/15 - 10/15 2013")

stream.discharge_3mo

