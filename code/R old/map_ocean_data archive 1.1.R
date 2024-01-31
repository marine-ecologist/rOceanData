
# rOceanData - simple functions to extract satellite data for global oceans
# check with RDS
map_ocean_data(filename = "abcd.csv", figurename = "GBR.png", width = 4000)

map_ocean_data <- function(filename, figurename = filename, ncol = NULL, nrow = NULL, view = TRUE, width = 2400) {
  if (!identical(getOption("bitmapType"), "cairo") && isTRUE(capabilities()[["cairo"]])) {
    options(bitmapType = "cairo")
  }

  # import data from extract_ocean_data in csv or rds
  if (grepl("csv", filename) == TRUE) {
    df1 <- read.csv(filename)
    if (names(df1)[3] == "date") {
      df1 <- df1 |>
        dplyr::select(-X) |>
        dplyr::relocate(latitude) |>
        dplyr::arrange(date, longitude, latitude) #|> na.omit()
    } else if (names(df1)[3] == "year") {
      df1 <- df1 |>
        dplyr::select(-X) |>
        dplyr::relocate(latitude) |>
        dplyr::arrange(year, longitude, latitude) #|> na.omit()
    }
  } else if (grepl("rds", filename) == TRUE) {
    df1 <- readRDS(filename)
    if (names(df1)[3] == "date") {
      df1 <- df1 |>
        dplyr::select(-X) |>
        dplyr::relocate(latitude) |>
        dplyr::arrange(date, longitude, latitude) #|> na.omit()
    } else if (names(df1)[3] == "year") {
      df1 <- df1 |>
        dplyr::select(-X) |>
        dplyr::relocate(latitude) |>
        dplyr::arrange(year, longitude, latitude) #|> na.omit()
    }
  } else {
    print("Specify either .csv or .rds output from extract_ocean_data()")
  }

  # convert df to array
  array1 <- array(
    data = df1[, 4],
    dim = c(
      length(unique(as.factor(df1[, 1]))),
      length(unique(as.factor(df1[, 2]))),
      length(levels(unique(as.factor(df1[, 3]))))
    ),
    dimnames = list(
      levels(unique(as.factor(df1[, 1]))),
      levels(unique(as.factor(df1[, 2]))),
      levels(unique(as.factor(df1[, 3])))
    )
  )

  dataset_array_extent <- terra::ext(
    min(as.numeric(dimnames(array1[1, , ])[1][[1]])),
    max(as.numeric(dimnames(array1[1, , ])[1][[1]])),
    min(as.numeric(dimnames(array1[, 1, ])[1][[1]])),
    max(as.numeric(dimnames(array1[, 1, ])[1][[1]]))
  )

  # convert array to spatraster
  # df_rast <- terra::rast(array1) # check resolution on HadISST
  df_rast <- terra::rast(array1, crs = "EPSG:4326") # check resolution on HadISST
  terra::ext(df_rast) <- dataset_array_extent
  names(df_rast) <- as.character(unique(as.factor(df1[, 3])))
  terra::units(df_rast) <- colnames(df1[4])

  if (names(df1)[3] == "date") {
    terra::time(df_rast) <- (unique(as.factor(df1[, 3])))
  } else if (names(df1)[3] == "year") {
    numericstring <- (as.numeric(as.character(unique(as.factor(df1[, 3])))))
    # numericstring <-  lubridate::year(as.Date(ISOdate(numericstring, 1, 1)))
    terra::time(df_rast) <- lubridate::year(as.Date(ISOdate(numericstring, 1, 1)))
  }


  # set crs, extract natural earth world coastline and reconfigure for Pacific view (centered on 180° not 0° meridian), convert to SpatVector
  target_crs <- sf::st_crs("+proj=longlat +x_0=0 +y_0=0 +lat_0=0 +lon_0=180") # set crs
  polygon <- sf::st_polygon(x = list(rbind(c(-0.0001, 90), c(0, 90), c(0, -90), c(-0.0001, -90), c(-0.0001, 90)))) |>
    sf::st_sfc() |>
    sf::st_set_crs(4326)
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


  if (length(names(df_rast)) < 5) {
    nrow <- 1
    ncol <- NULL
  } else if (length(names(df_rast) > 5)) {
    nrow <- NULL
    ncol <- as.integer(floor(length(names(df_rast)) / 5))
  }

  # extract midpoint for vals
  z_range <- ((max(df_rast@ptr$range_max, na.rm = TRUE) - min(df_rast@ptr$range_min, na.rm = TRUE)) / 2) + min(df_rast@ptr$range_min, na.rm = TRUE)

  #  plot <- ggplot2::ggplot() +
  ggplot2::ggplot() +
    ggplot2::theme_bw() +
    ggplot2::facet_wrap(~lyr, nrow = nrow, ncol = ncol) +
    tidyterra::geom_spatraster(data = df_rast, alpha = 0.6) +
    tidyterra::geom_spatvector(data = worldrn_m, fill = "white", color = "grey", size = 0.4) +
    tidyterra::geom_spatvector(data = worldrn_m, colour = "black", size = 0.5) +
    ggplot2::geom_hline(yintercept = 0, size = 0.05) + # add equator
    # ggplot2::coord_fixed(ratio = 1)
    ggplot2::xlim(terra::ext(df_rast)[1], terra::ext(df_rast)[2]) + # set x plot extents to match SpatRaster longitude extent
    ggplot2::ylim(terra::ext(df_rast)[3], terra::ext(df_rast)[4]) + # set y plot extents to match SpatRaster latitude extent
    ggplot2::labs(title = filename, x = "Longitude", y = "Latitude", fill = "SST\n") + ### CHANGE THIS_VAR
    # ggplot2::scale_colour_gradient2(midpoint = z_range, low = scales::muted("blue"), mid = "white", high = scales::muted("red"), limits = c(min(df_rast@ptr$range_min, na.rm = TRUE), max(df_rast@ptr$range_max, na.rm = TRUE)), na.value = "transparent") +
    ggplot2::scale_fill_gradient2(midpoint = z_range, low = scales::muted("blue"), mid = "white", high = scales::muted("red"), limits = c(min(df_rast@ptr$range_min, na.rm = TRUE), max(df_rast@ptr$range_max, na.rm = TRUE)), na.value = "transparent") +
    # ggplot2::guides(color=guide_legend("SST")) +

    ggplot2::theme(
      legend.position = "below",
      # legend.key.height = grid::unit(10, "points"),
      legend.direction = "horizontal",
      strip.text.x = ggplot2::element_text(size = 8),
      axis.text.x = ggplot2::element_text(size = 6, angle = 90, vjust = 0.5, hjust = 1),
      axis.text.y = ggplot2::element_text(size = 6, angle = 0, vjust = 0, hjust = 0.5),
      axis.line = ggplot2::element_line(color = "black"),
      plot.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.margin = ggplot2::unit(c(1, 1, 0, 1), "cm")
    )


  # https://stackoverflow.com/questions/66429500/how-to-make-raggagg-png-device-work-with-ggsave
  ggplot2::ggsave(
    filename = paste0(figurename),
    plot = plot, device = "png", bg = "white",
    width = 4000, height = 4000, units = "px", limitsize = TRUE
  )


  if (view == TRUE) {
    base::suppressMessages(print(plot))
  } else {

  }
}
