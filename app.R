library(shiny)
library(dplyr)
library(sf)
library(leaflet)
library(mapview)
library(mapedit)
library(leafpm)

TJK_camera_cells <- st_read("data/TJK_camera_cells.shp") %>% st_transform(4326)
KYR_camera_cells <- st_read("data/KYR_camera_cells.shp") %>% st_transform(4326)
camera_cells <- rbind(TJK_camera_cells, KYR_camera_cells[,-1])

## get study area shape files
TJK_aoi_boundary <- st_read("data/VT_TJK_ProjectRegionWGS84.shp") %>% st_zm() %>% 
  st_transform("+proj=utm +zone=43 +datum=WGS84 +units=m +no_defs") %>% st_cast("LINESTRING")
KYR_aoi_boundary <- st_read("data/VT_ProjectArea_KGalatoo_revSM.SHP") %>% st_zm() %>% 
  st_transform("+proj=utm +zone=43 +datum=WGS84 +units=m +no_defs") %>% st_cast("LINESTRING")

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%")
)

# Define server logic
server <- function(input, output, session) {
  
  m <-  mapview(TJK_aoi_boundary, col = "red", col.regions = "transparent", legend = FALSE) +
    mapview(KYR_aoi_boundary, col = "red", col.regions = "transparent", legend = FALSE) +
    mapview(camera_cells, legend = FALSE) 
  
  output$map <- renderLeaflet({
    m@map %>% addPmToolbar(targetGroup = "camera_cells")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
