# oceanwarming
# library(oceandistiller)


library(readxl)
library(thredds)
library(tidyverse)
library(ncdf4.helpers)
library(ncdf4)
library(terra)
library(sf)
library(rnaturalearth)
library(tidyterra)
library(scales)
library(lubridate)
library(ncdf4)
library(foreach)
library(PCICt)

### Function to extract NOAA CRW monthly 5km SST data
### NOAA Coral Reef Watch (CRW) sea surface temperature (SST) dataset
### https://www.pacioos.hawaii.edu/metadata/dhw_5km_dataset.html

## Description:
# Contains a suite of NOAA Coral Reef Watch (CRW) version 3.1 monthly average global satellite coral bleaching
# heat stress monitoring products at 5-km resolution, including sea surface temperature (SST), HotSpot, and Degree
# Heating Week (DHW). These data are based on CoralTemp Version 1.0, a daily global 5-km sea surface temperature
# dataset combined from: (1.) NOAA/NESDIS operational near-real-time daily global 5-km geostationary-polar-orbiting
# (geo-polar) blended night-only SST analysis, (2.) NOAA/NESDIS 2002-2016 reprocessed daily global 5-km geo-polar
# blended night-only SST analysis, and (3.) United Kingdom Met Office 1985-2002 daily global 5-km night-only SST
# reanalysis of Operational SST and Sea Ice Analysis (OSTIA).

# Date range: 1986-01-01 to 2021-12-01

## function requires:
# coords: path for .xlsx file with coordinates. Requires two columns (Longitude and Latitude, any other columns are fine) and data in decimal degrees
# startdate: beginning date in "yyyy-mm" format - leave blank for full dataset
# enddate: end date in "yyyy-mm" format - leave blank for full dataset
# savefile: path for saving file as a csv (for example "oman data" -filename automaticaly added)

## function outputs a csv with: | date |	year | SST | lon | lat | grid.lon | grid.lat |
## grid.lon and grid.lat are the actual 0.05 degree gridcell coords matched from the NOAA CRW dataset





extract_noaa_pts <- function(coords, startdate="1986-01", enddate="2021-12", savefile) {

  ## Use thredds to get the DatasetNode for the dhw_5km_monthly data:
  Top <- CatalogNode$new("https://pae-paha.pacioos.hawaii.edu/thredds/satellite.xml") # URL for NOAA Coral Reef Watch Degree Heating Week data
  DD <- Top$get_datasets() # Daily 5-km, Monthly 5-km
  dnames <- names(DD)
  dname <- dnames[length(dnames)]
  D <- DD[[dname]]

  ## THREDDS OPeNDAP file path
  dl_url <- file.path("https://pae-paha.pacioos.hawaii.edu/thredds/dodsC", D$url)
  dhw_5km_monthly <- nc_open(dl_url)

  ## extract Lon/Lat/Time and crs from nc file
  dhw_crs <- ncdf4::ncvar_get(dhw_5km_monthly, "crs") # Get crs, see https://www.e-education.psu.edu/geog862/node/1801
  dhw_lon <- ncdf4::ncvar_get(dhw_5km_monthly, "longitude") # Get longitude values
  dhw_lat <- ncdf4::ncvar_get(dhw_5km_monthly, "latitude") # Get latitude values
  dhw_time <- ncdf4::ncvar_get(dhw_5km_monthly, "time") # get time values
  dhw_time_index <- nc.get.time.series(dhw_5km_monthly, v = "time", time.dim.name = "time") # get time values in tidy format


  coordlist <- readxl::read_excel(coords)

  data <- foreach(i = 1:nrow(coordlist), .combine = "rbind") %do% {
    pts <- ncvar_get(dhw_5km_monthly,
      varid = "CRW_SST",
      verbose = FALSE,
      start = c(findInterval(coordlist$Longitude[i], dhw_lon), findInterval(coordlist$Latitude[i], sort(dhw_lat)), findInterval(as.PCICt(paste0(startdate, "-01 12:00:00"), cal = "proleptic_gregorian"), dhw_time_index)),
      count = c(1, 1, (findInterval(as.PCICt(paste0(enddate, "-01 12:00:00"), cal = "proleptic_gregorian"), dhw_time_index) -
        findInterval(as.PCICt(paste0(startdate, "-01 12:00:00"), cal = "proleptic_gregorian"), dhw_time_index)))
    )
    date.seq <- seq(
      to = as.PCICt(paste0(enddate, "-01 12:00:00"), cal = "proleptic_gregorian"),
      from = as.PCICt(paste0(startdate, "-01 12:00:00"), cal = "proleptic_gregorian"),
      length.out = findInterval(as.PCICt(paste0(enddate, "-01 12:00:00"), cal = "proleptic_gregorian"), dhw_time_index) -
        findInterval(as.PCICt(paste0(startdate, "-01 12:00:00"), cal = "proleptic_gregorian"), dhw_time_index)
    )

    df <- data.frame(
      date = as.character(date.seq),
      year = as.numeric(lubridate::year(ymd_hms(date.seq, tz = "UTC"))),
      month = as.numeric(lubridate::month(ymd_hms(date.seq, tz = "UTC"))),
      lon = coordlist$Longitude[i],
      lat = coordlist$Latitude[i],
      SST = pts,
      grid.lon = dhw_lon[findInterval(coordlist$Longitude[i], dhw_lon)],
      grid.lat = dhw_lat[findInterval(coordlist$Latitude[i], sort(dhw_lat))]
    )

    df
  }

  data

  write.csv(data, paste0(savefile, ".csv"))

  data
}


# example function for xlsx locations across the full time series
dataset1 <- extract_noaa_pts(coords = "Oman locations.xlsx", savefile = "oman_output_full")

# example function for xlsx locations across a subset of data
dataset2 <- extract_noaa_pts(coords = "Oman locations.xlsx", startdate = "2010-01", enddate = "2012-01", savefile = "oman_output")
