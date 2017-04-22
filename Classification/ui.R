library(shiny)
library(plotly)

shinyUI(fluidPage(
  titlePanel("k-NN Classification"),
  sidebarLayout(
    sidebarPanel(
        selectInput("dataSetName", "Choose a data set:",
                  list(`DataSets` = c("iris", "Orange",
                                      "ChickWeight","CO2"))
        ),
        checkboxGroupInput("predictors","", choice = c()),
        radioButtons("dependent","", choice = c(0), selected = 0),
        sliderInput("k", label = h3("k"),
                    min = 1, max = 50, value = 3),
        actionButton("calculate", "calculate"),
        h1("Help"),
        span("First select the dataset you want to work."),
        span("Then select two predictors"),
        span("and one dependent variable."),
        span("Click 'Calculate' and the app will classify the predictors using k-NN algorithm."),
        span("Use the slider to control the k parameter and see the difference it does on the classification")
    ),
    mainPanel(
      plotlyOutput("plot")
    )
  )
))
