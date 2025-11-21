shinyServer(function(input, output) {
  
  # Reactive
  reacmap=reactive({
    
    # Bioregionalisation
    clu <- netclu_louvain(sim,
                          index = as.numeric(input$similarity),
                          cut_weight = as.numeric(input$cutw), 
                          seed = 1)
    
    # Map
    clusf <- map_bioregions(clu, vegesf,
                            write_clusters = TRUE,
                            plot = FALSE)
    
    # Bioregions
    bioregions <- as.factor(clusf[,2, drop=TRUE])
    
    # Créer une palette de couleurs 
    pal <- colorFactor(
      palette = "Set2",
      domain  = bioregions,
      na.color = "white"
    )
    
    # Associer une couleur à chaque bioregion
    palbio <- pal(bioregions)
    
    res=list(clusf=clusf, bioregions=bioregions, pal=pal, palbio=palbio)
    
  })
  
  # Create the base map
  output$map=renderLeaflet({
    
    # Map
    leaflet() %>%
      clearShapes() %>%
      clearMarkers() %>%
      clearControls() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      #addTiles() %>%
      addPolygons(data=reacmap()$clusf, 
                  color=reacmap()$palbio, 
                  weight = 2, smoothFactor = 0.5,
                  opacity = 0, fillOpacity = 0.5) %>%
      addLegend(
        position = "bottomleft",
        pal      = reacmap()$pal,
        values   = reacmap()$bioregions,
        title    = "Biorégions",
        opacity  = 1
      )
  
   })
    
 })
