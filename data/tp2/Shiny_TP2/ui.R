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
                     inputId = "type",
                     label = strong("Type de flux"),
                     choices = list("Flux sortants" = "Out_Commuters",
                                    "Flux entrants" = "In_Commuters"),
                     selected = "Out_Commuters"
                   ),
                   
     )
                                            
  ))

))
