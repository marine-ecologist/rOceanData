# ocean_data_functions

# check these links
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


#' select_data_source
#'
#' DEVELOPMENT Choose dataset from list
#'
#'
#'
#' @param dataset 1:52 common datasets
#' @export
#'

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


#' myURL.3dim
#'
#' get 3 dim URL (lon/lat/var)
#'
#'
#'
#' @param dataset 1:52 common datasets
#' @param burl base URL  "https://coastwatch.pfeg.noaa.gov/erddap/",
#' @param data_id data id
#' @param ftype file type = ".nc",
#' @param data_var data var,
#' @param space space
#' @param time time
#'
#' @export



myURL.3dim <- function(burl = "https://coastwatch.pfeg.noaa.gov/erddap/", data_id, ftype = ".nc", data_var, space, time) {
  url1 <- paste(burl, "griddap/", data_id, ftype, "?", data_var, sep = "")
  urltime <- paste("[(", paste(time[1], "T00:00:00Z", sep = ""), "):1:(", paste(time[2], "T00:00:00Z", sep = ""), ")]", sep = "")
  urllat <- paste("[(", space[3], "):1:(", space[4], ")]", sep = "")
  urllon <- paste("[(", space[1], "):1:(", space[2], ")]", sep = "")
  paste(url1, urltime, urllat, urllon, sep = "")
}

# myURL.3dim <- function(burl = "https://coastwatch.pfeg.noaa.gov/erddap/", data_id, ftype = ".nc", data_var, space, time) {
#   url1 <- paste(burl, "griddap/", data_id, ftype, "?", data_var, sep = "")
#   urltime <- paste("[(", paste(new.time[1], "T00:00:00Z", sep = ""), "):1:(", paste(new.time[2], "T00:00:00Z", sep = ""), ")]", sep = "")
#   urllat <- paste("[(", new.space[3], "):1:(", new.space[4], ")]", sep = "")
#   urllon <- paste("[(", new.space[1], "):1:(", new.space[2], ")]", sep = "")
#   paste(url1, urltime, urllat, urllon, sep = "")
# }


#' myURL.4dim
#'
#' get 4 dim URL (lon/lat/z/var)
#'
#'
#'
#' @param dataset 1:52 common datasets
#' @param burl base URL  "https://coastwatch.pfeg.noaa.gov/erddap/",
#' @param data_id data id
#' @param ftype file type = ".nc",
#' @param data_var data var,
#' @param space space
#' @param time time
#'
#' @export


# myURL.4dim <- function(burl = "https://coastwatch.pfeg.noaa.gov/erddap/", data_id, ftype = ".nc", data_var, space, time) {
#   url1 <- paste(burl, "griddap/", data_id, ftype, "?", data_var, sep = "")
#   urltime <- paste("[(", paste(new.time[1], "T00:00:00Z", sep = ""), "):1:(", paste(new.time[2], "T00:00:00Z", sep = ""), ")]", sep = "")
#   urlz <- paste("[(", 0.0, "):1:(", 0.0, ")]", sep = "")
#   urllat <- paste("[(", new.space[3], "):1:(", new.space[4], ")]", sep = "")
#   urllon <- paste("[(", new.space[1], "):1:(", new.space[2], ")]", sep = "")
#   paste(url1, urltime, urlz, urllat, urllon, sep = "")
# }

myURL.4dim <- function(burl = "https://coastwatch.pfeg.noaa.gov/erddap/", data_id, ftype = ".nc", data_var, space, time) {
  url1 <- paste(burl, "griddap/", data_id, ftype, "?", data_var, sep = "")
  urltime <- paste("[(", paste(time[1], "T00:00:00Z", sep = ""), "):1:(", paste(time[2], "T00:00:00Z", sep = ""), ")]", sep = "")
  urlz <- paste("[(", 0.0, "):1:(", 0.0, ")]", sep = "")
  urllat <- paste("[(", space[3], "):1:(", space[4], ")]", sep = "")
  urllon <- paste("[(", space[1], "):1:(", space[2], ")]", sep = "")
  paste(url1, urltime, urlz, urllat, urllon, sep = "")
}

#' extract griddap 180_points
#'
#'
#' @param space space
#' @param time time
#' @param this_dataset = this dataset
#' @param this_var - this var
#' @export


extract_griddap_180_points <- function(space = NULL, time = NULL, this_dataset = NULL, this_var = NULL) {
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

    coordlist.rn <- coordlist |> # standardise longitude and latitude for sanity
      dplyr::rename_with(.col = grep(".*lon.*", names(coordlist), ignore.case = TRUE), ~"longitude") |>
      dplyr::rename_with(.col = grep(".*lat.*", names(coordlist), ignore.case = TRUE), ~"latitude")

    #    coordlist.rn$longitude <- ifelse(coordlist.rn < 0, 360 + coordlist.rn, coordlist.rn)

    coords.pts <- list()
    for (i in 1:nrow(coordlist.rn)) {
      tmp.coord <- coordlist.rn[i, ]
      lon.pts <- c(tmp.coord$longitude, (tmp.coord$longitude))
      lat.pts <- c(tmp.coord$latitude, (tmp.coord$latitude))

      pts.csv <- rerddap::griddap(this_dataset, fmt = "nc", longitude = lon.pts, latitude = lat.pts, time = time)

      pts.csv.data <- as.data.frame(pts.csv$data)
      pts.csv.data <- pts.csv.data |> dplyr::select(longitude, latitude, time, all_of(this_var))
      # pts.csv.data[4][is.na(pts.csv.data[4])] <- 0  <- # replace missing values with na for this_var
      colnames(pts.csv.data)[colnames(pts.csv.data) == "longitude"] <- "cell.longitude" # rename to include actual cell coordinates
      colnames(pts.csv.data)[colnames(pts.csv.data) == "latitude"] <- "cell.latitude" # rename to include cell coordinates
      pts.csv.data$cell.longitude <- as.numeric(pts.csv.data$cell.longitude) # reformat array to numeric
      pts.csv.data$cell.latitude <- as.numeric(pts.csv.data$cell.latitude) # reformat array to numeric
      pts.csv.data <- pts.csv.data[!is.na(pts.csv.data[[this_var]]), ] # return only dates with values for this_var
      pts.csv.data[paste(this_var)][pts.csv.data[paste(this_var)] == pts.csv$summary$var[[this_var]]$missval] <- NA # replace missing values with NA

      coords.list <- merge(tmp.coord, pts.csv.data) # combine with original coords file row for metadata
      coords.list <- coords.list |>
        dplyr::group_by(time) |>
        dplyr::slice(which.min(abs(longitude - cell.longitude))) # if returns multiple longitude cells get closest match to data
      coords.list <- coords.list |>
        dplyr::group_by(time) |>
        dplyr::slice(which.min(abs(latitude - cell.latitude))) # if returns multiple latitude cells get closest match to data
      coords.pts[[i]] <- coords.list
    }

    spatial_points_extract <- do.call(rbind, coords.pts)
    spatial_points_extract <- as.data.frame(spatial_points_extract)
    save(spatial_extent_data, spatial_extent_raster,
      file = paste0(filename, ".rda")
    )
  }
}


#' function to shift longitude
#'
#'
#' @param longitude degrees
#' @export


shift_longitude <- function(longitude) { # rotate function
  ind <- which(longitude < 0)
  longitude[ind] <- longitude[ind] + 360
  return(longitude)
}
