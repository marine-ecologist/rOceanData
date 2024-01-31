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

space <- c(72, 74, -2, 6)
time <- c("2010-01-01", "2010-02-01")
filename <- "spatial_extent_trial"
dataset <- 17

selectdata <- sourcedata[sourcedata$number == dataset, ]
this_dataset <- selectdata$dataset
this_var <- selectdata$var

longitude.box <- space[1:2]
latitude.box <- space[3:4]

rast.nc <- rerddap::griddap(this_dataset, fmt = "nc", longitude = longitude.box, latitude = latitude.box, time = time)

var <- this_var
grid <- rast.nc

tmp <- get_rast(rast.nc, this_var)

saveRDS(tmp,  file = "temporary.rds")
rm(list = objects())
tmp <- readRDS(file="temporary.rds")#load(file="temporary.rda")
tmp
