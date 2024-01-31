
# to do:
# sort out missing vals

animate_ocean_data_raster <- function(filename, figurename = NULL, ocean = "Atlantic", ...) {

  ### import csv/rds data
  cat(paste0("importing data from ", filename, "\n"))
  output.df <- readRDS(filename)
  rasterfile <- terra::unwrap(readRDS(paste0(sub("\\..*", "", filename), "_raster.rds")))


  # output.df
  zmin <- floor(min(output.df[, 4], na.rm = TRUE))
  zmax <- ceiling(max(output.df[, 4], na.rm = TRUE))
  zstep <- ((zmax - zmin) / 12)

  cat("Starting animation \n")

countriesrn_m <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf") |>
  sf::st_make_valid()

#  tmp_animation <- tmap::tm_shape(terra::rotate(rasterfile)) +
  tmp_animation <- tmap::tm_shape(rasterfile) +
    tmap::tm_raster(
      style = "cont",
      breaks = seq(zmin, zmax, zstep),
      palette = "-RdBu",
      midpoint = NA,
      title = names(output.df)[4],
      alpha = 0.6,
      legend.is.portrait = FALSE
    ) +
   tmap::tm_shape(countriesrn_m) +
       tmap::tm_lines() +  tmap::tmap_options(check.and.fix =TRUE) +
    tmap::tm_facets(nrow = 1, ncol = 1, free.scales.fill = FALSE, free.scales.raster = FALSE, showNA = TRUE) +
    tmap::tm_layout(
      legend.title.size = 0.8,
      legend.text.size = 0.6,
      legend.height = 0.35,
      legend.outside.position = "bottom",
      legend.outside.size = 0.15,
      legend.outside = TRUE,
      legend.position = c("centre", "bottom"),
      panel.labels = levels(as.factor(output.df$date)),
      panel.label.bg.color = "white",
      frame.lwd = NA,
      frame = F
    ) +
    tmap::tm_credits(
      text = "http://github.com/marine-ecologist/rOceanData",
      size = 0.5,
      col = NA,
      alpha = 0.6,
      align = "left",
      bg.color = NA,
      bg.alpha = NA,
      fontface = NA,
      fontfamily = NA,
      position = c("centre", "bottom"),
      width = NA,
      just = NA
    )

  # tmap::tmap_animation(tmp_animation, figurename, 2)

  tmap::tmap_animation(tmp_animation, figurename, ...)
}
