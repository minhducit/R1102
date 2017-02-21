#install.packages("tidyjson")

#install.packages("lubridate")

library(tidyjson)
library(dplyr)
library(httr)
library(jsonlite)
library(lubridate)

##
## settings 
##

user <- "m.haverkamp"                                   ## my username
password <- "Rjira44"                                   ## my password
jira_url<- "https://nscommercie-jira.prepend.net"       ## url to jira site
jira_project<- "VIERJSA"                                ## Jira project name
data_dir <- "C:/PMD/R/R1102/datascience/pm" #Change the path to your located file 
setwd(data_dir)

## Function:
## Retrieve all isssues from the given project <jira_project>
##
##  example https://nscommercie-jira.prepend.net/rest/api/2/search?jql=project=
##           VIERJSA&maxResults=-1
## output is a list of issues 

issue_list_extraction <- function(jira_url, jira_project, user, password) {

    url_issue_list <- sprintf("%s/rest/api/2/search?jql=project=%s&maxResults=-1", jira_url, jira_project)

    res <- GET(url = url_issue_list,
               authenticate(user = user, password = password, "basic"),
               add_headers("Content-Type" = "application/json")
    )

    url_issue_list_live<- content(res, as = "text")          ## use text not parsed
    jsontbl_issue_list <- as.tbl_json(url_issue_list_live)   ## class  "tbl_json"  "tbl""data.frame"

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
    return(issue_list)
}



issue_list<-issue_list_extraction(jira_url, jira_project, user, password)

##
## Function: issue_extraction 
## Get issues from the list <issue_list> and get issue information
## Output:

issue_extraction <- function(url, issue, user, password) {

    url <- paste0(jira_url,"/rest/api/latest/issue/", issue, ".json?expand=changelog")  
    res_issue <- GET(url = url,
               authenticate(user = user, password = password, "basic"),
               add_headers("Content-Type" = "application/json")
    )
    message("Retrieving page issue: ", issue)
    return(res_issue)
}

rm(pages)
pages <- list()
j<-0
max_issues<-length(issue_list) - 1
max_issues<-2

for(j in 0:max_issues){
    issue_id<- issue_list[j+1] 
    message("Issueing page ", j," issue: ", issue_id)
    res_return<-issue_extraction(url,issue_id,user,password)
    json_issue<- content(res_return, as = "text")  ## use text not parsed
    jsontbl_issue <- as.tbl_json(json_issue)      ## class  "tbl_json"  "tbl""data.frame"
    pages[[j+1]] <- jsontbl_issue
}


##
## tests
##
raw_2<-json_issue

jsontbl_raw_1 <- as.tbl_json(raw_1) 
jsontbl_raw_2 <- as.tbl_json(raw_2) 

pages[[1]] <- jsontbl_raw_1
pages[[2]] <- jsontbl_raw_2
filings <- rbind.pages(pages)

class(jsontbl_raw_1)
showConnections(all = TRUE)
getConnection(0)


##
## Function Extract objects of interest from json issue 
## Test file location: json <-read_json("VIERJSA-184_expand_changelog.json")
## output json table <jsontbl>

issue_tbl <- function(json) {

    jsontbl_1 <- json %>%   
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
    jsontbl_2 <- json %>%   
        spread_values(    
            IssueKey = jstring("key")  # Extract the key of the Issue
        ) %>%
        enter_object("changelog")  %>% 
        enter_object("histories")  %>% 
        gather_array %>%
        spread_values(
            historyId = jnumber("id") # Id of each activity 
        )%>%
        enter_object("author") %>%
        
        spread_values(
            author = jstring("name")
        )        

    jsontbl_1 <- as.data.frame(jsontbl_1)    ## merge differnt parts of the Json extraction
    jsontbl_2 <- as.data.frame(jsontbl_2) 
    
    jsontbl<- merge.data.frame(jsontbl_1,jsontbl_2, by.x = "historyId", by.y = "historyId")
    return(jsontbl)
}

rm(result)
##i<-5
result<-list()
max_pages<-length(pages)

for(i in 1:max_pages){

    issue_page <- pages[[i]]
    message("Retrieving page ", i)
    result[[i]]<-issue_tbl(issue_page)
}
jsontbl<-rbind.pages(result)





##
## Get the columns that we wants and create a finaltable <finaltbl>
## Mutate the selected colums to an activity colum
##

df <- as.data.frame(jsontbl) 
finaltbl <- jsontbl[,c("IssueKey.x","historyId","createdTime","field","from","to","author")]
#finaltbl$activity<- NA

#CHECK WHY DROP one columm makes mutated column disappeared

## Mutate the selected colums to an activity colum
finaltbl <- finaltbl %>%
    mutate(activity = ifelse((field == 'Story Points' ), "Add story points",
                      ifelse((field == 'assignee' ), "Assigned",
                      ifelse((field == 'Sprint' & is.na(from)), "Open",
                      ifelse((field == 'status' & to == 'In Progress'), "In Progress",
                      ifelse((field == 'status' & to == 'Test'), "Test", 
                      ifelse((field == 'resolution' & to == 'Done'), "Done", 
                      ifelse((field == 'status' & to == 'Closed'), "Closed", NA))))))))

##
# change datetime stamp 
## !! problem with micorseconds !!
##
class(finaltbl$createdTime)
Sys.setlocale("LC_TIME", "English")
##options(digits.secs = 3)
##finaltbl["start_time"] <- NA
##finaltbl$start_time<- as.POSIXct(finaltbl$createdTime, format = "%Y-%m-%dT%H:%M:%OS")

#finaltbl$createdTime<- as.POSIXct(finaltbl$createdTime, format = "%Y-%m-%dT%H:%M:%0S3")

options(digits.secs=3)
finaltbl$createdTime<- ymd_hms(finaltbl$createdTime)

## create eventlog 
## !! todo create XES file  package edeaR
eventlog <- finaltbl[,c("IssueKey.x","createdTime","activity","field","author" )]
names(eventlog)[1] <- "case_id"
names(eventlog)[2] <- "start_time"

eventlog

