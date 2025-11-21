# Charger les packages
library(bioregion)
library(shiny)
library(shinyWidgets)
library(leaflet)
library(sf)
library(RColorBrewer)

# Charger les données
data(vegemat)
data(vegesf)

# Conversion projection
vegesf <- st_transform(vegesf, crs = 4326)


# Calculer la similarité
sim <- similarity(vegemat, metric = c("Simpson", "Jaccard"))
