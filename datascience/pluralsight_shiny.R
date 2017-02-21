#install.packages("shiny")
#install.packages("RColorBrewer")
#install.packages("ggplot2movies")

library(shiny)
library(RColorBrewer)
library(dplyr)
#library(ggplot2movies)

#head(movies[c("rating","votes")])
head(iris)
table(iris$Species)
summary(iris$Sepal.Length)
summary(iris$Petal.Length)

colors <- brewer.pal(4, "Set3")

summary(iris$Sepal.Width)

#create a UI
ui <- fluidPage(
  titlePanel("------ Iris -------"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "sepalwidth",
        label = "Sepal Width", 
        min = 2.0, 
        max = 4.4, 
        value = c(2.0, 4.4),
        sep = ""
      ),
      checkboxGroupInput(
        inputId = "species",
        label = "Species",
        choices = c("setosa","versicolor","virginica"),
        selected = c("setosa","versicolor","virginica")
      ),
      sliderInput(
        inputId = "petalwidth",
        label = "Petal Width", 
        min = 0.1, 
        max = 2.5, 
        value = c(0.1, 2.5),
        sep = ""
      )
    ),
    mainPanel(
      plotOutput(
        outputId = "plot"
      )
    )
  )
)

#create a server
server <- function(input, output){
  output$plot <- renderPlot(
    {
      subset <- iris %>%
        filter(Petal.Width >= input$petalwidth[1]) %>%
        filter(Petal.Width <= input$petalwidth[2]) %>%
        filter(Sepal.Width >= input$sepalwidth[1]) %>%
        filter(Sepal.Width <= input$sepalwidth[2]) %>%
        filter(Species %in% input$species) %>%
        as.data.frame()
      
      plot (
        x = subset$Sepal.Length,
        y = subset$Petal.Length,
        pch = 19, 
        cex = 1.5,
        col = colors[as.integer(subset$Species)],
        xlim = c(4.2, 8.0),
        ylim = c(1.0, 7.0),
        xlab = "Sepal Length",
        ylab = "Petal Length")
      
      legend(
          x = "topleft",
          as.character(levels(iris$Species)),
          col = colors[1:3],
          pch = 19,
          cex = 1.5
      )
    }
  )
  
}

#create a shinyApp
shinyApp(
  ui = ui, 
  server = server
)