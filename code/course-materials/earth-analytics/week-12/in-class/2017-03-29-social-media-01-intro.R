## ----eval=FALSE----------------------------------------------------------
## library(twitteR)
## 
## # Setup authorization codes/secrets
## consumer_key = "l0ong_@lph@_num3r1C_k3y"
## consumer_secret = "l0ong_@lph@_num3r1C_s3cr37"
## access_token = "l0ong_@lph@_num3r1C_t0k3n"
## access_secret = "l0ong_@lph@_num3r1C_s3cr37"
## 
## # Authorization 'hand-off'
## setup_twitter_oauth(consumer_key, consumer_secret,
##                     access_token, access_secret)

## ----echo=FALSE, results='hide'------------------------------------------
options(httr_oauth_cache=TRUE)

# Setup authorization codes/secrets
consumer_key = "vNvyX2ewRRPSAAkjmOhSgg"
consumer_secret = "NFgLmY2v7mx1GRNVwzoXE8wEyrUyGoXQ7yT9KVFEg"
access_token = "600943290-zLYvgerYYOA5OBXPK6bFvPbPY9ZVHObyYDoDTGnH"
access_secret = "hrWIgvxYxND5Re6o8g0w4xrjqk0pW6PZUBReu3nJG6EYD"

# Authorization 'hand-off'
setup_twitter_oauth(consumer_key, consumer_secret,
                    access_token, access_secret)

## ----eval=FALSE----------------------------------------------------------
## query = "forest+fire"
## fire_tweets = searchTwitter(query, n=100, lang="en",
##                             resultType="recent")

## ------------------------------------------------------------------------
# About the center of Boulder... give or take
geocode = '40.0150,-105.2705,50mi'
tweets = searchTwitter("", n=1000, lang="en",
                       geocode=geocode,
                       resultType="recent")

## ------------------------------------------------------------------------
text = sapply(tweets, function(x) x$getText())

## ------------------------------------------------------------------------
# Grab lat/long and make data.frame out of it
xy = sapply(tweets, function(x) {
  as.numeric(c(x$getLongitude(),
               x$getLatitude()))
  })
xy[!sapply(xy, length)] = NA  # Empty coords get NA
xy = as.data.frame(do.call("rbind", xy))

## ------------------------------------------------------------------------
text = iconv(text, "ASCII", "UTF-8", sub="")
xy$text = text  # Add tweet text to data.frame
colnames(xy) = c("x", "y", "text")

## ------------------------------------------------------------------------
xy = subset(xy, !is.na(x) & !is.na(y))

## ----fig.show='hide'-----------------------------------------------------
m = ggplot(data=xy, aes(x=x, y=y)) +
  stat_density2d(geom="raster", aes(fill=..density..),
                 contour=FALSE, alpha=1) +
  geom_point() + coord_equal()
print(m)

## ----echo=FALSE, fig.height=10, fig.width=10-----------------------------
m + pres_theme

## ----eval=FALSE, fig.show='hide', message=FALSE, warning=FALSE-----------
## # Create Boulder basemap (geocoding by name)
## # NOTE: This doesn't work right now...
## Boulder = get_map(location="Boulder, CO, USA",
##                   source="stamen", maptype="terrain",
##                   crop=FALSE, zoom=10)
## # Create base ggmap
## ggmap(Boulder) +
##   # Start adding elements...
##   geom_point(data=xy, aes(x, y), color="red",
##              size=5, alpha=0.5) +
##   stat_density2d(data=xy, aes(x, y, fill=..level..,
##                               alpha=..level..),
##                  size=0.01, bins=16, geom='polygon')

## ----eval=FALSE, echo=FALSE, fig.height=10, fig.width=10, message=FALSE, warning=FALSE----
## ggmap(Boulder) +
##   geom_point(data=xy, aes(x, y), color="red", size=2, alpha=0.5) +
##   stat_density2d(data=xy, aes(x, y,  fill=..level.., alpha=..level..),
##                               size=0.01, bins=16, geom='polygon') +
##   pres_theme

## ----cache=FALSE---------------------------------------------------------
# URL for 'custom' icon
url = "http://steppingstonellc.com/wp-content/uploads/twitter-icon-620x626.png"
twitter = makeIcon(url, url, 32, 31)  # Create Icon!

# How about auto-clustering?!
map = leaflet(xy) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=~x, lat=~y, popup=~text,
    clusterOptions=markerClusterOptions(),
    icon=twitter)

## ----echo=FALSE----------------------------------------------------------
saveWidget(widget=map, file="twitter_map.html", selfcontained=TRUE)

## ------------------------------------------------------------------------
pop = acs.fetch(endyear=2014, span=5, geography=geo,
                table.number="B01003",
                col.names="pretty")
est = pop@estimate  # Grab the Total Population
# Create a new data.frame
pop = data.frame(geoid, est[, 1],
                 stringsAsFactors=FALSE)
rownames(pop) = 1:nrow(inc)  # Rename rows
colnames(pop) = c("GEOID", "pop_total")  # Rename columns

## ------------------------------------------------------------------------
merged = geo_join(tracts, pop, "GEOID", "GEOID")

## ----cache=FALSE---------------------------------------------------------
popup = paste0("GEOID: ", merged$GEOID,
               "<br/>Total Population: ",
               round(merged$pop_total, 2))
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$pop_total)
map = leaflet() %>%  # Map time!
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data=merged, popup=popup,
              fillColor=~pal(pop_total),
              color="#b2aeae", # This is a 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2) %>%
  addCircles(data=xy, lng=~x, lat=~y,
             popup=~text, radius=5) %>%
  addLegend(pal=pal, values=merged$pop_total,
            position="bottomright",
            title="Total Population")

## ----echo=FALSE----------------------------------------------------------
saveWidget(widget=map, file="dual_map.html", selfcontained=TRUE)

## ------------------------------------------------------------------------
library(sp)
# Make the points a SpatialPointsDataFrame
coordinates(xy) = ~x+y
proj4string(xy) = CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0")
# Put the x/y data back into the data slot for later...
xy@data = as.data.frame(xy)

## ------------------------------------------------------------------------
overlay = over(xy, merged)
res = as.data.frame(table(overlay$GEOID))
colnames(res) = c("GEOID", "count")

## ------------------------------------------------------------------------
merged@data = join(merged@data, res, by="GEOID")
# And compute a 'tweet score'... based on logged pop
merged$percapita = merged$count/log(merged$pop_total)

## ------------------------------------------------------------------------
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$percapita)
# Also create a nice popup for display...
popup = paste0("GEOID: ", merged$GEOID, "<br>",
               "Score: ", round(merged$percapita, 2))

## ----cache=FALSE, echo=FALSE---------------------------------------------
map = leaflet() %>%
  addProviderTiles("CartoDB.Positron", group="Base") %>%
  addPolygons(data=merged, popup=popup,
              fillColor=~pal(percapita),
              color="#b2aeae", # This is a 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2, group="Score") %>%
  addCircleMarkers(data=xy, lng=~x, lat=~y, radius=4,
                   stroke=FALSE, popup=~text, group="Tweets") %>%
  addLayersControl(overlayGroups=c("Tweets", "Score"),
                   options=layersControlOptions(collapsed=FALSE)) %>%
  addLegend(pal=pal, values=merged$percapita,
            position="bottomright",
            title="Score")

saveWidget(widget=map, file="final_map.html", selfcontained=TRUE)

## ----eval=FALSE----------------------------------------------------------
## leaflet() %>%
##   addProviderTiles("CartoDB.Positron", group="Base") %>%
##   addPolygons(data=merged, popup=popup,
##               fillColor=~pal(percapita),
##               color="#b2aeae", # This is a 'hex' color
##               fillOpacity=0.7, weight=1,
##               smoothFactor=0.2, group="Score") %>%
##   addCircleMarkers(data=xy, lng=~x, lat=~y, radius=4,
##                    stroke=FALSE, popup=~text,
##                    group="Tweets") %>%
##   addLayersControl(overlayGroups=c("Tweets", "Score"),
##                    options=layersControlOptions(
##                      collapsed=FALSE)) %>%
##   addLegend(pal=pal, values=merged$percapita,
##             position="bottomright",
##             title="Score")

