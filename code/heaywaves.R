
maldives_OISST <- extract_ocean_data(dataset=8,
                                     space = c(73.45, 73.45, 2, 2),
                                     time = c("1981-01-01", "2024-01-01"))

maldives_OISST |>
  extract_heatwave() |>
  ts2clm()

ts <- ts2clm(trial, x=date, y=sstAnom, climatologyPeriod = c("2002-06-01", "2024-01-01"))
mhw <- detect_event(ts, x=date, y=seas)

event_line(mhw, x=date, y=sstAnom, spread = 180, metric = intensity_max,
           start_date = "2002-06-01", end_date = "2024-01-01")

