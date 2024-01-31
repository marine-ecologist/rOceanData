
#' Extract ocean data
#'
#' DEVELOPMENT function to extract ocean data from satellites
#'
#'
#'
#' @param dataset either "none", or in the format "data_id\[dataval\]"
#' @param filename filename for saving
#' @param space either a four length numeric vector (xmin, xmax, ymin, ymax) or a csv/xlsx of sites containing lon and lat columns
#' @param time vector containing two time periods in YYYY-MM-DD format e.g. c("2003-01-01", "2024-01-01")
#' @param save.output TRUE/FALSE for saving output to RDS based on filename.
#' @param ... passes functions

#' @export

extract_ocean_data <- function(dataset = "none", filename = NULL, space = NULL, time = NULL, save.output=FALSE, ...) {

  ##### get source data
  sourcedata <- get_sourcedata()
  dataselect <- select_data_source(data=dataset)
  data_id <- dataselect[[1]][1]
  data_var <- dataselect[[2]][1]

  if (is.numeric(space) && length(space) == 4) {

    start_time <- Sys.time()
    final.data <- download_od(data_id, data_var, space, time) |>
                    tidy_od(data_id)
    end_time <- Sys.time()

  } else {

    if (grepl(".*xlsx.*", space) == TRUE) {
    coordlist <- readxl::read_excel(space)
    } else if (grepl(".*csv.*", space) == TRUE) {
        coordlist <- read.csv(space)
    } else {
      (stop(print("coordinates must be in a vector (xmin, xmax, ymin, ymax) or as a file path to sites in either .xlsx, .xls, .csv")))
    }

    lon_columns <- grep("lon", names(coordlist), value = TRUE, ignore.case = TRUE)
    lat_columns <- grep("lat", names(coordlist), value = TRUE, ignore.case = TRUE)
    coordlist <- coordlist %>% dplyr::mutate(longitude_cell = .[[lon_columns]], latitude_cell = .[[lat_columns]])

    if(any(coordlist$longitude_cell > 180 | coordlist$longitude_cell < -180)) {
      stop("Longitude should be between -180 and 80 degrees")
    }

    if(any(coordlist$latitude_cell > 90 | coordlist$latitude_cell < -90)) {
      stop("Latitude should be between -90 and 90 degrees")
    }

    start_time <- Sys.time()
    final.data <- NULL
    for (i in 1:nrow(coordlist)){
      coordstring <- c(coordlist[lon_columns][[1]][i],coordlist[lon_columns][[1]][i],coordlist[lat_columns][[1]][i],coordlist[lat_columns][[1]][i])
      tmp <- download_od(data_id, data_var, coordstring, time) |>
        tidy_od(data_id) |>
        dplyr::mutate(site_lon=coordstring[1]) |>
        dplyr::mutate(site_lat=coordstring[3]) |>
        dplyr::mutate(site=coordlist$site[i])
      final.data[[i]] <- tmp
    }

    final.data <- do.call(rbind,final.data)
    end_time <- Sys.time()

  }



  ##### setup metadata


  if (is.numeric(space) && length(space) == 4) {

    xml_headers <- get_xml_headers(data_id, space=space, time=time) # get correct space and time from xml data
    xml.space <- c(xml_headers[[1]], xml_headers[[2]], xml_headers[[3]], xml_headers[[4]]) # new space from xml
    xml.time <- c(xml_headers[[5]], xml_headers[[6]]) # new time from xml


    data_info <- data.frame(
      name = xml_headers[[7]]$value[[1]],
      dataset=data_id,
      var=data_var,
      longitude=paste0(xml.space[1], "° to ", xml.space[2],"°"),
      latitude=paste0(xml.space[3], "° to ",  xml.space[4],"°"),
      timeseries=paste0(xml.time[1], " to ", xml.time[2]),
      resolution=paste0(sourcedata[dataset,6], " timesteps"),
      timesteps=length(unique(final.data$time)),
      downloaded_date=Sys.time(),
      download.duration=round(end_time - start_time, 2),
      file.size=pryr::object_size(final.data, units="b"),
      url=sourcedata[dataset,9]
    ) |> t() |>
      as.data.frame() |>
      tibble::rownames_to_column() |>
      dplyr::rename(parameter=1, output=2)
  } else {

  xml_headers <- get_xml_headers(data_id, space=space, time=time) # get correct space and time from xml data
  xml.space <- c(xml_headers[[1]], xml_headers[[2]], xml_headers[[3]], xml_headers[[4]]) # new space from xml
  xml.time <- c(xml_headers[[5]], xml_headers[[6]]) # new time from xml

    xml_headers <- get_xml_headers(data_id, space=space, time=time) # get correct space and time from xml data
    xml.time <- c(xml_headers[[5]], xml_headers[[6]]) # new time from xml

    data_info <- data.frame(
      name = xml_headers[[7]]$value[[1]],
      dataset=data_id,
      var=data_var,
      space = paste0(nrow(space), "sites"),
      timeseries=paste0(xml.time[1], " to ", xml.time[2]),
      resolution=paste0(sourcedata[dataset,6], " timesteps"),
      #timesteps=length(unique(final.data$time)),
      downloaded_date=Sys.time(),
      download.duration=round(end_time - start_time, 2),
      file.size=pryr::object_size(final.data, units="b"),
      url=sourcedata[dataset,9]
    ) |> t() |>
      as.data.frame() |>
      tibble::rownames_to_column() |>
      dplyr::rename(parameter=1, output=2)

  }

#
#   data_info <- data.frame(
#     name = xml_headers[[7]]$value[[1]],
#     dataset=data_id,
#     var=data_var,
#     longitude=paste0(xml.space[1], "° to ", xml.space[2],"°"),
#     latitude=paste0(xml.space[3], "° to ",  xml.space[4],"°"),
#     timeseries=paste0(xml.time[1], " to ", xml.time[2]),
#     resolution=paste0(sourcedata[dataset,6], " timesteps"),
#     timesteps=length(unique(final.data$time)),
#     downloaded_date=Sys.time(),
#     download.duration=round(end_time - start_time, 2),
#     file.size=pryr::object_size(final.data, units="b"),
#     url=sourcedata[dataset,9]
#   ) |> t() |>
#     as.data.frame() |>
#     tibble::rownames_to_column() |>
#     dplyr::rename(parameter=1, output=2)
#

  if (save.output == TRUE) {
    base::saveRDS(object=final.data, file=paste0("",filename, ".rds"))
  }
  rm(dataset)
  rm(sourcedata)
  combined_list <- list(data = final.data, metadata = data_info)

  return(combined_list)

}

