## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
#NOTE: if you have problems with ggmap, try to install both ggplot and ggmap from github
#devtools::install_github("dkahle/ggmap")
#devtools::install_github("hadley/ggplot2")
library(ggmap)
library(ggplot2)
library("dplyr")
library("RCurl")

## ----echo=FALSE----------------------------------------------------------
library("knitr")

## ------------------------------------------------------------------------
# Base URL path
base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url = paste0(base_url, "county=Boulder",
              "&$where=age between 20 and 40",
              "&$select=year,age,femalepopulation")
# view full url
full_url

## ------------------------------------------------------------------------
# get the data from the specified url
pop_proj_data = getURL(URLencode(full_url))

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
           y="Female Population - Age 20-40",
          title="Projected Female Population",
          subtitle = "Boulder, CO: 1990 - 2040")

## ----male-population, echo=FALSE-----------------------------------------
# Base URL path
base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url_80 = paste0(base_url, "county=Boulder",
              "&$where=age between 60 and 80",
              "&$select=year,age,malepopulation")
# get the data from the specified url
pop_proj_data_80 = getURL(URLencode(full_url_80))

# Convert JSON to data frame
pop_proj_data_80_df = fromJSON(pop_proj_data_80)

# turn columns to numeric and remove NA values
pop_proj_data_80_df <- pop_proj_data_80_df %>%
  mutate_each_(funs(as.numeric), c( "age", "year", "malepopulation"))

# plot the data
ggplot(pop_proj_data_80_df, aes(x=year, y=malepopulation,
  group=factor(age), color=age)) + geom_line() +
      labs(x="Year",
           y="Male Population age 60-80",
          title="Projected Male Population - Age 60-80",
          subtitle = "Boulder, CO: 1990 - 2040")

