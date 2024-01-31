
# to do:
# sort out missing vals

animate_ocean_data <- function(filename, figurename = NULL, ...) {

### import csv/rds data
cat(paste0("importing data from ",filename,"\n"))
df.import <- readRDS(filename)
metadata <-  df.import |> dplyr::select(vars,vals) |> na.omit() # seperate metadata
df <- df.import |> dplyr::select(-vars,-vals) |> na.omit()  # seperate main data
datelabels <- levels(as.factor(df$date)) # create vector of dates for tmap

df <- df |> dplyr::mutate(date=(as.numeric(date))) |>
  dplyr::mutate(longitude=as.numeric(as.character(longitude))) |>
  dplyr::mutate(latitude=as.numeric(as.character(latitude))) |>
  dplyr::arrange(date, longitude, latitude)

df_shp <- reshape(df, timevar="date", idvar=c("longitude", "latitude"), direction="wide")

if(length(levels(as.factor(df_shp$longitude)))==1) {stop(cat("Error: too few gridcells selected to plot animation. \nTo visualise data re-run the extract_ocean_data() function and specify a 2x2 array of lon/lat gridcells) \n"))}
if(length(levels(as.factor(df_shp$latitude)))==1) {stop(cat("Error: too few gridcells selected to plot animation. \nTo visualise data re-run the extract_ocean_data() function and specify a 2x2 array of lon/lat gridcells \n"))}

sf_gbr <- stars::st_as_stars(df_shp, xlim = c(min(df$longitude), max(df$longitude)),  ylim = c(min(df$latitude), max(df$latitude)), projection = 4326) |> sf::st_set_crs(4326)
#sf::st_is_longlat(sf_gbr)

zmin<-floor(min(df[,4], na.rm=TRUE))
zmax<-ceiling(max(df[,4], na.rm=TRUE))
zstep<-((zmax-zmin)/12)

cat("Starting animation \n")

# render animation
data(World, package = "tmap")

#worldrn_m <- rnaturalearth::ne_coastline(scale = "medium", returnclass = "sf")
countriesrn_m <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") |>
   sf::st_make_valid() |>
   sf::st_set_crs(4326)

tmp_animation <- tmap::tm_shape(sf_gbr, projection = 4326) +
  tmap::tm_raster(
    style = "cont",
    breaks = seq(zmin,zmax,zstep),
    palette = "-RdBu",
    midpoint = NA,
    title = names(df[4]),
    alpha = 0.6,
    legend.is.portrait = FALSE) +
  tmap::tm_shape(countriesrn_m) +
  tmap::tm_polygons(fill="grey") + #tmap::tmap_options(check.and.fix = sf::st_is_valid TRUE) +
  tmap::tm_facets(nrow = 1, ncol = 1, free.scales.fill = FALSE, free.scales.raster=FALSE, showNA=TRUE) +
  tmap::tm_layout(
    legend.title.size = 0.8,
    legend.text.size = 0.6,
    legend.height=0.35,
    legend.outside.position = "bottom",
    legend.outside.size = 0.15,
    legend.outside = TRUE,
    legend.position = c("centre","bottom"),
    panel.labels = datelabels,
    panel.label.bg.color = "white",
    frame.lwd = NA,
    frame = F) +
  tmap::tm_credits(
    text="http://github.com/marine-ecologist/rOceanData",
    size = 0.5,
    col = NA,
    alpha = 0.6,
    align = "left",
    bg.color = NA,
    bg.alpha = NA,
    fontface = NA,
    fontfamily = NA,
    position = c("centre", "bottom"),
    width = NA,
    just = NA)

#tmap::tmap_animation(tmp_animation, figurename, 2)

tmap::tmap_animation(tmp_animation, figurename, ...)




}
