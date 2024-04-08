
library(shiny)
library(shinyWidgets)
library(leaflet)
library(httr)
library(raster)
library(fontawesome)
library(mapview)
library(leafem)
library(leaflet.extras)
library(rnaturalearthhires)
library(cmocean)
library(shinycssloaders)

# Define UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .shiny-app-container {
        max-width: 1200px;
        margin: auto;
        align: center;
      }
      html, body {
        height: 100%;
      }
      .container-fluid {
        height: 100%;
      }
      #map {
        height: 1250px;
      }
      .main-title {
        text-align: center;
      }
      .shiny-input-container .switch label {
        font-size: 6px;
      }
    "))
  ),
  div(class = "main-title", titlePanel("")),




  sidebarLayout(
    sidebarPanel(
      tags$h3("rOceanData"),

      selectInput(inputId = "data",
                  label = "Select Dataset",
                  choices =c("NOAA SST", "HADISST SST", "Chlorophyll (Aqua MODIS)"),
                  selected = NULL,
                  multiple = FALSE,
                  selectize = TRUE,
                  width = NULL,
                  size = NULL),

      airDatepickerInput(
        inputId = "id",
        label = "Select Dates",
        placeholder = "Placeholder",
        multiple = 5,
        clearButton = TRUE
      ),


      width = 2
    ),
   mainPanel(
      textOutput("bbox_output"),
      leafletOutput("selectmap", width = "100%", height = "800px"),
      width = 8
    ),
  )
)



server <- function(input, output, session) {
  output$selectmap <- renderLeaflet({
    leaflet::leaflet() |>
      leaflet::addProviderTiles('Esri.WorldImagery',
                                options=leaflet::providerTileOptions(maxNativeZoom=18,maxZoom=100)) |>
      leafem::addMouseCoordinates() |>
      leaflet::setView(lng = 73.2, lat = 4.35, zoom = 8) |>
      leaflet.extras::addDrawToolbar(
        targetGroup = 'drawnShapes',
        rectangleOptions = list(
          repeatMode = TRUE,
          showArea = TRUE
        ),
        singleFeature = TRUE,
        polylineOptions = FALSE,  # Disable polylines
        polygonOptions = FALSE,   # Disable polygons
        circleOptions = FALSE,    # Disable circles
        markerOptions = FALSE,  # Disable circle markers
        circleMarkerOptions = FALSE,
        editOptions = editToolbarOptions(
          remove = TRUE  # Allow removal of drawn shapes
        )
      ) #%>% leaflet.extras::addStyleEditor()

  })

  observeEvent(input$mymap_draw_new_feature, {
    feature <- input$mymap_draw_new_feature
    #    bbox <- feature$geometry$coordinates[[1]]

    feature <- input$mymap_draw_new_feature
    print(feature$geometry$coordinates[[1]])


  })

}

shinyApp(ui, server)
