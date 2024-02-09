#' Distill ocean data
#'
#' DEVELOPMENT function to distill ocean data maps
#'
#'
#'
#' @param input input
#' @param var variable
#' @param group group factor
#' @param ... passes functions
#' @export


distill_ocean_data <- function(input, var, group="all", ...){

  if (group=="all"){

#    quo_column <- enquo(var)

    output <- input$data |>
      group_by(longitude, latitude) |>
      na.omit() |>
      summarise(!!quo_column := mean(var), na.rm = FALSE)
  }
  # daily
  # weekly
  # monthly
  # yearly

  return(output)

}


# library(data.table)
#
# distill_ocean_data <- function(input, group = "all", ...){
#   setDT(input) # Convert to data.table
#
#   if (group == "all"){
#     col_name <- names(input)[4]
#     output <- input[, .(
#       name = col_name,
#       mean_value = mean(get(col_name), na.rm = TRUE)
#     ), by = .(longitude, latitude)]
#   }
#   # daily
#   # weekly
#   # monthly
#   # yearly
#
#   return(as.data.frame(output)) # Convert back to data.frame
# }
