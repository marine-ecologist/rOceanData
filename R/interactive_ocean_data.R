
#' Map ocean data
#'
#' DEVELOPMENT function to generate ocean data maps
#'
#'
#'
#' @param input input
#' @param color variable for map color
#' @param rows number of rows if faceted
#' @param ... passes functions
#' @export


interactive_ocean_data <- function(input, color="SST", rows=1, ...){

  sf::sf_use_s2(FALSE)

  # initialise data
  #ne_coastline <- rnaturalearth::ne_countries(returnclass="sf", scale="large") |> dplyr::select(1)# |> sf::st_crs(4326)

  # create rast
  metadata <- input$metadata # input data
  data <- input$data # input data
  input_wide <- data |>  tidyr::pivot_wider(values_from=as.numeric(names(data)[4]), names_from=as.character(data$time))
  terrafile <- terra::rast(input_wide, type="xyz", crs="EPSG:4326")


  # set colors
  if (grepl("sst", names(input)[4], ignore.case = TRUE)) {
    colorrast="RdBU"
  }

  else{
    print("Choose one of the rColorBrewer palettes")
    RColorBrewer::display.brewer.all()
    colorrast <- readline(prompt = "Select a color palette:")
  }

  plot.title <- paste0(metadata[2,2], " ", metadata[3,2], " (", metadata[6,2],")")

  p <- tm_basemap("Esri.WorldImagery") +
    tmap::tm_shape(terrafile, is.master=TRUE) +
    tmap::tm_raster(colorrast) +
#    tmap::tm_raster(col = tm_shape_vars(), col.scale = tm_scale_intervals(values = colorrast),  col.free=FALSE) +
    tmap::tm_facets(nrow=rows) +
    #tmap::tm_graticules(labels.pos=c("left", "bottom"), lwd=0.2) +
#  tmap::tm_shape(ne_coastline) +
#    tmap::tm_borders("black", lwd=1) +
  tmap::tmap_options(check.and.fix=TRUE) #+
  #tmap::tm_title_out("temp",  position = tm_pos_out("center", "top"))

  return(p)
}
