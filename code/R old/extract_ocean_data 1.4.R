


# To do:

# round to whatever value (see SST_HadISST) time = c("2004-09-01", "2004-10-01") BUT 2004-09-16

# are cells boundaries or centers?
# The simplest is to pass a vector with numeric values for a numeric dimension, or character values for a categorical dimension. Parameter cell_midpoints is used to specify whether numeric values refer to the offset (start) of a dimension interval (default), or to the center; the center case is only available for regular dimensions.
# ncatget the summary


# CRS - MODIS = EPSG:4087 (equidistant cylindrical)

extract_ocean_data <- function(dataset = NULL, space = NULL, time = NULL, summarise = "none", filename = NULL, verbose = FALSE) {
  options(dplyr.summarise.inform = FALSE)

  # 1. extract available datasets from thredds catalogues (see oceanwatch catalogue: https://oceanwatch.pfeg.noaa.gov/thredds/catalog/catalog.html)

  ## Use thredds to get the Catalog nodes from oceanwatch (
  # catalog_list <- thredds::CatalogNode$new("https://oceanwatch.pifsc.noaa.gov/thredds/catalog.xml")
  # dataset_list <- catalog_list$get_datasets()

  # 0. catalogue list ----
  if (dataset == "CRW_SST") {
    this_dataset <- "Coral Reef Watch, SST nighttime, 50km, 1-day"
    this_ndims <- 4
    this_correction <- 180
    this_var <- "RWsstn"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data <- -9999999.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/RW/sstn/1day"
  } else if (dataset == "CRW_anomaly") {
    this_dataset <- "Coral Reef Watch, SST anomaly, 50km, 1-day"
    this_ndims <- 4
    this_correction <- 180
    this_var <- "RWtanm"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data <- -9999999.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/RW/tanm/1day"
  } else if (dataset == "CRW_anomaly") {
    this_dataset <- "Coral Reef Watch, HOTSPOTS, 50km, 1-day"
    this_ndims <- 4
    this_correction <- 180
    this_var <- "RWhots"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data <- -9999999.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/RW/hots/1day"
  } else if (dataset == "CRW_anomaly") {
    this_dataset <- "Coral Reef Watch, Degree Heating Weeks, 50km, 1-day"
    this_ndims <- 4
    this_correction <- 180
    this_var <- "RWdhws"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data <- -9999999.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/RW/dhws/1day"
  } else if (dataset == "SST_HadISST") {
    this_dataset <- "HadISST 1.1 monthly average sea surface temperature"
    this_ndims <- 3
    this_correction <- 0
    this_var <- "sst"
    this_origin <- "1870-01-01"
    this_timestep <- "days"
    missing_data <- -1.00000001504747e+30
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/HadleyCenter/HadISST"
  } else if (dataset == "SST_OISST") {
    this_dataset <- "OISST"
    this_ndims <- 3
    this_correction <- 180
    this_var <- "sst"
    this_origin <- "1800-1-1"
    this_timestep <- "days"
    catalog_dataset_url <- "https://www.psl.noaa.gov/thredds/dodsC/Datasets/noaa.oisst.v2.highres"
  } else if (dataset == "Chl_MODIS_monthly") {
    this_dataset <- "Aqua Modis Chlorophyll Concentration monthly,  4.64 km resolution"
    this_ndims <- 3
    this_correction <- 0
    this_var <- "chlor_a"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data <- -32767.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MH1/chla/mday"
  } else {
    stop(print("Incorrect dataset specification, see ?extract_ocean_data for options"))
  }

  # 1. define nc----

  dataset_nc <- ncdf4::nc_open(catalog_dataset_url)
  lonpos <- grep(".*lon.*", dataset_nc$dim) # grep dims for position for fuzzy matching lon
  latpos <- grep(".*lat.*", dataset_nc$dim) # grep dims for position for fuzzy matching lat
  longitude <- names(dataset_nc$dim[lonpos]) # extract names from position
  latitude <- names(dataset_nc$dim[latpos]) # extract names from position

  df_lon <- ncdf4::ncvar_get(dataset_nc, longitude) # Get longitude values
  df_lat <- ncdf4::ncvar_get(dataset_nc, latitude) # Get latitude values

  if (this_timestep == "seconds") {
    df_time_index <- lubridate::date(lubridate::as_datetime(as.Date(ncdf4::ncvar_get(dataset_nc, "time") / 86400, origin = this_origin)))
  } else if (this_timestep == "days") {
    df_time_index <- lubridate::date(lubridate::as_datetime(as.Date(ncdf4::ncvar_get(dataset_nc, "time"), origin = this_origin)))
  } else {
    stop("Incorrect date/time in ncvar_get")
  }

  # get parameters
  lonmin <- space[1] + this_correction
  lonmax <- space[2] + this_correction
  if (lonmin > lonmax) {
    stop("minimum longitude coordinate exceeds the maximum longitude coordinate, check boundary box limits")
  }
  latmin <- space[3]
  latmax <- space[4]
  if (latmin > latmax) {
    stop(print("minimum latitude coordinate exceeds the maximum latitude coordinate, check boundary box limits"))
  }
  timemin <- time[1]
  timemax <- time[2]

  # boundaries of the box and time
  LonIdx <- which(df_lon >= lonmin & df_lon <= lonmax) # get match by position
  LatIdx <- which(df_lat >= latmin & df_lat <= latmax)
  suppressWarnings(timeIdx <- which(df_time_index >= timemin & df_time_index <= timemax))
  if (length(timeIdx) == 0) {
    stop(cat(
      "extract_ocean_data error\n
   No data available within specified date range of ", timemin, "to", timemax, "\n",
      this_dataset, "starts at ", print(paste(min(df_time_index))), " and ends at", print(paste(max(df_time_index))), "\n "
    ))
  }
  # positions of the box and time boundaries (check against input)
  LonIdx.conv <- df_lon[min(LonIdx):max(LonIdx)]
  LatIdx.conv <- df_lat[min(LatIdx):max(LatIdx)]
  timeIdx.conv <- df_time_index[min(timeIdx):max(timeIdx)]
  cellcount <- ceiling(length(LonIdx.conv) * length(LatIdx.conv) * length(timeIdx.conv))

  #  ((cellcount*4)/1000000)
  # 2. extract vars ----
  yesnoanswer <- yesno::yesno2(cat(paste0(
    "The dataset contains ", english::english(cellcount), " grid cells,", "\n",
    "Which is approximately ", ceiling((((length(LonIdx.conv) * length(LatIdx.conv) * length(timeIdx.conv)) * 4) / 1000000)), "Mb in size.", "\n",
    #      "Which is approximately ", ceiling(round(( ((length(LonIdx.conv) * length(LatIdx.conv) * length(timeIdx.conv))*4)/1000000) , 1)), "Mb in size.", "\n",
    "Are you sure you want to proceed with the download?"
  )), yes = "Yes")

  if (yesnoanswer == TRUE) {
    #  print("Download started")
    print(paste0("Downloading ", this_dataset))
    print(paste0("Date range = ", time[1], " to ", time[2]))
    print(paste0("Longitude = ", lonmin - this_correction, " to ", lonmax - this_correction)) # , ")")
    print(paste0("Latitude  = ", latmin, " to ", latmax)) # , ")")

    start_time <- Sys.time()

    if (this_ndims == 3) {
      dataset_var <- (ncdf4::ncvar_get(dataset_nc,
        varid = (this_var),
        start = c(min(LonIdx), min(LatIdx), min(timeIdx)),
        count = c(length(LonIdx), length(LatIdx), length(timeIdx)),
        verbose = FALSE, collapse_degen = FALSE
      ))
    } else if (this_ndims == 4) { # X,Y,Z,T
      dataset_var <- (ncdf4::ncvar_get(dataset_nc,
        varid = (this_var),
        start = c(min(LonIdx), min(LatIdx), 1, min(timeIdx)),
        #      count = c(20, 20,-1, 1),
        count = c(length(LonIdx), length(LatIdx), -1, length(timeIdx)),
        verbose = FALSE, collapse_degen = FALSE
      ))

      dataset_var <- abind::adrop(dataset_var[, , 1, , drop = FALSE], drop = 3)
    } else {
    }

    print(paste0("Download complete"))
    end_time <- Sys.time()
    print(paste0("Calculating annual summaries = ", summarise))
  } else {
    stop("Dataset not downloaded")
  }

  start_time_2 <- Sys.time()

  # set dimnames from nc headers
  dimnames(dataset_var)[[1]] <- LonIdx.conv
  dimnames(dataset_var)[[2]] <- LatIdx.conv
  dimnames(dataset_var)[[3]] <- as.character(timeIdx.conv)

  # create data.frame
  output.df <- as.data.frame.table(dataset_var) |>
    dplyr::rename_with(.col = 1, ~"longitude") |>
    dplyr::rename_with(.col = 2, ~"latitude") |>
    dplyr::rename_with(.col = 3, ~"date") |>
    dplyr::rename_with(.col = 4, ~this_var) |>
    dplyr::mutate(date = as.Date(date)) |>
    dplyr::filter_at(4, dplyr::all_vars(. > missing_data))

  # create data.table
  # output.df <-  as.data.frame.table(dataset_var)
  # output.dt <- data.table::as.data.table(output.df)
  # output.dt[output.dt==missing_data] <- NA
  # data.table::setnames(output.dt, c("longitude", "latitude", "date", this_var))
  # output.dt[, date := data.table::as.IDate(date)]

  ### summarise data by year:
  if (summarise == "mean") {
    output.df.final <- output.df |>
      dplyr::mutate(date = lubridate::year(lubridate::floor_date(date, "year"))) |>
      dplyr::group_by(longitude, latitude, date) |>
      dplyr::summarise(across(all_of(this_var), .fns = mean)) |>
      dplyr::ungroup() |>
      as.data.frame() |>
      dplyr::mutate(longitude = as.numeric(as.character(longitude))) |>
      dplyr::mutate(latitude = as.numeric(as.character(latitude)))
  } else if (summarise == "max") {
    output.df.final <- output.df |>
      dplyr::mutate(date = lubridate::year(lubridate::floor_date(date, "year"))) |>
      dplyr::group_by(longitude, latitude, date) |>
      dplyr::summarise(across(this_var, .fns = max))
    dplyr::ungroup() |>
      as.data.frame() |>
      dplyr::mutate(longitude = as.numeric(as.character(longitude))) |>
      dplyr::mutate(latitude = as.numeric(as.character(latitude)))
  } else if (summarise == "anomaly") {
    # Calculate average across time series
    options(dplyr.summarise.inform = FALSE)
    output.df.avg <- output.df |>
      dplyr::select(-date) |>
      dplyr::rename("tempvar" = this_var) |>
      tidyr::unite(lonlat, c("longitude", "latitude"), remove = FALSE) |>
      dplyr::group_by(longitude, latitude, lonlat) |>
      dplyr::summarise(across(tempvar, .fns = mean))
    output.df.2 <- output.df |>
      tidyr::unite(lonlat, c("longitude", "latitude"), remove = FALSE)
    output.df.2 <- left_join(output.df.2, output.df.avg) |>
      dplyr::select(-lonlat) #|>
    # dplyr::mutate(date=lubridate::year(lubridate::floor_date(date, 'year')))
    output.df.2$sst_anomaly <- output.df.2[, this_var] - output.df.2[, "tempvar"]
    output.df.final <- dplyr::select(output.df.2, -sst, -tempvar)
    output.df.final <- output.df.final |>
      dplyr::mutate(date = lubridate::year(lubridate::floor_date(date, "year"))) |>
      dplyr::group_by(longitude, latitude, date) |>
      dplyr::summarise(across(sst_anomaly, .fns = mean)) |>
      dplyr::ungroup() |>
      as.data.frame() |>
      dplyr::mutate(longitude = as.numeric(as.character(longitude))) |>
      dplyr::mutate(latitude = as.numeric(as.character(latitude)))
  } else if (summarise == "none") {
    output.df.final <- output.df |>
      dplyr::mutate(date = lubridate::ymd(date)) |>
      dplyr::mutate(longitude = as.numeric(as.character(longitude))) |>
      dplyr::mutate(latitude = as.numeric(as.character(latitude)))
  } else {
    (stop(print("Incorrect summary, see ?extract_ocean_data for a list of options in arguments")))
  }

  ### recenter any datasets that are scaled 0-360
  if (max(as.numeric(output.df.final$longitude), na.rm = TRUE) > 180) {
    east <- output.df.final |> filter(as.numeric(longitude) < 180)
    west <- output.df.final |>
      filter(as.numeric(longitude) > 180) |>
      mutate(longitude = longitude - 360)

    output.df.final <- rbind(west, east)
  } else {
    output.df.final
  }

  ### make metadata?
  metadata <- data.frame(
    vars = c("datasource", "time", "space", "downloaded_on"),
    vals = c(catalog_dataset_url, paste(timemin, timemax, sep = " to "), paste(lonmin - this_correction, lonmax - this_correction, latmin, latmax, sep = ":"), as.character(as.Date(Sys.Date())))
  )

  output.df.final.meta <- dplyr::bind_rows(output.df.final, metadata)


  ### save if filename present

  # use fwrite instead of write.csv for data.table
  if (is.null(filename)) {
    output.df.final.meta
  } else if (grepl("csv", filename) == TRUE) {
    write.csv(output.df.final.meta, filename)
    output.df.final.meta
  } else if (grepl("rds", filename) == TRUE) {
    saveRDS(output.df.final.meta, filename)
    output.df.final.meta
  }
  end_time_2 <- Sys.time()

  print(paste0("Time taken = ", (round(as.numeric(end_time - start_time), 1) + round(as.numeric(end_time - start_time), 1)), " seconds (downloading = ", round(as.numeric(end_time - start_time), 2), "s, extracting = ", round(as.numeric(end_time_2 - start_time_2), 2), "s )"))
  print(paste0("Output file size = ", ceiling(file.info(filename)$size / 1000000), " Mb, (", (dim(dataset_var)[1] * dim(dataset_var)[2] * dim(dataset_var)[3]), " grid cells, ", length(timeIdx.conv), " layers)"))

  # output.df.final
}
