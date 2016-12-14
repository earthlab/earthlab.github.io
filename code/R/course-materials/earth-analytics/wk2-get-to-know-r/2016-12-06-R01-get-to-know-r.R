## ----open-file-----------------------------------------------------------

# load the ggplot2 library for plotting
library(ggplot2)

# turn off factors
options(stringsAsFactors = FALSE)

# download data from figshare
# note that we are downloaded the data into your
download.file(url = "https://ndownloader.figshare.com/files/7010681",
              destfile = "data/boulder-precip.csv")

# import data
boulder.precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder.precip)

# what is the format of the variable in R
str(boulder.precip)

# q plot stands for quick plot. Let's use it to plot our data
qplot(x=boulder.precip$DATE,
      y=boulder.precip$PRECIP)


## ---- results='show'-----------------------------------------------------

round(3.14159)


