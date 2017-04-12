## ----echo=FALSE----------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning=FALSE)


## ------------------------------------------------------------------------
#NOTE: if you have problems with ggmap, try to install both ggplot and ggmap from github
#devtools::install_github("dkahle/ggmap")
#devtools::install_github("hadley/ggplot2")
library(ggmap)
library(ggplot2)
library(dplyr)
library(rjson)
library(jsonlite)
library(RCurl)

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
# encode the URL with characters for each space.
full_url <- URLencode(full_url)
full_url


## ------------------------------------------------------------------------
library(rjson)

# Convert JSON to data frame
pop_proj_data_df <- fromJSON(getURL(full_url))
head(pop_proj_data_df, n = 2)
typeof(pop_proj_data_df)


## ----eval=FALSE, echo=FALSE----------------------------------------------
## # turn list into data.frame -- this is only needed if you use rjson instead of jsonlite
## pop_proj_data_df <- do.call(rbind.data.frame, pop_proj_data_df)
## head(pop_proj_data_df)

## ----eval=FALSE----------------------------------------------------------
## base_url <- "https://data.colorado.gov/resource/tv8u-hswn.json?"
## getForm(base_url, county="Boulder",
##              age="BOULDER")

## ----eval=FALSE----------------------------------------------------------
## # get the data from the specified url using RCurl
## pop_proj_data <- getURL(URLencode(full_url))

## ------------------------------------------------------------------------
# view data structure
str(pop_proj_data_df)

## ------------------------------------------------------------------------
# turn columns to numeric and remove NA values
pop_proj_data_df <- pop_proj_data_df %>%
 mutate_at(c( "age", "year", "femalepopulation"), as.numeric)

str(pop_proj_data_df)

## ---- eval=FALSE---------------------------------------------------------
## # convert EACH row to a numeric format
## # note this is the clunky way to do what we did above with dplyr!
## pop_proj_data_df$age <- as.numeric(pop_proj_data_df$age)
## pop_proj_data_df$year <- as.numeric(pop_proj_data_df$year)
## pop_proj_data_df$femalepopulation <- as.numeric(pop_proj_data_df$femalepopulation)
## 
## # OR use the apply function to convert all rows in the data.frame to numbers
## #pops <- as.data.frame(lapply(pop_proj_data_df, as.numeric))

## ----plot_pop_proj, fig.cap="Female population age 20-40."---------------
# plot the data
ggplot(pop_proj_data_df, aes(x=year, y=femalepopulation,
 group=factor(age), color=age)) + geom_line() +
     labs(x="Year",
          y="Female Population - Age 20-40",
          title="Projected Female Population",
          subtitle = "Boulder, CO: 1990 - 2040")

## ----male-population, echo=FALSE, fig.cap="Male population ages 60-80."----
# Base URL path
base_url <- "https://data.colorado.gov/resource/tv8u-hswn.json?"
full_url_males_80 <- paste0(base_url, "county=Boulder",
             "&$where=age between 60 and 80",
             "&$select=year,age,malepopulation")

full_url_males_80 <- URLencode(full_url_males_80)
# get the data from the specified url
pop_proj_data_males_80 <- fromJSON(full_url_males_80)
# turn into dataframe
# pop_proj_data_males_80_df <- do.call(rbind.data.frame, pop_proj_data_males_80)

# turn columns to numeric and remove NA values
pop_proj_data_males_80_df %>%
 mutate_at(c( "age", "malepopulation", "year"), as.numeric) %>%
 # plot the data
 ggplot(aes(x=year, y=malepopulation,
   group=factor(age), color=age)) + geom_line() +
     labs(x="Year",
          y="Male Population age 60-80",
         title="Projected Male Population - Age 60-80",
         subtitle = "Boulder, CO: 1990 - 2040")

