
extract_ocean_data <- function(dataset = "none", filename = NULL, space = NULL, time = NULL, save.output=FALSE, ...) {

  ##### get source data
  sourcedata <- get_sourcedata()
  dataselect <- select_data_source(data=dataset)
  data_id <- dataselect[[1]][1]
  data_var <- dataselect[[2]][1]

    if (grepl(".*xlsx.*", space) == TRUE) {
    coordlist <- readxl::read_excel(space)
    } else if (grepl(".*csv.*", space) == TRUE) {
        coordlist <- read.csv(space)
    } else {
      (stop(print("coordinates must be in a vector (xmin, xmax, ymin, ymax) or as a file path to sites in either .xlsx, .xls, .csv")))
    }
#
#     if(any(coordlist$latitude_cell > 90 | coordlist$latitude_cell < -90)) {
#       stop("Latitude should be between -90 and 90 degrees")
#     }
#

  ### add bbox to coord dataframe via sf
  coordlist <- tibble(
    site = c("GBR", "Hawaii", "Bahamas"),
    latitude = c(-19.2, 21.7, 24.4),
    longitude = c(148, -158, -77.7)
  )

  # Convert to sf object
  sf_object <- st_as_sf(coordlist, coords = c("longitude", "latitude"), crs = 4326)

  # Buffer by 1 km for each point and calculate bounding box
  buffered_and_bbox <- sf_object %>%
    st_transform(crs = 3857) %>%
    st_buffer(dist = 1000) %>%
    st_transform(crs = 4326) %>% as.data.frame()

  # Combine the original data with the bounding box information
  result <- cbind(coordlist, buffered_and_bbox)

  result


  coordlist2
    start_time <- Sys.time()
    final.data <- NULL
    for (i in 1:nrow(coordlist2)){
      coordstring2 <- c(coordlist2$xmin[i], coordlist2$xmax[i],coordlist2$ymin[i], coordlist2$ymax[i])
      tmp <- download_od(data_id, data_var, coordstring2, time) |>
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

  xml_headers <- get_xml_headers(data_id, space=space, time=time) # get correct space and time from xml data
  xml.space <- c(xml_headers[[1]], xml_headers[[2]], xml_headers[[3]], xml_headers[[4]]) # new space from xml
  xml.time <- c(xml_headers[[5]], xml_headers[[6]]) # new time from xml

  if (grepl("\\.xls[xm]?|\\.csv$", space, ignore.case = TRUE)) {
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

  } else {
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
  }


  if (save.output == TRUE) {
    base::saveRDS(object=final.data, file=paste0("",filename, ".rds"))
  }
  rm(dataset)
  rm(sourcedata)
  combined_list <- list(data = final.data, metadata = data_info)

  return(combined_list)

}

