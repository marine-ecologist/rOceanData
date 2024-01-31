
#CRW products
catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/RW/dhws/1day"

## MODIS products - $var[1] is palette, [2] is this_var
catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MPOC/mday" #Particulate Organic Carbon
catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MPIC/mday" #Particulate Inorganic Carbon
catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MH1/kd490/mday" # Diffuse Attenuation K490
catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MH1/chla/mday" # chla NPP
catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MH1/par/mday" #  Photosynthetically available radiation

catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/AI/icov/mday" # Ice Coverage, Aqua AMSR-E

catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/HadleyCenter/HadISST" # HadISST


dataset_nc <- ncdf4::nc_open(catalog_dataset_url)
ncdf4::ncatt_get(dataset_nc, varid = 0)$summary
ncdf4::ncatt_get(dataset_nc, varid = 0)$title
ncdf4::ncatt_get(dataset_nc, varid = 0)$id
names(dataset_nc$var)
names(dataset_nc$dim)



# extract time dimension from:

dataset_nc <- ncdf4::nc_open(catalog_dataset_url)

dataset_nc$dim$time$units # time since





data.frame(dataset = c(
"POC_MODIS_monthly",
"POC_MODIS_weekly",
"POC_MODIS_daily",
"PIC_MODIS_monthly",
"PIC_MODIS_weekly",
"PIC_MODIS_daily",
"K490_MODIS_monthly",
"K490_MODIS_weekly",
"K490_MODIS_daily",
"CHL_MODIS_monthly",
"CHL_MODIS_weekly",
"CHL_MODIS_daily",
"PAR_MODIS_monthly",
"PAR_MODIS_weekly",
"PAR_MODIS_daily",
"SST_CRW",
"SSTanom_CRW",
"SSThotspot_CRW",
"SSTdhw_CRW"),
  url = c(
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MPOC/mday",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MPOC/8day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MPOC/1day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MPIC/mday",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MPIC/8day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MPIC/1day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/kd490/mday",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/kd490/8day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/kd490/1day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/chla/mday",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/chla/8day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/chla/1day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/par/mday",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/par/8day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/MH1/par/1day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/RW/sstn/",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/RW/tanm/",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/RW/hots/1day",
"https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/satellite/RW/dhws/1day",
))



thisdataset <- function(dataset){
# CORAL REEF WATCH PRODUCTS ----
if (dataset == "CRW_SST") {
    assign(this_dataset) <- "Coral Reef Watch, SST nighttime, 50km, 1-day"
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
# HadISST ----
  } else if (dataset == "SST_HadISST") {
    this_dataset <- "HadISST 1.1 monthly average sea surface temperature"
    this_ndims <- 3
    this_correction <- 0
    this_var <- "sst"
    this_origin <- "1870-01-01"
    this_timestep <- "days"
    missing_data <- -1.00000001504747e+30
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/HadleyCenter/HadISST"
# OISST ----
  } else if (dataset == "SST_OISST") {
    this_dataset <- "OISST"
    this_ndims <- 3
    this_correction <- 180
    this_var <- "sst"
    this_origin <- "1800-1-1"
    this_timestep <- "days"
    catalog_dataset_url <- "https://www.psl.noaa.gov/thredds/dodsC/Datasets/noaa.oisst.v2.highres"
# MODIS PRODUCTS ----
    } else if (dataset == "CHL_MODIS_monthly") {
    this_dataset <- "Aqua Modis Chlorophyll Concentration monthly, 4.64 km resolution"
    this_ndims <- 3
    this_correction <- 0
    this_var <- "chlor_a"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data <- -32767.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MH1/chla/mday"
    } else if (dataset == "CHL_MODIS_weekly") {
    this_dataset <- "Aqua Modis Chlorophyll Concentration 8-day, 4.64 km resolution"
    this_ndims <- 3
    this_correction <- 0
    this_var <- "chlor_a"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data <- -32767.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MH1/chla/8day"
    } else if (dataset == "CHL_MODIS_daily") {
    this_dataset <- "Aqua Modis Chlorophyll Concentration 8-day, 4.64 km resolution"
    this_ndims <- 3
    this_correction <- 0
    this_var <- "chlor_a"
    this_origin <- "1970-01-01"
    this_timestep <- "seconds"
    missing_data <- -32767.0
    catalog_dataset_url <- "https://oceanwatch.pfeg.noaa.gov/thredds/dodsC/satellite/MH1/chla/1day"
    } else {
    stop(print("Incorrect dataset specification, see ?extract_ocean_data for options"))
  }

}
#assign(this_dataset,envir = globalenv())
#assign(this_ndims,envir = globalenv())
#  ,this_ndims,this_correction,this_var,this_origin,this_timestep,missing_data,catalog_dataset_url))




