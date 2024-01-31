
library(rerddap)
library(ggplot2)

# set longitude extent:
longitude.extent <- c(-100, 100)
latitude.extent <- c(0, 50)

### get Oisst in -180 to 180 from griddap
Oisst180 <- griddap("ncdcOisst21Agg_LonPM180", fmt = "nc", longitude = longitude.extent, latitude = latitude.extent, time = c("last", "last"))
Oisst180.sst <- Oisst180$data |>
  arrange(longitude, latitude) |>
  select(longitude, latitude, sst, time) |>
  as.data.frame()
Oisst180.sst$longitude <- as.numeric(Oisst180.sst$longitude)
Oisst180.sst$latitude <- as.numeric(Oisst180.sst$latitude)

ggplot() +
  coord_fixed(1.1) +
  theme_bw() +
  geom_raster(data = Oisst180.sst, aes(x = longitude, y = latitude, fill = sst), interpolate = FALSE) +
  scale_fill_gradientn(colours = colors$temperature, na.value = NA, limits = c(-3, 30), name = "temperature") +
  ylab("latitude") +
  xlab("longitude") +
  ggtitle(paste0("Latest OISST sea surface temperature (", unique(Oisst180.sst$time)[1], ")"))

### get Oisst in 0 to 360 from griddap, fails with:
# Oisst360 <- griddap("ncdcOisst21Agg", fmt = "nc", longitude = c(longitude.extent, latitude.extent), latitude = c(0, 50), time = c("last", "last"))
# so i) convert the input longitude values of longitude.extent from -180 to 180 to 0 to 360
# ii) get data,
# iii) convert data back to -180 to 180

# get information from ERDDAP dataset and extract xlims, set xmin and xmax
x <- info("ncdcOisst21Agg")
xlims <- (subset(x$alldata$longitude, attribute_name == "actual_range", "value")$value)
xlims.split <- strsplit(xlims, ",")[1]
xmin <- as.numeric(xlims.split[[1]][1])
xmax <- as.numeric(xlims.split[[1]][2])

# reformat input longitude for 0-360 by splitting into two datasets along the meridian:
# i.e. -100, 100 becomes 0-100 and 260-360.
# as 0 and 360 fall outside of the boundaries of the dataset, replace with xmin and xmax extracted above
longitude.extent.b <- c(360 + longitude.extent[1], xmax)
longitude.extent.a <- c(xmin, longitude.extent[2])

# get data for both extents with griddap with correct extent:
Oisst360b <- griddap("ncdcOisst21Agg", fmt = "nc", longitude = longitude.extent.b, latitude = latitude.extent, time = c("last", "last"))
Oisst360a <- griddap("ncdcOisst21Agg", fmt = "nc", longitude = longitude.extent.a, latitude = latitude.extent, time = c("last", "last"))

# reconvert data output BACK from 0 to 360 from -180 to 180 and merge
Oisst360b.data <- Oisst360b$data # get data.frame b
Oisst360b.data$longitude <- Oisst360b.data$longitude - 360
Oisst360a.data <- Oisst360a$data # get data.frame a
Oisst.merged <- rbind(Oisst360a.data, Oisst360b.data) # merge dataframes
Oisst.merged.sst <- Oisst.merged |>
  arrange(longitude, latitude) |>
  select(longitude, latitude, sst, time) #|> na.omit()

# visually assess plot
ggplot() +
  coord_fixed(1.1) +
  theme_bw() +
  geom_raster(data = Oisst.merged.sst, aes(x = longitude, y = latitude, fill = sst), interpolate = FALSE) +
  scale_fill_gradientn(colours = colors$temperature, na.value = NA, limits = c(-3, 30), name = "temperature") +
  ylab("latitude") +
  xlab("longitude") +
  ggtitle(paste0("Latest OISST sea surface temperature (", unique(Oisst.merged.sst$time)[1], ")"))

# compare both datasets
identical(Oisst180.sst, Oisst.merged.sst)
