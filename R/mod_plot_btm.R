#rm(mod_dataviz_bar_server, mod_dataviz_bar_ui, barApp)
library(shiny)
library(ggplot2)
library(ggthemes)
library(dplyr)

mod_dataviz_bar_ui <- function(id){
  
  end_date <- max(dailycases$time_stamp)
  
tagList(
    plotOutput(NS(id,"plot1"))
)
}
    

mod_dataviz_bar_server <- function(id,cnty="Dublin",type = "bar",r){
  moduleServer(id, function(input, output, session){
    
  #Determine the county click on the scatter plot  
  clicked_cnty <- reactive(if(length(r$cnty_point())==0){
    cnty}else{r$cnty_point()})
  
  start_date <- reactive(ymd(r$focus_date()[1]))
  end_date <- reactive(ymd(r$focus_date()[2]))
  days_between <- reactive(as.integer(end_date() - start_date()))
  
  output$plot1<- renderPlot({
    
    if(type == "bar"){
      
      #Call to function to create the initial plot
      plot <- plot_btm(dailycases, y_val = "day_cases",
                     county = clicked_cnty(), end_date = end_date(), 
                     days_before = days_between(), type = "bar")
      
      if(r$smth_7() == TRUE){
        plot <- plot +
          geom_line(aes(y = day_cases_7x2), color = "green")
      }
      
      if(r$smth_14() == TRUE){
        plot <- plot +
          geom_line(aes(y = day_cases_14x2), color = "blue")
        
      }
      
      
    }
      
      if(type == "line"){
        
        #call to function to create initial plot
        plot <- plot_btm(dailycases, y_val = "plt1_x",
               county = clicked_cnty(), end_date = end_date(), 
               days_before = days_between(), type = "line")
        
        
        if(r$smth_7() == TRUE){
          plot <- plot +
            geom_line(aes(y = cumm_7_inc_7x2), color = "green")
        }
        
        if(r$smth_14() == TRUE){
          plot <- plot +
            geom_line(aes(y = cumm_14_inc_14x2), color = "blue")
          
        }

      }
    
    plot <- plot + 
      theme_light()
    
    plot
    
  })
})
}

barApp <- function() {
  ui <- fluidPage(
    mod_dataviz_bar_ui("plot_test")
  )
  server <- function(input, output, session) {
    r = reactiveValues()
    r$cnty_point <- reactive("Dublin")
    r$focus_date <- reactive(c("2020-08-01","2020-09-28"))
    r$smth_7 <- reactive(TRUE)
    r$smth_14 <- reactive(TRUE)
    
    mod_dataviz_bar_server("plot_test", cnty = "Dublin", type = "bar",r)
  }
  shinyApp(ui, server)  
}

barApp()
    
## To be copied in the UI
# mod_dataviz_bar_ui("dataviz_bar_ui_1")
    
## To be copied in the server
# callModule(mod_dataviz_bar_server, "dataviz_bar_ui_1")
 
