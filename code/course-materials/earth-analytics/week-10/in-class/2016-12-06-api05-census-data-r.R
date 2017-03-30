## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
library("knitr")
library("dplyr")
library("ggplot2")
library("RCurl")
library("rjson")
library("jsonlite")

## ----message=FALSE-------------------------------------------------------
library(tigris)  # To get TIGER (geospatial) data
library(acs)     # To get census data
library(stringr) # To pad fips codes

## ----eval=FALSE----------------------------------------------------------
## key = "l0ong_@lph@_num3r1C_k3y"

## ----echo=FALSE----------------------------------------------------------
key = "d74cf7656effed2fdd74ba602a134541e0c296e4"

## ------------------------------------------------------------------------
api.key.install(key)

## ----message=FALSE, warning=FALSE----------------------------------------
# we can use the census API to look up terms
income_tables <- acs.lookup(keyword = "Household Income in the past 12 months", endyear = 2015, case.sensitive = F)

# Fips codes for counties _around_ Boulder
counties = c(5, 13, 35, 14, 59, 19,
             47, 49, 69, 123, 31, 1)
# Grab the spatial data (tigris)
tracts = tracts(state="CO", county=counties, cb=TRUE)

## ----message=FALSE-------------------------------------------------------
# Create a geographic set to grab tabular data (acs)
geo = geo.make(state=c("CO"), county=counties, tract="*")

## ----message=FALSE-------------------------------------------------------
library(choroplethr)


new <- get_acs_data(tableId = "B19001",
             map = "county",
             endyear=2014,
             span=5,
             column_idx = 1)

# get get the values
new1 <- new[[1]]
library(choroplethrMaps)
county_choropleth(new1,
                  title = "2012 County Estimates:nNumber of Japanese per County")


income = acs.fetch(endyear=2014, span=5,
                   geography=geo,
                   table.number="B19001",
                   col.names="pretty")

## ------------------------------------------------------------------------
names(attributes(income))

## ------------------------------------------------------------------------
# Create a geoid object
geog = income@geography
geoid = paste0(str_pad(geog$state,2,"left",pad="0"),
               str_pad(geog$county,3,"left",pad="0"),
               str_pad(geog$tract,6,"left",pad="0"))

# We want the first and last columns
est = income@estimate
inc = data.frame(geoid, est[,c(1, 17)],
                 stringsAsFactors=FALSE)

## ------------------------------------------------------------------------
rownames(inc) = 1:nrow(inc)
# Rename columns so they're shorter and cleaner
colnames(inc)= c("GEOID", "total", "over_200")
# Create a percentage over $200k column
inc$percent = 100*(inc$over_200/inc$total)

## ------------------------------------------------------------------------
merged = geo_join(tracts, inc, "GEOID", "GEOID")

## ----eval=FALSE----------------------------------------------------------
## # Quick look at distribution of `percent` variable
## ggplot(data=merged@data, aes(x=percent)) +
##   geom_histogram()

## ----echo=FALSE, fig.width=10, fig.height=6, message=FALSE, warning=FALSE----
ggplot(data=merged@data, aes(x=percent)) +
  geom_histogram() + pres_theme

## ------------------------------------------------------------------------
# Create a nice popup for display...
popup = paste0("GEOID: ", merged$GEOID, "<br>",
               "Households > $200k: ",
               round(merged$percent, 2), "%")

# We'll also create/use a colorbrewer pallette
pal = colorNumeric(palette="YlGnBu",
                   domain=merged$percent)

## ----cache=FALSE, message=FALSE------------------------------------------
map = leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data=merged, fillColor=~pal(percent),
              color="#b2aeae", # 'hex' color
              fillOpacity=0.7, weight=1,
              smoothFactor=0.2, popup=popup) %>%
  addLegend(pal=pal, values=merged$percent,
            position="bottomright",
            title="% > $200k",
            labFormat=labelFormat(suffix="%"))

## ----echo=FALSE----------------------------------------------------------
saveWidget(widget=map, file="income_map.html", selfcontained=FALSE)

