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
  # function that converts temperature in fahrenheit to celsius
  # input: temperature in degrees F (must be a numeric value)
  # output: temperature in celsius (numeric)
  # return: temperature in celsius (numeric)
  temp_k <- fahr_to_kelvin(temp)
  result <- kelvin_to_celsius(temp_k)
  return(result)
}

