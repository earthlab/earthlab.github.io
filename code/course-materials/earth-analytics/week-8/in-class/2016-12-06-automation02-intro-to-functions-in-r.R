## ------------------------------------------------------------------------
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

## ------------------------------------------------------------------------
# freezing point of water
fahr_to_kelvin(32)
# boiling point of water
fahr_to_kelvin(212)

## ----kelv-to-cens--------------------------------------------------------
kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}

# absolute zero in Celsius
kelvin_to_celsius(0)

## ------------------------------------------------------------------------
fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

# freezing point of water in Celsius
fahr_to_celsius(32.0)

## ----chained-example-----------------------------------------------------
# freezing point of water in Celsius
kelvin_to_celsius(fahr_to_kelvin(32.0))

## ----challenge, echo=F---------------------------------------------------
## Solution
fence <- function(original, wrapper) {
 answer <- c(wrapper, original, wrapper)
 return(answer)
 }


## ----challenge-2---------------------------------------------------------
 best_practice <- c("Write", "programs", "for", "people", "not", "computers")
 asterisk <- "***"  # R interprets a variable with a single value as a vector
                    # with one element.
 fence(best_practice, asterisk)

## ---- echo=F-------------------------------------------------------------
outside <- function(v) {
   first <- v[1]
    last <- v[length(v)]
    answer <- c(first, last)
    return(answer)
}

## ----challenge-example---------------------------------------------------
 dry_principle <- c("Don't", "repeat", "yourself", "or", "others")
 outside(dry_principle)

## ----funct-environment---------------------------------------------------
fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

fahr_to_celsius(15)


## ----document-function---------------------------------------------------
# define function
fahr_to_celsius <- function(temp) {
  # function that converts temperature in farenheit to celcius
  # input: temperature in degrees F
  # output: temperature in censius
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

