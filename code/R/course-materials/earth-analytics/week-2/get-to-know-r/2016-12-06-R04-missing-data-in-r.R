## ----no-data-values------------------------------------------------------

planets <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus",
             "Neptune", NA)


## ---- read-na-values-custom----------------------------------------------
# download file
download.file("https://ndownloader.figshare.com/files/7275959",
              "data/week2/temperature_example.csv")

# import data with multiple no data values
temp_df <- read.csv(file = "data/week2/temperature_example.csv")

temp_df2 <- read.csv(file = "data/week2/temperature_example.csv", na.strings = c("NA", " ", "-999"))


## ----na-remove-----------------------------------------------------------
mean(temp_df$avg_temp)
mean(temp_df2$avg_temp)

mean(temp_df2$avg_temp, na.rm = TRUE)

## ----math-no-data--------------------------------------------------------
heights <- c(2, 4, 4, NA, 6)
mean(heights)
max(heights)
mean(heights, na.rm = TRUE)
max(heights, na.rm = TRUE)

