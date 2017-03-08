## ------------------------------------------------------------------------
fahr_to_kelvin <- function(fahr) {
  kelvin <- ((fahr - 32) * (5 / 9)) + 273.15
  kelvin
}

## ------------------------------------------------------------------------
# freezing point of water
fahr_to_kelvin(32)
# boiling point of water
fahr_to_kelvin(212)

## ----kelv-to-cens--------------------------------------------------------
kelvin_to_celsius <- function(kelvin) {
  celsius <- kelvin - 273.15
  celsius
}

# absolute zero in Celsius
kelvin_to_celsius(0)

## ------------------------------------------------------------------------
fahr_to_celsius <- function(fahr) {
  kelvin <- fahr_to_kelvin(fahr)
  celsius <- kelvin_to_celsius(kelvin)
  celsius
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

