## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
# load packages
library(ggmap)
library(ggplot2)
library(dplyr)

## ----echo=FALSE----------------------------------------------------------
library("knitr")

## ----get-api-url---------------------------------------------------------
# Base URL path
base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url = paste0(base_url, "county=Boulder",
             "&$where=age between 20 and 40",
             "&$select=year,age,femalepopulation")
# view full url
full_url

## ------------------------------------------------------------------------
library(rjson)
# Convert JSON to data frame
pop_proj_data_df <- fromJSON(full_url)


## ------------------------------------------------------------------------
full_url <- URLencode(full_url)
full_url
# Convert JSON to data frame
pop_proj_data_df <- fromJSON(full_url)
head(pop_proj_data_df)

## ------------------------------------------------------------------------
library(jsonlite)
# Convert JSON to data frame
pop_proj_data_df <- fromJSON(full_url)

## ------------------------------------------------------------------------
# encode the URL with characters for each space.
full_url <- URLencode(full_url)
full_url
pop_proj_data_df <- fromJSON(full_url)
head(pop_proj_data_df)

