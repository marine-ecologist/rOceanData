
#' Animate ocean data
#'
#' DEVELOPMENT function to animate ocean data maps
#'
#'
#'
#' @param input input
#' @param color variable for color
#' @param ... passes functions
#' @export

animate_ocean_data <- function(input, color="SST", ...){

  sf::sf_use_s2(FALSE)

  ne_coastline <- rnaturalearth::ne_countries(returnclass="sf", scale="large") |> dplyr::select(1)
  terrafile <- terra::rast(input |> as.data.frame() |>  dplyr::select(-time), type="xyz", crs=terra::crs(ne_coastline))

  terrafile <- terra::rast(input |> as.data.frame() |>  dplyr::select(-time), type="xyz", crs=terra::crs(ne_coastline))


  if (color=="SST"){
    colorrast="RdBU"
  }

  else if (color=="chlorophyll"){
    colorrast="YlGnBu"
  }

  else{
    print("Choose one of the rColorBrewer palettes")
    RColorBrewer::display.brewer.all()
    colorrast <- readline(prompt = "Select a dataset:")



  }



  tmap::tm_view() +
    tmap::tm_shape(terrafile, is.master=TRUE) +
    tmap::tm_raster( fill.scale = tmap::tm_scale_intervals(values = colorrast)) +
    tmap::tm_shape(ne_coastline) +
    tmap::tm_borders("black", lwd=1) +
    tmap::tmap_options(check.and.fix=TRUE) +
    tmap::tm_facets("time")


}
