#install.packages("caret", dependencies = TRUE)
#install.packages("randomForest")
#install.packages("fields")

library(caret)
library(randomForest)

setwd("C:/PMD/R/R1102/data/titanic")

trainset <- read.table("train.csv", sep = ",", header = TRUE)

testset <- read.table("test.csv", sep = ",", header = TRUE)

head(trainset)

head(testset)

#Crosstabs for categorical variables
table(trainset[,c("Survived", "Pclass")])

#Try to plot to check the correlation

library(fields)
bplot.xy(trainset$Survived, trainset$Age)

bplot.xy(trainset$Survived, trainset$Pclass)

bplot.xy(trainset$Survived, trainset$Fare)

#Train data 
trainset$Survived <- factor(trainset$Survived)

set.seed(42)

model <- train(Survived ~ Pclass + Sex + SibSp + Embarked + Parch + Fare, #Survived is a function of features included
               data = trainset, method = "rf", #Random forest
               trControl = trainControl(method = "cv", number = 5) # Use 5-fold cross validation
               )


model

#testset$Survived <- predict(model, newdata = testset) #Error occurs as one variable does not have value

summary(testset) #Show that the Fare has one N.A

#If there is any N.A in Fare, replace by the mean value

testset$Fare <- ifelse(is.na(testset$Fare), mean(testset$Fare, na.rm = TRUE), testset$Fare)

testset$Survived <- predict(model, newdata = testset) 

head(testset)

#Prepare to submit solution
submission <- testset[,c("PassengerId", "Survived")]
write.table(submission, file="submission.csv",col.names = TRUE, row.names = FALSE, sep = ",")


