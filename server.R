# server.R

library(dplyr)
library(ggplot2)
library(nycflights13)
library(shiny)
source("multiplot.R")

alldata <-tbl_df(flights) %>% 
    select(month, dep_time, arr_delay, carrier, origin, dest)


shinyServer(
    function(input, output) {
        output$mktshare <- renderPlot({
            
                
            dt <- alldata %>% 
                filter(month >= input$month[1], 
                       month <= input$month[2],
                       dep_time >= input$deptime[1] * 100,
                       dep_time <= input$deptime[2] * 100)
            
            
            if (input$origin != "NYC") 
                dt <- dt %>% filter(origin == input$origin)
            
            if (input$dest != "*Anywhere*")
                dt <- dt %>% filter(dest == input$dest)
            
            dtplot <- dt %>%    
                group_by(carrier) %>%
                summarize(n = n(),
                          avgArrDelay = mean(arr_delay, na.rm=T)) %>%
                merge(airlines)
            
            p1 <- ggplot(dtplot, 
                         aes(x = reorder(name, n), 
                             y = n)) + 
                geom_bar(stat = "identity", fill = "skyblue") +
                coord_flip() +
                labs (x = "Carrier",
                      y = "number of flights", 
                      title = paste("Market Share of route", input$origin, "-", input$dest))
            
            p2 <- ggplot(dtplot, 
                         aes(x = reorder(name, n), 
                             y = avgArrDelay)) + 
                geom_bar(stat = "identity", fill = "orange") +
                coord_flip() +
                labs (x = "",
                      y = "average arrival delay (minutes)", 
                      title = paste("On-time performance of route", input$origin, "-", input$dest))
            
            

            #put the two plots into one graph

            multiplot(p1, p2, cols = 2)
            
            

        })
    }
)