#Loads in the functions from the myFunctions.R file, they can then be called using their names from the myFunctions file
source('myFunctions.R')

#Handles the 'actions' that are done within the application
myserver <- function(input, output, session) {
  
  #Results page set up and function declaration
  #############################################################################################################################################
  
  #Hides the results table as they will be empty/non-existant
  hideTab(inputId = "results_tabs", target = "Significant Genes")
  hideTab(inputId = "results_tabs", target = "Non_Canonic")
  hideTab(inputId = "results_tabs", target = "Canonic")
  hideTab(inputId = "results_tabs", target = "References")
  
  #Create a function that will show the results table if there are results to show (based on number of rows)
  #The function is declared here as it contains server specific objects (output), thus it can only be declared within the server
  show_results <- function(List_of_results)
  {
    if (nrow(List_of_results[["sig_genes"]])>0){
      output$sig_genes <- DT::renderDataTable({
        DT::datatable(data=List_of_results[["sig_genes"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
      })
      if(nrow(List_of_results[["ncan"]])>0) {
        output$Ncan <- DT::renderDataTable({
          DT::datatable(data=List_of_results[["ncan"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
        })
        output$Can <- DT::renderDataTable({
          DT::datatable(data=List_of_results[["can"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
        })
        output$refs <- DT::renderDataTable({
          DT::datatable(data=List_of_results[["refs"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
        })
      }else{
        output$results_status<- renderText("No non-canonical genes were found")
      } 
    }else{
      output$results_status<- renderText("No significant genes were found")
    }
    
    
  }
  #############################################################################################################################################
  
  #Generate the pdf in the information tab
  #############################################################################################################################################
  
  #addResourcePath("pdf_folder","C:/Users/yohan/Desktop/Projet-INSERM/Latex_folder")
  output$path <- renderUI({tags$iframe(src="user_guide.pdf",style="height:800px; width:100%;scrolling=yes")})
  
  
  #############################################################################################################################################
  
  #Exit's observe event
  #############################################################################################################################################
  #When the exit app (id=close) button is clicked, connections are killed and the app is stopped
  observeEvent(input$close,{
    killDbConnections()
    
    js$closeWindow()
    stopApp()
  })
  
  #############################################################################################################################################
  
  #Custom MA plot
  #############################################################################################################################################
  
  #Uses a validate as this is the only way to hide the spinner until a button is pressed
  output$custom_MA_plot <-renderPlot({validate(need(input$create_MA, ""))
    input$create_MA
    #Disables the buttons
    enable_disable_MA_plot(FALSE)
    
    #Runs the function to create the plot
    #Isolate is used to ensure that the plot creation is not reactive and only called when a button is clicked
    isolate({suppressWarnings(custom_MA_plot(input$file_custom_MA$datapath,
                                             sig_pval = input$p_value_thresh_MA, 
                                             main=input$title_of_MA_plot,
                                             labelsig = input$text_choice_MA,
                                             use_alternate_color = input$alternate_color_scheme_MA))})
    
    #Enables the buttons
    enable_disable_MA_plot(TRUE)
  })
  
  
  
  
  #Download the MA plot
  output$download_MA_plot <- downloadHandler(
    filename = function(){
      paste(input$title_of_MA_plot,".png",sep="")
    },
    content = function(file){
      if (input$text_choice_MA==FALSE){
        png(file,width=1200, height=1000, pointsize=20)
      }else{
        png(file,width=5200, height=5000, pointsize=20)
      }
      #Creates a shiny alert
      shinyalert(
        title = "Working",
        text = "Your download is being prepared, please wait.",
        closeOnEsc = FALSE,
        closeOnClickOutside = FALSE,
        html = FALSE,
        type = "",
        showConfirmButton = FALSE,
        showCancelButton = FALSE,
        timer = 0,
        imageUrl = "https://i.imgur.com/f8vNJCt.gif",
        animation = TRUE
      )
      #Disables MA buttons
      enable_disable_MA_plot(FALSE)
      
      #Calls the create plot function again to create it within the png that will be downloaded
      isolate({suppressWarnings(custom_MA_plot(input$file_custom_MA$datapath, 
                                               sig_pval = input$p_value_thresh_MA, 
                                               main=input$title_of_MA_plot,
                                               labelsig = input$text_choice_MA,
                                               use_alternate_color = input$alternate_color_scheme_MA))})
      #Closes the plot that was create as it has been saved and does not require to be opened in R
      dev.off()
      
      #Re-enables MA buttons
      enable_disable_MA_plot(TRUE)
      #Closes the shiny alert
      shinyjs::runjs("swal.close();")
    }
  )
  
  
  
  #Download the MA plot data
  output$download_MA_data <- downloadHandler(
    filename = function(){
      paste(input$title_of_MA_plot,".csv",sep="")
    },
    content = function(file){
      
      shinyalert(
        title = "Working",
        text = "Your download is being prepared, please wait.",
        closeOnEsc = FALSE,
        closeOnClickOutside = FALSE,
        html = FALSE,
        type = "",
        showConfirmButton = FALSE,
        showCancelButton = FALSE,
        timer = 0,
        imageUrl = "https://i.imgur.com/f8vNJCt.gif",
        animation = TRUE
      )
      #Disables MA buttons
      enable_disable_MA_plot(FALSE)
      x <-read.csv(file = input$file_custom_MA$datapath,check.names=FALSE)
      x <-subset(x, padj<input$p_value_thresh_MA)
      #Remove an unecessary row
      x<-x[,-1]
      write.csv(x,file)
      
      #Re-enables MA buttons
      enable_disable_MA_plot(TRUE)
      #Closes the shiny alert
      shinyjs::runjs("swal.close();")
    }
  )
  
  #Creates a reactive value that will be used to check if a file has been uploaded
  #This is then used to enable or disable the create plot button
  check_if_upload_MA_file <- reactiveValues(
    check_upload_MA_file=0
  )
  
  #Sets the check_if_upload variable to 1 if a file has been entered by the user
  observeEvent(input$file_custom_MA, {(check_if_upload_MA_file$check_upload_MA_file <- c(1))})
  
  
  #Enables the create and download buttons when all necessary prerequisites are met
  observe(if(check_if_upload_MA_file$check_upload_MA_file==1){
    enable("create_MA")
    enable("download_MA_plot")
    enable("download_MA_data")
  }else{
    disable("create_MA")
    disable("download_MA_plot")
    disable("download_MA_data")
    
  })
  
  #############################################################################################################################################
  
  #Custom volcano plot
  #############################################################################################################################################
  
  #Create the volcano plot
  output$custom_Volcano_plot <-renderPlot({validate(need(input$create_Volcano, ""))
    input$create_Volcano
    #Disables the buttons
    enable_disable_volcano_plot(FALSE)
    
    #Run the function to generate the plot
    #Isolate is to ensure that the function is not reactive, i.e not run everytime a parameter switches, needs a button push
    isolate({suppressWarnings(custom_Volcano_plot(input$file_custom_Volcano$datapath, 
                                                  lfcthresh = input$lfc_value_thresh,
                                                  sigthresh = input$p_value_thresh_Volcano,
                                                  main=input$title_of_Volcano_plot,
                                                  legendpos=input$legend_position,
                                                  labelsig = input$text_choice_MA,
                                                  use_alternate_colors = input$alternate_color_scheme_Volcano))})
    
    #enables the buttons
    enable_disable_volcano_plot(TRUE)
  })
  
  #Download the Volcano plot
  output$download_Volcano_plot <- downloadHandler(
    filename = function(){
      paste(input$title_of_Volcano_plot,".png",sep="")
    },
    content = function(file){
      #Depending on if the user wants text to appear, the size of the png is adjusted
      if (input$text_choice_Volcano==FALSE){
        png(file,width=1200, height=1000, pointsize=20)
      }else{
        png(file,width=5200, height=5000, pointsize=20)
      }
      #Creates a shiny alert
      shinyalert(
        title = "Working",
        text = "Your download is being prepared, please wait.",
        closeOnEsc = FALSE,
        closeOnClickOutside = FALSE,
        html = FALSE,
        type = "",
        showConfirmButton = FALSE,
        showCancelButton = FALSE,
        timer = 0,
        imageUrl = "https://i.imgur.com/f8vNJCt.gif",
        animation = TRUE
      )
      #disables the volcanos buttons
      enable_disable_volcano_plot(FALSE)
      
      #Generates the plot so it can be saved into the png
      isolate({suppressWarnings(custom_Volcano_plot(input$file_custom_Volcano$datapath, 
                                                    lfcthresh = input$lfc_value_thresh,
                                                    sigthresh = input$p_value_thresh_Volcano,
                                                    main=input$title_of_Volcano_plot,
                                                    legendpos=input$legend_position,
                                                    labelsig = input$text_choice_MA,
                                                    use_alternate_colors = input$alternate_color_scheme_Volcano))})
      #Removes the plot that was just created as it has been saved and is no longer necessary.
      dev.off()
      
      #Re-enables the volcano's buttons
      enable_disable_volcano_plot(TRUE)
      #Closes the shiny alert
      shinyjs::runjs("swal.close();")
    }
  )
  
  #Download the Volcano plot data
  output$download_Volcano_data <- downloadHandler(
    filename = function(){
      paste(input$title_of_Volcano_plot,".csv",sep="")
    },
    content = function(file){
      shinyalert(
        title = "Working",
        text = "Your download is being prepared, please wait.",
        closeOnEsc = FALSE,
        closeOnClickOutside = FALSE,
        html = FALSE,
        type = "",
        showConfirmButton = FALSE,
        showCancelButton = FALSE,
        timer = 0,
        imageUrl = "https://i.imgur.com/f8vNJCt.gif",
        animation = TRUE
      )
      #disables the volcanos buttons
      enable_disable_volcano_plot(FALSE)
      
      #Reads the data file, then filters it for significant data
      x <-read.csv(file = input$file_custom_Volcano$datapath,check.names=FALSE)
      x <-subset(x, padj<input$p_value_thresh_Volcano & abs(log2FoldChange)>input$lfc_value_thresh)
      #Remove an unecessary row
      x<-x[,-1]
      write.csv(x,file)
      
      #Re-enables the volcano's buttons
      enable_disable_volcano_plot(TRUE)
      #Closes the shiny alert
      shinyjs::runjs("swal.close();")
    }
  )
  
  
  check_if_upload_Volcano_file <- reactiveValues(
    check_upload_Volcano_file=0
  )
  
  #Sets the check_if_upload variable to one if a file has been entered by the user
  observeEvent(input$file_custom_Volcano, {(check_if_upload_Volcano_file$check_upload_Volcano_file <- c(1))})
  
  
  #Enables the create and download buttons when it all necessary prerequisites are met
  observe(if(check_if_upload_Volcano_file$check_upload_Volcano_file==1){
    enable("create_Volcano")
    enable("download_Volcano_plot")
    enable("download_Volcano_data")
  }else{
    disable("create_Volcano")
    disable("download_Volcano_plot")
    disable("download_Volcano_data")
  })
  
  #############################################################################################################################################
  
  #Database connection and DB reactive value
  #############################################################################################################################################
  #This creates a reactive variable, initializes it to null
  DB_Connect <- reactiveValues(
    DB=NULL
  )
  
  #Used to check if the email is valid when clicking the 'connect' button
  #It then prints the appropriate text in accordance to how the form was filled in
  observeEvent(input$connect_DB, {(
    if (isValidEmail(input$email)==FALSE){
      output$connect_db_status <- renderText("Please enter a valid email address")
    }else if (nchar(input$comments)>300){
      output$connect_db_status <- renderText(paste("Too many characters in comment box. Characters used:",nchar(input$comments)))
    }else if(nchar(input$comments)<300&&isValidEmail(input$email)==TRUE&&is.null(DB_Connect$DB<-Connect_to_database(input$email,input$study_type,input$user_position,input$comments))==FALSE){
      output$connect_db_status <- renderText(paste("Email address is valid. Database is connected. Characters in comment box:",nchar(input$comments)))
      #The reactive variable is updated in the if statement directly.
    }else{
      output$connect_db_status <- renderText(paste("Email address is valid. Database is NOT connected. Characters in comment box:",nchar(input$comments)))
    }
  )})
  #############################################################################################################################################
  
  #Directory set up
  #############################################################################################################################################
  
  #This observe event handles the setting of the directory for DESeq2
  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {
      input$directory_DESeq2
    },
    handlerExpr = {
      if (input$directory_DESeq2 > 0) {
        # condition prevents handler execution on initial app launch
        
        # launch the directory selection dialog with initial path read from the widget
        path = choose.dir(default = readDirectoryInput(session, 'directory_DESeq2'))
        # update the widget value
        updateDirectoryInput(session, 'directory_DESeq2', value = path)
        #if no proper path was selected, the 'path' is registered as empty, thus we check if it is empty before doing a setwd
        if (path!=""){
          setwd(path)
        }
        #else do nothing
      }
    }
  )
  
  
  #This observe event handles the setting of the directory for gene list analysis
  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {
      input$directory_gene_list
    },
    handlerExpr = {
      if (input$directory_gene_list > 0) {
        # condition prevents handler execution on initial app launch
        
        # launch the directory selection dialog with initial path read from the widget
        path = choose.dir(default = readDirectoryInput(session, 'directory_gene_list'))
        # update the widget value
        updateDirectoryInput(session, 'directory_gene_list', value = path)
        #if no proper path was selected, the 'path' is registered as empty, thus we check if it is empty before doing a setwd
        if (path!=""){
          setwd(path)
        }
        #else do nothing
      }
    }
  )
  #############################################################################################################################################
  
  #Reactive variables for gene_list_analysis and table creation + observe event
  #############################################################################################################################################
  
  
  #This creates a reactive variable which will be used as a verification for the enabling of the launch button (gene_list_analysis)
  #Using this, the application will prevent the user from starting an analysis without having entered a dataset
  check_genes_column <- reactiveValues(
    genes_column=0
  )
  
  #Generates a dataTable if a file was inputed, if no file has been uploaded, it returns NULL
  #The section of the file that is shown in the dataTable is the 'Genes' column of the uploaded file
  output$gene_list_table <- DT::renderDataTable({
    
    inFile <- input$gene_list_file
    if (is.null(inFile))
      return(NULL)
    #The file has been uploaded, the csv is read
    m <- read.csv(inFile$datapath, header = TRUE)
    #Runs the read csv through a function to check for a column named 'Genes'
    #The function will return TRUE or FALSE depending on if a 'Genes' column is found
    check_result<-check_for_genes_column(m)
    #A 'Genes' column was found
    if(check_result==TRUE){
      #Creates a new file with on the 'Genes' column
      m_new <- m[,"Genes",drop=FALSE]
      #Ensures that the text output is blank as it is uncessary in this condition
      output$check_gene_column_status<- renderText("")
      #Updates a reactive value which tells the code that a file has been uploaded
      check_genes_column$genes_column<-c(1)
      #Creates the datatable with the 'Genes' column
      DT::datatable(data=m_new, options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
    #A 'Genes' column was not found
    }else{
      #Indicates to the user that the file they entered was not correct.
      output$check_gene_column_status<- renderText("The entered file did not contain a 'Genes' column. Please enter a file with a 'Genes' column.")
      #Updates the reactive value to tell the code that no appropriate file has been entered
      check_genes_column$genes_column<-c(0)
      return(NULL)
    }
  })
  
  #This creates a reactive variable which will be used as a verification for the enabling of the launch button (gene_list_analysis)
  #Using this, the application will prevent the user from starting an analysis without having entered a dataset
  check_if_upload_gene_list_file <- reactiveValues(
    check_upload_gene_list_file=0
  )
  
  #Sets the check_if_upload variable to one if a file has been entered by the user
  observeEvent(input$gene_list_file, {(check_if_upload_gene_list_file$check_upload_gene_list_file <- c(1))})
  
  
  #Enables the launch_gene_list button when it all necessary prerequisites are met
  #An appropriate text is then generated to indicate to the user what they may have to do
  observe(if(check_if_upload_gene_list_file$check_upload_gene_list_file==1 && is.null(DB_Connect$DB)==FALSE &&check_genes_column$genes_column==1){
    enable("launch_list_analysis")
    output$launch_gene_list_status <- renderText("")
  }else{
    disable("launch_list_analysis")
    if(is.null(DB_Connect$DB)==TRUE){
      output$launch_gene_list_status <- renderText("You are not yet connected to the data base")
    }else{
      output$launch_gene_list_status <- renderText("Connected to database")
    }
  })
  
  #The observe event for the launch analysis button
  #First a shiny alert is created to lock the screen and tell the user that the program is working
  observeEvent(input$launch_list_analysis,{shinyalert(
    title = "Working",
    text = "You will be notified when the analysis is done",
    closeOnEsc = FALSE,
    closeOnClickOutside = FALSE,
    html = FALSE,
    type = "",
    showConfirmButton = FALSE,
    showCancelButton = FALSE,
    timer = 0,
    imageUrl = "https://i.imgur.com/f8vNJCt.gif",
    animation = TRUE
  )})
  
  #this observe event is the next action of the launch analysis button
  #This section first reads the file then uses the analysis function to analyze the contents
  #of the file
  observeEvent(input$launch_list_analysis,{(the_file <- read_csv_function(input$gene_list_file$datapath))
    (gene_list_results <- Non_canonic_analysis(DB_Connect$DB,the_file))
    
    #Runs the show results function which will put the results in the table if there are any
    show_results(gene_list_results)
    
    #Creates a shiny alert telling the user that the analysis is done
    shinyalert(
      title = "Done",
      text = paste("Your results have been downloaded here:",getwd()," \n They can also be viewed in the results tab"),
      closeOnEsc = TRUE,
      closeOnClickOutside = FALSE,
      html = FALSE,
      type = "success",
      showConfirmButton = TRUE,
      showCancelButton = FALSE,
      timer = 0,
      imageUrl = "",
      animation = TRUE
    )
    
    #Shows the results tabs if there are results to show
    if(nrow(gene_list_results[["ncan"]])>0){
      showTab(inputId = "results_tabs", target = "Non_Canonic")
      showTab(inputId = "results_tabs", target = "Canonic")
      showTab(inputId = "results_tabs", target = "References")
    }
    
  })
  #############################################################################################################################################
  
  #Reactive variables DESeq2 analysis
  #############################################################################################################################################
  
  #This creates a reactive variable which will be used as a verification for the enabling of the launch button (DESeq2)
  #Using this, the application will prevent the user from starting an analysis without having entered a dataset
  check_if_upload_File1_DESeq2 <- reactiveValues(
    check_upload_File1_DESeq2=0
  )
  
  #Sets the check_if_upload variable to one if a file has been entered by the user
  observeEvent(input$file1, {(check_if_upload_File1_DESeq2$check_upload_File1_DESeq2 <- c(1))})
  
  #This creates a reactive variable which will be used as a verification for the enabling of the launch button (DESeq2)
  #Using this, the application will prevent the user from starting an analysis without having entered a dataset
  check_if_upload_File2_DESeq2 <- reactiveValues(
    check_upload_File2_DESeq2=0
  )
  
  #Sets the check_if_upload variable to one if a file has been entered by the user
  observeEvent(input$file2, {(check_if_upload_File2_DESeq2$check_upload_File2_DESeq2 <- c(1))})
  
  #Enables the launch button when it all necessary prerequisites are met
  observe(if(check_if_upload_File1_DESeq2$check_upload_File1_DESeq2==1 && check_if_upload_File2_DESeq2$check_upload_File2_DESeq2==1&&
             input$condition1!=""&&input$condition2!="" && is.null(DB_Connect$DB)==FALSE){
    enable("launch")
    output$launch_status <- renderText("")
  }else if(check_if_upload_File1_DESeq2$check_upload_File1_DESeq2==1 && check_if_upload_File2_DESeq2$check_upload_File2_DESeq2==1&&
           input$condition1!=""&&input$condition2!="" && is.null(DB_Connect$DB)==TRUE && input$DESeq2_Ncan==FALSE){
    enable("launch")
    output$launch_status <- renderText("DESeq2 will be run without a non-canonical analysis")
  }else{
    disable("launch")
    if(input$DESeq2_Ncan==FALSE){
      output$launch_status <- renderText("DESeq2 will be run without a non-canonical analysis")
    }else if(is.null(DB_Connect$DB)==TRUE){
      output$launch_status <- renderText("You are not yet connected to the data base")
    }else{
      output$launch_status <- renderText("Connected to database, a non-canonical analysis will be performed")
    }
  })
  #############################################################################################################################################
  
  #DESeq2 observe event
  #############################################################################################################################################
  
  #The first action done when a user launches an analysis
  observeEvent(input$launch,{shinyalert(
    title = "Working",
    text = "You will be notified when the analysis is done",
    closeOnEsc = FALSE,
    closeOnClickOutside = FALSE,
    html = FALSE,
    type = "",
    showConfirmButton = FALSE,
    showCancelButton = FALSE,
    timer = 0,
    imageUrl = "https://i.imgur.com/f8vNJCt.gif",
    animation = TRUE
  )})
  
  
  #Okay, so this one is complexe, this line of code does several things at once, and this was the only way I found to circumvent a certain error
  #This line starts by holding the message send by the launchMuma function, if the Launch function works well, it will return a string of characters, no issues here
  #If the launch function has an error in it's 'catch', the function returns itself as a variable of type 'closure', I was unable to prevent this
  #This means that the code can't simply show the message return as in some instances the message will not be of character type
  #So the second part of this line of code is to check the type of the 'message' that was returned, if it is of character type, all is well and it can be shown as it is,
  #If it is not of character type, it means there was an error, thus I manually add in the error message that should have been sent by the 'launchMuma' function.
  #This line of code could not be split as the stored 'message' is only present for the duration of this line of code.
  observeEvent(input$launch,{(my_list <-suppressWarnings(DESeq2_pre_processing(input$file1$datapath,input$file2$datapath, 
                                                                               input$condition1,input$condition2,input$Make_MA,input$Make_Volcano)))
    
    
    
    
    
    
    
    if(typeof(my_list[["message"]])=="character"){
      #shinyjs::show("contents")
    }
    
    #If the user wanted to run a non-canonical gene analysis as part of the DESeq2 analysis
    if (input$DESeq2_Ncan==TRUE){
      Final_Results <- Non_canonic_analysis(DB_Connect$DB,my_list[["file"]])
      #Below is the format of 'Final_Results'
      #list("sig_genes"=file_to_analyze,"ncan"=non_canonic_results,"can"=canonic_results,"refs"=ref_results)
      
      #Call a function to print the results
      show_results(Final_Results)
      if(nrow(Final_Results[["sig_genes"]])>0){
        showTab(inputId = "results_tabs", target = "Significant Genes")
      }
      if (nrow(Final_Results[["ncan"]])>0){
        showTab(inputId = "results_tabs", target = "Non_Canonic")
        showTab(inputId = "results_tabs", target = "Canonic")
        showTab(inputId = "results_tabs", target = "References") 
      }
      
      #If the user did not want to run a non-canonical gene analysis as part of the DESeq2 analysis
    }else{
      output$sig_genes <- DT::renderDataTable({
        DT::datatable(data=my_list[["file"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
      })
      if(nrow(my_list[["file"]])>0){
        showTab(inputId = "results_tabs", target = "Significant Genes")
      }else{
        output$results_status<- renderText("No significant genes were found")
      }
      
    }
    
    #Checks if the message is of character type or not indicating if an error must be shown
    if (typeof(my_list[["message"]])!="character"){
      #This is an error
      title_var="Error"
      text_var=paste("Error, please check the 'Error_and_Warning_Log.txt' located here:",getwd())
      type_var="error"
    }else{
      title_var="Done"
      text_var=my_list[["message"]]
      type_var="success"
    }
    
    #Creates a shiny alert depending on if there was an error in the analysis or if everything went well
    shinyalert(
      title = title_var,
      text = text_var,
      closeOnEsc = TRUE,
      closeOnClickOutside = FALSE,
      html = FALSE,
      type = type_var,
      showConfirmButton = TRUE,
      showCancelButton = FALSE,
      confirmButtonText = "OK",
      confirmButtonCol = "#AEDEF4",
      timer = 0,
      imageUrl = "",
      animation = TRUE
    )
    
    
    
  })
  
  
  
  #############################################################################################################################################
  
  #Citation and references
  #############################################################################################################################################
  #The text isn't aligned as it had to be put this way so it would be aligned in the app
  output$Standard_cite<-renderText("MLA: Lefol, Yohan, Alexis Dupis, Ugo Vidal, and Marie Terrie. \"INSERM33\".(2020)
APA: Lefol, Y., Dupis, A., Vidal, U., and Terrien, M. (2020). INSERM33.
Chicago: Lefol, Yohan, Alexis Dupis, Ugo Vidal, and Marie Terrien. \"INSERM33\". (2020)
Harvard: Lefol, Y., Dupis,A., Vidal, U., and Terrien, M.,2020. INSERM33.
Vancouver: Lefol Y, Dupis A, Vidal U, Terrien M. INSERM33. 2020")
  
  output$BibTex_text<-renderText("@misc{INSERM33,
title = {INSERM33: Non-canonical gene analysis},
author={Yohan Lefol, Alexis Dupis, Ugo Vidal, Marie Terrien},
howpublished = {\\url{http://www.cellomet.com/?index}},
year = {2020},
note = {Accessed: }
}")
  output$EndNote_text<-renderText("%0 Computer Program
%A Lefol, Yohan
%A Dupis, Alexis
%A Vidal, Ugo
%A Terrien, Marie
%C Bordeaux
%T INSERM 33
%D 2020
%U http://www.cellomet.com/?index
%I Cellomet
                                  ")

  
  #############################################################################################################################################
  
}
