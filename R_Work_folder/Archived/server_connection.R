#Package allowing the R code to communicate with the database
if(!require(RMySQL)){
  install.packages("RJDBC")
  library(RMySQL)
}

#Establish the connection
DB <- dbConnect(RMySQL::MySQL(), user="root", host="localhost",password="", dbname="cellomet1",port=3306)


#Send the query and return results
dbGetQuery(DB, "SELECT * from `questionnaire`;")



