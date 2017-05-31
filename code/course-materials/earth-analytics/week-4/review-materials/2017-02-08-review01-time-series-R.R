## ----setup, fig.cap="plot precip data using ggplot"----------------------

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

## ----plot-ggplot, fig.cap="time series plot of precipitation 1948-2013"----
precip.boulder$HPCP_round <- round(precip.boulder$HPCP, digits = 1)

# plot the data using ggplot2
precPlot_hourly_round <- ggplot(precip.boulder, aes(DATE, HPCP_round)) +   # the variables of interest
      geom_point(stat="identity") +   # create a bar graph
      xlab("Date") + ylab("Precipitation (Inches)") +  # label the x & y axes
      ggtitle("Hourly Precipitation - Boulder Station\n 1948-2013")  # add a title

precPlot_hourly_round


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

