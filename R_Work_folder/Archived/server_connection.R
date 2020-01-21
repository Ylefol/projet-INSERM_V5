#Package allowing the R code to communicate with the database
if(!require(RMySQL)){
  install.packages("RJDBC")
  library(RMySQL)
}


DB <- dbConnect(RMySQL::MySQL(), user="cellomet1", host="https://sql.webmo.fr",
                password="cellomet1", dbname="cellomet1")

