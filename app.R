library(shiny)
library(ggplot2)
library(glue)

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
    
    mainPanel(
      plotOutput(outputId = "scatter_plot")
    )
  )
)

# Serveur
server <- function(input, output, session) {
  filtered_data <- reactive({
    subset(diamonds, color == input$filter_color & price <= input$max_price)
  })
  
  output$scatter_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = carat, y = price)) +
      geom_point(alpha = 0.6) +
      labs(title = glue("Prix max: {input$max_price} | Couleur: {input$filter_color}"),
           x = "Carat",
           y = "Prix") +
      theme_minimal()
  })
}

# Lancer l'application Shiny
shinyApp(ui = ui, server = server)