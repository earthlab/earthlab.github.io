## ----echo=F--------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
library("knitr")
library("dplyr")
library("ggplot2")
library("RCurl")

## ------------------------------------------------------------------------
base <- "https://data.colorado.gov/resource/j5pc-4t32.json?"
full <- paste0(base, "station_status=Active",
            "&county=BOULDER")
res <- getURL(URLencode(full))
sites <- fromJSON(res)

# turn amount into number
sites$amount <- as.numeric(sites$amount)
# lat and long should also be numeric
sites$location$longitude <- as.numeric(sites$location$longitude)
sites$location$latitude <- as.numeric(sites$location$latitude)

## ----eval=FALSE----------------------------------------------------------
## library(leaflet)
## 
## map = leaflet() %>%
##   addTiles() %>%  # Default OpenStreetMap tiles
##   addMarkers(lng=174.768, lat=-36.852,
##              popup="The birthplace of R")
## print(map)

## ----echo=FALSE, eval=FALSE----------------------------------------------
## library(htmlwidgets)
## saveWidget(widget=map, file="birthplace_r.html", selfcontained=FALSE)

## ----eval=FALSE----------------------------------------------------------
## leaflet(sites) %>%
##   addTiles() %>%
##   addCircleMarkers(lng=~long, lat=~lat)

## ----results="hide", cache=FALSE-----------------------------------------
map = leaflet(sites)
map = addTiles(map)
map = addCircleMarkers(map, lng=~long, lat=~lat)

## ----echo=FALSE----------------------------------------------------------
saveWidget(widget=map, file="water_map1.html", selfcontained=FALSE)

## ----eval=FALSE----------------------------------------------------------
## leaflet(sites) %>%
##   addProviderTiles("CartoDB.Positron") %>%
##   addMarkers(lng=~long, lat=~lat, popup=~station_name)

## ----echo=FALSE, cache=FALSE---------------------------------------------
map = leaflet(sites) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(lng=~long, lat=~lat, popup=~station_name)
saveWidget(widget=map, file="water_map2.html", selfcontained=FALSE)

## ----eval=FALSE----------------------------------------------------------
## # Nothing special, just found this one online...
## url = "http://tinyurl.com/jeybtwj"
## water = makeIcon(url, url, 24, 24)
## 
## leaflet(sites) %>%
##   addProviderTiles("Stamen.Terrain") %>%
##   addMarkers(lng=~long, lat=~lat, icon=water,
##              popup=~paste0(station_name,
##                            "<br/>Discharg: ",
##                            amount))

## ----echo=FALSE, cache=FALSE---------------------------------------------
url = "http://tinyurl.com/jeybtwj"
water = makeIcon(url, url, 24, 24)

map = leaflet(sites) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=~long, lat=~lat, icon=water,
             popup=~paste0(station_name, "<br/>Discharg: ", amount))
saveWidget(widget=map, file="water_map3.html", selfcontained=FALSE)

