## ----open-file-----------------------------------------------------------

# load the ggplot2 library for plotting
library(ggplot2)

# turn off factors
options(stringsAsFactors = FALSE)

# download data from figshare
# note that we are downloaded the data into your
download.file(url = "https://ndownloader.figshare.com/files/7010681",
              destfile = "data/boulder-precip.csv")

## ----import-data---------------------------------------------------------
# import data
boulder_precip <- read.csv(file="data/boulder-precip.csv")

# view first few rows of the data
head(boulder_precip)

# view the format of the boulder_precip object in R
str(boulder_precip)

## ----view-column---------------------------------------------------------
# when we download the data we create a dataframe
# view each column of the data frame using its name (or header)
boulder_precip$DATE

# view the precip column
boulder_precip$PRECIP

## ----view-structure------------------------------------------------------
# when we download the data we create a dataframe
# view each column of the data frame using its name (or header)
# how many rows does the data frame have
nrow(boulder_precip)

# view the precip column
boulder_precip$PRECIP

## ----quick-plot, fig.cap="plot precipitation data"-----------------------
# q plot stands for quick plot. Let's use it to plot our data
qplot(x=boulder_precip$DATE,
      y=boulder_precip$PRECIP)


