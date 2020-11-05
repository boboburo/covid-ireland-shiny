#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

#to do pass the mode in, set in global.R for now 
launch_app <- function(){
  shinyOptions(mode = "online")
  shinyApp(ui = ui, server = server)
}

launch_app()