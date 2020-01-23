#Package allowing the R code to communicate with the database
if(!require(RMySQL)){
  install.packages("RJDBC")
  library(RMySQL)
}

if(!require(config)){
  install.packages("config")
  library(config)
}
getwd()
setwd("C:/Users/yohan/Desktop/projet-INSERM_V5/R_Work_folder/Archived")
dw <- config::get("datawarehouse")

DB <- dbConnect(RMySQL::MySQL(), user=dw$uid, host=dw$server,password=dw$pwd, dbname=dw$database)

dbGetQuery(DB, "show GRANTS;")



dbGetQuery(DB, paste0("INSERT INTO `questionnaire` (`Email`, `Type_of_Study`, `Comments`, `submit_date`) VALUES ('yohan.lefol@gmail.com', 'test_connect_real_config_marie', '#3', '2020-01-21');"))
