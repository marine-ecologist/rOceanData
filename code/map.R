library(stringr)
library(tidyverse)

sites <- read.csv("/Users/rof011/rOceanData/datasets/collections_output_turbs.csv") |>
  filter(str_detect(sample_id, "AU18")) |>
  mutate(subregion = if_else(area == "Moreton", "seQLD", subregion)) |>
  mutate(subregion_ordered = factor(subregion, levels =  c("sGBR", "seQLD", "nNSW", "cNSW")))

library(sf)
sites_sf <- st_as_sf(sites, coords=c("longitude", "latitude"), crs=4326)


### map
library(tmap)
library(rnaturalearth)
library(httr)
library(ows4R)

# get countries and coastlines
ausmapcoastlines <- ne_coastline(returnclass="sf", scale="large")
ausmapstates <- ne_countries(country="Australia", returnclass="sf")
ausmap <- ne_countries(country="Australia", returnclass="sf", scale="large")

# get Australian coastlines
xmin = 150; xmax = 155; ymin = -32; ymax = -22
deacl_annualshorelines = "https://geoserver.dea.ga.gov.au/geoserver/wfs?service=WFS&version=1.1.0&request=GetFeature&typeName=dea:shorelines_annual&maxFeatures=1000&bbox={ymin},{xmin},{ymax},{xmax},urn:ogc:def:crs:EPSG:4326" %>%
  glue::glue() %>%
  sf::read_sf() %>%
  sf::st_set_crs(4326)

# get Australian internal borders
ausgeo <- "https://services.ga.gov.au/gis/services/AustraliasLandBorders/MapServer/WFSServer"
ausgeo_client <- WFSClient$new(ausgeo, serviceVersion = "2.0.0")
land_borders <- ausgeo_client$getFeatures(typeName = "AustraliasLandBorders:Land_Borders") |> st_transform(4326)

# OISST
library(terra)
library(tidyterra)

OISST_map <- extract_ocean_data(dataset="ncdcOisst2Agg[sst]", space = c(150, 155,  -32, -22), time = c("2015-01-01", "2020-01-01"))
OISST_map_mean <- OISST_map$data |>
  group_by(longitude, latitude) |>
  summarise(SST=mean(sst_degree_c)) |>
  rast(type="xyz", crs="EPSG:4326")

saveRDS(OISST_map_mean, "datasets/OISST_map_mean.RDS")

MUR_map <- extract_ocean_data(dataset="jplMURSST41mday[sst]", space = c(150, 155,  -32, -22), time = c("2015-01-01", "2020-01-01"))
MUR_map_mean <- MUR_map$data |>
  group_by(longitude, latitude) |>
  summarise(SST=mean(sst_degree_c)) |>
  rast(type="xyz", crs="EPSG:4326")

saveRDS(MUR_map_mean, "datasets/MUR_map_mean.RDS")


# # map with tmap
# tmap_mode("plot")
#
# ausmap_crop <- st_crop(ausmap, st_bbox(MUR_map_mean))
# land_borders_crop <- st_crop(land_borders, st_bbox(MUR_map_mean))
# coralreefdist_crop <- st_crop(coralreefdist, st_bbox(MUR_map_mean))
#
# ##
# SSTmap <- tm_shape(MUR_map_mean, is.master=TRUE,  name="") +
#     tm_raster(pal="-RdBu",  title="", style= "cont")
# map <- tm_shape(ausmap) +
#     tm_polygons(fill="darkolivegreen2") +
#   tm_shape(land_borders) +
#     tm_lines(lwd=0.5)
# sites <- tm_shape(sites_sf) +
#     tm_dots("subregion", legend.show=TRUE, shape=21, size=0.4)
#
#
# SSTmap + map + sites +
#   tm_layout(title = "MUR SST", title.size = 0.75,legend.outside = TRUE,
#             legend.outside.position = c("left", "top"))
#
#
# ### cNSW st_bbox(sites_sf |> filter(subregion=="cNSW"))
#
# cNSW <- tm_basemap(leaflet::providers$Stamen.Watercolor) +
#   tm_shape(MUR_map_mean,  name="") +
#   tm_raster(pal="-RdBu",  title="", style= "cont", legend.show=FALSE) +
#   tm_shape(ausmap,is.master=TRUE,  bbox = c(153, -30.4,  153.5, -29.8)) +
#   tm_polygons(fill="darkolivegreen2") +
#   tm_shape(land_borders) +
#   tm_lines(lwd=0.5) +
#   # tm_shape(coralreefdist) +
#   #    tm_polygons(fill="darkorange4") +
#   tm_shape(sites_sf) +
#     tm_dots("subregion", legend.show=FALSE, shape=21, size=0.4) +
#     tm_text("site", xmod=1, ymod=0.4, remove.overlap=FALSE) +
#   tm_layout(title = "MUR SST", title.size = 0.75,legend.outside = TRUE,
#             legend.outside.position = c("left", "top"))
#
# ### nNSW st_bbox(sites_sf |> filter(subregion=="nNSW"))
#
# nNSW <- tm_basemap(leaflet::providers$Stamen.Watercolor) +
#   tm_shape(MUR_map_mean,  name="") +
#     tm_raster(pal="-RdBu",  title="", style= "cont", legend.show=FALSE) +
#   tm_shape(ausmap,is.master=TRUE,  bbox = c(153.6, -28.65,  153.7, -28.55)) +
#     tm_polygons(fill="darkolivegreen2") +
#   tm_shape(land_borders) +
#     tm_lines(lwd=0.5) +
#   # tm_shape(coralreefdist) +
#   #    tm_polygons(fill="darkorange4") +
#   tm_shape(sites_sf) +
#     tm_text("site", xmod=1.5, ymod=0.4, remove.overlap=FALSE) +
#     tm_dots("subregion", legend.show=FALSE, shape=21, size=0.4) +
#   tm_layout(title = "", title.size = 0.75,legend.outside = TRUE,
#             legend.outside.position = c("left", "top"))
#
#
# ### seQLD st_bbox(sites_sf |> filter(subregion=="seQLD"))
#
# seQLD <- tm_basemap(leaflet::providers$Stamen.Watercolor) +
#   tm_shape(MUR_map_mean,  name="") +
#   tm_raster(pal="-RdBu",  title="", style= "cont", legend.show=FALSE) +
#   tm_shape(ausmap,is.master=TRUE,  bbox = c(153, -27.8,  153.9, -26.5)) +
#   tm_polygons(fill="darkolivegreen2") +
#   tm_shape(land_borders) +
#   tm_lines(lwd=0.5) +
#   # tm_shape(coralreefdist) +
#   #    tm_polygons(fill="darkorange4") +
#   tm_shape(sites_sf) +
#   tm_text("site", xmod=1.5, ymod=0.4, remove.overlap=FALSE) +
#   tm_dots("subregion", legend.show=FALSE, shape=21, size=0.4) +
#   tm_layout(title = "", title.size = 0.75,legend.outside = TRUE,
#             legend.outside.position = c("left", "top"))
#
#
# ### sGBR st_bbox(sites_sf |> filter(subregion=="sGBR"))
#
#
# sGBR <- tm_basemap(leaflet::providers$Stamen.Watercolor) +
#   tm_shape(MUR_map_mean,  name="") +
#   tm_raster(pal="-RdBu",  title="", style= "cont", legend.show=FALSE) +
#   tm_shape(ausmap,is.master=TRUE,  bbox = c(150.7, -24.6,  153.5, -22.9)) +
#   tm_polygons(fill="darkolivegreen2") +
#   tm_shape(land_borders) +
#   tm_lines(lwd=0.5) +
#   tm_shape(coralreefdist_crop) +
#       tm_polygons(fill="darkorange4") +
#       # tm_borders(col="black", lwd=0.1) +
#   tm_shape(sites_sf) +
#   tm_text("site", xmod=1.5, ymod=0.4, remove.overlap=FALSE) +
#   tm_dots("subregion", legend.show=FALSE, shape=21, size=0.4) +
#   tm_layout(title = "", title.size = 0.75,legend.outside = TRUE,
#             legend.outside.position = c("left", "top"))
#
# sGBR
#
#
# tmap_arrange(sGBR, seQLD, nNSW, cNSW, nrow=2)

### ggplot

library(patchwork)
library(tidyterra)
library(lubridate)
library(scales)


### functions
compare_ratio <- function(xlim, ylim) {
  x_range <- abs(xlim[2] - xlim[1])
  y_range <- abs(ylim[2] - ylim[1])
  return(x_range / y_range)
}

st_insetbox <- function(xlim, ylim) {
  if(length(xlim) != 2 || length(ylim) != 2) {
    stop("xlim and ylim must each have exactly two elements.")
  }
  points <- matrix(c(xlim[1], ylim[1],
                     xlim[2], ylim[1],
                     xlim[2], ylim[2],
                     xlim[1], ylim[2],
                     xlim[1], ylim[1]),
                   ncol = 2, byrow = TRUE)
  polygon <- st_polygon(list(points))
  sfc_polygon <- st_sfc(polygon, crs = 4326)
  return(sfc_polygon)
}

# limits


# main map
main <- ggplot() + theme_bw() +
  geom_spatraster(data=MUR_map_mean, show.legend=TRUE) +
  geom_sf(data=ausmap_crop, show.legend=FALSE) +
  geom_sf(data=land_borders_crop, linewidth=0.1) +
  geom_sf(data=sites_sf, aes(color=subregion), fill=NA, show.legend=TRUE) +
  geom_sf(data=st_insetbox(xlim=c(152.9, 153.8), ylim=c(-30.4, -29.8)), fill=NA, color="darkred", lwd=0.3) +
  geom_sf(data=st_insetbox(xlim=c(153.5, 153.755), ylim=c(-28.7, -28.53)), fill=NA, color="darkred", lwd=0.3) +
  geom_sf(data=st_insetbox(xlim=c(152.7, 154.4), ylim=c(-27.78, -26.65)), fill=NA, color="darkred", lwd=0.3) +
  geom_sf(data=st_insetbox(xlim=c(150.4, 153.4), ylim=c(-24.6, -22.54)), fill=NA, color="darkred", lwd=0.3) +
  geom_text(aes(x=150.55, y=-22.75, label="a"), size=4.5) +
  geom_text(aes(x=152.86, y=-26.82, label="b"), size=4.5) +
  geom_text(aes(x=153.4, y=-28.36, label="c"), size=4.5) +
  geom_text(aes(x=153.05, y=-29.95, label="d"), size=4.5) +
  geom_text(aes(x=151, y=-28, label="Queensland"), size=3, color="grey40") +
  geom_text(aes(x=151.2, y=-30, label="New South Wales"), size=3, color="grey40") +
  #scale_fill_distiller(palette="RdBu") +
  scale_fill_gradient2(midpoint=24, low = muted("blue"), mid = "white", high = muted("red")) +
  scale_color_manual(values=c("darkred", "darkorange4", "darkgrey", "darkblue"), na.value = "transparent") +
  coord_sf(xlim=c(150.25, 154.8), ylim=c(-31.5, -22.5)) + ylab("") + xlab("") +
  theme(legend.position="left")


cNSW <- ggplot() + theme_bw() +
  geom_spatraster(data=MUR_map_mean, show.legend=FALSE) +
  geom_sf(data=ausmap_crop) +
  geom_sf(data=land_borders_crop, linewidth=0.1) +
  geom_sf(data=sites_sf, aes(color=subregion), show.legend=FALSE) +
  geom_text(aes(x=153.12, y=-29.8, label="d) Central New South Wales"), size=4) +
  scale_fill_gradient2(midpoint=24, low = muted("blue"), mid = "white", high = muted("red")) +
  #scale_fill_distiller(palette="RdBu", na.value="transparent") +
  scale_color_manual(values=c("darkred", "darkorange4", "darkgrey", "darkblue")) +
  coord_sf(xlim=c(152.9, 153.8), ylim=c(-30.4, -29.8)) +  ylab("") + xlab("")

#compare_ratio(xlim=c(152.9, 153.8), ylim=c(-30.4, -29.8))

nNSW <- ggplot() + theme_bw() +
  geom_spatraster(data=MUR_map_mean, show.legend=FALSE) +
  geom_sf(data=ausmap_crop) +
  geom_sf(data=land_borders_crop, linewidth=0.1) +
  geom_sf(data=sites_sf, aes(color=subregion), show.legend=FALSE) +
  geom_text(aes(x=153.565, y=-28.53, label="c) Northern New South Wales"), size=4) +
  scale_fill_gradient2(midpoint=24, low = muted("blue"), mid = "white", high = muted("red")) +
  #scale_fill_distiller(palette="RdBu", na.value="transparent") +
  scale_color_manual(values=c("darkred", "darkorange4", "darkgrey", "darkblue")) +
  coord_sf(xlim=c(153.5, 153.755), ylim=c(-28.7, -28.53)) +  ylab("") + xlab("")

seQLD <- ggplot() + theme_bw() +
  geom_spatraster(data=MUR_map_mean, show.legend=FALSE) +
  geom_sf(data=ausmap_crop) +
  geom_sf(data=land_borders_crop, linewidth=0.1) +
  geom_sf(data=sites_sf, aes(color=subregion), show.legend=FALSE) +
  geom_text(aes(x=153.07, y=-26.65, label="b) South-east Queensland"), size=4) +
  scale_fill_gradient2(midpoint=24, low = muted("blue"), mid = "white", high = muted("red")) +
  #scale_fill_distiller(palette="RdBu", na.value="transparent") +
  scale_color_manual(values=c("darkred", "darkorange4", "darkgrey", "darkblue")) +
  coord_sf(xlim=c(152.7, 154.4), ylim=c(-27.78, -26.65)) +  ylab("") + xlab("")

sGBR <- ggplot() + theme_bw() +
  geom_spatraster(data=MUR_map_mean, show.legend=FALSE) +
  geom_sf(data=ausmap_crop) +
  geom_sf(data=land_borders_crop, linewidth=0.1) +
  geom_sf(data=sites_sf, aes(color=subregion), show.legend=FALSE) +
  geom_text(aes(x=151.2, y=-22.55, label="a) Southern Great Barrier Reef"), size=4) +
  scale_fill_gradient2(midpoint=24, low = muted("blue"), mid = "white", high = muted("red")) +
  #scale_fill_distiller(palette="RdBu", na.value="transparent") +
  scale_color_manual(values=c("darkred", "darkorange4", "darkgrey", "darkblue")) +
  coord_sf(xlim=c(150.4, 153.4), ylim=c(-24.6, -22.54)) +  ylab("") + xlab("")

layout <- '
ABC
ADE
'
fig_map <- wrap_plots(A = main,
           B = sGBR,
           C = seQLD,
           D = nNSW,
           E = cNSW, design = layout)


ggsave(fig_map, filename="figmap.png", width=16, height=10)



### get more data ----

PAR_map <- extract_ocean_data(dataset="erdMH1par0mday[par]", space = c(150, 155,  -32, -22), time = c("2015-01-01", "2020-01-01"))
k490_map <- extract_ocean_data(dataset="erdMH1kd490mday[k490]", space = c(150, 155,  -32, -22), time = c("2015-01-01", "2020-01-01"))
chl_map <- extract_ocean_data(dataset="erdMH1chlamday[chlorophyll]", space = c(150, 155,  -32, -22), time = c("2015-01-01", "2020-01-01"))

saveRDS(PAR_map, "datasets/PAR_map.RDS")
saveRDS(k490_map, "datasets/k490_map.RDS")
saveRDS(chl_map, "datasets/chl_map.RDS")

PAR_map_mean <- PAR_map$data |>
  group_by(longitude, latitude) |>
  summarise(PAR=mean(par_einstein_m_2_day_1))

k490_map_mean <- k490_map$data |>
  group_by(longitude, latitude) |>
  summarise(k490=mean(k490_m_1))

chl_map_mean <- chl_map$data |>
  group_by(longitude, latitude) |>
  summarise(k490=mean(k490_m_1))


coremap_PAR_map_winter <- ggplot() + theme_bw() +
  geom_tile(data=PAR_map_mean, aes(longitude, latitude, fill=PAR), show.legend=TRUE) +
  geom_sf(data=ausmap_crop) +
  geom_sf(data=land_borders_crop, linewidth=0.1) +
  geom_sf(data=sites_sf, aes(color=subregion), show.legend=FALSE) +
  scale_fill_gradient2(midpoint=43, low = muted("purple"), mid = "white", high = muted("green")) +
  scale_color_manual(values=c("darkred", "darkorange4", "darkgrey", "darkblue")) +
  ylab("") + xlab("")

nNSW_PAR <- coremap_PAR_map_winter + coord_sf(xlim=c(152.9, 153.8), ylim=c(-30.4, -29.8))
cNSW_PAR <- coremap_PAR_map_winter + coord_sf(xlim=c(153.5, 153.755), ylim=c(-28.7, -28.53))
seQLD_PAR <- coremap_PAR_map_winter + coord_sf(xlim=c(152.7, 154.4), ylim=c(-27.78, -26.65))
sGBR_PAR <- coremap_PAR_map_winter + coord_sf(xlim=c(150.4, 153.4), ylim=c(-24.6, -22.54))



MUR_map_summer <- MUR_map$data |>
  mutate(month=month(time)) |>
  filter(month %in% c(12,1,2)) |>
  group_by(longitude, latitude) |>
  summarise(SST=mean(sst_degree_c)) |>
  rast(type="xyz", crs="EPSG:4326")

MUR_map_winter <- MUR_map$data |>
  mutate(month=month(time)) |>
  filter(month %in% c(6,7,8)) |>
  group_by(longitude, latitude) |>
  summarise(SST=mean(sst_degree_c)) |>
  rast(type="xyz", crs="EPSG:4326")


coremap_MUR_map_winter <- ggplot() + theme_bw() +
  geom_spatraster(data=MUR_map_winter, show.legend=FALSE) +
  geom_sf(data=ausmap_crop) +
  geom_sf(data=land_borders_crop, linewidth=0.1) +
  geom_sf(data=sites_sf, aes(color=subregion), show.legend=FALSE) +
  scale_fill_gradient2(midpoint=24, low = muted("blue"), mid = "white", high = muted("red")) +
  scale_color_manual(values=c("darkred", "darkorange4", "darkgrey", "darkblue")) +
  ylab("") + xlab("") +
  coord_sf(xlim=c(150.25, 154.8), ylim=c(-31.5, -22.5))

nNSW_winter <- coremap_MUR_map_winter + coord_sf(xlim=c(152.9, 153.8), ylim=c(-30.4, -29.8))
cNSW_winter <- coremap_MUR_map_winter + coord_sf(xlim=c(153.5, 153.755), ylim=c(-28.7, -28.53))
seQLD_winter <- coremap_MUR_map_winter + coord_sf(xlim=c(152.7, 154.4), ylim=c(-27.78, -26.65))
sGBR_winter <- coremap_MUR_map_winter + coord_sf(xlim=c(150.4, 153.4), ylim=c(-24.6, -22.54))


coremap_MUR_map_summer <- ggplot() + theme_bw() +
  geom_spatraster(data=MUR_map_summer, show.legend=FALSE) +
  geom_sf(data=ausmap_crop) +
  geom_sf(data=land_borders_crop, linewidth=0.1) +
  geom_sf(data=sites_sf, aes(color=subregion), show.legend=FALSE) +
  #scale_fill_distiller(palette="RdBu", na.value="transparent") +
  scale_fill_gradient2(midpoint=24, low = muted("blue"), mid = "white", high = muted("red")) +
  scale_color_manual(values=c("darkred", "darkorange4", "darkgrey", "darkblue")) +
  ylab("") + xlab("") +
  coord_sf(xlim=c(150.25, 154.8), ylim=c(-31.5, -22.5))

nNSW_summer <- coremap_MUR_map_summer + coord_sf(xlim=c(152.9, 153.8), ylim=c(-30.4, -29.8))
cNSW_summer <- coremap_MUR_map_summer + coord_sf(xlim=c(153.5, 153.755), ylim=c(-28.7, -28.53))
seQLD_summer <- coremap_MUR_map_summer + coord_sf(xlim=c(152.7, 154.4), ylim=c(-27.78, -26.65))
sGBR_summer <- coremap_MUR_map_summer + coord_sf(xlim=c(150.4, 153.4), ylim=c(-24.6, -22.54))

fig_params <- (sGBR_summer + seQLD_summer + cNSW_summer + nNSW_summer +
              sGBR_winter + seQLD_winter + cNSW_winter + nNSW_winter +
              sGBR_PAR + seQLD_PAR + cNSW_PAR + nNSW_PAR) +
              plot_layout(ncol = 4)


ggsave(fig_params, filename="fig_params.png", width=16, height=10)



SSTmap <- (main + coremap_MUR_map_summer + coremap_MUR_map_winter) + plot_layout(ncol = 4)
ggsave(SSTmap, filename="SSTmap.png", width=16, height=10)

