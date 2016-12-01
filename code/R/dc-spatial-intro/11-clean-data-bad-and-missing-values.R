## ----missing values------------------------------------------------------

# Check for NA values
sum(is.na(harMet15.09.11$datetime))
sum(is.na(harMet15.09.11$airt))


# view rows where the air temperature is NA
harMet15.09.11[is.na(harMet15.09.11$airt),]

