## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------

water_base_url = "https://data.colorado.gov/resource/j5pc-4t32.json?"
water_full_url = paste0(water_base_url, "station_status=Active",
            "&county=BOULDER")
water_data = getURL(URLencode(water_full_url))
water_data_df <- fromJSON(water_data)


## ------------------------------------------------------------------------
# view data structure
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

## ----water_data_plot1, fig.width=5, fig.height=5-------------------------
ggplot(water_data_df, aes(location.longitude, location.latitude, size=amount,
  color=station_type)) +
  geom_point() + coord_equal() +
      labs(x="Longitude",
           y="Latitude",
          title="Surface Water Site Locations by Type",
          subtitle = "Boulder, Colorado")


## ----create_ggmap--------------------------------------------------------
boulder <- get_map(location="Boulder, CO, USA",
                  source="google", crop=FALSE, zoom=10)
ggmap(boulder) +
  geom_point(data=water_data_df, aes(location.longitude, location.latitude, size=amount,
  color=factor(station_type)))

