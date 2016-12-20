## ----plot-data, eval=F---------------------------------------------------
## 
## # load the ggplot2 library for plotting
## library(ggplot2)
## 
## # download data from figshare
## # note that we are downloaded the data into your
## download.file(url = "https://ndownloader.figshare.com/files/7010681",
##               destfile = "data/boulder-precip.csv")
## 
## # import data
## boulder.precip <- read.csv(file="data/boulder-precip.csv")
## 
## # view first few rows of the data
## head(boulder.precip)
## 
## # when we download the data we create a dataframe
## # view each column of the data frame using it's name (or header)
## boulder.precip$DATE
## 
## # view the precip column
## boulder.precip$PRECIP
## 
## # q plot stands for quick plot. Let's use it to plot our data
## qplot(x=boulder.precip$DATE,
##       y=boulder.precip$PRECIP)
## 

## ----render-plot, echo=F, fig.cap="Precipitation over time"--------------

# load ggplot library for plotting
library(ggplot2)

# import data
boulder.precip <- read.csv(file="data/boulder-precip.csv")

# q plot stands for quick plot. Let's use it to plot our data
# NOTE: qplot is a function in the GGPLOT2 package
qplot(x=boulder.precip$DATE,
      y=boulder.precip$PRECIP)


