# space = c(72, 74, -2, 6); time = c("2010-01-01", "2010-02-01"); filename = "spatial_extent_trial"; dataset = 17
space = "limitedsites.xlsx"; time = c("2010-01-01", "2010-02-01"); filename = "spatial_extent_trial"; dataset = 17


# spatial extent
extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), filename = "spatial_extent_trial")
extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), filename = "spatial_extent_trial", dataset = "ncdcOisst21Agg_LonPM180[sst]")
extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), filename = "spatial_extent_trial", dataset = 17)

# spatial points
extract_ocean_data(space = "limitedsites.xlsx", time = c("2010-01-01", "2010-02-01"), filename = "spatial_points_trial")
extract_ocean_data(space = "limitedsites.xlsx", time = c("2010-01-01", "2010-02-01"), filename = "spatial_points_trial", dataset = "ncdcOisst21Agg_LonPM180[sst]")
extract_ocean_data(space = "limitedsites.xlsx", time = c("2010-01-01", "2010-02-01"), filename = "spatial_points_trial", dataset = 17)

extract_ocean_data <- function(dataset = "none", filename = NULL, space = NULL, time = NULL, save.raster = TRUE) {

  # Load functions and datasets
  # (get_raster sourced from library(plotdap), https://github.com/rmendels/plotdap/blob/master/R/plotdap.R)
  # get_raster <- function(grid, var) {
  #   times <- grid$summary$dim$time$vals
  #   lats <- grid$summary$dim$latitude$vals
  #   lons <- grid$summary$dim$longitude$vals
  #   ylim <- range(lats, na.rm = TRUE)
  #   xlim <- range(lons, na.rm = TRUE)
  #   ext <- raster::extent(xlim[1], xlim[2], ylim[1], ylim[2])
  #   r <- if (length(times) > 1) {
  #     # ensure values appear in the right order...
  #     # TODO: how to detect a south -> north ordering?
  #     if ("lat" %in% names(grid$data)) {
  #       d <- dplyr::arrange(grid$data, time, desc(lat), lon)
  #     } else {
  #       d <- dplyr::arrange(grid$data, time, desc(latitude), longitude)
  #     }
  #     b <- raster::brick(
  #       nl = length(times),
  #       nrows = length(lats),
  #       ncols = length(lons)
  #     )
  #     raster::values(b) <- lazyeval::f_eval(var, d)
  #     raster::setExtent(b, ext)
  #   } else {
  #     if ("lat" %in% names(grid$data)) {
  #       d <- dplyr::arrange(grid$data, desc(lat), lon)
  #     } else {
  #       d <- dplyr::arrange(grid$data, desc(latitude), longitude)
  #     }
  #     raster::raster(
  #       nrows = length(lats),
  #       ncols = length(lons),
  #       ext = ext,
  #       vals = lazyeval::f_eval(var, d)
  #     )
  #   }
  #   names(r) <- make.names(unique(grid$data$time) %||% "")
  #   r
  # }
  # (get_rast is an updated version of get_raster converted to terra sourced from library(plotdap), https://github.com/rmendels/plotdap/blob/master/R/plotdap.R)
  get_rast <- function(grid, var) {
  times <- grid$summary$dim$time$vals
  lats <- grid$summary$dim$latitude$vals
  lons <- grid$summary$dim$longitude$vals
  ylim <- range(lats, na.rm = TRUE)
  xlim <- range(lons, na.rm = TRUE)
  spatial.ext <- terra::ext(xlim[1], xlim[2], ylim[1], ylim[2])
  r <- if (length(times) > 1) {
    if ("lat" %in% names(grid$data)) {
      d <- dplyr::arrange(grid$data, time, desc(lat), lon)
    } else {
      d <- dplyr::arrange(grid$data, time, desc(latitude), longitude)
    }
    b <- terra::rast(
      nl = length(times),
      nrows = length(lats),
      ncols = length(lons)
    )
    terra::values(b) <- d[[var]]
    terra::ext(b) <- spatial.ext
    b
  } else {
    if ("lat" %in% names(grid$data)) {
      d <- dplyr::arrange(grid$data, desc(lat), lon)
    } else {
      d <- dplyr::arrange(grid$data, desc(latitude), longitude)
    }
    b <- terra::rast(
      nrows = length(lats),
      ncols = length(lons),
      ext = spatial.ext,
      vals = d[[var]]
    )
    b
  }

  names(r) <- paste0(as.character(unique(lubridate::ymd(as.Date((unique(grid$data$time)))))))
  r
}

  { sourcedata <- base::as.data.frame(rbind(
      c("1", "erdHadISSTIce", "sic", "HadISST", "Sea Surface Temperature", "monthly", "1870-present", "1°", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISSTIce/index.html"),
      c("2", "jplMURSST41", "analysed_sst", "MUR", "Sea Surface Temperature", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41/index.html"),
      c("3", "jplMURSST41mday", "analysed_sst", "MUR", "Sea Surface Temperature", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41mday/index.html"),
      c("4", "jplMURSST41anom1day", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anom1day/index.html"),
      c("5", "jplMURSST41anommday", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anommday/index.html"),
      c("6", "NOAA_DHW", "CRW_SST", "NOAA Coral Reef Watch", "Sea Surface Temperature", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("7", "NOAA_DHW", "CRW_SSTANOMALY", "NOAA Coral Reef Watch", "Sea Surface Temperature anomaly", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("8", "ncdcOisst21Agg_LonPM180", "sea_surface_temperature", "NOAA OISST", "Sea Surface Temperature", "daily", "0.25°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
      c("9", "ncdcOisst21Agg_LonPM180", "anom", "NOAA OISST", "Sea Surface Temperature anomaly", "daily", "0.25°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
      c("10", "nceiPH53sstd1day", "sea_surface_temperature", "Pathfinder", "Sea Surface Temperature (daytime)", "daily", "0.0417°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/nceiPH53sstd1day/index.html"),
      c("11", "nceiPH53sstn1day", "sea_surface_temperature", "Pathfinder", "Sea Surface Temperature (nighttime)", "daily", "0.0417°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/nceiPH53sstn1day/index.html"),
      c("12", "nceiPH53sstd1day", "dt_analysis", "Pathfinder", "Sea Surface Temperature deviation (daytime)", "daily", "0.0417°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/nceiPH53sstd1day/index.html"),
      c("13", "nceiPH53sstn1day", "dt_analysis", "Pathfinder", "Sea Surface Temperature deviation (nighttime)", "daily", "0.0417°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/nceiPH53sstn1day/index.html"),
      c("14", "NOAA_DHW", "CRW_DHW", "NOAA Coral Reef Watch", "Degree Heating Weeks", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("15", "NOAA_DHW_monthly", "sea_surface_temperature", "NOAA Coral Reef Watch", "Degree Heating Weeks", "monthly", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW_monthly/index.html"),
      c("16", "NOAA_DHW", "CRW_HOTSPOT", "NOAA Coral Reef Watch", "Hotspots", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("17", "NOAA_DHW_monthly", "sea_surface_temperature_anomaly", "NOAA Coral Reef Watch", "Hotspots", "monthly", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW_monthly/index.html"),
      c("18", "NOAA_DHW", "CRW_BAA", "NOAA Coral Reef Watch", "Bleaching alert area", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("19", "NOAA_DHW", "CRW_BAA_7D_MAX", "NOAA Coral Reef Watch", "Bleaching alert area", "7-day", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("20", "coastwatchSMOSv662SSS1day", "sss", "CoastWatch", "Sea Surface Salinity", "daily", "0.25°", "2010-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/coastwatchSMOSv662SSS1day/index.html"),
      c("21", "coastwatchSMOSv662SSS3day", "sss", "CoastWatch", "Sea Surface Salinity", "8-day ", "0.25°", "2010-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/coastwatchSMOSv662SSS3day/index.html"),
      c("22", "coastwatchSMOSv662SSS1day", "sss_dif", "CoastWatch", "Sea Surface Salinity mean difference", "daily", "0.25°", "2010-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/coastwatchSMOSv662SSS1day/index.html"),
      c("23", "coastwatchSMOSv662SSS3day", "sss_dif", "CoastWatch", "Sea Surface Salinity mean difference", "8-day ", "0.25°", "2010-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/coastwatchSMOSv662SSS3day/index.html"),
      c("24", "erdHadISST", "sst", "HadISST", "Sea ice concentration", "monthly", "1°", "1870-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISST/index.html"),
      c("25", "jplMURSST41", "sea_ice_fraction", "MUR", "Sea ice fraction", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41/index.html"),
      c("26", "jplMURSST41mday", "sea_ice_fraction", "MUR", "Sea ice fraction", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41mday/index.html"),
      c("27", "NOAA_DHW", "CRW_SEAICE", "NOAA Coral Reef Watch", "Sea ice fraction", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("28", "ncdcOisst21Agg_LonPM180", "ice", "NOAA OISST", "Sea ice concentration", "daily", "0.25°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
      c("29", "nceiPH53sstd1day", "sea_ice_fraction", "Pathfinder", "Sea ice (daytime)", "daily", "0.0417°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/nceiPH53sstd1day/index.html"),
      c("30", "nceiPH53sstn1day", "sea_ice_fraction", "Pathfinder", "Sea ice (nighttime)", "daily", "0.0417°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/nceiPH53sstn1day/index.html"),
      c("31", "erdSW2018chla1day", "chlorophyll", "Orbview-2 SeaWiFS", "Chlorophyll a", "daily", "0.1°", "1997-2010", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdSW2018chla1day/index.html"),
      c("32", "erdSW2018chla8day", "chlorophyll", "Orbview-2 SeaWiFS", "Chlorophyll a", "8-day ", "0.1°", "1997-2010", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdSW2018chla8day/index.html"),
      c("33", "erdSW2018chlamday", "chlorophyll", "Orbview-2 SeaWiFS", "Chlorophyll a", "monthly", "0.1°", "1997-2010", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdSW2018chlamday/index.html"),
      c("34", "erdMH1chla1day", "chlorophyll", "Aqua MODIS", "Chlorophyll a", "daily", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1chla1day/index.html"),
      c("35", "erdMH1chla8day", "chlorophyll", "Aqua MODIS", "Chlorophyll a", "8-day ", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1chla8day/index.html"),
      c("36", "erdMH1chlamday", "chlorophyll", "Aqua MODIS", "Chlorophyll a", "monthly", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1chlamday/index.html"),
      c("37", "erdMH1kd4901day", "k490", "Aqua MODIS", "Diffuse Attenuation K490", "daily", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1kd4901day/index.html"),
      c("38", "erdMH1kd4908day", "k490", "Aqua MODIS", "Diffuse Attenuation K490", "8-day ", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1kd4908day/index.html"),
      c("39", "erdMH1kd490mday", "k490", "Aqua MODIS", "Diffuse Attenuation K490", "monthly", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1kd490mday/index.html"),
      c("40", "erdMH1pp1day", "productivity", "Aqua MODIS", "Net Primary Productivity", "daily", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1pp1day/index.html"),
      c("41", "erdMH1pp3day", "productivity", "Aqua MODIS", "Net Primary Productivity", "3-day", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1pp3day/index.html"),
      c("42", "erdMH1pp8day", "productivity", "Aqua MODIS", "Net Primary Productivity", "8-day ", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1pp8day/index.html"),
      c("43", "erdMH1ppmday", "productivity", "Aqua MODIS", "Net Primary Productivity", "monthly", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1ppmday/index.html"),
      c("44", "erdMPIC1day", "pic", "Aqua MODIS", "Particulate Inorganic Carbon", "daily", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMPIC1day/index.html"),
      c("45", "erdMPIC8day", "pic", "Aqua MODIS", "Particulate Inorganic Carbon", "8-day ", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMPIC8day/index.html"),
      c("46", "erdMPICmday", "pic", "Aqua MODIS", "Particulate Inorganic Carbon", "monthly", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMPICmday/index.html"),
      c("47", "erdMPOC1day", "poc", "Aqua MODIS", "Particulate Organic Carbon", "daily", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMPOC1day/index.html"),
      c("48", "erdMPOC8day", "poc", "Aqua MODIS", "Particulate Organic Carbon", "8-day ", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMPOC8day/index.html"),
      c("49", "erdMPOCmday", "poc", "Aqua MODIS", "Particulate Organic Carbon", "monthly", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMPOCmday/index.html"),
      c("50", "erdMH1par01day", "par", "Aqua MODIS", "Photosynthetically Available Radiation", "daily", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1par01day/index.html"),
      c("51", "erdMH1par08day", "par", "Aqua MODIS", "Photosynthetically Available Radiation", "8-day ", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1par08day/index.html"),
      c("52", "erdMH1par0mday", "par", "Aqua MODIS", "Photosynthetically Available Radiation", "monthly", "0.025°", "2003-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1par0mday/index.html")
    ))
    colnames(sourcedata) <- c("number", "dataset", "var", "satellite", "parameter", "temporal", "spatial", "timespan", "url")
  }

  ##### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ##### 1. Get dataset
  ##### three options: 1a) specify dataset and variable, 1b) select dataset from the list with prompt, 1c) enter dataset from list

  ##### 1a. choose dataset from a list and filter by dataframe row:

  if (dataset == "none") {
    cat(paste0("\n"))
    cat(paste0("Available datasets (see ?extract_ocean_data):\n"))
    cat(paste0("\n"))
    cat(paste0("------------SEA SURFACE TEMPERATURE------------\n"))
    cat(paste0("[1] HadISST - Sea Surface Temperature (1", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[2] MUR - Sea Surface Temperature (0.01", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[3] MUR - Sea Surface Temperature (0.01", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[4] MUR - Sea Surface Temperature anomaly (0.01", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[5] MUR - Sea Surface Temperature anomaly (0.01", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[6] NOAA Coral Reef Watch - Sea Surface Temperature (0.05", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[7] NOAA Coral Reef Watch - Sea Surface Temperature anomaly (0.05", intToUtf8(176), " grid)  (0.05", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[8] NOAA OISST - Sea Surface Temperature (0.25", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[9] NOAA OISST - Sea Surface Temperature anomaly (0.25", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[10] Pathfinder - Sea Surface Temperature daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[11] Pathfinder - Sea Surface Temperature nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[12] Pathfinder - Sea Surface Temperature deviation daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[13] Pathfinder - Sea Surface Temperature deviation nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("\n"))
    cat(paste0("------------CORAL STRESS------------\n"))
    cat(paste0("[14] NOAA Coral Reef Watch - Degree Heating Weeks (0.05", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[15] NOAA Coral Reef Watch - Degree Heating Weeks (0.05", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[16] NOAA Coral Reef Watch - Hotspots (0.05", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[17] NOAA Coral Reef Watch - Hotspots (0.05", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[18] NOAA Coral Reef Watch - Bleaching alert area (0.05", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[19] NOAA Coral Reef Watch - Bleaching alert area (0.05", intToUtf8(176), " grid) 7-day [composite]\n"))
    cat(paste("\n"))
    cat(paste0("------------SEA SURFACE SALINITY------------\n"))
    cat(paste0("[20] CoastWatch	- Sea Surface Salinity (0.25", intToUtf8(176), " grid)  [daily]\n"))
    cat(paste0("[21] CoastWatch	- Sea Surface Salinity (0.25", intToUtf8(176), " grid)  [8-day composite]\n"))
    cat(paste0("[22] CoastWatch	- Sea Surface Salinity mean difference (0.25", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[23] CoastWatch	- Sea Surface Salinity mean difference (0.25", intToUtf8(176), " grid) [8-day composite]\n"))
    cat(paste0("\n"))
    cat(paste0("------------SEA ICE------------\n"))
    cat(paste0("[24] HadISST - Sea ice concentration (1", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[25] MUR - Sea ice fraction (0.01", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[26] MUR - Sea ice fraction (0.01", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[27] NOAA Coral Reef Watch - Sea ice fraction (0.05", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[28] NOAA OISST - Sea ice concentration (0.25", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[29] Pathfinder - Sea ice daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[30] Pathfinder - Sea ice nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("\n"))
    cat(paste0("------------WATER QUALITY------------\n"))
    cat(paste0("[31] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[32] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [8-day composite]\n"))
    cat(paste0("[33] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[34] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[35] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
    cat(paste0("[36] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[37] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[38] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
    cat(paste0("[39] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[40] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[41] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [3-day composite]\n"))
    cat(paste0("[42] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
    cat(paste0("[43] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[44] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[45] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
    cat(paste0("[46] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[47] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[48] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
    cat(paste0("[49] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [monthly]\n"))
    cat(paste0("[50] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [daily]\n"))
    cat(paste0("[51] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
    cat(paste0("[52] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [monthly]\n"))

    dataset.num <- readline(prompt = "Select a dataset:")

    selectdata <- sourcedata[sourcedata$number == dataset.num, ]
    this_dataset <- selectdata$dataset
    this_var <- selectdata$var

    ##### 1b. else manually enter dataset list
  } else if (dataset %in% seq(1:52)) {
    selectdata <- sourcedata[sourcedata$number == dataset, ]
    this_dataset <- selectdata$dataset
    this_var <- selectdata$var

    ##### 1c. else specify dataset and variable in the format dataset[variable], e.g.
    ##### dataset="ncdcOisst21Agg_LonPM180[sst]"
    ##### list ERDAPP datasets:
    ##### https://coastwatch.pfeg.noaa.gov/erddap/search/advanced.html?page=1&itemsPerPage=10000&searchFor=&protocol=griddap&cdm_data_type=%28ANY%29&institution=%28ANY%29&ioos_category=%28ANY%29&keywords=%28ANY%29&long_name=%28ANY%29&standard_name=%28ANY%29&variableName=%28ANY%29&maxLat=&minLon=-180&maxLon=&minLat=-180&minTime=&maxTime=
    ##### note: MUST must be [-180 to 180] longitude (not [0 to 360])
  } else if (grepl("[", dataset, fixed = TRUE) == TRUE) {
    this_var <- substr(strsplit(dataset, "[[]")[[1]][2], 1, nchar(strsplit(dataset, "[[]")[[1]][2]) - 1)
    this_dataset <- strsplit(dataset, "[[]")[[1]][1]
  } else {
    cat(print("invalid option"))
  }



  ##### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ##### Get spatial
  ##### IF coordinate list

  if (is.character(space)[1] == TRUE) {
    if (grepl(".*xlsx.*", space) == TRUE) {
      coordlist <- readxl::read_excel(space)
    } else if (grepl(".*xls.*", space) == TRUE) {
      coordlist <- readxl::read_excel(space)
    } else if (grepl(".*csv.*", space) == TRUE) {
      coordlist <- read.csv(space)
    } else {
      (stop(print("coordinates file must be in one of the following formats: .xlsx, .xls, .csv")))
    }

    coordlist.rn <- coordlist |> # standardise longitude and latitude for sanity
      dplyr::rename_with(.col = grep(".*lon.*", names(coordlist), ignore.case = TRUE), ~"longitude") |>
      dplyr::rename_with(.col = grep(".*lat.*", names(coordlist), ignore.case = TRUE), ~"latitude")

  coordlist.loop <- list()
    # then iterate across coordlist loop
    for (i in 1:nrow(coordlist.rn)) {
      tmp.coord <- coordlist.rn[i, ]
      lon.pts <- c(tmp.coord$longitude, (tmp.coord$longitude))
      lat.pts <- c(tmp.coord$latitude, (tmp.coord$latitude))

      tmp.spatial.points.nc <- rerddap::griddap(this_dataset, fmt = "nc", longitude = lon.pts, latitude = lat.pts, time = time)
      tmp.spatial.points.df.full <- tmp.spatial.points.nc$data
      tmp.spatial.points.raster <- get_rast(tmp.spatial.points.nc, this_var) # extract raster
      coordlist.loop[[i]] <- tmp.spatial.points.raster
    }

    spatial.points.raster <- terra::sprc(coordlist.loop)
    #spatial.points.raster <- merge(spatial.points.raster)

    terra::saveRDS(spatial.points.raster, file = paste0(filename, ".rds"))

    #########
  } else if (length(space) == 4) {
    longitude.box <- space[1:2]
    latitude.box <- space[3:4]

    spatial.extent.nc <- rerddap::griddap(this_dataset, fmt = "nc", longitude = longitude.box, latitude = latitude.box, time = time)
    spatial.extent.df.full <- spatial.extent.nc$data
    spatial.extent.raster <- get_rast(spatial.extent.nc, this_var) # extract raster
    # dataset_raster[dataset_raster == dataset_nc_box$summary$var[[this_var]]$missval] <- NA # replace missing values with NA
    #names(spatial.extent.raster) <- paste0("ts.", as.character(unique(lubridate::ymd(as.Date(spatial.extent.nc$data$time)))))

    terra::saveRDS(spatial.extent.raster, file = paste0(filename, ".rds"))
    #spatial.extent.raster
  }
}
