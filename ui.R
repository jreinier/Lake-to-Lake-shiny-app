library(shiny)

shinyUI(fluidPage(
  headerPanel("Lake to Lake Water Levels"),
  selectInput(inputId = "serial", label = "Serial Number", choices = 
                c("000010FADCAB","00001130D1CB","00001130D2F8","00001130D339","00001130E08D","00001130E0B9","00001130E1A0","00001130E1C8","00001130E43F","00001130E5BA","00001130E9AC","00001130E9E2","00001130EEFF","00001130F137","00001130F7D6","00001130F7EF","00001130FA67","00001131050E","00001131056F","000011310845","000011311045","0000113121DF","000011312821","0000113128C7","0000113128FE","000011312A8D","000011312B76","000011312C09","000011312C13","000011312D0C","0000113130D3","000011313112","000011313A5A","000011313B7A","000011313C87","000011313CF4","000011313D13","00001314CCFB","000013153088","0000136AC163","0000136B6374","0000136B9D32","0000138B8F48","0000138BA0F2","0000138BB107","0000138BC058")),
  sliderInput(inputId = "timestamp", label = "Choose Date/Time Range", min = as.POSIXct("2008-06-17 00:00:00"), max = as.POSIXct("2014-09-26 00:00:00"), value = c(as.POSIXct ("2008-06-17 00:00:00"), as.POSIXct ("2014-09-26 00:00:00"))),
  
  checkboxInput("discharge", "Plot Abram Creek Discharge Rate", 
                value = FALSE),
  
  checkboxInput("precip", "Plot local Precipitation Data", 
                value = FALSE),
    
    mainPanel(plotOutput(outputId = "plot"))
  )
)
