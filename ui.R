library(shiny)
shinyUI(
  pageWithSidebar(
    headerPanel("Daily Queue Submission Predictions"),
    
    sidebarPanel(
      dateInput("Forecast", "Enter a date to receive a forecast:", 
                value = as.Date(Sys.Date()),
                format = 'mm/dd/yyyy'
      ),
      textOutput('seldate'),
      textOutput('fcast_length'),
      dataTableOutput('fcast')
      

    ),
    mainPanel(
      plotOutput('plot')

      )
  )
)