---
layout: single
title: "Introduction to APIs"
excerpt: "This lesson will cover the basic principles of using functions and why they are important."
authors: ['Carson Farmer', 'Leah Wasser']
modified: '2017-03-30'
category: [course-materials]
class-lesson: ['social-media-r']
permalink: /course-materials/earth-analytics/week-12/intro-to-API-r/
nav-title: "Social media intro"
module-title: "Introduction to API data access in R"
module-description: "In this module, we introduce various ways to access, download and work with data programmatically. These methods include downloading text files directly from a website onto your
computer and into R, reading in data stored in text format from a website, into a data.frame in R and finally, accessing subsets of particular data using REST and SOAP API's in R. "
module-nav-title: 'twitter APIs'
module-type: 'class'
week: 12
sidebar:
  nav:
author_profile: false
comments: true
order: 1
---


{% include toc title="In This Lesson" icon="file-text" %}

<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:

* Be able to describe the difference between human vs machine readable data structures.
* Be able to describe the difference between data returned using an API compared to downloading a text file directly.
* Be able to describe 2-3 components of a RESTful API call.

## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What you need

You will need a computer with internet access to complete this lesson.

</div>


Working with Social Media Data
========================================================
type: sub-section

Social media data typically describes information created and curated by individual users and collected from public spaces, such as Social media networks (e.g., Twitter, Facebook, Flickr, etc.).

It *can* provide a near real-time outlook on social processes--but it isn't a data panacea by any stretch...

Getting Started
========================================================

- We'll start by querying Twitter's API for a few different query types
- Building on this, we'll conduct some (very basic) analysis
- We'll finish with basic web-mapping similar to previous examples
<center>
[![Twitter Heat Map -- $%^& You!](http://www.socialmatt.com/wp-content/uploads/2015/03/Boulder_Twitter_Map_Visualizations.jpg)](http://www.socialmatt.com/amazing-denver-twitter-visualization/)
</center>

Lots of Setup...
========================================================

1. Log into the [Twitter Developers section](https://dev.twitter.com/)
    - If you have a Twitter account, you can login with those credentials
2. Go to [Create an app](Create an app)
    - Fill in details of the app you'll be using to connect
    - Name should be unique: I used "CarsonResearch"
3. Click on "Create your Twitter application"
    - Details of app are shown along with *consumer key* and *consumer secret*
4. You'll need access tokens
    - Scroll down and click "Create my access token"
    - Page should refresh on "Details" tab with new access tokens

Some More Setup...
========================================================

- Now that we have those details, we need to tell the `twitteR` package to use our credentials when making queries:


```r
library(twitteR)

# Setup authorization codes/secrets
consumer_key = "l0ong_@lph@_num3r1C_k3y"
consumer_secret = "l0ong_@lph@_num3r1C_s3cr37"
access_token = "l0ong_@lph@_num3r1C_t0k3n"
access_secret = "l0ong_@lph@_num3r1C_s3cr37"

# Authorization 'hand-off'
setup_twitter_oauth(consumer_key, consumer_secret,
                    access_token, access_secret)
```


```
## Error in eval(expr, envir, enclos): could not find function "setup_twitter_oauth"
```

Time to Start Querying
========================================================

- Let's query for the 100 most recent 'forest fire' tweets:


```r
query = "forest+fire"
fire_tweets = searchTwitter(query, n=100, lang="en",
                            resultType="recent")
```

- How about all recent tweets around Boulder (within 10 miles)?


```r
# About the center of Boulder... give or take
geocode = '40.0150,-105.2705,50mi'
tweets = searchTwitter("", n=1000, lang="en",
                       geocode=geocode,
                       resultType="recent")
## Error in eval(expr, envir, enclos): could not find function "searchTwitter"
```

- Now what?

Working with Twitter Responses
========================================================

- We need to extract some properties from the tweets
  - Such as the Tweet content:
    
    ```r
    text = sapply(tweets, function(x) x$getText())
    ## Error in lapply(X = X, FUN = FUN, ...): object 'tweets' not found
    ```
  - And the Tweet location information:
    
    ```r
    # Grab lat/long and make data.frame out of it
    xy = sapply(tweets, function(x) {
      as.numeric(c(x$getLongitude(),
                   x$getLatitude()))
      })
    ## Error in lapply(X = X, FUN = FUN, ...): object 'tweets' not found
    xy[!sapply(xy, length)] = NA  # Empty coords get NA
    ## Error in xy[!sapply(xy, length)] = NA: object 'xy' not found
    xy = as.data.frame(do.call("rbind", xy))
    ## Error in do.call("rbind", xy): object 'xy' not found
    ```
  - Next, we'll clean things up a bit...

Cleaning Things Up
========================================================

- Unfortunately, `R` isn't so great with emojis etc, so we'll strip these :(


```r
text = iconv(text, "ASCII", "UTF-8", sub="")
## Error in as.character(x): cannot coerce type 'closure' to vector of type 'character'
xy$text = text  # Add tweet text to data.frame
## Error in xy$text = text: object 'xy' not found
colnames(xy) = c("x", "y", "text")
## Error in colnames(xy) = c("x", "y", "text"): object 'xy' not found
```

- Next, we'll drop any rows that have missing (`NA`) coordinates


```r
xy = subset(xy, !is.na(x) & !is.na(y))
## Error in subset(xy, !is.na(x) & !is.na(y)): object 'xy' not found
```

- Finally, some simple density estimation/plotting...


```r
m = ggplot(data=xy, aes(x=x, y=y)) +
  stat_density2d(geom="raster", aes(fill=..density..),
                 contour=FALSE, alpha=1) +
  geom_point() + coord_equal()
## Error in ggplot(data = xy, aes(x = x, y = y)): object 'xy' not found
print(m)
## Error in print(m): object 'm' not found
```

Basic Mapping and Analysis
========================================================
title: false

<center>

```
## Error in eval(expr, envir, enclos): object 'm' not found
```
</center>

Adding Some Context...
========================================================

- Plotting on Stamen Terrain basemap provides useful context...


```r
# Create Boulder basemap (geocoding by name)
# NOTE: This doesn't work right now...
Boulder = get_map(location="Boulder, CO, USA",
                  source="stamen", maptype="terrain",
                  crop=FALSE, zoom=10)
# Create base ggmap
ggmap(Boulder) +
  # Start adding elements...
  geom_point(data=xy, aes(x, y), color="red",
             size=5, alpha=0.5) +
  stat_density2d(data=xy, aes(x, y, fill=..level..,
                              alpha=..level..),
                 size=0.01, bins=16, geom='polygon')
```

Twitter with Context
========================================================
title: false
<center>

</center>

Computing 'Clusters'
========================================================

- Or we can compute clusters 'on the fly', again using the powerful `leaflet` package:


```r
# URL for 'custom' icon
url = "http://steppingstonellc.com/wp-content/uploads/twitter-icon-620x626.png"
twitter = makeIcon(url, url, 32, 31)  # Create Icon!
## Error in eval(expr, envir, enclos): could not find function "makeIcon"

# How about auto-clustering?!
map = leaflet(xy) %>%
  addProviderTiles("Stamen.Terrain") %>%
  addMarkers(lng=~x, lat=~y, popup=~text,
    clusterOptions=markerClusterOptions(),
    icon=twitter)
## Error in eval(expr, envir, enclos): could not find function "leaflet"
```

```
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```

Interactive Map of Twitter Data
========================================================
title: false

<iframe  title="Twitter Map" width="1100" height="900"
  src="./twitter_map.html"
  frameborder="0" allowfullscreen></iframe>

Going a Step Further
========================================================
type: section

It isn't really enough just to grab some web-data and start mapping. Afterall, this session is really about data integration---something web-data and APIs are particularly good for!

Heat Maps are NOT Enough...
========================================================

<center>
[![xkcd Heat Maps](http://imgs.xkcd.com/comics/heatmap.png)](http://xkcd.com/1138/)
</center>

Combining Tweets and Census Info
========================================================

- Let's take another look at our Census data (this time grabbing population counts for Boulder region)

```r
pop = acs.fetch(endyear=2014, span=5, geography=geo,
                table.number="B01003",
                col.names="pretty")
est = pop@estimate  # Grab the Total Population
# Create a new data.frame
pop = data.frame(geoid, est[, 1],
                 stringsAsFactors=FALSE)
rownames(pop) = 1:nrow(inc)  # Rename rows
colnames(pop) = c("GEOID", "pop_total")  # Rename columns
```
- Create the merged data.frame!

```r
merged = geo_join(tracts, pop, "GEOID", "GEOID")
```

Big Ol' Chunk of Leaflet Code
========================================================


```r
popup = paste0("GEOID: ", merged$GEOID,
               "<br/>Total Population: ",
               round(merged$pop_total, 2))
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$pop_total)
## Error in eval(expr, envir, enclos): could not find function "colorNumeric"
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
## Error in eval(expr, envir, enclos): could not find function "leaflet"
```


```
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```

Interactive Map of Twitter Data
========================================================
title: false

<iframe  title="Twitter Map" width="1100" height="900"
  src="./dual_map.html"
  frameborder="0" allowfullscreen></iframe>

Controlling for Population
========================================================

- That's all fine and good, but are areas with lots of tweets associated with areas of high population? Its hard to tell from the map...

```r
library(sp)
# Make the points a SpatialPointsDataFrame
coordinates(xy) = ~x+y
## Error in coordinates(xy) = ~x + y: object 'xy' not found
proj4string(xy) = CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0")
## Error in proj4string(xy) = CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"): object 'xy' not found
# Put the x/y data back into the data slot for later...
xy@data = as.data.frame(xy)
## Error in as.data.frame(xy): object 'xy' not found
```
- And now we count 'points in polygon':

```r
overlay = over(xy, merged)
## Error in over(xy, merged): object 'xy' not found
res = as.data.frame(table(overlay$GEOID))
## Error in table(overlay$GEOID): object 'overlay' not found
colnames(res) = c("GEOID", "count")
## Error in colnames(res) = c("GEOID", "count"): object 'res' not found
```

Tweet Score?
========================================================

- We can then join counts back onto the counties:

```r
merged@data = join(merged@data, res, by="GEOID")
## Error in as.vector(x): object 'res' not found
# And compute a 'tweet score'... based on logged pop
merged$percapita = merged$count/log(merged$pop_total)
## Error in `[[<-.data.frame`(`*tmp*`, name, value = numeric(0)): replacement has 0 rows, data has 830
```
- Based on this new variable, we setup a new pallette:

```r
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$percapita)
## Error in eval(expr, envir, enclos): could not find function "colorNumeric"
# Also create a nice popup for display...
popup = paste0("GEOID: ", merged$GEOID, "<br>",
               "Score: ", round(merged$percapita, 2))
## Error in round(merged$percapita, 2): non-numeric argument to mathematical function
```
- And we plot it!

Plotting the Tweets
========================================================
title: false


```
## Error in eval(expr, envir, enclos): could not find function "leaflet"
## Error in eval(expr, envir, enclos): could not find function "saveWidget"
```

<iframe  title="Twitter Map" width="1100" height="900"
  src="./final_map.html"
  frameborder="0" allowfullscreen></iframe>


Wanna See the Code for That One?
========================================================


```r
leaflet() %>%
  addProviderTiles("CartoDB.Positron", group="Base") %>%
  addPolygons(data=merged, popup=popup,
              fillColor=~pal(percapita),
              color="#b2aeae", # This is a 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2, group="Score") %>%
  addCircleMarkers(data=xy, lng=~x, lat=~y, radius=4,
                   stroke=FALSE, popup=~text,
                   group="Tweets") %>%
  addLayersControl(overlayGroups=c("Tweets", "Score"),
                   options=layersControlOptions(
                     collapsed=FALSE)) %>%
  addLegend(pal=pal, values=merged$percapita,
            position="bottomright",
            title="Score")
```

That's All Folks!
========================================================
type: section

## Data Harmonization + Working with Web and Social Media Data
Earth Analytics---Spring 2016

Carson J. Q. Farmer
[carson.farmer@colorado.edu]()

babs buttenfield
[babs@colorado.edu]()

References
========================================================
type: sub-section

- Most of the content in this tutorial was 'borrowed' from one of the following sources:
    - [Leaflet for `R`](https://rstudio.github.io/leaflet/)
    - [An Introduction to `R` for Spatial Analysis & Mapping](https://us.sagepub.com/en-us/nam/an-introduction-to-r-for-spatial-analysis-and-mapping/book241031)
    - [Manipulating and mapping US Census data in `R`](http://zevross.com/blog/2015/10/14/manipulating-and-mapping-us-census-data-in-r-using-the-acs-tigris-and-leaflet-packages-3/#census-data-the-hard-way)
- Data was courtesy of:
    - [Colorado Information Marketplace](https://data.colorado.gov)
    - [Twitter's API](https://dev.twitter.com/rest/public)
    - [US Census ACS 5-Year Data API](https://www.census.gov/data/developers/data-sets/acs-survey-5-year-data.html)

Want to Play Some More?
========================================================

- Check out the [EnviroCar API](http://envirocar.github.io/enviroCar-server/api/)
    - Data on vehicle trajectories annotated with CO^2 emmisions!
- [PHL API](http://phlapi.com)---Open Data for the City of Philly
- [NYC Open Data Portal](https://nycopendata.socrata.com)---Open Data for NYC
- [SF OpenData](https://data.sfgov.org)---Open Data for San Fran
- ... you get the point!

- In general, the [Programmable Web](http://www.programmableweb.com/) is a good resource
    - Here are [146 location APIs](http://www.programmableweb.com/news/146-location-apis-foursquare-panoramio-and-geocoder/2012/06/20) for example...
