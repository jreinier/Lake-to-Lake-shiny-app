# server.R

library(shiny)
library(RPostgreSQL)
library(ggplot2)
library(agricolae)
library(quantmod)
library(dplyr)
library(shinyTime)

drv <- dbDriver("PostgreSQL")
conn <- dbConnect(drv, host="10.0.0.27", port="5432",
                  dbname="NR_monitoring", user="jreinier", password="carex91308")

hydrodata <- dbGetQuery(conn, "SELECT date, timestamp, reserv, level_cm, serial FROM nr_misc.water_level_data WHERE reserv = 'big creek' AND level_raw < 9.15;")


server <- function(input, output) {
  
  newdata <- reactive({ 
    hydrodata %>%
      filter(timestamp >= input$timestamp[1],
             timestamp <= input$timestamp[2],
             serial == input$serial)
  })
  
  output$plot <- renderPlot({
    
    p <- ggplot(newdata(), aes(x = timestamp, y = level_cm)) +
      geom_line() +
      xlab("Date") +
      ylab("Water Level (cm)") +
      ggtitle("Test Hydrograph")
    
    print(p)
    })
  
}


