
#rOceanData - simple functions to extract satellite data for global oceans

# six main functions
extract_ocean_data()
# call rerddap::griddap to extract the data
# datasetx = dataset from rerddap list
# fmt = nc or csv
# df.nc <- griddap(sstInfo, fmt="csv", longitude = c(142, 155), latitude = c(-25, -9),
                 time = c('2015-01-01','2016-12-31'), fields = 'CRW_DHW')

map_ocean_data()

animate_ocean_data()

interactive_ocean_data()

export_ocean_data()

# pipe into heatwaveR
