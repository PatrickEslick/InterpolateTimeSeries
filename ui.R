#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for applicatio
shinyUI(fluidPage(
  
  # Application title
  includeMarkdown("help.Rmd"),
  
  fluidRow(
    #Options for specifying the sample data
    column(4,
      fileInput("sample_data_file", "Sample data"),
      uiOutput("s_datetime_head_select"),
      selectInput("s_dateformat","Date Format", c(
        "mm/dd/yyyy hh:mm" = "%m/%d/%Y %H:%M",
        "mm/dd/yyyy hh:mm:ss" = "%m/%d/%Y %H:%M:%S",
        "yyyy-mm-dd hh:mm" = "%Y-%m-%d %H:%M",
        "yyyymmdd hhmm" = "%Y%m%d %H%M",
        "mm/dd/yy hh:mm" = "%m/%d/%y %H:%M",
        "yyyymmddhhmm" = "%Y%m%d%H%M",
        "yyyymmddhhmmss" = "%Y%m%d%H%M%S"))
    ),
    #Options for specifiying the continuous data
    column(4,
      fileInput("cont_data_file", "Continuous data"),
      uiOutput("c_datetime_head_select"),
      selectInput("c_dateformat","Date Format", c(
        "mm/dd/yyyy hh:mm" = "%m/%d/%Y %H:%M",
        "mm/dd/yyyy hh:mm:ss" = "%m/%d/%Y %H:%M:%S",
        "yyyy-mm-dd hh:mm" = "%Y-%m-%d %H:%M",
        "yyyymmdd hhmm" = "%Y%m%d %H%M",
        "mm/dd/yy hh:mm" = "%m/%d/%y %H:%M",
        "yyyymmddhhmm" = "%Y%m%d%H%M",
        "yyyymmddhhmmss" = "%Y%m%d%H%M%S"))
    ),
    column(4,
      sliderInput("maxDiff", "Maximum distance in hours", min=1, max=5, value=4),
      downloadButton("download_merged", "Interpolate")      
    )
  )
  

))
