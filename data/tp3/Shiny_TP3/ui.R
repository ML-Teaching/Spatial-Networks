shinyUI(navbarPage(title=HTML('<span style="font-size:120%;color:white;font-weight:bold;">Nom app &nbsp;&nbsp;</span></a>'),
                   windowTitle="Nom fenetre",
                   
 tabPanel(strong("Nom onglet"),
   div(class="outer",     
                                
     # Include custom CSS
     tags$head(
       includeCSS("styles.css")
       ),
                                
     # Map
     leafletOutput("map", width = "100%", height = "100%"),
                                
     # Panel              
     absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE,
                   draggable = TRUE, top = 80, left = "auto", right = 20, bottom = "auto",
                   width = 350, height = "auto",
                   
                   h2("Explorateur"),

                   selectInput(
                     inputId = "similarity",
                     label = strong("Métrique de similarité"),
                     choices = list("Simpson" = 4,
                                    "Jaccard" = 3),
                     selected = "Simpson"
                   ),
                   
                   chooseSliderSkin("Flat", "#4682B4"),
                   sliderInput(inputId = "cutw", 
                               label = strong("Valeur de coupe"), 
                               value=0, 
                               min = 0, 
                               max = 1, 
                               step = 0.1)
                   
     )
                                            
  ))

))
