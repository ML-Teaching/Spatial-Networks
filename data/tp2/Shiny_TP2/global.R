# Charger les packages
library(TDLM)
library(shiny)
library(leaflet)
library(sf)
library(RColorBrewer)

# Charger les données
data(mass_mtp)
data(mtp)

# Ajouter les masses à la table attributaire de mtp
mtp <- cbind(mtp, mass_mtp)

