  #' Generate a ggplot line plot with the dailycases dataset
  #'
  #' @description
  #' The map function transform the input, returning a vector the same length
  #' as the input. 
  #' 
  #' @importFrom ggplot2 ggplot aes geom_bar geom_line labs
  #' @importFrom dplyr filter
  #' @importFrom lubridate days
  #' @importFrom glue glue
  

library(ggplot2)
library(dplyr)
library(lubridate)
library(glue)
  
  plot_btm <- function(df, x_val = "time_stamp", y_val, county, end_date, days_before, type = "bar"){
    
    if (missing(df))
      stop("No data frame supplied.")
  
    if (missing(y_val))
      stop("x, y variable not supplied")
    
    if (missing(county) |  missing(end_date) | missing(days_before))
      stop("Filter variable not supplied")
  
  if(class(end_date) != "Date" )
    stop("End date not correct")  
  

  plot <-df %>%
    filter(time_stamp <= end_date) %>%
    filter(time_stamp >= end_date - lubridate::days(days_before))%>%
    filter(county_name == county) %>% 
    ggplot(aes(x = .data[[x_val]], y = .data[[y_val]]))
  
  if(type == "bar"){
    plot <- plot + geom_col()
    
    plot_title = glue('Daily count of cases in {county}')
    plot_subtitle = glue('{days_before} days up until {format(end_date, "%A, %B %d, %Y")}')
    
    plot <- plot +
      labs(title = plot_title,
           subtitle = plot_subtitle,
           y = "Daily Case Count\n", x = "")
  }
  
  if(type == "line"){
    plot <- plot + geom_line() 
    
    plot_title = glue('Trend of cases per 100k in {county}')
    plot_subtitle = glue('{days_before} days up until {format(end_date, "%A, %B %d, %Y")}')
    
    plot <- plot +
      labs(title = plot_title,
           subtitle = plot_subtitle,
           y = "14 days cases per 100k\n", x = "")
    
  }
  
  return(plot)
}

plot_btm_test <- function(){
  
  plot_btm(dailycases, y_val = "plt1_x",
            county = "Dublin",
            end_date = ymd("2020-05-29"), days_before =30, type = "line")
  
}

#plot_btm_test()

  