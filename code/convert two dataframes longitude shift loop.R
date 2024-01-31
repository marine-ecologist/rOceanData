
library(rerddap)
library(ggplot2)

# set longitude extent:
longitude.extent = c(-100, 50)
latitude.extent = c(5,30)
timerecent = c("last", "last")

this_dataset <- "ncdcOisst21Agg" #c(0.125, 359.875)
this_var <- "sst" 

#this_dataset <- "ncdcOisst21Agg_LonPM180" #c(-179.875, 179.875)
#this_dataset <- "ncdcOisst21Agg" #c(0.125, 359.875)
#this_dataset <- "NOAA_DHW" #c(0.125, 359.875)
#this_var <- "sst"


#extract_shift_data(dataset=dataset) { # function to extract data from 

x <- info(this_dataset)
xlims <- (subset(x$alldata$longitude, attribute_name == "actual_range", "value")$value)
xlims.split <- strsplit(xlims, ",")[1]
xmin <- as.numeric(xlims.split[[1]][1])
xmax <- as.numeric(xlims.split[[1]][2])

# if -180 to 180
if (xmin<0) {

### get Oisst in -180 to 180 from griddap
this_dataset_nc <- rerddap::griddap(this_dataset, fmt = "nc", longitude = longitude.extent, latitude = latitude.extent, time = c("2022-12-01", "2022-12-02"))
get_rast <- function(grid, var) {
    times <- grid$summary$dim$time$vals
    lats <- grid$summary$dim$latitude$vals
    lons <- grid$summary$dim$longitude$vals
    ylim <- range(lats, na.rm = TRUE)
    xlim <- range(lons, na.rm = TRUE)
    spatial.ext <- terra::ext(xlim[1], xlim[2], ylim[1], ylim[2])
    r <- if (length(times) > 1) {
        d <- dplyr::arrange(grid$data, time, desc(latitude), longitude)
        b <- terra::rast(
              nl = length(times),
              nrows = length(lats),
              ncols = length(lons))
      raster::values(b) <- lazyeval::f_eval(var, d)
      terra::ext(b) <- spatial.ext
      b
    } else {
        d <- dplyr::arrange(grid$data, desc(latitude), longitude)
        b <- terra::rast(
              nrows = length(lats),
              ncols = length(lons),
              ext = spatial.ext,
              vals = lazyeval::f_eval(var, d))
        b
    }

    names(r) <- paste0(as.character(unique(lubridate::ymd(as.Date((unique(grid$data$time)))))))
    terra::time(r) <- unique(lubridate::ymd(as.Date(names(r))))
         r
  }

this_dataset_nc <- get_rast(this_dataset_nc,  ~ this_var)

# ------------------------------------------------------------------------
# else if 0 to 360
# ------------------------------------------------------------------------

} else if (xmax>180) {


longitude.extent.b <- c(360 + longitude.extent[1] + xmin, xmax)
longitude.extent.a <- c(xmin, longitude.extent[2] + xmin)

Oisst360b <- griddap("ncdcOisst21Agg", fmt = "nc", longitude = c(260.125, 359.875), latitude = latitude.extent, time = c("2022-12-01", "2022-12-02"))
Oisst360a <- griddap("ncdcOisst21Agg", fmt = "nc", longitude = longitude.extent.a, latitude = latitude.extent, time = c("2022-12-01", "2022-12-02"))

Oisst360b_NC <- get_rast(Oisst360b,  ~ get(this_var)) # use get(this_var) with ~ f_eval
Oisst360a_NC <- get_rast(Oisst360a,  ~ get(this_var))

Oisst360_merged <- terra::merge(Oisst360b_NC, Oisst360a_NC)

# neither res match original...
#terra::res(Oisst360b_NC) <- round(terra::res(Oisst360b_NC),6)
#terra::res(Oisst360a_NC) <- round(terra::res(Oisst360a_NC),6)

Oisst360_merged <- terra::vrt(Oisst360b_NC, Oisst360a_NC)

# ext.b <- terra::ext(360 + longitude.extent[1], xmax, latitude.extent[1], latitude.extent[2])
# ext.a <- terra::ext(xmin, longitude.extent[2], xmax, latitude.extent[1], latitude.extent[2])




### get Oisst in 0 to 360 from griddap, fails with:
# Oisst360 <- griddap("ncdcOisst21Agg", fmt = "nc", longitude = c(longitude.extent, latitude.extent), latitude = c(0, 50), time = c("last", "last"))
# so i) convert the input longitude values of longitude.extent from -180 to 180 to 0 to 360
# ii) get data,
# iii) convert data back to -180 to 180


# reformat input longitude for 0-360 by splitting into two datasets along the meridian:
# i.e. -100, 100 becomes 0-100 and 260-360.
# as 0 and 360 fall outside of the boundaries of the dataset, replace with xmin and xmax extracted above
longitude.extent.b = c(360+longitude.extent[1], xmax)
longitude.extent.a = c(xmin, longitude.extent[2])

# get data for both extents with griddap with correct extent:
this_dataset_nc_data_b <- griddap(this_dataset, fmt = "nc", longitude = longitude.extent.b, latitude = latitude.extent, time = timerecent)
this_dataset_nc_data_a <- griddap(this_dataset, fmt = "nc", longitude = longitude.extent.a, latitude = latitude.extent, time = timerecent)

# reconvert data output BACK from 0 to 360 from -180 to 180 and merge
this_dataset_nc_data_b_data <- this_dataset_nc_data_b$data # get data.frame b
this_dataset_nc_data_b_data$longitude <- this_dataset_nc_data_b_data$longitude - 360
this_dataset_nc_data_a_data <- this_dataset_nc_data_a$data # get data.frame a
this_dataset_merged <- rbind(this_dataset_nc_data_a_data, this_dataset_nc_data_b_data) |> arrange(longitude, latitude) 

this_dataset_merged.subset <- this_dataset_merged |> select(longitude, latitude, time, get(this_var))

} else {
  print("Error in dataset extraction")

}
  



