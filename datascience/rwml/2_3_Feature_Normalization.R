#install.packages("tidyr")
#install.packages("ggplot2")
#install.packages("vcd")


library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(vcd)

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

normalizeFeature = function(data, fMin = -1.0, fMax = 1.0){
  dMin = min(na.omit(data))
  dMax = max(na.omit(data))
  factor = (fMax -fMin) / (dMax - dMin)
  normalized = fMin + (data - dMin)*factor
  normalized
}

titanic$AgeNormalized <- normalizeFeature(titanic$Age)
#ggplot(data=titanic, aes(AgeNormalized)) + geom_histogram()
ggplot(data=titanic, aes(AgeNormalized)) + geom_histogram()


mosaic(
  ~ Sex + Survived,
  data = titanic, 
  main = "Mosaic plot for Titanic data: Gender vs. survival",
  shade = TRUE,
  split_vertical = TRUE,
  labeling_args = list(
    set_varnames = c(
      Survived = "Survived?")))

