
#' Plot HadISST files
#'
#' This function plots the output from extract_HadISST using ggplot2
#' It assumes the input file is a spatraster format in .rds.
#'
#' The code is dynanic in ranging SST
#'
#' @param filename infile Path to the input file
#' @param figurename name of the saved figure file, if null then will default to same as filename
#' @param view view file in R graphics device (TRUE or FALSE)
#' @param format format of the saved figure file either "pdf" or "jpg" or "png"
#' @param ncol specify the number of columns in facet_wrap (can be blank)
#' @param nrow specify the number of columns in facet_wrap (can be blank)
#' @param width specify desired width (default is 2400px)


plot_HadISST <- function(filename, figurename = filename, ncol = NULL, nrow = NULL, view = TRUE, width = 2400, format = "png") {

  # temp <- tempfile()
  # download.file("https://datadownload-production.s3.us-east-1.amazonaws.com/WCMC008_CoralReefs2018_v4_1.zip",temp)


  # set crs, extract natural earth world coastline and reconfigure for Pacific view (centered on 180° not 0° meridian), convert to SpatVector
  if (!exists("target_crs")) {
    target_crs <- sf::st_crs("+proj=longlat +x_0=0 +y_0=0 +lat_0=0 +lon_0=180") # set crs
  }
  if (!exists("polygon")) {
    polygon <- sf::st_polygon(x = list(rbind(c(-0.0001, 90), c(0, 90), c(0, -90), c(-0.0001, -90), c(-0.0001, 90)))) |>
      sf::st_sfc() |>
      sf::st_set_crs(4326)
  }
  if (!exists("worldrn_m")) {
    worldrn_m <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf") |>
      sf::st_make_valid() |>
      sf::st_difference(polygon) |>
      sf::st_transform(crs = target_crs) |>
      terra::vect()
  }
  # countriesrn_m <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") |>
  #   sf::st_make_valid() |>
  #   sf::st_difference(polygon) |>
  #   sf::st_transform(crs = target_crs) |>
  #    terra::vect()

  # filter names by seq
  #  plot.file <- readRDS("outputs/HadISST.GBR.bleachingyears.rds")
  plot.file <- terra::readRDS(paste0("outputs/", filename, ".rds")) # |> filter(>1, .keep_extent=TRUE)
  #  plot.file <- terra::subset(plot.file, subset, NSE = FALSE)

  temprange <- ((max(plot.file@ptr$range_max) - min(plot.file@ptr$range_min)) / 2) + min(plot.file@ptr$range_min)

  plot <- ggplot2::ggplot() +
    ggplot2::theme_bw() +
    ggplot2::facet_wrap(~lyr, nrow = nrow, ncol = ncol) +
    tidyterra::geom_spatraster(data = plot.file, alpha = 0.6) +
    tidyterra::geom_spatvector(data = worldrn_m, fill = "white", color = "grey", size = 0.4) +
    tidyterra::geom_spatvector(data = worldrn_m, colour = "black", size = 0.5) +
    ggplot2::geom_hline(yintercept = 0, size = 0.05) + # add equator
    ggplot2::xlim(ext(plot.file)[1], ext(plot.file)[2]) + # set x plot extents to match SpatRaster longitude extent
    ggplot2::ylim(ext(plot.file)[3], ext(plot.file)[4]) + # set y plot extents to match SpatRaster latitude extent
    # ggplot2::xlab("Longitude") +
    # ggplot2::ylab("Latitude") +
    ggplot2::labs(title = filename, x = "Longitude", y = "Latitude", fill = "SST\n") +
    # ggplot2::ggtitle(filename) +
    ggplot2::scale_colour_gradient2(midpoint = temprange, low = scales::muted("blue"), mid = "white", high = scales::muted("red"), limits = c(min(plot.file@ptr$range_min), max(plot.file@ptr$range_max)), na.value = "transparent") +
    ggplot2::scale_fill_gradient2(midpoint = temprange, low = scales::muted("blue"), mid = "white", high = scales::muted("red"), limits = c(min(plot.file@ptr$range_min), max(plot.file@ptr$range_max)), na.value = "transparent") +
    # ggplot2::guides(color=guide_legend("SST")) +
    ggplot2::theme(
      legend.position = "bottom",
      legend.key.width = grid::unit(1, "cm"),
      legend.direction = "horizontal",
      strip.text.x = ggplot2::element_text(size = 8),
      axis.text.x = ggplot2::element_text(size = 6, angle = 90, vjust = 0.5, hjust = 1),
      axis.text.y = ggplot2::element_text(size = 6, angle = 0, vjust = 0, hjust = 0.5),
      axis.line = ggplot2::element_line(color = "black"),
      plot.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    )

  ggplot2::ggsave(
    filename = paste0("outputs/", figurename, ".", format),
    device = format,
    width = width,
    #      height = height,
    units = "px",
    limitsize = TRUE
  )


  if (view == TRUE) {
    base::suppressMessages(print(plot))
  } else {

  }
}
