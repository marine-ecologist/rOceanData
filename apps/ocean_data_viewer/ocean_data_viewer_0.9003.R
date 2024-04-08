library(shiny)
library(shinyWidgets)
library(leaflet)
library(httr)
library(raster)
library(fontawesome)
library(mapview)
library(leafem)
library(rnaturalearthhires)
library(cmocean)

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
        height: 1200px; /* Adjust height as needed */
      }
      .main-title {
        text-align: center;
      }
    "))
  ),
  div(class = "main-title", titlePanel("Ocean Data Viewer")),
  sidebarLayout(
    sidebarPanel(
      tags$h3("Ocean Data Viewer"),
      tags$p("Interactive map for daily sea surface temperature data via ",
             tags$a(href = "https://coastwatch.pfeg.noaa.gov/erddap/index.html",
                    "NOAA data servers", target = "_blank")),
      tags$p("."),

      selectInput("dataLocation", HTML(paste(fa("globe"), "Start location:")),
                  choices = list("Maldives" = "Maldives", "Great Barrier Reef" = "GBR")),

      selectInput("dataType", HTML(paste(fa("code-branch"), "Data source:")),
                  choices = list(
                    "Sea Surface Temperatures (NOAA)" = "CRW_SST",
                    "Sea Surface Temperature Anomalies (NOAA)" = "CRW_SSTANOMALY",
                    "Degree Heating Weeks (NOAA)" = "CRW_DHW"
                  )),

      dateInput("date", HTML(paste(fa("calendar"), "Date:")), value = Sys.Date() - 7),

      switchInput("showCoralReefs", label = "Coral Reef Atlas", value = FALSE, size = "mini"),
      switchInput("showSatelliteImage", label = "Satellite Image", value = FALSE, size = "mini"),

      sliderInput("opacity", HTML(paste(fa("wand-magic-sparkles"), "Map Transparency")),
                  min = 0, max = 1, value = 0.6, step = 0.1),

      tags$a(href = "mailto:x@y.com", HTML(paste(fa("envelope"), " Contact")), target = "_blank"),
      width = 2
    ),

    mainPanel(
      leafletOutput("map", width = "100%", height = "800px"),
      width = 8
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  reactiveLocation <- reactive({
    switch(input$dataLocation,
           "GBR" = c(145.425, -14.675, 10),
           "Maldives" = c(73.2, 4.35, 10))
  })

  output$map <- renderLeaflet({
    loc <- reactiveLocation()
    leaflet() %>%
      addTiles(options = tileOptions(maxZoom = 12)) %>%
      setView(lng = loc[1], lat = loc[2], zoom = loc[3])
  })

  inputTrigger <- reactive({
    list(
      bounds = input$map_bounds,
      date = input$date,
      dataType = input$dataType,
      showCoralReefs = input$showCoralReefs,
      showSatelliteImage = input$showSatelliteImage,
      opacity = input$opacity
    )
  })

  observe({
    trigger <- inputTrigger()

    bounds <- input$map_bounds
    if (!is.null(bounds)) {
      lat_range <- c(bounds$south, bounds$north)
      lon_range <- c(bounds$west, bounds$east)

      print(lat_range)
      print(lon_range)
      print(input$date)

      erddap_url <- paste0(
        "https://coastwatch.pfeg.noaa.gov/erddap/griddap/NOAA_DHW.csv?",
        input$dataType, "%5B(", input$date, "T12:00:00Z):1:(", input$date,
        "T12:00:00Z)%5D%5B(", lat_range[1], "):1:(", lat_range[2], ")%5D%5B(",
        lon_range[1], "):1:(", lon_range[2], ")%5D"
      )

      print(erddap_url)

      temp_erddap <- tempfile(fileext = ".csv")
      GET(url = erddap_url, write_disk(temp_erddap, overwrite = TRUE), timeout(60))

      # tryCatch({
        tmpread <- read.csv(temp_erddap, header = TRUE)
        csvdata <- read.csv(temp_erddap, header = TRUE, skip = 1) |>
          dplyr::select(3, 2, 4)

        ocean_data <- tidyterra::as_spatraster(csvdata, crs = "EPSG:4326") |>
          raster::raster()



        # Calculate step size for approximately 8 breaks
        raster_min = minValue(ocean_data[[1]])
        raster_max = maxValue(ocean_data[[1]])
        num_breaks = 8
        step_size = (raster_max - raster_min) / (num_breaks - 1)

        # Generate the legend values
        legend_values = seq(from = (raster_min), to = (raster_max), by = step_size)

        # Define color palette with the calculated domain
        ocean_data_pal = colorNumeric(
          palette = "RdBu",
          na.color = "#d2f8f9",
          reverse = TRUE,
          domain = c(raster_min, raster_max)
        )

        id_name <- names(csvdata)[3]

        leafletProxy("map") %>%
          clearGroup(id_name) %>%
          clearControls() %>%
          clearImages() %>%
          addRasterImage(ocean_data[[1]], layerId = id_name, group = id_name,
                         opacity = input$opacity, color = ocean_data_pal) %>%
          addLegend(pal = ocean_data_pal, position = "bottomright", values = legend_values,
                    title = paste0(input$dataType, " (", id_name, ")"), group = id_name) %>%
          addMouseCoordinates() %>%
          addImageQuery(ocean_data[[1]], type = "mousemove", layerId = id_name, position = "topright") %>%
          clearGroup("CoralReefs")


      # }, error = function(e) {
      #   showNotification("No satellite data available for this date.", type = "error")
      # })
    }
  })
}

shinyApp(ui, server)
