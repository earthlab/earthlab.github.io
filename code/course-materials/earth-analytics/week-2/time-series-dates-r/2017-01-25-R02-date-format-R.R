## ----import-data, fig.cap="quick plot of precip data"--------------------
# load the ggplot2 library for plotting
library(ggplot2)

# download data from figshare
# note that we already downloaded the data in the previous exercises so this line
# is commented out. If you want to redownload the data, umcomment the line below.
# download.file(url = "https://ndownloader.figshare.com/files/7010681",
#             destfile = "data/boulder-precip.csv")

# import data
boulder_precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder_precip)

qplot(x=boulder_precip$DATE,
      y=boulder_precip$PRECIP)

## ----ggplot-plot, fig.cap="ggplot of precip data"------------------------
# plot the data using ggplot
ggplot(data=boulder_precip, aes(x=DATE, y=PRECIP)) +
  geom_point() +
  glabs(x="Date",
    y="Total Precipitation (Inches)",
    title="Precipitation Data",
    subtitle="Boulder, Colorado 2013")


## ----structure-----------------------------------------------------------
str(boulder_precip)


## ----view-class----------------------------------------------------------
# View data class for each column that we wish to plot
class(boulder_precip$DATE)

class(boulder_precip$PRECIP)


## ----convert-date-time---------------------------------------------------
# convert date column to date class
boulder_precip$DATE <- as.Date(boulder_precip$DATE,
                        format="%Y-%m-%d")

# view R class of data
class(boulder_precip$DATE)

# view results
head(boulder_precip$DATE)

## ----qplot-data, fig.cap="precip bar plot"-------------------------------
# quickly plot the data and include a title using main=""
# In title string we can use '\n' to force the string to break onto a new line

ggplot(data=boulder_precip, aes(x=DATE, y=PRECIP)) +
      geom_bar(stat="identity") +
      ggtitle("Precipitation")


