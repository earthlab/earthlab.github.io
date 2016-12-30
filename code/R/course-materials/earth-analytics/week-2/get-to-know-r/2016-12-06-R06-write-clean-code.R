## ----example-code-messy, eval=FALSE--------------------------------------
## 
## #my code
## 
## #load stuff
## library(ggplot2)
## 
## #turn off factors
## options(stringsAsFactors = FALSE)
## 
## 1variable <- 3 * 6
## meanVariable <- 1variable
## 
## #calculate something important
## mean-variable <- meanvariable * 5
## 
## thefinalthingthatineedtocalculate <- mean-variable + 5
## 
## #get things that are important
## download.file(url = "https://ndownloader.figshare.com/files/7010681",
##               destfile = "data/boulder-precip.csv")
## 
## my.data <- read.csv(file="data/boulder-precip.csv")
## head(my_data)
## 
## str(my.data)
## 
## qplot(x=my.data$DATE,
##       y=my.data$PRECIP)
## 
## 
## 

