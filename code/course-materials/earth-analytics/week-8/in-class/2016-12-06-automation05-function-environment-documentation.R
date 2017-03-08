## ----funct-environment---------------------------------------------------
## fahr_to_celsius <- function(fahr) {
##   kelvin <- fahr_to_kelvin(fahr)
##   celsius <- kelvin_to_celsius(kelvin)
##   celsius
## }
## 
## fahr_to_celsius(15)
## 

## ----document-function---------------------------------------------------
## fahr_to_celsius <- function(fahr) {
##   # convert temperature in fahrenheit to celsius
##   # args: temperature in degrees F (numeric)
##   # returns: temperature in degrees celsius (numeric)
##   kelvin <- fahr_to_kelvin(fahr)
##   celsius <- kelvin_to_celsius(kelvin)
##   celsius
## }

