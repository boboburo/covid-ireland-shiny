#helper files are run first

df <- load_covid_ireland(src = "offline_sqlite")


focus_day_test_data <- data.frame(
  time_stamp = ymd("2020-01-02","2020-04-04","2020-04-04","2020-04-04","2020-04-04"),
  other = c(1,2,3,4,5),
  plt1_y = c(Inf,1,2,3,5),
  plt1_x = c(1,2,3,NA,5))
  