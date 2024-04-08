### notes:
# The viewer utilises the Allen Atlas wms based on map boundaries to detect lon/lat, then adds to map.
# (https://stackoverflow.com/questions/51616693/r-leaflet-geojson-coloring)


# to implement:
# deployApp("/Users/rof011/rOceanData/apps/ocean_data_viewer/", appPrimaryDoc="ocean_data_viewer_0.9001.R", appName="oceandata", appTitle="oceandata")
# https://stackoverflow.com/questions/74191858/r-leaflet-how-to-display-raster-value-on-mouse-hover

# notes:
# https://stackoverflow.com/questions/30704487/interactive-plotting-with-r-raster-values-on-mouseover

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
  div(class = "main-title",
      titlePanel("")),
  sidebarLayout(
    sidebarPanel(
      tags$h3("Ocean data viewer"),
      tags$p("Interactive map for  daily sea surface temperature data via ",
             tags$a(href="https://coastwatch.pfeg.noaa.gov/erddap/index.html",
                    "NOAA data servers", target="_blank")),

      tags$p("."),

      selectInput("dataLocation", HTML(paste(fa("globe"), "Start location:")),
                  choices = list("Maldives" = "Maldives",
                                 "Great Barrier Reef" = "GBR")),

      selectInput("dataType", HTML(paste(fa("code-branch"), "Data source:")),
                  choices = list("Sea Surface Temperatures (NOAA)" = "CRW_SST",
                                 "Sea Surface Temperature Anomalies (NOAA)" = "CRW_SSTANOMALY",
                                 "Degree Heating Weeks (NOAA)" = "CRW_DHW"
                                 #"Coral Bleaching Hotspots (NOAA)" = "CRW_HOTSPOTS",
                                 )),

      dateInput("date", HTML(paste(fa("calendar"), "Date:")),
                value=format(as.Date(Sys.Date()) - 7, "%Y-%m-%d")),

      switchInput(
        label="Coral Reef Atlas",
        value=FALSE,
        inputId = "showCoralReefs",
        size = "mini",
        labelWidth = "100px"
      ),

      switchInput(
        label="Satellite image",
        value=TRUE,
        inputId = "showSatelliteImage",
        size = "mini",
        labelWidth = "100px"
      ),

      sliderInput("opacity", HTML(paste(fa("wand-magic-sparkles"), "Map transparency:")), min = 0, max = 1, value = 0, step = 0.1),


      tags$a(href="mailto:x@y.com", HTML(paste(fa("envelope"), " Contact")), target="_blank"),


      width = 2
    ),
    mainPanel(
      leafletOutput("map", width = "100%", height = "800px"),
      width = 8
    )
  )
)

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

    # reset
    output$map <- renderLeaflet({
      loc <- reactiveLocation()
      leaflet() %>%
        addTiles(options = tileOptions(maxZoom = 12)) %>%
        setView(lng = loc[1], lat = loc[2], zoom = loc[3])
    })

    trigger <- inputTrigger()

    bounds <- input$map_bounds
    if (!is.null(bounds)) {

      # get ERDAPP data:
      lat_range <- c(bounds$south, bounds$north)
      lon_range <- c(bounds$west, bounds$east)


      erddap_url <- paste0(
        "https://coastwatch.pfeg.noaa.gov/erddap/griddap/NOAA_DHW.csv?",
        input$dataType,"%5B(", input$date,"T12:00:00Z):1:(", input$date,"T12:00:00Z)%5D%5B(", # date
        lat_range[1], "):1:(", lat_range[2], ")%5D%5B(", # lat
        lon_range[1] , "):1:(", lon_range[2], # date
        ")%5D"
      )

      temp_erddap <- tempfile(fileext = ".csv")
      GET(url = erddap_url, write_disk(temp_erddap, overwrite = TRUE), timeout(60))

      tryCatch({

        # download image as csv and convert to SpatRaster:
#        erddap_url <- "https://coastwatch.pfeg.noaa.gov/erddap/griddap/NOAA_DHW.csv?CRW_SSTANOMALY%5B(2024-03-25T12:00:00Z)%5D%5B(-13.425):(-15.925)%5D%5B(144.175):(146.675)%5D&.draw=surface&.vars=longitude%7Clatitude%7CCRW_SSTANOMALY&.colorBar=KT_deep%7C%7C%7C0%7C5%7C&.land=off&.bgColor=0xffccccff"
        temp_file <- tempfile(fileext = ".csv")
        GET(url = erddap_url, write_disk(temp_file, overwrite = TRUE), timeout(60))
        tmpread <- csvdata <- read.csv(temp_file, header = TRUE)
        csvdata <- read.csv(temp_file, header = TRUE, skip=1) |> dplyr::select(3,2,4)
        ocean_data <- tidyterra::as_spatraster(csvdata, crs="EPSG:4326") |> raster::raster()
      #  print(utils::object.size(temp_file, "Mb"))

            # get Allen layer
        # if (input$showCoralReefs) {
        #   allen_layer <- read_sf(paste0("https://allencoralatlas.org/geoserver/ows?service=wms&version=2.0.0&request=GetMap&layers=coral-atlas:benthic_data_verbose&crs=EPSG:4326&styles=polygon&bbox=", lon_range[1], ",", lat_range[1], ",", lon_range[2], ",", lat_range[2], "&width=2048&height=2048&format=geojson")) |>
        #     st_transform(4326) |>
        #     select(-id, -area_sqkm) |>
        #     filter(!class_name=="Sand") |>
        #     filter(!class_name=="Microalgal Mats") |>
        #     filter(!class_name=="Seagrass") |>
        #     filter(!class_name=="") |>
        #     mutate(class_name=fct_recode(class_name, "Reef" = "Rubble")) |>
        #     mutate(class_name=fct_recode(class_name, "Reef" = "Rock"))
        #
        # }


        # update map
        observe({

           if (input$dataType=="CRW_DHW"){

             # DHWbins <- 0:20
             # DHWcolors <- c("#d2f8f9", "#433374", "#615192", "#7f6faf", "#9d8dcd", "#ffff54",
             #                "#f9dd4a", "#f4bc41", "#f19b38", "#ea3323", "#c0281b", "#921c12",
             #                "#641009", "#d88252", "#a85f34", "#754025", "#502f19", "#dc2fe8",
             #                "#b726c1", "#921c9b", "#6e1274", "#2d0330")
             #
             # ocean_data_pal <- colorBin(palette = DHWcolors, domain = DHWbins, bins=20, na.color = "transparent")

             ocean_data_pal <- colorNumeric("RdBu", na.color = "#d2f8f9", reverse = TRUE, bins=20,
                                            domain = c(minValue(ocean_data), maxValue(ocean_data)))


             } else {

            ocean_data_pal <- colorNumeric("RdBu", na.color = "#d2f8f9", reverse = TRUE,
                                           domain = c(minValue(ocean_data), maxValue(ocean_data)))
           }

          id_name <- names(csvdata)[3]

          if (isTRUE(input$showCoralReefs) & isTRUE(input$showSatelliteImage)) {
            leafletProxy("map") %>%
              clearGroup(id_name) %>%
              clearControls() %>%
              clearImages() %>%
              addImageQuery(ocean_data[[1]]) %>%
              addProviderTiles("Esri.WorldImagery", group=id_name) %>%
              addRasterImage(ocean_data[[1]], layerId = id_name, group = id_name, opacity = input$opacity, color = ocean_data_pal) %>%
              addLegend(pal = ocean_data_pal, position = "bottomright", title = paste0(input$dataType, " (", id_name, ")"), group = id_name, values = csvdata[, 3]) %>%
              addMouseCoordinates() %>%
              addImageQuery(ocean_data[[1]], type = "mousemove", layerId = id_name, position = "topright") %>%
              addWMSTiles(
                baseUrl = "https://allencoralatlas.org/geoserver/ows?",
                layers = "coral-atlas:benthic_data_verbose", # Example layer, replace with the actual layer name you need
                options = WMSTileOptions(
                  format = "image/png", # Request PNG format
                  transparent = TRUE,
                  version = "1.3.0",
                  crs = CRS("EPSG:4326")
                ),
                attribution = "© Allen Coral Atlas",
                group = id_name
              )
          } else if (isTRUE(input$showCoralReefs)) {
            leafletProxy("map") %>%
              clearGroup(id_name) %>%
              clearControls() %>%
              clearImages() %>%
              addImageQuery(ocean_data[[1]]) %>%
              addRasterImage(ocean_data[[1]], layerId = id_name, group = id_name, opacity = input$opacity, color = ocean_data_pal) %>%
              addLegend(pal = ocean_data_pal, position = "bottomright", title = paste0(input$dataType, " (", id_name, ")"), group = id_name, values = csvdata[, 3]) %>%
              addMouseCoordinates() %>%
              addImageQuery(ocean_data[[1]], type = "mousemove", layerId = id_name, position = "topright") %>%
              # addWMSTiles(
              #   baseUrl = "http://geo.pacioos.hawaii.edu/geoserver/gwc/service/wms?",
              #   layers = "world_unepwcmc_coralreefs2010", # Example layer, replace with the actual layer name you need
              #   options = WMSTileOptions(
              #     format = "image/png", # Request PNG format
              #     transparent = TRUE,
              #     version = "1.1.1",
              #     crs = CRS("EPSG:4326")
              #   ),
              #   attribution = "© UNEP-WCMC (2010)",
              addWMSTiles(
                baseUrl = "https://allencoralatlas.org/geoserver/ows?",
                layers = "coral-atlas:benthic_data_verbose", # Example layer, replace with the actual layer name you need
                options = WMSTileOptions(
                  format = "image/png", # Request PNG format
                  transparent = TRUE,
                  version = "1.3.0",
                  crs = CRS("EPSG:4326")
                ),
                attribution = "© Allen Coral Atlas",
                group = id_name
              )
          } else if (isTRUE(input$showSatelliteImage)) {
            leafletProxy("map") %>%
              clearGroup(id_name) %>%
              clearControls() %>%
              clearImages() %>%
              addImageQuery(ocean_data[[1]]) %>%
              addProviderTiles("Esri.WorldImagery", group=id_name) %>%
              addRasterImage(ocean_data[[1]], layerId = id_name, group = id_name, opacity = input$opacity, color = ocean_data_pal) %>%
              addLegend(pal = ocean_data_pal, position = "bottomright", title = paste0(input$dataType, " (", id_name, ")"), group = id_name, values = csvdata[, 3]) %>%
              addMouseCoordinates() %>%
              addImageQuery(ocean_data[[1]], type = "mousemove", layerId = id_name, position = "topright") %>%
              clearGroup("CoralReefs")
          } else {
            leafletProxy("map") %>%
              clearGroup(id_name) %>%
              clearControls() %>%
              clearImages() %>%
              addImageQuery(ocean_data[[1]]) %>%
              addRasterImage(ocean_data[[1]], layerId = id_name, group = id_name, opacity = input$opacity, color = ocean_data_pal) %>%
              addLegend(pal = ocean_data_pal, position = "bottomright", title = paste0(input$dataType, " (", id_name, ")"), group = id_name, values = csvdata[, 3]) %>%
              addMouseCoordinates() %>%
              addImageQuery(ocean_data[[1]], type = "mousemove", layerId = id_name, position = "topright") %>%
              clearGroup("CoralReefs")
          }

        })


      }, error = function(e) {
        # Handle missing data and incorrect dates
        showNotification("No satellite data available for this date.", type = "error")
      })

    }
  })
}

shinyApp(ui, server)
