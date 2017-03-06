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

## ---- echo=-1------------------------------------------------------------
fence <- function(original, wrapper) {
    answer <- c(wrapper, original, wrapper)
    return(answer)
 }
 best_practice <- c("Write", "programs", "for", "people", "not", "computers")
 asterisk <- "***"  # R interprets a variable with a single value as a vector
                    # with one element.
 fence(best_practice, asterisk)

## ---- echo=F-------------------------------------------------------------
## Solution
fence <- function(original, wrapper) {
 answer <- c(wrapper, original, wrapper)
 return(answer)
 }


## ---- echo=-1------------------------------------------------------------
outside <- function(v) {
   first <- v[1]
    last <- v[length(v)]
    answer <- c(first, last)
    return(answer)
}
 dry_principle <- c("Don't", "repeat", "yourself", "or", "others")
 outside(dry_principle)

## ----funct-environment---------------------------------------------------
fahr_to_celsius <- function(temp) {
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

fahr_to_celsius(15)


## ------------------------------------------------------------------------
input_1 = 20
mySum <- function(input_1, input_2 = 10) {
  output <- input_1 + input_2
  return(output)
}

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

## ----rescale-test, include=FALSE, eval=F---------------------------------
## answer <- rescale(dat[, 4])
## min(answer)
## max(answer)
## plot(answer)
## plot(dat[, 4], answer)  # This hasn't been introduced yet, but it may be
##                         # useful to show when explaining the answer.

## ---- eval=F-------------------------------------------------------------
## dat <- read.csv("data/inflammation-01.csv", FALSE)

## ---- error = TRUE, eval=F-----------------------------------------------
## dat <- read.csv(header = FALSE, file = "data/inflammation-01.csv")
## dat <- read.csv(FALSE, "data/inflammation-01.csv")

## ---- eval=F-------------------------------------------------------------
## center <- function(data, desired = 0) {
##   # return a new vector containing the original data centered around the
##   # desired value (0 by default).
##   # Example: center(c(1, 2, 3), 0) => c(-1, 0, 1)
##   new_data <- (data - mean(data)) + desired
##   return(new_data)
## }

## ---- eval=F-------------------------------------------------------------
## test_data <- c(0, 0, 0, 0)
## center(test_data, 3)

## ---- eval=F-------------------------------------------------------------
## more_data <- 5 + test_data
## more_data
## center(more_data)

## ---- eval=F-------------------------------------------------------------
## display <- function(a = 1, b = 2, c = 3) {
##   result <- c(a, b, c)
##   names(result) <- c("a", "b", "c")  # This names each element of the vector
##   return(result)
## }
## 
## # no arguments
## display()
## # one argument
## display(55)
## # two arguments
## display(55, 66)
## # three arguments
## display (55, 66, 77)

## ---- eval=F-------------------------------------------------------------
## # only setting the value of c
## display(c = 77)

## ---- eval=FALSE---------------------------------------------------------
## ?read.csv

## ---- eval=FALSE---------------------------------------------------------
## read.csv(file, header = TRUE, sep = ",", quote = "\"",
##          dec = ".", fill = TRUE, comment.char = "", ...)

## ---- results="hide", error = TRUE, eval=F-------------------------------
## dat <- read.csv(FALSE, "data/inflammation-01.csv")

## ---- include=FALSE, eval=F----------------------------------------------
## rescale <- function(v, lower = 0, upper = 1) {
##   # Rescales a vector, v, to lie in the range lower to upper.
##   L <- min(v)
##   H <- max(v)
##   result <- (v - L) / (H - L) * (upper - lower) + lower
##   return(result)
## }
## answer <- rescale(dat[, 4], lower = 2, upper = 5)
## min(answer)
## max(answer)
## answer <- rescale(dat[, 4], lower = -5, upper = -2)
## min(answer)
## max(answer)

