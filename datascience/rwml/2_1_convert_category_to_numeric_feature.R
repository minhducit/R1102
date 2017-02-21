personData <- data.frame(person = 1:2, 
                         name = c("Jane Doe", "John Smith"),
                         age = c(24, 41),
                         income = c(81200, 121000),
                         maritalstatus = c("single","married"))

personDataNew <- data.frame(personData[,1:4], 
                            model.matrix(~ maritalstatus - 1, 
                                         data = personData)) 

#model.matrix(~ maritalstatus - 1, data = personData)

str(personData)

str(personDataNew)

