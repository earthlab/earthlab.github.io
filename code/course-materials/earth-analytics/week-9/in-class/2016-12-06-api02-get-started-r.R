## ------------------------------------------------------------------------
library("knitr")
library("dplyr")
library("ggplot2")
library("leaflet")
library("htmlwidgets")
library("twitteR")

## ------------------------------------------------------------------------
base = "http://data.princeton.edu/wws509"  # Base url
file = "/datasets/effort.dat"  # File name
fpe = read.table(paste0(base, file))

## ------------------------------------------------------------------------
head(fpe)

## ----eval=FALSE----------------------------------------------------------
## pairs(fpe, panel=panel.smooth)

## ----echo=FALSE, fig.width=10, fig.height=10-----------------------------
pairs(fpe, panel=panel.smooth)

