
sites <- "/Users/rof011/rOceanData/datasets/testdata.xlsx"
k490 <- extract_ocean_data(dataset="erdMH1kd490mday[k490]", space = sites, time = c("2003-01-01", "2003-04-01"))
MUR <- extract_ocean_data(dataset="jplMURSST41mday[sst]", space = sites, time = c("2003-01-01", "2024-01-01"))


parspace <- extract_ocean_data(dataset="erdMH1par0mday[par]", space = c(-23, 23.3, 151.1, 150.9), time = c("2004-06-14")) # add single option



k490 <- extract_ocean_data(dataset="erdMH1kd490mday[k490]", space = sites, time = c("2003-01-01", "2003-01-01"))

par <- extract_ocean_data(dataset="erdMH1par0mday[par]", space = sites, time = c("2003-01-01", "2024-01-01"))
chl <- extract_ocean_data(dataset="erdMH1chlamday[chlorophyll]", space = sites, time = c("2003-01-01", "2024-01-01"))
MUR <- extract_ocean_data(dataset="jplMURSST41mday[sst]", space = sites, time = c("2003-01-01", "2024-01-01"))
MURanomalies <- extract_ocean_data("dataset=jplMURSST41anommday[sstAnom]", space = sites, time = c("2003-01-01", "2024-01-01"))



par <- extract_ocean_data(space = sites, time = c("2003-01-01", "2024-01-01"))



parspace <- extract_ocean_data(dataset="erdMH1par0mday[par]", space = c(-23, 23.3, 151.1, 150.9), time = c("2004-06-14")) # add single option


extract_ocean_data() |>
  distil_ocean_data(group="mean", by="month*year") |>
  map_ocean_data()
