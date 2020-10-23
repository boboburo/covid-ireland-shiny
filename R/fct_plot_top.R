#' Generate a ggplot line plot with the dailycases dataset
#'
#' @description
#' The plot_top function takes a data frame and aesthetics and generates a plot 
#' 
#' @importFrom ggplot2 ggplot aes geom_bar geom_line labs geom_hline ggplot_build
#' @importFrom dplyr filter
#' @importFrom lubridate days
#' @importFrom glue glue
#' @importFrom ggrepel geom_text_repel


plot_top <- function(df, x_val, y_val, pnt_color = "red", size_col, label_col, focus_date = NULL){
  
  if (missing(df))
    stop("No data frame supplied.")
  
  if (missing(x_val) | missing(y_val) | missing(size_col) | missing(label_col))
    stop("Aesthetic not supplied")
  
  #filter to the date to focus on 
  df_focus_day = focus_on_day(df,focus_date = focus_date)
  
  plot <- df_focus_day %>%
    ggplot(aes(x = .data[[x_val]],y = .data[[y_val]])) +
      geom_point(color = pnt_color, aes(size = .data[[size_col]])) +
      geom_text_repel(aes(label = .data[[label_col]]), size = 3)
  
  #add hline, labels and scale the axis
  plot <- plot + 
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey24", alpha = 0.8, size = 1)
  
  #add labels
  date_focus = max(df_focus_day$time_stamp)
  
  
  plot <- plot +
    labs(title = glue('COVID rates per 100k (based on 7 day cummulative).\n'),
         subtitle = glue('{format(date_focus, "%A, %B %d, %Y")}, (Click on county to explore in detail below)'),
         x = '\nCount of 14 days cases, per 100k people',
         y = 'Weekly change\n',
         size = 'Population Size ~')
  
  #scales
  plot <- plot + 
    scale_y_continuous(labels = scales::percent_format(accuracy = 1)) + 
    scale_size_continuous(range = c(0.1,10), breaks = 10000 * c(5,10,50), 
                          labels  = c("50k","100k", "500k"))
  
  #add annotation labels to the plot
  plot <- plot_4_annotate(plot)
  
  #theme the plot 
  plot <- plot + 
    theme_light()+
    ggplot2::theme(legend.position="top",
                   axis.title.x = element_text(size = 14),
                   axis.title.y = element_text(size =14),
                   axis.text = element_text(size = 10))
  
  
  
  return(plot)
           
}


plot_top_test <- function()
{
 # last_days = dailycases %>% filter(time_stamp == max(time_stamp))
  mst_rcnt = max(dailycases$time_stamp)
  
  plot_top(dailycases, x_val = "plt1_x", 
           y_val = "plt1_y", 
           size_col = "population_census16", 
           label_col = "county_name", focus_date = ymd("2020-05-11"))
  
}

plot_top_test()
  
#' Generate annotations for a plot in four corners 
#'
#' @description
#' Annotate a plot


plot_4_annotate <- function(plot){
  if (!is.ggplot(plot))
    stop("Expected a ggplot.")
  
  #Extract the values from the plot
  plot_vals <- ggplot_build(plot)
  x_val <- plot_vals$data[[1]]$x
  y_val <- plot_vals$data[[1]]$y
  
  
  #create the annotation values used for HIGH RISING, LOW RISING labels
  xrng <-  range(x_val)
  yrng <- range(y_val)
  
  #sometimes y is off the plot so move. 
  if(yrng[1] > -0.25){yrng[1]= -0.25}
  if(yrng[2] <  0.25){yrng[2]=  0.25}
  
  #add annotations
  clr = "red3"
  sz = 4
  
  plot <- plot +
    ggplot2::annotate("text", x = xrng[2], y = yrng[2], label = "HIGHER\nRISING", 
                      size = sz, color = clr, hjust = 1, vjust = 1.0) +
    ggplot2::annotate("text", x = xrng[2], y = yrng[1], label = "HIGHER\nFALLING", 
                      size = sz, color = clr, hjust = 1, vjust = -0.5) +
    ggplot2::annotate("text", x = xrng[1], y = yrng[2], label = "LOWER\nRISING", 
                      size = sz, color = clr, hjust = 0, vjust = 1.0) +
    ggplot2::annotate("text", x = xrng[1], y = yrng[1], label = "LOWER\nFALLING", 
                      size = sz, color = clr, hjust = 0, vjust = -0.5)
  
  return(plot)
  
  
  
}

plot_4_annotate_test <- function(){
  plot <- plot_top_test()
  return(plot_4_annotate(plot))
}

plot_4_annotate_test()


#' Filter to a focus date 


focus_on_day <- function(df, focus_date = NULL){
  
  if(is.null(focus_date)){
    reduced_df = df %>% filter(time_stamp == max(time_stamp))
  } 
  else {
    reduced_df = df %>% filter(time_stamp == focus_date)
  }
  
  if(nrow(reduced_df) == 0)
    stop("No rows in the subset of data")
  
  strip_infs_na <- !(is.na(rowSums(reduced_df %>% select(plt1_x,plt1_y))) |
                     is.infinite(rowSums(reduced_df %>% select(plt1_x, plt1_y))))
  
  reduced_df <- reduced_df[strip_infs_na,]
  
  
  return(reduced_df)
  

  
}


