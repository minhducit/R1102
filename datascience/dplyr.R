library(dplyr) 

# Current path
getwd()

# Deserialize R object from file
chicago <- readRDS("C:/PMD/R/R1102/data/chicago.rds")

dim(chicago)

# show the structure of the data frame
str(chicago)

names(chicago)[1:3]

#-------------------- SELECT: Select on variables (like RDBMS Select) -------------#
#Select subset of variables from city to dptp
subset <- select(chicago, city:dptp)

head(subset)

#select all except variables from city to dptp
remain <- select(chicago, -(city:dptp))

head(remain)

#other method
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[,-(i:j)])


#Select all varibales that ends with a "2"
subset <- select (chicago, ends_with("2"))
str(subset)

#Select all varibales that starts with a "d"
subset <- select (chicago, starts_with("d"))
str(subset)

#-------------------- FILTER: Filter on rows (like RDBMS Select predicate) ----------#
chic.f <- filter(chicago, pm25tmean2 > 30)
str(chic.f)

summary (chic.f$pm25tmean2)

chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
select (chic.f, date, tmpd, pm25tmean2)

#-------------------- ARRANGE: Reorder the rows (like RDBMS Order by ) ----------#

chicago <- arrange(chicago, date)

head(select(chicago, date, pm25tmean2))

tail(select(chicago, date, pm25tmean2))

#sort by desc order
chicago <- arrange(chicago, desc(date))

head(select(chicago, date, pm25tmean2))

tail(select(chicago, date, pm25tmean2))


#--------------------- RENAME --------------------------------------------------#
head(chicago[,1:5], 3)

chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)
head(chicago[1:5], 3)

#---------MUTATE: Create new variable as a function of a variable 
chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(chicago)

#---------TRANSMUTATE: Create new variable as a function of a variable 
head(transmute(chicago, 
               pm10detrend = pm10tmean2 - mean(pm10tmean2, na.rm = TRUE),
               o3detrend = o3tmean2 - mean(o3tmean2, na.rm = TRUE)))

#---------GROUP BY

#create a year variable
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)

years <- group_by(chicago, year)

#summarize by groups
summarize(years, pm25 = mean(pm25, na.rm = TRUE),
          o3 = max(o3tmean2, na.rm = TRUE),
          no2 = median(no2tmean2, na.rm = TRUE))

#get 
qq <- quantile(chicago$pm25, seq(0, 1, 0.2), na.rm = TRUE)
chicago <- mutate(chicago, pm25.quint = cut(pm25, qq))

quint <- group_by(chicago, pm25.quint)

summarize(quint, o3 = mean(o3tmean2, na.rm = TRUE),
          no2 = mean(no2tmean2, na.rm = TRUE))


# ------------- %>% : Pipe line operator
mutate(chicago, pm25.quint = cut(pm25, qq)) %>%
  group_by(pm25.quint) %>%
  summarize(o3 = mean(o3tmean2, na.rm = TRUE),
            no2 = mean(no2tmean2, na.rm = TRUE))
  


