

# To do:
# are cells boundaries or centers?
# The simplest is to pass a vector with numeric values for a numeric dimension, or character values for a categorical dimension. Parameter cell_midpoints is used to specify whether numeric values refer to the offset (start) of a dimension interval (default), or to the center; the center case is only available for regular dimensions.
# ncatget the summary
# CRS - MODIS = EPSG:4087 (equidistant cylindrical)

extract_ocean_data <- function(dataset = NULL, space = NULL, time = NULL, summarise = "none", filename = NULL, verbose = FALSE) {
  options(dplyr.summarise.inform = FALSE)

  # 0. catalogue list ----
  # The first section defines the parameters for each dataset and the url to
  # download and extract the data from THREDDS servers.
  # https://oceanwatch.pfeg.noaa.gov/thredds/catalog/catalog.html
  # ^^^ list of potential datasets via the oceanwatch catalogue
  # A more sophisticated approach would be to extract these parameters direct
  # from the netCDF files using ncdf4::ncvar_get and ncdf4::ncat_get but the
  # lack of consistency in global variables among datasets makes this challenging

  ocean_watch <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/"
  psl <- "https://www.psl.noaa.gov/thredds/dodsC/" # Datasets/noaa.oisst.v2.highres

  nc_varnames <- data.frame(
    nc_dataset = c("CRW_SST", "CRW_anomaly", "CRW_hotspots", "CRW_dhw", "SST_HadISST", "Chl_MODIS_monthly", "PIC_MODIS_monthly"),
    nc_var = c("RWsstn", "RWtanm", "RWhots", "RWdhws", "sst", "chlor_a", "pic"),
    nc_url = c(paste0(ocean_watch, "satellite/RW/sstn/1day"), paste0(ocean_watch, "satellite/RW/tanm/1day"), paste0(ocean_watch, "satellite/RW/hots/1day"), paste0(ocean_watch, "satellite/RW/dhws/1day"), paste0(ocean_watch, "HadleyCenter/HadISST"), paste0(ocean_watch, "satellite/MH1/chla/mday"), paste0(ocean_watch, "satellite/MPIC/mday"))
  )

  this_dataset <- as.character(dplyr::filter(nc_varnames, nc_dataset == dataset)[1])
  this_var <- as.character(dplyr::filter(nc_varnames, nc_dataset == dataset)[2])
  this_url <- as.character(dplyr::filter(nc_varnames, nc_dataset == dataset)[3])
  this_dataset <- as.character(dplyr::filter(nc_varnames, nc_dataset == dataset)[1])
  # this_ndims <- as.numeric(as.character(dplyr::filter(nc_varnames, nc_dataset == dataset)[4]))

  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  # 1. Extract nc parameters ----
  # open the dataset using nc_open and grep the dims for "longitude" and
  # "latitude" in dimnames. The lack of consistency in netCDF files to the point
  # where different datasets have different dimnames (e.g. "lon", "Lon",
  # "longitude", "latitude) hence the need to pattern match insensitive to case.
  # store the time steps in lubridate format depending on whether the dataset is
  # minutes or seconds. Grep this from dataset_nc$dim$time$units

  dataset_nc <- ncdf4::nc_open(this_url) # open netcdf at url
  lonpos <- grep(".*lon.*", dataset_nc$dim, ignore.case = TRUE) # grep dims for position for fuzzy matching lon
  latpos <- grep(".*lat.*", dataset_nc$dim, ignore.case = TRUE) # grep dims for position for fuzzy matching lat
  longitude <- names(dataset_nc$dim[lonpos]) # extract names from position
  latitude <- names(dataset_nc$dim[latpos]) # extract names from position

  df_lon <- ncdf4::ncvar_get(dataset_nc, longitude) # Get longitude values
  df_lat <- ncdf4::ncvar_get(dataset_nc, latitude) # Get latitude values

  this_origin <- as.Date(sub(" .*", "", sub("^\\S*\\s+", "", sub("^\\S*\\s+", "", gsub("\\T.*", "", dataset_nc$dim$time$units))))) # grep date from dim$time formats
  this_ndims <- sum(lapply(dataset_nc$dim, function(x) x$create_dimvar) == TRUE) # get number of dimensions
  this_correction <- ifelse(max(df_lon) > 180, 180, 0) # add correcton for 0-360 longitude datasets

    if (grepl(".*seconds.*", as.character(dataset_nc$dim$time$units))) {
    df_time_index <- lubridate::date(lubridate::as_datetime(as.Date(ncdf4::ncvar_get(dataset_nc, "time") / 86400, origin = this_origin)))
  } else if (grepl(".*day.*", as.character(dataset_nc$dim$time$units))) {
    df_time_index <- lubridate::date(lubridate::as_datetime(as.Date(ncdf4::ncvar_get(dataset_nc, "time"), origin = this_origin)))
  } else {
    stop("Incorrect date/time in ncvar_get")
  }



  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  # 2. define input parameters ----
  # Spatial data can be defined either as a list of sites with point coordinates,
  # or as a spatial extent defined by boundaries set with lon/lat.
  #  i) spatial datapoints
  #    Looks for a matching input file (e.g. sites.xlsx, sites.xls, sites.csv)
  #    The function will detect and import the data correctly as long as the
  #    filename is correctly specified. As a minimum the file needs two columns
  #    containing "lon" and "lat" (the function will pattern detect from the
  #    colnames for flexibility, e.g. longitude,Longitude,lon,Lon etc)

  #  ii) defining a spatial extent (xmin, xmax, ymin, ymax)
  #
  #    Spatial extent requires 4 numbers (xmin, xmax, ymin, ymax)
  #     e.g. space(154,155,-10,8)
  #    The function will display an error if min > max for either lon or lat
  # .   The function will correct according to lon positions similar to terra::rotate
  #
  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ### a. spatial points ----


  # if (is.character(space) == TRUE) {
  # start_download_time <- Sys.time()
  # if (grepl(".*xlsx.*", space) == TRUE) {
  #   coordlist <- readxl::read_excel(space)
  # } else if (grepl(".*xlsx.*", space) == TRUE) {
  #   coordlist <- readxl::read_excel(space)
  # } else if (grepl(".*xls.*", space) == TRUE) {
  #   coordlist <- read.csv(space)
  # } else {
  #   (stop(print("coordinates file must be in one of the following formats: .xlsx, .xls, .csv")))
  # }
  #
  # coordlist <- coordlist |>
  #   dplyr::rename_with(.col = grep(".*lon.*", names(coordlist), ignore.case = TRUE), ~ "longitude") |>
  #   dplyr::rename_with(.col = grep(".*lat.*", names(coordlist), ignore.case = TRUE), ~"latitude")
  #
  # suppressWarnings(timeIdx <- which(df_time_index >= time[1] & df_time_index <= time[2]))
  # if (length(timeIdx) == 0) {
  #   stop(print("extract_ocean_data error\n No data available within specified date range of ", time[1], "to", time[2], "\n", this_dataset, "starts at ", print(paste(min(df_time_index))), " and ends at", print(paste(max(df_time_index))), "\n "))
  # }
  # timeIdx.conv <- df_time_index[min(timeIdx):max(timeIdx)]
  # start_time <- Sys.time()
  # if (this_ndims == 3) {
  #   spatial.pts.df <- foreach(i = 1:nrow(coordlist), .combine = "rbind") %do% {
  #     pts_nc <- ncvar_get(dataset_nc,
  #       varid = this_var,
  #       verbose = FALSE,collapse_degen=FALSE,
  #       start = c(findInterval(coordlist$longitude[i], df_lon), findInterval(coordlist$latitude[i], sort(df_lat)), min(timeIdx)),
  #       count = c(1, 1, length(timeIdx))
  #     )
  #
  #     pts_df <- data.frame(
  #       date = (as.Date(timeIdx.conv)),
  #       year = as.numeric(lubridate::year(as.character(as.Date(timeIdx.conv))), tz = "UTC"),
  #       month = as.numeric(lubridate::month(as.character(as.Date(timeIdx.conv))), tz = "UTC"),
  #       longitude = coordlist$longitude[i],
  #       longitude.cell = paste0("(", df_lon[findInterval(coordlist$longitude[i], df_lon)], ", ", df_lon[findInterval(coordlist$longitude[i], df_lon) + 1], ")"),
  #       latitude = coordlist$latitude[i],
  #       latitude.cell = paste0("(", df_lat[findInterval(coordlist$latitude[i], sort(df_lat))], ", ", df_lat[findInterval(coordlist$latitude[i], sort(df_lat)) + 1], ")"),
  #       pts_nc = pts_nc
  #     )
  #
  #     dplyr::rename_with(pts_df, .col = 8, ~this_var)
  #   }
  #   output.df <- spatial.pts.df
  # } else if (this_ndims == 4) { # X,Y,Z,
  #   spatial.pts.df <- foreach(i = 1:nrow(coordlist), .combine = "rbind") %do% {
  #     pts_nc <- ncvar_get(dataset_nc,
  #       varid = this_var,
  #       verbose = FALSE, collapse_degen = TRUE,
  #       start = c(findInterval(coordlist$longitude[i], df_lon), findInterval(coordlist$latitude[i], sort(df_lat)), 1, min(timeIdx)),
  #       count = c(1, 1, -1, length(timeIdx))
  #     )
  #
  #     pts_df <- data.frame(
  #       date = (as.Date(timeIdx.conv)),
  #       year = as.numeric(lubridate::year(as.character(as.Date(timeIdx.conv))), tz = "UTC"),
  #       month = as.numeric(lubridate::month(as.character(as.Date(timeIdx.conv))), tz = "UTC"),
  #       longitude = coordlist$longitude[i],
  #       longitude.cell = paste0("(", df_lon[findInterval(coordlist$longitude[i], df_lon)], ", ", df_lon[findInterval(coordlist$longitude[i], df_lon) + 1], ")"),
  #       latitude = coordlist$latitude[i],
  #       latitude.cell = paste0("(", df_lat[findInterval(coordlist$latitude[i], df_lat)], ", ", df_lat[findInterval(coordlist$latitude[i], df_lat) + 1], ")"),
  #       pts_nc = pts_nc
  #     )
  #
  #     dplyr::rename_with(pts_df, .col = 8, ~this_var)
  #   }
  #   output.df <- spatial.pts.df
  # }
  # end_download_time <- Sys.time()
  #  } else if (is.numeric(space) == TRUE) {

  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ### b. spatial extent ----

  shift_longitude <- function(longitude) { # rotate function
    ind <- which(longitude < 0)
    longitude[ind] <- longitude[ind] + 360
    return(longitude)
  }

  # if .nc is in 0-360 longitude, convert input coords from -180-180
  # to 0-360 to match using shift_longitude function

  # check if current nc is 0 - 360 or -180 to 180
  #    longcoord <- if((max(df_lon)>180.005)==TRUE){"lon_0_360"} else if((max(df_lon)<179.005)==TRUE){"lon_-180_to_180"}
  start_download_time <- Sys.time()

  if ((max(df_lon) >= 180) == TRUE) { # as center of cell should never be absolute x,y
    lonmin <- shift_longitude(space[1] + 180)
    lonmax <- shift_longitude(space[2] + 180)
    cat("Longitude of coordinates shifted from -180 to 180 to 0 to 360 to match netCDF\n")
  } else {
    lonmin <- space[1]
    lonmax <- space[2]
    cat("Longitude matches netCDF (-180 to 180) to 0 to 360 to match netCDF\n")
  }
  latmin <- space[3]
  latmax <- space[4]
  timemin <- time[1]
  timemax <- time[2]

  if (lonmin > lonmax) {
    stop("minimum longitude coordinate exceeds the maximum longitude coordinate, check boundary box limits")
  }
  if (latmin > latmax) {
    stop(print("minimum latitude coordinate exceeds the maximum latitude coordinate, check boundary box limits"))
  }

  # boundaries of the box and time
  LonIdx <- which(df_lon >= lonmin & df_lon <= lonmax) # get match by position
  LatIdx <- which(df_lat >= latmin & df_lat <= latmax)
  timeIdx <- which(df_time_index >= timemin & df_time_index <= timemax)
  if (length(timeIdx) == 0) {
    stop(cat(paste0("extract_ocean_data error\nNo data available within specified date range of ", timemin, " to ", timemax, "\nDates range for ", this_dataset, " starts at ", print(paste(min(df_time_index))), " and ends at ", print(paste(max(df_time_index))), "\n ")))
  }

  # positions of the box and time boundaries (check against input)
  LonIdx.conv <- df_lon[min(LonIdx):max(LonIdx)]
  LatIdx.conv <- df_lat[min(LatIdx):max(LatIdx)]
  timeIdx.conv <- df_time_index[min(timeIdx):max(timeIdx)]
  cellcount <- ceiling(length(LonIdx.conv) * length(LatIdx.conv) * length(timeIdx.conv)) #  ((cellcount*4)/1000000)
  bytecount <- ceiling((cellcount * 4) / 1000000)

  if (bytecount > 70) {
    yesnoanswer <- yesno::yesno2(cat(paste0(
      "The dataset contains ", english::english(cellcount), " grid cells,", "\n",
      "Which is approximately ", ceiling((((length(LonIdx.conv) * length(LatIdx.conv) * length(timeIdx.conv)) * 4) / 1000000)), "Mb in size.", "\n",
      #      "Which is approximately ", ceiling(round(( ((length(LonIdx.conv) * length(LatIdx.conv) * length(timeIdx.conv))*4)/1000000) , 1)), "Mb in size.", "\n",
      "Are you sure you want to proceed with the download?"
    )), yes = "Yes")
  }
  cat("Download started \n")
  cat(paste0("Dataset: ", this_dataset), "\n")
  cat(paste0("Date range = ", time[1], " to ", time[2]), "\n")
  cat(paste0("Longitude = ", lonmin - this_correction, " to ", lonmax - this_correction), "\n") # , ")")
  cat(paste0("Latitude  = ", latmin, " to ", latmax), "\n") # , ")")

  if (this_ndims == 3) { # X,Y,T
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
      count = c(length(LonIdx), length(LatIdx), -1, length(timeIdx)),
      verbose = FALSE, collapse_degen = FALSE
    ))

    dataset_var <- abind::adrop(dataset_var[, , 1, , drop = FALSE], drop = 3)
  } else {
    print(stop("Error in downloading data via ncvar_get"))
  }

  cat("Download complete", "\n")

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
    dplyr::filter_at(4, dplyr::all_vars(. > dataset_nc$var[[this_var]]$missval)) # filter by missing value

  end_download_time <- Sys.time()





  # create data.table
  # output.df <-  as.data.frame.table(dataset_var)
  # output.dt <- data.table::as.data.table(output.df)
  # output.dt[output.dt==missing_data] <- NA
  # data.table::setnames(output.dt, c("longitude", "latitude", "date", this_var))
  # output.dt[, date := data.table::as.IDate(date)]
  # }

  # 3. Summarise data ----
  start_summarise_time <- Sys.time()
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
    output.df.2 <- dplyr::left_join(output.df.2, output.df.avg) |>
      dplyr::select(-lonlat) #|>
    # dplyr::mutate(date=lubridate::year(lubridate::floor_date(date, 'year')))
    output.df.2$sst_anomaly <- output.df.2[, this_var] - output.df.2[, "tempvar"]
    output.df.final <- dplyr::select(output.df.2, -tempvar)
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
  if ((max(df_lon) > 180) == TRUE) {
    east <- output.df.final |> dplyr::filter(as.numeric(longitude) < 180)
    west <- output.df.final |>
      dplyr::filter(as.numeric(longitude) > 180) |>
      dplyr::mutate(longitude = longitude - 360)

    output.df.final <- rbind(west, east)
  }

  ### make metadata?
  if (is.character(space) == TRUE) {
    metadata <- data.frame(
      vars = c("datasource", "time", "downloaded_on"),
      vals = c(this_url, paste(time[1], time[2], sep = " to "), as.character(as.Date(Sys.Date())))
    )
  } else if (is.numeric(space) == TRUE) {
    metadata <- data.frame(
      vars = c("datasource", "time", "space", "downloaded_on"),
      vals = c(this_url, paste(timemin, timemax, sep = " to "), paste(lonmin - this_correction, lonmax - this_correction, latmin, latmax, sep = ":"), as.character(as.Date(Sys.Date())))
    )
  }

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

  end_summarise_time <- Sys.time()

  ncdf4::nc_close(dataset_nc)

  if (is.character(space) == TRUE) {
    cat("Data extracted for:\n")
    cat(as.data.frame(dplyr::select(coordlist, longitude, latitude)))
    cat(paste0("Time taken = ", (round(as.numeric(end_summarise_time - start_download_time), 1)), " seconds (downloading = ", round(as.numeric(end_download_time - start_download_time), 2), "s, extracting = ", round(as.numeric(end_summarise_time - start_summarise_time), 2), "s )\n"))
    cat(paste0("Output file size = ", ceiling(file.info(filename)$size / 1000000), " Mb, (", (nrow(space)), " sites, ", length(timeIdx.conv), " timepoints)\n"))
  } else if (is.numeric(space) == TRUE) {
    cat(paste0("Time taken = ", (round(as.numeric(end_summarise_time - start_download_time), 1)), " seconds (downloading = ", round(as.numeric(end_download_time - start_download_time), 2), "s, extracting = ", round(as.numeric(end_summarise_time - start_summarise_time), 2), "s )\n"))
    cat(paste0("Output file size = ", ceiling(file.info(filename)$size / 1000000), " Mb, (", (dim(dataset_var)[1] * dim(dataset_var)[2] * dim(dataset_var)[3]), " grid cells, ", length(timeIdx.conv), " layers)\n"))
  }

  # output.df.final
}
