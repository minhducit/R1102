#install.packages("tidyjson")

library(tidyjson)
library(dplyr)
#library(magrittr)

#library for viewing json
library(jsonlite)



#json <- '[{"name": "bob1", "age": 32}, {"name": "susan", "age": 54}]'
#prettify(json)

setwd("C:/PMD/R/R1102/datascience/pm")
json <- read_json("example.json",format = c("json", "jsonl", "infer"))

head(json)

jsontbl <- json %>%   
  gather_array %>%
  spread_values(    # Spread (widen) values to widen the data.frame
    user.name = jstring("name"),  # Extract the "name" object as a character column "user.name"
    user.age = jnumber("age")     # Extract the "age" object as a numeric column "user.age"
  )

jsontbl

#jsontbl$"user.name"


