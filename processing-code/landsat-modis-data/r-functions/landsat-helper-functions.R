
# Helper functions for working with landsat 8 data ------------------------
library(raster)
library(dplyr)

load_bands <- function(directory) {
  # Load multiple tif bands into one raster stack
  # args: directory (string) - the directory containing tif files to be read
  # returns: a raster stack
  # get list of tif files
  
  landsat_bands <- list.files(directory, 
                              pattern = glob2rx("*band*.tif$"), 
                              full.names = TRUE)
  landsat_stack <- stack(landsat_bands)
  landsat_stack
}

calc_ndvi <- function(landsat_stack) {
  # Calculate ndvi from a raster stack using band math
  # args: raster stack with landsat 8
  # returns: a raster containing ndvi
  numerator <- landsat_stack[[5]] - landsat_stack[[4]]
  denominator <- landsat_stack[[5]] + landsat_stack[[4]]
  ndvi <- numerator / denominator
  ndvi
}


calc_nbr <- function(landsat_stack) {
  # Calculate normalized burn ratio from a raster stack using band math
  # args: raster stack with landsat 8
  # returns: a raster containing nbr
  numerator <- landsat_stack[[4]] - landsat_stack[[7]]
  denominator <- landsat_stack[[4]] + landsat_stack[[7]]
  nbr <- numerator / denominator
  nbr
}

calc_index <- function(landsat_stack, which_index) {
  # Calculate an index (ndvi or nbr)
  # args: 
  #     - landsat_stack (raster stack)
  #     - which_index (string): must be "ndvi" or "nbr"
  # return: the index raster (ndvi or nbr)
  if (which_index == "ndvi") {
    index_raster <- calc_ndvi(landsat_stack)
  } else if (which_index == "nbr") {
    index_raster <- calc_nbr(landsat_stack)
  } else {
    stop("Invalid index provided. which_index must be 'ndvi' or 'nbr'")
  }
  index_raster
}


reclassify_ndvi <- function(ndvi) {
  # Reclassify ndvi according to a classification matrix
  # args: raster stack with ndvi
  # return: reclassified raster stack
  classification_matrix <- c(-1, -.2, 1,
                             -.2, .2, 2,
                             .2, .5, 3,
                             .5, 1, 4) %>%
    matrix(ncol = 3, byrow = TRUE)
  
  
  
  ndvi_classified <- reclassify(ndvi, classification_matrix)
  ndvi_classified
}


reclassify_nbr <- function(nbr) {
  # Reclassify normalized burn ratio according to a classification matrix
  # args: raster stack with nbr
  # return: reclassified raster stack
  classification_matrix <- c(-1.0, -.1, 1,
                             -.1, .1, 2,
                             .1, .27, 3,
                             .27, .66, 4,
                             .66, 1.3, 5) %>%
    matrix(ncol = 3, byrow = TRUE)
  nbr_classified <- reclassify(nbr, classification_matrix)
  nbr_classified
}
