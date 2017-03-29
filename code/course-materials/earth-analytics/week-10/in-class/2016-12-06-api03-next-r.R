## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
#NOTE: if you have problems with ggmap, try to install from github
#devtools::install_github("dkahle/ggmap")
#devtools::install_github("hadley/ggplot2")
library(ggmap)
library(ggplot2)

library("knitr")
library("dplyr")
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
pop_proj_data_df = fromJSON(pop_proj_data)
#unlist(pop_proj_data_df)
head(pop_proj_data_df)

# turn columns to numeric and remove NA values
pop_proj_data_df <- pop_proj_data_df %>%
  mutate_each_(funs(as.numeric), c( "age", "year", "femalepopulation"))


## ---- eval=FALSE---------------------------------------------------------
## # convert EACH row to a numeric format
## # note this is the clunky way to do what we did above with dplyr!
## pop_proj_data_df$age <- as.numeric(pop_proj_data_df$age)
## pop_proj_data_df$year <- as.numeric(pop_proj_data_df$year)
## pop_proj_data_df$femalepopulation <- as.numeric(pop_proj_data_df$femalepopulation)
## 
## # OR use the apply function to convert all rows in the DF to numbers
## #pops <- as.data.frame(lapply(pop_proj_data_df, as.numeric))
## 
## 

## ----plot_pop_proj-------------------------------------------------------
# plot the data
ggplot(pop_proj_data_df, aes(x=year, y=femalepopulation,
  group=factor(age), color=age)) + geom_line() +
      labs(x="Year",
           y="Female Population",
          title="Projected Female Population",
          subtitle = "Boulder, CO: 1990 - 2040")

## ----echo=FALSE, eval=FALSE----------------------------------------------
## 
## # some code i don't use that is fancier...
## # fromJSON(res) %>% as.data.frame
## 
## # pops = do.call("rbind", pop_proj_data_df)  # Combine rows
## # Convert to data.frame with numeric columns
## # pops = as.data.frame(apply(pops, 2, as.numeric))

## ------------------------------------------------------------------------

water_base_url = "https://data.colorado.gov/resource/j5pc-4t32.json?"
water_full_url = paste0(water_base_url, "station_status=Active",
            "&county=BOULDER")
water_data = getURL(URLencode(water_full_url))
water_data_df <- fromJSON(water_data)
head(water_data_df)
str(water_data_df)

## ------------------------------------------------------------------------

water_data_df$location
water_data_df$location$latitude

## ------------------------------------------------------------------------
# remove the nested data frame
water_data_df <- flatten(water_data_df, recursive = TRUE)
water_data_df$location.latitude


## ------------------------------------------------------------------------
str(water_data_df$location.latitude)

## ------------------------------------------------------------------------
# turn columns to numeric and remove NA values
water_data_df <- water_data_df %>%
  mutate_each_(funs(as.numeric), c( "amount", "location.longitude", "location.latitude")) %>%
  filter(!is.na(location.latitude))

## ----water_data_plot1----------------------------------------------------
ggplot(water_data_df, aes(location.longitude, location.latitude, size=amount,
  color=station_type)) +
  geom_point() + coord_equal() +
      labs(x="Year",
           y="Female Population",
          title="Projected Female Population",
          subtitle = "Boulder, CO: 1990 - 2040")


## ----create_ggmap--------------------------------------------------------
boulder <- get_map(location="Boulder, CO, USA",
                  source="google", crop=FALSE, zoom=10)
ggmap(boulder) +
  geom_point(data=water_data_df, aes(location.longitude, location.latitude, size=amount,
  color=factor(station_type)))

