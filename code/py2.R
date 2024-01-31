library(reticulate)
library(reticulate)

# If you haven't already, you might need to set up the Python environment
# use_python("/path/to/python", required = TRUE) 
use_virtualenv("/Users/rof011/.virtualenvs/r-reticulate", required = TRUE)
py_install("rasterio", envname = "/Users/rof011/.virtualenvs/r-reticulate")
py_install("cameratransform", envname = "/Users/rof011/.virtualenvs/r-reticulate")
py_install("numpy", envname = "/Users/rof011/.virtualenvs/r-reticulate")

# Import necessary Python modules using reticulate
rasterio <- import('rasterio')
ct <- import('cameratransform')
np <- import('numpy')

mini pro 3 = type 1/1.3 (10 x 7.5mm) 

# Define the variables used in your Python code
f <- 6.72 # Define focallength_mm
sensor_size <- c(10, 7.5) ... # Define sensor_size
image_size <- c(4032, 3024)... # Define image_size
#img <- c... # Define img with properties like altitude, latitude, longitude
pitch <- -90 # Define pitch
sensor_offset <- c(0.00, 0.00, 15.40) # Define sensor_offset
roll <- 0 # Define roll
yaw <-  22.7  # Define yaw
path_name <- "/Users/rof011/reefspawn/DCIM/DJI_0012.JPG" # Define the path to the original image
img_altitude= 5 3.438
img_latitude = -27.5113343611111
img_longitude = 152.927477888889 


# Your Python code translated into R using reticulate
cam <- ct$Camera(
  ct$RectilinearProjection(focallength_mm = f, sensor = sensor_size, image = image_size),
  ct$SpatialOrientation(elevation_m = img_altitude, tilt_deg = pitch + sensor_offset, roll_deg = roll, heading_deg = yaw)
)

cam$setGPSpos(img_latitude, img_longitude, img_altitude)

coords <- np$array(list(
  cam$gpsFromImage(c(0, 0)),
  cam$gpsFromImage(c(image_size[[1]] - 1, 0)),
  cam$gpsFromImage(c(image_size[[1]] - 1, image_size[[2]] - 1)),
  cam$gpsFromImage(c(0, image_size[[2]] - 1))
))

# Define GCPs
gcp1 <- rasterio$control$GroundControlPoint(row=0, col=0, x=coords[1, 2], y=coords[1, 1], z=coords[1, 3])
gcp2 <- rasterio$control$GroundControlPoint(row=image_size[[1]] - 1, col=0, x=coords[2, 2], y=coords[2, 1], z=coords[2, 3])
gcp3 <- rasterio$control$GroundControlPoint(row=image_size[[1]] - 1, col=image_size[[2]] - 1, x=coords[3, 2], y=coords[3, 1], z=coords[3, 3])
gcp4 <- rasterio$control$GroundControlPoint(row=0, col=image_size[[2]] - 1, x=coords[4, 2], y=coords[4, 1], z=coords[4, 3])

# Use rasterio
with(rasterio$Env(), {
  with(rasterio$open(path_name, 'r'), function(src) {
    profile <- src$profile
    tsfm <- rasterio$transform$from_gcps(list(gcp1, gcp2, gcp3, gcp4))
    
    crs <- rasterio$crs$CRS(dict(init = "epsg:4326"))
    
    profile$update(dtype = rasterio$uint8, transform = tsfm, crs = crs)
    
    with(rasterio$open('example.tif', 'w', **profile), function(dst) {
      dst$write(src$read()$astype(rasterio$uint8), 1)
    })
  })
})
