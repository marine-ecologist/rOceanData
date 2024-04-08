

#' Check bbox
#'
#' DEVELOPMENT function to distill ocean data maps
#'
#'
#'
#' @param space input
#' @export


check_space <- function(space=c(70, 71, 1, 2), crs=4326){

    xmin=space[1]
    xmax=space[2]
    ymin=space[3]
    ymax=space[4]

    coords <- matrix(
    c(
      xmin, ymin,
      xmax, ymin,
      xmax, ymax,
      xmin, ymax,
      xmin, ymin  # Closing the polygon by repeating the first point
    ),
    ncol = 2, byrow = TRUE
  )

  # Create a list containing the coordinates matrix
  polygon_list <- list(coords)

  # Create the polygon and convert it to an sf object
  sf_polygon <- sf::st_sf( geometry = sf::st_sfc(sf::st_polygon(polygon_list), crs = crs))

  leaflet::leaflet() |>
    leaflet::addProviderTiles('Esri.WorldImagery', options=leaflet::providerTileOptions(maxNativeZoom=18,maxZoom=100)) |>
    leaflet::addPolygons(data = sf_polygon, color = "red", fill="red", weight = 1, opacity = 1, fillOpacity = 0.2) |>
    leafem::addMouseCoordinates()


}

