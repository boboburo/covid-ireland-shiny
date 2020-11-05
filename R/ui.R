# Define UI for application that draws a histogram
ui <-  shinyUI(
  fluidPage(#theme = shinythemes::shinytheme("flatly"),
    #useShinydashboard(),
            tags$title("Analyze COVID Numbers in Ireland by County"),
            column(width = 12,
                   h1("COVID Numbers in Ireland by County"),
                   HTML(
                     "<div class='alert alert-info'>",
                     "The scatter plot is a recreation of this <a href='https://www.ft.com/content/a2dbf1c0-dcce-4eae-b1f6-f2c31bf0db8a' class='alert-link'>plot</a> from the Finanical Times.",
                     "</div>"
                   )),
            fluidRow(column(width = 11, offset = 1,
              tabsetPanel(type = "tabs",
                tabPanel("Covid Rates",mod_dataviz_scatter_ui("dataviz_scatter_ui_1"))))
              ),
            fluidRow(
              
              
              # Sidebar with a slider input
              column(width = 3, 
                #     wellPanel(
                       # tags$style(".well {background-color:#33FFC4;}"),
                       dateRangeInput("slider_dlb_date", label = "Date Range", 
                                      start = min(lubridate::ymd("2020-04-01")), 
                                      end = max(dailycases$time_stamp), 
                                      min = min(lubridate::ymd("2020-04-01")), 
                                      max = max(dailycases$time_stamp),
                                      format = "M-dd", 
                                      startview = "month", 
                                      weekstart = 0,
                                      language = "en", separator = " to ", width = '100%'),
                       checkboxInput("ck_7day", "7 day smoothed", FALSE),
                       checkboxInput("ck_14day", "14 day smoothed", FALSE)
                     ),#)
              
              # Show a plot of the generated distribution
              column(width = 9,
                     tabsetPanel(
                       tabPanel("Avg Rates per 100k", mod_dataviz_bar_ui("dataviz_bar_ui_1")),
                       tabPanel("Daily Case Counts",mod_dataviz_bar_ui("dataviz_bar_ui_2"))
                     )#tabsetpane
              )#column
            )#fluidRow
  )#fluidPage
)#shinyUi
