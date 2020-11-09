# laod in data for the app
library(here)
library(dplyr)
library(DBI)
library(RSQLite)
library(janitor)
library(lubridate)
library(tidyr)
library(stringr)
library(dbplyr)


POP_GRP = 100000

load_covid_ireland <- function(src = "online_csv"){
  
  if(src == "online_csv"){
    #url <- "https://opendata-geohive.hub.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D"
    url <- "https://storage.covid19datahub.io/data-2.csv"
    df <- read.csv(url)
    
  }
  
  if(src == "offline_sqlite"){
    
    # Connect to the SQLite DB 
    con <- dbConnect(RSQLite::SQLite(), 
                     here("DATA/covid-ireland.db"))
    
    df <- tbl(con, "dailycases_2020_10_24") %>%
      collect()
    
    dbDisconnect(con) 

    }
    
  df <- df %>% filter(administrative_area_level_1 == "Ireland")
  df <- data_aug_covid_ireland(df)
  

  
  return(df)
}

data_aug_covid_ireland <- function(df){
    
    
    #tidy up the date column 
    df <- df %>% 
      mutate(time_stamp = ymd(date)) %>%
      select(-date)
    
    df <- df %>% mutate(county_name = administrative_area_level_2)
    df <- df %>% mutate(cumm_cases = confirmed) %>%
      select(-confirmed)
    
    df <- df %>% mutate(population_census16 = population) %>%
      select(-population)
    
    
    #all new columns and prefix c
    df <- df %>% 
      dplyr::group_by(county_name) %>% 
      dplyr::arrange(time_stamp) %>%
      dplyr::mutate(
        day_cases = cumm_cases - lag(cumm_cases,1), 
        day_delta = as.integer(time_stamp - lag(time_stamp,1)),
        day_cases_7x1 = RcppRoll::roll_mean(day_cases, n = 7, align = "right", fill = NA),
        day_cases_14x1 = RcppRoll::roll_mean(day_cases, n = 14, align = "right", fill = NA),
        day_cases_7x2 = RcppRoll::roll_mean(day_cases_7x1, n = 7, align = "right", fill = NA),
        day_cases_14x2 = RcppRoll::roll_mean(day_cases_14x1, n = 14, align = "right" , fill = NA ),
        chg7_in_day_cases_7x2 = day_cases_7x2 - lag(day_cases_7x2, 7),
        cumm_7 = RcppRoll::roll_sum(day_cases, n = 7, align = "right", fill = NA),
        cumm_14 = RcppRoll::roll_sum(day_cases, n = 14, align = "right", fill = NA),
        cumm_7_inc = cumm_7 / (population_census16/ POP_GRP),
        cumm_14_inc = cumm_14 / (population_census16/ POP_GRP),
        cumm_7_inc_7x1 = RcppRoll::roll_mean(cumm_7_inc, n = 7, align = "right", fill = NA),
        cumm_14_inc_14x1 = RcppRoll::roll_mean(cumm_14_inc, n = 14, align = "right", fill = NA),
        cumm_7_inc_7x2 = RcppRoll::roll_mean(cumm_7_inc_7x1, n = 7, align = "right", fill = NA),
        cumm_14_inc_14x2 = RcppRoll::roll_mean(cumm_14_inc_14x1, n = 14, align = "right", fill = NA),
        cumm_7_inc_7_day_chg = (cumm_7_inc - lag(cumm_7_inc, 7))/lag(cumm_7_inc,7),
        cumm_14_inc_7_day_chg = (cumm_14_inc - lag(cumm_14_inc, 7))/lag(cumm_14_inc,7),
        plt1_x =  cumm_14_inc,
        plt1_y = cumm_14_inc_7_day_chg) %>%
      dplyr::ungroup()
    
    #remove the very first date
    df <- df %>% filter(time_stamp > lubridate::ymd("2020-02-28"))
    
    return(df)
  
  
}
