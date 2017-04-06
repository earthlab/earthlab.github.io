## ---- eval=FALSE---------------------------------------------------------
## # download text file to a specified location on our computer
## download.file(url = "https://ndownloader.figshare.com/files/7010681",
##              destfile = "data/week10/boulder-precip-aug-oct-2013.csv")

## ------------------------------------------------------------------------
# read data into R
boulder_precip <- read.csv("data/week10/boulder-precip-aug-oct-2013.csv")


## ----print-table, echo=FALSE---------------------------------------------
knitr::kable(boulder_precip)

