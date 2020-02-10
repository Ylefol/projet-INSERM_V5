#Package allowing the R code to communicate with the database
if(!require(RMySQL)){
  install.packages("RJDBC")
  library(RMySQL)
}

#Establish the connection
DB <- dbConnect(RMySQL::MySQL(), user="test", host="sqlgold.webmo.fr:50413",password="test", dbname="cellomet2")

#Establish the connection
DB <- dbConnect(RMySQL::MySQL(), user="test", host="sql10413.webmo.fr",password="test", dbname="cellomet2")

#Send the query and return results
dbGetQuery(DB, "SELECT * from `questionnaire`;")



