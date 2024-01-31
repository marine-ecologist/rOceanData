#https://cran.r-project.org/web/packages/plotKML/plotKML.pdf

#rOceanData - simple functions to extract satellite data for global oceans

map_ocean_data(filename="global.csv", figurename="global.png", ncol=5, width=2000)
#map_ocean_data(filename="abcd.csv", ncol=5, width=4000)

map_ocean_data <- function(filename, figurename = NULL, coralreef = FALSE, ncol = NULL, nrow = NULL, view = TRUE, width = 2400) {


if(!identical(getOption("bitmapType"), "cairo") && isTRUE(capabilities()[["cairo"]])){
  options(bitmapType = "cairo")
}

start_time_1 <- Sys.time()


  # import data from extract_ocean_data in csv or rds
  if (  grepl("csv", filename)) {
    df1 <- read.csv(filename) |> dplyr::select(-X)
   } else if (grepl("rds", filename)) {
      df1 <- readRDS(filename)  |> dplyr::select(-X)
  } else {
      print("Specify either .csv or .rds output from extract_ocean_data()")
  }

  # import map data
  # set crs, extract natural earth world coastline and reconfigure for Pacific view (centered on 180° not 0° meridian), convert to SpatVector
    target_crs <- sf::st_crs("EPSG:4326") # set crs
#    target_crs <- sf::st_crs("+proj=longlat +x_0=0 +y_0=0 +lat_0=0 +lon_0=180") # set crs
    polygon <- sf::st_polygon(x = list(rbind(c(-0.0001, 90), c(0, 90), c(0, -90), c(-0.0001, -90), c(-0.0001, 90)))) |>
      sf::st_sfc() |>
      sf::st_set_crs(4326)

 #if (!exists("worldrn_m")) {
      worldrn_m <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf") |>
      sf::st_make_valid() |>
      sf::st_set_crs(4326) |>
      terra::vect()
 #}
 #if (!exists("countriesrn_m")) {
   countriesrn_m <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") |>
      sf::st_make_valid() |>
      sf::st_set_crs(4326) |>
      terra::vect()
#}


df1_shp <- reshape(df1, timevar="date", idvar=c("longitude", "latitude"), direction="wide")
df_rast <- terra::rast(df1_shp, type="xyz", crs="EPSG:4326")

# extract midpoint for vals
  z_range <- ((max(df_rast@ptr$range_max, na.rm = TRUE) - min(df_rast@ptr$range_min, na.rm = TRUE)) / 2) + min(df_rast@ptr$range_min, na.rm = TRUE)

plot <- ggplot2::ggplot() +
    ggplot2::theme_bw() +
    ggplot2::facet_wrap(~lyr, nrow = nrow, ncol = ncol) +
    tidyterra::geom_spatraster(data = df_rast, alpha = 0.6) +
    tidyterra::geom_spatvector(data = countriesrn_m, fill = "white", color = NA, size = 0.1) +
    tidyterra::geom_spatvector(data = worldrn_m, fill = NA, color = "black", size = 0.5) +
   # tidyterra::geom_spatvector(data = worldrn_m, colour = "black", size = 0.5) +
    ggplot2::geom_hline(yintercept = 0, size = 0.05) + # add equator
    #ggplot2::coord_fixed(ratio = 1)
    ggplot2::xlim(terra::ext(df_rast)[1], terra::ext(df_rast)[2]) + # set x plot extents to match SpatRaster longitude extent
    ggplot2::ylim(terra::ext(df_rast)[3], terra::ext(df_rast)[4]) + # set y plot extents to match SpatRaster latitude extent
    ggplot2::labs(title = filename, x = "Longitude", y = "Latitude", fill = "SST\n") + ### CHANGE THIS_VAR
    ggplot2::scale_colour_gradient2(midpoint = z_range, low = scales::muted("blue"), mid = "white", high = scales::muted("red"), limits = c(min(df_rast@ptr$range_min, na.rm = TRUE), max(df_rast@ptr$range_max, na.rm = TRUE)), na.value = "transparent") +
    ggplot2::scale_fill_gradient2(midpoint = z_range, low = scales::muted("blue"), mid = "white", high = scales::muted("red"), limits = c(min(df_rast@ptr$range_min, na.rm = TRUE), max(df_rast@ptr$range_max, na.rm = TRUE)), na.value = "transparent") +
    # ggplot2::guides(color=guide_legend("SST")) +
    ggplot2::theme(
      legend.position = "below",
      #legend.key.height = grid::unit(10, "points"),
      legend.direction = "horizontal",
      strip.text.x = ggplot2::element_text(size = 8),
      axis.text.x = ggplot2::element_text(size = 6, angle = 90, vjust = 0.5, hjust = 1),
      axis.text.y = ggplot2::element_text(size = 6, angle = 0, vjust = 0, hjust = 0.5),
      axis.line = ggplot2::element_line(color = "black"),
      plot.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.margin = ggplot2::unit(c(1,1,0,1), "cm") )


 end_time_1 <- Sys.time()

  print(paste0("Time taken to generate map: ", round(as.numeric(end_time - start_time), 2), " seconds"))


  if (is.null(figurename)) {

      } else {
      start_time_2 <- Sys.time()

  ggplot2::ggsave(filename = paste0(figurename),
    plot=plot, device = sub('.*\\.', '', figurename), bg="white",
    width = 4000, height = 4000, units = "px", limitsize = TRUE)
   end_time_2 <- Sys.time()

    print(paste0("Time taken to save map to file: ", round(as.numeric(end_time - start_time), 2), " seconds"))
    print(paste0("Map saved as: ", figurename))


  }

  if (view == TRUE) {
    base::suppressMessages(print(plot))
  } else {

  }
}
