# Define server logic required to draw a histogram
server <- function( input, output, session ) {
  # List the first level callModules here
  
  r <- reactiveValues()
  r$focus_date <- reactive(input$slider_dlb_date)
  r$smth_7 <- reactive(input$ck_7day)
  r$smth_14 <- reactive(input$ck_14day)
  
  mod_dataviz_scatter_server("dataviz_scatter_ui_1", r)
  mod_dataviz_bar_server("dataviz_bar_ui_1", cnty = "Dublin",type = "line",r)
  mod_dataviz_bar_server("dataviz_bar_ui_2", cnty = "Dublin",type = "bar",r)
}