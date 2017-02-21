#install.packages("tidyjson")

library(tidyjson)
library(dplyr)
library(httr)


##
## settings 
##

user <- "m.haverkamp"                                   ## my username
password <- "Rjira44"                                   ## my password
jira_url<- "https://nscommercie-jira.prepend.net"       ## url to jira site
jira_project<- "VIERJSA"                                ## Jira project name

data_dir <- "C:/PMD/R/R1102/datascience/pm" #Change the path to your located file 
setwd(data_dir)

## Retrieve all isssues from the given project <jira_project>
##
##  example https://nscommercie-jira.prepend.net/rest/api/2/search?jql=project=
##           VIERJSA&maxResults=-1
## output is a json table of issues <jsontbl_issue_list>

url_issue_list <- sprintf("%s/rest/api/2/search?jql=project=%s&maxResults=-1", jira_url, jira_project)

res <- GET(url = url_issue_list,
           authenticate(user = user, password = password, "basic"),
           add_headers("Content-Type" = "application/json"),
           verbose(data_out = verbose, data_in = verbose, info = verbose)
)

url_issue_list_live<- content(res, as = "text")          ## use text not parsed
jsontbl_issue_list <- as.tbl_json(url_issue_list_live)   ## class  "tbl_json"  "tbl""data.frame"

##
## tests
##
class(jsontbl_issue_list)



##
##  Report the total number of issues in a message
##

total_issues <- jsontbl_issue_list %>%
    spread_values(
        total = jnumber("total")
    )

message("Total issues retrieved: ", total_issues$total)


##
## create issue list
## local file url to test url_issue_list <- read_json("VIERJSA-issues.json")
## output is a list of issue numbers <issue_list>
##

jsontbl <- jsontbl_issue_list %>%   

   enter_object("issues")  %>%   
    gather_array %>%
    spread_values(
        historyId = jnumber("id"),  # Id of each activity      
        Key = jstring("key")
    )  
issue_list <- jsontbl$historyId


##
## Get issues from the list <issue_list> and get issue information
##  !! ToDo -> create loop to get all info
##  !! current output json table of 1 issue <jsontbl_issue>


issue<- issue_list[110]                                                             ## select 1 issue
url <- paste0(jira_url,"/rest/api/latest/issue/", issue, ".json?expand=changelog")  ## url to extract changelog json


res_issue <- GET(url = url,
           authenticate(user = user, password = password, "basic"),
           add_headers("Content-Type" = "application/json"),
           verbose(data_out = verbose, data_in = verbose, info = verbose)
)

json_issue<- content(res_issue, as = "text")  ## use text not parsed
jsontbl_issue <- as.tbl_json(json_issue)      ## class  "tbl_json"  "tbl""data.frame"

##
## tests
##
class(jsontbl_issue)


##
##  !! TODO   store all pages in a list first
##
library(jsonlite)
baseurl <- "https://nscommercie-jira.prepend.net/rest/api/2/issue/VIERJSA-"
end_url <- ".json?expand=changelog"
pages <- list()
for(i in 110:150){
    mydata <- fromJSON(paste0(baseurl, i, end_url))
    message("Retrieving page ", i)
    pages[[i+1]] <- mydata$filings
}
ddd <-paste0(baseurl, i, end_url)
#combine all into one
filings <- rbind.pages(pages)

#check output
nrow(filings)




##
## Extract objects of interest from json issue 
## Test file location: json <-read_json("VIERJSA-184_expand_changelog.json")
## output json table <jsontbl>


json <- jsontbl_issue
    

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
  
    
    enter_object("items") %>%
    gather_array %>%
    spread_values(
        field = jstring("field"),
        from = jstring("fromString"),
        to = jstring("toString")
    )  
jsontbl                           ## class  "tbl_json"  "tbl""data.frame"


jsontbl2 <- json %>%   
    spread_values(    
        IssueKey = jstring("key")  # Extract the key of the Issue
    ) %>%
    enter_object("changelog")  %>% 
    enter_object("histories")  %>% 
    gather_array %>%
    enter_object("author") %>%
    spread_values(
        author = jstring("name")
        )        
      
jsontbl2
    

##
## Get the columns that we wants and create a finaltable <finaltbl>
## Mutate the selected colums to an activity colum
##

df <- as.data.frame(jsontbl) 
finaltbl <- df[,c("IssueKey","historyId","createdTime","field","from","to")]


## Mutate the selected colums to an activity colum
finaltbl %>%
    mutate(activity = ifelse((field == 'Story Points' ), "Add story points",
                      ifelse((field == 'assignee' ), "Assigned",
                      ifelse((field == 'Sprint' & is.na(from)), "Open",
                      ifelse((field == 'status' & to == 'In Progress'), "In Progress",
                      ifelse((field == 'status' & to == 'Test'), "Test", 
                      ifelse((field == 'resolution' & to == 'Done'), "Done", 
                      ifelse((field == 'status' & to == 'Closed'), "Closed", NA))))))))

## change datetime stamp 
class(finaltbl$createdTime)
Sys.setlocale("LC_TIME", "English")
finaltbl$createdTime<- as.POSIXct(finaltbl$createdTime, format = "%Y-%m-%dT%H:%M:%S")

## create eventlog 
## !! todo create XES file  package edeaR
eventlog <- finaltbl[,c("IssueKey","createdTime","activity","field")]
names(eventlog)[1] <- "case_id"
names(eventlog)[2] <- "start_time"
