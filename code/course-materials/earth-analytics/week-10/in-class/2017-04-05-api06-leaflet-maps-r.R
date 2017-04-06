## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(RCurl)
library(rjson)
library(jsonlite)
library(leaflet)

## ---- echo=FALSE---------------------------------------------------------
library("knitr")

## ----eval=FALSE----------------------------------------------------------
## map <- leaflet() %>%
##   addTiles() %>%  # use the default base map which is OpenStreetMap tiles
##   addMarkers(lng=174.768, lat=-36.852,
##              popup="The birthplace of R")
## map

## ----echo=FALSE, eval=FALSE----------------------------------------------
## library(htmlwidgets)
## saveWidget(widget=map, file="birthplace_r.html", selfcontained=FALSE)

## ------------------------------------------------------------------------
base_url <- "https://data.colorado.gov/resource/j5pc-4t32.json?"
full_url <- paste0(base_url, "station_status=Active",
            "&county=BOULDER")
water_data <- getURL(URLencode(full_url))
water_data_df <- fromJSON(water_data)
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)

# turn columns to numeric and remove NA values
water_data_df <- water_data_df %>%
  mutate_each_(funs(as.numeric), c( "amount", "location.latitude", "location.longitude")) %>%
  filter(!is.na(location.latitude))


## ----eval=FALSE----------------------------------------------------------
## # create leaflet map
## leaflet(water_data_df) %>%
##   addTiles() %>%
##   addCircleMarkers(lng=~location.longitude, lat=~location.latitude)

## ----results="hide", cache=FALSE-----------------------------------------
map <- leaflet(water_data_df)
map <- addTiles(map)
map <- addCircleMarkers(map, lng=~location.longitude, lat=~location.latitude)


## ----echo=FALSE, eval=FALSE----------------------------------------------
## saveWidget(widget=map, file="water_map1.html", selfcontained=FALSE)

## ----eval=FALSE----------------------------------------------------------
## leaflet(water_data_df) %>%
##   addProviderTiles("CartoDB.Positron") %>%
##   addMarkers(lng=~location.longitude, lat=~location.latitude, popup=~station_name)

## ----echo=FALSE, cache=FALSE, eval=FALSE---------------------------------
## map = leaflet(water_data_df) %>%
##   addProviderTiles("CartoDB.Positron") %>%
##   addMarkers(lng=~location.longitude, lat=~location.latitude, popup=~station_name)
## saveWidget(widget=map, file="water_map2.html", selfcontained=FALSE)

## ------------------------------------------------------------------------
# let's look at the output of our popup text before calling it in leaflet
paste0(water_data_df$station_name, "<br/>Discharge: ", water_data_df$amount)

## ----eval=FALSE----------------------------------------------------------
## # Specify custom icon
## url = "http://tinyurl.com/jeybtwj"
## water = makeIcon(url, url, 24, 24)
## 
## leaflet(water_data_df) %>%
##   addProviderTiles("Stamen.Terrain") %>%
##   addMarkers(lng=~location.longitude, lat=~location.latitude, icon=water,
##              popup=~paste0(station_name,
##                            "<br/>Discharge: ",
##                            amount))

## ----echo=FALSE, cache=FALSE, eval=FALSE---------------------------------
## url = "http://tinyurl.com/jeybtwj"
## water = makeIcon(url, url, 24, 24)
## 
## map = leaflet(water_data_df) %>%
##   addProviderTiles("Stamen.Terrain") %>%
##   addMarkers(lng=~location.longitude, lat=~location.latitude, icon=water,
##              popup=~paste0(station_name, "<br/>Discharg: ", amount))
## saveWidget(widget=map, file="water_map3.html", selfcontained=FALSE)

