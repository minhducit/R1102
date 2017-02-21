https://app.pluralsight.com/player?course=r-data-analysis&author=matthew-renze&name=r-data-analysis-m3&clip=7&mode=live

#For univariate analysis

mean(movies$Runtimes)

median(movies$Runtimes)

mode = The most frequent item: table --> frequency of each item
which.max(table(movies$Runtimes))

min, max, range

diff(range(movies$Runtimes))

quantile(movies$Runtimes)

quantile(movies$Runtimes, 0.25)

quantile(movies$Runtimes, 0.90)

IQR(movies$Runtimes): Quantile range from 25% to 75%
  
  
variance: 
var()

standard deviation
sd()

#Show the total number of movies group by Ratings
table(movies$Rating)

#Use the moments package for the skewness and kertosis
library(moments)
skewness(movies$Runtimes): Positive number -> right skewed distribution, Negative -> left skewed....
kurtosis(movies$Runtimes): < 3: The peak is flatter than normal distribution, > 3: Steeper than normal dist.

plot(density(movies$Runtimes))

summary(movies$Runtimes)



#===========================================================
#For bivariate analysis

joint frequency/percentage <-> contingencytable = two way table = cross tabulation table matrix
table(genres$Genre, genres$Rating)


covariance - correlation
cov(movies$Runtimes, movies$Box.Office): Positive -> greater runtimes, greater Box.Office. However, the big number does not mean anything.

correlation coefficients:
cor(movies$Runtimes, movies$Box.Office): The bigger number the more correlated.


summary(movies)

  
Visualization: 
  
Spine Plot  /  Mosaic Plot
Scatter Plot: For two numeric variables (NOte: WHEN WE CAN SEE THAT THERE IS NO CORRELATION: When the regression line is horizontal)
Line graph

Bar Chart
Multiple Box plots





============= Visualization ==========
  
plot(movies$Rating)  --> Bar chart, each bar shows the number of movies corresponding to a certain Rate

or in Pie chart
pie(table(movie$Rating))


Dot plot:
  plot(x = movie$Runtime, 
       y = rep(0, nrow(movies)))
Box plot: 
  boxplot(
    x = movie$Runtime,
    xlab = "Runtime (minutes)",
    horizontal = TRUE)

histogram:
  hist(
    x = movie$Runtime,
    breaks = 10 #Increase this number to make it more fine grained
    )

  The most fined grain is using the density
  plot(density(movies$Runtime))
  
# Add dot plot to base of density plot
  
  points(
    x = movies$Runtime,
    y = rep(-0.0005, nrows(movies))
  )

  
spineplot(
  x = genres$Genre, 
  y = genres$Rating
)

mosaicplot(  #Similar to spineplot
  x = table(
    genres$Genre, 
    genres$Rating
  ),
  las = 3
)

scatterplot : Still for 2 variables
plot(
  x = movie$Runtime,
  y = movie$Box.Office
)

Line chart
plot(
  x = table(movie$Year),
  type = "l"
)


scatter plot matrix
plot(movies)

