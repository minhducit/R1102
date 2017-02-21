library(MASS)

head(painters)



# Get mean of Composition from "C" school
school = painters$School

c_school = school == "C"

c_school_mean = mean(painters[c_school,]$Composition)

c_school_mean

# Get mean of Composition group by each type of school
tapply(painters$Composition, painters$School, mean)




# Get cummulative frequency distribution
duration = faithful$eruptions 
breaks = seq(1.5, 5.5, by=0.5) 
duration.cut = cut(duration, breaks, right=FALSE)  # cut a set into several interval, assign each element to its interval
duration.freq = table(duration.cut)

duration.cumfreq = cumsum(duration.freq)

# Draw the graph for the cummulative frequent dist. 
cumfreq0 = c(0, cumsum(duration.freq)) 
plot(breaks, cumfreq0,            # plot the data 
        main="Old Faithful Eruptions",  # main title 
        xlab="Duration minutes",        # x???axis label 
        ylab="Cumulative eruptions")   # y???axis label 

lines(breaks, cumfreq0)           # join the points


# Stem-and-Leaf Plot
duration2 = faithful$eruptions 

head(duration2)

stem(duration2)
