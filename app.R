library(shiny)

# Interface utilisateur (UI)
ui <- fluidPage(
  titlePanel("Exploration des Diamants"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "filter_color", 
                  label = "Filtrer par couleur :", 
                  choices = unique(diamonds$color), 
                  selected = "G"),
      
      sliderInput(inputId = "max_price", 
                  label = "Prix maximum :", 
                  min = 300, 
                  max = 20000, 
                  value = 3444, 
                  step = 100)
    ),
    
    mainPanel()
  )
)

# Serveur
server <- function(input, output, session) {}

# Lancer l'application Shiny
shinyApp(ui = ui, server = server)