numbers2words <- function(x){
  ## original function by John Fox (https://socialsciences.mcmaster.ca/jfox/Courses/R-course-Berkeley/programming-2.R)

  helper <- function(x){

    digits <- rev(strsplit(as.character(x), "")[[1]])
    nDigits <- length(digits)
    if (nDigits == 1) as.vector(ones[digits])
    else if (nDigits == 2)
      if (x <= 19) as.vector(teens[digits[1]])
    else trim(paste(tens[digits[2]],
                    Recall(as.numeric(digits[1]))))
    else if (nDigits == 3) trim(paste(ones[digits[3]], "hundred",
                                      Recall(makeNumber(digits[2:1]))))
    else {
      nSuffix <- ((nDigits + 2) %/% 3) - 1
      if (nSuffix > length(suffixes)) stop(paste(x, "is too large!"))
      trim(paste(Recall(makeNumber(digits[
        nDigits:(3*nSuffix + 1)])),
                 suffixes[nSuffix],
                 Recall(makeNumber(digits[(3*nSuffix):1]))))
    }
  }
  trim <- function(text){
    gsub("^\ ", "", gsub("\ *$", "", text))
  }
  makeNumber <- function(...) as.numeric(paste(..., collapse=""))
  opts <- options(scipen=100)
  on.exit(options(opts))
  ones <- c("", "one", "two", "three", "four", "five", "six", "seven",
            "eight", "nine")
  names(ones) <- 0:9
  teens <- c("ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
             "sixteen", " seventeen", "eighteen", "nineteen")
  names(teens) <- 0:9
  tens <- c("twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty",
            "ninety")
  names(tens) <- 2:9
  x <- round(x)
  suffixes <- c("thousand", "million", "billion", "trillion")
  if (length(x) > 1) return(sapply(x, helper))
  helper(x)
}



### Read thredds catalog ----

## Use thredds to get the DatasetNode:
catalog_list <- thredds::CatalogNode$new("https://oceanwatch.pifsc.noaa.gov/thredds/catalog.xml")
dataset_list <- catalog_list$get_datasets()
#names(dataset_list)
catalog_dataset <- dataset_list$`Photosynthetically Available Radiation (PAR), Aqua MODIS - Monthly, 2002-present. v.2018.0`
catalog_dataset <- dataset_list$`Photosynthetically Available Radiation (PAR), Aqua MODIS - 8-Day, 2002-present. v.2018.0`
catalog_dataset <- dataset_list$`Photosynthetically Available Radiation (PAR), Aqua MODIS - Daily, 2002-present. v.2018.0`

## THREDDS OPeNDAP file path
catalog_dataset_url <- file.path("https://oceanwatch.pifsc.noaa.gov/thredds/dodsC", catalog_dataset$url)
dataset <- ncdf4::nc_open(catalog_dataset_url)

# explore dataset
names(dataset$var) # get varnames
dataset$var$par$size # get dims

dataset$dim$lat$units # lat units
range(dataset$dim$lat$vals) # lat range
dataset$dim$lon$units # lat units
range(dataset$dim$lon$vals) # lat range

((dataset$var$par$size)[1]*(dataset$var$par$size)[2]) # total xy gridcells
as.numeric((dataset$var$par$size)[1])*(dataset$var$par$size)[2]*(dataset$var$par$size)[3] # total xyz gridcells


## extract Lon/Lat/Time and crs from nc file
# df_crs <- ncdf4::ncvar_get(dataset, "crs") # Get crs, see https://www.e-education.psu.edu/geog862/node/1801
df_lon <- ncdf4::ncvar_get(dataset, "lon") # Get longitude values
df_lat <- ncdf4::ncvar_get(dataset, "lat") # Get latitude values
#df_time <- ncdf4::ncvar_get(dataset, "time") # get time values
df_time_index <- lubridate::ymd(as.Date(ncdf4::ncvar_get(dataset, "time"))) # get time values

lonmin <- 70 + 180
lonmax <- 70.3 + 180
latmin <- 0.0
latmax <- 0.1
timemin <- "2007-11-01"
timemax <- "2007-12-01"

# boundaries of the box and time
LonIdx <- which(df_lon >= lonmin & df_lon <= lonmax) # get match by position
LatIdx <- which(df_lat >= latmin & df_lat <= latmax)
timeIdx <- which(df_time_index >= timemin & df_time_index <= timemax)

# positions of the box and time boundaries (check against input)
LonIdx.conv <- df_lon[min(LonIdx):max(LonIdx)]
LatIdx.conv <- df_lat[min(LatIdx):max(LatIdx)]
timeIdx.conv <- df_time_index[min(timeIdx):max(timeIdx)]

# start and count parameters for ncvar_get
c(min(LonIdx), min(LatIdx), min(timeIdx)) # start positions
c(length(LonIdx), length(LatIdx), length(timeIdx)) # count (check)

# create a grid for ncvar_get to work with
count.loop <- expand.grid(                              # use expand.grid here to generate sequences bound by start positions and end counts
     x=seq(min(LonIdx), min(LonIdx) + (length(LonIdx)-1)),
     y=seq(min(LatIdx), min(LatIdx) + (length(LatIdx)-1)),
     z=seq(min(timeIdx), min(timeIdx) + (length(timeIdx)-1))
    ) |>
  dplyr::mutate(                         # extract exact values from positions in xyz cols
     lon=df_lon[x],
     lat=df_lat[y],
     date=df_time_index[z]
    )

### download loop ----
{start_time <- Sys.time()
  ncdf4::ncvar_get(dataset,
    start = as.numeric(count.loop[1,1:3]),
    count = c(1, 1, 1),
    varid = "par", verbose = FALSE
  )
end_time <- Sys.time()
time_prog_a <- end_time - start_time}

df.loop <-NULL # matrix(NA, ncol = 4, nrow = nrow(count.loop))
msg <- paste0("There are ", nrow(count.loop)," (",numbers2words(nrow(count.loop)),") gridcells ","(",length(LonIdx),"*",length(LatIdx),"*",length(timeIdx)," array)",'\n',"which will take ~", round((as.numeric(time_prog_a) * nrow(count.loop) / 60), 1), " minutes to download.",'\n',"Are you sure you want to proceed?")

{if (askYesNo(msg) == TRUE) {
  for (i in 1:nrow(count.loop)) {
    start_time <- Sys.time()
    value=as.numeric(ncdf4::ncvar_get(dataset,
        start = as.numeric(count.loop[i,1:3]),
        count = c(1, 1, 1),
        varid = "par", verbose = FALSE))
   # df.loop[i,]=cbind(as.matrix(count.loop[i,4:6]), value)
    end_time <- Sys.time()
    time_prog_b <- end_time - start_time

    message("Downloading gridcell ", i, " of ", (nrow(count.loop)), " - ",
      round((i / nrow(count.loop) * 100),0), "% complete, ~",
      round(((nrow(count.loop)-i)*as.numeric(time_prog_b)/60),  1), " mins remaining")




  }
} else {
  print("Download not initiated")
}

output.df <- as.data.frame(df.loop) |>
  dplyr::rename(lon=1, lat=2, date=3, value=4) |>
  dplyr::mutate(date=lubridate::ymd(as.Date(date))) |>
  dplyr::arrange(lon,lat)
}


output.df












  ##############
  # check if folder exists otherwise create folder
  if (!dir.exists("datasets/")) {
    dir.create("datasets/")
  }
  if (!dir.exists("outputs/")) {
    dir.create("outputs/")
  }

  # check if file exists otherwise download the full HadISST dataset *475mb*
  if (file.exists("datasets/HadISST_sst.nc")) {
    print("HadISST dataset already downloaded - extracting SST data")
  } else {
    print("downloading HadISST dataset on first use")
    download.file("https://www.metoffice.gov.uk/hadobs/hadisst/data/HadISST_sst.nc.gz", "datasets/HadISST_sst.nc.gz")
    R.utils::gunzip("datasets/HadISST_sst.nc.gz")
  }

  HadISSTmain <- terra::rast("datasets/HadISST_sst.nc") # read nc file as raster
  HadISST <- terra::crop(HadISSTmain, terra::ext(xmin, xmax, ymin, ymax)) # crop to bounding box depending on lon/lat
  names(HadISST) <- terra::time(HadISST) # set layer names from time
  terra::units(HadISST) <- "SST"

  # yrs_list_had <- terra::time(HadISST)

  # Select output type (average annual SST, max annual SST, min annual SST, raw (daily))
  if (output == "mean") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = mean)
    # names(HadISST) <- (gsub("X", "", names(HadISST)))
    # terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "max") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = max)
    # names(HadISST) <- (gsub("X", "", names(HadISST)))
    # terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "min") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = min)
    # names(HadISST) <- (gsub("X", "", names(HadISST)))
    # terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "modal") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = modal)
    # names(HadISST) <- (gsub("X", "", names(HadISST)))
    # terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "median") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = median)
    # names(HadISST) <- (gsub("X", "", names(HadISST)))
    # terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "sd") {
    HadISST <- terra::tapp(HadISST, index = "years", fun = sd)
    # names(HadISST) <- (gsub("X", "", names(HadISST)))
    # terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else if (output == "monthly") {
    terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
  } else {
    HadISST <- terra::tapp(HadISST, index = "years", fun = mean)
    # names(HadISST) <- (gsub("X", "", names(HadISST)))
    # terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
    print("No output type specified, defaulting to annual mean")
  }


  ### Select filetype and save output
  if (filetype == "sp") { # save as SpatRaster to RDS
    names(HadISST) <- (gsub("X", "", names(HadISST)))
    terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
    HadISST <- terra::subset(HadISST, as.character(years), NSE = FALSE)
    saveRDS(object = HadISST, file = paste0("outputs/", filename, ".rds"))
    rm(HadISST)
  } else if (filetype == "csv") { # save as csv
    names(HadISST) <- (gsub("X", "", names(HadISST)))
    terra::time(HadISST) <- lubridate::year(as.Date(ISOdate(names(HadISST), 1, 1)))
    HadISST <- terra::subset(HadISST, as.character(years), NSE = FALSE)
    filesave <- HadISST |>
      terra::as.data.frame(xy = TRUE, na.rm = FALSE) |>
      tidyr::pivot_longer(!x:y, names_to = "date", values_to = "SST") |>
      dplyr::rename(lat = x, lon = y)
    #  mutate(date = case_when(grepl("X", date) ~ (gsub("X","",date)), grepl("-", date) ~date)) %>%
    write.csv(filesave, file = paste0("outputs/", filename, ".csv"))
    rm(HadISST)
  } else {
    print("filetype not found (either 'csv' or 'sp') ")
  }
}
