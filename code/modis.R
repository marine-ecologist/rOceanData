extract_ocean_data_2 <- function(dataset = "none", filename = NULL, space = NULL, time = NULL, save.output = TRUE) {
  {sourcedata <-
    base::as.data.frame(rbind(
      c("1", "erdHadISST", "sst", "HadISST", "Sea Surface Temperature", "monthly", "1870-present", "1°", "https://upwell.pfeg.noaa.gov/erddap/info/erdHadISSTIce/index.html"),
      c("2", "jplMURSST41", "analysed_sst", "MUR", "Sea Surface Temperature", "daily", "0.01°", "2002-present", "https://upwell.pfeg.noaa.gov/erddap/info/jplMURSST41/index.html"),
      c("3", "jplMURSST41mday", "analysed_sst", "MUR", "Sea Surface Temperature", "monthly", "0.01°", "2002-present", "https://upwell.pfeg.noaa.gov/erddap/info/jplMURSST41mday/index.html"),
      c("4", "jplMURSST41anom1day", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "daily", "0.01°", "2002-present", "https://upwell.pfeg.noaa.gov/erddap/info/jplMURSST41anom1day/index.html"),
      c("5", "jplMURSST41anommday", "sstAnom", "MUR", "Sea Surface Temperature anomaly", "monthly", "0.01°", "2002-present", "https://upwell.pfeg.noaa.gov/erddap/info/jplMURSST41anommday/index.html"),
      c("6", "NOAA_DHW", "CRW_SST", "NOAA Coral Reef Watch", "Sea Surface Temperature", "daily", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("7", "NOAA_DHW", "CRW_SSTANOMALY", "NOAA Coral Reef Watch", "Sea Surface Temperature anomaly", "daily", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("8", "ncdcOisst21Agg_LonPM180", "sst", "NOAA OISST", "Sea Surface Temperature", "daily", "0.25°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
      c("9", "ncdcOisst21Agg_LonPM180", "anom", "NOAA OISST", "Sea Surface Temperature anomaly", "daily", "0.25°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
      c("10", "nceiPH53sstd1day", "sea_surface_temperature", "Pathfinder", "Sea Surface Temperature (daytime)", "daily", "0.0417°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/nceiPH53sstd1day/index.html"),
      c("11", "nceiPH53sstn1day", "sea_surface_temperature", "Pathfinder", "Sea Surface Temperature (nighttime)", "daily", "0.0417°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/nceiPH53sstn1day/index.html"),
      c("12", "nceiPH53sstd1day", "dt_analysis", "Pathfinder", "Sea Surface Temperature deviation (daytime)", "daily", "0.0417°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/nceiPH53sstd1day/index.html"),
      c("13", "nceiPH53sstn1day", "dt_analysis", "Pathfinder", "Sea Surface Temperature deviation (nighttime)", "daily", "0.0417°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/nceiPH53sstn1day/index.html"),
      c("14", "NOAA_DHW", "CRW_DHW", "NOAA Coral Reef Watch", "Degree Heating Weeks", "daily", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("15", "NOAA_DHW_monthly", "sea_surface_temperature", "NOAA Coral Reef Watch", "Degree Heating Weeks", "monthly", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW_monthly/index.html"),
      c("16", "NOAA_DHW", "CRW_HOTSPOT", "NOAA Coral Reef Watch", "Hotspots", "daily", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("17", "NOAA_DHW_monthly", "sea_surface_temperature_anomaly", "NOAA Coral Reef Watch", "Hotspots", "monthly", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW_monthly/index.html"),
      c("18", "NOAA_DHW", "CRW_BAA", "NOAA Coral Reef Watch", "Bleaching alert area", "daily", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("19", "NOAA_DHW", "CRW_BAA_7D_MAX", "NOAA Coral Reef Watch", "Bleaching alert area", "7-day", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("20", "coastwatchSMOSv662SSS1day", "sss", "CoastWatch", "Sea Surface Salinity", "daily", "0.25°", "2010-present", "https://upwell.pfeg.noaa.gov/erddap/info/coastwatchSMOSv662SSS1day/index.html"),
      c("21", "coastwatchSMOSv662SSS3day", "sss", "CoastWatch", "Sea Surface Salinity", "8-day ", "0.25°", "2010-present", "https://upwell.pfeg.noaa.gov/erddap/info/coastwatchSMOSv662SSS3day/index.html"),
      c("22", "coastwatchSMOSv662SSS1day", "sss_dif", "CoastWatch", "Sea Surface Salinity mean difference", "daily", "0.25°", "2010-present", "https://upwell.pfeg.noaa.gov/erddap/info/coastwatchSMOSv662SSS1day/index.html"),
      c("23", "coastwatchSMOSv662SSS3day", "sss_dif", "CoastWatch", "Sea Surface Salinity mean difference", "8-day ", "0.25°", "2010-present", "https://upwell.pfeg.noaa.gov/erddap/info/coastwatchSMOSv662SSS3day/index.html"),
      c("24", "erdHadISSTIce", "sic", "HadISST", "Sea ice fraction", "monthly", "1°", "1870-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdHadISST/index.html"),
      c("25", "jplMURSST41", "sea_ice_fraction", "MUR", "Sea ice fraction", "daily", "0.01°", "2002-present", "https://upwell.pfeg.noaa.gov/erddap/info/jplMURSST41/index.html"),
      c("26", "jplMURSST41mday", "sea_ice_fraction", "MUR", "Sea ice fraction", "monthly", "0.01°", "2002-present", "https://upwell.pfeg.noaa.gov/erddap/info/jplMURSST41mday/index.html"),
      c("27", "NOAA_DHW", "CRW_SEAICE", "NOAA Coral Reef Watch", "Sea ice fraction", "daily", "0.05°", "1985-present", "https://upwell.pfeg.noaa.gov/erddap/info/NOAA_DHW/index.html"),
      c("28", "ncdcOisst21Agg_LonPM180", "ice", "NOAA OISST", "Sea ice concentration", "daily", "0.25°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg_LonPM180/index.html"),
      c("29", "nceiPH53sstd1day", "sea_ice_fraction", "Pathfinder", "Sea ice (daytime)", "daily", "0.0417°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/nceiPH53sstd1day/index.html"),
      c("30", "nceiPH53sstn1day", "sea_ice_fraction", "Pathfinder", "Sea ice (nighttime)", "daily", "0.0417°", "1981-present", "https://upwell.pfeg.noaa.gov/erddap/info/nceiPH53sstn1day/index.html"),
      c("31", "erdSW2018chla1day", "chlorophyll", "Orbview-2 SeaWiFS", "Chlorophyll a", "daily", "0.1°", "1997-2010", "https://upwell.pfeg.noaa.gov/erddap/info/erdSW2018chla1day/index.html"),
      c("32", "erdSW2018chla8day", "chlorophyll", "Orbview-2 SeaWiFS", "Chlorophyll a", "8-day ", "0.1°", "1997-2010", "https://upwell.pfeg.noaa.gov/erddap/info/erdSW2018chla8day/index.html"),
      c("33", "erdSW2018chlamday", "chlorophyll", "Orbview-2 SeaWiFS", "Chlorophyll a", "monthly", "0.1°", "1997-2010", "https://upwell.pfeg.noaa.gov/erddap/info/erdSW2018chlamday/index.html"),
      c("34", "erdMH1chla1day", "chlorophyll", "Aqua MODIS", "Chlorophyll a", "daily", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1chla1day/index.html"),
      c("35", "erdMH1chla8day", "chlorophyll", "Aqua MODIS", "Chlorophyll a", "8-day ", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1chla8day/index.html"),
      c("36", "erdMH1chlamday", "chlorophyll", "Aqua MODIS", "Chlorophyll a", "monthly", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1chlamday/index.html"),
      c("37", "erdMH1kd4901day", "k490", "Aqua MODIS", "Diffuse Attenuation K490", "daily", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1kd4901day/index.html"),
      c("38", "erdMH1kd4908day", "k490", "Aqua MODIS", "Diffuse Attenuation K490", "8-day ", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1kd4908day/index.html"),
      c("39", "erdMH1kd490mday", "k490", "Aqua MODIS", "Diffuse Attenuation K490", "monthly", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1kd490mday/index.html"),
      c("40", "erdMH1pp1day", "productivity", "Aqua MODIS", "Net Primary Productivity", "daily", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1pp1day/index.html"),
      c("41", "erdMH1pp3day", "productivity", "Aqua MODIS", "Net Primary Productivity", "3-day", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1pp3day/index.html"),
      c("42", "erdMH1pp8day", "productivity", "Aqua MODIS", "Net Primary Productivity", "8-day ", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1pp8day/index.html"),
      c("43", "erdMH1ppmday", "productivity", "Aqua MODIS", "Net Primary Productivity", "monthly", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1ppmday/index.html"),
      c("44", "erdMPIC1day", "pic", "Aqua MODIS", "Particulate Inorganic Carbon", "daily", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMPIC1day/index.html"),
      c("45", "erdMPIC8day", "pic", "Aqua MODIS", "Particulate Inorganic Carbon", "8-day ", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMPIC8day/index.html"),
      c("46", "erdMPICmday", "pic", "Aqua MODIS", "Particulate Inorganic Carbon", "monthly", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMPICmday/index.html"),
      c("47", "erdMPOC1day", "poc", "Aqua MODIS", "Particulate Organic Carbon", "daily", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMPOC1day/index.html"),
      c("48", "erdMPOC8day", "poc", "Aqua MODIS", "Particulate Organic Carbon", "8-day ", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMPOC8day/index.html"),
      c("49", "erdMPOCmday", "poc", "Aqua MODIS", "Particulate Organic Carbon", "monthly", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMPOCmday/index.html"),
      c("50", "erdMH1par01day", "par", "Aqua MODIS", "Photosynthetically Available Radiation", "daily", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1par01day/index.html"),
      c("51", "erdMH1par08day", "par", "Aqua MODIS", "Photosynthetically Available Radiation", "8-day ", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1par08day/index.html"),
      c("52", "erdMH1par0mday", "par", "Aqua MODIS", "Photosynthetically Available Radiation", "monthly", "0.025°", "2003-present", "https://upwell.pfeg.noaa.gov/erddap/info/erdMH1par0mday/index.html")
    ))
  colnames(sourcedata) <- c("number", "dataset", "var", "satellite", "parameter", "temporal", "spatial", "timespan", "url")
}
  select_data_source <- function(dataset = "none") {

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
}

  myURL.3dim <- function(burl = "https://upwell.pfeg.noaa.gov/erddap/", data_id, ftype = ".nc", data_var, space, time) {
  url1 <- paste(burl, "griddap/", data_id, ftype, "?", data_var, sep = "")
  urltime <- paste("[(", paste(new.time[1], "T00:00:00Z", sep = ""), "):1:(", paste(new.time[2], "T00:00:00Z", sep = ""), ")]", sep = "")
  urllat <- paste("[(", new.space[3], "):1:(", new.space[4], ")]", sep = "")
  urllon <- paste("[(", new.space[1], "):1:(", new.space[2], ")]", sep = "")
  paste(url1, urltime, urllat, urllon, sep = "")
}

  myURL.4dim <- function(burl = "https://upwell.pfeg.noaa.gov/erddap/", data_id, ftype = ".nc", data_var, space, time) {
  url1 <- paste(burl, "griddap/", data_id, ftype, "?", data_var, sep = "")
  urltime <- paste("[(", paste(new.time[1], "T00:00:00Z", sep = ""), "):1:(", paste(new.time[2], "T00:00:00Z", sep = ""), ")]", sep = "")
  urlz <- paste("[(", 0.0, "):1:(", 0.0, ")]", sep = "")
  urllat <- paste("[(", new.space[3], "):1:(", new.space[4], ")]", sep = "")
  urllon <- paste("[(", new.space[1], "):1:(", new.space[2], ")]", sep = "")
  paste(url1, urltime, urlz, urllat, urllon, sep = "")
}

  get_xml_headers <- function(data_id, burl = "https://upwell.pfeg.noaa.gov/erddap/") {
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

  # xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$description

  # axisResolution = as.numeric(xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation$axisDimensionProperties$MD_Dimension$resolution$Measure$text) # 1.0
  # #xml_data$contentInfo$MI_CoverageDescription$dimension$MD_Band$sequenceIdentifier$MemberName$aName$CharacterString # variable
  # #xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation$axisDimensionProperties$MD_Dimension$dimensionSize$Integer
  #
  # # get time series
  # TimePeriodDescription = xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$description
  # TimePeriodBegin = as.Date(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$beginPosition)
  # TimePeriodEnd = as.Date(xml_data$identificationInfo$MD_DataIdentification$extent$EX_Extent$temporalElement$EX_TemporalExtent$extent$TimePeriod$endPosition)
  # TimePeriodInteger = xml_data$spatialRepresentationInfo$MD_GridSpatialRepresentation$axisDimensionProperties$MD_Dimension$dimensionSize$Integer # nsteps
  # TimePeriodStep <- xml_data$identificationInfo$MD_DataIdentification$descriptiveKeywords$MD_Keywords$keyword$CharacterString
  #
}


  select_data <- select_data_source(dataset)
  data_id <- select_data[[1]][1]
  data_var <- select_data[[2]][1]

  ##### get XML
  xml_headers <- get_xml_headers(data_id)
  new.space <- c(xml_headers[[1]], xml_headers[[2]], xml_headers[[3]], xml_headers[[4]])
  new.time <- c(xml_headers[[5]], xml_headers[[6]])

  ##### get URL

  info.erddap <- readLines(paste0("https://upwell.pfeg.noaa.gov/erddap/info/", data_id, "/index.html"))

  ##### get main data

    if (any(grep("zlev", info.erddap)) == TRUE) {
    erddap_url <- myURL.4dim(data_id = data_id, data_var = data_var, ftype = ".csvp", space = new.space, time = new.time) # generate URL
  } else if (any(grep("zlev", info.erddap)) == FALSE) {
    erddap_url <- myURL.3dim(data_id = data_id, data_var = data_var, ftype = ".csvp", space = new.space, time = new.time) # generate URL
  }

  cat((paste0("Downloading ", data_id,"(",data_var, ") between ",new.time[1]," and ",new.time[2],"\n")))
  start_time <- Sys.time()
  file.data <- httr::content( httr::GET(erddap_url, httr::progress()), show_col_types = FALSE)
  end_time <- Sys.time()
  cat(("Download complete\n"))
  cat((paste0("Time taken to download: ", round(end_time - start_time, 2), " seconds\n")))
  cat((paste0("File size: ", round((pryr::object_size(file.data)*0.000001),2), " MB\n")))

  # stars_sst <- read_stars(file.data)
  # z <- y %>% select(sst) %>% adrop

  if (any(grep("zlev", info.erddap)) == TRUE) {

  file.data <- file.data |>
#    as.data.frame() |> # standardise longitude and latitude
    dplyr::rename_with(.col = grep(".*time.*", names(file.data), ignore.case = TRUE), ~"time") |>
    dplyr::rename_with(.col = grep(".*lon.*", names(file.data), ignore.case = TRUE), ~"longitude") |>
    dplyr::rename_with(.col = grep(".*lat.*", names(file.data), ignore.case = TRUE), ~"latitude") |> # standardise longitude and latitude
    dplyr::select(-contains("zlev")) |>
     dplyr::select(time, longitude, latitude, {{ data_var }} := 4)
 } else if (any(grep("zlev", info.erddap)) == FALSE) {


    file.data <- file.data |>
#    dplyr::select(-contains("zlev")) |>
#    as.data.frame() |> # standardise longitude and latitude
    dplyr::rename_with(.col = grep(".*time.*", names(file.data), ignore.case = TRUE), ~"time") |>
    dplyr::rename_with(.col = grep(".*lon.*", names(file.data), ignore.case = TRUE), ~"longitude") |>
    dplyr::rename_with(.col = grep(".*lat.*", names(file.data), ignore.case = TRUE), ~"latitude") |> # standardise longitude and latitude
    dplyr::select(time, longitude, latitude, {{ data_var }} := 4)

  }


  if (save.output == TRUE) {
    base::saveRDS(object=file.data, file=paste0("",filename, ".rds"))
  }

  file.data
}



library(leaflet)
library(mapview)
library(sp)


#coffs <- extract_ocean_data_2(dataset = "erdMH1chlamday[chlorophyll]", space = c(152.4, 153.6, -30.6, -29.2), time = c("2010-01-01", "2018-12-31"), filename = "coffs")
EAC <- extract_ocean_data_2(dataset = "erdMBchlamday[chlorophyll]", space = c(151, 154, -30.6, -22.5), time = c("2015-01-01", "2018-12-31"), filename = "EAC")
#EAC <- extract_ocean_data_2(dataset = "erdMH1kd490mday[k490]", space = c(151, 154, -30.6, -22.5), time = c("2015-01-01", "2018-12-31"), filename = "EAC")


#https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdMBchlamday_LonPM180.csvp?chlorophyll%5B(2012-01-16T12:00:00Z):1:(2018-12-16T12:00:00Z)%5D%5B(0.0):1:(0.0)%5D%5B(-31):1:(-22)%5D%5B(146):1:(154)%5D

collection <-  read.csv("/Users/rof011/Documents/AUS_collections_Turbinaria.csv") %>%
  select(site, latitude, longitude) %>%
  distinct() %>% na.omit() %>%
  filter(latitude < -22)

xy <- collection[,c(2,3)]

collection <- SpatialPointsDataFrame(data=collection, coords = xy, proj4string = CRS('+init=EPSG:4326'))




df <- read.csv("erdMBchlamday_LonPM180_ea3b_f55d_8dc1.csv") %>%
  dplyr::rename(time=1, altitude=2, latitude=3, longitude=4, chlorophyll=5) %>%
  dplyr::group_by(latitude,longitude) %>%
  dplyr::summarise(chlorophyll=mean(chlorophyll, na.rm=TRUE)) %>%
  relocate(latitude=2, longitude=1) %>%
  mutate_at(c('chlorophyll'), ~na_if(., 0))

range(df$latitude)
range(df$longitude)
range(df$chlorophyll, na.rm=TRUE)

df$chlorophyll[df$chlorophyll > 5] <- 10

#ggplot() + theme_bw() +
#  geom_tile(data=df, aes(x=longitude, y=latitude, fill=chlorophyll))

# df.factor <- df %>% group_by(longitude, latitude) %>% summarise(chlorophyll=mean(chlorophyll, na.rm=TRUE)) %>%
#   mutate(latitude=as.factor(latitude)) %>%
#   mutate(longitude=as.factor(longitude))
# levels(df.factor$latitude) <- (seq(min(as.numeric(df$latitude))*-1, max(as.numeric(df$latitude))*-1, along.with=1:length(levels(df.factor$latitude))))*-1
# levels(df.factor$longitude) <- (seq(min(as.numeric(df$longitude))*-1, max(as.numeric(df$longitude))*-1, along.with=1:length(levels(df.factor$longitude))))*-1
# df$latitude <- as.numeric(as.character(df.factor$latitude))
# df$longitude <- as.numeric(as.character(df.factor$longitude))

df.rast <- raster::rasterFromXYZ(df,crs=('+init=EPSG:4326'))


pal <- colorNumeric(palette = "BrBG", domain = df$chlorophyll, na.color = "transparent", reverse = TRUE)

tmp <- leaflet() |>
  addProviderTiles(
    "Esri.WorldImagery",
    group = "Esri.WorldImagery") |>
  addRasterImage(x = df.rast, colors = pal, opacity = 0.6) |>
  addMarkers(lng = collection$longitude, lat = collection$latitude, label=collection$site)#, popup = ~as.character(site), label = ~as.character(site))

mapshot(tmp, url = "EAC.html", selfcontained = FALSE)

