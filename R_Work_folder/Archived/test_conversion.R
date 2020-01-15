library(tcltk)
# We need libraries to read and parse URL
library(RCurl)
# install.packages("tidyverse")
library(tidyverse)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

#"C:\\Users\\yohan\\Desktop\\for_test.csv"

convert_gene_to_hsa<-function(path)
{
  
  #Read the data inputed by the user
  data <- read.csv(path)
  
  #Put the data in a new variable
  newdata <- data[,"Genes"]
  
  #Instantiate three empty vectors
  entrez = c()
  Genes=c()
  missing=c()
  
  #Start a for loop that will iterate through each gene in the inputed file
  for (g in 1:length(newdata[[1]])) {
    #'open' the website that corresponds to the gene of the current iteration
    query = paste("http://rest.kegg.jp/find/hsa/",newdata$Genes[g],sep="")
    #Store the query result in a variable
    result = getURL(query)
    #If the website does not exists, i.e gene symbol not found
    if (result=="\n"){
      #Gene symbol not found, therefore the gene is sorted as 'missing'
      missing<-c(missing,as.character(newdata$Genes[g]))
      #Go straight to the next iteration, saves time and prevents bugs
      next()
    }
    #The query returned a webpage containing one or more lines, each line is stored in list and split via \n (one line per list slot)
    my_list <- strsplit(result,"\n")
    
    #Initiate a counter before each iteration of a query result
    found_this_many = 0
    #For loop checks each element of the list (each line of the website) and checks which line contains the desired gene symbol
    for (i in 1:length(my_list[[1]])){
      #Takes the found line and stores it as a vector
      x <- str_replace(my_list[[1]][i],"\t"," ")
      #4 regular expressions that will cover all possibilities of finding a match
      check_comma_tab <- as.character(str_match (x,as.character(paste("\t",newdata$Genes[g],",",sep=""))))
      check_comma_space <- as.character(str_match (x,as.character(paste(" ",newdata$Genes[g],",",sep=""))))
      check_semicolon_tab <- as.character(str_match (x,as.character(paste("\t",newdata$Genes[g],";",sep=""))))
      check_semicolon_space <- as.character(str_match (x,as.character(paste(" ",newdata$Genes[g],";",sep=""))))
      
      #At least one of the regexes found a match
      if (is.na(check_comma_tab)==FALSE | is.na(check_comma_space)==FALSE | is.na(check_semicolon_tab)==FALSE | is.na(check_semicolon_space)==FALSE){
        #Update the counter as a match was found
        found_this_many = found_this_many + 1
        #This ensures that only one match is added in, preventing duplicates
        if (found_this_many == 1){
          Genes<-c(Genes,as.character(newdata$Genes[g]))
          entrez = c(entrez, strsplit(x," ")[[1]][1])
        }
        #If no regex matched, the loop is on the last iteration AND no genes were previously found, it means there is no hsa equivalent
      }else if(i==length(my_list[[1]])&found_this_many==0){
        #No hsa found, thus stored as missing
        missing<-c(missing,as.character(newdata$Genes[g]))
      }
    }
  }
  
  # Squash the found genes list and the hsa equivalent
  with_hsa <- cbind(Genes, entrez)
  
  #Create a list with only the hsa list
  found <- with_hsa[grep("hsa:", with_hsa[,"entrez"]), ]
  
  #Writes the hsa table
  write.table(found[,"entrez"], file = "hsa_ID.txt", row.names=FALSE, col.names=FALSE,sep=",",quote = FALSE)
  
  #Write the found and missing table
  write.table(found, file = "convert.txt", row.names=FALSE, col.names=TRUE,sep=",",quote=FALSE)
  write.table(missing, file = "missing.txt", row.names=FALSE, col.names=TRUE,sep=",",quote=FALSE)
  
}

