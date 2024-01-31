
  ### MODIS ###
  if (dataset == "PAR_MODIS_Monthly") {
    this_dataset <- "Photosynthetically Available Radiation (PAR), Aqua MODIS - Monthly, 2002-present. v.2018.0"
    this_correction = 180
    this_var <- "par"
    this_origin <- NULL
    this_timestep <- "days" # convert seconds to days if needed
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[15]]$url)
  } else if (dataset == "PAR_MODIS_8day") {
    this_dataset <- "Photosynthetically Available Radiation (PAR), Aqua MODIS - 8-Day, 2002-present. v.2018.0"
    this_correction=180
    this_var <- "par"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[16]]$url)
  } else if (dataset == "PAR_MODIS_Daily") {
    this_dataset <-"Photosynthetically Available Radiation (PAR), Aqua MODIS - Daily, 2002-present. v.2018.0"
    this_correction=180
    this_var <- "par"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[17]]$url)
  } else if (dataset == "Chl_MODIS_monthly") {
    this_dataset <- "Chlorophyll a Concentration, Aqua MODIS - Monthly, 2002-present. v.2018.0"
    this_correction=180
    this_var <- "chlor_a"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, (dataset_list[[4]])$url)
  } else if (dataset == "Chl_MODIS_8day") {
    this_dataset <-"Chlorophyll a Concentration, Aqua MODIS - 8-day, 2002-present. v.2018.0"
    this_correction=180
    this_var <- "chlor_a"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[5]]$url)
  } else if (dataset == "Chl_MODIS_Daily") {
    this_dataset <- "Chlorophyll a Concentration, Aqua MODIS - Daily, 2002-present. v.2018.0"
    this_correction=180
    this_var <- "chlor_a"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[6]]$url)
  } else if (dataset == "Kd490_MODIS_monthly") {
    this_dataset <- "Kd490, Aqua MODIS - Monthly, 2002-present. v.2018.0"
    this_correction=180
    this_var <- "Kd_490"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[21]]$url)
  } else if (dataset == "Kd490_MODIS_8day") {
    this_dataset <- "Kd490, Aqua MODIS - 8-Day, 2002-present. v.2018.0"
    this_correction=180
    this_var <- "Kd_490"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[22]]$url)
  } else if (dataset == "Kd490_MODIS_Daily") {
    this_dataset <- "Kd490, Aqua MODIS - Daily, 2002-present. v.2018.0"
    this_correction=180
    this_var <- "Kd_490"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[23]]$url)

  # NOAA
  } else if (dataset == "SST_NOAA_Blended_monthly") {
    this_dataset <- "Sea Surface Temperature, NOAA geopolar blended - Monthly, 2002-Present (2017 Reanalysis)"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[37]]$url)
  } else if (dataset == "SST_NOAA_Blended_8Day") {
    this_dataset <- "Sea Surface Temperature, NOAA geopolar blended - 8-day, 2002-Present (2017 Reanalysis)"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[38]]$url)
  } else if (dataset == "SST_NOAA_Blended_Daily") {
    this_dataset <- "Sea Surface Temperature, NOAA geopolar blended - Daily, 2002-Present (2017 Reanalysis)"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[39]]$url)

### NOAA ###
  } else if (dataset == "SST_NOAA_CRW_Hotspot") {
    this_dataset="NOAA Coral Reef Watch Daily Global 5-km Satellite sea surface temperature anomaly (Celsius)"
    this_correction=0
    this_var <- "CRW_HOTSPOT"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds" # convert seconds to days
    catalog_dataset_url <- "https://pae-paha.pacioos.hawaii.edu/thredds/dodsC/dhw_5km"
  } else if (dataset == "SST_NOAA_CRW_anomaly") {
    this_dataset="NOAA Coral Reef Watch Daily Global 5-km Satellite sea surface temperature anomaly (Celsius)"
    this_correction=0
    this_var <- "CRW_SSTANOMALY"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds" # convert seconds to days
    catalog_dataset_url <- "https://pae-paha.pacioos.hawaii.edu/thredds/dodsC/dhw_5km"
  } else if (dataset == "SST_NOAA_CRW_alert") {
    this_dataset=" 	NOAA Coral Reef Watch Daily Global 5-km Satellite bleaching alert area"
    this_correction=0
    this_var <- "CRW_BAA"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds" # convert seconds to days
    catalog_dataset_url <- "https://pae-paha.pacioos.hawaii.edu/thredds/dodsC/dhw_5km"
  } else if (dataset == "SST_NOAA_CRW_7day_alert") {
    this_dataset="NOAA Coral Reef Watch Daily Global 5-km Satellite bleaching alert area 7-day maximum composite"
    this_correction=0
    this_var <- "CRW_BAA_7D_MAX"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds" # convert seconds to days
    catalog_dataset_url <- "https://pae-paha.pacioos.hawaii.edu/thredds/dodsC/dhw_5km"
  } else if (dataset == "SST_NOAA_CRW_seaice") {
    this_dataset="NOAA Coral Reef Watch Daily Global 5-km Satellite sea ice fraction"
    this_correction=0
    this_var <- "CRW_SEAICE"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds" # convert seconds to days
    catalog_dataset_url <- "https://pae-paha.pacioos.hawaii.edu/thredds/dodsC/dhw_5km"
  } else if (dataset == "SST_NOAA_CRW_CoralTemp") {
    this_dataset="NOAA Coral Reef Watch Daily Global 5-km Satellite nighttime sea surface temperature"
    this_correction=0
    this_var <- "CRW_SST"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds" # convert seconds to days
    catalog_dataset_url <- "https://pae-paha.pacioos.hawaii.edu/thredds/dodsC/dhw_5km"
  } else if (dataset == "SST_NOAA_DHW") {
    this_dataset="NOAA Coral Reef Watch Daily Global 5-km Satellite Coral Bleaching Heat Stress Degree Heating Week"
    this_correction=0
    this_var <- "CRW_DHW"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds" # convert seconds to days
    catalog_dataset_url <- "https://pae-paha.pacioos.hawaii.edu/thredds/dodsC/dhw_5km"


     } else if (dataset == "CRW_SST") {
    this_dataset="Coral Reef Watch, SST nighttime, 50km, 1-day"
    this_correction=-180
    this_var <- "RWsstn"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data = -9999999.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/RW/sstn/1day"
