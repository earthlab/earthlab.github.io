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
# view url - notice spaces
full_url
# encode spaces with ascii value %20
full_url <- URLencode(full_url)
full_url
# Convert JSON api returned value to data frame
pop_proj_data_df <- fromJSON(full_url)
head(pop_proj_data_df)

## ------------------------------------------------------------------------
library(rjson)
# Convert JSON to data frame
# Base URL path
base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url = paste0(base_url, "county=Boulder",
             "&$where=age between 20 and 40",
             "&$select=year,age,femalepopulation")
# view full url
full_url
pop_proj_data_df <- fromJSON(full_url)

## ------------------------------------------------------------------------
# notice the url has spaces
full_url

pop_proj_data_df <- jsonlite::fromJSON(full_url)
pop_proj_data_df <- rjson::fromJSON(full_url)
pop_proj_data_df <- RJSONIO::fromJSON(full_url)

## ------------------------------------------------------------------------
# notice the url has spaces
full_url
# encode the url
full_url_encoded <- URLencode(full_url)
full_url_encoded


pop_proj_data_df <- jsonlite::fromJSON(full_url_encoded)
head(pop_proj_data_df)


## ------------------------------------------------------------------------
pop_proj_data_df1 <- rjson::fromJSON(full_url_encoded)

## ------------------------------------------------------------------------
pop_proj_geturl <- getURL(full_url_encoded)
pop_proj_data_df1 <- rjson::fromJSON(pop_proj_geturl)
head(pop_proj_data_df1, n=2)


## ------------------------------------------------------------------------
pop_proj_df_convert <- do.call(rbind.data.frame, pop_proj_data_df1)
head(pop_proj_df_convert)

## ------------------------------------------------------------------------
pop_proj_data_df2 <- RJSONIO::fromJSON(full_url_encoded)
head(pop_proj_data_df2, n=2)

