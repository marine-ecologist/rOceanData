#' Export ocean data
#'
#' DEVELOPMENT function to export ocean data
#'
#'
#'
#' @param input input
#' @param output file format for output
#' @param ... passes functions
#' @export


export_ocean_data <- function(input, output, ...){

  write.csv(input, paste0(output,".csv"))

}
