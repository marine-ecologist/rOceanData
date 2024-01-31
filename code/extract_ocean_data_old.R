

extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent")
extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent2", dataset = "ncdcOisst21Agg_LonPM180[sst]")
extract_ocean_data(space = c(-42, 40, 40, 42), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent", dataset = 17)



extract_ocean_data <- function(dataset = "none", saveas = NULL, space = NULL, time = NULL, ERDDAP_server_url="https://coastwatch.pfeg.noaa.gov/erddap/", save.raster = TRUE) {

  source("R/od_functions.R")


  {sourcedata <-
    base::as.data.frame(rbind(
      c("1", "erdHadISST", "sst", "HadISST", "Sea Surface Temperature", "monthly", "1870-present", "1°", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISSTIce/index.html"),
      c("2", "jplMURSST41", "analysed_sst", "MUR", "Sea Surface Temperature", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41/index.html"),
      c("3", "jplMURSST41mday", "analysed_sst", "MUR", "Sea Surface Temperature", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41mday/index.html"),
      c("4", "jplMURSST41anom1day", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anom1day/index.html"),
      c("5", "jplMURSST41anommday", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anommday/index.html"),
      c("6", "NOAA_DHW", "CRW_SST", "NOAA Coral Reef Watch", "Sea Surface Temperature", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("7", "NOAA_DHW", "CRW_SSTANOMALY", "NOAA Coral Reef Watch", "Sea Surface Temperature anomaly", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("8", "ncdcOisst21Agg_LonPM180", "sst", "NOAA OISST", "Sea Surface Temperature", "daily", "0.25°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
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
      c("24", "erdHadISSTIce", "sic", "HadISST", "Sea ice fraction", "monthly", "1°", "1870-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISST/index.html"),
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

  select_data_source <- function(dataset = "none") {

  {sourcedata <-
    base::as.data.frame(rbind(
      c("1", "erdHadISST", "sst", "HadISST", "Sea Surface Temperature", "monthly", "1870-present", "1°", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISSTIce/index.html"),
      c("2", "jplMURSST41", "analysed_sst", "MUR", "Sea Surface Temperature", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41/index.html"),
      c("3", "jplMURSST41mday", "analysed_sst", "MUR", "Sea Surface Temperature", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41mday/index.html"),
      c("4", "jplMURSST41anom1day", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anom1day/index.html"),
      c("5", "jplMURSST41anommday", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anommday/index.html"),
      c("6", "NOAA_DHW", "CRW_SST", "NOAA Coral Reef Watch", "Sea Surface Temperature", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("7", "NOAA_DHW", "CRW_SSTANOMALY", "NOAA Coral Reef Watch", "Sea Surface Temperature anomaly", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("8", "ncdcOisst21Agg_LonPM180", "sst", "NOAA OISST", "Sea Surface Temperature", "daily", "0.25°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
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
      c("24", "erdHadISSTIce", "sic", "HadISST", "Sea ice fraction", "monthly", "1°", "1870-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISST/index.html"),
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


   base::as.data.frame(rbind(
      c("1", "erdHadISST", "sst", "HadISST", "Sea Surface Temperature", "monthly", "1870-present", "1°", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISSTIce/index.html"),
      c("2", "jplMURSST41", "analysed_sst", "MUR", "Sea Surface Temperature", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41/index.html"),
      c("3", "jplMURSST41mday", "analysed_sst", "MUR", "Sea Surface Temperature", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41mday/index.html"),
      c("4", "jplMURSST41anom1day", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anom1day/index.html"),
      c("5", "jplMURSST41anommday", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anommday/index.html"),
      c("6", "NOAA_DHW", "CRW_SST", "NOAA Coral Reef Watch", "Sea Surface Temperature", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("7", "NOAA_DHW", "CRW_SSTANOMALY", "NOAA Coral Reef Watch", "Sea Surface Temperature anomaly", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("8", "ncdcOisst21Agg_LonPM180", "sst", "NOAA OISST", "Sea Surface Temperature", "daily", "0.25°", "1981-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
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
      c("24", "erdHadISSTIce", "sic", "HadISST", "Sea ice fraction", "monthly", "1°", "1870-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISST/index.html"),
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

  ##### 1a) choose dataset from a list and filter by dataframe row:
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

    ##### 1b) manually enter dataset from the list
  } else if (dataset %in% seq(1:52)) {
    selectdata <- sourcedata[sourcedata$number == dataset, ]
    this_dataset <- selectdata$dataset
    this_var <- selectdata$var
  } else if (dataset %in% seq(52:1000)) {
    cat(print("invalid option"))

    ##### 1c. else specify dataset and variable in the format dataset[variable], e.g. dataset="ncdcOisst21Agg_LonPM180[sst]"
  } else if (grepl("[", dataset, fixed = TRUE) == TRUE) {
    this_var <- substr(strsplit(dataset, "[[]")[[1]][2], 1, nchar(strsplit(dataset, "[[]")[[1]][2]) - 1)
    this_dataset <- strsplit(dataset, "[[]")[[1]][1]
  } else {
    cat(print("invalid option"))
  }

  select_data <- list(this_dataset, this_var)
  select_data
}

print(select_data)

source("R/od_functions.R")

##### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
##### 1. Get dataset
##### three options: 1a) specify dataset and variable, 1b) select dataset from the list with prompt, 1c) enter dataset from list

this_dataset <- select_data_source(dataset = dataset) # original keep
#this_dataset <- select_data_source(dataset = "none") # delete

##### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
##### Get dataset_information
this_dataset_info <- rerddap::info(paste(this_dataset)[[1]], ERDDAP_server_url) # print dump this?
this_var <- this_dataset[[2]]

# get longitude range from rerddap info() file
dataset.xlims <- (subset(this_dataset_info$alldata$longitude, attribute_name == "actual_range", "value")$value)
dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])

# get time parameters from rerddap info() file
dataset.time.lims <- (subset(this_dataset_info$alldata$time, attribute_name == "actual_range", "value")$value)
dataset.time.origin <- (subset(this_dataset_info$alldata$time, attribute_name == "time_origin", "value")$value)
dataset.time.units <- (subset(this_dataset_info$alldata$time, attribute_name == "units", "value")$value)
dataset.time.split <- strsplit(dataset.time.lims, ",")[1]
dataset.time.min <- as.numeric(dataset.time.split[[1]][1])
dataset.time.max <- as.numeric(dataset.time.split[[1]][2])
dataset.time.firstdate <- if (grepl(".*seconds.*", dataset.time.units)) {
      lubridate::date(lubridate::as_datetime(as.Date(dataset.time.min / 86400, origin = anytime::anydate(dataset.time.origin))))
    } else if (grepl(".*day.*", dataset.time.units)) {
      lubridate::date(lubridate::as_datetime(as.Date(dataset.time.min / 86400, origin = anytime::anydate(dataset.time.origin))))
    } else {
      cat(print("invalid date format"))
    }
dataset.time.latestdate <- if (grepl(".*seconds.*", dataset.time.units)) {
      lubridate::date(lubridate::as_datetime(as.Date(dataset.time.max / 86400, origin = anytime::anydate(dataset.time.origin))))
    } else if (grepl(".*day.*", dataset.time.units)) {
      lubridate::date(lubridate::as_datetime(as.Date(dataset.time.max / 86400, origin = anytime::anydate(dataset.time.origin))))
    } else {
      cat(print("invalid date format"))
    }

# check time parameters and add warnings if invalid
if (time[1] < dataset.time.firstdate) {
    stop(cat(paste0("***extract_ocean_data error***\nInput start date ", time[1], " is prior the first available time for ", this_dataset," (",dataset.time.firstdate,")", "\nSelect a date range between " , dataset.time.firstdate, " and ", dataset.time.latestdate, "\n ")))
  }

##### if spatial points

if (is.character(space)[1] == TRUE) {

  if (grepl(".*xlsx.*", space) == TRUE) {
    coordlist <- readxl::read_excel(space)
  } else if (grepl(".*xls.*", space) == TRUE) {
    coordlist <- readxl::read_excel(space)
  } else if (grepl(".*csv.*", space) == TRUE) {
    coordlist <- read.csv(space) |> select(-1)
  } else {
    (stop(print("coordinates file must be in one of the following formats: .xlsx, .xls, .csv")))
  }

  if (dataset.xmin < 0) {

  } else if (dataset.xmax > 180) {
    print("tbf")
    spatial_points_extract <- "tbf"
  }


  ##### else spatial extent
} else if (length(space) == 4) {
  if (dataset.xmin < 0) {

  ###############################################################################
  ### extract_griddap_180_extent
  ###############################################################################
  #this_dataset_info <- rerddap::info(paste(this_dataset)[1]) # no need to get twice, same earlier
  dataset.xlims <- (subset(this_dataset_info$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])
  dataset_nc_180 <- rerddap::griddap(this_dataset_info, fmt = "nc", longitude = space[1:2], latitude = space[3:4], time = time)
  dataset_nc_180.data <- dataset_nc_180$data |>
    dplyr::select(longitude, latitude, time, paste(this_var)) |>
    dplyr::arrange(rev(latitude)) |>
    as.data.frame()
  dataset_nc_180.data$longitude <- as.numeric(as.character(dataset_nc_180.data$longitude))
  dataset_nc_180.data$latitude <- as.numeric(as.character(dataset_nc_180.data$latitude))

  spatial.ext.180 <- terra::ext(min(dataset_nc_180.data$longitude, na.rm = TRUE), max(dataset_nc_180.data$longitude, na.rm = TRUE), min(dataset_nc_180.data$latitude, na.rm = TRUE), max(dataset_nc_180.data$latitude, na.rm = TRUE))
  dataset_nc_180.rast <- terra::rast(
    nrows = length(unique(dataset_nc_180.data$latitude)),
    ncols = length(unique(dataset_nc_180.data$longitude)),
    ext = spatial.ext.180,
    nl = length(unique(dataset_nc_180.data$time)),
    crs = "EPSG:4326",
    vals = dataset_nc_180.data[[this_var]])

  names(dataset_nc_180.rast) <- paste0(as.character(unique(lubridate::ymd(as.Date(dataset_nc_180.data$time)))))
  terra::time(dataset_nc_180.rast) <- (unique(lubridate::ymd(as.Date(dataset_nc_180.data$time))))

  spatial_extent_data <- dataset_nc_180.data
  spatial_extent_raster <- terra::wrap(dataset_nc_180.rast)
  spatial_extent_information <- this_dataset_info$alldata
  datalist <- list(
    spatial_extent_data = spatial_extent_data,
    spatial_extent_raster = spatial_extent_raster,
    spatial_extent_information = spatial_extent_information
  )
  saveRDS(datalist, paste0(saveas, ".rds"))
  rm(this_dataset, this_var, sourcedata, envir=.GlobalEnv)
  ###############################################################################
  ###############################################################################

  } else if (dataset.xmax > 180) {

###############################################################################
### extract_griddap_360_extent
###############################################################################
      this_dataset_info <- rerddap::info(paste(this_dataset))
      dataset.xlims <- (subset(this_dataset_info$alldata$longitude, attribute_name == "actual_range", "value")$value)
      dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
      dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
      dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])

      if (space[1] > 0 & space[2] > 0) {
        longitude.extent.a <- c(space[1], space[2])
        datasetnc_a <- rerddap::griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.a, latitude = space[3:4], time = time)
        datasetnc_a.data <- datasetnc_a$data # get data.frame a
        dataset_nc_360.data <- (datasetnc_a.data) |> # merge dataframes
          dplyr::select(longitude, latitude, time, paste(this_var)) |> # na.omit()
          dplyr::arrange(rev(latitude)) |> as.data.frame()
        dataset_nc_360.data$longitude <- as.numeric(as.character(dataset_nc_360.data$longitude))
        dataset_nc_360.data$latitude <- as.numeric(as.character(dataset_nc_360.data$latitude))

        spatial.ext.360 <- terra::ext(min(dataset_nc_360.data$longitude, na.rm = TRUE), max(dataset_nc_360.data$longitude, na.rm = TRUE), min(dataset_nc_360.data$latitude, na.rm = TRUE), max(dataset_nc_360.data$latitude, na.rm = TRUE))
        dataset_nc_360.rast <- terra::rast(
          nrows = length(unique(dataset_nc_360.data$latitude)),
          ncols = length(unique(dataset_nc_360.data$longitude)),
          ext = spatial.ext.360,
          nl = length(unique(dataset_nc_360.data$time)),
          crs = "EPSG:4326",
          vals = dataset_nc_360.data[[this_var]]
        )
        dataset_nc_360.rast
      } else if (space[1] < 0 & space[2] > 0) {
        longitude.extent.b <- c(360 + space[1], dataset.xmax) # split extents around meridian
        longitude.extent.a <- c(dataset.xmin, space[2])
        datasetnc_b <- rerddap::griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.b, latitude = space[3:4], time = time) # extract both splits seperately
        datasetnc_a <- rerddap::griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.a, latitude = space[3:4], time = time)

        datasetnc_b.data <- datasetnc_b$data |> # get data.frame b
          dplyr::select(longitude, latitude, time, paste(this_var)) |> # na.omit()
          dplyr::arrange(rev(latitude)) |> as.data.frame()
        datasetnc_b.data$longitude <- as.numeric(as.character(datasetnc_b.data$longitude)) - 360
        datasetnc_b.data$latitude <- as.numeric(as.character(datasetnc_b.data$latitude))


        datasetnc_a.data <- datasetnc_a$data |> # get data.frame a
          dplyr::select(longitude, latitude, time, paste(this_var)) |> # na.omit()
          dplyr::arrange(rev(latitude)) |> as.data.frame()

        dataset_nc_360.data <- rbind(datasetnc_a.data, datasetnc_b.data) |> # merge dataframes
          dplyr::arrange(rev(latitude), longitude)

        spatial.ext.360 <- terra::ext(min(dataset_nc_360.data$longitude, na.rm = TRUE), max(dataset_nc_360.data$longitude, na.rm = TRUE), min(dataset_nc_360.data$latitude, na.rm = TRUE), max(dataset_nc_360.data$latitude, na.rm = TRUE))
        dataset_nc_360.rast <- terra::rast(
          nrows = length(unique(dataset_nc_360.data$latitude)),
          ncols = length(unique(dataset_nc_360.data$longitude)),
          ext = spatial.ext.360,
          nl = length(unique(dataset_nc_360.data$time)),
          crs = "EPSG:4326",
          vals = dataset_nc_360.data[[this_var]]
        )
        dataset_nc_360.rast

      } else if (space[1] < 0 & space[2] < 0) {
        longitude.extent.b <- c(360 + space[1], 360 + space[2]) # split extents around meridian
        datasetnc_b <- rerddap::griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.b, latitude = space[3:4], time = time) # extract both splits seperately
        datasetnc_b.data <- datasetnc_b$data
        datasetnc_b.data$longitude <- as.numeric(datasetnc_b.data$longitude) - 360 # shift back to 180
        dataset_nc_360.data <- (datasetnc_b.data) |> # merge dataframes
          dplyr::select(longitude, latitude, time, paste(this_var)) |> # na.omit()
          dplyr::arrange(rev(latitude)) |> as.data.frame()
        dataset_nc_360.data$longitude <- as.numeric(as.character(dataset_nc_360.data$longitude))
        dataset_nc_360.data$latitude <- as.numeric(as.character(dataset_nc_360.data$latitude))


        spatial.ext.360 <- terra::ext(min(dataset_nc_360.data$longitude, na.rm = TRUE), max(dataset_nc_360.data$longitude, na.rm = TRUE), min(dataset_nc_360.data$latitude, na.rm = TRUE), max(dataset_nc_360.data$latitude, na.rm = TRUE))
        dataset_nc_360.rast <- terra::rast(
          nrows = length(unique(dataset_nc_360.data$latitude)),
          ncols = length(unique(dataset_nc_360.data$longitude)),
          ext = spatial.ext.360,
          nl = length(unique(dataset_nc_360.data$time)),
          crs = "EPSG:4326",
          vals = dataset_nc_360.data[[this_var]]
        )
      }
      spatial_extent_data <- dataset_nc_360.data
      spatial_extent_raster <- dataset_nc_360.rast
      spatial_extent_information <- this_dataset_info$alldata
    datalist <- list(
          spatial_extent_data = spatial_extent_data,
          spatial_extent_raster = spatial_extent_raster,
          spatial_extent_information = spatial_extent_information
        )
  saveRDS(datalist, paste0(saveas, ".rds"))
  rm(this_dataset, this_var, sourcedata)
          }

############################################################################
############################################################################

}
}
