data(iris)

head(iris)

unique(iris$Species)

table(iris$Species)

# Check scatter matrix of 4 variables
# each specy has a color
plot(iris[1:4], 
     col = as.integer(iris$Species)
     )

# Look into detail for the scatterplot of petal lenght and width
# it is homoscedastic, not heteroscedastic
plot(
  iris$Petal.Length,
  iris$Petal.Width,
  col = as.integer(iris$Species)
)

#Create k-mean cluster model
clusters <- kmeans(
  x = iris[,1:4],
  centers = 3, 
  nstart = 10    #Number of restart times
)

# Plot each cluster as a shape
plot(
  iris$Petal.Length,
  iris$Petal.Width,
  col = as.integer(iris$Species),
  pch = clusters$cluster
)

# Plot the centroid of clusters
points(
  x = clusters$centers[, "Petal.Length"],
  y = clusters$centers[, "Petal.Width"],
  pch = 4, 
  lwd = 4, 
  col = "blue"
)

# View how correct the clustering is
# by checking a contingency table

table(
  x = clusters$cluster, 
  y = iris$Species
)