data(iris)

head(iris)

unique(iris$Species)

table(iris$Species)

# Check scatter matrix of 4 variables
plot(iris[1:4])

# Look into detail for the scatterplot of petal lenght and width
# it is homoscedastic, not heteroscedastic
plot(
  iris$Petal.Length,
  iris$Petal.Width
)

x <- iris$Petal.Length
y <- iris$Petal.Width

model <- lm(y ~ x)

# Draw linear regression model on plot
lines(
  x = iris$Petal.Length,
  y = model$fitted,
  col = "red",
  lwd = 3
)

#Check the correlation coefficient

cor(
  x = iris$Petal.Length,
  y = iris$Petal.Width
)


summary(model)


predict (
  object = model,
  newdata = data.frame(x = c(2, 5, 7))  #NOTE: THE VARIABLE NAME SHOULD MATCH VARIABLE NAME IN MODEL
)