

#rm(mod_dataviz_scatter_server, mod_dataviz_scatter_ui , scatterApp)
# source(fct_plot_top.R)

mod_dataviz_scatter_ui <- function(id){
  tagList(
    # sliderInput(NS(id,"slider_sct_date"),label = "Focus Date", 
    #             value = max(dailycases$time_stamp),
    #             min = min(lubridate::ymd("2020-04-01")), 
    #             max = max(dailycases$time_stamp),
    #             dragRange = FALSE,
    #             timeFormat = "%b-%d",
    #             animate = TRUE),
    dateInput(NS(id,"slider_sct_date"),label = "Focus Date",
              value = max(dailycases$time_stamp),
              min = min(lubridate::ymd("2020-04-01")), 
              max = max(dailycases$time_stamp),
              format = "dd-M-yyyy", width = validateCssUnit("15%")),
  plotOutput(NS(id, "plotS"),
                 click = clickOpts(id = NS(id,"plotS_click")))
  )
}
    
#' dataviz_scatter Server Function
#'
#' @noRd 
#' 
mod_dataviz_scatter_server <- function(id,r){
  moduleServer(id,function(input, output, session){
    
    output$plotS <- renderPlot({
      
      plot <- plot_top(dailycases, x_val = "plt1_x", y_val = "plt1_y",
                     size_col = "population_census16", label_col = "county_name",
                     focus_date = input$slider_sct_date)
      plot
    })# end plot 
    
    
  
  #Work out which county point is selected
  r$cnty_point <- reactive({
    
    plot_data <- dailycases %>% filter(time_stamp == input$slider_sct_date)
    
    nearPoints(plot_data,
               input$plotS_click, xvar = "plt1_x", yvar = "plt1_y" )$county_name})
  
  })#end moduleServer
}
  
scatterApp <- function() {
  ui <- fluidPage(
    mod_dataviz_scatter_ui("plot_test")
  )
  server <- function(input, output, session) {
    r <- reactiveValues()
    mod_dataviz_scatter_server("plot_test",r)
  }
  shinyApp(ui, server)  
}

scatterApp()

## To be copied in the UI
# mod_dataviz_scatter_ui("dataviz_scatter_ui_1")
    
## To be copied in the server
# callModule(mod_dataviz_scatter_server, "dataviz_scatter_ui_1")
 
