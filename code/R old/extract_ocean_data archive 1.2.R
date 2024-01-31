
# round to whatever value (see SST_HadISST) time = c("2004-09-01", "2004-10-01") BUT 2004-09-16
# add a get resolution count per yr or similr

temp <- extract_ocean_data(dataset = "SST_HadISST",
  space = c(142, 154, -24, -6),
  time = c("1998-01-01", "2020-01-01"),
  summarise="mean",
  filename="abcd.csv")

extract_ocean_data <- function(dataset = NULL, space = NULL, time = NULL, summarise="none", filename = NULL) {

  ## Use thredds to get the DatasetNode (
  #if (exists("dataset_list")) {
  #  } else {
    catalog_list <- thredds::CatalogNode$new("https://oceanwatch.pifsc.noaa.gov/thredds/catalog.xml")
    dataset_list <- catalog_list$get_datasets()
  #  }

  ### MODIS ###
  if (dataset == "PAR_MODIS_Monthly") {
    this_dataset <- "Photosynthetically Available Radiation (PAR), Aqua MODIS - Monthly, 2002-present. v.2018.0"
    this_correction = 0
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
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[37]]$url)
  } else if (dataset == "SST_NOAA_Blended_8Day") {
    this_dataset <- "Sea Surface Temperature, NOAA geopolar blended - 8-day, 2002-Present (2017 Reanalysis)"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, dataset_list[[38]]$url)
  } else if (dataset == "SST_NOAA_Blended_Daily") {
    this_dataset <- "Sea Surface Temperature, NOAA geopolar blended - Daily, 2002-Present (2017 Reanalysis)"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
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
  } else if (dataset == "SST_HadISST") {
    this_dataset="Hadley Centre Sea Surface Temperature data set (HadISST)"
    this_correction=0
    this_var <- "sst"
    this_origin <- "1870-01-01"
    this_timestep <- "days"
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/HadleyCenter/HadISST"
  } else if (dataset == "SST_OISST") { # still not working
    this_dataset="OISST"
    this_correction=180
    this_var <- "sst"
    this_origin <- "1800-1-1"
    this_timestep <- "days"
    catalog_dataset_url <- "https://www.psl.noaa.gov/thredds/dodsC/Datasets/noaa.oisst.v2.highres"

  # } else if (dataset == "SSS_Global_SMOS") { # still not working
  #   this_dataset="Global SMOS Level 4 Sea Surface Salinity file"
  #   this_correction=180
  #   this_var <- "SSS"
  #   this_origin <- "2011-01-01"
  #   this_timestep <- "seconds"
  #   catalog_dataset_url <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC/smos/daily"


  # Add later
  # FOUR dims in PP
  # } else if (dataset == "PP_MODIS_Daily") {
  #   this_dataset="Primary Productivity, daily NASA Aqua MODIS L3SMI, Global, EXPERIMENTAL"
  #   this_correction=0
  #   this_var <- "MHPProd"
  #   this_origin <- "1970-01-01"
  #   this_timestep <- "seconds"
  #   catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/PPMH/1day"
  # } else if (dataset == "PP_MODIS_3Day") {
  #   this_dataset=" Primary Productivity, 3-day, NASA Aqua MODIS L3SMI, Global, EXPERIMENTAL"
  #   this_correction=0
  #   this_var <- "MHPProd"
  #   this_origin <- "1970-01-01"
  #   this_timestep <- "seconds"
  #   catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/PPMH/3day"

  } else {
    print("Incorrect dataset specification, see ?extract_ocean_data for options")
  }


  ## oceanwatch catalogue: https://oceanwatch.pfeg.noaa.gov/thredds/catalog/catalog.html
  ## THREDDS OPeNDAP file path

  # CRS - MODIS = EPSG:4087 (equidistant cylindrical)

  dataset_nc <- ncdf4::nc_open(catalog_dataset_url)
 # df_crs <- ncdf4::ncvar_get(dataset_nc, "crs") # Get crs, see https://www.e-education.psu.edu/geog862/node/1801
  # fuzzy match lon/lat from nc files, make consistent/fixed later
  lonpos <- grep(".*lon.*", dataset_nc$dim) # grep dims for position for fuzzy matching lon
  latpos <- grep(".*lat.*", dataset_nc$dim) # grep dims for position for fuzzy matching lat
  longitude <- names(dataset_nc$dim[lonpos]) # extract names from position
  latitude <- names(dataset_nc$dim[latpos])  # extract names from position

  df_lon <- ncdf4::ncvar_get(dataset_nc, longitude) # Get longitude values
  df_lat <- ncdf4::ncvar_get(dataset_nc, latitude) # Get latitude values
  if (this_timestep == "seconds") {
    df_time_index <- lubridate::date(lubridate::as_datetime(as.Date(ncdf4::ncvar_get(dataset_nc, "time")/86400, origin = this_origin)))
  } else {
   df_time_index <- lubridate::date(lubridate::as_datetime(as.Date(ncdf4::ncvar_get(dataset_nc, "time"), origin = this_origin)))
  }

  # get parameters
  lonmin <- space[1] + this_correction ; lonmax <- space[2] + this_correction
  latmin <- space[3] ; latmax <- space[4]
  timemin <- time[1] ; timemax <- time[2]

  # boundaries of the box and time
  LonIdx <- which(df_lon >= lonmin & df_lon <= lonmax) # get match by position
  LatIdx <- which(df_lat >= latmin & df_lat <= latmax)
  timeIdx <- which(df_time_index >= timemin & df_time_index <= timemax)

  # positions of the box and time boundaries (check against input)
  LonIdx.conv <- df_lon[min(LonIdx):max(LonIdx)]
  LatIdx.conv <- df_lat[min(LatIdx):max(LatIdx)]
  timeIdx.conv <- df_time_index[min(timeIdx):max(timeIdx)]

  # start and count parameters for ncvar_get
  #c(min(LonIdx), min(LatIdx), min(timeIdx)) # start positions
  #c(length(LonIdx), length(LatIdx), length(timeIdx)) # count

  # names(dataset_nc$dim) # names dataset - check dim vectors for unused

  # # create a grid for ncvar_get to work with
  # count.loop <- expand.grid( # use expand.grid here to generate sequences bound by start positions and end counts
  #   x = seq(min(LonIdx), min(LonIdx) + (length(LonIdx) - 1)),
  #   y = seq(min(LatIdx), min(LatIdx) + (length(LatIdx) - 1)),
  #   z = seq(min(timeIdx), min(timeIdx) + (length(timeIdx) - 1))
  # ) |>
  #   dplyr::mutate( # extract exact values from positions in xyz cols
  #     lon = df_lon[x],
  #     lat = df_lat[y],
  #     date = df_time_index[z]
  #   ) |>
  #   dplyr::select(lon, lat, date)

  names(dataset_nc$dim)

  # if (askYesNo(paste0(
  #   "There are ", length(LonIdx)*length(LatIdx)*length(timeIdx), " gridcells ", "(",
  #   length(LonIdx), "*", length(LatIdx), "*", length(timeIdx),
  #   " array) - are you sure you want to download?"
  # )) == TRUE) {
     start_time <- Sys.time()

    dataset_var <- (ncdf4::ncvar_get(dataset_nc,
      varid = (this_var),
      start = c(min(LonIdx), min(LatIdx), min(timeIdx)),
      count = c(length(LonIdx), length(LatIdx), length(timeIdx)),
      verbose = FALSE))

        arraydims <- length(dim(dataset_var)) # hack to ammend time dimensions if single timepoint
        if(arraydims==2){
          newdim <- array(NA, dim=c(nrow(dataset_var), ncol(dataset_var), 1))
          newdim[,,1] <- dataset_var
          dataset_var <- newdim
        } else {

        }

    print(paste0("Dataset downloaded: ", this_dataset))
    print(paste0("Date range = ",time[1], " to ",time[2]))
    end_time <- Sys.time()
    print(paste0("Completed in ", round(as.numeric(end_time - start_time), 2), " seconds"))
  # } else {
  #   print("netCDF not downloaded")
  # }

# terrarise the array
dimnames(dataset_var)[[1]] <- round(LonIdx.conv,3)
dimnames(dataset_var)[[2]] <- round(LatIdx.conv,3)
dimnames(dataset_var)[[3]] <- as.character(timeIdx.conv)

tmp <- terra::rast(dataset_var)

output.df <-  as.data.frame.table(dataset_var) |>
  dplyr::rename_with(.col = 1, ~"longitude") |>
  dplyr::rename_with(.col = 2, ~"latitude") |>
  dplyr::rename_with(.col = 3, ~"date") |>
  dplyr::rename_with(.col = 4, ~this_var) |>
  dplyr::mutate(date=as.Date(date))

  ### average if selected
options(dplyr.summarise.inform = FALSE)
  if (summarise == "mean") {
  output.df.final <- output.df |>
     dplyr::group_by(longitude,latitude, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = mean)) |>
     as.data.frame()
  } else if (summarise == "mode") {
  output.df.final <- output.df |>
     dplyr::group_by(longitude,latitude, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = mode)) |>
     as.data.frame()
  } else if (summarise == "median") {
  output.df.final <- output.df |>
     dplyr::group_by(longitude,latitude, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = median)) |>
     as.data.frame()
  } else if (summarise == "min") {
  output.df.final <- output.df |>
     dplyr::group_by(longitude,latitude, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = min)) |>
     as.data.frame()
  } else if (summarise == "max") {
  output.df.final <- output.df |>
     dplyr::group_by(longitude,latitude, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = max)) |>
     as.data.frame()
  } else if (summarise == "none") {
    output.df.final <- output.df
  } else {
    output.df.final <- output.df
  }


  ### save if filename present
  if (is.null(filename)) {
    output.df.final
  } else if (grepl("csv", filename) == TRUE) {
    write.csv(output.df.final, filename)
    output.df.final
  } else if (grepl("rds", filename) == TRUE) {
    saveRDS(output.df.final, filename)
    output.df.final
  } else {
    output.df.final
    }
}
