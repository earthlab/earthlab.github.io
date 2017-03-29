## ----echo=F--------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
library("knitr")
library("dplyr")
library("ggplot2")
library("RCurl")

## ------------------------------------------------------------------------
# Base URL path
base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url = paste0(base_url, "county=Boulder",
              "&$where=age between 20 and 40",
              "&$select=year,age,femalepopulation")
# view full url
full_url
# get the data from the specified url
pop_proj_data = getURL(URLencode(full_url))

#base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
#res = getForm(base_url, county="Boulder",
#              age="BOULDER")

## ------------------------------------------------------------------------
# view JSON data structure
head(pop_proj_data)

## ------------------------------------------------------------------------
library(rjson)
library(jsonlite)

# Convert JSON to data frame
json_text = fromJSON(pop_proj_data)
head(json_text)

# convert EACH row to a numeric format
json_text$age <- as.numeric(json_text$age)
json_text$year <- as.numeric(json_text$year)
json_text$femalepopulation <- as.numeric(json_text$femalepopulation)

# OR use the apply function to convert all rows in the DF to numbers
#pops <- as.data.frame(lapply(json_text, as.numeric))



## ----plot_pop_proj-------------------------------------------------------
# plot the data
ggplot(json_text, aes(x=year, y=femalepopulation,
  group=factor(age), color=age)) + geom_line() +
      labs(x="Year",
           y="Female Population",
          title="Projected Female Population",
          subtitle = "Boulder, CO: 1990 - 2040")

# fromJSON(res) %>% as.data.frame

# pops = do.call("rbind", json_text)  # Combine rows
# Convert to data.frame with numeric columns
# pops = as.data.frame(apply(pops, 2, as.numeric))

## ------------------------------------------------------------------------

base = "https://data.colorado.gov/resource/j5pc-4t32.json?"
full = paste0(base, "station_status=Active",
            "&county=BOULDER")
res = getURL(URLencode(full))
sites <- fromJSON(res)
head(sites)


## ------------------------------------------------------------------------
# turn amount into number
sites$amount <- as.numeric(sites$amount)
# lat and long should also be numeric
sites$location$longitude <- as.numeric(sites$location$longitude)
sites$location$latitude <- as.numeric(sites$location$latitude)

ggplot(sites, aes(location$longitude, location$latitude, size=amount,
  color=station_type)) +
  geom_point() + coord_equal()

## ----create_ggmap--------------------------------------------------------
library(ggmap)
boulder <- get_map(location="Boulder, CO, USA",
                  source="google", crop=FALSE, zoom=10)
ggmap(boulder) +
  geom_point(data=sites, aes(location$longitude, location$latitude, size=amount,
  color=factor(station_type)))

