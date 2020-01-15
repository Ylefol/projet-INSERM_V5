#Package and library calls
#############################################################################################################################################


if(!require(devtools)){
  install.packages("devtools")
  library(devtools)
}

#DESeq2 is a Differential gene expression analysis based on the negative binomial distribution.
#This package allows the users to find significant genes within two files representing different conditions (ex/ old vs young pulmonary cancer patients)
if(!require(DESeq2)){
  install.packages("BiocManager")
  BiocManager::install("DESeq2")
  library( "DESeq2" )
  library(DESeq2)
}

#Simple package used to genereate MA plots and volcano plots
if(!require(ggplot2)){
  install.packages(ggplot2)
  library(ggplot2)
}

#Rshiny allows us to convert R code into an application
if(!require(shiny)){
  install.packages("shiny")
  library(shiny)
}

#A few widgets are used within this application
if(!require(shinyWidgets)){
  install.packages("shinyWidgets")
  library(shinyWidgets)
} 

#the DT, or DataTable package allows us to have clearer and well designed data tables to add to the user friendliness of the application
if(!require("DT")){
  install.packages("DT")
  library(DT)
}

#The shinyJS package is used to hide/show various elements of the application
if(!require("shinyjs")){
  install.packages("shinyjs")
  library(shinyjs)
}

#This package is essentially a function that allows us to use a directory selection button
if(!require("shinyDirectoryInput")){
  devtools::install_github('wleepang/shiny-directory-input')
  library(shinyDirectoryInput)
}

#An extra layer on shiny applications which results in a cleaner application
if(!require("shinydashboard")){
  install.packages("shinydashboard")
  library(shinydashboard)
}


#Package allowing the R code to communicate with the database
if(!require(RMySQL)){
  install.packages("RMySQL")
  library(RMySQL)
}

#A package that allows for better and cleaner pop-up messages
#In this code, these pop up messages are used to tell the user when the application is working and when downloads or analyses are done.
if(!require(shinyalert)){
  install.packages("shinyalert")
  library(shinyalert)
}

#A css add on to Rshiny which allows us to implement CSS solutions to the application
if(!require(shinycssloaders)){
  install.packages("shinycssloaders")
  library(shinycssloaders)
}

#Used for connecting to the internet, will be usefull for gene_symbol conversion
if(!require(tcltk)){
  install.packages("tcltk")
  library(tcltk)
}

#Used for connecting to the internet, will be usefull for gene_symbol conversion
if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}

#Used for connecting to the internet, will be usefull for gene_symbol conversion
if(!require(RCurl)){
  install.packages("RCurl")
  library(RCurl)
}


#############################################################################################################################################

#Loads the necessary files from the folder
source('myUI.R', local = TRUE)
source('myServer.R')


#Launches the application
shinyApp(
  ui = myUI,
  server = myserver
)


