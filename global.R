# Load major & minor categories for the survey mock data
source("settings/categories.R")

# Create color palette
cus.pal <- RColorBrewer::brewer.pal(5, "Set1")

# Color palette for leaflet map based on cus.pal object
pal.major <- leaflet::colorFactor(cus.pal, domain = major.cats)

# Read geojson with world country data
shp <- rgdal::readOGR("layers/countries.geojson", "OGRGeoJSON")
shp@data$name <- as.character(shp@data$name)

# Values for selectize input
countries <- shp@data$name
ISO3 <- shp@data$sov_a3

# Load CFI theme for ggplot2
source("settings/ggplot_theme_cfi.R")
