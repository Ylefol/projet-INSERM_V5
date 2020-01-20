
#Creates the header for the application
#Adding the logo.png from the www file located in the same area as the R scripts.
#The logo is also linked with the Cellomet website
dbHeader <- dashboardHeader(title = div(img(src="logo_app.png", width = 190,title="CelloMap"),titlePanel(title="",windowTitle = "CelloMap")),
                            tags$li(a(href = 'http://www.cellomet.com/?index',
                                      img(src = 'logo_cell.png',
                                          title = "Company Home", height = "30px"),
                                      style = "padding-top:10px; padding-bottom:10px;"),
                                    class = "dropdown"))


# Options for Spinner, this line allows the modification of the size and color of all spinners in the application
options(spinner.color="#008A8A", spinner.color.background="#ffffff", spinner.size=2)

#This section of code shows the max upload limit
#the current limit is 50 000Mb, or 50 giga bites per file uploaded
options(shiny.maxRequestSize = 50000*1024^2)
#The ui for the application
myUI <- dashboardPage(dbHeader,
                    
  #Side bar (tabs) declarations
  #############################################################################################################################################
  dashboardSidebar(
    #the CSS for the navigation sections of the application
    #It is used to customize the color of the header and side bar of the application
    tags$head(tags$style(HTML('.logo {
            background-color: #008A8A !important;
            }
            .navbar {
            background-color: #008A8A !important;
            }
            .skin-blue .sidebar-menu>li.active>a,
            .skin-blue .sidebar-menu>li:hover>a {
             border-left-color:#008A8A
            }
            '))),
    #Declares the the shinyJS package will be used on some elements of the UI
    #Shiny JS allows the program to hide/show UI elements when the appropriate calls are made in the server file
    useShinyjs(),
    sidebarMenu(id="my_sidebar",
      #CSS to allow sidebard to be hidden, not currently used
      tags$head(tags$style(".inactiveLink {
                pointer-events: none;
                cursor: default;
      }")),
      # Web site for the icons: https://fontawesome.com/icons?d=gallery&m=free
      #Below is the declaration of each tab of the sidebar
      menuItem("Information", tabName = "info", icon = icon("book-open")),
      menuItem("Connect to database", tabName = "connect_DB",icon= icon("database")),
      menuItem("Analyze a gene list", tabName = "gene_list_analysis", icon= icon("list-ul")),
      menuItem("Run analysis with DESeq2", tabName = "DESeq2_analysis", icon= icon("chart-bar")),
      menuItem("Results",tabName = "res", icon=icon("dna")),
      menuItem("Custom MA plots",tabName = "cus_MA", icon=icon("file-image")),
      menuItem("Custom Volcano plots",tabName = "cus_Volcano", icon=icon("file-image")),
      menuItem("Citation", tabName = "citation", icon= icon("book")),
      
      #Sets up the code for the close button
      extendShinyjs(text = "shinyjs.closeWindow = function() { window.close(); }", functions = c("closeWindow")),
      
      #Use of a fluid row to set the button at the bottom
      #Issue is that it is set there using pixel margins, so it will have to be manually adjusted when adding tabs
      fluidRow(
        column(6,style="margin-top: 450px;",actionButton("close", "Exit App"))
      )
      
    )
  
  ),

  #The main panel is set up to only contain a datatable of the dataset the user will enter, the height is limited as to ensure the table is adapted to low resolution screens
  
  dashboardBody(
    #Indicates that shinyJS and shinyAlert can/will be used within these elements of the UI
    useShinyjs(),
    useShinyalert(),
    tabItems(
  #############################################################################################################################################
      
      #Info tab
      #This tab will simply read the pdf guide in the www folder located in the same file as the R scripts
      #############################################################################################################################################
      tabItem(tabName = "info",
              h2("Information tab content"),
              uiOutput('path')
      ),
      #############################################################################################################################################
      
      #Connect database tab
      #############################################################################################################################################
      tabItem(tabName = "connect_DB",
              h2("Establish connection to the database"),
              textInput("email","Email Address:"),
              
              selectInput("study_type", "Type of Study",
                          choices = list("Academic" = "Academic",
                                         "Industry" = "Industry",
                                         "Others" = "Others"),
                          selected = 1),
              
              textAreaInput("comments", "Comments", placeholder = "Feel free to add a comment",width="500px"),
              actionButton("connect_DB", "Connect to database"),
              textOutput("connect_db_status")
      ),
      #############################################################################################################################################
      
      #Gene list analysis tab
      #############################################################################################################################################
      tabItem(tabName = "gene_list_analysis",
              h2("Non-canonical analysis of a gene list"),
              fluidPage(
                fluidRow(
                  column(4,
                         fileInput("gene_list_file", "Choose a csv file",
                          multiple = TRUE,
                          accept = c("text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")),
                         
                         directoryInput('directory_gene_list', label = 'select a directory', value = getwd()),
                         tags$h6("The hsa conversion can be used with the KEGGS mapping tool to find all pathways (only for human genome)"),
                         tags$h6("Check the guide in the information tab for more information on KEEGS mapping tool"),
                         checkboxInput("hsa_conversion_choice", "Find hsa conversions", value = FALSE, width = NULL),
                         tags$br(),
                         disabled(actionButton("launch_list_analysis", "Launch Analysis")),
                         textOutput("launch_gene_list_status"),
                         textOutput("check_gene_column_status")
                         ),
                  column(6, 
                         withSpinner(DT::dataTableOutput("gene_list_table",width = 400,height = 500), type = 6),
                         ),
                ),
                
              )
      ),
      
      #############################################################################################################################################
      
      #DESeq2 analysis tab
      #############################################################################################################################################
      tabItem(tabName = "DESeq2_analysis",
              h2("Run an analysis using DESeq2"),
              
              
              useShinyjs(),
              fluidPage(
                fluidRow(
                  column(5,
                         #Setting up the file input system of the application
                         fileInput("file1", "Choose CSV File 1",
                                   accept = c(
                                     "text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")
                         ),
                         fileInput("file2", "Choose CSV File 2",
                                   accept = c(
                                     "text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")
                         ),
                         checkboxInput("DESeq2_Ncan", "Perform a non-canonical gene analysis", value = TRUE, width = NULL),
                         checkboxInput("hsa_conversion_choice_Deseq2", "Find hsa conversions", value = FALSE, width = NULL),
                         
                         directoryInput('directory_DESeq2', label = 'select a directory', value = getwd()),
                         #Adds the text_input which will take in the first condition
                         textInput("condition1", "Name of the condition for file 1", "Condition_1"),
                         
                         #Adds the text_input which will take in the first condition
                         textInput("condition2", "Name of the condition for file 2", "Condition_2"),
                         
                         #A simple checkbox which will allow users to choose if they want to do MA plots
                         checkboxInput("Make_MA", "Create standard MA Plots", value = TRUE, width = NULL),
                         
                         #A check box which will allow users to choose if they want to do Volcano plots
                         checkboxInput("Make_Volcano", "Create standard Volcano Plots", value = TRUE, width = NULL),
                         
                         #The action button which will set the analysis in motion, it is initially disabled to prevent users form clicking the button while the requirements are not fufilled
                         disabled(actionButton("launch", "Launch Analysis")),
                         textOutput("launch_status")
                         )
                )
              )
              
      ),
      
      #############################################################################################################################################

      #Results tab
      #############################################################################################################################################
      
      tabItem(tabName = "res",
              h2("Results tab"),
              
              
              tabsetPanel(id="results_tabs",type="tabs",
                          tabPanel("Significant Genes", DT::dataTableOutput("sig_genes",width = 'auto',height = 500)),
                          tabPanel("Non_Canonic", DT::dataTableOutput("Ncan",width = 'auto',height = 500)),
                          tabPanel("Canonic", DT::dataTableOutput("Can",width = 'auto',height = 500)),
                          tabPanel("References", DT::dataTableOutput("refs",width = 'auto',height = 500))
              ),
              textOutput("results_status")
      ),
      
      #############################################################################################################################################
      
      #Custom MA plot tab
      #############################################################################################################################################
      tabItem(tabName = "cus_MA",
              h2("Generate custom MA plots"),
              fluidRow(
                column(4,
                       fileInput("file_custom_MA", "Choose CSV File",
                                 accept = c(
                                   "text/csv",
                                   "text/comma-separated-values,text/plain",
                                   ".csv")
                       ),
                      checkboxInput("text_choice_MA","Add gene names", value=FALSE, width = NULL),
                      checkboxInput("alternate_color_scheme_MA","Use alternate colors",value = FALSE, width = NULL),
                      numericInput("p_value_thresh_MA", label = "P-value significance", value = 0.05,min = 0.0,max = 1,step = 0.01),
                      textInput("title_of_MA_plot","Title of the plot","my_MA_plot"),
                      tags$b("Create the plot"),
                      br(),
                      disabled(actionButton("create_MA","create_MA")),
                      br(),
                      br(),
                      tags$b("Download plot or data"),
                      br(),
                      disabled(downloadButton('download_MA_plot', 'Download Plot')),
                      br(),
                      disabled(downloadButton('download_MA_data','Download Data'))
                ),
                column(6,
                  withSpinner(plotOutput("custom_MA_plot"), type = 6),     
                )
              ),
              
              
              
      ),
      #############################################################################################################################################
      
      #Custom Volcano plot tab
      #############################################################################################################################################
      tabItem(tabName = "cus_Volcano",
              h2("Generate custom Volcano plots"),
              fluidRow(
                column(4,
                       fileInput("file_custom_Volcano", "Choose CSV File",
                                 accept = c(
                                   "text/csv",
                                   "text/comma-separated-values,text/plain",
                                   ".csv")
                       ),
                      checkboxInput("text_choice_Volcano","Add gene names", value=FALSE, width = NULL),
                      checkboxInput("alternate_color_scheme_Volcano","Use alternate colors",value = FALSE, width = NULL),
                      numericInput("p_value_thresh_Volcano", label = "P-value significance", value = 0.05,min = 0.0,max = 1,step = 0.01),
                      textInput("title_of_Volcano_plot","Title of the plot","my_Volcano_plot"),
                      numericInput("lfc_value_thresh", label = "LFC threshold", value = 1,min = 0.0,max = 5,step = 0.5),
                      selectInput("legend_position", "Position of legend on graph",
                                  choices = list("bottomleft" = "bottomleft",
                                                 "bottom" = "bottom",
                                                 "bottomright" = "bottomright",
                                                 "left" = "left",
                                                 "center" = "center",
                                                 "right" = "right",
                                                 "topleft" = "topleft",
                                                 "top" = "top",
                                                 "topright"="topright"),
                                  
                                  selected = 1),
                      tags$b("Create the plot"),
                      br(),
                      disabled(actionButton("create_Volcano","create_Volcano")),
                      br(),
                      br(),
                      tags$b("Download plot or data"),
                      br(),
                      disabled(downloadButton('download_Volcano_plot', 'Download Plot')),
                      br(),
                      disabled(downloadButton('download_Volcano_data', 'Download Data'))
                      
                      
                ),
                column(6,
                       withSpinner(plotOutput("custom_Volcano_plot"), type = 6),
                )

              ),

      ),
      #############################################################################################################################################
      
      #Citation tab
      #############################################################################################################################################
      tabItem(tabName = "citation",
              h2("How to cite this tool"),
              tabsetPanel(
                tabPanel("cite", verbatimTextOutput("Standard_cite")),
                tabPanel("BibTex", verbatimTextOutput("BibTex_text")),
                tabPanel("EndNote", verbatimTextOutput("EndNote_text"))
                )
      )
      #############################################################################################################################################
      
    ),

  )
)




