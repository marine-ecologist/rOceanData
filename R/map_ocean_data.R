
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

  df <- input

  lon_lims <- c(min(df$longitude), max(df$longitude))
  lat_lims <- c(min(df$latitude), max(df$latitude))

  input_sf <- stars::st_as_stars(df |> dplyr::select(-3))

  facet_column <- NULL
  if ("year" %in% names(input)) {
    facet_column <- "year"
  } else if ("month" %in% names(input)) {
    facet_column <- "month"
  } else if ("week" %in% names(input)) {
    facet_column <- "week"
  } else if ("day" %in% names(input)) {
    facet_column <- "day"
  }

  if (!is.null(facet_column)) {
    # Plot with dynamic faceting
    p <- ggplot2::ggplot() +
      ggplot2::theme_bw() +
      stars::geom_stars(data = input_sf) +
      ggplot2::geom_sf(data = map_countries %>%
                         sf::st_transform(), fill = "darkolivegreen3") +
      ggplot2::coord_sf(xlim = lon_lims, ylim = lat_lims, expand = FALSE) +
      ggplot2::scale_fill_distiller(palette = pal) +
      ggplot2::facet_wrap(as.formula(paste0("~ ", facet_column)), nrow = rows)  # Dynamic faceting
  } else {
    # Plot without faceting (single map)
    p <- ggplot2::ggplot() +
      ggplot2::theme_bw() +
      stars::geom_stars(data = input_sf) +
      ggplot2::geom_sf(data = map_countries %>%
                         sf::st_transform(), fill = "darkolivegreen3") +
      ggplot2::coord_sf(xlim = lon_lims, ylim = lat_lims, expand = FALSE) +
      ggplot2::scale_fill_distiller(palette = pal)
  }

  return(p)
}
