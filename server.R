# server.R

library(shiny)
library(RPostgreSQL)
library(ggplot2)
library(agricolae)
library(quantmod)
library(dplyr)
library(shinyTime)
library(grid)

drv <- dbDriver("PostgreSQL")
conn <- dbConnect(drv, host="10.0.0.27", port="5432",
                  dbname="NR_monitoring", user="jreinier", password="carex91308")

hydrodata <- dbGetQuery(conn, "SELECT date, timestamp, reserv, level_cm, serial FROM nr_misc.water_level_data WHERE reserv = 'big creek' AND level_raw < 9.15;")

usgs.sheldon <- dbGetQuery(conn, "SELECT datetime, par_value FROM nr_misc.usgs_abram_creek_discharge WHERE site_no = '04201515';")

usgs.kolthoff <- dbGetQuery(conn, "SELECT datetime, par_value FROM nr_misc.usgs_abram_creek_discharge WHERE site_no = '04201526';")

cle.precip <- dbGetQuery(conn, "SELECT datetime, hpcp FROM nr_misc.cle_noaa_precip_08_to_14;")




server <- function(input, output) {
  
  newdata <- reactive({ 
    hydrodata %>%
      filter(timestamp >= input$timestamp[1],
             timestamp <= input$timestamp[2],
             serial == input$serial)
  })
  
  sheldon <- reactive({ 
    usgs.sheldon %>%
      filter(datetime >= input$timestamp[1],
             datetime <= input$timestamp[2]
      )
  })
  
  kolthoff <- reactive({ 
    usgs.kolthoff %>%
      filter(datetime >= input$timestamp[1],
             datetime <= input$timestamp[2]
      )
  })
  
  precip <- reactive({ 
    cle.precip %>%
      filter(datetime >= input$timestamp[1],
             datetime <= input$timestamp[2]
      )
  })
  
  output$plot <- renderPlot({
    
    p1 <- ggplot(newdata(), aes(x = timestamp, y = level_cm)) +
      geom_line() +
      xlab("Date") +
      ylab("Water Level (cm)") +
      ggtitle("Test Hydrograph")
    
    p2 <- ggplot(sheldon(), aes(x = datetime, y = par_value)) +
      geom_line() +
      xlab("Date") +
      ylab("Discharge Rate") +
      ggtitle("USGS-Sheldon Road")
    
    p3 <- ggplot(kolthoff(), aes(x = datetime, y = par_value)) +
      geom_line() +
      xlab("Date") +
      ylab("Discharge Rate") +
      ggtitle("USGS-Kolthoff Road")
    
    p4 <- ggplot(precip(), aes(x = datetime, y = hpcp)) +
      geom_line() +
      xlab("Date") +
      ylab("Precipitation") +
      ggtitle("NOAA Precip (cm)")
    
    grid.newpage()
    plot.all <- grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "last"))
    
    print(plot.all)
    
    if(input$precip) {
      plot.all <- grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), ggplotGrob(p4), size = "last"))
      
      print(plot.all)
    }
  })
  
}



