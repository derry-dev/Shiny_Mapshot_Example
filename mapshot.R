library(shiny)
library(leaflet)
library(mapview)

ui <- fluidPage(
  
  leafletOutput("map"),
  
  actionButton("add_points", "Add Points"),
  
  downloadButton("dl")
  
)

server <- function(input, output, session) {
  
  map <- reactiveValues(dat = leaflet() %>% addTiles())

  output$map <- renderLeaflet({
    map$dat
  })
  
  observeEvent(input$add_points, {
    
    coords <- data.frame(
      lat = runif(100, min = -90, max = 90),
      lng = runif(100, min = -180, max = 180)
    )
    
    map$dat <- map$dat %>% clearGroup("Points") %>% addCircleMarkers(data = coords, group = "Points")
    
    leafletProxy("map") %>% clearGroup("Points") %>% addCircleMarkers(data = coords, group = "Points")
    
  })
  
  output$dl <- downloadHandler(
    filename = "map.png",
    
    content = function(file) {
      mapshot(map$dat, file = file, delay = 0)
    }
  )
}

shinyApp(ui = ui, server = server)