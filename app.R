library(shiny)
library(ggplot2)
library(DT)
library(glue)
library(shinythemes)
library(bslib)
library(shinylive)

shinylive::export(appdir = ".", destdir = "docs")


thematic_shiny(font="auto")

# Interface utilisateur (UI)
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "minty"),
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
                  step = 100),
      
      radioButtons(inputId = "color_rose", 
                   label = "Colorier les points en rose ?", 
                   choices = c("Oui" = TRUE, "Non" = FALSE), 
                   selected = TRUE),
      
      actionButton(inputId = "show_notification", 
                   label = "Afficher une notification")
    ),
    
    mainPanel(
      plotOutput(outputId = "scatter_plot"),
      DTOutput(outputId = "data_table")
    )
  )
)

# Serveur
server <- function(input, output, session) {
  filtered_data <- reactive({
    subset(diamonds, 
           color == input$filter_color & 
             price <= input$max_price)
  })
  
  # Affichage du nuage de points
  output$scatter_plot <- renderPlot({
    p <- ggplot(filtered_data(), aes(x = carat, y = price)) +
      geom_point(alpha = 0.6, color = ifelse(input$color_rose, "pink", "black")) +
      labs(title = glue("Prix max: {input$max_price} | Couleur: {input$filter_color}"),
           x = "Carat",
           y = "Prix") +
      theme_minimal() +
      theme(plot.background = element_rect(fill = "gray98"))
    
    p
  })
  
  # Affichage du tableau interactif
  output$data_table <- renderDT({
    datatable(filtered_data(), 
              options = list(pageLength = 10, scrollX = TRUE))
  })
  
  # Notification lors du clic sur le bouton
  observeEvent(input$show_notification, {
    showNotification(glue("Prix max: {input$max_price} | Couleur: {input$filter_color}"),
                     type = "message")
  })
}

# Lancer l'application Shiny
shinyApp(ui = ui, server = server)
