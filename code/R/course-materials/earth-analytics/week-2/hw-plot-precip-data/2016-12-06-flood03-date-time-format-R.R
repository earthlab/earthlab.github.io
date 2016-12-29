## ----import-data---------------------------------------------------------

# import the data
download.file("https://ndownloader.figshare.com/files/7270970",
              "data/week2/precip_2003_2013.csv")


## Show them the code below to assign to NA OR refer to lesson on importing with NA specified.

# import the data
precip_2003_2013 <- read.csv("data/week2/precip_2003_2013.csv")

# have to tell them the data are in the HPCP column
# view the structure of the data. What does the date field look like?

str(precip_2003_2013)
# ?strptime

# specify the format
#year date month?

# convert the date field to a data class
# they will need to look at the date to see there are no dashes in it.
precip_2003_2013$DATE <- as.Date(precip_2003_2013$DATE, format = "%Y%d%m")

precip_2003_2013$DATE <- as.Date(precip_2003_2013$DATE, # convert to Date class
                                  format="%Y%m%d %H:%M")
                                  #DATE in the format: YearMonthDay Hour:Minute

# check out min and max data values
min(precip_2003_2013$HPCP, na.rm=T)
max(precip_2003_2013$HPCP, na.rm=T)

# looks like we need to remove NA values
precip_2003_2013$HPCP[precip_2003_2013$HPCP == 999.99] <- NA

# aggregate the Precipitation (PRECIP) data by DATE
precip_2003_2013_daily <- aggregate(precip_2003_2013$HPCP,   # data to aggregate
	          by=list(precip.boulder$DATE),  # variable to aggregate by
	          FUN=sum,   # take the sum (total) of the precip
          	na.rm=TRUE)  # if there are NA values, ignore them

# add month
precip_2003_2013_daily$month <- format(precip_2003_2013_daily$DATE, "%m")
precip_2003_2013_daily$year <- format(precip_2003_2013_daily$DATE, "%Y")

library(lubridate)
precip_2003_2013_daily$julian <- yday(precip_2003_2013_daily$DATE)


names(precip_2003_2013_daily) <- c("DATE", "PRECIP")

write.csv(precip_2003_2013_daily,
          file="data/week2/precip_2003_2013daily.csv", sep=",")


# plot the data
ggplot(precip_2003_2013_daily, aes(x=julian, y=PRECIP)) +
  geom_point() + facet_wrap(~ year)



