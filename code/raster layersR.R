


# Ensure the data is ordered by time
df <- tmp |> with(data) %>% dplyr::arrange(time)

#map_countries <- rnaturalearth::ne_countries(type = "countries", scale=10)
#saveRDS(map_countries, "data/map_countries.RDS")

unique_times <- unique(df[[1]])

# Initialize an empty list for raster layers
raster_layers <- list()

# Loop over each unique time
for (time in unique_times) {
  # Filter the df for the current time
  df_time <- df %>% dplyr::filter(df[[1]] == time) %>% dplyr::select(-time) %>% as.data.frame()

  # Create a SpatRaster from the longitude and latitude columns and assign the SST values directly
  r <- terra::rast(df_time, type="xyz")
  #extent_val <- c(min(df_time[[2]]), max(df_time[[2]]), min(df_time[[3]]), max(df_time[[3]]))
  #res_val <- c(diff(range(df_time[[2]]))/length(unique(df_time[[2]])), diff(range(df_time[[3]]))/length(unique(df_time[[3]])))
  #r <- terra::ext(r, extent_val)
  #r <- terra::setResolution(r, res_val)
  #r <- terra::setValues(r, df_time[[4]])

  # Name the layer using the time value and add it to the list
  names(r) <- as.character(time)
  raster_layers[[as.character(time)]] = r
}

# Combine all layers into a single SpatRaster
#raster_brick <- do.call(c, raster_layers)

lon_lims <- c(min(df$longitude), max(df$longitude))
lat_lims <- c(min(df$latitude), max(df$latitude))

ggplot2::ggplot() + ggplot2::theme_bw() +
  ggplot2::geom_tile(data=df, ggplot2::aes(longitude, latitude, fill=par_einstein_m_2_day_1),
                     width=1.2, height=1.2, linewidth=0) +
  ggplot2::geom_sf(data=map_countries) +
  ggplot2::coord_sf(lon_lims, lat_lims, expand = FALSE)

brewerpalette <- "RdBu"

tmap::tm_shape(raster_brick$`1577880000`) +
  tmap::tm_raster("1577880000", palette=brewerpalette, alpha=0.8)
