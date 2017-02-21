# Remove a column

origData <- data.frame(c(2, 3, 4 , 5), c(21, 31, 41 , 51), c(2, 3, 5 , 5), c("one", "two", "three" , "four"),
                       c("23.00", "13.00", "43" , "25"))

origData                       
                       
names(origData) <- c("columnA", "columnB", "columnC", "X", "columnD")
origData$X <- NULL


# Check duplicated columns or correlated columns to remove using cor() function
# if the cor() returns 1, these columns are the same (or moving in locksteps)
# then one can be removed as it does not add value for the final analysis

cor(origData[c("columnA", "columnB")])

# Check for duplication between two variables/columsn

#Get all rows that have mismatch between columnA and columnC 
mismatched <- origData[origData$columnA != origData$columnC, ]

nrow(mismatched)

# Some function for filtering
# !is.na(origData$columnA): Check each row value is not N.A
# origData$columnA != "ABC"


# Change format of a field.

class(origData$columnD)

# From Factor to numeric
origData$columnD <- as.numeric(levels(origData$columnD))[origData$columnD]

# From Characters to numeric
origData$columnD <- as.integer(origData$columnD)



# 

