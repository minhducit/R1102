#install.packages("tidyjson")

#library(jsonlite)
library(tidyjson)
library(dplyr)
#library(magrittr)

#library for viewing json




#json <- '[{"name": "bob1", "age": 32}, {"name": "susan", "age": 54}]'

setwd("C:/PMD/R/R1102/datascience/pm")
json <- read_json("VIERJSA-184_expand_changelog.json")
#json <- read_json("example.json",format = c("json", "jsonl", "infer"))

head(json, n = 3)

json


jsontbl <- json %>%   
  #as.tbl_json %>%  
  #gather_array %>%   #Only used if there are more than 1 record
  spread_values(    # Spread (widen) values to widen the data.frame
    IssueKey = jstring("key")  # Extract the "key" object as
  ) %>%
  enter_object("changelog")  %>% 
    #gather_array %>%
  enter_object("histories")  %>%   
    gather_array %>%
    spread_values(
      historyId = jnumber("id"),  # Extract the "key" object as      
      createdTime = jstring("created")
    ) %>%   
    enter_object("author") %>%
    spread_values(
      authorname = jstring("name")       
    )

jsontbl



