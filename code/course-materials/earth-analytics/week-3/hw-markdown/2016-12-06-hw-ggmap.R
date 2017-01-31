## ----ggmap-setup---------------------------------------------------------

# install devtools
#install.packages("devtools")
# install ggmap from dev space
devtools::install_github("dkahle/ggmap")

library(ggmap)

## ----create-base-map-----------------------------------------------------
myMap <- get_map(location = "Boulder, Colorado",
          source="google", 
          maptype="terrain", crop=FALSE,
          zoom=6)
# plot map
ggmap(myMap)


## ----add-points-to-map---------------------------------------------------
# add points to your map
# creating a sample data.frame with your lat/lon points
lon <- c(-105.178333)
lat <- c(40.051667)
df <- as.data.frame(cbind(lon,lat))

# create a map with a point location for boulder. 
ggmap(myMap) + labs(x = "", y = "") +
  geom_point(data = df, aes(x = lon, y = lat, fill = "red", alpha = 0.2), size = 5, shape = 19) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE) 
  


