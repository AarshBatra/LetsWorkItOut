# 
# #loading libraries
# library(geojsonio)
# library(jsonlite)
# 
# data_met <- fromJSON("C:/Users/pc/Dropbox/and more/data analysis for social scientists, edX/extras/Lets-Work-it-out!/data+otherstuff_meteorLandVis/meteoriteLandings.json", flatten = TRUE)
# NA_in_lat <- sum(is.na(data_met$geolocation.latitude))
# NA_in_long <- sum(is.na(data_met$geolocation.longitude))
# NA_logic <- NA_in_lat == NA_in_long #Note-  'NA_logic' is true(check yourself).
# check_sum <- sum(is.na(data_met$geolocation.latitude) == is.na(data_met$geolocation.longitude)) #if 'check_sum'...
# #... equal number of rows(1000), than we can proceed to delete the rows with NA. Spoiler alert: 'check_sum' = 1000
# 
# #deleting rows with NA
# 
# 
# #data_met$geolocation.latitude <- as.numeric(data_met$geolocation.latitude)
# #data_met$geolocation.longitude <- as.numeric(data_met$geolocation.longitude)
# 
# #data_met <- data.frame(name = data_met$name, mass = data_met$mass, latitude = data_met$geolocation$latitude, longitude = data_met$geolocation$longitude)
# #data_met <- data_met[!(is.na(data_met$latitude) & is.na(data_met$longitude)),]
# #data_met$latitude <- as.numeric(data_met$latitude)
# #data_met$longitude <- as.numeric(data_met$longitude)
# #data <- geojsonio::geojson_read(x = "myfile.geojson", what = "sp")