#' Check ocean data
#'
#' DEVELOPMENT function to distill check data
#'
#'
#'
#' @param input input
#' @param ... passes functions
#' @export


check_ocean_data <- function(input, ...){

   aes1 <- colnames(input)[1]
   aes2 <- colnames(input)[2]
   aes3 <- colnames(input)[3]
   aes4 <- colnames(input)[4]


  cat()
  cat((paste0(sourcedata$satellite[dataset], " ", sourcedata$parameter[dataset], " (", sourcedata$temporal[dataset]," resolution)", "\n")))


  bbox <- st_bbox(c(xmin = min(input$longitude), ymin = min(input$latitude), xmax = max(input$longitude), ymax = max(input$latitude)), crs = 4326)
  bbox_sf <- st_as_sfc(bbox)

  ne_coastline <- rnaturalearth::ne_countries(returnclass="sf", scale="large") |> dplyr::select(1) |> sf::st_make_valid()
  terrafile <- terra::rast(input |> as.data.frame() |>  dplyr::select(-time), type="xyz", crs="EPSG:4326")

  xstep=abs(unique(input$longitude)[2]-unique(input$longitude)[1])
  ystep=abs(unique(input$latitude)[1]-unique(input$latitude)[2])

  summary_map <- tmap::tm_shape(terrafile, is.master=TRUE) +
    tmap::tm_raster(alpha=0, legend.show=FALSE) +
    tm_graticules() +
    tm_shape(World) +
    tm_borders() +
    tmap::tm_shape(ne_coastline) +
    tmap::tm_borders("black", lwd=1) +
    tmap::tmap_options(check.and.fix=TRUE)

  return(summary_map)
  #
  # ### summary ggplot
  # aes1 <- colnames(input)[1]
  # aes2 <- colnames(input)[2]
  # aes3 <- colnames(input)[3]
  # aes4 <- colnames(input)[4]
  #
  # a <- ggplot2::ggplot() + ggplot2::theme_bw() +
  #   ggplot2::geom_histogram(data=input, ggplot2::aes(.data[[aes1]]), fill="aquamarine3", col="black", lwd=0.2)
  #
  # b <- ggplot2::ggplot() + ggplot2::theme_bw() +
  #   ggplot2::geom_histogram(data=input, ggplot2::aes(.data[[aes2]]), fill="aquamarine3", col="black", lwd=0.2)
  #
  # c <- ggplot2::ggplot() + ggplot2::theme_bw() +
  #   ggplot2::geom_histogram(data=input, ggplot2::aes(.data[[aes3]]), fill="aquamarine3", col="black", lwd=0.2)
  #
  # d <- ggplot2::ggplot() + ggplot2::theme_bw() +
  #   ggplot2::geom_histogram(data=input, ggplot2::aes(.data[[aes4]]), fill="aquamarine3", col="black", lwd=0.2)
  #
  # summary_ggplot <- ggpubr::ggarrange(b,c,a,d, ncol=2, nrow=2)
  #
  # cowplot::plot_grid(tmap::tmap_grob(summary_map), summary_ggplot, ncol=2, nrow=1)


}
