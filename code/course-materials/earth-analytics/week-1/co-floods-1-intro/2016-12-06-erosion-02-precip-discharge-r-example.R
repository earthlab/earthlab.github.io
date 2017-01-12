## ----load-libraries, echo=FALSE, message=FALSE, results=FALSE, warning=FALSE----
# set your working directory
# setwd("working-dir-path-here")

# load packages
library(ggplot2) # create efficient, professional plots


# set strings as factors to false for everything!
options(stringsAsFactors = FALSE)

#download.file(url = "https://ndownloader.figshare.com/files/7270970",
#              "data/week1/805325-precip_daily_2003-2013.csv")

# import precip data into R data.frame
precip_boulder <- read.csv("data/week1/805325-precip_daily_2003-2013.csv",
                           header = TRUE)


# convert to date/time and retain as a new field
precip_boulder$DateTime <- as.POSIXct(precip_boulder$DATE,
                                  format="%Y%m%d %H:%M")

# assign NoData values to NA
precip_boulder$HPCP[precip_boulder$HPCP==999.99] <- NA



## ----daily-summaries, echo=FALSE, message=FALSE, results=FALSE, warning=FALSE, fig.cap="plot 1"----

# convert DATE to a Date class
# (this will strip the time, but that is saved in DateTime)
precip_boulder$DATE <- as.Date(precip_boulder$DateTime, # convert to Date class
                                  format="%Y%m%d %H:%M")
                                  #DATE in the format: YearMonthDay Hour:Minute

precPlot_daily1 <- ggplot(data=precip_boulder,  # the data frame
      aes(DATE, HPCP)) +   # the variables of interest
      geom_bar(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation") +  # label the x & y axes
      ggtitle("Daily Precipitation - Boulder Station\n 2003-2013")  # add a title

precPlot_daily1


## ----subset-data, echo=FALSE, message=FALSE, results=FALSE, fig.cap="plot 2 precip"----

# subset 2 months around flood
precip_boulder_AugOct <- precip_boulder %>%
                        filter(DATE >= as.Date('2013-08-15') & DATE <= as.Date('2013-10-15'))


# create new plot
precPlot_flood2 <- ggplot(data=precip_boulder_AugOct, aes(DATE, HPCP)) +
  geom_bar(stat="identity") +
  xlab("Date") + ylab("Precipitation") +
  ggtitle("Daily Total Precipitation Aug - Oct 2013 for Boulder Creek")

precPlot_flood2


## ----all-boulder-station-data, echo=FALSE, message=FALSE, results=FALSE, warning=FALSE, fig.cap="plot 3 discharge"----

download.file(url = "https://ndownloader.figshare.com/files/7271003",
                "data/week1/805333-precip_daily_1948-2013.csv")

# read in data
prec.boulder.all <- read.csv("data/week1/805333-precip_daily_1948-2013.csv",
                           stringsAsFactors = FALSE,
                           header = TRUE)

# assing NoData values to NA
prec.boulder.all$HPCP[prec.boulder.all$HPCP==999.99] <- NA

# format date/time
prec.boulder.all$DateTime <- as.POSIXct(prec.boulder.all$DATE,
                                  format="%Y%m%d %H:%M")
                                  #Date in the format: YearMonthDay Hour:Minute

# create a year-month variable to aggregate to monthly precip
prec.boulder.all$YearMon  = strftime(prec.boulder.all$DateTime, "%Y/%m")

# aggregate by month
prec.boulder.all_monthly <-aggregate(prec.boulder.all$HPCP,   # data to aggregate
																 by=list(prec.boulder.all$YearMon),  # variable to aggregate by
																 FUN=sum,   # take the sum (total) of the precip
																 na.rm=TRUE)  # if the are NA values ignore them
												# if this is FALSE any NA value will prevent a value be totalled

# rename the columns
names(prec.boulder.all_monthly)[names(prec.boulder.all_monthly)=="Group.1"] <- "DATE"
names(prec.boulder.all_monthly)[names(prec.boulder.all_monthly)=="x"] <- "PRECIP"

# re-format YearMon to a Date so x-axis looks good
prec.boulder.all_monthly$DATE <- paste(prec.boulder.all_monthly$DATE,"/01",sep="")
prec.boulder.all_monthly$DATE <- as.Date(prec.boulder.all_monthly$DATE)

# plot data
precPlot_all <- ggplot(data=prec.boulder.all_monthly, aes(DATE,PRECIP)) +
	geom_bar(stat="identity") +
  xlab("Date") + ylab("Precipitation (units)") +
  ggtitle("Total Monthly Precipitation \n Boulder, CO Station")

precPlot_all



