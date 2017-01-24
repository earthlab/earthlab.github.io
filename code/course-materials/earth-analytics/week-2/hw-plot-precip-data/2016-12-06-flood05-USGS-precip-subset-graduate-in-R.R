## ----load-libraries, echo=F----------------------------------------------

# setwd("working-dir-path-here")

# load packages
library(ggplot2)
library(dplyr)

options(stringsAsFactors = FALSE)


## ----import-precip, echo=F-----------------------------------------------

#precip_file <- "data/flood-co-2013/precip/805325-precip_daily_2003-2013.csv"
precip_file <- "data/week2/precipitation/805333-precip-daily-1948-2013.csv"

# import precip data into R data.frame
precip.boulder <- read.csv(precip_file,
                           header = TRUE)

# view first 6 lines of the data
head(precip.boulder)

# view structure of data
str(precip.boulder)


## ----no-data-values-hist, echo=F, fig.cap="histogram of data"------------
#plot histogram
hist(precip.boulder$HPCP, main ="Are there NA values?")

precip.boulder <- read.csv(precip_file,
                           header = TRUE, na.strings = 999.99)

hist(precip.boulder$HPCP, main ="This looks better after the reimporting with\n no data values specified", xlab="Precip (inches)", ylab="Frequency")



## ----how-many-na---------------------------------------------------------
print("how many NA values are there?")
sum(is.na(precip.boulder))

## ----convert-date, echo=F, results='hide'--------------------------------

# convert to date/time and retain as a new field
precip.boulder$DATE <- as.POSIXct(precip.boulder$DATE,
                                  format="%Y%m%d %H:%M")
                                  # date in the format: YearMonthDay Hour:Minute

# double check structure
str(precip.boulder$DATE)


## ----plot-precip-hourly, echo=F, fig.cap="hourly precipitation"----------

# plot the data using ggplot2
precPlot_hourly <- ggplot(precip.boulder, aes(DATE, HPCP)) +   # the variables of interest
      geom_point(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 1948-2013")  # add a title

precPlot_hourly


## ----plot-precip-hourly-round, echo=F, fig.cap="hourly precipitation"----
# round precip
precip.boulder$HPCP_round <- round(precip.boulder$HPCP, digits = 1)

# plot the data using ggplot2
precPlot_hourly_round <- ggplot(precip.boulder, aes(DATE, HPCP_round)) +   # the variables of interest
      geom_point(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 1948-2013")  # add a title

precPlot_hourly_round


## ----daily-summaries-----------------------------------------------------
# use dplyr
daily_sum_precip <- precip.boulder %>%
  mutate(day = as.Date(DATE, format="%Y-%m-%d"))   # create a new column called day w the date


# let's look at the new column
head(daily_sum_precip$day)


## ----plot-daily, echo=F, warning=F, fig.cap="Daily precip plot"----------
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
  group_by(day) %>% # group by the day column
  summarise(total_precip=sum(HPCP)) # calculate the SUM of all precipitation that occured on each day

# how large is the resulting data frame?
nrow(daily_sum_precip)

# view the results
head(daily_sum_precip)

# view column names
names(daily_sum_precip)


## ----daily-prec-plot, echo=F, warning=F, fig.cap="Daily precipitation for boulder"----
# plot daily data
precPlot_daily <- ggplot(daily_sum_precip, aes(day, total_precip)) +
      geom_bar(stat="identity") +
      xlab("Date") + ylab("Precipitation (inches)") +
      ggtitle("Daily Precipitation - Boulder Station\n 2003-2013")

precPlot_daily

## ----subset-data, echo=F, warning='hide', fig.cap="final precip plot daily sum"----

# use dplyr
daily_sum_precip_subset <- daily_sum_precip %>%
  filter(day >= as.Date('2012-12-31') & day <= as.Date('2013-12-31'))


# create new plot
precPlot_30yrs <- ggplot(daily_sum_precip_subset, aes(day, total_precip)) +
  geom_bar(stat="identity") +
  xlab("Date") + ylab("Precipitation (inches)") +
  ggtitle("Daily Total Precipitation 2012 - 2013 for Boulder Creek")

precPlot_30yrs


