#Package allowing the R code to communicate with the database
if(!require(RMySQL)){
  install.packages("RJDBC")
  library(RMySQL)
}


DB <- dbConnect(RMySQL::MySQL(), user="test", host="sql10413.webmo.fr",password="test", dbname="cellomet1")

dbGetQuery(DB, "show GRANTS;")



dbGetQuery(DB, paste0("INSERT INTO `questionnaire` (`Email`, `Type_of_Study`, `Comments`, `submit_date`) VALUES ('yohan.lefol@gmail.com', 'test_connect_real_config_marie', '#3', '2020-01-21');"))
