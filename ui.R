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