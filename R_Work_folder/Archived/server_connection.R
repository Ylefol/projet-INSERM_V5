#Package allowing the R code to communicate with the database
if(!require(RMySQL)){
  install.packages("RJDBC")
  library(RMySQL)
}

#Establish the connection
DB <- dbConnect(RMySQL::MySQL(), user="cellomet_user", host="sqlgold.webmo.fr",password="Charly_Mike", dbname="cellomet1",port=50413)


#Send the query and return results
dbGetQuery(DB, "SELECT * from `questionnaire`;")



