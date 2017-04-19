## ------------------------------------------------------------------------
# About the center of Boulder... give or take
geocode <- '40.0150,-105.2705,50mi'
boulder_tweets <- search_tweets("", n=1000, lang="en",
                       geocode=geocode)
head(boulder_tweets)

## ------------------------------------------------------------------------
boulder_users <- attributes(boulder_tweets)$users
boulder_users$location


## ------------------------------------------------------------------------

boulder_users$followers_count
summary(boulder_users$followers_count)
max_val <- max(boulder_users$followers_count)

# looks like there is an outlier -- let's use breaks to make this easier to look at
ggplot(boulder_users, aes(followers_count)) +
         geom_histogram(breaks=c(0,100,1000,10000,100000, 200000,max_val))


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

## ----echo=FALSE, eval=FALSE----------------------------------------------
## saveWidget(widget=map, file="twitter_map.html", selfcontained=TRUE)

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

## ----echo=FALSE, eval=FALSE----------------------------------------------
## saveWidget(widget=map, file="dual_map.html", selfcontained=TRUE)

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

## ----cache=FALSE, echo=FALSE, eval=FALSE---------------------------------
## map = leaflet() %>%
##   addProviderTiles("CartoDB.Positron", group="Base") %>%
##   addPolygons(data=merged, popup=popup,
##               fillColor=~pal(percapita),
##               color="#b2aeae", # This is a 'hex' color
##               fillOpacity=0.7, weight=1,
##               smoothFactor=0.2, group="Score") %>%
##   addCircleMarkers(data=xy, lng=~x, lat=~y, radius=4,
##                    stroke=FALSE, popup=~text, group="Tweets") %>%
##   addLayersControl(overlayGroups=c("Tweets", "Score"),
##                    options=layersControlOptions(collapsed=FALSE)) %>%
##   addLegend(pal=pal, values=merged$percapita,
##             position="bottomright",
##             title="Score")
## 
## saveWidget(widget=map, file="final_map.html", selfcontained=TRUE)

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

