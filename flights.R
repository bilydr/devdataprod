library(dplyr)
library(ggplot2)
library(nycflights13)
source("multiplot.R")

alldata <-tbl_df(flights) %>% 
    select(month, dep_time, arr_delay, carrier, origin, dest)

# sample inputs
monthi <- c(1:4)
deptimei <- c(6,20)
origini <- "NYC"
desti <- "ORD"


dt <- alldata %>% 
    filter(month >= monthi[1], 
           month <= monthi[2],
           dep_time >= deptimei[1] * 100,
           dep_time <= deptimei[2] * 100)


if (input$origin != "NYC") 
    dt <- dt %>% filter(origin == origini)

if (input$dest != "*Anywhere*")
    dt <- dt %>% filter(dest == desti)


dtplot <- dt %>%    
    group_by(carrier) %>%
    summarize(n = n(),
              avgArrDelay = mean(arr_delay, na.rm=T)) %>%
    merge(airlines)

p1 <- ggplot(dtplot, 
       aes(x = reorder(carrier, n), 
           y = n)) + 
    geom_bar(stat = "identity", fill = "skyblue") +
    coord_flip() +
    labs (x = "Carrier",
          y = "number of flights", 
          title = paste("Market Share of route", origini, "-", desti))

p2 <- ggplot(dtplot, 
       aes(x = reorder(carrier, n), 
           y = avgArrDelay)) + 
    geom_bar(stat = "identity", fill = "orange") +
    coord_flip() +
    labs (x = "Carrier",
          y = "average arrival delay (minutes)", 
          title = paste("On-time performance of route", origini, "-", desti))

# put two plots side by side
multiplot(p1, p2, cols=2)