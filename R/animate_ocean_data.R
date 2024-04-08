
#' Animate ocean data
#'
#' DEVELOPMENT function to animate ocean data maps
#'
#'
#'
#' @param input input
#' @param color variable for color
#' @param ... passes functions
#' @export

animate_ocean_data <- function(input, color="SST", ...){

  sf::sf_use_s2(FALSE)

  ne_coastline <- rnaturalearth::ne_countries(returnclass="sf", scale="large") |> dplyr::select(1)
  terrafile <- terra::rast(input |> as.data.frame() |>  dplyr::select(-time), type="xyz", crs=terra::crs(ne_coastline))

  terrafile <- terra::rast(input |> as.data.frame() |>  dplyr::select(-time), type="xyz", crs=terra::crs(ne_coastline))


  if (color=="SST"){
    colorrast="RdBU"
  }

  else if (color=="chlorophyll"){
    colorrast="YlGnBu"
  }

  else{
    print("Choose one of the rColorBrewer palettes")
    RColorBrewer::display.brewer.all()
    colorrast <- readline(prompt = "Select a dataset:")

#
#
#     # lizard_SST <- extract_ocean_data2(dataset="jplMURSST41",
#     #                                     space = c(145.3, 145.6, -14.4, -14.9),
#     #                                       time = c("2024-02-01", "2024-03-03"))
#
#
#     lizard_SST_day <- lizard_SST |>
#       as.data.frame() |>
#       dplyr::select(time, longitude, latitude, analysed_sst)# |> as_spatraster(xycols=3:2, crs="EPSG:4326")
#
#     time_groups <- split(lizard_SST_day, lizard_SST_day$time)
#
#     lizard_rasts <- NULL
#     for (i in 1:length(time_groups)){
#       lizard_rasts[[i]] <- as_spatraster(as.data.frame(time_groups[i]) |> select(-1), xycols = c(1, 2),  crs = "EPSG:4326")
#     }
#
#     r <- rast(lizard_rasts)
#     names(r) <- as.character(unique(lizard_SST_day$time))
#     r <- st_as_stars(r)
#     lizard <- st_read("/Users/rof011/rOceanData/code/Benthic-Map/benthic.geojson")
#
#
#     library(tmap)
#     # Visualize raster layers with facets
#     combined_animation <- tm_shape(r) +
#       tm_raster(palette="Reds") +
#       tm_shape(lizard) +
#       tm_polygons(border.col = "black", border.lwd=0.01, alpha=0.2) +
#       tm_facets(nrow=1, ncol=length(r), free.coords=FALSE, free.scales=FALSE) +
#       tmap_options(max.categories=1000, show.messages=FALSE)
#
#     tmap_animation(
#       combined_animation,
#       filename = "combined_animation.gif",
#       width = 1200,
#       height = 800,
#       delay = 30,
#       fps =  5,
#       loop = TRUE
#     )
#
  }



  tmap::tm_view() +
    tmap::tm_shape(terrafile, is.master=TRUE) +
    tmap::tm_raster( fill.scale = tmap::tm_scale_intervals(values = colorrast)) +
    tmap::tm_shape(ne_coastline) +
    tmap::tm_borders("black", lwd=1) +
    tmap::tmap_options(check.and.fix=TRUE) +
    tmap::tm_facets("time")


}
