library(shiny)
library(class)
library(RColorBrewer)
library(ggplot2)
library(plotly)

shinyServer(function(input, output, session) {
  dataset <- reactive({
    data(list=input$dataSetName)
    dataset <- get(input$dataSetName)
  })
  observe({
    possiblePredictors <- colnames(dataset())
    possibledependents <- names(Filter(is.factor, dataset()))
    updateCheckboxGroupInput(session,
                             "predictors",
                             "Choose 2 predictors:",
                             choices = possiblePredictors,
                             selected = c(possiblePredictors[1], possiblePredictors[2]))
    updateRadioButtons(session,
                             "dependent",
                             "Choose the dependent Variable:",
                             choices = possibledependents,
                       selected = possibledependents[1])
    
  })
  output$plot <- renderPlotly({
    print(input$calculate)
    d <- dataset()
    ps <- isolate({input$predictors})
    
    if(length(ps) == 2){
      
      print(input$predictors)
      print(input$dependent)
      
      p1 <- isolate({input$predictors[1]})
      p2 <- isolate({input$predictors[2]})
      dp <- isolate({input$dependent[1]})
      
      predictions <- knn(d[,c(p1,p2)], d[,c(p1,p2)], d[,c(dp)], k = input$k)
      possibledps <- levels(d[,c(dp)])
      colors <- brewer.pal(length(possibledps), "Set1")
      
      df <- data.frame(x = d[,c(p1)], y = d[,c(p2)], pred = predictions)
      plot_ly(df, x = ~x,y = ~y, color = predictions, type = "scatter") %>%
        layout(xaxis = list(title=p1), yaxis = list(title=p2))
      
    }else{
      plot_ly()
    }
  })
})
