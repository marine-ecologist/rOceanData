
#' Extract ocean data v0.1.0.9004
#' deployApp("/Users/rof011/rOceanData/apps/ocean_data_viewer/ocean_data_viewer_0.9004.R")
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


extract_ocean_data <- function(dataset, space, time, save_file, offset_km = 0, ...) {

#   # Determine space type and process accordingly
#   if (is.numeric(space) && length(space) == 4) {
#     # Apply offset to space coordinates if specified
#     if (offset_km > 0) {
#       space <- apply_offset_to_coords(space, offset_km)
#     }
#     dat_dap <- fetch_data_for_site(dataset, space, time)
#   } else if (grepl("\\.(xlsx|csv)$", space, ignore.case = TRUE)) {
#     coord_list <- if (grepl("\\.xlsx$", space, ignore.case = TRUE)) {
#       readxl::read_excel(space)
#     } else {
#       read.csv(space)
#     }
#     dat_dap <- extract_coords(coord_list)
#   } else if (is.data.frame(space)) {
#     dat_dap <- extract_coords(space = space)
#   } else {
#     stop("Coordinates must be in a vector (xmin, xmax, ymin, ymax) or as a file path to sites in either .xlsx, .csv format, or a data frame.")
#   }

    # Check if input is a numeric vector of length 4 (e.g., coordinates)
    if (is.numeric(space) && length(space) == 4) {
      # if (offset_km > 0) {
      #   input <- apply_offset_to_coords(space, offset_km)
      # }
      output <- wrap_griddap(dataset, space, time)


      # Check if input is a path to a CSV or Excel file
    } else if (is.character(space) && grepl("\\.(xlsx|csv)$", input, ignore.case = TRUE)) {
      if (grepl("\\.xlsx$", space, ignore.case = TRUE)) {
        coord_list <- readxl::read_excel(space)
      } else {  # For CSV
        coord_list <- read.csv(space)
      }

      dat_dap <- extract_coords(coord_list)

      results <- list()
      for (i in 1:nrow(dat_dap)) {
        coords <- c(dat_dap[i, 2], dat_dap[i, 2], dat_dap[i, 3], dat_dap[i, 3])
        results[[i]] <- wrap_griddap(dataset, coords, time) |>
          as.data.frame() |>
          dplyr::rename(site_longitude=longitude) |>
          dplyr::rename(site_latitude=latitude) |>
          dplyr::mutate(site = space[i,1]) |>
          dplyr::mutate(longitude = space[i,2]) |>
          dplyr::mutate(latitude = space[i,3])
      }
      output <- do.call(rbind, results)

    } else if (is.data.frame(space)) {
      dat_dap <- extract_coords(space)
      results <- list()
      for (i in 1:nrow(dat_dap)) {
        print(paste0("Extracting ", space[i,1], " (", space[i,2], " / ", space[i,3], ")"))
        coords <- c(dat_dap[i, 2], dat_dap[i, 2], dat_dap[i, 3], dat_dap[i, 3])
        results[[i]] <- wrap_griddap(dataset, coords, time) |>
          as.data.frame() |>
          dplyr::rename(site_longitude=longitude) |>
          dplyr::rename(site_latitude=latitude) |>
          dplyr::mutate(site = space[i,1]) |>
          dplyr::mutate(longitude = space[i,2]) |>
          dplyr::mutate(latitude = space[i,3]) #|>
          #dplyr::relocate(time=1, site=2, site_longitude=3,
          #         site_latitude=4, longitude=5, latitude=6)
      }
      output <- do.call(rbind, results)

    } else {
      stop("Invalid input type. Input must be a numeric vector (coordinates), a path to a CSV/XLS file, or an existing data.frame.")
    }


  # Save file if requested
  if (!save_file=="") {
    utils::write.csv(output, paste0(save_file, ".csv"), row.names = FALSE)
  }

  return(output)
}
