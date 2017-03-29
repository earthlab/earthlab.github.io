## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
library("knitr")
library("dplyr")
library("ggplot2")
library("RCurl")
library("rjson")
library("jsonlite")

## ----eval=FALSE----------------------------------------------------------
## library(leaflet)
## 
## map = leaflet() %>%
##   addTiles() %>%  # use the default base map which is OpenStreetMap tiles
##   addMarkers(lng=174.768, lat=-36.852,
##              popup="The birthplace of R")
## print(map)

## ----echo=FALSE, eval=FALSE----------------------------------------------
## library(htmlwidgets)
## saveWidget(widget=map, file="birthplace_r.html", selfcontained=FALSE)

## ------------------------------------------------------------------------
base_url <- "https://data.colorado.gov/resource/j5pc-4t32.json?"
full_url <- paste0(base, "station_status=Active",
            "&county=BOULDER")
water_data <- getURL(URLencode(full_url))
water_data_df <- fromJSON(water_data)
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)

# turn columns to numeric and remove NA values
water_data_df <- water_data_df %>% 
  mutate_each_(funs(as.numeric), c( "amount", "location.latitude", "location.longitude")) %>% 
  filter(!is.na(location.latitude))

# Note the code above is the same as doing the following below:
#water_data_df$amount <- as.numeric(water_data_df$amount)
# lat and long should also be numeric
# i'm also removing the nested location of these variables
#water_data_df$location.longitude <- as.numeric(water_data_df$location.longitude)
#water_data_df$location.latitude <- as.numeric(water_data_df$location.latitude)


## ----eval=FALSE----------------------------------------------------------
## # create leaflet map
## leaflet(water_data_df) %>%
##   addTiles() %>%
##   addCircleMarkers(lng=~location.longitude, lat=~location.latitude)

## ----results="hide", cache=FALSE-----------------------------------------
map = leaflet(water_data_df)
map = addTiles(map)
map = addCircleMarkers(map, lng=~location.longitude, lat=~location.latitude)


## ----echo=FALSE----------------------------------------------------------
saveWidget(widget=map, file="water_map1.html", selfcontained=FALSE)

## ----eval=FALSE----------------------------------------------------------
## leaflet(water_data_df) %>%
##   addProviderTiles("CartoDB.Positron") %>%
##   addMarkers(lng=~location.longitude, lat=~location.latitude, popup=~station_name)

## ----echo=FALSE, cache=FALSE---------------------------------------------
map = leaflet(water_data_df) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addMarkers(lng=~location.longitude, lat=~location.latitude, popup=~station_name)
saveWidget(widget=map, file="water_map2.html", selfcontained=FALSE)

## ----eval=FALSE----------------------------------------------------------
## # Nothing special, just found this one online...
## url = "http://tinyurl.com/jeybtwj"
## water = makeIcon(url, url, 24, 24)
## 
## leaflet(water_data_df) %>%
##   addProviderTiles("Stamen.Terrain") %>%
##   addMarkers(lng=~location.longitude, lat=~location.latitude, icon=water,
##              popup=~paste0(station_name,
##                            "<br/>Discharg: ",
##                            amount))

## ----echo=FALSE, cache=FALSE---------------------------------------------
url = "http://tinyurl.com/jeybtwj"
water = makeIcon(url, url, 24, 24)

map = leaflet(water_data_df) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=~location.longitude, lat=~location.latitude, icon=water,
             popup=~paste0(station_name, "<br/>Discharg: ", amount))
saveWidget(widget=map, file="water_map3.html", selfcontained=FALSE)

