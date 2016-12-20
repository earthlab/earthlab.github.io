## ----no-data-values------------------------------------------------------

planets <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus",
             "Neptune", NA)

## ---- read-na-values-custom----------------------------------------------

# import data with multiple no data values
planets_df <- read.csv(file = "planets.csv", na.strings = c("", " ", "-999"))

## ----math-no-data--------------------------------------------------------
heights <- c(2, 4, 4, NA, 6)
mean(heights)
max(heights)
mean(heights, na.rm = TRUE)
max(heights, na.rm = TRUE)

