## ----daily-summ, eval=F, echo=F------------------------------------------
## 
## # the data processing workflow
## library(dplyr)
## library(lubridate)
## 
## # import precip data into R data.frame
## precip_boulder <- read.csv("data/flood-co-2013/precip/805325-precip_daily_2003-2013.csv",
##                            header = TRUE,
##                            na.strings = c(999.99))
## 
## # convert time
## precip_boulder$DATE <- as.Date(precip_boulder$DATE, # convert to Date class
##                                   format="%Y%m%d %H:%M")
##                                   #DATE in the format: YearMonthDay Hour:Minute
## 
## precip_boulder_daily <- precip_boulder %>%
##     group_by(DATE) %>% # summarize on the date column
##     summarize(DAILY_PRECIP = sum(HPCP, na.rm=TRUE), # sum up rainfall for each day
##               STATION = first(STATION), STATION_NAME= first(STATION_NAME),
##               ELEVATION= first(ELEVATION), LATITUDE= first(LATITUDE),
##               LONGITUDE= first(LONGITUDE))
## 
## # add a year
## precip_boulder_daily$YEAR <- format(precip_boulder_daily$DATE, "%Y")
## # add a jday
## precip_boulder_daily$JULIAN <- yday(precip_boulder_daily$DATE)
## 
## # view the results
## # head(precip_boulder_daily)
## 
## # export to daily csv
## write.csv(precip_boulder_daily, "data/week2/805325-precip_dailysum_2003-2013.csv")
## 

## ----load-libraries------------------------------------------------------
# set your working directory to the earth-analytics directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2) # efficient, professional plots
library(dplyr) # efficient data manipulation

# set strings as factors to false for everything
options(stringsAsFactors = FALSE)


## ----import-precip-------------------------------------------------------

# download the data
# download.file(url = "https://ndownloader.figshare.com/files/7283285",
#              destfile = "data/week2/805325-precip-dailysum_2003-2013.csv")

# import the data
# do we need to do something about NA VALUES?
boulder_daily_precip <- read.csv("data/week2/805325-precip-dailysum_2003-2013.csv",
         header = TRUE)


# view first 6 lines of the data
head(boulder_daily_precip)

# view structure of data
str(boulder_daily_precip)

# are there any unusual / No data values?
summary(boulder_daily_precip$DAILY_PRECIP)
max(boulder_daily_precip$DAILY_PRECIP)

## ----plot-precip-hourly, echo=F, warning=F, fig.cap="precip plot w fixed dates"----

# do we need to do something about NA VALUES?
boulder_daily_precip <- read.csv("data/week2/805325-precip-dailysum_2003-2013.csv",
         header = TRUE,
         na.strings = 999.99)


# format date
boulder_daily_precip$DATE <- as.Date(boulder_daily_precip$DATE,
                                     format="%m/%d/%y")



# plot the data using ggplot2
prec_plot_daily <- ggplot(data=boulder_daily_precip,  # the data frame
      aes(DATE, DAILY_PRECIP)) +   # the variables of interest
      geom_point() +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 2003-2013")  # add a title

prec_plot_daily


## ----subset-data---------------------------------------------------------

# subset 2 months around flood
precip_boulder_AugOct <- boulder_daily_precip %>%
                        filter(DATE >= as.Date('2013-08-15') & DATE <= as.Date('2013-10-15'))


## ----check-subset, fig.cap="precip plot subset"--------------------------
# check the first & last dates
min(precip_boulder_AugOct$DATE)
max(precip_boulder_AugOct$DATE)

# create new plot
precPlot_flood2 <- ggplot(data=precip_boulder_AugOct, aes(DATE,DAILY_PRECIP)) +
  geom_bar(stat="identity") +
  xlab("Date") + ylab("Precipitation (inches)") +
  ggtitle("Daily Total Precipitation Aug - Oct 2013 for Boulder Creek")

precPlot_flood2


## ----challenge, echo=FALSE, warning="hide", fig.cap="precip plot subset 2"----

# subset 2 months around flood
precip_boulder_AugOct_2012 <- boulder_daily_precip %>%
                        filter(DATE >= as.Date('2012-08-15') & DATE <= as.Date('2012-10-15'))

# create new plot
precPlot_flood_2012 <- ggplot(data=precip_boulder_AugOct_2012, aes(DATE,DAILY_PRECIP)) +
  geom_bar(stat="identity") +
  xlab("Date") + ylab("Precipitation (inches)") +
  ggtitle("Daily Total Precipitation Aug - Oct 2013 for Boulder Creek") +
  ylim(0,10)

precPlot_flood_2012


