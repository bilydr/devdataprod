library(dplyr)
library(ggplot2)
library(nycflights13)
source("multiplot.R")

alldata <-tbl_df(flights) %>% 
    select(month, dep_time, arr_delay, carrier, origin, dest)

monthi <- 1:4
deptimei <- c(600,2000)
origini <- "NYC"
desti <- "ORD"


data <- alldata %>% 
    filter(month %in% monthi, 
           dep_time >= min(deptimei),
           dep_time <= max(deptimei),
           dest == desti)


if (origini != "NYC") 
    data <- data %>% filter(origin == origini)

dtplot <- data %>%    
    group_by(carrier) %>%
    summarize(n = n(),
              avgArrDelay = mean(arr_delay, na.rm=T))

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


multiplot(p1, p2, cols=2)