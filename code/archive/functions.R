extract_griddap_180_extent <- function(space = NULL, time = NULL, this_dataset = NULL, this_var = NULL) {
  this_dataset_info <- rerddap::info(this_dataset)
  dataset.xlims <- (subset(this_dataset_info$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])

  dataset_nc_180 <- rerddap::griddap(this_dataset, fmt = "nc", longitude = space[1:2], latitude = space[3:4], time = time)
  dataset_nc_180.data <- dataset_nc_180$data |>
    dplyr::select(longitude, latitude, time, paste(this_var)) |>
    dplyr::arrange(rev(latitude)) |> as.data.frame()
  dataset_nc_180.data$longitude <- as.numeric(as.character(dataset_nc_180.data$longitude))
  dataset_nc_180.data$latitude <- as.numeric(as.character(dataset_nc_180.data$latitude)) #* -1
  dataset_nc_180.data

  spatial.ext.180 <- terra::ext(min(dataset_nc_180.data$longitude, na.rm = TRUE),max(dataset_nc_180.data$longitude, na.rm = TRUE), min(dataset_nc_180.data$latitude, na.rm = TRUE), max(dataset_nc_180.data$latitude, na.rm = TRUE))
  dataset_nc_180.rast <- terra::rast(
        nrows = length(unique(dataset_nc_180.data$latitude)),
        ncols = length(unique(dataset_nc_180.data$longitude)),
        ext = spatial.ext.180,
        nl = length(unique(dataset_nc_180.data$time)),
        crs="EPSG:4326",
        vals = dataset_nc_180.data[[this_var]])
}
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
}

}
extract_griddap_360_extent <- function(space, time, this_dataset, this_var) {
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
      dplyr::select(longitude, latitude, time, paste(this_var)) |> #na.omit()
      dplyr::arrange(rev(latitude)) |> as.data.frame()
    dataset_nc_360.data$longitude <- as.numeric(as.character(dataset_nc_360.data$longitude))
    dataset_nc_360.data$latitude <- as.numeric(as.character(dataset_nc_360.data$latitude))

    spatial.ext.360 <- terra::ext(min(dataset_nc_360.data$longitude, na.rm = TRUE),max(dataset_nc_360.data$longitude, na.rm = TRUE), min(dataset_nc_360.data$latitude, na.rm = TRUE), max(dataset_nc_360.data$latitude, na.rm = TRUE))
    dataset_nc_360.rast <- terra::rast(
        nrows = length(unique(dataset_nc_360.data$latitude)),
        ncols = length(unique(dataset_nc_360.data$longitude)),
        ext = spatial.ext.360,
        nl = length(unique(dataset_nc_360.data$time)),
        crs="EPSG:4326",
        vals = dataset_nc_360.data[[this_var]])
    dataset_nc_360.rast

  } else if (space[1] < 0 & space[2] > 0) {
    longitude.extent.b <- c(360 + space[1], dataset.xmax) # split extents around meridian
    longitude.extent.a <- c(dataset.xmin, space[2])
    datasetnc_b <-rerddap:: griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.b, latitude = space[3:4], time = time) # extract both splits seperately
    datasetnc_a <- rerddap::griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.a, latitude = space[3:4], time = time)

    datasetnc_b.data <- datasetnc_b$data |> # get data.frame b
      dplyr::select(longitude, latitude, time, paste(this_var)) |> #na.omit()
      dplyr::arrange(rev(latitude)) |> as.data.frame()
    datasetnc_b.data$longitude <- as.numeric(as.character(datasetnc_b.data$longitude))-360
    datasetnc_b.data$latitude <- as.numeric(as.character(datasetnc_b.data$latitude))


    datasetnc_a.data <- datasetnc_a$data |> # get data.frame a
      dplyr::select(longitude, latitude, time, paste(this_var)) |> #na.omit()
      dplyr::arrange(rev(latitude)) |> as.data.frame()

    dataset_nc_360.data <- rbind(datasetnc_a.data, datasetnc_b.data) |> # merge dataframes
      #dplyr::arrange(rev(latitude)) |> as.data.frame()
      dplyr::arrange(rev(latitude),longitude)
#    dataset_nc_360.data$longitude <- as.numeric(as.character(dataset_nc_360.data$longitude))

    #   dataset_nc_360.data$latitude <- as.numeric(as.character(dataset_nc_360.data$latitude))

    spatial.ext.360 <- terra::ext(min(dataset_nc_360.data$longitude, na.rm = TRUE),max(dataset_nc_360.data$longitude, na.rm = TRUE), min(dataset_nc_360.data$latitude, na.rm = TRUE), max(dataset_nc_360.data$latitude, na.rm = TRUE))
    dataset_nc_360.rast <- terra::rast(
        nrows = length(unique(dataset_nc_360.data$latitude)),
        ncols = length(unique(dataset_nc_360.data$longitude)),
        ext = spatial.ext.360,
        nl = length(unique(dataset_nc_360.data$time)),
        crs="EPSG:4326",
        vals = dataset_nc_360.data[[this_var]])
    dataset_nc_360.rast

  } else if (space[1] < 0 & space[2] < 0) {
    longitude.extent.b <- c(360 + space[1], 360 + space[2]) # split extents around meridian
    datasetnc_b <- rerddap::griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.b, latitude = space[3:4], time = time) # extract both splits seperately
    datasetnc_b.data <- datasetnc_b$data
    datasetnc_b.data$longitude <- as.numeric(datasetnc_b.data$longitude) - 360 # shift back to 180
    dataset_nc_360.data <- (datasetnc_b.data) |> # merge dataframes
       dplyr::select(longitude, latitude, time, paste(this_var)) |> #na.omit()
      dplyr::arrange(rev(latitude)) |> as.data.frame()
    dataset_nc_360.data$longitude <- as.numeric(as.character(dataset_nc_360.data$longitude))
    dataset_nc_360.data$latitude <- as.numeric(as.character(dataset_nc_360.data$latitude))

    spatial.ext.360 <- terra::ext(min(dataset_nc_360.data$longitude, na.rm = TRUE),max(dataset_nc_360.data$longitude, na.rm = TRUE), min(dataset_nc_360.data$latitude, na.rm = TRUE), max(dataset_nc_360.data$latitude, na.rm = TRUE))
    dataset_nc_360.rast <- terra::rast(
        nrows = length(unique(dataset_nc_360.data$latitude)),
        ncols = length(unique(dataset_nc_360.data$longitude)),
        ext = spatial.ext.360,
        nl = length(unique(dataset_nc_360.data$time)),
        crs="EPSG:4326",
        vals = dataset_nc_360.data[[this_var]])
    dataset_nc_360.rast
  }
}

# test across prime meridian
tmp <- extract_griddap_180_extent(space = c(-100, 100, 0, 50), this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("2023-01-08", "2023-01-08"))
tmp <- extract_griddap_180_points(space = "LimitedSites.xlsx", this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("2023-01-08", "2023-01-08"))
tmp2 <- extract_griddap_360_extent(space = c(-100, 100, 0, 50), this_dataset = "ncdcOisst21Agg", this_var = "sst", time = c("2023-01-08", "2023-01-08"))
identical(tmp, tmp2)

Thanks # only west of prime meridian
tmp <- extract_griddap_180_extent(space = c(-30, -10, 0, 50), this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("2023-01-08", "2023-01-08"))
tmp2 <- extract_griddap_360_extent(space = c(-30, -10, 0, 50), this_dataset = "ncdcOisst21Agg", this_var = "sst", time = c("2023-01-08", "2023-01-08"))
identical(tmp, tmp2)

# only east of prime meridian
tmp <- extract_griddap_180_extent(space = c(10, 30, 0, 50), this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("2023-01-08", "2023-01-08"))
tmp2 <- extract_griddap_360_extent(space = c(10, 30, 0, 50), this_dataset = "ncdcOisst21Agg", this_var = "sst", time = c("2023-01-08", "2023-01-08"))
identical(tmp, tmp2)


# example use:
extract_griddap_extent <- function(space, time, this_dataset, this_var){
  x <- rerddap::info(paste(this_dataset))
  dataset.xlims <- (subset(x$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])

  if (dataset.xmin < 0) {
    extract_griddap_180_extent(space, time, this_dataset, this_var)

    } else if (dataset.xmax > 180) {
    extract_griddap_360_extent(space, time, this_dataset, this_var)
  }
}
ncdcOisst21Agg_LonPM180_output <- extract_griddap_extent(this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("last", "last"), space = c(-100, 100, 0, 50))
ncdcOisst21Agg_output <- extract_griddap_extent(this_dataset = "ncdcOisst21Agg", this_var = "sst", time = c("last", "last"), space = c(-100, 100, 0, 50))

identical(ncdcOisst21Agg_LonPM180_output, ncdcOisst21Agg_output)

ggplot2::ggplot() + ggplot2::ggtitle("dataset_180") +
     tidyterra::geom_spatraster(data=ncdcOisst21Agg_LonPM180_output)
ggplot2::ggplot() + ggplot2::ggtitle("dataset_360") +
     tidyterra::geom_spatraster(data=ncdcOisst21Agg_output)






### junk below IGNORE




extract_griddap_180_extent <- function(space = NULL, time = NULL, this_dataset = NULL, this_var = NULL) {
  x <- rerddap::info(paste(this_dataset))
  dataset.xlims <- (subset(x$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])
  xstep <- as.numeric(strsplit((subset(x$alldata$longitude, attribute_name == "grids", "value")$value)," ")[[1]][8])
  xIdx <- seq(dataset.xmin, dataset.xmax, xstep)
  LonIdx <- which(xIdx >= space[1] & xIdx <= space[2]) # get match by position

  dataset.ylims <- (subset(x$alldata$latitude, attribute_name == "actual_range", "value")$value)
  dataset.ylims.split <- strsplit(dataset.ylims, ",")[1]
  dataset.ymin <- as.numeric(dataset.ylims.split[[1]][1])
  dataset.ymax <- as.numeric(dataset.ylims.split[[1]][2])
  ystep <- as.numeric(strsplit((subset(x$alldata$longitude, attribute_name == "grids", "value")$value)," ")[[1]][8])
  yIdx <- seq(dataset.ymin, dataset.ymax, ystep)
  LonIdy <- which(yIdx >= space[3] & yIdx <= space[4]) # get match by position


  dataset_nc_180 <- rerddap::griddap(this_dataset, fmt = "nc", longitude = c(xIdx[min(LonIdx)], xIdx[max(LonIdx)]), latitude = c(yIdx[max(LonIdy)], yIdx[min(LonIdy)]), time = c("last", "last"))
  spatial.ext.180 <- terra::ext(min(dataset_nc_180$summary$dim$longitude$vals, na.rm = TRUE),max(dataset_nc_180$summary$dim$longitude$vals, na.rm = TRUE), min(dataset_nc_180$summary$dim$latitude$vals, na.rm = TRUE), max(dataset_nc_180$summary$dim$latitude$vals, na.rm = TRUE))
  dataset_nc_180_data <- dataset_nc_180$data
  dataset_nc_180_data <- dataset_nc_180_data |> dplyr::arrange(rev(latitude))
  #dataset_nc_180_data$latitude <- dataset_nc_180_data$latitude * -1
  dataset_nc_180_rast <- terra::rast(
        nrows = length(unique(dataset_nc_180_data$latitude)),
        ncols = length(unique(dataset_nc_180_data$longitude)),
        ext = spatial.ext.180,
        nl = length(unique(dataset_nc_180_data$time)),
        crs="EPSG:4326",
        vals = dataset_nc_180_data[[this_var]])

  names(dataset_nc_180_rast) <- paste0(as.character(unique(lubridate::ymd(as.Date((unique(dataset_nc_180$data$time)))))))
  terra::time(dataset_nc_180_rast) <- lubridate::ymd(names(dataset_nc_180_data))
  dataset_nc_180_rast

}

extract_griddap_360_extent <- function(space = NULL, time = NULL, this_dataset = NULL, this_var = NULL) {
  x <- rerddap::info(paste(this_dataset))
  dataset.xlims <- (subset(x$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])
  xstep <- as.numeric(strsplit((subset(x$alldata$longitude, attribute_name == "grids", "value")$value)," ")[[1]][8])
  xIdx <- seq(dataset.xmin, dataset.xmax, xstep)
  LonIdx <- which(xIdx >= space[1] & xIdx <= space[2]) # get match by position
  lon.list.360 <- xIdx
  lon.list.180 <- xIdx-180

  dataset.ylims <- (subset(x$alldata$latitude, attribute_name == "actual_range", "value")$value)
  dataset.ylims.split <- strsplit(dataset.ylims, ",")[1]
  dataset.ymin <- as.numeric(dataset.ylims.split[[1]][1])
  dataset.ymax <- as.numeric(dataset.ylims.split[[1]][2])
  ystep <- as.numeric(strsplit((subset(x$alldata$longitude, attribute_name == "grids", "value")$value)," ")[[1]][8])
  yIdx <- seq(dataset.ymin, dataset.ymax, ystep)
  LonIdy <- which(yIdx >= space[3] & yIdx <= space[4]) # get match by position


  lon180 <- seq(space[1]+(xstep/2), space[2]-(xstep/2), xstep)
  lona <- c(1, which(diff(sign(lon180))!=0), which(diff(sign(lon180))!=0)+1, length(lon180))[1:2]
  lonb <- c(1, which(diff(sign(lon180))!=0), which(diff(sign(lon180))!=0)+1, length(lon180))[3:4]
  lon360 <- ifelse(lon180 < 0, 360 + lon180, lon180)
  LonIdx <- which(lon360 >= space[1] & lon360 <= space[2]) # get match by position

  longitude.extent.b <- c(lon360[min(lona)], lon360[max(lona)]) # split extents around meridian
  dataset_nc_360b <- griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.b, latitude = c(yIdx[min(LonIdy)], yIdx[max(LonIdy)]), time = time) # extract both splits seperately
  spatial.ext.360b <- terra::ext(min(dataset_nc_360b$summary$dim$longitude$vals, na.rm = TRUE),max(dataset_nc_360b$summary$dim$longitude$vals, na.rm = TRUE), min(dataset_nc_360b$summary$dim$latitude$vals, na.rm = TRUE), max(dataset_nc_360b$summary$dim$latitude$vals, na.rm = TRUE))
  dataset_nc_360b_data <- dataset_nc_360b$data
  dataset_nc_360b_data <- dataset_nc_360b_data |> dplyr::arrange(rev(latitude))
  datasetnc_360b_rast <- terra::rast(
        nrows = length(unique(dataset_nc_360b_data$latitude)),
        ncols = length(unique(dataset_nc_360b_data$longitude)),
        ext = spatial.ext.360b,
        nl = unique(length(dataset_nc_360b_data$time)),
        vals = dataset_nc_360b_data[[this_var]])

  longitude.extent.a <- c(lon360[min(lonb)], lon360[max(lonb)])
  if ((is.na(longitude.extent.a)[1])==TRUE) {
  dataset_nc_360ab <- dataset_nc_360b$data

  } else {
  dataset_nc_360a <- griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.a, latitude = c(yIdx[min(LonIdy)], yIdx[max(LonIdy)]), time = time) # extract both splits seperately
  spatial.ext.360a <- terra::ext(min(dataset_nc_360a$summary$dim$longitude$vals, na.rm = TRUE),max(dataset_nc_360a$summary$dim$longitude$vals, na.rm = TRUE), min(dataset_nc_360a$summary$dim$latitude$vals, na.rm = TRUE), max(dataset_nc_360a$summary$dim$latitude$vals, na.rm = TRUE))
  dataset_nc_360a_data <- dataset_nc_360a$data
  dataset_nc_360a_data <- dataset_nc_360a_data |> dplyr::arrange(rev(latitude))
  datasetnc_360a_rast <- terra::rast(
        nrows = length(unique(dataset_nc_360a_data$latitude)),
        ncols = length(unique(dataset_nc_360a_data$longitude)),
        ext = spatial.ext.360a,
        nl = unique(length(dataset_nc_360a_data$time)),
        vals = dataset_nc_360a_data[[this_var]])

    dataset_nc_360ab <- rbind(dataset_nc_360b$data, dataset_nc_360a$data)
    }

  dataset_nc_360ab <- dataset_nc_360ab |> dplyr::arrange(rev(latitude))
  datasetnc_360 <- terra::rast(
        nrows = length(unique(dataset_nc_360ab$latitude)),
        ncols = length(unique(dataset_nc_360ab$longitude)),
       ext = terra::ext(min(lon180),max(lon180),min(dataset_nc_360ab$latitude),max(dataset_nc_360ab$latitude)),
        nl = length(unique(dataset_nc_360ab$time)),
        crs= "+proj=longlat +datum=WGS84",
        vals = dataset_nc_360ab[[this_var]])

  #datasetnc_360 <- terra::merge(datasetnc_360b_rast,datasetnc_360a_rast)
  names(datasetnc_360) <- paste0(as.character(unique(lubridate::ymd(as.Date((unique(dataset_nc_360ab$time)))))))
  terra::time(datasetnc_360) <- lubridate::ymd(names(datasetnc_360))
  #terra::values(datasetnc_360) <- round(terra::values(datasetnc_360),2)
  datasetnc_360


}

# caribbean space=c(-105,-40, 5,40)

tmp <- extract_griddap_180_extent(space=c(-105,40, -20,40), this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("2023-01-08", "2023-01-08"))

tmp2 <- extract_griddap_360_extent(space=c(-105,40, -20,40), this_dataset = "ncdcOisst21Agg", this_var = "sst", time = c("2023-01-08", "2023-01-08"))
identical(tmp, tmp2)

  ggplot() + ggtitle("datasetnc_360") +
    geom_spatraster(data=tmp2)
  ggplot() + ggtitle("datasetnc_180") +
    geom_spatraster(data=tmp)


tmp_df <- terra::as.data.frame(tmp, xy = TRUE, na.rm = FALSE)
tmp2_df <- terra::as.data.frame(tmp2, xy = TRUE, na.rm = FALSE)
identical(tmp_df, tmp2_df)


# example use:
extract_griddap_extent <- function(space, time, this_dataset, this_var){
  x <- info(paste(this_dataset))
  dataset.xlims <- (subset(x$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])

  if (dataset.xmin < 0) {
    extract_griddap_180_extent(space, time, this_dataset, this_var)

    } else if (dataset.xmax > 180) {
    extract_griddap_360_extent(space, time, this_dataset, this_var)
  }
}
ncdcOisst21Agg_LonPM180_output <- extract_griddap_extent(this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("last", "last"), space = c(-100, 100, 0, 50))
ncdcOisst21Agg_output <- extract_griddap_extent(this_dataset = "ncdcOisst21Agg", this_var = "sst", time = c("last", "last"), space = c(-100, 100, 0, 50))

identical(ncdcOisst21Agg_LonPM180_output, ncdcOisst21Agg_output)



#### below functioning on df
extract_griddap_180_extent <- function(space = NULL, time = NULL, this_dataset = NULL, this_var = NULL) {
  this_dataset_info <- rerddap::info(this_dataset)
  dataset.xlims <- (subset(this_dataset_info$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])

  dataset_nc_180 <- griddap(this_dataset, fmt = "nc", longitude = space[1:2], latitude = space[3:4], time = c("last", "last"))
  dataset_nc_180.data <- dataset_nc_180$data |>
    dplyr::dplyr::arrange(longitude, latitude) |>
    dplyr::select(longitude, latitude, time, paste(this_var)) |>
    as.data.frame()
  dataset_nc_180.data$longitude <- as.numeric(as.character(dataset_nc_180.data$longitude))
  dataset_nc_180.data$latitude <- as.numeric(as.character(dataset_nc_180.data$latitude))
  dataset_nc_180.data

}
extract_griddap_360_extent <- function(space = NULL, time = NULL, this_dataset = NULL, this_var = NULL) {
  this_dataset_info <- rerddap::info(paste(this_dataset))
  dataset.xlims <- (subset(this_dataset_info$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])

  longitude.extent.b <- c(360 + space[1], dataset.xmax) # split extents around meridian
  longitude.extent.a <- c(dataset.xmin, space[2])

  datasetnc_b <- griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.b, latitude = space[3:4], time = time) # extract both splits seperately
  datasetnc_a <- griddap(paste(this_dataset), fmt = "nc", longitude = longitude.extent.a, latitude = space[3:4], time = time)

  datasetnc_b.data <- datasetnc_b$data # get data.frame b
  datasetnc_b.data$longitude <- datasetnc_b.data$longitude - 360 # shift back to 180
  datasetnc_a.data <- datasetnc_a$data # get data.frame a
  dataset_nc_360.data <- rbind(datasetnc_a.data, datasetnc_b.data) |> # merge dataframes
    dplyr::arrange(longitude, latitude) |>
    select(longitude, latitude, time, paste(this_var)) #|> na.omit()
  dataset_nc_360.data$longitude <- as.numeric(as.character(dataset_nc_360.data$longitude))
  dataset_nc_360.data$latitude <- as.numeric(as.character(dataset_nc_360.data$latitude))
  dataset_nc_360.data
}

tmp <- extract_griddap_180_extent(this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("last", "last"), space = c(-100, 100, 0, 50))
tmp2 <- extract_griddap_360_extent(this_dataset = "ncdcOisst21Agg", this_var = "sst", time = c("last", "last"), space = c(-100, 100, 0, 50))
identical(tmp, tmp2)

# example use:
extract_griddap_extent <- function(space, time, this_dataset, this_var){
  x <- info(paste(this_dataset))
  dataset.xlims <- (subset(x$alldata$longitude, attribute_name == "actual_range", "value")$value)
  dataset.xlims.split <- strsplit(dataset.xlims, ",")[1]
  dataset.xmin <- as.numeric(dataset.xlims.split[[1]][1])
  dataset.xmax <- as.numeric(dataset.xlims.split[[1]][2])

  if (dataset.xmin < 0) {
    extract_griddap_180_extent(space, time, this_dataset, this_var)

    } else if (dataset.xmax > 180) {
    extract_griddap_360_extent(space, time, this_dataset, this_var)
  }
}
ncdcOisst21Agg_LonPM180_output <- extract_griddap_extent(this_dataset = "ncdcOisst21Agg_LonPM180", this_var = "sst", time = c("last", "last"), space = c(-100, 100, 0, 50))
ncdcOisst21Agg_output <- extract_griddap_extent(this_dataset = "ncdcOisst21Agg", this_var = "sst", time = c("last", "last"), space = c(-100, 100, 0, 50))

identical(ncdcOisst21Agg_LonPM180_output, ncdcOisst21Agg_output)
