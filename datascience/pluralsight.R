https://app.pluralsight.com/player?course=r-data-analysis&author=matthew-renze&name=r-data-analysis-m3&clip=7&mode=live

# Check the number of NA values in a data frame (from all varibales)
# movies is the data frame

sum(is.na(movies))

# Remove all rows contain na
movies <- na.omit(movies)

# Check type of a column
class(movies$Runtime)

# Cast from Factor datatype to character
runtimes <- as.character(movie$Runtime)


# Substitute a string in each element of the variable/column
runtimes <- sub("originalstring or regular experession", "newstring", runtimes)

#sub only replace the first occurrence, gsub function can be used to replace all

# Check if a string contains a certain pattern using grepl 
if (grepl("M", boxoffice)){
  #do/return smth
} else if (grepl("k", boxoffice)){
  #do/return smth
} 



#sapply: Apply a function to a each element collection 
#tapply: Apply a function with group by to another variable
tapply(movies$Box.Office, movies$Rating, mean)


#Loading data: Pay a bit attention to double quote
out <- read.csv(file = "ABC.csv", quote = "\"")