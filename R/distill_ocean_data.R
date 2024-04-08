distill_ocean_data <- function(input, var, group = "all", calculate = mean, ...) {
  # Ensure the 'time' column is in a usable date format
  input <- input %>%
    dplyr::mutate(time = as.Date(time))  # Convert to Date format if needed

  # Determine the time
  if (group == "year") {
    output <- input %>%
    dplyr::mutate(year = lubridate::year(time)) %>%
    dplyr::group_by(latitude, longitude, year) %>%
    dplyr::summarise(!!var := calculate(!!rlang::sym(var)), .groups = "drop")
  } else if (group == "month") {
    output <- input %>%
      dplyr::mutate(month = lubridate::floor_date(time, "month")) %>%
      dplyr::group_by(latitude, longitude, month) %>%
      dplyr::summarise(!!var := calculate(!!rlang::sym(var)), .groups = "drop")
  } else if (group == "week") {
    output <- input %>%
      dplyr::mutate(week = lubridate::floor_date(time, "week")) %>%
      dplyr::group_by(latitude, longitude, week) %>%
      dplyr::summarise(!!var := calculate(!!rlang::sym(var)), .groups = "drop")
  } else if (group == "day") {
    output <- input %>%
      dplyr::mutate(day = lubridate::floor_date(time, "day")) %>%
      dplyr::group_by(latitude, longitude, day) %>%
      dplyr::summarise(!!var := calculate(!!rlang::sym(var)), .groups = "drop")
  } else {
    output <- input %>%
      dplyr::group_by(latitude, longitude) %>%
      dplyr::summarise(!!var := calculate(!!rlang::sym(var)), .groups = "drop")
  }



  return(output)
}
