require(markdown)
library(markdown)
library(shiny)

shinyUI(
  navbarPage("UFO Database Explorer",
             tabPanel("Plots",
  fluidPage(
  titlePanel("UFO Sightings"),
  
 sidebarLayout(
    sidebarPanel(
      helpText("Select a Date Range to examine."),
    
      dateRangeInput("dates", 
        "Date range",
        start = "2000-01-015", 
        end = as.character(Sys.Date())),
      
      br(),
      fluidRow(helpText("The current Date Range:"), column(12, verbatimTextOutput("value"))),
      br(),
      
      fluidRow(
         # checkboxGroupInput("Test1", "Test1", choices=c("display")),
        #  checkboxGroupInput("Test2", "Test2", choices=c("1","2","3"), selected="2"),
        #  numericInput("n", "N:", value=NA),
         # actionButton("goButton", label="SHAPE Table"),
          #p("Click the button to display the SHAPE table"),
         # verbatimTextOutput("nText")
         imageOutput("shapeTable")
        
      ),
      br()
    
    ),
   
    mainPanel(
      
      tabsetPanel(
    
       tabPanel("Time Series", plotOutput("timeseriesplot")),
        tabPanel("By Month", plotOutput("shapeHistogram")),
        tabPanel("By Hour of Day", plotOutput("timeOfDay"))
       
        )
      )
    )
   )
  ),
  tabPanel("About",
           mainPanel(
             includeMarkdown("include.md")
           )),
   tabPanel("Time Series Data", mainPanel(dataTableOutput("table1"))),
   tabPanel("All Data",  mainPanel(dataTableOutput("table2")))
 )
 )