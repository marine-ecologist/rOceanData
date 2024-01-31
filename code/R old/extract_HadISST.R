
#' Extract SST data from HadISST
#'
#' extract_HadISST downloads and extracts Sea Surface Temperature (SST) data
#' from the Hadley Centre Sea Ice and Sea Surface Temperature dataset (HadISST).
#' HadISST is a monthly globally complete SST dataset spanning 1° latitude-longitude 
#' grid from 1871 to present (see https://www.metoffice.gov.uk/hadobs/hadisst/ and 
#' https://www.metoffice.gov.uk/hadobs/hadisst/HadISST_paper.pdf for more information).
#'
#' The function can output either one of "mean", "median", "modal", "min", "max", 
#' or "sd" (standard deviation) for annually averaged data, or "monthly" for unaveraged raw data. 
#' 'subset' allows selection of specific years or a sequence of years (see arguments for details),
#' 'output' allows selection of output type (either csv or spatraster) with corresponding filename.
#'
#' On first use, the function downloads the entire HadISST netCDF file (HadISST_sst.nc) to 
#' /rOceanData/datasets (226.2mb), and subsequent analyses check for the .nc file. This approach was 
#' adopted over subsetting and downloading data with each use due to the relatively small size of the 
#' global netCDF file (226.2mb compressed for download, 475.4mb uncompressed). To save SSD space and 
#' remove the HadISST_sst.nc use the function nuke.HadISST() 
#'
#'
#'
#' @param xmin minimum longitude for bounding box (between -180 to 180)
#' @param xmax maximum longitude for bounding box (between -180 to 180)
#' @param ymin minimum latitude for bounding box (between -90 to 90)
#' @param ymax maximum latitude for bounding box (between -90 to 90)
#' @param output one of either "mean", "median", "modal", "min", "max", "sd" for annual averages, or "monthly" for raw data
#' @param years subset data by years either with a numeric string or sequence (see examples below)
#' @param filetype either "csv" or "sp" (save as SpatRaster)
#' @param filename filename (defaults to "data")


# xmin=-180; xmax=180; ymin=-90; ymax=90
#
extract_HadISST <- function(xmin, xmax, ymin, ymax, output = "mean", years = c(seq.int(1870,lubridate::year(Sys.time()))), filetype = "csv", filename = "data") {

  # check if folder exists otherwise create folder
  if (!dir.exists("datasets/")) {
    dir.create("datasets/")
  }
  if (!dir.exists("outputs/")) {
    dir.create("outputs/")
  }

  # check if file exists otherwise download the full HadISST dataset *475mb*
  if (file.exists("datasets/HadISST_sst.nc")) {
    print("HadISST dataset already downloaded - extracting SST data")
  } else {
    print("downloading HadISST dataset on first use")
    download.file("https://www.metoffice.gov.uk/hadobs/hadisst/data/HadISST_sst.nc.gz", "datasets/HadISST_sst.nc.gz")
    R.utils::gunzip("datasets/HadISST_sst.nc.gz")
  }

  HadISSTmain <- terra::rast("datasets/HadISST_sst.nc") # read nc file as raster
  HadISST <- terra::crop(HadISSTmain, terra::ext(xmin, xmax, ymin, ymax)) # crop to bounding box depending on lon/lat
  names(HadISST) <- terra::time(HadISST) # set layer names from time
  terra::units(HadISST) <- "SST"

  #yrs_list_had <- terra::time(HadISST)

  # Select output type (average annual SST, max annual SST, min annual SST, raw (daily))
  if (output == "mean") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = mean)
    #names(HadISST) <- (gsub("X", "", names(HadISST)))
    #terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "max") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = max)
    #names(HadISST) <- (gsub("X", "", names(HadISST)))
    #terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "min") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = min)
    #names(HadISST) <- (gsub("X", "", names(HadISST)))
    #terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "modal") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = modal)
    #names(HadISST) <- (gsub("X", "", names(HadISST)))
    #terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "median") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = median)
    #names(HadISST) <- (gsub("X", "", names(HadISST)))
    #terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "sd") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = sd)
    #names(HadISST) <- (gsub("X", "", names(HadISST)))
    #terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "monthly") {
    terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else {
    HadISST <- terra::tapp(HadISST, index = "years", fun = mean)
   # names(HadISST) <- (gsub("X", "", names(HadISST)))
    #terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
    print("No output type specified, defaulting to annual mean")
  }

  
  ### Select filetype and save output
  if (filetype == "sp") { # save as SpatRaster to RDS
   names(HadISST) <- (gsub("X", "", names(HadISST)))
   terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
   HadISST <- terra::subset(HadISST, as.character(years), NSE = FALSE)
   saveRDS(object = HadISST, file = paste0("outputs/", filename, ".rds"))
   rm(HadISST)
   
  } else if (filetype == "csv") { # save as csv
   names(HadISST) <- (gsub("X", "", names(HadISST)))
   terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
   HadISST <- terra::subset(HadISST, as.character(years), NSE = FALSE)
   filesave <- HadISST |>
      terra::as.data.frame(xy = TRUE, na.rm = FALSE) |>
      tidyr::pivot_longer(!x:y, names_to = "date", values_to = "SST") |>
      dplyr::rename(lat = x, lon = y) 
    #  mutate(date = case_when(grepl("X", date) ~ (gsub("X","",date)), grepl("-", date) ~date)) %>%
    write.csv(filesave, file = paste0("outputs/", filename, ".csv"))
    rm(HadISST)
  } else {
    print("filetype not found (either 'csv' or 'sp') ")
  }
}
