# fix list:
# 1) sort tmap::tm_title bug
# 2)

library(tidyverse)


# single timepoint
df <- extract_ocean_data_2(dataset=5, space = c(70, 75, -2, 9), time = c("2010-01-01", "2010-01-01"))

df %>%
  map_ocean_data()



# multiple timepoints
df2 <- extract_ocean_data_2(dataset=5, space = c(70, 75, -2, 9), time = c("2010-01-01", "2010-06-01"))
df3 <- extract_ocean_data_2(dataset=8, space = c(144, 147, -16, -14), time = c("2020-01-01", "2020-12-31"))


df3 %>%
  map_ocean_data(rows=3)

library(sf)
library(httr)
library(ows4R)

wfs_bwk <- "https://allencoralatlas.org/geoserver/ows?service=wfs"
url <- parse_url(wfs_bwk)
url$query <- list(service = "wfs",
                  version = "2.0.0", # facultative
                  request = "GetCapabilities"
)
request <- build_url(url)
request

bwk_client <- WFSClient$new(wfs_bwk)


# install_github("r-tmap/tmap", force=TRUE)
# Sys.getenv("GITHUB_PAT")
# Sys.setenv(GITHUB_PAT="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")
# Sys.unsetenv("GITHUB_PAT")

check_ocean_data()
filter_ocean_data()

extract_ocean_data_2(dataset=1, space = c(70, 74, -2, 8), time = c("2010-01-01", "2010-04-01"))  %>%
  animate_ocean_data(color="chlorophyll")


tmap_animation(m1, delay=40)

# BIG LIST of stuff to do:
# example workflow:
#extract_oceandata(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent") |>
#  distill_oceandata(timestep="monthly", summarise="max") |>
#  map_oceandata(type="png")

# check https://furrr.futureverse.org to parallelise?
# get filesize for large files
# vectorise a loop for >2GB for big data

#

# adding two _ in a saveas crashes

# extract_ocean_data(space = "tmpcoords.csv", time = c("2010-01-01", "2010-02-01"), saveas = "temp", dataset = "NWW3_Global_Best[shgt]")
# load("temp.rda")
#
# # spatial extent
# extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent")
# extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent", dataset = "ncdcOisst21Agg_LonPM180[sst]")
# extract_ocean_data(space = c(-42, 40, 40, 42), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent", dataset = 17)
#
# # spatial points
# extract_ocean_data(space = "limitedsites.xlsx", time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialpoints")
# extract_ocean_data(space = "limitedsites.xlsx", time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialpoints", dataset = "ncdcOisst21Agg_LonPM180[sst]")
# extract_ocean_data(space = "limitedsites.xlsx", time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialpoints", dataset = 17)


extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent")
extract_ocean_data(space = c(72, 74, -2, 6), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent2", dataset = "ncdcOisst21Agg_LonPM180[sst]")
extract_ocean_data(space = c(-42, 40, 40, 42), time = c("2010-01-01", "2010-02-01"), saveas = "maldivesspatialextent", dataset = 17)
