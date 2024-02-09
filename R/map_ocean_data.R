
#' Map ocean data
#'
#' DEVELOPMENT function to generate ocean data maps
#'
#'
#'
#' @param input input
#' @param color variable for map color
#' @param rows number of rows if faceted
#' @param ... passes functions
#' @export


map_ocean_data <- function(input, pal="RdBu", ...){

  # initialise data
  # saveRDS(rnaturalearth::ne_countries(type = "countries", scale=10), "data/map_countries.RDS")

  df <- input |> with(data) |> dplyr::arrange(time)
  df <- input |>  dplyr::arrange(time)

  lon_lims <- c(min(df$longitude), max(df$longitude))
  lat_lims <- c(min(df$latitude), max(df$latitude))

  df_sf <- stars::st_as_stars(df |> dplyr::select(-1))

  print(length(unique(df$time)))
  if(length(unique(df$time))==1){

  p <- ggplot2::ggplot() + ggplot2::theme_bw() +
    # ggplot2::geom_tile(data=df, ggplot2::aes(longitude, latitude, fill=par_einstein_m_2_day_1),
    #                    width=1.2, height=1.2, linewidth=0) +
    stars::geom_stars(data=df_sf) +
    ggplot2::geom_sf(data=map_countries |> st_transform(), fill="darkolivegreen3") +
    ggplot2::coord_sf(lon_lims, lat_lims, expand = FALSE) +
    ggplot2::scale_fill_distiller(palette = pal)

  } else {
  print("test")
}

  return(p)
}
