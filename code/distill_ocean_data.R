
# spatial extent
# distill_ocean_data(filename = "spatial_extent_trial", summary="mean", timestep="annual")

# spatial points
# distill_ocean_data(filename = "spatial_points_trial", summary="mean", timestep="annual")


distill_ocean_data(filename = "caribbean_npp_jan2021", summary = "mean", timestep = "years")

# summary:
# "sum", "mean", "median", "modal", "which", "which.min", "which.max", "min", "max", "prod", "any", "all", "sd", "std", "first".

# index:
# years", "months", "yearmonths", "days", "week" (ISO 8601 week number), or "doy" (day of the year)

distill_ocean_data <- function(filename = NULL, dataset = "none", summary = "none", timestep = NULL) {

  filelist <- readRDS(paste0(filename, ".rds"))
  spatial_extent_raster <- terra::unwrap(filelist$spatial_extent_raster)
  spatial_extent_raster_summary <- terra::tapp(spatial_extent_raster, index = timestep, fun = mean)
  #names(spatial_extent_raster_summary) <- terra::time(spatial_extent_raster_summary)
  spatial_extent_raster_summary <- terra::wrap(spatial_extent_raster_summary)
  saveRDS(spatial_extent_raster_summary, paste0(filename,"-",summary,"-",timestep,".rds"))
}


