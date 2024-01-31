
tmp2 <- extract_ocean_data(dataset = "SST_OISST",
  space = c(70, 70.5, 0.0, 0.5),
  time = c("2004-09-01", "2007-11-01"),
  summarise="mean",
  filename="temp.csv")

extract_ocean_data <- function(dataset = NULL, space = NULL, time = NULL, summarise="none", filename = NULL) {

  ## Use thredds to get the DatasetNode:
  catalog_list <- thredds::CatalogNode$new("https://oceanwatch.pifsc.noaa.gov/thredds/catalog.xml")
  dataset_list <- catalog_list$get_datasets()

### MODIS ###
  if (dataset == "PAR_MODIS_Monthly") {
    this_dataset <- (dataset_list[[15]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "par"
    this_origin <- NULL
    this_timestep <- "days" # convert seconds to days if needed
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "PAR_MODIS_8day") {
    this_dataset <- (dataset_list[[16]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "par"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "PAR_MODIS_Daily") {
    this_dataset <- (dataset_list[[17]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "par"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "Chl_MODIS_monthly") {
    this_dataset <- (dataset_list[[4]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "chlor_a"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "Chl_MODIS_8day") {
    this_dataset <- (dataset_list[[5]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "chlor_a"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "Chl_MODIS_Daily") {
    this_dataset <- (dataset_list[[6]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "chlor_a"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "Kd490_MODIS_monthly") {
    this_dataset <- (dataset_list[[21]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "Kd_490"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "Kd490_MODIS_8day") {
    this_dataset <- (dataset_list[[22]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "Kd_490"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "Kd490_MODIS_Daily") {
    this_dataset <- (dataset_list[[23]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "Kd_490"
    this_origin <- NULL
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "SST_NOAA_Blended_monthly") {
    this_dataset <- (dataset_list[[37]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "SST_NOAA_Blended_8Day") {
    this_dataset <- (dataset_list[[38]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "SST_NOAA_Blended_Daily") {
    this_dataset <- (dataset_list[[39]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)

### NOAA ###
# below not working
  } else if (dataset == "SST_NOAA_CoralTemp_Daily") {
    this_dataset <- (dataset_list[[40]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "SST_NOAA_CoralTemp_8day") {
    this_dataset <- (dataset_list[[41]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "SST_NOAA_CoralTemp_Monthly") {
    this_dataset <- (dataset_list[[44]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)
  } else if (dataset == "SST_NOAA_CoralTemp_Cum") {
    this_dataset <- (dataset_list[[43]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "analysed_sst"
    this_origin <- "1981-01-01"
    this_timestep <- "days"
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)

    # below good again
  } else if (dataset == "SST_NOAA_DHW") {
    this_dataset <- (dataset_list[[45]])
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "degree_heating_week"
    this_origin <- "1981-01-01"
    this_timestep <- "seconds" # convert seconds to days
    this_catnode <- "https://oceanwatch.pifsc.noaa.gov/thredds/dodsC"
    catalog_dataset_url <- file.path(this_catnode, this_dataset$url)


  } else if (dataset == "SST_HadISST") {
    this_lon="longitude"
    this_lat="latitude"
    this_correction=0
    this_var <- "sst"
    this_origin <- "1870-01-01"
    this_timestep <- "days"
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/HadleyCenter/HadISST"

  } else if (dataset == "SST_OISST") {
    this_lon="lon"
    this_lat="lat"
    this_correction=180
    this_var <- "sst"
    this_origin <- "1800-1-1"
    this_timestep <- "days"
    catalog_dataset_url <- "https://psl.noaa.gov/thredds/dodsC/Datasets/noaa.oisst.v2/sst.mnmean.nc"

  } else {
    print("Incorrect dataset specification, see ?extract_ocean_data for options")
  }


  ## oceanwatch catalogue: https://oceanwatch.pfeg.noaa.gov/thredds/catalog/catalog.html
  ## THREDDS OPeNDAP file path

  dataset_nc <- ncdf4::nc_open(catalog_dataset_url)
  df_lon <- ncdf4::ncvar_get(dataset_nc, this_lon) # Get longitude values
  df_lat <- ncdf4::ncvar_get(dataset_nc, this_lat) # Get latitude values
  if (this_timestep == "seconds") {
    df_time_index <- lubridate::date(lubridate::as_datetime(as.Date(ncdf4::ncvar_get(dataset_nc, "time")/86400, origin = this_origin)))
  } else {
   df_time_index <- lubridate::date(lubridate::as_datetime(as.Date(ncdf4::ncvar_get(dataset_nc, "time"), origin = this_origin)))
  }

  timemin <- time[1]
  timemax <- time[2]
  timeIdx <- which(df_time_index >= timemin & df_time_index <= timemax)
  timeIdx.conv <- df_time_index[min(timeIdx):max(timeIdx)]

  gps_points <- readxl::read_excel("LimitedSites.xlsx") |>
    dplyr::rename_all(tolower) |>
#     dplyr::select(matches("lon|lat")) |> # partial match colnames for lon and lat
     dplyr::mutate(longitude = longitude + this_correction)

    start_time <- Sys.time()

    for(i in 1:nrow(gps_points)) {
    varget <- (ncdf4::ncvar_get(dataset_nc, # double check final sweep but looks good (for each z sweep x then y)
      varid = (this_var),
      start = c(min(LonIdx), min(LatIdx), min(timeIdx)),
      count = c(length(LonIdx), length(LatIdx), length(timeIdx)),
      verbose = FALSE
    ))

    print(paste0("Dataset downloaded: ", this_dataset$name))
    end_time <- Sys.time()
    print(paste0("Completed in ", round(as.numeric(end_time - start_time), 2), " seconds"))
  } else {
    print("netCDF not downloaded")
  }

  output.df <- count.loop |>
    dplyr::select(lon, lat, date) |>
    dplyr::mutate(date = lubridate::ymd(as.Date(date))) |>
    dplyr::mutate(xyz = as.numeric(varget)) |>
    dplyr::arrange(lon, lat) |>
    dplyr::rename_with(.col = xyz, ~this_var)

  ### average if selected
options(dplyr.summarise.inform = FALSE)
  if (summarise == "mean") {
  output.df.final <- output.df |>
     dplyr::group_by(lon,lat, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = mean)) |>
     as.data.frame()
  } else if (summarise == "mode") {
  output.df.final <- output.df |>
     dplyr::group_by(lon,lat, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = mode)) |>
     as.data.frame()
  } else if (summarise == "median") {
  output.df.final <- output.df |>
     dplyr::group_by(lon,lat, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = median)) |>
     as.data.frame()
  } else if (summarise == "min") {
  output.df.final <- output.df |>
     dplyr::group_by(lon,lat, year = lubridate::floor_date(date, 'year')) |>
     dplyr::mutate(year=lubridate::year(year)) |>
     dplyr::summarise(across(.cols = where(is.numeric),.fns = min)) |>
     as.data.frame()
  } else if (summarise == "max") {
  output.df.final <- output.df |>
     dplyr::group_by(lon,lat, year = lubridate::floor_date(date, 'year')) |>
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
  } else if (  grepl("csv", filename) == TRUE) {
    write.csv(output.df.final, filename)
  } else if (  grepl("rds", filename) == TRUE) {
    saveRDS(output.df.final, filename)
  } else {
    output.df.final
    }
}
