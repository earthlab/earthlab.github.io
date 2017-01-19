## ----load-libraries, echo=F----------------------------------------------

# setwd("working-dir-path-here")

# load packages
library(ggplot2)
library(dplyr)

options(stringsAsFactors = FALSE)


## ----import-precip, echo=F-----------------------------------------------

# import precip data into R data.frame
precip.boulder <- read.csv("data/flood-co-2013/precip/805325-precip_daily_2003-2013.csv",
                           header = TRUE)
precip.boulder <- read.csv("data/flood-co-2013/precip/805333-precip_daily_1948-2013.csv",
                           header = TRUE)

# view first 6 lines of the data
head(precip.boulder)

# view structure of data
str(precip.boulder)


## ----no-data-values-hist, fig.cap="histogram of data"--------------------

# histogram - would allow us to see 999.99 NA values
# or other "weird" values that might be NA if we didn't know the NA value
hist(precip.boulder$HPCP, main ="Are there NA values?")

precip.boulder <- read.csv("data/flood-co-2013/precip/805333-precip_daily_1948-2013.csv",
                           header = TRUE, na.strings = 999.99)

hist(precip.boulder$HPCP, main ="This looks better after the reimporting with\n no data values specified", xlab="value", ylab="frequency")


print("how many NA values are there?")
sum(is.na(precip.boulder))


## ----convert-date, echo=F, results='hide'--------------------------------

# convert to date/time and retain as a new field
precip.boulder$DATE <- as.POSIXct(precip.boulder$DATE,
                                  format="%Y%m%d %H:%M")
                                  # date in the format: YearMonthDay Hour:Minute

# double check structure
str(precip.boulder$DATE)


## ----plot-precip-hourly, echo=F------------------------------------------

# plot the data using ggplot2
precPlot_hourly <- ggplot(data=precip.boulder,  # the data frame
      aes(DateTime, HPCP)) +   # the variables of interest
      geom_bar(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 2003-2013")  # add a title

precPlot_hourly


## ----daily-summaries-----------------------------------------------------


# use dplyr
daily_sum_precip <- precip.boulder %>%
  mutate(day = as.Date(DATE, format="%Y-%m-%d"))

# let's look at the new column
head(daily_sum_precip$day)

precPlot_daily1 <- ggplot(data=precip.boulder,  # the data frame
      aes(DATE, HPCP)) +   # the variables of interest
      geom_bar(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Daily Precipitation - Boulder Station\n 2003-2013")  # add a title

precPlot_daily1


## ----daily-summ----------------------------------------------------------

# use dplyr
daily_sum_precip <- precip.boulder %>%
  mutate(day = as.Date(DATE, format="%Y-%m-%d")) %>%
  group_by(day) %>%
  summarise(total_precip=mean(HPCP))

# how large is the resulting data frame?
nrow(daily_sum_precip)

# view the results
head(daily_sum_precip)

# view column names
names(daily_sum_precip)


## ----daily-prec-plot, echo=F---------------------------------------------

# plot daily data
precPlot_daily <- ggplot(daily_sum_precip, aes(day, total_precip)) +
      geom_bar(stat="identity") +
      xlab("Date") + ylab("Precipitation (inches)") +
      ggtitle("Daily Precipitation - Boulder Station\n 2003-2013")

precPlot_daily

## ----subset-data---------------------------------------------------------

# use dplyr
daily_sum_precip_subset <- daily_sum_precip %>%
  filter(day >= as.Date('2003-08-15') & day <= as.Date('2013-12-31'))


# create new plot
precPlot_30yrs <- ggplot(daily_sum_precip_subset, aes(day, total_precip)) +
  geom_bar(stat="identity") +
  xlab("Date") + ylab("Precipitation (inches)") +
  ggtitle("Daily Total Precipitation Aug - Oct 2013 for Boulder Creek")

precPlot_30yrs


## ----inches--------------------------------------------------------------

# convert from 100th inch by dividing by 100
precip.boulder$PRECIP<-precip.boulder$HPCP/100

# view & check to make sure conversion occured
head(precip.boulder)


