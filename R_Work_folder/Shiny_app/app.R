
#Loads the necessary files from the folder
source('myUI.R', local = TRUE)
source('myServer.R')


#Launches the application
shinyApp(
  ui = myUI,
  server = myserver
)

