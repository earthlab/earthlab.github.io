---
layout: single
title: "What Could be Improved In this R Code?"
excerpt: ""
authors: ['Leah Wasser', 'Max Joseph']
modified: '2017-12-08'
category: [courses]
class-lesson: ['automating-your-science-r']
permalink: /courses/earth-analytics/automate-science-workflows/example-clean-code-activity-r/
nav-title: "Clean Code Activity"
module-type: 'class'
course: "earth-analytics"
week: 6
sidebar:
  nav:
author_profile: false
comments: true
topics:
  reproducible-science-and-programming: ['literate-expressive-programming', 'functions']
order: 2
---

{% include toc title="In This Lesson" icon="file-text" %}



<div class='notice--success' markdown="1">

## <i class="fa fa-graduation-cap" aria-hidden="true"></i> Learning Objectives

After completing this tutorial, you will be able to:


## <i class="fa fa-check-square-o fa-2" aria-hidden="true"></i> What You Need

You will need a computer with internet access to complete this lesson.

</div>



```r
#start my analysis
read.csv("data/week-06/outputs/precip_mm/precip-2003.csv")
plot(data)

mydata <- read.csv("data/week-06/outputs/precip_mm/precip-2003.csv")
myData$newcolumn <- mydata$precip * 12 / 2
my.data <-read.csv("data/week-06/outputs/precip_mm/precip-2004.csv")
my.data$newcolumn <- mydata$precip * 12 / 2
my.data<-read.csv("data/week-06/outputs/precip_mm/precip-2006.csv")
my.data$newcolumn <- mydata$precip * 12 / 2
my.data <-read.csv("data/week-06/outputs/precip_mm/precip-2007.csv")
my.data$newcolumn <- mydata$precip * 12 / 2
my.data <-read.csv("data/week-06/outputs/precip_mm/precip-20010.csv")
my.data$newcolumn <- mydata$precip * 12 / 2
plot(mydata)
#export stuff -  i should do this for all of my csv files
write.csv(mydata)


my.data <-read.csv("data/week-06/outputs/precip_mm/precip-2008.csv")
my.data$newcolumn <- mydata$month
#testing some stuff with pipes
outputs <- my.data %>%
  mutate(newcolumn = "fredyymack") %>%
  group_by(month) %>%
  summarise(mean(Precip_MM))

plot(mydata)
#export stuff
write.csv(mydata)

my.data <-read.csv("data/week-06/outputs/precip_mm/precip-2009.csv")
my.data$newcolumn <- mydata$month
#testing some stuff with pipes
outputs <- my.data %>%
  mutate(newcolumn = "fredyymack") %>% #i dont think i need this column do i?
  group_by(month) %>%
  summarise(mean(Precip_MM))

plot(mydata)
#export stuff
write.csv(mydata)

my.data <-read.csv("data/week-06/outputs/precip_mm/precip-2006.csv")
my.data$newcolumn <- mydata$month
#testing some stuff with pipes
outputs2 <- my.data %>%
  mutate(newcolumn = "fredyymack") %>%
  group_by(month) %>%
  summarise(mean(Precip_MM))

plot(mydata)
#export stuff
write.csv(mydata)

my.data <-read.csv("data/week-06/outputs/precip_mm/precip-2009.csv")
my.data<-read.csv("data/week-06/outputs/precip_mm/precip-2012.csv")
my.data <-read.csv("data/week-06/outputs/precip_mm/precip-2013.csv")

#not sure why everything isn't plotting
plot(my.data)
plot(my.data)
plot(mydata)
plot(my.data)
plot(my.data)

#testing some stuff with pipes
my.data %>%
  mutate(newcolumn = "fredyymack") %>%
  group_by(month) %>%
  summarise(mean(Precip_MM))


#testing some stuff with pipes
outputs <- my.data %>%
  mutate(newcolumn = "fredyymack") %>%
  group_by(month) %>%
  summarise(mean(Precip_MM))


ggplot(outputs, aes(y=month, x=precipmm)) +
  geom_point()

#need to do this to all of my data
#testing some stuff with pipes
#mydata <- my.data %>%
#  mutate(newcolumn = "fredyymack") %>%
#  group_by(month) %>%
#  summarise(mean(Precip_MM))



#export the data to a csv
write.csv(mydata)


library(dplyr)
library(ggplot2)
```
