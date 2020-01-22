#Package allowing the R code to communicate with the database
if(!require(RMySQL)){
  install.packages("RJDBC")
  library(RMySQL)
}

if(!require(keyring)){
  install.packages("keyring")
  library(keyring)
}

#key_set("ddb")



DB <- dbConnect(RMySQL::MySQL(), user="cellomet1", host="sql25.webmo.fr",password=key_get("ddb"), dbname="cellomet1")

dbGetQuery(DB, paste0("INSERT INTO `questionnaire` (`Email`, `Type_of_Study`, `Comments`, `submit_date`) VALUES ('yohan.lefol@gmail.com', 'test_connect_real_marie', '#3', '2020-01-21');"))
