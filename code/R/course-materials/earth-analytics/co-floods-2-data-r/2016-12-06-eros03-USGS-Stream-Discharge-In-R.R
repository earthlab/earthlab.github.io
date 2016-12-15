## ----load-libraries------------------------------------------------------
# set your working directory
#setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots
library(plotly) # create cool interactive plots

# set strings as factors to false
options(stringsAsFactors = FALSE)

## ----import-discharge-2--------------------------------------------------

#import data
# discharge <- read.csv("disturb-events-co13/discharge/06730200-discharge_daily_1986-2013.txt",
#                        sep="\t",
#                        skip=24,
#                        header=TRUE)

discharge <- read.csv("disturb-events-co13/discharge/06730200-discharge_daily_1986-2016.txt",
                      sep="\t",
                      skip=26,
                      header=TRUE)

# view first 6 lines of data
head(discharge)


## ----remove-second-header------------------------------------------------
# nrow: how many rows are in the R object
nrow(discharge)

# remove the first line from the data frame (which is a second list of headers)
# the code below selects all rows beginning at row 2 and ending at the total
# number of rows.
discharge <- discharge[2:nrow(discharge),]

## ----rename-headers------------------------------------------------------
# view column headers
names(discharge)

# rename the fifth column to disValue representing discharge value
names(discharge)[4] <- "disValue"
names(discharge)[5] <- "qualCode"

# view revised column headers
names(discharge)


## ----view-data-structure-------------------------------------------------
# view structure of data
str(discharge)


## ----adjust-data-structure-----------------------------------------------
# view class of the disValue column
class(discharge$disValue)

# convert column to integer
discharge$disValue <- as.integer(discharge$disValue)

str(discharge)


## ----convert-time--------------------------------------------------------
# view class
class(discharge$datetime)

# convert to date/time class - POSIX
discharge$datetime <- as.POSIXct(discharge$datetime)

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

stream.discharge.30yrs  <- ggplot(discharge, aes(datetime, disValue)) +
              geom_point() +
              ggtitle("Stream Discharge (CFS) - Boulder Creek, 1986-2016") +
              xlab("Year") + ylab("Discharge (CFS)")

stream.discharge.30yrs


## ----define-time-subset--------------------------------------------------

# Define Start and end times for the subset as R objects that are the time class
startTime <- as.POSIXct("2013-08-15 00:00:00")
endTime <- as.POSIXct("2013-10-15 00:00:00")

# create a start and end time R object
start.end <- c(startTime,endTime)
start.end

# plot the data - Aug 15-October 15
stream.discharge.3mo <- ggplot(discharge,
          aes(datetime,disValue)) +
          geom_point() +
          scale_x_datetime(limits=start.end) +
          xlab("Month / Day") + ylab("Discharge (Cubic Feet per Second)") +
          ggtitle("Daily Stream Discharge (CFS) for Boulder Creek 8/15 - 10/15 2013")

stream.discharge.3mo


## ----plotly-discharge-data-----------------------------------------------

# subset out some of the data - Aug 15 - October 15
discharge.aug.oct2013 <- subset(discharge,
                        datetime >= as.POSIXct('2013-08-15 00:00',
                                              tz = "America/Denver") &
                        datetime <= as.POSIXct('2013-10-15 23:59',
                                              tz = "America/Denver"))

# plot the data
disPlot.plotly <- ggplot(data=discharge.aug.oct2013,
        aes(datetime,disValue)) +
        geom_point(size=3)     # makes the points larger than default

disPlot.plotly

# add title and labels
disPlot.plotly <- disPlot.plotly +
	theme(axis.title.x = element_blank()) +
	xlab("Time") + ylab("Stream Discharge (CFS)") +
	ggtitle("Stream Discharge - Boulder Creek 2013")

disPlot.plotly

# view plotly plot in R
ggplotly(disPlot.plotly)

## ----pub-plotly, eval=FALSE----------------------------------------------
## # set username
## Sys.setenv("plotly_username"="yourUserNameHere")
## # set user key
## Sys.setenv("plotly_api_key"="yourUserKeyHere")
## 
## # publish plotly plot to your plotly online account if you want.
## plotly_POST(disPlot.plotly)
## 

