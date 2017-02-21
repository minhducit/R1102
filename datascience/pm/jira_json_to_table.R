#install.packages("tidyjson")

library(tidyjson)
library(dplyr)

#Change the path to your located file 
setwd("C:/PMD/R/R1102/datascience/pm")
json <- read_json("VIERJSA-184_expand_changelog.json")

jsontbl <- json %>%   
  spread_values(    
    IssueKey = jstring("key")  # Extract the key of the Issue
  ) %>%
  enter_object("changelog")  %>% 
    enter_object("histories")  %>%   
    gather_array %>%
    spread_values(
      historyId = jnumber("id"),  # Id of each activity      
      createdTime = jstring("created")
    ) %>%   
      enter_object("author") %>%
      spread_values(
        author = jstring("name")       
      )


jsontbl

#Get the columns that we wants
finaltbl <- jsontbl[,c("IssueKey","historyId","createdTime","author")]

finaltbl

write.table(finaltbl, file="jira.csv",col.names = TRUE, row.names = FALSE, sep = ",")
