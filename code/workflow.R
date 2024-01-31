
#rOceanData - simple functions to extract satellite data for global oceans

# six main functions
#extract_ocean_data()
# Simple function to extract satellite data for oceans.
# extract_ocean_data leverages griddap() from the rerdapp package to Get ERDDAP
# gridded data, the get_raster() function from the plotdap() package to convert
# the nc files to raster format, and tapp from the terra package to calculate
# summary statistics across layers of the raster.

extract_ocean_data(space="", time="", filename="")

# call rerddap::griddap to extract the data
# dataset = dataset from rerddap list
# fmt = nc or csv
# df.nc <- griddap(sstInfo, fmt="csv", longitude = c(142, 155), latitude = c(-25, -9),
                 time = c('2015-01-01','2016-12-31'), fields = 'CRW_DHW')

distill_ocean_data()

# csv, xls, xlsx for raw data
# geotiff, kml for raster data

export_ocean_data(export="csv")

map_ocean_data()

animate_ocean_data()

interactive_ocean_data()

export_ocean_data()

# pipe into heatwaveR
