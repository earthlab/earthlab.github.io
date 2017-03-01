getwd()
setwd("/Users/lewa8222/Documents/earth-analytics")


r1 <- r2 <- r3 <- raster(nrow=10, ncol=10)
# assign random values bewteen
# Assign random cell values

#  create rasters with  int values int2s structure
values(r1) <- floor(runif(ncell(r1), min=-32000, max=32000))
values(r2) <- floor(runif(ncell(r2), min=-32000, max=32000))
values(r3) <- floor(runif(ncell(r3), min=-32000, max=32000))
s <- stack(r1, r2, r3)
# it's a float now
str(s)
s

s[s < -100] <- NA
s
