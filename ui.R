# ui.R
library(shiny)
library(nycflights13)

lstdest <-c("*Anywhere*", sort(unique(flights$dest)))

shinyUI(fluidPage(
    titlePanel("Flights departing NYC in 2013 - compare carriers"),
    
    sidebarLayout(

        sidebarPanel(
            helpText("This app is based on flights data in R package nycflights13."),
            
            h4('User Guide'),
            p('1. Select origin and destination airport pairs to define a route. 
              "NYC" as origin would show the results combined of all New York airports.
              To leave destination as an open choice, select "*Anywhere*"'),
            
            selectInput("origin", 
                        label = "Choose an origin airport",
                        choices = c("NYC", "EWR", "JFK", "LGA"),                        
                        selected = "NYC"),
            
            selectInput("dest", 
                        label = "Choose a destination airport",
                        choices = lstdest,
                        selected = "MSP"),
            p('2. Use sliders below to limit the flights data to certains months of the 
                year 2013, or only focus on flights departing in certain hours'),
            
            sliderInput("month", 
                        label = "Month",
                        min = 1, max = 12, value = c(1,12)),
            
            sliderInput("deptime", 
                        label = "Departure Time (Hour)",
                        min = 0, max = 24, value = c(0, 24)),
            
            p('3. The results are displayed on the right, indicating the number of 
              flights, and the average arrival delay time by carrier on the chosen route.')
            ),
        
        mainPanel(plotOutput("mktshare"))
    )
))