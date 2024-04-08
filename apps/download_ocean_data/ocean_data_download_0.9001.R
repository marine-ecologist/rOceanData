# deployApp("/Users/rof011/rOceanData/apps/download_ocean_data/", appPrimaryDoc="ocean_data_download_0.9001.R", appName="oceandata_access", appTitle="oceandata_access")

library(shiny)
library(shinyFiles)
library(shinyWidgets)
library(leaflet)
library(leaflet.extras)
library(leafem)
library(httr)
library(raster)
library(fontawesome)
library(mapview)
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
        font-size: 12px;
      }
    "))
  ),
  div(class = "main-title", titlePanel("")),

  sidebarLayout(
    sidebarPanel(
      tags$h3("Download Ocean Data"),

      tags$p(HTML(paste("Select the", HTML(paste(fa("square", prefer_type="solid"))), "on the map toolbar to set the boundaries of
                   ocean to extract data from, and use the", HTML(paste(fa("pencil"))), "to edit the area boundaries"))),

      # Select start location
      selectInput("dataLocation", HTML(paste(fa("globe"), "Start location:")),
                  choices = list("Maldives" = "Maldives", "Great Barrier Reef" = "GBR")),

      selectInput("dataType", HTML(paste(fa("code-branch"), "Data source:")),
                  choices = list(
                    "Sea Surface Temperatures (NOAA)" = "CRW_SST",
                    "Sea Surface Temperature Anomalies (NOAA)" = "CRW_SSTANOMALY",
                    "Degree Heating Weeks (NOAA)" = "CRW_DHW")),

      # Date range
      airDatepickerInput(
        inputId = "date_range",
        label = HTML(paste(fa("calendar"), "date range:")),
        range = TRUE,
        clearButton = TRUE,
        value = c(Sys.Date() - 7, Sys.Date()),  # Default range
        placeholder = "Select a date range"
      ),

      # Sliders for longitude and latitude range
      sliderInput("lon_range", HTML(paste(fa("arrows-up-down"), "longitude range:")),
                  min = -180, max = 180, step=0.1, value = c(73, 75)),
      sliderInput("lat_range", HTML(paste(fa("arrows-left-right"), "latitude range:")),
                  min = -90, max = 90, step=0.1, value = c(4, 5)),


      # Folder selection for data download
      shinyDirButton("folder", "Select Save Folder", "Select a folder to save data", multiple = FALSE),


      width = 3
    ),

    mainPanel(
      leafletOutput("map", width = "100%", height = "800px"),
      width = 6
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Initialize reactive variable to store the coordinates
  coords <- reactiveVal(list(lon = c(73, 75), lat = c(4, 5)))

  # Reactive to get the selected start location
  reactiveLocation <- reactive({
    switch(input$dataLocation,
           "GBR" = c(145.425, -14.675, 9),
           "Maldives" = c(73.2, 4.35, 8))
  })

  reactiveRange <- reactive({
    switch(input$dataType,
           "CRW_SST" = c(18, 36),
           "CRW_SSTANOMALY" = c(-4.5, 4.5),
           "CRW_DHW" = c(0, 18))
  })



  # Render Leaflet map
  output$map <- renderLeaflet({
    loc <- reactiveLocation()
    leaflet() %>%
      addProviderTiles('Esri.WorldImagery',
                       options = providerTileOptions(maxNativeZoom = 18, maxZoom = 100)) %>%
      addDrawToolbar(
        targetGroup = 'drawnShapes',
        rectangleOptions = list(
          repeatMode = TRUE,
          showArea = TRUE
        ),
        singleFeature = TRUE,
        polylineOptions = FALSE,
        polygonOptions = FALSE,
        circleOptions = FALSE,
        markerOptions = FALSE,
        circleMarkerOptions = FALSE,
        editOptions = editToolbarOptions(
          remove = TRUE
        )
      ) %>%
      setView(lng = loc[1], lat = loc[2], zoom = loc[3]) %>%
      leafem::addMouseCoordinates()
  })

  # Handle new drawn shapes
  observeEvent(input$map_draw_new_feature, {
    feature <- input$map_draw_new_feature
    if (!is.null(feature)) {
      bbox <- feature$geometry$coordinates[[1]]
      lon <- range(sapply(bbox, function(coord) coord[[1]]))
      lat <- range(sapply(bbox, function(coord) coord[[2]]))

      coords(list(lon = lon, lat = lat))
      updateSliderInput(session, "lon_range", min = -180, step=0.1, max = 180, value = c(lon[1], lon[2]))
      updateSliderInput(session, "lat_range", min = -90, step=0.1, max = 90, value = c(lat[1], lat[2]))
    }
  })

  # Handle edited shapes
  observeEvent(input$map_draw_edited_features, {
    edited_features <- input$map_draw_edited_features
    if (!is.null(edited_features)) {
      bbox <- edited_features$features[[1]]$geometry$coordinates[[1]]
      lon <- range(sapply(bbox, function(coord) coord[[1]]))
      lat <- range(sapply(bbox, function(coord) coord[[2]]))

      coords(list(lon = lon, lat = lat))
      updateSliderInput(session, "lon_range", min = -180, max = 180, value = c(lon[1], lon[2]))
      updateSliderInput(session, "lat_range", min = -90, max = 90, value = c(lat[1], lat[2]))
    }
  })
}

shinyApp(ui, server)
