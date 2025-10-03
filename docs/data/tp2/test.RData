library(dodgr)
library(osmdata)
library(sf)
library(ggplot2)

# 1. Charger le réseau routier autour de Montpellier
bb <- getbb("Montpellier, France")
graph_sf <- dodgr_streetnet(bb, quiet=TRUE)  # réseau brut
graph <- weight_streetnet(graph_sf, wt_profile = "motorcar") # graphe pondéré

# 2. Définir origine/destination (lon/lat)
from <- c(3.8795, 43.6045)   # Gare Saint-Roch
to   <- c(3.8601, 43.6319)   # Université des Sciences

# 3. Récupérer les sommets et trouver les plus proches
vertices <- dodgr_vertices(graph)

from_id <- vertices$id[which.min((vertices$x - from[1])^2 + (vertices$y - from[2])^2)]
to_id   <- vertices$id[which.min((vertices$x - to[1])^2 + (vertices$y - to[2])^2)]

# 4. Calculer le chemin
path_nodes <- dodgr_paths(graph, from = from_id, to = to_id, vertices = TRUE)

# 5. Convertir la séquence de sommets en objet sf LINESTRING
coords <- do.call(rbind, lapply(path_nodes[[1]][[1]], function(id) {
  c(vertices$x[vertices$id == id], vertices$y[vertices$id == id])
}))

path_line <- st_sfc(st_linestring(coords), crs = 4326)

# 6. Tracer le chemin sur la carte
ggplot() +
  geom_sf(data = graph_sf, color = "grey80") +
  geom_sf(data = path_line, color = "red", size = 1.2) +
  ggtitle("Chemin routier entre Gare Saint-Roch et Université des Sciences")




