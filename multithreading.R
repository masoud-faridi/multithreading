library(shiny)
library(dplyr)
library(promises)
library(future)
library(DT)
plan(multisession)

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
  data1<-reactiveVal()

  observe({
    v_ch <- input$v_choosen
    future_promise({
      Sys.sleep(5)
      x    <- iris %>% dplyr::select(any_of(v_ch))
      x
    }) %...>%
      data1()  
    
    NULL
  })  

  output$dt_table <- renderDT({
    
    req(data1())
    as.data.frame(data1())
  })

  output$distPlot <- renderPlot({
   
    x    <- iris %>% dplyr::select(input$v_choosen)
    
    hist(x[,1],main=paste(input$v_choosen),xlab="")
  })
}

shinyApp(ui = ui, server = server)
