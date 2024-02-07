# show_sourcedata <- function(){
#     cat(paste0("\n"))
#     cat(paste0("Available datasets (see ?extract_ocean_data):\n"))
#     cat(paste0("\n"))
#     cat(paste0("------------SEA SURFACE TEMPERATURE------------\n"))
#     cat(paste0("[1] HadISST - Sea Surface Temperature (1", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[2] MUR - Sea Surface Temperature (0.01", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[3] MUR - Sea Surface Temperature (0.01", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[4] MUR - Sea Surface Temperature anomaly (0.01", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[5] MUR - Sea Surface Temperature anomaly (0.01", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[6] NOAA Coral Reef Watch - Sea Surface Temperature (0.05", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[7] NOAA Coral Reef Watch - Sea Surface Temperature anomaly (0.05", intToUtf8(176), " grid)  (0.05", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[8] NOAA OISST - Sea Surface Temperature (0.25", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[9] NOAA OISST - Sea Surface Temperature anomaly (0.25", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[10] Pathfinder - Sea Surface Temperature daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[11] Pathfinder - Sea Surface Temperature nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[12] Pathfinder - Sea Surface Temperature deviation daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[13] Pathfinder - Sea Surface Temperature deviation nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("\n"))
#     cat(paste0("------------CORAL STRESS------------\n"))
#     cat(paste0("[14] NOAA Coral Reef Watch - Degree Heating Weeks (0.05", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[15] NOAA Coral Reef Watch - Degree Heating Weeks (0.05", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[16] NOAA Coral Reef Watch - Hotspots (0.05", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[17] NOAA Coral Reef Watch - Hotspots (0.05", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[18] NOAA Coral Reef Watch - Bleaching alert area (0.05", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[19] NOAA Coral Reef Watch - Bleaching alert area (0.05", intToUtf8(176), " grid) 7-day [composite]\n"))
#     cat(paste("\n"))
#     cat(paste0("------------SEA SURFACE SALINITY------------\n"))
#     cat(paste0("[20] CoastWatch	- Sea Surface Salinity (0.25", intToUtf8(176), " grid)  [daily]\n"))
#     cat(paste0("[21] CoastWatch	- Sea Surface Salinity (0.25", intToUtf8(176), " grid)  [8-day composite]\n"))
#     cat(paste0("[22] CoastWatch	- Sea Surface Salinity mean difference (0.25", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[23] CoastWatch	- Sea Surface Salinity mean difference (0.25", intToUtf8(176), " grid) [8-day composite]\n"))
#     cat(paste0("\n"))
#     cat(paste0("------------SEA ICE------------\n"))
#     cat(paste0("[24] HadISST - Sea ice concentration (1", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[25] MUR - Sea ice fraction (0.01", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[26] MUR - Sea ice fraction (0.01", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[27] NOAA Coral Reef Watch - Sea ice fraction (0.05", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[28] NOAA OISST - Sea ice concentration (0.25", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[29] Pathfinder - Sea ice daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[30] Pathfinder - Sea ice nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("\n"))
#     cat(paste0("------------WATER QUALITY------------\n"))
#     cat(paste0("[31] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[32] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [8-day composite]\n"))
#     cat(paste0("[33] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[34] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[35] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#     cat(paste0("[36] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[37] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[38] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#     cat(paste0("[39] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[40] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[41] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [3-day composite]\n"))
#     cat(paste0("[42] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#     cat(paste0("[43] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[44] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[45] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#     cat(paste0("[46] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[47] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[48] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#     cat(paste0("[49] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [monthly]\n"))
#     cat(paste0("[50] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [daily]\n"))
#     cat(paste0("[51] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#     cat(paste0("[52] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [monthly]\n"))
#
#
# }


#' get_sourcedata()
#' DEVELOPMENT list datasets
#'
#'
#'
#'
#' @export
#'

get_sourcedata <- function(){
sourcedata <-
    base::as.data.frame(rbind(
      c("1", "erdHadISST", "sst", "HadISST", "Sea Surface Temperature", "monthly", "1870-present", "1°", "https://coastwatch.pfeg.noaa.gov/erddap/info/erdHadISSTIce/index.html"),
      c("2", "jplMURSST41", "analysed_sst", "MUR", "Sea Surface Temperature", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41/index.html"),
      c("3", "jplMURSST41mday", "sst", "MUR", "Sea Surface Temperature", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41mday/index.html"),
      c("4", "jplMURSST41anom1day", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "daily", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anom1day/index.html"),
      c("5", "jplMURSST41anommday", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "monthly", "0.01°", "2002-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/jplMURSST41anommday/index.html"),
      c("6", "NOAA_DHW", "SST", "NOAA Coral Reef Watch", "Sea Surface Temperature", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("7", "NOAA_DHW", "SSTANOMALY", "NOAA Coral Reef Watch", "Sea Surface Temperature anomaly", "daily", "0.05°", "1985-present", "https://coastwatch.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
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
  colnames(sourcedata) <- c("number", "dataset", "var", "satellite", "parameter", "temporal",  "timespan", "resolution", "url")

  return(sourcedata)

}

# ## select_sourcedata()
# # function to select sourcedata from internal selection or via
# # dataset and variable in the format dataset[variable]
# # e.g. dataset="ncdcOisst21Agg_LonPM180[sst]"
#
# select_data_source <- function(dataset = "none") {
#     ##### 1a) choose dataset from a list and filter by dataframe row:
#     if (dataset == "none") {
#       cat(paste0("\n"))
#       cat(paste0("Available datasets (see ?extract_ocean_data):\n"))
#       cat(paste0("\n"))
#       cat(paste0("------------SEA SURFACE TEMPERATURE------------\n"))
#       cat(paste0("[1] HadISST - Sea Surface Temperature (1", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[2] MUR - Sea Surface Temperature (0.01", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[3] MUR - Sea Surface Temperature (0.01", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[4] MUR - Sea Surface Temperature anomaly (0.01", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[5] MUR - Sea Surface Temperature anomaly (0.01", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[6] NOAA Coral Reef Watch - Sea Surface Temperature (0.05", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[7] NOAA Coral Reef Watch - Sea Surface Temperature anomaly (0.05", intToUtf8(176), " grid)  (0.05", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[8] NOAA OISST - Sea Surface Temperature (0.25", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[9] NOAA OISST - Sea Surface Temperature anomaly (0.25", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[10] Pathfinder - Sea Surface Temperature daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[11] Pathfinder - Sea Surface Temperature nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[12] Pathfinder - Sea Surface Temperature deviation daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[13] Pathfinder - Sea Surface Temperature deviation nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("\n"))
#       cat(paste0("------------CORAL STRESS------------\n"))
#       cat(paste0("[14] NOAA Coral Reef Watch - Degree Heating Weeks (0.05", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[15] NOAA Coral Reef Watch - Degree Heating Weeks (0.05", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[16] NOAA Coral Reef Watch - Hotspots (0.05", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[17] NOAA Coral Reef Watch - Hotspots (0.05", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[18] NOAA Coral Reef Watch - Bleaching alert area (0.05", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[19] NOAA Coral Reef Watch - Bleaching alert area (0.05", intToUtf8(176), " grid) 7-day [composite]\n"))
#       cat(paste("\n"))
#       cat(paste0("------------SEA SURFACE SALINITY------------\n"))
#       cat(paste0("[20] CoastWatch	- Sea Surface Salinity (0.25", intToUtf8(176), " grid)  [daily]\n"))
#       cat(paste0("[21] CoastWatch	- Sea Surface Salinity (0.25", intToUtf8(176), " grid)  [8-day composite]\n"))
#       cat(paste0("[22] CoastWatch	- Sea Surface Salinity mean difference (0.25", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[23] CoastWatch	- Sea Surface Salinity mean difference (0.25", intToUtf8(176), " grid) [8-day composite]\n"))
#       cat(paste0("\n"))
#       cat(paste0("------------SEA ICE------------\n"))
#       cat(paste0("[24] HadISST - Sea ice concentration (1", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[25] MUR - Sea ice fraction (0.01", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[26] MUR - Sea ice fraction (0.01", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[27] NOAA Coral Reef Watch - Sea ice fraction (0.05", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[28] NOAA OISST - Sea ice concentration (0.25", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[29] Pathfinder - Sea ice daytime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[30] Pathfinder - Sea ice nighttime (0.0417", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("\n"))
#       cat(paste0("------------WATER QUALITY------------\n"))
#       cat(paste0("[31] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[32] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [8-day composite]\n"))
#       cat(paste0("[33] Orbview-2 SeaWiFS - Chlorophyll a (0.1", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[34] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[35] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#       cat(paste0("[36] Aqua MODIS - Chlorophyll a (0.025", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[37] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[38] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#       cat(paste0("[39] Aqua MODIS - Diffuse Attenuation K490 (0.025", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[40] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[41] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [3-day composite]\n"))
#       cat(paste0("[42] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#       cat(paste0("[43] Aqua MODIS - Net Primary Productivity (0.025", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[44] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[45] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#       cat(paste0("[46] Aqua MODIS - Particulate Inorganic Carbon (0.025", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[47] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[48] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#       cat(paste0("[49] Aqua MODIS - Particulate Organic Carbon (0.025", intToUtf8(176), " grid) [monthly]\n"))
#       cat(paste0("[50] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [daily]\n"))
#       cat(paste0("[51] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [8-day composite]\n"))
#       cat(paste0("[52] Aqua MODIS - Photosynthetically Available Radiation (0.025", intToUtf8(176), " grid) [monthly]\n"))
#
#       dataset.num <- readline(prompt = "Select a dataset:")
#
#       if (dataset.num < 1 || dataset.num > 52) {
#         warning("Invalid input: Select a dataset between 1 and 52")
#       }
#
#       selectdata <- sourcedata[sourcedata$number == dataset.num, ]
#       this_dataset <- selectdata$dataset
#       this_var <- selectdata$var
#
#       ##### 1b) manually enter dataset from the list
#     } else if (dataset %in% seq(1:52)) {
#       selectdata <- sourcedata[sourcedata$number == dataset, ]
#       this_dataset <- selectdata$dataset
#       this_var <- selectdata$var
#     } else if (dataset %in% seq(52:1000)) {
#       cat(print("invalid option"))
#
#       ##### 1c. else specify dataset and variable in the format dataset[variable], e.g. dataset="ncdcOisst21Agg_LonPM180[sst]"
#     } else if (grepl("[", dataset, fixed = TRUE) == TRUE) {
#       this_var <- substr(strsplit(dataset, "[[]")[[1]][2], 1, nchar(strsplit(dataset, "[[]")[[1]][2]) - 1)
#       this_dataset <- strsplit(dataset, "[[]")[[1]][1]
#     } else {
#       cat(print("invalid option"))
#     }
#
#     select_data <- list(this_dataset, this_var)
#
#     return(select_data)
#
#   }
#
#
# myURL.3dim <- function(burl = "https://coastwatch.pfeg.noaa.gov/erddap/", data_id, ftype = ".nc", data_var, space, time) {
#   url1 <- paste(burl, "griddap/", data_id, ftype, "?", data_var, sep = "")
#   urltime <- paste("[(", paste(time[1], "T00:00:00Z", sep = ""), "):1:(", paste(time[2], "T00:00:00Z", sep = ""), ")]", sep = "")
#   urllat <- paste("[(", space[3], "):1:(", space[4], ")]", sep = "")
#   urllon <- paste("[(", space[1], "):1:(", space[2], ")]", sep = "")
#   paste(url1, urltime, urllat, urllon, sep = "")
# }
#
# myURL.4dim <- function(burl = "https://coastwatch.pfeg.noaa.gov/erddap/", data_id, ftype = ".nc", data_var, space, time) {
#   url1 <- paste(burl, "griddap/", data_id, ftype, "?", data_var, sep = "")
#   urltime <- paste("[(", paste(time[1], "T00:00:00Z", sep = ""), "):1:(", paste(time[2], "T00:00:00Z", sep = ""), ")]", sep = "")
#   urlz <- paste("[(", 0.0, "):1:(", 0.0, ")]", sep = "")
#   urllat <- paste("[(", space[3], "):1:(", space[4], ")]", sep = "")
#   urllon <- paste("[(", space[1], "):1:(", space[2], ")]", sep = "")
#   paste(url1, urltime, urlz, urllat, urllon, sep = "")
# }



#' tidy_OD
#' function to tidy output from erdapp
#'
#' @param file.data file
#' @param data_id id
#' @param data_var var
#' @param sites sites or space? TRUE/FALSE
#' @export

tidy_od <- function(file.data, data_id, data_var, sites = FALSE, ...) {

  info.erddap <- readLines(paste0("https://coastwatch.pfeg.noaa.gov/erddap/info/", data_id, "/index.html"))

  if (isFALSE(sites)) {
  if (any(grep("zlev", info.erddap)) == TRUE) {
    file.data <- file.data |>
      #    as.data.frame() |> # standardise longitude and latitude
      dplyr::rename_with(.col = grep(".*time.*", names(file.data), ignore.case = TRUE), ~"time") |>
      dplyr::rename_with(.col = grep(".*lon.*", names(file.data), ignore.case = TRUE), ~"longitude") |>
      dplyr::rename_with(.col = grep(".*lat.*", names(file.data), ignore.case = TRUE), ~"latitude") |> # standardise longitude and latitude
      dplyr::select(-contains("zlev")) |>
      dplyr::select(time, longitude, latitude, {{ data_var }} := 4)|>
      janitor::clean_names()
  } else if (any(grep("zlev", info.erddap)) == FALSE) {
    file.data <- file.data |>
      dplyr::rename_with(.col = grep(".*time.*", names(file.data), ignore.case = TRUE), ~"time") |>
      dplyr::rename_with(.col = grep(".*lon.*", names(file.data), ignore.case = TRUE), ~"longitude") |>
      dplyr::rename_with(.col = grep(".*lat.*", names(file.data), ignore.case = TRUE), ~"latitude") |> # standardise longitude and latitude
      dplyr::select(time, longitude, latitude, {{ data_var }} := 4) |>
      janitor::clean_names()
  }

  } else if (!isFALSE(sites)) {
    if (any(grep("zlev", info.erddap)) == TRUE) {
      file.data <- file.data |>
        select(-longitude_cell, -latitude_cell, -contains("zlev")) |>
        dplyr::rename_at(2, ~ "time") |>
        dplyr::rename_at(3, ~ "longitude_cell") |>
        dplyr::rename_at(4, ~ "latitude_cell")
    } else if (any(grep("zlev", info.erddap)) == FALSE) {
      file.data <- file.data |>
        select(-longitude_cell, -latitude_cell) |>
        dplyr::rename_at(2, ~ "time") |>
        dplyr::rename_at(3, ~ "longitude_cell") |>
        dplyr::rename_at(4, ~ "latitude_cell")
          }
    #file.data <- left_join(file.data, coordlist, by = c("longitude", "latitude"))
  }
  return(file.data)
}



#' get XML header
#'
#'
#' @param data_id 1:52 common datasets
#' @param data_var data var name
#' @param burl base URL  "https://coastwatch.pfeg.noaa.gov/erddap/",
#' @param space space
#' @param time time
#'
#' @export


get_xml_headers <- function(data_id, data_var, burl = "https://coastwatch.pfeg.noaa.gov/erddap/", space, time) {
  erddap_xml_URL <- paste(burl, "metadata/iso19115/xml/", data_id, "_iso19115.xml", sep = "")
  erddap_xml_data <- XML::xmlParse(httr::content(httr::GET(erddap_xml_URL), "text"))
  xml_data <- XML::xmlToList(erddap_xml_data)

  ### make header from XML
  # xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent # spatial extent information
  # grep for characters
  # lapply(xml_data, function(x) grep(15107, x))

  header_file <- as.data.frame((rbind(
    c("1", "Title", xml_data$identificationInfo$MD_DataIdentification$citation$CI_Citation$title$CharacterString),
    c("2", "Dataset ID", xml_data$fileIdentifier),
    c("3", "Variable", data_var),
    c("4", "URL", paste(burl, "erddap/griddap/", data_id, ".html", sep = "")),
    c("5", "Abstract", xml_data$identificationInfo$MD_DataIdentification$abstract$CharacterString),
    c("6", "ndims", xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation$numberOfDimensions),
    c("7", "Longitude - minimum value", as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$westBoundLongitude$Decimal)),
    c("8", "Longitude - maximum value", as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$eastBoundLongitude$Decimal)),
    c("9", "Longitude - number of values", as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$eastBoundLongitude$Decimal)),
    c("10", "Longitude - resolution", as.numeric(xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation[2]$axisDimensionProperties$MD_Dimension$resolution$Measure$text)),
    c("11", "Longitude - attrs", (xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation[2]$axisDimensionProperties$MD_Dimension$resolution$Measure$.attrs)),
    c("12", "Latitude - minimumvalue", as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$southBoundLatitude$Decimal)),
    c("13", "Latitude - maximum value", as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$northBoundLatitude$Decimal)),
    c("14", "Latitude - resolution", as.numeric(xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation[3]$axisDimensionProperties$MD_Dimension$resolution$Measure$text)),
    c("15", "Latitude - attrs", (xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation[3]$axisDimensionProperties$MD_Dimension$resolution$Measure$.attrs)),
    c("16", "Start time date", as.character(as.Date(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$beginPosition))),
    c("17", "End time date", as.character(as.Date(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$endPosition))),
    c("18", "Time period description", as.character(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$description))
    #  c("19", "Number of time steps", as.character(xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation$axisDimensionProperties$MD_Dimension$dimensionSize$Integer))
  )))
  names(header_file) <-  c("number", "variable", "value")

  minLon <- as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$westBoundLongitude$Decimal)
  maxLon <- as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$eastBoundLongitude$Decimal)
  minLat <- as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$southBoundLatitude$Decimal)
  maxLat <- as.numeric(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$geographicElement$EX_GeographicBoundingBox$northBoundLatitude$Decimal)
  minTime <- as.Date(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$beginPosition)
  maxTime <- as.Date(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$endPosition)

  xml_files <- list()
  xml_files[[1]] <- ifelse(space[1] < minLon, minLon, space[1])
  xml_files[[2]] <- ifelse(space[2] > maxLon, maxLon, space[2])
  xml_files[[3]] <- ifelse(space[3] < minLat, minLat, space[3])
  xml_files[[4]] <- ifelse(space[4] > maxLat, maxLat, space[4])
  xml_files[[5]] <- as.Date(ifelse(time[1] < minTime, minTime, time[1]), origin = "1970-01-01T00:00:00Z")
  xml_files[[6]] <- as.Date(ifelse(time[2] > maxTime, maxTime, time[2]), origin = "1970-01-01T00:00:00Z")
  xml_files[[7]] <- header_file
  return(xml_files)

}



#' download_OD
#' function to download data
#'
#' @param data_id id
#' @param data_var var
#' @param space id
#' @param time var
#' @export

download_od <- function(data_id, data_var, space, time, ...){

  ##### get URL
  info.erddap <- readLines(paste0("https://coastwatch.pfeg.noaa.gov/erddap/info/", data_id, "/index.html"))

  ##### get XML headers for download with space and time corrected for grid
  xml_headers <- get_xml_headers(data_id, data_var, space=space, time=time) # get correct space and time from xml data
  xml.space <- c(xml_headers[[1]], xml_headers[[2]], xml_headers[[3]], xml_headers[[4]]) # new space from xml
  xml.time <- c(xml_headers[[5]], xml_headers[[6]]) # new time from xml

  #####  # generate URL for data download
  if (any(grep("zlev", info.erddap)) == TRUE) {
    erddap_url <- myURL.4dim(data_id = data_id, data_var = data_var, ftype = ".csvp", space = xml.space, time = xml.time)
  } else if (any(grep("zlev", info.erddap)) == FALSE) {
    erddap_url <- myURL.3dim(data_id = data_id, data_var = data_var, ftype = ".csvp", space = xml.space, time = xml.time)
  }

  cat((paste0("Downloading... \n")))
  cat((paste0(xml_headers[[7]]$value[[1]], "\n")))
  #cat((paste0(xml_headers[[7]]$value[[2]], " ", xml_headers[[7]]$value[[3]], " (", xml_headers[[7]]$value[[18]], " resolution)", "\n")))
  #cat((paste0(sourcedata$satellite[dataset], " ", sourcedata$parameter[dataset], " (", sourcedata$temporal[dataset], " resolution)", "\n")))
  cat(paste0("Date range: ", xml.time[1], " and ", xml.time[2], "\n"))
  # cat(paste0("Date range: ",xml.time[1]," and ", xml.time[2], " (x",length(unique(tmp$time)), " ", sourcedata$temporal[dataset], " timesteps)", "\n"))
  # cat((paste0(sourcedata$satellite[dataset], " ", sourcedata$parameter[dataset], " ", sourcedata$monthly[dataset], "\n")))
  start_time <- Sys.time()
  file.data <- httr::content(httr::GET(erddap_url, httr::progress()), show_col_types = FALSE)
  end_time <- Sys.time()
  cat(("Download complete\n"))
  cat((paste0("Time taken to download: ", round(end_time - start_time, 2), " seconds\n")))

  object_size_kb <- pryr::object_size(file.data) / 1024  # Convert to KB
  object_size_mb <- object_size_kb / 1024     # Convert to MB

  if (object_size_mb < 1) {
    cat(paste0("File size: ", round(object_size_kb, 2), " KB\n"))     # If size is less than 1 MB, report in KB
  } else {
    cat(paste0("File size: ", round(object_size_mb, 2), " MB\n"))     # If size is 1 MB or more, report in MB
  }

  return(file.data)

}



