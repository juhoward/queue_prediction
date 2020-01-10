library(shiny)
library(ggplot2)
setwd('c:/users/howar/documents/wgu/queue_data/q_fcast')

# forecasting library
library(tswge)
# loading data
q.counts = read.csv('q.counts.csv')
phis = c(1.523623299, -1.069223401, 0.089237542,0.024954822,0.165674076,-0.092494591,
         0.150862061,-0.11499865,0.225761962,-0.136143373,0.022250511,0.116786439,-0.066169071,
         0.034183759,-0.040340693,0.19463899,-0.142253513,0.042060233,0.032372747,0.077742752,
         -0.056262175)

thetas = c(1.380611799,-0.999955429)

end_date = max(as.Date(q.counts$Date))

time_length = function(x){
  return(as.Date(x) - end_date + 1)
}

shinyServer(
  function(input, output, session){
    len = reactive({
      time_length(input$Forecast)
    })
  
    f = reactive ({
      d = fore.aruma.wge(q.counts$submission_count, 
                     s= 364, phi = phis, 
                     theta = thetas, 
                     lastn = F, n.ahead = len(),
                     plot = F)
      df = data.frame(Date = seq.Date(end_date, as.Date(input$Forecast), by = 'day'),
                 Predictions = d$f, 
                 Upper = d$ul, 
                 Lower = d$ll)

      df
    })
    output$seldate = renderText ({
      paste("The date selected is: ", 
            format(input$Forecast, '%m/%d/%Y'))
    }) 
    
    output$fcast_length = renderText ({
      paste("The forecast length is: ", 
            len(), " days.")
    })
    
    output$fcast = renderDataTable({
      f()
      })
    output$plot = renderPlot({
      p = ggplot(f(), aes(x=Date, y=Predictions)) +
        ggtitle('Estimated Daily Queue Submissions') +
        theme(plot.title = element_text(hjust = .5)) +
        geom_smooth( aes(ymin = Lower, ymax = Upper), stat = 'identity') +
        ylab('Submissions') 
      print(p)
    })
  }
)