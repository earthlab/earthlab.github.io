## ----plot-data-----------------------------------------------------------

# load the ggplot2 library for plotting
library(ggplot2)

# download data from figshare
# note that we are downloaded the data into your
#download.file(url = "https://ndownloader.figshare.com/files/7010681",
#              destfile = "data/boulder-precip.csv")

# import data
boulder_precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder_precip)

# when we download the data we create a dataframe
# view each column of the data frame using it's name (or header)
boulder_precip$DATE

# view the precip column
boulder_precip$PRECIP

# q plot stands for quick plot. Let's use it to plot our data
qplot(x=boulder_precip$DATE,
      y=boulder_precip$PRECIP)


## ----add-alpha, fig.cap="ggplot with blue points and alpha"--------------

ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha=.5, color = "blue")


## ----add-title, fig.cap="ggplot with labels"-----------------------------
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP)) +
    ggtitle("Precipitation - Boulder, Colorado 2013")

## ----add-title2, fig.cap="ggplot with title and labels"------------------
ggplot(data = boulder_precip,  aes(x = DATE, y = PRECIP)) +
    geom_point(alpha = 0.9, aes(color=PRECIP)) +
    ggtitle("Precipitation - Boulder, Colorado 2013") +
    xlab("x label here") + ylab("y label here")


