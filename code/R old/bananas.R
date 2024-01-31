library(data.table)

# Set the seed for reproducibility
set.seed(123)

# Generate the dataset
dt <- data.table(site = 1:10,
                 longitude = runif(10, -180, 180),
                 latitude = runif(10, -90, 90))

# Add a bananas variable for each year
for (year in 2010:2019) {
  dt[, paste0("bananas_", year) := round(runif(10, 50, 100))]
}

# Pivot the data.table to a longer format
dt_long <- melt(dt, id.vars = c("site", "longitude", "latitude"), 
                measure.vars = patterns("bananas"),
                variable.name = "year",
                value.name = "bananas")

# Convert the year variable to a numeric year
dt_long[, year := as.numeric(sub("bananas_", "", year))]

# Calculate the average number of bananas for each site
dt_avg <- dt_long[, .(bananas_avg = mean(bananas)), by = site]

# Merge the averages back into the original data.table
dt_long <- merge(dt_long, dt_avg, by = "site")

# Calculate the anomaly for each year
dt_long[, anomaly := bananas - bananas_avg]

# Print the resulting dataset
print(dt_long)


library(tidyr)

# Generate the dataset
df <- data.frame(site = 1:10,
                 longitude = runif(10, -180, 180),
                 latitude = runif(10, -90, 90))

# Add a bananas variable for each year
for (year in 2010:2019) {
  df[, paste0("bananas_", year)] <- round(runif(10, 50, 100))
}

# Pivot the data.frame to a longer format
df_long <- df %>% pivot_longer(-c(site, longitude, latitude), 
                                names_to = "year",
                                values_to = "bananas")

# Convert the year variable to a numeric year
df_long$year <- as.numeric(sub("bananas_", "", df_long$year))

# Calculate the average number of bananas for each site
df_avg <- aggregate(bananas ~ site, data = df_long, mean)
names(df_avg) <- c("site", "bananas_avg")

# Merge the averages back into the original data.frame
df_long <- merge(df_long, df_avg, by = "site")

# Calculate the anomaly for each year
df_long$anomaly <- df_long$bananas - df_long$bananas_avg

# Print the resulting data.frame
print(df_long)
