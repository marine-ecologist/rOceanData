
#' Extract ocean data v0.1.0.9002
#'
#' DEVELOPMENT function to extract ocean data from satellites
#'
#'
#'
#' @param dataset either "none", or in the format "data_id\[dataval\]"
#' @param filename filename for saving
#' @param space either a four length numeric vector (xmin, xmax, ymin, ymax) or a csv/xlsx of sites containing lon and lat columns
#' @param time vector containing two time periods in YYYY-MM-DD format e.g. c("2003-01-01", "2024-01-01")
#' @param save_file TRUE/FALSE for saving output to RDS based on filename.
#' @param ... passes functions

#' @export

extract_ocean_data2 <- function(dataset = "none", space = NULL, time = NULL, metadata = TRUE, save_file = NULL, ...) {
  if (is.numeric(space) && length(space) == 4) {

    dat_dap <- griddap(dataset,
      longitude = space[1:2],
      latitude = space[3:4],
      time = time,
      fmt = "csv"
    )

  } else if (grepl(".*xlsx.*", space) == TRUE) {

    coordlist <- readxl::read_excel(space)

    final.data <- NULL
    for (i in 1:nrow(coordlist)) {
      coordstring <- c(coordlist[lon_columns][[1]][i], coordlist[lon_columns][[1]][i], coordlist[lat_columns][[1]][i], coordlist[lat_columns][[1]][i])

      dat_dap <- griddap(dataset,
        longitude = coordstring[1:2],
        latitude = coordstring[3:4],
        time = time,
        fmt = "csv"
      )
    }

  } else if (grepl(".*csv.*", space) == TRUE) {

    coordlist <- read.csv(space)

    dat_dap <- NULL
    for (i in 1:nrow(coordlist)) {
      coordstring <- c(coordlist[lon_columns][[1]][i], coordlist[lon_columns][[1]][i], coordlist[lat_columns][[1]][i], coordlist[lat_columns][[1]][i])

      griddap(dataset,
        longitude = coordstring[1:2],
        latitude = coordstring[3:4],
        time = time,
        fmt = "csv"
      )
    }

    dat_dap <- do.call(dat_dap, rbind)
    cat(paste0(i, " sites downloaded"))

  } else {

    (stop(print("coordinates must be in a vector (xmin, xmax, ymin, ymax) or as a file path to sites in either .xlsx, .xls, .csv format")))

  }

  if (!is.null(save_file)){
    write.csv(dat_dap, save_file)
  }
  return(dat_dap)

}
