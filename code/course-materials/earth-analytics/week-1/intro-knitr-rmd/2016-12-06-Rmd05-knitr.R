## ----plot-data, eval=F---------------------------------------------------
## 
## # load the ggplot2 library for plotting
## library(ggplot2)
## 
## # download data from figshare
## # note that we are downloading  the data into your working directory (earth-analytics)
## download.file(url = "https://ndownloader.figshare.com/files/7010681",
##               destfile = "data/boulder-precip.csv")
## 
## # import data
## boulder_precip <- read.csv(file="data/boulder-precip.csv")
## 
## # view first few rows of the data
## head(boulder_precip)
## 
## # when we download the data we create a dataframe
## # view each column of the data frame using it's name (or header)
## boulder_precip$DATE
## 
## # view the precip column
## boulder_precip$PRECIP
## 
## # q plot stands for quick plot. Let's use it to plot our data
## qplot(x=boulder_precip$DATE,
##       y=boulder_precip$PRECIP)
## 

## ----render-plot, echo=F, fig.cap="Precipitation over time"--------------

# load ggplot library for plotting
library(ggplot2)

# import data
boulder_precip <- read.csv(file="data/boulder-precip.csv")

# q plot stands for quick plot. Let's use it to plot our data
# NOTE: qplot is a function in the GGPLOT2 package
qplot(x=boulder_precip$DATE,
      y=boulder_precip$PRECIP)


