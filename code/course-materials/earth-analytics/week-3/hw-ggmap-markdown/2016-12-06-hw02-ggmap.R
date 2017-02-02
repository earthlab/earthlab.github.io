## ----ggmap-setup---------------------------------------------------------
# install devtools
#install.packages("devtools")
# install ggmap from dev space
# devtools::install_github("dkahle/ggmap")

library(ggmap)

## ----create-base-map, fig.cap="ggmap base plot"--------------------------
myMap <- get_map(location = "Boulder, Colorado",
          source="google",
          maptype="terrain", crop=FALSE,
          zoom=6)
# plot map
ggmap(myMap)


## ----add-points-to-map, fig.cap="ggmap with location point on it. "------
# add points to your map
# creating a sample data.frame with your lat/lon points
lon <- c(-105.178333)
lat <- c(40.051667)
df <- as.data.frame(cbind(lon,lat))

# create a map with a point location for boulder.
ggmap(myMap) + labs(x = "", y = "") +
  geom_point(data = df, aes(x = lon, y = lat, fill = "red", alpha = 0.2), size = 5, shape = 19) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)



## ----load-maps-package---------------------------------------------------

#install.packages('maps')
library(maps)

## ----create-us-map, fig.cap="vector map of the US"-----------------------
map('state')
# add a title to your map
title('Map of the United States')

## ----create-us-map-colors, fig.cap="vector map of the US with colors"----
map('state', col="darkgray", fill=TRUE, border="white")
# add a title to your map
title('Map of the United States')

## ----create-CO-map-colors, fig.cap="vector map of the CO with colors"----
map('county', regions="Colorado", col="darkgray", fill=TRUE, border="grey80")
map('state', regions="Colorado", col="black", add=T)
# add the x, y location of the stream guage using the points 
# notice i used two colors adn sized to may the symbol look a little brighter
points(x=-105.178333, y=40.051667, pch=21, col="violetred4", cex=2)
points(x=-105.178333, y=40.051667, pch=8, col="white", cex=1.3)
# add a title to your map
title('County Map of Colorado\nStream gage location')

## ----create-map, fig.cap="Create final map"------------------------------

map('state', fill=TRUE, col="darkgray", border="white", lwd=1)
map(database = "usa", lwd=1, add=T)
# add the adjacent parts of the US; can't forget my homeland
map("state","colorado", col="springgreen", 
    lwd=1, fill=TRUE, add=TRUE)  
# add gage location
title("Stream gage location\nBoulder, Colorado")
# add the x, y location of hte stream guage using the points 
points(x=-105.178333, y=40.051667, pch=8, col="red", cex=1.3)

