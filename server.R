#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("tools.R")
options(shiny.maxRequestSize=30*1024^2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Read the sample data
  sample_data <- reactive({
    s_inFile <- input$sample_data_file
    if(is.null(s_inFile))
      return(NULL)
    read.csv(s_inFile$datapath, stringsAsFactors = FALSE)
  })
  
  #Read the continuous data
  cont_data <- reactive({
    c_inFile <- input$cont_data_file
    if(is.null(c_inFile))
      return(NULL)
    read.csv(c_inFile$datapath, stringsAsFactors = FALSE)
    
  })
  
  #Generate a select list of the column headings of the sample data
  output$s_datetime_head_select <- renderUI({
    if(is.null(sample_data()))
      return(NULL)
    headings <- names(sample_data())
    selectInput("sample_heading", "Datetime column", choices=headings)
    
  })
  
  #Generate a select list of the column headings of the continuous data
  output$c_datetime_head_select <- renderUI({
    if(is.null(cont_data()))
      return(NULL)
    headings <- names(cont_data())
    selectInput("cont_heading", "Datetime column", choices=headings)
  })
  
  #Merge the two files
  output$download_merged <- downloadHandler(
    filename = "merged_data.csv",
    content = function(file) {
      print(input$s_dateformat)
      print(input$c_dateformat)
      withProgress({
        merged <- msc(sample_data = sample_data(), 
            sample_dateformat = input$s_dateformat,
            sample_date_heading = input$sample_heading,
            cont_data = cont_data(),
            continuous_dateformat = input$c_dateformat,
            continuous_date_heading = input$cont_heading,
            maxDiff = input$maxDiff)
      })
      write.csv(merged, file=file, row.names=FALSE)
    }
  )
  
})
