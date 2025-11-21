shinyServer(function(input, output) {
  
  # Reactive
  reacmap=reactive({
    
    # Type de flux
    type <- input$type
    flux <- st_drop_geometry(mtp)[[type]]
    
    # Couleur légende
    cololeg <- colorRampPalette(brewer.pal(9, 'YlOrRd'))(13)
    
    # Couleur entité
    cat <- as.numeric(as.character(cut(flux,
                                       breaks=c(-1,seq(100,1000,100), 
                                                5000,
                                                10000,
                                                100000),
                                       labels=1:length(cololeg))))
    colo <- cololeg[cat]
    
    res=list(colo=colo,cololeg=cololeg)
    
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
      addPolygons(data=mtp, color=reacmap()$colo, weight = 2, smoothFactor = 0.5,
                  opacity = 0, fillOpacity = 0.5)  %>%
      addLegend(position = 'bottomleft', 
                colors = reacmap()$cololeg, 
                labels = c("[0,100]",
                           "]100,200]",
                           "]200,300]",
                           "]300,400]",
                           "]400,500]",
                           "]500,600]",
                           "]600,700]",
                           "]700,800]",
                           "]800,900]",
                           "]900,1000]",
                           "]1000,5000]",
                           "]5000,10000]",
                           "> 10000"), 
                opacity = 0.6,     
                title = "Taille des flux")  
  
   })
    
 })
