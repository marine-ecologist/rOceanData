
#https://stackoverflow.com/questions/64626573/tmap-customize-continuous-legend-values-without-changing-scale

map_ocean_data <- function(filename, figurename = NULL, ncol = NULL, nrow = NULL, view = TRUE, width = 2400) {

### import csv/rds data

df <- readRDS(filename)
datelabels <- levels(as.factor(df$date))
df1 <- df |> dplyr::mutate(date=(as.numeric(date))) |>
      dplyr::mutate(longitude=as.numeric(as.character(longitude))) |>
      dplyr::mutate(latitude=as.numeric(as.character(latitude)))
df1_shp <- reshape(df1, timevar="date", idvar=c("longitude", "latitude"), direction="wide")
sf_gbr <- stars::st_as_stars(df1_shp, projection = 4326) %>%  sf::st_set_crs(4326)

# render map
tmp_map <- tmap::tm_shape(sf_gbr, projection = 4326) +
  tmap::tm_raster(
            style = "cont",
            palette="-RdBu",
            midpoint = NA,
            title = "vars",
            alpha=0.6) +
  tmap::tm_shape(World, projection = 4326) +
  tmap::tm_borders() +
  tmap::tm_layout(panel.labels = datelabels,
    panel.label.size=0.8)


tmap::tmap_save(tmp_map, figurename)



}
