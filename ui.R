# ui.R
library(shiny)
library(nycflights13)

lstdest <-c("*Anywhere*", sort(unique(flights$dest)))

shinyUI(fluidPage(
    titlePanel("2013 Flights departed from NYC "),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Analyze market share and on-time performance among carriers."),
            
            selectInput("origin", 
                        label = "Choose an origin airport (NYC for all)",
                        choices = c("NYC", "EWR", "JFK", "LGA"),                        
                        selected = "NYC"),
            
            selectInput("dest", 
                        label = "Choose a destination airport",
                        choices = lstdest,
                        selected = "MSP"),
            
            sliderInput("month", 
                        label = "Month",
                        min = 1, max = 12, value = c(1,12)),
            
            sliderInput("deptime", 
                        label = "Departure Time (Hour)",
                        min = 0, max = 24, value = c(0, 24))
            ),
        
        mainPanel(plotOutput("mktshare"))
    )
))