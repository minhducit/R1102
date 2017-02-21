#install.packages("tidyr")
library(plyr)
library(dplyr)
library(tidyr)

setwd("C:/PMD/R/R1102/datascience/rwml/")

titanic <- read.csv("data/titanic.csv", 
                    colClasses = c(
                      Survived = "factor",
                      Name = "character",
                      Ticket = "character",
                      Cabin = "character"))

str(titanic)

titanic$Survived <- revalue(titanic$Survived, c("0"="no", "1"="yes"))

head(titanic$Cabin)

titanicNew <- titanic %>%
  separate(Cabin, into = "firstCabin", sep = " ", extra = "drop", remove = FALSE) %>%
  separate(firstCabin, into = c("cabinChar", "cabinNum"), sep = 1) %>%
  rowwise() %>%
  mutate(numCabins = length(unlist(strsplit(Cabin, " "))))


str(titanicNew)
