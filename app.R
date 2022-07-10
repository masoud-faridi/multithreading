library(shiny)
library(dplyr)
ui <- fluidPage(
  titlePanel("Old Faithful Geyser Data"),
  sidebarLayout(
    sidebarPanel(
      selectInput("v_choosen", "Choose:", choices = names(iris)[1:4]),
    ),
    mainPanel(
      plotOutput("distPlot"),
      DT::DTOutput("dt_table")
      
    )
  )
)


server <- function(input, output) {
  
  output$dt_table <- renderDT({
    Sys.sleep(5)
    iris %>% dplyr::select(input$v_choosen)
  })
  
  
  output$distPlot <- renderPlot({
    
    x    <- iris %>% dplyr::select(input$v_choosen)
    
    hist(x[,1],main=paste(input$v_choosen),xlab="")
  })
  
}
shinyApp(ui = ui, server = server)

